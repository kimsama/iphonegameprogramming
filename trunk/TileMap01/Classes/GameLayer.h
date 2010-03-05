//
//  GameLayer.h
//  Tilemap01
//
//  Created by 현우 김 on 09. 10. 03.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "MapData.h"

#define TILE_SIZE 16

@interface GameLayer : Layer 
{
    TileMapAtlas *tileMap;
	MapData *mapData;
	
	float mapX;
	float mapY;
	
	float dozerX;
	float dozerY;
	
	BOOL levelLoaded;
}

@property (nonatomic, retain) TileMapAtlas *tileMap;
@property (nonatomic, retain) MapData *mapData;

-(void) loadLevel:(int) level;
-(void) updateCamera;
-(void) setMapPosition;

@end

@interface TileMapTest : Layer
{
}
@end
