local var0_0 = coroutine.create
local var1_0 = coroutine.running
local var2_0 = coroutine.resume
local var3_0 = coroutine.yield
local var4_0 = error
local var5_0 = unpack
local var6_0 = debug
local var7_0 = FrameTimer
local var8_0 = CoTimer
local var9_0 = {}
local var10_0 = {}

setmetatable(var9_0, {
	__mode = "kv"
})

function coroutine.start(arg0_1, ...)
	local var0_1 = var0_0(arg0_1)

	if var1_0() == nil then
		local var1_1, var2_1 = var2_0(var0_1, ...)

		if not var1_1 then
			var4_0(var6_0.traceback(var0_1, var2_1))
		end
	else
		local var3_1 = packEx(...)
		local var4_1

		local function var5_1()
			var9_0[var0_1] = nil
			var4_1.func = nil

			local var0_2, var1_2 = var2_0(var0_1, unpackEx(var3_1))

			table.insert(var10_0, var4_1)

			if not var0_2 then
				var4_1:Stop()
				var4_0(var6_0.traceback(var0_1, var1_2))
			end
		end

		if #var10_0 > 0 then
			var4_1 = table.remove(var10_0)

			var4_1:Reset(var5_1, 0, 1)
		else
			var4_1 = var7_0.New(var5_1, 0, 1)
		end

		var9_0[var0_1] = var4_1

		var4_1:Start()
	end

	return var0_1
end

function coroutine.wait(arg0_3, arg1_3, ...)
	local var0_3 = packEx(...)

	arg1_3 = arg1_3 or var1_0()

	local var1_3

	local function var2_3()
		var9_0[arg1_3] = nil
		var1_3.func = nil

		local var0_4, var1_4 = var2_0(arg1_3, unpackEx(var0_3))

		if not var0_4 then
			var1_3:Stop()
			var4_0(var6_0.traceback(arg1_3, var1_4))

			return
		end
	end

	var1_3 = var8_0.New(var2_3, arg0_3, 1)
	var9_0[arg1_3] = var1_3

	var1_3:Start()

	return var3_0()
end

function coroutine.step(arg0_5, arg1_5, ...)
	local var0_5 = packEx(...)

	arg1_5 = arg1_5 or var1_0()

	local var1_5

	local function var2_5()
		var9_0[arg1_5] = nil
		var1_5.func = nil

		local var0_6, var1_6 = var2_0(arg1_5, unpackEx(var0_5))

		table.insert(var10_0, var1_5)

		if not var0_6 then
			var1_5:Stop()
			var4_0(var6_0.traceback(arg1_5, var1_6))

			return
		end
	end

	if #var10_0 > 0 then
		var1_5 = table.remove(var10_0)

		var1_5:Reset(var2_5, arg0_5 or 1, 1)
	else
		var1_5 = var7_0.New(var2_5, arg0_5 or 1, 1)
	end

	var9_0[arg1_5] = var1_5

	var1_5:Start()

	return var3_0()
end

function coroutine.www(arg0_7, arg1_7)
	arg1_7 = arg1_7 or var1_0()

	local var0_7

	local function var1_7()
		if not arg0_7.isDone then
			return
		end

		var9_0[arg1_7] = nil

		var0_7:Stop()

		var0_7.func = nil

		local var0_8, var1_8 = var2_0(arg1_7)

		table.insert(var10_0, var0_7)

		if not var0_8 then
			var4_0(var6_0.traceback(arg1_7, var1_8))

			return
		end
	end

	if #var10_0 > 0 then
		var0_7 = table.remove(var10_0)

		var0_7:Reset(var1_7, 1, -1)
	else
		var0_7 = var7_0.New(var1_7, 1, -1)
	end

	var9_0[arg1_7] = var0_7

	var0_7:Start()

	return var3_0()
end

function coroutine.stop(arg0_9)
	local var0_9 = var9_0[arg0_9]

	if var0_9 ~= nil then
		var9_0[arg0_9] = nil

		var0_9:Stop()

		var0_9.func = nil
	end
end
