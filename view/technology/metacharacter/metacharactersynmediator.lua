local var0 = class("MetaCharacterSynMediator", import("...base.ContextMediator"))

var0.OPEN_PT_GET_WAY_LAYER = "MetaCharacterSynMediator:OPEN_PT_GET_WAY_LAYER"

function var0.register(arg0)
	arg0:bind(var0.OPEN_PT_GET_WAY_LAYER, function(arg0)
		arg0:addSubLayers(Context.New({
			viewComponent = MetaPTGetPreviewLayer,
			mediator = MetaPTGetPreviewMediator,
			data = {}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.ACT_NEW_PT_DONE,
		GAME.GET_META_PT_AWARD_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.GET_META_PT_AWARD_DONE then
		arg0.viewComponent:updateData()
		arg0.viewComponent:updateTaskList()
		arg0.viewComponent:updateGetAwardBtn()
	end
end

return var0
