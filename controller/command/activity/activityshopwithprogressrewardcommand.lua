local var0_0 = class("ActivityShopWithProgressRewardCommand", pm.SimpleCommand)

var0_0.SHOW_SHOP_REWARD = "ActivityShopWithProgressRewardCommand Show shop reward"

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(ActivityProxy):getActivityById(var0_1.activity_id)
	local var2_1 = var1_1:getConfig("type")

	assert(var2_1 == ActivityConst.ACTIVITY_TYPE_SHOP_PROGRESS_REWARD, "Operation Cant Fit ActivityType " .. var2_1)

	if var2_1 == ActivityConst.ACTIVITY_TYPE_SHOP_PROGRESS_REWARD then
		if var0_1.cmd == 1 then
			local var3_1 = getProxy(PlayerProxy):getData()
			local var4_1 = pg.activity_shop_template[var0_1.arg1]
			local var5_1 = var0_1.arg2 or 1

			if var3_1[id2res(var4_1.resource_type)] < var4_1.resource_num * var5_1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

				return
			end

			if var4_1.commodity_type == 1 then
				if var4_1.commodity_id == 1 and var3_1:GoldMax(var4_1.num * var5_1) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

					return
				end

				if var4_1.commodity_id == 2 and var3_1:OilMax(var4_1.num * var5_1) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

					return
				end
			end
		elseif var0_1.cmd == 2 and table.contains(var1_1.data3_list, var0_1.arg1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0_1.activity_id,
		cmd = var0_1.cmd,
		arg1 = var0_1.arg1,
		arg2 = var0_1.arg2,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = arg0_1:getAwards(var0_1, arg0_2)
			local var1_2 = getProxy(ActivityProxy):getActivityById(var0_1.activity_id)
			local var2_2 = arg0_1:updateActivityData(var0_1, arg0_2, var1_2, var0_2)

			arg0_1:performance(var0_1, arg0_2, var2_2, var0_2)
		else
			print("activity op ret code: " .. arg0_2.result)

			if arg0_2.result == 3 or arg0_2.result == 4 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("activity_op_error", arg0_2.result))
			end

			arg0_1:sendNotification(ActivityProxy.ACTIVITY_OPERATION_ERRO, {
				actId = var0_1.activity_id,
				code = arg0_2.result
			})
		end
	end)
end

function var0_0.getAwards(arg0_3, arg1_3, arg2_3)
	local var0_3 = {}

	for iter0_3, iter1_3 in ipairs(arg2_3.award_list) do
		local var1_3 = {
			type = iter1_3.type,
			id = iter1_3.id,
			count = iter1_3.number
		}

		table.insert(var0_3, var1_3)
	end

	local var2_3 = PlayerConst.addTranDrop(var0_3)

	for iter2_3, iter3_3 in ipairs(var0_3) do
		if iter3_3.type == DROP_TYPE_SHIP then
			local var3_3 = pg.ship_data_template[iter3_3.id]

			if not getProxy(CollectionProxy):getShipGroup(var3_3.group_type) and Ship.inUnlockTip(iter3_3.id) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("collection_award_ship", var3_3.name))
			end
		end
	end

	if arg1_3.isAwardMerge then
		local var4_3 = {}
		local var5_3

		for iter4_3, iter5_3 in ipairs(var2_3) do
			if (function()
				for iter0_4, iter1_4 in ipairs(var4_3) do
					if iter5_3.id == iter1_4.id then
						var4_3[iter0_4].count = var4_3[iter0_4].count + iter5_3.count

						return false
					end
				end

				return true
			end)() then
				table.insert(var4_3, iter5_3)
			end
		end

		var2_3 = var4_3
	end

	return var2_3
end

function var0_0.updateActivityData(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	local var0_5 = arg3_5:getConfig("type")
	local var1_5 = getProxy(PlayerProxy)
	local var2_5 = getProxy(TaskProxy)

	if var0_5 == ActivityConst.ACTIVITY_TYPE_SHOP_PROGRESS_REWARD then
		if arg1_5.cmd == 1 then
			if table.contains(arg3_5.data1_list, arg1_5.arg1) then
				for iter0_5, iter1_5 in ipairs(arg3_5.data1_list) do
					if iter1_5 == arg1_5.arg1 then
						arg3_5.data2_list[iter0_5] = arg3_5.data2_list[iter0_5] + arg1_5.arg2

						break
					end
				end
			else
				table.insert(arg3_5.data1_list, arg1_5.arg1)
				table.insert(arg3_5.data2_list, arg1_5.arg2)
			end

			local var3_5 = pg.activity_shop_template[arg1_5.arg1]
			local var4_5 = var3_5.resource_num * arg1_5.arg2
			local var5_5 = var1_5:getData()

			var5_5:consume({
				[id2res(var3_5.resource_type)] = var4_5
			})
			var1_5:updatePlayer(var5_5)
		elseif arg1_5.cmd == 2 then
			table.insert(arg3_5.data3_list, arg1_5.arg1)
		end
	end

	return arg3_5
end

function var0_0.performance(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	arg0_6:sendNotification(var0_0.SHOW_SHOP_REWARD, {
		activityId = arg1_6.activity_id,
		shopType = arg1_6.cmd,
		awards = arg4_6,
		callback = function()
			getProxy(ActivityProxy):updateActivity(arg3_6)
		end
	})
end

return var0_0
