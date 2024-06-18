local var0_0 = class("EquipmentTraceBackMediator", import("view.base.ContextMediator"))

var0_0.TRANSFORM_EQUIP = "transform equip"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()

	arg0_1.env = {}

	arg0_1:getViewComponent():SetEnv(arg0_1.env)
	assert(arg0_1.contextData.TargetEquipmentId, "Should Set TargetEquipment First")

	arg0_1.env.tracebackHelper = getProxy(EquipmentProxy):GetWeakEquipsDict()

	arg0_1:getViewComponent():UpdatePlayer(getProxy(PlayerProxy):getData())

	arg0_1.stopUpdateView = false
end

function var0_0.BindEvent(arg0_2)
	arg0_2:bind(var0_0.TRANSFORM_EQUIP, function(arg0_3, arg1_3, arg2_3)
		arg0_2.stopUpdateView = true

		arg0_2:sendNotification(GAME.TRANSFORM_EQUIPMENT, {
			candicate = arg1_3,
			formulaIds = arg2_3
		})
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		PlayerProxy.UPDATED,
		BagProxy.ITEM_UPDATED,
		EquipmentProxy.EQUIPMENT_UPDATED,
		GAME.EQUIP_TO_SHIP_DONE,
		GAME.UNEQUIP_FROM_SHIP_DONE,
		GAME.TRANSFORM_EQUIPMENT_DONE,
		GAME.TRANSFORM_EQUIPMENT_FAIL
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == PlayerProxy.UPDATED then
		arg0_5:getViewComponent():UpdatePlayer(var1_5)
	elseif var0_5 == BagProxy.ITEM_UPDATED then
		if arg0_5.stopUpdateView then
			return
		end

		local var2_5 = arg0_5:getViewComponent()

		var2_5:UpdateSort()
		var2_5:UpdateSourceList()
		var2_5:UpdateFormula()
	elseif var0_5 == EquipmentProxy.EQUIPMENT_UPDATED then
		if arg0_5.stopUpdateView then
			return
		end

		if arg0_5.contextData.sourceEquipmentInstance then
			local var3_5 = var1_5.count == 0
			local var4_5 = arg0_5.contextData.sourceEquipmentInstance

			if var3_5 and var4_5.type == DROP_TYPE_EQUIP and EquipmentProxy.SameEquip(var1_5, var4_5.template) then
				arg0_5.contextData.sourceEquipmentInstance = nil
			end
		end

		local var5_5 = arg0_5:getViewComponent()

		var5_5:UpdateSourceEquipmentPaths()
		var5_5:UpdateSort()
		var5_5:UpdateSourceList()
		var5_5:UpdateFormula()
	elseif var0_5 == GAME.UNEQUIP_FROM_SHIP_DONE or var0_5 == GAME.EQUIP_TO_SHIP_DONE then
		if arg0_5.stopUpdateView then
			return
		end

		local var6_5 = arg0_5.contextData.sourceEquipmentInstance

		if var6_5 and var6_5.type == DROP_TYPE_EQUIP then
			local var7_5 = var1_5:getEquip(var6_5.template.shipPos)

			if var6_5.template.shipId == var1_5.id and (not var7_5 or var7_5.id ~= var6_5.id) then
				arg0_5.contextData.sourceEquipmentInstance = nil
			end
		end

		local var8_5 = arg0_5:getViewComponent()

		var8_5:UpdateSourceEquipmentPaths()
		var8_5:UpdateSort()
		var8_5:UpdateSourceList()
		var8_5:UpdateFormula()
	elseif var0_5 == GAME.TRANSFORM_EQUIPMENT_DONE or var0_5 == GAME.TRANSFORM_EQUIPMENT_FAIL then
		arg0_5.stopUpdateView = false

		local var9_5 = arg0_5:getViewComponent()

		var9_5:UpdateSourceEquipmentPaths()
		var9_5:UpdateSort()
		var9_5:UpdateSourceList()
		var9_5:UpdateFormula()
	end
end

return var0_0
