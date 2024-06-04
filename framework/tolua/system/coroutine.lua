local var0 = coroutine.create
local var1 = coroutine.running
local var2 = coroutine.resume
local var3 = coroutine.yield
local var4 = error
local var5 = unpack
local var6 = debug
local var7 = FrameTimer
local var8 = CoTimer
local var9 = {}
local var10 = {}

setmetatable(var9, {
	__mode = "kv"
})

function coroutine.start(arg0, ...)
	local var0 = var0(arg0)

	if var1() == nil then
		local var1, var2 = var2(var0, ...)

		if not var1 then
			var4(var6.traceback(var0, var2))
		end
	else
		local var3 = packEx(...)
		local var4

		local function var5()
			var9[var0] = nil
			var4.func = nil

			local var0, var1 = var2(var0, unpackEx(var3))

			table.insert(var10, var4)

			if not var0 then
				var4:Stop()
				var4(var6.traceback(var0, var1))
			end
		end

		if #var10 > 0 then
			var4 = table.remove(var10)

			var4:Reset(var5, 0, 1)
		else
			var4 = var7.New(var5, 0, 1)
		end

		var9[var0] = var4

		var4:Start()
	end

	return var0
end

function coroutine.wait(arg0, arg1, ...)
	local var0 = packEx(...)

	arg1 = arg1 or var1()

	local var1
	local var2 = function()
		var9[arg1] = nil
		var1.func = nil

		local var0, var1 = var2(arg1, unpackEx(var0))

		if not var0 then
			var1:Stop()
			var4(var6.traceback(arg1, var1))

			return
		end
	end

	var1 = var8.New(var2, arg0, 1)
	var9[arg1] = var1

	var1:Start()

	return var3()
end

function coroutine.step(arg0, arg1, ...)
	local var0 = packEx(...)

	arg1 = arg1 or var1()

	local var1
	local var2 = function()
		var9[arg1] = nil
		var1.func = nil

		local var0, var1 = var2(arg1, unpackEx(var0))

		table.insert(var10, var1)

		if not var0 then
			var1:Stop()
			var4(var6.traceback(arg1, var1))

			return
		end
	end

	if #var10 > 0 then
		var1 = table.remove(var10)

		var1:Reset(var2, arg0 or 1, 1)
	else
		var1 = var7.New(var2, arg0 or 1, 1)
	end

	var9[arg1] = var1

	var1:Start()

	return var3()
end

function coroutine.www(arg0, arg1)
	arg1 = arg1 or var1()

	local var0

	local function var1()
		if not arg0.isDone then
			return
		end

		var9[arg1] = nil

		var0:Stop()

		var0.func = nil

		local var0, var1 = var2(arg1)

		table.insert(var10, var0)

		if not var0 then
			var4(var6.traceback(arg1, var1))

			return
		end
	end

	if #var10 > 0 then
		var0 = table.remove(var10)

		var0:Reset(var1, 1, -1)
	else
		var0 = var7.New(var1, 1, -1)
	end

	var9[arg1] = var0

	var0:Start()

	return var3()
end

function coroutine.stop(arg0)
	local var0 = var9[arg0]

	if var0 ~= nil then
		var9[arg0] = nil

		var0:Stop()

		var0.func = nil
	end
end
