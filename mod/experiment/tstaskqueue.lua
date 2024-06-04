local var0 = class("TSTaskQueue")

var0.MTPF = 0.0333333333333333

function var0.Ctor(arg0, arg1)
	arg0.maxTimePerFrame = math.min(arg1, var0.MTPF)
	arg0.taskPool = {}
	arg0.taskQueue = {}
	arg0.running = false
	arg0.updateHandle = UpdateBeat:CreateListener(arg0.Update, arg0)
end

function var0.Enqueue(arg0, arg1)
	assert(type(arg1) == "function", "job should be a function")

	local var0 = #arg0.taskPool > 0 and table.remove(arg0.taskPool, #arg0.taskPool) or TSTask.New()

	var0:SetJob(arg1)
	table.insert(arg0.taskQueue, var0)

	if not arg0.running then
		arg0.running = true

		UpdateBeat:AddListener(arg0.updateHandle)
	end
end

function var0.Update(arg0)
	if not arg0.running then
		return
	end

	local var0 = 0

	while var0 < arg0.maxTimePerFrame do
		if #arg0.taskQueue == 0 then
			UpdateBeat:RemoveListener(arg0.updateHandle)

			arg0.running = false

			return
		end

		local var1 = table.remove(arg0.taskQueue, 1)

		var0 = var0 + var1:Execute()

		var1:Clear()
		table.insert(arg0.taskPool, var1)
	end
end

function var0.IsBusy(arg0)
	return arg0.running
end

function var0.Clear(arg0, arg1)
	for iter0 = #arg0.taskQueue, 1, -1 do
		local var0 = arg0.taskQueue[iter0]

		if arg1 then
			var0:Execute()
		end

		var0:Clear()
		table.insert(arg0.taskPool, var0)
	end

	arg0.taskQueue = {}
end

return var0
