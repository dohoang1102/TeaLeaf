//
//  MainController.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 01/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MessagingServicesManager.h"


@interface MainController : NSObject <MessagingServiceDelegateProtocol> {
	
	MessagingServicesManager	*msm;
	NSMutableArray				*config;
	NSString					*inboundMessageText;

}
-(void)run;

@end
