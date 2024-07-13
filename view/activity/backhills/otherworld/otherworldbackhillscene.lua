local var0_0 = class("OtherworldBackHillScene", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "OtherworldBackHillUI"
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
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.OtherworldBackHillSceneGraph"))
	arg0_2.ptIconTF = arg0_2:findTF("top/Res/icon")
	arg0_2.ptValueTF = arg0_2:findTF("top/Res/Text")
end

function var0_0.didEnter(arg0_3)
	arg0_3:SetNativeSizes()
	onButton(arg0_3, arg0_3:findTF("top/Back"), function()
		arg0_3:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("top/Home"), function()
		arg0_3:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.otherworld_backhill_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("top/Terminal"), function()
		arg0_3:emit(OtherworldBackHilllMediator.GO_SUBLAYER, Context.New({
			mediator = OtherworldTerminalMediator,
			viewComponent = OtherworldTerminalLayer
		}))
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("top/OtherWorld"), function()
		pg.SceneAnimMgr.GetInstance():OtherWorldCoverGoScene(SCENE.OTHERWORLD_MAP, {
			mode = OtherworldMapScene.MODE_BATTLE
		})
	end, SFX_CANCEL)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "maoxianzgonghui", function()
		local var0_9 = getProxy(ActivityProxy):getActivityById(ActivityConst.OTHER_WORLD_TASK_ID)

		if not var0_9 or var0_9:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_3:emit(OtherworldBackHilllMediator.GO_SUBLAYER, Context.New({
			mediator = OtherWorldTaskMediator,
			viewComponent = OtherWorldTaskLayer
		}))
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "jiujiushendian", function()
		arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.OTHER_WORLD_TEMPLE_SCENE)
	end)
	arg0_3:BindItemSkinShop()
	arg0_3:UpdateView()

	local var0_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.OTHER_WORLD_TERMINAL_LOTTERY_ID)

	if not var0_3 then
		return
	end

	local var1_3 = var0_3:getConfig("config_data")[1]

	arg0_3.resId = pg.activity_random_award_template[var1_3].resource_type

	GetImageSpriteFromAtlasAsync(Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = arg0_3.resId
	}):getIcon(), "", arg0_3.ptIconTF)
	arg0_3:UpdateRes()
end

function var0_0.SetNativeSizes(arg0_11)
	eachChild(arg0_11._upper, function(arg0_12)
		local var0_12 = arg0_12:Find("Image")
		local var1_12 = var0_12 and var0_12:GetComponent(typeof(Image))

		if var1_12 then
			var1_12:SetNativeSize()
		end
	end)
end

function var0_0.GongHuiTip()
	return getProxy(ActivityTaskProxy):getActTaskTip(ActivityConst.OTHER_WORLD_TASK_ID)
end

function var0_0.ShenDianTip()
	return ActivityItemPool.GetTempleRedTip(ActivityConst.OTHER_WORLD_TERMINAL_LOTTERY_ID)
end

function var0_0.TerminalTip()
	return TerminalAdventurePage.IsTip()
end

function var0_0.UpdateRes(arg0_16)
	setText(arg0_16.ptValueTF, getProxy(PlayerProxy):getData():getResource(arg0_16.resId))
end

function var0_0.UpdateView(arg0_17)
	setActive(arg0_17.upper_maoxianzgonghui:Find("Tip"), var0_0.GongHuiTip())
	setActive(arg0_17.upper_jiujiushendian:Find("Tip"), var0_0.ShenDianTip())
	setActive(arg0_17:findTF("top/Terminal/Tip"), var0_0.TerminalTip())
end

function var0_0.UpdateActivity(arg0_18)
	arg0_18:UpdateView()
end

function var0_0.willExit(arg0_19)
	arg0_19:clearStudents()
	var0_0.super.willExit(arg0_19)
end

function var0_0.IsShowMainTip(arg0_20)
	if arg0_20 and not arg0_20:isEnd() then
		return var0_0.GongHuiTip() or var0_0.ShenDianTip()
	end
end

function var0_0.IsShowTip()
	return var0_0.GongHuiTip() or var0_0.ShenDianTip()
end

return var0_0
