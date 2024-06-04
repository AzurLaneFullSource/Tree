local var0 = class("CourtYardFeastShipModule", import(".CourtYardShipModule"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.feastAttachments = arg0._tf:Find("feastAttachments")
	arg0.bubbles = {
		arg0._tf:Find("feastAttachments/greet"),
		arg0._tf:Find("feastAttachments/drink"),
		arg0._tf:Find("feastAttachments/eat"),
		arg0._tf:Find("feastAttachments/dance"),
		arg0._tf:Find("feastAttachments/sleep")
	}
	arg0.expressList = {
		arg0._tf:Find("feastAttachments/express/1"),
		arg0._tf:Find("feastAttachments/express/2"),
		arg0._tf:Find("feastAttachments/express/3"),
		arg0._tf:Find("feastAttachments/express/4")
	}
	arg0.chatBubble = arg0._tf:Find("feastAttachments/chat")
	arg0.chatBubbleTxt = arg0._tf:Find("feastAttachments/chat/Text"):GetComponent(typeof(Text))
	arg0.specialMark = arg0._tf:Find("feastAttachments/specialmark")

	setActive(arg0.chatBubble, false)
	setParent(arg0.specialMark, arg0._tf)
	arg0.specialMark:SetAsFirstSibling()

	arg0.specialMark.localScale = Vector3(2, 2, 1)

	arg0:InitMark()

	arg0.timers = {}
end

function var0.InitMark(arg0)
	setActive(arg0.specialMark, arg0.data:IsSpecial())
	arg0:OnFeastBubbleChange(arg0.data.bubble)

	arg0.bubbles[1]:GetComponent(typeof(Image)).raycastTarget = true

	onButton(arg0, arg0.bubbles[1], function()
		triggerButton(arg0.clickTF)
	end, SFX_PANEL)
end

function var0.AddListeners(arg0)
	var0.super.AddListeners(arg0)
	arg0:AddListener(CourtYardEvent.FEAST_SHIP_BUBBLE_CHANGE, arg0.OnFeastBubbleChange)
	arg0:AddListener(CourtYardEvent.FEAST_SHIP_CHAT_CHANGE, arg0.OnFeastChatChange)
	arg0:AddListener(CourtYardEvent.FEAST_SHIP_BUBBLE_INTERACTION, arg0.OnFeastShipBubbleInterAction)
	arg0:AddListener(CourtYardEvent.FEAST_SHIP_SHOW_EXPRESS, arg0.OnFeastShipShowExpress)
end

function var0.RemoveListeners(arg0)
	var0.super.RemoveListeners(arg0)
	arg0:RemoveListener(CourtYardEvent.FEAST_SHIP_BUBBLE_CHANGE, arg0.OnFeastBubbleChange)
	arg0:RemoveListener(CourtYardEvent.FEAST_SHIP_CHAT_CHANGE, arg0.OnFeastChatChange)
	arg0:RemoveListener(CourtYardEvent.FEAST_SHIP_BUBBLE_INTERACTION, arg0.OnFeastShipBubbleInterAction)
	arg0:RemoveListener(CourtYardEvent.FEAST_SHIP_SHOW_EXPRESS, arg0.OnFeastShipShowExpress)
end

function var0.OnFeastShipShowExpress(arg0, arg1)
	local var0 = arg0.expressList[arg1]

	if var0 then
		arg0:ClearChatAnimation()
		arg0:PlayExpressAnim(var0)
	end
end

function var0.PlayExpressAnim(arg0, arg1, arg2, arg3)
	arg3 = defaultValue(arg3, 0)
	arg2 = defaultValue(arg2, Vector3(1, 1, 1))

	LeanTween.scale(go(arg1), arg2, 0.5):setEase(LeanTweenType.easeOutBack):setDelay(arg3):setOnComplete(System.Action(function()
		arg0:PlayExpressAnim(arg1, Vector3(0, 0, 0), 2)
	end))
end

function var0.ClearChatAnimation(arg0)
	var0.super.ClearChatAnimation(arg0)

	for iter0, iter1 in ipairs(arg0.expressList or {}) do
		if LeanTween.isTweening(iter1.gameObject) then
			LeanTween.cancel(iter1.gameObject)
		end

		iter1.localScale = Vector3.zero
	end
end

function var0.OnFeastBubbleChange(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.bubbles) do
		setActive(iter1, iter0 == arg1)
	end
end

function var0.OnFeastChatChange(arg0, arg1)
	local var0 = arg1 ~= ""

	setActive(arg0.chatBubble, var0)

	arg0.chatBubbleTxt.text = arg1

	arg0:RemoveDisappearTimer()

	if var0 then
		arg0:DisappearTimer()
	end
end

local var1 = {
	"AiXin",
	"XinXin",
	"XinXin",
	"YinFu",
	"Zzz"
}

function var0.OnFeastShipBubbleInterAction(arg0, arg1)
	local var0 = arg0:GetView().poolMgr
	local var1 = var1[arg1] or var1[1]
	local var2 = var0["Get" .. var1 .. "Pool"](var0):Dequeue()

	var2.transform:SetParent(arg0._tf, false)

	tf(var2).localPosition = Vector3(0, 100, -100)
	tf(var2).localScale = Vector3(3, 3, 3)

	local var3 = #arg0.timers + 1
	local var4

	arg0.cg.blocksRaycasts = false
	var4 = Timer.New(function()
		var4:Stop()
		table.remove(arg0.timers, var3)
		arg0:Emit("ShipBubbleInterActionFinish", arg0.data.id)

		arg0.cg.blocksRaycasts = true
	end, 0.01, 1)

	var4:Start()
	table.insert(arg0.timers, var4)
end

function var0.DisappearTimer(arg0)
	arg0.disappearTimer = Timer.New(function()
		setActive(arg0.chatBubble, false)
	end, CourtYardConst.FEAST_CHAT_TIME, 1)

	arg0.disappearTimer:Start()
end

function var0.RemoveDisappearTimer(arg0)
	if arg0.disappearTimer then
		arg0.disappearTimer:Stop()

		arg0.disappearTimer = nil
	end
end

function var0.OnStateChange(arg0, arg1, arg2)
	var0.super.OnStateChange(arg0, arg1, arg2)

	local var0 = false

	if arg0.data:IsSpecial() and (arg1 == CourtYardShip.STATE_IDLE or arg1 == CourtYardShip.STATE_MOVE or arg1 == CourtYardShip.STATE_MOVING_ZERO or arg1 == CourtYardShip.STATE_MOVING_HALF or arg1 == CourtYardShip.STATE_MOVING_ONE or arg1 == CourtYardShip.STATE_TOUCH or arg1 == CourtYardShip.STATE_GETAWARD) then
		var0 = true
	end

	setActive(arg0.specialMark, var0)

	local var1 = arg1 == CourtYardShip.STATE_INTERACT

	arg0.feastAttachments.localPosition = var1 and Vector3(0, -85, 0) or Vector3.zero
end

function var0.OnDestroy(arg0)
	arg0.cg.blocksRaycasts = true

	for iter0, iter1 in ipairs(arg0.timers or {}) do
		iter1:Stop()
	end

	arg0.timers = nil

	arg0:RemoveDisappearTimer()

	if arg0.feastAttachments then
		setParent(arg0.specialMark, arg0.feastAttachments)

		arg0.specialMark.localScale = Vector3.one

		Object.Destroy(arg0.feastAttachments.gameObject)

		arg0.feastAttachments = nil
	end

	var0.super.OnDestroy(arg0)
end

return var0
