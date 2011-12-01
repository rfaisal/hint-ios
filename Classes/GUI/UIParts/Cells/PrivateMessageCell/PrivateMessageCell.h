//
//  ChatCell.h
//  FansNet
//
//  Created by Andrew Kopanev on 7/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseTableCell.h"

@class Users;
@interface PrivateMessageCell : BaseTableCell {
	UIImageView * avatarView;
	UILabel * messageLabel, *statusLabel;
	UIView * roundView;
    NSMutableArray *avatarsArray;
    Users* user;
}

@property (nonatomic, retain) NSMutableArray *avatarsArray;
@property (nonatomic, readonly) Class thambnailClass;


@property (nonatomic, retain)	UIImageView * avatarView;
@property (nonatomic, retain)	UILabel * messageLabel, *statusLabel;
@property (nonatomic, retain)	UIView * roundView;
@property (nonatomic, retain)    UIView* tapView;

@property (nonatomic, retain)    Users* user;


- (CGFloat)getCellHeight;
- (void) setMessageText: (NSString *) messageText;
//
//- (void) setMessage: (NSDictionary *) message;

@end
