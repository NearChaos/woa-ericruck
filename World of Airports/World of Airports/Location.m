//
//  Location.m
//  World of Airports
//
//  Created by Eric Ruck on 12/18/14.
//  Copyright 2014 NearChaos. All Rights Reserved.
//

#import "Location.h"


@implementation Location

+(Location *)locationWithLat:(CLLocationDegrees)latitude
		byLong:(CLLocationDegrees)longitude named:(NSString *)name {
	return [[Location alloc] initLat:latitude byLong:longitude named:name];
}


-(id)initLat:(CLLocationDegrees)latitude byLong:(CLLocationDegrees)longitude
		named:(NSString *)name {
	// Initialize parent first
	self = [super init];
	if (self) {
		// Keep the initial values
		self->_location.latitude  = latitude;
		self->_location.longitude = longitude;
		self->_name = name;
	}

	// Return self reference
	return self;
}


-(CLLocationCoordinate2D)coordinate {
	return self.location;
}


-(NSString *)title {
	return self.name;
}

@end
