local var0_0 = class("WorldInventoryMediator", import("..base.ContextMediator"))

var0_0.OnUseItem = "WorldInventoryMediator.OnUseItem"
var0_0.OnMap = "WorldInventoryMediator.OnMap"
var0_0.OnOpenAllocateLayer = "WorldInventoryMediator.OnOpenAllocateLayer"
var0_0.OPEN_MODULEINFO_LAYER = "WorldInventoryMediator:OPEN_MODULEINFO_LAYER"
var0_0.OPEN_EQUIPMENT_INDEX = "OPEN_EQUIPMENT_INDEX"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OnUseItem, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:sendNotification(GAME.WORLD_ITEM_USE, {
			itemID = arg1_2,
			count = arg2_2 or 1,
			args = arg3_2
		})
	end)
	arg0_1:bind(var0_0.OnMap, function(arg0_3, arg1_3)
		local var0_3 = nowWorld():FindTreasureEntrance(arg1_3)
		local var1_3

		for iter0_3, iter1_3 in ipairs(var0_3.config.teasure_chapter) do
			if arg1_3 == iter1_3[1] then
				var1_3 = iter1_3[2]

				break
			end
		end

		arg0_1:sendNotification(var0_0.OnMap, {
			entrance = var0_3,
			mapId = var1_3
		})
	end)
	arg0_1:bind(var0_0.OnOpenAllocateLayer, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(Context.New({
			mediator = WorldAllocateMediator,
			viewComponent = WorldAllocateLayer,
			data = arg1_4
		}))
	end)
	arg0_1:bind(var0_0.OPEN_MODULEINFO_LAYER, function(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5, arg5_5)
		return
	end)
	arg0_1:bind(var0_0.OPEN_EQUIPMENT_INDEX, function(arg0_6, arg1_6)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_6
		}))
	end)

	local var0_1 = nowWorld()

	arg0_1.viewComponent:setInventoryProxy(var0_1:GetInventoryProxy())
	arg0_1.viewComponent:setWorldFleet(var0_1:GetFleets())

	local var1_1 = getProxy(BayProxy)
	local var2_1 = getProxy(EquipmentProxy):getEquipments(true)

	for iter0_1, iter1_1 in ipairs(var1_1:getEquipsInShips()) do
		table.insert(var2_1, iter1_1)
	end

	arg0_1.viewComponent:setEquipments(var2_1)

	local var3_1 = getProxy(BagProxy):GetItemsByCondition({
		is_world = 1
	})

	arg0_1.viewComponent:SetMaterials(var3_1)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		EquipmentProxy.EQUIPMENT_UPDATED,
		GAME.USE_ITEM_DONE,
		GAME.DESTROY_EQUIPMENTS_DONE,
		BagProxy.ITEM_UPDATED,
		var0_0.BATCHDESTROY_MODE,
		GAME.REVERT_EQUIPMENT_DONE,
		GAME.FRAG_SELL_DONE,
		GAME.TRANSFORM_EQUIPMENT_AWARD_FINISHED
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == EquipmentProxy.EQUIPMENT_UPDATED then
		arg0_8.viewComponent:setEquipment(var1_8)
	elseif var0_8 == GAME.USE_ITEM_DONE then
		if table.getCount(var1_8) ~= 0 then
			arg0_8.viewComponent:emit(BaseUI.ON_AWARD, {
				animation = true,
				items = var1_8
			})
		end
	elseif var0_8 == GAME.FRAG_SELL_DONE then
		arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_8.awards)
	elseif var0_8 == GAME.DESTROY_EQUIPMENTS_DONE then
		if table.getCount(var1_8) ~= 0 then
			arg0_8.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1_8
			})
		end
	elseif var0_8 == BagProxy.ITEM_UPDATED then
		if arg0_8.canUpdate then
			local var2_8 = getProxy(BagProxy):GetItemsByCondition({
				is_world = 1
			})

			arg0_8.viewComponent:SetMaterials(var2_8)
		end
	elseif var0_8 == GAME.REVERT_EQUIPMENT_DONE then
		if table.getCount(var1_8.awards) > 0 then
			arg0_8.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1_8.awards
			})
		end
	elseif var0_8 == GAME.TRANSFORM_EQUIPMENT_AWARD_FINISHED then
		arg0_8:getViewComponent():Scroll2Equip(var1_8.newEquip)
	end
end

return var0_0
