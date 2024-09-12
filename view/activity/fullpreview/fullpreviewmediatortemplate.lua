local var0_0 = class("FullPreviewMediatorTemplate", import("view.base.ContextMediator"))

var0_0.GO_SCENE = "FullPreviewMediator.TemplateGO_SCENE"
var0_0.CHANGE_SCENE = "FullPreviewMediatorTemplate.CHANGE_SCENE"
var0_0.GO_SUBLAYER = "FullPreviewMediatorTemplate.GO_SUBLAYER"
var0_0.GO_MINIGAME = "FullPreviewMediatorTemplate.GO_MINIGAME"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()
end

function var0_0.BindEvent(arg0_2)
	arg0_2:bind(var0_0.GO_SCENE, function(arg0_3, arg1_3, ...)
		arg0_2:sendNotification(GAME.GO_SCENE, arg1_3, ...)
	end)
	arg0_2:bind(var0_0.CHANGE_SCENE, function(arg0_4, arg1_4, ...)
		arg0_2:sendNotification(GAME.CHANGE_SCENE, arg1_4, ...)
	end)
	arg0_2:bind(var0_0.GO_SUBLAYER, function(arg0_5, arg1_5, arg2_5)
		arg0_2:addSubLayers(arg1_5, nil, arg2_5)
	end)
	arg0_2:bind(var0_0.GO_MINIGAME, function(arg0_6, arg1_6, ...)
		arg0_2:sendNotification(GAME.GO_MINI_GAME, arg1_6, ...)
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == ActivityProxy.ACTIVITY_UPDATED then
		arg0_8.viewComponent:UpdateView(var1_8)
	end
end

return var0_0
