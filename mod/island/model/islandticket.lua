local var0_0 = class("IslandTicket", import("model.vo.BaseVO"))

var0_0.TYPES = {
	ONE_MINUTE = 1,
	TEN_MINUTE = 2,
	ONE_HOUR = 3
}
var0_0.TYPE2BG = {
	[var0_0.TYPES.ONE_MINUTE] = "bg_blue",
	[var0_0.TYPES.TEN_MINUTE] = "bg_purple",
	[var0_0.TYPES.ONE_HOUR] = "bg_gold"
}
var0_0.TYPE2FRAME = {
	[var0_0.TYPES.ONE_MINUTE] = "rarity_blue",
	[var0_0.TYPES.TEN_MINUTE] = "rarity_purple",
	[var0_0.TYPES.ONE_HOUR] = "rarity_orange"
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg0_1.id
	arg0_1.count = arg3_1
	arg0_1.endTime = arg2_1
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_speedup_ticket
end

function var0_0.GetType(arg0_3)
	return arg0_3:getConfig("type")
end

function var0_0.GetTime(arg0_4)
	return arg0_4:getConfig("speedup_time")
end

function var0_0.GetBgName(arg0_5)
	return var0_0.TYPE2BG[arg0_5:GetType()]
end

function var0_0.GetFrameName(arg0_6)
	return var0_0.TYPE2FRAME[arg0_6:GetType()]
end

function var0_0.GetIconName(arg0_7)
	return "island/" .. arg0_7:getConfig("icon")
end

function var0_0.GetCount(arg0_8)
	return arg0_8.count
end

function var0_0.AddCount(arg0_9, arg1_9)
	arg0_9.count = arg0_9.count + arg1_9
end

function var0_0.ReduceCount(arg0_10, arg1_10)
	arg0_10.count = arg0_10.count - arg1_10
end

function var0_0.IsEmpty(arg0_11)
	return arg0_11.count <= 0
end

function var0_0.IsForever(arg0_12)
	return arg0_12.endTime == 0
end

function var0_0.GetEndTime(arg0_13)
	return arg0_13.endTime
end

function var0_0.GetRemainTime(arg0_14)
	return arg0_14.endTime - pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.IsExpired(arg0_15)
	if arg0_15:IsForever() then
		return false
	end

	return arg0_15:GetRemainTime() < 0
end

function var0_0.WillExpire(arg0_16)
	if arg0_16:IsForever() then
		return false
	end

	local var0_16 = arg0_16:GetRemainTime()

	return var0_16 > 0 and var0_16 < 172800
end

function var0_0.GetEndTimeById(arg0_17, arg1_17)
	local var0_17 = pg.island_speedup_ticket[arg0_17]

	if var0_17.expiration_type == 2 then
		local var1_17 = var0_17.expiration_time

		if var1_17 == "always" then
			return 0
		end

		return pg.TimeMgr.GetInstance():parseTimeFromConfig(var1_17)
	elseif var0_17.expiration_type == 1 then
		return (arg1_17 or pg.TimeMgr.GetInstance():GetTimeToNextTime() - 86400) + 86400 * var0_17.duration - 1
	end

	return 0
end

return var0_0
