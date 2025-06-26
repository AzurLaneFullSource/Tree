local var0_0 = class("ZengKeMainPage", import("...base.BaseActivityPage"))
local var1_0 = 71151
local var2_0 = 50013
local var3_0 = 50013

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.btnList = arg0_1:findTF("btn_list", arg0_1.bg)
	arg0_1.build_bgtime = arg0_1.bg:Find("btn_list/build/build_bgtime")
	arg0_1.build_time = arg0_1.bg:Find("btn_list/build/build_bgtime/time")
	arg0_1.shop_bgtime = arg0_1.bg:Find("btn_list/shop/shop_bgtime")
	arg0_1.shop_time = arg0_1.bg:Find("btn_list/shop/shop_bgtime/time")
	arg0_1.Manual = arg0_1.bg:Find("Manual")

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
			viewComponent = CamouflageCityMedalAlbumView
		})

		arg0_3:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_4)
	end)
	arg0_3:updateUI()
	eachChild(arg0_3.btnList, function(arg0_5)
		arg0_3.btnFuncList[arg0_5.name](arg0_5)
	end)
end

function var0_0.OnUpdateFlush(arg0_6)
	arg0_6:updateUI()
end

function var0_0.updateUI(arg0_7)
	local var0_7, var1_7 = arg0_7.timeMgr:inTime(pg.shop_template[var1_0].time)
	local var2_7

	if var1_7 then
		local var3_7 = arg0_7.timeMgr:Table2ServerTime(var1_7)

		var2_7 = var0_0:skinCommdityTimeStamps(var3_7)
	end

	setActive(arg0_7.shop_bgtime, var2_7 and var2_7 ~= 0)
	setText(arg0_7.shop_time, var2_7)

	local var4_7, var5_7 = arg0_7.timeMgr:inTime(pg.activity_template[var3_0].time)
	local var6_7

	if var5_7 then
		local var7_7 = arg0_7.timeMgr:Table2ServerTime(var5_7)

		var6_7 = var0_0:skinCommdityTimeStamps(var7_7)
	end

	setActive(arg0_7.build_bgtime, var6_7 and var6_7 ~= 0)
	setText(arg0_7.build_time, i18n("tolovemainpage_build_countdown"))

	local var8_7 = arg0_7.activity:getConfig("config_client")

	arg0_7.btnFuncList = {
		shop = function(arg0_8)
			onButton(arg0_7, arg0_8, function()
				if var2_7 == nil then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0_7:emit(ActivityMediator.GO_CHANGE_SHOP)
			end)
		end,
		build = function(arg0_10)
			onButton(arg0_7, arg0_10, function()
				if var6_7 == nil then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0_7:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
					page = BuildShipScene.PAGE_BUILD,
					projectName = BuildShipScene.PROJECTS.ACTIVITY
				})
			end)
		end,
		fight = function(arg0_12)
			onButton(arg0_7, arg0_12, function()
				arg0_7:emit(ActivityMediator.ON_BOSSRUSH_MAP)
			end)
		end
	}
end

function var0_0.skinCommdityTimeStamps(arg0_14, arg1_14)
	local var0_14 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_14 = math.max(arg1_14 - var0_14, 0)

	if math.floor(var1_14 / 86400) > 0 then
		return 0
	else
		local var2_14 = math.floor(var1_14 / 3600)

		if var2_14 > 0 then
			return var2_14 .. i18n("word_hour")
		else
			local var3_14 = math.floor(var1_14 / 60)

			if var3_14 > 0 then
				return var3_14 .. i18n("word_minute")
			else
				return var1_14 .. i18n("word_second")
			end
		end
	end
end

return var0_0
