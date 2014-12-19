//
//  Location.h
//  World of Airports
//
//  Created by Eric Ruck on 12/18/14.
//  Copyright 2014 NearChaos. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


/**
 * Manages one location received from the web service.
 * @author Eric Ruck
 */
@interface Location : NSObject <MKAnnotation>

/** Map location of the airport location. */
@property (readonly) CLLocationCoordinate2D location;

/** Name of the airport location. */
@property (readonly) NSString *name;

/**
 * Creates a new location instance.
 * @param latitude Location latitude
 * @param longitude Location longitude
 * @param name Location name
 * @return New location instance
 */
+(Location *)locationWithLat:(CLLocationDegrees)latitude
		byLong:(CLLocationDegrees)longitude named:(NSString *)name;

/**
 * Initializes with the location fields.
 * @param latitude Location latitude
 * @param longitude Location longitude
 * @param name Location name
 * @return Self reference
 */
-(id)initLat:(CLLocationDegrees)latitude byLong:(CLLocationDegrees)longitude
		named:(NSString *)name;

@end
