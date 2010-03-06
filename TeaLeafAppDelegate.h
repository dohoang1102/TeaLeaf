//
//  TeaLeafAppDelegate.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 10/01/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class ConfigurationFileManager;

@interface TeaLeafAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	
	NSTextField	*twitterUsernameField;
	NSTextField	*twitterPasswordField;
	NSTextField	*directMessageKeywordField;
	NSTextField *timeIntervalToCheckField;
	NSButton	*isStolenCheckBox;
	
	ConfigurationFileManager *configurationFileManager;
	
}

-(IBAction)save:(NSButton *)sender;

@property (assign) IBOutlet NSWindow		*window;
@property (assign) IBOutlet NSTextField		*twitterUsernameField;
@property (assign) IBOutlet NSTextField		*twitterPasswordField;
@property (assign) IBOutlet NSTextField		*directMessageKeywordField;
@property (assign) IBOutlet NSTextField		*timeIntervalToCheckField;
@property (assign) IBOutlet NSButton		*isStolenCheckBox;



@property (readwrite, nonatomic, retain) ConfigurationFileManager *configurationFileManager;

@end