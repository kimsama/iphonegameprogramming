
#import "GostopCard.h"

// 초기화 시에 필히 호출 되어야 함   
//    InitCardTypes();
//    InitGostopHands();

@implementation CGostopCard

// 카드 타입 초기화
- (void) InitCardTypes
{
	//카드 타입을 기억하는 벡터
	for(int i = 0; i < CARDTYPE_COUNT; i++)
		m_vCardTypes[i] = [[NSMutableArray alloc] initWithCapacity:10];
	
	//고스톱 족보를 기억하는 벡터
	for(int i = 0; i < HANDS_COUNT ; i++)
		m_vGostopHands[i] = [[NSMutableArray alloc] initWithCapacity:10];
	
	// 플레이어 카드 슬롯 벡터
	for(int i = 0; i <PLAYER_COUNT ; i++)
		m_vPlayerCards[i] = [[NSMutableArray alloc] initWithCapacity:10];
	// 플레이어 획득 카드 슬롯 벡터
	for(int i = 0; i <CARDTYPE_COUNT; i++)
	{
		for(int j =0 ; j <PLAYER_COUNT ; j++)
		{
			m_vObtainedCards[j][i] = [[NSMutableArray alloc] initWithCapacity:40];
		}
	}
    
	
	// 1월 광
	NSNumber *iCntNum = [[NSNumber alloc] initWithInt:4*(1-1)];
	[m_vCardTypes[KWANG] addObject:iCntNum]; 
	
	// 3월 광
	NSNumber *iCntNum2 = [[NSNumber alloc] initWithInt:4*(3-1)];
	[m_vCardTypes[KWANG] addObject:iCntNum2];
    
	// 8월 광
	NSNumber *iCntNum3 = [[NSNumber alloc] initWithInt:4*(8-1)];
	[m_vCardTypes[KWANG] addObject:iCntNum3];
	//NSArray *array = [NSArray arrayWithObjects:iCntNum, iCntNum2, iCntNum3, nil];
	//[m_vCardTypes[KWANG] addObjectsFromArray:array];
    
	// 11월 광
	NSNumber *iCntNum4 = [[NSNumber alloc] initWithInt:4*(11-1)];
	[m_vCardTypes[KWANG] addObject:iCntNum4];

	// 12월 광
	NSNumber *iCntNum5 = [[NSNumber alloc] initWithInt:4*(12-1)];
	[m_vCardTypes[KWANG] addObject:iCntNum5];

	// 열끗
	NSNumber *iCntNum6 = [[NSNumber alloc] initWithInt:4];
	[m_vCardTypes[YEOL] addObject:iCntNum6];

	NSNumber *iCntNum7 = [[NSNumber alloc] initWithInt:12];
	[m_vCardTypes[YEOL] addObject:iCntNum7];

	NSNumber *iCntNum8 = [[NSNumber alloc] initWithInt:16];
	[m_vCardTypes[YEOL] addObject:iCntNum8];

	NSNumber *iCntNum9 = [[NSNumber alloc] initWithInt:20];
	[m_vCardTypes[YEOL] addObject:iCntNum9];

	NSNumber *iCntNum10 = [[NSNumber alloc] initWithInt:24];
	[m_vCardTypes[YEOL] addObject:iCntNum10];

	NSNumber *iCntNum11 = [[NSNumber alloc] initWithInt:29];
	[m_vCardTypes[YEOL] addObject:iCntNum11];

	NSNumber *iCntNum12 = [[NSNumber alloc] initWithInt:KUKJIN];
	[m_vCardTypes[YEOL] addObject:iCntNum12];

	NSNumber *iCntNum13 = [[NSNumber alloc] initWithInt:36];
	[m_vCardTypes[YEOL] addObject:iCntNum13];

	NSNumber *iCntNum14 = [[NSNumber alloc] initWithInt:45];
	[m_vCardTypes[YEOL] addObject:iCntNum14];

	// 띠
	NSNumber *iCntNum15 = [[NSNumber alloc] initWithInt:1];
	[m_vCardTypes[TEE] addObject:iCntNum15];

	NSNumber *iCntNum16 = [[NSNumber alloc] initWithInt:5];
	[m_vCardTypes[TEE] addObject:iCntNum16];

	NSNumber *iCntNum17 = [[NSNumber alloc] initWithInt:9];
	[m_vCardTypes[TEE] addObject:iCntNum17];

	NSNumber *iCntNum18 = [[NSNumber alloc] initWithInt:13];
	[m_vCardTypes[TEE] addObject:iCntNum18];

	NSNumber *iCntNum19 = [[NSNumber alloc] initWithInt:17];
	[m_vCardTypes[TEE] addObject:iCntNum19];

	NSNumber *iCntNum20 = [[NSNumber alloc] initWithInt:21];
	[m_vCardTypes[TEE] addObject:iCntNum20];

	NSNumber *iCntNum21 = [[NSNumber alloc] initWithInt:25];
	[m_vCardTypes[TEE] addObject:iCntNum21];

	NSNumber *iCntNum22 = [[NSNumber alloc] initWithInt:33];
	[m_vCardTypes[TEE] addObject:iCntNum22];

	NSNumber *iCntNum23 = [[NSNumber alloc] initWithInt:37];
	[m_vCardTypes[TEE] addObject:iCntNum23];

	NSNumber *iCntNum24 = [[NSNumber alloc] initWithInt:46];
	[m_vCardTypes[TEE] addObject:iCntNum24];

	
	// 쌍피
	NSNumber *iCntNum25 = [[NSNumber alloc] initWithInt:KUKJIN];
	[m_vCardTypes[PEE] addObject:iCntNum25];

	NSNumber *iCntNum26 = [[NSNumber alloc] initWithInt:41];
	[m_vCardTypes[PEE] addObject:iCntNum26];

	NSNumber *iCntNum27 = [[NSNumber alloc] initWithInt:47];
	[m_vCardTypes[PEE] addObject:iCntNum27];


} // void InitCardTypes(void).
// 족보 배열 초기화
- (void) InitGostopHands
{
	// 홍단
	NSNumber *iCntNum28 = [[NSNumber alloc] initWithInt:1];
	[m_vGostopHands[HONGDAN] addObject:iCntNum28]; 

	NSNumber *iCntNum29 = [[NSNumber alloc] initWithInt:5];
	[m_vGostopHands[HONGDAN] addObject:iCntNum29]; 

	NSNumber *iCntNum30 = [[NSNumber alloc] initWithInt:9];
	[m_vGostopHands[HONGDAN] addObject:iCntNum30]; 

	// 청단
	NSNumber *iCntNum31 = [[NSNumber alloc] initWithInt:21];
	[m_vGostopHands[CHUNGDAN] addObject:iCntNum31]; 

	NSNumber *iCntNum32 = [[NSNumber alloc] initWithInt:41];
	[m_vGostopHands[CHUNGDAN] addObject:iCntNum32]; 

	NSNumber *iCntNum33 = [[NSNumber alloc] initWithInt:46];
	[m_vGostopHands[CHUNGDAN] addObject:iCntNum33]; 

	// 초단
	NSNumber *iCntNum34 = [[NSNumber alloc] initWithInt:13];
	[m_vGostopHands[CHODAN] addObject:iCntNum34]; 

	NSNumber *iCntNum35 = [[NSNumber alloc] initWithInt:17];
	[m_vGostopHands[CHODAN] addObject:iCntNum35]; 

	NSNumber *iCntNum36 = [[NSNumber alloc] initWithInt:25];
	[m_vGostopHands[CHODAN] addObject:iCntNum36]; 

	// 고도리
	NSNumber *iCntNum37 = [[NSNumber alloc] initWithInt:4];
	[m_vGostopHands[GODORI] addObject:iCntNum37]; 

	NSNumber *iCntNum38 = [[NSNumber alloc] initWithInt:12];
	[m_vGostopHands[GODORI] addObject:iCntNum38]; 

	NSNumber *iCntNum39 = [[NSNumber alloc] initWithInt:29];
	[m_vGostopHands[GODORI] addObject:iCntNum39]; 

} // void InitGostopHands(void).

// 초기화
- (void) Init
{
    int iCnt;
	// 플레이어 카드 초기화
    for(iCnt=0; iCnt<PLAYER_COUNT; iCnt++)
    {	// 점수 초기화
        m_nScore[iCnt] = 0;
		// 플레이어 카드 슬롯
		//m_vPlayerCards[iCnt] = [[NSMutableArray alloc] init];
		[m_vPlayerCards[iCnt] removeAllObjects];
		// 획득 카드 슬롯
        //m_vObtainedCards[iCnt][KWANG] = [[NSMutableArray alloc] init];
		[m_vObtainedCards[iCnt][KWANG] removeAllObjects];
        //m_vObtainedCards[iCnt][KWANG].clear();
		//m_vObtainedCards[iCnt][YEOL] = [[NSMutableArray alloc] init];
		[m_vObtainedCards[iCnt][YEOL] removeAllObjects];
        //m_vObtainedCards[iCnt][YEOL].clear();
		//m_vObtainedCards[iCnt][TEE] = [[NSMutableArray alloc] init];
		[m_vObtainedCards[iCnt][TEE] removeAllObjects];
        //m_vObtainedCards[iCnt][TEE].clear();
		//m_vObtainedCards[iCnt][PEE] = [[NSMutableArray alloc] init];
		[m_vObtainedCards[iCnt][PEE] removeAllObjects];
        //m_vObtainedCards[iCnt][PEE].clear();
    }
} // void Init(void).

// 풀레이어 카드 정렬
- (void) SortPlayerCards
{
    [self SortPlayerCards:PLAYER];
    [self SortPlayerCards:OPPONENT];
} // void SortPlayerCards(void).

// 정렬
//static int numbersort (id obj1, id obj2, void *context)
- (int) numbersort:(id)obj1  second:(id)obj2 
{
	NSNumber *int1 = (NSNumber*)obj1;
	NSNumber *int2 = (NSNumber*)obj2;
	
	//NSNumber *int1 = [obj1 lastObject];
	//NSNumber *int2 = [obj2 lastObject];
	
	int int3 = [int1 intValue];
	int int4 = [int2 intValue]; 
	if(int3 < int4)
		return NSOrderedAscending;
	else if(int3 == int4)
		return NSOrderedSame;
	else
		return NSOrderedDescending;
	
}// numbersort
// 특정 플레이어 카드 정렬
- (void) SortPlayerCards:(int)nPlayer
{
	
	int count = [m_vPlayerCards[nPlayer] count];
	
	int i, Sorted;
	Sorted = FALSE;
	while(!Sorted) {
		Sorted = TRUE;
		for(i = 1; i < count; i++) {
			int first = [[m_vPlayerCards[nPlayer] objectAtIndex:i] intValue];
			int second = [[m_vPlayerCards[nPlayer] objectAtIndex:i-1] intValue];
			if(second > first) {
				
				[m_vPlayerCards[nPlayer] exchangeObjectAtIndex:(NSUInteger)i-1 withObjectAtIndex:(NSUInteger)i];
				Sorted = FALSE;
			}
		}
	}
	 
	
} // void SortPlayerCards(int nPlayer).
// 획득 카드 정렬
- (void) SortObtainCards:(int)nPlayer
{
    [self SortObtainCards:(int)nPlayer nCardType:KWANG];
    [self SortObtainCards:(int)nPlayer nCardType:YEOL];
    [self SortObtainCards:(int)nPlayer nCardType:TEE];
    [self SortObtainCards:(int)nPlayer nCardType:PEE];
} // void SortObtainCards(int nPlayer).
// 획득 카드 정렬, 특정 타입
- (void) SortObtainCards:(int)nPlayer  nCardType:(int) nCardType
{
//    sort(m_vObtainedCards[nPlayer][nCardType].begin(), m_vObtainedCards[nPlayer][nCardType].end());
//	[m_vObtainedCards[nPlayer][nCardType] sortUsingFunction:numbersort context:nil];
	int count = [m_vObtainedCards[nPlayer][nCardType] count];
	
	int i, Sorted;
	Sorted = FALSE;
	while(!Sorted) {
		Sorted = TRUE;
		for(i = 1; i < count; i++) {
			int first = [[m_vObtainedCards[nPlayer][nCardType] objectAtIndex:i] intValue];
			int second = [[m_vObtainedCards[nPlayer][nCardType] objectAtIndex:i-1] intValue];
			if(second > first) {
				
				[m_vObtainedCards[nPlayer][nCardType] exchangeObjectAtIndex:(NSUInteger)i-1 withObjectAtIndex:(NSUInteger)i];
				Sorted = FALSE;
			}
		}
	}
	/*
    for(int i = 0; i < count ; i++)
	{
		for(int j = count; j > 0 ; j--)
		{
			//배열이니까
			j--;
			NSNumber *first = [m_vObtainedCards[nPlayer][nCardType] objectAtIndex:i];
			NSNumber *second = [m_vObtainedCards[nPlayer][nCardType] objectAtIndex:j];
			
			if(first == nil && second == nil) 
				continue;
			
			if(first == nil)
			{
				[m_vObtainedCards[nPlayer][nCardType] insertObject:second atIndex:i];
			}else if(second == nil)
			{				
				[m_vObtainedCards[nPlayer][nCardType] insertObject:first atIndex:j];
			}else
			{
				int result = [self numbersort:first second:second ];
				if(result == NSOrderedDescending)
				{
					[m_vObtainedCards[nPlayer][nCardType] exchangeObjectAtIndex:(NSUInteger)i withObjectAtIndex:(NSUInteger)j];
				}
			}
		}
	}
	*/
} // void SortObtainCards(int nPlayer, int nCardType).

// 카드 획득
- (int) ObtainCard:(int) nPlayer  nIdxCard:(int) nIdxCard
{
    int nCardType = [self GetCardType:nIdxCard];

    if( 0 > (nCardType) )
    {
        return NOCARD;
    }

    //m_vObtainedCards[nPlayer][nCardType].push_back(nIdxCard);
	NSNumber *cardnum = [[NSNumber alloc] initWithInt:nIdxCard];
	[m_vObtainedCards[nPlayer][nCardType] addObject:cardnum];

    return nIdxCard;
} // void ObtainCard(int nPlayer, int nIdxCard).
// 카드를 받음
-(void) ReceiveCard:(int)nPlayer  nIdxCard:(int) nIdxCard
{
    //m_vPlayerCards[nPlayer].push_back( nIdxCard );
	NSNumber *cardnum = [[NSNumber alloc] initWithInt:nIdxCard];
	[m_vPlayerCards[nPlayer] addObject:cardnum];

} // void ReceiveCard(int nPlayer, int nIdxCard).

// 피를 획득
- (void) RobPee:(int) nPlayer
{
    int iCnt;
    int nOffsetCard = NOCARD;
    int nOpponent;
	if(nPlayer == PLAYER)
	{
		nOpponent = OPPONENT;
	}else
	{
		nOpponent = PLAYER;
	}
    if(0 >= [self GetObtainedCardCount:(int)nOpponent nCardType:(int)PEE])
    {
		NSLog(@"상대 피가 없음 (%d)",nOpponent);
        return;
    }

	// 획득 카드 정렬
    //SortObtainCards(nPlayer);
	[self SortObtainCards:PLAYER];
    //SortObtainCards(!nPlayer);
	[self SortObtainCards:OPPONENT];

    iCnt = 0;
	// 상대방의 카드를 조사
    while( !( 0 > (nOffsetCard=[self GetObtainedCard:(int)nOpponent nCardType:(int)PEE nOffset:(int)iCnt])) )
    {
		NSLog(@"상대방의 피를 검색중 (%d)",nOffsetCard);
       if( NORMALPEE < [self IsSsangPee:(int)nOffsetCard] )
        {
			NSLog(@"쌍피가 있음 (%d)",nOffsetCard);
            nOffsetCard = NONE;
            iCnt++;
            continue;
        }
		NSLog(@"(%d)번 슬롯에서 일반피 발견 (%d)",iCnt,nOffsetCard);
        nOffsetCard = iCnt;
        break;
    }
    
   
    if( 0 > (nOffsetCard) )
    {
		NSLog(@"일반 피를 발견 못함");
        nOffsetCard = 0;
    }
	int obtaincard = [self GetObtainedCard:nOpponent nCardType:PEE nOffset:nOffsetCard];
	NSLog(@"최종 획득 피 (%d)",obtaincard);
    //ObtainCard(nPlayer, GetObtainedCard(nOpponent, PEE, nOffsetCard));
	
	[self ObtainCard:(int)nPlayer nIdxCard:(int)[self GetObtainedCard:(int)nOpponent nCardType:PEE nOffset:(int)nOffsetCard]];
	m_nRobPeeCard = obtaincard;
	
	// 해당 벡터에서 카드 제거
    //m_vObtainedCards[nOpponent][PEE].erase(m_vObtainedCards[nOpponent][PEE].begin()+nOffsetCard);
	//[m_vObtainedCards[nOpponent][PEE] removeObjectAtIndex:];
	
	[m_vObtainedCards[nOpponent][PEE] removeObjectAtIndex:(int)nOffsetCard];
	
	
	
} // void RobPee(int nPlayer).

// 플레이어의 점수 계산
- (int) FigureOutScore:(int)nPlayer nInitialScore:(int)nInitialScore
{
	// 점수 계산 전에 반드시 정렬이 필요
    //SortObtainCards(nPlayer);
	[self SortObtainCards:(int)nPlayer];
	// 점수 초기화 한다음에,
    m_nScore[nPlayer] = nInitialScore;
	// 기본 게임 규칙 체크,
    //FigureOutGameRuleScore(nPlayer);
	[self FigureOutGameRuleScore:(int)nPlayer];
	// 족보 체크
    //FigureOutGostopHandsScore(nPlayer);
	[self FigureOutGostopHandsScore:(int)nPlayer];
	//
	// 최종적으로 마무리 계산
	//
	// 내가 광을 3장 이상 가지고 있을때,
    if(3 <= (int)[self GetObtainedCardCount:(int)nPlayer nCardType:KWANG])    
	{
		// 상대방이 광을 한장도 안가지고 있다면, 광박
        if(0 ==(int)[self GetObtainedCardCount:(int)!nPlayer nCardType:KWANG])
        {
			// 광박이면, 두배
            m_nScore[nPlayer] *= 2;
        }
    }
	// 내가 피를 10장 이상 가지고 있을때,
    if(10 <= (int)[self GetObtainedCardCount:(int)nPlayer  nCardType:PEE])
    {
		// 상대방이 피를 6장 미만으로 가지고 있다면, 피박
        if(6 > (int)[self GetObtainedCardCount:(int)!nPlayer nCardType:PEE])
        {
			// 피박이면, 두배
            m_nScore[nPlayer] *= 2;
        }
    }
	// 멍따라면,
    if( TRUE == [self IsMungDda:(int)nPlayer] )
    {	// 멍따라면, 기본적으로 두배
        m_nScore[nPlayer] *= 2;
		// 멍따시에 상대방이 열끗이 없다면, 멍박으로 또 두배
        if(0 == [self GetObtainedCardCount:(int)!nPlayer nCardType:YEOL])
        {
            m_nScore[nPlayer] *= 2;
        }
    } // if( TRUE == IsMungDda(nPlayer) ).

    return m_nScore[nPlayer];
} // int FigureOutScore(int nPlayer, int nInitialScore).
// 기본 게임 규칙 점수 연산
- (void) FigureOutGameRuleScore:(int)nPlayer
{
    int iCnt;
    int nCntCards;
	// 광의 갯수에 따른 점수 추가
	//
	NSNumber *iCntNum = [[NSNumber alloc] initWithInt:BIKWANG];
	
    //
    switch( nCntCards=[self GetObtainedCardCount:(int)nPlayer nCardType:KWANG] )
    {
    case 3:
			// 광이 3개 일때 , 비광을 검색후,
			// 비광을 찾았다면,
			
        //if(TRUE == binary_search(m_vObtainedCards[nPlayer][KWANG].begin(), 
         //                        m_vObtainedCards[nPlayer][KWANG].end(), BIKWANG) )
		if(TRUE == [m_vObtainedCards[nPlayer][KWANG] containsObject:iCntNum])
        {
			// 비광 포함 3장이면 2점
            m_nScore[nPlayer] += 2;
            break;
        }
			// 비광이 없다면, 그냥 광의 수 만큼 점수 증가
    case 4:
			// 광의 3개면 3점 , 4개면 4점
        m_nScore[nPlayer] += nCntCards;
        break;

    case 5:
			// 오광이면 15점
        m_nScore[nPlayer] += 15;
        break;
    } // switch( nCntCards=GetObtainedCardCount(nPlayer, KWANG) ).

	// 열끗/띠의 갯수에 따른 점수 추가
    //
    for(iCnt=YEOL; iCnt<=TEE; iCnt++)
    {
		// 열끗, 띠가 5장 이상이라면
        if( 5 <= (nCntCards=[self GetObtainedCardCount:(int)nPlayer nCardType:(int)iCnt]) )
        {
			// 5장부터 1점씩 추가로 받는다.
            m_nScore[nPlayer] += 1+nCntCards-5;
        }
    } // for(jCnt=YEOL; jCnt<=TEE; jCnt++).
	// 피가 10장 이상이라면,
    if( 10 <= (nCntCards=[self GetObtainedPeeCount:(int)nPlayer]) )
    {
		// 피는 10장부터 1점씩 추가로 받는다.
        m_nScore[nPlayer] += 1+nCntCards-10;
    }
} // void FigureOutGameRuleScore(int nPlayer).
// 게임 족보에 따른 규칙 점수 연산
- (void) FigureOutGostopHandsScore:(int)nPlayer
{
    int iCnt;
	bool hasscorecard = TRUE;
    for(iCnt=0; iCnt<=CHODAN; iCnt++)
    {
		// 홍단, 청단, 초단 패를 가지고 있다면
		
        //if( includes(m_vObtainedCards[nPlayer][TEE].begin(), 
        //             m_vObtainedCards[nPlayer][TEE].end(),
        //             m_vGostopHands[iCnt].begin(), m_vGostopHands[iCnt].end()) )
		// 이게 맞는지 모르겠지만 가지고 있는 카드중에 초단 카드가 있는지 검사..
		if(NSNotFound == [m_vObtainedCards[nPlayer][TEE] indexOfObject:(id)[m_vGostopHands[iCnt] objectAtIndex:0] ])
        {
			hasscorecard = FALSE;
            
        }
    }
	if(hasscorecard == TRUE)
	{
		m_nScore[nPlayer] += 3;
	}

	// 고도리 패를 가지고 있다면
//    if( includes(m_vObtainedCards[nPlayer][YEOL].begin(), 
//                 m_vObtainedCards[nPlayer][YEOL].end(),
//                 m_vGostopHands[GODORI].begin(), m_vGostopHands[GODORI].end()) )
	//이거 역시 맞는지 모르겠지만 가지고 있는 카드중에 고도리 카드가 있으면 5점 가산
	if(NSNotFound != [m_vObtainedCards[nPlayer][YEOL] indexOfObject:(id)[m_vGostopHands[GODORI] objectAtIndex:0] ] )
    {

        m_nScore[nPlayer] += 5;
    }
} // void FigureOutGostopHandsScore(int nPlayer).

// 플레이어 보유 카드 추출
-(int) PopPlayerCard:(int) nPlayer  nOffset:(int) nOffset
{
    int nIdxCard;
	// 해당 오프셋에 카드가 없다면
    if([self GetPlayerCardCount:(int)nPlayer] <= nOffset)
    {
		// 카드 없음 리턴
        return NOCARD;
    }
	// 중앙 카드의 맨뒤 카드를 한장 추출
    //nIdxCard = m_vPlayerCards[nPlayer].at(nOffset);
	nIdxCard = (int) [[m_vPlayerCards[nPlayer] objectAtIndex:nOffset] intValue];
	// 해당 카드 인덱스 ㄹ턴
    //m_vPlayerCards[nPlayer].erase( m_vPlayerCards[nPlayer].begin() + nOffset );
	[m_vPlayerCards[nPlayer] removeObjectAtIndex:nOffset];

    return nIdxCard;
} // int PopPlayerCard(int nPlayer, int nOffset).

// 카드 타입 리턴
-(int) GetCardType:(int)nIdxCard
{
    int iCardType;

    if( 0 > (nIdxCard) )
    {
        return NOCARD;
    }
    // 광, 열끗, 띠중에서 검색
    for(iCardType=0; iCardType<CARDTYPE_COUNT-1; iCardType++)
    {
		// 해당 카드 번호를 검색 후,
		// 해당 카드 번호를 카드 타입 스롯에서 찾았다면,
        //if(TRUE == binary_search(m_vCardTypes[iCardType].begin(), m_vCardTypes[iCardType].end(), nIdxCard))
		//NSNumber *idxcard = [[NSNumber alloc] initWithInt:nIdxCard];
		int cnt = [m_vCardTypes[iCardType] count];
		for(int i = 0 ; i < cnt ; i++)
		{
			int intcard = [[m_vCardTypes[iCardType] objectAtIndex:i] intValue];
			if( intcard == nIdxCard)
			{
				return iCardType;				
			}
		}
		
    }
	// 위에서 못찾았다면 , 피
    return PEE;
} // int GetCardType(int nIdxCard).
// 쌍피인지 리턴
-(BOOL) IsSsangPee:(int)nIdxCard
{
   // int iCardType;

    if(BONUSCARD2 == nIdxCard)
    {
        // BONUSCARD2
        return BONUSPEE2;
    }

    if(BONUSCARD3 == nIdxCard)
    {
        // BONUSPEE3 
        return BONUSPEE3;
    }

	if(nIdxCard == KUKJIN || nIdxCard == 41 || nIdxCard == 47)
	{
		return SSANGPEE;
	}
	
	/*
	NSNumber *idxcard = [[NSNumber alloc] initWithInt:nIdxCard];

    if(TRUE == [m_vCardTypes[PEE] containsObject:idxcard])
    {
        return SSANGPEE;
    }
	 */
    return NORMALPEE;
} // BOOL IsSsangPee(int nIdxCard).

// 해당 플레이어 점수 리턴
-(int) GetScore:(int) nPlayer
{
    return m_nScore[nPlayer];
} // int GetScore(int nPlayer).
// 멍따인지 리턴
-(BOOL) IsMungDda:(int) nPlayer
{
    return ([self GetObtainedCardCount:(int)nPlayer nCardType:YEOL] >= 7);
} // BOOL IsMungDda(int nPlayer).
// 총통 여부 체크
-(int) CheckPresident:(int)nPlayer
{
    int iCnt;
    int nCurMonth;
    int nBeginMonth;
    int nLastMonth = NONE;
    int nCntSameMonth = 0;
	// 체크 전 플레이어 카드 정렬
    [self SortPlayerCards:(int)nPlayer];
	// 플레이어 카드의 수 만큼 루프를 돌며 총통패 체크
    for(iCnt=0; iCnt<[self GetPlayerCardCount:(int)nPlayer]; iCnt++)
    {	// 현재 오프셋의 카드가 몇월인지 게산.
        nCurMonth = [self GetPlayerCard:nPlayer nOffset:(int)iCnt]/4;
		// 이전 월과 같은 월이라면,
        if(nLastMonth == nCurMonth)
        {	// 같은 월 카운트.
            nCntSameMonth++;
        }
        else
        {	// 같은 월이 아니라면
			// 카운트 초기화
            nCntSameMonth = 1;
			// 시작 오프셋 기억
            nBeginMonth = iCnt;
			// 현재 월 기억
            nLastMonth = nCurMonth;
        }
		// 같은 월의 카드가 4장 이상이라면,
        if(4 <= nCntSameMonth)
        {
			// 총통
			// 해당 패의 시작 오프셋 리턴
            return nBeginMonth;
        }
    } // for(iCnt=0; iCnt<GetPlayerCardCount(nPlayer); iCnt++).

    return NONE;
} // int CheckPresident(int nPlayer).

// 플레이어 보유 카드 갯수 리턴
- (int) GetPlayerCardCount:(int)nPlayer
{
    return (int)[m_vPlayerCards[nPlayer] count];
} // int GetPlayerCardCount(int nPlayer).
// 플레이어 보유 카드 리턴
-(int) GetPlayerCard:(int)nPlayer nOffset:(int)nOffset
{
    if([self GetPlayerCardCount:(int)nPlayer] <= nOffset)
    {
        return NOCARD;
    }

    return (int)[[m_vPlayerCards[nPlayer] objectAtIndex:(int)nOffset] intValue];
} // int GetPlayerCard(int nPlayer, int nOffset).
// 특정월의 카드를 몇장 가지고 있는지 체크
- (int) GetSameMonthCardsCount:(int)nPlayer nIdxCard:(int) nIdxCard
{
    int iCnt;
    int nCntCards = 0;
    BOOL bFind = FALSE;
    int nMonth = nIdxCard/4;

    for(iCnt=0; iCnt<(int)[m_vPlayerCards[nPlayer] count]; iCnt++)
    {	// 같은 월을 찾았따면
        if((int)[[m_vPlayerCards[nPlayer] objectAtIndex:((iCnt)/4)] intValue] == nMonth)
        {
            if(FALSE == bFind)
            {
                bFind = TRUE;
            }
            // 카드 카운트
            nCntCards++;
        }
        else if(TRUE == bFind)
        {
			// 정렬이 되어 있는 상태이므로,
			// 같은 월이 더이상 안나온다면 뒤에는 더이상 없다.
            break;
        }
    }

    return nCntCards;
} // int GetSameMonthCardsCount(int nPlayer, int nMonth).

// 획득 카드 갯수 리턴
-(int) GetObtainedCardCount:(int)nPlayer nCardType:(int)nCardType
{
	// 해당 타입의 카등의 갯수를 리턴
    return (int)[m_vObtainedCards[nPlayer][nCardType] count];
} // int GetObtainedCardCount(int nPlayer, int nCardType).
// 획득 카드 리턴
-(int) GetObtainedCard:(int) nPlayer nCardType:(int)nCardType nOffset:(int) nOffset
{
	// 해당 오프셋에 카드가 없다면
    if([self GetObtainedCardCount:(int)nPlayer nCardType:(int)nCardType] <= nOffset)
    {
        // 카드 없음 리턴
        return NOCARD;
    }
	// 해당 오프셋의 카드 인덱스 리턴
    return (int)[[m_vObtainedCards[nPlayer][nCardType] objectAtIndex:nOffset] intValue];
	//return nOffset;
} // int GetObtainedCard(int nPlayer, int nCardType, int nOffset).

// 획득 피 장수 리턴
-(int) GetObtainedPeeCount:(int) nPlayer
{
    int iCnt;
	// 피의 기본 갯수를 세고,
    int nCntCards = (int)[m_vObtainedCards[nPlayer][PEE] count];
	// 룹을 돌며 쌍피가 있는지 체크한다.
    for(iCnt=0; iCnt< (int)[m_vObtainedCards[nPlayer][PEE] count]; iCnt++)
    {
		// 쌍피 여부를 검사하고
        switch( [self IsSsangPee:(int)[[m_vObtainedCards[nPlayer][PEE] objectAtIndex:iCnt] intValue]] )
        {
        case SSANGPEE:
        case BONUSPEE2:
				// 쌍피 , 두방 보너스 피면 1장 더 추가
            nCntCards += 1;
            break;

        case BONUSPEE3:
				// 세장 보너스 피면 2장 더 추가
            nCntCards += 2;
            break;
        }
    }
	// 최종적으로 계산된 카드 장수 리턴
    return nCntCards;
} // int GetObtainedPeeCount(int nPlayer).

-(int) GetRobPeeCard
{
	return m_nRobPeeCard;
}


@end