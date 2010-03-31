//
//  ServiceConfigController.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 19/03/2010.
//  Copyright 2010 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "ServiceConfigController.h"

static NSString * const serviceNameKey = @"serviceName"; 
static NSString * const serviceTypeKey = @"serviceType"; 

@implementation ServiceConfigController

@synthesize configDictionary;
@dynamic	serviceName, serviceType;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (![super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
		return nil;
	
	self.configDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
	
	return self;
}

-(id)init
{
	NSLog(@"init needs to be overidden in a subclass. return nil");
	return nil;
}

-(void)dealloc
{
	self.configDictionary = nil;
	[super dealloc];
}

-(void)setServiceName:(NSString *)aServiceName
{
	NSLog(@"setting service name to %@", aServiceName);	
	if ([aServiceName isEqual:nil]) {
		[self.configDictionary setNilValueForKey:serviceNameKey];
	}
	else {
		[self.configDictionary setObject:aServiceName forKey:serviceNameKey];
	}
}

-(NSString*)serviceName
{

	return [[[self.configDictionary objectForKey:serviceNameKey] retain ] autorelease];
}
	
-(void)setServiceType:(NSString *)aServiceType
{
	NSLog(@"setting service type to %@", aServiceType);	
	if ([aServiceType isEqual:nil]) {
		[self.configDictionary setNilValueForKey:serviceTypeKey];
	}
	else {
		[self.configDictionary setObject:aServiceType forKey:serviceTypeKey];
	}
}

-(NSString*)serviceType
{
	
	return [[[self.configDictionary objectForKey:serviceTypeKey] retain ] autorelease];
}

@end
