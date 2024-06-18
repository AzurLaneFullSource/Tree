local var0_0 = class("MainCalibrationPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MainCalibrationUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.moveBtn = arg0_2:findTF("move")
	arg0_2.setBtn = arg0_2:findTF("set")
	arg0_2.backBtn = arg0_2:findTF("back")
	arg0_2.resetBtn = arg0_2:findTF("reset")
	arg0_2.saveBtn = arg0_2:findTF("save")
	arg0_2.bgImage = arg0_2._tf:Find("adapt/bg"):GetComponent(typeof(Image))
	arg0_2.paintingTF = arg0_2._parentTf:Find("paint")
	arg0_2._bgTf = arg0_2._parentTf:Find("paintBg")
	arg0_2.l2dContainer = arg0_2.paintingTF:Find("live2d")
	arg0_2.spineContainer = arg0_2.paintingTF:Find("spinePainting")
	arg0_2.setBtnX = arg0_2.setBtn.localPosition.x
	arg0_2.showing = false
end

function var0_0.OnInit(arg0_3)
	local var0_3 = false
	local var1_3 = false

	onToggle(arg0_3, arg0_3.moveBtn, function(arg0_4)
		var0_3 = arg0_4

		arg0_3:Move(arg0_4)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._parentTf, function()
		if var1_3 then
			return
		end

		if arg0_3.showing and not var0_3 then
			if var1_3 then
				triggerToggle(arg0_3.setBtn, false)
			end

			arg0_3:emit(NewMainScene.FOLD, false)
		end
	end)
	onButton(arg0_3, arg0_3.backBtn, function()
		if var0_3 then
			triggerToggle(arg0_3.moveBtn, false)
		end

		arg0_3:emit(NewMainScene.FOLD, false)
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.setBtn, function(arg0_7)
		var1_3 = arg0_7

		arg0_3:SetPostion(arg0_7)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.saveBtn, function()
		arg0_3:SavePostion()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.resetBtn, function()
		arg0_3:ResetPostion()
	end, SFX_PANEL)
end

function var0_0.Move(arg0_10, arg1_10)
	setToggleEnabled(arg0_10.setBtn, not arg1_10)
	arg0_10:emit(NewMainScene.ENABLE_PAITING_MOVE, arg1_10)
end

function var0_0.SetPostion(arg0_11, arg1_11)
	local function var0_11()
		setActive(arg0_11.moveBtn, not arg1_11)
		setActive(arg0_11.backBtn, not arg1_11)
	end

	arg0_11.bgImage.enabled = arg1_11

	local var1_11 = arg1_11 and arg0_11.moveBtn.localPosition.x or arg0_11.setBtnX

	LeanTween.moveLocalX(arg0_11.setBtn.gameObject, var1_11, 0.2)

	local var2_11 = arg1_11 and -150 or 0
	local var3_11 = arg1_11 and 0 or -150
	local var4_11 = LeanTween.value(arg0_11.backBtn.gameObject, var3_11, var2_11, 0.3):setOnUpdate(System.Action_float(function(arg0_13)
		arg0_11.resetBtn.anchoredPosition = Vector2(arg0_13, arg0_11.resetBtn.anchoredPosition.y)
		arg0_11.saveBtn.anchoredPosition = Vector2(arg0_13, arg0_11.saveBtn.anchoredPosition.y)
	end))

	if arg1_11 then
		var0_11()
	else
		var4_11:setOnComplete(System.Action(var0_11))
	end

	arg0_11:emit(NewMainScene.ENABLE_PAITING_MOVE, arg1_11)
end

function var0_0.SavePostion(arg0_14)
	local var0_14 = arg0_14.paintingTF.anchoredPosition
	local var1_14 = arg0_14.paintingTF.localScale.x
	local var2_14 = arg0_14.flagShip.skinId

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("secretary_pos_save"),
		onYes = function()
			getProxy(SettingsProxy):setSkinPosSetting(arg0_14.flagShip, var0_14.x, var0_14.y, var1_14)
			pg.TipsMgr.GetInstance():ShowTips(i18n("secretary_pos_save_success"))
			triggerToggle(arg0_14.setBtn, false)
			arg0_14:emit(NewMainScene.FOLD, false)
		end
	})
end

function var0_0.ResetPostion(arg0_16)
	getProxy(SettingsProxy):resetSkinPosSetting(arg0_16.flagShip)

	local var0_16 = MainPaintingView.GetAssistantStatus(arg0_16.flagShip)
	local var1_16, var2_16 = arg0_16.shift:GetMeshImageShift()

	arg0_16.paintingTF.anchoredPosition = var1_16
	arg0_16._bgTf.anchoredPosition = var1_16

	local var3_16, var4_16 = arg0_16.shift:GetL2dShift()

	arg0_16.l2dContainer.anchoredPosition = var3_16

	local var5_16, var6_16 = arg0_16.shift:GetSpineShift()

	arg0_16.spineContainer.anchoredPosition = var5_16

	if var0_16 == MainPaintingView.STATE_L2D then
		arg0_16._bgTf.localScale = var4_16
		arg0_16.paintingTF.localScale = var4_16
	elseif var0_16 == MainPaintingView.STATE_SPINE_PAINTING then
		arg0_16._bgTf.localScale = var6_16
		arg0_16.paintingTF.localScale = var6_16
	else
		arg0_16._bgTf.localScale = var2_16
		arg0_16.paintingTF.localScale = var2_16
	end
end

function var0_0.ShowOrHide(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
	if arg1_17 then
		arg0_17:Show(arg3_17)
		arg0_17:UpdateBg(arg4_17)
	else
		arg0_17:Hide()
	end

	arg0_17.flagShip = arg2_17
	arg0_17.showing = arg1_17
end

function var0_0.UpdateBg(arg0_18, arg1_18)
	if arg1_18 == arg0_18.bgName then
		return
	end

	LoadSpriteAsync("clutter/" .. arg1_18, function(arg0_19)
		if arg0_18.exited then
			return
		end

		arg0_18.bgImage.sprite = arg0_19
	end)

	arg0_18.bgName = arg1_18
end

function var0_0.Show(arg0_20, arg1_20)
	var0_0.super.Show(arg0_20)

	arg0_20.shift = arg1_20

	arg0_20:DoBottomAnimation(0, 100)
	arg0_20:DoLeftAnimation(0, -150, function()
		return
	end)
end

function var0_0.DoLeftAnimation(arg0_22, arg1_22, arg2_22, arg3_22)
	LeanTween.value(arg0_22.backBtn.gameObject, arg1_22, arg2_22, 0.3):setOnUpdate(System.Action_float(function(arg0_23)
		arg0_22.backBtn.anchoredPosition = Vector2(arg0_23, arg0_22.backBtn.anchoredPosition.y)
	end)):setOnComplete(System.Action(arg3_22))
end

function var0_0.DoBottomAnimation(arg0_24, arg1_24, arg2_24)
	LeanTween.value(arg0_24.moveBtn.gameObject, arg1_24, arg2_24, 0.3):setOnUpdate(System.Action_float(function(arg0_25)
		arg0_24.moveBtn.anchoredPosition = Vector2(arg0_24.moveBtn.anchoredPosition.x, arg0_25)
		arg0_24.setBtn.anchoredPosition = Vector2(arg0_24.setBtn.anchoredPosition.x, arg0_25)
	end))
end

function var0_0.Hide(arg0_26)
	arg0_26:DoBottomAnimation(100, 0)
	arg0_26:DoLeftAnimation(-150, 0, function()
		var0_0.super.Hide(arg0_26)
	end)
end

function var0_0.Reset(arg0_28)
	var0_0.super.Reset(arg0_28)

	arg0_28.exited = false
end

function var0_0.OnDestroy(arg0_29)
	arg0_29.exited = true
	arg0_29.bgName = nil
end

return var0_0
