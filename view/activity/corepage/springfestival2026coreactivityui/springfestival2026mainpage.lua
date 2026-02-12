local var0_0 = class("SpringFestival2026MainPage", import("view.activity.CorePage.Helena.HelenaMainPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.AD = arg0_1._tf:Find("bg")
	arg0_1.list = arg0_1.AD:Find("list")
	arg0_1.build = arg0_1.list:Find("buildbtn")
	arg0_1.build_bgtime = arg0_1.build:Find("time_bg")
	arg0_1.build_time = arg0_1.build_bgtime:Find("time")
	arg0_1.fight = arg0_1.list:Find("fightbtn")
	arg0_1.shop = arg0_1.list:Find("shopbtn")
	arg0_1.shop_bgtime = arg0_1.shop:Find("time_bg")
	arg0_1.shop_time = arg0_1.shop_bgtime:Find("time")
	arg0_1.Manual = arg0_1.AD:Find("Manualbtn")
	arg0_1.plot = arg0_1.AD:Find("plot")

	SetActive(arg0_1.build_bgtime, false)
	SetActive(arg0_1.shop_bgtime, false)
	setText(arg0_1.Manual:Find("Text"), i18n("fengfanV3_20251023_jinianshouce"))
	setText(arg0_1.plot:Find("Text"), i18n("drawdiary_ui_2026"))
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.Manual, function()
		local var0_3 = Context.New({
			mediator = MedalAlbumTemplateMediator,
			viewComponent = DonghuangMedalAlbumView
		})

		arg0_2:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_3)
	end)
	onButton(arg0_2, arg0_2.plot, function()
		local var0_4 = Context.New({
			mediator = SpringFestival2026ColoringAnshanMediator,
			viewComponent = SpringFestival2026ColoringAnshanscene
		})

		arg0_2:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_4)
	end)
end

function var0_0.updateUI(arg0_5)
	if arg0_5.shop_id then
		local var0_5, var1_5 = arg0_5.timeMgr:inTime(pg.shop_template[arg0_5.shop_id].time)
		local var2_5

		if var1_5 then
			local var3_5 = arg0_5.timeMgr:Table2ServerTime(var1_5)

			var2_5 = var0_0:skinCommdityTimeStamps(var3_5)
		end

		setActive(arg0_5.shop_bgtime, var2_5 and var2_5 ~= 0)
		setText(arg0_5.shop_time, var2_5)
		onButton(arg0_5, arg0_5.shop, function()
			if var2_5 == nil then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

				return
			end

			arg0_5:emit(ActivityMediator.GO_CHANGE_SHOP)
		end)
	end

	local var4_5, var5_5 = arg0_5.timeMgr:inTime(pg.activity_template[arg0_5.activity.id].time)
	local var6_5

	if var5_5 then
		local var7_5 = arg0_5.timeMgr:Table2ServerTime(var5_5)

		var6_5 = var0_0:skinCommdityTimeStamps(var7_5)
	end

	setActive(arg0_5.build_bgtime, var6_5 and var6_5 ~= 0)
	setText(arg0_5.build_time, i18n("tolovemainpage_build_countdown"))
	onButton(arg0_5, arg0_5.build, function()
		if var6_5 == nil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_5:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD,
			projectName = BuildShipScene.PROJECTS.ACTIVITY
		})
	end)
	onButton(arg0_5, arg0_5.fight, function()
		local var0_8 = Context.New({
			mediator = ActivityBossMediatorTemplate,
			viewComponent = ActivityBossZhangwuScene
		})

		arg0_5:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_8)
	end)
end

return var0_0
