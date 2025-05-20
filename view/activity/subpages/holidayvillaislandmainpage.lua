local var0_0 = class("HolidayVillaIslandMainPage", import(".TemplatePage.PreviewTemplatePage"))

function var0_0.initBtn(arg0_1)
	var0_0.super.initBtn(arg0_1)

	arg0_1.Manual = arg0_1:findTF("Manual", arg0_1.bg)

	function arg0_1.btnFuncList.shop(arg0_2)
		onButton(arg0_1, arg0_2, function()
			local var0_3 = underscore.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_4)
				return arg0_4:getConfig("config_id") == 3
			end)

			if not var0_3 or var0_3:isEnd() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

				return
			end

			local var1_3 = Context.New({
				mediator = HolidayVillaShopMediator,
				viewComponent = HolidayVillaShopLayer
			})

			arg0_1:emit(ActivityMediator.OPEN_LAYER, var1_3)
		end, SFX_PANEL)
	end

	function arg0_1.btnFuncList.activity(arg0_5)
		onButton(arg0_1, arg0_5, function()
			local var0_6 = getProxy(ActivityProxy):getActivityById(ActivityConst.HOLIDAY_ACT_PRE_ID)

			if var0_6.data3 >= 5 then
				local var1_6 = underscore.flatten(var0_6:getConfig("config_data"))
				local var2_6 = getProxy(TaskProxy)
				local var3_6 = var1_6[var0_6.data3]

				if var2_6:getTaskVO(var3_6):getTaskStatus() == 2 then
					arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.HOLIDAY_VILLA_MAP)
				else
					arg0_1:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.HOLIDAY_ACT_PRE_ID)
				end
			else
				arg0_1:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.HOLIDAY_ACT_PRE_ID)
			end
		end, SFX_PANEL)
	end

	onButton(arg0_1, arg0_1.Manual, function()
		local var0_7 = Context.New({
			mediator = MedalAlbumTemplateMediator,
			viewComponent = HolidayVillaMedalAlbumView
		})

		arg0_1:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_7)
	end, SFX_PANEL)
end

return var0_0
