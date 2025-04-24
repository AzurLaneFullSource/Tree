local var0_0 = class("HeLanMainPage", import("...base.BaseActivityPage"))
local var1_0 = 71132
local var2_0 = 5901
local var3_0 = 5901

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
		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_ALBUM
		})
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
	local var0_7 = false
	local var1_7, var2_7 = arg0_7.timeMgr:inTime(pg.shop_template[var1_0].time)
	local var3_7

	if var2_7 then
		local var4_7 = arg0_7.timeMgr:Table2ServerTime(var2_7)

		var3_7 = var0_0:skinCommdityTimeStamps(var4_7)
	end

	local var5_7, var6_7 = arg0_7.timeMgr:inTime(pg.activity_template[var3_0].time)
	local var7_7 = 0

	if var6_7 then
		local var8_7 = arg0_7.timeMgr:Table2ServerTime(var6_7)

		var7_7 = var0_0:skinCommdityTimeStamps(var8_7)
	end

	if var3_7 and var3_7 ~= 0 then
		setActive(arg0_7.shop_bgtime, true)
		setText(arg0_7.shop_time, var3_7)
	else
		setActive(arg0_7.shop_bgtime, false)
	end

	if var7_7 and var7_7 ~= 0 then
		setActive(arg0_7.build_bgtime, true)
		setText(arg0_7.build_time, i18n("tolovemainpage_build_countdown"))
	else
		setActive(arg0_7.build_bgtime, false)
	end

	local var9_7 = arg0_7.activity:getConfig("config_client")

	arg0_7.btnFuncList = {
		shop = function(arg0_8)
			onButton(arg0_7, arg0_8, function()
				if var3_7 == nil then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0_7:emit(ActivityMediator.GO_CHANGE_SHOP)
			end)
		end,
		build = function(arg0_10)
			onButton(arg0_7, arg0_10, function()
				if var7_7 == nil then
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
				arg0_7:emit(ActivityMediator.BATTLE_OPERA)
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
			return i18n("time_remaining_tip") .. var2_14 .. i18n("word_hour")
		else
			local var3_14 = math.floor(var1_14 / 60)

			if var3_14 > 0 then
				return i18n("time_remaining_tip") .. var3_14 .. i18n("word_minute")
			else
				return i18n("time_remaining_tip") .. var1_14 .. i18n("word_second")
			end
		end
	end
end

return var0_0
