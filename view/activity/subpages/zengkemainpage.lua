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

function var0_0.findTF(arg0_2, arg1_2, arg2_2)
	return findTF(arg2_2 or arg0_2._tf, arg1_2)
end

function var0_0.OnDataSetting(arg0_3)
	arg0_3.timeMgr = pg.TimeMgr.GetInstance()
end

function var0_0.OnFirstFlush(arg0_4)
	onButton(arg0_4, arg0_4.Manual, function()
		local var0_5 = Context.New({
			mediator = MedalAlbumTemplateMediator,
			viewComponent = CamouflageCityMedalAlbumView
		})

		arg0_4:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_5)
	end)
	arg0_4:updateUI()
	eachChild(arg0_4.btnList, function(arg0_6)
		arg0_4.btnFuncList[arg0_6.name](arg0_6)
	end)
end

function var0_0.OnUpdateFlush(arg0_7)
	arg0_7:updateUI()
end

function var0_0.updateUI(arg0_8)
	local var0_8, var1_8 = arg0_8.timeMgr:inTime(ShopConst.GetShopConfig(var1_0).time)
	local var2_8

	if var1_8 then
		local var3_8 = arg0_8.timeMgr:Table2ServerTime(var1_8)

		var2_8 = var0_0:skinCommdityTimeStamps(var3_8)
	end

	setActive(arg0_8.shop_bgtime, var2_8 and var2_8 ~= 0)
	setText(arg0_8.shop_time, var2_8)

	local var4_8, var5_8 = arg0_8.timeMgr:inTime(pg.activity_template[var3_0].time)
	local var6_8

	if var5_8 then
		local var7_8 = arg0_8.timeMgr:Table2ServerTime(var5_8)

		var6_8 = var0_0:skinCommdityTimeStamps(var7_8)
	end

	setActive(arg0_8.build_bgtime, var6_8 and var6_8 ~= 0)
	setText(arg0_8.build_time, i18n("tolovemainpage_build_countdown"))

	local var8_8 = arg0_8.activity:getConfig("config_client")

	arg0_8.btnFuncList = {
		shop = function(arg0_9)
			onButton(arg0_8, arg0_9, function()
				if var2_8 == nil then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0_8:emit(ActivityMediator.GO_CHANGE_SHOP)
			end)
		end,
		build = function(arg0_11)
			onButton(arg0_8, arg0_11, function()
				if var6_8 == nil then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0_8:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
					page = BuildShipScene.PAGE_BUILD,
					projectName = BuildShipScene.PROJECTS.ACTIVITY
				})
			end)
		end,
		fight = function(arg0_13)
			onButton(arg0_8, arg0_13, function()
				arg0_8:emit(ActivityMediator.ON_BOSSRUSH_MAP)
			end)
		end
	}
end

function var0_0.skinCommdityTimeStamps(arg0_15, arg1_15)
	local var0_15 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_15 = math.max(arg1_15 - var0_15, 0)

	if math.floor(var1_15 / 86400) > 0 then
		return 0
	else
		local var2_15 = math.floor(var1_15 / 3600)

		if var2_15 > 0 then
			return var2_15 .. i18n("word_hour")
		else
			local var3_15 = math.floor(var1_15 / 60)

			if var3_15 > 0 then
				return var3_15 .. i18n("word_minute")
			else
				return var1_15 .. i18n("word_second")
			end
		end
	end
end

return var0_0
