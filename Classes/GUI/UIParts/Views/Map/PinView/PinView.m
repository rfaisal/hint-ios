//
//  PinView.m
//  SuperSample
//
//  Created by Danil on 16.09.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "PinView.h"
#import "userAnnotation.h"
#import "Users.h"
#import "UsersProvider.h"

@implementation PinView

@synthesize imageView, lastMessage, detailedView, powerView, annotationModel,tapView;
@synthesize user;


-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier ownMarker:(BOOL) isOwnMarker{
    if ((self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])) {
        
        self.annotationModel = annotation;
        
        self.user = NSClassFromString(@"MKUserLocation") == [self.annotationModel class] ? 
                [[UsersProvider sharedProvider] currentUser] 
                : self.annotationModel.userModel;

        UIImage *img = nil;
        if(isOwnMarker){
            img = [UIImage imageNamed: @"marker_own_map.png"];
        }else{
            img = [UIImage imageNamed: @"marker_map.png"];
        }
		
		self.backgroundColor = [UIColor clearColor];
		
		const float labelWidth = 80;
		const float labelHeight = 24;
		
		self.frame = CGRectMake(0, 0, labelWidth, img.size.height + labelHeight);
		
        
        // marker
		imageView = [[UIImageView alloc] initWithFrame: CGRectMake(self.frame.size.width * .5 - img.size.width * .5,
																   labelHeight, 
																   img.size.width, img.size.height)];
		imageView.image = img;
		[self addSubview: imageView];
        [imageView release];
		
        
        // power
		powerView = [[UIImageView alloc] init];
		powerView.frame = CGRectMake(self.frame.size.width / 2 - img.size.width / 2 + 2, 20, 24, 3);
		powerView.image = [UIImage imageNamed:@"img_power_line.png"];
		powerView.layer.cornerRadius = (0 - 2) * 0.5;
		[self addSubview: powerView];
        [powerView release];
		
        // last message view
		lastMessage = [[UILabel alloc] initWithFrame: CGRectMake(5, 0, labelWidth-10, labelHeight-5)];
		lastMessage.backgroundColor = [UIColor colorWithRed: .5 green: .5 blue: .5 alpha: .7];
		lastMessage.textAlignment = UITextAlignmentCenter;
		lastMessage.numberOfLines = 2;
		lastMessage.layer.cornerRadius = 4;
		lastMessage.textColor = [UIColor whiteColor];
		lastMessage.font = [UIFont boldSystemFontOfSize: 10];
		[self addSubview: lastMessage];
        [lastMessage release];
        if(user.status){
            lastMessage.text = user.status;
        }else{
            lastMessage.alpha = 0;
        }
		
		// correct frame, check it on infinite loop =)
		CGRect r = self.frame;
		self.frame = CGRectMake(r.origin.x - r.size.width * .5,
								r.origin.y - r.size.height,
								r.size.width, r.size.height);

        tapView = [[UIView alloc] initWithFrame:self.bounds];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tapView addGestureRecognizer:tap];
        [self addSubview:tapView];
        [tapView release];
        [tap release];
    }
    
    return self;
}

-(void)handleTap:(UITapGestureRecognizer *) gesture{
    [[NSNotificationCenter defaultCenter] postNotificationName:nOpenAnnotationDetails 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObject:[user objectID] forKey:nkData]];
}

- (void)dealloc{
    self.detailedView = nil;
    self.annotationModel = nil;
    self.user = nil;
    
    [super dealloc];
}

@end