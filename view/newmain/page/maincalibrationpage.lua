local var0 = class("MainCalibrationPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "MainCalibrationUI"
end

function var0.OnLoaded(arg0)
	arg0.moveBtn = arg0:findTF("move")
	arg0.setBtn = arg0:findTF("set")
	arg0.backBtn = arg0:findTF("back")
	arg0.resetBtn = arg0:findTF("reset")
	arg0.saveBtn = arg0:findTF("save")
	arg0.bgImage = arg0._tf:Find("adapt/bg"):GetComponent(typeof(Image))
	arg0.paintingTF = arg0._parentTf:Find("paint")
	arg0._bgTf = arg0._parentTf:Find("paintBg")
	arg0.l2dContainer = arg0.paintingTF:Find("live2d")
	arg0.spineContainer = arg0.paintingTF:Find("spinePainting")
	arg0.setBtnX = arg0.setBtn.localPosition.x
	arg0.showing = false
end

function var0.OnInit(arg0)
	local var0 = false
	local var1 = false

	onToggle(arg0, arg0.moveBtn, function(arg0)
		var0 = arg0

		arg0:Move(arg0)
	end, SFX_PANEL)
	onButton(arg0, arg0._parentTf, function()
		if var1 then
			return
		end

		if arg0.showing and not var0 then
			if var1 then
				triggerToggle(arg0.setBtn, false)
			end

			arg0:emit(NewMainScene.FOLD, false)
		end
	end)
	onButton(arg0, arg0.backBtn, function()
		if var0 then
			triggerToggle(arg0.moveBtn, false)
		end

		arg0:emit(NewMainScene.FOLD, false)
	end, SFX_PANEL)
	onToggle(arg0, arg0.setBtn, function(arg0)
		var1 = arg0

		arg0:SetPostion(arg0)
	end, SFX_PANEL)
	onButton(arg0, arg0.saveBtn, function()
		arg0:SavePostion()
	end, SFX_PANEL)
	onButton(arg0, arg0.resetBtn, function()
		arg0:ResetPostion()
	end, SFX_PANEL)
end

function var0.Move(arg0, arg1)
	setToggleEnabled(arg0.setBtn, not arg1)
	arg0:emit(NewMainScene.ENABLE_PAITING_MOVE, arg1)
end

function var0.SetPostion(arg0, arg1)
	local function var0()
		setActive(arg0.moveBtn, not arg1)
		setActive(arg0.backBtn, not arg1)
	end

	arg0.bgImage.enabled = arg1

	local var1 = arg1 and arg0.moveBtn.localPosition.x or arg0.setBtnX

	LeanTween.moveLocalX(arg0.setBtn.gameObject, var1, 0.2)

	local var2 = arg1 and -150 or 0
	local var3 = arg1 and 0 or -150
	local var4 = LeanTween.value(arg0.backBtn.gameObject, var3, var2, 0.3):setOnUpdate(System.Action_float(function(arg0)
		arg0.resetBtn.anchoredPosition = Vector2(arg0, arg0.resetBtn.anchoredPosition.y)
		arg0.saveBtn.anchoredPosition = Vector2(arg0, arg0.saveBtn.anchoredPosition.y)
	end))

	if arg1 then
		var0()
	else
		var4:setOnComplete(System.Action(var0))
	end

	arg0:emit(NewMainScene.ENABLE_PAITING_MOVE, arg1)
end

function var0.SavePostion(arg0)
	local var0 = arg0.paintingTF.anchoredPosition
	local var1 = arg0.paintingTF.localScale.x
	local var2 = arg0.flagShip.skinId

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("secretary_pos_save"),
		onYes = function()
			getProxy(SettingsProxy):setSkinPosSetting(arg0.flagShip, var0.x, var0.y, var1)
			pg.TipsMgr.GetInstance():ShowTips(i18n("secretary_pos_save_success"))
			triggerToggle(arg0.setBtn, false)
			arg0:emit(NewMainScene.FOLD, false)
		end
	})
end

function var0.ResetPostion(arg0)
	getProxy(SettingsProxy):resetSkinPosSetting(arg0.flagShip)

	local var0 = MainPaintingView.GetAssistantStatus(arg0.flagShip)
	local var1, var2 = arg0.shift:GetMeshImageShift()

	arg0.paintingTF.anchoredPosition = var1
	arg0._bgTf.anchoredPosition = var1

	local var3, var4 = arg0.shift:GetL2dShift()

	arg0.l2dContainer.anchoredPosition = var3

	local var5, var6 = arg0.shift:GetSpineShift()

	arg0.spineContainer.anchoredPosition = var5

	if var0 == MainPaintingView.STATE_L2D then
		arg0._bgTf.localScale = var4
		arg0.paintingTF.localScale = var4
	elseif var0 == MainPaintingView.STATE_SPINE_PAINTING then
		arg0._bgTf.localScale = var6
		arg0.paintingTF.localScale = var6
	else
		arg0._bgTf.localScale = var2
		arg0.paintingTF.localScale = var2
	end
end

function var0.ShowOrHide(arg0, arg1, arg2, arg3, arg4)
	if arg1 then
		arg0:Show(arg3)
		arg0:UpdateBg(arg4)
	else
		arg0:Hide()
	end

	arg0.flagShip = arg2
	arg0.showing = arg1
end

function var0.UpdateBg(arg0, arg1)
	if arg1 == arg0.bgName then
		return
	end

	LoadSpriteAsync("clutter/" .. arg1, function(arg0)
		if arg0.exited then
			return
		end

		arg0.bgImage.sprite = arg0
	end)

	arg0.bgName = arg1
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)

	arg0.shift = arg1

	arg0:DoBottomAnimation(0, 100)
	arg0:DoLeftAnimation(0, -150, function()
		return
	end)
end

function var0.DoLeftAnimation(arg0, arg1, arg2, arg3)
	LeanTween.value(arg0.backBtn.gameObject, arg1, arg2, 0.3):setOnUpdate(System.Action_float(function(arg0)
		arg0.backBtn.anchoredPosition = Vector2(arg0, arg0.backBtn.anchoredPosition.y)
	end)):setOnComplete(System.Action(arg3))
end

function var0.DoBottomAnimation(arg0, arg1, arg2)
	LeanTween.value(arg0.moveBtn.gameObject, arg1, arg2, 0.3):setOnUpdate(System.Action_float(function(arg0)
		arg0.moveBtn.anchoredPosition = Vector2(arg0.moveBtn.anchoredPosition.x, arg0)
		arg0.setBtn.anchoredPosition = Vector2(arg0.setBtn.anchoredPosition.x, arg0)
	end))
end

function var0.Hide(arg0)
	arg0:DoBottomAnimation(100, 0)
	arg0:DoLeftAnimation(-150, 0, function()
		var0.super.Hide(arg0)
	end)
end

function var0.Reset(arg0)
	var0.super.Reset(arg0)

	arg0.exited = false
end

function var0.OnDestroy(arg0)
	arg0.exited = true
	arg0.bgName = nil
end

return var0
