local var0_0 = class("SpringFestivalBackHill2022Scene", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "SpringFestivalBackHill2022UI"
end

var0_0.edge2area = {
	default = "_sdPlace"
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
	arg0_2._sdPlace = arg0_2:findTF("SDPlace")
	arg0_2._upper = arg0_2:findTF("upper")

	for iter1_2 = 0, arg0_2._upper.childCount - 1 do
		local var2_2 = arg0_2._upper:GetChild(iter1_2)
		local var3_2 = go(var2_2).name

		arg0_2["upper_" .. var3_2] = var2_2
	end

	arg0_2.containers = {
		arg0_2._sdPlace
	}
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.SpringFestival2022Graph"))
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
			helps = pg.gametip.springfes_tips1.tip
		})
	end, SFX_PANEL)

	local var0_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_SPRINGFESTIVAL_2022)

	arg0_3:InitStudents(var0_3 and var0_3.id, 3, 3)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "fushundamaoxian", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 37)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "longtenghuyue", function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.ANSHAN_CHANGCHUN_GAIZAO_ID
		})
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "huazhongshijie", function()
		local var0_9 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

		if not var0_9 or var0_9:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		local var1_9 = var0_9:getConfig("config_client").linkActID

		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = var1_9
		})
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "huituriji", function()
		arg0_3:emit(NewYearFestivalMediator.GO_SCENE, SCENE.COLORING)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "jiulou", function()
		arg0_3:emit(NewYearFestivalMediator.GO_SUBLAYER, Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer
		}))
	end)
	arg0_3:BindItemSkinShop()
	arg0_3:BindItemBuildShip()
	arg0_3:UpdateView()
end

function var0_0.UpdateView(arg0_12)
	local var0_12
	local var1_12
	local var2_12 = getProxy(ActivityProxy)
	local var3_12 = getProxy(ColoringProxy):CheckTodayTip()

	setActive(arg0_12.upper_huituriji:Find("Tip"), var3_12)

	local var4_12 = BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_SPRINGFESTIVAL_2022)

	setActive(arg0_12.upper_fushundamaoxian:Find("Tip"), var4_12)

	local var5_12 = RedPacketLayer.isShowRedPoint()

	setActive(arg0_12.upper_jiulou:Find("Tip"), var5_12)

	local var6_12 = var2_12:getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)
	local var7_12 = Activity.IsActivityReady(var6_12)

	setActive(arg0_12.upper_huazhongshijie:Find("Tip"), var7_12)

	local var8_12 = var2_12:getActivityById(ActivityConst.ANSHAN_CHANGCHUN_GAIZAO_ID)
	local var9_12 = Activity.IsActivityReady(var8_12)

	setActive(arg0_12.upper_longtenghuyue:Find("Tip"), var9_12)
end

function var0_0.willExit(arg0_13)
	arg0_13:clearStudents()
	var0_0.super.willExit(arg0_13)
end

return var0_0
