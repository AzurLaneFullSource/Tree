local var0_0 = class("MiniGameHubData", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.id = arg1_1.id
	arg0_1.configId = arg1_1.id
	arg0_1.count = arg1_1.available_cnt or arg0_1:getConfig("reborn_times")
	arg0_1.usedtime = arg1_1.used_cnt or 0
	arg0_1.ultimate = arg1_1.ultimate or 0
	arg0_1.highScores = {}

	underscore.each(arg1_1.maxscores or {}, function(arg0_2)
		arg0_1.highScores[arg0_2.key] = {
			arg0_2.value1,
			arg0_2.value2
		}
	end)
end

function var0_0.bindConfigTable(arg0_3)
	return pg.mini_game_hub
end

function var0_0.UpdateData(arg0_4, arg1_4)
	arg0_4.count = arg1_4.available_cnt or arg0_4.count
	arg0_4.usedtime = arg1_4.used_cnt or arg0_4.usedtime
	arg0_4.ultimate = arg1_4.ultimate or arg0_4.ultimate

	local var0_4 = arg1_4.maxscores

	underscore.each(arg1_4.maxscores or {}, function(arg0_5)
		arg0_4.highScores[arg0_5.key] = {
			arg0_5.value1,
			arg0_5.value2
		}
	end)
	print("Hub 更新", "ID:", tostring(arg0_4.id), "Count:", tostring(arg0_4.count), "UsedTime:", tostring(arg0_4.usedtime), "Ultimate:", tostring(arg0_4.ultimate))
end

function var0_0.CheckInTime(arg0_6)
	local var0_6 = arg0_6:getConfig("act_id")

	if var0_6 ~= nil then
		local var1_6 = pg.activity_template[var0_6]

		if var1_6 then
			local var2_6 = var1_6.time

			return (pg.TimeMgr.GetInstance():inTime(var2_6))
		end
	else
		return true
	end
end

return var0_0
