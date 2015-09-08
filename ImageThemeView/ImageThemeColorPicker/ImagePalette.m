//
//  ImagePalette.m
//  ImageColorView
//
//  Created by Kip Ricker on 8/29/15.
//  Copyright (c) 2015 Kilopound. All rights reserved.
//

#import "ImagePalette.h"
#include "libimagequant.h"

#define DEFAULT_PALETTE_SIZE 8
#define DEFAULT_IMAGE_WIDTH 100
#define DEFAULT_IMAGE_HEIGHT 100

@implementation ImagePalette

+ (CGImageRef)cgImageFromUIImage:(UIImage*)image imageSize:(CGSize)size rect:(CGRect)rect {
    
    CGFloat imageWidth = size.width;
    CGFloat imageHeight = size.height;
    
    CGFloat outputWidth = rect.size.width;
    CGFloat outputHeight = rect.size.height;
    
    CGImageRef imageRef = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(outputHeight * outputWidth * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * outputWidth;
    NSUInteger bitsPerComponent = 8;
    
    CGContextRef context = CGBitmapContextCreate(rawData, outputWidth, outputHeight,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGFloat y = (CGFloat)outputHeight - (CGFloat)imageHeight;
    CGContextTranslateCTM(context, -rect.origin.x, y + rect.origin.y);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), imageRef);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    return cgImage;
}

+ (unsigned char*)pixelsFromUIImage:(UIImage*)image imageSize:(CGSize)size {
    
    return [self pixelsFromUIImage:image imageSize:size rect:CGRectMake(0, 0, size.width, size.height)];
}

+ (unsigned char*)pixelsFromUIImage:(UIImage*)image imageSize:(CGSize)size rect:(CGRect)rect {
    
    CGFloat outputWidth = size.width;
    CGFloat outputHeight = size.height;
    
    CGImageRef imageRef = [self cgImageFromUIImage:image imageSize:size rect:rect];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(outputHeight * outputWidth * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * outputWidth;
    NSUInteger bitsPerComponent = 8;
    
    CGContextRef context = CGBitmapContextCreate(rawData, outputWidth, outputHeight,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), imageRef);
    
    CGContextRelease(context);

    return rawData;
}

+ (UIColor*)uiImageAverageColor:(UIImage*)image {
    
    CGImageRef imageRef = [self cgImageFromUIImage:image
                                         imageSize:CGSizeMake(DEFAULT_IMAGE_WIDTH, DEFAULT_IMAGE_HEIGHT)
                                              rect:CGRectMake(0, 0, DEFAULT_IMAGE_WIDTH, DEFAULT_IMAGE_HEIGHT)];
    
    return [self cgImageAverageColor:imageRef];
}

+ (UIColor*)cgImageAverageColor:(CGImageRef)imageRef {

    CGColorSpaceRef avgColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rawData[4];
    CGContextRef avgContext = CGBitmapContextCreate(rawData, 1, 1, 8, 4, avgColorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(avgContext, CGRectMake(0, 0, 1, 1), imageRef);
    
    CGColorSpaceRelease(avgColorSpace);
    CGContextRelease(avgContext);
    
    return [UIColor colorWithRed:((CGFloat)rawData[0])/255.0
                           green:((CGFloat)rawData[1])/255.0
                            blue:((CGFloat)rawData[2])/255.0
                           alpha:((CGFloat)rawData[3])/255.0];
}

+ (NSArray*)uiImagePalette:(UIImage*)image {
    
    return [self uiImagePalette:image paletteSize:DEFAULT_PALETTE_SIZE];
}

+ (NSArray*)uiImagePalette:(UIImage*)image paletteSize:(int)paletteSize {
    
    CGSize imageSize = CGSizeMake(DEFAULT_IMAGE_WIDTH, DEFAULT_IMAGE_HEIGHT);
    unsigned char *pixels = [self pixelsFromUIImage:image imageSize:imageSize];
    return [self imagePalette:pixels imageSize:imageSize paletteSize:paletteSize];
}

+ (NSArray*)imagePalette:(unsigned char*)pixels imageSize:(CGSize)size {
    
    return [self imagePalette:pixels imageSize:size paletteSize:DEFAULT_PALETTE_SIZE];
}

+ (NSArray*)imagePalette:(unsigned char*)pixels imageSize:(CGSize)size paletteSize:(int)paletteSize {
    
    liq_attr *liqAttr = liq_attr_create();
    liq_set_speed(liqAttr, 5);
    liq_set_max_colors(liqAttr, paletteSize);
    liq_image *liqImage = liq_image_create_rgba(liqAttr, pixels, (int)size.width, (int)size.height, 0);
    liq_result *liqRes = liq_quantize_image(liqAttr, liqImage);
    
    liq_write_remapped_image(liqRes, liqImage, pixels, 4 * size.height * size.width);

    const liq_palette *liqPal = liq_get_palette(liqRes);

    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSInteger n = 0; n < liqPal->count; n++) {
        
        CGFloat r = liqPal->entries[n].r/255.0f;
        CGFloat g = liqPal->entries[n].g/255.0f;
        CGFloat b = liqPal->entries[n].b/255.0f;
        
        [result addObject:[UIColor colorWithRed:r green:g blue:b alpha:1]];
    }
    
    liq_attr_destroy(liqAttr);
    liq_image_destroy(liqImage);
    liq_result_destroy(liqRes);
    
    free(pixels);
    
    return result;
}


@end
