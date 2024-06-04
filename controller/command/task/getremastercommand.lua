local var0 = class("GetRemasterCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	pg.ConnectionMgr.GetInstance():Send(13503, {
		type = 0
	}, 13504, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(ChapterProxy)

			var0:updateDailyCount()

			local var1 = Drop.New({
				type = DROP_TYPE_VITEM,
				id = ITEM_ID_REACT_CHAPTER_TICKET,
				count = math.min(pg.gameset.reactivity_ticket_daily.key_value, pg.gameset.reactivity_ticket_max.key_value - var0.remasterTickets)
			})

			arg0:sendNotification(GAME.ADD_ITEM, var1)
			arg0:sendNotification(GAME.GET_REMASTER_TICKETS_DONE, {
				var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("领取失败")
		end
	end)
end

return var0
