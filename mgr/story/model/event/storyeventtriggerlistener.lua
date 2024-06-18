local var0_0 = class("StoryEventTriggerListener", pm.Mediator)

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.eventList = arg1_1

	var0_0.super.Ctor(arg0_1)
	pg.m02:registerMediator(arg0_1)

	arg0_1.caches = {}
end

function var0_0.listNotificationInterests(arg0_2)
	return arg0_2.eventList
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	print(var0_3, var1_3)

	arg0_3.caches[var0_3] = {
		var1_3
	}
end

function var0_0.Clear(arg0_4)
	arg0_4.caches = {}
end

function var0_0.ExistCache(arg0_5, arg1_5)
	return arg0_5.caches[arg1_5] ~= nil
end

function var0_0.ExistArg(arg0_6, arg1_6)
	return arg0_6.caches[arg1_6][1] ~= nil
end

function var0_0.GetArg(arg0_7, arg1_7)
	if not arg0_7:ExistCache(arg1_7) then
		return nil
	end

	if not arg0_7:ExistArg(arg1_7) then
		return nil
	end

	return arg0_7.caches[arg1_7][1]
end

function var0_0.Dispose(arg0_8)
	arg0_8:Clear()
	pg.m02:removeMediator(arg0_8.__cname)
end

return var0_0
