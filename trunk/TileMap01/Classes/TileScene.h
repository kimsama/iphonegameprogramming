//
//  TileScene.h
//  Tilemap01
//
//  Created by 현우 김 on 09. 10. 03.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameLayer.h"

@interface TileScene : Scene 
{
    GameLayer *gameLayer;
	
}

@property (nonatomic, retain) GameLayer *gameLayer;

@end
