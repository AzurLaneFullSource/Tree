local var0 = import("..patterns.observer.Observer")
local var1 = class("View")

function var1.Ctor(arg0, arg1)
	if var1.instanceMap[arg1] ~= nil then
		error(var1.MULTITON_MSG)
	end

	arg0.multitonKey = arg1
	var1.instanceMap[arg0.multitonKey] = arg0
	arg0.mediatorMap = {}
	arg0.observerMap = {}

	arg0:initializeView()
end

function var1.initializeView(arg0)
	return
end

function var1.getInstance(arg0)
	if arg0 == nil then
		return nil
	end

	if var1.instanceMap[arg0] == nil then
		return var1.New(arg0)
	else
		return var1.instanceMap[arg0]
	end
end

function var1.registerObserver(arg0, arg1, arg2)
	if arg0.observerMap[arg1] ~= nil then
		table.insert(arg0.observerMap[arg1], arg2)
	else
		if arg1 == nil then
			print(debug.traceback())
		end

		arg0.observerMap[arg1] = {
			arg2
		}
	end
end

function var1.notifyObservers(arg0, arg1)
	local var0 = arg0.observerMap[arg1:getName()]

	if var0 ~= nil then
		local var1 = table.shallowCopy(var0)

		for iter0, iter1 in pairs(var1) do
			if table.contains(var0, iter1) then
				iter1:notifyObserver(arg1)
			end
		end

		local var2
	end
end

function var1.removeObserver(arg0, arg1, arg2)
	local var0 = arg0.observerMap[arg1]

	for iter0, iter1 in pairs(var0) do
		if iter1:compareNotifyContext(arg2) then
			table.remove(var0, iter0)

			break
		end
	end

	if #var0 == 0 then
		arg0.observerMap[arg1] = nil
	end
end

function var1.registerMediator(arg0, arg1)
	if arg0.mediatorMap[arg1:getMediatorName()] ~= nil then
		return
	end

	arg1:initializeNotifier(arg0.multitonKey)

	arg0.mediatorMap[arg1:getMediatorName()] = arg1

	local var0 = arg1:listNotificationInterests()

	if #var0 > 0 then
		local var1 = var0.New(arg1.handleNotification, arg1)

		for iter0, iter1 in pairs(var0) do
			arg0:registerObserver(iter1, var1)
		end
	end

	arg1:onRegister()
end

function var1.retrieveMediator(arg0, arg1)
	return arg0.mediatorMap[arg1]
end

function var1.removeMediator(arg0, arg1)
	local var0 = arg0.mediatorMap[arg1]

	if var0 ~= nil then
		local var1 = var0:listNotificationInterests()

		for iter0, iter1 in pairs(var1) do
			arg0:removeObserver(iter1, var0)
		end

		arg0.mediatorMap[arg1] = nil

		var0:onRemove()
	end

	return var0
end

function var1.hasMediator(arg0, arg1)
	return arg0.mediatorMap[arg1] ~= nil
end

function var1.removeView(arg0)
	var1.instanceMap[arg0] = nil
end

var1.instanceMap = {}
var1.MULTITON_MSG = "View instance for this Multiton key already constructed!"

return var1
