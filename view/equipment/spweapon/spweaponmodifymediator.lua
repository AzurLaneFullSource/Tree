local var0 = class("SpWeaponModifyMediator", ContextMediator)

var0.ON_REFORGE = "ON_REFORGE"
var0.ON_CONFIRM_REFORGE = "ON_CONFIRM_REFORGE"

function var0.register(arg0)
	arg0:BindEvent()

	local var0, var1 = EquipmentProxy.StaticGetSpWeapon(arg0.contextData.shipId, arg0.contextData.spWeaponUid)

	arg0.viewComponent:SetSpweaponVO(var0)
	arg0.viewComponent:SetItems(getProxy(BagProxy):getRawData())
end

function var0.BindEvent(arg0)
	arg0:bind(var0.ON_REFORGE, function(arg0)
		arg0:sendNotification(GAME.REFORGE_SPWEAPON, {
			shipId = arg0.contextData.shipId,
			uid = arg0.contextData.spWeaponUid
		})
	end)
	arg0:bind(var0.ON_CONFIRM_REFORGE, function(arg0, arg1)
		arg0:sendNotification(GAME.CONFIRM_REFORGE_SPWEAPON, {
			shipId = arg0.contextData.shipId,
			uid = arg0.contextData.spWeaponUid,
			op = arg1
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.REFORGE_SPWEAPON_DONE,
		GAME.CONFIRM_REFORGE_SPWEAPON_DONE,
		BagProxy.ITEM_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.REFORGE_SPWEAPON_DONE then
		arg0.viewComponent:SetSpweaponVO(var1)
		arg0.viewComponent:ResetMaterialMask()
		arg0.viewComponent:UpdateView()
	elseif var0 == GAME.CONFIRM_REFORGE_SPWEAPON_DONE then
		arg0.viewComponent:SetSpweaponVO(var1)
		arg0.viewComponent:UpdateView()
	elseif var0 == BagProxy.ITEM_UPDATED then
		arg0.viewComponent:SetItems(getProxy(BagProxy):getRawData())
	end
end

return var0
