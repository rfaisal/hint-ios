//
//  QuizStatisticVC.h
//  Quiz
//
//  Created by You on 05.07.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuizTestEngine;

@interface QuizStatisticVC : UIViewController {
	QuizTestEngine *engine;

	UIButton *btn_view_leardbord;
}

@property (nonatomic, retain) QuizTestEngine *engine;
@property (nonatomic, retain) IBOutlet UIButton *btn_view_leardbord;

- (IBAction)onLeaderboardClick;

@end