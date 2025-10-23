local var0_0 = class("SailingShip3MainPage", import("view.activity.CorePage.CoreActivityPage"))
local var1_0 = 71226
local var2_0 = 50181
local var3_0 = 50181

function var0_0.OnInit(arg0_1)
	arg0_1.AD = arg0_1._tf:Find("bg")
	arg0_1.list = arg0_1.AD:Find("list")
	arg0_1.build = arg0_1.list:Find("build")
	arg0_1.build_bgtime = arg0_1.build:Find("time_bg")
	arg0_1.build_time = arg0_1.build_bgtime:Find("time")
	arg0_1.fight = arg0_1.list:Find("fight")
	arg0_1.shop = arg0_1.list:Find("shop")
	arg0_1.shop_bgtime = arg0_1.shop:Find("time_bg")
	arg0_1.shop_time = arg0_1.shop_bgtime:Find("time")
	arg0_1.Manual = arg0_1.AD:Find("Manual")
	arg0_1.name = arg0_1.Manual:Find("name")

	setText(arg0_1.name, i18n("fengfanV3_20251023_jinianshouce"))
	SetActive(arg0_1.build_bgtime, false)
	SetActive(arg0_1.shop_bgtime, false)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.timeMgr = pg.TimeMgr.GetInstance()
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.Manual, function()
		local var0_4 = Context.New({
			mediator = MedalAlbumTemplateMediator,
			viewComponent = SailingShip3MedalAlbumView
		})

		arg0_3:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_4)
	end)
	arg0_3:updateUI()
end

function var0_0.OnUpdateFlush(arg0_5)
	arg0_5:updateUI()
end

function var0_0.updateUI(arg0_6)
	local var0_6, var1_6 = arg0_6.timeMgr:inTime(pg.shop_template[var1_0].time)
	local var2_6

	if var1_6 then
		local var3_6 = arg0_6.timeMgr:Table2ServerTime(var1_6)

		var2_6 = var0_0:skinCommdityTimeStamps(var3_6)
	end

	setActive(arg0_6.shop_bgtime, var2_6 and var2_6 ~= 0)
	setText(arg0_6.shop_time, var2_6)

	local var4_6, var5_6 = arg0_6.timeMgr:inTime(pg.activity_template[var3_0].time)
	local var6_6

	if var5_6 then
		local var7_6 = arg0_6.timeMgr:Table2ServerTime(var5_6)

		var6_6 = var0_0:skinCommdityTimeStamps(var7_6)
	end

	setActive(arg0_6.build_bgtime, var6_6 and var6_6 ~= 0)
	setText(arg0_6.build_time, i18n("tolovemainpage_build_countdown"))
	onButton(arg0_6, arg0_6.shop, function()
		if var2_6 == nil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_6:emit(ActivityMediator.GO_CHANGE_SHOP)
	end)
	onButton(arg0_6, arg0_6.build, function()
		if var6_6 == nil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_6:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD,
			projectName = BuildShipScene.PROJECTS.ACTIVITY
		})
	end)
	onButton(arg0_6, arg0_6.fight, function()
		arg0_6:emit(ActivityMediator.BATTLE_OPERA)
	end)
end

function var0_0.skinCommdityTimeStamps(arg0_10, arg1_10)
	local var0_10 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_10 = math.max(arg1_10 - var0_10, 0)

	if math.floor(var1_10 / 86400) > 0 then
		return 0
	else
		local var2_10 = math.floor(var1_10 / 3600)

		if var2_10 > 0 then
			return i18n("shop_new_during_hour", var2_10)
		else
			local var3_10 = math.floor(var1_10 / 60)

			if var3_10 > 0 then
				return i18n("shop_new_during_minite", var3_10)
			end
		end
	end
end

function var0_0.OnShowFlush(arg0_11)
	setCanvasGroupAlpha(arg0_11._tf, 1)
end

return var0_0
