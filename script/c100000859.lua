 --Created and coded by Rising Phoenix
function c100000859.initial_effect(c)
	--trigger
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c100000859.check)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetDescription(aux.Stringid(100000859,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_EVENT_PLAYER)
	e4:SetCode(100000859)
	e4:SetTarget(c100000859.target)
	e4:SetOperation(c100000859.operation)
	c:RegisterEffect(e4)
	--s1
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetTarget(c100000859.targetse)
	e5:SetOperation(c100000859.activate)
	c:RegisterEffect(e5)
		--cannot act
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetRange(LOCATION_FZONE)
	e9:SetTargetRange(1,0)
	e9:SetValue(c100000859.actset)
	c:RegisterEffect(e9)
	--cannot set
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CANNOT_MSET)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetRange(LOCATION_FZONE)
	e10:SetValue(c100000859.actset)
	e10:SetTargetRange(1,0)
	e10:SetTarget(aux.TRUE)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetCode(EFFECT_CANNOT_SSET)
	e11:SetValue(c100000859.actset)
	c:RegisterEffect(e11)
	local e12=e10:Clone()
	e12:SetValue(c100000859.actset)
	e12:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e12)
	local e13=e10:Clone()
	e13:SetValue(c100000859.actset)
	e13:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e13:SetTarget(c100000859.sumlimit)
	c:RegisterEffect(e13)
	--cannot sp
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetRange(LOCATION_FZONE)
	e14:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e14:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e14:SetTargetRange(1,0)
	e14:SetTarget(c100000859.spslimit)
	c:RegisterEffect(e14)
		--cannot ns
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_FIELD)
	e15:SetRange(LOCATION_FZONE)
	e15:SetCode(EFFECT_CANNOT_SUMMON)
	e15:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e15:SetTargetRange(1,0)
	e15:SetTarget(c100000859.spslimit)
	c:RegisterEffect(e15)
end
function c100000859.spslimit(e,c)
	return not c:IsSetCard(0x10D)
end
function c100000859.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)~=0
end
function c100000859.actset(e,re,tp)
	local rc=re:GetHandler()
	return not rc:IsSetCard(0x10D) and not rc:IsImmuneToEffect(e)
end
function c100000859.filterse1(c)
	return c:IsCode(100000856) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c100000859.filterse2(c)
	return c:IsCode(100000853) and c:IsAbleToHand()
end
function c100000859.targetse(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000859.filterse1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c100000859.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100000859.filterse1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local mg=Duel.GetMatchingGroup(c100000859.filterse2,tp,LOCATION_DECK,0,nil)
		if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100000859,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c100000859.check(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local tp1=false local tp2=false
	while tc do
		local code=tc:GetCode()
		if tc:IsFaceup() and (code==100000856) then
			if tc:IsControler(tp) then tp1=true else tp2=true end
		end
		tc=eg:GetNext()
	end
	if tp1 then Duel.RaiseSingleEvent(c,100000859,e,r,rp,tp,0) end
	if tp2 then Duel.RaiseSingleEvent(c,100000859,e,r,rp,1-tp,0) end
end
function c100000859.filter(c)
	return c:IsType(TYPE_TRAP) or c:IsFacedown()
end
function c100000859.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c100000859.filter(chkc) end
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c100000859.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c100000859.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end