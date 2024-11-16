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
		local var1_2 = var0_2:GetMaxProgress()
		local var2_2 = var0_2:GetPerDayCount()
		local var3_2 = var0_2:GetPerLevelProgress()
		local var4_2 = var1_2 / var3_2
		local var5_2 = 0

		for iter0_2 = 1, var4_2 do
			var5_2 = var5_2 + (var0_2:getKVPList(1, iter0_2) or 0)
		end

		local var6_2 = pg.TimeMgr.GetInstance()
		local var7_2 = var6_2:DiffDay(var0_2.data1, var6_2:GetServerTime()) + 1

		if var5_2 < math.min(var7_2 * var2_2, var1_2) then
			local var8_2 = arg0_2.stageId
			local var9_2 = var0_2:getConfig("config_client").stages
			local var10_2 = table.indexof(var9_2, var8_2)
			local var11_2 = math.floor((var10_2 - 1) / math.floor(#var9_2 / var4_2)) + 1
			local var12_2 = var0_2:getKVPList(1, var11_2) or 0
			local var13_2 = var0_2:getKVPList(2, var11_2) == 1

			if var12_2 < var3_2 and not var13_2 then
				arg1_2:sendNotification(GAME.ACTIVITY_OPERATION, {
					cmd = 1,
					activity_id = var0_2 and var0_2.id,
					arg1 = var11_2,
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
