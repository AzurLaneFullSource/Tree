local var0 = class("NewBackYardShopMediator", import("...base.ContextMediator"))

var0.ON_SHOPPING = "NewBackYardShopMediator:ON_SHOPPING"
var0.ON_CHARGE = "NewBackYardShopMediator:ON_CHARGE"

function var0.register(arg0)
	arg0:bind(var0.ON_SHOPPING, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.BUY_FURNITURE, {
			furnitureIds = arg1,
			type = arg2
		})
	end)
	arg0:bind(var0.ON_CHARGE, function(arg0, arg1)
		if arg0.contextData.onDeattch then
			arg0.contextData.onDeattch = nil
		end

		local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(CourtYardMediator)

		if var0 then
			var0.data.skipToCharge = true
		end

		if arg1 == PlayerConst.ResDiamond then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
				wrap = ChargeScene.TYPE_DIAMOND
			})
		elseif arg1 == PlayerConst.ResDormMoney then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
		end
	end)
	arg0.viewComponent:SetDorm(getProxy(DormProxy):getRawData())
	arg0.viewComponent:SetPlayer(getProxy(PlayerProxy):getRawData())
end

function var0.remove(arg0)
	if arg0.contextData.onRemove then
		arg0.contextData.onRemove()
	end
end

function var0.listNotificationInterests(arg0)
	return {
		PlayerProxy.UPDATED,
		GAME.BUY_FURNITURE_DONE,
		DormProxy.DORM_UPDATEED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
	local var2 = arg1:getType()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:PlayerUpdated(var1)
	elseif var0 == GAME.BUY_FURNITURE_DONE then
		arg0.viewComponent:FurnituresUpdated(var2)
	elseif var0 == DormProxy.DORM_UPDATEED then
		arg0.viewComponent:DormUpdated(getProxy(DormProxy):getRawData())
	end
end

return var0
