local var0_0 = class("FinishStageCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.system

	if var0_0.CheaterVertify() then
		return
	end

	ys.Battle.BattleGate.Gates[var1_1].Exit(var0_1, arg0_1)
end

function var0_0.CheaterVertify()
	ys.Battle.BattleState.GenerateVertifyData()

	local var0_2, var1_2 = ys.Battle.BattleState.Vertify()

	if not var0_2 then
		pg.m02:sendNotification(GAME.CHEATER_MARK, {
			reason = var1_2
		})
	end

	return not var0_2
end

function var0_0.GeneralPackage(arg0_3, arg1_3)
	local var0_3 = 0
	local var1_3 = {}
	local var2_3 = arg0_3.system
	local var3_3

	if arg0_3.system == SYSTEM_DUEL then
		var3_3 = arg0_3.rivalId
	elseif arg0_3.system == SYSTEM_WORLD_BOSS then
		var3_3 = arg0_3.bossId
	else
		var3_3 = arg0_3.stageId
	end

	local var4_3 = arg0_3.statistics._battleScore
	local var5_3 = var2_3 + var3_3 + var4_3

	for iter0_3, iter1_3 in ipairs(arg1_3) do
		local var6_3 = arg0_3.statistics[iter1_3.id]

		if var6_3 then
			local var7_3 = var6_3.id
			local var8_3 = math.floor(var6_3.bp)
			local var9_3 = math.floor(var6_3.output)
			local var10_3 = math.max(0, math.floor(var6_3.damage))
			local var11_3 = math.floor(var6_3.maxDamageOnce)
			local var12_3 = math.floor(var6_3.gearScore)

			table.insert(var1_3, {
				ship_id = var7_3,
				hp_rest = var8_3,
				damage_cause = var9_3,
				damage_caused = var10_3,
				max_damage_once = var11_3,
				ship_gear_score = var12_3
			})

			var5_3 = var5_3 + var7_3 + var8_3 + var9_3 + var11_3
			var0_3 = var0_3 + iter1_3:getShipCombatPower()
		end
	end

	local var13_3, var14_3 = GetBattleCheckResult(var5_3, arg0_3.token, arg0_3.statistics._totalTime)

	return {
		system = var2_3,
		data = var3_3,
		score = var4_3,
		key = var13_3,
		statistics = var1_3,
		kill_id_list = arg0_3.statistics.kill_id_list,
		total_time = arg0_3.statistics._totalTime,
		bot_percentage = arg0_3.statistics._botPercentage,
		extra_param = var0_3,
		file_check = var14_3,
		boss_hp = arg0_3.statistics._maxBossHP,
		enemy_info = {},
		data2 = {}
	}
end

function var0_0.SendRequest(arg0_4, arg1_4, arg2_4)
	pg.ConnectionMgr.GetInstance():Send(40003, arg1_4, 40004, function(arg0_5)
		if arg0_5.result == 0 or arg0_5.result == 1030 then
			arg2_4(arg0_5)
		else
			arg0_4:RequestFailStandardProcess(arg0_5)
		end
	end)
end

function var0_0.RequestFailStandardProcess(arg0_6, arg1_6)
	if arg1_6.result == 2 then
		originalPrint("stage_finishStage error--" .. arg1_6.result)
		pg.TipsMgr.GetInstance():ShowTips(errorTip("stage_finishStage", arg1_6.result))
		arg0_6:sendNotification(GAME.FINISH_STAGE_ERROR, {})
	else
		originalPrint("stage_finishStage error--" .. arg1_6.result)
		pg.TipsMgr.GetInstance():ShowTips(errorTip("stage_finishStage", arg1_6.result))
	end
end

function var0_0.addShipsExp(arg0_7, arg1_7, arg2_7)
	local var0_7 = getProxy(BayProxy)
	local var1_7 = {}
	local var2_7 = {}

	for iter0_7, iter1_7 in ipairs(arg0_7) do
		local var3_7 = iter1_7.ship_id
		local var4_7 = iter1_7.exp or 0
		local var5_7 = iter1_7.intimacy
		local var6_7 = iter1_7.energy

		if arg1_7[var3_7] then
			local var7_7 = var0_7:getShipById(var3_7)

			var7_7:addExp(var4_7, arg2_7)

			if arg2_7 then
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

			var0_7:updateShip(var7_7)
		end
	end
end

function var0_0.DeadShipEnergyCosume(arg0_8, arg1_8)
	local var0_8 = pg.gameset.battle_dead_energy.key_value
	local var1_8 = getProxy(BayProxy)

	for iter0_8, iter1_8 in ipairs(arg1_8) do
		local var2_8 = arg0_8.statistics[iter1_8.id]

		if var2_8 and var2_8.bp == 0 then
			local var3_8 = var1_8:getShipById(iter1_8.id)

			var3_8:cosumeEnergy(var0_8)
			var1_8:updateShip(var3_8)
		end
	end
end

function var0_0.GeneralPlayerCosume(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	local var0_9 = getProxy(PlayerProxy)
	local var1_9 = var0_9:getData()

	var1_9:addExp(arg3_9)

	local var2_9 = pg.battle_cost_template[arg0_9]

	if var2_9.oil_cost > 0 and arg1_9 then
		var1_9:consume({
			gold = 0,
			oil = arg2_9
		})
	end

	if var2_9.attack_count > 0 and not arg4_9 then
		if var2_9.attack_count == 1 then
			var1_9:increaseAttackCount()

			if arg1_9 then
				var1_9:increaseAttackWinCount()
			end
		elseif var2_9.attack_count == 2 then
			var1_9:increasePvpCount()

			if arg1_9 then
				var1_9:increasePvpWinCount()
			end
		end
	end

	var0_9:updatePlayer(var1_9)
end

function var0_0.GeneralLoot(arg0_10, arg1_10)
	local var0_10 = {
		drops = arg1_10.drop_info,
		extraDrops = arg1_10.extra_drop_info
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

function var0_0.GenerateCommanderExp(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.commander_exp
	local var1_12 = getProxy(CommanderProxy)

	local function var2_12(arg0_13)
		local var0_13 = arg0_13:getCommanders()
		local var1_13 = {}

		for iter0_13, iter1_13 in pairs(var0_13) do
			local var2_13 = iter1_13.id
			local var3_13 = var1_12:getCommanderById(var2_13)
			local var4_13 = var3_13.exp
			local var5_13

			for iter2_13, iter3_13 in ipairs(var0_12) do
				if iter3_13.commander_id == var2_13 then
					var5_13 = iter3_13

					break
				end
			end

			local var6_13 = var5_13 and var5_13.exp or 0

			var3_13:addExp(var6_13)
			var1_12:updateCommander(var3_13)
			table.insert(var1_13, {
				commander_id = var2_13,
				exp = var6_13,
				curExp = var4_13
			})
		end

		return var1_13
	end

	local var3_12 = var2_12(arg1_12)
	local var4_12 = {}

	if arg2_12 then
		var4_12 = var2_12(arg2_12)
	end

	return {
		surfaceCMD = var3_12,
		submarineCMD = var4_12
	}
end

return var0_0
