local var0 = class("SpringFestivalBackHill2022Scene", import("..TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "SpringFestivalBackHill2022UI"
end

var0.edge2area = {
	default = "_sdPlace"
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
	arg0._sdPlace = arg0:findTF("SDPlace")
	arg0._upper = arg0:findTF("upper")

	for iter1 = 0, arg0._upper.childCount - 1 do
		local var2 = arg0._upper:GetChild(iter1)
		local var3 = go(var2).name

		arg0["upper_" .. var3] = var2
	end

	arg0.containers = {
		arg0._sdPlace
	}
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.SpringFestival2022Graph"))
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
			helps = pg.gametip.springfes_tips1.tip
		})
	end, SFX_PANEL)

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_SPRINGFESTIVAL_2022)

	arg0:InitStudents(var0 and var0.id, 3, 3)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "fushundamaoxian", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 37)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "longtenghuyue", function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.ANSHAN_CHANGCHUN_GAIZAO_ID
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "huazhongshijie", function()
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

		if not var0 or var0:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		local var1 = var0:getConfig("config_client").linkActID

		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = var1
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "huituriji", function()
		arg0:emit(NewYearFestivalMediator.GO_SCENE, SCENE.COLORING)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "jiulou", function()
		arg0:emit(NewYearFestivalMediator.GO_SUBLAYER, Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer
		}))
	end)
	arg0:BindItemSkinShop()
	arg0:BindItemBuildShip()
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local var0
	local var1
	local var2 = getProxy(ActivityProxy)
	local var3 = getProxy(ColoringProxy):CheckTodayTip()

	setActive(arg0.upper_huituriji:Find("Tip"), var3)

	local var4 = BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_SPRINGFESTIVAL_2022)

	setActive(arg0.upper_fushundamaoxian:Find("Tip"), var4)

	local var5 = RedPacketLayer.isShowRedPoint()

	setActive(arg0.upper_jiulou:Find("Tip"), var5)

	local var6 = var2:getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)
	local var7 = Activity.IsActivityReady(var6)

	setActive(arg0.upper_huazhongshijie:Find("Tip"), var7)

	local var8 = var2:getActivityById(ActivityConst.ANSHAN_CHANGCHUN_GAIZAO_ID)
	local var9 = Activity.IsActivityReady(var8)

	setActive(arg0.upper_longtenghuyue:Find("Tip"), var9)
end

function var0.willExit(arg0)
	arg0:clearStudents()
	var0.super.willExit(arg0)
end

return var0
