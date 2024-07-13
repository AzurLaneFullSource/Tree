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
			var0_4 = (function()
				local var0_5 = arg0_4:getConfig("benefit_condition")

				if var0_5[1] == "lv" then
					local var1_5 = getProxy(PlayerProxy):getRawData()

					return var1_0(var1_5.level, var0_5[2], var0_5[3])
				elseif var0_5[1] == "activity" then
					if var0_5[3] == 0 then
						return true
					end

					if var1_4:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF or var1_4:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
						local var2_5 = var0_5[3][1]

						return (var1_4.data1KeyValueList[2][var2_5] or 1) == var0_5[3][2]
					end
				end

				if var0_5 == "" then
					return true
				end
			end)() or false
		end
	end

	return var0_4
end

function var0_0.getLeftTime(arg0_6)
	local var0_6 = pg.TimeMgr.GetInstance():GetServerTime()

	return getProxy(ActivityProxy):getActivityById(arg0_6.activityId).stopTime - var0_6
end

function var0_0.isAddedBuff(arg0_7)
	local var0_7 = true
	local var1_7 = getProxy(ActivityProxy):getActivityById(arg0_7.activityId)

	if var1_7 and not var1_7:isEnd() then
		local var2_7 = arg0_7:getConfig("benefit_condition")

		if var2_7[1] == "pt" then
			local var3_7 = var2_7[2]
			local var4_7 = var2_7[3]
			local var5_7 = var2_7[4]
			local var6_7 = pg.player_resource[var3_7].name
			local var7_7 = getProxy(PlayerProxy):getData()[var6_7] or 0

			if not (var4_7 <= var7_7) or not (var7_7 < var5_7) then
				var0_7 = false
			end
		end
	end

	return var0_7
end

return var0_0
