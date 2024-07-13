local var0_0 = class("SpWeaponUpgradeMediator", import("view.base.ContextMediator"))

var0_0.EQUIPMENT_UPGRADE = "SpWeaponUpgradeMediator:EQUIPMENT_UPGRADE"
var0_0.EQUIPMENT_COMPOSITE = "SpWeaponUpgradeMediator:EQUIPMENT_COMPOSITE"
var0_0.OPEN_EQUIPMENT_INDEX = "SpWeaponUpgradeMediator:OPEN_EQUIPMENT_INDEX"
var0_0.ON_SKILLINFO = "SpWeaponUpgradeMediator:ON_SKILLINFO"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()

	local var0_1 = getProxy(BagProxy):getData()

	arg0_1.viewComponent:setItems(var0_1)

	local var1_1 = getProxy(PlayerProxy)

	arg0_1.viewComponent:updateRes(var1_1:getData())

	local var2_1 = EquipmentProxy.StaticGetSpWeapon(arg0_1.contextData.shipId, arg0_1.contextData.spWeaponUid)

	if arg0_1.contextData.spWeaponConfigId then
		var2_1 = SpWeapon.New({
			id = arg0_1.contextData.spWeaponConfigId
		})
	end

	arg0_1.viewComponent:SetSpWeapon(var2_1)
	arg0_1:UpdateSpWeapons()
end

function var0_0.UpdateSpWeapons(arg0_2)
	local var0_2 = getProxy(BayProxy):GetSpWeaponsInShips()
	local var1_2 = _.values(getProxy(EquipmentProxy):GetSpWeapons())

	for iter0_2, iter1_2 in ipairs(var1_2) do
		table.insert(var0_2, iter1_2)
	end

	arg0_2.viewComponent:SetSpWeaponList(var0_2)
end

function var0_0.BindEvent(arg0_3)
	arg0_3:bind(var0_0.EQUIPMENT_UPGRADE, function(arg0_4, arg1_4, arg2_4, arg3_4)
		arg0_3:sendNotification(GAME.UPGRADE_SPWEAPON, {
			shipId = arg0_3.contextData.shipId,
			uid = arg1_4,
			items = arg2_4,
			consumes = arg3_4
		})
	end)
	arg0_3:bind(var0_0.EQUIPMENT_COMPOSITE, function(arg0_5, arg1_5, arg2_5, arg3_5)
		arg0_3:sendNotification(GAME.COMPOSITE_SPWEAPON, {
			id = arg1_5,
			consumeItems = arg2_5,
			consumeSpweapons = arg3_5
		})
	end)
	arg0_3:bind(var0_0.OPEN_EQUIPMENT_INDEX, function(arg0_6, arg1_6)
		arg0_3:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_6
		}))
	end)
	arg0_3:bind(var0_0.ON_SKILLINFO, function(arg0_7, arg1_7, arg2_7, arg3_7)
		arg0_3:addSubLayers(Context.New({
			mediator = SkillInfoMediator,
			viewComponent = SpWeaponSkillInfoLayer,
			data = {
				unlock = arg2_7,
				skillId = arg1_7,
				skillOnShip = {
					level = arg3_7
				}
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		BagProxy.ITEM_UPDATED,
		PlayerProxy.UPDATED,
		EquipmentProxy.SPWEAPONS_UPDATED,
		GAME.COMPOSITE_SPWEAPON_DONE,
		GAME.UPGRADE_SPWEAPON_DONE,
		GAME.EQUIP_SPWEAPON_TO_SHIP_DONE
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == GAME.COMPOSITE_SPWEAPON_DONE then
		arg0_9.viewComponent:SetSpWeapon(var1_9)
		arg0_9.viewComponent:ClearSelectMaterials()
		arg0_9.viewComponent:UpdateAll()

		if arg0_9.contextData.shipId and arg0_9.contextData.shipId > 0 then
			arg0_9:sendNotification(GAME.EQUIP_SPWEAPON_TO_SHIP, {
				spWeaponUid = var1_9:GetUID(),
				shipId = arg0_9.contextData.shipId
			})
		end
	elseif var0_9 == GAME.EQUIP_SPWEAPON_TO_SHIP_DONE then
		arg0_9.viewComponent:emit(BaseUI.ON_BACK)
	elseif var0_9 == GAME.UPGRADE_SPWEAPON_DONE then
		arg0_9.viewComponent:SetSpWeapon(var1_9)
		arg0_9.viewComponent:ClearSelectMaterials()
		arg0_9.viewComponent:UpdateAll()
	elseif var0_9 == BagProxy.ITEM_UPDATED then
		arg0_9.viewComponent:setItems(getProxy(BagProxy):getData())
	elseif var0_9 == PlayerProxy.UPDATED then
		arg0_9.viewComponent:updateRes(getProxy(PlayerProxy):getData())
	elseif var0_9 == EquipmentProxy.SPWEAPONS_UPDATED then
		arg0_9:UpdateSpWeapons()
		arg0_9.viewComponent:UpdateCraftTargetCount()
	end
end

return var0_0
