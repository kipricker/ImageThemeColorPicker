//
//  ImageThemeColorPicker.m
//  ImageColorView
//
//  Created by Kip Ricker on 9/5/15.
//  Copyright © 2015 Kilopound. All rights reserved.
//

#import "ImageThemeColorPicker.h"
#import "ImagePalette.h"
#import <UIColor+T23ColourSpaces.h>

#define CONTRAST_THRESHOLD 4.5f

@interface ImageThemeColorPicker ()

@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIColor *primaryColor;
@property (strong, nonatomic) UIColor *secondaryColor;

@end

@implementation ImageThemeColorPicker


- (instancetype)initWithImageName:(NSString*)imageName {
    return [self initWithImage:[UIImage imageNamed:imageName]];
}

- (instancetype)initWithImage:(UIImage*)image {
    
    self = [super init];
    
    if (self) {

        _image = image;
        _imagePalette = [NSMutableArray arrayWithArray:[ImagePalette uiImagePalette:_image]];
        
        // The background color is based on the predominant color in top left quadrant of the image
        unsigned char *pixels = [ImagePalette pixelsFromUIImage:_image
                                                      imageSize:CGSizeMake(100, 100)
                                                           rect:CGRectMake(0, 0, 50, 50)];

        _backgroundColor = [ImagePalette imagePalette:pixels
                                            imageSize:CGSizeMake(100, 100)][0];
        
        UIColor *color1 = [self findColorComparedTo:_backgroundColor];
        CGFloat h1, s1, l1, a1;
        [color1 getHue:&h1 saturation:&s1 brightness:&l1 alpha:&a1];
        
        UIColor *color2 = [self findColorComparedTo:color1];
        CGFloat h2, s2, l2, a2;
        [color2 getHue:&h2 saturation:&s2 brightness:&l2 alpha:&a2];
        
        // Pick the color with the highest saturation as the primary color
        _primaryColor = s1 > s2 ? color1 : color2;
        _secondaryColor = s1 < s2 ? color1 : color2;
    }
    
    return self;
}

// Sort colors by ΔE, find colors furthest from the comparisonColor
- (UIColor*)findColorComparedTo:(UIColor*)comparisonColor {
    
    NSMutableArray *colors = [NSMutableArray arrayWithArray:_imagePalette];
    
    NSArray *sortedColors = [colors sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        T23UIColourDistanceOptions option = T23UIColourDistanceFormulaCIE76;
        CGFloat dE1 = [comparisonColor getDistanceMetricBetweenUIColor:(UIColor*)obj1 withOptions:option];
        CGFloat dE2 = [comparisonColor getDistanceMetricBetweenUIColor:(UIColor*)obj2 withOptions:option];
        
        return dE1 < dE2;
    }];
    
    for (UIColor *color in sortedColors) {
        
        // Pick the first valid color
        CGFloat contrast = [self contrastBg:_backgroundColor fg:color];
        if (contrast >= CONTRAST_THRESHOLD) {
            return color;
        }
    }
    
    CGFloat bgh, bgs, bgl, bga;
    [_backgroundColor getHue:&bgh saturation:&bgs brightness:&bgl alpha:&bga];
    
    // If there are no valid colors, pick black or white according to the lightness of the background color
    return (bgl >= 0.5) ? [UIColor blackColor] : [UIColor whiteColor];
}

#pragma mark - Contrast Test

- (CGFloat)channelLuminance:(CGFloat)channel {
    
    if (channel <= 0.03928f) {
        return channel/12.92f;
    } else {
        return pow((channel+0.055f)/1.055f, 2.4f);
    }
}

- (CGFloat)luminance:(UIColor*)color {
    
    CGFloat r, g, b, a;
    
    [color getRed:&r green:&g blue:&b alpha:&a];
    r = [self channelLuminance:r];
    g = [self channelLuminance:g];
    b = [self channelLuminance:b];
    
    return 0.2126f * r + 0.7152f * g + 0.0722f * b;
}

// http://www.w3.org/TR/WCAG20-TECHS/G18.html
// Contrast test passes when contrast is >= 4.5
- (CGFloat)contrastBg:(UIColor*)bg fg:(UIColor*)fg {
    
    CGFloat bgL = [self luminance:bg];
    CGFloat fgL = [self luminance:fg];
    
    CGFloat lighter = MAX(bgL, fgL);
    CGFloat darker = MIN(bgL, fgL);
    
    CGFloat ratio = (lighter + 0.05f)/(darker + 0.05f);
    
    return ratio;
}

@end
