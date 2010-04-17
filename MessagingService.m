//
//  MessagingService.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 31/03/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "MessagingService.h"
#import	"Globals.h"


@implementation MessagingService
@synthesize configDictionary;
@dynamic serviceName, serviceType;


-(NSString*)serviceName
{
	
	return [[[self.configDictionary objectForKey:serviceNameKey] retain ] autorelease];
}


-(NSString*)serviceType
{
	
	return [[[self.configDictionary objectForKey:serviceTypeKey] retain ] autorelease];
}

-(id)initWithConfig:(NSDictionary *)theConfigDctionary;
{
	if (self = [super init]) {
		self.configDictionary = theConfigDctionary;
		NSLog (@"created service:%@", [self.configDictionary valueForKey:serviceNameKey]);
	}
	
	return self;
}

-(void)dealloc
{
	self.configDictionary = nil;
	[super dealloc];
}

@end
