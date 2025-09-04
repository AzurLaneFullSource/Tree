local var0_0 = class("AgoraOpView", import("Mod.Island.Core.View.IslandOpView"))

function var0_0.GetUIName(arg0_1)
	return "IslandAgoraOpUI"
end

function var0_0.OnInit(arg0_2, arg1_2)
	var0_0.super.OnInit(arg0_2, arg1_2)

	arg0_2.agoraPanel = arg0_2._tf:Find("agora_op_btns")
	arg0_2.lookBtn = arg0_2._tf:Find("look")
	arg0_2.moveBtn = arg0_2._tf:Find("move")
	arg0_2.agoraMoveBtn = arg0_2.agoraPanel:Find("move")
	arg0_2.agoraMoveDirTr = arg0_2._tf:Find("agora_op_btns/move/Area/dir")
	arg0_2.dragBtn = arg0_2.agoraPanel:Find("drag")
	arg0_2.confirmBtn = arg0_2.dragBtn:Find("ok")
	arg0_2.removeBtn = arg0_2.dragBtn:Find("cancel")
	arg0_2.rotationBtn = arg0_2.dragBtn:Find("rotation")
	arg0_2.signInTip = arg0_2._tf:Find("adapt/signIn_tip")
	arg0_2.isDraging = false
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

function var0_0.ActiveDragBtn(arg0_7, arg1_7)
	arg0_7.dftAniEvent:SetEndEvent(nil)
	arg0_7:UpdateDragPosition(arg1_7)

	arg0_7.activeMould = arg1_7

	arg0_7.animator:Stop()
	arg0_7.dftAniEvent:SetEndEvent(function()
		arg0_7.dftAniEvent:SetEndEvent(nil)
		arg0_7:AddDraglistener(arg1_7)
	end)
	arg0_7.animator:Play("anim_IslandAgoraOpUI_Agora_In")
end

function var0_0.InActiveDragBtn(arg0_9)
	arg0_9.activeMould = nil
	arg0_9.isDraging = false

	arg0_9.animator:Stop()
	arg0_9.dftAniEvent:SetEndEvent(nil)
	arg0_9.dftAniEvent:SetEndEvent(function()
		arg0_9.dftAniEvent:SetEndEvent(nil)
		arg0_9:RemoveDraglistener()

		arg0_9.dragBtn.localPosition = Vector3(10000, 10000, 0)
	end)
	arg0_9.animator:Play("anim_IslandAgoraOpUI_Agora_Out")
end

function var0_0.UpdateDragPosition(arg0_11, arg1_11)
	local var0_11 = arg1_11.root.position
	local var1_11 = AgoraCalc.WorldPosition2ScreenPosition(var0_11)
	local var2_11 = AgoraCalc.ScreenPosition2LocalPosition(arg0_11.dragBtn.parent, var1_11)

	arg0_11.dragBtn.localPosition = var2_11
end

function var0_0.AddDraglistener(arg0_12, arg1_12)
	local var0_12 = GetOrAddComponent(arg0_12.dragBtn, typeof(EventTriggerListener))

	var0_12:AddBeginDragFunc(function(arg0_13, arg1_13)
		arg0_12.isDraging = true

		arg0_12:Op("BeginDragItem")
	end)
	var0_12:AddDragFunc(function(arg0_14, arg1_14)
		local var0_14 = AgoraCalc.ScreenPostion2MapPosition(arg1_14.position)

		arg0_12:Op("DragItem", var0_14)
		arg0_12:UpdateDragPosition(arg1_12)
	end)
	var0_12:AddDragEndFunc(function(arg0_15, arg1_15)
		local var0_15 = AgoraCalc.ScreenPostion2MapPosition(arg1_15.position)

		arg0_12:Op("EndDragItem", var0_15)
		arg0_12:UpdateDragPosition(arg1_12)

		arg0_12.isDraging = false
	end)
	onButton(arg0_12, arg0_12.confirmBtn, function()
		arg0_12:Op("ConfirmSelectedItem")
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.removeBtn, function()
		arg0_12:Op("RemovePlaceItem")
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.rotationBtn, function()
		arg0_12:Op("RotationItem")
	end, SFX_PANEL)
end

function var0_0.RemoveDraglistener(arg0_19)
	local var0_19 = GetOrAddComponent(arg0_19.dragBtn, typeof(EventTriggerListener))

	var0_19:AddBeginDragFunc(nil)
	var0_19:AddDragFunc(nil)
	var0_19:AddDragEndFunc(nil)
	removeOnButton(arg0_19.confirmBtn)
	removeOnButton(arg0_19.removeBtn)
	removeOnButton(arg0_19.removeBtn)
end

function var0_0.EnterMode(arg0_20, arg1_20)
	if arg1_20 == AgoraView.MODE_OVERVIEW then
		setActive(arg0_20.moveBtn, true)
		setActive(arg0_20.agoraMoveBtn, false)
		arg0_20:TryEnablePlayerOp()
		arg0_20.inputController:ActivePlayerActionMap(IslandConst.PLAYER_INPUT_INDEX)
		arg0_20:RemoveEditModeListener()
	elseif arg1_20 == AgoraView.MODE_EDIT then
		setActive(arg0_20.moveBtn, false)
		setActive(arg0_20.agoraMoveBtn, true)

		if not arg0_20.mode or arg0_20.mode == AgoraView.MODE_OVERVIEW then
			arg0_20:TryDisablePlayerOp()
		end

		arg0_20.inputController:ActivePlayerActionMap(IslandConst.AGORA_INPUT_INDEX)
		arg0_20.inputController:EnableAgoraLook()
		arg0_20:RemovePaveTileModeListener()
		arg0_20:AddEditModeListener()
	elseif arg1_20 == AgoraView.MODE_PAVE_TILE then
		arg0_20.inputController:DisableAgoraLook()
		arg0_20:RemoveEditModeListener()
		arg0_20:AddPaveTileModeListener()
	end

	arg0_20.mode = arg1_20
end

function var0_0.StartInteraction(arg0_21)
	arg0_21.super.StartInteraction(arg0_21)
	setActive(arg0_21.agoraPanel, false)
end

function var0_0.EndInteraction(arg0_22)
	arg0_22.super.EndInteraction(arg0_22)
	setActive(arg0_22.agoraPanel, true)
end

function var0_0.OnEditModeClick(arg0_23, arg1_23)
	local var0_23 = AgoraCalc.ScreenPostion2MapPosition(arg1_23)

	arg0_23:Op("TrySelectItem", var0_23)
end

function var0_0.AddEditModeListener(arg0_24)
	local var0_24 = GetOrAddComponent(arg0_24.lookBtn, typeof(EventTriggerListener))
	local var1_24

	var0_24:AddPointDownFunc(function(arg0_25, arg1_25)
		var1_24 = arg1_25.position
	end)
	var0_24:AddPointUpFunc(function(arg0_26, arg1_26)
		if not var1_24 or var1_24 ~= arg1_26.position then
			return
		end

		arg0_24:OnEditModeClick(arg1_26.position)

		var1_24 = nil
	end)
end

function var0_0.RemoveEditModeListener(arg0_27)
	local var0_27 = arg0_27.lookBtn:GetComponent(typeof(EventTriggerListener))

	if var0_27 then
		var0_27:AddPointDownFunc(nil)
		var0_27:AddPointUpFunc(nil)
	end
end

function var0_0.AddPaveTileModeListener(arg0_28)
	local var0_28 = GetOrAddComponent(arg0_28.lookBtn, typeof(EventTriggerListener))
	local var1_28

	var0_28:AddPointDownFunc(function(arg0_29, arg1_29)
		var1_28 = arg1_29.position
	end)
	var0_28:AddPointUpFunc(function(arg0_30, arg1_30)
		if not var1_28 or var1_28 ~= arg1_30.position then
			return
		end

		local var0_30 = AgoraCalc.ScreenPostion2MapPosition(arg1_30.position)

		arg0_28:Op("OpLayer", var0_30)

		local var1_30
	end)
	var0_28:AddBeginDragFunc(function(arg0_31, arg1_31)
		return
	end)
	var0_28:AddDragFunc(function(arg0_32, arg1_32)
		local var0_32 = AgoraCalc.ScreenPostion2MapPosition(arg1_32.position)

		arg0_28:Op("OpLayer", var0_32)
	end)
	var0_28:AddDragEndFunc(function(arg0_33, arg1_33)
		return
	end)
end

function var0_0.RemovePaveTileModeListener(arg0_34)
	local var0_34 = arg0_34.lookBtn:GetComponent(typeof(EventTriggerListener))

	if var0_34 then
		var0_34:AddPointDownFunc(nil)
		var0_34:AddPointUpFunc(nil)
		var0_34:AddBeginDragFunc(nil)
		var0_34:AddDragFunc(nil)
		var0_34:AddDragEndFunc(nil)
	end
end

function var0_0.OnDestroy(arg0_35)
	var0_0.super.OnDestroy(arg0_35)
	arg0_35:RemovePaveTileModeListener()
	arg0_35:RemoveDraglistener()
	arg0_35.dftAniEvent:SetEndEvent(nil)
end

return var0_0
