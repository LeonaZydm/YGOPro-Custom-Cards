 --Created and coded by Rising Phoenix
function c100000837.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--avoid negate summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e1:SetOperation(c100000837.activate)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100000837,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c100000837.retcon)
	e3:SetTarget(c100000837.rettg)
	e3:SetOperation(c100000837.retop)
	c:RegisterEffect(e3)
end
function c100000837.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x10B)
end
function c100000837.activate(e,tp,eg,ep,ev,re,r,rp)
	local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if opt==0 then end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
		e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x10B))
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_DISABLE_FLIP_SUMMON)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_SUMMON_SUCCESS)
		e4:SetCondition(c100000837.sumcon)
		e4:SetOperation(c100000837.sumsuc)
		Duel.RegisterEffect(e4,tp)
		local e5=e4:Clone()
		e5:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e5,tp)
		local e6=e4:Clone()
		e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(e6,tp)
end		
function c100000837.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100000837.filter,1,nil)
end
function c100000837.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c100000837.efun)
end
function c100000837.efun(e,ep,tp)
	return ep==tp
end
function c100000837.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY)
end
function c100000837.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	e:GetHandler():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c100000837.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,REASON_EFFECT,nil)
		Duel.ConfirmCards(1-tp,c)
	end
end