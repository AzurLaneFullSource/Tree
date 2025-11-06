local var0_0 = class("BattleGateWorldBossSimulate")

ys.Battle.BattleGateWorldBossSimulate = var0_0
var0_0.__name = "BattleGateWorldBossSimulate"

function var0_0.Entrance(arg0_1, arg1_1)
	if BeginStageCommand.DockOverload() then
		return
	end

	local var0_1 = arg0_1.actId
	local var1_1 = getProxy(PlayerProxy)
	local var2_1 = getProxy(BayProxy)
	local var3_1 = {}
	local var4_1 = 0
	local var5_1 = 0
	local var6_1 = nowWorld()
	local var7_1 = var6_1:GetBossProxy():GetFleet(arg0_1.bossId)
	local var8_1 = var7_1.ships

	for iter0_1, iter1_1 in ipairs(var8_1) do
		var3_1[#var3_1 + 1] = iter1_1
	end

	local var9_1 = var2_1:getSortShipsByFleet(var7_1)
	local var10_1 = var1_1:getData()
	local var11_1 = arg0_1.bossId
	local var12_1 = arg0_1.hpRate
	local var13_1 = var6_1:GetBossProxy()
	local var14_1
	local var15_1
	local var16_1 = pg.world_joint_boss_template[var11_1]

	if WorldBossConst.GetCurrBossID() == var11_1 then
		var15_1 = var13_1.currentBossLV
		var14_1 = var16_1.boss_level_id + var13_1.currentBossLV - 1
	else
		var15_1 = 15
		var14_1 = var16_1.boss_level_id + 14
	end

	local var17_1 = pg.world_boss_level[var14_1].expedition_id

	arg1_1.ShipVertify()

	local var18_1 = {
		isSimulate = true,
		prefabFleet = {},
		bossId = var11_1,
		actId = var0_1,
		stageId = var17_1,
		system = SYSTEM_WORLD_BOSS,
		bossLevel = var15_1,
		bossConfigId = var11_1,
		hpRate = var12_1
	}

	arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var18_1)
end

function var0_0.Exit(arg0_2, arg1_2)
	local var0_2 = arg0_2.statistics._battleScore

	arg0_2.statistics.mvpShipID = -1

	local var1_2 = {
		result = 0,
		system = SYSTEM_WORLD_BOSS,
		statistics = arg0_2.statistics,
		score = var0_2,
		drops = {},
		commanderExps = {},
		extraDrops = {},
		bossId = arg0_2.bossId,
		name = name
	}

	arg1_2:sendNotification(GAME.FINISH_STAGE_DONE, var1_2)
end

return var0_0
