local var0_0 = class("ActivitySelectableCommodity", import(".ActivityCommodity"))

function var0_0.Selectable(arg0_1)
	local var0_1 = arg0_1:getConfig("commodity_id_list")

	return var0_1 and var0_1 ~= "" and #var0_1 > 0
end

function var0_0.GetFirstDropId(arg0_2)
	return arg0_2:getConfig("commodity_id_list")
end

return var0_0
