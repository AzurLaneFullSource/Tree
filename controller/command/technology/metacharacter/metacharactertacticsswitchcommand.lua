local var0 = class("MetaCharacterTacticsSwitchCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipID
	local var2 = var0.skillID

	print("63307 switch skill", tostring(var1), tostring(var2))
	pg.ConnectionMgr.GetInstance():Send(63307, {
		ship_id = var1,
		skill_id = var2
	}, 63308, function(arg0)
		if arg0.result == 0 then
			print("63308 switch success")
			getProxy(MetaCharacterProxy):switchMetaTacticsSkill(var1, var2)
			getProxy(MetaCharacterProxy):tryRemoveMetaSkillLevelMaxInfo(var1, var2)

			local var0 = arg0.switch_cnt

			arg0:sendNotification(GAME.TACTICS_META_SWITCH_SKILL_DONE, {
				metaShipID = var1,
				skillID = var2,
				leftSwitchCount = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
