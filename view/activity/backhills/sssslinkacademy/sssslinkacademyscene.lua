local var0 = class("SSSSLinkAcademyScene", import("..TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "SSSSLinkAcademyUI"
end

var0.edge2area = {
	default = "map_middle",
	["2_3"] = "map_front",
	["4_5"] = "map_front",
	["2_2"] = "map_front",
	["3_4"] = "map_front"
}

function var0.init(arg0)
	arg0.top = arg0:findTF("top")
	arg0._map = arg0:findTF("map")

	for iter0 = 0, arg0._map.childCount - 1 do
		local var0 = arg0._map:GetChild(iter0)
		local var1 = go(var0).name

		arg0["map_" .. var1] = var0
	end

	arg0._shipTpl = arg0._map:Find("ship")
	arg0._upper = arg0:findTF("upper")

	for iter1 = 0, arg0._upper.childCount - 1 do
		local var2 = arg0._upper:GetChild(iter1)
		local var3 = go(var2).name

		arg0["upper_" .. var3] = var2
	end

	arg0.containers = {
		arg0.map_front,
		arg0.map_middle
	}
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.SSSSLinkAcademyGraph"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("top/return_btn"), function()
		arg0:emit(var0.ON_BACK)
	end)
	onButton(arg0, arg0:findTF("top/return_main_btn"), function()
		arg0:emit(var0.ON_HOME)
	end)
	onButton(arg0, arg0:findTF("top/help_btn"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ssss_main_help.tip
		})
	end)
	arg0:BindItemActivityShop()
	arg0:BindItemSkinShop()
	arg0:BindItemBuildShip()
	arg0:BindItemBattle()

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)

	arg0:InitStudents(var0 and var0.id, 3, 4)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "xiaoyouxi", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 55)
	end)

	local var1 = getProxy(ActivityProxy):getActivityById(ActivityConst.SSSS_PT)

	arg0:InitFacilityCross(arg0._map, arg0._upper, "huodongye", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
			id = var1 and var1.id
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "jinianzhang", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SSSS_MEDAL_COLLECTION)
	end)
	onButton(arg0, arg0.upper_huoyuehuodong, function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.MONOPOLY_WORLD)
	end)
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local var0 = getProxy(ActivityProxy)
	local var1
	local var2 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
	local var3 = var0.IsMiniActNeedTip(var2 and var2.id)
	local var4 = arg0.upper_xiaoyouxi:Find("tip")

	setActive(var4, var3)

	local var5 = var0:getActivityById(ActivityConst.SSSS_PT)
	local var6 = arg0.upper_huodongye:Find("tip")
	local var7 = var5 and var5:readyToAchieve()

	setActive(var6, var7)

	local var8 = arg0.upper_jinianzhang:Find("tip")
	local var9 = var0.MedalTip()

	setActive(var8, var9)

	local var10 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)
	local var11 = arg0.upper_huoyuehuodong:Find("tip")
	local var12 = var10 and var10:readyToAchieve()

	setActive(var11, var12)
end

function var0.willExit(arg0)
	arg0:clearStudents()
end

function var0.MedalTip()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	return Activity.IsActivityReady(var0)
end

function var0.IsShowMainTip(arg0)
	local var0 = getProxy(ActivityProxy)

	local function var1()
		local var0 = var0:getActivityById(ActivityConst.SSSS_PT)

		return Activity.IsActivityReady(var0)
	end

	local var2 = var0.MedalTip()

	local function var3()
		local var0 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)

		return Activity.IsActivityReady(var0)
	end

	local function var4()
		local var0 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

		return Activity.IsActivityReady(var0)
	end

	return var1() or var2() or var3() or var4()
end

return var0
