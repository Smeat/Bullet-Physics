/*
Physics Effects Copyright(C) 2011 Sony Computer Entertainment Inc.
All rights reserved.

Physics Effects is open software; you can redistribute it and/or
modify it under the terms of the BSD License.

Physics Effects is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the BSD License for more details.

A copy of the BSD License is distributed with
Physics Effects under the filename: physics_effects_license.txt
*/

#ifndef BT_LOW_LEVEL_DATA_H
#define BT_LOW_LEVEL_DATA_H

#include "physics_effects/base_level/broadphase/pfx_broadphase_pair.h"

namespace sce
{
	namespace PhysicsEffects
	{
		class	PfxContactManifold;
		class	PfxRigidState;
		class	PfxCollidable;
		class	PfxRigidBody;
		struct	PfxSolverBody;
	};
};

struct btLowLevelData
{
	btLowLevelData()
		:m_pairSwap(0),
		m_maxPairs(0),
		m_contacts(0),
		m_numContacts(0),
		m_maxContacts(0),
		m_contactIdPool(0),
		m_numContactIdPool(0),
		m_states(0),
		m_collidables(0),
		m_numRigidBodies(0),
		m_maxNumRigidBodies(0)
	{
		m_numPairs[0]=0;
		m_numPairs[1]=0;
		m_pairsBuff[0]=0;
		m_pairsBuff[1]=0;
	}
	
	///broadphase pairs
	unsigned int					m_pairSwap;
	unsigned int					m_numPairs[2];
	sce::PhysicsEffects::PfxBroadphasePair*				m_pairsBuff[2];
	int								m_maxPairs;

	//J コンタクト
	//E Contacts
	sce::PhysicsEffects::PfxContactManifold*		m_contacts;
	int								m_numContacts;
	int								m_maxContacts;

	int*							m_contactIdPool;
	int								m_numContactIdPool;

	sce::PhysicsEffects::PfxRigidState*			m_states;
	sce::PhysicsEffects::PfxCollidable*			m_collidables;
	sce::PhysicsEffects::PfxRigidBody*			m_bodies;
	sce::PhysicsEffects::PfxSolverBody*			m_solverBodies;

	int								m_numRigidBodies;
	int								m_maxNumRigidBodies;

	

	inline int						getNumCurrentPairs() const
	{
		return m_numPairs[m_pairSwap];
	}
	inline sce::PhysicsEffects::PfxBroadphasePair*		getCurrentPairs()
	{
		return &m_pairsBuff[m_pairSwap][0];
	}


};

#endif //BT_LOW_LEVEL_DATA_H