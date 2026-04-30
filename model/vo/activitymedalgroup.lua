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

	local var0_3 = arg0_3:GetMedalIds()

	arg0_3.medalList = {}

	for iter0_3, iter1_3 in ipairs(var0_3) do
		local var1_3 = {
			id = iter1_3
		}

		arg0_3.medalList[iter1_3] = var1_3
	end
end

function var0_0.GetMedalIds(arg0_4)
	return pg.activity_medal_template.get_id_list_by_group[arg0_4.configId]
end

function var0_0.IsMedalGroupCollectionGrey(arg0_5)
	player = getProxy(PlayerProxy):getData()

	return not player:getActivityMedalGroup()[arg0_5]
end

function var0_0.GetMedalGroupStateByID(arg0_6)
	local var0_6 = pg.activity_medal_group[arg0_6]
	local var1_6 = var0_6.is_out_of_print

	if var1_6 == 1 then
		return var0_0.STATE_EXPIRE
	elseif var1_6 == 0 then
		local var2_6 = false

		for iter0_6, iter1_6 in ipairs(var0_6.activity_link) do
			local var3_6 = iter1_6[2]
			local var4_6 = getProxy(ActivityProxy):getActivityById(var3_6)

			if var4_6 and not var4_6:isEnd() then
				var2_6 = true

				break
			end
		end

		if var2_6 then
			return var0_0.STATE_ACTIVE
		else
			return var0_0.STATE_CLOSE
		end
	end
end

function var0_0.GetMedalGroupState(arg0_7)
	local var0_7 = arg0_7:getConfig("is_out_of_print")

	if var0_7 == 1 then
		return var0_0.STATE_EXPIRE
	elseif var0_7 == 0 then
		if arg0_7:GetMedalGroupActivityConfig() then
			return var0_0.STATE_ACTIVE
		else
			return var0_0.STATE_CLOSE
		end
	end
end

function var0_0.GetMedalGroupActivityConfig(arg0_8)
	for iter0_8, iter1_8 in ipairs(arg0_8:getConfig("activity_link")) do
		local var0_8 = iter1_8[2]
		local var1_8 = getProxy(ActivityProxy):getActivityById(var0_8)

		if var1_8 and not var1_8:isEnd() then
			return iter1_8
		end
	end
end

function var0_0.GetMedalList(arg0_9)
	return arg0_9.medalList
end

function var0_0.UpdateMedal(arg0_10, arg1_10, arg2_10)
	arg0_10.medalList[arg1_10].timeStamp = arg2_10
end

function var0_0.GetAll(arg0_11)
	return underscore.all(arg0_11:GetMedalIds(), function(arg0_12)
		return arg0_11:OwnMedel(arg0_12)
	end)
end

function var0_0.OwnMedel(arg0_13, arg1_13)
	return arg0_13.medalList[arg1_13] and arg0_13.medalList[arg1_13].timeStamp and arg0_13.medalList[arg1_13].timeStamp ~= 0
end

function var0_0.GetGroupIDByMedalID(arg0_14)
	return pg.activity_medal_group[arg0_14].group
end

return var0_0
