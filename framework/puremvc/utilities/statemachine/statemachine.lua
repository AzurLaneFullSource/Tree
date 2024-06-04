local var0 = import("...patterns.mediator.Mediator")
local var1 = class("StateMachine", var0)

var1.NAME = "StateMachine"
var1.ACTION = var1.NAME .. "/notes/action"
var1.CHANGED = var1.NAME .. "/notes/changed"
var1.CANCEL = var1.NAME .. "/notes/cancel"

function var1.Ctor(arg0)
	var1.super.Ctor(arg0, var1.NAME, null)

	arg0.states = {}
end

function var1.onRegister(arg0)
	if arg0.initial ~= nil then
		arg0:transitionTo(arg0.initial, null)
	end
end

function var1.registerState(arg0, arg1, arg2)
	if arg1 == nil or arg0.states[arg1.name] ~= nil then
		return
	end

	arg0.states[arg1.name] = arg1

	if arg2 then
		arg0.initial = arg1
	end
end

function var1.retrieveState(arg0, arg1)
	return arg0.states[arg1]
end

function var1.removeState(arg0, arg1)
	if arg0.states[arg1] == nil then
		return
	end

	arg0.states[arg1] = nil
end

function var1.transitionTo(arg0, arg1, arg2)
	if arg1 == nil then
		return
	end

	arg0.canceled = false

	local var0 = arg0:getCurrentState()

	if var0 ~= nil and var0.exiting ~= nil then
		arg0:sendNotification(var0.exiting, arg2, arg1.name)
	end

	if arg0.canceled then
		arg0.canceled = false

		return
	end

	if arg1.entering ~= nil then
		arg0:sendNotification(arg1.entering, arg2)
	end

	if arg0.canceled then
		arg0.canceled = false

		return
	end

	arg0:setCurrentState(arg1)

	if arg1.changed ~= nil then
		arg0:sendNotification(arg1.changed, arg2)
	end

	arg0:sendNotification(var1.CHANGED, arg2, arg1.name)
end

function var1.listNotificationInterests(arg0)
	return {
		var1.ACTION,
		var1.CANCEL
	}
end

function var1.handleNotification(arg0, arg1)
	local var0 = arg1:getName()

	if var0 == var1.ACTION then
		local var1 = arg1:getType()
		local var2 = arg0:getCurrentState():getTarget(var1)

		if var2 ~= nil then
			local var3 = arg0.states[var2]

			if var3 ~= nil then
				arg0:transitionTo(var3, arg1:getBody())
			else
				print("state not found, target: " .. var2)
			end
		else
			print("target not found, action: " .. var1)
		end
	elseif var0 == var1.CANCEL then
		arg0.canceled = true
	end
end

function var1.getCurrentState(arg0)
	return arg0.viewComponent
end

function var1.setCurrentState(arg0, arg1)
	arg0.viewComponent = arg1
end

return var1
