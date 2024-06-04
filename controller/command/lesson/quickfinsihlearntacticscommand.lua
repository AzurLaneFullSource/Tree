local var0 = class("QuickFinsihLearnTacticsCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipId
	local var2 = getProxy(NavalAcademyProxy)
	local var3 = var0.callback
	local var4 = var0.onConfirm
	local var5 = var2:getStudentById(var1)
	local var6 = getProxy(BayProxy)
	local var7 = var6:getShipById(var5.shipId)
	local var8 = var5:getSkillId(var7)

	pg.ConnectionMgr.GetInstance():Send(22014, {
		roomid = var1
	}, 22015, function(arg0)
		if arg0.result == 0 then
			var2:updateUsedDailyFinishCnt()
			arg0:sendNotification(GAME.QUICK_FINISH_LEARN_TACTICS_DONE)

			local var0 = Clone(var7.skills[var8])

			var7:addSkillExp(var0.id, var5.exp)
			var6:updateShip(var7)
			var2:SaveRecentShip(var5.shipId)
			var2:deleteStudent(var1)
			arg0:sendNotification(GAME.CANCEL_LEARN_TACTICS_DONE, {
				id = var1,
				shipId = var5.shipId,
				totalExp = var5.exp,
				oldSkill = var0,
				newSkill = var7.skills[var8],
				onConfirm = var4,
				newShipVO = var7
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("lesson_quickfinsh", arg0.result))
		end

		if var3 ~= nil then
			var3()
		end
	end)
end

return var0
