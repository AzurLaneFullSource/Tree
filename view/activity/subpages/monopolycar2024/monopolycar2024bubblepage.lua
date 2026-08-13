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

function var0_0.GetUiAtlas(arg0_3)
	return "ui/MonopolyCar2024_atlas"
end

function var0_0.emit(arg0_4, ...)
	arg0_4.event:emit(...)
end

function var0_0.Show(arg0_5, arg1_5, arg2_5, arg3_5)
	setActive(arg0_5._tf, true)
	arg0_5.anim:Play("anim_monopolycar_bubble_show")

	local var0_5 = GetSpriteFromAtlas(arg0_5:GetUiAtlas(), arg2_5)

	arg0_5.head.sprite = var0_5

	arg0_5.head:SetNativeSize()

	local var1_5 = pg.activity_event_monopoly_dialogue[arg3_5].dialogue

	arg0_5.content.text = var1_5

	arg0_5:AddTimer()
	arg0_5:emit(MonopolyCar2024Mediator.ON_DIALOGUE, arg1_5, arg3_5)
end

function var0_0.AddTimer(arg0_6)
	arg0_6:RemoveTimer()

	arg0_6.timer = Timer.New(function()
		arg0_6:RemoveTimer()
		arg0_6:Hide()
	end, arg0_6.showTime, 1)

	arg0_6.timer:Start()
end

function var0_0.RemoveTimer(arg0_8)
	if arg0_8.timer then
		arg0_8.timer:Stop()

		arg0_8.timer = nil
	end
end

function var0_0.Hide(arg0_9)
	arg0_9.anim:Play("anim_monopolycar_bubble_hide")
end

function var0_0.Dispose(arg0_10)
	arg0_10:RemoveTimer()
end

return var0_0
