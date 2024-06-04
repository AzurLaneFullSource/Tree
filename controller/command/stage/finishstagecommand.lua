local var0 = class("FinishStageCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.system

	if var0.CheaterVertify() then
		return
	end

	ys.Battle.BattleGate.Gates[var1].Exit(var0, arg0)
end

function var0.CheaterVertify()
	ys.Battle.BattleState.GenerateVertifyData()

	local var0, var1 = ys.Battle.BattleState.Vertify()

	if not var0 then
		pg.m02:sendNotification(GAME.CHEATER_MARK, {
			reason = var1
		})
	end

	return not var0
end

function var0.GeneralPackage(arg0, arg1)
	local var0 = 0
	local var1 = {}
	local var2 = arg0.system
	local var3

	if arg0.system == SYSTEM_DUEL then
		var3 = arg0.rivalId
	elseif arg0.system == SYSTEM_WORLD_BOSS then
		var3 = arg0.bossId
	else
		var3 = arg0.stageId
	end

	local var4 = arg0.statistics._battleScore
	local var5 = var2 + var3 + var4

	for iter0, iter1 in ipairs(arg1) do
		local var6 = arg0.statistics[iter1.id]

		if var6 then
			local var7 = var6.id
			local var8 = math.floor(var6.bp)
			local var9 = math.floor(var6.output)
			local var10 = math.max(0, math.floor(var6.damage))
			local var11 = math.floor(var6.maxDamageOnce)
			local var12 = math.floor(var6.gearScore)

			table.insert(var1, {
				ship_id = var7,
				hp_rest = var8,
				damage_cause = var9,
				damage_caused = var10,
				max_damage_once = var11,
				ship_gear_score = var12
			})

			var5 = var5 + var7 + var8 + var9 + var11
			var0 = var0 + iter1:getShipCombatPower()
		end
	end

	local var13, var14 = GetBattleCheckResult(var5, arg0.token, arg0.statistics._totalTime)

	return {
		system = var2,
		data = var3,
		score = var4,
		key = var13,
		statistics = var1,
		kill_id_list = arg0.statistics.kill_id_list,
		total_time = arg0.statistics._totalTime,
		bot_percentage = arg0.statistics._botPercentage,
		extra_param = var0,
		file_check = var14,
		boss_hp = arg0.statistics._maxBossHP,
		enemy_info = {},
		data2 = {}
	}
end

function var0.SendRequest(arg0, arg1, arg2)
	pg.ConnectionMgr.GetInstance():Send(40003, arg1, 40004, function(arg0)
		if arg0.result == 0 or arg0.result == 1030 then
			arg2(arg0)
		else
			arg0:RequestFailStandardProcess(arg0)
		end
	end)
end

function var0.RequestFailStandardProcess(arg0, arg1)
	if arg1.result == 2 then
		originalPrint("stage_finishStage error--" .. arg1.result)
		pg.TipsMgr.GetInstance():ShowTips(errorTip("stage_finishStage", arg1.result))
		arg0:sendNotification(GAME.FINISH_STAGE_ERROR, {})
	else
		originalPrint("stage_finishStage error--" .. arg1.result)
		pg.TipsMgr.GetInstance():ShowTips(errorTip("stage_finishStage", arg1.result))
	end
end

function var0.addShipsExp(arg0, arg1, arg2)
	local var0 = getProxy(BayProxy)
	local var1 = {}
	local var2 = {}

	for iter0, iter1 in ipairs(arg0) do
		local var3 = iter1.ship_id
		local var4 = iter1.exp or 0
		local var5 = iter1.intimacy
		local var6 = iter1.energy

		if arg1[var3] then
			local var7 = var0:getShipById(var3)

			var7:addExp(var4, arg2)

			if arg2 then
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

			var0:updateShip(var7)
		end
	end
end

function var0.DeadShipEnergyCosume(arg0, arg1)
	local var0 = pg.gameset.battle_dead_energy.key_value
	local var1 = getProxy(BayProxy)

	for iter0, iter1 in ipairs(arg1) do
		local var2 = arg0.statistics[iter1.id]

		if var2 and var2.bp == 0 then
			local var3 = var1:getShipById(iter1.id)

			var3:cosumeEnergy(var0)
			var1:updateShip(var3)
		end
	end
end

function var0.GeneralPlayerCosume(arg0, arg1, arg2, arg3, arg4)
	local var0 = getProxy(PlayerProxy)
	local var1 = var0:getData()

	var1:addExp(arg3)

	local var2 = pg.battle_cost_template[arg0]

	if var2.oil_cost > 0 and arg1 then
		var1:consume({
			gold = 0,
			oil = arg2
		})
	end

	if var2.attack_count > 0 and not arg4 then
		if var2.attack_count == 1 then
			var1:increaseAttackCount()

			if arg1 then
				var1:increaseAttackWinCount()
			end
		elseif var2.attack_count == 2 then
			var1:increasePvpCount()

			if arg1 then
				var1:increasePvpWinCount()
			end
		end
	end

	var0:updatePlayer(var1)
end

function var0.GeneralLoot(arg0, arg1)
	local var0 = {
		drops = arg1.drop_info,
		extraDrops = arg1.extra_drop_info
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

function var0.GenerateCommanderExp(arg0, arg1, arg2)
	local var0 = arg0.commander_exp
	local var1 = getProxy(CommanderProxy)

	local function var2(arg0)
		local var0 = arg0:getCommanders()
		local var1 = {}

		for iter0, iter1 in pairs(var0) do
			local var2 = iter1.id
			local var3 = var1:getCommanderById(var2)
			local var4 = var3.exp
			local var5

			for iter2, iter3 in ipairs(var0) do
				if iter3.commander_id == var2 then
					var5 = iter3

					break
				end
			end

			local var6 = var5 and var5.exp or 0

			var3:addExp(var6)
			var1:updateCommander(var3)
			table.insert(var1, {
				commander_id = var2,
				exp = var6,
				curExp = var4
			})
		end

		return var1
	end

	local var3 = var2(arg1)
	local var4 = {}

	if arg2 then
		var4 = var2(arg2)
	end

	return {
		surfaceCMD = var3,
		submarineCMD = var4
	}
end

return var0
