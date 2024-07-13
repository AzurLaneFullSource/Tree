local var0_0 = class("WorldBossArchivesAutoBattleCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = nowWorld():GetBossProxy()
	local var2_1 = var1_1:GetSelfBoss()

	if not var2_1 or var2_1:isDeath() then
		return
	end

	local var3_1 = WorldBossConst.GetAutoBattleOilConsume()

	if var3_1 > getProxy(PlayerProxy):getRawData():getResource(PlayerConst.ResOil) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_auto_battle_no_oil"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(34523, {
		boss_id = var0_1
	}, 34524, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(PlayerProxy):getData()

			var0_2:consume({
				oil = var3_1
			})
			getProxy(PlayerProxy):updatePlayer(var0_2)
			var1_1:UpdateAutoBattleFinishTime(arg0_2.auto_fight_finish_time)
			arg0_1:sendNotification(GAME.WORLD_ARCHIVES_BOSS_AUTO_BATTLE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
