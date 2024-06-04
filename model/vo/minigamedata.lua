local var0 = class("MiniGameData", import(".BaseVO"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.id = arg1.id
	arg0.configId = arg1.id
	arg0.configCsv = arg0:getConfig("config_csv")
	arg0.configCsvKey = arg0:getConfig("config_csv_key")
	arg0.runtimeData = {}
	arg0.exData = nil
	arg0.rank = {}
	arg0._rankCd = 0
end

function var0.bindConfigTable(arg0)
	return pg.mini_game
end

function var0.GetSimpleValue(arg0, arg1)
	return arg0:getConfig("simple_config_data")[arg1]
end

function var0.GetConfigCsvValue(arg0, arg1)
	return pg[arg0.configCsv][arg0.configCsvKey][arg1]
end

function var0.GetConfigCsvLine(arg0, arg1)
	return pg[arg0.configCsv][arg1]
end

function var0.SetRuntimeData(arg0, arg1, arg2)
	arg0.runtimeData[arg1] = arg2
end

function var0.GetRuntimeData(arg0, arg1)
	return arg0.runtimeData[arg1]
end

function var0.CheckInTime(arg0)
	local var0 = getProxy(MiniGameProxy)
	local var1 = arg0:getConfig("hub_id")

	if var0:CheckHasHub(var1) then
		return var0:GetHubByHubId(var1):CheckInTime()
	else
		return false
	end
end

function var0.GetRank(arg0)
	return arg0.rank
end

function var0.SetRank(arg0, arg1)
	arg0._rankCd = GetHalfHour()
	arg0.rank = arg1
end

function var0.CanFetchRank(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() > arg0._rankCd
end

return var0
