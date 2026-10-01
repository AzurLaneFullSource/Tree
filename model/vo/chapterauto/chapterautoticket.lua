local var0_0 = class("ChapterAutoTicket")

var0_0.TYPE = {
	MAIN = 1,
	WORLD = 2,
	TIME = 3
}
var0_0.GET_SHOW_ID = {
	[var0_0.TYPE.MAIN] = 68710,
	[var0_0.TYPE.TIME] = 68711,
	[var0_0.TYPE.WORLD] = 68712
}
var0_0.FOREVER_TIME = 4294967295

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.time
	arg0_1.type = arg1_1.type
	arg0_1.count = arg1_1.num
	arg0_1.expireTime = arg0_1.id
end

function var0_0.GetRemainTime(arg0_2)
	return arg0_2.expireTime - pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.IsForever(arg0_3)
	return arg0_3.expireTime == var0_0.FOREVER_TIME
end

function var0_0.IsExpired(arg0_4)
	return arg0_4:GetRemainTime() < 0
end

function var0_0.WillExpire(arg0_5)
	local var0_5 = arg0_5:GetRemainTime()

	return var0_5 > 0 and var0_5 < 86400 * pg.gameset.auto_battle_ticket_warning_time.key_value
end

function var0_0.GetCount(arg0_6)
	return arg0_6.count
end

function var0_0.IncreaseCount(arg0_7, arg1_7)
	arg0_7.count = arg0_7.count + arg1_7
end

function var0_0.ReduceCount(arg0_8, arg1_8)
	arg0_8.count = math.max(0, arg0_8.count - arg1_8)
end

function var0_0.GetDrop(arg0_9)
	local var0_9 = var0_0.GET_SHOW_ID[arg0_9]

	return Drop.New({
		count = 0,
		type = DROP_TYPE_VITEM,
		id = var0_9
	})
end

function var0_0.CreateByItem(arg0_10, arg1_10)
	return var0_0.New({
		type = arg0_10,
		time = var0_0.GetExpireTimeByArg(arg1_10:getConfig("drop_arg")),
		num = arg1_10.count
	})
end

function var0_0.GetExpireTimeByArg(arg0_11)
	if type(arg0_11) ~= "table" then
		return var0_0.FOREVER_TIME
	end

	if #arg0_11 == 0 then
		return var0_0.FOREVER_TIME
	end

	local var0_11 = arg0_11[1]
	local var1_11 = arg0_11[2]

	if type(var0_11) == "table" then
		return pg.TimeMgr.GetInstance():parseTimeFromConfig(arg0_11)
	end

	if type(var0_11) == "string" then
		local var2_11 = pg.TimeMgr.GetInstance()

		return switch(var0_11, {
			always = function()
				return var0_0.FOREVER_TIME
			end,
			day = function()
				return var2_11:GetTimeToNextTime() + var1_11 * 86400
			end,
			week = function()
				return var2_11:GetNextWeekTime(1, 0, 0, 0) + var1_11 * 604800
			end,
			month = function()
				local var0_15 = var2_11:STimeDescS(var2_11:GetServerTime(), "*t")
				local var1_15 = var0_15.month + var1_11 + 1
				local var2_15 = var0_15.year + math.floor((var1_15 - 1) / 12)
				local var3_15 = (var1_15 - 1) % 12 + 1

				return var2_11:Table2ServerTime({
					sec = 0,
					min = 0,
					hour = 0,
					day = 1,
					year = var2_15,
					month = var3_15
				})
			end,
			year = function()
				local var0_16 = tonumber(var2_11:STimeDescS(var2_11:GetServerTime(), "%Y")) + var1_11 + 1

				return var2_11:Table2ServerTime({
					min = 0,
					month = 1,
					hour = 0,
					sec = 0,
					day = 1,
					year = var0_16
				})
			end
		}, function()
			return var0_0.FOREVER_TIME
		end)
	end

	return var0_0.FOREVER_TIME
end

return var0_0
