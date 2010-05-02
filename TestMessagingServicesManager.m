//
//  TestMessagingServicesManager.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 02/05/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "TestMessagingServicesManager.h"
#import "MessagingServicesManager.h"



@implementation TestMessagingServicesManager

- (void)setUp
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
	
	
    msMgr = [[MessagingServicesManager alloc] initWithDelegate:self configArray:config];
	
		
	successRequestIDs = [[NSMutableArray alloc] initWithCapacity:2];
	
}

- (void) tearDown
{
    
	[msMgr release];
	[config release];
	[successRequestIDs release];
	[failureRequestIDs release];
}

-(void)testSendTextMessageSuccess
{
	// send a text message to each

	NSArray *requestIDs = [msMgr sendTextMessage:@"This is a test message"];
	
	
	for (int i; i<2; i++) {
		
		STAssertEqualObjects ([requestIDs objectAtIndex:i], 
							  [successRequestIDs objectAtIndex:i],
							  @":Success requestID at index %d should be %@ but is in fact %@",
							  i,
							  [requestIDs objectAtIndex:i],
							  [successRequestIDs objectAtIndex:i]);
	}
							
							  
}

-(void)testSendTextMessageFailFile
{
	[msMgr release];
	[config removeAllObjects];
	
	// just 1 config now
	
	NSDictionary *d = [[NSDictionary alloc ] initWithObjectsAndKeys:
					   @"/Users/rbt/Development/TeaLeafTesting/read-1", 
					   directoryToReadFromKey, 
					   @"/wibble/wobble/",
					   directoryToSendToKey,
					   @"Service 1 (File)",
					   serviceNameKey,
					   @"File",
					   serviceTypeKey,
					   nil];
	
	[config addObject:d];
	[d release];
	
	msMgr = [[MessagingServicesManager alloc] initWithDelegate:self configArray:config];
	
	NSArray *requestIDs = [msMgr sendTextMessage:@"This is a test message"];
	
	STAssertEqualObjects ([requestIDs objectAtIndex:0], 
						  [failureRequestIDs objectAtIndex:0],
						  @"failure requestID should be %@ but is in fact %@",
						  [requestIDs objectAtIndex:0],
						  [failureRequestIDs objectAtIndex:0]);
	

}


-(void)testSendTextMessageUsingServiceInstanceSuccess
{
	
	NSString *requestID = [msMgr sendTextMessage:@"This is a test message" usingMessagingServiceNamed:@"Service 2 (File)"];
	

	STAssertEqualObjects (requestID, 
						  [successRequestIDs objectAtIndex:0],
						  @":Success requestID at should be %@ but is in fact %@",
						  requestID,
						  [successRequestIDs objectAtIndex:0]);
	
	
}

-(void)testSendTextMessageUsingServiceInstanceFailureFile
{
	[msMgr release];
	[config removeAllObjects];
	
	// just 1 config now
	
	NSDictionary *d = [[NSDictionary alloc ] initWithObjectsAndKeys:
					   @"/Users/rbt/Development/TeaLeafTesting/read-1", 
					   directoryToReadFromKey, 
					   @"/wibble/wobble/",
					   directoryToSendToKey,
					   @"Service 1 (File)",
					   serviceNameKey,
					   @"File",
					   serviceTypeKey,
					   nil];
	
	[config addObject:d];
	[d release];
	
	msMgr = [[MessagingServicesManager alloc] initWithDelegate:self configArray:config];
	
	NSString *requestID = [msMgr sendTextMessage:@"This is a test message" usingMessagingServiceNamed:@"Service 1 (File)"];
	
	STAssertEqualObjects (requestID, 
						  [failureRequestIDs objectAtIndex:0],
						  @"failure requestID should be %@ but is in fact %@",
						  requestID,
						  [failureRequestIDs objectAtIndex:0]);
	
}

-(void)createMessageFiles
{

	NSString *fileContents = [NSString stringWithString:@"The quick brown fox jumps over the lazy dog"];
	
	// step over each fms in the array in msmgr
		
	for (NSDictionary *d in config)
	{
		NSString *fullPath = [[d valueForKey:directoryToReadFromKey] stringByAppendingPathComponent:@"test.txt"];
	
		[fileContents writeToFile:fullPath atomically:YES encoding:NSASCIIStringEncoding error:NULL];
	}
	NSLog(@"files created");
}


-(void)testReceivedMessagesFromFile
{

	// install timer
	NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:2
												  target:self 
												selector:@selector(createMessageFiles) 
												userInfo:nil 
												 repeats:NO];
	
	inboundMessages = [[NSMutableArray alloc] initWithCapacity:2];

	[[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
		
	// set up runloop to last for 10 seconds.
	CFRunLoopRunInMode(kCFRunLoopDefaultMode,10, YES);
	
	for (NSString *s in inboundMessages)
	{
		STAssertEqualObjects (@"The quick brown fox jumps over the lazy dog", s, 
							  @"inbound message text should have been:%@, but was actually:%@",
							  @"The quick brown fox jumps over the lazy dog", 
							  s);
	}
	
	
}





// delegate methods

-(void)messageSendSucceeded:(NSString *)requestIdentifier
{
	NSLog (@"messageSendSucceeded");
	[successRequestIDs addObject:requestIdentifier];
}

-(void)messageSendFailed:(NSString *)requestIdentifier withError:(NSError *)error
{
	NSLog (@"messageSendFailed");
	failureRequestIDs =  [[NSArray arrayWithObject:requestIdentifier] retain];
	
	// We should get a code 4 error here
	NSLog(@"error code: %qi", [error code]);
	STAssertTrue(4 == [error code], @"we should have got an error 4 code here, but we got:%qi", [error code]);
}

-(void)receivedMessage:(NSString *)message fromServiceInstanceNamed:(NSString *)serviceInstanceName
{

	NSLog(@"adding message:%@",message);
	[inboundMessages addObject:message];
	
	
}


@end
