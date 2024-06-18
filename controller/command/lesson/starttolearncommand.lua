local var0_0 = class("StartToLearnCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().students

	pg.ConnectionMgr.GetInstance():Send(22002, {
		students = var0_1
	}, 22003, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NavalAcademyProxy)
			local var1_2 = var0_2:getCourse()

			var1_2.students = var0_1
			var1_2.timestamp = pg.TimeMgr.GetInstance():GetServerTime()

			var0_2:setCourse(var1_2)
			arg0_1:sendNotification(GAME.CLASS_START_COURSE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("lesson_startToLearn", arg0_2.result))
		end
	end)
end

return var0_0
