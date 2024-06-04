local var0 = class("SpWeaponStoreHouseMediator", import("view.base.ContextMediator"))

var0.ON_COMPOSITE = "SpWeaponStoreHouseMediator:ON_COMPOSITE"
var0.ON_UNEQUIP = "SpWeaponStoreHouseMediator:ON_UNEQUIP"
var0.OPEN_EQUIPMENT_INDEX = "OPEN_EQUIPMENT_INDEX"

function var0.register(arg0)
	arg0:BindEvent()

	local var0 = getProxy(BayProxy):getShipById(arg0.contextData.shipId)

	arg0.viewComponent:setShip(var0)

	if var0 and arg0.contextData.mode == StoreHouseConst.EQUIPMENT then
		arg0.contextData.qiutBtn = var0:GetSpWeapon()
	end

	local var1 = {}

	_.each(SpWeapon.bindConfigTable().all, function(arg0)
		local var0 = SpWeapon.New({
			id = arg0
		})

		if var0:IsCraftable() and (not var0 or not var0:IsSpWeaponForbidden(var0)) then
			table.insert(var1, var0)
		end
	end)
	arg0.viewComponent:SetCraftList(var1)
	arg0:UpdateSpWeapons()

	local var2 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayer(var2)
end

function var0.UpdateSpWeapons(arg0)
	local var0 = getProxy(BayProxy):RawGetShipById(arg0.contextData.shipId)
	local var1 = getProxy(BayProxy):GetSpWeaponsInShips(var0)
	local var2 = _.values(getProxy(EquipmentProxy):GetSpWeapons())

	for iter0, iter1 in ipairs(var2) do
		if not var0 or not var0:IsSpWeaponForbidden(iter1) then
			table.insert(var1, iter1)
		end
	end

	arg0.viewComponent:setEquipments(var1)
end

function var0.BindEvent(arg0)
	arg0:bind(var0.ON_UNEQUIP, function(arg0)
		arg0:sendNotification(GAME.EQUIP_SPWEAPON_TO_SHIP, {
			shipId = arg0.contextData.shipId
		})
	end)
	arg0:bind(var0.OPEN_EQUIPMENT_INDEX, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)
	arg0:bind(var0.ON_COMPOSITE, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = SpWeaponUpgradeMediator,
			viewComponent = SpWeaponUpgradeLayer,
			data = {
				spWeaponConfigId = arg1,
				shipId = arg0.contextData.shipId
			}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		PlayerProxy.UPDATED,
		BayProxy.SHIP_UPDATED,
		GAME.EQUIP_SPWEAPON_TO_SHIP_DONE,
		EquipmentProxy.SPWEAPONS_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == BayProxy.SHIP_UPDATED then
		if var1.id == arg0.contextData.shipId then
			arg0.viewComponent:setShip(var1)
		end
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayer(var1)
	elseif var0 == GAME.EQUIP_SPWEAPON_TO_SHIP_DONE then
		arg0.viewComponent:emit(BaseUI.ON_BACK)
	elseif var0 == EquipmentProxy.SPWEAPONS_UPDATED then
		arg0:UpdateSpWeapons()
		arg0.viewComponent:setEquipmentUpdate()
	end
end

return var0
