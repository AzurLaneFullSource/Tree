local var0_0 = class("MetaPTGetPreviewLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "MetaPTGetPreviewUI"
end

function var0_0.init(arg0_2)
	arg0_2:initUITextTips()
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf)
end

function var0_0.initUITextTips(arg0_5)
	local var0_5 = arg0_5:findTF("Panel/BG/TitleText")

	setText(var0_5, i18n("meta_pt_get_way"))
end

function var0_0.initData(arg0_6)
	return
end

function var0_0.findUI(arg0_7)
	arg0_7.bg = arg0_7:findTF("BG")
	arg0_7.panelTF = arg0_7:findTF("Panel")
	arg0_7.bossBtn = arg0_7:findTF("BossTip", arg0_7.panelTF)
	arg0_7.taskBtn = arg0_7:findTF("TaskTip", arg0_7.panelTF)
	arg0_7.resetBtn = arg0_7:findTF("ResetTip", arg0_7.panelTF)
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.bg, function()
		arg0_8:closeView()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.panelTF, function()
		arg0_8:closeView()
	end, SFX_PANEL)

	local function var0_8()
		local var0_11 = getProxy(ContextProxy):getContextByMediator(MetaCharacterMediator)
		local var1_11 = pg.m02:retrieveMediator("MetaCharacterMediator")

		var0_11.data.lastPageIndex = var1_11.viewComponent.curPageIndex

		arg0_8:closeView()
		arg0_8:sendNotification(GAME.GO_SCENE, SCENE.WORLDBOSS)

		local var2_11 = getProxy(ContextProxy):getContextByMediator(MetaCharacterSynMediator)

		if var2_11 then
			var0_11:removeChild(var2_11)
		end
	end

	onButton(arg0_8, arg0_8.bossBtn, var0_8, SFX_PANEL)
	onButton(arg0_8, arg0_8.taskBtn, var0_8, SFX_PANEL)
	onButton(arg0_8, arg0_8.resetBtn, var0_8, SFX_PANEL)
end

return var0_0
