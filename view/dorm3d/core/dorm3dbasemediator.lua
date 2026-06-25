local var0_0 = class("Dorm3dBaseMediator", import("view.base.ContextMediator"))

function var0_0.GetDefaultSystemClasses()
	return DormConst.GetDefaultSystemClasses()
end

function var0_0.handleNotification(arg0_2, arg1_2)
	var0_0.super.handleNotification(arg0_2, arg1_2)

	local var0_2 = arg1_2:getName()
	local var1_2 = arg1_2:getBody()

	if arg0_2.viewComponent.systemManager then
		arg0_2.viewComponent.systemManager:BroadcastNotification(var0_2, var1_2)
	end
end

function var0_0.listNotificationInterests(arg0_3)
	local var0_3 = underscore.keys(arg0_3.handleDic or {})

	if arg0_3.viewComponent and arg0_3.viewComponent.systemManager then
		var0_3 = table.mergeArray(var0_3, arg0_3.viewComponent.systemManager:GetAllInterests(), true)
	else
		local var1_3 = arg0_3.GetDefaultSystemClasses()

		for iter0_3, iter1_3 in ipairs(var1_3) do
			if iter1_3.GetInterests then
				var0_3 = table.mergeArray(var0_3, iter1_3.GetInterests())
			end
		end
	end

	return var0_3
end

return var0_0
