local var0_0 = class("SpringFestivalTownScene2", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "SpringFestivalTownUI2"
end

var0_0.edge2area = {
	default = "map_middle"
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

	arg0_2._shipTpl = arg0_2._map:Find("ship")
	arg0_2._upper = arg0_2:findTF("upper")

	for iter1_2 = 0, arg0_2._upper.childCount - 1 do
		local var2_2 = arg0_2._upper:GetChild(iter1_2)
		local var3_2 = go(var2_2).name

		arg0_2["upper_" .. var3_2] = var2_2
	end

	arg0_2.containers = {
		arg0_2.map_middle
	}
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.SpringFestivalTownGraph2"))

	local var4_2 = arg0_2._tf:GetComponentInParent(typeof(UnityEngine.Canvas))
	local var5_2 = var4_2 and var4_2.sortingOrder or 0

	arg0_2._bg:GetComponent(typeof(UnityEngine.Canvas)).sortingOrder = var5_2 - 2

	local var6_2 = GetComponent(arg0_2._bg, "ItemList")

	for iter2_2 = 1, 1 do
		local var7_2 = var6_2.prefabItem[iter2_2 - 1]

		if not IsNil(var7_2) then
			local var8_2 = tf(Instantiate(var7_2))

			setParent(var8_2, arg0_2._bg)
			pg.ViewUtils.SetSortingOrder(var8_2, var5_2 - 1)
		end
	end
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3:findTF("top/back"), function()
		arg0_3:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("top/home"), function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("top/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_chunjie2021_feast.tip
		})
	end, SFX_PANEL)

	local var0_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.SPRING_FES_MINIGAME_SECOND)

	arg0_3:InitStudents(var0_3 and var0_3.id, 2, 3)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "damaoxian", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 21)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "chunyouji", function()
		local var0_8 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

		arg0_3:emit(NewYearFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = var0_8 and var0_8.id
		})
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "huituriji", function()
		arg0_3:emit(NewYearFestivalMediator.GO_SCENE, SCENE.COLORING)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "dajiulou", function()
		arg0_3:emit(NewYearFestivalMediator.GO_SUBLAYER, Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer
		}))
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "fuzhuang", function()
		arg0_3:emit(NewYearFestivalMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "jianzao", function()
		arg0_3:emit(NewYearFestivalMediator.GO_SCENE, SCENE.GETBOAT, {
			page = 1,
			projectName = BuildShipScene.PROJECTS.LIGHT
		})
	end)
	arg0_3:UpdateView()
end

function var0_0.UpdateView(arg0_13)
	local var0_13
	local var1_13
	local var2_13 = getProxy(ActivityProxy)
	local var3_13 = getProxy(MiniGameProxy)
	local var4_13 = getProxy(ColoringProxy):CheckTodayTip()

	setActive(arg0_13.upper_huituriji:Find("Tip"), var4_13)

	local var5_13 = RedPacketLayer.isShowRedPoint()

	setActive(arg0_13.upper_dajiulou:Find("Tip"), var5_13)

	local var6_13 = var2_13:getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)
	local var7_13 = var6_13 and not var6_13:isEnd() and var6_13:readyToAchieve()

	setActive(arg0_13.upper_chunyouji:Find("Tip"), var7_13)

	local var8_13 = var2_13:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
	local var9_13 = var8_13 and not var8_13:isEnd() and var8_13:readyToAchieve()

	setActive(arg0_13.upper_damaoxian:Find("Tip"), var9_13)
end

function var0_0.willExit(arg0_14)
	arg0_14:clearStudents()
	var0_0.super.willExit(arg0_14)
end

return var0_0
