local var0 = class("SpringFestivalTownScene2", import("..TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "SpringFestivalTownUI2"
end

var0.edge2area = {
	default = "map_middle"
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

	arg0._shipTpl = arg0._map:Find("ship")
	arg0._upper = arg0:findTF("upper")

	for iter1 = 0, arg0._upper.childCount - 1 do
		local var2 = arg0._upper:GetChild(iter1)
		local var3 = go(var2).name

		arg0["upper_" .. var3] = var2
	end

	arg0.containers = {
		arg0.map_middle
	}
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.SpringFestivalTownGraph2"))

	local var4 = arg0._tf:GetComponentInParent(typeof(UnityEngine.Canvas))
	local var5 = var4 and var4.sortingOrder or 0

	arg0._bg:GetComponent(typeof(UnityEngine.Canvas)).sortingOrder = var5 - 2

	local var6 = GetComponent(arg0._bg, "ItemList")

	for iter2 = 1, 1 do
		local var7 = var6.prefabItem[iter2 - 1]

		if not IsNil(var7) then
			local var8 = tf(Instantiate(var7))

			setParent(var8, arg0._bg)
			pg.ViewUtils.SetSortingOrder(var8, var5 - 1)
		end
	end
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("top/back"), function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("top/home"), function()
		arg0:emit(var0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("top/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_chunjie2021_feast.tip
		})
	end, SFX_PANEL)

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.SPRING_FES_MINIGAME_SECOND)

	arg0:InitStudents(var0 and var0.id, 2, 3)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "damaoxian", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 21)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "chunyouji", function()
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

		arg0:emit(NewYearFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = var0 and var0.id
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "huituriji", function()
		arg0:emit(NewYearFestivalMediator.GO_SCENE, SCENE.COLORING)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "dajiulou", function()
		arg0:emit(NewYearFestivalMediator.GO_SUBLAYER, Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer
		}))
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "fuzhuang", function()
		arg0:emit(NewYearFestivalMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "jianzao", function()
		arg0:emit(NewYearFestivalMediator.GO_SCENE, SCENE.GETBOAT, {
			page = 1,
			projectName = BuildShipScene.PROJECTS.LIGHT
		})
	end)
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local var0
	local var1
	local var2 = getProxy(ActivityProxy)
	local var3 = getProxy(MiniGameProxy)
	local var4 = getProxy(ColoringProxy):CheckTodayTip()

	setActive(arg0.upper_huituriji:Find("Tip"), var4)

	local var5 = RedPacketLayer.isShowRedPoint()

	setActive(arg0.upper_dajiulou:Find("Tip"), var5)

	local var6 = var2:getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)
	local var7 = var6 and not var6:isEnd() and var6:readyToAchieve()

	setActive(arg0.upper_chunyouji:Find("Tip"), var7)

	local var8 = var2:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
	local var9 = var8 and not var8:isEnd() and var8:readyToAchieve()

	setActive(arg0.upper_damaoxian:Find("Tip"), var9)
end

function var0.willExit(arg0)
	arg0:clearStudents()
	var0.super.willExit(arg0)
end

return var0
