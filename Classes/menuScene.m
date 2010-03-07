//
//  MenuScene.m
//  kriel
//
//  Created by Hyoun Woo Kim on 09. 06. 17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"

@implementation MenuScene

-(id) init 
{
	self = [super init];
	if (self != nil)
	{
		Sprite * bg = [Sprite spriteWithFile:@"menu.png"];
		[bg setPosition:ccp(240, 160)];
		[self addChild:bg z:0];
		[self addChild:[MenuLayer node] z:1];
	}
	
	return self;
}

@end

@implementation MenuLayer

-(id) init 
{
    self = [super init];
	if (self != nil)
	{
		[MenuItemFont setFontSize:20];
		[MenuItemFont setFontName:@"helvetica"];
		MenuItem* start = [MenuItemFont itemFromString:@"Start Game" target:self selector:@selector(startGameCallback:)];
		MenuItem* quit = [MenuItemFont itemFromString:@"Quit" target:self selector:@selector(quitCallback:)];
		
		Menu* menu = [Menu menuWithItems:start, quit, nil];
		[menu alignItemsVertically];
		[self addChild:menu];
	}
	
	return self;
}

-(void) startGameCallback: (id)sender
{
    NSLog(@"start game");
	
	GameScene* gs = [GameScene node];
	[[Director sharedDirector] replaceScene:gs];
}

-(void) quitCallback: (id)sender
{
	NSLog(@"quit");
	
	[[Director sharedDirector] end];
	if ([[UIApplication sharedApplication] respondsToSelector:@selector(terminate)])
		[[UIApplication sharedApplication] performSelector:@selector(terminate)];
}
@end

