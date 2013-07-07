//


@interface SubscribedView : UIView {
    
}

- (void)subscribe;
- (void)unsubscribe;

- (void)addObservers:(NSObject*)observable forKeyPaths:(NSArray*)keyPaths;
- (void)removeObservers:(NSObject*)observable forKeyPaths:(NSArray*)keyPaths;
- (void)addObserversForKeyPaths:(NSArray*)keyPaths;
- (void)removeObserversForKeyPaths:(NSArray*)keyPaths;

- (void)startInit;
- (void)releaseProperties;

@end
