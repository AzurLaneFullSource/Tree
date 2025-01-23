local var0_0 = class("NewEducateBuff", import("model.vo.BaseVO"))

var0_0.TYPE = {
	TALENT = 1,
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

function var0_0.Ctor(arg0_2, arg1_2, arg2_2)
	arg0_2.id = arg1_2
	arg0_2.configId = arg0_2.id
	arg0_2.round = arg2_2

	arg0_2:InitEndRound()
end

function var0_0.InitEndRound(arg0_3)
	local var0_3 = arg0_3:getConfig("during_time")

	arg0_3.endRound = var0_3 == -1 and var0_3 or arg0_3.round + var0_3
end

function var0_0.GetEndRound(arg0_4)
	return arg0_4.endRound
end

function var0_0.GetBenefitIdsByEffectType(arg0_5, arg1_5)
	local var0_5 = {}

	for iter0_5, iter1_5 in ipairs(arg0_5:getConfig("show_content")) do
		if underscore.any(pg.child2_benefit[iter1_5].effect, function(arg0_6)
			assert(type(arg0_6) == "table", "请检查effect配置的括号,benefit id:" .. iter1_5)

			return arg0_6[1] == arg1_5
		end) then
			table.insert(var0_5, iter1_5)
		end
	end

	return var0_5
end

return var0_0
