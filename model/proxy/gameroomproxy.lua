local var0_0 = class("GameRoomProxy", import(".NetProxy"))

var0_0.coin_res_id = 11
var0_0.ticket_res_id = 12
var0_0.ticket_remind = false

function var0_0.register(arg0_1)
	arg0_1.data = {}
	arg0_1.rooms = {}

	arg0_1:on(26120, function(arg0_2)
		arg0_1.weekly = arg0_2.weekly_free
		arg0_1.monthlyTicket = arg0_2.monthly_ticket

		if arg0_2.rooms then
			for iter0_2, iter1_2 in ipairs(arg0_2.rooms) do
				table.insert(arg0_1.rooms, {
					roomId = iter1_2.roomid,
					maxScore = iter1_2.max_score
				})
			end
		end

		arg0_1.payCoinCount = arg0_2.pay_coin_count
		arg0_1.firstEnter = arg0_2.first_enter
	end)
end

function var0_0.getRoomScore(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.rooms) do
		if iter1_3.roomId == arg1_3 then
			return iter1_3.maxScore
		end
	end

	return 0
end

function var0_0.storeGameScore(arg0_4, arg1_4, arg2_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.rooms) do
		if iter1_4.roomId == arg1_4 and arg2_4 > iter1_4.maxScore then
			iter1_4.maxScore = arg2_4

			return
		end
	end

	table.insert(arg0_4.rooms, {
		roomId = arg1_4,
		maxScore = arg2_4
	})
end

function var0_0.getCoin(arg0_5)
	return getProxy(PlayerProxy):getRawData():getResource(var0_0.coin_res_id)
end

function var0_0.getTicket(arg0_6)
	return getProxy(PlayerProxy):getRawData():getResource(var0_0.ticket_res_id)
end

function var0_0.getMonthlyTicket(arg0_7)
	return arg0_7.monthlyTicket
end

function var0_0.setMonthlyTicket(arg0_8, arg1_8)
	arg0_8.monthlyTicket = arg0_8.monthlyTicket + arg1_8
end

function var0_0.lastMonthlyTicket(arg0_9)
	local var0_9 = pg.gameset.game_ticket_month.key_value - arg0_9.monthlyTicket

	return var0_9 < 0 and 0 or var0_9
end

function var0_0.lastTicketMax(arg0_10)
	local var0_10 = pg.gameset.game_room_remax.key_value - arg0_10:getTicket()

	return var0_10 < 0 and 0 or var0_10
end

function var0_0.ticketMaxTip(arg0_11)
	if arg0_11:lastMonthlyTicket() <= 200 then
		return i18n("game_ticket_max_month")
	elseif arg0_11:lastTicketMax() <= 200 then
		return i18n("game_ticket_max_all")
	end

	return nil
end

function var0_0.getFirstEnter(arg0_12)
	return arg0_12.firstEnter == 0
end

function var0_0.getPayCoinCount(arg0_13)
	return arg0_13.payCoinCount
end

function var0_0.setPayCoinCount(arg0_14, arg1_14)
	arg0_14.payCoinCount = arg0_14.payCoinCount + arg1_14
end

function var0_0.setFirstEnter(arg0_15)
	arg0_15.firstEnter = 1
end

function var0_0.getWeekly(arg0_16)
	return arg0_16.weekly == 0
end

function var0_0.setWeekly(arg0_17)
	arg0_17.weekly = 1
end

function var0_0.getTip(arg0_18)
	if arg0_18.firstEnter == 0 then
		return true
	end

	if arg0_18.weekly == 0 then
		return true
	end

	return false
end

return var0_0
