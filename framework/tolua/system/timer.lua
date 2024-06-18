local var0_0 = setmetatable
local var1_0 = UpdateBeat
local var2_0 = CoUpdateBeat
local var3_0 = Time

Timer = {
	loop = 1,
	running = false,
	time = 0,
	duration = 1,
	scale = false
}

local var4_0 = Timer
local var5_0 = {
	__index = var4_0
}

function var4_0.New(arg0_1, arg1_1, arg2_1, arg3_1)
	assert(arg1_1 > 0, "定时器间隔不能小于等于0！：" .. arg1_1)

	arg3_1 = arg3_1 or false
	arg2_1 = arg2_1 or 1

	return var0_0({
		running = false,
		func = arg0_1,
		duration = arg1_1,
		time = arg1_1,
		loop = arg2_1,
		scale = arg3_1
	}, var5_0)
end

function var4_0.Start(arg0_2)
	assert(arg0_2.running == false, "对已经启动的定时器执行启动！")

	arg0_2.running = true
	arg0_2.paused = nil

	if not arg0_2.handle then
		arg0_2.handle = var1_0:CreateListener(arg0_2.Update, arg0_2)
	end

	var1_0:AddListener(arg0_2.handle)
end

function var4_0.Reset(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	arg0_3.duration = arg2_3 or arg0_3.duration

	assert(arg0_3.duration > 0, "定时器间隔不能小于等于0！：" .. arg0_3.duration)

	arg0_3.loop = arg3_3 or arg0_3.loop
	arg0_3.scale = arg4_3 or arg0_3.scale
	arg0_3.func = arg1_3 or arg0_3.func
	arg0_3.time = arg2_3 or arg0_3.time
	arg0_3.running = false
	arg0_3.paused = nil
end

function var4_0.SetScale(arg0_4, arg1_4)
	arg0_4.scale = arg1_4
end

function var4_0.Stop(arg0_5)
	if not arg0_5.running then
		return
	end

	arg0_5.running = false
	arg0_5.paused = nil
	arg0_5.time = 0

	if arg0_5.handle then
		var1_0:RemoveListener(arg0_5.handle)
	end
end

function var4_0.Pause(arg0_6)
	arg0_6.paused = true
end

function var4_0.Resume(arg0_7)
	arg0_7.paused = nil
end

function var4_0.Update(arg0_8)
	if not arg0_8.running or arg0_8.paused then
		return
	end

	local var0_8 = arg0_8.scale and var3_0.deltaTime or var3_0.unscaledDeltaTime

	arg0_8.time = arg0_8.time - var0_8

	local var1_8 = 0

	while arg0_8.time <= 0 and var1_8 < 6 do
		var1_8 = var1_8 + 1

		arg0_8.func(arg0_8)

		if arg0_8.loop > 0 then
			arg0_8.loop = arg0_8.loop - 1
			arg0_8.time = arg0_8.time + arg0_8.duration
		end

		if arg0_8.loop == 0 then
			arg0_8:Stop()

			return
		elseif arg0_8.loop < 0 then
			arg0_8.time = arg0_8.time + arg0_8.duration
		end
	end
end

FrameTimer = {}

local var6_0 = FrameTimer
local var7_0 = {
	__index = var6_0
}

function var6_0.New(arg0_9, arg1_9, arg2_9)
	local var0_9 = var3_0.frameCount + arg1_9

	arg2_9 = arg2_9 or 1

	return var0_0({
		running = false,
		func = arg0_9,
		loop = arg2_9,
		duration = arg1_9,
		count = var0_9
	}, var7_0)
end

function var6_0.Reset(arg0_10, arg1_10, arg2_10, arg3_10)
	arg0_10.func = arg1_10
	arg0_10.duration = arg2_10
	arg0_10.loop = arg3_10
	arg0_10.count = var3_0.frameCount + arg2_10
end

function var6_0.Start(arg0_11)
	if not arg0_11.handle then
		arg0_11.handle = var2_0:CreateListener(arg0_11.Update, arg0_11)
	end

	var2_0:AddListener(arg0_11.handle)

	arg0_11.running = true
end

function var6_0.Stop(arg0_12)
	arg0_12.running = false

	if arg0_12.handle then
		var2_0:RemoveListener(arg0_12.handle)
	end
end

function var6_0.Update(arg0_13)
	if not arg0_13.running then
		return
	end

	if var3_0.frameCount >= arg0_13.count then
		arg0_13.func()

		if arg0_13.loop > 0 then
			arg0_13.loop = arg0_13.loop - 1
		end

		if arg0_13.loop == 0 then
			arg0_13:Stop()
		else
			arg0_13.count = var3_0.frameCount + arg0_13.duration
		end
	end
end

CoTimer = {}

local var8_0 = CoTimer
local var9_0 = {
	__index = var8_0
}

function var8_0.New(arg0_14, arg1_14, arg2_14)
	arg2_14 = arg2_14 or 1

	return var0_0({
		running = false,
		duration = arg1_14,
		loop = arg2_14,
		func = arg0_14,
		time = arg1_14
	}, var9_0)
end

function var8_0.Start(arg0_15)
	if not arg0_15.handle then
		arg0_15.handle = var2_0:CreateListener(arg0_15.Update, arg0_15)
	end

	arg0_15.running = true

	var2_0:AddListener(arg0_15.handle)
end

function var8_0.Reset(arg0_16, arg1_16, arg2_16, arg3_16)
	arg0_16.duration = arg2_16
	arg0_16.loop = arg3_16 or 1
	arg0_16.func = arg1_16
	arg0_16.time = arg2_16
end

function var8_0.Stop(arg0_17)
	arg0_17.running = false

	if arg0_17.handle then
		var2_0:RemoveListener(arg0_17.handle)
	end
end

function var8_0.Update(arg0_18)
	if not arg0_18.running then
		return
	end

	if arg0_18.time <= 0 then
		arg0_18.func()

		if arg0_18.loop > 0 then
			arg0_18.loop = arg0_18.loop - 1
			arg0_18.time = arg0_18.time + arg0_18.duration
		end

		if arg0_18.loop == 0 then
			arg0_18:Stop()
		elseif arg0_18.loop < 0 then
			arg0_18.time = arg0_18.time + arg0_18.duration
		end
	end

	arg0_18.time = arg0_18.time - var3_0.deltaTime
end
