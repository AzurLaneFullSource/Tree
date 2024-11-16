local var0_0 = class("AirFightActivity", import("model.vo.Activity"))

function var0_0.GetMaxProgress(arg0_1)
	return arg0_1:getConfig("config_data")[1]
end

function var0_0.GetPerDayCount(arg0_2)
	return arg0_2:getConfig("config_data")[2]
end

function var0_0.GetPerLevelProgress(arg0_3)
	return arg0_3:getConfig("config_data")[3]
end

function var0_0.GetLevelCount(arg0_4)
	return arg0_4:GetMaxProgress() / arg0_4:GetPerLevelProgress()
end

function var0_0.readyToAchieve(arg0_5)
	if arg0_5:IsTip() then
		return false
	end

	local var0_5 = arg0_5:GetMaxProgress()
	local var1_5 = arg0_5:GetPerDayCount()
	local var2_5 = arg0_5:GetLevelCount()
	local var3_5 = 0

	for iter0_5 = 1, var2_5 do
		var3_5 = var3_5 + (arg0_5:getKVPList(1, iter0_5) or 0)
	end

	local var4_5 = pg.TimeMgr.GetInstance()
	local var5_5 = var4_5:DiffDay(arg0_5.data1, var4_5:GetServerTime()) + 1

	return var3_5 < math.min(var5_5 * var1_5, var0_5)
end

function var0_0.IsTip(arg0_6)
	local var0_6 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt("airfight_tip_" .. arg0_6.id .. "_" .. var0_6, 0) > pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.RecordTip(arg0_7)
	if arg0_7:IsTip() then
		return
	end

	local var0_7 = getProxy(PlayerProxy):getRawData().id
	local var1_7 = pg.TimeMgr.GetInstance():GetTimeToNextTime()

	PlayerPrefs.SetInt("airfight_tip_" .. arg0_7.id .. "_" .. var0_7, var1_7)
end

return var0_0
