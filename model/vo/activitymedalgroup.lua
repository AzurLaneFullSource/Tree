local var0_0 = class("ActivityMedalGroup", import("model.vo.BaseVO"))

var0_0.STATE_EXPIRE = -1
var0_0.STATE_CLOSE = 0
var0_0.STATE_ACTIVE = 1

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_medal_group
end

function var0_0.GetConfigID(arg0_2)
	return arg0_2.configId
end

function var0_0.Ctor(arg0_3, arg1_3)
	arg0_3.configId = arg1_3

	local var0_3 = arg0_3:getConfig("activity_medal_ids")

	arg0_3.medalList = {}

	for iter0_3, iter1_3 in ipairs(var0_3) do
		local var1_3 = {
			id = iter1_3
		}

		arg0_3.medalList[iter1_3] = var1_3
	end
end

function var0_0.GetMedalGroupStateByID(arg0_4)
	local var0_4 = pg.activity_medal_group[arg0_4]
	local var1_4 = var0_4.is_out_of_print

	if var1_4 == 1 then
		return var0_0.STATE_EXPIRE
	elseif var1_4 == 0 then
		local var2_4 = false

		for iter0_4, iter1_4 in ipairs(var0_4.activity_link) do
			local var3_4 = iter1_4[2]
			local var4_4 = getProxy(ActivityProxy):getActivityById(var3_4)

			if var4_4 and not var4_4:isEnd() then
				var2_4 = true

				break
			end
		end

		if var2_4 then
			return var0_0.STATE_ACTIVE
		else
			return var0_0.STATE_CLOSE
		end
	end
end

function var0_0.GetMedalGroupState(arg0_5)
	local var0_5 = arg0_5:getConfig("is_out_of_print")

	if var0_5 == 1 then
		return var0_0.STATE_EXPIRE
	elseif var0_5 == 0 then
		if arg0_5:GetMedalGroupActivityConfig() then
			return var0_0.STATE_ACTIVE
		else
			return var0_0.STATE_CLOSE
		end
	end
end

function var0_0.GetMedalGroupActivityConfig(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6:getConfig("activity_link")) do
		local var0_6 = iter1_6[2]
		local var1_6 = getProxy(ActivityProxy):getActivityById(var0_6)

		if var1_6 and not var1_6:isEnd() then
			return iter1_6
		end
	end
end

function var0_0.GetMedalList(arg0_7)
	return arg0_7.medalList
end

function var0_0.UpdateMedal(arg0_8, arg1_8, arg2_8)
	arg0_8.medalList[arg1_8].timeStamp = arg2_8
end

function var0_0.GetGroupIDByMedalID(arg0_9)
	for iter0_9, iter1_9 in pairs(pg.activity_medal_group.all) do
		if table.contains(iter1_9.activity_medal_ids, arg0_9) then
			return iter0_9.id
		end
	end
end

return var0_0
