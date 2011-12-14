//
//  QuizQuestionVC.h
//  Quiz
//
//  Created by You on 04.07.11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuizTestEngine;

@interface QuizQuestionVC : UIViewController {
	NSMutableDictionary *question;

	int answersCount;
	int currentAnswer;
}

@property (nonatomic, retain) QuizTestEngine *engine;
@property (nonatomic, retain) IBOutlet UIButton *btn_answer;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollview;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

- (IBAction)onAnswerClick;

@end