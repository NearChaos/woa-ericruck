//
//  WebServiceDelegate.h
//  World of Airports
//
//  Created by Eric Ruck on 12/16/14.
//  Copyright 2014 NearChaos. All Rights Reserved.
//

// Forward class references
@class WebService;


/**
 * Handles the result from the web service client.
 * @author Eric Ruck
 */
@protocol WebServiceDelegate <NSObject>

/**
 * Handles failure from web service response.
 * <p>
 * Went with errorMessage for simplicity, in a more general API I would use
 * NSError*.
 *
 * @param service Failed service
 * @param errorMessage Message that describes the error
 */
@required
-(void)webService:(WebService *)service didFailWithMessage:(NSString *)errorMessage;

/**
 * Reports the complete receipt of the response from the web service.
 * @param service Completed service
 * @param result  Response from the service
 */
@required
-(void)webService:(WebService *)service completedResult:(NSDictionary *)result;

@end
