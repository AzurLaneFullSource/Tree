local var0 = class("MiniGameHubData", import(".BaseVO"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.id = arg1.id
	arg0.configId = arg1.id
	arg0.count = arg1.available_cnt or arg0:getConfig("reborn_times")
	arg0.usedtime = arg1.used_cnt or 0
	arg0.ultimate = arg1.ultimate or 0
	arg0.highScores = {}

	underscore.each(arg1.maxscores or {}, function(arg0)
		arg0.highScores[arg0.key] = {
			arg0.value1,
			arg0.value2
		}
	end)
end

function var0.bindConfigTable(arg0)
	return pg.mini_game_hub
end

function var0.UpdateData(arg0, arg1)
	arg0.count = arg1.available_cnt or arg0.count
	arg0.usedtime = arg1.used_cnt or arg0.usedtime
	arg0.ultimate = arg1.ultimate or arg0.ultimate

	local var0 = arg1.maxscores

	underscore.each(arg1.maxscores or {}, function(arg0)
		arg0.highScores[arg0.key] = {
			arg0.value1,
			arg0.value2
		}
	end)
	print("Hub 更新", "ID:", tostring(arg0.id), "Count:", tostring(arg0.count), "UsedTime:", tostring(arg0.usedtime), "Ultimate:", tostring(arg0.ultimate))
end

function var0.CheckInTime(arg0)
	local var0 = arg0:getConfig("act_id")

	if var0 ~= nil then
		local var1 = pg.activity_template[var0]

		if var1 then
			local var2 = var1.time

			return (pg.TimeMgr.GetInstance():inTime(var2))
		end
	else
		return true
	end
end

return var0
