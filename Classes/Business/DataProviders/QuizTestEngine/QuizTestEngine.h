//
//  QuizXMLParser.h
//  Quiz
//
//  Created by You on 04.07.11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import <Foundation/Foundation.h>

//xml nodes constants
#define TEST @"test"
#define TEXT @"text"
#define QUESTION @"question"
#define POINTS @"points"
#define ANSWERS @"answers"
#define ANSWER @"answer"
#define ANSWER_NUMBER(X) [NSString stringWithFormat:@"answer %d", X]
#define IMAGE @"image"
#define CORRECT @"correct"

@interface QuizTestEngine : NSObject <NSXMLParserDelegate>{
	NSMutableDictionary *question;
	NSMutableArray *test;
	NSString *dictionaryKey;
	NSString *currentElement;
    
	int currentQuestion;
	int correctAnswersCount;
	int pointsCount;
}

@property(nonatomic, assign) int correctAnswersCount;
@property(nonatomic, assign) int pointsCount;

- (void)initQuestions;
- (BOOL)isTestEnd;
- (NSMutableDictionary *)getCurrentQuestion;

@end