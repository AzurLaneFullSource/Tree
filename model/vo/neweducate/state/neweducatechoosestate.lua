local var0_0 = class("NewEducateChooseState", import(".NewEducateStateBase"))

var0_0.TYPE = {
	ENTRY = 2,
	TAROT = 1
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1:UpdataData(arg1_1)

	arg0_1.finishFlag = false
end

function var0_0.IsPriorityType(arg0_2)
	return true
end

function var0_0.GetSystemNo(arg0_3)
	return NewEducatePriorityFSM.SYSTEM.CHOOSE
end

function var0_0.UpdataData(arg0_4, arg1_4)
	arg0_4.choices = {}

	for iter0_4, iter1_4 in ipairs(arg1_4.selects or {}) do
		table.insert(arg0_4.choices, iter1_4.id)
	end

	arg0_4.refreshCnts = arg1_4.reroll_count or {}
	arg0_4.isFromShop = arg1_4.is_from_shop == 1
end

function var0_0.GetChoices(arg0_5)
	return arg0_5.choices
end

function var0_0.GetUsedCnts(arg0_6)
	return arg0_6.refreshCnts
end

function var0_0.IsFromShop(arg0_7)
	return arg0_7.isFromShop
end

function var0_0.MarkFinish(arg0_8)
	arg0_8.finishFlag = true
end

function var0_0.IsFinish(arg0_9)
	return arg0_9.finishFlag
end

function var0_0.Reset(arg0_10)
	arg0_10.choices = {}
	arg0_10.refreshCnts = {}
	arg0_10.finishFlag = false
end

return var0_0
