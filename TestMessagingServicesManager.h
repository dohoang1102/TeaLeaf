//
//  TestMessagingServicesManager.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 02/05/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Globals.h"
#import "MessagingServiceDelegateProtocol.h"
@class MessagingServicesManager;


@interface TestMessagingServicesManager : SenTestCase <MessagingServiceDelegateProtocol> {
	
	MessagingServicesManager	*msMgr;
	NSMutableArray				*config;
	NSMutableArray				*successRequestIDs;
	NSArray						*failureRequestIDs;
	NSMutableArray				*inboundMessages;
	
}

@end
