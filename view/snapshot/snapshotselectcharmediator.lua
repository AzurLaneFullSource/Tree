local var0 = class("SnapshotSelectCharMediator", import("..base.ContextMediator"))

var0.SELECT_CHAR = "SnapshotSelectCharMediator.SELECT_CHAR"

function var0.register(arg0)
	local var0 = getProxy(CollectionProxy)

	arg0.viewComponent:setShipGroups(var0:getGroups())

	local var1 = getProxy(BayProxy)

	arg0.viewComponent:setProposeList(var1:getProposeGroupList())
	arg0:bind(SnapshotSelectCharLayer.ON_INDEX, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)
	arg0:bind(SnapshotSelectCharLayer.SELECT_CHAR, function(arg0, arg1)
		arg0:sendNotification(var0.SELECT_CHAR, arg1)
	end)
end

return var0
