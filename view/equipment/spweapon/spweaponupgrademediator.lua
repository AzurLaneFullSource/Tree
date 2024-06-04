local var0 = class("SpWeaponUpgradeMediator", import("view.base.ContextMediator"))

var0.EQUIPMENT_UPGRADE = "SpWeaponUpgradeMediator:EQUIPMENT_UPGRADE"
var0.EQUIPMENT_COMPOSITE = "SpWeaponUpgradeMediator:EQUIPMENT_COMPOSITE"
var0.OPEN_EQUIPMENT_INDEX = "SpWeaponUpgradeMediator:OPEN_EQUIPMENT_INDEX"
var0.ON_SKILLINFO = "SpWeaponUpgradeMediator:ON_SKILLINFO"

function var0.register(arg0)
	arg0:BindEvent()

	local var0 = getProxy(BagProxy):getData()

	arg0.viewComponent:setItems(var0)

	local var1 = getProxy(PlayerProxy)

	arg0.viewComponent:updateRes(var1:getData())

	local var2 = EquipmentProxy.StaticGetSpWeapon(arg0.contextData.shipId, arg0.contextData.spWeaponUid)

	if arg0.contextData.spWeaponConfigId then
		var2 = SpWeapon.New({
			id = arg0.contextData.spWeaponConfigId
		})
	end

	arg0.viewComponent:SetSpWeapon(var2)
	arg0:UpdateSpWeapons()
end

function var0.UpdateSpWeapons(arg0)
	local var0 = getProxy(BayProxy):GetSpWeaponsInShips()
	local var1 = _.values(getProxy(EquipmentProxy):GetSpWeapons())

	for iter0, iter1 in ipairs(var1) do
		table.insert(var0, iter1)
	end

	arg0.viewComponent:SetSpWeaponList(var0)
end

function var0.BindEvent(arg0)
	arg0:bind(var0.EQUIPMENT_UPGRADE, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.UPGRADE_SPWEAPON, {
			shipId = arg0.contextData.shipId,
			uid = arg1,
			items = arg2,
			consumes = arg3
		})
	end)
	arg0:bind(var0.EQUIPMENT_COMPOSITE, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.COMPOSITE_SPWEAPON, {
			id = arg1,
			consumeItems = arg2,
			consumeSpweapons = arg3
		})
	end)
	arg0:bind(var0.OPEN_EQUIPMENT_INDEX, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)
	arg0:bind(var0.ON_SKILLINFO, function(arg0, arg1, arg2, arg3)
		arg0:addSubLayers(Context.New({
			mediator = SkillInfoMediator,
			viewComponent = SpWeaponSkillInfoLayer,
			data = {
				unlock = arg2,
				skillId = arg1,
				skillOnShip = {
					level = arg3
				}
			}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		BagProxy.ITEM_UPDATED,
		PlayerProxy.UPDATED,
		EquipmentProxy.SPWEAPONS_UPDATED,
		GAME.COMPOSITE_SPWEAPON_DONE,
		GAME.UPGRADE_SPWEAPON_DONE,
		GAME.EQUIP_SPWEAPON_TO_SHIP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.COMPOSITE_SPWEAPON_DONE then
		arg0.viewComponent:SetSpWeapon(var1)
		arg0.viewComponent:ClearSelectMaterials()
		arg0.viewComponent:UpdateAll()

		if arg0.contextData.shipId and arg0.contextData.shipId > 0 then
			arg0:sendNotification(GAME.EQUIP_SPWEAPON_TO_SHIP, {
				spWeaponUid = var1:GetUID(),
				shipId = arg0.contextData.shipId
			})
		end
	elseif var0 == GAME.EQUIP_SPWEAPON_TO_SHIP_DONE then
		arg0.viewComponent:emit(BaseUI.ON_BACK)
	elseif var0 == GAME.UPGRADE_SPWEAPON_DONE then
		arg0.viewComponent:SetSpWeapon(var1)
		arg0.viewComponent:ClearSelectMaterials()
		arg0.viewComponent:UpdateAll()
	elseif var0 == BagProxy.ITEM_UPDATED then
		arg0.viewComponent:setItems(getProxy(BagProxy):getData())
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:updateRes(getProxy(PlayerProxy):getData())
	elseif var0 == EquipmentProxy.SPWEAPONS_UPDATED then
		arg0:UpdateSpWeapons()
		arg0.viewComponent:UpdateCraftTargetCount()
	end
end

return var0
