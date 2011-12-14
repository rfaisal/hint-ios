//
//  QuizQuestionVC.m
//  Quiz
//
//  Created by You on 04.07.11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "SuperSampleAppDelegate.h"
#import "SubscribedViewController.h"
#import "QuizQuestionVC.h"
#import "QuizTestEngine.h"
#import "QuizStatisticVC.h"


@implementation QuizQuestionVC

@synthesize engine;
@synthesize scrollview;
@synthesize imageView;
@synthesize btn_answer;

- (void) viewDidLoad {
	question = [engine getCurrentQuestion];
    
	currentAnswer = 0;
    
	int topPosition;

    // question without image
	if ([question valueForKey:IMAGE] == nil) {
		UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 100, 100)];
		[img setContentMode:UIViewContentModeScaleAspectFit];
		img.image = [UIImage imageNamed:[question valueForKey:IMAGE]];
		[scrollview addSubview:img];
		[img release];
		
		imageView.frame = CGRectMake(17, 35, 286, 315);
		imageView.image = [UIImage imageNamed:@"white_settings_bg.png"];
		scrollview.frame = CGRectMake(17, 40, 286, 310);
    
    // question with image
	} else {
		UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 100, 100)];
		[img setContentMode:UIViewContentModeScaleAspectFit];
		img.image = [UIImage imageNamed:[question valueForKey:IMAGE]];
		[self.view addSubview:img];
		[img release];
		
		imageView.frame = CGRectMake(17, 110, 286, 240);
		imageView.image = [UIImage imageNamed:@"white_quiz_info_bg.png"];
		scrollview.frame = CGRectMake(17, 115, 286, 230);
	}

	topPosition = 20;
	
	// add question text
	NSString *text = [question valueForKey:TEXT];
    int textHeight = [text sizeWithFont:[UIFont boldSystemFontOfSize:20] constrainedToSize:CGSizeMake(266, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap].height;  
	UILabel *lbl_text =[[UILabel alloc] initWithFrame:CGRectMake(10, topPosition, 266, textHeight)];
	lbl_text.backgroundColor = [UIColor clearColor];
	lbl_text.font = [UIFont systemFontOfSize:20];
	lbl_text.text = text;
	lbl_text.numberOfLines = 0;
	lbl_text.lineBreakMode = UILineBreakModeWordWrap;
	[lbl_text sizeToFit];
	[scrollview addSubview:lbl_text];
	[lbl_text release];
	
	// add answers variants on the view
	answersCount = 1;
	topPosition += textHeight + 20;
	while ([question valueForKey:ANSWER_NUMBER(answersCount)] != nil) {
		NSString *answer = [question valueForKey:ANSWER_NUMBER(answersCount)];
		int answerHeight = [answer sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(216, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap].height;
		UILabel *lbl_answer =[[UILabel alloc] initWithFrame:CGRectMake(60, topPosition, 216, answerHeight)];
		lbl_answer.backgroundColor = [UIColor clearColor];
		lbl_answer.font = [UIFont systemFontOfSize:20];
		lbl_answer.text = answer;
		lbl_answer.numberOfLines = 0;
		lbl_answer.lineBreakMode = UILineBreakModeWordWrap;
		[lbl_answer sizeToFit];
		[scrollview addSubview:lbl_answer];
		[lbl_answer release];
		
		UIButton *btn_check = [[UIButton alloc] initWithFrame:CGRectMake(20, topPosition, 20, 20)];
		btn_check.tag = answersCount;
		[btn_check setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
		[btn_check addTarget:self action:@selector(onCheckClick:) forControlEvents:UIControlEventTouchUpInside];
		[scrollview addSubview:btn_check];
		[btn_check release];
		
		topPosition += answerHeight + 20;
		answersCount++;
	}
	
	scrollview.contentSize = CGSizeMake(286, topPosition);
	
	if (scrollview.contentSize.height > self.scrollview.frame.size.height) {
		[scrollview flashScrollIndicators];
	}
}

// set answer
- (void)onCheckClick:(id)sender {
    
    // check/uncheck
	UIButton *btn_check = (UIButton *)sender;
	for (int i = 1; i < answersCount; i++) {
		btn_check = (UIButton *)[[sender superview] viewWithTag:i];
		[btn_check setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
	}
	
	[(UIButton *)sender setBackgroundImage:[UIImage imageNamed:@"checkedbox.png"] forState:UIControlStateNormal];
	
    // save current answer
    currentAnswer = ((UIButton *)sender).tag;
}

- (IBAction)onAnswerClick {
    [self.navigationController popViewControllerAnimated:NO];

	if(currentAnswer == [[question valueForKey:CORRECT] intValue]) {
		engine.correctAnswersCount++;
		engine.pointsCount += [[question valueForKey:POINTS] intValue];
	}
	
	//check end of the test
    // it's not end
	if (![engine isTestEnd]) {
		//transition to the next question
		QuizQuestionVC *quizQuestionVC = [[QuizQuestionVC alloc] init];
		quizQuestionVC.engine = engine;
        [[((SuperSampleAppDelegate *)[[UIApplication sharedApplication] delegate]).quizRootController navigationController] pushViewController:quizQuestionVC animated:YES];
		[quizQuestionVC release];
        
    // it's the end
	} else {
		//transition to the statistic controller
		QuizStatisticVC *quizStatisticVC = [[QuizStatisticVC alloc] init];
		quizStatisticVC.engine = engine;
        [[((SuperSampleAppDelegate *)[[UIApplication sharedApplication] delegate]).quizRootController navigationController] pushViewController:quizStatisticVC animated:YES];
		[quizStatisticVC release];	
	}
}

- (void)viewDidUnload {
    self.btn_answer = nil;
    self.scrollview = nil;
    self.imageView = nil;

    [super viewDidUnload];
}

- (void)dealloc {
	[engine release];
    
    [super dealloc];
}

@end