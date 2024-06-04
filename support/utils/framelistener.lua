FrameListener = class("FrameListener")

local var0 = FrameListener

function var0.Ctor(arg0)
	arg0.jobs = {}
end

function var0.UnShift(arg0, ...)
	local var0 = {
		...
	}

	for iter0 = #var0, 1, -1 do
		table.insert(arg0.jobs, 1, var0[iter0])
	end

	arg0:TryStart()
end

function var0.Push(arg0, ...)
	local var0 = {
		...
	}

	for iter0 = 1, #var0 do
		table.insert(arg0.jobs, var0[iter0])
	end

	arg0:TryStart()
end

function var0.Remove(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.jobs) do
		if iter1 == arg1 then
			table.remove(arg0.jobs, iter0)
			arg0:TryStop()

			break
		end
	end
end

function var0.TryStart(arg0)
	if not arg0.running and #arg0.jobs > 0 then
		arg0.running = true

		UpdateBeat:Add(arg0.Update, arg0)
	end
end

function var0.TryStop(arg0)
	if arg0.running and #arg0.jobs == 0 then
		UpdateBeat:Remove(arg0.Update, arg0)

		arg0.running = false
	end
end

function var0.Update(arg0)
	if #arg0.jobs == 0 then
		arg0:TryStop()
	else
		table.remove(arg0.jobs, 1)()
	end
end

return var0
