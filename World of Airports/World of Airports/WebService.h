//
//  WebService.h
//  World of Airports
//
//  Created by Eric Ruck on 12/16/14.
//  Copyright 2014 NearChaos. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceDelegate.h"


/**
 * Provides a simple generic web service client.
 * @author Eric Ruck
 */
@interface WebService : NSObject
		<NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
	/** Delegate receives service results. */
	id<WebServiceDelegate> __weak delegate;

	/** Query parameters to add to web service URL. */
	NSMutableDictionary *params;

	/** Connection to the web service. */
	NSURLConnection *connection;

	/** Caches data response from web service. */
	NSMutableData *receivedData;
}


/**
 * Initializes to access a web service endpoint.
 * @param  initDelegate Delegate receives results
 * @return Self reference
 */
-(id)initForDelegate:(id<WebServiceDelegate>)initDelegate;

/**
 * Gets the base URL of our web services.  Child classes can override
 * to access a different server.
 * @return Base service URL
 */
-(NSString *)baseService;

/**
 * Gets the web service endpoint relative to the base URL.
 * Child classes can override to target a different endpoint.
 * @return Endpoint fragment
 */
-(NSString *)endpoint;

/**
 * Gets the URL to access the service.
 * @return Service URL
 */
-(NSURL *)serviceURL;

/**
 * Adds a parameter to the web service query.
 * @param value Parameter value
 * @param name  Parameter name
 */
-(void)addParam:(NSString *)value named:(NSString *)name;

/**
 * Executes our web service.
 * <p>
 * TODO: Replace result with NSError if we are to expose as production client interface.
 *
 * @return Error message on failure to execute, else nil
 */
-(NSString *)execute;

/**
 * Processes the JSON results before the client delegate is called on success.
 * @param json JSON parsed from response
 * @return Error message or nil on success
 */
-(NSString *)processJson:(NSDictionary *)json;

/**
 * Cancels the transaction in progress.
 */
-(void)cancel;

@end
