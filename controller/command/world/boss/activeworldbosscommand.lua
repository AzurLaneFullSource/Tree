local var0 = class("ActiveWorldBossCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.type

	pg.ConnectionMgr.GetInstance():Send(34521, {
		template_id = var1
	}, 34522, function(arg0)
		if arg0.result == 0 then
			local var0 = nowWorld():GetBossProxy()

			var0:RemoveSelfBoss()

			local var1 = WorldBoss.New()

			var1:Setup(arg0.boss, getProxy(PlayerProxy):getData())
			var1:UpdateBossType(WorldBoss.BOSS_TYPE_SELF)
			var1:SetJoinTime(pg.TimeMgr.GetInstance():GetServerTime())

			if var0.isSetup then
				var0:ClearRank(var1.id)
				var0:UpdateCacheBoss(var1)

				if var2 == WorldBossConst.BOSS_TYPE_CURR then
					local var2 = WorldBossConst.GetCurrBossConsume()

					var0:ConsumeSummonPt(var2)
				elseif var2 == WorldBossConst.BOSS_TYPE_ARCHIVES then
					local var3 = WorldBossConst.GetAchieveBossConsume()

					var0:ConsumeSummonPtOld(var3)
				end
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
