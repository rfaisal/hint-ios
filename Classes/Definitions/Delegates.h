//
//  Delegates.h
//  SuperSample
//
//  Created by Andrey Kozlov on 9/14/11.
//  Copyright (c) 2011 YAS. All rights reserved.
//

#ifndef SuperSample_Delegates_h
#define SuperSample_Delegates_h


@class LoadableDataSource;
@protocol BaseDataSourceDelegate

@optional

- (void)dataSource:(LoadableDataSource *)dataSource selectRowWithObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath;
- (void)dataSource:(LoadableDataSource *)dataSource detailRowWithObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath;
- (void)dataSource:(LoadableDataSource *)dataSource selectObject:(NSObject *)object atIndex:(NSUInteger)index;
- (void)allObjectsDidDelete:(LoadableDataSource *)dataSource;

- (void)dataStartLoading:(LoadableDataSource *)dataSource;
- (void)dataSource:(LoadableDataSource *)dataSource loadProgressChangeTo:(float)progress;
- (void)dataLoaded:(LoadableDataSource *)dataSource;

@end

@class ChatEntry;
@protocol ChatProtocolDelegate <NSObject>
- (void) openConversationWith:(ChatEntry*)chat;
- (void) setNewMessagesValue:(NSUInteger)mCount;
- (void) refreshConversation;
- (void) openConversations;
@end

#endif
