local var0_0 = class("PlayerProxy", import(".NetProxy"))

var0_0.UPDATED = "PlayerProxy.UPDATED"

function var0_0.register(arg0_1)
	arg0_1._flags = {}
	arg0_1.combatFleetId = 1
	arg0_1.mainBGShiftFlag = false
	arg0_1.inited = false
	arg0_1.botHelp = false
	arg0_1.playerAssists = {}
	arg0_1.playerGuildAssists = {}
	arg0_1.summaryInfo = nil

	arg0_1:on(11000, function(arg0_2)
		arg0_1:sendNotification(GAME.TIME_SYNCHRONIZATION, arg0_2)
	end)
	arg0_1:on(11003, function(arg0_3)
		local var0_3 = Player.New(arg0_3)

		var0_3.resUpdateTm = pg.TimeMgr.GetInstance():GetServerTime()

		arg0_1:updatePlayer(var0_3)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inAdmiral")
		pg.NewStoryMgr.GetInstance():SetData(arg0_3.story_list or {})
		print("days from regist time to new :" .. arg0_1.data:GetDaysFromRegister())

		if arg0_1.data:GetDaysFromRegister() == 1 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_2D_RETENTION)
		elseif arg0_1.data:GetDaysFromRegister() == 6 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_7D_RETENTION)
		end
	end)
	arg0_1:on(11004, function(arg0_4)
		if not arg0_1.data then
			return
		end

		local var0_4 = arg0_1.data:clone()

		var0_4:updateResources(arg0_4.resource_list)

		var0_4.resUpdateTm = pg.TimeMgr.GetInstance():GetServerTime()

		arg0_1:updatePlayer(var0_4)

		if arg0_1.data:isFull() then
			-- block empty
		end
	end)
	arg0_1:on(10999, function(arg0_5)
		if arg0_5.reason == LOGOUT_NEW_VERSION then
			getProxy(SettingsProxy).lastRequestVersionTime = nil
		else
			arg0_1:sendNotification(GAME.LOGOUT, {
				code = arg0_5.reason
			})
		end
	end)
	arg0_1:on(11015, function(arg0_6)
		local var0_6 = arg0_1.data:clone()

		var0_6.buff_list = {}

		for iter0_6, iter1_6 in ipairs(arg0_6.buff_list) do
			local var1_6 = {
				id = iter1_6.id,
				timestamp = iter1_6.timestamp
			}

			table.insert(var0_6.buff_list, var1_6)
		end

		arg0_1:updatePlayer(var0_6)
	end)
	arg0_1:on(11503, function(arg0_7)
		getProxy(ShopsProxy):removeChargeTimer(arg0_7.pay_id)
		arg0_1:sendNotification(GAME.CHARGE_SUCCESS, {
			shopId = arg0_7.shop_id,
			payId = arg0_7.pay_id,
			gem = arg0_7.gem,
			gem_free = arg0_7.gem_free
		})
	end)
	arg0_1:on(11802, function(arg0_8)
		local var0_8 = arg0_1.data:clone()

		var0_8:SetCommonFlag(arg0_8.id, arg0_8.value == 1)
		arg0_1:updatePlayer(var0_8)
	end)
end

function var0_0.timeCall(arg0_9)
	return {
		[ProxyRegister.DayCall] = function(arg0_10)
			local var0_10 = arg0_9:getData()

			var0_10:resetBuyOilCount()

			for iter0_10, iter1_10 in pairs(var0_10.vipCards) do
				if iter1_10:isExpire() then
					var0_10.vipCards[iter1_10.id] = nil
				end
			end

			arg0_9:updatePlayer(var0_10)
		end
	}
end

function var0_0.remove(arg0_11)
	return
end

function var0_0.getSummaryInfo(arg0_12)
	return arg0_12.summaryInfo
end

function var0_0.setSummaryInfo(arg0_13, arg1_13)
	arg0_13.summaryInfo = arg1_13
end

function var0_0.updatePlayer(arg0_14, arg1_14)
	assert(isa(arg1_14, Player), "should be an instance of Player")

	if arg0_14.data then
		arg0_14:sendNotification(GAME.ON_PLAYER_RES_CHANGE, {
			oldPlayer = arg0_14.data,
			newPlayer = arg1_14
		})
	end

	arg0_14.data = arg1_14:clone()

	arg0_14.data:display("updated")
	arg0_14:sendNotification(var0_0.UPDATED, arg1_14:clone())
end

function var0_0.UpdatePlayerRes(arg0_15, arg1_15)
	if not arg0_15.data then
		return
	end

	local var0_15 = {}
	local var1_15 = {}

	for iter0_15, iter1_15 in ipairs(arg1_15) do
		local var2_15 = id2res(iter1_15.id)

		if iter1_15.count < 0 then
			var1_15[var2_15] = defaultValue(var1_15[var2_15], 0) - iter1_15.count
		else
			var0_15[var2_15] = defaultValue(var0_15[var2_15], 0) + iter1_15.count
		end
	end

	arg0_15.data:addResources(var0_15)
	arg0_15.data:consume(var1_15)
	arg0_15:updatePlayer(arg0_15.data)
end

function var0_0.updatePlayerMedalDisplay(arg0_16, arg1_16)
	arg0_16.data.displayTrophyList = arg1_16
end

function var0_0.getPlayerId(arg0_17)
	return arg0_17.data.id
end

function var0_0.setFlag(arg0_18, arg1_18, arg2_18)
	arg0_18._flags[arg1_18] = arg2_18
end

function var0_0.getFlag(arg0_19, arg1_19)
	return arg0_19._flags[arg1_19]
end

function var0_0.isSelf(arg0_20, arg1_20)
	return arg0_20.data.id == arg1_20
end

function var0_0.setInited(arg0_21, arg1_21)
	arg0_21.inited = arg1_21
end

function var0_0.getInited(arg0_22)
	return arg0_22.inited
end

function var0_0.setRefundInfo(arg0_23, arg1_23)
	local var0_23

	if arg1_23 and #arg1_23 > 0 then
		var0_23 = {}

		for iter0_23, iter1_23 in ipairs(arg1_23) do
			table.insert(var0_23, {
				shopId = iter1_23.shop_id,
				buyTime = iter1_23.buy_time,
				refundTime = iter1_23.refund_time
			})
		end
	end

	arg0_23.refundInfo = var0_23
end

function var0_0.getRefundInfo(arg0_24)
	if not arg0_24.refundInfo then
		return nil
	end

	if #arg0_24.refundInfo <= 0 then
		return nil
	end

	return arg0_24.refundInfo
end

function var0_0.IsShowCommssionTip(arg0_25)
	local var0_25 = getProxy(EventProxy):hasFinishState()
	local var1_25 = getProxy(NavalAcademyProxy)
	local var2_25 = arg0_25:getRawData()
	local var3_25 = var1_25:GetOilVO()
	local var4_25 = var1_25:GetGoldVO()
	local var5_25 = var1_25:GetClassVO()
	local var6_25 = var3_25:isCommissionNotify(var2_25.oilField)
	local var7_25 = var4_25:isCommissionNotify(var2_25.goldField)
	local var8_25 = var5_25:GetGenResCnt()
	local var9_25 = var5_25:GetEffectAttrs()
	local var10_25 = 0

	for iter0_25, iter1_25 in ipairs(var9_25) do
		if iter1_25.attrName == "stock" then
			var10_25 = iter1_25.value
		end
	end

	local var11_25 = NotifyTipHelper.ShouldShowUrTip()
	local var12_25 = var1_25:getStudents()
	local var13_25 = 0

	_.each(_.values(var12_25), function(arg0_26)
		if arg0_26:getFinishTime() <= pg.TimeMgr.GetInstance():GetServerTime() then
			var13_25 = var13_25 + 1
		end
	end)

	local var14_25 = 0

	_.each(getProxy(TechnologyProxy):getPlanningTechnologys(), function(arg0_27)
		if arg0_27:isCompleted() then
			var14_25 = var14_25 + 1
		end
	end)

	local var15_25 = WorldBossConst.GetCommissionSceneMetaBossBtnState()
	local var16_25 = CommissionMetaBossBtn.STATE_GET_AWARDS == var15_25 or CommissionMetaBossBtn.STATE_FINSH_BATTLE == var15_25
	local var17_25 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)
	local var18_25 = false

	if var17_25 and not var17_25:isEnd() then
		var18_25 = #var17_25:GetCrusingUnreceiveAward() > 0
	end

	return var16_25 or var0_25 or var6_25 or var7_25 or var10_25 ~= 0 and var8_25 > var10_25 - 10 or var11_25 or var13_25 > 0 or var14_25 > 0 or var18_25
end

return var0_0
