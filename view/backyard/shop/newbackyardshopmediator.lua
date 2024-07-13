local var0_0 = class("NewBackYardShopMediator", import("...base.ContextMediator"))

var0_0.ON_SHOPPING = "NewBackYardShopMediator:ON_SHOPPING"
var0_0.ON_CHARGE = "NewBackYardShopMediator:ON_CHARGE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_SHOPPING, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.BUY_FURNITURE, {
			furnitureIds = arg1_2,
			type = arg2_2
		})
	end)
	arg0_1:bind(var0_0.ON_CHARGE, function(arg0_3, arg1_3)
		if arg0_1.contextData.onDeattch then
			arg0_1.contextData.onDeattch = nil
		end

		local var0_3 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(CourtYardMediator)

		if var0_3 then
			var0_3.data.skipToCharge = true
		end

		if arg1_3 == PlayerConst.ResDiamond then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
				wrap = ChargeScene.TYPE_DIAMOND
			})
		elseif arg1_3 == PlayerConst.ResDormMoney then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
		end
	end)
	arg0_1.viewComponent:SetDorm(getProxy(DormProxy):getRawData())
	arg0_1.viewComponent:SetPlayer(getProxy(PlayerProxy):getRawData())
end

function var0_0.remove(arg0_4)
	if arg0_4.contextData.onRemove then
		arg0_4.contextData.onRemove()
	end
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		PlayerProxy.UPDATED,
		GAME.BUY_FURNITURE_DONE,
		DormProxy.DORM_UPDATEED
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()
	local var2_6 = arg1_6:getType()

	if var0_6 == PlayerProxy.UPDATED then
		arg0_6.viewComponent:PlayerUpdated(var1_6)
	elseif var0_6 == GAME.BUY_FURNITURE_DONE then
		arg0_6.viewComponent:FurnituresUpdated(var2_6)
	elseif var0_6 == DormProxy.DORM_UPDATEED then
		arg0_6.viewComponent:DormUpdated(getProxy(DormProxy):getRawData())
	end
end

return var0_0
