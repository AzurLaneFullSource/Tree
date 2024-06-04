local var0 = class("AllBuffDetailMediator", import("..base.ContextMediator"))

var0.OPEN_SET_VALUE_LAYER = "AllBuffDetailMediator:OPEN_SET_VALUE_LAYER"

function var0.register(arg0)
	arg0:bind(var0.OPEN_SET_VALUE_LAYER, function()
		arg0:addSubLayers(Context.New({
			mediator = TechnologyTreeSetAttrMediator,
			viewComponent = TechnologyTreeSetAttrLayer,
			data = {
				LayerWeightMgr_weight = LayerWeightConst.TOP_LAYER
			},
			onRemoved = function()
				arg0.viewComponent:updateDetail()
			end
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0
