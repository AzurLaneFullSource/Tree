local var0_0 = class("SSSSLinkAcademyScene", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "SSSSLinkAcademyUI"
end

var0_0.edge2area = {
	default = "map_middle",
	["2_3"] = "map_front",
	["4_5"] = "map_front",
	["2_2"] = "map_front",
	["3_4"] = "map_front"
}

function var0_0.init(arg0_2)
	arg0_2.top = arg0_2:findTF("top")
	arg0_2._map = arg0_2:findTF("map")

	for iter0_2 = 0, arg0_2._map.childCount - 1 do
		local var0_2 = arg0_2._map:GetChild(iter0_2)
		local var1_2 = go(var0_2).name

		arg0_2["map_" .. var1_2] = var0_2
	end

	arg0_2._shipTpl = arg0_2._map:Find("ship")
	arg0_2._upper = arg0_2:findTF("upper")

	for iter1_2 = 0, arg0_2._upper.childCount - 1 do
		local var2_2 = arg0_2._upper:GetChild(iter1_2)
		local var3_2 = go(var2_2).name

		arg0_2["upper_" .. var3_2] = var2_2
	end

	arg0_2.containers = {
		arg0_2.map_front,
		arg0_2.map_middle
	}
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.SSSSLinkAcademyGraph"))
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3:findTF("top/return_btn"), function()
		arg0_3:emit(var0_0.ON_BACK)
	end)
	onButton(arg0_3, arg0_3:findTF("top/return_main_btn"), function()
		arg0_3:emit(var0_0.ON_HOME)
	end)
	onButton(arg0_3, arg0_3:findTF("top/help_btn"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ssss_main_help.tip
		})
	end)
	arg0_3:BindItemActivityShop()
	arg0_3:BindItemSkinShop()
	arg0_3:BindItemBuildShip()
	arg0_3:BindItemBattle()

	local var0_3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)

	arg0_3:InitStudents(var0_3 and var0_3.id, 3, 4)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "xiaoyouxi", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 55)
	end)

	local var1_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.SSSS_PT)

	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "huodongye", function()
		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
			id = var1_3 and var1_3.id
		})
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "jinianzhang", function()
		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SSSS_MEDAL_COLLECTION)
	end)
	onButton(arg0_3, arg0_3.upper_huoyuehuodong, function()
		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.MONOPOLY_WORLD)
	end)
	arg0_3:UpdateView()
end

function var0_0.UpdateView(arg0_11)
	local var0_11 = getProxy(ActivityProxy)
	local var1_11
	local var2_11 = var0_11:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
	local var3_11 = var0_0.IsMiniActNeedTip(var2_11 and var2_11.id)
	local var4_11 = arg0_11.upper_xiaoyouxi:Find("tip")

	setActive(var4_11, var3_11)

	local var5_11 = var0_11:getActivityById(ActivityConst.SSSS_PT)
	local var6_11 = arg0_11.upper_huodongye:Find("tip")
	local var7_11 = var5_11 and var5_11:readyToAchieve()

	setActive(var6_11, var7_11)

	local var8_11 = arg0_11.upper_jinianzhang:Find("tip")
	local var9_11 = var0_0.MedalTip()

	setActive(var8_11, var9_11)

	local var10_11 = var0_11:getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)
	local var11_11 = arg0_11.upper_huoyuehuodong:Find("tip")
	local var12_11 = var10_11 and var10_11:readyToAchieve()

	setActive(var11_11, var12_11)
end

function var0_0.willExit(arg0_12)
	arg0_12:clearStudents()
end

function var0_0.MedalTip()
	local var0_13 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	return Activity.IsActivityReady(var0_13)
end

function var0_0.IsShowMainTip(arg0_14)
	local var0_14 = getProxy(ActivityProxy)

	local function var1_14()
		local var0_15 = var0_14:getActivityById(ActivityConst.SSSS_PT)

		return Activity.IsActivityReady(var0_15)
	end

	local var2_14 = var0_0.MedalTip()

	local function var3_14()
		local var0_16 = var0_14:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)

		return Activity.IsActivityReady(var0_16)
	end

	local function var4_14()
		local var0_17 = var0_14:getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

		return Activity.IsActivityReady(var0_17)
	end

	return var1_14() or var2_14() or var3_14() or var4_14()
end

return var0_0
