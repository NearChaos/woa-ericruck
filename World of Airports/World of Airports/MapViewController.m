//
//  MapViewController.m
//  World of Airports
//
//  Created by Eric Ruck on 12/16/14.
//  Copyright 2014 NearChaos. All Rights Reserved.
//

#import "MapViewController.h"
#import "QueryLatLong.h"
#import "Location.h"


@interface MapViewController (Private)
@end


@implementation MapViewController

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
	// Clear annotations for old region
	[mapView removeAnnotations:mapView.annotations];
}


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
	// Do we have a query running now?
	if (self->currentQuery) {
		// Yes, cancel it
		[self->currentQuery cancel];
	}

	// Query for the locations
	QueryArea qa =
		{{mapView.region.center.latitude  - (mapView.region.span.latitudeDelta  / 2),
		  mapView.region.center.longitude - (mapView.region.span.longitudeDelta / 2)},
		 {mapView.region.center.latitude  + (mapView.region.span.latitudeDelta  / 2),
		  mapView.region.center.longitude + (mapView.region.span.longitudeDelta / 2)}};
	self->currentQuery = [QueryLatLong queryArea:&qa for:self];
	NSString *errorMsg = self->currentQuery.execute;
	if (errorMsg) {
		// Failed to start locations query
		self->currentQuery = nil;
		mapView.userInteractionEnabled = YES;
		[[[UIAlertView alloc] initWithTitle:@"Query Locations Error"
				message:errorMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
			show];
	} else {
		// Show wait cursor
		self.waiting.hidden = NO;
	}
}


-(void)webService:(WebService *)service didFailWithMessage:(NSString *)errorMsg {
	// Cleanup our state
	self->currentQuery = nil;
	self.waiting.hidden = YES;

	// Show the error
	[[[UIAlertView alloc] initWithTitle:@"Query Locations Error"
			message:errorMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
		show];
}


-(void)webService:(WebService *)service completedResult:(NSDictionary *)result {
	// Cleanup our state
	self->currentQuery = nil;
	self.waiting.hidden = YES;

	// Often there will be other web service, so we should take care which
	// we are processing
	if ([service isKindOfClass:[QueryLatLong class]]) {
		// Handle location results
		self.map.userInteractionEnabled = YES;
		[self.map addAnnotations:((QueryLatLong *)service).result];
		return;
	}

	// Unknown or unexpected response
	NSLog(@"Unexpected response from web service: %@", service.class.description);
}

@end
