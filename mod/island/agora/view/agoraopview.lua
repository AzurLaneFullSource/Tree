local var0_0 = class("AgoraOpView", import("Mod.Island.Core.View.IslandOpView"))

function var0_0.GetUIName(arg0_1)
	return "IslandAgoraOpUI"
end

function var0_0.OnInit(arg0_2, arg1_2)
	var0_0.super.OnInit(arg0_2, arg1_2)
	arg0_2.opUI:SetAsFirstSibling()

	arg0_2.agoraPanel = arg0_2._tf:Find("agora_op_btns")
	arg0_2.lookBtn = arg0_2.opUI:Find("look")
	arg0_2.moveBtn = arg0_2.opUI:Find("move")
	arg0_2.agoraMoveBtn = arg0_2.agoraPanel:Find("move")
	arg0_2.agoraMoveDirTr = arg0_2._tf:Find("agora_op_btns/move/Area/dir")
	arg0_2.dragBtn = arg0_2.agoraPanel:Find("drag")
	arg0_2.confirmBtn = arg0_2.dragBtn:Find("ok")
	arg0_2.removeBtn = arg0_2.dragBtn:Find("cancel")
	arg0_2.rotationBtn = arg0_2.dragBtn:Find("rotation")
	arg0_2.signInTip = arg0_2._tf:Find("adapt/signIn_tip")
	arg0_2.isDraging = false

	arg0_2:ShowOrHideGameObject(arg0_2.agoraPanel, false)

	arg0_2.animator = arg0_2.agoraPanel:GetComponent(typeof(Animation))
	arg0_2.dftAniEvent = arg0_2.agoraPanel:GetComponent(typeof(DftAniEvent))

	setText(arg0_2.signInTip:Find("Text"), i18n("island_agora_signIn_tip"))
	arg0_2:UpdateSignInTip()
end

function var0_0.DisablePlayerOp(arg0_3)
	var0_0.super.DisablePlayerOp(arg0_3)
	setActive(arg0_3.signInTip, false)
end

function var0_0.EnablePlayerOp(arg0_4)
	var0_0.super.EnablePlayerOp(arg0_4)
	arg0_4:UpdateSignInTip()
end

function var0_0.OnUpdate(arg0_5)
	var0_0.super.OnUpdate(arg0_5)

	if arg0_5.activeMould and not arg0_5.isDraging then
		arg0_5:UpdateDragPosition(arg0_5.activeMould)
	end
end

function var0_0.UpdateSignInTip(arg0_6)
	if not arg0_6:GetView():IsSelfIsland() then
		setActive(arg0_6.signInTip, false)
	else
		local var0_6 = arg0_6:GetView():GetIsland()

		setActive(arg0_6.signInTip, var0_6:GetSignInAgency():CanSignIn())
	end
end

function var0_0.ShowMoveBtn(arg0_7, arg1_7)
	arg0_7:ShowOrHideGameObject(arg0_7.agoraPanel, arg1_7)
end

function var0_0.ActiveDragBtn(arg0_8, arg1_8)
	arg0_8.dftAniEvent:SetEndEvent(nil)
	arg0_8:UpdateDragPosition(arg1_8)

	arg0_8.activeMould = arg1_8

	arg0_8.animator:Stop()
	arg0_8.dftAniEvent:SetEndEvent(function()
		arg0_8.dftAniEvent:SetEndEvent(nil)
		arg0_8:AddDraglistener(arg1_8)
	end)
	arg0_8.animator:Play("anim_IslandAgoraOpUI_Agora_In")
end

function var0_0.InActiveDragBtn(arg0_10)
	arg0_10.activeMould = nil
	arg0_10.isDraging = false

	arg0_10.animator:Stop()
	removeOnButton(arg0_10.confirmBtn)
	removeOnButton(arg0_10.removeBtn)
	removeOnButton(arg0_10.rotationBtn)
	arg0_10.dftAniEvent:SetEndEvent(nil)
	arg0_10.dftAniEvent:SetEndEvent(function()
		arg0_10.dftAniEvent:SetEndEvent(nil)
		arg0_10:RemoveDraglistener()

		arg0_10.dragBtn.localPosition = Vector3(10000, 10000, 0)
	end)
	arg0_10.animator:Play("anim_IslandAgoraOpUI_Agora_Out")
end

function var0_0.UpdateDragPosition(arg0_12, arg1_12)
	local var0_12 = arg1_12.root.position
	local var1_12 = AgoraCalc.WorldPosition2ScreenPosition(var0_12)
	local var2_12 = AgoraCalc.ScreenPosition2LocalPosition(arg0_12.dragBtn.parent, var1_12)

	arg0_12.dragBtn.localPosition = var2_12
end

function var0_0.AddDraglistener(arg0_13, arg1_13)
	local var0_13 = GetOrAddComponent(arg0_13.dragBtn, typeof(EventTriggerListener))

	var0_13:AddBeginDragFunc(function(arg0_14, arg1_14)
		arg0_13.isDraging = true

		arg0_13:Op("BeginDragItem")
	end)
	var0_13:AddDragFunc(function(arg0_15, arg1_15)
		local var0_15 = AgoraCalc.ScreenPostion2MapPosition(arg1_15.position)

		arg0_13:Op("DragItem", var0_15)
		arg0_13:UpdateDragPosition(arg1_13)
	end)
	var0_13:AddDragEndFunc(function(arg0_16, arg1_16)
		local var0_16 = AgoraCalc.ScreenPostion2MapPosition(arg1_16.position)

		arg0_13:Op("EndDragItem", var0_16)
		arg0_13:UpdateDragPosition(arg1_13)

		arg0_13.isDraging = false
	end)
	onButton(arg0_13, arg0_13.confirmBtn, function()
		arg0_13:Op("ConfirmSelectedItem")
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.removeBtn, function()
		arg0_13:Op("RemovePlaceItem")
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.rotationBtn, function()
		arg0_13:Op("RotationItem")
	end, SFX_PANEL)
end

function var0_0.RemoveDraglistener(arg0_20)
	local var0_20 = GetOrAddComponent(arg0_20.dragBtn, typeof(EventTriggerListener))

	var0_20:AddBeginDragFunc(nil)
	var0_20:AddDragFunc(nil)
	var0_20:AddDragEndFunc(nil)
	removeOnButton(arg0_20.confirmBtn)
	removeOnButton(arg0_20.removeBtn)
end

function var0_0.EnterMode(arg0_21, arg1_21)
	if arg1_21 == AgoraView.MODE_OVERVIEW then
		arg0_21:ShowOrHideGameObject(arg0_21.moveBtn, true)
		arg0_21:ShowOrHideGameObject(arg0_21.agoraPanel, false)
		arg0_21:TryEnablePlayerOp()
		arg0_21.inputController:ActivePlayerActionMap(IslandConst.PLAYER_INPUT_INDEX)
		arg0_21:RemoveEditModeListener()
	elseif arg1_21 == AgoraView.MODE_EDIT then
		arg0_21:ShowOrHideGameObject(arg0_21.moveBtn, false)
		arg0_21:ShowOrHideGameObject(arg0_21.agoraPanel, true)

		if not arg0_21.mode or arg0_21.mode == AgoraView.MODE_OVERVIEW then
			arg0_21:TryDisablePlayerOp()
		end

		arg0_21.inputController:ActivePlayerActionMap(IslandConst.AGORA_INPUT_INDEX)
		arg0_21.inputController:EnableAgoraLook()
		arg0_21:RemovePaveTileModeListener()
		arg0_21:AddEditModeListener()
	elseif arg1_21 == AgoraView.MODE_PAVE_TILE then
		arg0_21.inputController:DisableAgoraLook()
		arg0_21:RemoveEditModeListener()
		arg0_21:AddPaveTileModeListener()
	end

	arg0_21.mode = arg1_21
end

function var0_0.OnEditModeClick(arg0_22, arg1_22)
	local var0_22 = IslandHelper.Raycast4Agora(arg1_22, IslandConst.UNIT_LIST_AGORA, IslandConst.LAYER_WORLDMAP3D)

	if var0_22 > 0 then
		arg0_22:Op("TrySelectItemById", var0_22)
	end
end

function var0_0.AddEditModeListener(arg0_23)
	local var0_23 = GetOrAddComponent(arg0_23.lookBtn, typeof(EventTriggerListener))
	local var1_23

	var0_23:AddPointDownFunc(function(arg0_24, arg1_24)
		var1_23 = arg1_24.position
	end)
	var0_23:AddPointUpFunc(function(arg0_25, arg1_25)
		if not var1_23 or var1_23 ~= arg1_25.position then
			return
		end

		arg0_23:OnEditModeClick(arg1_25.position)

		var1_23 = nil
	end)
end

function var0_0.RemoveEditModeListener(arg0_26)
	local var0_26 = arg0_26.lookBtn:GetComponent(typeof(EventTriggerListener))

	if var0_26 then
		var0_26:AddPointDownFunc(nil)
		var0_26:AddPointUpFunc(nil)
	end
end

function var0_0.AddPaveTileModeListener(arg0_27)
	local var0_27 = GetOrAddComponent(arg0_27.lookBtn, typeof(EventTriggerListener))
	local var1_27

	var0_27:AddPointDownFunc(function(arg0_28, arg1_28)
		var1_27 = arg1_28.position
	end)
	var0_27:AddPointUpFunc(function(arg0_29, arg1_29)
		if not var1_27 or var1_27 ~= arg1_29.position then
			return
		end

		local var0_29 = AgoraCalc.ScreenPostion2MapPosition(arg1_29.position)

		arg0_27:Op("OpLayer", var0_29)

		local var1_29
	end)
	var0_27:AddBeginDragFunc(function(arg0_30, arg1_30)
		return
	end)
	var0_27:AddDragFunc(function(arg0_31, arg1_31)
		local var0_31 = AgoraCalc.ScreenPostion2MapPosition(arg1_31.position)

		arg0_27:Op("OpLayer", var0_31)
	end)
	var0_27:AddDragEndFunc(function(arg0_32, arg1_32)
		return
	end)
end

function var0_0.RemovePaveTileModeListener(arg0_33)
	local var0_33 = arg0_33.lookBtn:GetComponent(typeof(EventTriggerListener))

	if var0_33 then
		var0_33:AddPointDownFunc(nil)
		var0_33:AddPointUpFunc(nil)
		var0_33:AddBeginDragFunc(nil)
		var0_33:AddDragFunc(nil)
		var0_33:AddDragEndFunc(nil)
	end
end

function var0_0.OnDestroy(arg0_34)
	var0_0.super.OnDestroy(arg0_34)
	arg0_34:RemovePaveTileModeListener()
	arg0_34:RemoveDraglistener()
	arg0_34.dftAniEvent:SetEndEvent(nil)
end

return var0_0
