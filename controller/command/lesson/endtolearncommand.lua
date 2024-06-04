local var0 = class("EndToLearnCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(22004, {
		type = 0
	}, 22005, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(NavalAcademyProxy)
			local var1 = getProxy(BayProxy)
			local var2 = var0:getCourse()
			local var3 = var2:getConfig("name_show")
			local var4 = var2.proficiency
			local var5 = math.max(var4 - arg0.proficiency, 0)

			var2.proficiency = var5

			local var6 = {}
			local var7 = {}

			_.each(arg0.awards, function(arg0)
				var6[arg0.ship_id] = arg0.exp
				var7[arg0.ship_id] = arg0.energy
			end)

			local var8 = _.map(var2.students, function(arg0)
				return var1:getShipById(arg0)
			end)
			local var9 = Clone(var8)

			_.each(var9, function(arg0)
				arg0:addExp(var6[arg0.id] or 0)
				arg0:cosumeEnergy(var7[arg0.id] or 0)
				var1:updateShip(arg0)
			end)

			var2.students = {}
			var2.timestamp = 0

			var0:setCourse(var2)
			arg0:sendNotification(GAME.CLASS_STOP_COURSE_DONE, {
				title = var3,
				oldProficiency = var4,
				newProficiency = var5,
				oldStudents = var8,
				newStudents = var9
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("lesson_endToLearn", arg0.result))
		end
	end)
end

return var0
