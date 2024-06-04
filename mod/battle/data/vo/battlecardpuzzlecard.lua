ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = var0.Battle.BattleCardPuzzleEvent
local var4 = var0.Battle.BattleFormulas
local var5 = var0.Battle.BattleCardPuzzleFormulas
local var6 = var0.Battle.BattleConst
local var7 = var0.Battle.BattleConfig
local var8 = var0.Battle.BattleAttr
local var9 = var0.Battle.BattleDataFunction
local var10 = var0.Battle.BattleAttr
local var11 = class("BattleCardPuzzleCard")

var0.Battle.BattleCardPuzzleCard = var11
var11.__name = "BattleCardPuzzleCard"

function var11.GetCardEffectConfig(arg0)
	local var0 = "card_" .. arg0

	return pg.cardCfg[var0]
end

function var11.Ctor(arg0, arg1)
	arg0._client = arg1

	arg0:init()
end

function var11.init(arg0)
	arg0._timeStampList = {}
end

function var11.SetCardTemplate(arg0, arg1)
	arg0._cardID = arg1
	arg0._cardTemp = var9.GetPuzzleCardDataTemplate(arg0._cardID)

	local var0 = var11.GetCardEffectConfig(arg0._cardTemp.effect[1])

	arg0._iconID = arg0._cardTemp.icon
	arg0._cost = arg0._cardTemp.cost
	arg0._returnCost = var0.shuffle_cost
	arg0._labelList = arg0._cardTemp.label
	arg0._effectList = var0.effect_list
	arg0._shuffleEffectList = var0.shuffle_effect_list

	arg0:initCardEffectList()

	arg0._extraCost = var0.extra_cost
	arg0._castCondition = var0.cast_condition
	arg0._boostCondition = var0.boost_hint
end

function var11.GetCardTemplate(arg0)
	return arg0._cardTemp
end

function var11.GetCardID(arg0)
	return arg0._cardID
end

function var11.GetRarity(arg0)
	return arg0._cardTemp.rarity
end

function var11.GetCardType(arg0)
	return arg0._cardTemp.card_type
end

function var11.GetCardCD(arg0)
	return arg0._cardTemp.cooldown
end

function var11.GetLabels(arg0)
	return arg0._labelList
end

function var11.GetCurrentPile(arg0)
	return arg0._currentPile
end

function var11.SetCurrentPile(arg0, arg1)
	arg0._currentPile = arg1
end

function var11.GetFromPile(arg0)
	return arg0._fromPile
end

function var11.SetFromPile(arg0, arg1)
	arg0._fromPile = arg1
end

function var11.LabelContain(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		if table.contains(arg0._labelList, iter1) then
			return true
		end
	end

	return false
end

function var11.GetCastCondition(arg0)
	if not arg0._castCondition then
		return nil
	else
		return var5.parseCompare(arg0._castCondition, arg0._client:GetAttrManager())
	end
end

function var11.GetBaseCost(arg0)
	return arg0._cost
end

function var11.GetExtraCost(arg0)
	if not arg0._extraCost then
		return 0
	else
		return var5.parseFormula(arg0._extraCost, arg0._client:GetAttrManager())
	end
end

function var11.GetTotalCost(arg0)
	return math.max(arg0:GetBaseCost() + arg0:GetExtraCost(), 0)
end

function var11.GetReturnCost(arg0)
	return arg0._returnCost
end

function var11.IsBoost(arg0)
	if not arg0._boostCondition then
		return false
	else
		return var5.parseCompare(arg0._boostCondition, arg0._client:GetAttrManager())
	end
end

function var11.GetIconID(arg0)
	return arg0._iconID
end

function var11.GetMoveAfterCast(arg0)
	return arg0._moveAfterCaster
end

function var11.SetBaseEnergyFillDuration(arg0, arg1)
	local var0 = arg1 + pg.TimeMgr.GetInstance():GetCombatTime()

	arg0._timeStampList.energy = {
		duration = arg1,
		timeStamp = var0
	}
end

function var11.SetOverHeatDuration(arg0, arg1)
	timeStamp = arg1 + pg.TimeMgr.GetInstance():GetCombatTime()
	arg0._timeStampList.overheat = {
		duration = arg1,
		timeStamp = timeStamp
	}
end

function var11.GetCastRemainRate(arg0)
	local var0 = 0
	local var1 = 0

	for iter0, iter1 in pairs(arg0._timeStampList) do
		if var1 < iter1.timeStamp then
			var0 = iter1.duration
			var1 = iter1.timeStamp
		end
	end

	if var0 ~= 0 then
		return (var1 - pg.TimeMgr.GetInstance():GetCombatTime()) / var0
	else
		return 0
	end
end

function var11.Precast(arg0, arg1)
	arg0._castCallback = arg1

	if arg0._holdForInputMark then
		arg0._client:HoldForInput(arg0)
	else
		arg0:Cast()
	end
end

function var11.Cast(arg0)
	arg0:checkAndStartQueue(arg0._queueList)

	if arg0._castCallback then
		arg0._castCallback()
	end
end

function var11.Retrun(arg0, arg1)
	arg0:checkAndStartQueue(arg0._returnQueueList)
	arg1()
end

function var11.Active(arg0)
	arg0:checkAndStartQueue(arg0._queueList)
end

function var11.SetInputPoint(arg0, arg1)
	arg0._inputPoint = Clone(arg1)
end

function var11.GetInputPoint(arg0)
	return arg0._inputPoint
end

function var11.GetClient(arg0)
	return arg0._client
end

function var11.QueueFinish(arg0, arg1)
	local var0 = arg1:GetBranch()

	if var0 then
		local var1 = {}

		for iter0, iter1 in pairs(var0) do
			if var5.parseCompare(iter1, arg0._client:GetAttrManager()) then
				var1[iter0] = true
			end
		end

		local var2

		if arg1:GetQueueType() == var0.Battle.BattleCardPuzzleCardEffectQueue.QUEUE_TYPE_RETURN then
			local var3 = arg0._returnBranchQueueList
		else
			local var4 = arg0._branchQueueList
		end

		for iter2, iter3 in pairs(var1) do
			arg0._branchQueueList[iter2]:Start()
		end
	end
end

function var11.initCardEffectList(arg0)
	arg0._holdForInputMark = false
	arg0._moveAfterCaster = var0.Battle.BattleFleetCardPuzzleComponent.CARD_PILE_INDEX_DISCARD
	arg0._queueList, arg0._branchQueueList = {}, {}

	for iter0, iter1 in ipairs(arg0._effectList) do
		local var0 = var0.Battle.BattleCardPuzzleCardEffectQueue.New(arg0)

		var0:ConfigData(iter1)
		var0:SetQueueType(var0.Battle.BattleCardPuzzleCardEffectQueue.QUEUE_TYPE_NORMAL)
		table.insert(arg0._queueList, var0)

		if var0:GetHoldForInputMark() then
			arg0._holdForInputMark = true
		end
	end

	for iter2, iter3 in pairs(arg0._effectList) do
		local var1 = var0.Battle.BattleCardPuzzleCardEffectQueue.New(arg0)

		var1:ConfigData(iter3)
		var1:SetQueueType(var0.Battle.BattleCardPuzzleCardEffectQueue.QUEUE_TYPE_NORMAL)

		arg0._branchQueueList[iter2] = var1
	end

	if arg0._returnCost then
		arg0._returnQueueList, arg0._returnBranchQueueList = {}, {}

		for iter4, iter5 in ipairs(arg0._shuffleEffectList) do
			local var2 = var0.Battle.BattleCardPuzzleCardEffectQueue.New(arg0)

			var2:ConfigData(iter5)
			var2:SetQueueType(var0.Battle.BattleCardPuzzleCardEffectQueue.QUEUE_TYPE_RETURN)
			table.insert(arg0._returnQueueList, var2)
		end

		for iter6, iter7 in pairs(arg0._shuffleEffectList) do
			local var3 = var0.Battle.BattleCardPuzzleCardEffectQueue.New(arg0)

			var3:ConfigData(iter7)
			var3:SetQueueType(var0.Battle.BattleCardPuzzleCardEffectQueue.QUEUE_TYPE_RETURN)

			arg0._returnBranchQueueList[iter6] = var3
		end
	end
end

function var11.checkAndStartQueue(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		local var1 = iter1:GetCondition()

		if var1 and not var5.parseCompare(var1, arg0._client:GetAttrManager()) then
			var0[iter0] = false
		else
			arg0._moveAfterCaster = iter1:GetMoveAfterCast()
			var0[iter0] = true
		end
	end

	for iter2, iter3 in pairs(var0) do
		if iter3 == true then
			arg1[iter2]:Start()
		end
	end
end

function var11.GetCardEffectTargetFilterList(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0._effectList) do
		if not iter1.condition or var5.parseCompare(iter1.condition, arg0._client:GetAttrManager()) then
			arg0:checkQueueTarget(iter1, var0)
		end
	end

	return var0
end

var11.AIM_FX_EFFECT = {
	"BattleCardPuzzleSkillFire"
}

function var11.checkQueueTarget(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg1) do
		if table.contains(var11.AIM_FX_EFFECT, iter1.type) and iter1.target_choise then
			local var0 = arg2[iter1.caster] or {}

			table.insert(var0, iter1.target_choise)

			arg2[iter1.caster] = var0
		end
	end

	if arg1.branch then
		for iter2, iter3 in pairs(arg1.branch) do
			if var5.parseCompare(iter3, arg0._client:GetAttrManager()) then
				arg0:checkQueueTarget(arg0._effectList[iter2])
			end
		end
	end
end

function var11.GetIconPath(arg0)
	return CardPuzzleCard.GetCardIconPath(arg0:GetCardTemplate().icon)
end

function var11.GetType(arg0)
	return arg0:GetCardType()
end

function var11.GetName(arg0)
	return arg0:GetCardTemplate().name
end

function var11.GetDesc(arg0)
	return arg0:GetCardTemplate().discript
end

function var11.GetCost(arg0)
	return arg0:GetTotalCost()
end

function var11.GetKeywords(arg0)
	return CardPuzzleCard.GetCardKeyWord(arg0:GetCardTemplate().label)
end

function var11.getConfig(arg0, arg1)
	return arg0._cardTemp[arg1]
end
