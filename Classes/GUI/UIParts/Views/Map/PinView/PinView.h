//
//  PinView.h
//  SuperSample
//
//  Created by Danil on 16.09.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "Users.h"

@class userAnnotation;
@interface PinView : MKAnnotationView {
	UIImageView *imageView;
	UILabel *lastMessage;
	UIView *detailedView;
	UIImageView *powerView;
    userAnnotation *annotationModel;
    UIView *tapView;
}
@property(nonatomic, retain)    UIView *tapView;
@property(nonatomic, retain)	UIImageView *imageView;
@property(nonatomic, retain)	UILabel *lastMessage;
@property(nonatomic, retain)	UIView *detailedView;
@property(nonatomic, retain)	UIImageView *powerView;
@property(nonatomic, retain)    userAnnotation *annotationModel;
@property (nonatomic, retain)   Users *user;

-(id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier ownMarker:(BOOL) isOwnMarker;

@end