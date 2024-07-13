local var0_0 = class("ContinuousOperationPanel", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ContinuousOperationUI"
end

function var0_0.init(arg0_2)
	arg0_2.btnOn = arg0_2._tf:Find("Panel/On")
	arg0_2.btnOff = arg0_2._tf:Find("Panel/Off")
	arg0_2.slider = arg0_2._tf:Find("Panel/Slider")
	arg0_2._ratioFitter = GetComponent(arg0_2._tf, typeof(AspectRatioFitter))

	setText(arg0_2.btnOff:Find("common/Text"), i18n("multiple_sorties_stopped"))
end

function var0_0.UpdateAutoFightMark(arg0_3)
	local var0_3 = arg0_3.contextData.autoFlag

	setActive(arg0_3.btnOn, var0_3)
	setActive(arg0_3.btnOff, not var0_3)
end

function var0_0.didEnter(arg0_4)
	arg0_4.contextData.autoFlag = defaultValue(arg0_4.contextData.autoFlag, true)

	onButton(arg0_4, arg0_4.btnOn, function()
		arg0_4.contextData.autoFlag = false

		arg0_4:UpdateAutoFightMark()
		pg.TipsMgr.GetInstance():ShowTips(i18n("multiple_sorties_stop_tip"))
		arg0_4:emit(BattleMediator.HIDE_ALL_BUTTONS, true)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.btnOff, function()
		arg0_4.contextData.autoFlag = true

		arg0_4:UpdateAutoFightMark()
		pg.TipsMgr.GetInstance():ShowTips(i18n("multiple_sorties_resume_tip"))
		arg0_4:emit(BattleMediator.HIDE_ALL_BUTTONS, false)
	end, SFX_PANEL)

	arg0_4._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance():GetBattleUIRatio()

	arg0_4:UpdateAutoFightMark()
	arg0_4:UpdateBattleTimes()
	pg.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_OVERLAY_FOREVER, arg0_4._tf, {
		weight = LayerWeightConst.THIRD_LAYER,
		groupName = LayerWeightConst.GROUP_COMBAT
	})
end

function var0_0.UpdateBattleTimes(arg0_7)
	local var0_7 = arg0_7.contextData.continuousBattleTimes
	local var1_7 = arg0_7.contextData.totalBattleTimes

	setText(arg0_7.btnOn:Find("Text"), var1_7 - var0_7 + 1 .. "/" .. var1_7)
	setActive(arg0_7.slider, false)
	setActive(arg0_7.btnOff:Find("small"), true)
	setActive(arg0_7.btnOff:Find("common"), false)
end

function var0_0.OnEnterBattleResult(arg0_8)
	setActive(arg0_8.btnOff:Find("small"), false)
	setActive(arg0_8.btnOff:Find("common"), true)
end

function var0_0.AnimatingSlider(arg0_9)
	setActive(arg0_9.slider, true)
	arg0_9:managedTween(LeanTween.value, function()
		arg0_9:emit(ContinuousOperationMediator.ON_REENTER)
	end, go(arg0_9.slider), 1, 0, 5):setOnUpdate(System.Action_float(function(arg0_11)
		setSlider(arg0_9.slider, 0, 1, arg0_11)
	end))
end

function var0_0.willExit(arg0_12)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_12._tf)
end

function var0_0.onBackPressed(arg0_13)
	arg0_13:emit(GAME.PAUSE_BATTLE)
end

return var0_0
