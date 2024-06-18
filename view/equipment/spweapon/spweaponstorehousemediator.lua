local var0_0 = class("SpWeaponStoreHouseMediator", import("view.base.ContextMediator"))

var0_0.ON_COMPOSITE = "SpWeaponStoreHouseMediator:ON_COMPOSITE"
var0_0.ON_UNEQUIP = "SpWeaponStoreHouseMediator:ON_UNEQUIP"
var0_0.OPEN_EQUIPMENT_INDEX = "OPEN_EQUIPMENT_INDEX"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()

	local var0_1 = getProxy(BayProxy):getShipById(arg0_1.contextData.shipId)

	arg0_1.viewComponent:setShip(var0_1)

	if var0_1 and arg0_1.contextData.mode == StoreHouseConst.EQUIPMENT then
		arg0_1.contextData.qiutBtn = var0_1:GetSpWeapon()
	end

	local var1_1 = {}

	_.each(SpWeapon.bindConfigTable().all, function(arg0_2)
		local var0_2 = SpWeapon.New({
			id = arg0_2
		})

		if var0_2:IsCraftable() and (not var0_1 or not var0_1:IsSpWeaponForbidden(var0_2)) then
			table.insert(var1_1, var0_2)
		end
	end)
	arg0_1.viewComponent:SetCraftList(var1_1)
	arg0_1:UpdateSpWeapons()

	local var2_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var2_1)
end

function var0_0.UpdateSpWeapons(arg0_3)
	local var0_3 = getProxy(BayProxy):RawGetShipById(arg0_3.contextData.shipId)
	local var1_3 = getProxy(BayProxy):GetSpWeaponsInShips(var0_3)
	local var2_3 = _.values(getProxy(EquipmentProxy):GetSpWeapons())

	for iter0_3, iter1_3 in ipairs(var2_3) do
		if not var0_3 or not var0_3:IsSpWeaponForbidden(iter1_3) then
			table.insert(var1_3, iter1_3)
		end
	end

	arg0_3.viewComponent:setEquipments(var1_3)
end

function var0_0.BindEvent(arg0_4)
	arg0_4:bind(var0_0.ON_UNEQUIP, function(arg0_5)
		arg0_4:sendNotification(GAME.EQUIP_SPWEAPON_TO_SHIP, {
			shipId = arg0_4.contextData.shipId
		})
	end)
	arg0_4:bind(var0_0.OPEN_EQUIPMENT_INDEX, function(arg0_6, arg1_6)
		arg0_4:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_6
		}))
	end)
	arg0_4:bind(var0_0.ON_COMPOSITE, function(arg0_7, arg1_7)
		arg0_4:addSubLayers(Context.New({
			mediator = SpWeaponUpgradeMediator,
			viewComponent = SpWeaponUpgradeLayer,
			data = {
				spWeaponConfigId = arg1_7,
				shipId = arg0_4.contextData.shipId
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		PlayerProxy.UPDATED,
		BayProxy.SHIP_UPDATED,
		GAME.EQUIP_SPWEAPON_TO_SHIP_DONE,
		EquipmentProxy.SPWEAPONS_UPDATED
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == BayProxy.SHIP_UPDATED then
		if var1_9.id == arg0_9.contextData.shipId then
			arg0_9.viewComponent:setShip(var1_9)
		end
	elseif var0_9 == PlayerProxy.UPDATED then
		arg0_9.viewComponent:setPlayer(var1_9)
	elseif var0_9 == GAME.EQUIP_SPWEAPON_TO_SHIP_DONE then
		arg0_9.viewComponent:emit(BaseUI.ON_BACK)
	elseif var0_9 == EquipmentProxy.SPWEAPONS_UPDATED then
		arg0_9:UpdateSpWeapons()
		arg0_9.viewComponent:setEquipmentUpdate()
	end
end

return var0_0
