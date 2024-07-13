local var0_0 = class("SpWeaponModifyMediator", ContextMediator)

var0_0.ON_REFORGE = "ON_REFORGE"
var0_0.ON_CONFIRM_REFORGE = "ON_CONFIRM_REFORGE"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()

	local var0_1, var1_1 = EquipmentProxy.StaticGetSpWeapon(arg0_1.contextData.shipId, arg0_1.contextData.spWeaponUid)

	arg0_1.viewComponent:SetSpweaponVO(var0_1)
	arg0_1.viewComponent:SetItems(getProxy(BagProxy):getRawData())
end

function var0_0.BindEvent(arg0_2)
	arg0_2:bind(var0_0.ON_REFORGE, function(arg0_3)
		arg0_2:sendNotification(GAME.REFORGE_SPWEAPON, {
			shipId = arg0_2.contextData.shipId,
			uid = arg0_2.contextData.spWeaponUid
		})
	end)
	arg0_2:bind(var0_0.ON_CONFIRM_REFORGE, function(arg0_4, arg1_4)
		arg0_2:sendNotification(GAME.CONFIRM_REFORGE_SPWEAPON, {
			shipId = arg0_2.contextData.shipId,
			uid = arg0_2.contextData.spWeaponUid,
			op = arg1_4
		})
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.REFORGE_SPWEAPON_DONE,
		GAME.CONFIRM_REFORGE_SPWEAPON_DONE,
		BagProxy.ITEM_UPDATED
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.REFORGE_SPWEAPON_DONE then
		arg0_6.viewComponent:SetSpweaponVO(var1_6)
		arg0_6.viewComponent:ResetMaterialMask()
		arg0_6.viewComponent:UpdateView()
	elseif var0_6 == GAME.CONFIRM_REFORGE_SPWEAPON_DONE then
		arg0_6.viewComponent:SetSpweaponVO(var1_6)
		arg0_6.viewComponent:UpdateView()
	elseif var0_6 == BagProxy.ITEM_UPDATED then
		arg0_6.viewComponent:SetItems(getProxy(BagProxy):getRawData())
	end
end

return var0_0
