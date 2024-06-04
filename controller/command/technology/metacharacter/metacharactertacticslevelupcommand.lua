local var0 = class("MetaCharacterTacticsLevelUpCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipID
	local var2 = var0.skillID

	print("63309 skill levelup", tostring(var1), tostring(var2))
	pg.ConnectionMgr.GetInstance():Send(63309, {
		ship_id = var1,
		skill_id = var2
	}, 63310, function(arg0)
		if arg0.result == 0 then
			print("63310 skill levelup success")

			local var0 = getProxy(BayProxy)
			local var1 = var0:getShipById(var1)

			var1:upSkillLevelForMeta(var2)
			var0:updateShip(var1)

			local var2 = arg0.switch_cnt

			arg0:sendNotification(GAME.TACTICS_META_LEVELUP_SKILL_DONE, {
				skillID = var2,
				leftSwitchCount = var2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
