//
//  main.m
//  Hello
//
//  Created by 현우 김 on 09. 10. 02.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	int retVal = UIApplicationMain(argc, argv, nil, @"HelloAppDelegate");
	[pool release];
	return retVal;
}
