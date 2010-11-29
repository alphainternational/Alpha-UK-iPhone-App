// Copyright 2010 Brightec Ltd

#import "MapController.h"
#import "Constants.h"
#import "JsonModel.h"
#import "Pin.h"
#import "Constants.h"
#import "AlphaStyle.h"


@implementation MapController

@synthesize searchBar = _searchBar;
@synthesize mapView = _mapView;
@synthesize query = _query;
@synthesize touchOverlay = _touchOverlay;


static const float minUKLong = -10.81;
static const float maxUKLong = 2.29;
static const float minUKLat = 49.69;
static const float maxUKLat = 59.46;


// utility

MKCoordinateRegion bestRegion(double minLat, double maxLat, double minLong, double maxLong, float extra) {
	MKCoordinateRegion region;
	region.center.latitude = (maxLat + minLat) / 2;
	region.center.longitude = (minLong + maxLong) / 2;
	region.span.latitudeDelta = fabs(maxLat - region.center.latitude) * extra;
	region.span.longitudeDelta = fabs(maxLong - region.center.longitude) * extra;
	return region;
}


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = @"Find a Course";

		self.touchOverlay = [[[UIControl alloc] initWithFrame:CGRectZero] autorelease];
		[self.touchOverlay addTarget:self action:@selector(hideTouchOverlay:) forControlEvents:UIControlEventTouchDown];
	}
	return self;
}


-(void)dealloc {
	self.searchBar = nil;
	self.mapView = nil;
	self.query = nil;
	self.touchOverlay = nil;
	[super dealloc];
}


-(void)loadView {
	[super loadView];
	self.view.backgroundColor = [AlphaStyle lightYellowColor];

	self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0,kNavSpacerHeight,320,kSearchBarHeight)] autorelease];
	self.searchBar.tintColor = [AlphaStyle searchTintColor];  // doesn't always look good
	
	// remove the search bar background
	// this looks for a subview that's as big as the search bar and removes it
	// Note: this relies on undocumented behaviour.

//	UIView *searchBarBackground;
//	for (UIView *s in self.searchBar.subviews) {
//		if (s.frame.size.width > 319.5 && s.frame.size.height > 43.5) {
//			searchBarBackground = s;
//		}
//	}
//	[searchBarBackground removeFromSuperview];
	
	
	self.searchBar.delegate = self;
	self.searchBar.placeholder = @"Enter postcode or town";
	[self.view addSubview:self.searchBar];
	
	float mapY = kNavSpacerHeight+kSearchBarHeight;
	float mapHeight = 460-kNavSpacerHeight-kNavBarHeight-kSearchBarHeight-kTabBarHeight;
	
	self.mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0,mapY,320,mapHeight)] autorelease];
	self.mapView.autoresizingMask = UIViewAutoresizingNone;
	self.mapView.delegate = self;
	[self.view addSubview:self.mapView];
	
	self.touchOverlay.frame = CGRectMake(0, 0, self.mapView.frame.size.width, self.mapView.frame.size.height);
}


-(void)viewDidLoad {
	self.mapView.region = bestRegion(minUKLat, maxUKLat, minUKLong, maxUKLong, 1);
}


-(void)createModel {
	if (self.query) {
		NSString *escapedQuery = [self.query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString *url = [[BASE_URL_DRUPAL stringByAppendingString:@"findacourse/"] stringByAppendingString:escapedQuery];
		JsonModel *model = [(JsonModel *)[JsonModel alloc] initWithURL:url];
		self.model = model;
		[model release];
	}
}


-(void)didLoadModel:(BOOL)firstTime {
	JsonModel *model = (JsonModel *) self.model;
	if ([model isKindOfClass:[JsonModel class]]) {

		[self.mapView removeAnnotations:self.mapView.annotations];
		
		NSArray *pins = model.parsedObject;
		for (Pin *pin in pins) {
			[self.mapView addAnnotation:pin];
		}
		
		// resize around annotations
		if (pins.count > 0) {
			float minLat = 90;
			float maxLat = -90;
			float minLong = 180;
			float maxLong = -180;
			for (Pin *pin in pins) {
				minLat = MIN(minLat, [pin.latitude doubleValue]);
				maxLat = MAX(maxLat, [pin.latitude doubleValue]);
				minLong = MIN(minLong, [pin.longitude doubleValue]);
				maxLong = MAX(maxLong, [pin.longitude doubleValue]);
			}
			
			[self.mapView setRegion:bestRegion(minLat, maxLat, minLong, maxLong, 1.4) animated:YES];
		}
		
	}
}


#pragma mark MKMapViewDelegate


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	Pin *pin = (Pin *)annotation;
	MKPinAnnotationView *pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:pin
																	reuseIdentifier:@"pin"] autorelease];
	pinView.canShowCallout = YES;
	if (pin.color) {
		pinView.pinColor = [pin.color intValue];
	}
	
	UIButton *b = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	[b addTarget:self action:@selector(followLink:) forControlEvents:UIControlEventTouchUpInside];
	pinView.rightCalloutAccessoryView = b;
	
	return pinView;
}


-(void)followLink:(id)sender {
	MKPinAnnotationView *pinView = (MKPinAnnotationView *)[[sender superview] superview];
	Pin *pin = pinView.annotation;
	if (pin.URL) {
		UIViewController *childController = [[TTNavigator navigator] viewControllerForURL:pin.URL];
		[self.navigationController pushViewController:childController animated:YES];
	}
}


#pragma mark UISearchBarDelegate


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	[self.mapView addSubview:self.touchOverlay];
	return YES;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self.touchOverlay removeFromSuperview];
	self.query = self.searchBar.text;
	if (self.query) {
		[self invalidateModel];
	}
	[self.searchBar resignFirstResponder];
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[self.touchOverlay removeFromSuperview];
	[self.searchBar resignFirstResponder];
}


-(void)hideTouchOverlay:(id)sender {
	[self.touchOverlay removeFromSuperview];
	[self.searchBar resignFirstResponder];
}


@end
