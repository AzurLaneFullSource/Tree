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

			if var4_2.win then
				var0_2:AddPassSeries(var4_2.seriesId)
				var0_2:AddUsedBonus(var4_2.seriesId)
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
				function(arg0_3)
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
					return
				end
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

function var0_0.ConcludeEXP(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5.system
	local var1_5 = arg0_5.arg1
	local var2_5 = BossRushSeriesData.New({
		id = var1_5
	})
	local var3_5 = {
		seriesId = var1_5
	}
	local var4_5 = true
	local var5_5 = arg2_5 and arg2_5[#arg0_5.re40004]

	if var5_5 then
		var4_5 = var5_5.statistics._battleScore > ys.Battle.BattleConst.BattleScore.C
	end

	var3_5.win = var4_5

	for iter0_5, iter1_5 in ipairs(arg0_5.re40004) do
		var3_5[iter0_5] = {}

		local var6_5, var7_5 = var0_0.addShipsExp(iter1_5.ship_exp_list, var0_5 == SYSTEM_BOSS_RUSH)

		var3_5[iter0_5].oldShips = var6_5
		var3_5[iter0_5].newShips = var7_5

		local var8_5, var9_5 = var0_0.GenerateCommanderExp(iter1_5.commander_exp)

		var3_5[iter0_5].oldCmds = var8_5
		var3_5[iter0_5].newCmds = var9_5
		var3_5[iter0_5].mvp = iter1_5.mvp

		local var10_5, var11_5 = var0_0.GeneralLoot(iter1_5)

		var3_5[iter0_5].drops = var10_5
		var3_5[iter0_5].extraDrops = var11_5

		local var12_5 = 0

		if pg.battle_cost_template[var0_5].oil_cost > 0 then
			local var13_5 = {
				{
					0,
					0
				},
				{
					0,
					0
				}
			}

			table.Foreach(var6_5, function(arg0_6, arg1_6)
				local var0_6 = arg1_6:getStartBattleExpend()
				local var1_6 = arg1_6:getEndBattleExpend()
				local var2_6 = arg1_6:getTeamType() == TeamType.Submarine and 2 or 1

				var13_5[var2_6][1] = var13_5[var2_6][1] + var0_6
				var13_5[var2_6][2] = var13_5[var2_6][2] + var1_6
			end)

			local var14_5 = var2_5:GetOilLimit()
			local var15_5 = var13_5[1][2]

			if var14_5[1] > 0 then
				var15_5 = math.clamp(var14_5[1] - var13_5[1][1], 0, var13_5[1][2])
			end

			local var16_5 = var13_5[2][2]

			if var14_5[1] > 0 then
				var16_5 = math.clamp(var14_5[2] - var13_5[2][1], 0, var13_5[2][2])
			end

			var12_5 = var15_5 + var16_5
		end

		var3_5[iter0_5].playerExp = var0_0.GeneralPlayerCosume(var0_5, var4_5, var12_5, iter1_5.player_exp)
	end

	return var3_5
end

function var0_0.addShipsExp(arg0_7, arg1_7)
	local var0_7 = {}
	local var1_7 = {}
	local var2_7 = getProxy(BayProxy)

	for iter0_7, iter1_7 in ipairs(arg0_7) do
		local var3_7 = iter1_7.ship_id
		local var4_7 = iter1_7.exp
		local var5_7 = iter1_7.intimacy
		local var6_7 = iter1_7.energy
		local var7_7 = var2_7:getShipById(var3_7)

		var0_7[var3_7] = Clone(var7_7)
		var0_7[var3_7].expAdd = var4_7

		var7_7:addExp(var4_7, arg1_7)

		if arg1_7 then
			local var8_7 = pg.gameset.level_get_proficency.key_value

			if (var8_7 < var7_7.level or var7_7.level == var8_7 and var7_7.exp > 0) and pg.ship_data_template[var7_7.configId].can_get_proficency == 1 then
				getProxy(NavalAcademyProxy):AddCourseProficiency(var4_7)
			end
		end

		if var5_7 then
			var7_7:addLikability(var5_7 - 10000)
		end

		if var6_7 then
			var7_7:cosumeEnergy(var6_7)
		end

		var1_7[var3_7] = Clone(var7_7)

		var2_7:updateShip(var7_7)
	end

	return var0_7, var1_7
end

function var0_0.GenerateCommanderExp(arg0_8)
	local var0_8 = {}
	local var1_8 = {}
	local var2_8 = getProxy(CommanderProxy)

	for iter0_8, iter1_8 in ipairs(arg0_8) do
		local var3_8 = iter1_8.commander_id
		local var4_8 = iter1_8.exp
		local var5_8 = var2_8:getCommanderById(var3_8)

		var0_8[var3_8] = Clone(var5_8)
		var0_8[var3_8].expAdd = iter1_8.exp

		var5_8:addExp(var4_8)

		var1_8[var3_8] = Clone(var5_8)

		var2_8:updateCommander(var5_8)
	end

	return var0_8, var1_8
end

function var0_0.GeneralLoot(arg0_9)
	local var0_9 = {
		drops = arg0_9.drop_info,
		extraDrops = arg0_9.extra_drop_info
	}

	for iter0_9, iter1_9 in pairs(var0_9) do
		var0_9[iter0_9] = PlayerConst.addTranDrop(iter1_9)

		underscore.each(var0_9[iter0_9], function(arg0_10)
			if arg0_10.type == DROP_TYPE_SHIP then
				local var0_10 = pg.ship_data_template[arg0_10.id].group_type
				local var1_10 = getProxy(CollectionProxy)

				arg0_10.virgin = var1_10 and var1_10.shipGroups[var0_10] == nil
			end
		end)
	end

	return var0_9.drops, var0_9.extraDrops
end

function var0_0.GeneralPlayerCosume(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = getProxy(PlayerProxy)
	local var1_11 = var0_11:getData()
	local var2_11 = {
		oldPlayer = {
			level = var1_11.level,
			exp = var1_11.exp
		},
		addExp = arg3_11
	}

	var1_11:addExp(arg3_11)

	local var3_11 = pg.battle_cost_template[arg0_11]

	if var3_11.oil_cost > 0 and arg1_11 then
		var1_11:consume({
			gold = 0,
			oil = arg2_11
		})
	end

	if var3_11.attack_count > 0 then
		if var3_11.attack_count == 1 then
			var1_11:increaseAttackCount()

			if arg1_11 then
				var1_11:increaseAttackWinCount()
			end
		elseif var3_11.attack_count == 2 then
			var1_11:increasePvpCount()

			if arg1_11 then
				var1_11:increasePvpWinCount()
			end
		end
	end

	var0_11:updatePlayer(var1_11)

	var2_11.newPlayer = Clone(var1_11)

	return var2_11
end

return var0_0
