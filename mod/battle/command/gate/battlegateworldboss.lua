local var0_0 = class("BattleGateWorldBoss")

ys.Battle.BattleGateWorldBoss = var0_0
var0_0.__name = "BattleGateWorldBoss"

function var0_0.Entrance(arg0_1, arg1_1)
	if BeginStageCommand.DockOverload() then
		return
	end

	local var0_1 = arg0_1.actId
	local var1_1 = getProxy(PlayerProxy)
	local var2_1 = getProxy(BayProxy)
	local var3_1 = pg.battle_cost_template[SYSTEM_WORLD_BOSS]
	local var4_1 = true
	local var5_1 = {}
	local var6_1 = 0
	local var7_1 = 0
	local var8_1 = nowWorld()
	local var9_1 = var8_1:GetBossProxy():GetFleet(arg0_1.bossId)
	local var10_1 = var9_1.ships

	for iter0_1, iter1_1 in ipairs(var10_1) do
		var5_1[#var5_1 + 1] = iter1_1
	end

	local var11_1 = var2_1:getSortShipsByFleet(var9_1)
	local var12_1 = var1_1:getData()
	local var13_1 = arg0_1.bossId
	local var14_1 = var8_1:GetBossProxy()
	local var15_1 = var14_1:GetBossById(var13_1)
	local var16_1 = var15_1:GetStageID()

	if var14_1:IsSelfBoss(var15_1) and var15_1:GetSelfFightCnt() > 0 then
		var7_1 = var15_1:GetOilConsume()
	end

	if var4_1 and var7_1 > var12_1.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	arg1_1.ShipVertify()

	local function var17_1(arg0_2)
		if var4_1 then
			var12_1:consume({
				gold = 0,
				oil = var7_1
			})
		end

		if var3_1.enter_energy_cost > 0 then
			local var0_2 = pg.gameset.battle_consume_energy.key_value

			for iter0_2, iter1_2 in ipairs(var11_1) do
				iter1_2:cosumeEnergy(var0_2)
				var2_1:updateShip(iter1_2)
			end
		end

		if var14_1:IsSelfBoss(var15_1) then
			var15_1:IncreaseFightCnt()
		else
			if WorldBossConst._IsCurrBoss(var15_1) then
				var14_1:reducePt()
			end

			var14_1:LockCacheBoss(var13_1)
		end

		var1_1:updatePlayer(var12_1)

		local var1_2 = {
			prefabFleet = {},
			bossId = var13_1,
			actId = var0_1,
			stageId = var16_1,
			system = SYSTEM_WORLD_BOSS,
			token = arg0_2.key,
			bossLevel = var15_1:GetLevel(),
			bossConfigId = var15_1:GetConfigID()
		}

		arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var1_2)
	end

	local function var18_1(arg0_3)
		local function var0_3()
			var14_1:UnlockCacheBoss()
			var14_1:RemoveCacheBoss(var15_1.id)
			pg.m02:sendNotification(GAME.WORLD_BOSS_START_BATTLE_FIALED)
		end

		if arg0_3.result == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))
			var0_3()
		elseif arg0_3.result == 3 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))
			var0_3()
		elseif arg0_3.result == 6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_max_challenge_cnt"))
			var0_3()
		elseif arg0_3.result == 20 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))
			var0_3()
		elseif arg0_3.result == 9997 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_maintenance"))
			var0_3()
		else
			arg1_1:RequestFailStandardProcess(arg0_3)
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
		end
	end

	BeginStageCommand.SendRequest(SYSTEM_WORLD_BOSS, var5_1, {
		var13_1
	}, var17_1, var18_1)
end

function var0_0.Exit(arg0_5, arg1_5)
	if arg1_5.CheaterVertify() then
		return
	end

	local var0_5 = pg.battle_cost_template[SYSTEM_WORLD_BOSS]
	local var1_5 = arg0_5.statistics._battleScore
	local var2_5 = {}
	local var3_5 = nowWorld():GetBossProxy():GetFleet(arg0_5.bossId)
	local var4_5 = getProxy(BayProxy):getSortShipsByFleet(var3_5)
	local var5_5 = arg1_5.GeneralPackage(arg0_5, var4_5)
	local var6_5 = 0
	local var7_5 = {}

	for iter0_5, iter1_5 in ipairs(arg0_5.statistics._enemyInfoList) do
		table.insert(var7_5, {
			enemy_id = iter1_5.id,
			damage_taken = iter1_5.damage,
			total_hp = iter1_5.totalHp
		})

		if var6_5 < iter1_5.damage then
			var6_5 = iter1_5.damage
		end
	end

	var5_5.enemy_info = var7_5

	local function var8_5(arg0_6)
		local var0_6, var1_6 = arg1_5:GeneralLoot(arg0_6)

		arg1_5.addShipsExp(arg0_6.ship_exp_list, arg0_5.statistics, accumulate)

		local var2_6 = nowWorld():GetBossProxy()
		local var3_6 = var2_6:GetBossById(arg0_5.bossId)
		local var4_6 = var3_6:GetName()

		var2_6:ClearRank(var3_6.id)
		var2_6:UpdateHighestDamage(var6_5)

		arg0_5.statistics.mvpShipID = arg0_6.mvp

		local var5_6 = {
			system = SYSTEM_WORLD_BOSS,
			statistics = arg0_5.statistics,
			score = var1_5,
			drops = var0_6,
			commanderExps = {},
			result = arg0_6.result,
			extraDrops = var1_6,
			bossId = arg0_5.bossId,
			name = var4_6
		}

		arg1_5:sendNotification(GAME.FINISH_STAGE_DONE, var5_6)
		var2_6:UnlockCacheBoss()
	end

	arg1_5:SendRequest(var5_5, var8_5)
end

return var0_0
