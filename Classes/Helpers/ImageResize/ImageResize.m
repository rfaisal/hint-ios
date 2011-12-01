//
//  ImageResize.m
//  SuperSample
//
//  Created by Danil on 27.09.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "ImageResize.h"


@implementation ImageResize

//	==============================================================
//	resizedImage
//	==============================================================
// Return a scaled down copy of the image.  

+ (UIImage*) resizedImage:(UIImage *)inImage withRect: (CGRect) thumbRect
{
	CGImageRef			imageRef = [inImage CGImage];
	CGImageAlphaInfo	alphaInfo = CGImageGetAlphaInfo(imageRef);
	
	// There's a wierdness with kCGImageAlphaNone and CGBitmapContextCreate
	// see Supported Pixel Formats in the Quartz 2D Programming Guide
	// Creating a Bitmap Graphics Context section
	// only RGB 8 bit images with alpha of kCGImageAlphaNoneSkipFirst, kCGImageAlphaNoneSkipLast, kCGImageAlphaPremultipliedFirst,
	// and kCGImageAlphaPremultipliedLast, with a few other oddball image kinds are supported
	// The images on input here are likely to be png or jpeg files
	if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;

	// Build a bitmap context that's the size of the thumbRect
	CGContextRef bitmap = CGBitmapContextCreate(
				NULL,
				thumbRect.size.width,		// width
				thumbRect.size.height,		// height
				CGImageGetBitsPerComponent(imageRef),	// really needs to always be 8
				4 * thumbRect.size.width,	// rowbytes
				CGImageGetColorSpace(imageRef),
				alphaInfo
		);

	// Draw into the context, this scales the image
	CGContextDrawImage(bitmap, thumbRect, imageRef);

	// Get an image from the context and a UIImage
	CGImageRef	ref = CGBitmapContextCreateImage(bitmap);
	UIImage*	result = [UIImage imageWithCGImage:ref];

	CGContextRelease(bitmap);	// ok if NULL
	CGImageRelease(ref);

	return result;
}

@end
