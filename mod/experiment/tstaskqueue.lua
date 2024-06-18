local var0_0 = class("TSTaskQueue")

var0_0.MTPF = 0.0333333333333333

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.maxTimePerFrame = math.min(arg1_1, var0_0.MTPF)
	arg0_1.taskPool = {}
	arg0_1.taskQueue = {}
	arg0_1.running = false
	arg0_1.updateHandle = UpdateBeat:CreateListener(arg0_1.Update, arg0_1)
end

function var0_0.Enqueue(arg0_2, arg1_2)
	assert(type(arg1_2) == "function", "job should be a function")

	local var0_2 = #arg0_2.taskPool > 0 and table.remove(arg0_2.taskPool, #arg0_2.taskPool) or TSTask.New()

	var0_2:SetJob(arg1_2)
	table.insert(arg0_2.taskQueue, var0_2)

	if not arg0_2.running then
		arg0_2.running = true

		UpdateBeat:AddListener(arg0_2.updateHandle)
	end
end

function var0_0.Update(arg0_3)
	if not arg0_3.running then
		return
	end

	local var0_3 = 0

	while var0_3 < arg0_3.maxTimePerFrame do
		if #arg0_3.taskQueue == 0 then
			UpdateBeat:RemoveListener(arg0_3.updateHandle)

			arg0_3.running = false

			return
		end

		local var1_3 = table.remove(arg0_3.taskQueue, 1)

		var0_3 = var0_3 + var1_3:Execute()

		var1_3:Clear()
		table.insert(arg0_3.taskPool, var1_3)
	end
end

function var0_0.IsBusy(arg0_4)
	return arg0_4.running
end

function var0_0.Clear(arg0_5, arg1_5)
	for iter0_5 = #arg0_5.taskQueue, 1, -1 do
		local var0_5 = arg0_5.taskQueue[iter0_5]

		if arg1_5 then
			var0_5:Execute()
		end

		var0_5:Clear()
		table.insert(arg0_5.taskPool, var0_5)
	end

	arg0_5.taskQueue = {}
end

return var0_0
