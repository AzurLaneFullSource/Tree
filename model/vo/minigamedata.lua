local var0_0 = class("MiniGameData", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.id = arg1_1.id
	arg0_1.configId = arg1_1.id
	arg0_1.configCsv = arg0_1:getConfig("config_csv")
	arg0_1.configCsvKey = arg0_1:getConfig("config_csv_key")
	arg0_1.runtimeData = {}
	arg0_1.exData = nil
	arg0_1.rank = {}
	arg0_1._rankCd = 0
end

function var0_0.bindConfigTable(arg0_2)
	return pg.mini_game
end

function var0_0.GetSimpleValue(arg0_3, arg1_3)
	return arg0_3:getConfig("simple_config_data")[arg1_3]
end

function var0_0.GetConfigCsvValue(arg0_4, arg1_4)
	return pg[arg0_4.configCsv][arg0_4.configCsvKey][arg1_4]
end

function var0_0.GetConfigCsvLine(arg0_5, arg1_5)
	return pg[arg0_5.configCsv][arg1_5]
end

function var0_0.SetRuntimeData(arg0_6, arg1_6, arg2_6)
	arg0_6.runtimeData[arg1_6] = arg2_6
end

function var0_0.GetRuntimeData(arg0_7, arg1_7)
	return arg0_7.runtimeData[arg1_7]
end

function var0_0.CheckInTime(arg0_8)
	local var0_8 = getProxy(MiniGameProxy)
	local var1_8 = arg0_8:getConfig("hub_id")

	if var0_8:CheckHasHub(var1_8) then
		return var0_8:GetHubByHubId(var1_8):CheckInTime()
	else
		return false
	end
end

function var0_0.GetRank(arg0_9)
	return arg0_9.rank
end

function var0_0.SetRank(arg0_10, arg1_10)
	arg0_10._rankCd = GetHalfHour()
	arg0_10.rank = arg1_10
end

function var0_0.CanFetchRank(arg0_11)
	return pg.TimeMgr.GetInstance():GetServerTime() > arg0_11._rankCd
end

return var0_0
