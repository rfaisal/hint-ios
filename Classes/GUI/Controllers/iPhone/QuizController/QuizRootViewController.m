//
//  QuizRootViewController.m
//  Quiz
//
//  Created by Igor Khomenko on 04.07.10.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "QuizRootViewController.h"
#import "QuizQuestionVC.h"



@implementation QuizRootViewController

@synthesize btn_go;
@synthesize engine;

- (IBAction)onStartClick {
    // parse quiz xml
	engine = [[QuizTestEngine alloc] init];
	[engine initQuestions];
    
	QuizQuestionVC *quizQuestionVC = [[QuizQuestionVC alloc] init];
	quizQuestionVC.engine = engine;
    
	[self.navigationController pushViewController:quizQuestionVC animated:YES];
	[quizQuestionVC release];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidUnload {
    self.btn_go = nil;
    
    [super viewDidUnload];
}

- (void)dealloc {
    [engine release];
    
    [super dealloc];
}

@end