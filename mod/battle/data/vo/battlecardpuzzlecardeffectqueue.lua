ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleCardPuzzleCardEffectQueue")

var0_0.Battle.BattleCardPuzzleCardEffectQueue = var1_0
var1_0.__name = "BattleCardPuzzleCardEffectQueue"
var1_0.QUEUE_TYPE_NORMAL = "normal"
var1_0.QUEUE_TYPE_RETURN = "return"

function var1_0.Ctor(arg0_1, arg1_1)
	arg0_1._card = arg1_1
	arg0_1._holdForInputMark = false
	arg0_1._condition = nil
	arg0_1._moveAfterCast = nil
	arg0_1._effectList = {}
	arg0_1._headEffect = nil
end

function var1_0.SetQueueType(arg0_2, arg1_2)
	arg0_2._queueType = arg1_2
end

function var1_0.GetQueueType(arg0_3)
	return arg0_3._queueType
end

function var1_0.ConfigData(arg0_4, arg1_4)
	arg0_4._condition = arg1_4.condition
	arg0_4._branch = arg1_4.branch

	local var0_4 = #arg1_4
	local var1_4 = -1

	while var0_4 > 0 do
		local var2_4 = arg1_4[var0_4]

		assert(var0_0.Battle[var2_4.type] ~= nil, "找不到对应的卡牌效果类型>>" .. var2_4.type .. "<<，检查卡牌ID：" .. arg0_4._card:GetCardID())

		local var3_4 = var0_0.Battle[var2_4.type].New(var2_4)

		if var3_4:HoldForInput() then
			arg0_4._holdForInputMark = true
		end

		if var3_4:MoveCardAfterCast() ~= arg0_4._moveAfterCast then
			arg0_4._moveAfterCast = var3_4:MoveCardAfterCast()
		end

		var3_4:ConfigCard(arg0_4._card)
		var3_4:SetQueue(arg0_4)

		arg0_4._effectList[var3_4] = var1_4
		var0_4 = var0_4 - 1
		var1_4 = var3_4
	end

	arg0_4._headEffect = var1_4
end

function var1_0.Start(arg0_5)
	if arg0_5._headEffect == -1 then
		arg0_5._card:QueueFinish(arg0_5)
	else
		arg0_5._headEffect:Execute()
	end
end

function var1_0.EffectFinale(arg0_6, arg1_6)
	local var0_6 = arg0_6._effectList[arg1_6]

	if var0_6 == -1 then
		arg0_6._card:QueueFinish(arg0_6)
	else
		var0_6:Execute()
	end
end

function var1_0.GetBranch(arg0_7)
	return arg0_7._branch
end

function var1_0.GetHoldForInputMark(arg0_8)
	return arg0_8._holdForInputMark
end

function var1_0.GetMoveAfterCast(arg0_9)
	return arg0_9._moveAfterCast
end

function var1_0.GetCondition(arg0_10)
	return arg0_10._condition
end
