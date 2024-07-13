local var0_0 = class("StoryTimer")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.duration = arg2_1
	arg0_1.func = arg1_1
	arg0_1.loop = arg3_1
end

function var0_0.Start(arg0_2)
	arg0_2.passed = 0
	arg0_2.running = true
	arg0_2.paused = nil

	if not arg0_2.handle then
		arg0_2.handle = UpdateBeat:CreateListener(arg0_2.Update, arg0_2)
	end

	UpdateBeat:AddListener(arg0_2.handle)
end

function var0_0.Pause(arg0_3)
	arg0_3.paused = true
end

function var0_0.Resume(arg0_4)
	arg0_4.paused = nil
end

function var0_0.Stop(arg0_5)
	if not arg0_5.running then
		return
	end

	arg0_5.running = false
	arg0_5.paused = nil
	arg0_5.passed = 0

	if arg0_5.handle then
		UpdateBeat:RemoveListener(arg0_5.handle)
	end
end

function var0_0.Update(arg0_6)
	if not arg0_6.running or arg0_6.paused then
		return
	end

	arg0_6.passed = arg0_6.passed + Time.deltaTime

	if arg0_6.passed >= arg0_6.duration then
		arg0_6.passed = 0

		arg0_6.func()

		arg0_6.loop = arg0_6.loop - 1
	end

	if arg0_6.loop == 0 then
		arg0_6:Stop()
	end
end

return var0_0
