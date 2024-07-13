local var0_0 = class("EquipCodeMediator", import("..base.ContextMediator"))

var0_0.SHARE_EQUIP_CODE = "EquipCodeMediator.SHARE_EQUIP_CODE"
var0_0.IMPORT_SHIP_EQUIP = "EquipCodeMediator.IMPORT_SHIP_EQUIP"
var0_0.OPEN_CUSTOM_INDEX = "EquipCodeMediator.OPEN_CUSTOM_INDEX"
var0_0.OPEN_EQUIP_CODE_SHARE = "EquipCodeMediator.OPEN_EQUIP_CODE_SHARE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SHARE_EQUIP_CODE, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.EQUIP_CODE_SHARE, {
			groupId = arg1_2,
			code = arg2_2
		})
	end)
	arg0_1:bind(var0_0.IMPORT_SHIP_EQUIP, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.SHIP_EQUIP_ALL_CHANGE, {
			shipId = arg1_3,
			equipData = arg2_3
		})
	end)
	arg0_1:bind(var0_0.OPEN_CUSTOM_INDEX, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_4
		}))
	end)
	arg0_1:bind(var0_0.OPEN_EQUIP_CODE_SHARE, function(arg0_5, arg1_5)
		arg0_1:addSubLayers(Context.New({
			mediator = EquipCodeShareMediator,
			viewComponent = EquipCodeShareLayer,
			data = {
				shipGroupId = arg1_5
			}
		}))
	end)

	local var0_1 = getProxy(EquipmentProxy):getEquipments(true)

	for iter0_1, iter1_1 in ipairs(getProxy(BayProxy):getEquipsInShips()) do
		table.insert(var0_1, iter1_1)
	end

	local var1_1 = underscore.values(getProxy(EquipmentProxy):GetSpWeapons())

	for iter2_1, iter3_1 in ipairs(getProxy(BayProxy):GetSpWeaponsInShips()) do
		table.insert(var1_1, iter3_1)
	end

	arg0_1.viewComponent:setEquipments(var0_1, var1_1)
	arg0_1.viewComponent:setShip(arg0_1.contextData.shipId)
end

function var0_0.initNotificationHandleDic(arg0_6)
	arg0_6.handleDic = {
		[GAME.SHIP_EQUIP_ALL_CHANGE_DONE] = function(arg0_7, arg1_7)
			local var0_7 = arg1_7:getBody()

			assert(var0_7 == arg0_7.contextData.shipId)
			arg0_7.viewComponent:closeView()
		end
	}
end

return var0_0
