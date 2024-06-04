local var0 = class("CourtYardShipModule", import("..CourtYardPlaceableModule"))
local var1 = 1

function var0.Ctor(arg0, arg1, arg2, arg3)
	var1 = CourtYardConst.SHIP_SCALE

	var0.super.Ctor(arg0, arg1, arg2)

	arg0.role = arg3
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	pg.ViewUtils.SetLayer(arg0._tf, Layer.UI)
	arg0._tf:SetParent(arg0.floor)

	arg0.model = arg0._tf:Find("model")
	arg0.model.localPosition = Vector3(0, 25, 0)
	arg0.shadow = arg0._tf:Find("shadow")
	arg0.shadow.localPosition = Vector3(0, 25, 0)

	arg0.shadow:SetAsFirstSibling()

	arg0.spineAnimUI = arg0.role.model:GetComponent(typeof(SpineAnimUI))
	arg0.clickTF = arg0._tf:Find("click")
	arg0.chatTF = arg0._tf:Find("chat")
	arg0.chatTF.localScale = Vector3.zero
	arg0.additionTF = arg0._tf:Find("addition")
	arg0.additionTFs = {
		findTF(arg0.additionTF, "money"),
		findTF(arg0.additionTF, "intimacy"),
		findTF(arg0.additionTF, "exp")
	}
	arg0.additionTFPos = Vector3(0, 250, 0)
	arg0.inimacyBubble = arg0._tf:Find("intimacy")
	arg0.moneyBubble = arg0._tf:Find("money")
	arg0.animator = CourtYardShipAnimatorAgent.New(arg0)
	arg0._tf.localScale = Vector3(var1, var1, 1)
	arg0._tf:Find("grids").localScale = Vector3(1 / var1, 1 / var1, 1)

	arg0.animator:SetState(arg0.data:GetState())
	arg0:UpdateBubble(arg0.inimacyBubble, arg0.data.inimacy)
	arg0:UpdateBubble(arg0.moneyBubble, arg0.data.coin)
	arg0:InitAttachment()
	setActive(arg0.shadow, true)
end

function var0.AdjustYForInteraction(arg0)
	arg0.model.localPosition = Vector3(0, 0, 0)
end

function var0.ResetYForInteraction(arg0)
	arg0.model.localPosition = Vector3(0, 25, 0)
end

function var0.GetSpine(arg0)
	return arg0.spineAnimUI.gameObject.transform
end

function var0.AddListeners(arg0)
	arg0:AddListener(CourtYardEvent.SHIP_STATE_CHANGE, arg0.OnStateChange)
	arg0:AddListener(CourtYardEvent.SHIP_MOVE, arg0.OnMove)
	arg0:AddListener(CourtYardEvent.SHIP_POSITION_CHANGE, arg0.OnUpdatePosition)
	arg0:AddListener(CourtYardEvent.SHIP_GET_AWARD, arg0.OnAddAward)
	arg0:AddListener(CourtYardEvent.SHIP_INIMACY_CHANGE, arg0.OnInimacyChange)
	arg0:AddListener(CourtYardEvent.SHIP_COIN_CHANGE, arg0.OnCoinChange)
	arg0:AddListener(CourtYardEvent.SHIP_UPDATE_INTERACTION, arg0.OnUpdateInteraction)
	arg0:AddListener(CourtYardEvent.SHIP_WILL_INTERACTION, arg0.WillInterAction)
	arg0:AddListener(CourtYardEvent.SHIP_START_INTERACTION, arg0.StartInterAction)
	arg0:AddListener(CourtYardEvent.SHIP_STOP_INTERACTION, arg0.StopInterAction)
end

function var0.RemoveListeners(arg0)
	arg0:RemoveListener(CourtYardEvent.SHIP_STATE_CHANGE, arg0.OnStateChange)
	arg0:RemoveListener(CourtYardEvent.SHIP_MOVE, arg0.OnMove)
	arg0:RemoveListener(CourtYardEvent.SHIP_POSITION_CHANGE, arg0.OnUpdatePosition)
	arg0:RemoveListener(CourtYardEvent.SHIP_GET_AWARD, arg0.OnAddAward)
	arg0:RemoveListener(CourtYardEvent.SHIP_INIMACY_CHANGE, arg0.OnInimacyChange)
	arg0:RemoveListener(CourtYardEvent.SHIP_COIN_CHANGE, arg0.OnCoinChange)
	arg0:RemoveListener(CourtYardEvent.SHIP_UPDATE_INTERACTION, arg0.OnUpdateInteraction)
	arg0:RemoveListener(CourtYardEvent.SHIP_WILL_INTERACTION, arg0.WillInterAction)
	arg0:RemoveListener(CourtYardEvent.SHIP_START_INTERACTION, arg0.StartInterAction)
	arg0:RemoveListener(CourtYardEvent.SHIP_STOP_INTERACTION, arg0.StopInterAction)
end

function var0.InitAttachment(arg0)
	onButton(arg0, arg0.clickTF, function()
		arg0:Emit("TouchShip", arg0.data.id)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BOAT_CLICK)
	end)
	onButton(arg0, arg0.inimacyBubble, function()
		arg0:Emit("GetShipInimacy", arg0.data.id)
	end, SFX_PANEL)
	onButton(arg0, arg0.moneyBubble, function()
		arg0:Emit("GetShipCoin", arg0.data.id)
	end, SFX_PANEL)
end

function var0.OnBeginDrag(arg0)
	if not arg0:GetView():GetCurrStorey():AllModulesAreCompletion() then
		return
	end

	arg0:Emit("DragShip", arg0.data.id)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BOAT_DRAG)
end

function var0.OnDragging(arg0, arg1)
	arg0:Emit("DragingShip", arg0.data.id, arg1)
end

function var0.OnDragEnd(arg0, arg1)
	arg0:Emit("DragShipEnd", arg0.data.id, arg1)
end

function var0.OnUpdatePosition(arg0, arg1, arg2)
	arg0:UpdatePosition(arg1, arg2)
end

function var0.OnStateChange(arg0, arg1, arg2)
	if arg1 ~= CourtYardShip.STATE_MOVING_ZERO and arg1 ~= CourtYardShip.STATE_MOVING_HALF and arg1 ~= CourtYardShip.STATE_MOVING_ONE then
		arg0:ClearMove()
	end

	arg0.animator:SetState(arg1)

	if arg1 == CourtYardShip.STATE_TOUCH then
		arg0:ClearChatAnimation()
		arg0:PlayChatAnim()
	end
end

function var0.PlayChatAnim(arg0, arg1, arg2, arg3)
	arg3 = defaultValue(arg3, true)
	arg2 = defaultValue(arg2, 0)
	arg1 = defaultValue(arg1, Vector3(2, 2, 2))

	local var0 = LeanTween.scale(go(arg0.chatTF), arg1, 0.5):setEase(LeanTweenType.easeOutBack):setDelay(arg2)

	if not arg3 then
		return
	end

	var0:setOnComplete(System.Action(function()
		arg0:PlayChatAnim(Vector3(0, 0, 0), 2, false)
	end))
end

function var0.ClearChatAnimation(arg0)
	if LeanTween.isTweening(go(arg0.chatTF)) then
		LeanTween.cancel(go(arg0.chatTF))
	end

	arg0.chatTF.localScale = Vector3.zero
end

function var0.OnUpdateInteraction(arg0, arg1)
	local var0 = arg1.action

	arg0.animator:PlayInteractioAnim(var0)
end

function var0.OnAnimtionFinish(arg0, arg1)
	arg0:Emit("ShipAnimtionFinish", arg0.data.id, arg1)
end

function var0.OnMove(arg0, arg1, arg2)
	arg0:ClearMove()

	local var0 = arg0.data:GetPosition()
	local var1 = CourtYardCalcUtil.Map2Local(arg1)
	local var2 = arg0.data:GetMoveTime()
	local var3 = arg1.x < var0.x and arg1.y == var0.y or arg1.x == var0.x and arg1.y > var0.y

	arg0.model.transform.localScale = Vector3(var3 and -1 or 1, 1, 1)

	local var4 = Vector3(var1.x, var1.y, 0) + arg2
	local var5 = CourtYardCalcUtil.TrPosition2LocalPos(arg0:GetParentTF(), arg0._tf.parent, var4)

	LeanTween.moveLocal(arg0._go, var5, var2)

	for iter0 = 1, arg0.interactionTF.childCount do
		local var6 = arg0.interactionTF:GetChild(iter0 - 1)

		var6.localScale = Vector3(math.abs(var6.localScale.x), var6.localScale.y, var6.localScale.z)
	end

	arg0.interactionTF.localScale = arg0.model.transform.localScale
end

function var0.OnAddAward(arg0, arg1, arg2)
	if arg2 == 3 and arg1 <= 0 then
		return
	end

	for iter0, iter1 in pairs(arg0.additionTFs) do
		setActive(iter1, arg2 == iter0)
	end

	local var0 = arg0.additionTFs[arg2]

	if arg2 ~= 1 then
		arg1 = ""
	end

	setText(var0:Find("Text"), arg1 or "")

	if arg2 == 2 and arg0:GetView().poolMgr:GetHeartPool() then
		local var1 = arg0:GetView().poolMgr:GetHeartPool():Dequeue()

		var1.transform:SetParent(arg0._tf, false)

		tf(var1).localPosition = Vector3(0, 200, -100)
		tf(var1).localScale = Vector3(100, 100, 100)
	end

	local var2 = 1 / var1

	if CourtYardCalcUtil.GetTransformSign(arg0._tf, arg0.rect) < 0 then
		arg0.additionTF.localScale = Vector3(-var2, var2, var2)
	end

	LeanTween.cancel(arg0.additionTF.gameObject)

	arg0.additionTF.transform.localPosition = arg0.additionTFPos

	LeanTween.moveY(rtf(arg0.additionTF), arg0.additionTFPos.y + 110, 1.2):setOnComplete(System.Action(function()
		arg0.additionTF.localScale = Vector3(var2, var2, var2)

		setActive(var0, false)
	end))
end

function var0.UpdateBubble(arg0, arg1, arg2)
	setActive(arg1, arg2 ~= 0)

	if LeanTween.isTweening(arg1.gameObject) then
		LeanTween.cancel(arg1.gameObject)
	end

	if arg2 ~= 0 then
		arg1.localScale = Vector3(2, 2, 0)
	end

	if arg2 ~= 0 then
		floatAni(arg1, 20, 1)
	end
end

function var0.OnInimacyChange(arg0, arg1)
	arg0:UpdateBubble(arg0.inimacyBubble, arg1)
end

function var0.OnCoinChange(arg0, arg1)
	arg0:UpdateBubble(arg0.moneyBubble, arg1)
end

function var0.ClearMove(arg0)
	LeanTween.cancel(arg0._go)
end

function var0.WillInterAction(arg0, arg1)
	return
end

function var0.StartInterAction(arg0, arg1)
	setActive(arg0.shadow, false)

	local var0 = arg1:GetOffset()

	setAnchoredPosition(arg0._tf, var0)

	local var1 = arg1:GetOwner():GetNormalDirection()
	local var2 = arg1:GetScale()

	arg0.model.localScale = Vector3(var1 * var2.x, var2.y, var2.z)

	arg0:AdjustYForInteraction()
end

function var0.StopInterAction(arg0)
	setActive(arg0.shadow, true)
	arg0:ResetTransform()
	arg0:ResetYForInteraction()
end

function var0.ResetTransform(arg0)
	arg0._tf.localScale = Vector3(var1, var1, 1)
	arg0._tf.localEulerAngles = Vector3.zero
end

function var0.HideAttachment(arg0, arg1)
	if arg0.role then
		arg0.role:SetVisible(not arg1)
	end
end

function var0.OnDispose(arg0)
	var0.super.OnDispose(arg0)
	arg0:ClearChatAnimation()
	arg0:ResetTransform()

	if arg0.animator then
		arg0.animator:Dispose()

		arg0.animator = nil
	end

	if arg0.spineAnimUI then
		arg0.spineAnimUI:SetActionCallBack(nil)

		arg0.spineAnimUI = nil
	end

	arg0:ClearMove()

	if arg0.role then
		arg0.role:Dispose()

		arg0.role = nil
	end
end

function var0.OnDestroy(arg0)
	arg0:GetView().poolMgr:GetShipPool():Enqueue(arg0._go)
end

return var0
