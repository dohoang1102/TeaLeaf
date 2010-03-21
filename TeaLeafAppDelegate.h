//
//  TeaLeafAppDelegate.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 10/01/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BWToolkitFramework/BWToolkitFramework.h>
@class ManagingServiceConfigController;


@interface TeaLeafAppDelegate : NSObject <NSApplicationDelegate> {

	// main window controls
    NSWindow	*window;
	NSBox		*viewBox;
	NSTableView *servicesTable;
	BWAnchoredButton *removeButton;
	
	NSButton	*daemonStartButton;
	NSButton	*revertButton;
	NSButton	*saveButton;
	
	// config view sheet and controls
	NSWindow		*newConfigViewSheet;
	NSPopUpButton	*serviceTypePopup;
	NSTextField		*serviceNameField;
	
	// controllers
	//NSArrayController *arrayController;
	
	// configuration data etc
	NSArray			*serviceTypes;			// loaded from plist
	NSMutableArray	*serviceConfigControllers;
//	NSArray			*messagingConfig;	
//	ManagingServiceConfigController *currentConfigController;  // just point to the currently selected in the array
	
	
}

-(IBAction)addView:(id)sender;
-(IBAction)removeView:(id)sender;
-(IBAction)stopSheet:(NSButton *)whichButton;


-(IBAction)apply:(NSButton *)sender;
-(IBAction)revert:(NSButton *)sender;

-(IBAction)close:(NSButton *)sender;



@property (assign) IBOutlet NSWindow		*window;
@property (assign) IBOutlet NSBox			*viewBox;
@property (assign) IBOutlet BWAnchoredButton *removeButton;
@property (assign) IBOutlet NSButton		*daemonStartButton;
@property (assign) IBOutlet NSWindow		*newConfigViewSheet;
@property (assign) IBOutlet NSPopUpButton	*serviceTypePopup;
@property (assign) IBOutlet NSTextField		*serviceNameField;
@property (assign) IBOutlet NSTableView		*servicesTable;

//@property (assign) IBOutlet NSArrayController *arrayController;

@property (copy, nonatomic) NSArray			*serviceTypes;
@property (retain, nonatomic) NSMutableArray  *serviceConfigControllers;  // cannot use copy on mutable object
//@property (copy, nonatomic) NSArray		    *messagingConfig;	
//@property (assign, nonatomic) ManagingServiceConfigController *currentConfigController;


@end