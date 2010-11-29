// Copyright 2010 Brightec Ltd

#import "JsonParser.h"
#import "NSString+SBJSON.h"


@interface JsonParser(Private)

- (id)parseDictionary:(NSDictionary *)d;
- (id)parseArray:(NSArray *)a;
- (id)parseObject:(NSObject *)o;

@end
	


@implementation JsonParser


- (NSObject *)parse:(NSData *)data encoding:(NSStringEncoding)encoding {
	NSString *str = [[[NSString alloc] initWithData:data encoding:encoding] autorelease];
	NSObject *jsonValue = [str JSONValue];
	NSObject *object = [self parseObject:jsonValue];
	return object;
}


- (id)parseDictionary:(NSDictionary *)d {
	
	NSString *className = [d valueForKey:@"class"];
	Class c = NSClassFromString(className);
	id object = [[[c alloc] init] autorelease];
	
	NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:[d count]-1];
	
	for (NSString *key in d) {
		if (![key isEqualToString:@"class"]) {
			NSObject *value = [d objectForKey:key];
			[md setObject:[self parseObject:value] forKey:key];
		}
	}
	
	[object setValuesForKeysWithDictionary:md];
	return object;   
}


- (id)parseArray:(NSArray *)a {
	
	NSMutableArray *ma = [NSMutableArray arrayWithCapacity:[a count]];
	for (NSObject *o in a) {
		[ma addObject:[self parseObject:o]];
	}
	return ma;
	
}


- (id)parseObject:(NSObject *)o {
	
	if ([o isKindOfClass:[NSDictionary class]]) {
		return [self parseDictionary:(NSDictionary *)o];
	} else if ([o isKindOfClass:[NSArray class]]) {
		return [self parseArray:(NSArray *)o];
	} else {
		return o;
	}
}


@end
