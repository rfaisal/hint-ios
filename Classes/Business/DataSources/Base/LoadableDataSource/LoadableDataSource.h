//
//  LoadableDataSource.h
//  SuperSample
//
//  Created by Andrey Kozlov on 8/5/11.
//  Copyright 2011 YAS. All rights reserved.
//

@interface LoadableDataSource : NSObject <ActionStatusDelegate> {
    NSObject<BaseDataSourceDelegate> *delegate;
	NSObject<Cancelable> *canceler;
}

@property (nonatomic, retain) NSObject<Cancelable> *canceler;

@property (nonatomic, assign) IBOutlet NSObject<BaseDataSourceDelegate> *delegate;

- (void)startInit;
- (void)releaseObjects;

- (void)subscribe; 
- (void)unsubscribe;

- (void)clearCashData;

- (void)refreshLastCell;

- (void)reloadData;
- (void)cancelReload;

- (void)loadData:(Result*)result;

- (void)loadStarted;
- (void)setLoadProgress:(float)progress;
- (void)loadFinished;
- (void)loadError:(NSArray*)errors;

@end
