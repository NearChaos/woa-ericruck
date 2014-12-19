//
//  QueryLatLong.m
//  World of Airports
//
//  Created by Eric Ruck on 12/18/14.
//  Copyright 2014 NearChaos. All Rights Reserved.
//

#import "QueryLatLong.h"
#import "Location.h"


@interface QueryLatLong (Private)
@end


@implementation QueryLatLong

+(QueryLatLong *)queryArea:(QueryArea *)area for:(id<WebServiceDelegate>)client {
	return [[QueryLatLong alloc] initQueryArea:area for:client];
}


-(id)initQueryArea:(QueryArea *)area for:(id<WebServiceDelegate>)client {
	// Initialize base first
	self = [super initForDelegate:client];
	if (self) {
		// Add query parameters
		NSString *query = [NSString stringWithFormat:@"lon:[%f TO %f] AND lat:[%f TO %f]",
			area->start.longitude, area->end.longitude, area->start.latitude, area->end.latitude];
		[self addParam:query named:@"q"];

		// Initialize remaining fields
		self->locations = nil;
	}

	// Return self reference
	return self;
}


-(NSString *)endpoint {
	return @"_design/view1/_search/geo";
}


-(NSString *)processJson:(NSDictionary *)json {
	// Get the rows from the response
	NSArray *rows = [json objectForKey:@"rows"];
	if (!rows || ![rows isKindOfClass:[NSArray class]]) {
		// Invalid response
		return @"Invalid rows response";
	}

	// Parse the rows
	int rowIndex = -1;
	NSMutableArray *results = NSMutableArray.new;
	for (NSDictionary *row in rows) {
		// Get the value from the current row
		++rowIndex;
		if (![row isKindOfClass:[NSDictionary class]]) {
			// Invalid row
			NSLog(@"Invalid row type at %d", rowIndex);
			continue;
		}
		NSDictionary *fields = [row objectForKey:@"fields"];
		if (![fields isKindOfClass:[NSDictionary class]]) {
			// Invalid row fields
			NSLog(@"Invalid fields type at %d", rowIndex);
			continue;
		}
		NSNumber *latitude  = [fields objectForKey:@"lat"];
		NSNumber *longitude = [fields objectForKey:@"lon"];
		NSString *name      = [fields objectForKey:@"name"];
		if (!latitude  || ![latitude  isKindOfClass:[NSNumber class]] ||
		    !longitude || ![longitude isKindOfClass:[NSNumber class]] ||
			!name      || ![name      isKindOfClass:[NSString class]]) {
			// Invalid field(s)
			NSLog(@"One or more invalid fields at row %d", rowIndex);
			continue;
		}

		// Add the row to the results
		[results addObject:
			[Location locationWithLat:latitude.doubleValue byLong:longitude.doubleValue named:name]];
	}

	// If we get here we're successful
	self->locations = results;
	return nil;
}


-(NSArray *)result {
	return self->locations;
}

@end
