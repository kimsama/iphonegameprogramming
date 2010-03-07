/*
 *  game.c
 *  kriel
 *
 *  Created by Hyoun Woo Kim on 09. 10. 24.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#include <stdio.h>
#include "game.h"

#define STAGE_FILENAME "STAGE.DAT"


unsigned char stage[CX_STAGE][CY_STAGE];

// hero's start postion
int hero_sx = 0;
int hero_sy = 0;

/**
 */
int getHeroInitX()
{
	return hero_sx; 
}

/**
 */
int getHeroInitY()
{
	return hero_sy;
}

/**
 */
void setStage(int i, int x, int y)
{
	if (x >= 0 && y >=0)
	    stage[x][y] = i;	
}

/**
     get index from the given (x, y)
 */
byte getStage(int x, int y)
{
	byte ret;
	
	if (x >= 0 && y >=0)
	    ret = stage[x][y];
	else
		ret = stage[0][0];
	
	return ret;
}

/**
     load all stage info from stage file.
 */
int loadStage(char* fileName)
{
	
	FILE* stageFile;
	
	stageFile = fopen(fileName, "rb");
	if (stageFile)
	{
		/*
		fseek(stageFile, CX_STAGE * CY_STAGE * stageNum, SEEK_SET);
		
		for (int j=0; j<CY_STAGE; j++)
		{
			for (int i=0; i<CX_STAGE; i++)
			{
				stage[i][j] = getc(stageFile);
			}
		}
		*/
		for (int i=0; i<CX_STAGE * CY_STAGE * MAX_STAGE; i++)
		{
			stageDB[i] = getc(stageFile);
		}
		
		fclose(stageFile);
	}
	
	return 0;
}

/**
     read a stage info.
 */
int readStage(int stageNum)
{
	int x, y;
	int nSkip = stageNum * CX_STAGE * CY_STAGE;
	
	for (x=0; x<CX_STAGE; x++)
	{
		for (y=0; y<CY_STAGE; y++)
		{
			stage[x][y] = stageDB[nSkip++];
		}
	}
	
	for (y=0; y<CY_STAGE; y++)
	{
		for (x=0; x<CX_STAGE; x++)
		{
			if (stage[x][y] == IMG_HERO)
			{
				stage[x][y] = IMG_FLOOR;
				
				//heroX = x;
				//heroY = y;
				//heroOldX = x;
				//heroOldY = y;
				hero_sx = x;
				hero_sy = y;
			}
		}
	}
}
