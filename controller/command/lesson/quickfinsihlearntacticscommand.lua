local var0_0 = class("QuickFinsihLearnTacticsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipId
	local var2_1 = getProxy(NavalAcademyProxy)
	local var3_1 = var0_1.callback
	local var4_1 = var0_1.onConfirm
	local var5_1 = var2_1:getStudentById(var1_1)
	local var6_1 = getProxy(BayProxy)
	local var7_1 = var6_1:getShipById(var5_1.shipId)
	local var8_1 = var5_1:getSkillId(var7_1)

	pg.ConnectionMgr.GetInstance():Send(22014, {
		roomid = var1_1
	}, 22015, function(arg0_2)
		if arg0_2.result == 0 then
			var2_1:updateUsedDailyFinishCnt()
			arg0_1:sendNotification(GAME.QUICK_FINISH_LEARN_TACTICS_DONE)

			local var0_2 = Clone(var7_1.skills[var8_1])

			var7_1:addSkillExp(var0_2.id, var5_1.exp)
			var6_1:updateShip(var7_1)
			var2_1:SaveRecentShip(var5_1.shipId)
			var2_1:deleteStudent(var1_1)
			arg0_1:sendNotification(GAME.CANCEL_LEARN_TACTICS_DONE, {
				id = var1_1,
				shipId = var5_1.shipId,
				totalExp = var5_1.exp,
				oldSkill = var0_2,
				newSkill = var7_1.skills[var8_1],
				onConfirm = var4_1,
				newShipVO = var7_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("lesson_quickfinsh", arg0_2.result))
		end

		if var3_1 ~= nil then
			var3_1()
		end
	end)
end

return var0_0
