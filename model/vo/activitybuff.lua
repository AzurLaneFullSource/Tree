local var0_0 = class("ActivityBuff", import(".CommonBuff"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, {
		id = arg2_1,
		timestamp = arg3_1
	})

	arg0_1.activityId = arg1_1
end

function var0_0.IsActiveType(arg0_2)
	return true
end

local function var1_0(arg0_3, arg1_3, arg2_3)
	if arg1_3 == "<=" then
		return arg0_3 <= arg2_3
	elseif arg1_3 == "<" then
		return arg0_3 < arg2_3
	elseif arg1_3 == "==" then
		return arg0_3 == arg2_3
	elseif arg1_3 == ">=" then
		return arg2_3 <= arg0_3
	elseif arg1_3 == ">" then
		return arg2_3 < arg0_3
	end

	return false
end

function var0_0.isActivate(arg0_4)
	local var0_4 = getProxy(ActivityProxy)

	if not var0_4:IsActivityNotEnd(arg0_4.activityId) then
		return false
	end

	local var1_4 = var0_4:getActivityById(arg0_4.activityId)

	if var1_4:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_BUFF and not ActivityPtData.New(var1_4):isInBuffTime() then
		return false
	end

	local var2_4 = noEmptyStr(arg0_4:getConfig("benefit_condition"))

	if not var2_4 then
		return true
	end

	return switch(var2_4[1], {
		pt = function()
			local var0_5, var1_5, var2_5, var3_5 = unpack(var2_4)
			local var4_5 = pg.player_resource[var1_5].name
			local var5_5 = getProxy(PlayerProxy):getData()[var4_5] or 0

			return var2_5 <= var5_5 and var5_5 < var3_5
		end,
		lv = function()
			local var0_6 = getProxy(PlayerProxy):getRawData()

			return var1_0(var0_6.level, var2_4[2], var2_4[3])
		end,
		activity = function()
			if not var0_4:IsActivityNotEnd(var2_4[2]) then
				return false
			end

			if var1_4:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF or var1_4:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
				if var2_4[3] ~= 0 then
					return true
				end

				local var0_7 = var2_4[3][1]

				return (var1_4.data1KeyValueList[2][var0_7] or 1) == var2_4[3][2]
			end

			return true
		end,
		chapter = function(arg0_8)
			return true
		end
	}, function()
		return false
	end)
end

function var0_0.checkChaper(arg0_10, arg1_10)
	local var0_10 = noEmptyStr(arg0_10:getConfig("benefit_condition"))

	if not var0_10 or var0_10[1] ~= "chapter" then
		return true
	else
		return table.contains(var0_10[2], arg1_10)
	end
end

function var0_0.getLeftTime(arg0_11)
	local var0_11 = pg.TimeMgr.GetInstance():GetServerTime()

	return getProxy(ActivityProxy):getActivityById(arg0_11.activityId).stopTime - var0_11
end

return var0_0
