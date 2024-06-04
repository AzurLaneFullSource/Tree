local var0 = class("GetCacheBossHpCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().callback
	local var1 = nowWorld():GetBossProxy()
	local var2 = var1:GetCacheBossList()

	if not var2 or #var2 == 0 then
		if var0 then
			var0()
		end

		return
	end

	local var3 = _.map(var2, function(arg0)
		return arg0.id
	end)

	pg.ConnectionMgr.GetInstance():Send(34517, {
		boss_id = var3
	}, 34518, function(arg0)
		for iter0, iter1 in pairs(arg0.list) do
			local var0 = var1:GetCacheBoss(iter1.id)

			if var0 then
				var0:UpdateHp(iter1.hp)
				var0:SetRankCnt(iter1.rank_count)
			end
		end

		if var0 then
			var0()
		end
	end)
end

return var0
