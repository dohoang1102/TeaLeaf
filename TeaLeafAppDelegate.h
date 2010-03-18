//
//  TeaLeafAppDelegate.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 10/01/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BWToolkitFramework/BWToolkitFramework.h>


@interface TeaLeafAppDelegate : NSObject <NSApplicationDelegate> {

	// main window controls
    NSWindow	*window;
	NSBox		*viewBox;
	NSTableView *configViewTable;
	NSButton	*daemonStartButton;
	NSButton	*revertButton;
	NSButton	*saveButton;
	
	// config view sheet and controls
	NSWindow		*newConfigViewSheet;
	NSPopUpButton	*serviceTypePopup;
	NSTextField		*serviceNameField;
	
	// configuration data etc
	NSArray			*serviceTypes;			// loaded from plist
	NSMutableArray	*serviceConfigViews;
	NSArray			*messagingConfig;	
	
	
}

-(IBAction)addView:(id)sender;
-(IBAction)removeView:(id)sender;
-(IBAction)stopSheet:(NSButton *)whichButton;


-(IBAction)apply:(NSButton *)sender;
-(IBAction)revert:(NSButton *)sender;

-(IBAction)close:(NSButton *)sender;



@property (assign) IBOutlet NSWindow		*window;
@property (assign) IBOutlet NSBox			*viewBox;
@property (assign) IBOutlet NSButton		*daemonStartButton;
@property (assign) IBOutlet NSWindow		*newConfigViewSheet;
@property (assign) IBOutlet NSPopUpButton	*serviceTypePopup;
@property (assign) IBOutlet NSTextField		*serviceNameField;

@property (copy, nonatomic) NSArray			*serviceTypes;
@property (copy, nonatomic) NSMutableArray  *serviceConfigViews;
@property (copy, nonatomic) NSArray		    *messagingConfig;	


@end