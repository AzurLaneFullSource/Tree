local var0_0 = class("GetCacheBossHpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().callback
	local var1_1 = nowWorld():GetBossProxy()
	local var2_1 = var1_1:GetCacheBossList()

	if not var2_1 or #var2_1 == 0 then
		if var0_1 then
			var0_1()
		end

		return
	end

	local var3_1 = _.map(var2_1, function(arg0_2)
		return arg0_2.id
	end)

	pg.ConnectionMgr.GetInstance():Send(34517, {
		boss_id = var3_1
	}, 34518, function(arg0_3)
		for iter0_3, iter1_3 in pairs(arg0_3.list) do
			local var0_3 = var1_1:GetCacheBoss(iter1_3.id)

			if var0_3 then
				var0_3:UpdateHp(iter1_3.hp)
				var0_3:SetRankCnt(iter1_3.rank_count)
			end
		end

		if var0_1 then
			var0_1()
		end
	end)
end

return var0_0
