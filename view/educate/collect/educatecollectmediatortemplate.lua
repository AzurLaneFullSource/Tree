local var0_0 = class("EducateCollectMediatorTemplate", import("..base.EducateContextMediator"))

var0_0.UNLOCK = "EducateCollectMediatorTemplate.UNLOCK"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.UNLOCK, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.EDUCATE_BUY_COLLECT, {
			type = arg1_2.type,
			id = arg1_2.id,
			cost = arg1_2.cost
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		EducateProxy.CLEAR_NEW_TIP,
		GAME.EDUCATE_BUY_COLLECT_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == EducateProxy.CLEAR_NEW_TIP then
		if var1_4.index == EducateTipHelper.NEW_MEMORY or var1_4.index == EducateTipHelper.NEW_POLAROID then
			arg0_4.viewComponent:Flush()
		end
	elseif var0_4 == GAME.EDUCATE_BUY_COLLECT_DONE then
		arg0_4.viewComponent:Flush()
	end
end

return var0_0
