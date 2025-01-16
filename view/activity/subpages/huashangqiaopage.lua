local var0_0 = class("HuaShangQiaoPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.Build = arg0_1.bg:Find("build"):GetComponent("Button")
	arg0_1.build_times = arg0_1.bg:Find("build/build_times")
	arg0_1.build_time = arg0_1.bg:Find("build/build_times/time"):GetComponent("Text")
	arg0_1.Level = arg0_1.bg:Find("fight"):GetComponent("Button")
	arg0_1.fight_times = arg0_1.bg:Find("fight/fight_times")
	arg0_1.fight_time = arg0_1.bg:Find("fight/fight_times/time"):GetComponent("Text")
	arg0_1.Shop = arg0_1.bg:Find("shop"):GetComponent("Button")
	arg0_1.shop_times = arg0_1.bg:Find("shop/shop_times")
	arg0_1.shop_time = arg0_1.bg:Find("shop/shop_times/time"):GetComponent("Text")
	arg0_1.Manual = arg0_1.bg:Find("Manual"):GetComponent("Button")

	SetActive(arg0_1.build_times, fasle)
	SetActive(arg0_1.fight_times, fasle)
	SetActive(arg0_1.shop_times, fasle)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.time = arg0_2.activity:getConfig("time")
	arg0_2.time = arg0_2.time[2]
	arg0_2.timeMgr = pg.TimeMgr.GetInstance()
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.Manual, function()
		local var0_4 = Context.New({
			mediator = MedalAlbumTemplateMediator,
			viewComponent = SpringFashionFestaMedalAlbumView
		})

		arg0_3:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_4)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.Build, function()
		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD,
			projectName = BuildShipScene.PROJECTS.ACTIVITY
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.Level, function()
		arg0_3:emit(ActivityMediator.GO_SPECIAL_EXERCISE)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.Shop, function()
		arg0_3:emit(ActivityMediator.GO_CHANGE_SHOP)
	end, SFX_PANEL)

	if os.date("%d") == "06" and os.date("%m") == "02" and os.date("%Y") == "2025" then
		SetActive(arg0_3.build_times, true)
		SetActive(arg0_3.fight_times, true)
		SetActive(arg0_3.shop_times, true)
		setText(arg0_3.build_time, i18n("tolovemainpage_build_countdown"))
		setText(arg0_3.fight_time, i18n("tolovemainpage_build_countdown"))

		arg0_3.times = arg0_3.timeMgr:GetServerHour()

		if os.date("%d") >= "01" then
			setText(arg0_3.shop_time, i18n("tolovemainpage_skin_countdown", 24 - arg0_3.times - 1))
		else
			setText(arg0_3.shop_time, i18n("tolovemainpage_skin_countdown", 24 - arg0_3.times))
		end
	end
end

return var0_0
