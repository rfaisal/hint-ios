//
//  QuizXMLParser.m
//  Quiz
//
//  Created by You on 04.07.11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "QuizTestEngine.h"

@implementation QuizTestEngine

@synthesize correctAnswersCount;
@synthesize pointsCount;

- (void)initQuestions {
	currentQuestion = 0;
	correctAnswersCount = 0;
	pointsCount = 0;
    
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"xml"]; 
	NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    // parse XML
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
	[parser parse];
	[parser release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
            qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    
	static int answersCounterInQuestion; 
    
	if ([elementName isEqualToString:TEST]) {
		test = [[NSMutableArray alloc] init];
	} else if ([elementName isEqualToString:QUESTION]) {
		question = [[NSMutableDictionary alloc] init];
	} else if ([elementName isEqualToString:TEXT]) {
		dictionaryKey = TEXT;
	} else if ([elementName isEqualToString:ANSWERS]) {
		answersCounterInQuestion = 1;
	} else if ([elementName isEqualToString:ANSWER]) {
		if ([[attributeDict objectForKey:@"true"] isEqualToString:@"YES"]) {
			[question setValue:[NSString stringWithFormat:@"%d", answersCounterInQuestion] forKey:CORRECT];
		}
		dictionaryKey = ANSWER_NUMBER(answersCounterInQuestion++);
	} else if ([elementName isEqualToString:IMAGE]) {
		dictionaryKey = IMAGE;
	} else if ([elementName isEqualToString:POINTS]) {
		dictionaryKey = POINTS;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (dictionaryKey != nil) {
		[question setValue:string forKey:dictionaryKey];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:QUESTION]) {
		[test addObject:question];
		[question release];
	} else {
		dictionaryKey = nil;
	}
}

- (BOOL)isTestEnd {
	if (currentQuestion < [test count]) {
		return NO;
	} else {
		return YES;
	}
}

- (NSMutableDictionary *)getCurrentQuestion {
	if (currentQuestion < [test count]) {
		return [test objectAtIndex:currentQuestion++];
	} else {
		return nil;
	}
}

- (void) dealloc{
    [test release];
    [question release];
    
    [super dealloc];
}

@end