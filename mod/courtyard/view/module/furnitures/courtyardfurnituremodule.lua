local var0 = class("CourtYardFurnitureModule", import("..CourtYardPlaceableModule"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)
	arg0:AddListener(CourtYardEvent.FURNITURE_POSITION_CHANGE, arg0.OnPositionUpdate)
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	pg.ViewUtils.SetLayer(arg0._tf, Layer.UI)

	arg0.model = arg0._tf:Find("icon")
	arg0.masksTF = arg0._tf:Find("masks")
	arg0.masks = {}
	arg0.isMultiMask = arg0:GetData():IsMultiMask()

	for iter0, iter1 in pairs(arg0:GetData():GetMaskNames()) do
		local var0 = arg0.masksTF:Find("icon_front_" .. iter0)

		if arg0.isMultiMask then
			setParent(var0, arg0.interactionTF)
		end

		arg0.masks[iter0] = var0
	end

	arg0.archMask = arg0.masksTF:Find("icon_front_arch")
	arg0.bodyMasks = {}

	for iter2, iter3 in pairs(arg0.data:GetBodyMasks()) do
		arg0.bodyMasks[iter2] = arg0.interactionTF:Find("body_mask" .. iter2)
	end

	arg0.animators = {}

	for iter4, iter5 in pairs(arg0.data:GetAnimators()) do
		local var1 = arg0.data:GetAnimatorMask() and arg0.interactionTF:Find("animtor_mask") or arg0.interactionTF

		arg0.animators[iter5.key] = var1:Find("Animator" .. iter5.key)
	end

	local var2 = arg0:GetData().selectedFlag

	arg0:InitAttachment(var2)

	if not var2 then
		arg0:EnableTrigger(false)
	end

	if arg0.data:IsSpine() then
		arg0.animator = CourtYardFurnitureAnimatorAgent.New(arg0)
	end

	arg0.effectContainer = arg0._tf
	arg0.effectAgent = CourtYardEffectAgent.New(arg0)
end

function var0.CreateWhenStoreyInit(arg0)
	var0.super.CreateWhenStoreyInit(arg0)
	arg0:BlocksRaycasts(false)
end

function var0.BlocksRaycasts(arg0, arg1)
	local var0 = arg0.data:CanClickWhenExitEditMode()
	local var1 = #arg0.data:GetUsingSlots() > 0

	if var0 or var1 and arg1 == false then
		return
	end

	arg0.cg.blocksRaycasts = arg1
end

function var0.GetSpine(arg0)
	if arg0.animator then
		return arg0.animator.spineAnimUI.gameObject.transform
	end
end

function var0.GetCenterPoint(arg0)
	local var0 = arg0:GetParentTF():InverseTransformPoint(arg0._tf.position)
	local var1 = Vector2(var0.x, var0.y)
	local var2 = arg0._tf.sizeDelta
	local var3 = Vector2(0.5, 0.5) - arg0._tf.pivot
	local var4 = arg0._tf.localScale.x
	local var5 = var1 + Vector2(var4 * var2.x * var3.x, var2.y * var3.y)

	return Vector3(var5.x, var5.y, 0)
end

function var0.GetSpinePoint(arg0)
	local var0 = arg0:GetParentTF():InverseTransformPoint(arg0._tf:Find("spine_icon/spine").position)

	return Vector3(var0.x, var0.y, 0)
end

function var0.GetBodyMask(arg0, arg1)
	return arg0.bodyMasks[arg1]
end

function var0.GetAnimator(arg0, arg1)
	return arg0.animators[arg1]
end

function var0.AddListeners(arg0)
	arg0:AddListener(CourtYardEvent.FURNITURE_OP_FLAG_CHANGE, arg0.EnableTrigger)
	arg0:AddListener(CourtYardEvent.ROTATE_FURNITURE, arg0.OnDirChange)
	arg0:AddListener(CourtYardEvent.FURNITURE_STATE_CHANGE, arg0.OnStateChange)
	arg0:AddListener(CourtYardEvent.FURNITURE_WILL_INTERACTION, arg0.OnWillInterAction)
	arg0:AddListener(CourtYardEvent.FURNITURE_START_INTERACTION, arg0.OnStartInterAction)
	arg0:AddListener(CourtYardEvent.FURNITURE_UPDATE_INTERACTION, arg0.OnUpdateInteraction)
	arg0:AddListener(CourtYardEvent.FURNITURE_STOP_INTERACTION, arg0.OnStopInterAction)
	arg0:AddListener(CourtYardEvent.FURNITURE_MOVE, arg0.OnMove)
	arg0:AddListener(CourtYardEvent.FURNITURE_STOP_MOVE, arg0.OnStopMove)
end

function var0.RemoveListeners(arg0)
	arg0:RemoveListener(CourtYardEvent.FURNITURE_OP_FLAG_CHANGE, arg0.EnableTrigger)
	arg0:RemoveListener(CourtYardEvent.ROTATE_FURNITURE, arg0.OnDirChange)
	arg0:RemoveListener(CourtYardEvent.FURNITURE_STATE_CHANGE, arg0.OnStateChange)
	arg0:RemoveListener(CourtYardEvent.FURNITURE_WILL_INTERACTION, arg0.OnWillInterAction)
	arg0:RemoveListener(CourtYardEvent.FURNITURE_START_INTERACTION, arg0.OnStartInterAction)
	arg0:RemoveListener(CourtYardEvent.FURNITURE_UPDATE_INTERACTION, arg0.OnUpdateInteraction)
	arg0:RemoveListener(CourtYardEvent.FURNITURE_STOP_INTERACTION, arg0.OnStopInterAction)
	arg0:RemoveListener(CourtYardEvent.FURNITURE_MOVE, arg0.OnMove)
	arg0:RemoveListener(CourtYardEvent.FURNITURE_STOP_MOVE, arg0.OnStopMove)
end

function var0.EnableTrigger(arg0, arg1)
	arg0.dragAgent:Enable(arg1)
end

function var0.InitAttachment(arg0, arg1)
	onButton(arg0, arg0._tf, function()
		arg0:Emit("SelectFurniture", arg0.data.id)
	end, SFX_PANEL)

	if arg1 then
		triggerButton(arg0._tf)
	end
end

function var0.OnBeginDrag(arg0)
	arg0:Emit("BeginDragFurniture", arg0.data.id)
end

function var0.OnDragging(arg0, arg1)
	arg0:Emit("DragingFurniture", arg0.data.id, arg1)
end

function var0.OnDragEnd(arg0, arg1)
	arg0:Emit("DragFurnitureEnd", arg0.data.id, arg1)
end

function var0.OnPositionUpdate(arg0, arg1, arg2)
	arg0:UpdatePosition(arg1, arg2)
end

function var0.OnDirChange(arg0, arg1)
	arg0._tf.localScale = Vector3(arg1 == 1 and 1 or -1, 1, 1)
end

function var0.OnWillInterAction(arg0, arg1)
	if arg0.isMultiMask then
		for iter0, iter1 in pairs(arg0.masks) do
			iter1:SetAsLastSibling()
		end
	end
end

function var0.OnStartInterAction(arg0, arg1)
	local var0 = arg1:GetUsingAnimator()

	if var0 then
		setActive(arg0:GetAnimator(var0.key), true)
	end

	local var1 = arg1:GetSkew()

	if var1 ~= Vector3.zero then
		arg0._tf.localPosition = var1
	end

	for iter0, iter1 in pairs(arg0.masks) do
		setActive(iter1, true)
	end

	if arg0.isMultiMask then
		for iter2, iter3 in pairs(arg0.masks) do
			iter3:SetSiblingIndex(1 + 2 * (iter2 - 1))
		end
	end
end

function var0.OnUpdateInteraction(arg0, arg1)
	if arg0.animator then
		arg0.animator:PlayInteractioAnim(arg1.action)
	end

	local var0 = arg0:GetBodyMask(arg1.slot.id)

	if var0 then
		var0:GetComponent(typeof(Image)).enabled = not arg1.closeBodyMask
	end

	local var1 = arg1.slot:GetUsingAnimator()

	if arg1.isReset and var1 then
		local var2 = arg0:GetAnimator(var1.key)

		setActive(var2, false)
		setActive(var2, true)
	end

	if arg1.block then
		arg0.cg.blocksRaycasts = false
	end
end

function var0.OnStopInterAction(arg0, arg1)
	local var0 = arg1:GetUsingAnimator()

	if var0 then
		local var1 = arg0:GetAnimator(var0.key)

		var1.localScale = Vector3.one
		var1.localEulerAngles = Vector3.zero

		setActive(var1, false)
	end

	local var2 = arg0:GetBodyMask(arg1.id)

	if var2 then
		var2.localScale = Vector3.one
		var2.localEulerAngles = Vector3.zero
	end

	if arg0:GetData():AnySlotIsUsing() and table.getCount(arg0.masks) >= 1 then
		-- block empty
	else
		for iter0, iter1 in pairs(arg0.masks) do
			setActive(iter1, false)
		end
	end
end

function var0.OnAnimtionFinish(arg0, arg1)
	arg0.cg.blocksRaycasts = true

	arg0:Emit("FurnitureAnimtionFinish", arg0.data.id, arg1)
end

function var0.OnStateChange(arg0, arg1)
	if arg1 == CourtYardFurniture.STATE_PLAY_MUSIC then
		arg0:AddMusicEffect()
	elseif arg1 == CourtYardFurniture.STATE_IDLE then
		arg0:StopMusicEffect()
	end

	if arg0.animator then
		arg0.animator:SetState(arg1)
	end
end

function var0.AddMusicEffect(arg0)
	local var0 = arg0.data:GetMusicData()

	if var0 and var0.effect then
		arg0.effectAgent:EnableEffect(var0.effect)
	end
end

function var0.StopMusicEffect(arg0)
	local var0 = arg0.data:GetMusicData()

	if var0 and var0.effect then
		arg0.effectAgent:DisableEffect(var0.effect)
	end
end

function var0.OnMove(arg0, arg1)
	local var0 = CourtYardCalcUtil.Map2Local(arg1)
	local var1 = arg0.data:GetMoveTime()
	local var2 = Vector3(var0.x, var0.y, 0)
	local var3 = CourtYardCalcUtil.TrPosition2LocalPos(arg0:GetParentTF(), arg0._tf.parent, var2)

	LeanTween.moveLocal(arg0._go, var3, var1)
end

function var0.OnStopMove(arg0)
	if LeanTween.isTweening(arg0._go) then
		LeanTween.cancel(arg0._go)
	end
end

function var0.OnDispose(arg0)
	var0.super.OnDispose(arg0)

	if not IsNil(arg0.model) then
		Object.Destroy(arg0.model.gameObject)
	end

	for iter0, iter1 in pairs(arg0.masks) do
		Object.Destroy(iter1.gameObject)
	end

	arg0.masks = nil

	for iter2, iter3 in pairs(arg0.animators) do
		Object.Destroy(iter3.gameObject)
	end

	arg0.animators = nil

	if not IsNil(arg0.archMask) then
		Object.Destroy(arg0.archMask.gameObject)
	end

	arg0.archMask = nil

	if arg0.animator then
		arg0.animator:Dispose()

		arg0.animator = nil
	end

	arg0.effectAgent:Dispose()

	arg0.effectAgent = nil

	for iter4, iter5 in pairs(arg0.bodyMasks) do
		Object.Destroy(iter5.gameObject)
	end

	arg0.bodyMasks = nil
	arg0.cg.blocksRaycasts = true

	Object.Destroy(arg0._tf:GetComponent(typeof(ButtonEventExtend)))
	Object.Destroy(arg0._tf:GetComponent(typeof(Button)))
end

function var0.OnDestroy(arg0)
	arg0:RemoveListener(CourtYardEvent.FURNITURE_POSITION_CHANGE, arg0.OnPositionUpdate)
	arg0:GetView().poolMgr:GetFurniturePool():Enqueue(arg0._go)
end

return var0
