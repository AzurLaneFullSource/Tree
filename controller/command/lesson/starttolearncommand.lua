local var0 = class("StartToLearnCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().students

	pg.ConnectionMgr.GetInstance():Send(22002, {
		students = var0
	}, 22003, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(NavalAcademyProxy)
			local var1 = var0:getCourse()

			var1.students = var0
			var1.timestamp = pg.TimeMgr.GetInstance():GetServerTime()

			var0:setCourse(var1)
			arg0:sendNotification(GAME.CLASS_START_COURSE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("lesson_startToLearn", arg0.result))
		end
	end)
end

return var0
