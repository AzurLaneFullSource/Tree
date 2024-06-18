local var0_0 = class("EndToLearnCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(22004, {
		type = 0
	}, 22005, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NavalAcademyProxy)
			local var1_2 = getProxy(BayProxy)
			local var2_2 = var0_2:getCourse()
			local var3_2 = var2_2:getConfig("name_show")
			local var4_2 = var2_2.proficiency
			local var5_2 = math.max(var4_2 - arg0_2.proficiency, 0)

			var2_2.proficiency = var5_2

			local var6_2 = {}
			local var7_2 = {}

			_.each(arg0_2.awards, function(arg0_3)
				var6_2[arg0_3.ship_id] = arg0_3.exp
				var7_2[arg0_3.ship_id] = arg0_3.energy
			end)

			local var8_2 = _.map(var2_2.students, function(arg0_4)
				return var1_2:getShipById(arg0_4)
			end)
			local var9_2 = Clone(var8_2)

			_.each(var9_2, function(arg0_5)
				arg0_5:addExp(var6_2[arg0_5.id] or 0)
				arg0_5:cosumeEnergy(var7_2[arg0_5.id] or 0)
				var1_2:updateShip(arg0_5)
			end)

			var2_2.students = {}
			var2_2.timestamp = 0

			var0_2:setCourse(var2_2)
			arg0_1:sendNotification(GAME.CLASS_STOP_COURSE_DONE, {
				title = var3_2,
				oldProficiency = var4_2,
				newProficiency = var5_2,
				oldStudents = var8_2,
				newStudents = var9_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("lesson_endToLearn", arg0_2.result))
		end
	end)
end

return var0_0
