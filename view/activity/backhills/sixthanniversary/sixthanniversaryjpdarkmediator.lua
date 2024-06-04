local var0 = class("SixthAnniversaryJPDarkMediator", import("view.base.ContextMediator"))

var0.GO_SCENE = "GO_SCENE"
var0.GO_SUBLAYER = "GO_SUBLAYER"

function var0.register(arg0)
	arg0:BindEvent()
end

function var0.BindEvent(arg0)
	arg0:bind(var0.GO_SCENE, function(arg0, arg1, ...)
		arg0:sendNotification(GAME.GO_SCENE, arg1, ...)
	end)
	arg0:bind(var0.GO_SUBLAYER, function(arg0, arg1, arg2)
		arg0:addSubLayers(arg1, nil, arg2)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.SUBMIT_TASK_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1.id == ActivityConst.MINIGAME_ZUMA then
			arg0.viewComponent:UpdateLevels()
			arg0.viewComponent:UpdateCount()
		end
	elseif var0 == GAME.SUBMIT_TASK_DONE then
		arg0.viewComponent:UpdateTaskTip()
	end
end

return var0
