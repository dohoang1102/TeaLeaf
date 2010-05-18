//
//  MainController.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 01/04/2010.
//  Copyright 2010 Swandrift Consulting Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyLocationManagerDelegateProtocol.h"
#import "MessagingServiceDelegateProtocol.h"

@class MyLocationManager;
@class MessagingServicesManager;

@interface MainController : NSObject <MessagingServiceDelegateProtocol, MyLocationManagerDelegateProtocol> {
	
	MessagingServicesManager	*msm;
	NSMutableDictionary			*state;
	MyLocationManager			*locationManager;

}
@property (readwrite, nonatomic, assign) BOOL isStolen;
@property (readwrite, nonatomic, assign) BOOL logLocation;
@property (readwrite, nonatomic, assign) BOOL takePictures;
@property (readonly,  nonatomic) NSString *password;


-(void)run;

@end
