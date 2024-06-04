local var0 = setmetatable
local var1 = UpdateBeat
local var2 = CoUpdateBeat
local var3 = Time

Timer = {
	loop = 1,
	running = false,
	time = 0,
	duration = 1,
	scale = false
}

local var4 = Timer
local var5 = {
	__index = var4
}

function var4.New(arg0, arg1, arg2, arg3)
	assert(arg1 > 0, "定时器间隔不能小于等于0！：" .. arg1)

	arg3 = arg3 or false
	arg2 = arg2 or 1

	return var0({
		running = false,
		func = arg0,
		duration = arg1,
		time = arg1,
		loop = arg2,
		scale = arg3
	}, var5)
end

function var4.Start(arg0)
	assert(arg0.running == false, "对已经启动的定时器执行启动！")

	arg0.running = true
	arg0.paused = nil

	if not arg0.handle then
		arg0.handle = var1:CreateListener(arg0.Update, arg0)
	end

	var1:AddListener(arg0.handle)
end

function var4.Reset(arg0, arg1, arg2, arg3, arg4)
	arg0.duration = arg2 or arg0.duration

	assert(arg0.duration > 0, "定时器间隔不能小于等于0！：" .. arg0.duration)

	arg0.loop = arg3 or arg0.loop
	arg0.scale = arg4 or arg0.scale
	arg0.func = arg1 or arg0.func
	arg0.time = arg2 or arg0.time
	arg0.running = false
	arg0.paused = nil
end

function var4.SetScale(arg0, arg1)
	arg0.scale = arg1
end

function var4.Stop(arg0)
	if not arg0.running then
		return
	end

	arg0.running = false
	arg0.paused = nil
	arg0.time = 0

	if arg0.handle then
		var1:RemoveListener(arg0.handle)
	end
end

function var4.Pause(arg0)
	arg0.paused = true
end

function var4.Resume(arg0)
	arg0.paused = nil
end

function var4.Update(arg0)
	if not arg0.running or arg0.paused then
		return
	end

	local var0 = arg0.scale and var3.deltaTime or var3.unscaledDeltaTime

	arg0.time = arg0.time - var0

	local var1 = 0

	while arg0.time <= 0 and var1 < 6 do
		var1 = var1 + 1

		arg0.func(arg0)

		if arg0.loop > 0 then
			arg0.loop = arg0.loop - 1
			arg0.time = arg0.time + arg0.duration
		end

		if arg0.loop == 0 then
			arg0:Stop()

			return
		elseif arg0.loop < 0 then
			arg0.time = arg0.time + arg0.duration
		end
	end
end

FrameTimer = {}

local var6 = FrameTimer
local var7 = {
	__index = var6
}

function var6.New(arg0, arg1, arg2)
	local var0 = var3.frameCount + arg1

	arg2 = arg2 or 1

	return var0({
		running = false,
		func = arg0,
		loop = arg2,
		duration = arg1,
		count = var0
	}, var7)
end

function var6.Reset(arg0, arg1, arg2, arg3)
	arg0.func = arg1
	arg0.duration = arg2
	arg0.loop = arg3
	arg0.count = var3.frameCount + arg2
end

function var6.Start(arg0)
	if not arg0.handle then
		arg0.handle = var2:CreateListener(arg0.Update, arg0)
	end

	var2:AddListener(arg0.handle)

	arg0.running = true
end

function var6.Stop(arg0)
	arg0.running = false

	if arg0.handle then
		var2:RemoveListener(arg0.handle)
	end
end

function var6.Update(arg0)
	if not arg0.running then
		return
	end

	if var3.frameCount >= arg0.count then
		arg0.func()

		if arg0.loop > 0 then
			arg0.loop = arg0.loop - 1
		end

		if arg0.loop == 0 then
			arg0:Stop()
		else
			arg0.count = var3.frameCount + arg0.duration
		end
	end
end

CoTimer = {}

local var8 = CoTimer
local var9 = {
	__index = var8
}

function var8.New(arg0, arg1, arg2)
	arg2 = arg2 or 1

	return var0({
		running = false,
		duration = arg1,
		loop = arg2,
		func = arg0,
		time = arg1
	}, var9)
end

function var8.Start(arg0)
	if not arg0.handle then
		arg0.handle = var2:CreateListener(arg0.Update, arg0)
	end

	arg0.running = true

	var2:AddListener(arg0.handle)
end

function var8.Reset(arg0, arg1, arg2, arg3)
	arg0.duration = arg2
	arg0.loop = arg3 or 1
	arg0.func = arg1
	arg0.time = arg2
end

function var8.Stop(arg0)
	arg0.running = false

	if arg0.handle then
		var2:RemoveListener(arg0.handle)
	end
end

function var8.Update(arg0)
	if not arg0.running then
		return
	end

	if arg0.time <= 0 then
		arg0.func()

		if arg0.loop > 0 then
			arg0.loop = arg0.loop - 1
			arg0.time = arg0.time + arg0.duration
		end

		if arg0.loop == 0 then
			arg0:Stop()
		elseif arg0.loop < 0 then
			arg0.time = arg0.time + arg0.duration
		end
	end

	arg0.time = arg0.time - var3.deltaTime
end
