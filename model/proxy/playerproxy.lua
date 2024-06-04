local var0 = class("PlayerProxy", import(".NetProxy"))

var0.UPDATED = "PlayerProxy.UPDATED"

function var0.register(arg0)
	arg0._flags = {}
	arg0.combatFleetId = 1
	arg0.mainBGShiftFlag = false
	arg0.inited = false
	arg0.botHelp = false
	arg0.playerAssists = {}
	arg0.playerGuildAssists = {}
	arg0.summaryInfo = nil

	arg0:on(11000, function(arg0)
		arg0:sendNotification(GAME.TIME_SYNCHRONIZATION, arg0)
	end)
	arg0:on(11003, function(arg0)
		local var0 = Player.New(arg0)

		var0.resUpdateTm = pg.TimeMgr.GetInstance():GetServerTime()

		arg0:updatePlayer(var0)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inAdmiral")
		pg.NewStoryMgr.GetInstance():SetData(arg0.story_list or {})
		print("days from regist time to new :" .. arg0.data:GetDaysFromRegister())

		if arg0.data:GetDaysFromRegister() == 1 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_2D_RETENTION)
		elseif arg0.data:GetDaysFromRegister() == 6 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_7D_RETENTION)
		end

		arg0:flushTimesListener()
	end)
	arg0:on(11004, function(arg0)
		if not arg0.data then
			return
		end

		local var0 = arg0.data:clone()

		var0:updateResources(arg0.resource_list)

		var0.resUpdateTm = pg.TimeMgr.GetInstance():GetServerTime()

		arg0:updatePlayer(var0)

		if arg0.data:isFull() then
			-- block empty
		end
	end)
	arg0:on(10999, function(arg0)
		if arg0.reason == LOGOUT_NEW_VERSION then
			getProxy(SettingsProxy).lastRequestVersionTime = nil
		else
			arg0:sendNotification(GAME.LOGOUT, {
				code = arg0.reason
			})
		end
	end)
	arg0:on(11015, function(arg0)
		local var0 = arg0.data:clone()

		var0.buff_list = {}

		for iter0, iter1 in ipairs(arg0.buff_list) do
			local var1 = {
				id = iter1.id,
				timestamp = iter1.timestamp
			}

			table.insert(var0.buff_list, var1)
		end

		arg0:updatePlayer(var0)
	end)
	arg0:on(11503, function(arg0)
		getProxy(ShopsProxy):removeChargeTimer(arg0.pay_id)
		arg0:sendNotification(GAME.CHARGE_SUCCESS, {
			shopId = arg0.shop_id,
			payId = arg0.pay_id,
			gem = arg0.gem,
			gem_free = arg0.gem_free
		})
	end)
	arg0:on(11802, function(arg0)
		local var0 = arg0.data:clone()

		var0:SetCommonFlag(arg0.id, arg0.value == 1)
		arg0:updatePlayer(var0)
	end)
end

function var0.remove(arg0)
	arg0:clearTimesListener()
end

function var0.getSummaryInfo(arg0)
	return arg0.summaryInfo
end

function var0.setSummaryInfo(arg0, arg1)
	arg0.summaryInfo = arg1
end

function var0.flushTimesListener(arg0)
	arg0:clearTimesListener()

	local var0 = pg.TimeMgr.GetInstance()

	arg0.fourClockId = var0:AddTimer("daily_four", var0:GetNextTime(4, 0, 0) - var0:GetServerTime(), 86400, function()
		arg0:sendNotification(GAME.FOUR_HOUR)
	end)
end

function var0.clearTimesListener(arg0)
	if arg0.fourClockId then
		pg.TimeMgr.GetInstance():RemoveTimer(arg0.fourClockId)

		arg0.fourClockId = nil
	end
end

function var0.updatePlayer(arg0, arg1)
	assert(isa(arg1, Player), "should be an instance of Player")

	if arg0.data then
		arg0:sendNotification(GAME.ON_PLAYER_RES_CHANGE, {
			oldPlayer = arg0.data,
			newPlayer = arg1
		})
	end

	arg0.data = arg1:clone()

	arg0.data:display("updated")
	arg0:sendNotification(var0.UPDATED, arg1:clone())
end

function var0.UpdatePlayerRes(arg0, arg1)
	if not arg0.data then
		return
	end

	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg1) do
		local var2 = id2res(iter1.id)

		if iter1.count < 0 then
			var1[var2] = defaultValue(var1[var2], 0) - iter1.count
		else
			var0[var2] = defaultValue(var0[var2], 0) + iter1.count
		end
	end

	arg0.data:addResources(var0)
	arg0.data:consume(var1)
	arg0:updatePlayer(arg0.data)
end

function var0.updatePlayerMedalDisplay(arg0, arg1)
	arg0.data.displayTrophyList = arg1
end

function var0.getPlayerId(arg0)
	return arg0.data.id
end

function var0.setFlag(arg0, arg1, arg2)
	arg0._flags[arg1] = arg2
end

function var0.getFlag(arg0, arg1)
	return arg0._flags[arg1]
end

function var0.isSelf(arg0, arg1)
	return arg0.data.id == arg1
end

function var0.setInited(arg0, arg1)
	arg0.inited = arg1
end

function var0.getInited(arg0)
	return arg0.inited
end

function var0.setRefundInfo(arg0, arg1)
	local var0

	if arg1 and #arg1 > 0 then
		var0 = {}

		for iter0, iter1 in ipairs(arg1) do
			table.insert(var0, {
				shopId = iter1.shop_id,
				buyTime = iter1.buy_time,
				refundTime = iter1.refund_time
			})
		end
	end

	arg0.refundInfo = var0
end

function var0.getRefundInfo(arg0)
	if not arg0.refundInfo then
		return nil
	end

	if #arg0.refundInfo <= 0 then
		return nil
	end

	return arg0.refundInfo
end

function var0.IsShowCommssionTip(arg0)
	local var0 = getProxy(EventProxy):hasFinishState()
	local var1 = getProxy(NavalAcademyProxy)
	local var2 = arg0:getRawData()
	local var3 = var1:GetOilVO()
	local var4 = var1:GetGoldVO()
	local var5 = var1:GetClassVO()
	local var6 = var3:isCommissionNotify(var2.oilField)
	local var7 = var4:isCommissionNotify(var2.goldField)
	local var8 = var5:GetGenResCnt()
	local var9 = var5:GetEffectAttrs()
	local var10 = 0

	for iter0, iter1 in ipairs(var9) do
		if iter1.attrName == "stock" then
			var10 = iter1.value
		end
	end

	local var11 = NotifyTipHelper.ShouldShowUrTip()
	local var12 = var1:getStudents()
	local var13 = 0

	_.each(_.values(var12), function(arg0)
		if arg0:getFinishTime() <= pg.TimeMgr.GetInstance():GetServerTime() then
			var13 = var13 + 1
		end
	end)

	local var14 = 0

	_.each(getProxy(TechnologyProxy):getPlanningTechnologys(), function(arg0)
		if arg0:isCompleted() then
			var14 = var14 + 1
		end
	end)

	local var15 = WorldBossConst.GetCommissionSceneMetaBossBtnState()
	local var16 = CommissionMetaBossBtn.STATE_GET_AWARDS == var15 or CommissionMetaBossBtn.STATE_FINSH_BATTLE == var15
	local var17 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)
	local var18 = false

	if var17 and not var17:isEnd() then
		var18 = #var17:GetCrusingUnreceiveAward() > 0
	end

	return var16 or var0 or var6 or var7 or var10 ~= 0 and var8 > var10 - 10 or var11 or var13 > 0 or var14 > 0 or var18
end

return var0
