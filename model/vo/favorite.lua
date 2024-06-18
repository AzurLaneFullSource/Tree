local var0_0 = class("Favorite", import(".BaseVO"))

var0_0.STATE_AWARD = 1
var0_0.STATE_WAIT = 2
var0_0.STATE_LOCK = 3
var0_0.STATE_FETCHED = 4

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.configId = arg1_1.id
	arg0_1.id = arg0_1.configId
	arg0_1.star = arg1_1.star
end

function var0_0.bindConfigTable(arg0_2)
	return pg.storeup_data_template
end

function var0_0.getStarCount(arg0_3, arg1_3)
	local var0_3 = 0

	for iter0_3, iter1_3 in pairs(arg0_3:getConfig("char_list")) do
		if arg1_3[iter1_3] then
			var0_3 = var0_3 + arg1_3[iter1_3].star
		end
	end

	return var0_3
end

function var0_0.getNextAwardIndex(arg0_4, arg1_4)
	local var0_4 = 1

	if arg1_4[arg0_4.id] then
		var0_4 = arg1_4[arg0_4.id] + 1
	end

	return var0_4
end

function var0_0.isFetchAll(arg0_5, arg1_5)
	return (arg1_5[arg0_5.id] or 0) >= #arg0_5:getConfig("level")
end

function var0_0.canGetRes(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6:getNextAwardIndex(arg2_6)
	local var1_6 = arg0_6:getConfig("award_display")
	local var2_6 = arg0_6:getStarCount(arg1_6)
	local var3_6 = false

	if var0_6 <= #var1_6 then
		var3_6 = true

		if var2_6 >= arg0_6:getConfig("level")[var0_6] then
			return true
		end
	end

	return false, var3_6
end

function var0_0.getState(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg2_7[arg0_7.id]
	local var1_7, var2_7 = arg0_7:canGetRes(arg1_7, arg2_7)
	local var3_7 = arg0_7:isFetchAll(arg2_7)

	if var1_7 then
		return var0_0.STATE_AWARD
	elseif var3_7 then
		return var0_0.STATE_FETCHED
	else
		return var2_7 and var0_0.STATE_WAIT or var0_0.STATE_LOCK
	end
end

function var0_0.getAwardState(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = arg2_8[arg0_8.id] or 0
	local var1_8 = arg0_8:getConfig("level")
	local var2_8 = arg0_8:getConfig("award_display")

	if var1_8[arg3_8] <= arg0_8:getStarCount(arg1_8) then
		return var0_8 < arg3_8 and (var2_8[arg3_8] and var0_0.STATE_AWARD or var0_0.STATE_LOCK) or var0_0.STATE_FETCHED
	else
		return var2_8[arg3_8] and var0_0.STATE_WAIT or var0_0.STATE_LOCK
	end
end

function var0_0.containShipGroup(arg0_9, arg1_9)
	local var0_9 = arg0_9:getConfig("award_display")

	return _.any(var0_9, function(arg0_10)
		if arg0_10[1] == DROP_TYPE_SHIP and Ship.New({
			configId = arg0_10[2]
		}):getGroupId() == arg1_9 then
			return true
		end

		return false
	end)
end

return var0_0
