local var0_0 = class("WorldBossStartBattleCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.bossId
	local var2_1 = var0_1.isOther
	local var3_1 = var0_1.hpRate
	local var4_1 = var0_1.isSimulate
	local var5_1 = nowWorld():GetBossProxy()
	local var6_1 = var5_1:GetBossById(var1_1)
	local var7_1

	if var4_1 then
		local var8_1
		local var9_1 = pg.world_joint_boss_template[var1_1]

		if WorldBossConst.GetCurrBossID() == var1_1 then
			var8_1 = var9_1.boss_level_id + var5_1.currentBossLV - 1
		else
			var8_1 = var9_1.boss_level_id + 14
		end

		var7_1 = pg.world_boss_level[var8_1].expedition_id
	else
		if not var6_1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_boss_not_found"))

			return
		end

		if var2_1 and var5_1:GetPt() <= 0 and WorldBossConst._IsCurrBoss(var6_1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_count_no_enough"))

			return
		end

		var7_1 = var6_1:GetStageID()
	end

	local function var10_1()
		local var0_2 = getProxy(ContextProxy):getCurrentContext()

		pg.m02:retrieveMediator(var0_2.mediator.__cname):addSubLayers(Context.New({
			mediator = WorldBossFormationMediator,
			viewComponent = WorldBossFormationLayer,
			data = {
				actID = 0,
				stageId = var7_1,
				bossId = var1_1,
				system = SYSTEM_WORLD_BOSS,
				isOther = var2_1,
				hpRate = var3_1,
				isSimulate = var4_1
			}
		}))
	end

	local function var11_1()
		var5_1:RemoveCacheBoss(var6_1.id)
	end

	if var4_1 then
		var10_1()
	else
		arg0_1:sendNotification(GAME.CHECK_WORLD_BOSS_STATE, {
			bossId = var1_1,
			time = var6_1.lastTime,
			callback = var10_1,
			failedCallback = var11_1
		})
	end
end

return var0_0
