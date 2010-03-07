//
//  main.m
//  kriel
//
//  Created by Hyoun Woo Kim on 09. 06. 17.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
	int retVal = UIApplicationMain(argc, argv, nil, @"krielAppDelegate");
    
	[pool release];
    return retVal;
}
