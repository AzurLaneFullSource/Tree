local var0 = class("WSTimer", import("...BaseEntity"))

var0.Fields = {
	tweens = "table",
	inMapTimers = "table",
	timers = "table",
	inMapTweens = "table"
}
var0.Listeners = {}

function var0.Setup(arg0)
	arg0.inMapTimers = {}
	arg0.timers = {}
	arg0.inMapTweens = {}
	arg0.tweens = {}
end

function var0.Dispose(arg0)
	arg0:ClearInMapTweens()
	arg0:ClearInMapTimers()
	arg0:ClearTweens()
	arg0:ClearTimers()
	arg0:Clear()
end

function var0.AddInMapTimer(arg0, arg1, arg2, arg3, arg4)
	local var0 = Timer.New(arg1, arg2, arg3, arg4)

	table.insert(arg0.inMapTimers, var0)

	return var0
end

function var0.RemoveInMapTimer(arg0, arg1)
	arg1:Stop()

	for iter0, iter1 in ipairs(arg0.inMapTimers) do
		if iter1 == arg1 then
			table.remove(arg0.inMapTimers, iter0)
		end
	end
end

function var0.ClearInMapTimers(arg0)
	for iter0, iter1 in ipairs(arg0.inMapTimers) do
		iter1:Stop()
	end

	arg0.inMapTimers = {}
end

function var0.AddTimer(arg0, arg1, arg2, arg3, arg4)
	local var0 = Timer.New(arg1, arg2, arg3, arg4)

	table.insert(arg0.timers, var0)

	return var0
end

function var0.RemoveTimer(arg0, arg1)
	arg1:Stop()

	for iter0, iter1 in ipairs(arg0.timers) do
		if iter1 == arg1 then
			table.remove(arg0.timers, iter0)
		end
	end
end

function var0.ClearTimers(arg0)
	for iter0, iter1 in ipairs(arg0.timers) do
		iter1:Stop()
	end

	arg0.timers = {}
end

function var0.AddInMapTween(arg0, arg1)
	assert(arg1 and type(arg1) == "number")
	table.insert(arg0.inMapTweens, arg1)
end

function var0.RemoveInMapTween(arg0, arg1)
	assert(arg1 and type(arg1) == "number")
	LeanTween.cancel(arg1)

	for iter0, iter1 in ipairs(arg0.inMapTweens) do
		if iter1 == arg1 then
			table.remove(arg0.inMapTweens, iter0)

			break
		end
	end
end

function var0.ClearInMapTweens(arg0)
	for iter0, iter1 in ipairs(arg0.inMapTweens) do
		LeanTween.cancel(iter1)
	end

	arg0.inMapTweens = {}
end

function var0.AddTween(arg0, arg1)
	assert(arg1 and type(arg1) == "number")
	table.insert(arg0.tweens, arg1)
end

function var0.RemoveTween(arg0, arg1)
	assert(arg1 and type(arg1) == "number")
	LeanTween.cancel(arg1)

	for iter0, iter1 in ipairs(arg0.tweens) do
		if iter1 == arg1 then
			table.remove(arg0.tweens, iter0)
		end
	end
end

function var0.ClearTweens(arg0)
	for iter0, iter1 in ipairs(arg0.tweens) do
		LeanTween.cancel(iter1)
	end

	arg0.tweens = {}
end

return var0
