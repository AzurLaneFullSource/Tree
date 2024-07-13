ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = var0_0.Battle.BattleCardPuzzleEvent
local var4_0 = var0_0.Battle.BattleFormulas
local var5_0 = var0_0.Battle.BattleCardPuzzleFormulas
local var6_0 = var0_0.Battle.BattleConst
local var7_0 = var0_0.Battle.BattleConfig
local var8_0 = var0_0.Battle.BattleAttr
local var9_0 = var0_0.Battle.BattleDataFunction
local var10_0 = var0_0.Battle.BattleAttr
local var11_0 = class("BattleCardPuzzleCard")

var0_0.Battle.BattleCardPuzzleCard = var11_0
var11_0.__name = "BattleCardPuzzleCard"

function var11_0.GetCardEffectConfig(arg0_1)
	local var0_1 = "card_" .. arg0_1

	return pg.cardCfg[var0_1]
end

function var11_0.Ctor(arg0_2, arg1_2)
	arg0_2._client = arg1_2

	arg0_2:init()
end

function var11_0.init(arg0_3)
	arg0_3._timeStampList = {}
end

function var11_0.SetCardTemplate(arg0_4, arg1_4)
	arg0_4._cardID = arg1_4
	arg0_4._cardTemp = var9_0.GetPuzzleCardDataTemplate(arg0_4._cardID)

	local var0_4 = var11_0.GetCardEffectConfig(arg0_4._cardTemp.effect[1])

	arg0_4._iconID = arg0_4._cardTemp.icon
	arg0_4._cost = arg0_4._cardTemp.cost
	arg0_4._returnCost = var0_4.shuffle_cost
	arg0_4._labelList = arg0_4._cardTemp.label
	arg0_4._effectList = var0_4.effect_list
	arg0_4._shuffleEffectList = var0_4.shuffle_effect_list

	arg0_4:initCardEffectList()

	arg0_4._extraCost = var0_4.extra_cost
	arg0_4._castCondition = var0_4.cast_condition
	arg0_4._boostCondition = var0_4.boost_hint
end

function var11_0.GetCardTemplate(arg0_5)
	return arg0_5._cardTemp
end

function var11_0.GetCardID(arg0_6)
	return arg0_6._cardID
end

function var11_0.GetRarity(arg0_7)
	return arg0_7._cardTemp.rarity
end

function var11_0.GetCardType(arg0_8)
	return arg0_8._cardTemp.card_type
end

function var11_0.GetCardCD(arg0_9)
	return arg0_9._cardTemp.cooldown
end

function var11_0.GetLabels(arg0_10)
	return arg0_10._labelList
end

function var11_0.GetCurrentPile(arg0_11)
	return arg0_11._currentPile
end

function var11_0.SetCurrentPile(arg0_12, arg1_12)
	arg0_12._currentPile = arg1_12
end

function var11_0.GetFromPile(arg0_13)
	return arg0_13._fromPile
end

function var11_0.SetFromPile(arg0_14, arg1_14)
	arg0_14._fromPile = arg1_14
end

function var11_0.LabelContain(arg0_15, arg1_15)
	for iter0_15, iter1_15 in ipairs(arg1_15) do
		if table.contains(arg0_15._labelList, iter1_15) then
			return true
		end
	end

	return false
end

function var11_0.GetCastCondition(arg0_16)
	if not arg0_16._castCondition then
		return nil
	else
		return var5_0.parseCompare(arg0_16._castCondition, arg0_16._client:GetAttrManager())
	end
end

function var11_0.GetBaseCost(arg0_17)
	return arg0_17._cost
end

function var11_0.GetExtraCost(arg0_18)
	if not arg0_18._extraCost then
		return 0
	else
		return var5_0.parseFormula(arg0_18._extraCost, arg0_18._client:GetAttrManager())
	end
end

function var11_0.GetTotalCost(arg0_19)
	return math.max(arg0_19:GetBaseCost() + arg0_19:GetExtraCost(), 0)
end

function var11_0.GetReturnCost(arg0_20)
	return arg0_20._returnCost
end

function var11_0.IsBoost(arg0_21)
	if not arg0_21._boostCondition then
		return false
	else
		return var5_0.parseCompare(arg0_21._boostCondition, arg0_21._client:GetAttrManager())
	end
end

function var11_0.GetIconID(arg0_22)
	return arg0_22._iconID
end

function var11_0.GetMoveAfterCast(arg0_23)
	return arg0_23._moveAfterCaster
end

function var11_0.SetBaseEnergyFillDuration(arg0_24, arg1_24)
	local var0_24 = arg1_24 + pg.TimeMgr.GetInstance():GetCombatTime()

	arg0_24._timeStampList.energy = {
		duration = arg1_24,
		timeStamp = var0_24
	}
end

function var11_0.SetOverHeatDuration(arg0_25, arg1_25)
	timeStamp = arg1_25 + pg.TimeMgr.GetInstance():GetCombatTime()
	arg0_25._timeStampList.overheat = {
		duration = arg1_25,
		timeStamp = timeStamp
	}
end

function var11_0.GetCastRemainRate(arg0_26)
	local var0_26 = 0
	local var1_26 = 0

	for iter0_26, iter1_26 in pairs(arg0_26._timeStampList) do
		if var1_26 < iter1_26.timeStamp then
			var0_26 = iter1_26.duration
			var1_26 = iter1_26.timeStamp
		end
	end

	if var0_26 ~= 0 then
		return (var1_26 - pg.TimeMgr.GetInstance():GetCombatTime()) / var0_26
	else
		return 0
	end
end

function var11_0.Precast(arg0_27, arg1_27)
	arg0_27._castCallback = arg1_27

	if arg0_27._holdForInputMark then
		arg0_27._client:HoldForInput(arg0_27)
	else
		arg0_27:Cast()
	end
end

function var11_0.Cast(arg0_28)
	arg0_28:checkAndStartQueue(arg0_28._queueList)

	if arg0_28._castCallback then
		arg0_28._castCallback()
	end
end

function var11_0.Retrun(arg0_29, arg1_29)
	arg0_29:checkAndStartQueue(arg0_29._returnQueueList)
	arg1_29()
end

function var11_0.Active(arg0_30)
	arg0_30:checkAndStartQueue(arg0_30._queueList)
end

function var11_0.SetInputPoint(arg0_31, arg1_31)
	arg0_31._inputPoint = Clone(arg1_31)
end

function var11_0.GetInputPoint(arg0_32)
	return arg0_32._inputPoint
end

function var11_0.GetClient(arg0_33)
	return arg0_33._client
end

function var11_0.QueueFinish(arg0_34, arg1_34)
	local var0_34 = arg1_34:GetBranch()

	if var0_34 then
		local var1_34 = {}

		for iter0_34, iter1_34 in pairs(var0_34) do
			if var5_0.parseCompare(iter1_34, arg0_34._client:GetAttrManager()) then
				var1_34[iter0_34] = true
			end
		end

		local var2_34

		if arg1_34:GetQueueType() == var0_0.Battle.BattleCardPuzzleCardEffectQueue.QUEUE_TYPE_RETURN then
			local var3_34 = arg0_34._returnBranchQueueList
		else
			local var4_34 = arg0_34._branchQueueList
		end

		for iter2_34, iter3_34 in pairs(var1_34) do
			arg0_34._branchQueueList[iter2_34]:Start()
		end
	end
end

function var11_0.initCardEffectList(arg0_35)
	arg0_35._holdForInputMark = false
	arg0_35._moveAfterCaster = var0_0.Battle.BattleFleetCardPuzzleComponent.CARD_PILE_INDEX_DISCARD
	arg0_35._queueList, arg0_35._branchQueueList = {}, {}

	for iter0_35, iter1_35 in ipairs(arg0_35._effectList) do
		local var0_35 = var0_0.Battle.BattleCardPuzzleCardEffectQueue.New(arg0_35)

		var0_35:ConfigData(iter1_35)
		var0_35:SetQueueType(var0_0.Battle.BattleCardPuzzleCardEffectQueue.QUEUE_TYPE_NORMAL)
		table.insert(arg0_35._queueList, var0_35)

		if var0_35:GetHoldForInputMark() then
			arg0_35._holdForInputMark = true
		end
	end

	for iter2_35, iter3_35 in pairs(arg0_35._effectList) do
		local var1_35 = var0_0.Battle.BattleCardPuzzleCardEffectQueue.New(arg0_35)

		var1_35:ConfigData(iter3_35)
		var1_35:SetQueueType(var0_0.Battle.BattleCardPuzzleCardEffectQueue.QUEUE_TYPE_NORMAL)

		arg0_35._branchQueueList[iter2_35] = var1_35
	end

	if arg0_35._returnCost then
		arg0_35._returnQueueList, arg0_35._returnBranchQueueList = {}, {}

		for iter4_35, iter5_35 in ipairs(arg0_35._shuffleEffectList) do
			local var2_35 = var0_0.Battle.BattleCardPuzzleCardEffectQueue.New(arg0_35)

			var2_35:ConfigData(iter5_35)
			var2_35:SetQueueType(var0_0.Battle.BattleCardPuzzleCardEffectQueue.QUEUE_TYPE_RETURN)
			table.insert(arg0_35._returnQueueList, var2_35)
		end

		for iter6_35, iter7_35 in pairs(arg0_35._shuffleEffectList) do
			local var3_35 = var0_0.Battle.BattleCardPuzzleCardEffectQueue.New(arg0_35)

			var3_35:ConfigData(iter7_35)
			var3_35:SetQueueType(var0_0.Battle.BattleCardPuzzleCardEffectQueue.QUEUE_TYPE_RETURN)

			arg0_35._returnBranchQueueList[iter6_35] = var3_35
		end
	end
end

function var11_0.checkAndStartQueue(arg0_36, arg1_36)
	local var0_36 = {}

	for iter0_36, iter1_36 in ipairs(arg1_36) do
		local var1_36 = iter1_36:GetCondition()

		if var1_36 and not var5_0.parseCompare(var1_36, arg0_36._client:GetAttrManager()) then
			var0_36[iter0_36] = false
		else
			arg0_36._moveAfterCaster = iter1_36:GetMoveAfterCast()
			var0_36[iter0_36] = true
		end
	end

	for iter2_36, iter3_36 in pairs(var0_36) do
		if iter3_36 == true then
			arg1_36[iter2_36]:Start()
		end
	end
end

function var11_0.GetCardEffectTargetFilterList(arg0_37)
	local var0_37 = {}

	for iter0_37, iter1_37 in ipairs(arg0_37._effectList) do
		if not iter1_37.condition or var5_0.parseCompare(iter1_37.condition, arg0_37._client:GetAttrManager()) then
			arg0_37:checkQueueTarget(iter1_37, var0_37)
		end
	end

	return var0_37
end

var11_0.AIM_FX_EFFECT = {
	"BattleCardPuzzleSkillFire"
}

function var11_0.checkQueueTarget(arg0_38, arg1_38, arg2_38)
	for iter0_38, iter1_38 in ipairs(arg1_38) do
		if table.contains(var11_0.AIM_FX_EFFECT, iter1_38.type) and iter1_38.target_choise then
			local var0_38 = arg2_38[iter1_38.caster] or {}

			table.insert(var0_38, iter1_38.target_choise)

			arg2_38[iter1_38.caster] = var0_38
		end
	end

	if arg1_38.branch then
		for iter2_38, iter3_38 in pairs(arg1_38.branch) do
			if var5_0.parseCompare(iter3_38, arg0_38._client:GetAttrManager()) then
				arg0_38:checkQueueTarget(arg0_38._effectList[iter2_38])
			end
		end
	end
end

function var11_0.GetIconPath(arg0_39)
	return CardPuzzleCard.GetCardIconPath(arg0_39:GetCardTemplate().icon)
end

function var11_0.GetType(arg0_40)
	return arg0_40:GetCardType()
end

function var11_0.GetName(arg0_41)
	return arg0_41:GetCardTemplate().name
end

function var11_0.GetDesc(arg0_42)
	return arg0_42:GetCardTemplate().discript
end

function var11_0.GetCost(arg0_43)
	return arg0_43:GetTotalCost()
end

function var11_0.GetKeywords(arg0_44)
	return CardPuzzleCard.GetCardKeyWord(arg0_44:GetCardTemplate().label)
end

function var11_0.getConfig(arg0_45, arg1_45)
	return arg0_45._cardTemp[arg1_45]
end
