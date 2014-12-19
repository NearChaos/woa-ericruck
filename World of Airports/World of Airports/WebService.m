//
//  WebService.m
//  World of Airports
//
//  Created by Eric Ruck on 12/16/14.
//  Copyright 2014 NearChaos. All Rights Reserved.
//

#import "WebService.h"
#import "WebServiceDelegate.h"


@interface WebService (Private)
-(void)resetConnection;
+(NSString *)urlencode:(NSString *)input;
@end


@implementation WebService

-(id)initForDelegate:(id<WebServiceDelegate>)initDelegate {
	// Default init
	self = [super init];
	if (self) {
		// Keep the delegate
		self->delegate = initDelegate;
	}

	// Return self reference
	return self;
}


-(NSString *)baseService {
	return @"https://mikerhodes.cloudant.com/airportdb/";
}


-(NSString *)endpoint {
	return @"_all_docs";
}


-(NSURL *)serviceURL {
	NSString *url = [self.baseService stringByAppendingPathComponent:self.endpoint];
	if (self->params) {
		NSString *sep = @"?";
		for (NSString *currentName in self->params.allKeys) {
			// Add the current parameter
			NSString *encodedValue = [[self->params valueForKey:currentName]
					stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			url = [url stringByAppendingFormat:@"%@%@=%@", sep, currentName, encodedValue];
			sep = @"&";
		}
	}
	return [NSURL URLWithString:url];
}


-(void)addParam:(NSString *)value named:(NSString *)name {
	if (self->params) {
		[self->params setValue:value forKey:name];
	} else {
		self->params = [NSMutableDictionary dictionaryWithObject:value forKey:name];
	}
}


-(NSString *)execute {
	// Make sure we're not already executing
	if (self->connection) {
		// Already executing
		return @"A web service request is already in progress.";
	}

	// Make sure we have Internet access
	// TODO: On the one hand Apple requires production code to test Internet availability,
	//   and update the user interface reasonably.  However, since this is demo code, we're
	//   going to skip for now.  Also since this could be precursor to a static library API
	//   we should probably push this responsibility to the client application.  Probably
	//   include this in an integration doc.
//	if (!AppDelegate.getReachable) {
//		// Unable to access the Internet
//		return @"Unable to access the Internet, please make sure you have a wireless connection.";
//	}

	// Prepare the service URL
	NSURL *url = self.serviceURL;

	// Prepare the service request
	NSMutableURLRequest *request =
		[NSMutableURLRequest requestWithURL:url];
	request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
	connection = [NSURLConnection connectionWithRequest:request delegate:self];
	if (!connection) {
		// Failed to create connection
		return @"Failed to create web service connection.";
	}

	// Connection is executing
	return nil;
}


-(void)cancel {
	[self->connection cancel];
}


-(void)resetConnection {
	self->connection = nil;
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	// Report failure to our delegate
	[self->delegate webService:self didFailWithMessage:error.localizedDescription];
	[self resetConnection];
}


-(void)connection:(NSURLConnection *)connection
		didReceiveResponse:(NSURLResponse *)response {
	if (!self->receivedData) {
		// Initialize
		self->receivedData = NSMutableData.new;
	} else {
		// Always reset here in case of redirect or similar
		[self->receivedData setLength:0];
	}
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	// Keep the data
	[self->receivedData appendData:data];
}


-(NSString *)processJson:(NSDictionary *)json {
	// Default does nothing
	return nil;
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
	// Trivial data check
	NSDictionary *json = nil;
	NSString *failMsg = nil;
	if (!self->receivedData || !self->receivedData.length) {
		// No data received, or the service was not executed
		failMsg = [NSMutableString stringWithString:@"Failed to parse empty service results"];
	} else {
		// Parse the data
		NSError *error;
		json = [NSJSONSerialization JSONObjectWithData:self->receivedData options:0 error:&error];
		if (!json) {
			// Failed to parse the data
			failMsg = [NSMutableString stringWithFormat:@"Failed to parse service result"];
			if (error && error.localizedDescription) {
				// Show details
				failMsg = [failMsg stringByAppendingFormat:@": %@", error.localizedDescription];
			}
		} else if (![json isKindOfClass:[NSDictionary class]]) {
			// Invalid JSON
			failMsg = [NSMutableString stringWithFormat:
					@"Unexpected root type %@ parsing service result",
					json.class.description];
		}
	}
	if (!failMsg) {
		// Allow the subclass a chance to process the results
		failMsg = [self processJson:json];
	}
	if (failMsg) {
		// Respond with failure
		[self->delegate webService:self didFailWithMessage:failMsg];
	} else {
		// Respond with success
		[self->delegate webService:self completedResult:json];
	}

	// Cleanup
	[self resetConnection];
}

@end
