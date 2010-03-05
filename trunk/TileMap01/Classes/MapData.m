//
//  MapData.m
//  Tilemap01
//
//  Created by 현우 김 on 09. 10. 03.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MapData.h"


@implementation MapData

@synthesize tileMap;
@synthesize mapWidth, mapHeight;

- (void) dealloc
{
	[tileMap release];
	[super dealloc];
}

- (void) setTileMapAtlas:(TileMapAtlas *) map
{
	self.tileMap = map;
	self.mapWidth = tileMap.contentSize.width;
	self.mapHeight = tileMap.contentSize.height;
}

static MapData *sharedMapData = nil;

+ (MapData *) sharedMap
{
    @synchronized(self)
	{
        if (sharedMapData == nil)
		{
            [[self alloc] init];
        }
    }
	
    return sharedMapData;
}



@end
