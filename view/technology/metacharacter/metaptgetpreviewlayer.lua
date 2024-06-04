local var0 = class("MetaPTGetPreviewLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "MetaPTGetPreviewUI"
end

function var0.init(arg0)
	arg0:initUITextTips()
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.initUITextTips(arg0)
	local var0 = arg0:findTF("Panel/BG/TitleText")

	setText(var0, i18n("meta_pt_get_way"))
end

function var0.initData(arg0)
	return
end

function var0.findUI(arg0)
	arg0.bg = arg0:findTF("BG")
	arg0.panelTF = arg0:findTF("Panel")
	arg0.bossBtn = arg0:findTF("BossTip", arg0.panelTF)
	arg0.taskBtn = arg0:findTF("TaskTip", arg0.panelTF)
	arg0.resetBtn = arg0:findTF("ResetTip", arg0.panelTF)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.bg, function()
		arg0:closeView()
	end, SFX_PANEL)
	onButton(arg0, arg0.panelTF, function()
		arg0:closeView()
	end, SFX_PANEL)

	local function var0()
		local var0 = getProxy(ContextProxy):getContextByMediator(MetaCharacterMediator)
		local var1 = pg.m02:retrieveMediator("MetaCharacterMediator")

		var0.data.lastPageIndex = var1.viewComponent.curPageIndex

		arg0:closeView()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.WORLDBOSS)

		local var2 = getProxy(ContextProxy):getContextByMediator(MetaCharacterSynMediator)

		if var2 then
			var0:removeChild(var2)
		end
	end

	onButton(arg0, arg0.bossBtn, var0, SFX_PANEL)
	onButton(arg0, arg0.taskBtn, var0, SFX_PANEL)
	onButton(arg0, arg0.resetBtn, var0, SFX_PANEL)
end

return var0
