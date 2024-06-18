local var0_0 = class("SpWeaponDesignMediator", import("view.base.ContextMediator"))

var0_0.ON_COMPOSITE = "SpWeaponDesignMediator:ON_COMPOSITE"
var0_0.OPEN_EQUIPMENTDESIGN_INDEX = "SpWeaponDesignMediator:OPEN_EQUIPMENTDESIGN_INDEX"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()
	arg0_1.viewComponent:setItems(getProxy(BagProxy):getRawData())

	local var0_1 = getProxy(EquipmentProxy)
	local var1_1 = {}

	_.each(SpWeapon.bindConfigTable().all, function(arg0_2)
		local var0_2 = SpWeapon.New({
			id = arg0_2
		})

		if var0_2:IsCraftable() then
			table.insert(var1_1, var0_2)
		end
	end)
	arg0_1.viewComponent:SetCraftList(var1_1)

	local var2_1 = getProxy(PlayerProxy):getRawData()

	arg0_1.viewComponent:setPlayer(var2_1)

	local var3_1 = arg0_1:getFacade():retrieveMediator(EquipmentMediator.__cname):getViewComponent()

	arg0_1.viewComponent:SetParentTF(var3_1._tf)
	arg0_1.viewComponent:SetTopContainer(var3_1.topPanel)
	arg0_1.viewComponent:SetTopItems(var3_1.topItems)
	arg0_1:UpdateSpWeapons()
end

function var0_0.BindEvent(arg0_3)
	arg0_3:bind(var0_0.ON_COMPOSITE, function(arg0_4, arg1_4)
		arg0_3:addSubLayers(Context.New({
			mediator = SpWeaponUpgradeMediator,
			viewComponent = SpWeaponUpgradeLayer,
			data = {
				spWeaponConfigId = arg1_4
			}
		}))
	end)
	arg0_3:bind(var0_0.OPEN_EQUIPMENTDESIGN_INDEX, function(arg0_5, arg1_5)
		arg0_3:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_5
		}))
	end)
end

function var0_0.UpdateSpWeapons(arg0_6)
	local var0_6 = getProxy(BayProxy):GetSpWeaponsInShips()
	local var1_6 = _.values(getProxy(EquipmentProxy):GetSpWeapons())

	for iter0_6, iter1_6 in ipairs(var1_6) do
		table.insert(var0_6, iter1_6)
	end

	arg0_6.viewComponent:SetSpWeapons(var0_6)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		BagProxy.ITEM_UPDATED,
		PlayerProxy.UPDATED,
		GAME.COMPOSITE_SPWEAPON_DONE,
		GAME.EQUIP_SPWEAPON_TO_SHIP_DONE,
		EquipmentProxy.SPWEAPONS_UPDATED
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == BagProxy.ITEM_UPDATED then
		arg0_8.viewComponent:setItems(getProxy(BagProxy):getRawData())
	elseif var0_8 == PlayerProxy.UPDATED then
		arg0_8.viewComponent:setPlayer(getProxy(PlayerProxy):getRawData())
	elseif var0_8 == GAME.COMPOSITE_SPWEAPON_DONE then
		local var2_8 = getProxy(ContextProxy):getContextByMediator(EquipmentMediator):getContextByMediator(SpWeaponUpgradeMediator)

		if var2_8 then
			arg0_8:sendNotification(GAME.REMOVE_LAYERS, {
				context = var2_8
			})
		end
	elseif var0_8 == GAME.EQUIP_SPWEAPON_TO_SHIP_DONE or var0_8 == EquipmentProxy.SPWEAPONS_UPDATED then
		arg0_8:UpdateSpWeapons()
		arg0_8.viewComponent:filter()
	end
end

return var0_0
