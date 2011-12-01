//

#import "LoadBinaryAnswer.h"
#import "LoadBinaryResult.h"

@implementation LoadBinaryAnswer

- (Result *)allocResult {
    return [LoadBinaryResult alloc];
}

@end
