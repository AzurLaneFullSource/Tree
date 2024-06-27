local var0_0 = class("BattleGateGuild")

ys.Battle.BattleGateGuild = var0_0
var0_0.__name = "BattleGateGuild"

function var0_0.Entrance(arg0_1, arg1_1)
	local var0_1 = pg.guildset.use_oil.key_value
	local var1_1 = getProxy(PlayerProxy):getRawData()

	if var0_1 > var1_1.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	local var2_1 = var0_0.GetGuildBossMission()
	local var3_1 = var2_1:GetMyShipIds()
	local var4_1 = var2_1:GetShipsSplitByUserID()
	local var5_1 = {}

	for iter0_1, iter1_1 in ipairs(var4_1) do
		table.insert(var5_1, {
			ship_id = iter1_1.shipID,
			user_id = iter1_1.userID
		})
	end

	local var6_1 = var2_1:GetStageID()

	local function var7_1(arg0_2)
		local var0_2 = {
			prefabFleet = {},
			bossId = var2_1.id,
			actId = var2_1.id,
			stageId = var6_1,
			system = SYSTEM_GUILD,
			token = arg0_2.key
		}
		local var1_2 = getProxy(GuildProxy)
		local var2_2 = var1_2:getData()
		local var3_2 = pg.guildset.operation_boss_guild_active.key_value

		var2_2:getMemberById(var1_1.id):AddLiveness(var3_2)
		var1_2:updateGuild(var2_2)
		arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var0_2)
	end

	local function var8_1(arg0_3)
		arg1_1:RequestFailStandardProcess(arg0_3)
	end

	BeginStageCommand.SendRequest(SYSTEM_GUILD, var3_1, {
		var6_1
	}, var7_1, var8_1, var5_1)
end

function var0_0.Exit(arg0_4, arg1_4)
	local var0_4 = getProxy(FleetProxy)
	local var1_4 = arg0_4.statistics._battleScore
	local var2_4 = pg.guildset.use_oil.key_value
	local var3_4 = {}
	local var4_4 = var0_0.GetGuildBossMission()
	local var5_4 = var4_4:GetMainFleet()
	local var6_4 = {}

	for iter0_4, iter1_4 in pairs(var5_4:getCommanders()) do
		table.insert(var6_4, iter1_4.id)
	end

	local var7_4 = var5_4:GetShips()

	for iter2_4, iter3_4 in ipairs(var7_4) do
		table.insert(var3_4, iter3_4.ship)
	end

	if arg0_4.statistics.submarineAid then
		local var8_4 = var4_4:GetSubFleet()

		if var8_4 then
			local var9_4 = var8_4:GetShips()

			for iter4_4, iter5_4 in ipairs(var9_4) do
				local var10_4 = iter5_4.ship

				if arg0_4.statistics[var10_4.id] then
					table.insert(var3_4, var10_4)
				end
			end

			for iter6_4, iter7_4 in pairs(var8_4:getCommanders()) do
				table.insert(var6_4, iter7_4.id)
			end
		else
			originalPrint("finish stage error: can not find submarin fleet.")
		end
	end

	local var11_4 = 0
	local var12_4 = 0

	for iter8_4, iter9_4 in ipairs(var3_4) do
		local var13_4 = arg0_4.statistics[iter9_4.id]

		if var11_4 < var13_4.output then
			var12_4 = iter9_4.id
			var11_4 = var13_4.output
		end
	end

	local var14_4 = var0_0.GeneralPackage(arg0_4, var3_4)

	var14_4.commander_id_list = var6_4

	local function var15_4(arg0_5)
		arg0_4.statistics.mvpShipID = var12_4

		local var0_5, var1_5 = arg1_4:GeneralLoot(arg0_5)
		local var2_5 = var1_4 > ys.Battle.BattleConst.BattleScore.C
		local var3_5 = arg1_4.GenerateCommanderExp(arg0_5, var5_4, var4_4:GetSubFleet())

		var0_0.GeneralPlayerCosume(SYSTEM_GUILD, var2_5, var2_4, arg0_5.player_exp, exFlag)

		local var4_5 = {
			system = SYSTEM_GUILD,
			statistics = arg0_4.statistics,
			score = var1_4,
			drops = var0_5,
			commanderExps = var3_5,
			result = arg0_5.result,
			extraDrops = var1_5
		}

		var0_0.UpdateGuildBossMission()
		arg1_4:sendNotification(GAME.FINISH_STAGE_DONE, var4_5)
	end

	var0_0.SendRequest(arg1_4, var14_4, var15_4)
end

function var0_0.SendRequest(arg0_6, arg1_6, arg2_6)
	pg.ConnectionMgr.GetInstance():Send(40003, arg1_6, 40004, function(arg0_7)
		if arg0_7.result == 0 or arg0_7.result == 1030 then
			arg2_6(arg0_7)
		elseif arg0_7.result == 20 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("guild_battle_result_boss_is_death"),
				onYes = function()
					pg.m02:sendNotification(GAME.QUIT_BATTLE)
				end
			})
		elseif arg0_7.result == 4 then
			pg.m02:sendNotification(GAME.QUIT_BATTLE)
		else
			arg0_6:RequestFailStandardProcess(arg0_7)
		end
	end)
end

function var0_0.GetGuildBossMission()
	local var0_9 = getProxy(GuildProxy):getData():GetActiveEvent()

	assert(var0_9)

	local var1_9 = var0_9:GetBossMission()

	assert(var1_9)

	return var1_9
end

function var0_0.UpdateGuildBossMission()
	local var0_10 = getProxy(GuildProxy)
	local var1_10 = var0_10:getData()
	local var2_10 = var1_10:GetActiveEvent()

	assert(var2_10)

	local var3_10 = var2_10:GetBossMission()

	assert(var3_10)
	var3_10:ReduceDailyCnt()
	var0_10:ResetBossRankTime()
	var0_10:ResetRefreshBossTime()
	var0_10:updateGuild(var1_10)
end

function var0_0.GeneralPlayerCosume(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	local var0_11 = getProxy(PlayerProxy)
	local var1_11 = var0_11:getData()

	var1_11:addExp(arg3_11)
	var1_11:consume({
		gold = 0,
		oil = arg2_11
	})
	var0_11:updatePlayer(var1_11)
end

function var0_0.GeneralPackage(arg0_12, arg1_12)
	local var0_12 = 0
	local var1_12 = {}
	local var2_12 = {}
	local var3_12 = arg0_12.system
	local var4_12 = arg0_12.stageId
	local var5_12 = arg0_12.statistics._battleScore
	local var6_12 = var3_12 + var4_12 + var5_12
	local var7_12 = getProxy(PlayerProxy):getRawData().id

	for iter0_12, iter1_12 in ipairs(arg1_12) do
		local var8_12 = arg0_12.statistics[iter1_12.id]

		if var8_12 then
			local var9_12 = GuildAssaultFleet.GetRealId(var8_12.id)
			local var10_12 = GuildAssaultFleet.GetUserId(var8_12.id)
			local var11_12 = math.floor(var8_12.bp)
			local var12_12 = math.floor(var8_12.output)
			local var13_12 = math.max(0, math.floor(var8_12.damage))
			local var14_12 = math.floor(var8_12.maxDamageOnce)
			local var15_12 = math.floor(var8_12.gearScore)
			local var16_12 = var10_12 ~= var7_12 and var2_12 or var1_12

			table.insert(var16_12, {
				ship_id = var9_12,
				hp_rest = var11_12,
				damage_cause = var12_12,
				damage_caused = var13_12,
				max_damage_once = var14_12,
				ship_gear_score = var15_12
			})

			var6_12 = var6_12 + var9_12 + var11_12 + var12_12 + var14_12
			var0_12 = var0_12 + iter1_12:getShipCombatPower()
		end
	end

	local var17_12, var18_12 = GetBattleCheckResult(var6_12, arg0_12.token, arg0_12.statistics._totalTime)
	local var19_12 = {}

	for iter2_12, iter3_12 in ipairs(arg0_12.statistics._enemyInfoList) do
		table.insert(var19_12, {
			enemy_id = iter3_12.id,
			damage_taken = iter3_12.damage,
			total_hp = iter3_12.totalHp
		})
	end

	return {
		system = var3_12,
		data = var4_12,
		score = var5_12,
		key = var17_12,
		statistics = var1_12,
		otherstatistics = var2_12,
		kill_id_list = arg0_12.statistics.kill_id_list,
		total_time = arg0_12.statistics._totalTime,
		bot_percentage = arg0_12.statistics._botPercentage,
		extra_param = var0_12,
		file_check = var18_12,
		enemy_info = var19_12,
		data2 = {}
	}
end

return var0_0
