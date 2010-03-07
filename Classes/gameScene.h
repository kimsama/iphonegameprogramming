//
//  GameScene.h
//  kriel
//
//  Created by Hyoun Woo Kim on 09. 06. 17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioToolbox/AudioServices.h"
#import "cocos2d.h"

#import "resourceManager.h"
#import "ActorSprite.h"
#import "defines.h"

@interface GameScene : Scene 
{
}

@end

@interface GameLayer: Layer
{

	ResourceManager *resManager;
	NSMutableDictionary *spriteDirctionay;
	
	AtlasAnimation *slimAnim;
	AtlasAnimation *guardAnim;
	AtlasAnimation *ghostAnim;
	AtlasAnimation *keyAnim;

	Action* slimeAction;
	Action* guardAction;
	Action* ghostAction;
	Action* keyAction;
	
	AtlasAnimation *heroLeftAnim;
	AtlasAnimation *heroRightAnim;
	AtlasAnimation *heroUpAnim;
	AtlasAnimation *heroDownAnim;
	
	Action* heroLeftAction;
	Action* heroRightAction;
	Action* heroUpAction;
	Action* heroDownAction;
	Action* currentHeroAction;
	
	AtlasAnimation *crushAnim;
	Action *crushAction;
	
    enum HERO_DIR {
		DIR_LEFT,
		DIR_RIGHT,
		DIR_UP,
		DIR_DOWN
	};
	
	int heroX;
	int heroY;
	int heroOldX;
	int heroOldY;	
	
	int heroDir;
	
	int numHeroLife;
	int itemWhichHave;
	
	int currentStage;
	int lastStage;
	int stageCleared;
	
	int heroKey;

	AtlasSprite* stageSprArray[CX_STAGE][CY_STAGE];
	
	ActorSprite *actor;
	
	int gameState;
	
	BOOL haveKey;
	
	// get a item
	SystemSoundID sndIDItem;
	// when the hero walks
	SystemSoundID sndIDWalk;
	// when the hero kills a monster
	SystemSoundID sndIDKill;	
}

@property(readwrite, retain) Action* currentHeroAction;

-(AtlasAnimation*) makeAnimation: (NSString*)animationName andNumFrames:(int)frames;
-(void) addAction:(AtlasSprite*)sprite at:(int)x and:(int)y;
-(void)udpateVSBox:(int)itemIndex Show:(BOOL)show;

-(void) drawCursors;
-(void) drawVSBox;
-(void) drawLife;
-(void) drawUI;
-(void) drawStage;
-(void) drawHero;
-(AtlasSprite*) getHeroSprite;

-(AtlasSprite*)createSprite:(NSString*)sprname At:(int)x And:(int)y withLayer:(int)z Tag:(int)t;

-(BOOL) check:(int)item With:(int)monster;
-(BOOL) canMoveTo: (int)x and:(int)y;
-(void) crashMonsterAt:(int)x And:(int)y;
-(BOOL) pickupAt:(int)x And:(int)y Item:(int)itemIndex;
-(void) checkEvent;
-(BOOL) checkStageClearAt:(int)x And:(int)y;
-(void) updateHeroPositionAt:(int)x And:(int)y;
-(void) heroMovePositionX:(int)x andY:(int)y;
-(void) nextStage;

@end
