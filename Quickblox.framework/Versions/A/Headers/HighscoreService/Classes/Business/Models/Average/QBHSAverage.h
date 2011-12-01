//
//  QBHSAverage.h
//  Mobserv
//
//  Created by Andrey Kozlov on 4/15/11.
//  Copyright 2011 YAS. All rights reserved.
//

@interface QBHSAverage : NSObject {
	NSUInteger gameModeId;
	CGFloat value;
}

@property (nonatomic) NSUInteger gameModeId;
@property (nonatomic) CGFloat value;

@end
