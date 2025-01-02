local var0_0 = class("ActivityOperationCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(ActivityProxy):getActivityById(var0_1.activity_id)

	assert(var1_1)

	local var2_1 = var1_1:getConfig("type")

	if var2_1 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 or var2_1 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_PRAY or var2_1 == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD then
		local var3_1, var4_1, var5_1 = BuildShip.canBuildShipByBuildId(var0_1.buildId, var0_1.arg1, var0_1.arg2 == 1)

		if not var3_1 then
			if var5_1 then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_1"), ChargeScene.TYPE_ITEM, var5_1)
			else
				pg.TipsMgr.GetInstance():ShowTips(var4_1)
			end

			return
		end
	elseif var2_1 == ActivityConst.ACTIVITY_TYPE_SHOP then
		local var6_1 = getProxy(PlayerProxy):getData()
		local var7_1 = getProxy(ShopsProxy):getActivityShopById(var1_1.id):bindConfigTable()[var0_1.arg1]
		local var8_1 = var0_1.arg2 or 1

		if var6_1[id2res(var7_1.resource_type)] < var7_1.resource_num * var8_1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

			return
		end

		if var7_1.commodity_type == 1 then
			if var7_1.commodity_id == 1 and var6_1:GoldMax(var7_1.num * var8_1) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

				return
			end

			if var7_1.commodity_id == 2 and var6_1:OilMax(var7_1.num * var8_1) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

				return
			end
		end
	elseif var2_1 == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 and var0_1.cmd == 2 and not var1_1:CanRequest() then
		return
	end

	print(var0_1.activity_id, var0_1.cmd, var0_1.arg1, var0_1.arg2)
	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0_1.activity_id,
		cmd = var0_1.cmd,
		arg1 = var0_1.arg1,
		arg2 = var0_1.arg2,
		arg_list = var0_1.arg_list or {},
		kvargs1 = var0_1.kvargs1
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.GetTranAwards(var0_1, arg0_2)
			local var1_2 = arg0_1:updateActivityData(var0_1, arg0_2, var1_1, var0_2)

			getProxy(ActivityTaskProxy):checkAutoSubmit()
			arg0_1:performance(var0_1, arg0_2, var1_2, var0_2)
		else
			originalPrint("activity op ret code: " .. arg0_2.result)
			print("activity op ret code: " .. arg0_2.result, var0_1.cmd, var0_1.arg1)

			if var2_1 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN or var2_1 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN or var2_1 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN or var2_1 == ActivityConst.ACTIVITY_TYPE_REFLUX then
				var1_1.autoActionForbidden = true

				getProxy(ActivityProxy):updateActivity(var1_1)
			elseif var2_1 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 or var2_1 == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD then
				if arg0_2.result == 1 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("activity_build_end_tip"))
				end
			elseif var2_1 == 17 then
				pg.TipsMgr.GetInstance():ShowTips("错误!:" .. arg0_2.result)
			elseif var2_1 == ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP then
				-- block empty
			elseif arg0_2.result == 3 or arg0_2.result == 4 then
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

function var0_0.updateActivityData(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	local var0_3 = arg3_3:getConfig("type")
	local var1_3 = getProxy(PlayerProxy)
	local var2_3 = getProxy(TaskProxy)

	if var0_3 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
		arg3_3.data1 = arg3_3.data1 + 1
		arg3_3.data2 = pg.TimeMgr.GetInstance():GetServerTime()
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
		if arg1_3.cmd == 1 then
			arg3_3.data1 = arg3_3.data1 + 1
			arg3_3.data2 = pg.TimeMgr.GetInstance():GetServerTime()
		elseif arg1_3.cmd == 2 then
			arg3_3.achieved = true
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_LEVELAWARD then
		table.insert(arg3_3.data1_list, arg1_3.arg1)
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_STORY_AWARD then
		table.insert(arg3_3.data1_list, arg1_3.arg1)
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_LEVELPLAN then
		if arg1_3.cmd == 1 then
			arg3_3.data1 = true
		elseif arg1_3.cmd == 2 then
			table.insert(arg3_3.data1_list, arg1_3.arg1)
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
		local var3_3 = pg.TimeMgr.GetInstance():GetServerTime()
		local var4_3 = pg.TimeMgr.GetInstance():STimeDescS(var3_3, "*t")
		local var5_3

		if arg3_3:getSpecialData("reMonthSignDay") ~= nil then
			var5_3 = arg3_3:getSpecialData("reMonthSignDay")
			arg3_3.data3 = arg3_3.data3 and arg3_3.data3 + 1 or 1
		else
			var5_3 = var4_3.day
		end

		getProxy(ActivityProxy):updateActivity(arg3_3)
		table.insert(arg3_3.data1_list, var5_3)
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_CHARGEAWARD then
		arg3_3.data2 = 1
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 or var0_3 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_PRAY or var0_3 == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_SHIP, arg1_3.arg1)

		local var6_3 = pg.ship_data_create_material[arg1_3.buildId]

		if arg1_3.arg2 == 1 then
			local var7_3 = getProxy(ActivityProxy)
			local var8_3 = var7_3:getBuildFreeActivityByBuildId(arg1_3.buildId)

			var8_3.data1 = var8_3.data1 - arg1_3.arg1

			var7_3:updateActivity(var8_3)
		else
			getProxy(BagProxy):removeItemById(var6_3.use_item, var6_3.number_1 * arg1_3.arg1)

			local var9_3 = var1_3:getData()

			var9_3:consume({
				gold = var6_3.use_gold * arg1_3.arg1
			})
			var1_3:updatePlayer(var9_3)
		end

		local var10_3 = getProxy(BuildShipProxy)

		if var6_3.exchange_count > 0 then
			var10_3:changeRegularExchangeCount(arg1_3.arg1 * var6_3.exchange_count)
		end

		for iter0_3, iter1_3 in ipairs(arg2_3.build) do
			local var11_3 = BuildShip.New(iter1_3)

			var10_3:addBuildShip(var11_3)
		end

		arg3_3.data1 = arg3_3.data1 + arg1_3.arg1

		arg0_3:sendNotification(GAME.BUILD_SHIP_DONE)
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_SHOP then
		local var12_3 = getProxy(ShopsProxy)
		local var13_3 = var12_3:getActivityShopById(arg3_3.id)

		var12_3:UpdateActivityGoods(arg3_3.id, arg1_3.arg1, arg1_3.arg2)

		if table.contains(arg3_3.data1_list, arg1_3.arg1) then
			for iter2_3, iter3_3 in ipairs(arg3_3.data1_list) do
				if iter3_3 == arg1_3.arg1 then
					arg3_3.data2_list[iter2_3] = arg3_3.data2_list[iter2_3] + arg1_3.arg2

					break
				end
			end
		else
			table.insert(arg3_3.data1_list, arg1_3.arg1)
			table.insert(arg3_3.data2_list, arg1_3.arg2)
		end

		local var14_3 = var13_3:bindConfigTable()[arg1_3.arg1]
		local var15_3 = var14_3.resource_num * arg1_3.arg2
		local var16_3 = var1_3:getData()

		var16_3:consume({
			[id2res(var14_3.resource_type)] = var15_3
		})
		var1_3:updatePlayer(var16_3)
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_ZPROJECT then
		-- block empty
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_TASK_LIST then
		if arg1_3.cmd == 1 then
			local var17_3, var18_3 = getActivityTask(arg3_3)

			if var18_3 and not var18_3:isReceive() then
				local var19_3 = arg3_3:getConfig("config_data")

				for iter4_3, iter5_3 in ipairs(var19_3) do
					local var20_3 = _.flatten({
						iter5_3
					})

					if table.contains(var20_3, var17_3) then
						arg3_3.data3 = iter4_3

						break
					end
				end
			end
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_TASK_RES then
		if arg1_3.cmd == 1 then
			local var21_3, var22_3 = getActivityTask(arg3_3)

			if var22_3 and not var22_3:isReceive() then
				local var23_3 = arg3_3:getConfig("config_data")

				for iter6_3, iter7_3 in ipairs(var23_3) do
					local var24_3 = _.flatten({
						iter7_3
					})

					if table.contains(var24_3, var21_3) then
						arg3_3.data3 = iter6_3

						break
					end
				end
			end
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_PUZZLA then
		if arg1_3.cmd == PuzzleActivity.CMD_COMPLETE then
			arg3_3.data1 = 1
		elseif arg1_3.cmd == PuzzleActivity.CMD_EARN_EXTRA then
			arg3_3.data1 = 2
		end

		getProxy(ActivityProxy):updateActivity(arg3_3)
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_BB then
		arg3_3.data1 = arg3_3.data1 + 1
		arg3_3.data2 = arg3_3.data2 - 1
		arg3_3.data1_list = arg2_3.number
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_LOTTERY then
		if arg1_3.cmd == 1 then
			local var25_3 = ActivityItemPool.New({
				id = arg1_3.arg2
			})
			local var26_3 = var25_3:getComsume()
			local var27_3 = arg1_3.arg1 * var26_3.count

			if var26_3.type == DROP_TYPE_RESOURCE then
				local var28_3 = var1_3:getData()

				var28_3:consume({
					[id2res(var26_3.id)] = var27_3
				})
				var1_3:updatePlayer(var28_3)
			elseif var26_3.type == DROP_TYPE_ITEM then
				getProxy(BagProxy):removeItemById(var26_3.id, var27_3)
			end

			arg3_3:updateData(var25_3.id, arg2_3.number)
		elseif arg1_3.cmd == 2 then
			arg3_3.data1 = arg1_3.arg1
		elseif arg1_3.cmd == 3 then
			arg3_3.data2_list = _.map(arg1_3.arg_list, function(arg0_4)
				return arg0_4
			end)
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_CARD_PAIRS or var0_3 == ActivityConst.ACTIVITY_TYPE_LINK_LINK then
		if arg1_3.cmd == 1 then
			local var29_3 = arg3_3:getConfig("config_data")[4]

			if #arg4_3 > 0 then
				arg3_3.data2 = arg3_3.data2 + 1

				if var29_3 <= arg3_3.data2 then
					arg3_3.data1 = 1
				end
			end

			if arg3_3.data4 == 0 then
				arg3_3.data4 = arg1_3.arg2
			elseif arg1_3.arg2 < arg3_3.data4 then
				arg3_3.data4 = arg1_3.arg2
			end
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_REFLUX then
		if arg1_3.cmd == 1 then
			arg3_3.data1_list[1] = pg.TimeMgr.GetInstance():GetServerTime()
			arg3_3.data1_list[2] = arg3_3.data1_list[2] + 1
		elseif arg1_3.cmd == 2 then
			arg3_3.data4 = arg1_3.arg1
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD then
		if arg1_3.cmd == 1 then
			arg3_3.data1 = arg3_3.data1 + 1
			arg3_3.data2 = arg2_3.number[1]
		elseif arg1_3.cmd == 2 then
			table.insert(arg3_3.data1_list, arg3_3.data1)
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_DODGEM then
		if arg1_3.cmd == 1 then
			arg0_3:sendNotification(GAME.FINISH_STAGE_DONE, {
				statistics = arg1_3.statistics,
				score = arg1_3.statistics._battleScore,
				system = SYSTEM_DODGEM
			})

			arg3_3.data1_list[1] = math.max(arg3_3.data1_list[1], arg1_3.arg2)
			arg3_3.data2_list[1] = arg2_3.number[1]
			arg3_3.data2_list[2] = arg2_3.number[2]
		elseif arg1_3.cmd == 2 then
			arg3_3.data2 = arg2_3.number[1]
			arg3_3.data3 = arg2_3.number[2]
			arg3_3.data2_list[1] = 0
			arg3_3.data2_list[2] = 0
		elseif arg1_3.cmd == 3 then
			arg3_3.data4 = defaultValue(arg3_3.data4, 0) + 1
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_SUBMARINE_RUN then
		if arg1_3.cmd == 1 then
			arg0_3:sendNotification(GAME.FINISH_STAGE_DONE, {
				statistics = arg1_3.statistics,
				score = arg1_3.statistics._battleScore,
				system = SYSTEM_SUBMARINE_RUN
			})

			arg3_3.data1_list[1] = math.max(arg3_3.data1_list[1], arg1_3.arg2)
			arg3_3.data2_list[1] = arg2_3.number[1]
			arg3_3.data2_list[2] = arg2_3.number[2]
		elseif arg1_3.cmd == 2 then
			arg3_3.data2 = arg2_3.number[1]
			arg3_3.data3 = arg2_3.number[2]
			arg3_3.data2_list[1] = 0
			arg3_3.data2_list[2] = 0
		elseif arg1_3.cmd == 3 then
			arg3_3.data4 = defaultValue(arg3_3.data4, 0) + 1
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_TURNTABLE then
		if arg1_3.cmd == 2 then
			arg3_3.data4 = 0
		elseif arg1_3.cmd == 1 then
			local var30_3 = arg3_3:getConfig("config_id")
			local var31_3 = pg.activity_event_turning[var30_3].total_num

			if arg3_3.data3 == var31_3 then
				arg3_3.data2 = 1
				arg3_3.data3 = arg3_3.data3 + 1
			else
				arg3_3.data3 = arg3_3.data3 + 1
				arg3_3.data4 = arg2_3.number[1]
				arg3_3.data1_list[arg1_3.arg1] = arg3_3.data4
			end
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_SHRINE then
		arg3_3.data1 = 1
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_RED_PACKETS then
		arg3_3.data1 = arg3_3.data1 - 1

		if arg3_3.data2 > 0 then
			arg3_3.data2 = arg3_3.data2 - 1
		end

		arg3_3.data1_list[2] = arg3_3.data1_list[2] + 1

		local var32_3 = getProxy(ActivityProxy)
		local var33_3 = var32_3:getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

		if var33_3 and not var33_3:isEnd() and var33_3.data2_list[1] > var33_3.data2_list[2] then
			var33_3.data2_list[2] = var33_3.data2_list[2] + 1

			var32_3:updateActivity(var33_3)
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_RED_PACKET_LOTTER then
		arg3_3.data1 = arg3_3.data1 + 1

		if not table.contains(arg3_3.data2_list, arg1_3.arg1) then
			table.insert(arg3_3.data2_list, arg1_3.arg1)
		end

		if not table.contains(arg3_3.data1_list, arg2_3.number[1]) then
			table.insert(arg3_3.data1_list, arg2_3.number[1])
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF or var0_3 == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
		if arg1_3.cmd == 1 then
			local var34_3 = pg.activity_event_building[arg1_3.arg1]
			local var35_3 = arg3_3:GetBuildingLevel(arg1_3.arg1)

			arg3_3:SetBuildingLevel(arg1_3.arg1, var35_3 + 1)

			if var35_3 < #var34_3.buff then
				_.each(var34_3.material[var35_3], function(arg0_5)
					local var0_5 = arg0_5[1]
					local var1_5 = arg0_5[2]
					local var2_5 = arg0_5[3]
					local var3_5

					if var0_5 == DROP_TYPE_VITEM then
						local var4_5 = AcessWithinNull(Item.getConfigData(var1_5), "link_id")

						assert(var4_5 == arg3_3.id)

						var3_5 = arg3_3
					elseif var0_5 > DROP_TYPE_USE_ACTIVITY_DROP then
						local var5_5 = AcessWithinNull(pg.activity_drop_type[var0_5], "activity_id")

						var3_5 = getProxy(ActivityProxy):getActivityById(var5_5)
					end

					local var6_5 = var3_5.data1KeyValueList[1][var1_5] or 0
					local var7_5 = math.max(0, var6_5 - var2_5)

					var3_5.data1KeyValueList[1][var1_5] = var7_5

					if var0_5 > DROP_TYPE_USE_ACTIVITY_DROP then
						getProxy(ActivityProxy):updateActivity(var3_5)
					end
				end)
			end
		elseif arg1_3.cmd == 2 and var0_3 == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
			arg3_3:RecordLastRequestTime()
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_EXPEDITION then
		if arg1_3.cmd == 0 then
			return arg3_3
		end

		if arg1_3.cmd == 3 then
			arg0_3:sendNotification(GAME.FINISH_STAGE_DONE, {
				statistics = arg1_3.statistics,
				score = arg1_3.statistics._battleScore,
				system = SYSTEM_REWARD_PERFORM
			})

			return arg3_3
		end

		if arg1_3.cmd == 4 then
			arg3_3.data2_list[1] = arg3_3.data2_list[1] + 1

			return arg3_3
		end

		if arg1_3.cmd == 1 then
			arg3_3.data3 = arg3_3.data3 - 1
		end

		local var36_3 = arg1_3.arg1

		if arg1_3.cmd ~= 2 then
			arg3_3.data2 = var36_3
		end

		local var37_3 = arg2_3.number[1]

		arg3_3.data1_list[var36_3] = var37_3

		print("格子:" .. var36_3 .. " 值:" .. arg2_3.number[1])

		if arg2_3.number[2] and arg3_3.data1 ~= arg2_3.number[2] then
			print("关卡变更" .. arg2_3.number[2])

			arg3_3.data1 = arg3_3.data1 + 1
			arg3_3.data2 = 0

			for iter8_3 = 1, #arg3_3.data1_list do
				arg3_3.data1_list[iter8_3] = 0
			end
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE then
		if arg1_3.cmd == 1 then
			arg0_3:sendNotification(GAME.FINISH_STAGE_DONE, {
				statistics = arg1_3.statistics,
				score = arg1_3.statistics._battleScore,
				system = SYSTEM_AIRFIGHT
			})

			arg3_3.data1KeyValueList[1] = arg3_3.data1KeyValueList[1] or {}
			arg3_3.data1KeyValueList[1][arg1_3.arg1] = (arg3_3.data1KeyValueList[1][arg1_3.arg1] or 0) + 1
		elseif arg1_3.cmd == 2 then
			arg3_3.data1KeyValueList[2] = arg3_3.data1KeyValueList[2] or {}
			arg3_3.data1KeyValueList[2][arg1_3.arg1] = 1
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS then
		if arg1_3.cmd == 1 then
			arg3_3.data1 = arg3_3.data1 - 1

			local var38_3 = arg2_3.number[1]

			arg3_3.data1KeyValueList[1][var38_3] = arg3_3.data1KeyValueList[1][var38_3] + 1
		elseif arg1_3.cmd == 2 then
			arg3_3.data2 = 1
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_PT_OTHER then
		if arg1_3.cmd == 1 then
			arg3_3.data2 = 1
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
		if arg1_3.cmd == SpringActivity.OPERATION_UNLOCK then
			arg3_3:AddSlotCount()
		elseif arg1_3.cmd == SpringActivity.OPERATION_SETSHIP then
			arg3_3:SetShipIds(arg1_3.kvargs1)
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_HOTSPRING_2 then
		if arg1_3.cmd == Spring2Activity.OPERATION_SETSHIP then
			arg3_3:SetShipIds(arg1_3.kvargs1)
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_FIREWORK then
		if arg1_3.cmd == 1 then
			arg3_3.data1 = arg3_3.data1 - 1

			if not table.contains(arg3_3.data1_list, arg1_3.arg1) then
				table.insert(arg3_3.data1_list, arg1_3.arg1)
			end

			local var39_3 = Item.getConfigData(arg1_3.arg1).link_id

			if var39_3 > 0 then
				local var40_3 = getProxy(ActivityProxy)
				local var41_3 = var40_3:getActivityById(var39_3)

				if var41_3 and not var41_3:isEnd() then
					var41_3.data1 = var41_3.data1 + 1

					var40_3:updateActivity(var41_3)
				end
			end

			local var42_3 = getProxy(PlayerProxy)
			local var43_3 = var42_3:getRawData()
			local var44_3 = arg3_3:getConfig("config_data")[2][1]
			local var45_3 = arg3_3:getConfig("config_data")[2][2]

			var43_3:consume({
				[id2res(var44_3)] = var45_3
			})
			var42_3:updatePlayer(var43_3)
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_CARD_PUZZLE then
		if not table.contains(arg3_3.data1_list, arg1_3.arg1) then
			table.insert(arg3_3.data1_list, arg1_3.arg1)
		end
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_ZUMA then
		if arg1_3.cmd == 1 then
			if arg1_3.arg1 == LaunchBallGameConst.round_type_juqing then
				arg3_3.data1 = arg3_3.data1 + 1
			elseif arg1_3.arg1 == 2 then
				if not arg3_3.data1_list then
					arg3_3.data1_list = {}
				end

				table.insert(arg3_3.data1_list, arg1_3.arg2)
			elseif arg1_3.arg1 == 3 then
				arg3_3.data2 = arg1_3.arg2
			end
		elseif arg1_3.cmd == 2 then
			arg3_3.data3 = 1
		end

		getProxy(ActivityProxy):updateActivity(arg3_3)
	elseif var0_3 == ActivityConst.ACTIVITY_TYPE_PUZZLE_CONNECT then
		local var46_3 = getProxy(ActivityProxy)
		local var47_3 = arg3_3.data1_list
		local var48_3 = arg3_3.data2_list
		local var49_3 = arg3_3.data3_list

		if arg1_3.cmd == 1 then
			local var50_3 = pg.activity_tolove_jigsaw[arg1_3.arg1].need[2]
			local var51_3 = pg.player_resource[var50_3].name
			local var52_3 = pg.activity_tolove_jigsaw[arg1_3.arg1].need[3]
			local var53_3 = var1_3:getData()

			var53_3:consume({
				[var51_3] = var52_3
			})
			var1_3:updatePlayer(var53_3)
			table.insert(var47_3, arg1_3.arg1)
		elseif arg1_3.cmd == 2 then
			table.insert(var48_3, arg1_3.arg1)
		elseif arg1_3.cmd == 3 then
			table.insert(var49_3, arg1_3.arg1)
		end

		var46_3:updateActivity(arg3_3)
	end

	return arg3_3
end

function var0_0.performance(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	local var0_6 = arg3_6:getConfig("type")
	local var1_6

	local function var2_6()
		if var1_6 and coroutine.status(var1_6) == "suspended" then
			local var0_7, var1_7 = coroutine.resume(var1_6)

			assert(var0_7, var1_7)
		end
	end

	var1_6 = coroutine.create(function()
		if var0_6 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
			local var0_8 = arg3_6:getConfig("config_client").story

			if var0_8 and var0_8[arg3_6.data1] and var0_8[arg3_6.data1][1] then
				pg.NewStoryMgr.GetInstance():Play(var0_8[arg3_6.data1][1], var2_6)
				coroutine.yield()
			end
		elseif var0_6 == ActivityConst.ACTIVITY_TYPE_BB then
			local var1_8 = pg.gameset.bobing_memory.description[arg3_6.data1]

			if var1_8 and #var1_8 > 0 then
				pg.NewStoryMgr.GetInstance():Play(var1_8, var2_6)
				coroutine.yield()
			end

			arg0_6:sendNotification(ActivityProxy.ACTIVITY_SHOW_BB_RESULT, {
				numbers = arg2_6.number,
				callback = var2_6,
				awards = arg4_6
			})
			coroutine.yield()
		elseif var0_6 == ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD then
			if arg1_6.cmd == 1 then
				local var2_8 = arg3_6:getConfig("config_client").story

				if var2_8 and var2_8[arg3_6.data1] and var2_8[arg3_6.data1][1] then
					pg.NewStoryMgr.GetInstance():Play(var2_8[arg3_6.data1][1], var2_6)
					coroutine.yield()
				end

				arg0_6:sendNotification(ActivityProxy.ACTIVITY_SHOW_LOTTERY_AWARD_RESULT, {
					activityID = arg3_6.id,
					awards = arg4_6,
					number = arg2_6.number[1],
					callback = var2_6
				})

				arg4_6 = {}

				coroutine.yield()
			end
		elseif var0_6 == ActivityConst.ACTIVITY_TYPE_CARD_PAIRS or var0_6 == ActivityConst.ACTIVITY_TYPE_LINK_LINK then
			if arg3_6:getConfig("config_client")[1] then
				local var3_8 = arg3_6:getConfig("config_client")[1][arg3_6.data2 + 1]

				if var3_8 then
					pg.NewStoryMgr.GetInstance():Play(var3_8, var2_6)
					coroutine.yield()
				end
			end
		elseif var0_6 == ActivityConst.ACTIVITY_TYPE_DODGEM or var0_6 == ActivityConst.ACTIVITY_TYPE_SUBMARINE_RUN then
			if arg1_6.cmd == 2 and arg2_6.number[3] > 0 then
				local var4_8 = arg3_6:getConfig("config_client")[1]
				local var5_8 = {
					type = var4_8[1],
					id = var4_8[2],
					count = var4_8[3]
				}

				table.insert(arg4_6, var5_8)
			end
		elseif var0_6 == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF or var0_6 == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
			if arg1_6.cmd == 1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("building_complete_tip"))
			end
		elseif var0_6 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
			if arg1_6.cmd == 3 then
				local var6_8 = arg3_6:getSpecialData("month_sign_awards") or {}

				for iter0_8 = 1, #arg4_6 do
					table.insert(var6_8, arg4_6[iter0_8])
				end

				arg3_6:setSpecialData("month_sign_awards", var6_8)

				arg4_6 = {}
			end
		elseif var0_6 == ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS then
			if arg1_6.cmd == 1 then
				arg0_6:sendNotification(ActivityProxy.ACTIVITY_SHOW_SHAKE_BEADS_RESULT, {
					number = arg2_6.number[1],
					callback = var2_6,
					awards = arg4_6
				})
				coroutine.yield()
			end
		elseif var0_6 == ActivityConst.ACTIVITY_TYPE_APRIL_REWARD then
			if arg1_6.cmd == 1 then
				arg3_6.data1 = arg1_6.arg1
			elseif arg1_6.cmd == 2 then
				arg3_6.data2 = 1
			end
		elseif var0_6 == ActivityConst.ACTIVITY_TYPE_FIREWORK then
			pg.TipsMgr.GetInstance():ShowTips(i18n("activity_yanhua_tip8"))

			local var7_8 = #arg3_6:getData1List()
			local var8_8 = arg3_6:getConfig("config_client").story

			if var8_8 and type(var8_8) == "table" then
				for iter1_8, iter2_8 in ipairs(var8_8) do
					if var7_8 == iter2_8[1] then
						pg.NewStoryMgr.GetInstance():Play(iter2_8[2], var2_6)
						coroutine.yield()
					end
				end
			end

			local var9_8 = getProxy(ActivityProxy)

			var9_8:updateActivity(arg3_6)

			local var10_8 = arg3_6:getConfig("config_client").ActID

			if var10_8 then
				local var11_8 = var9_8:getActivityById(var10_8)

				if var11_8 then
					var9_8:updateActivity(var11_8)
				end
			end
		end

		if #arg4_6 > 0 then
			arg0_6:sendNotification(arg3_6:getNotificationMsg(), {
				activityId = arg1_6.activity_id,
				awards = arg4_6,
				callback = var2_6
			})
			coroutine.yield()
		end

		if var0_6 == 17 and arg1_6.cmd and arg1_6.cmd == 2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("mingshi_get_tip"))
		end

		getProxy(ActivityProxy):updateActivity(arg3_6)
		arg0_6:sendNotification(ActivityProxy.ACTIVITY_OPERATION_DONE, arg1_6.activity_id)
	end)

	var2_6()
end

return var0_0
