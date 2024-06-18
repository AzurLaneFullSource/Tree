local var0_0 = class("WSTimer", import("...BaseEntity"))

var0_0.Fields = {
	tweens = "table",
	inMapTimers = "table",
	timers = "table",
	inMapTweens = "table"
}
var0_0.Listeners = {}

function var0_0.Setup(arg0_1)
	arg0_1.inMapTimers = {}
	arg0_1.timers = {}
	arg0_1.inMapTweens = {}
	arg0_1.tweens = {}
end

function var0_0.Dispose(arg0_2)
	arg0_2:ClearInMapTweens()
	arg0_2:ClearInMapTimers()
	arg0_2:ClearTweens()
	arg0_2:ClearTimers()
	arg0_2:Clear()
end

function var0_0.AddInMapTimer(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	local var0_3 = Timer.New(arg1_3, arg2_3, arg3_3, arg4_3)

	table.insert(arg0_3.inMapTimers, var0_3)

	return var0_3
end

function var0_0.RemoveInMapTimer(arg0_4, arg1_4)
	arg1_4:Stop()

	for iter0_4, iter1_4 in ipairs(arg0_4.inMapTimers) do
		if iter1_4 == arg1_4 then
			table.remove(arg0_4.inMapTimers, iter0_4)
		end
	end
end

function var0_0.ClearInMapTimers(arg0_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.inMapTimers) do
		iter1_5:Stop()
	end

	arg0_5.inMapTimers = {}
end

function var0_0.AddTimer(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	local var0_6 = Timer.New(arg1_6, arg2_6, arg3_6, arg4_6)

	table.insert(arg0_6.timers, var0_6)

	return var0_6
end

function var0_0.RemoveTimer(arg0_7, arg1_7)
	arg1_7:Stop()

	for iter0_7, iter1_7 in ipairs(arg0_7.timers) do
		if iter1_7 == arg1_7 then
			table.remove(arg0_7.timers, iter0_7)
		end
	end
end

function var0_0.ClearTimers(arg0_8)
	for iter0_8, iter1_8 in ipairs(arg0_8.timers) do
		iter1_8:Stop()
	end

	arg0_8.timers = {}
end

function var0_0.AddInMapTween(arg0_9, arg1_9)
	assert(arg1_9 and type(arg1_9) == "number")
	table.insert(arg0_9.inMapTweens, arg1_9)
end

function var0_0.RemoveInMapTween(arg0_10, arg1_10)
	assert(arg1_10 and type(arg1_10) == "number")
	LeanTween.cancel(arg1_10)

	for iter0_10, iter1_10 in ipairs(arg0_10.inMapTweens) do
		if iter1_10 == arg1_10 then
			table.remove(arg0_10.inMapTweens, iter0_10)

			break
		end
	end
end

function var0_0.ClearInMapTweens(arg0_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.inMapTweens) do
		LeanTween.cancel(iter1_11)
	end

	arg0_11.inMapTweens = {}
end

function var0_0.AddTween(arg0_12, arg1_12)
	assert(arg1_12 and type(arg1_12) == "number")
	table.insert(arg0_12.tweens, arg1_12)
end

function var0_0.RemoveTween(arg0_13, arg1_13)
	assert(arg1_13 and type(arg1_13) == "number")
	LeanTween.cancel(arg1_13)

	for iter0_13, iter1_13 in ipairs(arg0_13.tweens) do
		if iter1_13 == arg1_13 then
			table.remove(arg0_13.tweens, iter0_13)
		end
	end
end

function var0_0.ClearTweens(arg0_14)
	for iter0_14, iter1_14 in ipairs(arg0_14.tweens) do
		LeanTween.cancel(iter1_14)
	end

	arg0_14.tweens = {}
end

return var0_0
