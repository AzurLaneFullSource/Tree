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
	local var0_4 = false
	local var1_4 = getProxy(ActivityProxy):getActivityById(arg0_4.activityId)

	if var1_4 and not var1_4:isEnd() then
		if var1_4:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUFF then
			if arg0_4:RookieBattleExpUsage() then
				if getProxy(PlayerProxy):getRawData().level < arg0_4:GetRookieBattleExpMaxLevel() then
					var0_4 = true
				end
			elseif arg0_4:isAddedBuff() then
				var0_4 = true
			end
		else
			local var2_4 = noEmptyStr(arg0_4:getConfig("benefit_condition"))

			var0_4 = not var2_4 and true or switch(var2_4[1], {
				lv = function()
					local var0_5 = getProxy(PlayerProxy):getRawData()

					return var1_0(var0_5.level, var2_4[2], var2_4[3])
				end,
				activity = function()
					if var2_4[3] == 0 then
						return true
					end

					if var1_4:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF or var1_4:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
						local var0_6 = var2_4[3][1]

						return (var1_4.data1KeyValueList[2][var0_6] or 1) == var2_4[3][2]
					end
				end,
				chapter = function(arg0_7)
					return true
				end
			}, function()
				return false
			end) or false
		end
	end

	return var0_4
end

function var0_0.checkChaper(arg0_9, arg1_9)
	local var0_9 = noEmptyStr(arg0_9:getConfig("benefit_condition"))

	if not var0_9 or var0_9[1] ~= "chapter" then
		return true
	else
		return table.contains(var0_9[2], arg1_9)
	end
end

function var0_0.getLeftTime(arg0_10)
	local var0_10 = pg.TimeMgr.GetInstance():GetServerTime()

	return getProxy(ActivityProxy):getActivityById(arg0_10.activityId).stopTime - var0_10
end

function var0_0.isAddedBuff(arg0_11)
	local var0_11 = true
	local var1_11 = getProxy(ActivityProxy):getActivityById(arg0_11.activityId)

	if var1_11 and not var1_11:isEnd() then
		local var2_11 = arg0_11:getConfig("benefit_condition")

		if var2_11[1] == "pt" then
			local var3_11 = var2_11[2]
			local var4_11 = var2_11[3]
			local var5_11 = var2_11[4]
			local var6_11 = pg.player_resource[var3_11].name
			local var7_11 = getProxy(PlayerProxy):getData()[var6_11] or 0

			if not (var4_11 <= var7_11) or not (var7_11 < var5_11) then
				var0_11 = false
			end
		end
	end

	return var0_11
end

return var0_0
