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
@class PreferencesController;


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
	PreferencesController *preferencesController;
	
	// configuration data etc
	NSArray				*serviceTypes;				// loaded from plist
	NSMutableArray		*serviceConfigControllers;
	NSMutableDictionary *preferencesDictionary; // store the prefs - bound to the equiv. in the prefs Controller.
	
	
}

-(IBAction)addView:(id)sender;
-(IBAction)removeView:(id)sender;
-(IBAction)stopSheet:(NSButton *)whichButton;


-(IBAction)apply:(NSButton *)sender;
-(IBAction)revert:(NSButton *)sender;

-(IBAction)close:(NSButton *)sender;

-(IBAction)showPreferences:(id)sender;



@property (assign, nonatomic) IBOutlet NSWindow		*window;
@property (assign, nonatomic) IBOutlet NSBox			*viewBox;
@property (assign, nonatomic) IBOutlet BWAnchoredButton *removeButton;
@property (assign, nonatomic) IBOutlet NSButton		*daemonStartButton;
@property (assign, nonatomic) IBOutlet NSWindow		*newConfigViewSheet;
@property (assign, nonatomic) IBOutlet NSPopUpButton	*serviceTypePopup;
@property (assign, nonatomic) IBOutlet NSTextField		*serviceNameField;
@property (assign, nonatomic) IBOutlet NSTableView		*servicesTable;

@property (retain, nonatomic) PreferencesController *preferencesController;
	
@property (copy, nonatomic)		NSArray				*serviceTypes;
@property (retain, nonatomic)	NSMutableArray		*serviceConfigControllers;  // cannot use copy on mutable object
@property (retain, nonatomic)	NSMutableDictionary *preferencesDictionary;


@end