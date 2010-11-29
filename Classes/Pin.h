// Copyright 2010 Brightec Ltd

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface Pin : NSObject <MKAnnotation> {
	
	NSString *_title;
	NSString *_subtitle;
	NSString *_URL;
	NSNumber *_color;
	NSNumber *_latitude;
	NSNumber *_longitude;

}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSString *URL;
@property (nonatomic, retain) NSNumber *color;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;

@end
