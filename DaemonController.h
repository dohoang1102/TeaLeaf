//
//  DaemonController.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 10/01/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGTwitterEngineDelegate.h"

@class MGTwitterEngine;
@class ConfigurationFileManager;

@interface DaemonController : NSObject <MGTwitterEngineDelegate> {
	
	NSTimer						*checkForTwitterDirectMessagesTimer;
	NSTimer						*stolenModeTimer;	
	BOOL						runLoopShouldRun;
	MGTwitterEngine				*twitter;
	ConfigurationFileManager	*configuration;
	
	
}

-(void)configure;
-(void)run;

@end
