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

		arg0_1:flushTimesListener()
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

function var0_0.remove(arg0_9)
	arg0_9:clearTimesListener()
end

function var0_0.getSummaryInfo(arg0_10)
	return arg0_10.summaryInfo
end

function var0_0.setSummaryInfo(arg0_11, arg1_11)
	arg0_11.summaryInfo = arg1_11
end

function var0_0.flushTimesListener(arg0_12)
	arg0_12:clearTimesListener()

	local var0_12 = pg.TimeMgr.GetInstance()

	arg0_12.fourClockId = var0_12:AddTimer("daily_four", var0_12:GetNextTime(4, 0, 0) - var0_12:GetServerTime(), 86400, function()
		arg0_12:sendNotification(GAME.FOUR_HOUR)
	end)
end

function var0_0.clearTimesListener(arg0_14)
	if arg0_14.fourClockId then
		pg.TimeMgr.GetInstance():RemoveTimer(arg0_14.fourClockId)

		arg0_14.fourClockId = nil
	end
end

function var0_0.updatePlayer(arg0_15, arg1_15)
	assert(isa(arg1_15, Player), "should be an instance of Player")

	if arg0_15.data then
		arg0_15:sendNotification(GAME.ON_PLAYER_RES_CHANGE, {
			oldPlayer = arg0_15.data,
			newPlayer = arg1_15
		})
	end

	arg0_15.data = arg1_15:clone()

	arg0_15.data:display("updated")
	arg0_15:sendNotification(var0_0.UPDATED, arg1_15:clone())
end

function var0_0.UpdatePlayerRes(arg0_16, arg1_16)
	if not arg0_16.data then
		return
	end

	local var0_16 = {}
	local var1_16 = {}

	for iter0_16, iter1_16 in ipairs(arg1_16) do
		local var2_16 = id2res(iter1_16.id)

		if iter1_16.count < 0 then
			var1_16[var2_16] = defaultValue(var1_16[var2_16], 0) - iter1_16.count
		else
			var0_16[var2_16] = defaultValue(var0_16[var2_16], 0) + iter1_16.count
		end
	end

	arg0_16.data:addResources(var0_16)
	arg0_16.data:consume(var1_16)
	arg0_16:updatePlayer(arg0_16.data)
end

function var0_0.updatePlayerMedalDisplay(arg0_17, arg1_17)
	arg0_17.data.displayTrophyList = arg1_17
end

function var0_0.getPlayerId(arg0_18)
	return arg0_18.data.id
end

function var0_0.setFlag(arg0_19, arg1_19, arg2_19)
	arg0_19._flags[arg1_19] = arg2_19
end

function var0_0.getFlag(arg0_20, arg1_20)
	return arg0_20._flags[arg1_20]
end

function var0_0.isSelf(arg0_21, arg1_21)
	return arg0_21.data.id == arg1_21
end

function var0_0.setInited(arg0_22, arg1_22)
	arg0_22.inited = arg1_22
end

function var0_0.getInited(arg0_23)
	return arg0_23.inited
end

function var0_0.setRefundInfo(arg0_24, arg1_24)
	local var0_24

	if arg1_24 and #arg1_24 > 0 then
		var0_24 = {}

		for iter0_24, iter1_24 in ipairs(arg1_24) do
			table.insert(var0_24, {
				shopId = iter1_24.shop_id,
				buyTime = iter1_24.buy_time,
				refundTime = iter1_24.refund_time
			})
		end
	end

	arg0_24.refundInfo = var0_24
end

function var0_0.getRefundInfo(arg0_25)
	if not arg0_25.refundInfo then
		return nil
	end

	if #arg0_25.refundInfo <= 0 then
		return nil
	end

	return arg0_25.refundInfo
end

function var0_0.IsShowCommssionTip(arg0_26)
	local var0_26 = getProxy(EventProxy):hasFinishState()
	local var1_26 = getProxy(NavalAcademyProxy)
	local var2_26 = arg0_26:getRawData()
	local var3_26 = var1_26:GetOilVO()
	local var4_26 = var1_26:GetGoldVO()
	local var5_26 = var1_26:GetClassVO()
	local var6_26 = var3_26:isCommissionNotify(var2_26.oilField)
	local var7_26 = var4_26:isCommissionNotify(var2_26.goldField)
	local var8_26 = var5_26:GetGenResCnt()
	local var9_26 = var5_26:GetEffectAttrs()
	local var10_26 = 0

	for iter0_26, iter1_26 in ipairs(var9_26) do
		if iter1_26.attrName == "stock" then
			var10_26 = iter1_26.value
		end
	end

	local var11_26 = NotifyTipHelper.ShouldShowUrTip()
	local var12_26 = var1_26:getStudents()
	local var13_26 = 0

	_.each(_.values(var12_26), function(arg0_27)
		if arg0_27:getFinishTime() <= pg.TimeMgr.GetInstance():GetServerTime() then
			var13_26 = var13_26 + 1
		end
	end)

	local var14_26 = 0

	_.each(getProxy(TechnologyProxy):getPlanningTechnologys(), function(arg0_28)
		if arg0_28:isCompleted() then
			var14_26 = var14_26 + 1
		end
	end)

	local var15_26 = WorldBossConst.GetCommissionSceneMetaBossBtnState()
	local var16_26 = CommissionMetaBossBtn.STATE_GET_AWARDS == var15_26 or CommissionMetaBossBtn.STATE_FINSH_BATTLE == var15_26
	local var17_26 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)
	local var18_26 = false

	if var17_26 and not var17_26:isEnd() then
		var18_26 = #var17_26:GetCrusingUnreceiveAward() > 0
	end

	return var16_26 or var0_26 or var6_26 or var7_26 or var10_26 ~= 0 and var8_26 > var10_26 - 10 or var11_26 or var13_26 > 0 or var14_26 > 0 or var18_26
end

return var0_0
