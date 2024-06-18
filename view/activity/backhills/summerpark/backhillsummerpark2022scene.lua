local var0_0 = class("BackHillSummerPark2022Scene", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "BackHillSummerParkUI"
end

var0_0.edge2area = {
	default = "_SDPlace"
}

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)

	arg0_2.top = arg0_2:findTF("top")
	arg0_2._bg = arg0_2:findTF("BG")
	arg0_2._map = arg0_2:findTF("map")

	for iter0_2 = 0, arg0_2._map.childCount - 1 do
		local var0_2 = arg0_2._map:GetChild(iter0_2)
		local var1_2 = go(var0_2).name

		arg0_2["map_" .. var1_2] = var0_2
	end

	arg0_2._shipTpl = arg0_2:findTF("ship")
	arg0_2._upper = arg0_2:findTF("upper")

	for iter1_2 = 0, arg0_2._upper.childCount - 1 do
		local var2_2 = arg0_2._upper:GetChild(iter1_2)
		local var3_2 = go(var2_2).name

		arg0_2["upper_" .. var3_2] = var2_2
	end

	arg0_2._SDPlace = arg0_2._tf:Find("SDPlace")
	arg0_2.containers = {
		arg0_2._SDPlace
	}
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.BackHillSummerParkGraph"))
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3:findTF("top/Back"), function()
		arg0_3:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("top/Home"), function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.summerland_tip.tip
		})
	end, SFX_PANEL)

	local var0_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_ICECREAM)

	arg0_3:InitStudents(var0_3 and var0_3.id, 2, 4)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "bingqilin", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 41)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "qimazhan", function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.ISUZU_SPORTS_SKIN_ID
		})
	end)
	setActive(arg0_3.map_shujvhuigu, PLATFORM_CODE == PLATFORM_US)
	setActive(arg0_3.upper_shujvhuigu, PLATFORM_CODE == PLATFORM_US)

	if PLATFORM_CODE == PLATFORM_US then
		local function var1_3()
			arg0_3:emit(NewYearFestivalMediator.GO_SCENE, SCENE.SUMMARY)
		end

		arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "shujvhuigu", var1_3)
	end

	arg0_3:BindItemSkinShop()
	arg0_3:BindItemBuildShip()
	arg0_3:UpdateView()
end

function var0_0.UpdateView(arg0_10)
	local function var0_10()
		return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_ICECREAM)
	end

	setActive(arg0_10.upper_bingqilin:Find("Tip"), var0_10())

	local function var1_10()
		local var0_12 = getProxy(ActivityProxy):getActivityById(ActivityConst.ISUZU_SPORTS_SKIN_ID)

		return Activity.IsActivityReady(var0_12)
	end

	setActive(arg0_10.upper_qimazhan:Find("Tip"), var1_10())

	local function var2_10()
		if PLATFORM_CODE ~= PLATFORM_US then
			return
		end

		local var0_13 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

		return Activity.IsActivityReady(var0_13)
	end

	setActive(arg0_10.upper_shujvhuigu:Find("Tip"), var2_10())
end

function var0_0.IsShowMainTip(arg0_14)
	local function var0_14()
		return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_ICECREAM)
	end

	local function var1_14()
		local var0_16 = getProxy(ActivityProxy):getActivityById(ActivityConst.ISUZU_SPORTS_SKIN_ID)

		return Activity.IsActivityReady(var0_16)
	end

	local function var2_14()
		if PLATFORM_CODE ~= PLATFORM_US then
			return
		end

		local var0_17 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

		return Activity.IsActivityReady(var0_17)
	end

	return var0_14() or var1_14() or var2_14()
end

function var0_0.willExit(arg0_18)
	arg0_18:clearStudents()
	var0_0.super.willExit(arg0_18)
end

return var0_0
