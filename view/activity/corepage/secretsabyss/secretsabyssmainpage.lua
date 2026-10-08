local var0_0 = class("SecretsAbyssMainPage", import("view.activity.CorePage.CoreActivityPage"))
local var1_0 = 71165
local var2_0 = 50081
local var3_0 = 50081

function var0_0.OnInit(arg0_1)
	arg0_1.AD = arg0_1:findTF("bg")
	arg0_1.list = arg0_1:findTF("list", arg0_1.AD)
	arg0_1.build = arg0_1:findTF("build", arg0_1.list)
	arg0_1.build_bgtime = arg0_1:findTF("time_bg", arg0_1.build)
	arg0_1.build_time = arg0_1:findTF("time", arg0_1.build_bgtime)
	arg0_1.fight = arg0_1:findTF("fight", arg0_1.list)
	arg0_1.shop = arg0_1:findTF("shop", arg0_1.list)
	arg0_1.shop_bgtime = arg0_1:findTF("time_bg", arg0_1.shop)
	arg0_1.shop_time = arg0_1:findTF("time", arg0_1.shop_bgtime)
	arg0_1.Manual = arg0_1:findTF("Manual", arg0_1.AD)

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
			viewComponent = MassenaMedalAlbumView
		})

		arg0_4:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_5)
	end)
	arg0_4:updateUI()
end

function var0_0.OnUpdateFlush(arg0_6)
	arg0_6:updateUI()
end

function var0_0.updateUI(arg0_7)
	local var0_7, var1_7 = arg0_7.timeMgr:inTime(ShopConst.GetShopConfig(var1_0).time)
	local var2_7

	if var1_7 then
		local var3_7 = arg0_7.timeMgr:Table2ServerTime(var1_7)

		var2_7 = var0_0:skinCommdityTimeStamps(var3_7)
	end

	setActive(arg0_7.shop_bgtime, var2_7 and var2_7 ~= 0)
	setText(arg0_7.shop_time, var2_7)

	local var4_7 = arg0_7.activity.stopTime

	buildLastTime = var0_0:skinCommdityTimeStamps(var4_7)

	setActive(arg0_7.build_bgtime, buildLastTime and buildLastTime ~= 0)
	setText(arg0_7.build_time, i18n("tolovemainpage_build_countdown"))
	onButton(arg0_7, arg0_7.shop, function()
		if var2_7 == nil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_7:emit(ActivityMediator.GO_CHANGE_SHOP)
	end)
	onButton(arg0_7, arg0_7.build, function()
		if buildLastTime == nil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_7:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD,
			projectName = BuildShipScene.PROJECTS.ACTIVITY
		})
	end)
	onButton(arg0_7, arg0_7.fight, function()
		arg0_7:emit(ActivityMediator.BATTLE_OPERA)
	end)
end

function var0_0.skinCommdityTimeStamps(arg0_11, arg1_11)
	local var0_11 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_11 = math.max(arg1_11 - var0_11, 0)

	if math.floor(var1_11 / 86400) > 0 then
		return 0
	else
		local var2_11 = math.floor(var1_11 / 3600)

		if var2_11 > 0 then
			return var2_11 .. i18n("word_hour")
		else
			local var3_11 = math.floor(var1_11 / 60)

			if var3_11 > 0 then
				return var3_11 .. i18n("word_minute")
			else
				return var1_11 .. i18n("word_second")
			end
		end
	end
end

function var0_0.OnDestroy(arg0_12)
	if arg0_12.camEventId then
		pg.CameraFixMgr.GetInstance():disconnect(arg0_12.camEventId)

		arg0_12.camEventId = nil
	end
end

return var0_0
