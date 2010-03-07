//
//  GameScene.m
//  kriel
//
//  Created by Hyoun Woo Kim on 09. 06. 17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "gameScene.h"
#import "menuScene.h"
#import "spriteXmlParser.h"

#include "game.h"

@implementation GameScene

/**
 */
-(id) init 
{
	self = [super init];
	if(self != nil)
	{
		// 배경 출력
		Sprite* bg = [Sprite spriteWithFile:@"menu.png"];
		[bg setPosition:ccp(240, 160)];
		[self addChild:bg z:0];
		[self addChild:[GameLayer node] z:1];
	}
	
	return self;
}

@end

@implementation GameLayer

@synthesize currentHeroAction;

/**
 */
-(id) init
{
	self = [super init];
	if (self != nil)
	{
		isTouchEnabled = YES;
	
		NSError *error = nil;
		NSString * dataFilePath = @"kriel_spr.xml";
		spriteXmlParser *xmlParser = [[spriteXmlParser alloc] init];
		[xmlParser parseXMLWithFile:dataFilePath parseError:&error];
		
		//// strip '.xml' file extension.
		//NSString *imgFilename = [dataFilePath stringByDeletingPathExtension];
		//// appedn '.png' file extension.
		//NSString *imgFilePath = [imgFilename stringByAppendingString:@".png"];
		
		AtlasSpriteManager *mgr = [AtlasSpriteManager spriteManagerWithFile:@"kriel_spr04.png" capacity:100];
		// FIXME: hardcoding with tag!!!
		[self addChild:mgr z:0 tag:tagSpriteManager];
		
		// Create sprite resource manager.
		resManager = [[ResourceManager alloc] init];
		
        // Access to the sprite info array which contains all information on the sprites.
		NSMutableArray *spr = xmlParser.spriteArray;
		
		spriteDirctionay = [[NSMutableDictionary alloc] init];
		
		for (int i=0; i < spr.count; i++)
		{
			SpriteElement *element = [spr objectAtIndex:i];
			
			// create AtlasSprite with the parsed key values withe the given AtlasSpriteManager
			AtlasSprite *sprite = [AtlasSprite spriteWithRect:CGRectMake(element.x, element.y, element.w, element.h) spriteManager: mgr];
			
			sprite.position = ccp(130, 40);
			sprite.visible = NO;
			
			// Add the created sprite to the sprite manager.
			NSString* sprID = [resManager.resourceID valueForKey:element.fileName];
			[mgr addChild:sprite z:1 tag:[sprID intValue]];
			
			[spriteDirctionay setObject:element forKey:element.fileName];
		}
		
		/*
		// BEGIN OF TEST CODE!!! 
		// the following code retrieves "hero_left1.png" sprite
		NSString* resID = [resManager.resourceID objectForKey:@"hero_left1.png"];
		int myTag = [resID intValue];
		AtlasSprite* mySprite = [mgr getChildByTag:myTag];
		mySprite.visible = YES;
		mySprite.position = ccp(150, 100);
		// END OF TEST CODE!!!
		*/
		
		[xmlParser release];
		
		/////
		[self newGame];
		
		NSString *path = [[NSBundle mainBundle] bundlePath];
		NSString *dataPath = [path stringByAppendingPathComponent:@"STAGE.DAT"];
		loadStage([dataPath UTF8String]);
		
		readStage(currentStage);
		
		heroX = getHeroInitX();
		heroY = getHeroInitY();
		heroOldX = heroX;
		heroOldY = heroY;		
		
		// knight, guard, key, open
		slimAnim = [self makeAnimation:@"slime" andNumFrames:4];
		guardAnim = [self makeAnimation:@"guard" andNumFrames:4];
		ghostAnim = [self makeAnimation:@"ghost" andNumFrames:4];
		keyAnim = [self makeAnimation:@"key" andNumFrames:4];
		//AtlasAnimation * openAnim = [self makeAnimation:@"open"];
		
		slimeAction = [RepeatForever actionWithAction:[Animate actionWithAnimation: slimAnim]];
		guardAction = [RepeatForever actionWithAction:[Animate actionWithAnimation: guardAnim]];
		ghostAction = [RepeatForever actionWithAction:[Animate actionWithAnimation: ghostAnim]];
		keyAction = [RepeatForever actionWithAction:[Animate actionWithAnimation: keyAnim]];
		
		heroLeftAnim = [self makeAnimation:@"hero_left" andNumFrames:2];
		heroRightAnim = [self makeAnimation:@"hero_right" andNumFrames:2];
		heroUpAnim    = [self makeAnimation:@"hero_up" andNumFrames:2];
		heroDownAnim  = [self makeAnimation:@"hero_down" andNumFrames:2];
		
		heroLeftAction  = [[RepeatForever actionWithAction:[Animate actionWithAnimation: heroLeftAnim]] retain];
		heroRightAction = [[RepeatForever actionWithAction:[Animate actionWithAnimation: heroRightAnim]] retain];
		heroUpAction    = [[RepeatForever actionWithAction:[Animate actionWithAnimation: heroUpAnim]] retain];
		heroDownAction  = [[RepeatForever actionWithAction:[Animate actionWithAnimation: heroDownAnim]] retain];
		
		crushAnim = [self makeAnimation:@"crush" andNumFrames:4];
		crushAction = [[Sequence actions:[Animate actionWithAnimation: crushAnim], 
						[CallFunc actionWithTarget:self selector:@selector(callbackCrush)], nil] retain];
		
		SpriteElement *e = [spriteDirctionay objectForKey:@"crush1.png"];
		
		AtlasSprite *sprite = [AtlasSprite spriteWithRect:CGRectMake(e.x, e.y,e.w, e.h) spriteManager:mgr];
		[sprite runAction:crushAction];
		[mgr addChild:sprite z:0 tag:tagCrush];
		
		/*
		SpriteElement *ele= [spriteDirctionay objectForKey:@"slime1.png"];
		AtlasSprite *slimSprite = [AtlasSprite spriteWithRect:CGRectMake(ele.x, ele.y,ele.w, ele.h) spriteManager:mgr];
		slimSprite.position = ccp(200, 100);
		
		[slimSprite runAction:slimeAction];
		
		[mgr addChild:slimSprite z:2 tag:2000];
		*/ 
		
		[self drawUI];
		[self drawStage];
		[self drawHero];
		////
		
        MenuItemImage *itemUp = [MenuItemImage itemFromNormalImage:@"r1.png" selectedImage:@"r2.png" 
															target:self selector:@selector(upCallback:)];
		MenuItemImage *itemDown = [MenuItemImage itemFromNormalImage:@"r1.png" selectedImage:@"r2.png" 
															target:self selector:@selector(downCallback:)];		
		MenuItemImage *itemLeft = [MenuItemImage itemFromNormalImage:@"r1.png" selectedImage:@"r2.png" 
															target:self selector:@selector(leftCallback:)];		
		MenuItemImage *itemRight = [MenuItemImage itemFromNormalImage:@"r1.png" selectedImage:@"r2.png" 
															target:self selector:@selector(rightCallback:)];	
		
		Menu *menu = [Menu menuWithItems:itemUp, itemDown, itemLeft, itemRight, nil];
		menu.position = CGPointZero;
		
		itemUp.position    = ccp(360, 200);
		itemDown.position  = ccp(360, 120);
		itemLeft.position  = ccp(320, 160);
		itemRight.position = ccp(400, 160);
		
		[self addChild: menu z:1];	
		
		
		// Load sounds files...
		id sndpathItem = [[[NSBundle mainBundle] pathForResource:@"item" ofType:@"wav"] autorelease];
		id sndpathWalk = [[[NSBundle mainBundle] pathForResource:@"walk" ofType:@"wav"] autorelease];
		id sndpathKill = [[[NSBundle mainBundle] pathForResource:@"kill" ofType:@"wav"] autorelease];
		
		CFURLRef baseURLItem = (CFURLRef)[[NSURL alloc] initFileURLWithPath:sndpathItem];
		CFURLRef baseURLWalk = (CFURLRef)[[NSURL alloc] initFileURLWithPath:sndpathWalk];
		CFURLRef baseURLKill = (CFURLRef)[[NSURL alloc] initFileURLWithPath:sndpathKill];
		
		AudioServicesCreateSystemSoundID(baseURLItem, &sndIDItem);
		AudioServicesCreateSystemSoundID(baseURLWalk, &sndIDWalk);
		AudioServicesCreateSystemSoundID(baseURLKill, &sndIDKill);
		
		/*** TEST
		actor = [[ActorSprite alloc] init];
		id manager = [actor Load:@"testanimation.xml" withImage:@"naruto02.png"];
		[self addChild:manager z:1 tag:1];
		***/
	}
	
	return self;
}

-(void)callbackCrush
{
}

/**
 */
-(void) upCallback: (id) sender
{
	NSLog(@"Up Key Down\n");
	heroDir = DIR_UP;
	
	int x = heroX;
	int y = heroY - 1;
	
	[self heroMovePositionX: x andY: y];
}

/**
 */
-(void) downCallback: (id) sender
{
	NSLog(@"Down Key Down\n");	
	heroDir = DIR_DOWN;
	
	int x = heroX;
	int y = heroY + 1;
	[self heroMovePositionX: x andY: y];	
}

/**
 */
-(void) leftCallback: (id) sender
{
	NSLog(@"Left Key Down\n");	
	heroDir = DIR_LEFT;
	
	int x = heroX - 1;
	int y = heroY;
	[self heroMovePositionX: x andY: y];	
}

/**
 */
-(void) rightCallback: (id) sender
{
	NSLog(@"Right Key Down\n");	
	heroDir = DIR_RIGHT;
	
	int x = heroX + 1;
	int y = heroY;
	[self heroMovePositionX: x andY: y];
}

/**
   e.g. slime, knight, guard, key, open etc.
 
 */
-(AtlasAnimation*) makeAnimation: (NSString*)animationName andNumFrames:(int)frames
{
	AtlasAnimation *animation = [AtlasAnimation animationWithName:animationName delay:0.2f];
	
	SpriteElement *elem;
	
	for (int i=0; i<frames; i++)
	{
	
		NSString* animFilename = [NSString stringWithFormat:@"%@%d.png", animationName, i+1];
		
		elem = [spriteDirctionay objectForKey:animFilename];
		
		
		if (elem)
		    [animation addFrameWithRect: CGRectMake(elem.x, elem.y, elem.w, elem.h) ];
		else
			return nil;
	}
	
	return animation;
}

/**
 */
-(void) addAction:(AtlasSprite*)sprite at:(int)x and:(int)y
{	
	byte b = getStage(x, y);
	
	// slime
	if (b == IMG_SLIME /*3*/)
	{
		id action = [[slimeAction copy] autorelease];
		[sprite runAction:action];
		
	}
	
	// guard
	if (b == IMG_KNIGHT /*4*/)
	{
		id action = [[guardAction copy] autorelease];
		[sprite runAction:action];		
	}
	
	// ghost
	if (b == IMG_GHOST /*5*/)
	{
		id action = [[ghostAction copy] autorelease];
		[sprite runAction:action];		
	}
	
	// key
	if (b == IMG_KEY /*10*/)
	{
		id action = [[keyAction copy] autorelease];
		[sprite runAction:action];			
	}
}

/**
 */
-(void) drawUI
{
	[self drawVSBox];
	[self drawVSBox];
	[self drawLife];
	[self drawCursors];
}

/**
 */
-(void) drawStage
{	
	NSArray *values = [NSArray arrayWithObjects: 
					   @"floor_2.png",        // 0
					   @"block_1.png",        // 1
					   @"hero_left1.png",     // 2
					   @"slime1.png",         // 3
					   @"guard1.png",         // 4 @"knight1.png"
					   @"ghost1.png",         // 5
					   @"stick.png",          // 6
					   @"sword.png",          // 7
					   @"cross.png",          // 8
					   @"princess.png",       // 9
					   @"key1.png",           // 10
					   @"door_close.png",     // 11 @"close.png"
					   @"arrow_up1_1.png",    // 12
					   @"arrow_down1_1.png",  // 13
					   @"arrow_left1_1.png",  // 14
					   @"arrow_right1_1.png", // 15
					   nil ];
	
	int x, y;
	
	AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:tagSpriteManager];
	
	for (int j=0; j<CY_STAGE; j++)
	{
		for (int i=0; i<CX_STAGE; i++)
		{
			/////////
			// DEBUG
			if (i==7 && j==7)
			{
			    NSLog(@"Map Debug: i:%D j:%d %@", i, j, [values objectAtIndex:getStage(i, j)]);
			}		
			if (i==4 && j==3)
			{
			    NSLog(@"Map Debug: i:%D j:%d %@", i, j, [values objectAtIndex:getStage(i, j)]);
			}
			/////////
			
			SpriteElement *e = [spriteDirctionay objectForKey:[values objectAtIndex:getStage(i, j)]];
			
			AtlasSprite *sprite = [AtlasSprite spriteWithRect:CGRectMake(e.x, e.y,e.w, e.h) spriteManager:mgr];
			
			x = PX_STAGE_START + i * e.w;//CY_IMG;
			//y = PY_STAGE_START + j * e.h;//CX_IMG;
			y = PY_STAGE_START - j*e.h;
			
			sprite.position = ccp(x, y);
			
			// add action if the sprite has it...
			[self addAction:sprite at:i and:j];
			
			int sprTag = tagStage + i + j;
			[mgr addChild:sprite z:0 tag:sprTag];
			
			stageSprArray[i][j] = sprite;
			
			/////////
			// DEBUG
			if (i==6 && j==7)
			{
			    NSLog(@"Map Debug: i:%D j:%d %@ tag:%d", i, j, [values objectAtIndex:getStage(i, j)], sprTag);
			}
			/////////
		}
	}
}

/**
 */
-(AtlasSprite*) getHeroSprite
{
	AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:tagSpriteManager];
	AtlasSprite *sprite = (AtlasSprite*)[mgr getChildByTag:tagHero];
	
	return sprite;
}

/**
 */
-(void) drawHero
{
	AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:tagSpriteManager];
	
	SpriteElement *e = [spriteDirctionay objectForKey:@"hero_left1.png"];
	AtlasSprite *sprite = [AtlasSprite spriteWithRect:CGRectMake(e.x, e.y,e.w, e.h) spriteManager:mgr];
	
	int x,y;
	x = PX_STAGE_START + heroX * e.w;//CY_IMG;
	//y = PY_STAGE_START + heroY * e.h;//CX_IMG;
	y = PY_STAGE_START - heroY * e.h;
	
	sprite.position = ccp(x, y);
	
	[mgr addChild:sprite z:1 tag:tagHero];
	
	// default action
	[sprite runAction:heroDownAction];
	self.currentHeroAction = heroDownAction;
}

/**
     @"icon_stick.png", // 0
     @"icon_sword.png", // 1
     @"icon_cross.png", // 2
     @"icon_guard.png", // 3
     @"icon_ghost.png", // 4
     @"icon_slime.png", // 5
     @"vsbox.png",      // 6									
     @"vsbox.png",      // 7
     @"equal.png",      // 8 
 */
-(void)udpateVSBox:(int)itemIndex Show:(BOOL)show
{
    AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:tagSpriteManager];
	
	int itemSpriteTag;
	int monsterSpriteTag;
	
	//int x, y;
	switch (itemIndex) {
		case IMG_STICK:
			itemSpriteTag = 301;
			monsterSpriteTag = 306;
			break;
		case IMG_SWORD:
			itemSpriteTag = 302;
			monsterSpriteTag = 304;
			break;
		case IMG_CROSS:
			itemSpriteTag = 303;
			monsterSpriteTag = 305;
			break;
		default:
			return;
			break;
	}
	
	int t;
	AtlasSprite *sprite;
	
	t = tagVSBOX + itemSpriteTag;
	sprite = (AtlasSprite*)[mgr getChildByTag:itemSpriteTag];
	if (sprite)
	{
	    //[sprite setVisible:show];//sprite.visible = show;
		if (show)
		    sprite.position = ccp(PX_VSBOX, PY_VSBOX);
		else
			sprite.position = ccp(500, 500);
	}
	
	t = tagVSBOX + monsterSpriteTag;
	sprite = (AtlasSprite*)[mgr getChildByTag:monsterSpriteTag];
	if (sprite)
	{
		if (show)
		    sprite.position = ccp(PX_VSBOX + CX_VSBOX*2 + 8, PY_VSBOX);
		else
			sprite.position = ccp(500, 500);		
	}
}

/**
 
 */
-(void) drawVSBox
 {
	 NSArray *values = [NSArray arrayWithObjects: 
	     @"icon_stick.png", // 0
         @"icon_sword.png", // 1
         @"icon_cross.png", // 2
         @"icon_guard.png", // 3
         @"icon_ghost.png", // 4
         @"icon_slime.png", // 5
		 @"vsbox.png",      // 6									
		 @"vsbox.png",      // 7
		 @"equal.png",      // 8
		 nil ];	 
	 
    AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:tagSpriteManager];
	
	SpriteElement *e;
	
	for (int i=0; i<9; i++)
	{
	    e = [spriteDirctionay objectForKey:[values objectAtIndex:i]];
	    AtlasSprite *sprite = [AtlasSprite spriteWithRect:CGRectMake(e.x, e.y,e.w, e.h) spriteManager:mgr];
		
		switch (i)
		{
			case 0:
				sprite.position = ccp(500, 500);
				[mgr addChild:sprite z:2 tag:tagStickIcon];				
				break;
			case 1:
				sprite.position = ccp(500, 500);
				[mgr addChild:sprite z:2 tag:tagSwordIcon];							
				break;
			case 2:
				sprite.position = ccp(500, 500);
				[mgr addChild:sprite z:2 tag:tagCrossIcon];							
				break;
			case 3:
				sprite.position = ccp(500, 500);
				[mgr addChild:sprite z:2 tag:tagGuardIcon];							
				break;
			case 4:
				sprite.position = ccp(500, 500);
				[mgr addChild:sprite z:2 tag:tagGhostIcon];							
				break;
			case 5:
				sprite.position = ccp(500, 500);
				[mgr addChild:sprite z:2 tag:tagSlimeIcon];							
				break;
			case 6:
				sprite.position = ccp(PX_VSBOX, PY_VSBOX); 
				[mgr addChild:sprite z:1 tag:tagVSBOX];				
				break;
			case 7:
				sprite.position = ccp(PX_VSBOX + CX_VSBOX*2 + 8, PY_VSBOX); 
				[mgr addChild:sprite z:1 tag:tagVSBOX];				
				break;
			case 8:
				sprite.position = ccp(PX_VSBOX + CX_VSBOX + 4, PY_VSBOX); 
				[mgr addChild:sprite z:1 tag:tagEqualIcon];				
				break;
		}
		/*
		if (i<=0 && i<3)
		{
		    sprite.position = ccp(500, 500);//ccp(PX_VSBOX, PY_VSBOX); // item icon
			//sprite.visible = NO;
			
			[mgr addChild:sprite z:2 tag:tagVSBOX+i];
		}
		else
		if (i>=3 && i<6)
		{
		    sprite.position = ccp(500, 500); //ccp(PX_VSBOX + CX_VSBOX*2 + 8, PY_VSBOX); //mob icon
			//sprite.visible = NO;
			
			[mgr addChild:sprite z:2 tag:tagVSBOX+i];
		}
		else
		if (i==6)
		{
		    sprite.position = ccp(PX_VSBOX, PY_VSBOX); 
			
			[mgr addChild:sprite z:1 tag:tagVSBOX+i];
		}
		else
		if (i==7)
		{
		    sprite.position = ccp(PX_VSBOX + CX_VSBOX*2 + 8, PY_VSBOX); 
			
			[mgr addChild:sprite z:1 tag:tagVSBOX+i];
		}
		else
		if (i==8) // equal
		{
		    sprite.position = ccp(PX_VSBOX + CX_VSBOX + 4, PY_VSBOX); 
			
			[mgr addChild:sprite z:1 tag:tagVSBOX+i];
		}
		
		//[mgr addChild:sprite z:2 tag:tagVSBOX+i];
		 */
	}
 }
 
/**
 */
-(void) drawLife
{
	AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:tagSpriteManager];
	
	SpriteElement *e = [spriteDirctionay objectForKey:@"life.png"];
	
	for (int i=0; i<numHeroLife; i++)
	{
		
		AtlasSprite *sprite = [AtlasSprite spriteWithRect:CGRectMake(e.x, e.y,e.w, e.h) spriteManager:mgr];
		
		sprite.position = ccp(PX_LIFE + i * CX_LIFE, PY_LIFE);
		[mgr addChild:sprite z:1 tag:tagLife];
	}
}

/**
 */
-(void) drawCursors
{
	NSArray *values = [NSArray arrayWithObjects: 
	    @"cur_left.png",  // 0
		@"cur_up.png",    // 1
		@"cur_down.png",  // 2
	    @"cur_right.png", // 3
		nil];
	
	AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:tagSpriteManager];
	SpriteElement *e;
	
	for (int i=0; i<4; i++)
	{
	    e = [spriteDirctionay objectForKey:[values objectAtIndex:i]];
	    AtlasSprite *sprite = [AtlasSprite spriteWithRect:CGRectMake(e.x, e.y,e.w, e.h) spriteManager:mgr];
		
		switch (i) {
			case 0:
				sprite.position = ccp(PX_CURSOR + CX_CURSOR * 0, PY_CURSOR); // left
				break;
			case 1:
				sprite.position = ccp(PX_CURSOR + CX_CURSOR * 1, PY_CURSOR); // right
				break;
			case 2:
				sprite.position = ccp(PX_CURSOR + CX_CURSOR * 2, PY_CURSOR); // down
				break;
			case 3:
				sprite.position = ccp(PX_CURSOR + CX_CURSOR * 3, PY_CURSOR); // up
				break;
		}
		
		[mgr addChild:sprite z:1 tag:tagLife];
	}		
}

/**
     가지고 있는 아이템이 이동할 좌표의 몬스터에 유효한지를 검사.
 */
-(BOOL) check:(int)item With:(int)monster
{
	if (item == IMG_STICK && monster == IMG_SLIME)
		return YES;
	if (item == IMG_SWORD && monster == IMG_KNIGHT)
		return YES;
	if (item == IMG_CROSS && monster == IMG_GHOST)
		return YES;
	
	return NO;
}

/**
 */
-(void) crashMonsterAt:(int)x And:(int)y
{
	// play sound
	AudioServicesPlaySystemSound(sndIDKill);
	
	setStage(IMG_FLOOR, x, y);
	itemWhichHave = 0;
	
	// hide the monster sprite
	AtlasSprite *sprite = stageSprArray[x][y];
	sprite.position = ccp(500, 500);
	
	// animate crash animation
	// ...
	
	// create floor sprite and replace it.
	AtlasSprite* spr = [self createSprite:@"floor_2.png" At:x And:y withLayer:0 Tag:2000];
	
	stageSprArray[x][y] = spr;	
}

/**
 */
-(BOOL) canMoveTo: (int)x and:(int)y
{
	NSLog(@"Where to go: x:%d y:%d stage:%d \n", x, y, getStage(x, y));
	
	if (x < 0 || x >= CX_STAGE || y < 0 || y >= CY_STAGE)
		return NO;

	//HACK:	
	//switch (getStage(heroX, heroY)) ==> 현재 hero 위치 
    switch (getStage(x, y)) // ==> 이동할 위치 	
	{
		case IMG_LEFT:
		case IMG_RIGHT:
		case IMG_UP:
		case IMG_DOWN:
		case IMG_FLOOR:
		case IMG_KEY:
		case IMG_EXIT:
		case IMG_PRINCESS:
			gameState = GS_PLAY_HERO_MOVE;
			AudioServicesPlaySystemSound(sndIDWalk);
			return YES;
			
		case IMG_STICK:
		case IMG_SWORD:
		case IMG_CROSS:
			if (itemWhichHave)
				return NO;
			else
				AudioServicesPlaySystemSound(sndIDWalk);
				return YES;
	}
	
	if (itemWhichHave)
	{
		if( [self check:itemWhichHave With:getStage(x, y)])
		{
			AudioServicesPlaySystemSound(sndIDWalk);
			gameState = GS_PLAY_HERO_MOVE;
			return YES;
		}
	}
	
	return NO;
}

/**
     @x - 이동을 검사할 위치 x 좌표
     @y - 이동을 검사할 위치 y 좌표
     @item - 이동할 위치의 아이템, 맵 인덱스로부터 얻어 온다.
 */
-(BOOL) pickupAt:(int)x And:(int)y Item:(int)itemIndex
{
	//int i;
	
	if (itemIndex == IMG_KEY)
	{
		// hide the item on the map at (x, y);
		AtlasSprite *sprite = stageSprArray[x][y];
		sprite.position = ccp(500, 500);
		
		// create floor sprite and replace it.
		AtlasSprite* spr = [self createSprite:@"floor_2.png" At:x And:y withLayer:0 Tag:2000];
		stageSprArray[x][y] = spr;
		
		haveKey = YES;
		
		// play pickup key item sound!
		AudioServicesPlaySystemSound(sndIDItem);
		
		for (int i=0; i<4; i++)
		{
			;
		}
		
		return YES;
	}
	
	if (itemIndex == IMG_PRINCESS)
	{
		AudioServicesPlaySystemSound(sndIDItem);
		return YES;
	}
	
	// 아이템을 가지고 있는 경우, 새로운 아이템을 획득할 수 없다.
	if (itemWhichHave)
		return NO;
	
	switch (itemIndex) {
		case IMG_STICK:
		case IMG_SWORD:
		case IMG_CROSS:
			itemWhichHave = itemIndex;
			[self udpateVSBox:itemIndex Show:YES];
			
			/*
			// hide item sprite at the given (x, y)
			AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:tagSpriteManager];
			int t = tagStage + x + y;
			AtlasSprite *sprite = (AtlasSprite*)[mgr getChildByTag:t];
			if (sprite)
			{
				// 화면에 그리고 있는 동안에는 AtlaSprite에서는 setVisible을 사용할 수 없다.
				sprite.position = ccp(500, 500);
				//[sprite setVisible:NO];//sprite.visible = NO;
			}
			*/
			
			// hide the item on the map at (x, y);
			AtlasSprite *sprite = stageSprArray[x][y];
			sprite.position = ccp(500, 500);
			
			// create floor sprite and replace it.
		    AtlasSprite* spr = [self createSprite:@"floor_2.png" At:x And:y withLayer:0 Tag:2000];
			
			stageSprArray[x][y] = spr;
			
			
			break;
	
		default:
			return NO;
	}
	
	// play sound get item
	AudioServicesPlaySystemSound(sndIDItem);
	
	return YES;
}

/**
 */
-(AtlasSprite*)createSprite:(NSString*)sprname At:(int)x And:(int)y withLayer:(int)z Tag:(int)t
{
	AtlasSpriteManager *mgr = (AtlasSpriteManager*) [self getChildByTag:tagSpriteManager];
	
	//SpriteElement *e = [spriteDirctionay objectForKey:@"floor_2.png"];
	SpriteElement *e = [spriteDirctionay objectForKey:sprname];
	AtlasSprite *sprite = [AtlasSprite spriteWithRect:CGRectMake(e.x, e.y,e.w, e.h) spriteManager:mgr];
	
	int nx, ny;
	nx = PX_STAGE_START + x * e.w;
	ny = PY_STAGE_START - y * e.h;
	
	sprite.position = ccp(nx, ny);
	
	[mgr addChild:sprite z:0 tag:t];
	
	return sprite;
}

/**
 */
-(void) checkEvent
{
	
}

/**
 */
-(BOOL) checkStageClearAt:(int)x And:(int)y
{
	if (YES == haveKey && IMG_EXIT == getStage(x, y))
	{
		// play stage cleared sound
		//...
		
		return YES;
	}
	
	return NO;
}

/**
 */
-(void)updateHeroPositionAt:(int)x And:(int)y
{
	// change hero's position in screen mode
	AtlasSprite* heroSprite = [self getHeroSprite];
	if (heroSprite != nil)
	{
		int sx = PX_STAGE_START + x * CX_IMG;
		int sy = PY_STAGE_START - y * CY_IMG;
		
		heroSprite.position = ccp(sx, sy);
		
		NSLog(@"Current Hero Pos in pixel: (%d, %d)\n", sx, sy);
	}
	
	// change hero's animation
	AtlasSprite* s = [self getHeroSprite];
	[s stopAction:currentHeroAction];
	
	switch (heroDir) {
		case DIR_LEFT:
			self.currentHeroAction = heroLeftAction;
			[s runAction:heroLeftAction];
			break;
		case DIR_RIGHT:
			self.currentHeroAction = heroRightAction;
			[s runAction:heroRightAction];
			break;
        case DIR_UP:
			self.currentHeroAction = heroUpAction;
			[s runAction:heroUpAction];			
			break;
		case DIR_DOWN:	
			self.currentHeroAction = heroDownAction;
			[s runAction:heroDownAction];
			break;
		default:
			break;
	}
}

/**
 */
-(void) heroMovePositionX:(int)x andY:(int)y
{	
	if (NO == [self canMoveTo:x and:y])
		return;
	
	[self updateHeroPositionAt:x And:y];
	
	if ([self pickupAt:x And:y Item:getStage(x, y)])
	{
		setStage(IMG_FLOOR, x, y);
		heroOldX = heroX;
		heroOldY = heroY;
		heroX = x;
		heroY = y;
				
		return;
	}
	
	if (itemWhichHave)
	{
		if ([self check:itemWhichHave With:getStage(x,y)])
		{
			// we used the item
			[self udpateVSBox:itemWhichHave Show:NO];
			
			// remove the monster at (x, y)
			[self crashMonsterAt:x And:y];
		}
	}
	
	//TODO
	if ([self checkStageClearAt:x And:y])
	    [self nextStage];
	
	switch (getStage(x, y)) 
	{
		case IMG_FLOOR:
		case IMG_UP:
		case IMG_DOWN:
		case IMG_LEFT:
		case IMG_RIGHT:			
			heroOldX = heroX;
			heroOldY = heroY;
			heroX = x;
			heroY = y;
			break;
	}
}

/**
 */
-(void) nextStage
{
	itemWhichHave = 0;
	heroKey = 0;
	stageCleared = 0;
	//heroDir = DIR_DOWN;
	heroOldX = 0;
	heroOldY = 0;
	
	haveKey = NO;
	
	if (++currentStage >= MAX_STAGE)
	{
		gameState = GS_ALLCLEAR;
		currentStage = 0;
	}
	
	if (lastStage < currentStage)
		lastStage = currentStage;
	
	readStage(currentStage);
	
	heroX = getHeroInitX();
	heroY = getHeroInitY();
	heroOldX = heroX;
	heroOldY = heroY;
	
	// save ...
}

/**
 */
-(void) newGame
{
	gameState = GS_PLAY;
	currentStage = 2;
	itemWhichHave = 0;
	numHeroLife = MAX_LIFE;				
	
	heroKey = 0;
	stageCleared = 0;
	heroDir = DIR_DOWN;
	heroOldX = 0;
	heroOldY = 0;
	
	haveKey = NO;
}

/**
 */
-(BOOL) ccTouchesEnabled:(NSSet*)touches withEvent: (UIEvent*)event
{
	MenuScene* ms = [MenuScene node];
	[[Director sharedDirector] replaceScene:ms];
	return kEventHandled;
}

/**
 */
-(void) dealloc
{
	[resManager release];
	
	[super dealloc];
}

@end
