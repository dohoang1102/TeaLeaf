//
//  TestFileMessagingService.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 01/05/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "TestFileMessagingService.h"
#import "FileMessagingService.h"
#import "NSString+UUID.h"
#import "Globals.h"

@implementation TestFileMessagingService



- (void) setUp
{
	config = [[NSDictionary alloc ] initWithObjectsAndKeys:
						@"/Users/rbt/Development/TeaLeafTesting/read", 
						directoryToReadFromKey, 
						@"/Users/rbt/Development/TeaLeafTesting/send",
						directoryToSendToKey,
						@"test file service",
						serviceNameKey,
						@"File",
						serviceTypeKey,
						nil];
						
    ms = [[FileMessagingService alloc] initWithDelegate:self config:config];
	
}

- (void) tearDown
{
    
	[ms release];
	[config release];
}




-(void)testServiceName
{
	STAssertEqualObjects(@"test file service", ms.serviceName, @"serviceName should be %@ but is in fact %@", 
						 @"test file service",ms.serviceName);
}

-(void)testServiceType
{
	STAssertEqualObjects(@"File", ms.serviceType, @"serviceName should be %@ but is in fact %@",
						 @"File", ms.serviceType);
}

-(void)testServiceDirectoryToReadFrom
{
	STAssertEqualObjects(@"/Users/rbt/Development/TeaLeafTesting/read", ms.directoryToReadFrom, 
						 @"directoryToReadFrom should be %@ but is in fact %@",
						 @"/Users/rbt/Development/TeaLeafTesting/read", ms.directoryToReadFrom);
}

-(void)testServiceDirectoryToSendTo
{
	STAssertEqualObjects(@"/Users/rbt/Development/TeaLeafTesting/send", ms.directoryToSendTo, 
						 @"directoryToSendTo should be %@ but is in fact %@",
						 @"/Users/rbt/Development/TeaLeafTesting/send", ms.directoryToSendTo);
}

-(void)testSendTextMessagePassed
{
	NSString *requestID = [ms sendTextMessage:@"This is a test message"];
	STAssertEqualObjects (requestID, successRequestID, 
						  @"msg send failed when should have passed: requestID: %@, successRequestID: %@",
						  requestID, successRequestID);
	[successRequestID release];
}

-(void)testSendTextMessageFailed
{
	// ensure the write fails
	[ms release];
	[config release];
	config = [[NSDictionary alloc ] initWithObjectsAndKeys:
			  @"/Users/rbt/Development/TeaLeafTesting/read", 
			  directoryToReadFromKey, 
			  @"/wibble/wobble",
			  directoryToSendToKey,
			  @"test file service",
			  serviceNameKey,
			  @"File",
			  serviceTypeKey,
			  nil];
	ms = [[FileMessagingService alloc] initWithDelegate:self config:config];
	
	NSString *requestID = [ms sendTextMessage:@"This is a test message"];
	STAssertEqualObjects (requestID, failureRequestID, 
						  @"message send should have failed: requestID: %@, successRequestID: %@",
						  requestID, failureRequestID);
	[failureRequestID release];
}

//-(void)testServiceTypeInPlist
//{
//
//}


// delegate methods

-(void)messageSendSucceeded:(NSString *)requestIdentifier
{
	NSLog (@"messageSendSucceeded");
	successRequestID = [requestIdentifier retain];
}

-(void)messageSendFailed:(NSString *)requestIdentifier withError:(NSError *)error
{
	NSLog (@"messageSendFailed");
	failureRequestID = [requestIdentifier retain];
	// We should get a code 4 error here
	NSLog(@"error code: %qi", [error code]);
	STAssertTrue(4 == [error code], @"we should have got an error 4 code here, but we got:%qi", [error code]);
}

-(void)receivedMessage:(NSString *)message fromServiceInstanceNamed:(NSString *)serviceInstanceName
{
}



@end
