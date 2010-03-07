//
//  cocos2d_appAppDelegate.m
//  cocos2d app
//
//  Created by 주세영 on 09. 07. 12.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

// local import
#import "cocos2d.h"
#import "cocos2d_appAppDelegate.h"



static int sceneIdx=-1;
static NSString *transitions[] = {
@"MainGame",
 };

Class nextAction()
{
	
	sceneIdx++;
	sceneIdx = sceneIdx % ( sizeof(transitions) / sizeof(transitions[0]) );
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

Class backAction()
{
	sceneIdx--;
	if( sceneIdx < 0 )
		sceneIdx = sizeof(transitions) / sizeof(transitions[0]) -1;	
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

Class restartAction()
{
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}



@implementation MainGame

- (id) init
{
	if(![super init])
		return nil;
	
	isTouchEnabled = YES;
	AtlasSpriteManager *mgr = [AtlasSpriteManager spriteManagerWithFile:@"editcard.png" ];	
	[self addChild:mgr z:1 tag:kTagSpriteManager ];
	
	
	
	AtlasSpriteManager *mgr2 = [AtlasSpriteManager spriteManagerWithFile:@"background.png" ];	
	[self addChild:mgr2 z:0 tag:99];
	
	AtlasSprite *m_sprBackGround = [AtlasSprite spriteWithRect:CGRectMake(0, 0, 320, 460) spriteManager:mgr2];
	[mgr2 setPosition:CGPointMake(160,250)];
	[mgr2 addChild:m_sprBackGround z:0 tag:0];
	[m_sprBackGround draw];
	
//	[self LoadSprites];
	
	m_Agent = [CGostopAgent alloc];
	[m_Agent SetFirstStartGame:(bool)FALSE]; 
	[m_Agent InitGame];
	[m_Agent SetDefaultCoordination];
	[m_Agent SetDisplayCoordination];
	[m_Agent SetAtlasspritemgr:mgr];
	[m_Agent LoadSprites];
	[m_Agent StartNewGame];
	
	[m_Agent DrawFloorCards];
	[m_Agent DrawObtainedCards];
	[m_Agent DrawPlayerCards];
	[m_Agent DisplayGameProgress];
	

	
	return self;
}
- (void) dealloc
{
	[m_Agent UnloadSprites];
	[m_Agent release];
	[super dealloc];
}



- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		int whoturn = [m_Agent GetTurn];
		location = [[Director sharedDirector] convertCoordinate: location];
		if(GS_PLAYING == [m_Agent GetState])
		{
			NSLog(@"click : %f , %f",location.x , location.y);
			for(int  i =0; i < [m_Agent GetPlayerCardCount];i++ )
			{
				
				CGPoint pos = [m_Agent Getm_coPlayerCards:whoturn index2:i];
				
				if( location.x > pos.x - (18.0f)  && location.x < pos.x + (CARD_WIDTH) - (18.0f) )
				{
					if( location.y  > pos.y - CARD_HEIGHT + (24.0f) && location.y < pos.y + (24.0f))
					{
						NSLog(@"location : %f , %f : choose: %d",location.x , location.y, i);
						[m_Agent PutOutPlayerCard:i];
						[m_Agent PlaySound:SND_CLICK];
						break;
					}
				}
			}
		}
		
	}
	return kEventHandled;
}

- (void) draw
{
	[m_Agent DoAgency:nil];
	
//	glEnableClientState(GL_VERTEX_ARRAY);
//	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
//	glEnable( GL_TEXTURE_2D);
	
	//배경 그리고
//	if(GS_PLAYING == [m_Agent GetState])
	{
		
		//카드 그리고
		//[m_Agent DrawFloorCards];
		//[m_Agent DrawObtainedCards];
		//[m_Agent DrawPlayerCards];
		//게임 상황 그리고
		//[m_Agent DisplayGameProgress];
	}
	
//	AtlasSpriteManager *mgr = (AtlasSpriteManager*)[self getChildByTag:kTagSpriteManager];
//	[mgr draw];
	
//	glDisable(GL_TEXTURE_2D);
//	glDisableClientState(GL_VERTEX_ARRAY);
//	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
}

@end


// CLASS IMPLEMENTATIONS
//@implementation AppController

@implementation cocos2d_appAppDelegate

@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];

	// Init the window
	CGRect appRect = [[UIScreen mainScreen] applicationFrame];
	//appRect.origin = CGPointMake( 0.0f , 0.0f );
	window = [[UIWindow alloc] initWithFrame:appRect]; // CGRectInset(appRect, 0.0f, 0.0f) [[UIScreen mainScreen] bounds]
	//window.backgroundColor = [UIColor greenColor];
	[window setUserInteractionEnabled:YES];
	[window setMultipleTouchEnabled:YES];
	
	

	// must be called before any othe call to the director
	//	[Director useFastDirector];
	
	// Attach cocos2d to the window
	[[Director sharedDirector] attachInWindow:window];
	
	// 일단 종으로 보자..
	[[Director sharedDirector] setLandscape: NO];
	
	// display FPS (useful when debugging)
	[[Director sharedDirector] setDisplayFPS:YES];
	
	// frames per second
	[[Director sharedDirector] setAnimationInterval:1.0/60];
	
	// Make the window visible
	[window makeKeyAndVisible];
	
	Scene *scene = [Scene node];
	[scene addChild: [nextAction() node]];
	
	[[Director sharedDirector] runWithScene: scene];
	
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	[[Director sharedDirector] pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[Director sharedDirector] resume];
}

// purge memroy
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[TextureMgr sharedTextureMgr] removeAllTextures];
}

- (void) dealloc
{
	[window release];
	[super dealloc];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[Director sharedDirector] setNextDeltaTimeZero:YES];
}

@end
