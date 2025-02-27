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

function var0_0.IsMedalGroupCollectionGrey(arg0_4)
	player = getProxy(PlayerProxy):getData()

	return not player:getActivityMedalGroup()[arg0_4]
end

function var0_0.GetMedalGroupStateByID(arg0_5)
	local var0_5 = pg.activity_medal_group[arg0_5]
	local var1_5 = var0_5.is_out_of_print

	if var1_5 == 1 then
		return var0_0.STATE_EXPIRE
	elseif var1_5 == 0 then
		local var2_5 = false

		for iter0_5, iter1_5 in ipairs(var0_5.activity_link) do
			local var3_5 = iter1_5[2]
			local var4_5 = getProxy(ActivityProxy):getActivityById(var3_5)

			if var4_5 and not var4_5:isEnd() then
				var2_5 = true

				break
			end
		end

		if var2_5 then
			return var0_0.STATE_ACTIVE
		else
			return var0_0.STATE_CLOSE
		end
	end
end

function var0_0.GetMedalGroupState(arg0_6)
	local var0_6 = arg0_6:getConfig("is_out_of_print")

	if var0_6 == 1 then
		return var0_0.STATE_EXPIRE
	elseif var0_6 == 0 then
		if arg0_6:GetMedalGroupActivityConfig() then
			return var0_0.STATE_ACTIVE
		else
			return var0_0.STATE_CLOSE
		end
	end
end

function var0_0.GetMedalGroupActivityConfig(arg0_7)
	for iter0_7, iter1_7 in ipairs(arg0_7:getConfig("activity_link")) do
		local var0_7 = iter1_7[2]
		local var1_7 = getProxy(ActivityProxy):getActivityById(var0_7)

		if var1_7 and not var1_7:isEnd() then
			return iter1_7
		end
	end
end

function var0_0.GetMedalList(arg0_8)
	return arg0_8.medalList
end

function var0_0.UpdateMedal(arg0_9, arg1_9, arg2_9)
	arg0_9.medalList[arg1_9].timeStamp = arg2_9
end

function var0_0.GetGroupIDByMedalID(arg0_10)
	for iter0_10, iter1_10 in pairs(pg.activity_medal_group.all) do
		if table.contains(iter1_10.activity_medal_ids, arg0_10) then
			return iter0_10.id
		end
	end
end

return var0_0
