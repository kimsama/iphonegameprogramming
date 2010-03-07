/*
 *  game.h
 *  kriel
 *
 *  Created by Hyoun Woo Kim on 09. 10. 24.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

typedef unsigned char byte;

#define CX_STAGE 11
#define CY_STAGE 16

//#define STAGE_SZX 16
//#define STAGE_SZY 11

#define MAX_STAGE    30

#define IMG_FLOOR 0
#define IMG_HERO  2

byte stageDB[CX_STAGE * CY_STAGE * MAX_STAGE];

int getInitHeroX();
int getInitHeroY();

//int heroX;
//int heroY;
//int heroOldX;
//int heroOldY;

void setStage(int i, int x, int y);
byte getStage(int x, int y);
int loadStage(char* fileName);
int readStage(int stageNum);