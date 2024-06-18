local var0_0 = class("LinerEvent", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg0_1.id
end

function var0_0.bindConfigTable(arg0_2)
	return pg.activity_liner_event
end

function var0_0.GetOptionName(arg0_3)
	return HXSet.hxLan(arg0_3:getConfig("option"))
end

function var0_0.GetOptionDisplay(arg0_4)
	local var0_4 = {}

	for iter0_4, iter1_4 in ipairs(arg0_4:getConfig("option_desc_display")) do
		local var1_4 = HXSet.hxLan(iter1_4[1])

		table.insert(var0_4, var1_4)
	end

	return var0_4
end

function var0_0.GetTitle(arg0_5)
	return HXSet.hxLan(arg0_5:getConfig("title"))
end

function var0_0.GetLogDesc(arg0_6)
	return HXSet.hxLan(arg0_6:getConfig("option_desc"))
end

function var0_0.GetReasoningDesc(arg0_7)
	return HXSet.hxLan(arg0_7:getConfig("option_desc_2"))
end

return var0_0
