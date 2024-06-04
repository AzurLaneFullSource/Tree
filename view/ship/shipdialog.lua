local var0 = class("ShipDialog")
local var1 = 0.3
local var2 = 2

function var0.Ctor(arg0, arg1, arg2)
	arg0.dialog = arg1
	arg0.label = arg0.dialog.gameObject:GetComponentInChildren(typeof(Text))
	arg0.content = arg2
	arg0.started = false
end

function var0.loop(arg0, arg1, arg2, arg3)
	arg0.timer = Timer.New(function()
		arg0:display()
	end, arg2 + arg3 * math.random(), arg1)
end

function var0.display(arg0)
	if arg0.chatOn then
		return
	end

	arg0.chatOn = true
	rtf(arg0.dialog).localScale = Vector3.New(0, 0, 1)
	arg0.label.text = arg0.content
	arg0.label.alignment = #arg0.content > CHAT_POP_STR_LEN and TextAnchor.MiddleLeft or TextAnchor.MiddleCenter

	LeanTween.scale(rtf(arg0.dialog), Vector3.New(1, 1, 1), var1):setEase(LeanTweenType.easeOutBack)
	LeanTween.scale(rtf(arg0.dialog), Vector3.New(0, 0, 1), var1):setOnComplete(System.Action(function()
		arg0.chatOn = false
	end)):setDelay(var1 + var2):setEase(LeanTweenType.easeInBack)
end

function var0.play(arg0)
	if not arg0.started then
		arg0.started = true

		arg0.timer:Start()
	else
		arg0.timer:Resume()
	end
end

function var0.pause(arg0)
	if arg0.started then
		arg0.timer:Pause()
	end
end

function var0.stop(arg0)
	arg0.timer:Stop()

	arg0.started = false
end

return var0
