//
//  FileModel.h
//  
//


//
@class AttachmentDataModel;

@interface FileModel : NSObject {
	// File Type
	NSString *type;
	
	NSString *urlThambneil;
	NSString *urlFile;
	
	AttachmentDataModel *attachement;
}

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *urlThambneil;
@property (nonatomic, retain) NSString *urlFile;

@property (nonatomic, retain) AttachmentDataModel *attachement;

- (id)initWithType:(NSString*)t thumbnail:(NSString*)thumb file:(NSString*)file;

@end
