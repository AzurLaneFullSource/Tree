local var0_0 = class("IndexMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	assert(arg0_1.contextData.display)

	if arg0_1.contextData.display.sort then
		assert(arg0_1.contextData.sort)
	end

	if arg0_1.contextData.display.index then
		assert(arg0_1.contextData.index)
	end

	if arg0_1.contextData.display.camp then
		assert(arg0_1.contextData.camp)
	end

	if arg0_1.contextData.display.rarity then
		assert(arg0_1.contextData.rarity)
	end
end

function var0_0.listNotificationInterests(arg0_2)
	return {}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	return
end

return var0_0
