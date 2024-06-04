local var0 = class("EquipmentTraceBackMediator", import("view.base.ContextMediator"))

var0.TRANSFORM_EQUIP = "transform equip"

function var0.register(arg0)
	arg0:BindEvent()

	arg0.env = {}

	arg0:getViewComponent():SetEnv(arg0.env)
	assert(arg0.contextData.TargetEquipmentId, "Should Set TargetEquipment First")

	arg0.env.tracebackHelper = getProxy(EquipmentProxy):GetWeakEquipsDict()

	arg0:getViewComponent():UpdatePlayer(getProxy(PlayerProxy):getData())

	arg0.stopUpdateView = false
end

function var0.BindEvent(arg0)
	arg0:bind(var0.TRANSFORM_EQUIP, function(arg0, arg1, arg2)
		arg0.stopUpdateView = true

		arg0:sendNotification(GAME.TRANSFORM_EQUIPMENT, {
			candicate = arg1,
			formulaIds = arg2
		})
	end)
end

function var0.listNotificationInterests(arg0)
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

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0:getViewComponent():UpdatePlayer(var1)
	elseif var0 == BagProxy.ITEM_UPDATED then
		if arg0.stopUpdateView then
			return
		end

		local var2 = arg0:getViewComponent()

		var2:UpdateSort()
		var2:UpdateSourceList()
		var2:UpdateFormula()
	elseif var0 == EquipmentProxy.EQUIPMENT_UPDATED then
		if arg0.stopUpdateView then
			return
		end

		if arg0.contextData.sourceEquipmentInstance then
			local var3 = var1.count == 0
			local var4 = arg0.contextData.sourceEquipmentInstance

			if var3 and var4.type == DROP_TYPE_EQUIP and EquipmentProxy.SameEquip(var1, var4.template) then
				arg0.contextData.sourceEquipmentInstance = nil
			end
		end

		local var5 = arg0:getViewComponent()

		var5:UpdateSourceEquipmentPaths()
		var5:UpdateSort()
		var5:UpdateSourceList()
		var5:UpdateFormula()
	elseif var0 == GAME.UNEQUIP_FROM_SHIP_DONE or var0 == GAME.EQUIP_TO_SHIP_DONE then
		if arg0.stopUpdateView then
			return
		end

		local var6 = arg0.contextData.sourceEquipmentInstance

		if var6 and var6.type == DROP_TYPE_EQUIP then
			local var7 = var1:getEquip(var6.template.shipPos)

			if var6.template.shipId == var1.id and (not var7 or var7.id ~= var6.id) then
				arg0.contextData.sourceEquipmentInstance = nil
			end
		end

		local var8 = arg0:getViewComponent()

		var8:UpdateSourceEquipmentPaths()
		var8:UpdateSort()
		var8:UpdateSourceList()
		var8:UpdateFormula()
	elseif var0 == GAME.TRANSFORM_EQUIPMENT_DONE or var0 == GAME.TRANSFORM_EQUIPMENT_FAIL then
		arg0.stopUpdateView = false

		local var9 = arg0:getViewComponent()

		var9:UpdateSourceEquipmentPaths()
		var9:UpdateSort()
		var9:UpdateSourceList()
		var9:UpdateFormula()
	end
end

return var0
