local var0_0 = class("AgoraOpView", import("Mod.Island.Core.View.IslandOpView"))

function var0_0.GetUIName(arg0_1)
	return "IslandAgoraOpUI"
end

function var0_0.OnInit(arg0_2, arg1_2)
	var0_0.super.OnInit(arg0_2, arg1_2)

	arg0_2.agoraPanel = arg0_2._tf:Find("agora_op_btns")
	arg0_2.agoraOpBtn = arg0_2.agoraPanel:Find("agora")
	arg0_2.lookBtn = arg0_2._tf:Find("look")
	arg0_2.moveBtn = arg0_2._tf:Find("move")
	arg0_2.agoraMoveBtn = arg0_2.agoraPanel:Find("move")
	arg0_2.agoraMoveDirTr = arg0_2._tf:Find("agora_op_btns/move/Area/dir")
	arg0_2.dragBtn = arg0_2.agoraPanel:Find("drag")
	arg0_2.confirmBtn = arg0_2.dragBtn:Find("ok")
	arg0_2.removeBtn = arg0_2.dragBtn:Find("cancel")
	arg0_2.rotationBtn = arg0_2.dragBtn:Find("rotation")
	arg0_2.testBtn = arg0_2._tf:Find("test")
	arg0_2.testCancelBtn = arg0_2._tf:Find("test_1")

	onButton(arg0_2, arg0_2.agoraOpBtn, function()
		arg0_2:Op("EnterEditMode")
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.testBtn, function()
		arg0_2:Op("InterAction", 6000101, 3)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.testCancelBtn, function()
		arg0_2:Op("InterActionEnd", 6000101, 3)
	end, SFX_PANEL)
	setActive(arg0_2.agoraOpBtn, arg0_2:IsSelfIsland())

	arg0_2.isDraging = false
end

function var0_0.OnUpdate(arg0_6)
	var0_0.super.OnUpdate(arg0_6)

	if arg0_6.activeMould and not arg0_6.isDraging then
		arg0_6:UpdateDragPosition(arg0_6.activeMould)
	end
end

function var0_0.ActiveDragBtn(arg0_7, arg1_7)
	arg0_7:UpdateDragPosition(arg1_7)
	arg0_7:AddDraglistener(arg1_7)

	arg0_7.activeMould = arg1_7
end

function var0_0.InActiveDragBtn(arg0_8)
	arg0_8.activeMould = nil
	arg0_8.isDraging = false
	arg0_8.dragBtn.localPosition = Vector3(10000, 10000, 0)

	arg0_8:RemoveDraglistener()
end

function var0_0.UpdateDragPosition(arg0_9, arg1_9)
	local var0_9 = arg1_9.root.position
	local var1_9 = AgoraCalc.WorldPosition2ScreenPosition(var0_9)
	local var2_9 = AgoraCalc.ScreenPosition2LocalPosition(arg0_9.dragBtn.parent, var1_9)

	arg0_9.dragBtn.localPosition = var2_9
end

function var0_0.AddDraglistener(arg0_10, arg1_10)
	local var0_10 = GetOrAddComponent(arg0_10.dragBtn, typeof(EventTriggerListener))

	var0_10:AddBeginDragFunc(function(arg0_11, arg1_11)
		arg0_10.isDraging = true

		arg0_10:Op("BeginDragItem")
	end)
	var0_10:AddDragFunc(function(arg0_12, arg1_12)
		local var0_12 = AgoraCalc.ScreenPostion2MapPosition(arg1_12.position)

		arg0_10:Op("DragItem", var0_12)
		arg0_10:UpdateDragPosition(arg1_10)
	end)
	var0_10:AddDragEndFunc(function(arg0_13, arg1_13)
		local var0_13 = AgoraCalc.ScreenPostion2MapPosition(arg1_13.position)

		arg0_10:Op("EndDragItem", var0_13)
		arg0_10:UpdateDragPosition(arg1_10)

		arg0_10.isDraging = false
	end)
	onButton(arg0_10, arg0_10.confirmBtn, function()
		arg0_10:Op("ConfirmSelectedItem")
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.removeBtn, function()
		arg0_10:Op("UnPlaceItem")
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.rotationBtn, function()
		arg0_10:Op("RotationItem")
	end, SFX_PANEL)
end

function var0_0.RemoveDraglistener(arg0_17)
	local var0_17 = GetOrAddComponent(arg0_17.dragBtn, typeof(EventTriggerListener))

	var0_17:AddBeginDragFunc(nil)
	var0_17:AddDragFunc(nil)
	var0_17:AddDragEndFunc(nil)
	removeOnButton(arg0_17.confirmBtn)
	removeOnButton(arg0_17.removeBtn)
	removeOnButton(arg0_17.removeBtn)
end

function var0_0.OnClick(arg0_18, arg1_18)
	local var0_18 = AgoraCalc.ScreenPostion2MapPosition(arg1_18)

	arg0_18:Op("SelectItem", var0_18)
end

function var0_0.EnableAgoraOp(arg0_19)
	setActive(arg0_19.agoraOpBtn, false)
	setActive(arg0_19.moveBtn, false)
	setActive(arg0_19.agoraMoveBtn, true)
	arg0_19.inputController:ActivePlayerActionMap(IslandConst.AGORA_INPUT_INDEX)
	arg0_19:AddClickListener()
end

function var0_0.DisableAgoraOp(arg0_20)
	setActive(arg0_20.agoraOpBtn, true)
	setActive(arg0_20.moveBtn, true)
	setActive(arg0_20.agoraMoveBtn, false)
	arg0_20.inputController:ActivePlayerActionMap(IslandConst.PLAYER_INPUT_INDEX)
	arg0_20:RemoveClickListener()
end

function var0_0.Disable(arg0_21)
	setActive(arg0_21.lookBtn, false)
	setActive(arg0_21.moveBtn, false)
	setActive(arg0_21.opPanel, false)
	setActive(arg0_21.agoraPanel, false)
end

function var0_0.Enable(arg0_22)
	setActive(arg0_22.lookBtn, true)
	setActive(arg0_22.moveBtn, true)
	setActive(arg0_22.opPanel, true)
	setActive(arg0_22.agoraPanel, true)
end

function var0_0.AddClickListener(arg0_23)
	local var0_23 = GetOrAddComponent(arg0_23.lookBtn, typeof(EventTriggerListener))
	local var1_23

	var0_23:AddPointDownFunc(function(arg0_24, arg1_24)
		var1_23 = arg1_24.position
	end)
	var0_23:AddPointUpFunc(function(arg0_25, arg1_25)
		if not var1_23 or var1_23 ~= arg1_25.position then
			return
		end

		arg0_23:OnClick(arg1_25.position)

		var1_23 = nil
	end)
end

function var0_0.RemoveClickListener(arg0_26)
	local var0_26 = arg0_26.lookBtn:GetComponent(typeof(EventTriggerListener))

	if var0_26 then
		var0_26:AddPointDownFunc(nil)
		var0_26:AddPointUpFunc(nil)
		RemoveComponent(arg0_26.lookBtn, "EventTriggerListener")
	end
end

function var0_0.OnDestroy(arg0_27)
	var0_0.super.OnDestroy(arg0_27)
	arg0_27:RemoveClickListener()
	arg0_27:RemoveDraglistener()
end

return var0_0
