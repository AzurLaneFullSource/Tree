local var0_0 = class("FushunSchedule")

function var0_0.Ctor(arg0_1)
	arg0_1.time = 0
	arg0_1.schedules = {}
end

function var0_0.Update(arg0_2)
	for iter0_2 = #arg0_2.schedules, 1, -1 do
		local var0_2 = arg0_2.schedules[iter0_2]

		if arg0_2.time - var0_2.nowtime >= var0_2.targetTime then
			var0_2.callback()

			var0_2.count = var0_2.count - 1
			var0_2.nowtime = arg0_2.time

			if var0_2.count == 0 then
				table.remove(arg0_2.schedules, iter0_2)
			end
		end
	end

	arg0_2.time = arg0_2.time + Time.deltaTime
end

function var0_0.AddSchedule(arg0_3, arg1_3, arg2_3, arg3_3)
	table.insert(arg0_3.schedules, {
		targetTime = arg1_3,
		count = arg2_3,
		callback = arg3_3,
		nowtime = arg0_3.time
	})
end

function var0_0.Dispose(arg0_4)
	arg0_4.schedules = nil
end

return var0_0
