local var0_0 = class("ActivityOperationCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(ActivityProxy):getActivityById(var0_1.activity_id)

	assert(var1_1)

	local var2_1 = var1_1:getConfig("type")

	if switch(var2_1, {
		[ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1] = function()
			local var0_2, var1_2, var2_2 = BuildShip.canBuildShipByBuildId(var0_1.buildId, var0_1.arg1, var0_1.arg2 == 1)

			if not var0_2 then
				if var2_2 then
					GoShoppingMsgBox(i18n("switch_to_shop_tip_1"), ChargeScene.TYPE_ITEM, var2_2)
				else
					pg.TipsMgr.GetInstance():ShowTips(var1_2)
				end

				return true
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDSHIP_PRAY] = ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		[ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD] = ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		[ActivityConst.ACTIVITY_TYPE_SHOP] = function()
			local var0_3 = getProxy(PlayerProxy):getData()
			local var1_3 = getProxy(ShopsProxy):getActivityShopById(var1_1.id):bindConfigTable()[var0_1.arg1]
			local var2_3 = var0_1.arg2 or 1

			if var0_3[id2res(var1_3.resource_type)] < var1_3.resource_num * var2_3 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

				return true
			end

			if var1_3.commodity_type == 1 then
				if var1_3.commodity_id == 1 and var0_3:GoldMax(var1_3.num * var2_3) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

					return true
				end

				if var1_3.commodity_id == 2 and var0_3:OilMax(var1_3.num * var2_3) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

					return true
				end
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2] = function()
			if var0_1.cmd == 2 and not var1_1:CanRequest() then
				return true
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_SKIN_FAKE_PACKAGE] = function()
			local var0_5 = var0_1.costDrop

			if var0_5.count > var0_5:getOwnedCount() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

				return true
			end
		end
	}) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0_1.activity_id,
		cmd = var0_1.cmd,
		arg1 = var0_1.arg1,
		arg2 = var0_1.arg2,
		arg_list = var0_1.arg_list or {},
		kvargs1 = var0_1.kvargs1
	}, 11203, function(arg0_6)
		if arg0_6.result == 0 then
			local var0_6 = PlayerConst.GetTranAwards(var0_1, arg0_6)
			local var1_6 = arg0_1:updateActivityData(var0_1, arg0_6, var1_1, var0_6)

			getProxy(ActivityTaskProxy):checkAutoSubmit()
			arg0_1:performance(var0_1, arg0_6, var1_6, var0_6)
		else
			originalPrint("activity op ret code: " .. arg0_6.result)

			if var2_1 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN or var2_1 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN or var2_1 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN or var2_1 == ActivityConst.ACTIVITY_TYPE_REFLUX then
				var1_1.autoActionForbidden = true

				getProxy(ActivityProxy):updateActivity(var1_1)
			elseif var2_1 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 or var2_1 == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD then
				if arg0_6.result == 1 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("activity_build_end_tip"))
				end
			elseif var2_1 == 17 then
				pg.TipsMgr.GetInstance():ShowTips("错误!:" .. arg0_6.result)
			elseif var2_1 == ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP then
				pg.TipsMgr.GetInstance():ShowTips(errorTip("activity_op_error", arg0_6.result))
			elseif var2_1 == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF then
				if var1_1:getConfig("config_client").resource_ID == BossRushDALUpgradeView.RES_ID then
					pg.TipsMgr.GetInstance():ShowTips(i18n("DAL_upgrade_not_enough"))
				end
			elseif arg0_6.result == 3 or arg0_6.result == 4 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("activity_op_error", arg0_6.result))
			end

			arg0_1:sendNotification(ActivityProxy.ACTIVITY_OPERATION_ERRO, {
				actId = var0_1.activity_id,
				code = arg0_6.result
			})
		end
	end)
end

function var0_0.updateActivityData(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	local var0_7 = arg3_7:getConfig("type")
	local var1_7 = getProxy(PlayerProxy)
	local var2_7 = getProxy(TaskProxy)

	switch(var0_7, {
		[ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN] = function()
			arg3_7.data1 = arg3_7.data1 + 1
			arg3_7.data2 = pg.TimeMgr.GetInstance():GetServerTime()
		end,
		[ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN] = function()
			if arg1_7.cmd == 1 then
				arg3_7.data1 = arg3_7.data1 + 1
				arg3_7.data2 = pg.TimeMgr.GetInstance():GetServerTime()
			elseif arg1_7.cmd == 2 then
				arg3_7.achieved = true
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_LEVELAWARD] = function()
			table.insert(arg3_7.data1_list, arg1_7.arg1)
		end,
		[ActivityConst.ACTIVITY_TYPE_STORY_AWARD] = function()
			table.insert(arg3_7.data1_list, arg1_7.arg1)
		end,
		[ActivityConst.ACTIVITY_TYPE_LEVELPLAN] = function()
			if arg1_7.cmd == 1 then
				arg3_7.data1 = true
			elseif arg1_7.cmd == 2 then
				table.insert(arg3_7.data1_list, arg1_7.arg1)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_MONTHSIGN] = function()
			local var0_13 = pg.TimeMgr.GetInstance():GetServerTime()
			local var1_13 = pg.TimeMgr.GetInstance():STimeDescS(var0_13, "*t")

			if arg3_7:getSpecialData("reMonthSignDay") ~= nil then
				day = arg3_7:getSpecialData("reMonthSignDay")
				arg3_7.data3 = arg3_7.data3 and arg3_7.data3 + 1 or 1
			else
				day = var1_13.day
			end

			arg3_7:setSpecialData(MonthSignPage.MILESTONE_SPECIAL_DATA, nil)
			table.insert(arg3_7.data1_list, day)

			local var2_13 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOGIN_RECORD)

			if var2_13 and not var2_13:isEnd() then
				var2_13.data1 = var2_13.data1 + 1
				var2_13.data2 = var2_13.data2 + 1
				var2_13.data3 = math.max(var2_13.data3, var2_13.data2)

				for iter0_13, iter1_13 in ipairs(MonthSignPage.MONTH_SIGN_SP_DAYS) do
					if iter1_13 == var2_13.data1 then
						arg3_7:setSpecialData(MonthSignPage.MILESTONE_SPECIAL_DATA, iter1_13)
					end
				end

				getProxy(ActivityProxy):updateActivity(var2_13)
			end

			getProxy(ActivityProxy):updateActivity(arg3_7)
		end,
		[ActivityConst.ACTIVITY_TYPE_CHARGEAWARD] = function()
			arg3_7.data2 = 1
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1] = function()
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_SHIP, arg1_7.arg1)

			local var0_15 = pg.ship_data_create_material[arg1_7.buildId]

			if arg1_7.arg2 == 1 then
				local var1_15 = getProxy(ActivityProxy)
				local var2_15 = var1_15:getBuildFreeActivityByBuildId(arg1_7.buildId)

				var2_15.data1 = var2_15.data1 - arg1_7.arg1

				var1_15:updateActivity(var2_15)
			else
				getProxy(BagProxy):removeItemById(var0_15.use_item, var0_15.number_1 * arg1_7.arg1)

				local var3_15 = var1_7:getData()

				var3_15:consume({
					gold = var0_15.use_gold * arg1_7.arg1
				})
				var1_7:updatePlayer(var3_15)
			end

			local var4_15 = getProxy(BuildShipProxy)

			if var0_15.exchange_count > 0 then
				var4_15:changeRegularExchangeCount(arg1_7.arg1 * var0_15.exchange_count)
			end

			for iter0_15, iter1_15 in ipairs(arg2_7.build) do
				local var5_15 = BuildShip.New(iter1_15)

				var4_15:addBuildShip(var5_15)
			end

			arg3_7.data1 = arg3_7.data1 + arg1_7.arg1

			arg0_7:sendNotification(GAME.BUILD_SHIP_DONE)
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDSHIP_PRAY] = ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		[ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD] = ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		[ActivityConst.ACTIVITY_TYPE_SHOP] = function()
			local var0_16 = getProxy(ShopsProxy)
			local var1_16 = var0_16:getActivityShopById(arg3_7.id)

			var0_16:UpdateActivityGoods(arg3_7.id, arg1_7.arg1, arg1_7.arg2)

			if table.contains(arg3_7.data1_list, arg1_7.arg1) then
				for iter0_16, iter1_16 in ipairs(arg3_7.data1_list) do
					if iter1_16 == arg1_7.arg1 then
						arg3_7.data2_list[iter0_16] = arg3_7.data2_list[iter0_16] + arg1_7.arg2

						break
					end
				end
			else
				table.insert(arg3_7.data1_list, arg1_7.arg1)
				table.insert(arg3_7.data2_list, arg1_7.arg2)
			end

			local var2_16 = var1_16:bindConfigTable()[arg1_7.arg1]
			local var3_16 = var2_16.resource_num * arg1_7.arg2
			local var4_16 = var1_7:getData()

			var4_16:consume({
				[id2res(var2_16.resource_type)] = var3_16
			})
			var1_7:updatePlayer(var4_16)
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_LIST] = function()
			if arg1_7.cmd == 1 then
				local var0_17, var1_17 = getActivityTask(arg3_7)

				if var1_17 and not var1_17:isReceive() then
					local var2_17 = arg3_7:getConfig("config_data")

					for iter0_17, iter1_17 in ipairs(var2_17) do
						local var3_17 = _.flatten({
							iter1_17
						})

						if table.contains(var3_17, var0_17) then
							arg3_7.data3 = iter0_17

							break
						end
					end
				end
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_RES] = function()
			if arg1_7.cmd == 1 then
				local var0_18, var1_18 = getActivityTask(arg3_7)

				if var1_18 and not var1_18:isReceive() then
					local var2_18 = arg3_7:getConfig("config_data")

					for iter0_18, iter1_18 in ipairs(var2_18) do
						local var3_18 = _.flatten({
							iter1_18
						})

						if table.contains(var3_18, var0_18) then
							arg3_7.data3 = iter0_18

							break
						end
					end
				end
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_PUZZLA] = function()
			if arg1_7.cmd == PuzzleActivity.CMD_COMPLETE then
				arg3_7.data1 = 1
			elseif arg1_7.cmd == PuzzleActivity.CMD_EARN_EXTRA then
				arg3_7.data1 = 2
			elseif arg1_7.cmd == PuzzleActivity.CMD_ACTIVATE then
				table.insert(arg3_7.data2_list, arg1_7.arg1)
			end

			getProxy(ActivityProxy):updateActivity(arg3_7)
		end,
		[ActivityConst.ACTIVITY_TYPE_BB] = function()
			arg3_7.data1 = arg3_7.data1 + 1
			arg3_7.data2 = arg3_7.data2 - 1
			arg3_7.data1_list = arg2_7.number
		end,
		[ActivityConst.ACTIVITY_TYPE_LOTTERY] = function()
			if arg1_7.cmd == 1 then
				local var0_21 = ActivityItemPool.New({
					id = arg1_7.arg2
				})
				local var1_21 = var0_21:getComsume()
				local var2_21 = arg1_7.arg1 * var1_21.count

				if var1_21.type == DROP_TYPE_RESOURCE then
					local var3_21 = var1_7:getData()

					var3_21:consume({
						[id2res(var1_21.id)] = var2_21
					})
					var1_7:updatePlayer(var3_21)
				elseif var1_21.type == DROP_TYPE_ITEM then
					getProxy(BagProxy):removeItemById(var1_21.id, var2_21)
				end

				arg3_7:updateData(var0_21.id, arg2_7.number)
			elseif arg1_7.cmd == 2 then
				arg3_7.data1 = arg1_7.arg1
			elseif arg1_7.cmd == 3 then
				arg3_7.data2_list = _.map(arg1_7.arg_list, function(arg0_22)
					return arg0_22
				end)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_CARD_PAIRS] = function()
			if arg1_7.cmd == 1 then
				local var0_23 = arg3_7:getConfig("config_data")[4]

				if #arg4_7 > 0 then
					arg3_7.data2 = arg3_7.data2 + 1

					if var0_23 <= arg3_7.data2 then
						arg3_7.data1 = 1
					end
				end

				if arg3_7.data4 == 0 then
					arg3_7.data4 = arg1_7.arg2
				elseif arg1_7.arg2 < arg3_7.data4 then
					arg3_7.data4 = arg1_7.arg2
				end
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_LINK_LINK] = ActivityConst.ACTIVITY_TYPE_CARD_PAIRS,
		[ActivityConst.ACTIVITY_TYPE_REFLUX] = function()
			if arg1_7.cmd == 1 then
				arg3_7.data1_list[1] = pg.TimeMgr.GetInstance():GetServerTime()
				arg3_7.data1_list[2] = arg3_7.data1_list[2] + 1
			elseif arg1_7.cmd == 2 then
				arg3_7.data4 = arg1_7.arg1
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD] = function()
			if arg1_7.cmd == 1 then
				arg3_7.data1 = arg3_7.data1 + 1
				arg3_7.data2 = arg2_7.number[1]
			elseif arg1_7.cmd == 2 then
				table.insert(arg3_7.data1_list, arg3_7.data1)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_DODGEM] = function()
			if arg1_7.cmd == 1 then
				arg0_7:sendNotification(GAME.FINISH_STAGE_DONE, {
					statistics = arg1_7.statistics,
					score = arg1_7.statistics._battleScore,
					system = SYSTEM_DODGEM
				})

				arg3_7.data1_list[1] = math.max(arg3_7.data1_list[1], arg1_7.arg2)
				arg3_7.data2_list[1] = arg2_7.number[1]
				arg3_7.data2_list[2] = arg2_7.number[2]
			elseif arg1_7.cmd == 2 then
				arg3_7.data2 = arg2_7.number[1]
				arg3_7.data3 = arg2_7.number[2]
				arg3_7.data2_list[1] = 0
				arg3_7.data2_list[2] = 0
			elseif arg1_7.cmd == 3 then
				arg3_7.data4 = defaultValue(arg3_7.data4, 0) + 1
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_SUBMARINE_RUN] = function()
			if arg1_7.cmd == 1 then
				arg0_7:sendNotification(GAME.FINISH_STAGE_DONE, {
					statistics = arg1_7.statistics,
					score = arg1_7.statistics._battleScore,
					system = SYSTEM_SUBMARINE_RUN
				})

				arg3_7.data1_list[1] = math.max(arg3_7.data1_list[1], arg1_7.arg2)
				arg3_7.data2_list[1] = arg2_7.number[1]
				arg3_7.data2_list[2] = arg2_7.number[2]
			elseif arg1_7.cmd == 2 then
				arg3_7.data2 = arg2_7.number[1]
				arg3_7.data3 = arg2_7.number[2]
				arg3_7.data2_list[1] = 0
				arg3_7.data2_list[2] = 0
			elseif arg1_7.cmd == 3 then
				arg3_7.data4 = defaultValue(arg3_7.data4, 0) + 1
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_TURNTABLE] = function()
			if arg1_7.cmd == 2 then
				arg3_7.data4 = 0
			elseif arg1_7.cmd == 1 then
				local var0_28 = arg3_7:getConfig("config_id")
				local var1_28 = pg.activity_event_turning[var0_28].total_num

				if arg3_7.data3 == var1_28 then
					arg3_7.data2 = 1
					arg3_7.data3 = arg3_7.data3 + 1
				else
					arg3_7.data3 = arg3_7.data3 + 1
					arg3_7.data4 = arg2_7.number[1]
					arg3_7.data1_list[arg1_7.arg1] = arg3_7.data4
				end
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_SHRINE] = function()
			arg3_7.data1 = 1
		end,
		[ActivityConst.ACTIVITY_TYPE_RED_PACKETS] = function()
			arg3_7.data1 = arg3_7.data1 - 1

			if arg3_7.data2 > 0 then
				arg3_7.data2 = arg3_7.data2 - 1
			end

			arg3_7.data1_list[2] = arg3_7.data1_list[2] + 1

			local var0_30 = getProxy(ActivityProxy)
			local var1_30 = var0_30:getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

			if var1_30 and not var1_30:isEnd() and var1_30.data2_list[1] > var1_30.data2_list[2] then
				var1_30.data2_list[2] = var1_30.data2_list[2] + 1

				var0_30:updateActivity(var1_30)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_RED_PACKET_LOTTER] = function()
			arg3_7.data1 = arg3_7.data1 + 1

			if not table.contains(arg3_7.data2_list, arg1_7.arg1) then
				table.insert(arg3_7.data2_list, arg1_7.arg1)
			end

			if not table.contains(arg3_7.data1_list, arg2_7.number[1]) then
				table.insert(arg3_7.data1_list, arg2_7.number[1])
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF] = function()
			if arg1_7.cmd == 1 then
				local var0_32 = pg.activity_event_building[arg1_7.arg1]
				local var1_32 = arg3_7:GetBuildingLevel(arg1_7.arg1)

				arg3_7:SetBuildingLevel(arg1_7.arg1, var1_32 + 1)

				if var1_32 < #var0_32.buff then
					_.each(var0_32.material[var1_32], function(arg0_33)
						local var0_33 = arg0_33[1]
						local var1_33 = arg0_33[2]
						local var2_33 = arg0_33[3]
						local var3_33

						if var0_33 == DROP_TYPE_VITEM then
							local var4_33 = AcessWithinNull(Item.getConfigData(var1_33), "link_id")

							assert(var4_33 == arg3_7.id)

							var3_33 = arg3_7
						elseif var0_33 > DROP_TYPE_USE_ACTIVITY_DROP then
							local var5_33 = AcessWithinNull(pg.activity_drop_type[var0_33], "activity_id")

							var3_33 = getProxy(ActivityProxy):getActivityById(var5_33)
						end

						local var6_33 = var3_33.data1KeyValueList[1][var1_33] or 0
						local var7_33 = math.max(0, var6_33 - var2_33)

						var3_33.data1KeyValueList[1][var1_33] = var7_33

						if var0_33 > DROP_TYPE_USE_ACTIVITY_DROP then
							getProxy(ActivityProxy):updateActivity(var3_33)
						end
					end)
				end
			elseif arg1_7.cmd == 2 and var0_7 == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
				arg3_7:RecordLastRequestTime()
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2] = ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = function()
			if arg1_7.cmd == 2 then
				table.insert(arg3_7.data2_list, arg1_7.arg1)
				arg0_7:sendNotification(GAME.FINISH_STAGE_DONE, {
					statistics = arg1_7.statistics,
					score = arg1_7.statistics._battleScore,
					system = SYSTEM_REWARD_PERFORM
				})

				return arg3_7
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_EXPEDITION] = function()
			if arg1_7.cmd == 0 then
				return arg3_7
			end

			if arg1_7.cmd == 3 then
				arg0_7:sendNotification(GAME.FINISH_STAGE_DONE, {
					statistics = arg1_7.statistics,
					score = arg1_7.statistics._battleScore,
					system = SYSTEM_REWARD_PERFORM
				})

				return arg3_7
			end

			if arg1_7.cmd == 4 then
				arg3_7.data2_list[1] = arg3_7.data2_list[1] + 1

				return arg3_7
			end

			if arg1_7.cmd == 1 then
				arg3_7.data3 = arg3_7.data3 - 1
			end

			local var0_35 = arg1_7.arg1

			if arg1_7.cmd ~= 2 then
				arg3_7.data2 = var0_35
			end

			local var1_35 = arg2_7.number[1]

			arg3_7.data1_list[var0_35] = var1_35

			print("格子:" .. var0_35 .. " 值:" .. arg2_7.number[1])

			if arg2_7.number[2] and arg3_7.data1 ~= arg2_7.number[2] then
				print("关卡变更" .. arg2_7.number[2])

				arg3_7.data1 = arg3_7.data1 + 1
				arg3_7.data2 = 0

				for iter0_35 = 1, #arg3_7.data1_list do
					arg3_7.data1_list[iter0_35] = 0
				end
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE] = function()
			if arg1_7.cmd == 1 then
				arg0_7:sendNotification(GAME.FINISH_STAGE_DONE, {
					statistics = arg1_7.statistics,
					score = arg1_7.statistics._battleScore,
					system = SYSTEM_AIRFIGHT
				})

				arg3_7.data1KeyValueList[1] = arg3_7.data1KeyValueList[1] or {}
				arg3_7.data1KeyValueList[1][arg1_7.arg1] = (arg3_7.data1KeyValueList[1][arg1_7.arg1] or 0) + 1
			elseif arg1_7.cmd == 2 then
				arg3_7.data1KeyValueList[2] = arg3_7.data1KeyValueList[2] or {}
				arg3_7.data1KeyValueList[2][arg1_7.arg1] = 1
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS] = function()
			if arg1_7.cmd == 1 then
				arg3_7.data1 = arg3_7.data1 - 1

				local var0_37 = arg2_7.number[1]

				arg3_7.data1KeyValueList[1][var0_37] = arg3_7.data1KeyValueList[1][var0_37] + 1
			elseif arg1_7.cmd == 2 then
				arg3_7.data2 = 1
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_PT_OTHER] = function()
			if arg1_7.cmd == 1 then
				arg3_7.data2 = 1
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_HOTSPRING] = function()
			if arg1_7.cmd == SpringActivity.OPERATION_UNLOCK then
				arg3_7:AddSlotCount()
			elseif arg1_7.cmd == SpringActivity.OPERATION_SETSHIP then
				arg3_7:SetShipIds(arg1_7.kvargs1)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_HOTSPRING_2] = function()
			if arg1_7.cmd == Spring2Activity.OPERATION_SETSHIP then
				arg3_7:SetShipIds(arg1_7.kvargs1)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_FIREWORK] = function()
			if arg1_7.cmd == 1 then
				arg3_7.data1 = arg3_7.data1 - 1

				if not table.contains(arg3_7.data1_list, arg1_7.arg1) then
					table.insert(arg3_7.data1_list, arg1_7.arg1)
				end

				local var0_41 = Item.getConfigData(arg1_7.arg1).link_id

				if var0_41 > 0 then
					local var1_41 = getProxy(ActivityProxy)
					local var2_41 = var1_41:getActivityById(var0_41)

					if var2_41 and not var2_41:isEnd() then
						var2_41.data1 = var2_41.data1 + 1

						var1_41:updateActivity(var2_41)
					end
				end

				local var3_41 = getProxy(PlayerProxy)
				local var4_41 = var3_41:getRawData()
				local var5_41 = arg3_7:getConfig("config_data")[2][1]
				local var6_41 = arg3_7:getConfig("config_data")[2][2]

				var4_41:consume({
					[id2res(var5_41)] = var6_41
				})
				var3_41:updatePlayer(var4_41)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_CARD_PUZZLE] = function()
			if not table.contains(arg3_7.data1_list, arg1_7.arg1) then
				table.insert(arg3_7.data1_list, arg1_7.arg1)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_ZUMA] = function()
			if arg1_7.cmd == 1 then
				if arg1_7.arg1 == LaunchBallGameConst.round_type_juqing then
					arg3_7.data1 = arg3_7.data1 + 1
				elseif arg1_7.arg1 == 2 then
					if not arg3_7.data1_list then
						arg3_7.data1_list = {}
					end

					table.insert(arg3_7.data1_list, arg1_7.arg2)
				elseif arg1_7.arg1 == 3 then
					arg3_7.data2 = arg1_7.arg2
				end
			elseif arg1_7.cmd == 2 then
				arg3_7.data3 = 1
			end

			getProxy(ActivityProxy):updateActivity(arg3_7)
		end,
		[ActivityConst.ACTIVITY_TYPE_PUZZLE_CONNECT] = function()
			local var0_44 = getProxy(ActivityProxy)
			local var1_44 = arg3_7.data1_list
			local var2_44 = arg3_7.data2_list
			local var3_44 = arg3_7.data3_list

			if arg1_7.cmd == 1 then
				local var4_44 = pg.activity_tolove_jigsaw[arg1_7.arg1].need[2]
				local var5_44 = pg.player_resource[var4_44].name
				local var6_44 = pg.activity_tolove_jigsaw[arg1_7.arg1].need[3]
				local var7_44 = var1_7:getData()

				var7_44:consume({
					[var5_44] = var6_44
				})
				var1_7:updatePlayer(var7_44)
				table.insert(var1_44, arg1_7.arg1)
			elseif arg1_7.cmd == 2 then
				table.insert(var2_44, arg1_7.arg1)
			elseif arg1_7.cmd == 3 then
				table.insert(var3_44, arg1_7.arg1)
			end

			var0_44:updateActivity(arg3_7)
		end,
		[ActivityConst.ACTIVITY_TYPE_SKIN_COUPON_COUNTING] = function()
			local var0_45 = getProxy(ActivityProxy)

			arg3_7.data2 = arg3_7.data2 + arg3_7.data1
			arg3_7.data1 = 0

			var0_45:updateActivity(arg3_7)
		end,
		[ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP] = function()
			if arg1_7.cmd == 1 then
				if not table.contains(arg3_7.data1_list, arg3_7.data1) then
					table.insert(arg3_7.data1_list, arg3_7.data1)
				end

				arg3_7.data1 = arg1_7.arg1
			elseif arg1_7.cmd == 2 then
				-- block empty
			elseif arg1_7.cmd == 3 then
				if not table.contains(arg3_7.data1_list, arg3_7.data1) then
					table.insert(arg3_7.data1_list, arg3_7.data1)
				end

				arg3_7.data1 = 1
				arg3_7.data2 = 1

				getProxy(TaskProxy):removeFinishTaskById(arg3_7:getConfig("config_data")[3][1][2])
			else
				assert(false)
			end

			getProxy(ActivityProxy):updateActivity(arg3_7)
		end,
		[ActivityConst.ACTIVITY_TYPE_HOLIDAY_VILLA] = function()
			if arg1_7.cmd == 1 then
				arg3_7.data1 = 1

				arg3_7:setVitemNumber(66001, 0)
				arg3_7:setVitemNumber(66002, 0)
				arg3_7:setVitemNumber(66003, 0)
				arg3_7:setVitemNumber(66004, 0)
				arg3_7:addVitemNumber(66005, arg2_7.number[1])
				getProxy(ActivityProxy):updateActivity(arg3_7)
				arg0_7:sendNotification(ActivityProxy.ACTIVITY_EXCHANGE_RESOURCES, arg1_7.activity_id)
			elseif arg1_7.cmd == 2 then
				arg3_7:updateDataList(arg1_7.arg1)
				getProxy(ActivityProxy):updateActivity(arg3_7)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_STRONGHOLD] = function()
			if arg1_7.cmd == 1 then
				arg3_7:updateDataList(arg1_7.arg1)

				local var0_48 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

				for iter0_48, iter1_48 in ipairs(arg1_7.consumes) do
					local var1_48 = iter1_48[2]
					local var2_48 = iter1_48[3]

					if var1_48 == 6 then
						local var3_48 = var1_7:getData()

						var3_48:consume({
							[id2res(var1_48)] = var2_48
						})
						var1_7:updatePlayer(var3_48)
					else
						var0_48:subItemCount(var1_48, var2_48)
					end
				end
			elseif arg1_7.cmd == 2 then
				arg3_7:updateKVPList(1, arg1_7.arg1, arg1_7.canGetIndex)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_SKIN_FAKE_PACKAGE] = function()
			assert(arg3_7.data1 == 0)

			arg3_7.data1 = 1

			reducePlayerOwn(arg1_7.costDrop)
		end,
		[ActivityConst.ACTIVITY_TYPE_LOVE_LETTER_UP] = function()
			arg3_7:SetTargetGroupId(arg1_7.arg1)
			arg3_7:AddChangeCount()
		end
	})

	return arg3_7
end

function var0_0.performance(arg0_51, arg1_51, arg2_51, arg3_51, arg4_51)
	local var0_51 = arg3_51:getConfig("type")
	local var1_51

	local function var2_51()
		if var1_51 and coroutine.status(var1_51) == "suspended" then
			local var0_52, var1_52 = coroutine.resume(var1_51)

			assert(var0_52, var1_52)
		end
	end

	var1_51 = coroutine.create(function()
		switch(var0_51, {
			[ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN] = function()
				local var0_54 = arg3_51:getConfig("config_client").story

				if var0_54 and var0_54[arg3_51.data1] and var0_54[arg3_51.data1][1] then
					pg.NewStoryMgr.GetInstance():Play(var0_54[arg3_51.data1][1], var2_51)
					coroutine.yield()
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_BB] = function()
				local var0_55 = pg.gameset.bobing_memory.description[arg3_51.data1]

				if var0_55 and #var0_55 > 0 then
					pg.NewStoryMgr.GetInstance():Play(var0_55, var2_51)
					coroutine.yield()
				end

				arg0_51:sendNotification(ActivityProxy.ACTIVITY_SHOW_BB_RESULT, {
					numbers = arg2_51.number,
					callback = var2_51,
					awards = arg4_51
				})
				coroutine.yield()
			end,
			[ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD] = function()
				if arg1_51.cmd == 1 then
					local var0_56 = arg3_51:getConfig("config_client").story

					if var0_56 and var0_56[arg3_51.data1] and var0_56[arg3_51.data1][1] then
						pg.NewStoryMgr.GetInstance():Play(var0_56[arg3_51.data1][1], var2_51)
						coroutine.yield()
					end

					arg0_51:sendNotification(ActivityProxy.ACTIVITY_SHOW_LOTTERY_AWARD_RESULT, {
						activityID = arg3_51.id,
						awards = arg4_51,
						number = arg2_51.number[1],
						callback = var2_51
					})

					arg4_51 = {}

					coroutine.yield()
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_CARD_PAIRS] = function()
				if arg3_51:getConfig("config_client")[1] then
					local var0_57 = arg3_51:getConfig("config_client")[1][arg3_51.data2 + 1]

					if var0_57 then
						pg.NewStoryMgr.GetInstance():Play(var0_57, var2_51)
						coroutine.yield()
					end
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_LINK_LINK] = function()
				if arg3_51:getConfig("config_client")[1] then
					local var0_58 = arg3_51:getConfig("config_client")[1][arg3_51.data2 + 1]

					if var0_58 then
						pg.NewStoryMgr.GetInstance():Play(var0_58, var2_51)
						coroutine.yield()
					end
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_DODGEM] = function()
				if arg1_51.cmd == 2 and arg2_51.number[3] > 0 then
					local var0_59 = arg3_51:getConfig("config_client")[1]
					local var1_59 = {
						type = var0_59[1],
						id = var0_59[2],
						count = var0_59[3]
					}

					table.insert(arg4_51, var1_59)
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_SUBMARINE_RUN] = function()
				if arg1_51.cmd == 2 and arg2_51.number[3] > 0 then
					local var0_60 = arg3_51:getConfig("config_client")[1]
					local var1_60 = {
						type = var0_60[1],
						id = var0_60[2],
						count = var0_60[3]
					}

					table.insert(arg4_51, var1_60)
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF] = function()
				if arg1_51.cmd == 1 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("building_complete_tip"))
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2] = function()
				if arg1_51.cmd == 1 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("building_complete_tip"))
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_MONTHSIGN] = function()
				if arg1_51.cmd == 3 then
					local var0_63 = arg3_51:getSpecialData("month_sign_awards") or {}

					for iter0_63 = 1, #arg4_51 do
						table.insert(var0_63, arg4_51[iter0_63])
					end

					arg3_51:setSpecialData("month_sign_awards", var0_63)

					arg4_51 = {}
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS] = function()
				if arg1_51.cmd == 1 then
					arg0_51:sendNotification(ActivityProxy.ACTIVITY_SHOW_SHAKE_BEADS_RESULT, {
						number = arg2_51.number[1],
						callback = var2_51,
						awards = arg4_51
					})
					coroutine.yield()
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_APRIL_REWARD] = function()
				if arg1_51.cmd == 1 then
					arg3_51.data1 = arg1_51.arg1
				elseif arg1_51.cmd == 2 then
					arg3_51.data2 = 1
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_FIREWORK] = function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("activity_yanhua_tip8"))

				local var0_66 = #arg3_51:getData1List()
				local var1_66 = arg3_51:getConfig("config_client").story

				if var1_66 and type(var1_66) == "table" then
					for iter0_66, iter1_66 in ipairs(var1_66) do
						if var0_66 == iter1_66[1] then
							pg.NewStoryMgr.GetInstance():Play(iter1_66[2], var2_51)
							coroutine.yield()
						end
					end
				end

				local var2_66 = getProxy(ActivityProxy)

				var2_66:updateActivity(arg3_51)

				local var3_66 = arg3_51:getConfig("config_client").ActID

				if var3_66 then
					local var4_66 = var2_66:getActivityById(var3_66)

					if var4_66 then
						var2_66:updateActivity(var4_66)
					end
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_SKIN_FAKE_PACKAGE] = function()
				getProxy(ActivityProxy):updateActivity(arg3_51)
				arg0_51:sendNotification(NewShopMainMediator.NOTI_UPDATE_CURRENT)
			end
		})

		if #arg4_51 > 0 then
			arg0_51:sendNotification(arg3_51:getNotificationMsg(), {
				activityId = arg1_51.activity_id,
				awards = arg4_51,
				callback = var2_51
			})
			coroutine.yield()
		end

		if var0_51 == 17 and arg1_51.cmd and arg1_51.cmd == 2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("mingshi_get_tip"))
		end

		getProxy(ActivityProxy):updateActivity(arg3_51)
		arg0_51:sendNotification(ActivityProxy.ACTIVITY_OPERATION_DONE, arg1_51.activity_id)
		existCall(arg1_51.callback)
	end)

	var2_51()
end

return var0_0
