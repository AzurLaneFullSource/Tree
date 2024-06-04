local var0 = class("BaseEventLogic")
local var1 = require("Framework.notify.event")

function var0.Ctor(arg0, arg1)
	arg0.eventCounter = 1
	arg0.eventStore = {}
	arg0.event = arg1 or var1.New()
	arg0.tweenIdList = {}
end

function var0.bind(arg0, arg1, arg2)
	arg0.event:connect(arg1, arg2)

	local var0 = arg0.eventCounter

	arg0.eventStore[var0] = {
		event = arg1,
		callback = arg2
	}
	arg0.eventCounter = arg0.eventCounter + 1

	return var0
end

function var0.emit(arg0, ...)
	if arg0.event then
		arg0.event:emit(...)
	end
end

function var0.disconnect(arg0, arg1)
	local var0 = arg0.eventStore[arg1]

	if var0 then
		arg0.event:disconnect(var0.event, var0.callback)

		arg0.eventStore[arg1] = nil
	end
end

function var0.disposeEvent(arg0)
	for iter0, iter1 in pairs(arg0.eventStore) do
		arg0.event:disconnect(iter1.event, iter1.callback)
	end

	arg0.eventStore = {}
end

function var0.managedTween(arg0, arg1, arg2, ...)
	local var0 = arg1(...)

	var0:setOnComplete(System.Action(function()
		table.removebyvalue(arg0.tweenIdList, var0.uniqueId)

		if arg2 then
			arg2()
		end
	end))

	arg0.tweenIdList[#arg0.tweenIdList + 1] = var0.uniqueId

	return var0
end

function var0.cleanManagedTween(arg0, arg1)
	arg1 = defaultValue(arg1, false)

	for iter0, iter1 in ipairs(arg0.tweenIdList) do
		if LeanTween.isTweening(iter1) then
			LeanTween.cancel(iter1, arg1)
		end
	end

	arg0.tweenIdList = {}
end

function var0.pauseManagedTween(arg0)
	for iter0, iter1 in ipairs(arg0.tweenIdList) do
		if LeanTween.isTweening(iter1) then
			LeanTween.pause(iter1)
		end
	end
end

function var0.resumeManagedTween(arg0)
	for iter0, iter1 in ipairs(arg0.tweenIdList) do
		if LeanTween.isTweening(iter1) then
			LeanTween.resume(iter1)
		end
	end
end

function var0.AddLeanTween(arg0, arg1)
	local var0 = arg1()

	assert(var0)

	arg0.tweenIdList[#arg0.tweenIdList + 1] = var0.uniqueId
end

return var0
