// Copyright 2010 Brightec Ltd

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Three20/Three20.h"


@interface MapController : TTModelViewController <MKMapViewDelegate, UISearchBarDelegate> {

	UISearchBar *_searchBar;
	MKMapView *_mapView;
	NSString *_query;
	UIControl *_touchOverlay;

}

@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) NSString *query;
@property (nonatomic, retain) UIControl *touchOverlay;

@end

