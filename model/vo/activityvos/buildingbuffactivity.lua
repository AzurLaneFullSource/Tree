local var0 = class("BuildingBuffActivity", import("model.vo.Activity"))

function var0.GetBuildingConfigTable(arg0, arg1)
	return pg.activity_event_building[arg1]
end

function var0.GetBuildingLevel(arg0, arg1)
	return arg0.data1KeyValueList[2][arg1] or 1
end

function var0.SetBuildingLevel(arg0, arg1, arg2)
	arg0.data1KeyValueList[2][arg1] = arg2
end

function var0.GetBuildingIds(arg0)
	return arg0:getConfig("config_data")
end

function var0.GetMaterialCount(arg0, arg1)
	return arg0.data1KeyValueList[1][arg1] or 0
end

return var0
