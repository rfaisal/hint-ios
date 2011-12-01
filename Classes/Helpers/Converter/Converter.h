//
//
//

@interface Converter : NSObject {

}

+ (enum AttachmentCategory)categoryOfAttachementByString:(NSString*)string;
+ (enum BlockingStatus)blockedStatusFromString:(NSString*)string;
+ (enum ProfileStatus)profileStatusFromString:(NSString*)string;
+ (enum MessageFolderType)messageFolderTypeFromString:(NSString*)string;
+ (enum ReasonStatus)reasonStatusFromString:(NSString*)string; 
+ (enum ReasonStatus)reasonStatusFromShortString:(NSString*)string; 

+ (NSString*)shortStringFromReasonStatus:(enum ReasonStatus)status;
+ (NSString*)stringFromReasonStatus:(enum ReasonStatus)status;
+ (NSString*)categoryForUserFriendState:(enum UserFriendState)state;
+ (NSString*)stringFromProfileStatus:(enum ProfileStatus)state;
+ (NSString*)stringFromMessageFolderType:(enum MessageFolderType)type;
+ (NSString*)stringByCategoryOfAttachement:(enum AttachmentCategory)category;
+ (NSDate*)dateFromXMLString:(NSString*)string;
+ (NSString*)stringFromDateToXML:(NSDate*)date;
+ (NSDate*)dateToLocalTimeFromServerDate:(NSDate*)servDate forTimeZone:(NSTimeZone*)servTZ;
+ (NSString*) decodeHtmlUnicodeCharactersToString:(NSString*)str start:(int)start;
+ (NSString*) decodeNonRomanHtmlUnicodeCharactersToString:(NSString*)html start:(int)start;
@end
    