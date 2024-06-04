local var0 = class("CheckWorldBossStateCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.bossId
	local var2 = var0.callback
	local var3 = tonumber(var0.time or 0)
	local var4 = var0.failedCallback

	local function var5()
		local var0 = getProxy(ChatProxy)
		local var1 = var0:GetMessagesByUniqueId(var1 .. "_" .. var3)

		for iter0, iter1 in ipairs(var1) do
			iter1.args.isDeath = true

			var0:UpdateMsg(iter1)
		end

		local var2 = getProxy(GuildProxy)
		local var3 = var2:GetMessagesByUniqueId(var1 .. "_" .. var3)

		for iter2, iter3 in ipairs(var3) do
			iter3.args.isDeath = true

			var2:UpdateMsg(iter3)
		end

		if var4 then
			var4()
		end
	end

	print("boss id", var1, " time:", var3)
	pg.ConnectionMgr.GetInstance():Send(34515, {
		boss_id = var1,
		last_time = var3
	}, 34516, function(arg0)
		if arg0.result == 0 then
			if var2 then
				var2()
			end
		elseif arg0.result == 1 then
			var5()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))
		elseif arg0.result == 3 then
			var5()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))
		elseif arg0.result == 6 then
			var5()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_max_challenge_cnt"))
		elseif arg0.result == 20 then
			var5()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
