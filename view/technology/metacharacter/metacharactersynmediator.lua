local var0_0 = class("MetaCharacterSynMediator", import("...base.ContextMediator"))

var0_0.OPEN_PT_GET_WAY_LAYER = "MetaCharacterSynMediator:OPEN_PT_GET_WAY_LAYER"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_PT_GET_WAY_LAYER, function(arg0_2)
		arg0_1:addSubLayers(Context.New({
			viewComponent = MetaPTGetPreviewLayer,
			mediator = MetaPTGetPreviewMediator,
			data = {}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.ACT_NEW_PT_DONE,
		GAME.GET_META_PT_AWARD_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.GET_META_PT_AWARD_DONE then
		arg0_4.viewComponent:updateData()
		arg0_4.viewComponent:updateTaskList()
		arg0_4.viewComponent:updateGetAwardBtn()
	end
end

return var0_0
