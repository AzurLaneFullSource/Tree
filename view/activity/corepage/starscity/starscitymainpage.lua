local var0_0 = class("StarsCityMainPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.AD = arg0_1._tf:Find("AD")
	arg0_1.btnManual = arg0_1.AD:Find("TopPage/top/manual")
	arg0_1.Txtmanual = arg0_1.btnManual:Find("Text")
	arg0_1.redMalPoint = arg0_1.btnManual:Find("tip")
	arg0_1.btnGroup = arg0_1.AD:Find("btn_list")
	arg0_1.btnBuild = arg0_1.btnGroup:Find("build")
	arg0_1.btnFight = arg0_1.btnGroup:Find("fight")
	arg0_1.btnShop = arg0_1.btnGroup:Find("shop")
	arg0_1.resTimeBuild = arg0_1.btnBuild:Find("resTime/Text")
	arg0_1.resTimeShop = arg0_1.btnShop:Find("resTime/Text")
end

function var0_0.OnFirstFlush(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_client")

	var0_2 = type(var0_2) == "table" and var0_2 or {}

	local function var1_2(arg0_3)
		if not arg0_3 then
			return false
		end

		local var0_3 = getProxy(ActivityProxy):getActivityById(arg0_3)

		return not var0_3 or var0_3:isEnd()
	end

	onButton(arg0_2, arg0_2.btnBuild, function()
		if var1_2(var0_2.buildLinkActID) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD,
			projectName = BuildShipScene.PROJECTS.ACTIVITY
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.btnFight, function()
		local var0_5 = var0_2.fightLinkActID

		if var0_5 and var1_2(var0_5) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		if var0_5 then
			arg0_2:emit(ActivityMediator.SKIP_ACTIVITY_MAP, var0_5)
		else
			arg0_2:emit(ActivityMediator.BATTLE_OPERA)
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.btnShop, function()
		arg0_2:emit(ActivityMediator.GO_CHANGE_SHOP)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.btnManual, function()
		local var0_7 = Context.New({
			mediator = MedalAlbumTemplateMediator,
			viewComponent = StarsCityMedalAlbumView
		})

		arg0_2:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_7)
	end, SFX_PANEL)
	setText(arg0_2.Txtmanual, i18n("anniversary_nine_main_page"))
	arg0_2:refreshBtnResTime()
	arg0_2:refreshRed()
end

function var0_0.refreshBtnResTime(arg0_8)
	local var0_8 = arg0_8.activity:getConfig("config_client")

	var0_8 = type(var0_8) == "table" and var0_8 or {}

	local var1_8 = pg.TimeMgr.GetInstance():GetServerTime()

	local function var2_8(arg0_9, arg1_9, arg2_9)
		if not arg0_9 then
			return
		end

		local var0_9 = 0
		local var1_9 = 0
		local var2_9 = false

		if arg2_9 == 1 then
			local var3_9 = arg1_9 and getProxy(ActivityProxy):getActivityById(arg1_9) or nil

			var2_9 = var3_9 and not var3_9:isEnd() and var3_9.stopTime and var3_9.stopTime > var1_8

			local var4_9 = var3_9.stopTime - var1_8

			var1_9 = math.floor(var4_9 / 3600)
		else
			local var5_9 = pg.shop_template[arg1_9]
			local var6_9 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var5_9.time[2]) - var1_8

			var1_9 = math.floor(var6_9 / 3600)
			var2_9 = var6_9 > 0
		end

		if var2_9 and var1_9 <= 24 then
			setActive(arg0_9.parent, true)

			if arg2_9 == 1 then
				setText(arg0_9, i18n("StarsCityMainPage_no_time"))
			else
				setText(arg0_9, i18n("StarsCityMainPage_res_day_time", var1_9))
			end
		else
			setActive(arg0_9.parent, false)
			setText(arg0_9, "")
		end
	end

	var2_8(arg0_8.resTimeBuild, var0_8.buildLinkActID, 1)
	var2_8(arg0_8.resTimeShop, var0_8.shopItemID, 2)
end

function var0_0.OnUpdateFlush(arg0_10)
	arg0_10:refreshRed()
	arg0_10:refreshBtnResTime()
end

function var0_0.refreshRed(arg0_11)
	local var0_11, var1_11 = var0_0.GetFujinBayMedalTaskCount()

	setActive(arg0_11.redMalPoint, var1_11 > 0)
end

function var0_0.IsShowReminder(arg0_12)
	return var0_0.IsTip()
end

function var0_0.IsTip()
	return var0_0.IsFujinBayMedalTaskTip()
end

function var0_0.IsFujinBayMedalTaskTip()
	local var0_14, var1_14 = var0_0.GetFujinBayMedalTaskCount()

	return var1_14 > 0
end

function var0_0.GetFujinBayMedalTaskCount()
	local var0_15 = StarsCityMedalAlbumView.GROUP_ID
	local var1_15 = pg.activity_medal_group[var0_15]
	local var2_15 = var1_15 and var1_15.activity_link or {}
	local var3_15

	for iter0_15, iter1_15 in ipairs(var2_15) do
		local var4_15 = iter1_15[2]
		local var5_15 = getProxy(ActivityProxy):getActivityById(var4_15)

		if var5_15 and not var5_15:isEnd() then
			var3_15 = iter1_15[3]

			break
		end
	end

	if not var3_15 then
		return 0, 0, 0
	end

	local var6_15 = getProxy(TaskProxy)
	local var7_15 = 0
	local var8_15 = 0
	local var9_15 = #var3_15

	for iter2_15, iter3_15 in ipairs(var3_15) do
		local var10_15 = var6_15:getTaskById(iter3_15) or var6_15:getFinishTaskById(iter3_15)

		if var10_15 then
			local var11_15 = var10_15:getTaskStatus()

			if var11_15 == 1 then
				var8_15 = var8_15 + 1
				var7_15 = var7_15 + 1
			elseif var11_15 == 2 then
				var7_15 = var7_15 + 1
			end
		end
	end

	return var7_15, var8_15, var9_15
end

return var0_0
