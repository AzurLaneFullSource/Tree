local var0_0 = class("NewEducateRoundTipPanel", import("view.base.BaseSubView"))

var0_0.SHOW_TIME = 5

function var0_0.getUIName(arg0_1)
	return "NewEducateRoundTipPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.rootTF = arg0_2._tf:Find("root")
	arg0_2.assessWindow = arg0_2.rootTF:Find("assess")

	setActive(arg0_2.assessWindow, false)

	arg0_2.assessTF = arg0_2.assessWindow:Find("content/assess/Text")
	arg0_2.targetTF = arg0_2.assessWindow:Find("content/target/Text")
	arg0_2.roundWindow = arg0_2.rootTF:Find("round")

	setActive(arg0_2.roundWindow, false)

	arg0_2.roundTF = arg0_2.roundWindow:Find("calendar/week/Text")
	arg0_2.roundAnim = arg0_2.roundWindow:GetComponent(typeof(Animation))
	arg0_2.roundAnimEvent = arg0_2.roundWindow:GetComponent(typeof(DftAniEvent))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.assessWindow, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_5, arg1_5)
	var0_0.super.Show(arg0_5)

	arg0_5.callback = arg1_5

	pg.UIMgr.GetInstance():OverlayPanel(arg0_5._tf, {
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = LayerWeightConst.BASE_LAYER + 1
	})

	local var0_5 = arg0_5.contextData.char:GetRoundData()
	local var1_5, var2_5, var3_5 = var0_5:GetProgressInfo()

	setText(arg0_5.assessTF, i18n("child2_assess_tip", var2_5))
	setText(arg0_5.targetTF, i18n("child2_assess_tip_target", var3_5))
	setText(arg0_5.roundTF, i18n("child2_cur_round", var1_5 - 1))
	seriesAsync({
		function(arg0_6)
			arg0_5.roundAnimEvent:SetEndEvent(function()
				arg0_5.roundAnimEvent:SetEndEvent(nil)
				setActive(arg0_5.roundWindow, false)
				arg0_6()
			end)
			arg0_5.roundAnimEvent:SetTriggerEvent(function()
				arg0_5.roundAnimEvent:SetTriggerEvent(nil)
				setText(arg0_5.roundTF, i18n("child2_cur_round", var1_5))
			end)
			setActive(arg0_5.roundWindow, true)
		end,
		function(arg0_9)
			if var0_5:IsShowAssessTip() then
				setActive(arg0_5.assessWindow, true)
				onDelayTick(function()
					if not arg0_5._tf or not arg0_5:isShowing() then
						return
					end

					setActive(arg0_5.assessWindow, false)
					arg0_9()
				end, var0_0.SHOW_TIME)
			else
				arg0_9()
			end
		end
	}, function()
		arg0_5:Hide()
	end)
end

function var0_0.Hide(arg0_12)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_12._tf)
	existCall(arg0_12.callback)

	arg0_12.callback = nil

	var0_0.super.Hide(arg0_12)
end

function var0_0.OnDestroy(arg0_13)
	return
end

return var0_0
