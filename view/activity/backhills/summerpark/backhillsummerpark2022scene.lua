local var0 = class("BackHillSummerPark2022Scene", import("..TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "BackHillSummerParkUI"
end

var0.edge2area = {
	default = "_SDPlace"
}

function var0.init(arg0)
	var0.super.init(arg0)

	arg0.top = arg0:findTF("top")
	arg0._bg = arg0:findTF("BG")
	arg0._map = arg0:findTF("map")

	for iter0 = 0, arg0._map.childCount - 1 do
		local var0 = arg0._map:GetChild(iter0)
		local var1 = go(var0).name

		arg0["map_" .. var1] = var0
	end

	arg0._shipTpl = arg0:findTF("ship")
	arg0._upper = arg0:findTF("upper")

	for iter1 = 0, arg0._upper.childCount - 1 do
		local var2 = arg0._upper:GetChild(iter1)
		local var3 = go(var2).name

		arg0["upper_" .. var3] = var2
	end

	arg0._SDPlace = arg0._tf:Find("SDPlace")
	arg0.containers = {
		arg0._SDPlace
	}
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.BackHillSummerParkGraph"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("top/Back"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("top/Home"), function()
		arg0:emit(var0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.summerland_tip.tip
		})
	end, SFX_PANEL)

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_ICECREAM)

	arg0:InitStudents(var0 and var0.id, 2, 4)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "bingqilin", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 41)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "qimazhan", function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.ISUZU_SPORTS_SKIN_ID
		})
	end)
	setActive(arg0.map_shujvhuigu, PLATFORM_CODE == PLATFORM_US)
	setActive(arg0.upper_shujvhuigu, PLATFORM_CODE == PLATFORM_US)

	if PLATFORM_CODE == PLATFORM_US then
		local function var1()
			arg0:emit(NewYearFestivalMediator.GO_SCENE, SCENE.SUMMARY)
		end

		arg0:InitFacilityCross(arg0._map, arg0._upper, "shujvhuigu", var1)
	end

	arg0:BindItemSkinShop()
	arg0:BindItemBuildShip()
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local function var0()
		return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_ICECREAM)
	end

	setActive(arg0.upper_bingqilin:Find("Tip"), var0())

	local function var1()
		local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.ISUZU_SPORTS_SKIN_ID)

		return Activity.IsActivityReady(var0)
	end

	setActive(arg0.upper_qimazhan:Find("Tip"), var1())

	local function var2()
		if PLATFORM_CODE ~= PLATFORM_US then
			return
		end

		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

		return Activity.IsActivityReady(var0)
	end

	setActive(arg0.upper_shujvhuigu:Find("Tip"), var2())
end

function var0.IsShowMainTip(arg0)
	local function var0()
		return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_ICECREAM)
	end

	local function var1()
		local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.ISUZU_SPORTS_SKIN_ID)

		return Activity.IsActivityReady(var0)
	end

	local function var2()
		if PLATFORM_CODE ~= PLATFORM_US then
			return
		end

		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

		return Activity.IsActivityReady(var0)
	end

	return var0() or var1() or var2()
end

function var0.willExit(arg0)
	arg0:clearStudents()
	var0.super.willExit(arg0)
end

return var0
