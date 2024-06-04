local var0 = class("GameRoomProxy", import(".NetProxy"))

var0.coin_res_id = 11
var0.ticket_res_id = 12
var0.ticket_remind = false

function var0.register(arg0)
	arg0.data = {}
	arg0.rooms = {}

	arg0:on(26120, function(arg0)
		arg0.weekly = arg0.weekly_free
		arg0.monthlyTicket = arg0.monthly_ticket

		if arg0.rooms then
			for iter0, iter1 in ipairs(arg0.rooms) do
				table.insert(arg0.rooms, {
					roomId = iter1.roomid,
					maxScore = iter1.max_score
				})
			end
		end

		arg0.payCoinCount = arg0.pay_coin_count
		arg0.firstEnter = arg0.first_enter
	end)
end

function var0.getRoomScore(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.rooms) do
		if iter1.roomId == arg1 then
			return iter1.maxScore
		end
	end

	return 0
end

function var0.storeGameScore(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg0.rooms) do
		if iter1.roomId == arg1 and arg2 > iter1.maxScore then
			iter1.maxScore = arg2

			return
		end
	end

	table.insert(arg0.rooms, {
		roomId = arg1,
		maxScore = arg2
	})
end

function var0.getCoin(arg0)
	return getProxy(PlayerProxy):getRawData():getResource(var0.coin_res_id)
end

function var0.getTicket(arg0)
	return getProxy(PlayerProxy):getRawData():getResource(var0.ticket_res_id)
end

function var0.getMonthlyTicket(arg0)
	return arg0.monthlyTicket
end

function var0.setMonthlyTicket(arg0, arg1)
	arg0.monthlyTicket = arg0.monthlyTicket + arg1
end

function var0.lastMonthlyTicket(arg0)
	local var0 = pg.gameset.game_ticket_month.key_value - arg0.monthlyTicket

	return var0 < 0 and 0 or var0
end

function var0.lastTicketMax(arg0)
	local var0 = pg.gameset.game_room_remax.key_value - arg0:getTicket()

	return var0 < 0 and 0 or var0
end

function var0.ticketMaxTip(arg0)
	if arg0:lastMonthlyTicket() <= 200 then
		return i18n("game_ticket_max_month")
	elseif arg0:lastTicketMax() <= 200 then
		return i18n("game_ticket_max_all")
	end

	return nil
end

function var0.getFirstEnter(arg0)
	return arg0.firstEnter == 0
end

function var0.getPayCoinCount(arg0)
	return arg0.payCoinCount
end

function var0.setPayCoinCount(arg0, arg1)
	arg0.payCoinCount = arg0.payCoinCount + arg1
end

function var0.setFirstEnter(arg0)
	arg0.firstEnter = 1
end

function var0.getWeekly(arg0)
	return arg0.weekly == 0
end

function var0.setWeekly(arg0)
	arg0.weekly = 1
end

function var0.getTip(arg0)
	if arg0.firstEnter == 0 then
		return true
	end

	if arg0.weekly == 0 then
		return true
	end

	return false
end

return var0
