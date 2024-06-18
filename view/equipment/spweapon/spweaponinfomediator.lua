local var0_0 = class("SpWeaponInfoMediator", import("view.base.ContextMediator"))

var0_0.ON_DESTROY = "SpWeaponInfoMediator:ON_DESTROY"
var0_0.ON_EQUIP = "SpWeaponInfoMediator:ON_EQUIP"
var0_0.ON_INTENSIFY = "SpWeaponInfoMediator.ON_INTENSIFY"
var0_0.ON_CHANGE = "SpWeaponInfoMediator.ON_CHANGE"
var0_0.ON_UNEQUIP = "SpWeaponInfoMediator:ON_UNEQUIP"
var0_0.ON_MOVE = "SpWeaponInfoMediator:ON_MOVE"
var0_0.ON_MODIFY = "SpWeaponInfoMediator:ON_MODIFY"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()

	if getProxy(ContextProxy):getCurrentContext().scene == SCENE.SPWEAPON_STOREHOUSE then
		arg0_1.viewComponent.fromEquipmentView = true
	end

	local var0_1 = getProxy(BayProxy):getShipById()
	local var1_1, var2_1 = unpack(arg0_1.contextData.shipVO and {
		arg0_1.contextData.shipVO:GetSpWeapon(),
		arg0_1.contextData.shipVO
	} or {
		EquipmentProxy.StaticGetSpWeapon(arg0_1.contextData.shipId, arg0_1.contextData.spWeaponUid)
	})

	if arg0_1.contextData.spWeaponConfigId then
		var1_1 = SpWeapon.New({
			id = arg0_1.contextData.spWeaponConfigId
		})
	end

	local var3_1, var4_1 = EquipmentProxy.StaticGetSpWeapon(arg0_1.contextData.oldShipId, arg0_1.contextData.oldSpWeaponUid)

	arg0_1.viewComponent:setShip(var2_1, var4_1)
	arg0_1.viewComponent:setEquipment(var1_1, var3_1)

	local var5_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var5_1)
end

function var0_0.BindEvent(arg0_2)
	arg0_2:bind(var0_0.ON_EQUIP, function(arg0_3)
		if arg0_2.contextData.oldShipId then
			arg0_2:sendNotification(GAME.EQUIP_SPWEAPON_FROM_SHIP, {
				spWeaponUid = arg0_2.contextData.oldSpWeaponUid,
				oldShipId = arg0_2.contextData.oldShipId,
				shipId = arg0_2.contextData.shipId
			})
		else
			arg0_2:sendNotification(GAME.EQUIP_SPWEAPON_TO_SHIP, {
				spWeaponUid = arg0_2.contextData.oldSpWeaponUid,
				shipId = arg0_2.contextData.shipId
			})
		end
	end)
	arg0_2:bind(var0_0.ON_UNEQUIP, function(arg0_4)
		arg0_2:sendNotification(GAME.EQUIP_SPWEAPON_TO_SHIP, {
			shipId = arg0_2.contextData.shipId
		})
		arg0_2.viewComponent:emit(BaseUI.ON_CLOSE)
	end)
	arg0_2:bind(var0_0.ON_MODIFY, function(arg0_5)
		arg0_2:addSubLayers(Context.New({
			mediator = SpWeaponModifyMediator,
			viewComponent = SpWeaponModifyLayer,
			data = {
				spWeaponUid = arg0_2.contextData.spWeaponUid,
				shipId = arg0_2.contextData.shipId
			}
		}), true)
		arg0_2.viewComponent:emit(BaseUI.ON_CLOSE)
	end)
	arg0_2:bind(var0_0.ON_INTENSIFY, function(arg0_6)
		local var0_6 = getProxy(BayProxy):getShipById(arg0_2.contextData.shipId)

		if var0_6 then
			local var1_6, var2_6 = ShipStatus.ShipStatusCheck("onModify", var0_6)

			if not var1_6 then
				pg.TipsMgr.GetInstance():ShowTips(var2_6)

				return
			end
		end

		arg0_2:addSubLayers(Context.New({
			mediator = SpWeaponUpgradeMediator,
			viewComponent = SpWeaponUpgradeLayer,
			data = {
				spWeaponUid = arg0_2.contextData.spWeaponUid,
				shipId = arg0_2.contextData.shipId
			}
		}), true, function()
			arg0_2.viewComponent:emit(BaseUI.ON_CLOSE)
		end)
	end)
	arg0_2:bind(var0_0.ON_CHANGE, function(arg0_8)
		local var0_8 = getProxy(BayProxy):getShipById(arg0_2.contextData.shipId)
		local var1_8, var2_8 = ShipStatus.ShipStatusCheck("onModify", var0_8)

		if not var1_8 then
			pg.TipsMgr.GetInstance():ShowTips(var2_8)

			return
		end

		arg0_2.viewComponent:emit(BaseUI.ON_CLOSE)
		arg0_2:sendNotification(GAME.GO_SCENE, SCENE.SPWEAPON_STOREHOUSE, {
			lock = true,
			shipId = arg0_2.contextData.shipId,
			warp = StoreHouseConst.WARP_TO_WEAPON,
			mode = StoreHouseConst.EQUIPMENT
		})
	end)
	arg0_2:bind(var0_0.ON_MOVE, function(arg0_9, arg1_9)
		arg0_2.viewComponent:emit(BaseUI.ON_CLOSE)
		arg0_2:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			page = 2,
			shipId = arg1_9
		})
	end)
end

function var0_0.listNotificationInterests(arg0_10)
	return {
		GAME.EQUIP_SPWEAPON_TO_SHIP_DONE
	}
end

function var0_0.handleNotification(arg0_11, arg1_11)
	local var0_11 = arg1_11:getName()
	local var1_11 = arg1_11:getBody()

	if var0_11 == GAME.EQUIP_SPWEAPON_TO_SHIP_DONE then
		arg0_11.viewComponent:emit(BaseUI.ON_CLOSE)
	end
end

return var0_0
