//
//
//
#import "Converter.h"

@implementation Converter

#pragma mark -
#pragma mark From String To enum

//+ (enum AttachmentCategory)categoryOfAttachementByString:(NSString*)string {
//	if ([@"main" isEqualToString:string]) {
//		return AttachmentCategoryMain;
//	} else if ([@"public" isEqualToString:string]) {
//		return AttachmentCategoryPublic;
//	} else if ([@"private" isEqualToString:string]) {
//		return AttachmentCategoryPrivate;
//	}
//	
//	return AttachmentCategoryNone;
//}
//+ (enum BlockingStatus)blockedStatusFromString:(NSString*)string {
//	if ([@"U" isEqualToString:string]) {
//		return BlockingStatusUnBlock;
//	} else if ([@"B" isEqualToString:string]) {
//		return BlockingStatusBlock;
//	}
//	
//	return BlockingStatusNone;
//}
//+ (enum ProfileStatus)profileStatusFromString:(NSString*)string {
//	if ([@"N" isEqualToString:string]) {
//		return ProfileStatusNew;
//	} else if ([@"A" isEqualToString:string]) {
//		return ProfileStatusActive;
//	} else if ([@"I" isEqualToString:string]) {
//		return ProfileStatusInactive;
//	} else if ([@"D" isEqualToString:string]) {
//		return ProfileStatusDeleted;
//	}
//	
//	return ProfileStatusNone;
//}
//+ (enum MessageFolderType)messageFolderTypeFromString:(NSString*)string {
//	if ([@"N" isEqualToString:string]) {
//		return MessageFolderTypeUnread;
//	} else if ([@"A" isEqualToString:string]) {
//		return MessageFolderTypeRead;
//	} else if ([@"I" isEqualToString:string]) {
//		return MessageFolderTypeSent;
//	} else if ([@"D" isEqualToString:string]) {
//		return MessageFolderTypeRecieved;
//	} else if ([@"D" isEqualToString:string]) {
//		return MessageFolderTypeSaved;
//	}
//	
//	return MessageFolderTypeNone;
//}
//+ (enum ReasonStatus)reasonStatusFromString:(NSString*)string {
//	if([string isEqualToString:nReasonStatusBoyfriending])
//		return ReasonStatusBoyfriending;
//	if([string isEqualToString:nReasonStatusChat])
//		return ReasonStatusChat;
//	if([string isEqualToString:nReasonStatusDateing])
//		return ReasonStatusDateing;
//	if([string isEqualToString:nReasonStatusHookUpLater])
//		return ReasonStatusHookUpLater;
//	if([string isEqualToString:nReasonStatusHookUpNow])
//		return ReasonStatusHookUpNow;
//	if([string isEqualToString:nReasonStatusMessaging])
//		return ReasonStatusMessaging;
//	if([string isEqualToString:nReasonStatusTraveling])
//		return ReasonStatusTraveling;
//	return ReasonStatusNone;
//}
//+ (enum ReasonStatus)reasonStatusFromShortString:(NSString*)string{
//	if([string isEqualToString:nReasonStatusShortBoyfriending])
//		return ReasonStatusBoyfriending;
//	if([string isEqualToString:nReasonStatusShortChat])
//		return ReasonStatusChat;
//	if([string isEqualToString:nReasonStatusShortDateing])
//		return ReasonStatusDateing;
//	if([string isEqualToString:nReasonStatusShortHookUpLater])
//		return ReasonStatusHookUpLater;
//	if([string isEqualToString:nReasonStatusShortHookUpNow])
//		return ReasonStatusHookUpNow;
//	if([string isEqualToString:nReasonStatusShortMessaging])
//		return ReasonStatusMessaging;
//	if([string isEqualToString:nReasonStatusShortTraveling])
//		return ReasonStatusTraveling;
//	return ReasonStatusNone;
//}
//#pragma mark -
//#pragma mark From enum to string
//
//+ (NSString*)stringFromReasonStatus:(enum ReasonStatus)status {
//	switch (status) {
//		case ReasonStatusNone:
//			return nReasonStatusNone;
//		case ReasonStatusBoyfriending:
//			return nReasonStatusBoyfriending;
//		case ReasonStatusChat:
//			return nReasonStatusChat;
//		case ReasonStatusDateing:
//			return nReasonStatusDateing;
//		case ReasonStatusHookUpLater:
//			return nReasonStatusHookUpLater;
//		case ReasonStatusHookUpNow:
//			return nReasonStatusHookUpNow;
//		case ReasonStatusMessaging:
//			return nReasonStatusMessaging;
//		case ReasonStatusTraveling:
//			return nReasonStatusTraveling;
//	}
//	
//	return @"";
//}
//
//+ (NSString*)shortStringFromReasonStatus:(enum ReasonStatus)status {
//	switch (status) {
//		case ReasonStatusNone:
//			return nReasonStatusNone;
//		case ReasonStatusBoyfriending:
//			return nReasonStatusShortBoyfriending;
//		case ReasonStatusChat:
//			return nReasonStatusShortChat;
//		case ReasonStatusDateing:
//			return nReasonStatusShortDateing;
//		case ReasonStatusHookUpLater:
//			return nReasonStatusShortHookUpLater;
//		case ReasonStatusHookUpNow:
//			return nReasonStatusShortHookUpNow;
//		case ReasonStatusMessaging:
//			return nReasonStatusShortMessaging;
//		case ReasonStatusTraveling:
//			return nReasonStatusShortTraveling;
//	}
//	
//	return @"";
//}
//
//+ (NSString*)categoryForUserFriendState:(enum UserFriendState)state {
//	switch (state) {
//		case UserFriendStateFriend:
//			return @"friends";
//		case UserFriendStateFavourite:
//			return @"favourites";
//		case UserFriendStateAll:
//			return @"all";
//	}
//	
//	return @"";
//}
//+ (NSString*)stringFromProfileStatus:(enum ProfileStatus)state {
//	switch (state) {
//		case ProfileStatusNew:
//			return @"N";
//		case ProfileStatusActive:
//			return @"A";
//		case ProfileStatusInactive:
//			return @"I";
//		case ProfileStatusDeleted:
//			return @"D";
//	}
//	
//	return @"";
//}

+ (NSString*)stringByCategoryOfAttachement:(enum AttachmentCategory)category {
	switch (category) {
		case AttachmentCategoryMain:
			return @"main";
		case AttachmentCategoryPrivate:
			return @"private";
		case AttachmentCategoryPublic:
			return @"public";
	}
	
	return @"";
}
//+ (NSString*)stringFromMessageFolderType:(enum MessageFolderType)type {
//	switch (type) {
//		case MessageFolderTypeUnread:
//			return @"unread";
//		case MessageFolderTypeRead:
//			return @"read";
//		case MessageFolderTypeSent:
//			return @"sent";
//		case MessageFolderTypeRecieved:
//			return @"received";
//		case MessageFolderTypeSaved:
//			return @"saved";
//	}
//	
//	return @"";	
//}
//
#pragma mark -
#pragma mark Date Fromaters

+ (NSDate*)dateFromXMLString:(NSString*)string {
	string = [string stringByReplacingOccurrencesOfString:@"Z" withString:@""];
	string = [string stringByReplacingOccurrencesOfString:@"+" withString:@":"];
	NSArray* ar1 = [string componentsSeparatedByString:@"T"];
	NSArray* dar = [(NSString*)[ar1 objectAtIndex:0] componentsSeparatedByString:@"-"];
	NSArray* tar = [(NSString*)[ar1 objectAtIndex:1] componentsSeparatedByString:@":"];
	NSString* year = (NSString*)[dar objectAtIndex:0];
	NSString* month = (NSString*)[dar objectAtIndex:1];
	NSString* day = (NSString*)[dar objectAtIndex:2];
	NSString* hour = (NSString*)[tar objectAtIndex:0];
	NSString* minute = (NSString*)[tar objectAtIndex:1];
	NSString* second = (NSString*)[tar objectAtIndex:2];
	NSDateComponents* components = [[NSDateComponents alloc] init];
	[components setYear:[year intValue]];
	[components setMonth:[month intValue]];
	[components setDay:[day intValue]];
	[components setHour:[hour intValue]];
	[components setMinute:[minute intValue]];
	[components setSecond:[second intValue]];
	BOOL addToData = NO;
	NSInteger destinationGMTOffset;
	if ([components respondsToSelector:@selector(setTimeZone:)]) {
		[components setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	} else {
		NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
		
		destinationGMTOffset = [destinationTimeZone secondsFromGMT];
		addToData = YES;
	}
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate* dt = [gregorian dateFromComponents:components];
	[components release];
	[gregorian release];
	
	if (addToData) {
		[dt dateByAddingTimeInterval:destinationGMTOffset];
	}
	
	 return dt;
}
+ (NSString*)stringFromDateToXML:(NSDate*)date {
	NSDateFormatter *dateFromXMLFormater = [[[NSDateFormatter alloc] init] autorelease];
	[dateFromXMLFormater setDateFormat:@"yyyy-MM-ddeeeeeHH:mm:ss"];
	NSDateFormatter	*dateFromXMLFormater2 = [[[NSDateFormatter alloc] init] autorelease];
	[dateFromXMLFormater2 setDateFormat:@"eeeee"];
	NSString * d = [[dateFromXMLFormater stringFromDate:date] 
					stringByReplacingOccurrencesOfString:[dateFromXMLFormater2 stringFromDate:date] 
					 withString:@"T"];
	return d;
}

+ (NSString*) decodeHtmlUnicodeCharactersToString:(NSString*)html start:(int)start
{
    if ([html isEqualToString:@"(null)"]) {
        return @"";
    }
    return [self decodeNonRomanHtmlUnicodeCharactersToString:html start:0];
    NSMutableString* string = [[NSMutableString alloc] initWithString:html];
    NSString* unicodeStr = nil;
    NSString* replaceStr = nil;
    BOOL containUnicode = NO;
	int unicodeCharStart = [string rangeOfString:@"&#" 										 
										 options:NSLiteralSearch 
										   range:NSMakeRange(start, [string length] - start)].location;
    for(int i = unicodeCharStart; i < [string length] - 1; i++)
    {
        unichar char1 = [string characterAtIndex:i];    
		unichar char2 = [string characterAtIndex:i+1]; 
		int unicodeCharEnd = [[string substringFromIndex:i] rangeOfString:@";"].location;
		if ((char1 == '&'  && char2 == '#' && (unicodeCharEnd >= 1 && unicodeCharEnd <= 2)) || (unicodeCharEnd > 6 && unicodeCharEnd <= 9)) {
            return [self decodeNonRomanHtmlUnicodeCharactersToString:html start:0];
        }
		if (char1 == '&'  && char2 == '#' && unicodeCharEnd >= 3 && unicodeCharEnd <= 6) 
		{   
			containUnicode = YES;
			unicodeStr = [string substringWithRange:NSMakeRange(i + 2 , unicodeCharEnd - 2)];    
			replaceStr = [string substringWithRange:NSMakeRange(i, unicodeCharEnd + 1)];
			if([unicodeStr intValue] > 0)
			{
                NSString *replacement = [NSString stringWithFormat:@"%c",[unicodeStr intValue]];
				[string replaceCharactersInRange:[string rangeOfString:replaceStr] 
									  withString:replacement];
				unicodeCharStart = i;
				break;
			}
		}
		
		containUnicode = NO;
		i = [string rangeOfString:@"&#" options:NSLiteralSearch range:NSMakeRange(i + 1, [string length] - i - 1)].location - 1;
    }
	
    [string autorelease];
	
    if (containUnicode)
	{
        return  [self decodeHtmlUnicodeCharactersToString:string start:unicodeCharStart]; 
	}
    else
	{
		[string replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
        [string replaceOccurrencesOfString:@"&apos;" withString:@"'" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
        [string replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
        [string replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
        [string replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
		
        
        NSString *result = [[[NSString alloc] initWithData:[string dataUsingEncoding:[NSString defaultCStringEncoding]] 
                                                  encoding:NSUTF8StringEncoding] autorelease];
		return result;
	}
}   
+ (NSString*) decodeNonRomanHtmlUnicodeCharactersToString:(NSString*)html start:(int)start 
{	
	if([html isEqualToString:@""])
	{
		return @"";
	}
	
    NSMutableString* string = [[NSMutableString alloc] initWithString:html];
	NSString* unicodeStr = nil;
    NSString* replaceStr = nil;
    BOOL containUnicode = NO;
	int unicodeCharStart = [string rangeOfString:@"&#" 										 
										 options:NSLiteralSearch 
										   range:NSMakeRange(start, [string length] - start)].location;
    for(int i = unicodeCharStart; i < [string length] - 1; i++) {
        unichar char1 = [string characterAtIndex:i];    
		unichar char2 = [string characterAtIndex:i+1]; 
		int unicodeCharEnd = [[string substringFromIndex:i] rangeOfString:@";"].location;
		if (char1 == '&'  && char2 == '#' && unicodeCharEnd >= 1 && unicodeCharEnd <= 9) {   
			containUnicode = YES;
			unicodeStr = [string substringWithRange:NSMakeRange(i + 2 , unicodeCharEnd - 2)];    
			replaceStr = [string substringWithRange:NSMakeRange(i, unicodeCharEnd + 1)];
			if([unicodeStr intValue] > 0) {
                NSString *replacement = [NSString stringWithFormat:@"%C",[unicodeStr intValue]];
				[string replaceCharactersInRange:[string rangeOfString:replaceStr] 
									  withString:replacement];
				unicodeCharStart = i;
				break;
			}
		}
		
		containUnicode = NO;
		i = [string rangeOfString:@"&#" options:NSLiteralSearch range:NSMakeRange(i + 1, [string length] - i - 1)].location - 1;
    }
	
    [string autorelease];
	
    if (containUnicode) {
        return  [self decodeNonRomanHtmlUnicodeCharactersToString:string start:unicodeCharStart]; 
	} else {
		[string replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
        [string replaceOccurrencesOfString:@"&apos;" withString:@"'" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
        [string replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
        [string replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
        [string replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
		
	}
    return string;
}


@end
