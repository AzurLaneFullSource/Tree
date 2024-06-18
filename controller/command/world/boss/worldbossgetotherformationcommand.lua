local var0_0 = class("WorldBossGetOtherFormationCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.bossId
	local var2_1 = var0_1.userId

	pg.ConnectionMgr.GetInstance():Send(34519, {
		boss_id = var1_1,
		userId = var2_1
	}, 34520, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.ship_list) do
				local var1_2 = MetaBossRankShip.New(iter1_2)

				table.insert(var0_2, var1_2)
			end

			arg0_1:sendNotification(GAME.WORLD_BOSS_GET_FORMATION_DONE, {
				ships = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
