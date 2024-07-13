local var0_0 = class("MetaCharacterTacticsLevelUpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipID
	local var2_1 = var0_1.skillID

	print("63309 skill levelup", tostring(var1_1), tostring(var2_1))
	pg.ConnectionMgr.GetInstance():Send(63309, {
		ship_id = var1_1,
		skill_id = var2_1
	}, 63310, function(arg0_2)
		if arg0_2.result == 0 then
			print("63310 skill levelup success")

			local var0_2 = getProxy(BayProxy)
			local var1_2 = var0_2:getShipById(var1_1)

			var1_2:upSkillLevelForMeta(var2_1)
			var0_2:updateShip(var1_2)

			local var2_2 = arg0_2.switch_cnt

			arg0_1:sendNotification(GAME.TACTICS_META_LEVELUP_SKILL_DONE, {
				skillID = var2_1,
				leftSwitchCount = var2_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
