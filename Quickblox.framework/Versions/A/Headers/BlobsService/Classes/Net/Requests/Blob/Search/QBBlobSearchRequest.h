//
//  BLBlobSearchRequest.h
//  BlobsService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBBlobSearchRequest : PagedRequest {
@private
	// Filters
	NSUInteger blobID;
	NSDate* created_at;
	NSUInteger userID;
	NSUInteger appID;
	NSArray* contentTypes;
	NSArray* tags;
	
	// Ranges
	NSDate* min_created_at;
	NSDate* max_created_at;
	NSUInteger min_size;
	NSUInteger max_size;
	
	// Sorts
	BOOL sort_asc;
	enum QBBlobSortByKind sort_by;	
}

// Filters
@property (nonatomic) NSUInteger blobID;
@property (nonatomic, retain) NSDate* created_at;
@property (nonatomic) NSUInteger userID;
@property (nonatomic) NSUInteger appID;
@property (nonatomic, retain) NSArray* contentTypes;
@property (nonatomic, retain) NSArray* tags;

// Ranges
@property (nonatomic, retain) NSDate* min_created_at;
@property (nonatomic, retain) NSDate* max_created_at;
@property (nonatomic) NSUInteger min_size;
@property (nonatomic) NSUInteger max_size;


// Sorts
@property (nonatomic) BOOL sort_asc;
@property (nonatomic) enum QBBlobSortByKind sort_by;

@property (nonatomic, readonly) NSDictionary* dict;

@end
