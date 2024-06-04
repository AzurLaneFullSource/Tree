local var0 = class("IndexMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	assert(arg0.contextData.display)

	if arg0.contextData.display.sort then
		assert(arg0.contextData.sort)
	end

	if arg0.contextData.display.index then
		assert(arg0.contextData.index)
	end

	if arg0.contextData.display.camp then
		assert(arg0.contextData.camp)
	end

	if arg0.contextData.display.rarity then
		assert(arg0.contextData.rarity)
	end
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	return
end

return var0
