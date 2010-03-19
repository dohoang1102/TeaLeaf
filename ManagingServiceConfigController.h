//
//  ManagingServiceConfigController.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 19/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ManagingServiceConfigController : NSViewController {

	NSMutableDictionary *configDictionary;
	NSString			*serviceName;

}

@property (copy, nonatomic) NSMutableDictionary *configDictionary;
@property (copy, nonatomic) NSString			*serviceName;



@end
