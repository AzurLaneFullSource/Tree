local var0 = class("WorldInventoryMediator", import("..base.ContextMediator"))

var0.OnUseItem = "WorldInventoryMediator.OnUseItem"
var0.OnMap = "WorldInventoryMediator.OnMap"
var0.OnOpenAllocateLayer = "WorldInventoryMediator.OnOpenAllocateLayer"
var0.OPEN_MODULEINFO_LAYER = "WorldInventoryMediator:OPEN_MODULEINFO_LAYER"
var0.OPEN_EQUIPMENT_INDEX = "OPEN_EQUIPMENT_INDEX"

function var0.register(arg0)
	arg0:bind(var0.OnUseItem, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.WORLD_ITEM_USE, {
			itemID = arg1,
			count = arg2 or 1,
			args = arg3
		})
	end)
	arg0:bind(var0.OnMap, function(arg0, arg1)
		local var0 = nowWorld():FindTreasureEntrance(arg1)
		local var1

		for iter0, iter1 in ipairs(var0.config.teasure_chapter) do
			if arg1 == iter1[1] then
				var1 = iter1[2]

				break
			end
		end

		arg0:sendNotification(var0.OnMap, {
			entrance = var0,
			mapId = var1
		})
	end)
	arg0:bind(var0.OnOpenAllocateLayer, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = WorldAllocateMediator,
			viewComponent = WorldAllocateLayer,
			data = arg1
		}))
	end)
	arg0:bind(var0.OPEN_MODULEINFO_LAYER, function(arg0, arg1, arg2, arg3, arg4, arg5)
		return
	end)
	arg0:bind(var0.OPEN_EQUIPMENT_INDEX, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)

	local var0 = nowWorld()

	arg0.viewComponent:setInventoryProxy(var0:GetInventoryProxy())
	arg0.viewComponent:setWorldFleet(var0:GetFleets())

	local var1 = getProxy(BayProxy)
	local var2 = getProxy(EquipmentProxy):getEquipments(true)

	for iter0, iter1 in ipairs(var1:getEquipsInShips()) do
		table.insert(var2, iter1)
	end

	arg0.viewComponent:setEquipments(var2)

	local var3 = getProxy(BagProxy):GetItemsByCondition({
		is_world = 1
	})

	arg0.viewComponent:SetMaterials(var3)
end

function var0.listNotificationInterests(arg0)
	return {
		EquipmentProxy.EQUIPMENT_UPDATED,
		GAME.USE_ITEM_DONE,
		GAME.DESTROY_EQUIPMENTS_DONE,
		BagProxy.ITEM_UPDATED,
		var0.BATCHDESTROY_MODE,
		GAME.REVERT_EQUIPMENT_DONE,
		GAME.FRAG_SELL_DONE,
		GAME.TRANSFORM_EQUIPMENT_AWARD_FINISHED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == EquipmentProxy.EQUIPMENT_UPDATED then
		arg0.viewComponent:setEquipment(var1)
	elseif var0 == GAME.USE_ITEM_DONE then
		if table.getCount(var1) ~= 0 then
			arg0.viewComponent:emit(BaseUI.ON_AWARD, {
				animation = true,
				items = var1
			})
		end
	elseif var0 == GAME.FRAG_SELL_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
	elseif var0 == GAME.DESTROY_EQUIPMENTS_DONE then
		if table.getCount(var1) ~= 0 then
			arg0.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1
			})
		end
	elseif var0 == BagProxy.ITEM_UPDATED then
		if arg0.canUpdate then
			local var2 = getProxy(BagProxy):GetItemsByCondition({
				is_world = 1
			})

			arg0.viewComponent:SetMaterials(var2)
		end
	elseif var0 == GAME.REVERT_EQUIPMENT_DONE then
		if table.getCount(var1.awards) > 0 then
			arg0.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1.awards
			})
		end
	elseif var0 == GAME.TRANSFORM_EQUIPMENT_AWARD_FINISHED then
		arg0:getViewComponent():Scroll2Equip(var1.newEquip)
	end
end

return var0
