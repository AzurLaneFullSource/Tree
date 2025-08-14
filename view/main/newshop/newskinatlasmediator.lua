local var0_0 = class("NewSkinAtlasMediator", import("...base.ContextMediator"))

var0_0.OPEN_SHOW_LAYER = "NewSkinAtlasMediator.OPEN_SHOW_LAYER"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_SHOW_LAYER, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			viewComponent = NewSkinShowLayer,
			mediator = NewSkinShowMediator,
			data = {
				skin = arg1_2
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		PlayerProxy.UPDATED
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == PlayerProxy.UPDATED then
		arg0_4.viewComponent:SetResource()
	end
end

return var0_0
