local var0_0 = class("HarborBackHillScene", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "HarborBackHillUI"
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
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.HarborBackHillGraph"))
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
			helps = pg.gametip.harbor_backhill_help.tip
		})
	end, SFX_PANEL)

	local var0_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_PIRATE_ID)

	arg0_3:InitStudents(var0_3 and var0_3.id, 2, 3)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "xuanshangban", function()
		if var0_0.XuanShangBanFirstTip() then
			local var0_7 = getProxy(PlayerProxy):getData().id

			PlayerPrefs.SetInt("FIRST_INTO_ACT_" .. ActivityConst.PIRATE_MEDAL_ACT_ID .. "_" .. var0_7, 1)
		end

		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.TEMPESTA_MEDAL_COLLECTION)
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "mimichuanchang", function()
		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SECRET_SHIPYARD)
	end)
	arg0_3:BindItemActivityShop()
	arg0_3:BindItemSkinShop()
	arg0_3:BindItemBuildShip()
	arg0_3:UpdateView()
end

function var0_0.XuanShangBanFirstTip()
	local var0_9 = getProxy(PlayerProxy):getData().id

	return PlayerPrefs.GetInt("FIRST_INTO_ACT_" .. ActivityConst.PIRATE_MEDAL_ACT_ID .. "_" .. var0_9) == 0
end

function var0_0.XuanShangBanTip()
	local var0_10 = getProxy(ActivityProxy):getActivityById(ActivityConst.PIRATE_MEDAL_ACT_ID)

	return var0_0.XuanShangBanFirstTip() or Activity.IsActivityReady(var0_10)
end

function var0_0.IsFinishAllActTask()
	local var0_11 = getProxy(TaskProxy)
	local var1_11 = pg.activity_template[ActivityConst.BOAT_QIAN_SHAO_ZHAN].config_data
	local var2_11 = var1_11[#var1_11]

	return underscore.all(var2_11, function(arg0_12)
		return var0_11:getFinishTaskById(arg0_12)
	end)
end

function var0_0.MiMiChuanChangTip()
	if not var0_0.IsFinishAllActTask() then
		local var0_13 = getProxy(ActivityProxy):getActivityById(ActivityConst.BOAT_QIAN_SHAO_ZHAN)

		return Activity.IsActivityReady(var0_13)
	else
		return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_PIRATE_ID)
	end
end

function var0_0.UpdateView(arg0_14)
	setActive(arg0_14.upper_mimichuanchang:Find("Tip"), var0_0.MiMiChuanChangTip())
	setActive(arg0_14.upper_xuanshangban:Find("Tip"), var0_0.XuanShangBanTip())
end

function var0_0.willExit(arg0_15)
	arg0_15:clearStudents()
	var0_0.super.willExit(arg0_15)
end

function var0_0.IsShowMainTip(arg0_16)
	if arg0_16 and not arg0_16:isEnd() then
		return var0_0.XuanShangBanTip() or var0_0.MiMiChuanChangTip()
	end
end

return var0_0
