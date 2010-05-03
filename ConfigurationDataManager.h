//
//  ConfigurationDataManager.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 03/05/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//
// This class simply reads and writes data to the configuration files (for the services) and the daemon preferences

@interface ConfigurationDataManager : NSObject {

}

+(NSMutableDictionary *)readPreferences;
+(NSMutableArray *)readMessagingConfig;

+(BOOL)writePreferences:(NSDictionary *)preferencesDictionary;
+(BOOL)writeMessagingConfig:(NSArray *)configArray;






@end
