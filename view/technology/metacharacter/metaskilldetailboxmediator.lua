local var0_0 = class("MetaSkillDetailBoxMediator", import("...base.ContextMediator"))

function var0_0.register(arg0_1)
	return
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		GAME.TACTICS_META_UNLOCK_SKILL_DONE,
		GAME.TACTICS_META_SWITCH_SKILL_DONE
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == GAME.TACTICS_META_UNLOCK_SKILL_DONE or var0_3 == GAME.TACTICS_META_SWITCH_SKILL_DONE then
		if var0_3 == GAME.TACTICS_META_SWITCH_SKILL_DONE then
			local var2_3 = arg0_3.contextData.expInfoList

			if var2_3 and #var2_3 > 0 then
				local var3_3 = arg0_3.contextData.metaShipID
				local var4_3

				for iter0_3, iter1_3 in ipairs(var2_3) do
					if iter1_3.shipID == var3_3 and iter1_3.isUpLevel and iter1_3.isMaxLevel then
						var4_3 = iter0_3
					end
				end

				if var4_3 then
					var2_3[var4_3].isUpLevel = false
					var2_3[var4_3].isMaxLevel = false
				end
			end
		end

		arg0_3.viewComponent:updateSkillList()
	end
end

return var0_0
