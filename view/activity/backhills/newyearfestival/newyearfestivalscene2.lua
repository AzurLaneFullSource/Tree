local var0_0 = class("NewYearFestivalScene2", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "NewyearFestivalUI2"
end

var0_0.edge2area = {
	default = "map_middle",
	["3_4"] = "map_bottom",
	["5_6"] = "map_bottom"
}

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)

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
		arg0_2.map_middle
	}
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.NewyearFestivalGraph2"))

	local var4_2 = arg0_2._tf:GetComponentInParent(typeof(UnityEngine.Canvas))
	local var5_2 = var4_2 and var4_2.sortingOrder or 0

	arg0_2._map:GetComponent(typeof(UnityEngine.Canvas)).sortingOrder = var5_2 - 2

	local var6_2 = GetComponent(arg0_2._map, "ItemList")

	for iter2_2 = 1, 1 do
		local var7_2 = var6_2.prefabItem[iter2_2 - 1]

		if not IsNil(var7_2) then
			local var8_2 = tf(Instantiate(var7_2))

			setParent(var8_2, arg0_2._map)
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
			helps = pg.gametip.help_xinnian2021_feast.tip
		})
	end, SFX_PANEL)

	local var0_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.NEWYEAR_SNACKSTREET_MINIGAME)

	arg0_3:InitStudents(var0_3 and var0_3.id, 3, 4)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "daxuezhang", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 18)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "xiaochijie", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 19)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "qiaozhong", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 20)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "fuzhuangdian", function()
		arg0_3:emit(NewYearFestivalMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "mofang", function()
		arg0_3:emit(NewYearFestivalMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	arg0_3:UpdateView()
end

function var0_0.UpdateView(arg0_12)
	setActive(arg0_12.upper_daxuezhang:Find("Tip"), var0_0.IsMiniActNeedTip(ActivityConst.NEWYEAR_SNOWBALL_FIGHT))
	setActive(arg0_12.upper_xiaochijie:Find("Tip"), NewYearSnackPage.IsTip())
	setActive(arg0_12.upper_qiaozhong:Find("Tip"), NewYearShrineView.IsNeedShowTipWithoutActivityFinalReward())
end

function var0_0.willExit(arg0_13)
	arg0_13:clearStudents()
	var0_0.super.willExit(arg0_13)
end

return var0_0
