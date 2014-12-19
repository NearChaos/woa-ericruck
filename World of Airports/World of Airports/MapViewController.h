//
//  MapViewController.h
//  World of Airports
//
//  Created by Eric Ruck on 12/16/14.
//  Copyright 2014 NearChaos. All Rights Reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

// Forward references
@protocol WebServiceDelegate;
@class QueryLatLong;


/**
 * Controls our main map view.
 * @author Eric Ruck
 */
@interface MapViewController : UIViewController
		<MKMapViewDelegate, WebServiceDelegate> {
	/** Current query or nil if none. */
	QueryLatLong *currentQuery;
}

/** Binds the map view. */
@property IBOutlet MKMapView *map;

/** Binds to the waiting view. */
@property IBOutlet UIView *waiting;

@end
