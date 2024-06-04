local var0 = class("StoryTimer")

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.duration = arg2
	arg0.func = arg1
	arg0.loop = arg3
end

function var0.Start(arg0)
	arg0.passed = 0
	arg0.running = true
	arg0.paused = nil

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
end

function var0.Pause(arg0)
	arg0.paused = true
end

function var0.Resume(arg0)
	arg0.paused = nil
end

function var0.Stop(arg0)
	if not arg0.running then
		return
	end

	arg0.running = false
	arg0.paused = nil
	arg0.passed = 0

	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end
end

function var0.Update(arg0)
	if not arg0.running or arg0.paused then
		return
	end

	arg0.passed = arg0.passed + Time.deltaTime

	if arg0.passed >= arg0.duration then
		arg0.passed = 0

		arg0.func()

		arg0.loop = arg0.loop - 1
	end

	if arg0.loop == 0 then
		arg0:Stop()
	end
end

return var0
