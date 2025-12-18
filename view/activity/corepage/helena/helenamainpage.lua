local var0_0 = class("HelenaMainPage", import("view.activity.CorePage.DAL.DALMainPage"))

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

	SetActive(arg0_1.build_bgtime, false)
	SetActive(arg0_1.shop_bgtime, false)
	setText(arg0_1.shop:Find("shop"), i18n("yumia_main_tip_3"))
	setText(arg0_1.fight:Find("fight"), i18n("yumia_main_tip_2"))
	setText(arg0_1.build:Find("build"), i18n("yumia_main_tip_1"))
	setText(arg0_1.Manual:Find("Manual"), i18n("fengfanV3_20251023_jinianshouce"))
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.Manual, function()
		local var0_3 = Context.New({
			mediator = MedalAlbumTemplateMediator,
			viewComponent = TianqiongMedalAlbumView
		})

		arg0_2:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_3)
	end)
end

function var0_0.updateUI(arg0_4)
	if not arg0_4.shop_id then
		return
	end

	local var0_4, var1_4 = arg0_4.timeMgr:inTime(pg.shop_template[arg0_4.shop_id].time)
	local var2_4

	if var1_4 then
		local var3_4 = arg0_4.timeMgr:Table2ServerTime(var1_4)

		var2_4 = var0_0:skinCommdityTimeStamps(var3_4)
	end

	setActive(arg0_4.shop_bgtime, var2_4 and var2_4 ~= 0)
	setText(arg0_4.shop_time, var2_4)

	local var4_4, var5_4 = arg0_4.timeMgr:inTime(pg.activity_template[arg0_4.activity.id].time)
	local var6_4

	if var5_4 then
		local var7_4 = arg0_4.timeMgr:Table2ServerTime(var5_4)

		var6_4 = var0_0:skinCommdityTimeStamps(var7_4)
	end

	setActive(arg0_4.build_bgtime, var6_4 and var6_4 ~= 0)
	setText(arg0_4.build_time, i18n("tolovemainpage_build_countdown"))
	onButton(arg0_4, arg0_4.shop, function()
		if var2_4 == nil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_4:emit(ActivityMediator.GO_CHANGE_SHOP)
	end)
	onButton(arg0_4, arg0_4.build, function()
		if var6_4 == nil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_4:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD,
			projectName = BuildShipScene.PROJECTS.ACTIVITY
		})
	end)
	onButton(arg0_4, arg0_4.fight, function()
		arg0_4:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end)
end

return var0_0
