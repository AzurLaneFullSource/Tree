local var0_0 = class("StartLearnTacticsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipId
	local var2_1 = var0_1.lessonId
	local var3_1 = var0_1.skillPos
	local var4_1 = var0_1.roomId
	local var5_1 = getProxy(BagProxy)
	local var6_1 = var5_1:getItemById(var2_1)

	if not var6_1 or var6_1.count == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", var6_1:getConfig("name")))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(22201, {
		room_id = var4_1,
		ship_id = var1_1,
		skill_pos = var3_1,
		item_id = var2_1
	}, 22202, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NavalAcademyProxy)
			local var1_2 = Item.getConfigData(var2_1).usage_arg[1]
			local var2_2 = Student.New(arg0_2.class_info)

			var2_2:setTime(var1_2)
			var2_2:setLesson(var2_1)
			var0_2:addStudent(var2_2)
			var5_1:removeItemById(var6_1.id, 1)
			arg0_1:sendNotification(GAME.START_TO_LEARN_TACTICS_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("lesson_endToLearn", arg0_2.result))
		end
	end)
end

return var0_0
