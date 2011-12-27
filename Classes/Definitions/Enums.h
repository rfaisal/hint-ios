//
//  Enums.h
//  SuperSample
//
//  Created by Andrey Kozlov on 9/14/11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#ifndef SuperSample_Enums_h
#define SuperSample_Enums_h

enum DownloadStatus {
	DownloadStatusUndefined = -1,
	DownloadStatusStarted = 0,
	DownloadStatusPaused = 2,
	DownloadStatusFailed = 4,
    DownloadStatusFinished = 8
};

enum ChatMessageType {
	ChatMessageTypeText = 0,
	ChatMessageTypeImage = 1,
	ChatMessageTypeVideo = 2,
	ChatMessageTypeLocation = 3,
	ChatMessageStartDate = 4
};

enum AttachmentCategory {
	AttachmentCategoryNone = 0,
	AttachmentCategoryMain = 1,
	AttachmentCategoryPublic = 2,
	AttachmentCategoryPrivate = 3
};

#endif
