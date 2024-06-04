local var0 = class("NewYearFestivalScene2", import("..TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "NewyearFestivalUI2"
end

var0.edge2area = {
	default = "map_middle",
	["3_4"] = "map_bottom",
	["5_6"] = "map_bottom"
}

function var0.init(arg0)
	var0.super.init(arg0)

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
		arg0.map_middle
	}
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.NewyearFestivalGraph2"))

	local var4 = arg0._tf:GetComponentInParent(typeof(UnityEngine.Canvas))
	local var5 = var4 and var4.sortingOrder or 0

	arg0._map:GetComponent(typeof(UnityEngine.Canvas)).sortingOrder = var5 - 2

	local var6 = GetComponent(arg0._map, "ItemList")

	for iter2 = 1, 1 do
		local var7 = var6.prefabItem[iter2 - 1]

		if not IsNil(var7) then
			local var8 = tf(Instantiate(var7))

			setParent(var8, arg0._map)
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
			helps = pg.gametip.help_xinnian2021_feast.tip
		})
	end, SFX_PANEL)

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.NEWYEAR_SNACKSTREET_MINIGAME)

	arg0:InitStudents(var0 and var0.id, 3, 4)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "daxuezhang", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 18)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "xiaochijie", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 19)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "qiaozhong", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 20)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "fuzhuangdian", function()
		arg0:emit(NewYearFestivalMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "mofang", function()
		arg0:emit(NewYearFestivalMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	setActive(arg0.upper_daxuezhang:Find("Tip"), var0.IsMiniActNeedTip(ActivityConst.NEWYEAR_SNOWBALL_FIGHT))
	setActive(arg0.upper_xiaochijie:Find("Tip"), NewYearSnackPage.IsTip())
	setActive(arg0.upper_qiaozhong:Find("Tip"), NewYearShrineView.IsNeedShowTipWithoutActivityFinalReward())
end

function var0.willExit(arg0)
	arg0:clearStudents()
	var0.super.willExit(arg0)
end

return var0
