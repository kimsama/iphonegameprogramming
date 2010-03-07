
#define GAME_TOTAL_BONUS2           1
#define GAME_TOTAL_BONUS3           1
#define GAME_TOTAL_BONUSCARD       (GAME_TOTAL_BONUS2 + GAME_TOTAL_BONUS3)
#define GAME_TOTAL_CARD             (48 + GAME_TOTAL_BONUSCARD)

#define BONUSCARD                   48
#define BONUSCARD2                  48
#define BONUSCARD3                  49
#define BOMBCARD                    50

#define BACK_CARD                   GAME_TOTAL_CARD + 1


#define DISTRIBUTE_FLOOR_CARDS      8
#define DISTRIBUTE_PLAYER_CARDS     10

#define KUKJIN                      32
#define BIKWANG                     44

#define ANIMTIME					0.3
#define FLOOR_CARD_HSPACE 60
#define FLOOR_CARD_VSPACE 45
#define FLOOR_CARD_GAP    10
#define OBTAINED_CARD_GAP -17
#define PLAYER_CARD_SPACE 2
#define OPPONENT_CARD_SPACE 0
#define GAME_LEFT_SPACE 80
#define CARD_WIDTH 37
#define CARD_HEIGHT 56

#define NONE        -1
#define NOCARD      -1
//#define ISNOCARD(_CRESULT_)         ((_CRESULT_) < 0)
//#define ISBOMBCARD(_CARDINDEX_)     ((BOMBCARD) == (_CARDINDEX_))
//s#define ISBONUSCARD(_CARDINDEX_)    ((BONUSCARD2 == (_CARDINDEX_)) || (BONUSCARD3 == (_CARDINDEX_)))

// 플레이어 구분 상수
enum EPlayer
{
    PLAYER = 0,
    OPPONENT = 1,
    PLAYER_COUNT= 2,
};
// 카드타입 상수
enum ECardType
{
    KWANG = 0, // 광
    YEOL = 1, // 열
    TEE = 2, // 띠 
    PEE = 3, //피
    CARDTYPE_COUNT = 4,// 카드 타입 갯수
};
// 피타입
enum EPeeType
{
	// 일반 피
    NORMALPEE = 0,
	// 쌍피
    SSANGPEE = 1,
	// 2장 보너스
    BONUSPEE2 = 2,
	// 3장 보너스
    BONUSPEE3 = 3,
	// 피 타입 갯수
    PEETYPE_COUNT = 4,
};
// 게임내 규칙 상수
enum ERule
{
    GO = 0,
    SHAKE = 1,
    PPUCK = 2,
    RULE_COUNT = 3
};
// 바닥에 카드 내는 모드
enum EPutOutMode
{
    PM_NORMAL = 0, // 일반
    PM_SHAKE = 1, // 흔들기
    PM_BOMB = 2 // 폭탄
};
// 족보상수
enum EHands
{    
    HONGDAN = 0, 
    CHUNGDAN = 1,
    CHODAN = 2,
    GODORI = 3,
    HANDS_COUNT = 4
};
// 결과 룰 타입 상수
enum EResultRule
{
    RES_JJOCK = 0,
    RES_DDADDAK = 1,
    RES_PPUCK = 2,
    RES_EATPPUCK = 3,
    RES_EATJAPPUCK = 4,
    RESULTRULE_COUNT = 5
};

enum EGameState
{
	GS_NULL,
	// 게임 시작
	GS_START_NEWGAME,
	// 바닥 카드 분배
	GS_DISTRIBUTE,
	// 일반 플레이 상태 상수
	GS_PLAYING,
	// 턴 변경.
	GS_CHANGETURN,
	// 바닥에 카드 냄
	GS_PUTOUT_PLAYERCARD,
	// 상태 갯수
	GS_COUNT
};
// 카드 분배 상태 상수
enum EDistributeCardState
{
	// 대기 상태
	DC_READY,
	// 첫번째 바닥 카드 분배 애니메이션,
	//DC_FLOORCARDS_FIRST_ANI,
	// 첫번째 바닥 카드 분배.
	DC_FLOORCARDS_FIRST,
	//
	//DC_FLOORCARDS_SECOND_ANI,
	// 두번째 바닥 카드 분배
	DC_FLOORCARDS_SECOND,
	//
	//DC_PLAYERCARDS_FIRST_ANI,
	// 플레이어 카드 분배
	DC_PLAYERCARDS_FIRST,
	//
	//DC_OPPONENTCARDS_FIRST_ANI,
	// 상대방 카드 분배
	DC_OPPONENTCARDS_FIRST,
	//
	//DC_PLAYERCARDS_SECOND_ANI,
	// 플레이어 나머지 카드 분배
	DC_PLAYERCARDS_SECOND,
	//
	//DC_OPPONENTCARDS_SECOND_ANI,
	// 상대방 나머지 카드 분배
	DC_OPPONENTCARDS_SECOND,
	// 사용자 카드 정렬
	DC_SORT_CARDS,
	//
	//DC_PICKUP_BONUSCARDS_ANI,
	// 바닥에서 보너스 카드를 빼냄
	DC_PICKUP_BONUSCARDS,
	// 총통 검사
	DC_CHECK_PRESIDENT,
	// 마무리
	DC_FINISH,
    // 상태갯수
	DC_COUNT
};

// 카드를 바닥에 내는 상태 상수.
enum EPutOutState
{
	// 낼카드를 고름
	PO_PICKUP,
	// 흔들수 있는지 체크
	PO_CHECKSHAKE,
	// 카드를 바닥에 냄
	PO_PUTOUT,
	// 뒤집음
	PO_TURNUP,
	// 벌칙 룰 적용 체크
	PO_CHECKRULE,
	// 턴 변경
	PO_CHANGETURN,
	// 상태 갯수
	PO_COUNT
};

enum EChangeTurnState
{
	// 피를 뺏어옴
	CT_ROBPEE,
	// 게임이 끝났는지 확인
	CT_CHECKENDOFGAME,
	// 턴 변경
	CT_CHANGETURN,
	// 상태 갯수
	CT_COUNT
};

enum {
	kTagAnimationDance = 1,
	kTagSpriteManager = 1,
	KtagTileMap = 1,
};

enum {
	kTagSprite1,
	kTagSprite2,
	kTagSprite3,
	
};

enum {
	SND_GET,
	SND_MATCH,
	SND_CLICK,
};

