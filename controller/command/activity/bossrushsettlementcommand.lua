local var0_0 = class("BossRushSettlementCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1.body

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 2,
		activity_id = var0_1.actId
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(ActivityProxy):getActivityById(var0_1.actId)
			local var1_2 = var0_2:GetSeriesData()

			var0_2:SetSeriesData(nil)

			local var2_2 = PlayerConst.GetTranAwards(var0_1, arg0_2)
			local var3_2 = var0_1.actId
			local var4_2 = getProxy(ActivityProxy):GetBossRushRuntime(var3_2).settlementData

			getProxy(ActivityProxy):GetBossRushRuntime(var0_2.id).settlementData = nil

			local var5_2

			if var4_2.win then
				var0_2:AddPassSeries(var4_2.seriesId)
				getProxy(ChapterProxy):addRemasterPassCount(var4_2.seriesId, var0_1.actId)

				local var6_2 = BossRushChapterRemasterHelper.GetActivityRemasterByFinalSeriesId(var0_1.actId, var4_2.seriesId)

				var5_2 = var6_2 and var6_2.memory_group

				if var0_2:getConfig("type") ~= ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB then
					var0_2:AddUsedBonus(var4_2.seriesId)
				end
			end

			for iter0_2, iter1_2 in ipairs(var4_2) do
				table.insertto(var2_2, iter1_2.drops)
				table.insertto(var2_2, iter1_2.extraDrops)
			end

			if var1_2 then
				var1_2:AddFinalResults(var4_2)
			end

			getProxy(ActivityProxy):updateActivity(var0_2)
			seriesAsync({
				function(arg0_3, arg1_3)
					local var0_3 = {
						seriesData = var1_2,
						activityId = var0_1.actId,
						awards = var2_2,
						callback = arg0_3
					}

					if var0_1.callback then
						var0_1.callback(var0_3)
					else
						arg0_1:sendNotification(GAME.BOSSRUSH_SETTLE_DONE, var0_3)
					end
				end,
				function(arg0_4)
					if not BossRushChapterRemasterHelper.UnlockMemoryGroupStoriesAndShowMsgBox(var5_2, function(arg0_5)
						arg0_4(arg0_5)
					end) then
						arg0_4({})
					end
				end
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

function var0_0.ConcludeEXP(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6.system
	local var1_6 = arg0_6.arg1
	local var2_6

	if var0_6 == SYSTEM_BOSS_RUSH_COLLABRATE then
		for iter0_6, iter1_6 in ipairs(pg.extraenemy_series_template) do
			local var3_6 = pg.extraenemy_series_template[iter1_6]

			if table.contains(var3_6.activity_series_enemy_id, var1_6) then
				var2_6 = CollabrateBossRushSeriesData.New({
					id = iter1_6,
					actId = arg1_6.id
				})
				var1_6 = iter1_6

				break
			end
		end
	else
		var2_6 = BossRushSeriesData.New({
			id = var1_6
		})
	end

	local var4_6 = {
		seriesId = var1_6
	}
	local var5_6 = true
	local var6_6 = arg2_6 and arg2_6[#arg0_6.re40004]

	if var6_6 then
		var5_6 = var6_6.statistics._battleScore > ys.Battle.BattleConst.BattleScore.C
	end

	var4_6.win = var5_6

	for iter2_6, iter3_6 in ipairs(arg0_6.re40004) do
		var4_6[iter2_6] = {}

		local var7_6, var8_6 = var0_0.addShipsExp(iter3_6.ship_exp_list, var0_6 == SYSTEM_BOSS_RUSH or var0_6 == SYSTEM_BOSS_RUSH_COLLABRATE)

		var4_6[iter2_6].oldShips = var7_6
		var4_6[iter2_6].newShips = var8_6

		local var9_6, var10_6 = var0_0.GenerateCommanderExp(iter3_6.commander_exp)

		var4_6[iter2_6].oldCmds = var9_6
		var4_6[iter2_6].newCmds = var10_6
		var4_6[iter2_6].mvp = iter3_6.mvp

		local var11_6, var12_6 = var0_0.GeneralLoot(iter3_6)

		var4_6[iter2_6].drops = var11_6
		var4_6[iter2_6].extraDrops = var12_6

		local var13_6 = 0

		if pg.battle_cost_template[var0_6].oil_cost > 0 then
			local var14_6 = {
				{
					0,
					0
				},
				{
					0,
					0
				}
			}

			table.Foreach(var7_6, function(arg0_7, arg1_7)
				local var0_7 = arg1_7:getStartBattleExpend()
				local var1_7 = arg1_7:getEndBattleExpend()
				local var2_7 = arg1_7:getTeamType() == TeamType.Submarine and 2 or 1

				var14_6[var2_7][1] = var14_6[var2_7][1] + var0_7
				var14_6[var2_7][2] = var14_6[var2_7][2] + var1_7
			end)

			local var15_6 = var2_6:GetOilLimit()
			local var16_6 = var14_6[1][2]

			if var15_6[1] > 0 then
				var16_6 = math.clamp(var15_6[1] - var14_6[1][1], 0, var14_6[1][2])
			end

			local var17_6 = var14_6[2][2]

			if var15_6[1] > 0 then
				var17_6 = math.clamp(var15_6[2] - var14_6[2][1], 0, var14_6[2][2])
			end

			var13_6 = var16_6 + var17_6
		end

		var4_6[iter2_6].playerExp = var0_0.GeneralPlayerCosume(var0_6, var5_6, var13_6, iter3_6.player_exp)
	end

	return var4_6
end

function var0_0.addShipsExp(arg0_8, arg1_8)
	local var0_8 = {}
	local var1_8 = {}
	local var2_8 = getProxy(BayProxy)

	for iter0_8, iter1_8 in ipairs(arg0_8) do
		local var3_8 = iter1_8.ship_id
		local var4_8 = iter1_8.exp
		local var5_8 = iter1_8.intimacy
		local var6_8 = iter1_8.energy
		local var7_8 = var2_8:getShipById(var3_8)

		var0_8[var3_8] = Clone(var7_8)
		var0_8[var3_8].expAdd = var4_8

		var7_8:addExp(var4_8, arg1_8)

		if arg1_8 then
			local var8_8 = pg.gameset.level_get_proficency.key_value

			if (var8_8 < var7_8.level or var7_8.level == var8_8 and var7_8.exp > 0) and pg.ship_data_template[var7_8.configId].can_get_proficency == 1 then
				getProxy(NavalAcademyProxy):AddCourseProficiency(var4_8)
			end
		end

		if var5_8 then
			var7_8:addLikability(var5_8 - 10000)
		end

		if var6_8 then
			var7_8:cosumeEnergy(var6_8)
		end

		var1_8[var3_8] = Clone(var7_8)

		var2_8:updateShip(var7_8)
	end

	return var0_8, var1_8
end

function var0_0.GenerateCommanderExp(arg0_9)
	local var0_9 = {}
	local var1_9 = {}
	local var2_9 = getProxy(CommanderProxy)

	for iter0_9, iter1_9 in ipairs(arg0_9) do
		local var3_9 = iter1_9.commander_id
		local var4_9 = iter1_9.exp
		local var5_9 = var2_9:getCommanderById(var3_9)

		var0_9[var3_9] = Clone(var5_9)
		var0_9[var3_9].expAdd = iter1_9.exp

		var5_9:addExp(var4_9)

		var1_9[var3_9] = Clone(var5_9)

		var2_9:updateCommander(var5_9)
	end

	return var0_9, var1_9
end

function var0_0.GeneralLoot(arg0_10)
	local var0_10 = {
		drops = arg0_10.drop_info,
		extraDrops = arg0_10.extra_drop_info
	}

	for iter0_10, iter1_10 in pairs(var0_10) do
		var0_10[iter0_10] = PlayerConst.addTranDrop(iter1_10)

		underscore.each(var0_10[iter0_10], function(arg0_11)
			if arg0_11.type == DROP_TYPE_SHIP then
				local var0_11 = pg.ship_data_template[arg0_11.id].group_type
				local var1_11 = getProxy(CollectionProxy)

				arg0_11.virgin = var1_11 and var1_11.shipGroups[var0_11] == nil
			end
		end)
	end

	return var0_10.drops, var0_10.extraDrops
end

function var0_0.GeneralPlayerCosume(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = getProxy(PlayerProxy)
	local var1_12 = var0_12:getData()
	local var2_12 = {
		oldPlayer = {
			level = var1_12.level,
			exp = var1_12.exp
		},
		addExp = arg3_12
	}

	var1_12:addExp(arg3_12)

	local var3_12 = pg.battle_cost_template[arg0_12]

	if var3_12.oil_cost > 0 and arg1_12 then
		var1_12:consume({
			gold = 0,
			oil = arg2_12
		})
	end

	if var3_12.attack_count > 0 then
		if var3_12.attack_count == 1 then
			var1_12:increaseAttackCount()

			if arg1_12 then
				var1_12:increaseAttackWinCount()
			end
		elseif var3_12.attack_count == 2 then
			var1_12:increasePvpCount()

			if arg1_12 then
				var1_12:increasePvpWinCount()
			end
		end
	end

	var0_12:updatePlayer(var1_12)

	var2_12.newPlayer = Clone(var1_12)

	return var2_12
end

return var0_0
