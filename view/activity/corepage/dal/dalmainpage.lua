local var0_0 = class("DALMainPage", import("view.activity.CorePage.CoreActivityPage"))

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

	SetActive(arg0_1.build_bgtime, false)
	SetActive(arg0_1.shop_bgtime, false)
	setText(arg0_1.shop:Find("Text"), i18n("yumia_main_tip_3"))
	setText(arg0_1.fight:Find("Text"), i18n("yumia_main_tip_2"))
	setText(arg0_1.build:Find("Text"), i18n("yumia_main_tip_1"))
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.timeMgr = pg.TimeMgr.GetInstance()
	arg0_2.shop_id = arg0_2.activity:getConfig("config_client").shopItemID
end

function var0_0.OnFirstFlush(arg0_3)
	arg0_3:updateUI()
end

function var0_0.OnUpdateFlush(arg0_4)
	arg0_4:updateUI()
end

function var0_0.updateUI(arg0_5)
	if not arg0_5.shop_id then
		return
	end

	local var0_5, var1_5 = arg0_5.timeMgr:inTime(pg.shop_template[arg0_5.shop_id].time)
	local var2_5

	if var1_5 then
		local var3_5 = arg0_5.timeMgr:Table2ServerTime(var1_5)

		var2_5 = var0_0:skinCommdityTimeStamps(var3_5)
	end

	setActive(arg0_5.shop_bgtime, var2_5 and var2_5 ~= 0)
	setText(arg0_5.shop_time, var2_5)

	local var4_5, var5_5 = arg0_5.timeMgr:inTime(pg.activity_template[arg0_5.activity.id].time)
	local var6_5

	if var5_5 then
		local var7_5 = arg0_5.timeMgr:Table2ServerTime(var5_5)

		var6_5 = var0_0:skinCommdityTimeStamps(var7_5)
	end

	setActive(arg0_5.build_bgtime, var6_5 and var6_5 ~= 0)
	setText(arg0_5.build_time, i18n("tolovemainpage_build_countdown"))
	onButton(arg0_5, arg0_5.shop, function()
		if var2_5 == nil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_5:emit(ActivityMediator.GO_CHANGE_SHOP)
	end)
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
		arg0_5:emit(ActivityMediator.ON_COLLAB_BOSSRUSH_MAP)
	end)
end

function var0_0.skinCommdityTimeStamps(arg0_9, arg1_9)
	local var0_9 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_9 = math.max(arg1_9 - var0_9, 0)

	if math.floor(var1_9 / 86400) > 0 then
		return 0
	else
		local var2_9 = math.floor(var1_9 / 3600)

		if var2_9 > 0 then
			return i18n("shop_new_during_hour", var2_9)
		else
			local var3_9 = math.floor(var1_9 / 60)

			if var3_9 > 0 then
				return i18n("shop_new_during_minite", var3_9)
			else
				return i18n("shop_new_during_minite", var3_9)
			end
		end
	end
end

return var0_0
