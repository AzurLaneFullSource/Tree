local var0 = class("ActivityShopWithProgressRewardCommand", pm.SimpleCommand)

var0.SHOW_SHOP_REWARD = "ActivityShopWithProgressRewardCommand Show shop reward"

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(ActivityProxy):getActivityById(var0.activity_id)
	local var2 = var1:getConfig("type")

	assert(var2 == ActivityConst.ACTIVITY_TYPE_SHOP_PROGRESS_REWARD, "Operation Cant Fit ActivityType " .. var2)

	if var2 == ActivityConst.ACTIVITY_TYPE_SHOP_PROGRESS_REWARD then
		if var0.cmd == 1 then
			local var3 = getProxy(PlayerProxy):getData()
			local var4 = pg.activity_shop_template[var0.arg1]
			local var5 = var0.arg2 or 1

			if var3[id2res(var4.resource_type)] < var4.resource_num * var5 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

				return
			end

			if var4.commodity_type == 1 then
				if var4.commodity_id == 1 and var3:GoldMax(var4.num * var5) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

					return
				end

				if var4.commodity_id == 2 and var3:OilMax(var4.num * var5) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

					return
				end
			end
		elseif var0.cmd == 2 and table.contains(var1.data3_list, var0.arg1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0.activity_id,
		cmd = var0.cmd,
		arg1 = var0.arg1,
		arg2 = var0.arg2,
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			local var0 = arg0:getAwards(var0, arg0)
			local var1 = getProxy(ActivityProxy):getActivityById(var0.activity_id)
			local var2 = arg0:updateActivityData(var0, arg0, var1, var0)

			arg0:performance(var0, arg0, var2, var0)
		else
			print("activity op ret code: " .. arg0.result)

			if arg0.result == 3 or arg0.result == 4 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("activity_op_error", arg0.result))
			end

			arg0:sendNotification(ActivityProxy.ACTIVITY_OPERATION_ERRO, {
				actId = var0.activity_id,
				code = arg0.result
			})
		end
	end)
end

function var0.getAwards(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in ipairs(arg2.award_list) do
		local var1 = {
			type = iter1.type,
			id = iter1.id,
			count = iter1.number
		}

		table.insert(var0, var1)
	end

	local var2 = PlayerConst.addTranDrop(var0)

	for iter2, iter3 in ipairs(var0) do
		if iter3.type == DROP_TYPE_SHIP then
			local var3 = pg.ship_data_template[iter3.id]

			if not getProxy(CollectionProxy):getShipGroup(var3.group_type) and Ship.inUnlockTip(iter3.id) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("collection_award_ship", var3.name))
			end
		end
	end

	if arg1.isAwardMerge then
		local var4 = {}
		local var5

		for iter4, iter5 in ipairs(var2) do
			if (function()
				for iter0, iter1 in ipairs(var4) do
					if iter5.id == iter1.id then
						var4[iter0].count = var4[iter0].count + iter5.count

						return false
					end
				end

				return true
			end)() then
				table.insert(var4, iter5)
			end
		end

		var2 = var4
	end

	return var2
end

function var0.updateActivityData(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg3:getConfig("type")
	local var1 = getProxy(PlayerProxy)
	local var2 = getProxy(TaskProxy)

	if var0 == ActivityConst.ACTIVITY_TYPE_SHOP_PROGRESS_REWARD then
		if arg1.cmd == 1 then
			if table.contains(arg3.data1_list, arg1.arg1) then
				for iter0, iter1 in ipairs(arg3.data1_list) do
					if iter1 == arg1.arg1 then
						arg3.data2_list[iter0] = arg3.data2_list[iter0] + arg1.arg2

						break
					end
				end
			else
				table.insert(arg3.data1_list, arg1.arg1)
				table.insert(arg3.data2_list, arg1.arg2)
			end

			local var3 = pg.activity_shop_template[arg1.arg1]
			local var4 = var3.resource_num * arg1.arg2
			local var5 = var1:getData()

			var5:consume({
				[id2res(var3.resource_type)] = var4
			})
			var1:updatePlayer(var5)
		elseif arg1.cmd == 2 then
			table.insert(arg3.data3_list, arg1.arg1)
		end
	end

	return arg3
end

function var0.performance(arg0, arg1, arg2, arg3, arg4)
	arg0:sendNotification(var0.SHOW_SHOP_REWARD, {
		activityId = arg1.activity_id,
		shopType = arg1.cmd,
		awards = arg4,
		callback = function()
			getProxy(ActivityProxy):updateActivity(arg3)
		end
	})
end

return var0
