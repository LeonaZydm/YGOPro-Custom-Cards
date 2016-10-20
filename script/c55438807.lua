--T.M. Lord Majesti
function c55438807.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c55438807.fscon)
	e1:SetOperation(c55438807.fsop)
	c:RegisterEffect(e1)
	--spsummon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(55438807,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c55438807.con)
	e2:SetTarget(c55438807.tg)
	e2:SetOperation(c55438807.op)
	c:RegisterEffect(e2)
	--material check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c55438807.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--cannot be effect target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(c55438807.atkup)
	c:RegisterEffect(e5)
end
c55438807.material_count=2
c55438807.material={55438799,55438795}
function c55438807.valcheck(e,c)
	local ct=e:GetHandler():GetMaterial():GetClassCount(Card.GetCode)
	e:GetLabelObject():SetLabel(ct)
end
function c55438807.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c55438807.atkup(e,c)
	return Duel.GetMatchingGroupCount(c55438807.atkfilter,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*100
end
function c55438807.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c55438807.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	local con3,con5,con8,con10=nil
	if ct>=3 then
		con3=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,3,nil)
			and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,3,nil)
	end
	if ct>=5 then
		con5=Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.IsPlayerCanDiscardDeck(1-tp,3)
	end
	if ct>=8 then
		con8=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_REMOVED,0,1,nil)
			and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_REMOVED,1,nil)
	end
	if ct>=10 then
		con10=Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)>0
	end
	if chk==0 then return con3 or con5 or con8 or con10 end
end
function c55438807.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct>=3 then
		local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,nil)
		local sg1=nil
		if g1:GetCount()>=3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			sg1=g1:Select(tp,3,3,nil)
		else sg1=g1 end
		local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
		local sg2=nil
		if g2:GetCount()>=3 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			sg2=g2:Select(1-tp,3,3,nil)
		else sg2=g2 end
		sg1:Merge(sg2)
		if sg1:GetCount()>0 then
			Duel.SendtoGrave(sg1,REASON_EFFECT)
		end
	end
	if ct>=5 then
		Duel.BreakEffect()
		Duel.DiscardDeck(tp,3,REASON_EFFECT)
		Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
	end
	if ct>=8 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_REMOVED,0,1,3,nil)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(1-tp,Card.IsFaceup,1-tp,LOCATION_REMOVED,0,1,3,nil)
		g1:Merge(g2)
		if g1:GetCount()>0 then
			Duel.SendtoGrave(g1,REASON_EFFECT+REASON_RETURN)
		end
	end
	if ct>=10 then
		Duel.BreakEffect()
		local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
		Duel.SendtoGrave(g1,REASON_EFFECT)
	end
end
function c55438807.fcfilter1(c,code1,code2,g)
	local code=c:GetCode()
	return (code==code1 or code==code2) and g:IsExists(Card.IsAttribute,1,c,ATTRIBUTE_LIGHT)
end
function c55438807.fcfilter2(c,code,g)
	return (c:IsCode(code) or c:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)) and g:IsExists(Card.IsAttribute,1,c,ATTRIBUTE_LIGHT)
end
function c55438807.fcfilter3(c,g)
	return ((c:IsCode(55438799) or c:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)) and g:IsExists(Card.IsCode,1,c,55438795))
		or ((c:IsCode(55438795) or c:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)) and g:IsExists(Card.IsCode,1,c,55438799))
end
function c55438807.fcfilter4(c,code)
	return c:IsCode(code) or c:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)
end
function c55438807.fcfilter7(c,chkf)
	return aux.FConditionCheckF(c,chkf) and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsHasEffect(EFFECT_FUSION_SUBSTITUTE))
end
function c55438807.fscon(e,g,gc,chkf)
	if g==nil then return true end
	if gc then
		local mg=g:Clone()
		mg:RemoveCard(gc)
		if gc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE) then
			return mg:IsExists(c55438807.fcfilter1,1,nil,55438799,55438795,mg)
		elseif gc:IsCode(55438799) then
			return mg:IsExists(c55438807.fcfilter2,1,nil,55438795,mg)
		elseif gc:IsCode(55438795) then
			return mg:IsExists(c55438807.fcfilter2,1,nil,55438799,mg)
		elseif gc:IsAttribute(ATTRIBUTE_LIGHT) then
			return mg:IsExists(c55438807.fcfilter3,1,nil,mg)
		else
			return false
		end
	end
	local b1=0 local b2=0 local b3=0 local bs=0
	local fs=false
	local tc=g:GetFirst()
	while tc do
		if tc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE) then
			bs=1 if aux.FConditionCheckF(tc,chkf) then fs=true end
		elseif tc:IsCode(55438799) then
			if b1==0 then b1=1 else b3=1 end if aux.FConditionCheckF(tc,chkf) then fs=true end
		elseif tc:IsCode(55438795) then
			if b2==0 then b2=1 else b3=1 end if aux.FConditionCheckF(tc,chkf) then fs=true end
		elseif tc:IsAttribute(ATTRIBUTE_LIGHT) then
			b3=1 if aux.FConditionCheckF(tc,chkf) then fs=true end
		end
		tc=g:GetNext()
	end
	if chkf~=PLAYER_NONE then
		return fs and b1+b2+b3+bs>=3
	else
		return b1+b2+b3+bs>=3
	end
end
function c55438807.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local g1=Group.CreateGroup()
	if not gc and chkf~=PLAYER_NONE then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		gc=eg:FilterSelect(tp,c55438807.fcfilter7,1,1,nil,chkf):GetFirst()
		g1:AddCard(gc)
	end
	local mg=eg:Clone()
	if gc then mg:RemoveCard(gc) end
	local ok=false
	if gc then
		if gc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local sg=mg:FilterSelect(tp,c55438807.fcfilter1,1,1,nil,55438799,55438795,mg)
			g1:Merge(sg)
		elseif gc:IsCode(55438799) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local sg=mg:FilterSelect(tp,c55438807.fcfilter2,1,1,nil,55438795,mg)
			g1:Merge(sg)
		elseif gc:IsCode(55438795) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local sg=mg:FilterSelect(tp,c55438807.fcfilter2,1,1,nil,55438799,mg)
			g1:Merge(sg)
		elseif gc:IsAttribute(ATTRIBUTE_LIGHT) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local sg=mg:FilterSelect(tp,c55438807.fcfilter3,1,1,nil,55438799,55438795,mg)
			g1:Merge(sg)
			local tc1=sg:GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			if tc1:IsCode(55438799) then
				local sg=mg:FilterSelect(tp,c55438807.fcfilter4,1,1,nil,55438795)
				g1:Merge(sg)
			elseif tc1:IsCode(55438795) then
				local sg=mg:FilterSelect(tp,c55438807.fcfilter4,1,1,nil,55438799)
				g1:Merge(sg)
			else
				local sg=mg:FilterSelect(tp,aux.FConditionFilter21,1,1,nil,55438799,55438795)
				g1:Merge(sg)
			end
			ok=true
		end
	else
		local mg2=mg:Filter(aux.FConditionFilter22,nil,55438799,55438795,true)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg1=mg2:Select(tp,1,1,nil)
		local tc1=sg1:GetFirst()
		if not mg:IsExists(Card.IsAttribute,2,tc1,ATTRIBUTE_LIGHT) then
			mg2:Remove(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)
		end
		if tc1:IsHasEffect(EFFECT_FUSION_SUBSTITUTE) then
			mg2:Remove(Card.IsHasEffect,nil,EFFECT_FUSION_SUBSTITUTE)
		else mg2:Remove(Card.IsCode,nil,tc1:GetCode()) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg2=mg2:Select(tp,1,1,nil)
		g1:Merge(sg1)
		g1:Merge(sg2)
	end
	mg:Sub(g1)
	mg=mg:Filter(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)
	if mg:GetCount()==0 or (ok and not Duel.SelectYesNo(tp,93)) then
		Duel.SetFusionMaterial(g1)
		return
	end
	ok=false
	local dmg=mg:Filter(Card.IsLocation,nil,LOCATION_DECK)
	if dmg:GetCount()>0 and e:GetHandler():GetFlagEffect(31444249)~=0 and Duel.SelectYesNo(tp,aux.Stringid(31444249,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg=dmg:Select(tp,1,6-g1:FilterCount(Card.IsLocation,nil,LOCATION_DECK),nil)
		g1:Merge(sg)
		ok=true
	end
	if e:GetHandler():GetFlagEffect(31444249)~=0 then
		mg:Remove(Card.IsLocation,nil,LOCATION_DECK)
	end
	if mg:GetCount()==0 or (ok and not Duel.SelectYesNo(tp,93)) then
		Duel.SetFusionMaterial(g1)
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local sg=mg:Select(tp,1,99,nil)
	g1:Merge(sg)
	Duel.SetFusionMaterial(g1)
	return
end