local var0_0 = class("WorldBossStartBattleCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.bossId
	local var2_1 = var0_1.isOther
	local var3_1 = var0_1.hpRate
	local var4_1 = nowWorld():GetBossProxy()
	local var5_1 = var4_1:GetBossById(var1_1)

	if not var5_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_boss_not_found"))

		return
	end

	if var2_1 and var4_1:GetPt() <= 0 and WorldBossConst._IsCurrBoss(var5_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_count_no_enough"))

		return
	end

	local function var6_1()
		local var0_2 = var5_1:GetStageID()
		local var1_2 = getProxy(ContextProxy):getCurrentContext()

		pg.m02:retrieveMediator(var1_2.mediator.__cname):addSubLayers(Context.New({
			mediator = WorldBossFormationMediator,
			viewComponent = WorldBossFormationLayer,
			data = {
				actID = 0,
				stageId = var0_2,
				bossId = var1_1,
				system = SYSTEM_WORLD_BOSS,
				isOther = var2_1,
				hpRate = var3_1
			}
		}))
	end

	local function var7_1()
		var4_1:RemoveCacheBoss(var5_1.id)
	end

	arg0_1:sendNotification(GAME.CHECK_WORLD_BOSS_STATE, {
		bossId = var1_1,
		time = var5_1.lastTime,
		callback = var6_1,
		failedCallback = var7_1
	})
end

return var0_0
