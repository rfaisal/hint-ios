//
//  Consts.h
//  SuperSample
//
//  Created by Andrey Kozlov on 9/14/11.
//  Copyright 2011 YAS. All rights reserved.
//

#ifndef SuperSample_Consts_h
#define SuperSample_Consts_h

#pragma mark -
#pragma mark Ratings module

//static NSString *const RATINGS_GAME_MODE_TITLE = @"QB-SuperSample-iOS";
//static int const RATINGS_GAME_MODE_ID = 6;


#pragma mark -
#pragma mark UserDefaults Keys

#define kShareYourLocation @"kShareYourLocation"
#define kDisplayOfflineUser @"kDisplayOfflineUser"
#define kUserRatingsFormat @"kUserRatings_%u"


#pragma mark -
#pragma mark  Values

static NSString *const MESSAGE_KEY = @"MESSAGE_KEY";
static NSString *const GEODATA_KEY  = @"GEODATA_KEY";

static CGFloat const kManagedObjectContextDelayedSaveInterval = 1.0;

#define kUpdateMapInterval 180 //s
#define kUpdateChatInterval 20 //s


#pragma mark -
#pragma mark XMPPService

//static NSString *const emailUserName = @"%i@jabber.quickblox.com";


#pragma mark -
#pragma mark UI

static const float kCellStatusLabelHeight = 13;
static const float kCellImgSize = 40.0;
static const float kCellRoundWidth = 320 - 60;

#endif