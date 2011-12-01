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

@implementation PinView

@synthesize imageView, lastMessage, detailedView, powerView, annotationModel,tapView;


-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])) {

		UIImage *img = [UIImage imageNamed: @"marker_offline.png"];
		
		self.backgroundColor = [UIColor clearColor];
		
		const float labelWidth = 80;
		const float labelHeight = 24;
		
		self.frame = CGRectMake(0, 0, labelWidth, img.size.height + labelHeight);
		
		imageView = [[UIImageView alloc] initWithFrame: CGRectMake(self.frame.size.width * .5 - img.size.width * .5,
																   labelHeight, 
																   img.size.width, img.size.height)];
		imageView.image = img;
		[self addSubview: imageView];
		
		powerView = [[UIImageView alloc] init];
		powerView.frame = CGRectMake(self.frame.size.width / 2 - img.size.width / 2 + 2, 26, 26, 3);
		powerView.image = [UIImage imageNamed:@"img_power_line.png"];

		powerView.layer.cornerRadius = (0 - 2) * 0.5;
		[self addSubview: powerView];
		
		lastMessage = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, labelWidth, labelHeight)];
		lastMessage.backgroundColor = [UIColor colorWithRed: .5
													  green: .5
													   blue: .5
													  alpha: .7];

		lastMessage.textAlignment = UITextAlignmentCenter;
		lastMessage.numberOfLines = 2;
		lastMessage.layer.cornerRadius = 4;
		lastMessage.textColor = [UIColor whiteColor];
		lastMessage.font = [UIFont boldSystemFontOfSize: 10];
		[self addSubview: lastMessage];
		
		// correct frame, check it on infinite loop =)
		CGRect r = self.frame;
		self.frame = CGRectMake(r.origin.x - r.size.width * .5,
								r.origin.y - r.size.height,
								r.size.width, r.size.height);

        self.tapView=[[UIView alloc] initWithFrame:self.bounds];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tapView addGestureRecognizer:tap];
        [self addSubview:self.tapView];
        [tap release];
    }
    return self;

}

-(void)handleTap:(UITapGestureRecognizer*) gesture{
    Users* model;
    model= self.annotationModel.userModel;
    NSLog(@"user uid from pinvew: %@", model.uid);
    [[NSNotificationCenter defaultCenter] postNotificationName:nOpenAnnotationDetails object:nil userInfo:[NSDictionary dictionaryWithObject:[model objectID] forKey:nkData]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    self.tapView=nil;
    self.lastMessage=nil;
    self.powerView=nil;
    self.imageView=nil;
    self.detailedView=nil;
    self.annotationModel=nil;
    [super dealloc];
}

@end
