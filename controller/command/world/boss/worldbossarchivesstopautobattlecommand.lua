local var0 = class("WorldBossArchivesStopAutoBattleCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.type
	local var3 = nowWorld():GetBossProxy()
	local var4 = var3:GetSelfBoss()

	if not var4 then
		return
	end

	local var5 = var4.hp
	local var6 = var3:GetHighestDamage()

	pg.ConnectionMgr.GetInstance():Send(34525, {
		boss_id = var1
	}, 34526, function(arg0)
		if arg0.result == 0 then
			var3:ClearAutoBattle()

			local var0 = arg0.count or 0
			local var1 = arg0.damage or 0
			local var2 = arg0.oil or 0

			arg0:sendNotification(GAME.WORLD_ARCHIVES_BOSS_STOP_AUTO_BATTLE_DONE, {
				cnt = var0,
				damage = var1,
				oil = var2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
