//
//  Consts.h
//  SuperSample
//
//  Created by Andrey Kozlov on 9/14/11.
//  Copyright 2011 YAS. All rights reserved.
//

#ifndef SuperSample_Consts_h
#define SuperSample_Consts_h

//
//http://test.admin.aws.mob1serv.com/
//
//Login: kozlov-andrey
//Password: qb90Ru
//

//https://admin.quickblox.com
//
//Endpoint: quickblox.com
//
//Login: kozlov-andrey
//Password: qwe123

//-----------------
// Accs for testing
//
// login: testt
// pass: testpass
//
// login: tester
// pass: testpass
//
//-----------------
// Global user for chat
//
// e-mail: globaltest4@gmail.com pass: testpass4
//
// login: global
// pass: testpass
//
// jid: 109@jabber.aws.mob1serv.com/quickblox
//-----------------

static CGFloat const kManagedObjectContextDelayedSaveInterval = 1.0;

#pragma mark Operations

static NSString * const kNewOperation = @"new";
static NSString * const kChangedOperation = @"changed";
static NSString * const kDeletedOperation = @"deleted";

#pragma mark Mob1serv
static NSString* const endpoint = @"quickblox.com";
static NSUInteger const appID = 63;
static NSUInteger const ownerID = 33;
static NSString* const appKey = @"4MaxhVSUD2q3TtT";
static NSString* const appSecret = @"VrjtJ5TUqg4TTNU";


static NSString* const MESSAGE_KEY = @"MESSAGE_KEY";
static NSString* const GEODATA_KEY  = @"GEODATA_KEY";

//static NSString* const jabberEndpoint = @"jabber.aws.mob1serv.com";//@"quickblox.com";


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
