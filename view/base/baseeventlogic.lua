local var0_0 = class("BaseEventLogic")
local var1_0 = require("Framework.notify.event")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.eventCounter = 1
	arg0_1.eventStore = {}
	arg0_1.event = arg1_1 or var1_0.New()
	arg0_1.tweenIdList = {}
end

function var0_0.bind(arg0_2, arg1_2, arg2_2)
	arg0_2.event:connect(arg1_2, arg2_2)

	local var0_2 = arg0_2.eventCounter

	arg0_2.eventStore[var0_2] = {
		event = arg1_2,
		callback = arg2_2
	}
	arg0_2.eventCounter = arg0_2.eventCounter + 1

	return var0_2
end

function var0_0.emit(arg0_3, ...)
	if arg0_3.event then
		arg0_3.event:emit(...)
	end
end

function var0_0.disconnect(arg0_4, arg1_4)
	local var0_4 = arg0_4.eventStore[arg1_4]

	if var0_4 then
		arg0_4.event:disconnect(var0_4.event, var0_4.callback)

		arg0_4.eventStore[arg1_4] = nil
	end
end

function var0_0.disposeEvent(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5.eventStore) do
		arg0_5.event:disconnect(iter1_5.event, iter1_5.callback)
	end

	arg0_5.eventStore = {}
end

function var0_0.managedTween(arg0_6, arg1_6, arg2_6, ...)
	local var0_6 = arg1_6(...)

	var0_6:setOnComplete(System.Action(function()
		table.removebyvalue(arg0_6.tweenIdList, var0_6.uniqueId)

		if arg2_6 then
			arg2_6()
		end
	end))

	arg0_6.tweenIdList[#arg0_6.tweenIdList + 1] = var0_6.uniqueId

	return var0_6
end

function var0_0.cleanManagedTween(arg0_8, arg1_8)
	arg1_8 = defaultValue(arg1_8, false)

	for iter0_8, iter1_8 in ipairs(arg0_8.tweenIdList) do
		if LeanTween.isTweening(iter1_8) then
			LeanTween.cancel(iter1_8, arg1_8)
		end
	end

	arg0_8.tweenIdList = {}
end

function var0_0.pauseManagedTween(arg0_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.tweenIdList) do
		if LeanTween.isTweening(iter1_9) then
			LeanTween.pause(iter1_9)
		end
	end
end

function var0_0.resumeManagedTween(arg0_10)
	for iter0_10, iter1_10 in ipairs(arg0_10.tweenIdList) do
		if LeanTween.isTweening(iter1_10) then
			LeanTween.resume(iter1_10)
		end
	end
end

function var0_0.AddLeanTween(arg0_11, arg1_11)
	local var0_11 = arg1_11()

	assert(var0_11)

	arg0_11.tweenIdList[#arg0_11.tweenIdList + 1] = var0_11.uniqueId
end

return var0_0
