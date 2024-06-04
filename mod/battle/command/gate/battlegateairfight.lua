local var0 = class("BattleGateAirFight")

ys.Battle.BattleGateAirFight = var0
var0.__name = "BattleGateAirFight"

function var0.Entrance(arg0, arg1)
	local var0 = arg0.stageId
	local var1 = pg.expedition_data_template[var0].dungeon_id
	local var2 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var1).fleet_prefab
	local var3 = {
		prefabFleet = var2,
		stageId = var0,
		system = SYSTEM_AIRFIGHT
	}

	arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var3)
end

function var0.Exit(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE)

	if arg0.statistics._battleScore >= ys.Battle.BattleConst.BattleScore.B and var0 and not var0:isEnd() then
		local var1 = 0
		local var2 = var0:getConfig("config_client")[1]

		for iter0 = 1, var2 do
			var1 = var1 + (var0:getKVPList(1, iter0) or 0)
		end

		local var3 = pg.TimeMgr.GetInstance()
		local var4 = var3:DiffDay(var0.data1, var3:GetServerTime()) + 1

		if var1 < math.min(var4 * 2, var2 * 3) then
			local var5 = arg0.stageId
			local var6 = var0:getConfig("config_client")[2]
			local var7 = table.indexof(var6, var5)
			local var8 = math.floor((var7 - 1) / (#var6 / var2)) + 1
			local var9 = var0:getKVPList(1, var8) or 0
			local var10 = var0:getKVPList(2, var8) == 1

			if var9 < 3 and not var10 then
				arg1:sendNotification(GAME.ACTIVITY_OPERATION, {
					cmd = 1,
					activity_id = var0 and var0.id,
					arg1 = var8,
					statistics = arg0.statistics
				})

				return
			end
		end
	end

	arg1:sendNotification(GAME.FINISH_STAGE_DONE, {
		statistics = arg0.statistics,
		score = arg0.statistics._battleScore,
		system = SYSTEM_AIRFIGHT
	})
end

return var0
