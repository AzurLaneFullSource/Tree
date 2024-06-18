local var0_0 = class("BuildingBuffActivity", import("model.vo.Activity"))

function var0_0.GetBuildingConfigTable(arg0_1, arg1_1)
	return pg.activity_event_building[arg1_1]
end

function var0_0.GetBuildingLevel(arg0_2, arg1_2)
	return arg0_2.data1KeyValueList[2][arg1_2] or 1
end

function var0_0.SetBuildingLevel(arg0_3, arg1_3, arg2_3)
	arg0_3.data1KeyValueList[2][arg1_3] = arg2_3
end

function var0_0.GetBuildingIds(arg0_4)
	return arg0_4:getConfig("config_data")
end

function var0_0.GetMaterialCount(arg0_5, arg1_5)
	return arg0_5.data1KeyValueList[1][arg1_5] or 0
end

return var0_0
