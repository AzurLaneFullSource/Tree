local var0 = class("Favorite", import(".BaseVO"))

var0.STATE_AWARD = 1
var0.STATE_WAIT = 2
var0.STATE_LOCK = 3
var0.STATE_FETCHED = 4

function var0.Ctor(arg0, arg1)
	arg0.configId = arg1.id
	arg0.id = arg0.configId
	arg0.star = arg1.star
end

function var0.bindConfigTable(arg0)
	return pg.storeup_data_template
end

function var0.getStarCount(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in pairs(arg0:getConfig("char_list")) do
		if arg1[iter1] then
			var0 = var0 + arg1[iter1].star
		end
	end

	return var0
end

function var0.getNextAwardIndex(arg0, arg1)
	local var0 = 1

	if arg1[arg0.id] then
		var0 = arg1[arg0.id] + 1
	end

	return var0
end

function var0.isFetchAll(arg0, arg1)
	return (arg1[arg0.id] or 0) >= #arg0:getConfig("level")
end

function var0.canGetRes(arg0, arg1, arg2)
	local var0 = arg0:getNextAwardIndex(arg2)
	local var1 = arg0:getConfig("award_display")
	local var2 = arg0:getStarCount(arg1)
	local var3 = false

	if var0 <= #var1 then
		var3 = true

		if var2 >= arg0:getConfig("level")[var0] then
			return true
		end
	end

	return false, var3
end

function var0.getState(arg0, arg1, arg2)
	local var0 = arg2[arg0.id]
	local var1, var2 = arg0:canGetRes(arg1, arg2)
	local var3 = arg0:isFetchAll(arg2)

	if var1 then
		return var0.STATE_AWARD
	elseif var3 then
		return var0.STATE_FETCHED
	else
		return var2 and var0.STATE_WAIT or var0.STATE_LOCK
	end
end

function var0.getAwardState(arg0, arg1, arg2, arg3)
	local var0 = arg2[arg0.id] or 0
	local var1 = arg0:getConfig("level")
	local var2 = arg0:getConfig("award_display")

	if var1[arg3] <= arg0:getStarCount(arg1) then
		return var0 < arg3 and (var2[arg3] and var0.STATE_AWARD or var0.STATE_LOCK) or var0.STATE_FETCHED
	else
		return var2[arg3] and var0.STATE_WAIT or var0.STATE_LOCK
	end
end

function var0.containShipGroup(arg0, arg1)
	local var0 = arg0:getConfig("award_display")

	return _.any(var0, function(arg0)
		if arg0[1] == DROP_TYPE_SHIP and Ship.New({
			configId = arg0[2]
		}):getGroupId() == arg1 then
			return true
		end

		return false
	end)
end

return var0
