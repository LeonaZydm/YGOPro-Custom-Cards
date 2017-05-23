--DAL - AST
function c99970240.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99970240+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99970240.target)
  e1:SetOperation(c99970240.activate)
  c:RegisterEffect(e1)
end
function c99970240.spfilter(c,e,tp)
  return c:IsSetCard(0x997) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970240.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsType(TYPE_XYZ)
end
function c99970240.target(e,tp,eg,ep,ev,re,r,rp,chk)
  local b1=Duel.IsExistingMatchingCard(c99970240.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  local b2=Duel.IsExistingMatchingCard(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil)
  and Duel.IsExistingMatchingCard(c99970240.atkfilter,tp,LOCATION_MZONE,0,1,nil)
  if chk==0 then return b1 or b2 end
  local op=0
  if b1 and b2 then
  op=Duel.SelectOption(tp,aux.Stringid(99970240,0),aux.Stringid(99970240,1))
  elseif b1 then
  op=Duel.SelectOption(tp,aux.Stringid(99970240,0))
  else
  op=Duel.SelectOption(tp,aux.Stringid(99970240,1))+1
  end
  e:SetLabel(op)
  if op==0 then
  e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
  else
  e:SetCategory(CATEGORY_POSITION+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
  end
end
function c99970240.activate(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local op=e:GetLabel()
  if op==0 then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g1=Duel.SelectMatchingCard(tp,c99970240.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  if g1:GetCount()>0 and Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)~=0 then
  local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  tc=g2:GetFirst()
  while tc do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(-500)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  tc:RegisterEffect(e2)
  tc=g2:GetNext()
  end
  end
  else
  local g1=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
  Duel.ChangePosition(g1,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,0,0)
  local g2=Duel.GetMatchingGroup(c99970240.atkfilter,tp,LOCATION_MZONE,0,nil)
  local tc=g2:GetFirst()
  while tc do
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(500)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  tc=g2:GetNext()
  end
  end
end