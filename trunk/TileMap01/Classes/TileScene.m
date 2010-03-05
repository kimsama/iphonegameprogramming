//
//  TileScene.m
//  Tilemap01
//
//  Created by 현우 김 on 09. 10. 03.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TileScene.h"


@implementation TileScene

@synthesize gameLayer;


-(id) init
{
	self = [super init];
	
	if (self)
	{
		GameLayer *layer = [[GameLayer alloc] init];
		self.gameLayer = layer;
		[layer release];
		
		TileMapTest *tileMapTestLayer = [[TileMapTest alloc] init];
		
		//[self addChild:gameLayer];
		[self addChild:tileMapTestLayer];

		//[gameLayer loadLevel:1];
	}
	
	return self;
}

- (void) dealloc
{
	[gameLayer release];

	[super dealloc];
}

@end
