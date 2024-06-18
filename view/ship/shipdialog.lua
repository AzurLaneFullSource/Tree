local var0_0 = class("ShipDialog")
local var1_0 = 0.3
local var2_0 = 2

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.dialog = arg1_1
	arg0_1.label = arg0_1.dialog.gameObject:GetComponentInChildren(typeof(Text))
	arg0_1.content = arg2_1
	arg0_1.started = false
end

function var0_0.loop(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.timer = Timer.New(function()
		arg0_2:display()
	end, arg2_2 + arg3_2 * math.random(), arg1_2)
end

function var0_0.display(arg0_4)
	if arg0_4.chatOn then
		return
	end

	arg0_4.chatOn = true
	rtf(arg0_4.dialog).localScale = Vector3.New(0, 0, 1)
	arg0_4.label.text = arg0_4.content
	arg0_4.label.alignment = #arg0_4.content > CHAT_POP_STR_LEN and TextAnchor.MiddleLeft or TextAnchor.MiddleCenter

	LeanTween.scale(rtf(arg0_4.dialog), Vector3.New(1, 1, 1), var1_0):setEase(LeanTweenType.easeOutBack)
	LeanTween.scale(rtf(arg0_4.dialog), Vector3.New(0, 0, 1), var1_0):setOnComplete(System.Action(function()
		arg0_4.chatOn = false
	end)):setDelay(var1_0 + var2_0):setEase(LeanTweenType.easeInBack)
end

function var0_0.play(arg0_6)
	if not arg0_6.started then
		arg0_6.started = true

		arg0_6.timer:Start()
	else
		arg0_6.timer:Resume()
	end
end

function var0_0.pause(arg0_7)
	if arg0_7.started then
		arg0_7.timer:Pause()
	end
end

function var0_0.stop(arg0_8)
	arg0_8.timer:Stop()

	arg0_8.started = false
end

return var0_0
