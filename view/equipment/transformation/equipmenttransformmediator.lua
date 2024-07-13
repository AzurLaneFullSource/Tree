local var0_0 = class("EquipmentTransformMediator", import("view.base.ContextMediator"))

var0_0.TRANSFORM_EQUIP = "transform equip"
var0_0.UPDATE_NEW_FLAG = "UPDATE NEW FLAG"
var0_0.OPEN_TRANSFORM_TREE = "OPEN TRANSFORM TREE"
var0_0.SELECT_TRANSFORM_FROM_STOREHOUSE = "SELECT_TRANSFORM_FROM_STOREHOUSE"
var0_0.OPEN_LAYER = "OPEN_LAYER"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()

	arg0_1.env = {}

	arg0_1:getViewComponent():SetEnv(arg0_1.env)

	arg0_1.env.tracebackHelper = getProxy(EquipmentProxy):GetWeakEquipsDict()

	arg0_1:getViewComponent():UpdatePlayer(getProxy(PlayerProxy):getData())
end

function var0_0.BindEvent(arg0_2)
	arg0_2:bind(var0_0.TRANSFORM_EQUIP, function(arg0_3, arg1_3, arg2_3)
		arg0_2:sendNotification(GAME.TRANSFORM_EQUIPMENT, {
			candicate = arg1_3,
			formulaIds = {
				arg2_3
			}
		})
	end)
	arg0_2:bind(var0_0.UPDATE_NEW_FLAG, function(arg0_4, arg1_4)
		arg0_2:sendNotification(var0_0.UPDATE_NEW_FLAG, arg1_4)
	end)
	arg0_2:bind(var0_0.OPEN_TRANSFORM_TREE, function(arg0_5, arg1_5)
		arg0_2:getViewComponent():closeView()
		arg0_2:sendNotification(GAME.GO_SCENE, SCENE.EQUIPMENT_TRANSFORM, {
			targetEquipId = arg1_5,
			mode = EquipmentTransformTreeScene.MODE_HIDESIDE
		})
	end)
	arg0_2:bind(var0_0.SELECT_TRANSFORM_FROM_STOREHOUSE, function(arg0_6, arg1_6)
		local var0_6 = arg0_2.env.tracebackHelper:GetEquipmentTransformCandicates(arg1_6)

		arg0_2:sendNotification(GAME.GO_SCENE, SCENE.SELECT_TRANSFORM_EQUIPMENT, {
			warp = StoreHouseConst.WARP_TO_WEAPON,
			sourceVOs = var0_6,
			onSelect = function(arg0_7)
				if arg0_7.type == DROP_TYPE_ITEM and arg0_7.template.count < arg0_7.composeCfg.material_num then
					pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_feedback_lack_of_fragment", arg0_7.template:getConfig("name")))

					return false
				elseif arg0_7.type == DROP_TYPE_EQUIP and arg0_7.template.count <= 0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", arg0_7.template:getConfig("name")))

					return false
				end

				return true
			end,
			onConfirm = function(arg0_8)
				arg0_2.contextData.sourceEquipmentInstance = arg0_8[1] or arg0_2.contextData.sourceEquipmentInstance

				return true
			end
		})
	end)
	arg0_2:bind(var0_0.OPEN_LAYER, function(arg0_9, ...)
		arg0_2:addSubLayers(...)
	end)
end

function var0_0.listNotificationInterests(arg0_10)
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

function var0_0.handleNotification(arg0_11, arg1_11)
	local var0_11 = arg1_11:getName()
	local var1_11 = arg1_11:getBody()

	if var0_11 == PlayerProxy.UPDATED then
		arg0_11:getViewComponent():UpdatePlayer(var1_11)
	elseif var0_11 == BagProxy.ITEM_UPDATED then
		arg0_11:getViewComponent():UpdatePage()
	elseif var0_11 == EquipmentProxy.EQUIPMENT_UPDATED then
		if arg0_11.contextData.sourceEquipmentInstance then
			local var2_11 = var1_11.count == 0
			local var3_11 = arg0_11.contextData.sourceEquipmentInstance

			if var2_11 and var3_11.type == DROP_TYPE_EQUIP and EquipmentProxy.SameEquip(var1_11, var3_11.template) then
				arg0_11.contextData.sourceEquipmentInstance = nil
			end
		end

		local var4_11 = arg0_11:getViewComponent()

		var4_11:UpdateSourceEquipmentPaths()
		var4_11:UpdateSourceInfo()
		var4_11:UpdateTargetInfo()
	elseif var0_11 == GAME.UNEQUIP_FROM_SHIP_DONE or var0_11 == GAME.EQUIP_TO_SHIP_DONE then
		local var5_11 = arg0_11.contextData.sourceEquipmentInstance

		if var5_11 and var5_11.type == DROP_TYPE_EQUIP then
			local var6_11 = var1_11:getEquip(var5_11.template.shipPos)

			if var5_11.template.shipId == var1_11.id and (not var6_11 or var6_11.id ~= var5_11.id) then
				arg0_11.contextData.sourceEquipmentInstance = nil
			end
		end

		local var7_11 = arg0_11:getViewComponent()

		var7_11:UpdateSourceEquipmentPaths()
		var7_11:UpdateSourceInfo()
		var7_11:UpdateTargetInfo()
	elseif var0_11 == GAME.TRANSFORM_EQUIPMENT_DONE then
		arg0_11.contextData.sourceEquipmentInstance = nil

		arg0_11:getViewComponent():UpdatePage()
	elseif var0_11 == GAME.TRANSFORM_EQUIPMENT_FAIL then
		arg0_11:getViewComponent():UpdatePage()
	end
end

return var0_0
