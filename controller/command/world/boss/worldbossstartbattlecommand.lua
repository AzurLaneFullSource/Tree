local var0 = class("WorldBossStartBattleCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.bossId
	local var2 = var0.isOther
	local var3 = nowWorld():GetBossProxy()
	local var4 = var3:GetBossById(var1)

	if not var4 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_boss_not_found"))

		return
	end

	if var2 and var3:GetPt() <= 0 and WorldBossConst._IsCurrBoss(var4) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_count_no_enough"))

		return
	end

	local function var5()
		local var0 = var4:GetStageID()
		local var1 = getProxy(ContextProxy):getCurrentContext()

		pg.m02:retrieveMediator(var1.mediator.__cname):addSubLayers(Context.New({
			mediator = WorldBossFormationMediator,
			viewComponent = WorldBossFormationLayer,
			data = {
				actID = 0,
				stageId = var0,
				bossId = var1,
				system = SYSTEM_WORLD_BOSS,
				isOther = var2
			}
		}))
	end

	local function var6()
		var3:RemoveCacheBoss(var4.id)
	end

	arg0:sendNotification(GAME.CHECK_WORLD_BOSS_STATE, {
		bossId = var1,
		time = var4.lastTime,
		callback = var5,
		failedCallback = var6
	})
end

return var0
