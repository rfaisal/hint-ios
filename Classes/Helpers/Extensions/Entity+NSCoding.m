//
//  Entity+NSCoding.m
//  SuperSample
//
//  Created by Eugene Pavlyuk on 11/3/11.
//  Copyright (c) 2011 YAS. All rights reserved.
//

#import "Entity+NSCoding.h"
#import "Macro.h"

@implementation Entity(NSCoding)

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super init]))
	{
		DESERIALIZE_INT(ID, aDecoder);
        DESERIALIZE_BOOL(autosave, aDecoder);
        
        DESERIALIZE_OBJECT(updatedAt, aDecoder);
        DESERIALIZE_OBJECT(createdAt, aDecoder);
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    SERIALIZE_INT(ID, aCoder);
    SERIALIZE_BOOL(autosave, aCoder);
    
	SERIALIZE_OBJECT(updatedAt, aCoder);
    SERIALIZE_OBJECT(createdAt, aCoder);
}

@end
