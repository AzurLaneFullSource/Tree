ys = ys or {}

local var0 = ys
local var1 = class("BattleCardPuzzleCardEffectQueue")

var0.Battle.BattleCardPuzzleCardEffectQueue = var1
var1.__name = "BattleCardPuzzleCardEffectQueue"
var1.QUEUE_TYPE_NORMAL = "normal"
var1.QUEUE_TYPE_RETURN = "return"

function var1.Ctor(arg0, arg1)
	arg0._card = arg1
	arg0._holdForInputMark = false
	arg0._condition = nil
	arg0._moveAfterCast = nil
	arg0._effectList = {}
	arg0._headEffect = nil
end

function var1.SetQueueType(arg0, arg1)
	arg0._queueType = arg1
end

function var1.GetQueueType(arg0)
	return arg0._queueType
end

function var1.ConfigData(arg0, arg1)
	arg0._condition = arg1.condition
	arg0._branch = arg1.branch

	local var0 = #arg1
	local var1 = -1

	while var0 > 0 do
		local var2 = arg1[var0]

		assert(var0.Battle[var2.type] ~= nil, "找不到对应的卡牌效果类型>>" .. var2.type .. "<<，检查卡牌ID：" .. arg0._card:GetCardID())

		local var3 = var0.Battle[var2.type].New(var2)

		if var3:HoldForInput() then
			arg0._holdForInputMark = true
		end

		if var3:MoveCardAfterCast() ~= arg0._moveAfterCast then
			arg0._moveAfterCast = var3:MoveCardAfterCast()
		end

		var3:ConfigCard(arg0._card)
		var3:SetQueue(arg0)

		arg0._effectList[var3] = var1
		var0 = var0 - 1
		var1 = var3
	end

	arg0._headEffect = var1
end

function var1.Start(arg0)
	if arg0._headEffect == -1 then
		arg0._card:QueueFinish(arg0)
	else
		arg0._headEffect:Execute()
	end
end

function var1.EffectFinale(arg0, arg1)
	local var0 = arg0._effectList[arg1]

	if var0 == -1 then
		arg0._card:QueueFinish(arg0)
	else
		var0:Execute()
	end
end

function var1.GetBranch(arg0)
	return arg0._branch
end

function var1.GetHoldForInputMark(arg0)
	return arg0._holdForInputMark
end

function var1.GetMoveAfterCast(arg0)
	return arg0._moveAfterCast
end

function var1.GetCondition(arg0)
	return arg0._condition
end
