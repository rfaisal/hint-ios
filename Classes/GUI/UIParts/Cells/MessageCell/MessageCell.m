//
//  ChatCell.m
//  FansNet
//
//  Created by Andrew Kopanev on 7/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MessageCell.h"
#import "ImageThambnailView.h"

// Data
#import "Messages.h"
#import "Users.h"
#import "SourceImages.h"
#import "UsersProvider.h"

//Helpers
#import "Resources.h"


@implementation MessageCell

@synthesize messageLabel, userName, avatarView, roundView;
@synthesize avatarsArray, thambnailClass;
@synthesize user,tapView;

- (void)releaseObjects {
    self.user = nil;
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
	
    // avatar
	avatarView = [[UIImageView alloc] initWithFrame: CGRectMake(3, 2, kCellImgSize, kCellImgSize)];
	avatarView.layer.cornerRadius = 8;
    [avatarView setContentMode:UIViewContentModeScaleAspectFit];
	avatarView.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview: avatarView];
    [avatarView release];
    
    tapView = [[UIView alloc] initWithFrame:avatarView.frame];
    [self addSubview:tapView];
    [tapView release];
	
    // message bg
	roundView = [[UIView alloc] initWithFrame: CGRectZero];
	roundView.layer.cornerRadius = 5.0;
	roundView.backgroundColor = [UIColor whiteColor];
	[self.contentView addSubview: roundView];
    [roundView release];

	// message
	messageLabel = [[UILabel alloc] initWithFrame: CGRectZero];
	messageLabel.backgroundColor = [UIColor clearColor];
	messageLabel.numberOfLines = 999;
	messageLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 12];
	messageLabel.textColor = [UIColor blackColor];
	[roundView addSubview: messageLabel];
    [messageLabel release];

	// user
	userName = [[UILabel alloc] initWithFrame: CGRectMake(10 + kCellImgSize, 0, 
															 kCellRoundWidth, kCellStatusLabelHeight)];
	userName.backgroundColor = [UIColor clearColor];
	userName.font = [UIFont fontWithName: @"HelveticaNeue" size: 11];
	userName.textColor = [UIColor blackColor];
	[self.contentView addSubview: userName];
    [userName release];

	return self;
}

- (void)handleTap:(UITapGestureRecognizer *) gesture{
    Users *currentUser = [[UsersProvider sharedProvider] currentUser];
    
    if(user.objectID == currentUser.objectID){
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:nOpenPrivateChatView 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObject:user.objectID forKey:nkData]];
}

- (void)reloadCellSateWithData:(NSObject*)newData {
    Messages *mess = (Messages *)newData;
    self.user=mess.user;
    [self setMessageText: mess.text ];
    userName.text = [NSString stringWithFormat:@"%@ wrote:", mess.user.mbUser.login];
    SourceImages* sourceImage=mess.user.photo;
    self.avatarView.image=[UIImage imageWithData:sourceImage.thumbnail];
    if(self.avatarView.image==nil)
       self.avatarView.image=[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"user" ofType:@"png"]];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [tapView addGestureRecognizer:tap];
    [tap release];
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

@end