//
//  MapPinView.h
//  SuperSample
//
//  Created by Danil on 16.09.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "Users.h"

@class MapPinAnnotation;

@interface MapPinView : MKAnnotationView {
	UIImageView *imageView;
	UILabel *lastMessage;
	UIImageView *powerView;
    MapPinAnnotation *annotationModel;
    UIView *tapView;
}
@property(nonatomic, retain)    UIView *tapView;
@property(nonatomic, retain)	UIImageView *imageView;
@property(nonatomic, retain)	UILabel *lastMessage;
@property(nonatomic, retain)	UIImageView *powerView;
@property(nonatomic, retain)    MapPinAnnotation *annotationModel;

- (void)updateStatusWithAnimation:(BOOL)isAnimating;

@end