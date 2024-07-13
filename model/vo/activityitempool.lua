local var0_0 = class("ActivityItemPool", import(".BaseVO"))
local var1_0 = pg.activity_random_award_item

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.awards = arg1_1.awards or {}
	arg0_1.prevId = arg1_1.prevId
	arg0_1.index = arg1_1.index
end

function var0_0.bindConfigTable(arg0_2)
	return pg.activity_random_award_template
end

function var0_0.getComsume(arg0_3)
	local var0_3 = arg0_3:getConfig("resource_category")
	local var1_3 = arg0_3:getConfig("resource_type")
	local var2_3 = arg0_3:getConfig("resource_num")

	return {
		type = var0_3,
		id = var1_3,
		count = var2_3
	}
end

function var0_0.enoughResForUsage(arg0_4, arg1_4)
	local var0_4 = arg0_4:getComsume()

	if var0_4.type == DROP_TYPE_RESOURCE then
		if getProxy(PlayerProxy):getData():getResById(var0_4.id) < var0_4.count * arg1_4 then
			return false
		end
	elseif var0_4.type == DROP_TYPE_ITEM and getProxy(BagProxy):getItemCountById(var0_4.id) < var0_4.count * arg1_4 then
		return false
	end

	return true
end

function var0_0.getItemCount(arg0_5)
	local var0_5 = arg0_5:getConfig("item_list")

	return _.reduce(var0_5, 0, function(arg0_6, arg1_6)
		return arg0_6 + arg1_6[2]
	end)
end

function var0_0.getleftItemCount(arg0_7)
	return arg0_7:getItemCount() - arg0_7:getFetchCount()
end

function var0_0.getFetchCount(arg0_8)
	return _.reduce(_.values(arg0_8.awards), 0, function(arg0_9, arg1_9)
		return arg0_9 + arg1_9
	end)
end

function var0_0.getMainItems(arg0_10)
	return arg0_10:filterItems(true)
end

function var0_0.filterItems(arg0_11, arg1_11)
	local var0_11 = arg0_11:getConfig("main_item")
	local var1_11 = _.select(arg0_11:getConfig("item_list"), function(arg0_12)
		if arg1_11 then
			return table.contains(var0_11, arg0_12[1])
		else
			return not table.contains(var0_11, arg0_12[1])
		end
	end)

	return (_.map(var1_11, function(arg0_13)
		local var0_13 = var1_0[arg0_13[1]]
		local var1_13 = arg0_11.awards[arg0_13[1]] or 0

		return {
			id = var0_13.commodity_id,
			type = var0_13.resource_category,
			count = var0_13.num,
			surplus = arg0_13[2] - var1_13,
			total = arg0_13[2]
		}
	end))
end

function var0_0.getItems(arg0_14)
	local var0_14 = arg0_14:filterItems(true)
	local var1_14 = arg0_14:filterItems(false)

	return var0_14, var1_14
end

function var0_0.canOpenNext(arg0_15)
	return _.all(arg0_15:getMainItems(), function(arg0_16)
		return arg0_16.surplus == 0
	end)
end

function var0_0.getTempleNewChar(arg0_17, arg1_17)
	if not arg0_17.charAwardDisplayData then
		arg0_17.charAwardDisplayData = {}

		for iter0_17, iter1_17 in ipairs(pg.guardian_template.all) do
			if pg.guardian_template[iter1_17].guardian_gain_pool == arg0_17.configId then
				local var0_17 = arg0_17:getCharLotteryCount(iter1_17)

				table.insert(arg0_17.charAwardDisplayData, {
					iter1_17,
					var0_17
				})
			end
		end
	end

	local var1_17 = {}
	local var2_17 = arg0_17:getFetchCount()

	for iter2_17 = arg1_17 + 1, var2_17 do
		for iter3_17, iter4_17 in ipairs(arg0_17.charAwardDisplayData) do
			if iter4_17[2] == iter2_17 then
				table.insert(var1_17, iter4_17[1])
			end
		end
	end

	return var1_17
end

var0_0.guardian_type_lottery = 1
var0_0.guardian_type_lock = 2

function var0_0.getCharLotteryCount(arg0_18, arg1_18)
	local var0_18 = pg.guardian_template[arg1_18]

	if var0_18.type == ActivityItemPool.guardian_type_lottery then
		return var0_18.guardian_gain[2]
	elseif var0_18.type == ActivityItemPool.guardian_type_lock then
		local var1_18 = var0_18.guardian_gain
		local var2_18 = 0

		for iter0_18, iter1_18 in ipairs(var1_18) do
			var2_18 = math.max(var2_18, arg0_18:getCharLotteryCount(iter1_18))
		end

		return var2_18
	end

	return -1
end

function var0_0.getGuardianGot(arg0_19, arg1_19)
	local var0_19 = pg.guardian_template[arg1_19]

	if var0_19.guardian_gain_pool ~= arg0_19.id then
		warning("guardian id " .. arg1_19 .. "不属于该池子 " .. arg0_19.id .. " 所属对象")

		return false, 0
	end

	if var0_19.type == ActivityItemPool.guardian_type_lottery then
		return arg0_19:getFetchCount() >= var0_19.guardian_gain[2], math.max(var0_19.guardian_gain[2] - arg0_19:getFetchCount(), 0)
	elseif var0_19.type == ActivityItemPool.guardian_type_lock then
		local var1_19 = var0_19.guardian_gain
		local var2_19 = 0

		for iter0_19, iter1_19 in ipairs(var1_19) do
			if not arg0_19:getGuardianGot(iter1_19) then
				var2_19 = var2_19 + 1
			end
		end

		return var2_19 == 0, var2_19
	end

	return false, 0
end

function var0_0.GetAllGuardianIds(arg0_20)
	local var0_20 = pg.activity_template[arg0_20]

	if not var0_20 then
		return {}
	end

	if var0_20.type ~= ActivityConst.ACTIVITY_TYPE_LOTTERY then
		return {}
	end

	local var1_20 = {}
	local var2_20 = pg.activity_template[arg0_20].config_data

	for iter0_20, iter1_20 in ipairs(pg.guardian_template.all) do
		local var3_20 = pg.guardian_template[iter1_20]

		if table.contains(var2_20, var3_20.guardian_gain_pool) then
			local var4_20 = var3_20.id

			table.insert(var1_20, var4_20)
		end
	end

	return var1_20
end

function var0_0.GetAllGuardianIdsStatus(arg0_21)
	local var0_21 = pg.activity_template[arg0_21]
	local var1_21 = getProxy(ActivityProxy):getActivityById(arg0_21)

	if not var0_21 then
		return {}
	end

	if var0_21.type ~= ActivityConst.ACTIVITY_TYPE_LOTTERY then
		return {}
	end

	if not var1_21 then
		return
	end

	local var2_21 = {}
	local var3_21 = {}
	local var4_21 = {}
	local var5_21 = pg.activity_template[arg0_21].config_data

	for iter0_21, iter1_21 in ipairs(var5_21) do
		local var6_21 = var1_21:getAwardInfos()[iter1_21]

		var4_21[iter1_21] = ActivityItemPool.CreateItemPool(iter1_21, var6_21, nil, iter0_21)
	end

	for iter2_21, iter3_21 in ipairs(pg.guardian_template.all) do
		local var7_21 = pg.guardian_template[iter3_21]

		if table.contains(var5_21, var7_21.guardian_gain_pool) then
			local var8_21 = var7_21.id
			local var9_21 = var4_21[var7_21.guardian_gain_pool]

			if var9_21 then
				local var10_21, var11_21 = var9_21:getGuardianGot(var8_21)

				if var10_21 then
					table.insert(var2_21, var8_21)
				else
					table.insert(var3_21, {
						var8_21,
						var11_21
					})
				end
			end
		end
	end

	return var2_21, var3_21
end

function var0_0.GetGuardianLastCount(arg0_22, arg1_22)
	local var0_22 = pg.activity_template[arg0_22]
	local var1_22 = getProxy(ActivityProxy):getActivityById(arg0_22)

	if not var0_22 then
		return {}
	end

	if var0_22.type ~= ActivityConst.ACTIVITY_TYPE_LOTTERY then
		return {}
	end

	if not var1_22 then
		return
	end

	local var2_22 = pg.guardian_template[arg1_22].guardian_gain_pool
	local var3_22 = var1_22:getAwardInfos()[var2_22]

	return ActivityItemPool.CreateItemPool(var2_22, var3_22, nil, 1):getGuardianGot(arg1_22)
end

function var0_0.CreateItemPool(arg0_23, arg1_23, arg2_23, arg3_23)
	return (ActivityItemPool.New({
		id = arg0_23,
		awards = arg1_23,
		index = arg3_23
	}))
end

function var0_0.GetTempleRedTip(arg0_24, arg1_24)
	local var0_24 = pg.activity_template[arg0_24]

	if not var0_24 then
		return false
	end

	local var1_24 = getProxy(ActivityProxy):getActivityById(arg0_24)

	if not var1_24 then
		return false
	end

	arg1_24 = arg1_24 or 60

	local var2_24 = getProxy(PlayerProxy):getData()
	local var3_24 = pg.activity_template[arg0_24].config_data
	local var4_24 = 0
	local var5_24 = 0

	for iter0_24, iter1_24 in ipairs(var3_24) do
		local var6_24 = pg.activity_random_award_template[iter1_24]
		local var7_24 = var6_24.resource_num
		local var8_24 = var2_24:getResById(var6_24.resource_type)

		var4_24 = math.max(var4_24, math.floor(var8_24 / var7_24))

		local var9_24 = var1_24:getAwardInfos()[iter1_24]

		var5_24 = var5_24 + ActivityItemPool.CreateItemPool(iter1_24, var9_24, nil, 1):getleftItemCount()
	end

	if var5_24 <= 0 then
		return false
	end

	if arg1_24 <= var4_24 then
		return true
	end

	local var10_24 = var0_24.config_client.red_tip_time

	if var10_24 then
		local var11_24 = os.time({
			year = var10_24[1],
			month = var10_24[2],
			day = var10_24[3],
			hour = var10_24[4],
			min = var10_24[5],
			sec = var10_24[6]
		})

		return pg.TimeMgr.GetInstance():GetServerTime() - var11_24 > 0 and var4_24 > 1
	end

	return false
end

return var0_0
