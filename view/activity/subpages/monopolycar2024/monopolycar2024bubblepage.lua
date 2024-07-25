local var0_0 = class("MonopolyCar2024BubblePage")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.event = arg2_1
	arg0_1._tf = arg1_1
	arg0_1.head = findTF(arg1_1, "head"):GetComponent(typeof(Image))
	arg0_1.content = findTF(arg1_1, "chat/Text"):GetComponent(typeof(Text))
	arg0_1.anim = arg0_1._tf:GetComponent(typeof(Animation))
	arg0_1.animEvent = arg0_1.anim:GetComponent(typeof(DftAniEvent))

	arg0_1.animEvent:SetEndEvent(function()
		setActive(arg0_1._tf, false)
	end)

	arg0_1.showTime = pg.gameset.monopoly2024_bubble_time.key_value

	setActive(arg0_1._tf, false)
end

function var0_0.emit(arg0_3, ...)
	arg0_3.event:emit(...)
end

function var0_0.Show(arg0_4, arg1_4, arg2_4, arg3_4)
	setActive(arg0_4._tf, true)
	arg0_4.anim:Play("anim_monopolycar_bubble_show")

	local var0_4 = GetSpriteFromAtlas("ui/MonopolyCar2024_atlas", arg2_4)

	arg0_4.head.sprite = var0_4

	arg0_4.head:SetNativeSize()

	local var1_4 = pg.activity_event_monopoly_dialogue[arg3_4].dialogue

	arg0_4.content.text = var1_4

	arg0_4:AddTimer()
	arg0_4:emit(MonopolyCar2024Mediator.ON_DIALOGUE, arg1_4, arg3_4)
end

function var0_0.AddTimer(arg0_5)
	arg0_5:RemoveTimer()

	arg0_5.timer = Timer.New(function()
		arg0_5:RemoveTimer()
		arg0_5:Hide()
	end, arg0_5.showTime, 1)

	arg0_5.timer:Start()
end

function var0_0.RemoveTimer(arg0_7)
	if arg0_7.timer then
		arg0_7.timer:Stop()

		arg0_7.timer = nil
	end
end

function var0_0.Hide(arg0_8)
	arg0_8.anim:Play("anim_monopolycar_bubble_hide")
end

function var0_0.Dispose(arg0_9)
	arg0_9:RemoveTimer()
end

return var0_0
