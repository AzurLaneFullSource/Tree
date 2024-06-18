local var0_0 = class("CheckWorldBossStateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.bossId
	local var2_1 = var0_1.callback
	local var3_1 = tonumber(var0_1.time or 0)
	local var4_1 = var0_1.failedCallback

	local function var5_1()
		local var0_2 = getProxy(ChatProxy)
		local var1_2 = var0_2:GetMessagesByUniqueId(var1_1 .. "_" .. var3_1)

		for iter0_2, iter1_2 in ipairs(var1_2) do
			iter1_2.args.isDeath = true

			var0_2:UpdateMsg(iter1_2)
		end

		local var2_2 = getProxy(GuildProxy)
		local var3_2 = var2_2:GetMessagesByUniqueId(var1_1 .. "_" .. var3_1)

		for iter2_2, iter3_2 in ipairs(var3_2) do
			iter3_2.args.isDeath = true

			var2_2:UpdateMsg(iter3_2)
		end

		if var4_1 then
			var4_1()
		end
	end

	print("boss id", var1_1, " time:", var3_1)
	pg.ConnectionMgr.GetInstance():Send(34515, {
		boss_id = var1_1,
		last_time = var3_1
	}, 34516, function(arg0_3)
		if arg0_3.result == 0 then
			if var2_1 then
				var2_1()
			end
		elseif arg0_3.result == 1 then
			var5_1()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))
		elseif arg0_3.result == 3 then
			var5_1()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))
		elseif arg0_3.result == 6 then
			var5_1()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_max_challenge_cnt"))
		elseif arg0_3.result == 20 then
			var5_1()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
		end
	end)
end

return var0_0
