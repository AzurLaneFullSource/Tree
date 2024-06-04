local var0 = class("ActivityOperationCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(ActivityProxy):getActivityById(var0.activity_id)

	assert(var1)

	local var2 = var1:getConfig("type")

	if var2 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 or var2 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_PRAY or var2 == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD then
		local var3, var4, var5 = BuildShip.canBuildShipByBuildId(var0.buildId, var0.arg1, var0.arg2 == 1)

		if not var3 then
			if var5 then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_1"), ChargeScene.TYPE_ITEM, var5)
			else
				pg.TipsMgr.GetInstance():ShowTips(var4)
			end

			return
		end
	elseif var2 == ActivityConst.ACTIVITY_TYPE_SHOP then
		local var6 = getProxy(PlayerProxy):getData()
		local var7 = getProxy(ShopsProxy):getActivityShopById(var1.id):bindConfigTable()[var0.arg1]
		local var8 = var0.arg2 or 1

		if var6[id2res(var7.resource_type)] < var7.resource_num * var8 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

			return
		end

		if var7.commodity_type == 1 then
			if var7.commodity_id == 1 and var6:GoldMax(var7.num * var8) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

				return
			end

			if var7.commodity_id == 2 and var6:OilMax(var7.num * var8) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

				return
			end
		end
	elseif var2 == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 and var0.cmd == 2 and not var1:CanRequest() then
		return
	end

	print(var0.activity_id, var0.cmd, var0.arg1, var0.arg2)
	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0.activity_id,
		cmd = var0.cmd,
		arg1 = var0.arg1,
		arg2 = var0.arg2,
		arg_list = var0.arg_list or {},
		kvargs1 = var0.kvargs1
	}, 11203, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.GetTranAwards(var0, arg0)
			local var1 = arg0:updateActivityData(var0, arg0, var1, var0)

			getProxy(ActivityTaskProxy):checkAutoSubmit()
			arg0:performance(var0, arg0, var1, var0)
		else
			originalPrint("activity op ret code: " .. arg0.result)
			print("activity op ret code: " .. arg0.result, var0.cmd, var0.arg1)

			if var2 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN or var2 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN or var2 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN or var2 == ActivityConst.ACTIVITY_TYPE_REFLUX then
				var1.autoActionForbidden = true

				getProxy(ActivityProxy):updateActivity(var1)
			elseif var2 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 or var2 == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD then
				if arg0.result == 1 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("activity_build_end_tip"))
				end
			elseif var2 == 17 then
				pg.TipsMgr.GetInstance():ShowTips("错误!:" .. arg0.result)
			elseif var2 == ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP then
				-- block empty
			elseif arg0.result == 3 or arg0.result == 4 then
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

function var0.updateActivityData(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg3:getConfig("type")
	local var1 = getProxy(PlayerProxy)
	local var2 = getProxy(TaskProxy)

	if var0 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
		arg3.data1 = arg3.data1 + 1
		arg3.data2 = pg.TimeMgr.GetInstance():GetServerTime()
	elseif var0 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
		if arg1.cmd == 1 then
			arg3.data1 = arg3.data1 + 1
			arg3.data2 = pg.TimeMgr.GetInstance():GetServerTime()
		elseif arg1.cmd == 2 then
			arg3.achieved = true
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_LEVELAWARD then
		table.insert(arg3.data1_list, arg1.arg1)
	elseif var0 == ActivityConst.ACTIVITY_TYPE_STORY_AWARD then
		table.insert(arg3.data1_list, arg1.arg1)
	elseif var0 == ActivityConst.ACTIVITY_TYPE_LEVELPLAN then
		if arg1.cmd == 1 then
			arg3.data1 = true
		elseif arg1.cmd == 2 then
			table.insert(arg3.data1_list, arg1.arg1)
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
		local var3 = pg.TimeMgr.GetInstance():GetServerTime()
		local var4 = pg.TimeMgr.GetInstance():STimeDescS(var3, "*t")
		local var5

		if arg3:getSpecialData("reMonthSignDay") ~= nil then
			var5 = arg3:getSpecialData("reMonthSignDay")
			arg3.data3 = arg3.data3 and arg3.data3 + 1 or 1
		else
			var5 = var4.day
		end

		getProxy(ActivityProxy):updateActivity(arg3)
		table.insert(arg3.data1_list, var5)
	elseif var0 == ActivityConst.ACTIVITY_TYPE_CHARGEAWARD then
		arg3.data2 = 1
	elseif var0 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 or var0 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_PRAY or var0 == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_SHIP, arg1.arg1)

		local var6 = pg.ship_data_create_material[arg1.buildId]

		if arg1.arg2 == 1 then
			local var7 = getProxy(ActivityProxy)
			local var8 = var7:getBuildFreeActivityByBuildId(arg1.buildId)

			var8.data1 = var8.data1 - arg1.arg1

			var7:updateActivity(var8)
		else
			getProxy(BagProxy):removeItemById(var6.use_item, var6.number_1 * arg1.arg1)

			local var9 = var1:getData()

			var9:consume({
				gold = var6.use_gold * arg1.arg1
			})
			var1:updatePlayer(var9)
		end

		local var10 = getProxy(BuildShipProxy)

		if var6.exchange_count > 0 then
			var10:changeRegularExchangeCount(arg1.arg1 * var6.exchange_count)
		end

		for iter0, iter1 in ipairs(arg2.build) do
			local var11 = BuildShip.New(iter1)

			var10:addBuildShip(var11)
		end

		arg3.data1 = arg3.data1 + arg1.arg1

		arg0:sendNotification(GAME.BUILD_SHIP_DONE)
	elseif var0 == ActivityConst.ACTIVITY_TYPE_SHOP then
		local var12 = getProxy(ShopsProxy)
		local var13 = var12:getActivityShopById(arg3.id)

		var12:UpdateActivityGoods(arg3.id, arg1.arg1, arg1.arg2)

		if table.contains(arg3.data1_list, arg1.arg1) then
			for iter2, iter3 in ipairs(arg3.data1_list) do
				if iter3 == arg1.arg1 then
					arg3.data2_list[iter2] = arg3.data2_list[iter2] + arg1.arg2

					break
				end
			end
		else
			table.insert(arg3.data1_list, arg1.arg1)
			table.insert(arg3.data2_list, arg1.arg2)
		end

		local var14 = var13:bindConfigTable()[arg1.arg1]
		local var15 = var14.resource_num * arg1.arg2
		local var16 = var1:getData()

		var16:consume({
			[id2res(var14.resource_type)] = var15
		})
		var1:updatePlayer(var16)
	elseif var0 == ActivityConst.ACTIVITY_TYPE_ZPROJECT then
		-- block empty
	elseif var0 == ActivityConst.ACTIVITY_TYPE_TASK_LIST then
		if arg1.cmd == 1 then
			local var17, var18 = getActivityTask(arg3)

			if var18 and not var18:isReceive() then
				local var19 = arg3:getConfig("config_data")

				for iter4, iter5 in ipairs(var19) do
					local var20 = _.flatten({
						iter5
					})

					if table.contains(var20, var17) then
						arg3.data3 = iter4

						break
					end
				end
			end
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_TASK_RES then
		if arg1.cmd == 1 then
			local var21, var22 = getActivityTask(arg3)

			if var22 and not var22:isReceive() then
				local var23 = arg3:getConfig("config_data")

				for iter6, iter7 in ipairs(var23) do
					local var24 = _.flatten({
						iter7
					})

					if table.contains(var24, var21) then
						arg3.data3 = iter6

						break
					end
				end
			end
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_PUZZLA then
		if arg1.cmd == 1 then
			arg3.data1 = 1
		elseif arg1.cmd == 4 then
			arg3.data1 = 2
		end

		getProxy(ActivityProxy):updateActivity(arg3)
	elseif var0 == ActivityConst.ACTIVITY_TYPE_BB then
		arg3.data1 = arg3.data1 + 1
		arg3.data2 = arg3.data2 - 1
		arg3.data1_list = arg2.number
	elseif var0 == ActivityConst.ACTIVITY_TYPE_LOTTERY then
		if arg1.cmd == 1 then
			local var25 = ActivityItemPool.New({
				id = arg1.arg2
			})
			local var26 = var25:getComsume()
			local var27 = arg1.arg1 * var26.count

			if var26.type == DROP_TYPE_RESOURCE then
				local var28 = var1:getData()

				var28:consume({
					[id2res(var26.id)] = var27
				})
				var1:updatePlayer(var28)
			elseif var26.type == DROP_TYPE_ITEM then
				getProxy(BagProxy):removeItemById(var26.id, var27)
			end

			arg3:updateData(var25.id, arg2.number)
		elseif arg1.cmd == 2 then
			arg3.data1 = arg1.arg1
		elseif arg1.cmd == 3 then
			arg3.data2_list = _.map(arg1.arg_list, function(arg0)
				return arg0
			end)
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_CARD_PAIRS or var0 == ActivityConst.ACTIVITY_TYPE_LINK_LINK then
		if arg1.cmd == 1 then
			local var29 = arg3:getConfig("config_data")[4]

			if #arg4 > 0 then
				arg3.data2 = arg3.data2 + 1

				if var29 <= arg3.data2 then
					arg3.data1 = 1
				end
			end

			if arg3.data4 == 0 then
				arg3.data4 = arg1.arg2
			elseif arg1.arg2 < arg3.data4 then
				arg3.data4 = arg1.arg2
			end
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_REFLUX then
		if arg1.cmd == 1 then
			arg3.data1_list[1] = pg.TimeMgr.GetInstance():GetServerTime()
			arg3.data1_list[2] = arg3.data1_list[2] + 1
		elseif arg1.cmd == 2 then
			arg3.data4 = arg1.arg1
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD then
		if arg1.cmd == 1 then
			arg3.data1 = arg3.data1 + 1
			arg3.data2 = arg2.number[1]
		elseif arg1.cmd == 2 then
			table.insert(arg3.data1_list, arg3.data1)
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_DODGEM then
		if arg1.cmd == 1 then
			arg0:sendNotification(GAME.FINISH_STAGE_DONE, {
				statistics = arg1.statistics,
				score = arg1.statistics._battleScore,
				system = SYSTEM_DODGEM
			})

			arg3.data1_list[1] = math.max(arg3.data1_list[1], arg1.arg2)
			arg3.data2_list[1] = arg2.number[1]
			arg3.data2_list[2] = arg2.number[2]
		elseif arg1.cmd == 2 then
			arg3.data2 = arg2.number[1]
			arg3.data3 = arg2.number[2]
			arg3.data2_list[1] = 0
			arg3.data2_list[2] = 0
		elseif arg1.cmd == 3 then
			arg3.data4 = defaultValue(arg3.data4, 0) + 1
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_SUBMARINE_RUN then
		if arg1.cmd == 1 then
			arg0:sendNotification(GAME.FINISH_STAGE_DONE, {
				statistics = arg1.statistics,
				score = arg1.statistics._battleScore,
				system = SYSTEM_SUBMARINE_RUN
			})

			arg3.data1_list[1] = math.max(arg3.data1_list[1], arg1.arg2)
			arg3.data2_list[1] = arg2.number[1]
			arg3.data2_list[2] = arg2.number[2]
		elseif arg1.cmd == 2 then
			arg3.data2 = arg2.number[1]
			arg3.data3 = arg2.number[2]
			arg3.data2_list[1] = 0
			arg3.data2_list[2] = 0
		elseif arg1.cmd == 3 then
			arg3.data4 = defaultValue(arg3.data4, 0) + 1
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_TURNTABLE then
		if arg1.cmd == 2 then
			arg3.data4 = 0
		elseif arg1.cmd == 1 then
			local var30 = arg3:getConfig("config_id")
			local var31 = pg.activity_event_turning[var30].total_num

			if arg3.data3 == var31 then
				arg3.data2 = 1
				arg3.data3 = arg3.data3 + 1
			else
				arg3.data3 = arg3.data3 + 1
				arg3.data4 = arg2.number[1]
				arg3.data1_list[arg1.arg1] = arg3.data4
			end
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_SHRINE then
		arg3.data1 = 1
	elseif var0 == ActivityConst.ACTIVITY_TYPE_RED_PACKETS then
		arg3.data1 = arg3.data1 - 1

		if arg3.data2 > 0 then
			arg3.data2 = arg3.data2 - 1
		end

		arg3.data1_list[2] = arg3.data1_list[2] + 1

		local var32 = getProxy(ActivityProxy)
		local var33 = var32:getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

		if var33 and not var33:isEnd() and var33.data2_list[1] > var33.data2_list[2] then
			var33.data2_list[2] = var33.data2_list[2] + 1

			var32:updateActivity(var33)
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_RED_PACKET_LOTTER then
		arg3.data1 = arg3.data1 + 1

		if not table.contains(arg3.data2_list, arg1.arg1) then
			table.insert(arg3.data2_list, arg1.arg1)
		end

		if not table.contains(arg3.data1_list, arg2.number[1]) then
			table.insert(arg3.data1_list, arg2.number[1])
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF or var0 == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
		if arg1.cmd == 1 then
			local var34 = pg.activity_event_building[arg1.arg1]
			local var35 = arg3:GetBuildingLevel(arg1.arg1)

			arg3:SetBuildingLevel(arg1.arg1, var35 + 1)

			if var35 < #var34.buff then
				_.each(var34.material[var35], function(arg0)
					local var0 = arg0[1]
					local var1 = arg0[2]
					local var2 = arg0[3]
					local var3

					if var0 == DROP_TYPE_VITEM then
						local var4 = AcessWithinNull(Item.getConfigData(var1), "link_id")

						assert(var4 == arg3.id)

						var3 = arg3
					elseif var0 > DROP_TYPE_USE_ACTIVITY_DROP then
						local var5 = AcessWithinNull(pg.activity_drop_type[var0], "activity_id")

						var3 = getProxy(ActivityProxy):getActivityById(var5)
					end

					local var6 = var3.data1KeyValueList[1][var1] or 0
					local var7 = math.max(0, var6 - var2)

					var3.data1KeyValueList[1][var1] = var7

					if var0 > DROP_TYPE_USE_ACTIVITY_DROP then
						getProxy(ActivityProxy):updateActivity(var3)
					end
				end)
			end
		elseif arg1.cmd == 2 and var0 == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
			arg3:RecordLastRequestTime()
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_EXPEDITION then
		if arg1.cmd == 0 then
			return arg3
		end

		if arg1.cmd == 3 then
			arg0:sendNotification(GAME.FINISH_STAGE_DONE, {
				statistics = arg1.statistics,
				score = arg1.statistics._battleScore,
				system = SYSTEM_REWARD_PERFORM
			})

			return arg3
		end

		if arg1.cmd == 4 then
			arg3.data2_list[1] = arg3.data2_list[1] + 1

			return arg3
		end

		if arg1.cmd == 1 then
			arg3.data3 = arg3.data3 - 1
		end

		local var36 = arg1.arg1

		if arg1.cmd ~= 2 then
			arg3.data2 = var36
		end

		local var37 = arg2.number[1]

		arg3.data1_list[var36] = var37

		print("格子:" .. var36 .. " 值:" .. arg2.number[1])

		if arg2.number[2] and arg3.data1 ~= arg2.number[2] then
			print("关卡变更" .. arg2.number[2])

			arg3.data1 = arg3.data1 + 1
			arg3.data2 = 0

			for iter8 = 1, #arg3.data1_list do
				arg3.data1_list[iter8] = 0
			end
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE then
		if arg1.cmd == 1 then
			arg0:sendNotification(GAME.FINISH_STAGE_DONE, {
				statistics = arg1.statistics,
				score = arg1.statistics._battleScore,
				system = SYSTEM_AIRFIGHT
			})

			arg3.data1KeyValueList[1] = arg3.data1KeyValueList[1] or {}
			arg3.data1KeyValueList[1][arg1.arg1] = (arg3.data1KeyValueList[1][arg1.arg1] or 0) + 1
		elseif arg1.cmd == 2 then
			arg3.data1KeyValueList[2] = arg3.data1KeyValueList[2] or {}
			arg3.data1KeyValueList[2][arg1.arg1] = 1
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS then
		if arg1.cmd == 1 then
			arg3.data1 = arg3.data1 - 1

			local var38 = arg2.number[1]

			arg3.data1KeyValueList[1][var38] = arg3.data1KeyValueList[1][var38] + 1
		elseif arg1.cmd == 2 then
			arg3.data2 = 1
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_PT_OTHER then
		if arg1.cmd == 1 then
			arg3.data2 = 1
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
		if arg1.cmd == SpringActivity.OPERATION_UNLOCK then
			arg3:AddSlotCount()
		elseif arg1.cmd == SpringActivity.OPERATION_SETSHIP then
			arg3:SetShipIds(arg1.kvargs1)
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_HOTSPRING_2 then
		if arg1.cmd == Spring2Activity.OPERATION_SETSHIP then
			arg3:SetShipIds(arg1.kvargs1)
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_FIREWORK then
		if arg1.cmd == 1 then
			arg3.data1 = arg3.data1 - 1

			if not table.contains(arg3.data1_list, arg1.arg1) then
				table.insert(arg3.data1_list, arg1.arg1)
			end

			local var39 = Item.getConfigData(arg1.arg1).link_id

			if var39 > 0 then
				local var40 = getProxy(ActivityProxy)
				local var41 = var40:getActivityById(var39)

				if var41 and not var41:isEnd() then
					var41.data1 = var41.data1 + 1

					var40:updateActivity(var41)
				end
			end

			local var42 = getProxy(PlayerProxy)
			local var43 = var42:getRawData()
			local var44 = arg3:getConfig("config_data")[2][1]
			local var45 = arg3:getConfig("config_data")[2][2]

			var43:consume({
				[id2res(var44)] = var45
			})
			var42:updatePlayer(var43)
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_CARD_PUZZLE then
		if not table.contains(arg3.data1_list, arg1.arg1) then
			table.insert(arg3.data1_list, arg1.arg1)
		end
	elseif var0 == ActivityConst.ACTIVITY_TYPE_ZUMA then
		if arg1.cmd == 1 then
			if arg1.arg1 == LaunchBallGameConst.round_type_juqing then
				arg3.data1 = arg3.data1 + 1
			elseif arg1.arg1 == 2 then
				if not arg3.data1_list then
					arg3.data1_list = {}
				end

				table.insert(arg3.data1_list, arg1.arg2)
			elseif arg1.arg1 == 3 then
				arg3.data2 = arg1.arg2
			end
		elseif arg1.cmd == 2 then
			arg3.data3 = 1
		end

		getProxy(ActivityProxy):updateActivity(arg3)
	end

	return arg3
end

function var0.performance(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg3:getConfig("type")
	local var1

	local function var2()
		if var1 and coroutine.status(var1) == "suspended" then
			local var0, var1 = coroutine.resume(var1)

			assert(var0, var1)
		end
	end

	var1 = coroutine.create(function()
		if var0 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
			local var0 = arg3:getConfig("config_client").story

			if var0 and var0[arg3.data1] and var0[arg3.data1][1] then
				pg.NewStoryMgr.GetInstance():Play(var0[arg3.data1][1], var2)
				coroutine.yield()
			end
		elseif var0 == ActivityConst.ACTIVITY_TYPE_BB then
			local var1 = pg.gameset.bobing_memory.description[arg3.data1]

			if var1 and #var1 > 0 then
				pg.NewStoryMgr.GetInstance():Play(var1, var2)
				coroutine.yield()
			end

			arg0:sendNotification(ActivityProxy.ACTIVITY_SHOW_BB_RESULT, {
				numbers = arg2.number,
				callback = var2,
				awards = arg4
			})
			coroutine.yield()
		elseif var0 == ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD then
			if arg1.cmd == 1 then
				local var2 = arg3:getConfig("config_client").story

				if var2 and var2[arg3.data1] and var2[arg3.data1][1] then
					pg.NewStoryMgr.GetInstance():Play(var2[arg3.data1][1], var2)
					coroutine.yield()
				end

				arg0:sendNotification(ActivityProxy.ACTIVITY_SHOW_LOTTERY_AWARD_RESULT, {
					activityID = arg3.id,
					awards = arg4,
					number = arg2.number[1],
					callback = var2
				})

				arg4 = {}

				coroutine.yield()
			end
		elseif var0 == ActivityConst.ACTIVITY_TYPE_CARD_PAIRS or var0 == ActivityConst.ACTIVITY_TYPE_LINK_LINK then
			if arg3:getConfig("config_client")[1] then
				local var3 = arg3:getConfig("config_client")[1][arg3.data2 + 1]

				if var3 then
					pg.NewStoryMgr.GetInstance():Play(var3, var2)
					coroutine.yield()
				end
			end
		elseif var0 == ActivityConst.ACTIVITY_TYPE_DODGEM or var0 == ActivityConst.ACTIVITY_TYPE_SUBMARINE_RUN then
			if arg1.cmd == 2 and arg2.number[3] > 0 then
				local var4 = arg3:getConfig("config_client")[1]
				local var5 = {
					type = var4[1],
					id = var4[2],
					count = var4[3]
				}

				table.insert(arg4, var5)
			end
		elseif var0 == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF or var0 == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
			if arg1.cmd == 1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("building_complete_tip"))
			end
		elseif var0 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
			if arg1.cmd == 3 then
				local var6 = arg3:getSpecialData("month_sign_awards") or {}

				for iter0 = 1, #arg4 do
					table.insert(var6, arg4[iter0])
				end

				arg3:setSpecialData("month_sign_awards", var6)

				arg4 = {}
			end
		elseif var0 == ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS then
			if arg1.cmd == 1 then
				arg0:sendNotification(ActivityProxy.ACTIVITY_SHOW_SHAKE_BEADS_RESULT, {
					number = arg2.number[1],
					callback = var2,
					awards = arg4
				})
				coroutine.yield()
			end
		elseif var0 == ActivityConst.ACTIVITY_TYPE_APRIL_REWARD then
			if arg1.cmd == 1 then
				arg3.data1 = arg1.arg1
			elseif arg1.cmd == 2 then
				arg3.data2 = 1
			end
		elseif var0 == ActivityConst.ACTIVITY_TYPE_FIREWORK then
			pg.TipsMgr.GetInstance():ShowTips(i18n("activity_yanhua_tip8"))

			local var7 = #arg3:getData1List()
			local var8 = arg3:getConfig("config_client").story

			if var8 and type(var8) == "table" then
				for iter1, iter2 in ipairs(var8) do
					if var7 == iter2[1] then
						pg.NewStoryMgr.GetInstance():Play(iter2[2], var2)
						coroutine.yield()
					end
				end
			end
		end

		if #arg4 > 0 then
			arg0:sendNotification(arg3:getNotificationMsg(), {
				activityId = arg1.activity_id,
				awards = arg4,
				callback = var2
			})
			coroutine.yield()
		end

		if var0 == 17 and arg1.cmd and arg1.cmd == 2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("mingshi_get_tip"))
		end

		getProxy(ActivityProxy):updateActivity(arg3)
		arg0:sendNotification(ActivityProxy.ACTIVITY_OPERATION_DONE, arg1.activity_id)
	end)

	var2()
end

return var0
