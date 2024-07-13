local var0_0 = class("MetaCharacterTacticsSwitchCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipID
	local var2_1 = var0_1.skillID

	print("63307 switch skill", tostring(var1_1), tostring(var2_1))
	pg.ConnectionMgr.GetInstance():Send(63307, {
		ship_id = var1_1,
		skill_id = var2_1
	}, 63308, function(arg0_2)
		if arg0_2.result == 0 then
			print("63308 switch success")
			getProxy(MetaCharacterProxy):switchMetaTacticsSkill(var1_1, var2_1)
			getProxy(MetaCharacterProxy):tryRemoveMetaSkillLevelMaxInfo(var1_1, var2_1)

			local var0_2 = arg0_2.switch_cnt

			arg0_1:sendNotification(GAME.TACTICS_META_SWITCH_SKILL_DONE, {
				metaShipID = var1_1,
				skillID = var2_1,
				leftSwitchCount = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
