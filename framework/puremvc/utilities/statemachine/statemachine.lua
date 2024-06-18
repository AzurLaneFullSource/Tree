local var0_0 = import("...patterns.mediator.Mediator")
local var1_0 = class("StateMachine", var0_0)

var1_0.NAME = "StateMachine"
var1_0.ACTION = var1_0.NAME .. "/notes/action"
var1_0.CHANGED = var1_0.NAME .. "/notes/changed"
var1_0.CANCEL = var1_0.NAME .. "/notes/cancel"

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1, var1_0.NAME, null)

	arg0_1.states = {}
end

function var1_0.onRegister(arg0_2)
	if arg0_2.initial ~= nil then
		arg0_2:transitionTo(arg0_2.initial, null)
	end
end

function var1_0.registerState(arg0_3, arg1_3, arg2_3)
	if arg1_3 == nil or arg0_3.states[arg1_3.name] ~= nil then
		return
	end

	arg0_3.states[arg1_3.name] = arg1_3

	if arg2_3 then
		arg0_3.initial = arg1_3
	end
end

function var1_0.retrieveState(arg0_4, arg1_4)
	return arg0_4.states[arg1_4]
end

function var1_0.removeState(arg0_5, arg1_5)
	if arg0_5.states[arg1_5] == nil then
		return
	end

	arg0_5.states[arg1_5] = nil
end

function var1_0.transitionTo(arg0_6, arg1_6, arg2_6)
	if arg1_6 == nil then
		return
	end

	arg0_6.canceled = false

	local var0_6 = arg0_6:getCurrentState()

	if var0_6 ~= nil and var0_6.exiting ~= nil then
		arg0_6:sendNotification(var0_6.exiting, arg2_6, arg1_6.name)
	end

	if arg0_6.canceled then
		arg0_6.canceled = false

		return
	end

	if arg1_6.entering ~= nil then
		arg0_6:sendNotification(arg1_6.entering, arg2_6)
	end

	if arg0_6.canceled then
		arg0_6.canceled = false

		return
	end

	arg0_6:setCurrentState(arg1_6)

	if arg1_6.changed ~= nil then
		arg0_6:sendNotification(arg1_6.changed, arg2_6)
	end

	arg0_6:sendNotification(var1_0.CHANGED, arg2_6, arg1_6.name)
end

function var1_0.listNotificationInterests(arg0_7)
	return {
		var1_0.ACTION,
		var1_0.CANCEL
	}
end

function var1_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()

	if var0_8 == var1_0.ACTION then
		local var1_8 = arg1_8:getType()
		local var2_8 = arg0_8:getCurrentState():getTarget(var1_8)

		if var2_8 ~= nil then
			local var3_8 = arg0_8.states[var2_8]

			if var3_8 ~= nil then
				arg0_8:transitionTo(var3_8, arg1_8:getBody())
			else
				print("state not found, target: " .. var2_8)
			end
		else
			print("target not found, action: " .. var1_8)
		end
	elseif var0_8 == var1_0.CANCEL then
		arg0_8.canceled = true
	end
end

function var1_0.getCurrentState(arg0_9)
	return arg0_9.viewComponent
end

function var1_0.setCurrentState(arg0_10, arg1_10)
	arg0_10.viewComponent = arg1_10
end

return var1_0
