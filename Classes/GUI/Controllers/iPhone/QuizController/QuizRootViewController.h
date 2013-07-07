//
//  QuizRootViewController.h
//  Quiz
//
//  Created by Igor Khomenko on 04.07.10.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubscribedViewController.h"
#import "QuizTestEngine.h"

@interface QuizRootViewController : SubscribedViewController {
	UIButton *btn_go;
}

@property (nonatomic, retain) IBOutlet UIButton *btn_go;
@property (nonatomic, retain) QuizTestEngine *engine;

- (IBAction)onStartClick;

@end