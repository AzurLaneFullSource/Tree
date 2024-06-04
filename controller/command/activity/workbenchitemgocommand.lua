local var0 = class("WorkBenchItemGoCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1.body
	local var1 = WorkBenchItem.New({
		configId = var0
	}):GetSource()

	if var1.islandNodes then
		if getProxy(ContextProxy):getCurrentContext():getContextByMediator(SixthAnniversaryIslandMediator) then
			arg0:sendNotification(SixthAnniversaryIslandMediator.DISPLAY_NODES, var1.islandNodes)
		else
			arg0:sendNotification(GAME.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SEA, {
				nodeIds = var1.islandNodes
			})
		end
	elseif var1.islandShop then
		local var2 = getProxy(ContextProxy):getCurrentContext()

		if var2:getContextByMediator(SixthAnniversaryIslandShopMediator) then
			return
		end

		if var2:getContextByMediator(SixthAnniversaryIslandMediator) then
			arg0:sendNotification(SixthAnniversaryIslandMediator.DISPLAY_SHOP)
		else
			arg0:sendNotification(GAME.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SEA, {
				wraps = SixthAnniversaryIslandScene.SHOP
			})
		end
	elseif var1.recipeid then
		local var3 = var1.recipeid
		local var4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORKBENCH)

		if not var4 or var4:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		local var5 = WorkBenchFormula.New({
			configId = var3
		})

		var5:BuildFromActivity()

		if not var5:IsAvaliable() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("workbench_tips1"))

			return
		end

		if not var5:IsUnlock() then
			local var6 = var5:GetLockLimit()

			pg.TipsMgr.GetInstance():ShowTips(i18n("workbench_tips4", var6 and var6[3]))

			return
		end

		if getProxy(ContextProxy):getCurrentContext():getContextByMediator(AnniversaryIslandComposite2023Mediator) then
			arg0:sendNotification(AnniversaryIslandComposite2023Mediator.OPEN_FORMULA, var3)
		else
			arg0:sendNotification(GAME.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_WORKBENCH, {
				formulaId = var3
			})
		end
	elseif var1.taskid then
		local var7 = getProxy(ActivityProxy):getActivityById(ActivityConst.ISLAND_TASK_ID)

		if not var7 or var7:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		local var8 = getProxy(ContextProxy):getCurrentContext()

		if var8:getContextByMediator(IslandTaskMediator) then
			return
		end

		arg0:sendNotification(GAME.LOAD_LAYERS, {
			parentContext = var8,
			context = Context.New({
				mediator = IslandTaskMediator,
				viewComponent = IslandTaskScene,
				data = {
					task_ids = var1.taskid
				}
			})
		})
	elseif var1.minigame then
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var1.minigame)
	end
end

return var0
