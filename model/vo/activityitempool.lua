local var0 = class("ActivityItemPool", import(".BaseVO"))
local var1 = pg.activity_random_award_item

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.awards = arg1.awards or {}
	arg0.prevId = arg1.prevId
	arg0.index = arg1.index
end

function var0.bindConfigTable(arg0)
	return pg.activity_random_award_template
end

function var0.getComsume(arg0)
	local var0 = arg0:getConfig("resource_category")
	local var1 = arg0:getConfig("resource_type")
	local var2 = arg0:getConfig("resource_num")

	return {
		type = var0,
		id = var1,
		count = var2
	}
end

function var0.enoughResForUsage(arg0, arg1)
	local var0 = arg0:getComsume()

	if var0.type == DROP_TYPE_RESOURCE then
		if getProxy(PlayerProxy):getData():getResById(var0.id) < var0.count * arg1 then
			return false
		end
	elseif var0.type == DROP_TYPE_ITEM and getProxy(BagProxy):getItemCountById(var0.id) < var0.count * arg1 then
		return false
	end

	return true
end

function var0.getItemCount(arg0)
	local var0 = arg0:getConfig("item_list")

	return _.reduce(var0, 0, function(arg0, arg1)
		return arg0 + arg1[2]
	end)
end

function var0.getleftItemCount(arg0)
	return arg0:getItemCount() - arg0:getFetchCount()
end

function var0.getFetchCount(arg0)
	return _.reduce(_.values(arg0.awards), 0, function(arg0, arg1)
		return arg0 + arg1
	end)
end

function var0.getMainItems(arg0)
	return arg0:filterItems(true)
end

function var0.filterItems(arg0, arg1)
	local var0 = arg0:getConfig("main_item")
	local var1 = _.select(arg0:getConfig("item_list"), function(arg0)
		if arg1 then
			return table.contains(var0, arg0[1])
		else
			return not table.contains(var0, arg0[1])
		end
	end)

	return (_.map(var1, function(arg0)
		local var0 = var1[arg0[1]]
		local var1 = arg0.awards[arg0[1]] or 0

		return {
			id = var0.commodity_id,
			type = var0.resource_category,
			count = var0.num,
			surplus = arg0[2] - var1,
			total = arg0[2]
		}
	end))
end

function var0.getItems(arg0)
	local var0 = arg0:filterItems(true)
	local var1 = arg0:filterItems(false)

	return var0, var1
end

function var0.canOpenNext(arg0)
	return _.all(arg0:getMainItems(), function(arg0)
		return arg0.surplus == 0
	end)
end

function var0.getTempleNewChar(arg0, arg1)
	if not arg0.charAwardDisplayData then
		arg0.charAwardDisplayData = {}

		for iter0, iter1 in ipairs(pg.guardian_template.all) do
			if pg.guardian_template[iter1].guardian_gain_pool == arg0.configId then
				local var0 = arg0:getCharLotteryCount(iter1)

				table.insert(arg0.charAwardDisplayData, {
					iter1,
					var0
				})
			end
		end
	end

	local var1 = {}
	local var2 = arg0:getFetchCount()

	for iter2 = arg1 + 1, var2 do
		for iter3, iter4 in ipairs(arg0.charAwardDisplayData) do
			if iter4[2] == iter2 then
				table.insert(var1, iter4[1])
			end
		end
	end

	return var1
end

var0.guardian_type_lottery = 1
var0.guardian_type_lock = 2

function var0.getCharLotteryCount(arg0, arg1)
	local var0 = pg.guardian_template[arg1]

	if var0.type == ActivityItemPool.guardian_type_lottery then
		return var0.guardian_gain[2]
	elseif var0.type == ActivityItemPool.guardian_type_lock then
		local var1 = var0.guardian_gain
		local var2 = 0

		for iter0, iter1 in ipairs(var1) do
			var2 = math.max(var2, arg0:getCharLotteryCount(iter1))
		end

		return var2
	end

	return -1
end

function var0.getGuardianGot(arg0, arg1)
	local var0 = pg.guardian_template[arg1]

	if var0.guardian_gain_pool ~= arg0.id then
		warning("guardian id " .. arg1 .. "不属于该池子 " .. arg0.id .. " 所属对象")

		return false, 0
	end

	if var0.type == ActivityItemPool.guardian_type_lottery then
		return arg0:getFetchCount() >= var0.guardian_gain[2], math.max(var0.guardian_gain[2] - arg0:getFetchCount(), 0)
	elseif var0.type == ActivityItemPool.guardian_type_lock then
		local var1 = var0.guardian_gain
		local var2 = 0

		for iter0, iter1 in ipairs(var1) do
			if not arg0:getGuardianGot(iter1) then
				var2 = var2 + 1
			end
		end

		return var2 == 0, var2
	end

	return false, 0
end

function var0.GetAllGuardianIds(arg0)
	local var0 = pg.activity_template[arg0]

	if not var0 then
		return {}
	end

	if var0.type ~= ActivityConst.ACTIVITY_TYPE_LOTTERY then
		return {}
	end

	local var1 = {}
	local var2 = pg.activity_template[arg0].config_data

	for iter0, iter1 in ipairs(pg.guardian_template.all) do
		local var3 = pg.guardian_template[iter1]

		if table.contains(var2, var3.guardian_gain_pool) then
			local var4 = var3.id

			table.insert(var1, var4)
		end
	end

	return var1
end

function var0.GetAllGuardianIdsStatus(arg0)
	local var0 = pg.activity_template[arg0]
	local var1 = getProxy(ActivityProxy):getActivityById(arg0)

	if not var0 then
		return {}
	end

	if var0.type ~= ActivityConst.ACTIVITY_TYPE_LOTTERY then
		return {}
	end

	if not var1 then
		return
	end

	local var2 = {}
	local var3 = {}
	local var4 = {}
	local var5 = pg.activity_template[arg0].config_data

	for iter0, iter1 in ipairs(var5) do
		local var6 = var1:getAwardInfos()[iter1]

		var4[iter1] = ActivityItemPool.CreateItemPool(iter1, var6, nil, iter0)
	end

	for iter2, iter3 in ipairs(pg.guardian_template.all) do
		local var7 = pg.guardian_template[iter3]

		if table.contains(var5, var7.guardian_gain_pool) then
			local var8 = var7.id
			local var9 = var4[var7.guardian_gain_pool]

			if var9 then
				local var10, var11 = var9:getGuardianGot(var8)

				if var10 then
					table.insert(var2, var8)
				else
					table.insert(var3, {
						var8,
						var11
					})
				end
			end
		end
	end

	return var2, var3
end

function var0.GetGuardianLastCount(arg0, arg1)
	local var0 = pg.activity_template[arg0]
	local var1 = getProxy(ActivityProxy):getActivityById(arg0)

	if not var0 then
		return {}
	end

	if var0.type ~= ActivityConst.ACTIVITY_TYPE_LOTTERY then
		return {}
	end

	if not var1 then
		return
	end

	local var2 = pg.guardian_template[arg1].guardian_gain_pool
	local var3 = var1:getAwardInfos()[var2]

	return ActivityItemPool.CreateItemPool(var2, var3, nil, 1):getGuardianGot(arg1)
end

function var0.CreateItemPool(arg0, arg1, arg2, arg3)
	return (ActivityItemPool.New({
		id = arg0,
		awards = arg1,
		index = arg3
	}))
end

function var0.GetTempleRedTip(arg0, arg1)
	local var0 = pg.activity_template[arg0]

	if not var0 then
		return false
	end

	local var1 = getProxy(ActivityProxy):getActivityById(arg0)

	if not var1 then
		return false
	end

	arg1 = arg1 or 60

	local var2 = getProxy(PlayerProxy):getData()
	local var3 = pg.activity_template[arg0].config_data
	local var4 = 0
	local var5 = 0

	for iter0, iter1 in ipairs(var3) do
		local var6 = pg.activity_random_award_template[iter1]
		local var7 = var6.resource_num
		local var8 = var2:getResById(var6.resource_type)

		var4 = math.max(var4, math.floor(var8 / var7))

		local var9 = var1:getAwardInfos()[iter1]

		var5 = var5 + ActivityItemPool.CreateItemPool(iter1, var9, nil, 1):getleftItemCount()
	end

	if var5 <= 0 then
		return false
	end

	if arg1 <= var4 then
		return true
	end

	local var10 = var0.config_client.red_tip_time

	if var10 then
		local var11 = os.time({
			year = var10[1],
			month = var10[2],
			day = var10[3],
			hour = var10[4],
			min = var10[5],
			sec = var10[6]
		})

		return pg.TimeMgr.GetInstance():GetServerTime() - var11 > 0 and var4 > 1
	end

	return false
end

return var0
