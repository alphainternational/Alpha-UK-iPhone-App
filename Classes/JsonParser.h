// Copyright 2010 Brightec Ltd

#import <Foundation/Foundation.h>
#import "Parser.h"


@interface JsonParser : NSObject <Parser> {


}

- (NSObject *)parse:(NSData *)data encoding:(NSStringEncoding)encoding;

@end
