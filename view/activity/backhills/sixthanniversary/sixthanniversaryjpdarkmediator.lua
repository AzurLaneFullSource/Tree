local var0_0 = class("SixthAnniversaryJPDarkMediator", import("view.base.ContextMediator"))

var0_0.GO_SCENE = "GO_SCENE"
var0_0.GO_SUBLAYER = "GO_SUBLAYER"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()
end

function var0_0.BindEvent(arg0_2)
	arg0_2:bind(var0_0.GO_SCENE, function(arg0_3, arg1_3, ...)
		arg0_2:sendNotification(GAME.GO_SCENE, arg1_3, ...)
	end)
	arg0_2:bind(var0_0.GO_SUBLAYER, function(arg0_4, arg1_4, arg2_4)
		arg0_2:addSubLayers(arg1_4, nil, arg2_4)
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.SUBMIT_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_6.id == ActivityConst.MINIGAME_ZUMA then
			arg0_6.viewComponent:UpdateLevels()
			arg0_6.viewComponent:UpdateCount()
		end
	elseif var0_6 == GAME.SUBMIT_TASK_DONE then
		arg0_6.viewComponent:UpdateTaskTip()
	end
end

return var0_0
