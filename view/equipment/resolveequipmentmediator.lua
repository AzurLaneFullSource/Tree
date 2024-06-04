local var0 = class("ResolveEquipmentMediator", import("..base.ContextMediator"))

var0.ON_RESOLVE = "ResolveEquipmentMediator:ON_RESOLVE"

function var0.register(arg0)
	arg0:bind(var0.ON_RESOLVE, function(arg0, arg1)
		arg0:sendNotification(GAME.DESTROY_EQUIPMENTS, {
			equipments = arg1
		})
	end)

	local var0 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayer(var0)

	local var1 = arg0.contextData.Equipments

	assert(var1, "equipmentVOs can not be nil")
	arg0.viewComponent:setEquipments(var1)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.DESTROY_EQUIPMENTS_DONE,
		GAME.CANCEL_LIMITED_OPERATION
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.DESTROY_EQUIPMENTS_DONE then
		arg0.viewComponent:OnResolveEquipDone()

		if table.getCount(var1) ~= 0 then
			arg0.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1,
				title = AwardInfoLayer.TITLE.ITEM,
				removeFunc = function()
					arg0.viewComponent:emit(BaseUI.ON_CLOSE)
				end
			})
		end
	elseif var0 == GAME.CANCEL_LIMITED_OPERATION then
		-- block empty
	end
end

return var0
