//
//  FileSystemHelper.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/9/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "FileSystemHelper.h"

@implementation FileSystemHelper

+ (NSString*)applicationDocumentDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
