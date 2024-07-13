local var0_0 = class("BeatMonterNianActivity", import(".Activity"))

function var0_0.GetDataConfig(arg0_1, arg1_1)
	local var0_1 = arg0_1:getConfig("config_id")
	local var1_1 = pg.activity_event_nianshou[tonumber(var0_1)]

	return var1_1 and var1_1[arg1_1]
end

function var0_0.GetCountForHitMonster(arg0_2)
	local var0_2 = arg0_2:getStartTime()
	local var1_2 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2_2 = pg.TimeMgr.GetInstance():parseTimeFrom(var1_2 - var0_2)
	local var3_2 = arg0_2:GetDataConfig("daily_count")
	local var4_2 = arg0_2:GetDataConfig("first_extra_count")

	return (var2_2 + 1) * var3_2 + var4_2 - arg0_2.data2
end

return var0_0
