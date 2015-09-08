//
//  ImagePalette.h
//  ImageColorView
//
//  Created by Kip Ricker on 8/29/15.
//  Copyright (c) 2015 Kilopound. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePalette : NSObject

+ (CGImageRef)cgImageFromUIImage:(UIImage*)image imageSize:(CGSize)size rect:(CGRect)rect;

+ (unsigned char*)pixelsFromUIImage:(UIImage*)image imageSize:(CGSize)size;
+ (unsigned char*)pixelsFromUIImage:(UIImage*)image imageSize:(CGSize)size rect:(CGRect)rect;

+ (UIColor*)uiImageAverageColor:(UIImage*)image;
+ (UIColor*)cgImageAverageColor:(CGImageRef)imageRef;

+ (NSArray*)uiImagePalette:(UIImage*)image;
+ (NSArray*)uiImagePalette:(UIImage*)image paletteSize:(int)paletteSize;

+ (NSArray*)imagePalette:(unsigned char*)pixels imageSize:(CGSize)size;
+ (NSArray*)imagePalette:(unsigned char*)pixels imageSize:(CGSize)size paletteSize:(int)paletteSize;

@end
