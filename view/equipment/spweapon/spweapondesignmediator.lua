local var0 = class("SpWeaponDesignMediator", import("view.base.ContextMediator"))

var0.ON_COMPOSITE = "SpWeaponDesignMediator:ON_COMPOSITE"
var0.OPEN_EQUIPMENTDESIGN_INDEX = "SpWeaponDesignMediator:OPEN_EQUIPMENTDESIGN_INDEX"

function var0.register(arg0)
	arg0:BindEvent()
	arg0.viewComponent:setItems(getProxy(BagProxy):getRawData())

	local var0 = getProxy(EquipmentProxy)
	local var1 = {}

	_.each(SpWeapon.bindConfigTable().all, function(arg0)
		local var0 = SpWeapon.New({
			id = arg0
		})

		if var0:IsCraftable() then
			table.insert(var1, var0)
		end
	end)
	arg0.viewComponent:SetCraftList(var1)

	local var2 = getProxy(PlayerProxy):getRawData()

	arg0.viewComponent:setPlayer(var2)

	local var3 = arg0:getFacade():retrieveMediator(EquipmentMediator.__cname):getViewComponent()

	arg0.viewComponent:SetParentTF(var3._tf)
	arg0.viewComponent:SetTopContainer(var3.topPanel)
	arg0.viewComponent:SetTopItems(var3.topItems)
	arg0:UpdateSpWeapons()
end

function var0.BindEvent(arg0)
	arg0:bind(var0.ON_COMPOSITE, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = SpWeaponUpgradeMediator,
			viewComponent = SpWeaponUpgradeLayer,
			data = {
				spWeaponConfigId = arg1
			}
		}))
	end)
	arg0:bind(var0.OPEN_EQUIPMENTDESIGN_INDEX, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)
end

function var0.UpdateSpWeapons(arg0)
	local var0 = getProxy(BayProxy):GetSpWeaponsInShips()
	local var1 = _.values(getProxy(EquipmentProxy):GetSpWeapons())

	for iter0, iter1 in ipairs(var1) do
		table.insert(var0, iter1)
	end

	arg0.viewComponent:SetSpWeapons(var0)
end

function var0.listNotificationInterests(arg0)
	return {
		BagProxy.ITEM_UPDATED,
		PlayerProxy.UPDATED,
		GAME.COMPOSITE_SPWEAPON_DONE,
		GAME.EQUIP_SPWEAPON_TO_SHIP_DONE,
		EquipmentProxy.SPWEAPONS_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == BagProxy.ITEM_UPDATED then
		arg0.viewComponent:setItems(getProxy(BagProxy):getRawData())
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayer(getProxy(PlayerProxy):getRawData())
	elseif var0 == GAME.COMPOSITE_SPWEAPON_DONE then
		local var2 = getProxy(ContextProxy):getContextByMediator(EquipmentMediator):getContextByMediator(SpWeaponUpgradeMediator)

		if var2 then
			arg0:sendNotification(GAME.REMOVE_LAYERS, {
				context = var2
			})
		end
	elseif var0 == GAME.EQUIP_SPWEAPON_TO_SHIP_DONE or var0 == EquipmentProxy.SPWEAPONS_UPDATED then
		arg0:UpdateSpWeapons()
		arg0.viewComponent:filter()
	end
end

return var0
