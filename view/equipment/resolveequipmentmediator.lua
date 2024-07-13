local var0_0 = class("ResolveEquipmentMediator", import("..base.ContextMediator"))

var0_0.ON_RESOLVE = "ResolveEquipmentMediator:ON_RESOLVE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_RESOLVE, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.DESTROY_EQUIPMENTS, {
			equipments = arg1_2
		})
	end)

	local var0_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var0_1)

	local var1_1 = arg0_1.contextData.Equipments

	assert(var1_1, "equipmentVOs can not be nil")
	arg0_1.viewComponent:setEquipments(var1_1)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.DESTROY_EQUIPMENTS_DONE,
		GAME.CANCEL_LIMITED_OPERATION
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.DESTROY_EQUIPMENTS_DONE then
		arg0_4.viewComponent:OnResolveEquipDone()

		if table.getCount(var1_4) ~= 0 then
			arg0_4.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1_4,
				title = AwardInfoLayer.TITLE.ITEM,
				removeFunc = function()
					arg0_4.viewComponent:emit(BaseUI.ON_CLOSE)
				end
			})
		end
	elseif var0_4 == GAME.CANCEL_LIMITED_OPERATION then
		-- block empty
	end
end

return var0_0
