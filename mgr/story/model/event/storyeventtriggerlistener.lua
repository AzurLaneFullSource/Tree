local var0 = class("StoryEventTriggerListener", pm.Mediator)

function var0.Ctor(arg0, arg1)
	arg0.eventList = arg1

	var0.super.Ctor(arg0)
	pg.m02:registerMediator(arg0)

	arg0.caches = {}
end

function var0.listNotificationInterests(arg0)
	return arg0.eventList
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	print(var0, var1)

	arg0.caches[var0] = {
		var1
	}
end

function var0.Clear(arg0)
	arg0.caches = {}
end

function var0.ExistCache(arg0, arg1)
	return arg0.caches[arg1] ~= nil
end

function var0.ExistArg(arg0, arg1)
	return arg0.caches[arg1][1] ~= nil
end

function var0.GetArg(arg0, arg1)
	if not arg0:ExistCache(arg1) then
		return nil
	end

	if not arg0:ExistArg(arg1) then
		return nil
	end

	return arg0.caches[arg1][1]
end

function var0.Dispose(arg0)
	arg0:Clear()
	pg.m02:removeMediator(arg0.__cname)
end

return var0
