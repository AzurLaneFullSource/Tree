local var0_0 = class("IslandMainPage", import(".TemplatePage.PreviewTemplatePage"))

function var0_0.initBtn(arg0_1)
	var0_0.super.initBtn(arg0_1)

	function arg0_1.btnFuncList.shop(arg0_2)
		onButton(arg0_1, arg0_2, function()
			local var0_3 = underscore.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_4)
				return arg0_4:getConfig("config_id") == 3
			end)

			if not var0_3 or var0_3:isEnd() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

				return
			end

			local var1_3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

			if var1_3 and not var1_3:isEnd() then
				arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SEA, {
					wraps = SixthAnniversaryIslandScene.SHOP
				})
			else
				arg0_1:emit(ActivityMediator.OPEN_LAYER, Context.New({
					mediator = SixthAnniversaryIslandShopMediator,
					viewComponent = SixthAnniversaryIslandShopLayer
				}))
			end
		end, SFX_PANEL)
	end

	function arg0_1.btnFuncList.activity(arg0_5)
		onButton(arg0_1, arg0_5, function()
			local var0_6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

			if not var0_6 or var0_6:isEnd() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

				return
			end

			arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SEA)
		end, SFX_PANEL)
	end

	function arg0_1.btnFuncList.mountain(arg0_7)
		onButton(arg0_1, arg0_7, function()
			local var0_8 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

			if not var0_8 or var0_8:isEnd() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

				return
			end

			arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.ANNIVERSARY_ISLAND_BACKHILL_2023)
		end, SFX_PANEL)
	end
end

function var0_0.OnUpdateFlush(arg0_9)
	local var0_9 = {
		shop = function()
			return underscore.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_11)
				return arg0_11:getConfig("config_id") == 3
			end)
		end,
		activity = function()
			return getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)
		end,
		mountain = function()
			return getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)
		end
	}

	for iter0_9, iter1_9 in pairs(var0_9) do
		local var1_9 = iter1_9()

		setButtonEnabled(arg0_9.btnList:Find(iter0_9), tobool(var1_9 and not var1_9:isEnd()))
	end
end

return var0_0
