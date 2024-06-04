local var0 = class("HarborBackHillScene", import("..TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "HarborBackHillUI"
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
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.HarborBackHillGraph"))
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
			helps = pg.gametip.harbor_backhill_help.tip
		})
	end, SFX_PANEL)

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_PIRATE_ID)

	arg0:InitStudents(var0 and var0.id, 2, 3)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "xuanshangban", function()
		if var0.XuanShangBanFirstTip() then
			local var0 = getProxy(PlayerProxy):getData().id

			PlayerPrefs.SetInt("FIRST_INTO_ACT_" .. ActivityConst.PIRATE_MEDAL_ACT_ID .. "_" .. var0, 1)
		end

		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.TEMPESTA_MEDAL_COLLECTION)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "mimichuanchang", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SECRET_SHIPYARD)
	end)
	arg0:BindItemActivityShop()
	arg0:BindItemSkinShop()
	arg0:BindItemBuildShip()
	arg0:UpdateView()
end

function var0.XuanShangBanFirstTip()
	local var0 = getProxy(PlayerProxy):getData().id

	return PlayerPrefs.GetInt("FIRST_INTO_ACT_" .. ActivityConst.PIRATE_MEDAL_ACT_ID .. "_" .. var0) == 0
end

function var0.XuanShangBanTip()
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.PIRATE_MEDAL_ACT_ID)

	return var0.XuanShangBanFirstTip() or Activity.IsActivityReady(var0)
end

function var0.IsFinishAllActTask()
	local var0 = getProxy(TaskProxy)
	local var1 = pg.activity_template[ActivityConst.BOAT_QIAN_SHAO_ZHAN].config_data
	local var2 = var1[#var1]

	return underscore.all(var2, function(arg0)
		return var0:getFinishTaskById(arg0)
	end)
end

function var0.MiMiChuanChangTip()
	if not var0.IsFinishAllActTask() then
		local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.BOAT_QIAN_SHAO_ZHAN)

		return Activity.IsActivityReady(var0)
	else
		return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MINIGAME_PIRATE_ID)
	end
end

function var0.UpdateView(arg0)
	setActive(arg0.upper_mimichuanchang:Find("Tip"), var0.MiMiChuanChangTip())
	setActive(arg0.upper_xuanshangban:Find("Tip"), var0.XuanShangBanTip())
end

function var0.willExit(arg0)
	arg0:clearStudents()
	var0.super.willExit(arg0)
end

function var0.IsShowMainTip(arg0)
	if arg0 and not arg0:isEnd() then
		return var0.XuanShangBanTip() or var0.MiMiChuanChangTip()
	end
end

return var0
