local var0_0 = class("AllBuffDetailMediator", import("..base.ContextMediator"))

var0_0.OPEN_SET_VALUE_LAYER = "AllBuffDetailMediator:OPEN_SET_VALUE_LAYER"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_SET_VALUE_LAYER, function()
		arg0_1:addSubLayers(Context.New({
			mediator = TechnologyTreeSetAttrMediator,
			viewComponent = TechnologyTreeSetAttrLayer,
			data = {
				LayerWeightMgr_weight = LayerWeightConst.TOP_LAYER
			},
			onRemoved = function()
				arg0_1.viewComponent:updateDetail()
			end
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()
end

return var0_0
