local var0 = class("ContinuousOperationPanel", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "ContinuousOperationUI"
end

function var0.init(arg0)
	arg0.btnOn = arg0._tf:Find("Panel/On")
	arg0.btnOff = arg0._tf:Find("Panel/Off")
	arg0.slider = arg0._tf:Find("Panel/Slider")
	arg0._ratioFitter = GetComponent(arg0._tf, typeof(AspectRatioFitter))

	setText(arg0.btnOff:Find("common/Text"), i18n("multiple_sorties_stopped"))
end

function var0.UpdateAutoFightMark(arg0)
	local var0 = arg0.contextData.autoFlag

	setActive(arg0.btnOn, var0)
	setActive(arg0.btnOff, not var0)
end

function var0.didEnter(arg0)
	arg0.contextData.autoFlag = defaultValue(arg0.contextData.autoFlag, true)

	onButton(arg0, arg0.btnOn, function()
		arg0.contextData.autoFlag = false

		arg0:UpdateAutoFightMark()
		pg.TipsMgr.GetInstance():ShowTips(i18n("multiple_sorties_stop_tip"))
		arg0:emit(BattleMediator.HIDE_ALL_BUTTONS, true)
	end, SFX_PANEL)
	onButton(arg0, arg0.btnOff, function()
		arg0.contextData.autoFlag = true

		arg0:UpdateAutoFightMark()
		pg.TipsMgr.GetInstance():ShowTips(i18n("multiple_sorties_resume_tip"))
		arg0:emit(BattleMediator.HIDE_ALL_BUTTONS, false)
	end, SFX_PANEL)

	arg0._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance():GetBattleUIRatio()

	arg0:UpdateAutoFightMark()
	arg0:UpdateBattleTimes()
	pg.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_OVERLAY_FOREVER, arg0._tf, {
		weight = LayerWeightConst.THIRD_LAYER,
		groupName = LayerWeightConst.GROUP_COMBAT
	})
end

function var0.UpdateBattleTimes(arg0)
	local var0 = arg0.contextData.continuousBattleTimes
	local var1 = arg0.contextData.totalBattleTimes

	setText(arg0.btnOn:Find("Text"), var1 - var0 + 1 .. "/" .. var1)
	setActive(arg0.slider, false)
	setActive(arg0.btnOff:Find("small"), true)
	setActive(arg0.btnOff:Find("common"), false)
end

function var0.OnEnterBattleResult(arg0)
	setActive(arg0.btnOff:Find("small"), false)
	setActive(arg0.btnOff:Find("common"), true)
end

function var0.AnimatingSlider(arg0)
	setActive(arg0.slider, true)
	arg0:managedTween(LeanTween.value, function()
		arg0:emit(ContinuousOperationMediator.ON_REENTER)
	end, go(arg0.slider), 1, 0, 5):setOnUpdate(System.Action_float(function(arg0)
		setSlider(arg0.slider, 0, 1, arg0)
	end))
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

function var0.onBackPressed(arg0)
	arg0:emit(GAME.PAUSE_BATTLE)
end

return var0
