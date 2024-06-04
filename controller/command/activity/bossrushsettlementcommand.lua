local var0 = class("BossRushSettlementCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1.body

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 2,
		activity_id = var0.actId
	}, 11203, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(ActivityProxy):getActivityById(var0.actId)
			local var1 = var0:GetSeriesData()

			var0:SetSeriesData(nil)

			local var2 = PlayerConst.GetTranAwards(var0, arg0)
			local var3 = var0.actId
			local var4 = getProxy(ActivityProxy):GetBossRushRuntime(var3).settlementData

			getProxy(ActivityProxy):GetBossRushRuntime(var0.id).settlementData = nil

			if var4.win then
				var0:AddPassSeries(var4.seriesId)
				var0:AddUsedBonus(var4.seriesId)
			end

			for iter0, iter1 in ipairs(var4) do
				table.insertto(var2, iter1.drops)
				table.insertto(var2, iter1.extraDrops)
			end

			if var1 then
				var1:AddFinalResults(var4)
			end

			getProxy(ActivityProxy):updateActivity(var0)
			seriesAsync({
				function(arg0)
					local var0 = {
						seriesData = var1,
						activityId = var0.actId,
						awards = var2,
						callback = arg0
					}

					if var0.callback then
						var0.callback(var0)
					else
						arg0:sendNotification(GAME.BOSSRUSH_SETTLE_DONE, var0)
					end
				end,
				function(arg0)
					return
				end
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

function var0.ConcludeEXP(arg0, arg1, arg2)
	local var0 = arg0.system
	local var1 = arg0.arg1
	local var2 = BossRushSeriesData.New({
		id = var1
	})
	local var3 = {
		seriesId = var1
	}
	local var4 = true
	local var5 = arg2 and arg2[#arg0.re40004]

	if var5 then
		var4 = var5.statistics._battleScore > ys.Battle.BattleConst.BattleScore.C
	end

	var3.win = var4

	for iter0, iter1 in ipairs(arg0.re40004) do
		var3[iter0] = {}

		local var6, var7 = var0.addShipsExp(iter1.ship_exp_list, var0 == SYSTEM_BOSS_RUSH)

		var3[iter0].oldShips = var6
		var3[iter0].newShips = var7

		local var8, var9 = var0.GenerateCommanderExp(iter1.commander_exp)

		var3[iter0].oldCmds = var8
		var3[iter0].newCmds = var9
		var3[iter0].mvp = iter1.mvp

		local var10, var11 = var0.GeneralLoot(iter1)

		var3[iter0].drops = var10
		var3[iter0].extraDrops = var11

		local var12 = 0

		if pg.battle_cost_template[var0].oil_cost > 0 then
			local var13 = {
				{
					0,
					0
				},
				{
					0,
					0
				}
			}

			table.Foreach(var6, function(arg0, arg1)
				local var0 = arg1:getStartBattleExpend()
				local var1 = arg1:getEndBattleExpend()
				local var2 = arg1:getTeamType() == TeamType.Submarine and 2 or 1

				var13[var2][1] = var13[var2][1] + var0
				var13[var2][2] = var13[var2][2] + var1
			end)

			local var14 = var2:GetOilLimit()
			local var15 = var13[1][2]

			if var14[1] > 0 then
				var15 = math.clamp(var14[1] - var13[1][1], 0, var13[1][2])
			end

			local var16 = var13[2][2]

			if var14[1] > 0 then
				var16 = math.clamp(var14[2] - var13[2][1], 0, var13[2][2])
			end

			var12 = var15 + var16
		end

		var3[iter0].playerExp = var0.GeneralPlayerCosume(var0, var4, var12, iter1.player_exp)
	end

	return var3
end

function var0.addShipsExp(arg0, arg1)
	local var0 = {}
	local var1 = {}
	local var2 = getProxy(BayProxy)

	for iter0, iter1 in ipairs(arg0) do
		local var3 = iter1.ship_id
		local var4 = iter1.exp
		local var5 = iter1.intimacy
		local var6 = iter1.energy
		local var7 = var2:getShipById(var3)

		var0[var3] = Clone(var7)
		var0[var3].expAdd = var4

		var7:addExp(var4, arg1)

		if arg1 then
			local var8 = pg.gameset.level_get_proficency.key_value

			if (var8 < var7.level or var7.level == var8 and var7.exp > 0) and pg.ship_data_template[var7.configId].can_get_proficency == 1 then
				getProxy(NavalAcademyProxy):AddCourseProficiency(var4)
			end
		end

		if var5 then
			var7:addLikability(var5 - 10000)
		end

		if var6 then
			var7:cosumeEnergy(var6)
		end

		var1[var3] = Clone(var7)

		var2:updateShip(var7)
	end

	return var0, var1
end

function var0.GenerateCommanderExp(arg0)
	local var0 = {}
	local var1 = {}
	local var2 = getProxy(CommanderProxy)

	for iter0, iter1 in ipairs(arg0) do
		local var3 = iter1.commander_id
		local var4 = iter1.exp
		local var5 = var2:getCommanderById(var3)

		var0[var3] = Clone(var5)
		var0[var3].expAdd = iter1.exp

		var5:addExp(var4)

		var1[var3] = Clone(var5)

		var2:updateCommander(var5)
	end

	return var0, var1
end

function var0.GeneralLoot(arg0)
	local var0 = {
		drops = arg0.drop_info,
		extraDrops = arg0.extra_drop_info
	}

	for iter0, iter1 in pairs(var0) do
		var0[iter0] = PlayerConst.addTranDrop(iter1)

		underscore.each(var0[iter0], function(arg0)
			if arg0.type == DROP_TYPE_SHIP then
				local var0 = pg.ship_data_template[arg0.id].group_type
				local var1 = getProxy(CollectionProxy)

				arg0.virgin = var1 and var1.shipGroups[var0] == nil
			end
		end)
	end

	return var0.drops, var0.extraDrops
end

function var0.GeneralPlayerCosume(arg0, arg1, arg2, arg3)
	local var0 = getProxy(PlayerProxy)
	local var1 = var0:getData()
	local var2 = {
		oldPlayer = {
			level = var1.level,
			exp = var1.exp
		},
		addExp = arg3
	}

	var1:addExp(arg3)

	local var3 = pg.battle_cost_template[arg0]

	if var3.oil_cost > 0 and arg1 then
		var1:consume({
			gold = 0,
			oil = arg2
		})
	end

	if var3.attack_count > 0 then
		if var3.attack_count == 1 then
			var1:increaseAttackCount()

			if arg1 then
				var1:increaseAttackWinCount()
			end
		elseif var3.attack_count == 2 then
			var1:increasePvpCount()

			if arg1 then
				var1:increasePvpWinCount()
			end
		end
	end

	var0:updatePlayer(var1)

	var2.newPlayer = Clone(var1)

	return var2
end

return var0
