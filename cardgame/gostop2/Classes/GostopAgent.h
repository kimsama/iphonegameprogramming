
#import "cocos2d.h"
#import "GostopCommon.h"
#import "GostopFloor.h"
#import "GostopCard.h"
#import "AudioToolbox/AudioServices.h"

@class CGostopCard;
@class CGostopFloor;
// 게임 상태 상수

//
typedef struct bonuscardinfo {
	int nMonth;
	int nCount;
}bonusinfo;

@interface CGostopAgent : CocosNode
{
	// 게임 상태
    int m_nGameState;
	// 에이젼시 상태 관리 스텝
    int m_nAgencyStep;
	// 게임 상태 변수
    int m_nGSParam1;
    int m_nGSParam2;
	// 바닥에 낼 플레이어 카드
    int m_nIdxPutOutCard;
	// 가운데 패에서 뒤집은 카드
	int m_nidxTurnUpCard;
	// 가운데 패에서 뒤집은 카드가 이동할 위치
	int m_nTurnUpCardMonth;
	// 흔듦 여부
    int m_nShakingMode;
	// 바닥에 낼 슬롯
    int m_nAvailableFloorSlot;
	//바닥 카드 관리 클래스
	CGostopFloor *m_Floor;
	// 플레이어 카드 관리 클래스
	CGostopCard *m_Card;
	// 현재 턴
    int m_nTurn;
	// 턴 변경시 , 뺏어와야할 피 카운트
    int m_nCntRobPee;
	// 플레이어 점수 기억 변수
    int m_nScore[PLAYER_COUNT];
	// 게임 규칙 카운트 변수
    int m_nCntRule[PLAYER_COUNT][RULE_COUNT];
	// 애니메이션 중이냐
	bool m_bAnimEvent;
	// 
	bool m_bPickUpCard;
	// 처음 시작된 판인지의 여부
	BOOL m_bFirstStart;
	
	
	bonusinfo m_sbonuscardinfo;
	// 움직일 카드
	NSMutableArray *MoveCards;
	// 움직일 위치
	CGPoint Movepoint;
	
	AtlasSpriteManager * m_atlasmgr;
	
	
    CGPoint m_coFloorCards[13];
    CGPoint m_coPlayerCards[2][10];
	CGPoint m_coObtainedCards[2][CARDTYPE_COUNT];
	CGPoint m_coScore[2];
	CGPoint m_coRule[2][RULE_COUNT];
	
	AtlasSprite *m_sprBack[10];
	AtlasSprite *m_sprCard[GAME_TOTAL_CARD];
	AtlasSprite *m_sprOppCardBack[DISTRIBUTE_PLAYER_CARDS];
	AtlasSprite *m_sprBombCard;
	//AtlasSprite *m_sprBackGround;
	
	Label* pslabel;
	Label* oslabel;
	Label* pglabel;
	Label* oglabel;
	Label* pshlabel;
	Label* oshlabel;
	Label* pplabel;
	Label* oplabel;
	// sound
	SystemSoundID m_sndmatchcard; //때렸을때
	SystemSoundID m_sndgetcard; //얻을때
	SystemSoundID m_sndclickcard; // 눌렀을때
	
}


// 새 게임 시작
- (void) StartNewGame;
// 게임 초기화
- (void) InitGame;
// 게임 상태 변경
- (void) ChangeState:(int)nGameState;
// 게임 진행
- (void) DoAgency:(NSTimer*)Timer;
// 타이머 함수 실행
- (void) StartTimerfunc;
// 카드 분배
- (void) DealDistributeCards;
// 보너스 카드 픽업.
- (void) DealPickUpBonusCards;
// 총통 체크
- (BOOL) DealCheckPresident;
// 플레이어 카드를 바닥에 내는 것 처리
- (void) DealPutOutPlayerCards;
// 턴 변경
- (void) DealChangeTurn;

// 특정 이벤트 처리 함수
// 플레이어 보유  카드중 하나를 바닥에 낸다.
- (void) PutOutPlayerCard:(int)nOffsetPlayerCard;
// 바닥에 있는 카드 획득
- (void) ObtainFloorCard:(int)nMonth;
// 현재 턴 플레이어가 카드 획득
- (int) ObtainCard:(int)nIdxCard;
// 플레이어의 점수 계산
- (void) FigureOutScore;
// 카드 추출 함수
// 센터 카드 한장 추출
- (int) PopCenterCard;
// 해당 월의 맨 마지막 카드 획득
- (int) PopFloorCard:(int) nMonth;
// 바닥 카드 획득
- (int) PopFloorCard:(int) nMonth byOffset:(Byte) byOffset;
// 정보획득 함수
// 현재 상태 리턴
- (int) GetState;
// 현재 턴 설정
- (void) SetTurn:(int) nPlayer;
// 현재 턴 리턴
- (int) GetTurn;
// 카드 타입 리턴
- (int) GetCardType:(int) nIdxCard;
// 해당 플레이어 점수 리턴
- (int) GetScore:(int) nPlayer;
// 해당 플레이어의 규칙 횟수 리턴
- (int) GetRuleCount:(int) nPlayer nRuleType:(int) nRuleType;
// 센터 카드 갯수 리턴

- (int) GetCenterCardCount;
// 바닥 카드 갯수 리턴
- (int) GetFloorCardCount:(int) nMonth;

// 현재 플레이어 보유 카드 갯수 리턴
- (int) GetPlayerCardCount;
// 플레이어 보유 카드 갯수 리턴
- (int) GetPlayerCardCount:(int) nPlayer;
// 플레이어 보유 카드 리턴
- (int) GetPlayerCard:(int) nOffset;
- (int) GetPlayerCard:(int) nPlayer nOffset:(int) nOffset;
// 획득 카드 갯수 리턴
- (int) GetObtainedCardCount:(int) nPlayer nCardType:(int) nCardType;
// 획득 카드 리턴
- (int) GetObtainedCard:(int) nPlayer  nCardType:(int)nCardType nOffset:(int) nOffset;

// 바닥 카드 리턴
- (int) GetFloorCard:(int)nMonth boffset:(Byte)boffset;

- (void) SetDefaultCoordination;

- (void) SetDisplayCoordination;

- (CGPoint) Getm_coFloorCards:(int)index;
- (CGPoint) Getm_coPlayerCards:(int)index1 index2:(int)index2;
- (CGPoint) Getm_coObtainedCards:(int)index1 index2:(int)index2;
- (CGPoint) Getm_coScore:(int)index1;
- (CGPoint) Getm_coRule:(int)index1 index2:(int)index2;

- (void) LoadSprites;
- (void) UnloadSprites;
- (void) DrawCenterCards;
- (void) DrawFloorCards;
- (void) DrawObtainedCards;
- (void) DrawPlayerCards;
- (void) DisplayGameProgress;
- (void) SetAtlasspritemgr:(AtlasSpriteManager*)mgr;

- (void) DrawAll;

- (void) MovingCard:(int)nIdxCard startpoint:(CGPoint)startpoint endpoint:(CGPoint)endpoint;
- (bool) IsMoving:(int)nIdxCard point:(CGPoint)point;
// 중앙 카드를 뒤집어 바닥에 냄
- (int) TurnUpCard:(int) nPlayer;
- (void) SetFirstStartGame:(bool) set;

// 카드를 전부 중앙덱으로 이동
- (void) MoveAllCardToDeck;

- (void) PlaySound:(int)type;

- (void) LoadSound;


@end