local var0_0 = class("CourtYardShipModule", import("..CourtYardPlaceableModule"))
local var1_0 = 1

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var1_0 = CourtYardConst.SHIP_SCALE

	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.role = arg3_1
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	pg.ViewUtils.SetLayer(arg0_2._tf, Layer.UI)
	arg0_2._tf:SetParent(arg0_2.floor)

	arg0_2.model = arg0_2._tf:Find("model")
	arg0_2.model.localPosition = Vector3(0, 25, 0)
	arg0_2.shadow = arg0_2._tf:Find("shadow")
	arg0_2.shadow.localPosition = Vector3(0, 25, 0)

	arg0_2.shadow:SetAsFirstSibling()

	arg0_2.spineAnimUI = arg0_2.role.model:GetComponent(typeof(SpineAnimUI))
	arg0_2.clickTF = arg0_2._tf:Find("click")
	arg0_2.chatTF = arg0_2._tf:Find("chat")
	arg0_2.chatTF.localScale = Vector3.zero
	arg0_2.additionTF = arg0_2._tf:Find("addition")
	arg0_2.additionTFs = {
		findTF(arg0_2.additionTF, "money"),
		findTF(arg0_2.additionTF, "intimacy"),
		findTF(arg0_2.additionTF, "exp")
	}
	arg0_2.additionTFPos = Vector3(0, 250, 0)
	arg0_2.inimacyBubble = arg0_2._tf:Find("intimacy")
	arg0_2.moneyBubble = arg0_2._tf:Find("money")
	arg0_2.animator = CourtYardShipAnimatorAgent.New(arg0_2)
	arg0_2._tf.localScale = Vector3(var1_0, var1_0, 1)
	arg0_2._tf:Find("grids").localScale = Vector3(1 / var1_0, 1 / var1_0, 1)

	arg0_2.animator:SetState(arg0_2.data:GetState())
	arg0_2:UpdateBubble(arg0_2.inimacyBubble, arg0_2.data.inimacy)
	arg0_2:UpdateBubble(arg0_2.moneyBubble, arg0_2.data.coin)
	arg0_2:InitAttachment()
	setActive(arg0_2.shadow, true)
end

function var0_0.AdjustYForInteraction(arg0_3)
	arg0_3.model.localPosition = Vector3(0, 0, 0)
end

function var0_0.ResetYForInteraction(arg0_4)
	arg0_4.model.localPosition = Vector3(0, 25, 0)
end

function var0_0.GetSpine(arg0_5)
	return arg0_5.spineAnimUI.gameObject.transform
end

function var0_0.AddListeners(arg0_6)
	arg0_6:AddListener(CourtYardEvent.SHIP_STATE_CHANGE, arg0_6.OnStateChange)
	arg0_6:AddListener(CourtYardEvent.SHIP_MOVE, arg0_6.OnMove)
	arg0_6:AddListener(CourtYardEvent.SHIP_POSITION_CHANGE, arg0_6.OnUpdatePosition)
	arg0_6:AddListener(CourtYardEvent.SHIP_GET_AWARD, arg0_6.OnAddAward)
	arg0_6:AddListener(CourtYardEvent.SHIP_INIMACY_CHANGE, arg0_6.OnInimacyChange)
	arg0_6:AddListener(CourtYardEvent.SHIP_COIN_CHANGE, arg0_6.OnCoinChange)
	arg0_6:AddListener(CourtYardEvent.SHIP_UPDATE_INTERACTION, arg0_6.OnUpdateInteraction)
	arg0_6:AddListener(CourtYardEvent.SHIP_WILL_INTERACTION, arg0_6.WillInterAction)
	arg0_6:AddListener(CourtYardEvent.SHIP_START_INTERACTION, arg0_6.StartInterAction)
	arg0_6:AddListener(CourtYardEvent.SHIP_STOP_INTERACTION, arg0_6.StopInterAction)
end

function var0_0.RemoveListeners(arg0_7)
	arg0_7:RemoveListener(CourtYardEvent.SHIP_STATE_CHANGE, arg0_7.OnStateChange)
	arg0_7:RemoveListener(CourtYardEvent.SHIP_MOVE, arg0_7.OnMove)
	arg0_7:RemoveListener(CourtYardEvent.SHIP_POSITION_CHANGE, arg0_7.OnUpdatePosition)
	arg0_7:RemoveListener(CourtYardEvent.SHIP_GET_AWARD, arg0_7.OnAddAward)
	arg0_7:RemoveListener(CourtYardEvent.SHIP_INIMACY_CHANGE, arg0_7.OnInimacyChange)
	arg0_7:RemoveListener(CourtYardEvent.SHIP_COIN_CHANGE, arg0_7.OnCoinChange)
	arg0_7:RemoveListener(CourtYardEvent.SHIP_UPDATE_INTERACTION, arg0_7.OnUpdateInteraction)
	arg0_7:RemoveListener(CourtYardEvent.SHIP_WILL_INTERACTION, arg0_7.WillInterAction)
	arg0_7:RemoveListener(CourtYardEvent.SHIP_START_INTERACTION, arg0_7.StartInterAction)
	arg0_7:RemoveListener(CourtYardEvent.SHIP_STOP_INTERACTION, arg0_7.StopInterAction)
end

function var0_0.InitAttachment(arg0_8)
	onButton(arg0_8, arg0_8.clickTF, function()
		arg0_8:Emit("TouchShip", arg0_8.data.id)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BOAT_CLICK)
	end)
	onButton(arg0_8, arg0_8.inimacyBubble, function()
		arg0_8:Emit("GetShipInimacy", arg0_8.data.id)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.moneyBubble, function()
		arg0_8:Emit("GetShipCoin", arg0_8.data.id)
	end, SFX_PANEL)
end

function var0_0.OnBeginDrag(arg0_12)
	if not arg0_12:GetView():GetCurrStorey():AllModulesAreCompletion() then
		return
	end

	arg0_12:Emit("DragShip", arg0_12.data.id)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BOAT_DRAG)
end

function var0_0.OnDragging(arg0_13, arg1_13)
	arg0_13:Emit("DragingShip", arg0_13.data.id, arg1_13)
end

function var0_0.OnDragEnd(arg0_14, arg1_14)
	arg0_14:Emit("DragShipEnd", arg0_14.data.id, arg1_14)
end

function var0_0.OnUpdatePosition(arg0_15, arg1_15, arg2_15)
	arg0_15:UpdatePosition(arg1_15, arg2_15)
end

function var0_0.OnStateChange(arg0_16, arg1_16, arg2_16)
	if arg1_16 ~= CourtYardShip.STATE_MOVING_ZERO and arg1_16 ~= CourtYardShip.STATE_MOVING_HALF and arg1_16 ~= CourtYardShip.STATE_MOVING_ONE then
		arg0_16:ClearMove()
	end

	arg0_16.animator:SetState(arg1_16)

	if arg1_16 == CourtYardShip.STATE_TOUCH then
		arg0_16:ClearChatAnimation()
		arg0_16:PlayChatAnim()
	end
end

function var0_0.PlayChatAnim(arg0_17, arg1_17, arg2_17, arg3_17)
	arg3_17 = defaultValue(arg3_17, true)
	arg2_17 = defaultValue(arg2_17, 0)
	arg1_17 = defaultValue(arg1_17, Vector3(2, 2, 2))

	local var0_17 = LeanTween.scale(go(arg0_17.chatTF), arg1_17, 0.5):setEase(LeanTweenType.easeOutBack):setDelay(arg2_17)

	if not arg3_17 then
		return
	end

	var0_17:setOnComplete(System.Action(function()
		arg0_17:PlayChatAnim(Vector3(0, 0, 0), 2, false)
	end))
end

function var0_0.ClearChatAnimation(arg0_19)
	if LeanTween.isTweening(go(arg0_19.chatTF)) then
		LeanTween.cancel(go(arg0_19.chatTF))
	end

	arg0_19.chatTF.localScale = Vector3.zero
end

function var0_0.OnUpdateInteraction(arg0_20, arg1_20)
	local var0_20 = arg1_20.action

	arg0_20.animator:PlayInteractioAnim(var0_20)
end

function var0_0.OnAnimtionFinish(arg0_21, arg1_21)
	arg0_21:Emit("ShipAnimtionFinish", arg0_21.data.id, arg1_21)
end

function var0_0.OnMove(arg0_22, arg1_22, arg2_22)
	arg0_22:ClearMove()

	local var0_22 = arg0_22.data:GetPosition()
	local var1_22 = CourtYardCalcUtil.Map2Local(arg1_22)
	local var2_22 = arg0_22.data:GetMoveTime()
	local var3_22 = arg1_22.x < var0_22.x and arg1_22.y == var0_22.y or arg1_22.x == var0_22.x and arg1_22.y > var0_22.y

	arg0_22.model.transform.localScale = Vector3(var3_22 and -1 or 1, 1, 1)

	local var4_22 = Vector3(var1_22.x, var1_22.y, 0) + arg2_22
	local var5_22 = CourtYardCalcUtil.TrPosition2LocalPos(arg0_22:GetParentTF(), arg0_22._tf.parent, var4_22)

	LeanTween.moveLocal(arg0_22._go, var5_22, var2_22)

	for iter0_22 = 1, arg0_22.interactionTF.childCount do
		local var6_22 = arg0_22.interactionTF:GetChild(iter0_22 - 1)

		var6_22.localScale = Vector3(math.abs(var6_22.localScale.x), var6_22.localScale.y, var6_22.localScale.z)
	end

	arg0_22.interactionTF.localScale = arg0_22.model.transform.localScale
end

function var0_0.OnAddAward(arg0_23, arg1_23, arg2_23)
	if arg2_23 == 3 and arg1_23 <= 0 then
		return
	end

	for iter0_23, iter1_23 in pairs(arg0_23.additionTFs) do
		setActive(iter1_23, arg2_23 == iter0_23)
	end

	local var0_23 = arg0_23.additionTFs[arg2_23]

	if arg2_23 ~= 1 then
		arg1_23 = ""
	end

	setText(var0_23:Find("Text"), arg1_23 or "")

	if arg2_23 == 2 and arg0_23:GetView().poolMgr:GetHeartPool() then
		local var1_23 = arg0_23:GetView().poolMgr:GetHeartPool():Dequeue()

		var1_23.transform:SetParent(arg0_23._tf, false)

		tf(var1_23).localPosition = Vector3(0, 200, -100)
		tf(var1_23).localScale = Vector3(100, 100, 100)
	end

	local var2_23 = 1 / var1_0

	if CourtYardCalcUtil.GetTransformSign(arg0_23._tf, arg0_23.rect) < 0 then
		arg0_23.additionTF.localScale = Vector3(-var2_23, var2_23, var2_23)
	end

	LeanTween.cancel(arg0_23.additionTF.gameObject)

	arg0_23.additionTF.transform.localPosition = arg0_23.additionTFPos

	LeanTween.moveY(rtf(arg0_23.additionTF), arg0_23.additionTFPos.y + 110, 1.2):setOnComplete(System.Action(function()
		arg0_23.additionTF.localScale = Vector3(var2_23, var2_23, var2_23)

		setActive(var0_23, false)
	end))
end

function var0_0.UpdateBubble(arg0_25, arg1_25, arg2_25)
	setActive(arg1_25, arg2_25 ~= 0)

	if LeanTween.isTweening(arg1_25.gameObject) then
		LeanTween.cancel(arg1_25.gameObject)
	end

	if arg2_25 ~= 0 then
		arg1_25.localScale = Vector3(2, 2, 0)
	end

	if arg2_25 ~= 0 then
		floatAni(arg1_25, 20, 1)
	end
end

function var0_0.OnInimacyChange(arg0_26, arg1_26)
	arg0_26:UpdateBubble(arg0_26.inimacyBubble, arg1_26)
end

function var0_0.OnCoinChange(arg0_27, arg1_27)
	arg0_27:UpdateBubble(arg0_27.moneyBubble, arg1_27)
end

function var0_0.ClearMove(arg0_28)
	LeanTween.cancel(arg0_28._go)
end

function var0_0.WillInterAction(arg0_29, arg1_29)
	return
end

function var0_0.StartInterAction(arg0_30, arg1_30)
	setActive(arg0_30.shadow, false)

	local var0_30 = arg1_30:GetOffset()

	setAnchoredPosition(arg0_30._tf, var0_30)

	local var1_30 = arg1_30:GetOwner():GetNormalDirection()
	local var2_30 = arg1_30:GetScale()

	arg0_30.model.localScale = Vector3(var1_30 * var2_30.x, var2_30.y, var2_30.z)

	arg0_30:AdjustYForInteraction()
end

function var0_0.StopInterAction(arg0_31)
	setActive(arg0_31.shadow, true)
	arg0_31:ResetTransform()
	arg0_31:ResetYForInteraction()
end

function var0_0.ResetTransform(arg0_32)
	arg0_32._tf.localScale = Vector3(var1_0, var1_0, 1)
	arg0_32._tf.localEulerAngles = Vector3.zero
end

function var0_0.HideAttachment(arg0_33, arg1_33)
	if arg0_33.role then
		arg0_33.role:SetVisible(not arg1_33)
	end
end

function var0_0.OnDispose(arg0_34)
	var0_0.super.OnDispose(arg0_34)
	arg0_34:ClearChatAnimation()
	arg0_34:ResetTransform()

	if arg0_34.animator then
		arg0_34.animator:Dispose()

		arg0_34.animator = nil
	end

	if arg0_34.spineAnimUI then
		arg0_34.spineAnimUI:SetActionCallBack(nil)

		arg0_34.spineAnimUI = nil
	end

	arg0_34:ClearMove()

	if arg0_34.role then
		arg0_34.role:Dispose()

		arg0_34.role = nil
	end
end

function var0_0.OnDestroy(arg0_35)
	arg0_35:GetView().poolMgr:GetShipPool():Enqueue(arg0_35._go)
end

return var0_0
