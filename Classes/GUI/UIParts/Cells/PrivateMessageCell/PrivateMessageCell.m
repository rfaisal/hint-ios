//
//  ChatCell.m
//  FansNet
//
//  Created by Andrew Kopanev on 7/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PrivateMessageCell.h"
#import "ImageThambnailView.h"

// Data
#import "PrivateMessages.h"
#import "Users.h"
#import "SourceImages.h"
#import "UsersProvider.h"

//Helpers
#import "Resources.h"



@implementation PrivateMessageCell

@synthesize messageLabel, statusLabel, avatarView, roundView;
@synthesize avatarsArray, thambnailClass;
@synthesize user,tapView;

- (void)releaseObjects {
    self.user=nil;
    self.tapView=nil;
    self.messageLabel = nil;
    self.statusLabel = nil;
    self.avatarView = nil;
    self.roundView = nil;
    self.avatarsArray = nil;
    [super releaseObjects];
}



- (Class)thambnailClass {
	return [ImageThambnailView class];
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
	
	self.contentView.backgroundColor = [UIColor clearColor];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	avatarView = [[UIImageView alloc] initWithFrame: CGRectMake(3, 2, kCellImgSize, kCellImgSize)];
	avatarView.layer.cornerRadius = 8;
	avatarView.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview: avatarView];
    
    self.tapView=[[UIView alloc] initWithFrame:self.avatarView.frame];
    [self addSubview:tapView];

//	[avatarView release];
	
	roundView = [[UIView alloc] initWithFrame: CGRectZero];
	roundView.layer.cornerRadius = 5.0;
	roundView.backgroundColor = [UIColor whiteColor];
	[self.contentView addSubview: roundView];
//	[roundView release];
	
	messageLabel = [[UILabel alloc] initWithFrame: CGRectZero];
	messageLabel.backgroundColor = [UIColor clearColor];
	messageLabel.numberOfLines = 999;
	messageLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 12];
	messageLabel.textColor = [UIColor blackColor];
	[roundView addSubview: messageLabel];
//	[messageLabel release];	
	
	statusLabel = [[UILabel alloc] initWithFrame: CGRectMake(10 + kCellImgSize, 0, 
															 kCellRoundWidth, kCellStatusLabelHeight)];
	statusLabel.backgroundColor = [UIColor clearColor];
	statusLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 11];
	statusLabel.textColor = [UIColor blackColor];
	[self.contentView addSubview: statusLabel];
//	[statusLabel release];	
    
    
	return self;
}


-(void)handleTap:(UITapGestureRecognizer*) gesture
{
    Users* currentUser = [[UsersProvider sharedProvider] currentUser];
    
    if(user.objectID == currentUser.objectID)
        return;
    [[NSNotificationCenter defaultCenter] postNotificationName:nOpenPrivateChatView object:nil userInfo:[NSDictionary dictionaryWithObject:user.objectID forKey:nkData]];
}

- (void)reloadCellSateWithData:(NSObject*)newData {

//    NSLog(@"newData: %@", newData);
    
    PrivateMessages *mess = (PrivateMessages *)newData;
    self.user=[[UsersProvider sharedProvider] userByUID:mess.userFrom ];
    [self setMessageText: mess.text ];
    self.statusLabel.text = [NSString stringWithFormat:@"%@ wrote:", user.mbUser.login];
    SourceImages* sourceImage=user.photo;
    self.avatarView.image=[UIImage imageWithData:sourceImage.thumbnail];
    if(self.avatarView.image==nil)
       self.avatarView.image=[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"user" ofType:@"png"]];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [tapView addGestureRecognizer:tap];
    [tap release];

//    
//    if (self.avatarsArray) {
//        for (ImageThambnailView *view in self.avatarsArray) {
//            view.hidden = YES;
//            view.extra = nil;
//        }
//        
//        int i = 0;
//        for (NSManagedObject *model in array) {
//            if (i >= [self.avatarsArray count]) {
//                ImageThambnailView *avatar = [[[self.thambnailClass alloc] initWithIndex:i extras:model] autorelease];
//                [self.contentView addSubview:avatar];
//                [self.avatarsArray addObject:avatar];
//            }
//                
//            [((ImageThambnailView*)[self.avatarsArray objectAtIndex:i]) setExtras:model];
//            ((ImageThambnailView*)[self.avatarsArray objectAtIndex:i]).extra = model;
//            ((ImageThambnailView*)[self.avatarsArray objectAtIndex:i++]).hidden = NO;
//        }
//    } else {
//        self.avatarsArray = [NSMutableArray arrayWithCapacity:0];
//        
//        int i = 0;
//        for (NSManagedObject *model in array) { 
//            ImageThambnailView *avatar = [[[self.thambnailClass alloc] initWithIndex:i++ extras:model] autorelease];
//            avatar.extra = model;
//            
//            [self.contentView addSubview:avatar];
//            [self.avatarsArray addObject:avatar];
//        }
//    }
//

}

- (void) setMessageText: (NSString *) messageText {
	CGSize ts = [messageText sizeWithFont: messageLabel.font constrainedToSize: CGSizeMake(kCellRoundWidth - 10, 480)];
	if (ts.height < 20) ts.height = 20;
	roundView.frame = CGRectMake(10 + kCellImgSize, kCellStatusLabelHeight, kCellRoundWidth, ts.height + 10);
	[messageLabel setFrame: CGRectMake(5, 5, kCellRoundWidth - 10, ts.height)];	
	messageLabel.text = messageText;
}



- (CGFloat)getCellHeight {
	CGSize ts = [messageLabel.text sizeWithFont: [UIFont fontWithName: @"HelveticaNeue" size: 12]
						constrainedToSize: CGSizeMake(kCellRoundWidth, 480)];
	
	ts.height += kCellStatusLabelHeight;
	
	float rv = (ts.height < kCellImgSize + 5) ? kCellImgSize + 15 : ts.height + 15;
	return rv;
}

- (CGFloat) cellHeight{
    return [self getCellHeight];
}
//- (void) setMessageText: (NSString *) messageText {
//	CGSize ts = [messageText sizeWithFont: messageLabel.font constrainedToSize: CGSizeMake(kCellRoundWidth - 10, 480)];
//	if (ts.height < 20) ts.height = 20;
//	roundView.frame = CGRectMake(10 + kCellImgSize, kCellStatusLabelHeight, kCellRoundWidth, ts.height + 10);
//	[messageLabel setFrame: CGRectMake(5, 5, kCellRoundWidth - 10, ts.height)];	
//	messageLabel.text = messageText;
//}
//
//- (void) setMessage: (NSDictionary *) message {
//	[self setMessageText: [message objectForKey: kFanMessageKey]];
//	avatarView.image = [[ImagesManager getInstance] getImageAtPath: [message objectForKey: kFanUserImageFilePathKey]];
//	NSString * nickName = [message objectForKey: kFanNickNameKey];
//	NSDate * postDate = [message objectForKey: kFanMessageTimestampKey];
//	
//	NSDateFormatter * frm = [[NSDateFormatter alloc] init];
//	[frm setDateFormat: @"MM/dd/YY HH:mm"];
//	NSString * timestamp = [frm stringFromDate: postDate];
//	[frm release];
//	
//	statusLabel.text = [NSString stringWithFormat: @"On %@ %@ wrote:", timestamp, nickName];
//}
//



@end
