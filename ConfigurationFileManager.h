//
//  ConfigurationFileManager.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 10/01/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ConfigurationFileManager : NSObject {
	
	NSString	*twitterUsername;
	NSString	*twitterPassword;
	NSString	*directMessageKeyword;
	int			timeIntervalToCheck;
	BOOL		isStolen;

}

@property	(readwrite, copy, nonatomic)	NSString	*twitterUsername;
@property	(readwrite, copy, nonatomic)	NSString	*twitterPassword;
@property	(readwrite, copy, nonatomic)	NSString	*directMessageKeyword;
@property	(readwrite, assign, nonatomic)	int			timeIntervalToCheck;
@property	(readwrite, assign, nonatomic)	BOOL		isStolen;


-(void)load;
-(void)save;

@end
