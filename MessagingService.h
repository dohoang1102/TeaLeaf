//
//  MessagingService.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 31/03/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//
// Base class for each messaging service (twitter, web, etc)
//

@interface MessagingService : NSObject {
	
	NSDictionary *configDictionary;

}
	
@property (copy, nonatomic)		NSDictionary		*configDictionary;
@property (readonly, nonatomic)	NSString			*serviceName;
@property (readonly, nonatomic)	NSString			*serviceType;

@end
