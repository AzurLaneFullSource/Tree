local var0_0 = class("TechnologyTreeMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(TechnologyConst.OPEN_SHIP_BUFF_DETAIL, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:addSubLayers(Context.New({
			mediator = SingleBuffDetailMediator,
			viewComponent = SingleBuffDetailLayer,
			data = {
				groupID = arg1_2,
				maxLV = arg2_2,
				star = arg3_2
			}
		}))
	end)
	arg0_1:bind(TechnologyConst.CLOSE_TECHNOLOGY_NATION_LAYER, function(arg0_3)
		arg0_1:sendNotification(TechnologyConst.CLOSE_TECHNOLOGY_NATION_LAYER_NOTIFICATION)
	end)
	arg0_1:bind(TechnologyConst.OPEN_TECHNOLOGY_NATION_LAYER, function(arg0_4)
		arg0_1:addSubLayers(Context.New({
			mediator = TechnologyTreeNationMediator,
			viewComponent = TechnologyTreeNationScene,
			data = {}
		}))
	end)
	arg0_1:bind(TechnologyConst.OPEN_ALL_BUFF_DETAIL, function(arg0_5)
		arg0_1:addSubLayers(Context.New({
			mediator = AllBuffDetailMediator,
			viewComponent = AllBuffDetailLayer,
			data = {
				LayerWeightMgr_weight = LayerWeightConst.TOP_LAYER
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_6)
	return {
		TechnologyConst.UPDATE_REDPOINT_ON_TOP
	}
end

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()

	if var0_7 == TechnologyConst.UPDATE_REDPOINT_ON_TOP then
		arg0_7.viewComponent:updateRedPoint(getProxy(TechnologyNationProxy):getShowRedPointTag())
	end
end

return var0_0
