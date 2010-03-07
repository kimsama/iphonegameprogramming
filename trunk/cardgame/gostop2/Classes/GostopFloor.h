
#import "GostopCommon.h"
#import <Foundation/Foundation.h>

//
// CGostopFloor
//
@interface CGostopFloor : NSObject
{
	// 중앙 카드 슬롯 벡터
	NSMutableArray *m_vCenterCards;
	// 바닥 카드 슬롯 벡터
	NSMutableArray *m_vFloorCards[12];
    //vector<int> m_vCenterCards;
    //vector<int> m_vFloorCards[12];
	
	// 이전에 카드를 붙인 위치
    int m_nLastMonth;
	// 카드를 낸 월 기억
    int m_nPutOutMonth;
	// 뒤집어서 낸 월 기억
    int m_nTurnUpMonth;
	
	// 각 월별로 뻑을 한, 싼(!) 사람 기억
    int m_nPpuckConvict[12];
	
}
// 바닥 초기화
- (void) Init;
// 중앙의 카드를 섞어준다.
- (void) ShuffleCenterCards;

// 해당월이 보너스 카드를 갖고 있는지 리턴 , 갖고 있다면 보너스 카드의 오프셋 리턴
- (int) HasBonusCard:(int)nMonth;

// 바닥에 카드를 그냥 내려놓음
- (int) AddToFloor:(int)nIdxCard;
// 바닥의 특정 슬롯에 카드를 그냥 내려놓음
- (int) AddToFloor:(int)nIdxCard nMonth:(int)nMonth;
// 바닥에 카드를 냄
- (int) PutToFloor:(int)nPlayer nIdxCard:(int)nIdxCard;
// 바닥의 특정 슬롯에 카드를 냄
- (int) PutToFloor:(int)nPlayer nIdxCard:(int)nIdxCard nMonth:(int)nMonth;

// 바닥 정렬
- (void) SortFloor:(int) nMonth;

// 센터 카드 한장 추출
- (int) PopCenterCard;

// 해당월의 마지막 카드를 획득
- (int) PopFloorCard:(int) nMonth;
// 바닥 카드 획득
- (int) PopFloorCard:(int) nMonth byOffset:(Byte) byOffset;
// 바닥에 쌓여진 보너스 카드 획득
- (int) PopBonusCard:(int) nMonth;

- (int) GetCenterCard:(int)index;
// 센터 카드 갯수 리턴
- (int) GetCenterCardCount;

// 바닥 카드 장수 리턴
- (int) GetFloorCardCount:(int) nMonth;
// 일반 바닥 카드 장수 리턴
- (int) GetNormalFloorCardCount:(int) nMonth;
// 바닥 카드 리턴
- (int) GetFloorCard:(int) nMonth byOffset:(Byte) byOffset;

// 해당월의 보너스 카드 장수 리턴
- (int) GetBonusCardCount:(int)nMonth;

// 해당 카드가 붙게 될 바닥 슬롯
- (int) GetAvailableFloorSlot:(int)nCardIdx;

// 카드를 낸 월 리턴
- (int) GetPutOutMonth;

- (int) SetPutOutMonth:(int)nMonth;
// 카드를 뒤집어 낸 월 리턴
- (int) GetTurnUpMonth;

- (int) SetTurnUpMonth:(int)nMonth;

- (int) GetPpuckConvict:(int)nMonth;

- (int) SetPpuckConvict:(int)nMonth nSet:(int)nSet;

// 정렬
- (int) numbersort:(id) obj1 second: (id) obj2;

@end
