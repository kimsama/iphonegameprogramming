#import "GostopAgent.h"


@implementation CGostopAgent
// 새 게임 시작
- (void) StartNewGame
{
    [self ChangeState:(int)GS_START_NEWGAME];
} // void StartNewGame(void).


- (void) SetAtlasspritemgr:(AtlasSpriteManager*)mgr
{
	m_atlasmgr = mgr;
}

// 게임 초기화
- (void) InitGame
{
    int iCnt, jCnt;
	m_bAnimEvent = false;
	m_bPickUpCard = false;
	
	// 뺏어올 피 장수 초기화
    m_nCntRobPee = 0;
	
	m_nTurnUpCardMonth = 0;
	
	m_sbonuscardinfo.nMonth = 0;
	m_sbonuscardinfo.nCount = 0;
	
	if(m_bFirstStart == FALSE)
	{
		MoveCards = [[NSMutableArray alloc] initWithCapacity:20];
		
		Movepoint = CGPointMake( 0, 0 );
		
		// 카드 초기화
		m_Card = [[CGostopCard alloc] init];
		[m_Card InitCardTypes];
		[m_Card InitGostopHands];
		[m_Card Init];
		
		// 바닥 초기화
		m_Floor = [[CGostopFloor alloc] init];
		[m_Floor Init];
		
		m_bFirstStart  = TRUE;
	}else
	{
		//플레이어 카드 및 획득 카드 정보 초기화
		[m_Card Init];
		[m_Floor Init];
	}
	
    
	
	
    
	
    // 플레이어 수 만큼 룹을 돌며 초기화
    for(iCnt=0; iCnt<PLAYER_COUNT; iCnt++)
    {
        // 점수 초기화
        m_nScore[iCnt] = 0;

        // 규칙 수 만큼 룹을 돌며 초기화
        for(jCnt=0; jCnt<RULE_COUNT; jCnt++)
        {
            // 규칙 횟수 카운트 초기화
            m_nCntRule[iCnt][jCnt];
        }
    }

    // 기본선은 플레이어
    //SetTurn(PLAYER);
	[self SetTurn:(int)PLAYER];
	
	
} // void InitGame(void).
// 타이머 함수 실행
- (void) StartTimerfunc
{
	[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(DoAgency:) userInfo:nil repeats:YES];
	
}
- (void) SetFirstStartGame:(bool) set
{
	m_bFirstStart = set;
}
// 게임 상태 변경
- (void) ChangeState:(int) nGameState
{
    // 에이전시 스텝 초기화
    m_nAgencyStep = 0;

    // 상태 변경
    m_nGameState = nGameState;

    // 상태에 따른 이벤트 처리
    switch(nGameState)
    {
    // 새로운 게임 시작
    case GS_START_NEWGAME:
        //InitGame();
			
		[self InitGame];	
        break;

    // 턴 변경
    case GS_CHANGETURN:
        break;

    // 게임 진행 모드
    case GS_PLAYING:
        m_nShakingMode = NONE;
        m_nIdxPutOutCard = NOCARD;
        m_nAvailableFloorSlot = NONE;
        break;
    }
} // void ChangeState(int nGameState).


// 게임 진행
- (void) DoAgency :(NSTimer*)Timer
{
    switch(m_nGameState)
    {
			// 게임 시작
    case GS_START_NEWGAME:
			
			NSLog(@"new game start");

			[self ChangeState:GS_DISTRIBUTE];
        break;

			// 게임 시작 후 카드 분배
    case GS_DISTRIBUTE:
			// 카드 분배	
//        DealDistributeCards();
			[self DealDistributeCards];
        break;

			// 카드를 바닥에 냄
    case GS_PUTOUT_PLAYERCARD:
			// 카드를 바닥에 내는 것의 단곕ㄹ 처리
//        DealPutOutPlayerCards();
			[self DealPutOutPlayerCards];
        break;

			// 턴 변경
    case GS_CHANGETURN:
			// 턴 변경 단계별 처리
//        DealChangeTurn();
			[self DealChangeTurn];
        break;
    }
} // void DoAgency().


- (void) MovingCard:(int)nIdxCard startpoint:(CGPoint)startpoint endpoint:(CGPoint)endpoint
{
	
	//NSLog(@"%d번 플레이어가 %d번 카드를 %f ,%f 에서 %f , %f 로 이동시켰따~!!!",[self GetTurn], nIdxCard , startpoint.x , startpoint.y , endpoint.x , endpoint.y);
	AtlasSprite *Card = (AtlasSprite*)[m_atlasmgr getChildByTag:nIdxCard];
	Card.position = startpoint;
		
	id actionTo = [MoveTo actionWithDuration:ANIMTIME position:ccp( endpoint.x, endpoint.y)];
	[Card runAction:actionTo];
}
- (bool) IsMoving:(int)nIdxCard point:(CGPoint)point
{
	AtlasSprite *Card = (AtlasSprite*)[m_atlasmgr getChildByTag:nIdxCard];
	if(Card.position.x == point.x && Card.position.y == point.y)
	{
		return false;
	}
	
	return true;
}
// 카드 분배 처리
- (void) DealDistributeCards
{
    int iCnt;
	//int count = 0;
	//int slot = 1;
	//int i = 0;
	int nIdxCard;
	int nMonth;
	//int nCntPickedUp =0;

    switch(m_nAgencyStep)
    {
			// 처음엔 잠시 대기
    case DC_READY:
        break;

			// 바닥에 카드 분배
    case DC_FLOORCARDS_FIRST:
			
		
		// 바닥에 까는 카드중 반을 낸다.
        for(iCnt=0; iCnt<DISTRIBUTE_FLOOR_CARDS/2; iCnt++)
        {
			nIdxCard = [self PopCenterCard];
			nMonth = [m_Floor GetAvailableFloorSlot:nIdxCard];
			// 바닥에 카드 추가
			[m_Floor AddToFloor:nIdxCard nMonth:nMonth];
			[self MovingCard:nIdxCard startpoint:[self Getm_coFloorCards:0] endpoint:[self Getm_coFloorCards:nMonth+1]];
			[self PlaySound:SND_GET];
			
        }        
        break;
		
    case DC_FLOORCARDS_SECOND:
			// 바닥에 까는 카드중 나머지 반을 낸다.
			for(iCnt=0; iCnt<DISTRIBUTE_FLOOR_CARDS/2; iCnt++)
			{
				nIdxCard = [self PopCenterCard];
				nMonth = [m_Floor GetAvailableFloorSlot:nIdxCard];
				// 바닥에 카드 추가
				[m_Floor AddToFloor:nIdxCard nMonth:nMonth];
				[self MovingCard:nIdxCard startpoint:[self Getm_coFloorCards:0] endpoint:[self Getm_coFloorCards:nMonth+1]];
				[self PlaySound:SND_GET];				
			}        
			break;

    case DC_PLAYERCARDS_FIRST:
			// 나눠주야할 카드중 반을 준다.
			
			for(iCnt=0; iCnt<DISTRIBUTE_PLAYER_CARDS/2; iCnt++)
			{
				nIdxCard = [self PopCenterCard];
				NSLog(@"플레이어 카드 %d번째는 %d",iCnt,nIdxCard);
				// 플레이어에 카드 추가
				[m_Card ReceiveCard:PLAYER nIdxCard:nIdxCard];
				[self MovingCard:nIdxCard startpoint:[self Getm_coFloorCards:0] endpoint:[self Getm_coPlayerCards:PLAYER index2:iCnt]];
				[self PlaySound:SND_GET];				
			}        
			break;
		
    case DC_OPPONENTCARDS_FIRST:
			// 상대방에게 카드중 반을 준다.
			
			for(iCnt=0; iCnt<DISTRIBUTE_PLAYER_CARDS/2; iCnt++)
			{
				nIdxCard = [self PopCenterCard];
				NSLog(@"상대방 카드 %d번째는 %d",iCnt,nIdxCard);
				// 상대방에 카드 추가
				[m_Card ReceiveCard:OPPONENT nIdxCard:nIdxCard];
				[self MovingCard:nIdxCard startpoint:[self Getm_coFloorCards:0] endpoint:[self Getm_coPlayerCards:OPPONENT index2:iCnt]];
				[self PlaySound:SND_GET];				
			}        
			break;
			
    case DC_PLAYERCARDS_SECOND:
			// 플레이어에게 나머지 반을 준다.
			
			for(iCnt=0; iCnt<DISTRIBUTE_PLAYER_CARDS/2+DISTRIBUTE_PLAYER_CARDS%2; iCnt++)
			{
				nIdxCard = [self PopCenterCard];
				NSLog(@"플레이어 카드 %d번째는 %d",iCnt+5,nIdxCard);
				// 플레이어에 카드 추가
				[m_Card ReceiveCard:PLAYER nIdxCard:nIdxCard];
				[self MovingCard:nIdxCard startpoint:[self Getm_coFloorCards:0] endpoint:[self Getm_coPlayerCards:PLAYER index2:iCnt+5]];
				[self PlaySound:SND_GET];				
			}        
			break;

    case DC_OPPONENTCARDS_SECOND:
			// 상대방에게 카드중 반을 준다.
			
			for(iCnt=0; iCnt<DISTRIBUTE_PLAYER_CARDS/2+DISTRIBUTE_PLAYER_CARDS%2; iCnt++)
			{
				nIdxCard = [self PopCenterCard];
				NSLog(@"상대방 카드 %d번째는 %d",iCnt+5,nIdxCard);
				// 상대방에 카드 추가
				[m_Card ReceiveCard:OPPONENT nIdxCard:nIdxCard];
				[self MovingCard:nIdxCard startpoint:[self Getm_coFloorCards:0] endpoint:[self Getm_coPlayerCards:OPPONENT index2:iCnt+5]];
				[self PlaySound:SND_GET];				
			}        
			break;


    case DC_SORT_CARDS:

		
		// 플레이어들의 카드를 정렬한다.
		[m_Card SortPlayerCards];

		// 바닥에 카드를 정렬
        for(iCnt=0; iCnt<12; iCnt++)
        {
			[m_Floor SortFloor:iCnt];
        }
		
		[self DrawAll];
			
        break;

    case DC_PICKUP_BONUSCARDS:
			// 바닥에서 보너스 피를 추출
			[self DealPickUpBonusCards];

        break;


    case DC_CHECK_PRESIDENT:
			// 총통 검사
        if(TRUE == [self DealCheckPresident])
        {
			NSLog(@"총통입니다.~!");
            // 3초 대기
			sleep(1);

			// 새게임 시작	
            [self StartNewGame];
        }
        break;

    case DC_FINISH:
        // 플레이 상태로 변경
			[self ChangeState:GS_PLAYING];

        
        return;
    }

   if(!m_bAnimEvent)
	{
		m_nAgencyStep++;
	}
} // void DealDistributeCards().

// 보너스 카드 픽업
- (void) DealPickUpBonusCards
{
    int iCnt;
    int nCntPickedUp;
    int nIdxCard;
	int nMonth;
    do
    {
        nCntPickedUp = 0;

		// 바닥에서 보너스 카드를 추출
        for(iCnt=0; iCnt<12; iCnt++)
        {
			// 보너스 카드가 있는 월을 찾았다면
            while( !(0 > (nIdxCard=[m_Floor PopBonusCard:iCnt])) )
            {
				NSLog(@"첫턴 보너스 카드 가져감 %d",nIdxCard);
				// 첫턴이 보너스 카드를 가져감	
                [self ObtainCard:nIdxCard];
				[self MovingCard:nIdxCard startpoint:[self Getm_coFloorCards:iCnt+1] endpoint:[self Getm_coObtainedCards:[self GetTurn] index2:PEE]];
				// 픽업 카운트
                nCntPickedUp++;
            }
        }

		// 픽업 카드를 먹은 만큼 루프를 돌며
        for(iCnt=0; iCnt<nCntPickedUp; iCnt++)
        {
			// 바닥에 새 카드를 붙여 넣는다.
            //[m_Floor  AddToFloor:[self PopCenterCard]];
			nIdxCard = [self PopCenterCard];
			nMonth = [m_Floor GetAvailableFloorSlot:nIdxCard];
			// 바닥에 카드 추가
			[m_Floor AddToFloor:nIdxCard nMonth:nMonth];
			[self MovingCard:nIdxCard startpoint:[self Getm_coFloorCards:0] endpoint:[self Getm_coFloorCards:nMonth+1]];
			
        }
    } while(nCntPickedUp > 0);
} // void DealPickUpBonusCards().

// 플레이어 카드와 바닥에서 총통 체크
- (BOOL) DealCheckPresident
{
    int iCnt;
    int nResult;

    //
	// 먼저 바닥에서 총통을 체크
    //
    for(iCnt=0; iCnt<12; iCnt++)
    {
		// 바닥에 4장 이상의 같은 월의 카드가 있다면
        if(4 <= [m_Floor GetNormalFloorCardCount:iCnt])
        {
			NSLog(@"바닥 %d번 슬롯 총통!",iCnt);


			// 총통이다
            return TRUE;
        }
    } // for(iCnt=0; iCnt<12; iCnt++).

    //
	// 플레이어 카드에서 총통을 체크
    //
    for(iCnt=0; iCnt<PLAYER_COUNT; iCnt++)
    {
		// 총통을 체크
        nResult = [m_Card CheckPresident:iCnt ];

		// 총통을 발견했다면
        if( NONE != nResult )
        {
			NSLog(@"%d번 플레이어 %d월의 총통입니다.~!",iCnt, [m_Card GetPlayerCard:iCnt nOffset:nResult]/4);



			// 총통
            return TRUE;
        }
    }

	// 총통 패를 발견 못함
    return FALSE;
} // BOOL DealCheckPresident(void).


// 플레이어 카드를 바닥에 내는 것 처리
- (void) DealPutOutPlayerCards
{
    int iCnt;
    int nPutOutMonth = [m_Floor GetPutOutMonth];
    int nTurnUpMonth = [m_Floor GetTurnUpMonth];
	int turn = [self GetTurn];
	int nIdxCard;
    switch(m_nAgencyStep)
    {
    case PO_PICKUP:
			// 낼 카드를 고름
			// 플레이어 슬롯에서 해당 카드를 빼고,
		if( 0 > (m_nIdxPutOutCard = [m_Card PopPlayerCard:turn  nOffset:m_nGSParam1]))
        {
			//해당 슬롯에 카드가 없다면 아무것도 하지 않음
			[self ChangeState:GS_PLAYING];
            return;
        } // if( ISNOCARD(m_nIdxPutOutCard = m_Card.PopPlayerCard(GetTurn(), m_nGSParam1)) ).

		if([self GetTurn] == PLAYER)
		{  
			NSLog(@"플레이어가 바닥에 카드를 냄 (%d)",m_nIdxPutOutCard);
		}else
		{
			NSLog(@"상대가 바닥에 카드를 냄 (%d)",m_nIdxPutOutCard);
		}
			
		// 폭탄 카드라면
        if( (BOMBCARD) ==(m_nIdxPutOutCard) )
        {
			// 폭탄 카드는 바닥에 내는 카드가 아니므로,
			// 빈 카드를 바닥에 붙여 초기화 시킨 후,
            [m_Floor PutToFloor:turn nIdxCard:NOCARD];
			// 그냥 바로 중앙 카드 뒤집기로 간다.	
            m_nAgencyStep = PO_TURNUP;	
            return;
        } // if( ISBOMBCARD(m_nIdxPutOutCard) ).
			
		// 보너스 카드라면
		if((BONUSCARD2 == (m_nIdxPutOutCard)) || (BONUSCARD3 == (m_nIdxPutOutCard)))
        {	// 그냥 플레이어가 획득
            [self ObtainCard:m_nIdxPutOutCard];
			int type = [m_Card GetCardType:m_nIdxPutOutCard];
			[self MovingCard:m_nIdxPutOutCard startpoint:[self Getm_coPlayerCards:turn index2:m_nGSParam1] endpoint:[self Getm_coObtainedCards:turn index2:type]];
			
			// 중앙의 카드를 뒤집어서 플레이어가 가져감
            //[m_Card ReceiveCard:turn  nIdxCard:[m_Floor PopCenterCard]];
			nIdxCard = [m_Floor PopCenterCard];
			
			// 플레이어에 카드 추가
			[m_Card ReceiveCard:turn nIdxCard:nIdxCard];
			[self MovingCard:nIdxCard startpoint:[self Getm_coFloorCards:0] endpoint:[self Getm_coPlayerCards:turn index2:m_nGSParam1]];
			
			// 해당 플레이어 카드 정렬
            [m_Card SortPlayerCards:turn];
			// 그냥 플레이 상태로 돌아감
            [self ChangeState:GS_PLAYING];
            return;
        } // if( ISBONUSCARD(m_nIdxPutOutCard) ).
			
			// 몇월에 붙일 수 있는 지 체크
			m_nAvailableFloorSlot = [m_Floor GetAvailableFloorSlot:m_nIdxPutOutCard];
        break;
			
    case PO_CHECKSHAKE:
        m_nShakingMode = PM_NORMAL; // 기본 값 - 일반 모드
			// 흔들 수 있는 상태 인지 체크 후,
		if( 2 <= [m_Card GetSameMonthCardsCount:(int)[self GetTurn]  nIdxCard:m_nIdxPutOutCard] )
        {
			// 원래는 바로 흔드는 것이 아니라 
			// 흔들 것인지 물어보아야 한다.
			// 아직 미구현이므로 일단 무조건 흔들자
            m_nShakingMode = PM_SHAKE;
			// 내려는 슬롯에 같은 월의 카드가 존재하는 지 체크
            for(iCnt=0; iCnt<[self GetFloorCardCount:m_nAvailableFloorSlot]; iCnt++)
            {
				//같은 월의 카드를 발견했다면,
				Byte offset = iCnt /4 ;
				if([m_Floor GetFloorCard:m_nAvailableFloorSlot byOffset:offset] == m_nIdxPutOutCard/4)
                {	//폭탄
                    m_nShakingMode = PM_BOMB;
                    break;
                }
            }
        }
        break;

    case PO_PUTOUT:
			// 픽업한 카드를 바닥에 낸다.
		if(m_bAnimEvent == false)
		{
			Movepoint = [self Getm_coFloorCards:m_nAvailableFloorSlot+1];
			[self MovingCard:m_nIdxPutOutCard startpoint:[self Getm_coPlayerCards:turn index2:m_nGSParam1] endpoint:Movepoint];	
			m_bAnimEvent = true;
		
			switch( [m_Floor PutToFloor:[self GetTurn] nIdxCard:m_nIdxPutOutCard nMonth:m_nAvailableFloorSlot] )
			{
				// 뻑을 먹었다면
				case RES_EATPPUCK:
					NSLog(@"뻑먹음 1장");
					m_nCntRobPee += 1;
					break;
				// 자기가 싼 뻑을 먺었다면
				case RES_EATJAPPUCK:
					NSLog(@"자뻑먹음");
					m_nCntRobPee += 2;
					break;
			} // switch( m_Floor.PutToFloor(GetTurn(), m_nIdxPutOutCard, m_nAvailableFloorSlot) ).
			// 흔듬/ 폭탄 처리
			switch(m_nShakingMode)
			{
			case PM_SHAKE:
				break;

			case PM_BOMB:
				// 루프를 돌며 같은 월이 있는 첫번째 인덱스를 검색
				for(iCnt=0; iCnt<[self GetPlayerCardCount]; iCnt++)
				{	// 같은 월을 찾았다면
					if([self GetPlayerCard:(iCnt)/4] == m_nIdxPutOutCard/4)
					{	// 루프를 벗어남
						break;
					}
				}
				// 같은 월의 카드를 모두 냄
				while([self GetPlayerCard:(iCnt)/4] == m_nIdxPutOutCard/4)
				{	// 바닥의 방금 낸 슬롯에 해당 카드를 한번 더 냄
					// 특별히 처리할 것이 없으므로, 한번 더 낸다.
					nIdxCard = [m_Card PopPlayerCard:[self GetTurn] nOffset:iCnt];
					[m_Floor AddToFloor:nIdxCard nMonth:m_nAvailableFloorSlot ];
					[self MovingCard:nIdxCard startpoint:[self Getm_coPlayerCards:turn index2:m_nGSParam1] endpoint:[self Getm_coFloorCards:m_nAvailableFloorSlot+1]];
				}
				// 폭탄 카드 두장을 추가로 획득
				[m_Card ReceiveCard:[self GetTurn] nIdxCard:BOMBCARD];
				[m_Card ReceiveCard:[self GetTurn] nIdxCard:BOMBCARD];
				//To Do: 8,9 - Edit this
				[self MovingCard:BOMBCARD startpoint:[self Getm_coFloorCards:0] endpoint:[self Getm_coPlayerCards:turn index2:8]];
				[self MovingCard:BOMBCARD startpoint:[self Getm_coFloorCards:0] endpoint:[self Getm_coPlayerCards:turn index2:9]];
				NSLog(@"폭탄 1장 + 1장");
				// 빼앗아 올 피 장수 증가
				m_nCntRobPee++;
				break;
			} // switch(m_nShakingMode).
			
		} // if(m_bAnimEvent)
		else if(m_bAnimEvent)
		{
			if([self IsMoving:m_nIdxPutOutCard point:Movepoint] == false)
			{
				[self PlaySound:SND_MATCH];
				m_bAnimEvent = false;
			}
		}
        break;

    case PO_TURNUP:
			// 중앙의 카드를 뒤집어 바닥에 붙이고 , 몇월에 붙었는지 기억
			if(m_bAnimEvent == false)
			{
				m_nGSParam2 = [self TurnUpCard:[self GetTurn] ];
				m_bAnimEvent = true;
			}else if(m_bAnimEvent == true)
			{
				if(false == [self IsMoving:m_nidxTurnUpCard point:Movepoint])
				{
					[self PlaySound:SND_MATCH];
					m_bAnimEvent = false;
				}
			}
		
		break;
        
    case PO_CHECKRULE:
			// 바닥에 붙인 결과에 따라서
        switch( m_nGSParam2 )
        {
				// 뒤집엇는데 보너스 카드가 나온 경우
        case BONUSCARD2:
        case BONUSCARD3:
				// 한 스텝 뒤로 돌아가 다시 카드를 뒤집는다.
            m_nAgencyStep = PO_TURNUP;
            return;

        case RES_PPUCK:
				// 뻑인 경우
				// 아무것도 먹지 못함
				// 그냥 뻑 횟수만 카운트
            m_nCntRule[[self GetTurn]][PPUCK]++;
            break;
				// 자뻑인 경우,
        case RES_EATJAPPUCK:
				// 턴 변경시 뺏어와야할 피가 총 2장
				// 따라서, 카드 획득 처리 전 , 피 1장 증가
            m_nCntRobPee++;
				// 자뻑인 경우도 ㅣ 쪽/따닥 등과 마찬가지로 
				// 아래 문장을 공통적으로 처리해야하므로,
				// 여기서  브레이크를 하면 안된다.
				NSLog(@"자뻑 먹음! 피1장 (%d)월", nPutOutMonth);
				// 뻑을 먹은 경우
        case RES_EATPPUCK:
				// 처음 낸 카드는 먹을 수 있다면 획득
				[self ObtainFloorCard: nPutOutMonth ];
				NSLog(@"뻑 먹음! (%d)월",nPutOutMonth);
				//쪽인 경우
        case RES_JJOCK:
				// 따닥인 경우
        case RES_DDADDAK:
				NSLog(@"쪽/ 따닥/자뻑! 모든 패를 먹기 시작 (%d)",m_nGSParam2);
				NSLog(@"해당 슬롯(%d)의 카드수:  (%d)",nTurnUpMonth,[m_Floor GetFloorCardCount:nTurnUpMonth]);
				do
				{
					nIdxCard = [m_Floor PopFloorCard:nTurnUpMonth];
					[self ObtainCard:nIdxCard];
					[self MovingCard:nIdxCard startpoint:[self Getm_coFloorCards:nTurnUpMonth] endpoint:[self Getm_coObtainedCards:[self GetTurn] index2:[self GetCardType:nIdxCard]]];
				}while( nIdxCard != NOCARD );
				NSLog(@"해당 슬롯(%d)의 카드수: (%d)",nTurnUpMonth, [m_Floor GetFloorCardCount:nTurnUpMonth]);
				NSLog(@"쪽/따닥/자뻑 모든패를 먹기 끝.");
				// 마지막 턴인 경우, 플레이어, 상대방의 카드가 0장인 경우
			if(0 == [m_Card GetPlayerCardCount:PLAYER] && 0 == [m_Card  GetPlayerCardCount:OPPONENT])
            {
				NSLog(@"막턴 이므로 쪽따닥뻑 무효");
                break;
            }
				NSLog(@"쪽/따닥 먹음!");
				// 턴 변경시 뺏어와야할 피 1장 증가
            m_nCntRobPee++;
            break;

        default:
				// 특별한 사항이 없다면
				
				// 낸카드와
				[self ObtainFloorCard: nPutOutMonth];
				// 뒤집은 카드를 먹음.
				[self ObtainFloorCard: nTurnUpMonth ];
            break;
        } // switch( m_nGSParam2 ).
        break;

    case PO_CHANGETURN:
			[m_Card SortPlayerCards:[self GetTurn]];
			[self DrawPlayerCards];
			[self DrawObtainedCards];
			NSLog(@"턴 변경");
			[self ChangeState:GS_CHANGETURN];
        return;
    } // switch(m_nAgencyStep).
	// 스텝 증가
	if(m_bAnimEvent == false)
	{
		m_nAgencyStep++;
	}
    
} // void DealPutOutPlayerCards(void).

// 턴 변경
- (void) DealChangeTurn
{
	int turn = [self GetTurn];
	int oppturn;
	if(turn == PLAYER)
		oppturn = OPPONENT;
	else 
		oppturn = PLAYER;
    switch(m_nAgencyStep)
    {
    case CT_ROBPEE:
			if(m_nCntRobPee != 0)
			{
				NSLog(@"빼앗아 와야할 피 장수: (%d)",m_nCntRobPee);
			}
			
			//빼앗아 와야할 피의 장수 만큼
        while(m_nCntRobPee-- > 0)
        {
			if(m_nTurn == PLAYER)
			{
				NSLog(@"피 1장 가져옴 OPPONENT -> PLAYER");
			}else
			{
				NSLog(@"피 1장 가져옴 PLAYER -> OPPONENT");
			}
			
			// 피를 빼앗아 온다.
            [m_Card RobPee:turn];
			int robpeecard = [m_Card GetRobPeeCard];
			int robpeecardtype = [self GetCardType:robpeecard];
			CGPoint end = CGPointMake([self Getm_coObtainedCards:turn index2:robpeecardtype].x, [self Getm_coObtainedCards:turn index2:robpeecardtype].y);
			CGPoint start = CGPointMake([self Getm_coObtainedCards:oppturn index2:robpeecardtype].x,[self Getm_coObtainedCards:oppturn index2:robpeecardtype].y);
			[self MovingCard:robpeecard startpoint:start endpoint:end];
        }
        break;

    case CT_CHECKENDOFGAME:
			//빼어올 피 장수 초기화
        m_nCntRobPee = 0;
			// 턴을 바꾸기 전에 게임이 끝났는지 확인한다.
		if(0 == [m_Card  GetPlayerCardCount:[self GetTurn]] && 0 == [m_Card GetPlayerCardCount:![self GetTurn]])
		{
			// 모든 플레이어의 카드 갯수가 0이라면,
			// 게임이 끝났다고 볼수 있다.
			// 게임이 끝났을때, 바닥에 패가 남아있다면
			// 이는 분명히 서비스 패일 것이다.
			// 따라서 뒤집어서 플레이어가 가져간다.
			
			NSLog(@"바닥에 남은 보너스 피 가져감 시작");
			// 중앙에 남은 카드를 모두 가져감
            while( !( 0 > ( [self ObtainCard:[m_Floor PopCenterCard]] )) );
			// 바닥에 남은 카드를 모두 가져감
			for(int i = 0 ; i < 12 ; i++)
			{
				while( !(0 > ([self ObtainCard:[m_Floor PopFloorCard:i]] )) );
			}
			
			// 게임이 끝났다면, 턴을 바꾸지 않는다.
			if(m_bFirstStart == TRUE)
			{
				[self MoveAllCardToDeck];
			}
			
            [self ChangeState:GS_START_NEWGAME];
			// 바닥에 덱카드를 모두 Hide 시키자..
			// 새로 시작
            return;
        }
        break;

    case CT_CHANGETURN:
			NSLog(@"턴 변경 (%d) ->(%d)",m_nTurn , !m_nTurn);
			// 최종적으로 턴 변경
			[self SetTurn:(![self GetTurn])];
			// 플레이 상태로 복귀
			[self ChangeState:GS_PLAYING];
        return;
    }
	// 에이젼시 스텝 증가+
    m_nAgencyStep++;
} // void DealChangeTurn(void).

// 플레이어 보유 카드 중 하나를 바닥에 낸다.
- (void) PutOutPlayerCard:(int) nOffsetPlayerCard
{
	// 현재 턴인 플레이어의 카드를 한장 바닥에 낸다.
    [self ChangeState:GS_PUTOUT_PLAYERCARD];
	// 1번 파라미터 : 오프셋.
    m_nGSParam1 = nOffsetPlayerCard;
} // void PutOutPlayerCard(int nOffsetPlayerCard).

// 바닥ㅇ ㅔ있는 카드 획득
- (void) ObtainFloorCard:(int) nMonth
{
	int nIdxCard;
	// 음수 값이 들어왔으면
    if(NONE == nMonth)
    {	// 검사 하지 않고 리턴
        return;
    }
	// 일단 보너스 카드를 모두 먹고,
	if([m_Floor PopBonusCard:nMonth] > 0)
	{
		
		do
		{
			nIdxCard = [m_Floor PopBonusCard:nMonth];
			[self ObtainCard:nIdxCard];
			[self MovingCard:nIdxCard startpoint:[self Getm_coFloorCards:nMonth+1] endpoint:[self Getm_coObtainedCards:[self GetTurn] index2:[self GetCardType:nIdxCard]]];
		}while(  nIdxCard != NOCARD );
	}
    
    
	// 먹을수 있는지 체크하고 패를 획득
    switch( [m_Floor GetNormalFloorCardCount:nMonth] )
    {
			// 1장 있다면, 아무것도 안함
    case 1:
        break;
			// 3장 있다면 둘중에 하나를 선택해서 먹어야 한다.
			// 아직 미구현 상태 그냥 뒤의 두장을 먹는다.
    case 3:
			// 맨뒤의 두장의 카드를 먹는다.
			nIdxCard = [m_Floor PopFloorCard:nMonth];
			[self ObtainCard:nIdxCard];
			CGPoint pos =[self Getm_coObtainedCards:[self GetTurn] index2:[self GetCardType:nIdxCard]];
			[self MovingCard:nIdxCard startpoint:[self Getm_coFloorCards:nMonth+1] endpoint:pos];
			
			nIdxCard = [m_Floor PopFloorCard:nMonth];
			[self ObtainCard:nIdxCard];
			pos =[self Getm_coObtainedCards:[self GetTurn] index2:[self GetCardType:nIdxCard]];
			
			[self MovingCard:nIdxCard startpoint:[self Getm_coFloorCards:nMonth+1] endpoint:pos];
        break;

    default:
			
			NSLog(@"바닥(%d)에 있는 패 총 %d장 모두 획득",nMonth, [m_Floor GetFloorCardCount:nMonth]);
			// 2장 , 4장이 있다면
			// 그냥 다 먹어버림
			// 해당 월의 카드를 모두 먹고,
			
			for(int iCnt = 0 ; /*0 < (nIdxCard =[m_Floor PopFloorCard:nMonth])*/  ; iCnt++)
			{
				nIdxCard = [m_Floor PopFloorCard:nMonth];
				if(nIdxCard < 0) 
				{
					if( [m_Floor GetFloorCardCount:nMonth] == 0)
					{
						break;
					}
				}
				
				
				
				
				CGPoint startpoint = [self Getm_coFloorCards:nMonth+1];
				CGPoint endpoint = [self Getm_coObtainedCards:[self GetTurn] index2:[self GetCardType:nIdxCard]];
				NSLog(@"%d번 플레이어가 %d번 카드를 %2f ,%2f 에서 %2f , %2f 로 이동시켰따~!!!",[self GetTurn], nIdxCard , startpoint.x , startpoint.y , endpoint.x , endpoint.y);
				
				[self MovingCard:nIdxCard startpoint:startpoint endpoint:endpoint];
				
				//nIdxCard = [m_Floor PopFloorCard:nMonth];
				[self ObtainCard:nIdxCard];
			}
			
			NSLog(@"바닥(%d)에 있는 패 총 %d장 모두 획득",nMonth, [m_Floor GetFloorCardCount:nMonth]);

    }
} // void CGotopAgent::ObtainFloorCard(int nMonth).
// 현재 턴 플레이어가 카드 획득
- (int) ObtainCard:(int) nIdxCard
{
//	if(nIdxCard < 0)
//		return -1;
	
    int nResult;

	if([self GetTurn]== PLAYER)
	{
		NSLog(@"플레이어가 카드 획득 :(%d)번",nIdxCard);
	}else if([self GetTurn] == OPPONENT)
	{
		NSLog(@"상대방이 카드 획득 :(%d)번",nIdxCard);
	}
	
	// 카드 획득
    nResult = [m_Card ObtainCard:[self GetTurn]  nIdxCard:nIdxCard];
	// 점수 계산
    [self FigureOutScore];
	
    return nResult;
} // int ObtainCard(int nIdxCard).

// 점수 계산
- (void) FigureOutScore
{
    int iPlayer;
	// 플레이어들의 점수를 계산해준다.
    for(iPlayer=0; iPlayer<PLAYER_COUNT; iPlayer++)
    {
		// 고 한 횟수만큼 기본 점수 획득.
        m_nScore[iPlayer] = [m_Card FigureOutScore:iPlayer  nInitialScore:m_nCntRule[iPlayer][GO]];
		// 계산된 점수에 게임 룰을 적용
		// 흔든 횟수 만큼 점수에 제곱승.
		
        m_nScore[iPlayer] *= pow(2, m_nCntRule[iPlayer][SHAKE]);
		// 3고 이상이라면
        if(m_nCntRule[iPlayer][GO] >= 3)
        {
			// 3고 부터는 2의 고 횟수의 2승 배로 
            m_nScore[iPlayer] *= pow(2, m_nCntRule[iPlayer][GO]-2);
        }
		// 상대방이 고를 한적이 있따면, 독박
        if(0 < m_nCntRule[!iPlayer][GO])
        {	// 독박이면 두배,
            m_nScore[iPlayer] *= 2;
        }
    } // for(iPlayer=0; iPlayer<PLAYER_COUNT; iPlayer++).
} // void FigureOutScore(void).

// 센터 카드 추출
- (int) PopCenterCard
{
    return [m_Floor PopCenterCard];
} // int PopCenterCard(void).

// 해당 월의 마지막 카드 획득
- (int) PopFloorCard:(int) nMonth
{
    return [m_Floor PopFloorCard:nMonth];
} // int PopFloorCard(int nMonth).
// 바닥 카드 획득
- (int) PopFloorCard:(int) nMonth  byOffset:(Byte)byOffset
{
    return [m_Floor PopFloorCard:nMonth  byOffset:byOffset];
} // int PopFloorCard(int nMonth, BYTE byOffset).

// 상태 리턴
- (int) GetState
{
    return m_nGameState;
} // int GetState(void).
// 턴 설정
- (void) SetTurn:(int) nPlayer
{
    m_nTurn = nPlayer;
} // void SetTurn(int nPlayer).
// 턴 리턴
- (int) GetTurn
{
    return m_nTurn;
} // int GetTurn(void).

//카드 타입 리턴
- (int) GetCardType:(int) nIdxCard
{
    return [m_Card GetCardType:nIdxCard];
} // int GetCardType(int nIdxCard).

// 해당  플레이어 점수 리턴
- (int) GetScore:(int) nPlayer
{
    return m_nScore[nPlayer];
} // int GetScore(int nPlayer).
// 해당 플레이어의 규칙 횟수 리턴
- (int) GetRuleCount:(int) nPlayer nRuleType:(int) nRuleType
{
    return m_nCntRule[nPlayer][nRuleType];
} // int GetRuleCount(int nPlayer, int nRuleType).

// 센터 카드 갯수 리턴
- (int) GetCenterCardCount
{
    return [m_Floor GetCenterCardCount];
} // int GetCenterCardCount(void).

// 바닥 카드 갯수 리턴
- (int) GetFloorCardCount:(int) nMonth
{
    return [m_Floor GetFloorCardCount:nMonth];
} // int GetFloorCardCount(int nMonth).

// 바닥 카드 리턴
- (int) GetFloorCard:(int)nMonth boffset:(Byte)boffset
{
	return [m_Floor GetFloorCard:nMonth byOffset:boffset];
}
// 플레이어 카드 갯수
- (int) GetPlayerCardCount
{
    return [m_Card GetPlayerCardCount:[self GetTurn]];
} // int GetPlayerCardCount(void).
// 플레이어 카드 갯수
- (int) GetPlayerCardCount:(int) nPlayer
{
    return [m_Card GetPlayerCardCount:nPlayer];
} // int GetPlayerCardCount(int nPlayer).
// 플레이어 카드 리턴
- (int) GetPlayerCard:(int) nOffset
{
    return [m_Card GetPlayerCard:[self GetTurn] nOffset:nOffset];
} // int GetPlayerCard(int nOffset).
// 플레이어 카드 리턴
- (int) GetPlayerCard:(int) nPlayer nOffset:(int) nOffset
{
    return [m_Card GetPlayerCard:nPlayer  nOffset:nOffset];
} // int GetPlayerCard(int nPlayer, int nOffset).

// 먹은 카드 갯수 리턴
- (int) GetObtainedCardCount:(int) nPlayer nCardType:(int) nCardType
{
    return [m_Card GetObtainedCardCount:nPlayer nCardType:nCardType];
} // int GetObtainedCardCount(int nPlayer, int nCardType).
// 획득 카드  리턴
- (int) GetObtainedCard:(int) nPlayer nCardType:(int) nCardType nOffset:(int) nOffset
{
    return [m_Card GetObtainedCard:nPlayer nCardType:nCardType nOffset:nOffset];
} // int GetObtainedCard(int nPlayer, int nCardType, int nOffset).

- (void) SetDefaultCoordination
{
	m_coFloorCards[0] = CGPointMake( 215+(CARD_WIDTH/2) , 268 );
	
	m_coFloorCards[1] = CGPointMake( 141+(CARD_WIDTH/2) , 336 );
	m_coFloorCards[2] = CGPointMake( 178+(CARD_WIDTH/2) , 336 );
	m_coFloorCards[3] = CGPointMake( 215+(CARD_WIDTH/2) , 336 );
	m_coFloorCards[4] = CGPointMake( 246+(CARD_WIDTH/2) , 336 );
	m_coFloorCards[5] = CGPointMake( 277+(CARD_WIDTH/2) , 336 );
	m_coFloorCards[6] = CGPointMake( 141+(CARD_WIDTH/2) , 268 );
	m_coFloorCards[7] = CGPointMake( 277+(CARD_WIDTH/2) , 268 );
	m_coFloorCards[8] = CGPointMake( 141+(CARD_WIDTH/2) , 186 );
	m_coFloorCards[9] = CGPointMake( 178+(CARD_WIDTH/2) , 186 );
	m_coFloorCards[10] = CGPointMake( 215+(CARD_WIDTH/2) , 186 );
	m_coFloorCards[11] = CGPointMake( 246+(CARD_WIDTH/2) , 186 );
	m_coFloorCards[12] = CGPointMake( 277+(CARD_WIDTH/2) , 186 );
	
	m_coPlayerCards[PLAYER][0] = CGPointMake( 135+(CARD_WIDTH/2) , 112 );
	m_coPlayerCards[PLAYER][1] = CGPointMake( 172+(CARD_WIDTH/2) , 112 );
	m_coPlayerCards[PLAYER][2] = CGPointMake( 209+(CARD_WIDTH/2) , 112 );
	m_coPlayerCards[PLAYER][3] = CGPointMake( 246+(CARD_WIDTH/2) , 112 );
	m_coPlayerCards[PLAYER][4] = CGPointMake( 283+(CARD_WIDTH/2) , 112 );
	m_coPlayerCards[PLAYER][5] = CGPointMake( 135+(CARD_WIDTH/2) , 56 );
	m_coPlayerCards[PLAYER][6] = CGPointMake( 172+(CARD_WIDTH/2) , 56 );
	m_coPlayerCards[PLAYER][7] = CGPointMake( 209+(CARD_WIDTH/2) , 56 );
	m_coPlayerCards[PLAYER][8] = CGPointMake( 246+(CARD_WIDTH/2) , 56 );
	m_coPlayerCards[PLAYER][9] = CGPointMake( 283+(CARD_WIDTH/2) , 56 );
	
	for(int i = 0 ; i < 10 ; i++)
	{
		m_coPlayerCards[OPPONENT][i] = CGPointMake (m_coPlayerCards[PLAYER][i].x , m_coPlayerCards[PLAYER][i].y + 336); //336
	}
	m_coObtainedCards[PLAYER][KWANG] = CGPointMake ( 0+(CARD_WIDTH/2) , 225 );
	m_coObtainedCards[PLAYER][YEOL] = CGPointMake ( 0+(CARD_WIDTH/2) , 187.5 );
	m_coObtainedCards[PLAYER][TEE] = CGPointMake ( 0+(CARD_WIDTH/2) , 150 );
	m_coObtainedCards[PLAYER][PEE] = CGPointMake ( 0+(CARD_WIDTH/2) , 112.5 );
	
	for(int j =0; j < CARDTYPE_COUNT; j++)
	{
		m_coObtainedCards[OPPONENT][j] = CGPointMake ( 0+(CARD_WIDTH/2) , m_coObtainedCards[PLAYER][j].y + 223);//216.5
		
	}
	
	
}
- (void) SetDisplayCoordination
{
	m_coScore[PLAYER] = CGPointMake( 178 +(CARD_WIDTH/2) , 121 );
	m_coScore[OPPONENT] = CGPointMake ( 178+(CARD_WIDTH/2) , 335 );
	m_coRule[PLAYER][GO] = CGPointMake ( 215+(CARD_WIDTH/2) , 121 );
	m_coRule[OPPONENT][GO] = CGPointMake ( 215+(CARD_WIDTH/2) , 335 );
	m_coRule[PLAYER][SHAKE] = CGPointMake ( 246+(CARD_WIDTH/2) , 121 );
	m_coRule[OPPONENT][SHAKE] = CGPointMake ( 246+(CARD_WIDTH/2) , 335 );
	m_coRule[PLAYER][PPUCK] = CGPointMake ( 277+(CARD_WIDTH/2) , 121 );
	m_coRule[OPPONENT][PPUCK] = CGPointMake (277+(CARD_WIDTH/2) , 335 );
}


- (CGPoint) Getm_coFloorCards:(int)index
{
	if(index == 0)
	{
		return m_coFloorCards[index];
	}
	int offset = 0;
	int count = [m_Floor GetFloorCardCount:index-1];
	if( count > 0 )
	{
		offset = 3 * count;
	}
	CGPoint returnpoint = CGPointMake(m_coFloorCards[index].x + offset, m_coFloorCards[index].y + offset);
	return returnpoint;
}
- (CGPoint) Getm_coPlayerCards:(int)index1 index2:(int)index2
{
	return m_coPlayerCards[index1][index2];
}
- (CGPoint) Getm_coObtainedCards:(int)index1 index2:(int)index2
{
	//int offset = 0;
	int count;
	count = [m_Card GetObtainedCardCount:index1 nCardType:index2];
	/*
	if(index2 == PEE)
	{
		count = [m_Card GetObtainedCardCount:index1 nCardType:index2];
	}else if(index2 == KWANG)
	{
		count = [m_Card GetObtainedCardCount:index1 nCardType:KWANG];
	}else if(index2 == YEOL)
	{
		count = [m_Card GetObtainedCardCount:index1 nCardType:YEOL];
	}else if(index2 == TEE)
	{
		count = [m_Card GetObtainedCardCount:index1 nCardType:TEE];
	}
	 */
	CGPoint returnpoint = CGPointMake(m_coObtainedCards[index1][index2].x + (CARD_WIDTH*0.67)*(count%5), m_coObtainedCards[index1][index2].y - (CARD_HEIGHT*0.67)*(count/5));
	return returnpoint;
}
- (CGPoint) Getm_coScore:(int)index1
{
	return m_coScore[index1];
}
- (CGPoint) Getm_coRule:(int)index1 index2:(int)index2
{
	return m_coRule[index1][index2];
}

- (void) LoadSprites
{
	//AtlasSpriteManager *mgr = (AtlasSpriteManager*)[self getChildByTag:kTagSpriteManager];
	
	int cnt;
	float x = 0.0f; 
	float y = 0.0f;
	
	
	for( cnt = 0; cnt < GAME_TOTAL_CARD; cnt++)
	{
		
		x =(cnt%10)*CARD_WIDTH;
		y =((cnt)/10)*CARD_HEIGHT;
		
		m_sprCard[cnt] = [AtlasSprite spriteWithRect:CGRectMake(x,y,CARD_WIDTH,CARD_HEIGHT) spriteManager:m_atlasmgr];
		[m_atlasmgr setPosition:CGPointMake( 0, 0 )];
		[m_atlasmgr addChild:m_sprCard[cnt] z:0 tag:cnt];
		
		
	}
	x =(50%10)*CARD_WIDTH;
	y =((50)/10)*CARD_HEIGHT;
	
	m_sprBombCard = [AtlasSprite spriteWithRect:CGRectMake(x,y,CARD_WIDTH,CARD_HEIGHT) spriteManager:m_atlasmgr];
	[m_atlasmgr setPosition:CGPointMake( 0, 0 )];
	[m_atlasmgr addChild:m_sprBombCard z:0 tag:50];
	
	x =(51%10)*CARD_WIDTH;
	y =((51)/10)*CARD_HEIGHT;
	
	
	for(cnt = 0  ; cnt < DISTRIBUTE_PLAYER_CARDS ; cnt++)
	{
		m_sprBack[cnt] = [AtlasSprite spriteWithRect:CGRectMake(x, y, CARD_WIDTH, CARD_HEIGHT) spriteManager:m_atlasmgr];
		[m_atlasmgr setPosition:CGPointMake(0,0)];
		[m_atlasmgr addChild:m_sprBack[cnt] z:51+cnt tag:51+cnt];
		
		m_sprOppCardBack[cnt] = [AtlasSprite spriteWithRect:CGRectMake(x, y, CARD_WIDTH, CARD_HEIGHT) spriteManager:m_atlasmgr];
		[m_atlasmgr setPosition:CGPointMake(0,0)];
		[m_atlasmgr addChild:m_sprOppCardBack[cnt] z:61+cnt tag:61+cnt];
	}
	/*
	NSString *pscore = [[NSString alloc] initWithFormat:@"%d",[self GetScore:PLAYER]];
	NSString *oscore = [[NSString alloc] initWithFormat:@"%d",[self GetScore:OPPONENT]];
	
	NSString *pgonotice = [[NSString alloc] initWithFormat:@"%d",[self GetRuleCount:PLAYER nRuleType:GO]];
	NSString *ogonotice = [[NSString alloc] initWithFormat:@"%d",[self GetRuleCount:OPPONENT nRuleType:GO]];
	
	NSString *pshakenotice = [[NSString alloc] initWithFormat:@"%d",[self GetRuleCount:PLAYER nRuleType:SHAKE]];
	NSString *oshakenotice = [[NSString alloc] initWithFormat:@"%d",[self GetRuleCount:OPPONENT nRuleType:SHAKE]];
	
	NSString *pppnotice = [[NSString alloc] initWithFormat:@"%d",[self GetRuleCount:PLAYER nRuleType:PPUCK]];
	NSString *oppnotice = [[NSString alloc] initWithFormat:@"%d",[self GetRuleCount:OPPONENT nRuleType:PPUCK]];
	*/
	pslabel = [Label labelWithString:@"0" fontName:@"Courier" fontSize:32];
	oslabel = [Label labelWithString:@"0" fontName:@"Courier" fontSize:32];
	pglabel = [Label labelWithString:@"0" fontName:@"Courier" fontSize:10];
	oglabel = [Label labelWithString:@"0" fontName:@"Courier" fontSize:10];
	pshlabel = [Label labelWithString:@"0" fontName:@"Courier" fontSize:10];
	oshlabel = [Label labelWithString:@"0" fontName:@"Courier" fontSize:10];
	pplabel = [Label labelWithString:@"0" fontName:@"Courier" fontSize:10];
	oplabel = [Label labelWithString:@"0" fontName:@"Courier" fontSize:10];
	
	
	[pslabel setPosition: ccp([self Getm_coScore:PLAYER].x , [self Getm_coScore:PLAYER].y)];
	
	[oslabel setPosition: ccp([self Getm_coScore:OPPONENT].x, [self Getm_coScore:OPPONENT].y)];
	
	
	[pglabel setPosition: ccp([self Getm_coRule:PLAYER index2:GO].x, [self Getm_coRule:PLAYER index2:GO].y)];
	
	[oglabel setPosition: ccp([self Getm_coRule:OPPONENT index2:GO].x,[self Getm_coRule:OPPONENT index2:GO].y)];
	
	
	[pshlabel setPosition: ccp([self Getm_coRule:PLAYER index2:SHAKE].x,[self Getm_coRule:PLAYER index2:SHAKE].y)];
	
	[oshlabel setPosition: ccp([self Getm_coRule:OPPONENT index2:SHAKE].x,[self Getm_coRule:OPPONENT index2:SHAKE].y)];
	
	
	[pplabel setPosition: ccp([self Getm_coRule:PLAYER index2:PPUCK].x,[self Getm_coRule:PLAYER index2:PPUCK].y)];
	
	[oplabel setPosition: ccp([self Getm_coRule:OPPONENT index2:PPUCK].x,[self Getm_coRule:OPPONENT index2:PPUCK].y)];
	
	[self addChild: pslabel];
	[self addChild: oslabel];
	[self addChild: pglabel];
	[self addChild: oglabel];
	[self addChild: pshlabel];
	[self addChild: oshlabel];
	[self addChild: pplabel];
	[self addChild: oplabel];
	
	//sprite 까지 로드했으면 사운드도 로드한다.
	[self LoadSound];
	
	
		
}
- (void) UnloadSprites
{
	[m_sprBombCard release];
	
	//	[m_sprOppCardBack release];
	
	for(int i = 0 ; i < GAME_TOTAL_CARD; i++)
	{
		[m_sprCard[i] release];
	}
	
	for(int i = 0; i < DISTRIBUTE_PLAYER_CARDS; i++)
	{
		[m_sprOppCardBack[i] release];
		[m_sprBack[i] release];
	}
	
}

//중앙 카드 그려줌 - 가운데 덱카드
- (void) DrawCenterCards
{
	int iCnt;
	int nCntCenterCard;
	//AtlasSpriteManager *mgr = (AtlasSpriteManager*)[self getChildByTag:kTagSpriteManager];
	
	nCntCenterCard = [self GetCenterCardCount];
	
	
	if(nCntCenterCard == 0)
	{
		for(iCnt = 0; iCnt < 10; iCnt++)
		{
			AtlasSprite *OppCardBack = (AtlasSprite*)[m_atlasmgr getChildByTag:51+iCnt];
			[OppCardBack setPosition:CGPointMake(0,0)];
			
			
			
		}
		return;
	}
	// 처음엔 바닥에 덱카드를 다 그린다.
	if(nCntCenterCard >= 20)
	{
		for(iCnt = 0 ; iCnt < 10;iCnt++)
		{
			AtlasSprite *OppCardBack = (AtlasSprite*)[m_atlasmgr getChildByTag:51+iCnt];
			[OppCardBack setPosition:CGPointMake([self Getm_coFloorCards:0].x -iCnt,[self Getm_coFloorCards:0].y-iCnt)];
			
		}
		
	}else
	{// 덱카드가 줄어들때마다 2장에 1장씩 줄여서 그린다.
		int diff = (20 - nCntCenterCard)/2;
		
		
		for(iCnt = 0;iCnt< 10; iCnt++)
		{
			AtlasSprite *OppCardBack = (AtlasSprite*)[m_atlasmgr getChildByTag:51+iCnt];
			// 가져간 만큼 안그리고
			if(iCnt < diff)
			{
				[OppCardBack setPosition:CGPointMake(0,0)];
			}else
			{ // 나머지 그린다.
				[OppCardBack setPosition:CGPointMake([self Getm_coFloorCards:0].x -iCnt,[self Getm_coFloorCards:0].y-iCnt)];
			}
			
		}
	}
	
	
	
}
- (void) DrawFloorCards
{
	int iCnt;
	int iMonth;
	int nidxCard;
	
	// 중앙 덱카드를 그린다.
	[self DrawCenterCards];
	
	//AtlasSpriteManager *mgr = (AtlasSpriteManager*)[self getChildByTag:kTagSpriteManager];
	for(iMonth=0; iMonth <12; iMonth++)
	{
		if(0 < [self GetFloorCardCount:iMonth])
		{
			iCnt = -1;
			
			int count = [self GetFloorCardCount:iMonth];
			for(int i =0; i < count; i++)
			{
				++iCnt;
				
				nidxCard = [self GetFloorCard:iMonth boffset:iCnt];
				if(0 > (nidxCard))
				{
					continue;
				}
				
				AtlasSprite* card =(AtlasSprite*)[m_atlasmgr getChildByTag:nidxCard];
				[card setPosition:CGPointMake([self Getm_coFloorCards:(1+ iMonth)].x ,[self Getm_coFloorCards:(1+ iMonth)].y)];
				
				
			}
			
		}
	}
	
}
- (void) DrawObtainedCards
{
	int iCnt;
	int iPlayer;
	int iCardType;
	int nCntObtainedCard;
	int nGapObtainedCard;
	int nIdxObtainedCard;
	//AtlasSpriteManager *mgr = (AtlasSpriteManager*)[self getChildByTag:kTagSpriteManager];
	
	for(iPlayer=0; iPlayer<PLAYER_COUNT; iPlayer++)
	{
		for(iCardType=0; iCardType<CARDTYPE_COUNT; iCardType++)
		{
			nCntObtainedCard = [self GetObtainedCardCount:iPlayer nCardType:iCardType];
			nGapObtainedCard = OBTAINED_CARD_GAP;
			/*
			switch (iCardType)
			{
				case KWANG:
					if(nCntObtainedCard>=5)
					{
						nGapObtainedCard = 0;
					}else if( nCntObtainedCard > 2)
					{
						nGapObtainedCard -= -1;
					}
					break;
				case YEOL:
				case TEE:
					if(nCntObtainedCard >= 10)
					{
						nGapObtainedCard -= 0;
						
					}else if(nCntObtainedCard > 6)
					{
						nGapObtainedCard -= -3;
					}else if(nCntObtainedCard > 4)
					{
						nGapObtainedCard -= -2;
						
					}else if(nCntObtainedCard >2)
					{
						nGapObtainedCard -= -1;
					}
					break;
				case PEE:
					if(nCntObtainedCard >=10)
					{
						nGapObtainedCard = -22;
						
					}
					else if(nCntObtainedCard >=8)
					{
						nGapObtainedCard = -22;
					}else if(nCntObtainedCard >5)
					{
						nGapObtainedCard = -21;
					}
					break;
			}
			*/
			iCnt = -1;
			
			while(!( 0 > (nIdxObtainedCard = [self GetObtainedCard:iPlayer nCardType:iCardType nOffset:++iCnt])))
			{
				id sprite = [m_atlasmgr getChildByTag:nIdxObtainedCard];
				[m_atlasmgr reorderChild:sprite z:iCnt+1];
				
				AtlasSprite* card =(AtlasSprite*)[m_atlasmgr getChildByTag:nIdxObtainedCard];
				// 카드의 스케일을 변경시켜준다.
				[card setScale:0.67];
				CGPoint startpos = m_coObtainedCards[iPlayer][iCardType];
				CGPoint resultpos = CGPointMake(startpos.x + (CARD_WIDTH*0.67)*(iCnt%5) ,startpos.y - (CARD_HEIGHT*0.67)*(iCnt/5)); 
				
				//위치가 잘못되있다면 올바른 위치로 이동시킨다.
				if(card.position.x != resultpos.x && card.position.y != resultpos.y)
				{   // 이동시키는 ..카드
					[self MovingCard:nIdxObtainedCard startpoint:startpos endpoint:resultpos];
				}
				// 위치 세팅
				[card setPosition:resultpos];
				
                NSLog(@"%d번 플레이어 %d개의 카드중 %d번째 %d번 카드 정렬 위치는 %2f, %2f",iPlayer,nCntObtainedCard,iCnt, nIdxObtainedCard , resultpos.x , resultpos.y);
			}
			
			
		}
	}
	
	[m_atlasmgr draw];
	
}
- (void) DrawPlayerCards
{
	int iCnt;
	int nIdxPlayerCard;
	int nCntPlayerCardCount;
	
	iCnt = -1;
	
	nCntPlayerCardCount = [self GetPlayerCardCount:PLAYER];
	for(int i = 0 ; i < nCntPlayerCardCount; i++)
	{
		++iCnt;
		
		nIdxPlayerCard = [self GetPlayerCard:PLAYER nOffset:iCnt];	
		
		if(0 > (nIdxPlayerCard))
			break;
		//NSLog(@"정렬된 플레이어 카드 %d , %d번째",nIdxPlayerCard,i);
		
		id sprite = [m_atlasmgr getChildByTag:nIdxPlayerCard];
		[m_atlasmgr reorderChild:sprite z:i+10];
		
		
		AtlasSprite* card =(AtlasSprite*)[m_atlasmgr getChildByTag:nIdxPlayerCard];
		//[card setPosition:CGPointMake([self Getm_coPlayerCards:PLAYER index2:iCnt].x ,[self Getm_coPlayerCards:PLAYER index2:iCnt].y )];
		[self MovingCard:nIdxPlayerCard startpoint:card.position endpoint:[self Getm_coPlayerCards:PLAYER index2:i]];
		
		
	}
	
	
	for(iCnt =0; iCnt< [self GetPlayerCardCount:OPPONENT]; iCnt++)
	{
		
		nIdxPlayerCard = [self GetPlayerCard:OPPONENT nOffset:iCnt];	
		//NSLog(@"정렬된 상대방 카드 %d , %d번째",nIdxPlayerCard,iCnt);
		
		id sprite = [m_atlasmgr getChildByTag:nIdxPlayerCard];
		[m_atlasmgr reorderChild:sprite z:iCnt+10];
		
		AtlasSprite* card =(AtlasSprite*)[m_atlasmgr getChildByTag:nIdxPlayerCard];//61+iCnt
		//[card setPosition:CGPointMake([self Getm_coPlayerCards:OPPONENT index2:iCnt].x ,[self Getm_coPlayerCards:OPPONENT index2:iCnt].y )];
		[self MovingCard:nIdxPlayerCard startpoint:card.position endpoint:[self Getm_coPlayerCards:OPPONENT index2:iCnt]];
		
		//[OppCardBack release];
	}
}
- (void) DisplayGameProgress
{
	
	
	
	NSString *pscore = [NSString stringWithFormat:@"%d",[self GetScore:PLAYER]];
	NSString *oscore = [NSString stringWithFormat:@"%d",[self GetScore:OPPONENT]];
	
	NSString *pgonotice = [NSString stringWithFormat:@"%d",[self GetRuleCount:PLAYER nRuleType:GO]];
	NSString *ogonotice = [NSString stringWithFormat:@"%d",[self GetRuleCount:OPPONENT nRuleType:GO]];
	
	NSString *pshakenotice = [NSString stringWithFormat:@"%d",[self GetRuleCount:PLAYER nRuleType:SHAKE]];
	NSString *oshakenotice = [NSString stringWithFormat:@"%d",[self GetRuleCount:OPPONENT nRuleType:SHAKE]];
	
	NSString *pppnotice = [NSString stringWithFormat:@"%d",[self GetRuleCount:PLAYER nRuleType:PPUCK]];
	NSString *oppnotice = [NSString stringWithFormat:@"%d",[self GetRuleCount:OPPONENT nRuleType:PPUCK]];
	
	
	[pslabel setString:pscore];	
	[oslabel setString:oscore];	
	[pglabel setString:pgonotice];	
	[oglabel setString:ogonotice];	
	[pshlabel setString:pshakenotice];	
	[oshlabel setString:oshakenotice];	
	[pplabel setString:pppnotice];	
	[oplabel setString:oppnotice];	
	
	[pslabel draw];
	[oslabel draw];
	[pglabel draw];
	[oglabel draw];
	[pshlabel draw];
	[oshlabel draw];
	[pplabel draw];
	[oplabel draw];
	

}

- (void) DrawAll
{
//	if(GS_PLAYING == [self GetState])
	{
		
		//카드 그리고
		[self DrawFloorCards];
//		[self DrawObtainedCards];
		[self DrawPlayerCards];
		//게임 상황 그리고
		[self DisplayGameProgress];
	}
	
}

// 중앙 카드를 뒤집어 바닥에 냄
- (int) TurnUpCard:(int)nPlayer
{
    //int nIdxCard;
    int nResult = NONE;
    int nCntTurnUpMonth;
	m_nidxTurnUpCard = [m_Floor PopCenterCard];
	//int count = [m_Floor GetCenterCardCount];
	//NSLog(@"바닥에 남은 카드: %d", count);
	
	// 만약 중앙에 카드가 없다면
    if( 0 > m_nidxTurnUpCard  )
    {	// 아무것도 하지 않고
		NSLog(@"바닥 중앙 카드에 아무것도 없다");
        return NOCARD;
    }
	// 중앙 카드를 뒤집어 바닥에 냄
	[m_Floor SetTurnUpMonth:[m_Floor AddToFloor:m_nidxTurnUpCard]];
	m_nTurnUpCardMonth = [m_Floor GetAvailableFloorSlot:m_nidxTurnUpCard];
	Movepoint = [self Getm_coFloorCards:m_nTurnUpCardMonth+1];
	[self MovingCard:m_nidxTurnUpCard startpoint:[self Getm_coFloorCards:0] endpoint:Movepoint];
	// 보너스 카드를 냈다면
	if((BONUSCARD2 == (m_nidxTurnUpCard)) || (BONUSCARD3 == (m_nidxTurnUpCard)))
    {
        return m_nidxTurnUpCard;
    }
	// 낸 월(슬롯)의 카드 장수 카운트
    nCntTurnUpMonth = [m_Floor GetNormalFloorCardCount:[m_Floor GetTurnUpMonth]];
	// 지금 낸 월과 , 처음 낸 월이 같다면
    if([m_Floor GetTurnUpMonth] == [m_Floor GetPutOutMonth])
    {
		// 해당 월에서 보너스 카드 장수를 뺀 장수에 따라서 결과 리턴
        switch( nCntTurnUpMonth )
        {
				
			case 2:
				// 둘다 같은 월에 냈는데, 2장이라면, 쪽
				nResult = RES_JJOCK;
				break;
				
			case 4:
				// 둘다 같은 월에 냈는데, 4장이라면, 따닥
				nResult = RES_DDADDAK;
				break;
				
			case 3:
				// 둘다 같은 월에 냈는데, 3장이라면, 뻑
				nResult = RES_PPUCK;
				// 뻑을 한 사람 기억
				//m_nPpuckConvict[m_nPutOutMonth] = nPlayer;
				[m_Floor SetPpuckConvict:[m_Floor GetPutOutMonth] nSet:nPlayer];
				break;
        }
    } // if(m_nTurnUpMonth == m_nPutOutMonth).
    else if( nCntTurnUpMonth >= 4 )
    {
        // 둘다 같은 월이 아닌데
		// 해당 슬롯의 카드가 4장 이상이고
		//
		
		// 뻑을 한 살마과 현재 플레이어가 같다면

        if(nPlayer == [m_Floor GetPpuckConvict:[m_Floor GetPutOutMonth]]) 
        {
			// 해당 슬롯의 뻑기록 초기화
            //m_nPpuckConvict[m_nPutOutMonth] = NONE;
			[m_Floor SetPpuckConvict:[m_Floor GetPutOutMonth] nSet:NONE];
			// 자뻑
            nResult = RES_EATJAPPUCK;
        }
        else
        {	// 해당 슬롯의 뻑기록 초기화
            //m_nPpuckConvict[m_nPutOutMonth] = NONE;
			[m_Floor SetPpuckConvict:[m_Floor GetPutOutMonth] nSet:NONE];
			
			// 아니면 그냥 뻑을 먹은 것임.
			// 혹은 바닥에 놓인 3장이 뻑을 한것이 아닐수도 있찌만 
            nResult = RES_EATPPUCK;
        }
    } // else if( nCntTurnUpMonth >= 4 ).
	
	[self DrawCenterCards];
	
    return nResult;
} // INT CGostopFloor::TurnUpCard(INT nPlayer).

- (void) MoveAllCardToDeck
{
	for(int i = 0 ; i < GAME_TOTAL_CARD ; i++)
	{
		AtlasSprite *Card = (AtlasSprite*)[m_atlasmgr getChildByTag:i];
		[Card setScale:1.0];
		CGPoint start = Card.position;
		[self MovingCard:i startpoint:start endpoint:[self Getm_coFloorCards:0]];
		
	}
}

- (void) LoadSound
{
		
	id sndpath = [[[NSBundle mainBundle] pathForResource:@"MainGameMatchCard1" ofType:@"wav"] autorelease];
	id sndpath2 = [[[NSBundle mainBundle] pathForResource:@"MainGameClickCard" ofType:@"wav"] autorelease];
	id sndpath3 = [[[NSBundle mainBundle] pathForResource:@"MainGameGetCard" ofType:@"wav"] autorelease];
	
	CFURLRef baseURL = (CFURLRef)[[NSURL alloc] initFileURLWithPath:sndpath];
	CFURLRef baseURL2 = (CFURLRef)[[NSURL alloc] initFileURLWithPath:sndpath2];
	CFURLRef baseURL3 = (CFURLRef)[[NSURL alloc] initFileURLWithPath:sndpath3];
	
	AudioServicesCreateSystemSoundID(baseURL, &m_sndmatchcard);
	AudioServicesCreateSystemSoundID(baseURL2, &m_sndgetcard);
	AudioServicesCreateSystemSoundID(baseURL3, &m_sndclickcard);

	
}
- (void) PlaySound:(int)type
{
	if(type == SND_GET)
	{
		AudioServicesPlaySystemSound(m_sndgetcard);
	}else if(type == SND_MATCH)
	{
		AudioServicesPlaySystemSound(m_sndmatchcard);
	}else if(type == SND_CLICK)
	{
		AudioServicesPlaySystemSound(m_sndclickcard);
	}
}
@end