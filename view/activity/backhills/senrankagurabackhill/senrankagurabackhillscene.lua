local var0_0 = class("SenrankaguraBackHillScene", import("view.activity.BackHills.TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "SenrankaguraBackHillUI"
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
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.SenrankaguraBackHillGraph"))
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
			helps = pg.gametip.senrankagura_backhill_help.tip
		})
	end, SFX_PANEL)

	local var0_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.SENRANKAGURA_BUFF)

	arg0_3:InitStudents(var0_3 and var0_3.id, 2, 3)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "renshuzhidaochang", function()
		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SENRANKAGURA_TRAIN)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "michuanrenfashu", function()
		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SENRANKAGURA_MEDAL)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "renzherenwuban", function()
		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.SENRANKAGURA_TURNTABLE
		})
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "baochouleijisuo", function()
		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.SENRANKAGURA_PT
		})
	end)
	arg0_3:BindItemActivityShop()
	arg0_3:BindItemSkinShop()
	arg0_3:BindItemBuildShip()
	arg0_3:BindItemBattle()
	arg0_3:UpdateView()
end

function var0_0.UpdateView(arg0_11)
	setActive(arg0_11.upper_renshuzhidaochang:Find("Tip"), var0_0.TrainTip())
	setActive(arg0_11.upper_michuanrenfashu:Find("Tip"), var0_0.MedalTip())
	setActive(arg0_11.upper_renzherenwuban:Find("Tip"), var0_0.TaskTip())
	setActive(arg0_11.upper_baochouleijisuo:Find("Tip"), var0_0.PTTip())
end

function var0_0.willExit(arg0_12)
	arg0_12:clearStudents()
	var0_0.super.willExit(arg0_12)
end

function var0_0.MedalTip()
	local var0_13 = getProxy(ActivityProxy):getActivityById(ActivityConst.SENRANKAGURA_MEDAL_ID)

	return Activity.IsActivityReady(var0_13) or SenrankaguraMedalScene.GetTaskCountAble()
end

function var0_0.TaskTip()
	local var0_14 = getProxy(ActivityProxy):getActivityById(ActivityConst.SENRANKAGURA_TURNTABLE)

	return Activity.IsActivityReady(var0_14)
end

function var0_0.PTTip()
	local var0_15 = getProxy(ActivityProxy):getActivityById(ActivityConst.SENRANKAGURA_PT)

	return Activity.IsActivityReady(var0_15)
end

function var0_0.TrainTip()
	local var0_16 = getProxy(ActivityProxy):getActivityById(ActivityConst.SENRANKAGURA_TRAIN_ACT_ID)

	return Activity.IsActivityReady(var0_16)
end

function var0_0.IsShowMainTip(arg0_17)
	if arg0_17 and not arg0_17:isEnd() then
		return var0_0.PTTip() or var0_0.MedalTip() or var0_0.TaskTip() or var0_0.TrainTip()
	end
end

return var0_0
