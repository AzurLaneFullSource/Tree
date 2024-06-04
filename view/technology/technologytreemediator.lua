local var0 = class("TechnologyTreeMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	arg0:bind(TechnologyConst.OPEN_SHIP_BUFF_DETAIL, function(arg0, arg1, arg2, arg3)
		arg0:addSubLayers(Context.New({
			mediator = SingleBuffDetailMediator,
			viewComponent = SingleBuffDetailLayer,
			data = {
				groupID = arg1,
				maxLV = arg2,
				star = arg3
			}
		}))
	end)
	arg0:bind(TechnologyConst.CLOSE_TECHNOLOGY_NATION_LAYER, function(arg0)
		arg0:sendNotification(TechnologyConst.CLOSE_TECHNOLOGY_NATION_LAYER_NOTIFICATION)
	end)
	arg0:bind(TechnologyConst.OPEN_TECHNOLOGY_NATION_LAYER, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = TechnologyTreeNationMediator,
			viewComponent = TechnologyTreeNationScene,
			data = {}
		}))
	end)
	arg0:bind(TechnologyConst.OPEN_ALL_BUFF_DETAIL, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = AllBuffDetailMediator,
			viewComponent = AllBuffDetailLayer,
			data = {
				LayerWeightMgr_weight = LayerWeightConst.TOP_LAYER
			}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		TechnologyConst.UPDATE_REDPOINT_ON_TOP
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == TechnologyConst.UPDATE_REDPOINT_ON_TOP then
		arg0.viewComponent:updateRedPoint(getProxy(TechnologyNationProxy):getShowRedPointTag())
	end
end

return var0
