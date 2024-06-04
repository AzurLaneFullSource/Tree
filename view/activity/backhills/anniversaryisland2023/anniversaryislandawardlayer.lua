local var0 = class("AnniversaryIslandAwardLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "AnniversaryIslandAwardUI"
end

function var0.init(arg0)
	arg0.window = arg0._tf:Find("Window")

	setText(arg0.window:Find("Text"), i18n("expedition_award_tip"))

	arg0.loader = AutoLoader.New()
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.window:Find("Receive"), function()
		arg0:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("BG"), function()
		arg0:onBackPressed()
	end)

	arg0.awards = _.select(arg0.contextData.items or {}, function(arg0)
		return arg0.type ~= DROP_TYPE_ICON_FRAME and arg0.type ~= DROP_TYPE_CHAT_FRAME
	end)

	local var0 = UIItemList

	var0.StaticAlign(arg0.window:Find("Materials"), arg0.window:Find("Materials"):GetChild(0), #arg0.awards, function(arg0, arg1, arg2)
		if arg0 ~= var0.EventUpdate then
			return
		end

		local var0 = arg0.awards[arg1 + 1]

		AnniversaryIslandComposite2023Scene.UpdateActivityDrop(arg0, arg2:Find("Icon"), var0)
		onButton(arg0, arg2:Find("Icon"), function()
			arg0:emit(var0.ON_DROP, var0)
		end)
		setText(arg2:Find("Text"), var0.count)
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})
end

function var0.willExit(arg0)
	arg0.loader:Clear()
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
