local var0 = class("CancelLearnTacticsCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipId
	local var2 = var0.type
	local var3 = getProxy(NavalAcademyProxy)

	if not var3:ExistStudent(var1) then
		return
	end

	local var4 = var3:getStudentById(var1)
	local var5 = var0.callback
	local var6 = var0.onConfirm

	if not var4 then
		existCall(var5)

		return
	end

	local var7 = getProxy(BayProxy)
	local var8 = var7:getShipById(var4.shipId)
	local var9 = var4:getSkillId(var8)

	if not var8.skills[var9] then
		pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_noskill_erro"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(22203, {
		room_id = var1,
		type = var2
	}, 22204, function(arg0)
		if arg0.result == 0 then
			local var0 = Clone(var8.skills[var9])

			var8:addSkillExp(var0.id, arg0.exp)
			var7:updateShip(var8)
			var3:deleteStudent(var1)
			var3:SaveRecentShip(var4.shipId)
			arg0:sendNotification(GAME.CANCEL_LEARN_TACTICS_DONE, {
				id = var1,
				shipId = var4.shipId,
				totalExp = arg0.exp,
				oldSkill = var0,
				newSkill = var8.skills[var9],
				onConfirm = var6,
				newShipVO = var8
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("lesson_endToLearn", arg0.result))
		end

		if var5 ~= nil then
			var5()
		end
	end)
end

return var0
