

#import "GostopFloor.h"



@implementation CGostopFloor


// 바닥 초기화
- (void) Init
{
    int iCnt;
	// 각종 변수 초기화
    m_nLastMonth = NONE;
    m_nPutOutMonth = NONE;
    m_nTurnUpMonth = NONE;
	// 카드 덱 초기화	
	m_vCenterCards = [[NSMutableArray alloc] init];
    for(iCnt=0; iCnt<12; iCnt++)
    {
       
		m_vFloorCards[iCnt] = [[NSMutableArray alloc] init];
        m_nPpuckConvict[iCnt] = NONE;
    }
	// 카드 인덱스를 순서대로 넣어줌
    for(iCnt=0; iCnt<GAME_TOTAL_CARD; iCnt++)
    {
		NSNumber *iCntNum = [[NSNumber alloc] initWithInt:iCnt];
		[m_vCenterCards addObject:iCntNum];
    }
	
	
	// 순서대로 배치된 인덱스를 섞어줌
	[self ShuffleCenterCards];
} // void CGostopFloor::Init(void).

// 중앙의 카드를 섞어준다.
- (void) ShuffleCenterCards
{
    srand(time(Nil));
	srandom(time(Nil));
	for(int i = 0 ; i < 400; i++)
	{
		NSUInteger idx1 = random() % 50;
		NSUInteger idx2 = random() % 50;
		
		[m_vCenterCards exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2];
	}

} // void CGostopFloor::ShuffleCenterCards(void).

// 해당 월의 보너스 카드를 갖고 있는지 리턴
// 갖고 있다면 보너스 캬ㅏ드의 오프셋 리턴
- (int) HasBonusCard:(int)nMonth
{
    int iCnt;
	// 바닥에 보너스 카드가 있다면
	// 보너스 카드를 찾아 오프셋 리턴
	int iFloorCardCount = [self GetFloorCardCount:nMonth];
    for(iCnt=0; iCnt < iFloorCardCount; iCnt++)
    {
        NSNumber *numbercard = [m_vFloorCards[nMonth] objectAtIndex:iCnt]; 
		//if( ISBONUSCARD((int)[numbercard intValue]) )
		int nIdxCard = [numbercard intValue];
		if(BONUSCARD2 ==nIdxCard || BONUSCARD3 == nIdxCard)
        {
			return iCnt;
        }
    }
	// 보너스 카드를 찾지 못했다면,
    if(iCnt == iFloorCardCount)
    {
        return NOCARD;
    }
	// 찾았다면, 보너스 카드의 오프셋 리턴
    return iCnt;
} // INT CGostopFloor::HasBonusCard(INT nMonth).

// 바닥에 카드를 그냥 내려 놓음
- (int) AddToFloor:(int)nIdxCard
{	// 붙일 ㅅ 있는 곳을 찾아 붙임
	return [self AddToFloor:nIdxCard nMonth:[self GetAvailableFloorSlot:nIdxCard]];
} // INT CGostopFloor::AddToFloor(INT nIdxCard).
// 바닥에 특정 슬롯에 카드를 내려 놓음
- (int) AddToFloor:(int)nIdxCard nMonth:(int)nMonth
{
    if( 0 > (nIdxCard) )
    {
        return NOCARD;
    }
	//대상의 월을 추가해 넣고
	NSNumber *iCntNum = [[NSNumber alloc] initWithInt:nIdxCard];
	 
	[m_vFloorCards[nMonth] addObject:iCntNum];
	// 카드를 낸 위치를 기억하고
	m_nLastMonth = nMonth;
	// 몇월에 붙였는지 리턴
    return m_nLastMonth;
} // INT CGostopFloor::AddToFloor(INT nIdxCard, INT nMonth).

// 바닥에 카드를 냄
-(int) PutToFloor:(int)nPlayer nIdxCard:(int)nIdxCard
{
    return [self PutToFloor:nPlayer nIdxCard:nIdxCard];
} // INT CGostopFloor::PutToFloor(INT nPlayer, INT nIdxCard).
// 바닥의 특정 슬롯에 카드를 냄
-(int) PutToFloor:(int)nPlayer nIdxCard:(int)nIdxCard nMonth:(int)nMonth
{
    m_nLastMonth = NONE;
    m_nTurnUpMonth = NONE;
	// 카드를 낸 월의 일반 카드 장수가 4장 이상이라면,
	m_nPutOutMonth = [self AddToFloor:nIdxCard nMonth:nMonth];
	
    if( 4 <= [self GetNormalFloorCardCount:m_nPutOutMonth] )
    {
        // 뻑은 먹은 것이므로, 뻑은 먹은 사람과 현재 플레이어가 같다면
        if(nPlayer == m_nPpuckConvict[m_nPutOutMonth]) 
        {	// 해당 슬롯의 뻑 기록 초기화
            m_nPpuckConvict[m_nPutOutMonth] = NONE;
			// 자뻑~!
            return RES_EATJAPPUCK;
        }
        else
        {
			// 해당 슬롯의 뻑 기록 초기화
            m_nPpuckConvict[m_nPutOutMonth] = NONE;
			
			// 아니면 그냥 뻑을 먹은 것임
			// 혹은 바닥에 놓인 3장이 뻑을 한것이 아닐수도 있지만,
			// 그래도 뻑을 먹은 것과 동일하게 처리 해준다.
            return RES_EATPPUCK;
        }
    }
	// 그외에는 아무것도 리턴하지 않는다.
    return NONE;
} // INT CGostopFloor::PutToFloor(INT nPlayer, INT nIdxCard, INT nMonth).
// 정렬
- (int) numbersort:(id)obj1  second:(id)obj2 
{
	NSNumber *int1 = (NSNumber*)obj1;
	NSNumber *int2 = (NSNumber*)obj2;
	
	int int3 = [int1 intValue];
	int int4 = [int2 intValue]; 
	if(int3 < int4)
		return NSOrderedAscending;
	else if(int3 == int4)
		return NSOrderedSame;
	else
		return NSOrderedDescending;
	
}// numbersort

// 바닥 장렬
- (void) SortFloor:(int)nMonth
{
	
	int count = [m_vFloorCards[nMonth] count];
	int i, Sorted;
	Sorted = FALSE;
	while(!Sorted) {
		Sorted = TRUE;
		for(i = 1; i < count; i++) {
			int first = [[m_vFloorCards[nMonth] objectAtIndex:i] intValue];
			int second = [[m_vFloorCards[nMonth] objectAtIndex:i-1] intValue];
			if(second > first) {
				
				[m_vFloorCards[nMonth] exchangeObjectAtIndex:(NSUInteger)i-1 withObjectAtIndex:(NSUInteger)i];
				Sorted = FALSE;
			}
		}
	}
	
} // void CGostopFloor::SortFloor(INT nMonth).



// 센터 카드 한장 추출
- (int) PopCenterCard
{
    int nIdxCard;
	// 중앙에 쌓여 있는 카드가 없다면
    if([self GetCenterCardCount] <= 0)
    {	// 카드 없음 리턴
        return NOCARD;
    }
	// 중앙 카드의 맨 뒤 카드를 한장 추출
	NSNumber *lastcard = [m_vCenterCards lastObject];
	nIdxCard = (int)[lastcard intValue];
		
	[m_vCenterCards removeLastObject];
	// 카드 번호 리턴
    return nIdxCard;
} // INT CGostopFloor::PopCenterCard(void).
// 해당 월의 맨 마지막 카드 획득
- (int) PopFloorCard:(int)nMonth
{
    int nIdxCard;
	// 바닥에 놓인 장수보다 적으면 없다~
    if(0 >= [self GetFloorCardCount:nMonth])
    {
        return NOCARD;
    }
	// 중앙 카드의 맨 뒤 카드를 한 장 추출
	NSNumber *card = [m_vFloorCards[nMonth] lastObject];
    nIdxCard = (int)[card intValue];
    //m_vFloorCards[nMonth].pop_back();
	[m_vFloorCards[nMonth] removeLastObject];
	// 카드 번호 리턴
    return nIdxCard;
} // INT CGostopFloor::PopFloorCard(INT nMonth).
// 특정 바닥 카드 획득
- (int) PopFloorCard:(int)nMonth byOffset:(Byte)byOffset
{
    int nIdxCard;
	// 바닥에 놓인 장수보다 적으면 
    if(byOffset >= [self GetFloorCardCount:nMonth])
    {
        return NOCARD;
    }
	NSNumber *card = [m_vFloorCards[nMonth] objectAtIndex:byOffset];
    nIdxCard = (int)[card intValue];
    //m_vFloorCards[nMonth].erase(m_vFloorCards[nMonth].begin()+byOffset);
	[m_vFloorCards[nMonth] removeObjectAtIndex:byOffset];
	
    return nIdxCard;
} // INT CGostopFloor::PopFloorCard(INT nMonth, BYTE byOffset).

// 보너스 카드 획득
- (int) PopBonusCard:(int)nMonth
{
    int nOffset;
    int nIdxCard;
	// 보너스 카드가 있는 오프셋을 구하고
    nOffset = [self HasBonusCard:nMonth];
	// 해당 월에 보너스 카드가 없다면
    if( 0 > (nOffset) )
    {
        return NOCARD;
    }
	// ㅋ드 인덱스를 기억한 후
    //nIdxCard = m_vFloorCards[nMonth].at(nOffset);
    //m_vFloorCards[nMonth].erase(m_vFloorCards[nMonth].begin() + nOffset);
	NSNumber *card = [m_vFloorCards[nMonth] objectAtIndex:nOffset];
    nIdxCard = (int)[card intValue];
	// 해당 슬롯에서 카드 제거
	[m_vFloorCards[nMonth] removeObjectAtIndex:nOffset];
	
	
    return nIdxCard;
} // INT CGostopFloor::PopBonusCard(INT nMonth).

// 센터 카드 장수 리턴
- (int) GetCenterCardCount
{
    return [m_vCenterCards count];
} // INT CGostopFloor::GetCenterCardCount(void).

//센터 카드 리턴
- (int) GetCenterCard:(int)index
{
	return (int)[[m_vCenterCards objectAtIndex:index] intValue];
}

// 바닥 카드 장수 리턴
- (int) GetFloorCardCount:(int)nMonth
{
    return [m_vFloorCards[nMonth] count];
} // INT CGostopFloor::GetFloorCardCount(INT nMonth).
// 바닥 카드 리턴
- (int) GetFloorCard:(int)nMonth byOffset:(Byte) byOffset
{
    if(byOffset >= [self GetFloorCardCount:nMonth])
    {
        return NOCARD;
    }
	
    return (int)[[m_vFloorCards[nMonth] objectAtIndex:byOffset] intValue] ;
} // INT CGostopFloor::GetFloorCard(INT nMonth, BYTE byOffset).
// 일반 바닥카드 장수 리턴
- (int) GetNormalFloorCardCount:(int)nMonth
{
    return [self GetFloorCardCount:nMonth] - [self GetBonusCardCount:nMonth];
} // INT CGostopFloor::GetNormalFloorCardCount(INT nMonth).

// 해당 월의 보너스 카드 장수 리턴
- (int) GetBonusCardCount:(int)nMonth
{
    int iCnt;
    int nCntBonusCard = 0;
	// 바닥에 보너스 카드가 있따면, 장수 카운트,
    for(iCnt=0; iCnt<[self GetFloorCardCount:nMonth]; iCnt++)
    {
		//보너스 카드라면 
        //if( ISBONUSCARD((int)[[m_vFloorCards[nMonth] objectAtIndex:iCnt] intValue]) )
		int nIdxCard = 	(int)[[m_vFloorCards[nMonth] objectAtIndex:iCnt] intValue];
		if((BONUSCARD2 == (nIdxCard)) || (BONUSCARD3 == (nIdxCard)))	
        {	// 카운트
            nCntBonusCard++;
        }
    }
	// 보너스 카드의 장수 리턴
    return nCntBonusCard;
} // INT CGostopFloor::GetBonusCardCount(INT nMonth).

// 해당 카드가 붙게 될 바닥 슬롯
- (int) GetAvailableFloorSlot:(int)nIdxCard
{
    int iCnt;
    int nTargetMonth = NONE;
    BOOL bBonusCard = FALSE;// = ISBONUSCARD( nIdxCard );
	
	if((BONUSCARD2 == (nIdxCard)) || (BONUSCARD3 == (nIdxCard)))
	{
		bBonusCard = TRUE;
	}
	// 이전에 낸 카드 위치가 저장되어 있고, 보너스 카드라면,
    if( TRUE == bBonusCard && NONE != m_nLastMonth )
    {	// 이전에 낸 위치에 붙인다.
        nTargetMonth = m_nLastMonth;
    }
    else
    {	// 바닥의 카드 중에 같은 우러을 갖은 패가 있는지 검색
        for(iCnt=0; iCnt< 12; iCnt++)
        {
			int count = [self GetFloorCardCount:iCnt];
			// 카드가 있는 월이 있다면
            if(count > 0)
            {
				// 바닥에 가튼 월이 있다면,
				
				for(int i = 0; i < count; i++)
				{
					int Card = [self GetFloorCard:iCnt byOffset:(Byte)i];
					if(Card/4 == nIdxCard/4)
					{
						NSLog(@"바닥에 같은 월이 있다, 바닥:%d , 뒤집은 카드:%d, 월:%d",Card,nIdxCard,iCnt);
						nTargetMonth = iCnt;
						return nTargetMonth;
						// 아직 낼 곳을 결정하지 못한 경우, 보너스 카드만 쌓인 곳을 발견했다면,
					}else if(BONUSCARD2 == Card || BONUSCARD3 == Card )
					{
						if(0 == [self GetNormalFloorCardCount:iCnt])
						{
							NSLog(@"보너스 카드만 있다, 바닥:%d , 뒤집은 카드:%d, 월:%d",Card,nIdxCard,iCnt);							
							nTargetMonth = iCnt;
							continue;
						}
					}
				}
              
            }//if(count > 0)
            else if(NONE == nTargetMonth)
            {
				// 빈 월을 찾았다면, 기억해 둔다.
				NSLog(@"빈 바닥을 찾았다, 뒤집은 카드:%d, 월:%d",nIdxCard,iCnt);
                nTargetMonth = iCnt;
            }
        } // for(iCnt=0; iCnt<12; iCnt++).
    }
	// 타겟 월을 찾지 못했다면
    if( 0 > (nTargetMonth) )
    {
		//일반 카드는 이런일이 일어날 일이 없다.
		//그러나 보너스 카드의 경우 아주 극히 드문 확률로
		//이런 일이 발생할수도 있다. 그때를 위한 예외 처리
		NSLog(@"타겟 월을 찾지 못했다, , 뒤집은 카드:%d, 월:%d",nIdxCard,iCnt);
        nTargetMonth = 0;
    }
	// 해당 슬롯 번호 월를 리턴
    return nTargetMonth;
} // INT CGostopFloor::GetAvailableFloorSlot(INT nIdxCard).

// 카드를 낸 월 리턴
- (int) GetPutOutMonth
{
    return m_nPutOutMonth;
} // INT CGostopFloor::GetPutOutMonth(void).
// 카드를 뒤집어 낸 월 리턴
- (int) GetTurnUpMonth
{
    return m_nTurnUpMonth;
} // INT CGostopFloor::GetTurnUpMonth(void).

- (int) SetPutOutMonth:(int)nMonth
{
	m_nPutOutMonth = nMonth;
	return m_nPutOutMonth;
}

- (int) SetTurnUpMonth:(int)nMonth
{
	m_nTurnUpMonth = nMonth;
	return m_nTurnUpMonth;
}

- (int) GetPpuckConvict:(int)nMonth
{
	return m_nPpuckConvict[nMonth];
}

- (int) SetPpuckConvict:(int)nMonth nSet:(int)nSet
{
	m_nPpuckConvict[nMonth] = nSet;
	
	return m_nPpuckConvict[nMonth];
}

@end
