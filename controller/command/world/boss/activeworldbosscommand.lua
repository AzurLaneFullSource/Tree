local var0_0 = class("ActiveWorldBossCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.type

	pg.ConnectionMgr.GetInstance():Send(34521, {
		template_id = var1_1
	}, 34522, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = nowWorld():GetBossProxy()

			var0_2:RemoveSelfBoss()

			local var1_2 = WorldBoss.New()

			var1_2:Setup(arg0_2.boss, getProxy(PlayerProxy):getData())
			var1_2:UpdateBossType(WorldBoss.BOSS_TYPE_SELF)
			var1_2:SetJoinTime(pg.TimeMgr.GetInstance():GetServerTime())

			if var0_2.isSetup then
				var0_2:ClearRank(var1_2.id)
				var0_2:UpdateCacheBoss(var1_2)

				if var2_1 == WorldBossConst.BOSS_TYPE_CURR then
					local var2_2 = WorldBossConst.GetCurrBossConsume()

					var0_2:ConsumeSummonPt(var2_2)
				elseif var2_1 == WorldBossConst.BOSS_TYPE_ARCHIVES then
					local var3_2 = WorldBossConst.GetAchieveBossConsume()

					var0_2:ConsumeSummonPtOld(var3_2)
				end
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
