local var0_0 = class("NewEducateBuff", import("model.vo.BaseVO"))

var0_0.TYPE = {
	TALENT = 1,
	TAROT = 3,
	ENTRY = 4,
	STATUS = 2
}
var0_0.RARITY = {
	BLUE = 1,
	GOLD = 3,
	PURPLE = 2,
	COLOURS = 4
}

function var0_0.bindConfigTable(arg0_1)
	return pg.child2_benefit_list
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.configId = arg0_2.id
	arg0_2.round = arg1_2.round
	arg0_2.isPending = arg1_2.is_pending == 1

	arg0_2:InitEndRound()

	arg0_2.effectNums = {}
end

function var0_0.InitEndRound(arg0_3)
	local var0_3 = arg0_3:getConfig("during_time")

	arg0_3.endRound = var0_3 == -1 and var0_3 or arg0_3.round + var0_3
end

function var0_0.IsPending(arg0_4)
	return arg0_4.isPending
end

function var0_0.GetEndRound(arg0_5)
	return arg0_5.endRound
end

function var0_0.OnNextRound(arg0_6, arg1_6)
	if not arg0_6.isPending then
		return
	end

	arg0_6.isPending = false
	arg0_6.round = arg1_6

	arg0_6:InitEndRound()
end

function var0_0.GetBenefitIdsByEffectType(arg0_7, arg1_7)
	local var0_7 = {}

	for iter0_7, iter1_7 in ipairs(arg0_7:getConfig("show_content")) do
		if underscore.any(pg.child2_benefit[iter1_7].effect, function(arg0_8)
			assert(type(arg0_8) == "table", "请检查effect配置的括号,benefit id:" .. iter1_7)

			return arg0_8[1] == arg1_7
		end) then
			table.insert(var0_7, iter1_7)
		end
	end

	return var0_7
end

function var0_0.UpdateDisplayNum(arg0_9, arg1_9)
	for iter0_9, iter1_9 in ipairs(arg1_9) do
		arg0_9.effectNums[iter1_9.key] = iter1_9.value
	end
end

function var0_0.GetDisplayNum(arg0_10, arg1_10)
	return arg0_10.effectNums[arg1_10] or 0
end

function var0_0.IsVisible(arg0_11)
	local var0_11 = pg.child2_benefit_list[arg0_11]

	return var0_11.ignore_on_collection ~= 1 and var0_11.is_show ~= 0
end

return var0_0
