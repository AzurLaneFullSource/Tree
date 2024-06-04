local var0 = class("OtherworldBackHillScene", import("..TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "OtherworldBackHillUI"
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
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.OtherworldBackHillSceneGraph"))
	arg0.ptIconTF = arg0:findTF("top/Res/icon")
	arg0.ptValueTF = arg0:findTF("top/Res/Text")
end

function var0.didEnter(arg0)
	arg0:SetNativeSizes()
	onButton(arg0, arg0:findTF("top/Back"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("top/Home"), function()
		arg0:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.otherworld_backhill_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("top/Terminal"), function()
		arg0:emit(OtherworldBackHilllMediator.GO_SUBLAYER, Context.New({
			mediator = OtherworldTerminalMediator,
			viewComponent = OtherworldTerminalLayer
		}))
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("top/OtherWorld"), function()
		pg.SceneAnimMgr.GetInstance():OtherWorldCoverGoScene(SCENE.OTHERWORLD_MAP, {
			mode = OtherworldMapScene.MODE_BATTLE
		})
	end, SFX_CANCEL)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "maoxianzgonghui", function()
		local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.OTHER_WORLD_TASK_ID)

		if not var0 or var0:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0:emit(OtherworldBackHilllMediator.GO_SUBLAYER, Context.New({
			mediator = OtherWorldTaskMediator,
			viewComponent = OtherWorldTaskLayer
		}))
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "jiujiushendian", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.OTHER_WORLD_TEMPLE_SCENE)
	end)
	arg0:BindItemSkinShop()
	arg0:UpdateView()

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.OTHER_WORLD_TERMINAL_LOTTERY_ID)

	if not var0 then
		return
	end

	local var1 = var0:getConfig("config_data")[1]

	arg0.resId = pg.activity_random_award_template[var1].resource_type

	GetImageSpriteFromAtlasAsync(Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = arg0.resId
	}):getIcon(), "", arg0.ptIconTF)
	arg0:UpdateRes()
end

function var0.SetNativeSizes(arg0)
	eachChild(arg0._upper, function(arg0)
		local var0 = arg0:Find("Image")
		local var1 = var0 and var0:GetComponent(typeof(Image))

		if var1 then
			var1:SetNativeSize()
		end
	end)
end

function var0.GongHuiTip()
	return getProxy(ActivityTaskProxy):getActTaskTip(ActivityConst.OTHER_WORLD_TASK_ID)
end

function var0.ShenDianTip()
	return ActivityItemPool.GetTempleRedTip(ActivityConst.OTHER_WORLD_TERMINAL_LOTTERY_ID)
end

function var0.TerminalTip()
	return TerminalAdventurePage.IsTip()
end

function var0.UpdateRes(arg0)
	setText(arg0.ptValueTF, getProxy(PlayerProxy):getData():getResource(arg0.resId))
end

function var0.UpdateView(arg0)
	setActive(arg0.upper_maoxianzgonghui:Find("Tip"), var0.GongHuiTip())
	setActive(arg0.upper_jiujiushendian:Find("Tip"), var0.ShenDianTip())
	setActive(arg0:findTF("top/Terminal/Tip"), var0.TerminalTip())
end

function var0.UpdateActivity(arg0)
	arg0:UpdateView()
end

function var0.willExit(arg0)
	arg0:clearStudents()
	var0.super.willExit(arg0)
end

function var0.IsShowMainTip(arg0)
	if arg0 and not arg0:isEnd() then
		return var0.GongHuiTip() or var0.ShenDianTip()
	end
end

function var0.IsShowTip()
	return var0.GongHuiTip() or var0.ShenDianTip()
end

return var0
