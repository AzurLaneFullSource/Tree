local var0 = class("IslandTaskGoCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1.body.taskVO:getConfig("scene")

	if var0 and #var0 > 0 then
		if var0[1] == "ANNIVERSARY_ISLAND_SEA" then
			local var1 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(SixthAnniversaryIslandMediator)
			local var2 = var0[2].nodeIds

			if var1 then
				arg0:sendNotification(SixthAnniversaryIslandMediator.DISPLAY_NODES, var2)
			else
				arg0:sendNotification(GAME.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SEA, {
					nodeIds = var2
				})
			end
		elseif var0[1] == "ANNIVERSARY_ISLAND_WORKBENCH" then
			local var3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORKBENCH)

			if not var3 or var3:isEnd() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

				return
			end

			local var4 = AcessWithinNull(var0[2], "formulaId")

			if var4 and var4 > 0 then
				local var5 = WorkBenchFormula.New({
					configId = var4
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
			end

			if getProxy(ContextProxy):getCurrentContext():getContextByMediator(AnniversaryIslandComposite2023Mediator) then
				arg0:sendNotification(AnniversaryIslandComposite2023Mediator.OPEN_FORMULA, var4)
			else
				arg0:sendNotification(GAME.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_WORKBENCH, {
					formulaId = var4
				})
			end
		elseif var0[1] == "ISLAND_BUILDING" then
			local var7 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(AnniversaryIsland2023Mediator)
			local var8 = var0[2].build
			local var9 = Context.New({
				mediator = AnniversaryIslandBuildingUpgrade2023WindowMediator,
				viewComponent = AnniversaryIslandBuildingUpgrade2023Window,
				data = {
					isLayer = true,
					buildingID = var8
				}
			})

			if var7 then
				arg0:sendNotification(GAME.LOAD_LAYERS, {
					parentContext = var7,
					context = var9
				})
			else
				local var10 = Context.New()

				SCENE.SetSceneInfo(var10, SCENE.ANNIVERSARY_ISLAND_BACKHILL_2023)
				var10:addChild(var9)
				print("load scene: " .. SCENE.ANNIVERSARY_ISLAND_BACKHILL_2023)
				arg0:sendNotification(GAME.LOAD_SCENE, {
					context = var10
				})
			end
		else
			local var11 = Context.New()

			SCENE.SetSceneInfo(var11, SCENE[var0[1]])

			local var12 = var11.mediator

			if getProxy(ContextProxy):getCurrentContext():getContextByMediator(var12) then
				warning("Enter Current Context")

				return
			end

			arg0:sendNotification(GAME.GO_SCENE, SCENE[var0[1]], var0[2])
		end
	end
end

return var0
