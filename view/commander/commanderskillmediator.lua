local var0 = class("CommanderSkillMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	if arg0.contextData.isWorld then
		arg0.contextData.commonFlag = false
	end
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0
