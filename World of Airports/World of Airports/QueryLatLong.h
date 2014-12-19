//
//  QueryLatLong.h
//  World of Airports
//
//  Created by Eric Ruck on 12/18/14.
//  Copyright 2014 NearChaos. All Rights Reserved.
//

#import "WebService.h"
#import <CoreLocation/CoreLocation.h>

/**
 * Defines query area.
 */
typedef struct {
	CLLocationCoordinate2D start;
	CLLocationCoordinate2D end;
} QueryArea;


/**
 * Queries the web service for locations inside a rectangle.
 * @author Eric Ruck
 */
@interface QueryLatLong : WebService {
	NSArray *locations;
}

/**
 * Queries for the passed area.  Longitude is along the X axis, latitude along
 * the Y axis.
 * @param area   Area embedded in rectangle
 * @param client Results delegate
 * @return New query for area
 */
+(QueryLatLong *)queryArea:(QueryArea *)area for:(id<WebServiceDelegate>)client;

/**
 * Queries for the passed area.  Longitude is along the X axis, latitude along
 * the Y axis.
 * @param area   Area embedded in rectangle
 * @param client Results delegate
 * @return Self reference
 */
-(id)initQueryArea:(QueryArea *)area for:(id<WebServiceDelegate>)client;

/**
 * Returns the location results.
 * @return Array of Location*, or nil if not available
 */
-(NSArray *)result;

@end
