local var0 = class("EquipCodeMediator", import("..base.ContextMediator"))

var0.SHARE_EQUIP_CODE = "EquipCodeMediator.SHARE_EQUIP_CODE"
var0.IMPORT_SHIP_EQUIP = "EquipCodeMediator.IMPORT_SHIP_EQUIP"
var0.OPEN_CUSTOM_INDEX = "EquipCodeMediator.OPEN_CUSTOM_INDEX"
var0.OPEN_EQUIP_CODE_SHARE = "EquipCodeMediator.OPEN_EQUIP_CODE_SHARE"

function var0.register(arg0)
	arg0:bind(var0.SHARE_EQUIP_CODE, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.EQUIP_CODE_SHARE, {
			groupId = arg1,
			code = arg2
		})
	end)
	arg0:bind(var0.IMPORT_SHIP_EQUIP, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SHIP_EQUIP_ALL_CHANGE, {
			shipId = arg1,
			equipData = arg2
		})
	end)
	arg0:bind(var0.OPEN_CUSTOM_INDEX, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)
	arg0:bind(var0.OPEN_EQUIP_CODE_SHARE, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = EquipCodeShareMediator,
			viewComponent = EquipCodeShareLayer,
			data = {
				shipGroupId = arg1
			}
		}))
	end)

	local var0 = getProxy(EquipmentProxy):getEquipments(true)

	for iter0, iter1 in ipairs(getProxy(BayProxy):getEquipsInShips()) do
		table.insert(var0, iter1)
	end

	local var1 = underscore.values(getProxy(EquipmentProxy):GetSpWeapons())

	for iter2, iter3 in ipairs(getProxy(BayProxy):GetSpWeaponsInShips()) do
		table.insert(var1, iter3)
	end

	arg0.viewComponent:setEquipments(var0, var1)
	arg0.viewComponent:setShip(arg0.contextData.shipId)
end

function var0.initNotificationHandleDic(arg0)
	arg0.handleDic = {
		[GAME.SHIP_EQUIP_ALL_CHANGE_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			assert(var0 == arg0.contextData.shipId)
			arg0.viewComponent:closeView()
		end
	}
end

return var0
