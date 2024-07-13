local var0_0 = class("WorkBenchItemGoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1.body
	local var1_1 = WorkBenchItem.New({
		configId = var0_1
	}):GetSource()

	if var1_1.islandNodes then
		if getProxy(ContextProxy):getCurrentContext():getContextByMediator(SixthAnniversaryIslandMediator) then
			arg0_1:sendNotification(SixthAnniversaryIslandMediator.DISPLAY_NODES, var1_1.islandNodes)
		else
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SEA, {
				nodeIds = var1_1.islandNodes
			})
		end
	elseif var1_1.islandShop then
		local var2_1 = getProxy(ContextProxy):getCurrentContext()

		if var2_1:getContextByMediator(SixthAnniversaryIslandShopMediator) then
			return
		end

		if var2_1:getContextByMediator(SixthAnniversaryIslandMediator) then
			arg0_1:sendNotification(SixthAnniversaryIslandMediator.DISPLAY_SHOP)
		else
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SEA, {
				wraps = SixthAnniversaryIslandScene.SHOP
			})
		end
	elseif var1_1.recipeid then
		local var3_1 = var1_1.recipeid
		local var4_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORKBENCH)

		if not var4_1 or var4_1:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		local var5_1 = WorkBenchFormula.New({
			configId = var3_1
		})

		var5_1:BuildFromActivity()

		if not var5_1:IsAvaliable() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("workbench_tips1"))

			return
		end

		if not var5_1:IsUnlock() then
			local var6_1 = var5_1:GetLockLimit()

			pg.TipsMgr.GetInstance():ShowTips(i18n("workbench_tips4", var6_1 and var6_1[3]))

			return
		end

		if getProxy(ContextProxy):getCurrentContext():getContextByMediator(AnniversaryIslandComposite2023Mediator) then
			arg0_1:sendNotification(AnniversaryIslandComposite2023Mediator.OPEN_FORMULA, var3_1)
		else
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_WORKBENCH, {
				formulaId = var3_1
			})
		end
	elseif var1_1.taskid then
		local var7_1 = getProxy(ActivityProxy):getActivityById(ActivityConst.ISLAND_TASK_ID)

		if not var7_1 or var7_1:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		local var8_1 = getProxy(ContextProxy):getCurrentContext()

		if var8_1:getContextByMediator(IslandTaskMediator) then
			return
		end

		arg0_1:sendNotification(GAME.LOAD_LAYERS, {
			parentContext = var8_1,
			context = Context.New({
				mediator = IslandTaskMediator,
				viewComponent = IslandTaskScene,
				data = {
					task_ids = var1_1.taskid
				}
			})
		})
	elseif var1_1.minigame then
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var1_1.minigame)
	end
end

return var0_0
