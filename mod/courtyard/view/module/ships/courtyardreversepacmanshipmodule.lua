local var0_0 = class("CourtYardReversePacmanShipModule", import(".CourtYardShipModule"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.chatBubble = arg0_1._tf:Find("reversePacmanAttachments/chat")
	arg0_1.chatBubbleTxt = arg0_1._tf:Find("reversePacmanAttachments/chat/Text"):GetComponent(typeof(Text))

	setActive(arg0_1.chatBubble, false)
end

function var0_0.AddListeners(arg0_2)
	var0_0.super.AddListeners(arg0_2)
	arg0_2:AddListener(CourtYardEvent.REVERSE_PACMAN_CHAT_BUBBLE, arg0_2.OnShowText)
end

function var0_0.RemoveListeners(arg0_3)
	var0_0.super.RemoveListeners(arg0_3)
	arg0_3:RemoveListener(CourtYardEvent.REVERSE_PACMAN_CHAT_BUBBLE, arg0_3.OnShowText)
end

function var0_0.OnShowText(arg0_4, arg1_4)
	local var0_4 = pg.activity_chasing_character[arg0_4.data.roleID]

	if var0_4.random_talk[1] == nil then
		return
	end

	setActive(arg0_4.chatBubble, true)

	local var1_4 = math.random(1, #var0_4.random_talk[2])

	setText(arg0_4.chatBubbleTxt, ShipWordHelper.GetShipWord(var0_4.random_talk[1], var0_4.random_talk[2][var1_4], {}))
	arg0_4:DisappearTimer()
end

function var0_0.DisappearTimer(arg0_5)
	arg0_5.disappearTimer = Timer.New(function()
		setActive(arg0_5.chatBubble, false)
		arg0_5:RemoveDisappearTimer()
	end, CourtYardConst.REVERSE_PACMAN_CHAT_SHOW_TIME, 1)

	arg0_5.disappearTimer:Start()
end

function var0_0.RemoveDisappearTimer(arg0_7)
	if arg0_7.disappearTimer then
		arg0_7.disappearTimer:Stop()

		arg0_7.disappearTimer = nil
	end
end

function var0_0.OnDispose(arg0_8)
	arg0_8:RemoveDisappearTimer()
	var0_0.super.OnDispose(arg0_8)
end

return var0_0
