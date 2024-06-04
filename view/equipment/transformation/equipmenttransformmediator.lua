local var0 = class("EquipmentTransformMediator", import("view.base.ContextMediator"))

var0.TRANSFORM_EQUIP = "transform equip"
var0.UPDATE_NEW_FLAG = "UPDATE NEW FLAG"
var0.OPEN_TRANSFORM_TREE = "OPEN TRANSFORM TREE"
var0.SELECT_TRANSFORM_FROM_STOREHOUSE = "SELECT_TRANSFORM_FROM_STOREHOUSE"
var0.OPEN_LAYER = "OPEN_LAYER"

function var0.register(arg0)
	arg0:BindEvent()

	arg0.env = {}

	arg0:getViewComponent():SetEnv(arg0.env)

	arg0.env.tracebackHelper = getProxy(EquipmentProxy):GetWeakEquipsDict()

	arg0:getViewComponent():UpdatePlayer(getProxy(PlayerProxy):getData())
end

function var0.BindEvent(arg0)
	arg0:bind(var0.TRANSFORM_EQUIP, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.TRANSFORM_EQUIPMENT, {
			candicate = arg1,
			formulaIds = {
				arg2
			}
		})
	end)
	arg0:bind(var0.UPDATE_NEW_FLAG, function(arg0, arg1)
		arg0:sendNotification(var0.UPDATE_NEW_FLAG, arg1)
	end)
	arg0:bind(var0.OPEN_TRANSFORM_TREE, function(arg0, arg1)
		arg0:getViewComponent():closeView()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.EQUIPMENT_TRANSFORM, {
			targetEquipId = arg1,
			mode = EquipmentTransformTreeScene.MODE_HIDESIDE
		})
	end)
	arg0:bind(var0.SELECT_TRANSFORM_FROM_STOREHOUSE, function(arg0, arg1)
		local var0 = arg0.env.tracebackHelper:GetEquipmentTransformCandicates(arg1)

		arg0:sendNotification(GAME.GO_SCENE, SCENE.SELECT_TRANSFORM_EQUIPMENT, {
			warp = StoreHouseConst.WARP_TO_WEAPON,
			sourceVOs = var0,
			onSelect = function(arg0)
				if arg0.type == DROP_TYPE_ITEM and arg0.template.count < arg0.composeCfg.material_num then
					pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_feedback_lack_of_fragment", arg0.template:getConfig("name")))

					return false
				elseif arg0.type == DROP_TYPE_EQUIP and arg0.template.count <= 0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", arg0.template:getConfig("name")))

					return false
				end

				return true
			end,
			onConfirm = function(arg0)
				arg0.contextData.sourceEquipmentInstance = arg0[1] or arg0.contextData.sourceEquipmentInstance

				return true
			end
		})
	end)
	arg0:bind(var0.OPEN_LAYER, function(arg0, ...)
		arg0:addSubLayers(...)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.TRANSFORM_EQUIPMENT_DONE,
		GAME.TRANSFORM_EQUIPMENT_FAIL,
		PlayerProxy.UPDATED,
		BagProxy.ITEM_UPDATED,
		EquipmentProxy.EQUIPMENT_UPDATED,
		GAME.EQUIP_TO_SHIP_DONE,
		GAME.UNEQUIP_FROM_SHIP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0:getViewComponent():UpdatePlayer(var1)
	elseif var0 == BagProxy.ITEM_UPDATED then
		arg0:getViewComponent():UpdatePage()
	elseif var0 == EquipmentProxy.EQUIPMENT_UPDATED then
		if arg0.contextData.sourceEquipmentInstance then
			local var2 = var1.count == 0
			local var3 = arg0.contextData.sourceEquipmentInstance

			if var2 and var3.type == DROP_TYPE_EQUIP and EquipmentProxy.SameEquip(var1, var3.template) then
				arg0.contextData.sourceEquipmentInstance = nil
			end
		end

		local var4 = arg0:getViewComponent()

		var4:UpdateSourceEquipmentPaths()
		var4:UpdateSourceInfo()
		var4:UpdateTargetInfo()
	elseif var0 == GAME.UNEQUIP_FROM_SHIP_DONE or var0 == GAME.EQUIP_TO_SHIP_DONE then
		local var5 = arg0.contextData.sourceEquipmentInstance

		if var5 and var5.type == DROP_TYPE_EQUIP then
			local var6 = var1:getEquip(var5.template.shipPos)

			if var5.template.shipId == var1.id and (not var6 or var6.id ~= var5.id) then
				arg0.contextData.sourceEquipmentInstance = nil
			end
		end

		local var7 = arg0:getViewComponent()

		var7:UpdateSourceEquipmentPaths()
		var7:UpdateSourceInfo()
		var7:UpdateTargetInfo()
	elseif var0 == GAME.TRANSFORM_EQUIPMENT_DONE then
		arg0.contextData.sourceEquipmentInstance = nil

		arg0:getViewComponent():UpdatePage()
	elseif var0 == GAME.TRANSFORM_EQUIPMENT_FAIL then
		arg0:getViewComponent():UpdatePage()
	end
end

return var0
