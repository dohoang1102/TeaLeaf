//
//  MyLocationManager.h
//  CoreLocTest
//
//  Created by Richard Turnbull on 18/12/2009.
//  Copyright 2009 Swandrift Consulting Limited. All rights reserved.
//
//  Code based from a tutorial by Matt Gellagher - copyright below:
//  ---------------------------------------------------------------------------
//  Created by Matt Gallagher on 2009/12/19.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//


#import <Cocoa/Cocoa.h>
#import <CoreLocation/CoreLocation.h>
#import "MyLocationManagerDelegateProtocol.h"
#define URL_TEMPLATE @"http://maps.google.com/maps?ie=UTF8&ll=%f,%f&spn=%f,%f&t=h&z=32"

//
// returns location changes to delegate as URL's which can be used by Google.
//



@interface MyLocationManager : NSObject <CLLocationManagerDelegate> {
	
	CLLocationManager	*locationManager;
	id	<MyLocationManagerDelegateProtocol>				delegate;

}
@property (readwrite, assign, nonatomic) id <MyLocationManagerDelegateProtocol>	delegate;

-(id)initWithDelegate:(id)theDelegate;


@end
