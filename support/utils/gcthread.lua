GCThread = singletonClass("GCThread")

local var0 = GCThread

var0.R1024 = 0.00097656

function var0.Ctor(arg0)
	arg0.step = 1
	arg0.gctick = 0
	arg0.gccost = 0
	arg0.running = false
	arg0.gcHandle = UpdateBeat:CreateListener(arg0.GCStep, arg0)
	arg0.checkHandle = UpdateBeat:CreateListener(arg0.WatchStep, arg0)
end

function var0.GC(arg0, arg1)
	arg0.needUnityGC = true

	arg0:LuaGC(arg1)
end

function var0.LuaGC(arg0, arg1)
	if arg1 then
		collectgarbage("collect")
		arg0:GCFinal()
	elseif not arg0.running then
		arg0.running = true

		arg0:CalcStep()

		arg0.gctick = 0
		arg0.gccost = 0

		UpdateBeat:AddListener(arg0.gcHandle)
	end
end

function var0.GCFinal(arg0)
	arg0.running = false

	UpdateBeat:RemoveListener(arg0.gcHandle)

	if arg0.needUnityGC then
		arg0.needUnityGC = false

		local var0 = PoolMgr.GetInstance()
		local var1 = var0:SpriteMemUsage()
		local var2 = 24

		originalPrint("cached sprite size: " .. math.ceil(var1 * 10) / 10 .. "/" .. var2 .. "MB")

		if var2 < var1 then
			var0:DestroyAllSprite()
		end

		ResourceMgr.Inst:ResUnloadAsync()
		LuaHelper.UnityGC()
	end

	if IsUnityEditor then
		print("lua mem: " .. collectgarbage("count") * var0.R1024 .. "MB")
	end
end

function var0.GCStep(arg0)
	local var0 = os.clock()

	if not arg0.running then
		-- block empty
	elseif collectgarbage("step", arg0.step) then
		arg0:GCFinal()
	else
		local var1 = os.clock() * 1000 - var0 * 1000

		arg0.gccost = arg0.gccost <= 0 and var1 or arg0.gccost
		arg0.gccost = (arg0.gccost + var1) * 0.5
		arg0.gctick = arg0.gctick + 1

		if arg0.gctick > 300 and arg0.gctick % 30 == 0 then
			arg0:CalcStep()
		end
	end
end

function var0.CalcStep(arg0)
	arg0.step = math.max(arg0.gctick - 60, 30) / 30 * 500 * math.max(1 - math.max(arg0.gccost - 3, 0) * 0.1, 0.1)
end

function var0.StartWatch(arg0, arg1)
	originalPrint("overhead: start watch")

	local var0 = collectgarbage("count") * var0.R1024

	if arg1 < var0 + 12 then
		arg1 = var0 + 12
	end

	arg0.watcher = Timer.New(function()
		if not arg0.running then
			local var0 = collectgarbage("count") * var0.R1024

			if var0 > arg1 then
				originalPrint("overhead: start gc " .. var0 .. "MB")

				arg0.running = true

				arg0:CalcStep()

				arg0.gctick = 0
				arg0.gccost = 0

				UpdateBeat:AddListener(arg0.checkHandle)
			end
		end
	end, 5, -1)

	arg0.watcher:Start()
end

function var0.StopWatch(arg0)
	originalPrint("overhead: stop watch")

	if arg0.watcher then
		arg0.watcher:Stop()

		arg0.watcher = nil
	end
end

function var0.WatchStep(arg0)
	local var0 = os.clock()

	if collectgarbage("step", arg0.step) then
		originalPrint("overhead: gc complete")

		if IsUnityEditor then
			print("lua mem: " .. collectgarbage("count") * var0.R1024 .. "MB")
		end

		arg0.running = false

		UpdateBeat:RemoveListener(arg0.checkHandle)
	else
		local var1 = os.clock() * 1000 - var0 * 1000

		arg0.gccost = arg0.gccost <= 0 and var1 or arg0.gccost
		arg0.gccost = (arg0.gccost + var1) * 0.5
		arg0.gctick = arg0.gctick + 1

		if arg0.gctick > 300 and arg0.gctick % 30 == 0 then
			arg0:CalcStep()
		end
	end
end

return var0
