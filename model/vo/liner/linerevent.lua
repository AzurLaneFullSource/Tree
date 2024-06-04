local var0 = class("LinerEvent", import("model.vo.BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1
	arg0.configId = arg0.id
end

function var0.bindConfigTable(arg0)
	return pg.activity_liner_event
end

function var0.GetOptionName(arg0)
	return HXSet.hxLan(arg0:getConfig("option"))
end

function var0.GetOptionDisplay(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0:getConfig("option_desc_display")) do
		local var1 = HXSet.hxLan(iter1[1])

		table.insert(var0, var1)
	end

	return var0
end

function var0.GetTitle(arg0)
	return HXSet.hxLan(arg0:getConfig("title"))
end

function var0.GetLogDesc(arg0)
	return HXSet.hxLan(arg0:getConfig("option_desc"))
end

function var0.GetReasoningDesc(arg0)
	return HXSet.hxLan(arg0:getConfig("option_desc_2"))
end

return var0
