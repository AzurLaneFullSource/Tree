local var0_0 = class("BuildingBuff2Activity", import("model.vo.Activity"))

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
	return arg0_4:getConfig("config_data")[1]
end

function var0_0.GetTotalBuildingLevel(arg0_5)
	local var0_5 = arg0_5:GetBuildingIds()
	local var1_5 = 0

	for iter0_5, iter1_5 in ipairs(var0_5) do
		var1_5 = var1_5 + arg0_5:GetBuildingLevel(iter1_5)
	end

	return math.floor(var1_5 / #var0_5)
end

function var0_0.GetBuildingLevelSum(arg0_6)
	local var0_6 = arg0_6:GetBuildingIds()
	local var1_6 = 0

	for iter0_6, iter1_6 in ipairs(var0_6) do
		var1_6 = var1_6 + (arg0_6:GetBuildingLevel(iter1_6) - 1)
	end

	return var1_6
end

function var0_0.GetSceneBuildingId(arg0_7)
	return arg0_7:getConfig("config_id")
end

function var0_0.GetLastRequestTime(arg0_8)
	return arg0_8.data1
end

function var0_0.RecordLastRequestTime(arg0_9)
	arg0_9.data1 = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.CanRequest(arg0_10)
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0) - 86400 > arg0_10:GetLastRequestTime()
end

return var0_0
