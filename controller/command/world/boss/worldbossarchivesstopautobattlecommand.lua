local var0_0 = class("WorldBossArchivesStopAutoBattleCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.type
	local var3_1 = nowWorld():GetBossProxy()
	local var4_1 = var3_1:GetSelfBoss()

	if not var4_1 then
		return
	end

	local var5_1 = var4_1.hp
	local var6_1 = var3_1:GetHighestDamage()

	pg.ConnectionMgr.GetInstance():Send(34525, {
		boss_id = var1_1
	}, 34526, function(arg0_2)
		if arg0_2.result == 0 then
			var3_1:ClearAutoBattle()

			local var0_2 = arg0_2.count or 0
			local var1_2 = arg0_2.damage or 0
			local var2_2 = arg0_2.oil or 0

			arg0_1:sendNotification(GAME.WORLD_ARCHIVES_BOSS_STOP_AUTO_BATTLE_DONE, {
				cnt = var0_2,
				damage = var1_2,
				oil = var2_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
