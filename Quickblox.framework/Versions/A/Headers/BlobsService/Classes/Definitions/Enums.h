//
//  Enums.h
//  BlobsService
//

//  Copyright 2010 Mob1serv team. All rights reserved.


enum QBBlobSortByKind{
	QBBlobSortByKindNone = 0,
	QBBlobSortByKindCreatedAt = 1,
	QBBlobSortByKindSize = 2
};

enum QBBlobOwnerType{
	QBBlobOwnerTypeApplication,
	QBBlobOwnerTypeService,
	QBBlobOwnerTypeUser
};

/** The status of blob
 *  format - enum
 *  values - New, Locked, Complete
 */
enum QBBlobStatus{
	QBBlobStatusNew,
	QBBlobStatusLocked,
	QBBlobStatusCompleted
};

enum QBBlobObjectAccessType{
	QBBlobObjectAccessTypeRead,
	QBBlobObjectAccessTypeWrite
};