local var0 = class("IslandMainPage", import(".TemplatePage.PreviewTemplatePage"))

function var0.initBtn(arg0)
	var0.super.initBtn(arg0)

	function arg0.btnFuncList.shop(arg0)
		onButton(arg0, arg0, function()
			local var0 = underscore.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0)
				return arg0:getConfig("config_id") == 3
			end)

			if not var0 or var0:isEnd() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

				return
			end

			local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

			if var1 and not var1:isEnd() then
				arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SEA, {
					wraps = SixthAnniversaryIslandScene.SHOP
				})
			else
				arg0:emit(ActivityMediator.OPEN_LAYER, Context.New({
					mediator = SixthAnniversaryIslandShopMediator,
					viewComponent = SixthAnniversaryIslandShopLayer
				}))
			end
		end, SFX_PANEL)
	end

	function arg0.btnFuncList.activity(arg0)
		onButton(arg0, arg0, function()
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

			if not var0 or var0:isEnd() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

				return
			end

			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SEA)
		end, SFX_PANEL)
	end

	function arg0.btnFuncList.mountain(arg0)
		onButton(arg0, arg0, function()
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

			if not var0 or var0:isEnd() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

				return
			end

			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.ANNIVERSARY_ISLAND_BACKHILL_2023)
		end, SFX_PANEL)
	end
end

function var0.OnUpdateFlush(arg0)
	local var0 = {
		shop = function()
			return underscore.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0)
				return arg0:getConfig("config_id") == 3
			end)
		end,
		activity = function()
			return getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)
		end,
		mountain = function()
			return getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)
		end
	}

	for iter0, iter1 in pairs(var0) do
		local var1 = iter1()

		setButtonEnabled(arg0.btnList:Find(iter0), tobool(var1 and not var1:isEnd()))
	end
end

return var0
