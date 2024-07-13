FrameListener = class("FrameListener")

local var0_0 = FrameListener

function var0_0.Ctor(arg0_1)
	arg0_1.jobs = {}
end

function var0_0.UnShift(arg0_2, ...)
	local var0_2 = {
		...
	}

	for iter0_2 = #var0_2, 1, -1 do
		table.insert(arg0_2.jobs, 1, var0_2[iter0_2])
	end

	arg0_2:TryStart()
end

function var0_0.Push(arg0_3, ...)
	local var0_3 = {
		...
	}

	for iter0_3 = 1, #var0_3 do
		table.insert(arg0_3.jobs, var0_3[iter0_3])
	end

	arg0_3:TryStart()
end

function var0_0.Remove(arg0_4, arg1_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.jobs) do
		if iter1_4 == arg1_4 then
			table.remove(arg0_4.jobs, iter0_4)
			arg0_4:TryStop()

			break
		end
	end
end

function var0_0.TryStart(arg0_5)
	if not arg0_5.running and #arg0_5.jobs > 0 then
		arg0_5.running = true

		UpdateBeat:Add(arg0_5.Update, arg0_5)
	end
end

function var0_0.TryStop(arg0_6)
	if arg0_6.running and #arg0_6.jobs == 0 then
		UpdateBeat:Remove(arg0_6.Update, arg0_6)

		arg0_6.running = false
	end
end

function var0_0.Update(arg0_7)
	if #arg0_7.jobs == 0 then
		arg0_7:TryStop()
	else
		table.remove(arg0_7.jobs, 1)()
	end
end

return var0_0
