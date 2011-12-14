//
//  QuizStatisticVC.m
//  Quiz
//
//  Created by You on 05.07.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SuperSampleAppDelegate.h"
#import "SubscribedViewController.h"
#import "QuizStatisticVC.h"
#import "QuizTestEngine.h"
#import "Users.h"
#import "UsersProvider.h"

@implementation QuizStatisticVC

@synthesize engine;
@synthesize btn_view_leardbord;

- (void)viewDidLoad {
	[super viewDidLoad];

	UILabel *lbl_correct = [[UILabel alloc] initWithFrame:CGRectMake(35, 75, 250, 44)];
	lbl_correct.backgroundColor = [UIColor clearColor];
	lbl_correct.font = [UIFont systemFontOfSize:15];
	lbl_correct.text = [NSString stringWithFormat:@"Correct answers: %d", engine.correctAnswersCount];
	[self.view addSubview:lbl_correct];
	[lbl_correct release];
	
	UILabel *lbl_points = [[UILabel alloc] initWithFrame:CGRectMake(35, 140, 250, 44)];
	lbl_points.backgroundColor = [UIColor clearColor];
	lbl_points.font = [UIFont systemFontOfSize:15];
	lbl_points.text = [NSString stringWithFormat:@"You have earned: %d points", engine.pointsCount];
	[self.view addSubview:lbl_points];
	[lbl_points release];
    
    // save ratings
    unsigned int currentUserID = [[UsersProvider sharedProvider] currentUserID];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    int currentUserRatings = [defaults integerForKey:[NSString stringWithFormat:kUserRatingsFormat, currentUserID]];
    currentUserRatings += engine.pointsCount;
    [defaults setInteger:currentUserRatings forKey:[NSString stringWithFormat:kUserRatingsFormat, currentUserID]];
    [defaults synchronize];
                                     
	UILabel *lbl_fanPower = [[UILabel alloc] initWithFrame:CGRectMake(35, 210, 250, 44)];
	lbl_fanPower.backgroundColor = [UIColor clearColor];
	lbl_fanPower.font = [UIFont systemFontOfSize:15];
	lbl_fanPower.text = [NSString stringWithFormat:@"Your total Ratings is now %d", currentUserRatings];
	[self.view addSubview:lbl_fanPower];
	[lbl_fanPower release];
    
    
    self.navigationController.navigationBarHidden = NO;
	self.navigationItem.title = @"Thank you for passing our quiz";
}

- (IBAction)onLeaderboardClick {
	[self.navigationController popViewControllerAnimated:NO];
    
	//QuizLeaderboard *leaderboard = [[QuizLeaderboard alloc] init];
    //[[((SuperSampleAppDelegate *)[[UIApplication sharedApplication] delegate]).quizRootController navigationController] pushViewController:leaderboard animated:YES];
	//[leaderboard release];
}

- (void)viewDidUnload {
    self.btn_view_leardbord = nil;
    
    [super viewDidUnload];
}

- (void)dealloc {
	[engine release];
    
    [super dealloc];
}

@end