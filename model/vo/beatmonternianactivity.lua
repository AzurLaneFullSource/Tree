local var0 = class("BeatMonterNianActivity", import(".Activity"))

function var0.GetDataConfig(arg0, arg1)
	local var0 = arg0:getConfig("config_id")
	local var1 = pg.activity_event_nianshou[tonumber(var0)]

	return var1 and var1[arg1]
end

function var0.GetCountForHitMonster(arg0)
	local var0 = arg0:getStartTime()
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2 = pg.TimeMgr.GetInstance():parseTimeFrom(var1 - var0)
	local var3 = arg0:GetDataConfig("daily_count")
	local var4 = arg0:GetDataConfig("first_extra_count")

	return (var2 + 1) * var3 + var4 - arg0.data2
end

return var0
