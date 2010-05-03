//
//  MainController.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 01/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainController.h"
#import "Globals.h"


@implementation MainController

-(id)init
{
	if (self = [super init])
	{
		// read in configuration
		
		// instantiate MSM
		
		// 
		
		
		
		msm = [[MessagingServicesManager alloc] initWithDelegate:self configArray:config];
		
		
				
	}
	return self;
}

-(void)dealloc
{
	[msm release];
	[config release];
	
	[super dealloc];
}


-(void)run
{
	
	BOOL runLoopShouldRun = YES;
		
	// runloop
	do
    {
        // Start the run loop but return after each source is handled.
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, YES);
		
		//NSLog(@"RunLoop Result: %d",result);
		
    }
    while (runLoopShouldRun);
	

	
}



//
// delegate methods:
//
-(void)messageSendSucceeded:(NSString *)requestIdentifier
{
//	NSLog (@"messageSendSucceeded");
//	successRequestID = [requestIdentifier retain];
}

-(void)messageSendFailed:(NSString *)requestIdentifier withError:(NSError *)error
{
//	NSLog (@"messageSendFailed");
//	failureRequestID = [requestIdentifier retain];
//	// We should get a code 4 error here
//	NSLog(@"error code: %qi", [error code]);
//	STAssertTrue(4 == [error code], @"we should have got an error 4 code here, but we got:%qi", [error code]);
}

-(void)receivedMessage:(NSString *)message fromServiceInstanceNamed:(NSString *)serviceInstanceName
{
	NSLog(@"received message:%@ from service instance %@", message, serviceInstanceName);
	

	
}






@end
