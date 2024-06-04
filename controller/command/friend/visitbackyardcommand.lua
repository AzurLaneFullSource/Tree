local var0 = class("VisitBackYardCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(FriendProxy):getFriend(var0)

	if not var1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_not_add"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(19101, {
		user_id = var0
	}, 19102, function(arg0)
		if arg0.lv == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_unopen"))

			return
		end

		arg0:sendNotification(GAME.GET_BACKYARD_DATA, {
			data = arg0
		})

		local var0 = getProxy(DormProxy).friendData

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("data_erro"))
		else
			if not var0.name or var0.name == "" then
				var0.name = var1.name
			end

			arg0:sendNotification(GAME.VISIT_BACKYARD_DONE, {
				player = var1,
				dorm = var0
			})
		end
	end)
end

return var0
