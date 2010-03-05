//
//  GameLayer.m
//  Tilemap01
//
//  Created by 현우 김 on 09. 10. 03.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "chipmunk.h"

int const screenWidth  = 480;
int const screenHeight = 320;

@implementation GameLayer

@synthesize tileMap;
@synthesize mapData;

-(id) init
{
	self = [super init];
	
	if (self)
	{
		[self schedule: @selector(tick:) interval:0.01];
	}
	
	return self;
}

-(void) dealloc
{
	[self unschedule:@selector(tick:)];
	[super dealloc];
}

-(void) tick: (ccTime) deltime
{
	if (levelLoaded)
	{
		[self updateCamera];
	}
}

-(void) loadLevel:(int) level
{
	if (tileMap != nil)
		[tileMap releaseMap];
	if (mapData == nil)
		mapData = [MapData sharedMap];
	
	/*
	NSString *levelsDirectory = [[@"/Levels/level" stringByAppendingString:[NSString stringWithFormat:@"%d", level]] stringByAppendingString:@"/"];
	
	self.tileMap = [TileMapAtlas tileMapAtlasWithTileFile:[levelsDirectory stringByAppendingString:@"mario_tileset01.png"] 
												  mapFile:[levelsDirectory stringByAppendingString:@"mario01.tga"] tileWidth:TILE_SIZE tileHeight:TILE_SIZE];
	*/
	 
	self.tileMap = [TileMapAtlas tileMapAtlasWithTileFile:@"mario_tileset01.png" mapFile:@"mario01.tga" tileWidth:TILE_SIZE tileHeight:TILE_SIZE];	
	
	//tileMap.transformAnchor = cpv(0, 0);
	
	mapX = mapY = 0;
	
	[mapData setTileMapAtlas:tileMap];
	
	[self updateCamera];
	
	[self addChild:tileMap];
	
	levelLoaded = YES;
}


- (void) updateCamera
{	
	
	// Set mapX and mapY based on dozer position
	[self setMapPosition];
	
	tileMap.position = cpv(mapX, mapY);
}

- (void) setMapPosition
{	
	/*
	// Check if the dozer is near the edge of the map
	if(dozerX < screenWidth/2-(TILE_SIZE))
		mapX = 0;
	else if(dozerX > mapData.mapWidth - (screenWidth/2))
		mapX = -mapData.mapWidth;
	else
		mapX = -(dozerX - (screenWidth/2) + (TILE_SIZE));
	
	if(dozerY < screenHeight/2-(TILE_SIZE))
		mapY = 0;
	else if(dozerY > mapData.mapHeight - (screenHeight/2))
		mapY = -mapData.mapHeight;
	else
		mapY = -(dozerY - (screenHeight/2) + (TILE_SIZE));
	
	// Reset the map if the next position is past the edge
	if(mapX > 0) 
		mapX = 0;
	if(mapY > 0) 
		mapY = 0;
	
	if(mapX < -(mapData.mapWidth - screenWidth)) 
		mapX = -(mapData.mapWidth - screenWidth);
	if(mapY < -(mapData.mapHeight - screenHeight)) 
		mapY = -(mapData.mapHeight - screenHeight);
	*/
}

@end

enum {
	kTagTileMap = 1,
};

@implementation TileMapTest

-(id) init
{
	if( (self=[super init]) ) 
	{
		self.isTouchEnabled = YES;
		
		TileMapAtlas *tilemap = [TileMapAtlas tileMapAtlasWithTileFile:@"tiles.png" mapFile:@"levelmap.tga" tileWidth:16 tileHeight:16];
		// Convert it to "alias" (GL_LINEAR filtering)
		[tilemap.texture setAliasTexParameters];
		
		// If you are not going to use the Map, you can free it now
		// NEW since v0.7
		[tilemap releaseMap];
		
		[self addChild:tilemap z:0 tag:kTagTileMap];
		
		tilemap.anchorPoint = ccp(0, 0.5f);
		
		//		id s = [ScaleBy actionWithDuration:4 scale:0.8f];
		//		id scaleBack = [s reverse];
		//		
		//		id seq = [Sequence actions: s,
		//								scaleBack,
		//								nil];
		//		
		//		[tilemap runAction:[RepeatForever actionWithAction:seq]];
	}
	
	return self;
}

-(void) registerWithTouchDispatcher
{
	[[TouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchLocation = [touch locationInView: [touch view]];	
	CGPoint prevLocation = [touch previousLocationInView: [touch view]];	
	
	touchLocation = [[Director sharedDirector] convertCoordinate: touchLocation];
	prevLocation = [[Director sharedDirector] convertCoordinate: prevLocation];
	
	CGPoint diff = ccpSub(touchLocation,prevLocation);
	
	CocosNode *node = [self getChildByTag:kTagTileMap];
	CGPoint currentPos = [node position];
	[node setPosition: ccpAdd(currentPos, diff)];
}

@end
