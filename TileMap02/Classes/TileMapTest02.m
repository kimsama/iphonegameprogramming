//
//  TileMapTest02.m
//  TileMapTest02
//
//  Created by 현우 김 on 09. 10. 03.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TileMapTest02.h"


@implementation TileMapTest02

-(id) init
{
	if( (self=[super init]) ) 
	{
		self.isTouchEnabled = YES;
		
		//
		// Test orthogonal with 3d camera and anti-alias textures
		//
		// it should not flicker. No artifacts should appear
		//
		ColorLayer *color = [ColorLayer layerWithColor:ccc4(64,64,64,255)];
		[self addChild:color z:-1];
		
		TMXTiledMap *ortho = [TMXTiledMap tiledMapWithTMXFile:@"orthogonal-test2.tmx"];
		[self addChild:ortho z:0 tag:1];
		
		for( AtlasSpriteManager* child in [ortho children] ) {
			[[child texture] setAntiAliasTexParameters];
		}
		float x, y, z;
		[[ortho camera] eyeX:&x eyeY:&y eyeZ:&z];
		[[ortho camera] setEyeX:x-200 eyeY:y eyeZ:z+300];		
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
	
	CocosNode *node = [self getChildByTag:1];
	CGPoint currentPos = [node position];
	[node setPosition: ccpAdd(currentPos, diff)];
}

@end
