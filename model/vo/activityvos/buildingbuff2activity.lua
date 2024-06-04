local var0 = class("BuildingBuff2Activity", import("model.vo.Activity"))

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
	return arg0:getConfig("config_data")[1]
end

function var0.GetTotalBuildingLevel(arg0)
	local var0 = arg0:GetBuildingIds()
	local var1 = 0

	for iter0, iter1 in ipairs(var0) do
		var1 = var1 + arg0:GetBuildingLevel(iter1)
	end

	return math.floor(var1 / #var0)
end

function var0.GetBuildingLevelSum(arg0)
	local var0 = arg0:GetBuildingIds()
	local var1 = 0

	for iter0, iter1 in ipairs(var0) do
		var1 = var1 + (arg0:GetBuildingLevel(iter1) - 1)
	end

	return var1
end

function var0.GetSceneBuildingId(arg0)
	return arg0:getConfig("config_id")
end

function var0.GetLastRequestTime(arg0)
	return arg0.data1
end

function var0.RecordLastRequestTime(arg0)
	arg0.data1 = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.CanRequest(arg0)
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0) - 86400 > arg0:GetLastRequestTime()
end

return var0
