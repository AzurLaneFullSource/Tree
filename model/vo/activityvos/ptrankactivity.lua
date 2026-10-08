local var0_0 = class("PTRankActivity", import("model.vo.Activity"))

function var0_0.GetPTDrop(arg0_1)
	local var0_1 = arg0_1:getConfig("config_data")
	local var1_1 = type(var0_1) == "table" and var0_1[1] or DROP_TYPE_RESOURCE

	return Drop.New({
		count = 0,
		type = var1_1,
		id = arg0_1:getConfig("config_id")
	})
end

function var0_0.GetTotalPtCount(arg0_2)
	return arg0_2.data1
end

function var0_0.IsShowRank(arg0_3)
	local var0_3 = arg0_3:getConfig("config_data")
	local var1_3 = type(var0_3)

	return (var1_3 == "table" and var0_3[2] or var1_3 == "number" and tonumber(var0_3) or 0) > 0
end

return var0_0
