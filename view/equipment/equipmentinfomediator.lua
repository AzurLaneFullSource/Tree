local var0 = class("EquipmentInfoMediator", import("..base.ContextMediator"))

var0.TYPE_DEFAULT = 1
var0.TYPE_SHIP = 2
var0.TYPE_REPLACE = 3
var0.TYPE_DISPLAY = 4
var0.SHOW_UNIQUE = {
	1,
	2,
	3,
	4
}
var0.ON_DESTROY = "EquipmentInfoMediator:ON_DESTROY"
var0.ON_EQUIP = "EquipmentInfoMediator:ON_EQUIP"
var0.ON_INTENSIFY = "EquipmentInfoMediator.ON_INTENSIFY"
var0.ON_CHANGE = "EquipmentInfoMediator.ON_CHANGE"
var0.ON_UNEQUIP = "EquipmentInfoMediator:ON_UNEQUIP"
var0.ON_REVERT = "EquipmentInfoMediator:ON_REVERT"
var0.ON_MOVE = "EquipmentInfoMediator:ON_MOVE"
var0.OPEN_LAYER = "OPEN LAYER"

function var0.register(arg0)
	if getProxy(ContextProxy):getCurrentContext().scene == SCENE.EQUIPSCENE then
		arg0.viewComponent.fromEquipmentView = true
	end

	arg0:bind(var0.ON_DESTROY, function(arg0, arg1)
		arg0:sendNotification(GAME.DESTROY_EQUIPMENTS, {
			equipments = {
				{
					arg0.contextData.equipmentId,
					arg1
				}
			}
		})
	end)
	arg0:bind(var0.ON_EQUIP, function(arg0)
		if arg0.contextData.oldShipId then
			local var0 = getProxy(BayProxy):getShipById(arg0.contextData.oldShipId)
			local var1, var2 = ShipStatus.ShipStatusCheck("onModify", var0)

			if not var1 then
				pg.TipsMgr.GetInstance():ShowTips(var2)
			else
				if arg0.viewComponent.fromEquipmentView then
					arg0:sendNotification(EquipmentMediator.NO_UPDATE)
				end

				arg0:sendNotification(GAME.EQUIP_FROM_SHIP, {
					equipmentId = arg0.contextData.equipmentId,
					shipId = arg0.contextData.shipId,
					pos = arg0.contextData.pos,
					oldShipId = arg0.contextData.oldShipId,
					oldPos = arg0.contextData.oldPos
				})
			end
		else
			if arg0.viewComponent.fromEquipmentView then
				arg0:sendNotification(EquipmentMediator.NO_UPDATE)
			end

			arg0:sendNotification(GAME.EQUIP_TO_SHIP, {
				equipmentId = arg0.contextData.equipmentId,
				shipId = arg0.contextData.shipId,
				pos = arg0.contextData.pos
			})
		end
	end)
	arg0:bind(var0.ON_UNEQUIP, function(arg0)
		arg0:sendNotification(GAME.UNEQUIP_FROM_SHIP, {
			shipId = arg0.contextData.shipId,
			pos = arg0.contextData.pos
		})
		arg0.viewComponent:emit(BaseUI.ON_CLOSE)
	end)
	arg0:bind(var0.ON_INTENSIFY, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = EquipUpgradeMediator,
			viewComponent = EquipUpgradeLayer,
			data = {
				equipmentId = arg0.contextData.equipmentId,
				shipId = arg0.contextData.shipId,
				pos = arg0.contextData.pos
			}
		}), true, function()
			arg0.viewComponent:emit(BaseUI.ON_CLOSE)
		end)
	end)
	arg0:bind(var0.ON_CHANGE, function(arg0)
		local var0 = getProxy(BayProxy)
		local var1 = var0:getShipById(arg0.contextData.shipId)
		local var2 = getProxy(EquipmentProxy):getEquipments(true)
		local var3 = var0:getEquipsInShips(function(arg0, arg1)
			return var1.id ~= arg1 and not var1:isForbiddenAtPos(arg0, arg0.contextData.pos)
		end)

		for iter0, iter1 in ipairs(var2) do
			if not var1:isForbiddenAtPos(iter1, arg0.contextData.pos) then
				table.insert(var3, iter1)
			end
		end

		_.each(var3, function(arg0)
			if not var1:canEquipAtPos(arg0, arg0.contextData.pos) then
				arg0.mask = true
			end
		end)
		arg0.viewComponent:emit(BaseUI.ON_CLOSE)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
			lock = true,
			equipmentVOs = var3,
			shipId = arg0.contextData.shipId,
			pos = arg0.contextData.pos,
			warp = StoreHouseConst.WARP_TO_WEAPON,
			mode = StoreHouseConst.EQUIPMENT
		})
	end)
	arg0:bind(var0.ON_REVERT, function(arg0, arg1)
		arg0:sendNotification(GAME.REVERT_EQUIPMENT, {
			id = arg1
		})
	end)
	arg0:bind(var0.ON_MOVE, function(arg0, arg1)
		arg0.viewComponent:emit(BaseUI.ON_CLOSE)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			page = 2,
			shipId = arg1
		})
	end)
	arg0:bind(var0.OPEN_LAYER, function(arg0, ...)
		arg0:addSubLayers(...)
	end)

	if arg0.contextData.equipment then
		arg0.viewComponent:setEquipment(arg0.contextData.equipment)
	else
		local var0 = getProxy(EquipmentProxy)
		local var1 = arg0.contextData.equipmentId
		local var2 = var0:getEquipmentById(var1) or var1 and var1 > 0 and Equipment.New({
			id = var1
		}) or nil

		arg0.viewComponent:setEquipment(var2)
	end

	local var3 = getProxy(BayProxy)
	local var4 = arg0.contextData.shipVO or var3:getShipById(arg0.contextData.shipId)
	local var5 = arg0.contextData.oldShipId and var3:getShipById(arg0.contextData.oldShipId) or nil

	arg0.viewComponent:setShip(var4, var5)

	local var6 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayer(var6)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.DESTROY_EQUIPMENTS_DONE,
		GAME.EQUIP_TO_SHIP_DONE,
		GAME.REVERT_EQUIPMENT_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.DESTROY_EQUIPMENTS_DONE or var0 == GAME.EQUIP_TO_SHIP_DONE or var0 == GAME.REVERT_EQUIPMENT_DONE then
		arg0.viewComponent:emit(BaseUI.ON_CLOSE)
	end
end

return var0
