//
//  AlbumTableViewCell.m
//  ImageColorView
//
//  Created by Kip Ricker on 8/31/15.
//  Copyright (c) 2015 Kilopound. All rights reserved.
//

#import "AlbumTableViewCell.h"
#import "ImageThemeColorPicker.h"
#import "ImagePalette.h"

#import <UIColor+T23ColourSpaces.h>

@interface AlbumTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;


@property (strong, nonatomic) UIView *colorBars;

@end

@implementation AlbumTableViewCell

- (void)awakeFromNib {
    _colorBars = [[UIView alloc] init];
    _colorBars.backgroundColor = [UIColor clearColor];
    [self insertSubview:_colorBars atIndex:0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)displayAlbumImageNamed:(NSString*)imageNamed {
    UIImage *image = [UIImage imageNamed:imageNamed];
    _albumImage.image = image;
    
    NSLog(@"+++%@+++", imageNamed);
    
    ImageThemeColorPicker *picker = [[ImageThemeColorPicker alloc] initWithImage:image];
    
    self.backgroundColor = picker.backgroundColor;
    self.buttonLabel.textColor = picker.primaryColor;
    self.mainLabel.textColor = picker.secondaryColor;
    
    NSArray *sortedColors = [picker.imagePalette sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        T23UIColourDistanceOptions option = T23UIColourDistanceFormulaCIE76;
        
        CGFloat dE1 = [picker.backgroundColor getDistanceMetricBetweenUIColor:(UIColor*)obj1 withOptions:option];
        CGFloat dE2 = [picker.backgroundColor getDistanceMetricBetweenUIColor:(UIColor*)obj2 withOptions:option];
        
        return dE1 < dE2;
    }];
    
    [_colorBars.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat y = _albumImage.frame.origin.y;
    CGFloat step = _albumImage.frame.size.height / 8.0f;
    for (UIColor *color in sortedColors) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 8, y, 8, step)];
        view.backgroundColor = color;
        [_colorBars addSubview:view];
        y+=step;
    }
}

@end
