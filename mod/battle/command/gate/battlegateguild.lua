local var0 = class("BattleGateGuild")

ys.Battle.BattleGateGuild = var0
var0.__name = "BattleGateGuild"

function var0.Entrance(arg0, arg1)
	local var0 = pg.guildset.use_oil.key_value
	local var1 = getProxy(PlayerProxy):getRawData()

	if var0 > var1.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	local var2 = var0.GetGuildBossMission()
	local var3 = var2:GetMyShipIds()
	local var4 = var2:GetShipsSplitByUserID()
	local var5 = {}

	for iter0, iter1 in ipairs(var4) do
		table.insert(var5, {
			ship_id = iter1.shipID,
			user_id = iter1.userID
		})
	end

	local var6 = var2:GetStageID()

	local function var7(arg0)
		local var0 = {
			prefabFleet = {},
			bossId = var2.id,
			actId = var2.id,
			stageId = var6,
			system = SYSTEM_GUILD,
			token = arg0.key
		}
		local var1 = getProxy(GuildProxy)
		local var2 = var1:getData()
		local var3 = pg.guildset.operation_boss_guild_active.key_value

		var2:getMemberById(var1.id):AddLiveness(var3)
		var1:updateGuild(var2)
		arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var0)
	end

	local function var8(arg0)
		arg1:RequestFailStandardProcess(arg0)
	end

	BeginStageCommand.SendRequest(SYSTEM_GUILD, var3, {
		var6
	}, var7, var8, var5)
end

function var0.Exit(arg0, arg1)
	local var0 = getProxy(FleetProxy)
	local var1 = arg0.statistics._battleScore
	local var2 = pg.guildset.use_oil.key_value
	local var3 = {}
	local var4 = var0.GetGuildBossMission()
	local var5 = var4:GetMainFleet()
	local var6 = {}

	for iter0, iter1 in pairs(var5:getCommanders()) do
		table.insert(var6, iter1.id)
	end

	local var7 = var5:GetShips()

	for iter2, iter3 in ipairs(var7) do
		table.insert(var3, iter3.ship)
	end

	if arg0.statistics.submarineAid then
		local var8 = var4:GetSubFleet()

		if var8 then
			local var9 = var8:GetShips()

			for iter4, iter5 in ipairs(var9) do
				local var10 = iter5.ship

				if arg0.statistics[var10.id] then
					table.insert(var3, var10)
				end
			end

			for iter6, iter7 in pairs(var8:getCommanders()) do
				table.insert(var6, iter7.id)
			end
		else
			originalPrint("finish stage error: can not find submarin fleet.")
		end
	end

	local var11 = 0
	local var12 = 0

	for iter8, iter9 in ipairs(var3) do
		local var13 = arg0.statistics[iter9.id]

		if var11 < var13.output then
			var12 = iter9.id
			var11 = var13.output
		end
	end

	local var14 = var0.GeneralPackage(arg0, var3)

	var14.commander_id_list = var6

	local function var15(arg0)
		arg0.statistics.mvpShipID = var12

		local var0, var1 = arg1:GeneralLoot(arg0)
		local var2 = var1 > ys.Battle.BattleConst.BattleScore.C
		local var3 = arg1.GenerateCommanderExp(arg0, var5, var4:GetSubFleet())

		var0.GeneralPlayerCosume(SYSTEM_GUILD, var2, var2, arg0.player_exp, exFlag)

		local var4 = {
			system = SYSTEM_GUILD,
			statistics = arg0.statistics,
			score = var1,
			drops = var0,
			commanderExps = var3,
			result = arg0.result,
			extraDrops = var1
		}

		var0.UpdateGuildBossMission()
		arg1:sendNotification(GAME.FINISH_STAGE_DONE, var4)
	end

	var0.SendRequest(arg1, var14, var15)
end

function var0.SendRequest(arg0, arg1, arg2)
	pg.ConnectionMgr.GetInstance():Send(40003, arg1, 40004, function(arg0)
		if arg0.result == 0 or arg0.result == 1030 then
			arg2(arg0)
		elseif arg0.result == 20 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("guild_battle_result_boss_is_death"),
				onYes = function()
					pg.m02:sendNotification(GAME.QUIT_BATTLE)
				end
			})
		elseif arg0.result == 4 then
			pg.m02:sendNotification(GAME.QUIT_BATTLE)
		else
			arg0:RequestFailStandardProcess(arg0)
		end
	end)
end

function var0.GetGuildBossMission()
	local var0 = getProxy(GuildProxy):getData():GetActiveEvent()

	assert(var0)

	local var1 = var0:GetBossMission()

	assert(var1)

	return var1
end

function var0.UpdateGuildBossMission()
	local var0 = getProxy(GuildProxy)
	local var1 = var0:getData()
	local var2 = var1:GetActiveEvent()

	assert(var2)

	local var3 = var2:GetBossMission()

	assert(var3)
	var3:ReduceDailyCnt()
	var0:ResetBossRankTime()
	var0:ResetRefreshBossTime()
	var0:updateGuild(var1)
end

function var0.GeneralPlayerCosume(arg0, arg1, arg2, arg3, arg4)
	local var0 = getProxy(PlayerProxy)
	local var1 = var0:getData()

	var1:addExp(arg3)
	var1:consume({
		gold = 0,
		oil = arg2
	})
	var0:updatePlayer(var1)
end

function var0.GeneralPackage(arg0, arg1)
	local var0 = 0
	local var1 = {}
	local var2 = {}
	local var3 = arg0.system
	local var4 = arg0.stageId
	local var5 = arg0.statistics._battleScore
	local var6 = var3 + var4 + var5
	local var7 = getProxy(PlayerProxy):getRawData().id

	for iter0, iter1 in ipairs(arg1) do
		local var8 = arg0.statistics[iter1.id]

		if var8 then
			local var9 = GuildAssaultFleet.GetRealId(var8.id)
			local var10 = GuildAssaultFleet.GetUserId(var8.id)
			local var11 = math.floor(var8.bp)
			local var12 = math.floor(var8.output)
			local var13 = math.floor(var8.damage)
			local var14 = math.floor(var8.maxDamageOnce)
			local var15 = math.floor(var8.gearScore)
			local var16 = var10 ~= var7 and var2 or var1

			table.insert(var16, {
				ship_id = var9,
				hp_rest = var11,
				damage_cause = var12,
				damage_caused = var13,
				max_damage_once = var14,
				ship_gear_score = var15
			})

			var6 = var6 + var9 + var11 + var12 + var14
			var0 = var0 + iter1:getShipCombatPower()
		end
	end

	local var17, var18 = GetBattleCheckResult(var6, arg0.token, arg0.statistics._totalTime)
	local var19 = {}

	for iter2, iter3 in ipairs(arg0.statistics._enemyInfoList) do
		table.insert(var19, {
			enemy_id = iter3.id,
			damage_taken = iter3.damage,
			total_hp = iter3.totalHp
		})
	end

	return {
		system = var3,
		data = var4,
		score = var5,
		key = var17,
		statistics = var1,
		otherstatistics = var2,
		kill_id_list = arg0.statistics.kill_id_list,
		total_time = arg0.statistics._totalTime,
		bot_percentage = arg0.statistics._botPercentage,
		extra_param = var0,
		file_check = var18,
		enemy_info = var19,
		data2 = {}
	}
end

return var0
