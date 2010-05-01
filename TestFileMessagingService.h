//
//  TestFileMessagingService.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 01/05/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Globals.h"
#import "MessagingServiceDelegateProtocol.h"
@class FileMessagingService;



@interface TestFileMessagingService  :   SenTestCase <MessagingServiceDelegateProtocol> {

	NSDictionary			*config;
	FileMessagingService	*ms;
	NSString				*successRequestID;
	NSString				*failureRequestID;
	
}

@end
