local var0 = class("ActivityBuff", import(".CommonBuff"))

function var0.Ctor(arg0, arg1, arg2, arg3)
	var0.super.Ctor(arg0, {
		id = arg2,
		timestamp = arg3
	})

	arg0.activityId = arg1
end

function var0.IsActiveType(arg0)
	return true
end

local function var1(arg0, arg1, arg2)
	if arg1 == "<=" then
		return arg0 <= arg2
	elseif arg1 == "<" then
		return arg0 < arg2
	elseif arg1 == "==" then
		return arg0 == arg2
	elseif arg1 == ">=" then
		return arg2 <= arg0
	elseif arg1 == ">" then
		return arg2 < arg0
	end

	return false
end

function var0.isActivate(arg0)
	local var0 = false
	local var1 = getProxy(ActivityProxy):getActivityById(arg0.activityId)

	if var1 and not var1:isEnd() then
		if var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUFF then
			if arg0:RookieBattleExpUsage() then
				if getProxy(PlayerProxy):getRawData().level < arg0:GetRookieBattleExpMaxLevel() then
					var0 = true
				end
			elseif arg0:isAddedBuff() then
				var0 = true
			end
		else
			var0 = (function()
				local var0 = arg0:getConfig("benefit_condition")

				if var0[1] == "lv" then
					local var1 = getProxy(PlayerProxy):getRawData()

					return var1(var1.level, var0[2], var0[3])
				elseif var0[1] == "activity" then
					if var0[3] == 0 then
						return true
					end

					if var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF or var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
						local var2 = var0[3][1]

						return (var1.data1KeyValueList[2][var2] or 1) == var0[3][2]
					end
				end

				if var0 == "" then
					return true
				end
			end)() or false
		end
	end

	return var0
end

function var0.getLeftTime(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return getProxy(ActivityProxy):getActivityById(arg0.activityId).stopTime - var0
end

function var0.isAddedBuff(arg0)
	local var0 = true
	local var1 = getProxy(ActivityProxy):getActivityById(arg0.activityId)

	if var1 and not var1:isEnd() then
		local var2 = arg0:getConfig("benefit_condition")

		if var2[1] == "pt" then
			local var3 = var2[2]
			local var4 = var2[3]
			local var5 = var2[4]
			local var6 = pg.player_resource[var3].name
			local var7 = getProxy(PlayerProxy):getData()[var6] or 0

			if not (var4 <= var7) or not (var7 < var5) then
				var0 = false
			end
		end
	end

	return var0
end

return var0
