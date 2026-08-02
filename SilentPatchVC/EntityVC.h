#pragma once

#include <cstdint>
#include <cstddef>

#include "Maths.h"
#include "TheFLAUtils.h"

enum // m_objectCreatedBy
{
	GAME_OBJECT = 1,
	MISSION_OBJECT = 2,
	TEMP_OBJECT = 3,
};

class CEntity
{
public:
	void*		__vmt;
	CMatrix		m_matrix;
	void*		clump;
	uint8_t		m_nType : 3;
	uint8_t		m_nState : 5;

	uint8_t		bUsesCollision : 1;
	uint8_t		bEntUFlag02 : 1;
	uint8_t		bIsStatic : 1;
	uint8_t		bEntUFlag04 : 1;
	uint8_t		bEntUFlag05 : 1;
	uint8_t		bEntUFlag06 : 1;
	uint8_t		bEntUFlag07 : 1;
	uint8_t		bRecordCollisions : 1;

	uint8_t		bEntUFlag09 : 1;
	uint8_t		bExplosionProof : 1;
	uint8_t		bIsVisible : 1;
	uint8_t		bHasCollided : 1;
	uint8_t		bRenderScorched : 1;
	uint8_t		bHasBlip : 1;
	uint8_t		bUseLevelSectors : 1;
	uint8_t		bIsBigBuilding : 1;

	uint8_t		bEntUFlag17 : 1;
	uint8_t		bBulletProof : 1;
	uint8_t		bFireProof : 1;
	uint8_t		bCollisionProof : 1;
	uint8_t		bMeleeProof : 1;
	uint8_t		bImmuneToNonPlayerDamage : 1;
	uint8_t		bEntUFlag23 : 1;
	uint8_t		bRemoveFromWorld : 1;

	std::byte	__pad4[7];
	FLAUtils::int16 m_modelIndex;

public:
	int32_t GetModelIndex() const
		{ return m_modelIndex.Get(); }

	const CMatrix& GetMatrix() const
		{ return m_matrix; }
};
