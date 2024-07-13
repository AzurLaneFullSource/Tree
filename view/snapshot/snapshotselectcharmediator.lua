local var0_0 = class("SnapshotSelectCharMediator", import("..base.ContextMediator"))

var0_0.SELECT_CHAR = "SnapshotSelectCharMediator.SELECT_CHAR"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(CollectionProxy)

	arg0_1.viewComponent:setShipGroups(var0_1:getGroups())

	local var1_1 = getProxy(BayProxy)

	arg0_1.viewComponent:setProposeList(var1_1:getProposeGroupList())
	arg0_1:bind(SnapshotSelectCharLayer.ON_INDEX, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_2
		}))
	end)
	arg0_1:bind(SnapshotSelectCharLayer.SELECT_CHAR, function(arg0_3, arg1_3)
		arg0_1:sendNotification(var0_0.SELECT_CHAR, arg1_3)
	end)
end

return var0_0
