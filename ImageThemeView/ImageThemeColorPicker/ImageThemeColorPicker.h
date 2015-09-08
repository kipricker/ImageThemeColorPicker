//
//  ImageThemeColorPicker.h
//  ImageColorView
//
//  Created by Kip Ricker on 9/5/15.
//  Copyright © 2015 Kilopound. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageThemeColorPicker : NSObject

- (instancetype)initWithImage:(UIImage*)image;
- (instancetype)initWithImageName:(NSString*)imageName;

@property (strong, nonatomic, readonly) UIColor *backgroundColor;
@property (strong, nonatomic, readonly) UIColor *primaryColor;
@property (strong, nonatomic, readonly) UIColor *secondaryColor;

@property (strong, nonatomic, readonly) NSArray *imagePalette;

@end
