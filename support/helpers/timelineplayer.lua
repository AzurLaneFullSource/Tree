local var0_0 = class("TimelinePlayer")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.comDirector = arg1_1:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

	if GetComponent(arg1_1, "TimelineSpeed") then
		arg0_1:SetSpeed(1)
	else
		GetOrAddComponent(arg1_1, "TimelineSpeed")
	end

	arg0_1.signalReceiver = GetOrAddComponent(arg1_1, "DftCommonSignalReceiver")

	arg0_1.signalReceiver:SetCommonEvent(function(arg0_2)
		arg0_1:TriggerEvent(arg0_2)
	end)
	arg0_1.comDirector:Stop()

	arg0_1.comDirector.extrapolationMode = ReflectionHelp.RefGetField(typeof("UnityEngine.Playables.DirectorWrapMode"), "Hold", nil)

	TimelineSupport.InitTimeline(arg0_1.comDirector)
end

function var0_0.Register(arg0_3, arg1_3, arg2_3)
	if arg1_3 then
		arg0_3.comDirector.time = math.clamp(arg1_3, 0, arg0_3.comDirector.duration)
	end

	if arg2_3 then
		arg0_3.triggerFunc = arg2_3
	end
end

function var0_0.TriggerEvent(arg0_4, arg1_4)
	assert(arg0_4.triggerFunc)
	arg0_4.triggerFunc(arg0_4, arg1_4, arg0_4.mark)
end

function var0_0.Start(arg0_5)
	arg0_5.mark = {}

	arg0_5:Play()
end

function var0_0.Play(arg0_6)
	arg0_6.comDirector:Play()
end

function var0_0.Pause(arg0_7)
	arg0_7.comDirector:Pause()
end

function var0_0.Stop(arg0_8)
	arg0_8.comDirector:Stop()
end

function var0_0.SetSpeed(arg0_9, arg1_9)
	setDirectorSpeed(arg0_9.comDirector, arg1_9)
end

function var0_0.SetTime(arg0_10, arg1_10)
	arg0_10.comDirector.time = arg1_10

	arg0_10.comDirector:RebuildGraph()
end

function var0_0.RawSetTime(arg0_11, arg1_11)
	arg0_11.comDirector.time = arg1_11
end

function var0_0.Dispose(arg0_12)
	return
end

return var0_0
