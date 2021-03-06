--Zorc Necrophades
function c512000044.initial_effect(c)
	c:SetUniqueOnField(1,1,512000044)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c512000044.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--cannot release
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5)
	--atkup
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SET_ATTACK_FINAL)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c512000044.atcon)
	e6:SetValue(c512000044.atkval)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e7:SetValue(c512000044.defval)
	c:RegisterEffect(e7)
	--
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetCode(EFFECT_CANNOT_LOSE_LP)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(1,0)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_CANNOT_LOSE_DECK)
	c:RegisterEffect(e9)
	local e10=e8:Clone()
	e10:SetCode(EFFECT_CANNOT_LOSE_EFFECT)
	c:RegisterEffect(e10)
end
function c512000044.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c512000044.atcon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
end
function c512000044.atkval(e,c)
	local bc=e:GetHandler():GetBattleTarget()
	if not bc then return 0 end
	return bc:GetAttack()
end
function c512000044.defval(e,c)
	local bc=e:GetHandler():GetBattleTarget()
	if not bc then return 0 end
	return bc:GetDefense()
end
