//
//  MessagingServicesManager.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 31/03/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MessagingService;


@interface MessagingServicesManager : NSObject {
	
	NSMutableArray	*messagingServices;
	id				delegate;

}

@property (assign, nonatomic, readwrite) id delegate;


-(id)initWithDelegate:(id)delegate;
-(void)startListeningOnServiceInstance:(MessagingService *)messagingService



@end
