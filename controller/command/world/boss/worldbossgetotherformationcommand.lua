local var0 = class("WorldBossGetOtherFormationCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.bossId
	local var2 = var0.userId

	pg.ConnectionMgr.GetInstance():Send(34519, {
		boss_id = var1,
		userId = var2
	}, 34520, function(arg0)
		if arg0.result == 0 then
			local var0 = {}

			for iter0, iter1 in ipairs(arg0.ship_list) do
				local var1 = MetaBossRankShip.New(iter1)

				table.insert(var0, var1)
			end

			arg0:sendNotification(GAME.WORLD_BOSS_GET_FORMATION_DONE, {
				ships = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
