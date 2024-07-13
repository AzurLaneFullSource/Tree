local var0_0 = class("SixthAnniversaryJPScene", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "SixthAnniversaryJPUI"
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
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.SixthAnniversaryJPGraph"))

	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_CHT then
		setActive(arg0_2.map_shujuhuigu, true)
		setActive(arg0_2.upper_shujuhuigu, true)
	else
		setActive(arg0_2.map_shujuhuigu, false)
		setActive(arg0_2.upper_shujuhuigu, false)
	end
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
			helps = pg.gametip.jp6th_biaohoushan_help.tip
		})
	end, SFX_PANEL)

	local var0_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_ZUMA)

	arg0_3:InitStudents(var0_3 and var0_3.id, 2, 3)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "jiujiuwenquan", function()
		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SIXTH_ANNIVERSARY_JP_HOTSPRING)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "shujuhuigu", function()
		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SUMMARY)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "shijiandiaocha", function()
		pg.SceneAnimMgr.GetInstance():SixthAnniversaryJPCoverGoScene(SCENE.SIXTH_ANNIVERSARY_JP_DARK)
	end)
	arg0_3:BindItemSkinShop()
	arg0_3:BindItemBuildShip()
	arg0_3:UpdateView()

	local var1_3 = pg.activity_template[ActivityConst.MINIGAME_ZUMA].config_client.biaohoushanstory

	pg.NewStoryMgr.GetInstance():Play(var1_3)
end

function var0_0.HotSpringTip()
	local var0_10 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)

	return Activity.IsActivityReady(var0_10)
end

function var0_0.ZumaTip()
	return LaunchBallActivityMgr.IsTip(ActivityConst.MINIGAME_ZUMA) or LaunchBallTaskMgr.GetRedTip()
end

function var0_0.UpdateView(arg0_12)
	setActive(arg0_12.upper_jiujiuwenquan:Find("Tip"), var0_0.HotSpringTip())
	setActive(arg0_12.upper_shijiandiaocha:Find("Tip"), var0_0.ZumaTip())
end

function var0_0.willExit(arg0_13)
	arg0_13:clearStudents()
	var0_0.super.willExit(arg0_13)
end

function var0_0.IsShowMainTip(arg0_14)
	if arg0_14 and not arg0_14:isEnd() then
		return var0_0.HotSpringTip() or var0_0.ZumaTip()
	end
end

function var0_0.onBackPressed(arg0_15)
	arg0_15:emit(var0_0.ON_HOME)
end

return var0_0
