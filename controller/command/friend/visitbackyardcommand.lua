local var0_0 = class("VisitBackYardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(FriendProxy):getFriend(var0_1)

	if not var1_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_not_add"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(19101, {
		user_id = var0_1
	}, 19102, function(arg0_2)
		if arg0_2.lv == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_unopen"))

			return
		end

		arg0_1:sendNotification(GAME.GET_BACKYARD_DATA, {
			data = arg0_2
		})

		local var0_2 = getProxy(DormProxy).friendData

		if not var0_2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("data_erro"))
		else
			if not var0_2.name or var0_2.name == "" then
				var0_2.name = var1_1.name
			end

			arg0_1:sendNotification(GAME.VISIT_BACKYARD_DONE, {
				player = var1_1,
				dorm = var0_2
			})
		end
	end)
end

return var0_0
