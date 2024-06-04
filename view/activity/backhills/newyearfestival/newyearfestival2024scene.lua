local var0 = class("NewYearFestival2024Scene", import("view.activity.BackHills.TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "NewYearFestival2024UI"
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
	arg0._shipTpl = arg0._map:Find("ship")
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.NewyearFestival2024Graph"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("top/Back"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("top/Home"), function()
		arg0:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.newyear2024_backhill_help.tip
		})
	end, SFX_PANEL)

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_COOKGAME2_ID)

	arg0:InitStudents(var0 and var0.id, 2, 3)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "nvpudian", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 60)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "huimaqiyuan", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 62)
	end)
	arg0:BindItemSkinShop()
	arg0:BindItemBuildShip()
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	setActive(arg0.upper_nvpudian:Find("Tip"), var0.MiniGameTip())
	setActive(arg0.upper_huimaqiyuan:Find("Tip"), var0.ShrineTip())
end

function var0.ShrineTip()
	return Shrine2024View.IsNeedShowTipWithoutActivityFinalReward()
end

function var0.MiniGameTip()
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_COOKGAME2_ID)

	return Activity.IsActivityReady(var0)
end

function var0.willExit(arg0)
	arg0:clearStudents()
	var0.super.willExit(arg0)
end

function var0.IsShowMainTip(arg0)
	if arg0 and not arg0:isEnd() then
		return var0.MiniGameTip() or var0.ShrineTip()
	end
end

return var0
