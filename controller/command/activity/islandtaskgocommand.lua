local var0_0 = class("IslandTaskGoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1.body.taskVO:getConfig("scene")

	if var0_1 and #var0_1 > 0 then
		if var0_1[1] == "ANNIVERSARY_ISLAND_SEA" then
			local var1_1 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(SixthAnniversaryIslandMediator)
			local var2_1 = var0_1[2].nodeIds

			if var1_1 then
				arg0_1:sendNotification(SixthAnniversaryIslandMediator.DISPLAY_NODES, var2_1)
			else
				arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SEA, {
					nodeIds = var2_1
				})
			end
		elseif var0_1[1] == "ANNIVERSARY_ISLAND_WORKBENCH" then
			local var3_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORKBENCH)

			if not var3_1 or var3_1:isEnd() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

				return
			end

			local var4_1 = AcessWithinNull(var0_1[2], "formulaId")

			if var4_1 and var4_1 > 0 then
				local var5_1 = WorkBenchFormula.New({
					configId = var4_1
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
			end

			if getProxy(ContextProxy):getCurrentContext():getContextByMediator(AnniversaryIslandComposite2023Mediator) then
				arg0_1:sendNotification(AnniversaryIslandComposite2023Mediator.OPEN_FORMULA, var4_1)
			else
				arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_WORKBENCH, {
					formulaId = var4_1
				})
			end
		elseif var0_1[1] == "ISLAND_BUILDING" then
			local var7_1 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(AnniversaryIsland2023Mediator)
			local var8_1 = var0_1[2].build
			local var9_1 = Context.New({
				mediator = AnniversaryIslandBuildingUpgrade2023WindowMediator,
				viewComponent = AnniversaryIslandBuildingUpgrade2023Window,
				data = {
					isLayer = true,
					buildingID = var8_1
				}
			})

			if var7_1 then
				arg0_1:sendNotification(GAME.LOAD_LAYERS, {
					parentContext = var7_1,
					context = var9_1
				})
			else
				local var10_1 = Context.New()

				SCENE.SetSceneInfo(var10_1, SCENE.ANNIVERSARY_ISLAND_BACKHILL_2023)
				var10_1:addChild(var9_1)
				print("load scene: " .. SCENE.ANNIVERSARY_ISLAND_BACKHILL_2023)
				arg0_1:sendNotification(GAME.LOAD_SCENE, {
					context = var10_1
				})
			end
		else
			local var11_1 = Context.New()

			SCENE.SetSceneInfo(var11_1, SCENE[var0_1[1]])

			local var12_1 = var11_1.mediator

			if getProxy(ContextProxy):getCurrentContext():getContextByMediator(var12_1) then
				warning("Enter Current Context")

				return
			end

			arg0_1:sendNotification(GAME.GO_SCENE, SCENE[var0_1[1]], var0_1[2])
		end
	end
end

return var0_0
