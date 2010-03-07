//
//  test.m
//  kriel
//
//  Created by Hyoun Woo Kim on 09. 08. 26.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "test.h"


@implementation test

-(void) init
{
    mgr = [AtlasSpriteManager spriteManagerWithFile:@"knight.png" capacity:50];
	
    knight = [AtlasSprite spriteWithRect:CGRectMake(0, 90, 90, 90) spriteManager:mgr];
    knight.position = ccp(400, 160);
    [mgr addChild:knight];
    [self addChild:mgr];

    animation = [AtlasAnimation animationWithName:@"walk" delay:0.2];
	
    for (int i = 0; i < 3; i++)
    {
	    [animation addFrameWithRect:CGRectMake(i * 90, 90, 90, 90)];
    }

	atlasSpriteAction = [Animate actionWithAnimation:animation];
    [knight runAction:[RepeatForever actionWithAction:atlasSpriteAction]];
}

@end
