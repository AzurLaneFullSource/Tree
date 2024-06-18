local var0_0 = class("CourtYardFeastShipModule", import(".CourtYardShipModule"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.feastAttachments = arg0_1._tf:Find("feastAttachments")
	arg0_1.bubbles = {
		arg0_1._tf:Find("feastAttachments/greet"),
		arg0_1._tf:Find("feastAttachments/drink"),
		arg0_1._tf:Find("feastAttachments/eat"),
		arg0_1._tf:Find("feastAttachments/dance"),
		arg0_1._tf:Find("feastAttachments/sleep")
	}
	arg0_1.expressList = {
		arg0_1._tf:Find("feastAttachments/express/1"),
		arg0_1._tf:Find("feastAttachments/express/2"),
		arg0_1._tf:Find("feastAttachments/express/3"),
		arg0_1._tf:Find("feastAttachments/express/4")
	}
	arg0_1.chatBubble = arg0_1._tf:Find("feastAttachments/chat")
	arg0_1.chatBubbleTxt = arg0_1._tf:Find("feastAttachments/chat/Text"):GetComponent(typeof(Text))
	arg0_1.specialMark = arg0_1._tf:Find("feastAttachments/specialmark")

	setActive(arg0_1.chatBubble, false)
	setParent(arg0_1.specialMark, arg0_1._tf)
	arg0_1.specialMark:SetAsFirstSibling()

	arg0_1.specialMark.localScale = Vector3(2, 2, 1)

	arg0_1:InitMark()

	arg0_1.timers = {}
end

function var0_0.InitMark(arg0_2)
	setActive(arg0_2.specialMark, arg0_2.data:IsSpecial())
	arg0_2:OnFeastBubbleChange(arg0_2.data.bubble)

	arg0_2.bubbles[1]:GetComponent(typeof(Image)).raycastTarget = true

	onButton(arg0_2, arg0_2.bubbles[1], function()
		triggerButton(arg0_2.clickTF)
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_4)
	var0_0.super.AddListeners(arg0_4)
	arg0_4:AddListener(CourtYardEvent.FEAST_SHIP_BUBBLE_CHANGE, arg0_4.OnFeastBubbleChange)
	arg0_4:AddListener(CourtYardEvent.FEAST_SHIP_CHAT_CHANGE, arg0_4.OnFeastChatChange)
	arg0_4:AddListener(CourtYardEvent.FEAST_SHIP_BUBBLE_INTERACTION, arg0_4.OnFeastShipBubbleInterAction)
	arg0_4:AddListener(CourtYardEvent.FEAST_SHIP_SHOW_EXPRESS, arg0_4.OnFeastShipShowExpress)
end

function var0_0.RemoveListeners(arg0_5)
	var0_0.super.RemoveListeners(arg0_5)
	arg0_5:RemoveListener(CourtYardEvent.FEAST_SHIP_BUBBLE_CHANGE, arg0_5.OnFeastBubbleChange)
	arg0_5:RemoveListener(CourtYardEvent.FEAST_SHIP_CHAT_CHANGE, arg0_5.OnFeastChatChange)
	arg0_5:RemoveListener(CourtYardEvent.FEAST_SHIP_BUBBLE_INTERACTION, arg0_5.OnFeastShipBubbleInterAction)
	arg0_5:RemoveListener(CourtYardEvent.FEAST_SHIP_SHOW_EXPRESS, arg0_5.OnFeastShipShowExpress)
end

function var0_0.OnFeastShipShowExpress(arg0_6, arg1_6)
	local var0_6 = arg0_6.expressList[arg1_6]

	if var0_6 then
		arg0_6:ClearChatAnimation()
		arg0_6:PlayExpressAnim(var0_6)
	end
end

function var0_0.PlayExpressAnim(arg0_7, arg1_7, arg2_7, arg3_7)
	arg3_7 = defaultValue(arg3_7, 0)
	arg2_7 = defaultValue(arg2_7, Vector3(1, 1, 1))

	LeanTween.scale(go(arg1_7), arg2_7, 0.5):setEase(LeanTweenType.easeOutBack):setDelay(arg3_7):setOnComplete(System.Action(function()
		arg0_7:PlayExpressAnim(arg1_7, Vector3(0, 0, 0), 2)
	end))
end

function var0_0.ClearChatAnimation(arg0_9)
	var0_0.super.ClearChatAnimation(arg0_9)

	for iter0_9, iter1_9 in ipairs(arg0_9.expressList or {}) do
		if LeanTween.isTweening(iter1_9.gameObject) then
			LeanTween.cancel(iter1_9.gameObject)
		end

		iter1_9.localScale = Vector3.zero
	end
end

function var0_0.OnFeastBubbleChange(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(arg0_10.bubbles) do
		setActive(iter1_10, iter0_10 == arg1_10)
	end
end

function var0_0.OnFeastChatChange(arg0_11, arg1_11)
	local var0_11 = arg1_11 ~= ""

	setActive(arg0_11.chatBubble, var0_11)

	arg0_11.chatBubbleTxt.text = arg1_11

	arg0_11:RemoveDisappearTimer()

	if var0_11 then
		arg0_11:DisappearTimer()
	end
end

local var1_0 = {
	"AiXin",
	"XinXin",
	"XinXin",
	"YinFu",
	"Zzz"
}

function var0_0.OnFeastShipBubbleInterAction(arg0_12, arg1_12)
	local var0_12 = arg0_12:GetView().poolMgr
	local var1_12 = var1_0[arg1_12] or var1_0[1]
	local var2_12 = var0_12["Get" .. var1_12 .. "Pool"](var0_12):Dequeue()

	var2_12.transform:SetParent(arg0_12._tf, false)

	tf(var2_12).localPosition = Vector3(0, 100, -100)
	tf(var2_12).localScale = Vector3(3, 3, 3)

	local var3_12 = #arg0_12.timers + 1
	local var4_12

	arg0_12.cg.blocksRaycasts = false
	var4_12 = Timer.New(function()
		var4_12:Stop()
		table.remove(arg0_12.timers, var3_12)
		arg0_12:Emit("ShipBubbleInterActionFinish", arg0_12.data.id)

		arg0_12.cg.blocksRaycasts = true
	end, 0.01, 1)

	var4_12:Start()
	table.insert(arg0_12.timers, var4_12)
end

function var0_0.DisappearTimer(arg0_14)
	arg0_14.disappearTimer = Timer.New(function()
		setActive(arg0_14.chatBubble, false)
	end, CourtYardConst.FEAST_CHAT_TIME, 1)

	arg0_14.disappearTimer:Start()
end

function var0_0.RemoveDisappearTimer(arg0_16)
	if arg0_16.disappearTimer then
		arg0_16.disappearTimer:Stop()

		arg0_16.disappearTimer = nil
	end
end

function var0_0.OnStateChange(arg0_17, arg1_17, arg2_17)
	var0_0.super.OnStateChange(arg0_17, arg1_17, arg2_17)

	local var0_17 = false

	if arg0_17.data:IsSpecial() and (arg1_17 == CourtYardShip.STATE_IDLE or arg1_17 == CourtYardShip.STATE_MOVE or arg1_17 == CourtYardShip.STATE_MOVING_ZERO or arg1_17 == CourtYardShip.STATE_MOVING_HALF or arg1_17 == CourtYardShip.STATE_MOVING_ONE or arg1_17 == CourtYardShip.STATE_TOUCH or arg1_17 == CourtYardShip.STATE_GETAWARD) then
		var0_17 = true
	end

	setActive(arg0_17.specialMark, var0_17)

	local var1_17 = arg1_17 == CourtYardShip.STATE_INTERACT

	arg0_17.feastAttachments.localPosition = var1_17 and Vector3(0, -85, 0) or Vector3.zero
end

function var0_0.OnDestroy(arg0_18)
	arg0_18.cg.blocksRaycasts = true

	for iter0_18, iter1_18 in ipairs(arg0_18.timers or {}) do
		iter1_18:Stop()
	end

	arg0_18.timers = nil

	arg0_18:RemoveDisappearTimer()

	if arg0_18.feastAttachments then
		setParent(arg0_18.specialMark, arg0_18.feastAttachments)

		arg0_18.specialMark.localScale = Vector3.one

		Object.Destroy(arg0_18.feastAttachments.gameObject)

		arg0_18.feastAttachments = nil
	end

	var0_0.super.OnDestroy(arg0_18)
end

return var0_0
