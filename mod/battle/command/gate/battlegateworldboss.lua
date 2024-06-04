local var0 = class("BattleGateWorldBoss")

ys.Battle.BattleGateWorldBoss = var0
var0.__name = "BattleGateWorldBoss"

function var0.Entrance(arg0, arg1)
	if BeginStageCommand.DockOverload() then
		return
	end

	local var0 = arg0.actId
	local var1 = getProxy(PlayerProxy)
	local var2 = getProxy(BayProxy)
	local var3 = pg.battle_cost_template[SYSTEM_WORLD_BOSS]
	local var4 = true
	local var5 = {}
	local var6 = 0
	local var7 = 0
	local var8 = nowWorld()
	local var9 = var8:GetBossProxy():GetFleet(arg0.bossId)
	local var10 = var9.ships

	for iter0, iter1 in ipairs(var10) do
		var5[#var5 + 1] = iter1
	end

	local var11 = var2:getSortShipsByFleet(var9)
	local var12 = var1:getData()
	local var13 = arg0.bossId
	local var14 = var8:GetBossProxy()
	local var15 = var14:GetBossById(var13)
	local var16 = var15:GetStageID()

	if var14:IsSelfBoss(var15) and var15:GetSelfFightCnt() > 0 then
		var7 = var15:GetOilConsume()
	end

	if var4 and var7 > var12.oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	arg1.ShipVertify()

	local function var17(arg0)
		if var4 then
			var12:consume({
				gold = 0,
				oil = var7
			})
		end

		if var3.enter_energy_cost > 0 then
			local var0 = pg.gameset.battle_consume_energy.key_value

			for iter0, iter1 in ipairs(var11) do
				iter1:cosumeEnergy(var0)
				var2:updateShip(iter1)
			end
		end

		if var14:IsSelfBoss(var15) then
			var15:IncreaseFightCnt()
		else
			if WorldBossConst._IsCurrBoss(var15) then
				var14:reducePt()
			end

			var14:LockCacheBoss(var13)
		end

		var1:updatePlayer(var12)

		local var1 = {
			prefabFleet = {},
			bossId = var13,
			actId = var0,
			stageId = var16,
			system = SYSTEM_WORLD_BOSS,
			token = arg0.key,
			bossLevel = var15:GetLevel(),
			bossConfigId = var15:GetConfigID()
		}

		arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var1)
	end

	local function var18(arg0)
		local function var0()
			var14:UnlockCacheBoss()
			var14:RemoveCacheBoss(var15.id)
			pg.m02:sendNotification(GAME.WORLD_BOSS_START_BATTLE_FIALED)
		end

		if arg0.result == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))
			var0()
		elseif arg0.result == 3 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))
			var0()
		elseif arg0.result == 6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_max_challenge_cnt"))
			var0()
		elseif arg0.result == 20 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))
			var0()
		elseif arg0.result == 9997 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_maintenance"))
			var0()
		else
			arg1:RequestFailStandardProcess(arg0)
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end

	BeginStageCommand.SendRequest(SYSTEM_WORLD_BOSS, var5, {
		var13
	}, var17, var18)
end

function var0.Exit(arg0, arg1)
	if arg1.CheaterVertify() then
		return
	end

	local var0 = pg.battle_cost_template[SYSTEM_WORLD_BOSS]
	local var1 = arg0.statistics._battleScore
	local var2 = {}
	local var3 = nowWorld():GetBossProxy():GetFleet(arg0.bossId)
	local var4 = getProxy(BayProxy):getSortShipsByFleet(var3)
	local var5 = arg1.GeneralPackage(arg0, var4)
	local var6 = 0
	local var7 = {}

	for iter0, iter1 in ipairs(arg0.statistics._enemyInfoList) do
		table.insert(var7, {
			enemy_id = iter1.id,
			damage_taken = iter1.damage,
			total_hp = iter1.totalHp
		})

		if var6 < iter1.damage then
			var6 = iter1.damage
		end
	end

	var5.enemy_info = var7

	local function var8(arg0)
		local var0, var1 = arg1:GeneralLoot(arg0)

		arg1.addShipsExp(arg0.ship_exp_list, arg0.statistics, accumulate)

		local var2 = nowWorld():GetBossProxy()
		local var3 = var2:GetBossById(arg0.bossId)
		local var4 = var3:GetName()

		var2:ClearRank(var3.id)
		var2:UpdateHighestDamage(var6)

		arg0.statistics.mvpShipID = arg0.mvp

		local var5 = {
			system = SYSTEM_WORLD_BOSS,
			statistics = arg0.statistics,
			score = var1,
			drops = var0,
			commanderExps = {},
			result = arg0.result,
			extraDrops = var1,
			bossId = arg0.bossId,
			name = var4
		}

		arg1:sendNotification(GAME.FINISH_STAGE_DONE, var5)
		var2:UnlockCacheBoss()
	end

	arg1:SendRequest(var5, var8)
end

return var0
