//
//  QBUUser+NSCoding.m
//  SuperSample
//
//  Created by Eugene Pavlyuk on 11/3/11.
//  Copyright (c) 2011 YAS. All rights reserved.
//

#import "QBUUser+NSCoding.h"
#import "Macro.h"
#import "Entity+NSCoding.h"

@implementation QBUUser(NSCoding)

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
        DESERIALIZE_INT(externalUserID, aDecoder);     
        DESERIALIZE_OBJECT(fullName, aDecoder);
        DESERIALIZE_OBJECT(email, aDecoder);
        DESERIALIZE_OBJECT(login, aDecoder);
        DESERIALIZE_OBJECT(password, aDecoder);
        DESERIALIZE_OBJECT(phone, aDecoder);
        DESERIALIZE_OBJECT(website, aDecoder);
        DESERIALIZE_INT(blobID, aDecoder);
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    SERIALIZE_INT(externalUserID, aCoder);   
    SERIALIZE_OBJECT(fullName, aCoder);
    SERIALIZE_OBJECT(email, aCoder);
    SERIALIZE_OBJECT(login, aCoder);
    SERIALIZE_OBJECT(password, aCoder);
    SERIALIZE_OBJECT(phone, aCoder);
    SERIALIZE_OBJECT(website, aCoder);
    SERIALIZE_INT(blobID, aCoder);
}

@end
