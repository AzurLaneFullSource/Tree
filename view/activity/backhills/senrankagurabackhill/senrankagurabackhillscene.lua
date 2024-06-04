local var0 = class("SenrankaguraBackHillScene", import("view.activity.BackHills.TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "SenrankaguraBackHillUI"
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
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.SenrankaguraBackHillGraph"))
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
			helps = pg.gametip.senrankagura_backhill_help.tip
		})
	end, SFX_PANEL)

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.SENRANKAGURA_BUFF)

	arg0:InitStudents(var0 and var0.id, 2, 3)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "renshuzhidaochang", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SENRANKAGURA_TRAIN)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "michuanrenfashu", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SENRANKAGURA_MEDAL)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "renzherenwuban", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.SENRANKAGURA_TURNTABLE
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "baochouleijisuo", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.SENRANKAGURA_PT
		})
	end)
	arg0:BindItemActivityShop()
	arg0:BindItemSkinShop()
	arg0:BindItemBuildShip()
	arg0:BindItemBattle()
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	setActive(arg0.upper_renshuzhidaochang:Find("Tip"), var0.TrainTip())
	setActive(arg0.upper_michuanrenfashu:Find("Tip"), var0.MedalTip())
	setActive(arg0.upper_renzherenwuban:Find("Tip"), var0.TaskTip())
	setActive(arg0.upper_baochouleijisuo:Find("Tip"), var0.PTTip())
end

function var0.willExit(arg0)
	arg0:clearStudents()
	var0.super.willExit(arg0)
end

function var0.MedalTip()
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.SENRANKAGURA_MEDAL_ID)

	return Activity.IsActivityReady(var0) or SenrankaguraMedalScene.GetTaskCountAble()
end

function var0.TaskTip()
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.SENRANKAGURA_TURNTABLE)

	return Activity.IsActivityReady(var0)
end

function var0.PTTip()
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.SENRANKAGURA_PT)

	return Activity.IsActivityReady(var0)
end

function var0.TrainTip()
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.SENRANKAGURA_TRAIN_ACT_ID)

	return Activity.IsActivityReady(var0)
end

function var0.IsShowMainTip(arg0)
	if arg0 and not arg0:isEnd() then
		return var0.PTTip() or var0.MedalTip() or var0.TaskTip() or var0.TrainTip()
	end
end

return var0
