//
//  ServiceConfigController.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 19/03/2010.
//  Copyright 2010 2010 Swandrift Consulting Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ServiceConfigController : NSViewController {

	NSMutableDictionary *configDictionary;
	NSTextField			*readDirectoryTextField;
	NSTextField			*sendDirectoryTextField;
	NSObjectController  *objectController;
}

@property (retain, nonatomic) NSMutableDictionary *configDictionary;

@property (retain, nonatomic)	NSString	*serviceName;
@property (retain, nonatomic)	NSString	*serviceType;

@property (assign, nonatomic) IBOutlet		NSTextField	*readDirectoryTextField;
@property (assign, nonatomic) IBOutlet		NSTextField	*sendDirectoryTextField;
@property (assign, nonatomic) IBOutlet		NSObjectController  *objectController;

-(IBAction)chooseDirectory:(NSButton *)sender;

@end
