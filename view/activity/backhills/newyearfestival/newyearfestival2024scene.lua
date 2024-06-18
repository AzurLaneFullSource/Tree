local var0_0 = class("NewYearFestival2024Scene", import("view.activity.BackHills.TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "NewYearFestival2024UI"
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
	arg0_2._shipTpl = arg0_2._map:Find("ship")
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.NewyearFestival2024Graph"))
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3:findTF("top/Back"), function()
		arg0_3:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("top/Home"), function()
		arg0_3:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.newyear2024_backhill_help.tip
		})
	end, SFX_PANEL)

	local var0_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_COOKGAME2_ID)

	arg0_3:InitStudents(var0_3 and var0_3.id, 2, 3)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "nvpudian", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 60)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "huimaqiyuan", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 62)
	end)
	arg0_3:BindItemSkinShop()
	arg0_3:BindItemBuildShip()
	arg0_3:UpdateView()
end

function var0_0.UpdateView(arg0_9)
	setActive(arg0_9.upper_nvpudian:Find("Tip"), var0_0.MiniGameTip())
	setActive(arg0_9.upper_huimaqiyuan:Find("Tip"), var0_0.ShrineTip())
end

function var0_0.ShrineTip()
	return Shrine2024View.IsNeedShowTipWithoutActivityFinalReward()
end

function var0_0.MiniGameTip()
	local var0_11 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_COOKGAME2_ID)

	return Activity.IsActivityReady(var0_11)
end

function var0_0.willExit(arg0_12)
	arg0_12:clearStudents()
	var0_0.super.willExit(arg0_12)
end

function var0_0.IsShowMainTip(arg0_13)
	if arg0_13 and not arg0_13:isEnd() then
		return var0_0.MiniGameTip() or var0_0.ShrineTip()
	end
end

return var0_0
