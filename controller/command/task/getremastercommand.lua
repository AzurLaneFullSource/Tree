local var0_0 = class("GetRemasterCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	pg.ConnectionMgr.GetInstance():Send(13503, {
		type = 0
	}, 13504, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(ChapterProxy)

			var0_2:updateDailyCount()

			local var1_2 = Drop.New({
				type = DROP_TYPE_VITEM,
				id = ITEM_ID_REACT_CHAPTER_TICKET,
				count = math.min(pg.gameset.reactivity_ticket_daily.key_value, pg.gameset.reactivity_ticket_max.key_value - var0_2.remasterTickets)
			})

			arg0_1:sendNotification(GAME.ADD_ITEM, var1_2)
			arg0_1:sendNotification(GAME.GET_REMASTER_TICKETS_DONE, {
				var1_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("领取失败")
		end
	end)
end

return var0_0
