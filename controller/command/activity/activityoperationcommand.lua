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
		end,
		[ActivityConst.ACTIVITY_TYPE_TIMES_FAKE_PACKAGE] = function()
			local var0_6 = var0_1.costDrop

			if var0_6.count > var0_6:getOwnedCount() then
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
	}, 11203, function(arg0_7)
		if arg0_7.result == 0 then
			local var0_7 = PlayerConst.GetTranAwards(var0_1, arg0_7)
			local var1_7 = arg0_1:updateActivityData(var0_1, arg0_7, var1_1, var0_7)

			getProxy(ActivityTaskProxy):checkAutoSubmit()
			arg0_1:performance(var0_1, arg0_7, var1_7, var0_7)
		else
			originalPrint("activity op ret code: " .. arg0_7.result)

			if var2_1 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN or var2_1 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN or var2_1 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN or var2_1 == ActivityConst.ACTIVITY_TYPE_REFLUX then
				var1_1.autoActionForbidden = true

				getProxy(ActivityProxy):updateActivity(var1_1)
			elseif var2_1 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 or var2_1 == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD then
				if arg0_7.result == 1 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("activity_build_end_tip"))
				end
			elseif var2_1 == 17 then
				pg.TipsMgr.GetInstance():ShowTips("错误!:" .. arg0_7.result)
			elseif var2_1 == ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP then
				pg.TipsMgr.GetInstance():ShowTips(errorTip("activity_op_error", arg0_7.result))
			elseif var2_1 == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF then
				if var1_1:getConfig("config_client").resource_ID == BossRushDALUpgradeView.RES_ID then
					pg.TipsMgr.GetInstance():ShowTips(i18n("DAL_upgrade_not_enough"))
				end
			elseif arg0_7.result == 3 or arg0_7.result == 4 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("activity_op_error", arg0_7.result))
			end

			arg0_1:sendNotification(ActivityProxy.ACTIVITY_OPERATION_ERRO, {
				actId = var0_1.activity_id,
				code = arg0_7.result
			})
		end
	end)
end

function var0_0.updateActivityData(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	local var0_8 = arg3_8:getConfig("type")
	local var1_8 = getProxy(PlayerProxy)
	local var2_8 = getProxy(TaskProxy)

	switch(var0_8, {
		[ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN] = function()
			arg3_8.data1 = arg3_8.data1 + 1
			arg3_8.data2 = pg.TimeMgr.GetInstance():GetServerTime()
		end,
		[ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN] = function()
			if arg1_8.cmd == 1 then
				arg3_8.data1 = arg3_8.data1 + 1
				arg3_8.data2 = pg.TimeMgr.GetInstance():GetServerTime()
			elseif arg1_8.cmd == 2 then
				arg3_8.achieved = true
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_LEVELAWARD] = function()
			table.insert(arg3_8.data1_list, arg1_8.arg1)
		end,
		[ActivityConst.ACTIVITY_TYPE_STORY_AWARD] = function()
			table.insert(arg3_8.data1_list, arg1_8.arg1)
		end,
		[ActivityConst.ACTIVITY_TYPE_LEVELPLAN] = function()
			if arg1_8.cmd == 1 then
				arg3_8.data1 = true
			elseif arg1_8.cmd == 2 then
				table.insert(arg3_8.data1_list, arg1_8.arg1)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_MONTHSIGN] = function()
			local var0_14 = pg.TimeMgr.GetInstance():GetServerTime()
			local var1_14 = pg.TimeMgr.GetInstance():STimeDescS(var0_14, "*t")

			if arg3_8:getSpecialData("reMonthSignDay") ~= nil then
				day = arg3_8:getSpecialData("reMonthSignDay")
				arg3_8.data3 = arg3_8.data3 and arg3_8.data3 + 1 or 1
			else
				day = var1_14.day
			end

			arg3_8:setSpecialData(MonthSignPage.MILESTONE_SPECIAL_DATA, nil)
			table.insert(arg3_8.data1_list, day)

			local var2_14 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOGIN_RECORD)

			if var2_14 and not var2_14:isEnd() then
				var2_14.data1 = var2_14.data1 + 1
				var2_14.data2 = var2_14.data2 + 1
				var2_14.data3 = math.max(var2_14.data3, var2_14.data2)

				for iter0_14, iter1_14 in ipairs(MonthSignPage.MONTH_SIGN_SP_DAYS) do
					if iter1_14 == var2_14.data1 then
						arg3_8:setSpecialData(MonthSignPage.MILESTONE_SPECIAL_DATA, iter1_14)
					end
				end

				getProxy(ActivityProxy):updateActivity(var2_14)
			end

			getProxy(ActivityProxy):updateActivity(arg3_8)
		end,
		[ActivityConst.ACTIVITY_TYPE_CHARGEAWARD] = function()
			arg3_8.data2 = 1
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1] = function()
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_SHIP, arg1_8.arg1)

			local var0_16 = pg.ship_data_create_material[arg1_8.buildId]

			if arg1_8.arg2 == 1 then
				local var1_16 = getProxy(ActivityProxy)
				local var2_16 = var1_16:getBuildFreeActivityByBuildId(arg1_8.buildId)

				var2_16.data1 = var2_16.data1 - arg1_8.arg1

				var1_16:updateActivity(var2_16)
			else
				getProxy(BagProxy):removeItemById(var0_16.use_item, var0_16.number_1 * arg1_8.arg1)

				local var3_16 = var1_8:getData()

				var3_16:consume({
					gold = var0_16.use_gold * arg1_8.arg1
				})
				var1_8:updatePlayer(var3_16)
			end

			local var4_16 = getProxy(BuildShipProxy)

			if var0_16.exchange_count > 0 then
				var4_16:changeRegularExchangeCount(arg1_8.arg1 * var0_16.exchange_count)
			end

			for iter0_16, iter1_16 in ipairs(arg2_8.build) do
				local var5_16 = BuildShip.New(iter1_16)

				var4_16:addBuildShip(var5_16)
			end

			arg3_8.data1 = arg3_8.data1 + arg1_8.arg1

			arg0_8:sendNotification(GAME.BUILD_SHIP_DONE)
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDSHIP_PRAY] = ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		[ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD] = ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1,
		[ActivityConst.ACTIVITY_TYPE_SHOP] = function()
			local var0_17 = getProxy(ShopsProxy)
			local var1_17 = var0_17:getActivityShopById(arg3_8.id)

			var0_17:UpdateActivityGoods(arg3_8.id, arg1_8.arg1, arg1_8.arg2)

			if table.contains(arg3_8.data1_list, arg1_8.arg1) then
				for iter0_17, iter1_17 in ipairs(arg3_8.data1_list) do
					if iter1_17 == arg1_8.arg1 then
						arg3_8.data2_list[iter0_17] = arg3_8.data2_list[iter0_17] + arg1_8.arg2

						break
					end
				end
			else
				table.insert(arg3_8.data1_list, arg1_8.arg1)
				table.insert(arg3_8.data2_list, arg1_8.arg2)
			end

			local var2_17 = var1_17:bindConfigTable()[arg1_8.arg1]
			local var3_17 = var2_17.resource_num * arg1_8.arg2
			local var4_17 = var1_8:getData()

			var4_17:consume({
				[id2res(var2_17.resource_type)] = var3_17
			})
			var1_8:updatePlayer(var4_17)
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_LIST] = function()
			if arg1_8.cmd == 1 then
				local var0_18, var1_18 = getActivityTask(arg3_8)

				if var1_18 and not var1_18:isReceive() then
					local var2_18 = arg3_8:getConfig("config_data")

					for iter0_18, iter1_18 in ipairs(var2_18) do
						local var3_18 = _.flatten({
							iter1_18
						})

						if table.contains(var3_18, var0_18) then
							arg3_8.data3 = iter0_18

							break
						end
					end
				end
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_TASK_RES] = function()
			if arg1_8.cmd == 1 then
				local var0_19, var1_19 = getActivityTask(arg3_8)

				if var1_19 and not var1_19:isReceive() then
					local var2_19 = arg3_8:getConfig("config_data")

					for iter0_19, iter1_19 in ipairs(var2_19) do
						local var3_19 = _.flatten({
							iter1_19
						})

						if table.contains(var3_19, var0_19) then
							arg3_8.data3 = iter0_19

							break
						end
					end
				end
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_PUZZLA] = function()
			if arg1_8.cmd == PuzzleActivity.CMD_COMPLETE then
				arg3_8.data1 = 1
			elseif arg1_8.cmd == PuzzleActivity.CMD_EARN_EXTRA then
				arg3_8.data1 = 2
			elseif arg1_8.cmd == PuzzleActivity.CMD_ACTIVATE then
				table.insert(arg3_8.data2_list, arg1_8.arg1)
			end

			getProxy(ActivityProxy):updateActivity(arg3_8)
		end,
		[ActivityConst.ACTIVITY_TYPE_BB] = function()
			arg3_8.data1 = arg3_8.data1 + 1
			arg3_8.data2 = arg3_8.data2 - 1
			arg3_8.data1_list = arg2_8.number
		end,
		[ActivityConst.ACTIVITY_TYPE_LOTTERY] = function()
			if arg1_8.cmd == 1 then
				local var0_22 = ActivityItemPool.New({
					id = arg1_8.arg2
				})
				local var1_22 = var0_22:getComsume()
				local var2_22 = arg1_8.arg1 * var1_22.count

				if var1_22.type == DROP_TYPE_RESOURCE then
					local var3_22 = var1_8:getData()

					var3_22:consume({
						[id2res(var1_22.id)] = var2_22
					})
					var1_8:updatePlayer(var3_22)
				elseif var1_22.type == DROP_TYPE_ITEM then
					getProxy(BagProxy):removeItemById(var1_22.id, var2_22)
				end

				arg3_8:updateData(var0_22.id, arg2_8.number)
			elseif arg1_8.cmd == 2 then
				arg3_8.data1 = arg1_8.arg1
			elseif arg1_8.cmd == 3 then
				arg3_8.data2_list = _.map(arg1_8.arg_list, function(arg0_23)
					return arg0_23
				end)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_CARD_PAIRS] = function()
			if arg1_8.cmd == 1 then
				local var0_24 = arg3_8:getConfig("config_data")[4]

				if #arg4_8 > 0 then
					arg3_8.data2 = arg3_8.data2 + 1

					if var0_24 <= arg3_8.data2 then
						arg3_8.data1 = 1
					end
				end

				if arg3_8.data4 == 0 then
					arg3_8.data4 = arg1_8.arg2
				elseif arg1_8.arg2 < arg3_8.data4 then
					arg3_8.data4 = arg1_8.arg2
				end
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_LINK_LINK] = ActivityConst.ACTIVITY_TYPE_CARD_PAIRS,
		[ActivityConst.ACTIVITY_TYPE_REFLUX] = function()
			if arg1_8.cmd == 1 then
				arg3_8.data1_list[1] = pg.TimeMgr.GetInstance():GetServerTime()
				arg3_8.data1_list[2] = arg3_8.data1_list[2] + 1
			elseif arg1_8.cmd == 2 then
				arg3_8.data4 = arg1_8.arg1
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD] = function()
			if arg1_8.cmd == 1 then
				arg3_8.data1 = arg3_8.data1 + 1
				arg3_8.data2 = arg2_8.number[1]
			elseif arg1_8.cmd == 2 then
				table.insert(arg3_8.data1_list, arg3_8.data1)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_DODGEM] = function()
			if arg1_8.cmd == 1 then
				arg0_8:sendNotification(GAME.FINISH_STAGE_DONE, {
					statistics = arg1_8.statistics,
					score = arg1_8.statistics._battleScore,
					system = SYSTEM_DODGEM
				})

				arg3_8.data1_list[1] = math.max(arg3_8.data1_list[1], arg1_8.arg2)
				arg3_8.data2_list[1] = arg2_8.number[1]
				arg3_8.data2_list[2] = arg2_8.number[2]
			elseif arg1_8.cmd == 2 then
				arg3_8.data2 = arg2_8.number[1]
				arg3_8.data3 = arg2_8.number[2]
				arg3_8.data2_list[1] = 0
				arg3_8.data2_list[2] = 0
			elseif arg1_8.cmd == 3 then
				arg3_8.data4 = defaultValue(arg3_8.data4, 0) + 1
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_SUBMARINE_RUN] = function()
			if arg1_8.cmd == 1 then
				arg0_8:sendNotification(GAME.FINISH_STAGE_DONE, {
					statistics = arg1_8.statistics,
					score = arg1_8.statistics._battleScore,
					system = SYSTEM_SUBMARINE_RUN
				})

				arg3_8.data1_list[1] = math.max(arg3_8.data1_list[1], arg1_8.arg2)
				arg3_8.data2_list[1] = arg2_8.number[1]
				arg3_8.data2_list[2] = arg2_8.number[2]
			elseif arg1_8.cmd == 2 then
				arg3_8.data2 = arg2_8.number[1]
				arg3_8.data3 = arg2_8.number[2]
				arg3_8.data2_list[1] = 0
				arg3_8.data2_list[2] = 0
			elseif arg1_8.cmd == 3 then
				arg3_8.data4 = defaultValue(arg3_8.data4, 0) + 1
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_TURNTABLE] = function()
			if arg1_8.cmd == 2 then
				arg3_8.data4 = 0
			elseif arg1_8.cmd == 1 then
				local var0_29 = arg3_8:getConfig("config_id")
				local var1_29 = pg.activity_event_turning[var0_29].total_num

				if arg3_8.data3 == var1_29 then
					arg3_8.data2 = 1
					arg3_8.data3 = arg3_8.data3 + 1
				else
					arg3_8.data3 = arg3_8.data3 + 1
					arg3_8.data4 = arg2_8.number[1]
					arg3_8.data1_list[arg1_8.arg1] = arg3_8.data4
				end
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_SHRINE] = function()
			arg3_8.data1 = 1
		end,
		[ActivityConst.ACTIVITY_TYPE_RED_PACKETS] = function()
			arg3_8.data1 = arg3_8.data1 - 1

			if arg3_8.data2 > 0 then
				arg3_8.data2 = arg3_8.data2 - 1
			end

			arg3_8.data1_list[2] = arg3_8.data1_list[2] + 1

			local var0_31 = getProxy(ActivityProxy)
			local var1_31 = var0_31:getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

			if var1_31 and not var1_31:isEnd() and var1_31.data2_list[1] > var1_31.data2_list[2] then
				var1_31.data2_list[2] = var1_31.data2_list[2] + 1

				var0_31:updateActivity(var1_31)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_RED_PACKET_LOTTER] = function()
			arg3_8.data1 = arg3_8.data1 + 1

			if not table.contains(arg3_8.data2_list, arg1_8.arg1) then
				table.insert(arg3_8.data2_list, arg1_8.arg1)
			end

			if not table.contains(arg3_8.data1_list, arg2_8.number[1]) then
				table.insert(arg3_8.data1_list, arg2_8.number[1])
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF] = function()
			if arg1_8.cmd == 1 then
				local var0_33 = pg.activity_event_building[arg1_8.arg1]
				local var1_33 = arg3_8:GetBuildingLevel(arg1_8.arg1)

				arg3_8:SetBuildingLevel(arg1_8.arg1, var1_33 + 1)

				if var1_33 < #var0_33.buff then
					_.each(var0_33.material[var1_33], function(arg0_34)
						local var0_34 = arg0_34[1]
						local var1_34 = arg0_34[2]
						local var2_34 = arg0_34[3]
						local var3_34

						if var0_34 == DROP_TYPE_VITEM then
							local var4_34 = AcessWithinNull(Item.getConfigData(var1_34), "link_id")

							assert(var4_34 == arg3_8.id)

							var3_34 = arg3_8
						elseif var0_34 > DROP_TYPE_USE_ACTIVITY_DROP then
							local var5_34 = AcessWithinNull(pg.activity_drop_type[var0_34], "activity_id")

							var3_34 = getProxy(ActivityProxy):getActivityById(var5_34)
						end

						local var6_34 = var3_34.data1KeyValueList[1][var1_34] or 0
						local var7_34 = math.max(0, var6_34 - var2_34)

						var3_34.data1KeyValueList[1][var1_34] = var7_34

						if var0_34 > DROP_TYPE_USE_ACTIVITY_DROP then
							getProxy(ActivityProxy):updateActivity(var3_34)
						end
					end)
				end
			elseif arg1_8.cmd == 2 and var0_8 == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
				arg3_8:RecordLastRequestTime()
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2] = ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF,
		[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = function()
			if arg1_8.cmd == 2 then
				table.insert(arg3_8.data2_list, arg1_8.arg1)
				arg0_8:sendNotification(GAME.FINISH_STAGE_DONE, {
					statistics = arg1_8.statistics,
					score = arg1_8.statistics._battleScore,
					system = SYSTEM_REWARD_PERFORM
				})

				return arg3_8
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_EXPEDITION] = function()
			if arg1_8.cmd == 0 then
				return arg3_8
			end

			if arg1_8.cmd == 3 then
				arg0_8:sendNotification(GAME.FINISH_STAGE_DONE, {
					statistics = arg1_8.statistics,
					score = arg1_8.statistics._battleScore,
					system = SYSTEM_REWARD_PERFORM
				})

				return arg3_8
			end

			if arg1_8.cmd == 4 then
				arg3_8.data2_list[1] = arg3_8.data2_list[1] + 1

				return arg3_8
			end

			if arg1_8.cmd == 1 then
				arg3_8.data3 = arg3_8.data3 - 1
			end

			local var0_36 = arg1_8.arg1

			if arg1_8.cmd ~= 2 then
				arg3_8.data2 = var0_36
			end

			local var1_36 = arg2_8.number[1]

			arg3_8.data1_list[var0_36] = var1_36

			print("格子:" .. var0_36 .. " 值:" .. arg2_8.number[1])

			if arg2_8.number[2] and arg3_8.data1 ~= arg2_8.number[2] then
				print("关卡变更" .. arg2_8.number[2])

				arg3_8.data1 = arg3_8.data1 + 1
				arg3_8.data2 = 0

				for iter0_36 = 1, #arg3_8.data1_list do
					arg3_8.data1_list[iter0_36] = 0
				end
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE] = function()
			if arg1_8.cmd == 1 then
				arg0_8:sendNotification(GAME.FINISH_STAGE_DONE, {
					statistics = arg1_8.statistics,
					score = arg1_8.statistics._battleScore,
					system = SYSTEM_AIRFIGHT
				})

				arg3_8.data1KeyValueList[1] = arg3_8.data1KeyValueList[1] or {}
				arg3_8.data1KeyValueList[1][arg1_8.arg1] = (arg3_8.data1KeyValueList[1][arg1_8.arg1] or 0) + 1
			elseif arg1_8.cmd == 2 then
				arg3_8.data1KeyValueList[2] = arg3_8.data1KeyValueList[2] or {}
				arg3_8.data1KeyValueList[2][arg1_8.arg1] = 1
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS] = function()
			if arg1_8.cmd == 1 then
				arg3_8.data1 = arg3_8.data1 - 1

				local var0_38 = arg2_8.number[1]

				arg3_8.data1KeyValueList[1][var0_38] = arg3_8.data1KeyValueList[1][var0_38] + 1
			elseif arg1_8.cmd == 2 then
				arg3_8.data2 = 1
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_PT_OTHER] = function()
			if arg1_8.cmd == 1 then
				arg3_8.data2 = 1
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_HOTSPRING] = function()
			if arg1_8.cmd == SpringActivity.OPERATION_UNLOCK then
				arg3_8:AddSlotCount()
			elseif arg1_8.cmd == SpringActivity.OPERATION_SETSHIP then
				arg3_8:SetShipIds(arg1_8.kvargs1)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_HOTSPRING_2] = function()
			if arg1_8.cmd == Spring2Activity.OPERATION_SETSHIP then
				arg3_8:SetShipIds(arg1_8.kvargs1)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_FIREWORK] = function()
			if arg1_8.cmd == 1 then
				arg3_8.data1 = arg3_8.data1 - 1

				if not table.contains(arg3_8.data1_list, arg1_8.arg1) then
					table.insert(arg3_8.data1_list, arg1_8.arg1)
				end

				local var0_42 = Item.getConfigData(arg1_8.arg1).link_id

				if var0_42 > 0 then
					local var1_42 = getProxy(ActivityProxy)
					local var2_42 = var1_42:getActivityById(var0_42)

					if var2_42 and not var2_42:isEnd() then
						var2_42.data1 = var2_42.data1 + 1

						var1_42:updateActivity(var2_42)
					end
				end

				local var3_42 = getProxy(PlayerProxy)
				local var4_42 = var3_42:getRawData()
				local var5_42 = arg3_8:getConfig("config_data")[2][1]
				local var6_42 = arg3_8:getConfig("config_data")[2][2]

				var4_42:consume({
					[id2res(var5_42)] = var6_42
				})
				var3_42:updatePlayer(var4_42)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_CARD_PUZZLE] = function()
			if not table.contains(arg3_8.data1_list, arg1_8.arg1) then
				table.insert(arg3_8.data1_list, arg1_8.arg1)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_ZUMA] = function()
			if arg1_8.cmd == 1 then
				if arg1_8.arg1 == LaunchBallGameConst.round_type_juqing then
					arg3_8.data1 = arg3_8.data1 + 1
				elseif arg1_8.arg1 == 2 then
					if not arg3_8.data1_list then
						arg3_8.data1_list = {}
					end

					table.insert(arg3_8.data1_list, arg1_8.arg2)
				elseif arg1_8.arg1 == 3 then
					arg3_8.data2 = arg1_8.arg2
				end
			elseif arg1_8.cmd == 2 then
				arg3_8.data3 = 1
			end

			getProxy(ActivityProxy):updateActivity(arg3_8)
		end,
		[ActivityConst.ACTIVITY_TYPE_PUZZLE_CONNECT] = function()
			local var0_45 = getProxy(ActivityProxy)
			local var1_45 = arg3_8.data1_list
			local var2_45 = arg3_8.data2_list
			local var3_45 = arg3_8.data3_list

			if arg1_8.cmd == 1 then
				local var4_45 = pg.activity_tolove_jigsaw[arg1_8.arg1].need[2]
				local var5_45 = pg.player_resource[var4_45].name
				local var6_45 = pg.activity_tolove_jigsaw[arg1_8.arg1].need[3]
				local var7_45 = var1_8:getData()

				var7_45:consume({
					[var5_45] = var6_45
				})
				var1_8:updatePlayer(var7_45)
				table.insert(var1_45, arg1_8.arg1)
			elseif arg1_8.cmd == 2 then
				table.insert(var2_45, arg1_8.arg1)
			elseif arg1_8.cmd == 3 then
				table.insert(var3_45, arg1_8.arg1)
			end

			var0_45:updateActivity(arg3_8)
		end,
		[ActivityConst.ACTIVITY_TYPE_SKIN_COUPON_COUNTING] = function()
			local var0_46 = getProxy(ActivityProxy)

			arg3_8.data2 = arg3_8.data2 + arg3_8.data1
			arg3_8.data1 = 0

			var0_46:updateActivity(arg3_8)
		end,
		[ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP] = function()
			if arg1_8.cmd == 1 then
				if not table.contains(arg3_8.data1_list, arg3_8.data1) then
					table.insert(arg3_8.data1_list, arg3_8.data1)
				end

				arg3_8.data1 = arg1_8.arg1
			elseif arg1_8.cmd == 2 then
				-- block empty
			elseif arg1_8.cmd == 3 then
				if not table.contains(arg3_8.data1_list, arg3_8.data1) then
					table.insert(arg3_8.data1_list, arg3_8.data1)
				end

				arg3_8.data1 = 1
				arg3_8.data2 = 1

				getProxy(TaskProxy):removeFinishTaskById(arg3_8:getConfig("config_data")[3][1][2])
			else
				assert(false)
			end

			getProxy(ActivityProxy):updateActivity(arg3_8)
		end,
		[ActivityConst.ACTIVITY_TYPE_HOLIDAY_VILLA] = function()
			if arg1_8.cmd == 1 then
				arg3_8.data1 = 1

				arg3_8:setVitemNumber(66001, 0)
				arg3_8:setVitemNumber(66002, 0)
				arg3_8:setVitemNumber(66003, 0)
				arg3_8:setVitemNumber(66004, 0)
				arg3_8:addVitemNumber(66005, arg2_8.number[1])
				getProxy(ActivityProxy):updateActivity(arg3_8)
				arg0_8:sendNotification(ActivityProxy.ACTIVITY_EXCHANGE_RESOURCES, arg1_8.activity_id)
			elseif arg1_8.cmd == 2 then
				arg3_8:updateDataList(arg1_8.arg1)
				getProxy(ActivityProxy):updateActivity(arg3_8)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_STRONGHOLD] = function()
			if arg1_8.cmd == 1 then
				arg3_8:updateDataList(arg1_8.arg1)

				local var0_49 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

				for iter0_49, iter1_49 in ipairs(arg1_8.consumes) do
					local var1_49 = iter1_49[2]
					local var2_49 = iter1_49[3]

					if var1_49 == 6 then
						local var3_49 = var1_8:getData()

						var3_49:consume({
							[id2res(var1_49)] = var2_49
						})
						var1_8:updatePlayer(var3_49)
					else
						var0_49:subItemCount(var1_49, var2_49)
					end
				end
			elseif arg1_8.cmd == 2 then
				arg3_8:updateKVPList(1, arg1_8.arg1, arg1_8.canGetIndex)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_SKIN_FAKE_PACKAGE] = function()
			assert(arg3_8.data1 == 0)

			arg3_8.data1 = 1

			reducePlayerOwn(arg1_8.costDrop)
		end,
		[ActivityConst.ACTIVITY_TYPE_TIMES_FAKE_PACKAGE] = function()
			arg3_8.data1 = arg3_8.data1 + 1

			reducePlayerOwn(arg1_8.costDrop)
		end,
		[ActivityConst.ACTIVITY_TYPE_LOVE_LETTER_UP] = function()
			arg3_8:SetTargetGroupId(arg1_8.arg1)
			arg3_8:AddChangeCount()
		end
	})

	return arg3_8
end

function var0_0.performance(arg0_53, arg1_53, arg2_53, arg3_53, arg4_53)
	local var0_53 = arg3_53:getConfig("type")
	local var1_53

	local function var2_53()
		if var1_53 and coroutine.status(var1_53) == "suspended" then
			local var0_54, var1_54 = coroutine.resume(var1_53)

			assert(var0_54, var1_54)
		end
	end

	var1_53 = coroutine.create(function()
		switch(var0_53, {
			[ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN] = function()
				local var0_56 = arg3_53:getConfig("config_client").story

				if var0_56 and var0_56[arg3_53.data1] and var0_56[arg3_53.data1][1] then
					pg.NewStoryMgr.GetInstance():Play(var0_56[arg3_53.data1][1], var2_53)
					coroutine.yield()
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_BB] = function()
				local var0_57 = pg.gameset.bobing_memory.description[arg3_53.data1]

				if var0_57 and #var0_57 > 0 then
					pg.NewStoryMgr.GetInstance():Play(var0_57, var2_53)
					coroutine.yield()
				end

				arg0_53:sendNotification(ActivityProxy.ACTIVITY_SHOW_BB_RESULT, {
					numbers = arg2_53.number,
					callback = var2_53,
					awards = arg4_53
				})
				coroutine.yield()
			end,
			[ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD] = function()
				if arg1_53.cmd == 1 then
					local var0_58 = arg3_53:getConfig("config_client").story

					if var0_58 and var0_58[arg3_53.data1] and var0_58[arg3_53.data1][1] then
						pg.NewStoryMgr.GetInstance():Play(var0_58[arg3_53.data1][1], var2_53)
						coroutine.yield()
					end

					arg0_53:sendNotification(ActivityProxy.ACTIVITY_SHOW_LOTTERY_AWARD_RESULT, {
						activityID = arg3_53.id,
						awards = arg4_53,
						number = arg2_53.number[1],
						callback = var2_53
					})

					arg4_53 = {}

					coroutine.yield()
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_CARD_PAIRS] = function()
				if arg3_53:getConfig("config_client")[1] then
					local var0_59 = arg3_53:getConfig("config_client")[1][arg3_53.data2 + 1]

					if var0_59 then
						pg.NewStoryMgr.GetInstance():Play(var0_59, var2_53)
						coroutine.yield()
					end
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_LINK_LINK] = function()
				if arg3_53:getConfig("config_client")[1] then
					local var0_60 = arg3_53:getConfig("config_client")[1][arg3_53.data2 + 1]

					if var0_60 then
						pg.NewStoryMgr.GetInstance():Play(var0_60, var2_53)
						coroutine.yield()
					end
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_DODGEM] = function()
				if arg1_53.cmd == 2 and arg2_53.number[3] > 0 then
					local var0_61 = arg3_53:getConfig("config_client")[1]
					local var1_61 = {
						type = var0_61[1],
						id = var0_61[2],
						count = var0_61[3]
					}

					table.insert(arg4_53, var1_61)
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_SUBMARINE_RUN] = function()
				if arg1_53.cmd == 2 and arg2_53.number[3] > 0 then
					local var0_62 = arg3_53:getConfig("config_client")[1]
					local var1_62 = {
						type = var0_62[1],
						id = var0_62[2],
						count = var0_62[3]
					}

					table.insert(arg4_53, var1_62)
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF] = function()
				if arg1_53.cmd == 1 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("building_complete_tip"))
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2] = function()
				if arg1_53.cmd == 1 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("building_complete_tip"))
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_MONTHSIGN] = function()
				if arg1_53.cmd == 3 then
					local var0_65 = arg3_53:getSpecialData("month_sign_awards") or {}

					for iter0_65 = 1, #arg4_53 do
						table.insert(var0_65, arg4_53[iter0_65])
					end

					arg3_53:setSpecialData("month_sign_awards", var0_65)

					arg4_53 = {}
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS] = function()
				if arg1_53.cmd == 1 then
					arg0_53:sendNotification(ActivityProxy.ACTIVITY_SHOW_SHAKE_BEADS_RESULT, {
						number = arg2_53.number[1],
						callback = var2_53,
						awards = arg4_53
					})
					coroutine.yield()
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_APRIL_REWARD] = function()
				if arg1_53.cmd == 1 then
					arg3_53.data1 = arg1_53.arg1
				elseif arg1_53.cmd == 2 then
					arg3_53.data2 = 1
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_FIREWORK] = function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("activity_yanhua_tip8"))

				local var0_68 = #arg3_53:getData1List()
				local var1_68 = arg3_53:getConfig("config_client").story

				if var1_68 and type(var1_68) == "table" then
					for iter0_68, iter1_68 in ipairs(var1_68) do
						if var0_68 == iter1_68[1] then
							pg.NewStoryMgr.GetInstance():Play(iter1_68[2], var2_53)
							coroutine.yield()
						end
					end
				end

				local var2_68 = getProxy(ActivityProxy)

				var2_68:updateActivity(arg3_53)

				local var3_68 = arg3_53:getConfig("config_client").ActID

				if var3_68 then
					local var4_68 = var2_68:getActivityById(var3_68)

					if var4_68 then
						var2_68:updateActivity(var4_68)
					end
				end
			end,
			[ActivityConst.ACTIVITY_TYPE_SKIN_FAKE_PACKAGE] = function()
				getProxy(ActivityProxy):updateActivity(arg3_53)
				arg0_53:sendNotification(NewShopMainMediator.NOTI_UPDATE_CURRENT)
			end,
			[ActivityConst.ACTIVITY_TYPE_TIMES_FAKE_PACKAGE] = function()
				getProxy(ActivityProxy):updateActivity(arg3_53)
				arg0_53:sendNotification(NewShopMainMediator.NOTI_UPDATE_CURRENT)
			end
		})

		if #arg4_53 > 0 then
			arg0_53:sendNotification(arg3_53:getNotificationMsg(), {
				activityId = arg1_53.activity_id,
				awards = arg4_53,
				callback = var2_53
			})
			coroutine.yield()
		end

		if var0_53 == 17 and arg1_53.cmd and arg1_53.cmd == 2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("mingshi_get_tip"))
		end

		getProxy(ActivityProxy):updateActivity(arg3_53)
		arg0_53:sendNotification(ActivityProxy.ACTIVITY_OPERATION_DONE, arg1_53.activity_id)
		existCall(arg1_53.callback)
	end)

	var2_53()
end

return var0_0
