GCThread = singletonClass("GCThread")

local var0_0 = GCThread

var0_0.R1024 = 0.00097656

function var0_0.Ctor(arg0_1)
	arg0_1.step = 1
	arg0_1.gctick = 0
	arg0_1.gccost = 0
	arg0_1.running = false
	arg0_1.gcHandle = UpdateBeat:CreateListener(arg0_1.GCStep, arg0_1)
	arg0_1.checkHandle = UpdateBeat:CreateListener(arg0_1.WatchStep, arg0_1)
end

function var0_0.GC(arg0_2, arg1_2)
	arg0_2.needUnityGC = true

	arg0_2:LuaGC(arg1_2)
end

function var0_0.LuaGC(arg0_3, arg1_3)
	if arg1_3 then
		collectgarbage("collect")
		arg0_3:GCFinal()
	elseif not arg0_3.running then
		arg0_3.running = true

		arg0_3:CalcStep()

		arg0_3.gctick = 0
		arg0_3.gccost = 0

		UpdateBeat:AddListener(arg0_3.gcHandle)
	end
end

function var0_0.GCFinal(arg0_4)
	arg0_4.running = false

	UpdateBeat:RemoveListener(arg0_4.gcHandle)

	if arg0_4.needUnityGC then
		arg0_4.needUnityGC = false

		local var0_4 = PoolMgr.GetInstance()
		local var1_4 = var0_4:SpriteMemUsage()
		local var2_4 = 24

		originalPrint("cached sprite size: " .. math.ceil(var1_4 * 10) / 10 .. "/" .. var2_4 .. "MB")

		if var2_4 < var1_4 then
			var0_4:DestroyAllSprite()
		end

		ResourceMgr.Inst:ResUnloadAsync()
		LuaHelper.UnityGC()
	end

	if IsUnityEditor then
		print("lua mem: " .. collectgarbage("count") * var0_0.R1024 .. "MB")
	end
end

function var0_0.GCStep(arg0_5)
	local var0_5 = os.clock()

	if not arg0_5.running then
		-- block empty
	elseif collectgarbage("step", arg0_5.step) then
		arg0_5:GCFinal()
	else
		local var1_5 = os.clock() * 1000 - var0_5 * 1000

		arg0_5.gccost = arg0_5.gccost <= 0 and var1_5 or arg0_5.gccost
		arg0_5.gccost = (arg0_5.gccost + var1_5) * 0.5
		arg0_5.gctick = arg0_5.gctick + 1

		if arg0_5.gctick > 300 and arg0_5.gctick % 30 == 0 then
			arg0_5:CalcStep()
		end
	end
end

function var0_0.CalcStep(arg0_6)
	arg0_6.step = math.max(arg0_6.gctick - 60, 30) / 30 * 500 * math.max(1 - math.max(arg0_6.gccost - 3, 0) * 0.1, 0.1)
end

function var0_0.StartWatch(arg0_7, arg1_7)
	originalPrint("overhead: start watch")

	local var0_7 = collectgarbage("count") * var0_0.R1024

	if arg1_7 < var0_7 + 12 then
		arg1_7 = var0_7 + 12
	end

	arg0_7.watcher = Timer.New(function()
		if not arg0_7.running then
			local var0_8 = collectgarbage("count") * var0_0.R1024

			if var0_8 > arg1_7 then
				originalPrint("overhead: start gc " .. var0_8 .. "MB")

				arg0_7.running = true

				arg0_7:CalcStep()

				arg0_7.gctick = 0
				arg0_7.gccost = 0

				UpdateBeat:AddListener(arg0_7.checkHandle)
			end
		end
	end, 5, -1)

	arg0_7.watcher:Start()
end

function var0_0.StopWatch(arg0_9)
	originalPrint("overhead: stop watch")

	if arg0_9.watcher then
		arg0_9.watcher:Stop()

		arg0_9.watcher = nil
	end
end

function var0_0.WatchStep(arg0_10)
	local var0_10 = os.clock()

	if collectgarbage("step", arg0_10.step) then
		originalPrint("overhead: gc complete")

		if IsUnityEditor then
			print("lua mem: " .. collectgarbage("count") * var0_0.R1024 .. "MB")
		end

		arg0_10.running = false

		UpdateBeat:RemoveListener(arg0_10.checkHandle)
	else
		local var1_10 = os.clock() * 1000 - var0_10 * 1000

		arg0_10.gccost = arg0_10.gccost <= 0 and var1_10 or arg0_10.gccost
		arg0_10.gccost = (arg0_10.gccost + var1_10) * 0.5
		arg0_10.gctick = arg0_10.gctick + 1

		if arg0_10.gctick > 300 and arg0_10.gctick % 30 == 0 then
			arg0_10:CalcStep()
		end
	end
end

return var0_0
