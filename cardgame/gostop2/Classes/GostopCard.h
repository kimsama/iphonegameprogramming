
#import "GostopCommon.h"

//
// CGostopCard
// 
@interface CGostopCard : NSObject
{
	//카드 타입을 기억하는 벡터
	NSMutableArray *m_vCardTypes[CARDTYPE_COUNT];
	//int m_vCardTypes[CARDTYPE_COUNT];
	//고스톱 족보를 기억하는 벡터
    NSMutableArray *m_vGostopHands[HANDS_COUNT];
	//int m_vGostopHands[HANDS_COUNT];
	
	
	// 플레이어 카드 슬롯 벡터
    NSMutableArray *m_vPlayerCards[PLAYER_COUNT];
	//int m_vPlayerCards[PLAYER_COUNT];
	// 플레이어 획득 카드 슬롯 벡터
    NSMutableArray *m_vObtainedCards[PLAYER_COUNT][CARDTYPE_COUNT];
	//int m_vObtainedCards[PLAYER_COUNT][CARDTYPE_COUNT];
	// 점수 기억 배열
    int m_nScore[PLAYER_COUNT];
	
	int m_nRobPeeCard;
	


    
}; // class CGostopCard.
// 카드 타입 초기화
- (void) InitCardTypes;
// 족보 배열 초기화
- (void) InitGostopHands;

// 초기화
- (void) Init;

// 플레이어 카드 정렬
- (void) SortPlayerCards;
// 특정 플레이어 카드 정렬
   - (void) SortPlayerCards:(int)nPlayer;
// 해당 플레이어의 모든 타입의 획득 카드 정렬
- (void) SortObtainCards:(int)nPlayer;
// 해당 플레이어의 특정 타입의 획득 카드 정렬
- (void) SortObtainCards:(int)nPlayer nCardType:(int)nCardType;
// 카드 획득
- (int) ObtainCard:(int)nPlayer nIdxCard:(int)nIdxCard;
// 카드를 받음
- (void) ReceiveCard:(int)nPlayer nIdxCard:(int) nIdxCard;

// 피를 뺏어옴
- (void) RobPee:(int)nPlayer;

// 플레이어 점수 계산
- (int) FigureOutScore:(int)nPlayer nInitialScore:(int)nInitialScore; //0

// 카드 추출 함수들
// 플레이어 보유 카드 추출
- (int) PopPlayerCard:(int)nPlayer nOffset:(int)nOffset;

// 정보 획득 함수들
//카드 타입 리턴
- (int) GetCardType:(int) nIdxCard;
// 쌍피냐?
- (BOOL) IsSsangPee:(int) nIdxCard;
// 해당 플레이어의 점수 리턴
- (int) GetScore:(int) nPlayer;
// 기본 게임 규칙 점수 계산
- (void) FigureOutGameRuleScore:(int) nPlayer;
// 게임 족보에 따른 규칙 점수 계산
- (void) FigureOutGostopHandsScore:(int) nPlayer;

// 멍따인지 리턴
- (BOOL) IsMungDda:(int) nPlayer;
// 총통 여부 체크
- (int) CheckPresident:(int) nPlayer;


// 플레이어 보유 카드 갯수 리턴
- (int) GetPlayerCardCount:(int) nPlayer;
// 플레이어 보유 카드 리턴
- (int) GetPlayerCard:(int)nPlayer  nOffset:(int) nOffset;
// 특월 월의 카드를 몇장 가지고 있는 지 체크
- (int) GetSameMonthCardsCount:(int) nPlayer  nIdxCard:(int) nIdxCard;

// 획득 카드 갯수 리턴
- (int) GetObtainedCardCount:(int) nPlayer  nCardType:(int) nCardType;
// 획득 카드 리턴
- (int) GetObtainedCard:(int) nPlayer nCardType: (int) nCardType  nOffset: (int) nOffset;

// 획득 피 장수 리턴
- (int) GetObtainedPeeCount:(int) nPlayer;
// 정렬
- (int) numbersort:(id) obj1 second: (id) obj2;


-(int) GetRobPeeCard;
@end