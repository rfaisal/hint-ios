//
//  QBHSScore.h
//  Mobserv
//
//  Created by Andrey Kozlov on 4/15/11.
//  Copyright 2011 YAS. All rights reserved.
//

@interface QBHSScore : NSObject {
	NSDate *createdAt;
	NSUInteger gameModeId;
	NSUInteger scoreId;
	NSUInteger userId;
	NSUInteger value;
}

@property (nonatomic, retain) NSDate *createdAt;

@property (nonatomic) NSUInteger gameModeId;
@property (nonatomic) NSUInteger scoreId;
@property (nonatomic) NSUInteger userId;
@property (nonatomic) NSUInteger value;

@end
