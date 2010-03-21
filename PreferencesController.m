//
//  PreferencesController.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 21/03/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "PreferencesController.h"


@implementation PreferencesController

@synthesize preferencesDictionary;

-(id)init
{
	if (![super initWithWindowNibName:@"Preferences"])
		return nil;
	
	self.preferencesDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
	return self;
}

-(void)dealloc
{
	self.preferencesDictionary = nil;
	[super dealloc];
}

@end
