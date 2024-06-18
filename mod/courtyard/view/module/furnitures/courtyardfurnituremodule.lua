local var0_0 = class("CourtYardFurnitureModule", import("..CourtYardPlaceableModule"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1:AddListener(CourtYardEvent.FURNITURE_POSITION_CHANGE, arg0_1.OnPositionUpdate)
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	pg.ViewUtils.SetLayer(arg0_2._tf, Layer.UI)

	arg0_2.model = arg0_2._tf:Find("icon")
	arg0_2.masksTF = arg0_2._tf:Find("masks")
	arg0_2.masks = {}
	arg0_2.isMultiMask = arg0_2:GetData():IsMultiMask()

	for iter0_2, iter1_2 in pairs(arg0_2:GetData():GetMaskNames()) do
		local var0_2 = arg0_2.masksTF:Find("icon_front_" .. iter0_2)

		if arg0_2.isMultiMask then
			setParent(var0_2, arg0_2.interactionTF)
		end

		arg0_2.masks[iter0_2] = var0_2
	end

	arg0_2.archMask = arg0_2.masksTF:Find("icon_front_arch")
	arg0_2.bodyMasks = {}

	for iter2_2, iter3_2 in pairs(arg0_2.data:GetBodyMasks()) do
		arg0_2.bodyMasks[iter2_2] = arg0_2.interactionTF:Find("body_mask" .. iter2_2)
	end

	arg0_2.animators = {}

	for iter4_2, iter5_2 in pairs(arg0_2.data:GetAnimators()) do
		local var1_2 = arg0_2.data:GetAnimatorMask() and arg0_2.interactionTF:Find("animtor_mask") or arg0_2.interactionTF

		arg0_2.animators[iter5_2.key] = var1_2:Find("Animator" .. iter5_2.key)
	end

	local var2_2 = arg0_2:GetData().selectedFlag

	arg0_2:InitAttachment(var2_2)

	if not var2_2 then
		arg0_2:EnableTrigger(false)
	end

	if arg0_2.data:IsSpine() then
		arg0_2.animator = CourtYardFurnitureAnimatorAgent.New(arg0_2)
	end

	arg0_2.effectContainer = arg0_2._tf
	arg0_2.effectAgent = CourtYardEffectAgent.New(arg0_2)
end

function var0_0.CreateWhenStoreyInit(arg0_3)
	var0_0.super.CreateWhenStoreyInit(arg0_3)
	arg0_3:BlocksRaycasts(false)
end

function var0_0.BlocksRaycasts(arg0_4, arg1_4)
	local var0_4 = arg0_4.data:CanClickWhenExitEditMode()
	local var1_4 = #arg0_4.data:GetUsingSlots() > 0

	if var0_4 or var1_4 and arg1_4 == false then
		return
	end

	arg0_4.cg.blocksRaycasts = arg1_4
end

function var0_0.GetSpine(arg0_5)
	if arg0_5.animator then
		return arg0_5.animator.spineAnimUI.gameObject.transform
	end
end

function var0_0.GetCenterPoint(arg0_6)
	local var0_6 = arg0_6:GetParentTF():InverseTransformPoint(arg0_6._tf.position)
	local var1_6 = Vector2(var0_6.x, var0_6.y)
	local var2_6 = arg0_6._tf.sizeDelta
	local var3_6 = Vector2(0.5, 0.5) - arg0_6._tf.pivot
	local var4_6 = arg0_6._tf.localScale.x
	local var5_6 = var1_6 + Vector2(var4_6 * var2_6.x * var3_6.x, var2_6.y * var3_6.y)

	return Vector3(var5_6.x, var5_6.y, 0)
end

function var0_0.GetSpinePoint(arg0_7)
	local var0_7 = arg0_7:GetParentTF():InverseTransformPoint(arg0_7._tf:Find("spine_icon/spine").position)

	return Vector3(var0_7.x, var0_7.y, 0)
end

function var0_0.GetBodyMask(arg0_8, arg1_8)
	return arg0_8.bodyMasks[arg1_8]
end

function var0_0.GetAnimator(arg0_9, arg1_9)
	return arg0_9.animators[arg1_9]
end

function var0_0.AddListeners(arg0_10)
	arg0_10:AddListener(CourtYardEvent.FURNITURE_OP_FLAG_CHANGE, arg0_10.EnableTrigger)
	arg0_10:AddListener(CourtYardEvent.ROTATE_FURNITURE, arg0_10.OnDirChange)
	arg0_10:AddListener(CourtYardEvent.FURNITURE_STATE_CHANGE, arg0_10.OnStateChange)
	arg0_10:AddListener(CourtYardEvent.FURNITURE_WILL_INTERACTION, arg0_10.OnWillInterAction)
	arg0_10:AddListener(CourtYardEvent.FURNITURE_START_INTERACTION, arg0_10.OnStartInterAction)
	arg0_10:AddListener(CourtYardEvent.FURNITURE_UPDATE_INTERACTION, arg0_10.OnUpdateInteraction)
	arg0_10:AddListener(CourtYardEvent.FURNITURE_STOP_INTERACTION, arg0_10.OnStopInterAction)
	arg0_10:AddListener(CourtYardEvent.FURNITURE_MOVE, arg0_10.OnMove)
	arg0_10:AddListener(CourtYardEvent.FURNITURE_STOP_MOVE, arg0_10.OnStopMove)
end

function var0_0.RemoveListeners(arg0_11)
	arg0_11:RemoveListener(CourtYardEvent.FURNITURE_OP_FLAG_CHANGE, arg0_11.EnableTrigger)
	arg0_11:RemoveListener(CourtYardEvent.ROTATE_FURNITURE, arg0_11.OnDirChange)
	arg0_11:RemoveListener(CourtYardEvent.FURNITURE_STATE_CHANGE, arg0_11.OnStateChange)
	arg0_11:RemoveListener(CourtYardEvent.FURNITURE_WILL_INTERACTION, arg0_11.OnWillInterAction)
	arg0_11:RemoveListener(CourtYardEvent.FURNITURE_START_INTERACTION, arg0_11.OnStartInterAction)
	arg0_11:RemoveListener(CourtYardEvent.FURNITURE_UPDATE_INTERACTION, arg0_11.OnUpdateInteraction)
	arg0_11:RemoveListener(CourtYardEvent.FURNITURE_STOP_INTERACTION, arg0_11.OnStopInterAction)
	arg0_11:RemoveListener(CourtYardEvent.FURNITURE_MOVE, arg0_11.OnMove)
	arg0_11:RemoveListener(CourtYardEvent.FURNITURE_STOP_MOVE, arg0_11.OnStopMove)
end

function var0_0.EnableTrigger(arg0_12, arg1_12)
	arg0_12.dragAgent:Enable(arg1_12)
end

function var0_0.InitAttachment(arg0_13, arg1_13)
	onButton(arg0_13, arg0_13._tf, function()
		arg0_13:Emit("SelectFurniture", arg0_13.data.id)
	end, SFX_PANEL)

	if arg1_13 then
		triggerButton(arg0_13._tf)
	end
end

function var0_0.OnBeginDrag(arg0_15)
	arg0_15:Emit("BeginDragFurniture", arg0_15.data.id)
end

function var0_0.OnDragging(arg0_16, arg1_16)
	arg0_16:Emit("DragingFurniture", arg0_16.data.id, arg1_16)
end

function var0_0.OnDragEnd(arg0_17, arg1_17)
	arg0_17:Emit("DragFurnitureEnd", arg0_17.data.id, arg1_17)
end

function var0_0.OnPositionUpdate(arg0_18, arg1_18, arg2_18)
	arg0_18:UpdatePosition(arg1_18, arg2_18)
end

function var0_0.OnDirChange(arg0_19, arg1_19)
	arg0_19._tf.localScale = Vector3(arg1_19 == 1 and 1 or -1, 1, 1)
end

function var0_0.OnWillInterAction(arg0_20, arg1_20)
	if arg0_20.isMultiMask then
		for iter0_20, iter1_20 in pairs(arg0_20.masks) do
			iter1_20:SetAsLastSibling()
		end
	end
end

function var0_0.OnStartInterAction(arg0_21, arg1_21)
	local var0_21 = arg1_21:GetUsingAnimator()

	if var0_21 then
		setActive(arg0_21:GetAnimator(var0_21.key), true)
	end

	local var1_21 = arg1_21:GetSkew()

	if var1_21 ~= Vector3.zero then
		arg0_21._tf.localPosition = var1_21
	end

	for iter0_21, iter1_21 in pairs(arg0_21.masks) do
		setActive(iter1_21, true)
	end

	if arg0_21.isMultiMask then
		for iter2_21, iter3_21 in pairs(arg0_21.masks) do
			iter3_21:SetSiblingIndex(1 + 2 * (iter2_21 - 1))
		end
	end
end

function var0_0.OnUpdateInteraction(arg0_22, arg1_22)
	if arg0_22.animator then
		arg0_22.animator:PlayInteractioAnim(arg1_22.action)
	end

	local var0_22 = arg0_22:GetBodyMask(arg1_22.slot.id)

	if var0_22 then
		var0_22:GetComponent(typeof(Image)).enabled = not arg1_22.closeBodyMask
	end

	local var1_22 = arg1_22.slot:GetUsingAnimator()

	if arg1_22.isReset and var1_22 then
		local var2_22 = arg0_22:GetAnimator(var1_22.key)

		setActive(var2_22, false)
		setActive(var2_22, true)
	end

	if arg1_22.block then
		arg0_22.cg.blocksRaycasts = false
	end
end

function var0_0.OnStopInterAction(arg0_23, arg1_23)
	local var0_23 = arg1_23:GetUsingAnimator()

	if var0_23 then
		local var1_23 = arg0_23:GetAnimator(var0_23.key)

		var1_23.localScale = Vector3.one
		var1_23.localEulerAngles = Vector3.zero

		setActive(var1_23, false)
	end

	local var2_23 = arg0_23:GetBodyMask(arg1_23.id)

	if var2_23 then
		var2_23.localScale = Vector3.one
		var2_23.localEulerAngles = Vector3.zero
	end

	if arg0_23:GetData():AnySlotIsUsing() and table.getCount(arg0_23.masks) >= 1 then
		-- block empty
	else
		for iter0_23, iter1_23 in pairs(arg0_23.masks) do
			setActive(iter1_23, false)
		end
	end
end

function var0_0.OnAnimtionFinish(arg0_24, arg1_24)
	arg0_24.cg.blocksRaycasts = true

	arg0_24:Emit("FurnitureAnimtionFinish", arg0_24.data.id, arg1_24)
end

function var0_0.OnStateChange(arg0_25, arg1_25)
	if arg1_25 == CourtYardFurniture.STATE_PLAY_MUSIC then
		arg0_25:AddMusicEffect()
	elseif arg1_25 == CourtYardFurniture.STATE_IDLE then
		arg0_25:StopMusicEffect()
	end

	if arg0_25.animator then
		arg0_25.animator:SetState(arg1_25)
	end
end

function var0_0.AddMusicEffect(arg0_26)
	local var0_26 = arg0_26.data:GetMusicData()

	if var0_26 and var0_26.effect then
		arg0_26.effectAgent:EnableEffect(var0_26.effect)
	end
end

function var0_0.StopMusicEffect(arg0_27)
	local var0_27 = arg0_27.data:GetMusicData()

	if var0_27 and var0_27.effect then
		arg0_27.effectAgent:DisableEffect(var0_27.effect)
	end
end

function var0_0.OnMove(arg0_28, arg1_28)
	local var0_28 = CourtYardCalcUtil.Map2Local(arg1_28)
	local var1_28 = arg0_28.data:GetMoveTime()
	local var2_28 = Vector3(var0_28.x, var0_28.y, 0)
	local var3_28 = CourtYardCalcUtil.TrPosition2LocalPos(arg0_28:GetParentTF(), arg0_28._tf.parent, var2_28)

	LeanTween.moveLocal(arg0_28._go, var3_28, var1_28)
end

function var0_0.OnStopMove(arg0_29)
	if LeanTween.isTweening(arg0_29._go) then
		LeanTween.cancel(arg0_29._go)
	end
end

function var0_0.OnDispose(arg0_30)
	var0_0.super.OnDispose(arg0_30)

	if not IsNil(arg0_30.model) then
		Object.Destroy(arg0_30.model.gameObject)
	end

	for iter0_30, iter1_30 in pairs(arg0_30.masks) do
		Object.Destroy(iter1_30.gameObject)
	end

	arg0_30.masks = nil

	for iter2_30, iter3_30 in pairs(arg0_30.animators) do
		Object.Destroy(iter3_30.gameObject)
	end

	arg0_30.animators = nil

	if not IsNil(arg0_30.archMask) then
		Object.Destroy(arg0_30.archMask.gameObject)
	end

	arg0_30.archMask = nil

	if arg0_30.animator then
		arg0_30.animator:Dispose()

		arg0_30.animator = nil
	end

	arg0_30.effectAgent:Dispose()

	arg0_30.effectAgent = nil

	for iter4_30, iter5_30 in pairs(arg0_30.bodyMasks) do
		Object.Destroy(iter5_30.gameObject)
	end

	arg0_30.bodyMasks = nil
	arg0_30.cg.blocksRaycasts = true

	Object.Destroy(arg0_30._tf:GetComponent(typeof(ButtonEventExtend)))
	Object.Destroy(arg0_30._tf:GetComponent(typeof(Button)))
end

function var0_0.OnDestroy(arg0_31)
	arg0_31:RemoveListener(CourtYardEvent.FURNITURE_POSITION_CHANGE, arg0_31.OnPositionUpdate)
	arg0_31:GetView().poolMgr:GetFurniturePool():Enqueue(arg0_31._go)
end

return var0_0
