local var0_0 = class("MainCalibrationPage", import("view.base.BaseSubView"))
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2
local var4_0 = 3

function var0_0.getUIName(arg0_1)
	return "MainCalibrationUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.moveBtn = arg0_2._tf:Find("move")
	arg0_2.setBtn = arg0_2._tf:Find("set")
	arg0_2.scaleSetBtn = arg0_2._tf:Find("scale_set")
	arg0_2.backBtn = arg0_2._tf:Find("back")
	arg0_2.scaleContent = arg0_2._tf:Find("scale_content")
	arg0_2.resetBtn = arg0_2._tf:Find("reset")
	arg0_2.saveBtn = arg0_2._tf:Find("save")
	arg0_2.bgImage = arg0_2._tf:Find("adapt/bg"):GetComponent(typeof(Image))
	arg0_2.paintingTF = arg0_2._parentTf:Find("paint")
	arg0_2._bgTf = arg0_2._parentTf:Find("paintBg")
	arg0_2.l2dContainer = arg0_2.paintingTF:Find("live2d")
	arg0_2.spineContainer = arg0_2.paintingTF:Find("spinePainting")
	arg0_2.setBtnX = arg0_2.setBtn.localPosition.x
	arg0_2.scaleSetBtnX = arg0_2.scaleSetBtn.localPosition.x
	arg0_2.btnSelectX = arg0_2.moveBtn.localPosition.x
	arg0_2.showing = false
	arg0_2.pageCG = GetOrAddComponent(arg0_2._tf, typeof(CanvasGroup))
	arg0_2.pageCG.ignoreParentGroups = true
	arg0_2.pageCG.interactable = true
	arg0_2.pageCG.blocksRaycasts = true
end

function var0_0.OnInit(arg0_3)
	arg0_3.stateType = 0

	onButton(arg0_3, arg0_3._parentTf, function()
		if arg0_3.stateType > 0 then
			return
		end

		if arg0_3.showing then
			arg0_3:exitToggle()
			arg0_3:emit(NewMainScene.FOLD, false)
		end
	end)
	onToggle(arg0_3, arg0_3.moveBtn, function(arg0_5)
		arg0_3.stateType = arg0_5 and var2_0 or var1_0

		arg0_3:updateState()
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.setBtn, function(arg0_6)
		arg0_3.stateType = arg0_6 and var3_0 or var1_0

		arg0_3:updateState()
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.scaleSetBtn, function(arg0_7)
		arg0_3.stateType = arg0_7 and var4_0 or var1_0

		arg0_3:updateState()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:exitToggle()
		arg0_3:emit(NewMainScene.FOLD, false)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.saveBtn, function()
		arg0_3:SavePostion()
		arg0_3:updateState()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.resetBtn, function()
		if arg0_3.stateType == var3_0 then
			arg0_3:ResetPostion()
		elseif arg0_3.stateType == var4_0 then
			arg0_3:emit(NewMainScene.RESET_PAITING_SCALE)
		end
	end, SFX_PANEL)
	arg0_3:bind(NewMainScene.SET_SCALE_PART_CONTENT, function(arg0_11, arg1_11)
		setParent(arg1_11, arg0_3.scaleContent, true)
	end)
end

function var0_0.Move(arg0_12, arg1_12)
	setToggleEnabled(arg0_12.setBtn, not arg1_12)
	arg0_12:emit(NewMainScene.ENABLE_PAITING_MOVE, arg1_12)
end

function var0_0.exitToggle(arg0_13)
	if arg0_13.stateType == var2_0 then
		triggerToggle(arg0_13.moveBtn, false)
	elseif arg0_13.stateType == var3_0 then
		triggerToggle(arg0_13.setBtn, false)
	elseif arg0_13.stateType == var4_0 then
		triggerToggle(arg0_13.scaleSetBtn, false)
	end

	arg0_13.stateType = var1_0
end

function var0_0.updateState(arg0_14)
	setActive(arg0_14.moveBtn, arg0_14.stateType == var1_0)
	setActive(arg0_14.setBtn, arg0_14.stateType == var1_0)
	setActive(arg0_14.scaleSetBtn, arg0_14.stateType == var1_0 and not arg0_14.hideScaleSet)
	setActive(arg0_14.scaleContent, false)

	if arg0_14.stateType == var2_0 then
		setActive(arg0_14.moveBtn, true)
	elseif arg0_14.stateType == var3_0 then
		setActive(arg0_14.setBtn, true)
	elseif arg0_14.stateType == var4_0 then
		setActive(arg0_14.scaleContent, true)
		setActive(arg0_14.scaleSetBtn, true)
	end

	setActive(arg0_14.backBtn, arg0_14.stateType == var1_0)
	setActive(arg0_14.resetBtn, arg0_14.stateType > var2_0)
	setActive(arg0_14.saveBtn, arg0_14.stateType > var2_0)

	arg0_14.bgImage.enabled = arg0_14.stateType ~= var1_0 and arg0_14.stateType ~= var2_0

	if arg0_14.stateType > 0 then
		if arg0_14.stateType == var2_0 then
			LeanTween.moveLocalX(arg0_14.moveBtn.gameObject, arg0_14.btnSelectX, 0.2)
		elseif arg0_14.stateType == var3_0 then
			LeanTween.moveLocalX(arg0_14.setBtn.gameObject, arg0_14.btnSelectX, 0.2)
		elseif arg0_14.stateType == var4_0 then
			LeanTween.moveLocalX(arg0_14.scaleSetBtn.gameObject, arg0_14.btnSelectX, 0.2)
		end
	else
		LeanTween.moveLocalX(arg0_14.moveBtn.gameObject, arg0_14.btnSelectX, 0.2)
		LeanTween.moveLocalX(arg0_14.setBtn.gameObject, arg0_14.setBtnX, 0.2)
		LeanTween.moveLocalX(arg0_14.scaleSetBtn.gameObject, arg0_14.scaleSetBtnX, 0.2)
	end

	if arg0_14.stateType == var1_0 then
		arg0_14:emit(NewMainScene.ENABLE_PAITING_MOVE, false)
		arg0_14:emit(NewMainScene.ENABLE_PAITING_SCALE, false)
	elseif arg0_14.stateType == var2_0 or arg0_14.stateType == var3_0 then
		arg0_14:emit(NewMainScene.ENABLE_PAITING_MOVE, true)
	elseif arg0_14.stateType == var4_0 then
		arg0_14:emit(NewMainScene.ENABLE_PAITING_SCALE, true)
	end

	local var0_14 = arg0_14.stateType > 1 and -150 or 0
	local var1_14 = arg0_14.stateType > 1 and 0 or -150
	local var2_14 = LeanTween.value(arg0_14.backBtn.gameObject, var1_14, var0_14, 0.3):setOnUpdate(System.Action_float(function(arg0_15)
		arg0_14.resetBtn.anchoredPosition = Vector2(arg0_15, arg0_14.resetBtn.anchoredPosition.y)
		arg0_14.saveBtn.anchoredPosition = Vector2(arg0_15, arg0_14.saveBtn.anchoredPosition.y)
	end))
end

function var0_0.SetPostion(arg0_16, arg1_16)
	local function var0_16()
		setActive(arg0_16.moveBtn, not arg1_16)
		setActive(arg0_16.backBtn, not arg1_16)
		setActive(arg0_16.scaleSetBtn, not arg1_16)
	end

	arg0_16.bgImage.enabled = arg1_16

	local var1_16 = arg1_16 and arg0_16.moveBtn.localPosition.x or arg0_16.setBtnX

	LeanTween.moveLocalX(arg0_16.setBtn.gameObject, var1_16, 0.2)

	local var2_16 = arg1_16 and -150 or 0
	local var3_16 = arg1_16 and 0 or -150
	local var4_16 = LeanTween.value(arg0_16.backBtn.gameObject, var3_16, var2_16, 0.3):setOnUpdate(System.Action_float(function(arg0_18)
		arg0_16.resetBtn.anchoredPosition = Vector2(arg0_18, arg0_16.resetBtn.anchoredPosition.y)
		arg0_16.saveBtn.anchoredPosition = Vector2(arg0_18, arg0_16.saveBtn.anchoredPosition.y)
	end))

	if arg1_16 then
		var0_16()
	else
		var4_16:setOnComplete(System.Action(var0_16))
	end

	arg0_16:emit(NewMainScene.ENABLE_PAITING_MOVE, arg1_16)
end

function var0_0.SavePostion(arg0_19)
	if arg0_19.stateType == var3_0 then
		local var0_19 = arg0_19.paintingTF.anchoredPosition
		local var1_19 = arg0_19.paintingTF.localScale.x
		local var2_19 = arg0_19.flagShip:getSkinId()

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("secretary_pos_save"),
			onYes = function()
				getProxy(SettingsProxy):setSkinPosSetting(arg0_19.flagShip, var0_19.x, var0_19.y, var1_19)
				pg.TipsMgr.GetInstance():ShowTips(i18n("secretary_pos_save_success"))
				arg0_19:exitToggle()
				arg0_19:emit(NewMainScene.FOLD, false)
			end
		})
	elseif arg0_19.stateType == var4_0 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("secretary_pos_save"),
			onYes = function()
				arg0_19:emit(NewMainScene.SAVE_PART_SCALE)
				pg.TipsMgr.GetInstance():ShowTips(i18n("secretary_pos_save_success"))
				arg0_19:exitToggle()
				arg0_19:emit(NewMainScene.FOLD, false)
			end
		})
	end
end

function var0_0.ResetPostion(arg0_22)
	getProxy(SettingsProxy):resetSkinPosSetting(arg0_22.flagShip)

	local var0_22 = MainPaintingView.GetAssistantStatus(arg0_22.flagShip)
	local var1_22, var2_22 = arg0_22.shift:GetMeshImageShift()

	arg0_22.paintingTF.anchoredPosition = var1_22
	arg0_22._bgTf.anchoredPosition = var1_22

	local var3_22, var4_22 = arg0_22.shift:GetL2dShift()

	if MainPaintingShift.IsLimitYPos(arg0_22.flagShip:getPainting()) then
		var3_22.y = MainPaintingShift.GetHalfBodyOffsetY(arg0_22.paintingTF.parent, arg0_22.l2dContainer)
	end

	arg0_22.l2dContainer.anchoredPosition = var3_22

	local var5_22, var6_22 = arg0_22.shift:GetSpineShift()

	arg0_22.spineContainer.anchoredPosition = var5_22

	if var0_22 == MainPaintingView.STATE_L2D then
		arg0_22._bgTf.localScale = var4_22
		arg0_22.paintingTF.localScale = var4_22
	elseif var0_22 == MainPaintingView.STATE_SPINE_PAINTING then
		arg0_22._bgTf.localScale = var6_22
		arg0_22.paintingTF.localScale = var6_22
	else
		arg0_22._bgTf.localScale = var2_22
		arg0_22.paintingTF.localScale = var2_22
	end
end

function var0_0.ShowOrHide(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23)
	arg0_23.flagShip = arg2_23
	arg0_23.showing = arg1_23

	local var0_23 = MainPaintingView.GetAssistantStatus(arg0_23.flagShip)

	arg0_23.hideScaleSet = true

	local var1_23 = pg.ship_skin_template[arg0_23.flagShip:getSkinId()].part_scale

	if var0_23 == MainPaintingView.STATE_PAINTING and var1_23.paint and #var1_23.paint > 0 then
		arg0_23.hideScaleSet = false
	elseif var0_23 == MainPaintingView.STATE_SPINE_PAINTING and var1_23.spine and #var1_23.spine > 0 then
		arg0_23.hideScaleSet = false
	end

	if arg1_23 then
		arg0_23:Show(arg3_23)
		arg0_23:UpdateBg(arg4_23)
		arg0_23:updateState()
	else
		arg0_23:Hide()
	end
end

function var0_0.UpdateBg(arg0_24, arg1_24)
	if arg1_24 == arg0_24.bgName then
		return
	end

	LoadSpriteAsync("clutter/" .. arg1_24, function(arg0_25)
		if arg0_24.exited then
			return
		end

		arg0_24.bgImage.sprite = arg0_25
	end)

	arg0_24.bgName = arg1_24
end

function var0_0.Show(arg0_26, arg1_26)
	var0_0.super.Show(arg0_26)

	arg0_26.shift = arg1_26

	arg0_26:DoBottomAnimation(0, 100)
	arg0_26:DoLeftAnimation(0, -150, function()
		return
	end)
end

function var0_0.DoLeftAnimation(arg0_28, arg1_28, arg2_28, arg3_28)
	LeanTween.value(arg0_28.backBtn.gameObject, arg1_28, arg2_28, 0.3):setOnUpdate(System.Action_float(function(arg0_29)
		arg0_28.backBtn.anchoredPosition = Vector2(arg0_29, arg0_28.backBtn.anchoredPosition.y)
	end)):setOnComplete(System.Action(arg3_28))
end

function var0_0.DoBottomAnimation(arg0_30, arg1_30, arg2_30)
	LeanTween.value(arg0_30.moveBtn.gameObject, arg1_30, arg2_30, 0.3):setOnUpdate(System.Action_float(function(arg0_31)
		arg0_30.moveBtn.anchoredPosition = Vector2(arg0_30.moveBtn.anchoredPosition.x, arg0_31)
		arg0_30.setBtn.anchoredPosition = Vector2(arg0_30.setBtn.anchoredPosition.x, arg0_31)
		arg0_30.scaleSetBtn.anchoredPosition = Vector2(arg0_30.scaleSetBtn.anchoredPosition.x, arg0_31)
	end))
end

function var0_0.Hide(arg0_32)
	arg0_32:DoBottomAnimation(100, 0)
	arg0_32:DoLeftAnimation(-150, 0, function()
		var0_0.super.Hide(arg0_32)
	end)
end

function var0_0.Reset(arg0_34)
	var0_0.super.Reset(arg0_34)

	arg0_34.exited = false
end

function var0_0.OnDestroy(arg0_35)
	arg0_35.exited = true
	arg0_35.bgName = nil
end

return var0_0
