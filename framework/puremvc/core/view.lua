local var0_0 = import("..patterns.observer.Observer")
local var1_0 = class("View")

function var1_0.Ctor(arg0_1, arg1_1)
	if var1_0.instanceMap[arg1_1] ~= nil then
		error(var1_0.MULTITON_MSG)
	end

	arg0_1.multitonKey = arg1_1
	var1_0.instanceMap[arg0_1.multitonKey] = arg0_1
	arg0_1.mediatorMap = {}
	arg0_1.observerMap = {}

	arg0_1:initializeView()
end

function var1_0.initializeView(arg0_2)
	return
end

function var1_0.getInstance(arg0_3)
	if arg0_3 == nil then
		return nil
	end

	if var1_0.instanceMap[arg0_3] == nil then
		return var1_0.New(arg0_3)
	else
		return var1_0.instanceMap[arg0_3]
	end
end

function var1_0.registerObserver(arg0_4, arg1_4, arg2_4)
	if arg0_4.observerMap[arg1_4] ~= nil then
		table.insert(arg0_4.observerMap[arg1_4], arg2_4)
	else
		if arg1_4 == nil then
			print(debug.traceback())
		end

		arg0_4.observerMap[arg1_4] = {
			arg2_4
		}
	end
end

function var1_0.notifyObservers(arg0_5, arg1_5)
	local var0_5 = arg0_5.observerMap[arg1_5:getName()]

	if var0_5 ~= nil then
		local var1_5 = table.shallowCopy(var0_5)

		for iter0_5, iter1_5 in pairs(var1_5) do
			if table.contains(var0_5, iter1_5) then
				iter1_5:notifyObserver(arg1_5)
			end
		end

		local var2_5
	end
end

function var1_0.removeObserver(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6.observerMap[arg1_6]

	for iter0_6, iter1_6 in pairs(var0_6) do
		if iter1_6:compareNotifyContext(arg2_6) then
			table.remove(var0_6, iter0_6)

			break
		end
	end

	if #var0_6 == 0 then
		arg0_6.observerMap[arg1_6] = nil
	end
end

function var1_0.registerMediator(arg0_7, arg1_7)
	if arg0_7.mediatorMap[arg1_7:getMediatorName()] ~= nil then
		return
	end

	arg1_7:initializeNotifier(arg0_7.multitonKey)

	arg0_7.mediatorMap[arg1_7:getMediatorName()] = arg1_7

	local var0_7 = arg1_7:listNotificationInterests()

	if #var0_7 > 0 then
		local var1_7 = var0_0.New(arg1_7.handleNotification, arg1_7)

		for iter0_7, iter1_7 in pairs(var0_7) do
			arg0_7:registerObserver(iter1_7, var1_7)
		end
	end

	arg1_7:onRegister()
end

function var1_0.retrieveMediator(arg0_8, arg1_8)
	return arg0_8.mediatorMap[arg1_8]
end

function var1_0.removeMediator(arg0_9, arg1_9)
	local var0_9 = arg0_9.mediatorMap[arg1_9]

	if var0_9 ~= nil then
		local var1_9 = var0_9:listNotificationInterests()

		for iter0_9, iter1_9 in pairs(var1_9) do
			arg0_9:removeObserver(iter1_9, var0_9)
		end

		arg0_9.mediatorMap[arg1_9] = nil

		var0_9:onRemove()
	end

	return var0_9
end

function var1_0.hasMediator(arg0_10, arg1_10)
	return arg0_10.mediatorMap[arg1_10] ~= nil
end

function var1_0.removeView(arg0_11)
	var1_0.instanceMap[arg0_11] = nil
end

var1_0.instanceMap = {}
var1_0.MULTITON_MSG = "View instance for this Multiton key already constructed!"

return var1_0
