//
//  PreferencesController.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 21/03/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PreferencesController : NSWindowController {
	
	NSMutableDictionary *preferencesDictionary;

}

@property (retain, nonatomic) NSMutableDictionary *preferencesDictionary;

@end
