//
//  krielAppDelegate.m
//  kriel
//
//  Created by Hyoun Woo Kim on 09. 06. 17.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "krielAppDelegate.h"

@implementation krielAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window setUserInteractionEnabled:YES];
	[window setMultipleTouchEnabled:YES];
	[[Director sharedDirector] setLandscape:YES];
	[[Director sharedDirector] attachInWindow:window];
	
	[window makeKeyAndVisible];
	
	MenuScene* ms = [MenuScene node];
	
	[[Director sharedDirector] runWithScene:ms];
}

@end
