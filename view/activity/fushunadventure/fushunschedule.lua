local var0 = class("FushunSchedule")

function var0.Ctor(arg0)
	arg0.time = 0
	arg0.schedules = {}
end

function var0.Update(arg0)
	for iter0 = #arg0.schedules, 1, -1 do
		local var0 = arg0.schedules[iter0]

		if arg0.time - var0.nowtime >= var0.targetTime then
			var0.callback()

			var0.count = var0.count - 1
			var0.nowtime = arg0.time

			if var0.count == 0 then
				table.remove(arg0.schedules, iter0)
			end
		end
	end

	arg0.time = arg0.time + Time.deltaTime
end

function var0.AddSchedule(arg0, arg1, arg2, arg3)
	table.insert(arg0.schedules, {
		targetTime = arg1,
		count = arg2,
		callback = arg3,
		nowtime = arg0.time
	})
end

function var0.Dispose(arg0)
	arg0.schedules = nil
end

return var0
