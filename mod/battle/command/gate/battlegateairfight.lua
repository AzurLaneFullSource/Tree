local var0_0 = class("BattleGateAirFight")

ys.Battle.BattleGateAirFight = var0_0
var0_0.__name = "BattleGateAirFight"

function var0_0.Entrance(arg0_1, arg1_1)
	local var0_1 = arg0_1.stageId
	local var1_1 = pg.expedition_data_template[var0_1].dungeon_id
	local var2_1 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var1_1).fleet_prefab
	local var3_1 = {
		prefabFleet = var2_1,
		stageId = var0_1,
		system = SYSTEM_AIRFIGHT
	}

	arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var3_1)
end

function var0_0.Exit(arg0_2, arg1_2)
	local var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE)

	if arg0_2.statistics._battleScore >= ys.Battle.BattleConst.BattleScore.B and var0_2 and not var0_2:isEnd() then
		local var1_2 = 0
		local var2_2 = var0_2:getConfig("config_client")[1]

		for iter0_2 = 1, var2_2 do
			var1_2 = var1_2 + (var0_2:getKVPList(1, iter0_2) or 0)
		end

		local var3_2 = pg.TimeMgr.GetInstance()
		local var4_2 = var3_2:DiffDay(var0_2.data1, var3_2:GetServerTime()) + 1

		if var1_2 < math.min(var4_2 * 2, var2_2 * 3) then
			local var5_2 = arg0_2.stageId
			local var6_2 = var0_2:getConfig("config_client")[2]
			local var7_2 = table.indexof(var6_2, var5_2)
			local var8_2 = math.floor((var7_2 - 1) / (#var6_2 / var2_2)) + 1
			local var9_2 = var0_2:getKVPList(1, var8_2) or 0
			local var10_2 = var0_2:getKVPList(2, var8_2) == 1

			if var9_2 < 3 and not var10_2 then
				arg1_2:sendNotification(GAME.ACTIVITY_OPERATION, {
					cmd = 1,
					activity_id = var0_2 and var0_2.id,
					arg1 = var8_2,
					statistics = arg0_2.statistics
				})

				return
			end
		end
	end

	arg1_2:sendNotification(GAME.FINISH_STAGE_DONE, {
		statistics = arg0_2.statistics,
		score = arg0_2.statistics._battleScore,
		system = SYSTEM_AIRFIGHT
	})
end

return var0_0
