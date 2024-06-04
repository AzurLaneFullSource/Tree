local var0 = class("SpWeaponInfoMediator", import("view.base.ContextMediator"))

var0.ON_DESTROY = "SpWeaponInfoMediator:ON_DESTROY"
var0.ON_EQUIP = "SpWeaponInfoMediator:ON_EQUIP"
var0.ON_INTENSIFY = "SpWeaponInfoMediator.ON_INTENSIFY"
var0.ON_CHANGE = "SpWeaponInfoMediator.ON_CHANGE"
var0.ON_UNEQUIP = "SpWeaponInfoMediator:ON_UNEQUIP"
var0.ON_MOVE = "SpWeaponInfoMediator:ON_MOVE"
var0.ON_MODIFY = "SpWeaponInfoMediator:ON_MODIFY"

function var0.register(arg0)
	arg0:BindEvent()

	if getProxy(ContextProxy):getCurrentContext().scene == SCENE.SPWEAPON_STOREHOUSE then
		arg0.viewComponent.fromEquipmentView = true
	end

	local var0 = getProxy(BayProxy):getShipById()
	local var1, var2 = unpack(arg0.contextData.shipVO and {
		arg0.contextData.shipVO:GetSpWeapon(),
		arg0.contextData.shipVO
	} or {
		EquipmentProxy.StaticGetSpWeapon(arg0.contextData.shipId, arg0.contextData.spWeaponUid)
	})

	if arg0.contextData.spWeaponConfigId then
		var1 = SpWeapon.New({
			id = arg0.contextData.spWeaponConfigId
		})
	end

	local var3, var4 = EquipmentProxy.StaticGetSpWeapon(arg0.contextData.oldShipId, arg0.contextData.oldSpWeaponUid)

	arg0.viewComponent:setShip(var2, var4)
	arg0.viewComponent:setEquipment(var1, var3)

	local var5 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayer(var5)
end

function var0.BindEvent(arg0)
	arg0:bind(var0.ON_EQUIP, function(arg0)
		if arg0.contextData.oldShipId then
			arg0:sendNotification(GAME.EQUIP_SPWEAPON_FROM_SHIP, {
				spWeaponUid = arg0.contextData.oldSpWeaponUid,
				oldShipId = arg0.contextData.oldShipId,
				shipId = arg0.contextData.shipId
			})
		else
			arg0:sendNotification(GAME.EQUIP_SPWEAPON_TO_SHIP, {
				spWeaponUid = arg0.contextData.oldSpWeaponUid,
				shipId = arg0.contextData.shipId
			})
		end
	end)
	arg0:bind(var0.ON_UNEQUIP, function(arg0)
		arg0:sendNotification(GAME.EQUIP_SPWEAPON_TO_SHIP, {
			shipId = arg0.contextData.shipId
		})
		arg0.viewComponent:emit(BaseUI.ON_CLOSE)
	end)
	arg0:bind(var0.ON_MODIFY, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = SpWeaponModifyMediator,
			viewComponent = SpWeaponModifyLayer,
			data = {
				spWeaponUid = arg0.contextData.spWeaponUid,
				shipId = arg0.contextData.shipId
			}
		}), true)
		arg0.viewComponent:emit(BaseUI.ON_CLOSE)
	end)
	arg0:bind(var0.ON_INTENSIFY, function(arg0)
		local var0 = getProxy(BayProxy):getShipById(arg0.contextData.shipId)

		if var0 then
			local var1, var2 = ShipStatus.ShipStatusCheck("onModify", var0)

			if not var1 then
				pg.TipsMgr.GetInstance():ShowTips(var2)

				return
			end
		end

		arg0:addSubLayers(Context.New({
			mediator = SpWeaponUpgradeMediator,
			viewComponent = SpWeaponUpgradeLayer,
			data = {
				spWeaponUid = arg0.contextData.spWeaponUid,
				shipId = arg0.contextData.shipId
			}
		}), true, function()
			arg0.viewComponent:emit(BaseUI.ON_CLOSE)
		end)
	end)
	arg0:bind(var0.ON_CHANGE, function(arg0)
		local var0 = getProxy(BayProxy):getShipById(arg0.contextData.shipId)
		local var1, var2 = ShipStatus.ShipStatusCheck("onModify", var0)

		if not var1 then
			pg.TipsMgr.GetInstance():ShowTips(var2)

			return
		end

		arg0.viewComponent:emit(BaseUI.ON_CLOSE)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SPWEAPON_STOREHOUSE, {
			lock = true,
			shipId = arg0.contextData.shipId,
			warp = StoreHouseConst.WARP_TO_WEAPON,
			mode = StoreHouseConst.EQUIPMENT
		})
	end)
	arg0:bind(var0.ON_MOVE, function(arg0, arg1)
		arg0.viewComponent:emit(BaseUI.ON_CLOSE)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			page = 2,
			shipId = arg1
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.EQUIP_SPWEAPON_TO_SHIP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.EQUIP_SPWEAPON_TO_SHIP_DONE then
		arg0.viewComponent:emit(BaseUI.ON_CLOSE)
	end
end

return var0
