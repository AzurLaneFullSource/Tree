local var0_0 = class("EquipmentInfoMediator", import("..base.ContextMediator"))

var0_0.TYPE_DEFAULT = 1
var0_0.TYPE_SHIP = 2
var0_0.TYPE_REPLACE = 3
var0_0.TYPE_DISPLAY = 4
var0_0.SHOW_UNIQUE = {
	1,
	2,
	3,
	4
}
var0_0.ON_DESTROY = "EquipmentInfoMediator:ON_DESTROY"
var0_0.ON_EQUIP = "EquipmentInfoMediator:ON_EQUIP"
var0_0.ON_INTENSIFY = "EquipmentInfoMediator.ON_INTENSIFY"
var0_0.ON_CHANGE = "EquipmentInfoMediator.ON_CHANGE"
var0_0.ON_UNEQUIP = "EquipmentInfoMediator:ON_UNEQUIP"
var0_0.ON_REVERT = "EquipmentInfoMediator:ON_REVERT"
var0_0.ON_MOVE = "EquipmentInfoMediator:ON_MOVE"
var0_0.OPEN_LAYER = "OPEN LAYER"

function var0_0.register(arg0_1)
	if getProxy(ContextProxy):getCurrentContext().scene == SCENE.EQUIPSCENE then
		arg0_1.viewComponent.fromEquipmentView = true
	end

	arg0_1:bind(var0_0.ON_DESTROY, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.DESTROY_EQUIPMENTS, {
			equipments = {
				{
					arg0_1.contextData.equipmentId,
					arg1_2
				}
			}
		})
	end)
	arg0_1:bind(var0_0.ON_EQUIP, function(arg0_3)
		if arg0_1.contextData.oldShipId then
			local var0_3 = getProxy(BayProxy):getShipById(arg0_1.contextData.oldShipId)
			local var1_3, var2_3 = ShipStatus.ShipStatusCheck("onModify", var0_3)

			if not var1_3 then
				pg.TipsMgr.GetInstance():ShowTips(var2_3)
			else
				if arg0_1.viewComponent.fromEquipmentView then
					arg0_1:sendNotification(EquipmentMediator.NO_UPDATE)
				end

				arg0_1:sendNotification(GAME.EQUIP_FROM_SHIP, {
					equipmentId = arg0_1.contextData.equipmentId,
					shipId = arg0_1.contextData.shipId,
					pos = arg0_1.contextData.pos,
					oldShipId = arg0_1.contextData.oldShipId,
					oldPos = arg0_1.contextData.oldPos
				})
			end
		else
			if arg0_1.viewComponent.fromEquipmentView then
				arg0_1:sendNotification(EquipmentMediator.NO_UPDATE)
			end

			arg0_1:sendNotification(GAME.EQUIP_TO_SHIP, {
				equipmentId = arg0_1.contextData.equipmentId,
				shipId = arg0_1.contextData.shipId,
				pos = arg0_1.contextData.pos
			})
		end
	end)
	arg0_1:bind(var0_0.ON_UNEQUIP, function(arg0_4)
		arg0_1:sendNotification(GAME.UNEQUIP_FROM_SHIP, {
			shipId = arg0_1.contextData.shipId,
			pos = arg0_1.contextData.pos
		})
		arg0_1.viewComponent:emit(BaseUI.ON_CLOSE)
	end)
	arg0_1:bind(var0_0.ON_INTENSIFY, function(arg0_5)
		arg0_1:addSubLayers(Context.New({
			mediator = EquipUpgradeMediator,
			viewComponent = EquipUpgradeLayer,
			data = {
				equipmentId = arg0_1.contextData.equipmentId,
				shipId = arg0_1.contextData.shipId,
				pos = arg0_1.contextData.pos
			}
		}), true, function()
			arg0_1.viewComponent:emit(BaseUI.ON_CLOSE)
		end)
	end)
	arg0_1:bind(var0_0.ON_CHANGE, function(arg0_7)
		local var0_7 = getProxy(BayProxy)
		local var1_7 = var0_7:getShipById(arg0_1.contextData.shipId)
		local var2_7 = getProxy(EquipmentProxy):getEquipments(true)
		local var3_7 = var0_7:getEquipsInShips(function(arg0_8, arg1_8)
			return var1_7.id ~= arg1_8 and not var1_7:isForbiddenAtPos(arg0_8, arg0_1.contextData.pos)
		end)

		for iter0_7, iter1_7 in ipairs(var2_7) do
			if not var1_7:isForbiddenAtPos(iter1_7, arg0_1.contextData.pos) then
				table.insert(var3_7, iter1_7)
			end
		end

		_.each(var3_7, function(arg0_9)
			if not var1_7:canEquipAtPos(arg0_9, arg0_1.contextData.pos) then
				arg0_9.mask = true
			end
		end)
		arg0_1.viewComponent:emit(BaseUI.ON_CLOSE)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
			lock = true,
			equipmentVOs = var3_7,
			shipId = arg0_1.contextData.shipId,
			pos = arg0_1.contextData.pos,
			warp = StoreHouseConst.WARP_TO_WEAPON,
			mode = StoreHouseConst.EQUIPMENT
		})
	end)
	arg0_1:bind(var0_0.ON_REVERT, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.REVERT_EQUIPMENT, {
			id = arg1_10
		})
	end)
	arg0_1:bind(var0_0.ON_MOVE, function(arg0_11, arg1_11)
		arg0_1.viewComponent:emit(BaseUI.ON_CLOSE)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			page = 2,
			shipId = arg1_11
		})
	end)
	arg0_1:bind(var0_0.OPEN_LAYER, function(arg0_12, ...)
		arg0_1:addSubLayers(...)
	end)

	if arg0_1.contextData.equipment then
		arg0_1.viewComponent:setEquipment(arg0_1.contextData.equipment)
	else
		local var0_1 = getProxy(EquipmentProxy)
		local var1_1 = arg0_1.contextData.equipmentId
		local var2_1 = var0_1:getEquipmentById(var1_1) or var1_1 and var1_1 > 0 and Equipment.New({
			id = var1_1
		}) or nil

		arg0_1.viewComponent:setEquipment(var2_1)
	end

	local var3_1 = getProxy(BayProxy)
	local var4_1 = arg0_1.contextData.shipVO or var3_1:getShipById(arg0_1.contextData.shipId)
	local var5_1 = arg0_1.contextData.oldShipId and var3_1:getShipById(arg0_1.contextData.oldShipId) or nil

	arg0_1.viewComponent:setShip(var4_1, var5_1)

	local var6_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var6_1)
end

function var0_0.listNotificationInterests(arg0_13)
	return {
		GAME.DESTROY_EQUIPMENTS_DONE,
		GAME.EQUIP_TO_SHIP_DONE,
		GAME.REVERT_EQUIPMENT_DONE
	}
end

function var0_0.handleNotification(arg0_14, arg1_14)
	local var0_14 = arg1_14:getName()
	local var1_14 = arg1_14:getBody()

	if var0_14 == GAME.DESTROY_EQUIPMENTS_DONE or var0_14 == GAME.EQUIP_TO_SHIP_DONE or var0_14 == GAME.REVERT_EQUIPMENT_DONE then
		arg0_14.viewComponent:emit(BaseUI.ON_CLOSE)
	end
end

return var0_0
