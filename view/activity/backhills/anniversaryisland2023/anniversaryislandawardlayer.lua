local var0_0 = class("AnniversaryIslandAwardLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AnniversaryIslandAwardUI"
end

function var0_0.init(arg0_2)
	arg0_2.window = arg0_2._tf:Find("Window")

	setText(arg0_2.window:Find("Text"), i18n("expedition_award_tip"))

	arg0_2.loader = AutoLoader.New()
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.window:Find("Receive"), function()
		arg0_3:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("BG"), function()
		arg0_3:onBackPressed()
	end)

	arg0_3.awards = _.select(arg0_3.contextData.items or {}, function(arg0_6)
		return arg0_6.type ~= DROP_TYPE_ICON_FRAME and arg0_6.type ~= DROP_TYPE_CHAT_FRAME
	end)

	local var0_3 = UIItemList

	var0_3.StaticAlign(arg0_3.window:Find("Materials"), arg0_3.window:Find("Materials"):GetChild(0), #arg0_3.awards, function(arg0_7, arg1_7, arg2_7)
		if arg0_7 ~= var0_3.EventUpdate then
			return
		end

		local var0_7 = arg0_3.awards[arg1_7 + 1]

		AnniversaryIslandComposite2023Scene.UpdateActivityDrop(arg0_3, arg2_7:Find("Icon"), var0_7)
		onButton(arg0_3, arg2_7:Find("Icon"), function()
			arg0_3:emit(var0_0.ON_DROP, var0_7)
		end)
		setText(arg2_7:Find("Text"), var0_7.count)
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})
end

function var0_0.willExit(arg0_9)
	arg0_9.loader:Clear()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_9._tf)
end

return var0_0
