local var0 = class("SixthAnniversaryJPScene", import("..TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "SixthAnniversaryJPUI"
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
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.SixthAnniversaryJPGraph"))

	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_CHT then
		setActive(arg0.map_shujuhuigu, true)
		setActive(arg0.upper_shujuhuigu, true)
	else
		setActive(arg0.map_shujuhuigu, false)
		setActive(arg0.upper_shujuhuigu, false)
	end
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
			helps = pg.gametip.jp6th_biaohoushan_help.tip
		})
	end, SFX_PANEL)

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_ZUMA)

	arg0:InitStudents(var0 and var0.id, 2, 3)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "jiujiuwenquan", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SIXTH_ANNIVERSARY_JP_HOTSPRING)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "shujuhuigu", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SUMMARY)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "shijiandiaocha", function()
		pg.SceneAnimMgr.GetInstance():SixthAnniversaryJPCoverGoScene(SCENE.SIXTH_ANNIVERSARY_JP_DARK)
	end)
	arg0:BindItemSkinShop()
	arg0:BindItemBuildShip()
	arg0:UpdateView()

	local var1 = pg.activity_template[ActivityConst.MINIGAME_ZUMA].config_client.biaohoushanstory

	pg.NewStoryMgr.GetInstance():Play(var1)
end

function var0.HotSpringTip()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)

	return Activity.IsActivityReady(var0)
end

function var0.ZumaTip()
	return LaunchBallActivityMgr.IsTip(ActivityConst.MINIGAME_ZUMA) or LaunchBallTaskMgr.GetRedTip()
end

function var0.UpdateView(arg0)
	setActive(arg0.upper_jiujiuwenquan:Find("Tip"), var0.HotSpringTip())
	setActive(arg0.upper_shijiandiaocha:Find("Tip"), var0.ZumaTip())
end

function var0.willExit(arg0)
	arg0:clearStudents()
	var0.super.willExit(arg0)
end

function var0.IsShowMainTip(arg0)
	if arg0 and not arg0:isEnd() then
		return var0.HotSpringTip() or var0.ZumaTip()
	end
end

function var0.onBackPressed(arg0)
	arg0:emit(var0.ON_HOME)
end

return var0
