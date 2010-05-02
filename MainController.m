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
		config = [[NSMutableArray alloc] initWithCapacity:2];
		
		NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:
						   @"/Users/rbt/Development/TeaLeafTesting/read-1", 
						   directoryToReadFromKey, 
						   @"/Users/rbt/Development/TeaLeafTesting/send-1",
						   directoryToSendToKey,
						   @"Service 1 (File)",
						   serviceNameKey,
						   @"File",
						   serviceTypeKey,
						   nil];
		
		[config addObject:d];
		
		
		d = [NSDictionary dictionaryWithObjectsAndKeys:
			 @"/Users/rbt/Development/TeaLeafTesting/read-2", 
			 directoryToReadFromKey, 
			 @"/Users/rbt/Development/TeaLeafTesting/send-2",
			 directoryToSendToKey,
			 @"Service 2 (File)",
			 serviceNameKey,
			 @"File",
			 serviceTypeKey,
			 nil];
		
		[config addObject:d];

		
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




// delegate methods:
// delegate methods

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
