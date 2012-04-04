//
//  Consts.h
//  SuperSample
//
//  Created by Andrey Kozlov on 9/14/11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#ifndef SuperSample_Consts_h
#define SuperSample_Consts_h


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

#define FLURRY_API_KEY @"DCQCH5K116J63XH7DDS"
#define FACEBOOK_APP_ID @"329216907114105"

#pragma mark -
#pragma mark UI

static const float kCellStatusLabelHeight = 13;
static const float kCellImgSize = 40.0;
static const float kCellRoundWidth = 320 - 60;

#endif