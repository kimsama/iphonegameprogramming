//
//  MapData.h
//  Tilemap01
//
//  Created by 현우 김 on 09. 10. 03.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@interface MapData : NSObject 
{
    TileMapAtlas *tileMap;
	
	float mapWidth;
	float mapHeight;
}


@property (nonatomic, retain) TileMapAtlas *tileMap;

@property (readwrite) float mapWidth;
@property (readwrite) float mapHeight;

- (void) setTileMapAtlas:(TileMapAtlas *) map;

+(MapData*) sharedMap;

@end
