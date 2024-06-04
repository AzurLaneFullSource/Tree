local var0 = class("MetaSkillDetailBoxMediator", import("...base.ContextMediator"))

function var0.register(arg0)
	return
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.TACTICS_META_UNLOCK_SKILL_DONE,
		GAME.TACTICS_META_SWITCH_SKILL_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.TACTICS_META_UNLOCK_SKILL_DONE or var0 == GAME.TACTICS_META_SWITCH_SKILL_DONE then
		if var0 == GAME.TACTICS_META_SWITCH_SKILL_DONE then
			local var2 = arg0.contextData.expInfoList

			if var2 and #var2 > 0 then
				local var3 = arg0.contextData.metaShipID
				local var4

				for iter0, iter1 in ipairs(var2) do
					if iter1.shipID == var3 and iter1.isUpLevel and iter1.isMaxLevel then
						var4 = iter0
					end
				end

				if var4 then
					var2[var4].isUpLevel = false
					var2[var4].isMaxLevel = false
				end
			end
		end

		arg0.viewComponent:updateSkillList()
	end
end

return var0
