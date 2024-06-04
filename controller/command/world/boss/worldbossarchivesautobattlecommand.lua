local var0 = class("WorldBossArchivesAutoBattleCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id
	local var1 = nowWorld():GetBossProxy()
	local var2 = var1:GetSelfBoss()

	if not var2 or var2:isDeath() then
		return
	end

	local var3 = WorldBossConst.GetAutoBattleOilConsume()

	if var3 > getProxy(PlayerProxy):getRawData():getResource(PlayerConst.ResOil) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_auto_battle_no_oil"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(34523, {
		boss_id = var0
	}, 34524, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(PlayerProxy):getData()

			var0:consume({
				oil = var3
			})
			getProxy(PlayerProxy):updatePlayer(var0)
			var1:UpdateAutoBattleFinishTime(arg0.auto_fight_finish_time)
			arg0:sendNotification(GAME.WORLD_ARCHIVES_BOSS_AUTO_BATTLE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
