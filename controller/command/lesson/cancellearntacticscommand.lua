local var0_0 = class("CancelLearnTacticsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipId
	local var2_1 = var0_1.type
	local var3_1 = getProxy(NavalAcademyProxy)

	if not var3_1:ExistStudent(var1_1) then
		return
	end

	local var4_1 = var3_1:getStudentById(var1_1)
	local var5_1 = var0_1.callback
	local var6_1 = var0_1.onConfirm

	if not var4_1 then
		existCall(var5_1)

		return
	end

	local var7_1 = getProxy(BayProxy)
	local var8_1 = var7_1:getShipById(var4_1.shipId)
	local var9_1 = var4_1:getSkillId(var8_1)

	if not var8_1.skills[var9_1] then
		pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_noskill_erro"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(22203, {
		room_id = var1_1,
		type = var2_1
	}, 22204, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = Clone(var8_1.skills[var9_1])

			var8_1:addSkillExp(var0_2.id, arg0_2.exp)
			var7_1:updateShip(var8_1)
			var3_1:deleteStudent(var1_1)
			var3_1:SaveRecentShip(var4_1.shipId)
			arg0_1:sendNotification(GAME.CANCEL_LEARN_TACTICS_DONE, {
				id = var1_1,
				shipId = var4_1.shipId,
				totalExp = arg0_2.exp,
				oldSkill = var0_2,
				newSkill = var8_1.skills[var9_1],
				onConfirm = var6_1,
				newShipVO = var8_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("lesson_endToLearn", arg0_2.result))
		end

		if var5_1 ~= nil then
			var5_1()
		end
	end)
end

return var0_0
