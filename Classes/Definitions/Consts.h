//
//  Consts.h
//  SuperSample
//
//  Created by Andrey Kozlov on 9/14/11.
//  Copyright 2011 YAS. All rights reserved.
//

#ifndef SuperSample_Consts_h
#define SuperSample_Consts_h


#pragma mark QuickBlox
static NSString* const endpoint = @"qbtest01.quickblox.com";
static NSUInteger const appID = 56;
static NSUInteger const ownerID = 247;
static NSString* const appKey = @"X2TYsfGRBqh6Px3";
static NSString* const appSecret = @"Qbxu9R3rjMdhu9Q";



static CGFloat const kManagedObjectContextDelayedSaveInterval = 1.0;

#pragma mark Operations

static NSString * const kNewOperation = @"new";
static NSString * const kChangedOperation = @"changed";
static NSString * const kDeletedOperation = @"deleted";

static NSString* const MESSAGE_KEY = @"MESSAGE_KEY";
static NSString* const GEODATA_KEY  = @"GEODATA_KEY";


//Jabber
static NSUInteger const eventOwnerID = 1;

#define kGeoposServiceGetGeoDatInterval 60

#pragma mark -
#pragma mark Keys for Notification (Chat Jabber) 

static NSString* const nkMessageType = @"nT";
static NSString* const nkUserID= @"u";
static NSString* const nkUserDestID= @"dU";
static NSString* const kFileModelAttachement = @"Attachement";

//TODO: check if don't need and delete

static NSString* const nShowUserProfileView = @"ShowUserProfileView";
static NSString* const nShowAbuseView = @"ShowAbuseView";
static NSString* const nShowContentEntry = @"ShowContentEntry";
static NSString* const nShowPhotoView = @"ShowPhotoView";
static NSString* const nShowMessageDialog = @"ShowMessageDialog";
static NSString* const nShowSelectPhotoDialog = @"ShowSelectPfotoDialog";
static NSString* const nShowConversationView = @"ShowCoversationView";
static NSString* const nMessageArrived = @"MessageArrived";
static NSString* const nShowNewMessage = @"ShowNewMessages";

#pragma mark -
#pragma mark Dictionary Keys

static NSString* const kUserModelInstanceKey = @"UserModelInstanceKey";



static NSString *const RATINGS_GAME_MODE_TITLE = @"QB-SuperSample-iOS";
static int const RATINGS_GAME_MODE_ID = 6;


#pragma mark -
#pragma mark UserDefaults Keys

#define kShareYourLocation @"kShareYourLocation"
#define kDisplayOfflineUser @"kDisplayOfflineUser"
#define kUserRatingsFormat @"kUserRatings_%u"

#pragma mark -
#pragma mark XMPPService

static NSString* const commonPassword = @"chatPasswordAllSame";
static NSString* const emailForConnect = @"%i@jabber.aws.mob1serv.com/quickblox";
static NSString* const emailUserName = @"%i@jabber.aws.mob1serv.com";


#pragma mark -
#pragma mark UI

static const float kCellStatusLabelHeight = 13;
static const float kCellImgSize = 40.0;
static const float kCellRoundWidth = 320 - 60;
#pragma mark -

#endif