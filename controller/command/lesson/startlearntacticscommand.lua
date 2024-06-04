local var0 = class("StartLearnTacticsCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipId
	local var2 = var0.lessonId
	local var3 = var0.skillPos
	local var4 = var0.roomId
	local var5 = getProxy(BagProxy)
	local var6 = var5:getItemById(var2)

	if not var6 or var6.count == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", var6:getConfig("name")))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(22201, {
		room_id = var4,
		ship_id = var1,
		skill_pos = var3,
		item_id = var2
	}, 22202, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(NavalAcademyProxy)
			local var1 = Item.getConfigData(var2).usage_arg[1]
			local var2 = Student.New(arg0.class_info)

			var2:setTime(var1)
			var2:setLesson(var2)
			var0:addStudent(var2)
			var5:removeItemById(var6.id, 1)
			arg0:sendNotification(GAME.START_TO_LEARN_TACTICS_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("lesson_endToLearn", arg0.result))
		end
	end)
end

return var0
