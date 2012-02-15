//
//  ChatCell.m
//  FansNet
//
//  Created by Andrew Kopanev on 7/12/10.
//  Copyright 2010 QuickBlox. All rights reserved.
//

#import "MessageCell.h"

// Data
#import "Messages.h"
#import "Users.h"
#import "SourceImages.h"
#import "UsersProvider.h"


@implementation MessageCell

@synthesize messageLabel, userName, avatarView, roundView;
@synthesize avatarsArray;
@synthesize user,tapView;

- (void)releaseObjects {
    self.user = nil;
    self.avatarsArray = nil;
    
    [super releaseObjects];
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
	
    // message bg
	roundView = [[UIView alloc] initWithFrame: CGRectZero];
	roundView.layer.cornerRadius = 5.0;
	roundView.backgroundColor = [UIColor whiteColor];
	[self.contentView addSubview: roundView];
    [roundView release];

	// message
	messageLabel = [[UILabel alloc] initWithFrame: CGRectZero];
	messageLabel.backgroundColor = [UIColor clearColor];
	messageLabel.numberOfLines = 0;
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

    
    // tap view
    tapView = [[UIView alloc] initWithFrame:avatarView.frame];
    [self addSubview:tapView];
    [tapView release];
    
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

// update cell
- (void)reloadCellSateWithData:(NSObject *)newData {
    Messages *mess = (Messages *)newData;
    self.user = mess.user;
    
    // message
    [self setMessageText: mess.text];
    
    // user name
    userName.text = [NSString stringWithFormat:@"At %@ %@ wrote:", 
                     [[mess.date description] substringToIndex:[[mess.date description] length]-6] , 
                     user.qbUser.login];
    
    // avatar
    SourceImages *sourceImage = user.photo;
    self.avatarView.image = [UIImage imageWithData:sourceImage.image];
    if(self.avatarView.image == nil){
       self.avatarView.image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"user" ofType:@"png"]];
    }
    
    // tap recognizer
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [tapView addGestureRecognizer:tap];
    [tap release];
}

- (void) setMessageText: (NSString *) messageText {
	CGSize ts = [messageText sizeWithFont: messageLabel.font constrainedToSize: CGSizeMake(kCellRoundWidth-10, 1000000)];
	if (ts.height < 20) {
        ts.height = 20;
    }
	roundView.frame = CGRectMake(10 + kCellImgSize, kCellStatusLabelHeight, kCellRoundWidth, ts.height + 10);
	[messageLabel setFrame: CGRectMake(5, 5, kCellRoundWidth - 10, ts.height)];	
	
    messageLabel.text = messageText;
}

- (CGFloat)getCellHeight {
    CGFloat cellHeight = messageLabel.frame.size.height + kCellStatusLabelHeight;
	
	return (cellHeight < kCellImgSize + 5) ? kCellImgSize + 17 : cellHeight + 17;
}

- (CGFloat) cellHeight{
    return [self getCellHeight];
}

@end