/*
 *  defines.h
 *  kriel
 *
 *  Created by Hyoun Woo Kim on 09. 10. 26.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#define CX_STAGE 11
#define CY_STAGE 16

#define PX_STAGE_START  40
#define PY_STAGE_START  270//30

#define CX_IMG  20//16
#define CY_IMG  16//20

#define CX_VSBOX  18
#define CY_VSBOX  16
#define PX_VSBOX  ((240 - CX_VSBOX*3)/2 + 2)
#define PY_VSBOX  290 //0

#define CX_CURSOR 14
#define CY_CURSOR 14
#define PX_CURSOR ((240 - CX_CURSOR * 4) / 2)
#define PY_CURSOR 10 // 278 


#define MAX_LIFE  3
#define CX_LIFE  13
#define CY_LIFE  16
#define PX_LIFE  (240 - CX_LIFE * MAX_LIFE - 10)
#define PY_LIFE  290 //0

#define IMG_FLOOR    0
#define IMG_BLOCK    1
#define IMG_HERO     2
#define IMG_SLIME    3
#define IMG_KNIGHT   4
#define IMG_GHOST    5
#define IMG_STICK    6
#define IMG_SWORD    7
#define IMG_CROSS    8
#define IMG_PRINCESS 9
#define IMG_KEY      10
#define IMG_EXIT     11
#define IMG_UP       12
#define IMG_DOWN     13
#define IMG_LEFT     14
#define IMG_RIGHT    15

enum 
{
	tagSpriteManager = 1,
	tagLife = 2,
	
	tagVSBOX = 300, // ~9
	tagStickIcon = 301,
	tagSwordIcon = 302,
	tagCrossIcon = 303,
	tagGuardIcon = 304,
	tagGhostIcon = 305,
	tagSlimeIcon = 306,
	tagEqualIcon = 307,
	
	tagCrush = 400,
	
	tagStage = 500,
	tagHero = 1000
};

enum 
{
	GS_PLAY_HERO_MOVE = 500,
	GS_PLAY = 510,
	GS_ALLCLEAR = 520
};
