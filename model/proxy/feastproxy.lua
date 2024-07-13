local var0_0 = class("FeastProxy", import("model.proxy.NetProxy"))

function var0_0.register(arg0_1)
	return
end

local function var1_0(arg0_2, arg1_2, arg2_2)
	if arg0_2:getRawData() ~= nil then
		arg2_2()

		return
	end

	arg0_2:sendNotification(GAME.GET_FEAST_DATA, {
		activityId = arg1_2.id,
		callback = arg2_2
	})
end

local function var2_0(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg1_3:getConfig("config_data")
	local var1_3 = var0_3[1] or 5

	if not arg0_3:getRawData():ShouldRandomShips() then
		arg2_3()

		return
	end

	local var2_3 = var0_3[3] or {}
	local var3_3 = arg0_3:RandomShips(var2_3, var1_3)
	local var4_3 = _.map(var3_3, function(arg0_4)
		return arg0_4.id
	end)

	arg0_3:sendNotification(GAME.FEAST_OP, {
		activityId = arg1_3.id,
		cmd = FeastDorm.OP_RANDOM_SHIPS,
		argList = var4_3,
		callback = arg2_3
	})
end

function var0_0.RequestData(arg0_5, arg1_5)
	local var0_5 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

	if not var0_5 or var0_5:isEnd() then
		arg1_5()

		return
	end

	seriesAsync({
		function(arg0_6)
			var1_0(arg0_5, var0_5, arg0_6)
		end,
		function(arg0_7)
			var2_0(arg0_5, var0_5, arg0_7)
		end
	}, arg1_5)
end

function var0_0.SetData(arg0_8, arg1_8)
	assert(isa(arg1_8, FeastDorm))

	arg0_8.data = arg1_8

	arg0_8:AddRefreshTimer()
end

function var0_0.UpdateData(arg0_9, arg1_9)
	assert(isa(arg1_9, FeastDorm))

	arg0_9.data = arg1_9
end

function var0_0.GetConsumeList(arg0_10)
	local var0_10 = (getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST):getConfig("config_data")[3] or {})[1]
	local var1_10 = pg.activity_partyinvitation_template[var0_10]
	local var2_10 = var1_10.invitationID[2]
	local var3_10 = var1_10.giftID[2]

	return var2_10, var3_10
end

local function var3_0(arg0_11)
	local var0_11 = _.filter(pg.ship_data_group.all, function(arg0_12)
		return pg.ship_data_group[arg0_12].handbook_type ~= 1
	end)
	local var1_11 = {}
	local var2_11 = {}

	for iter0_11, iter1_11 in ipairs(var0_11) do
		local var3_11 = pg.ship_data_group[iter1_11]
		local var4_11 = arg0_11[var3_11.group_type]

		if var4_11 then
			table.insert(var1_11, var4_11)
		else
			table.insert(var1_11, ShipGroup.New({
				id = var3_11.group_type
			}))
		end
	end

	return var1_11, var2_11
end

local function var4_0(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in pairs(arg0_13) do
		if not table.contains(arg1_13, iter1_13.id) then
			table.insert(var0_13, iter1_13)
		end
	end

	local var1_13 = {}
	local var2_13 = {}
	local var3_13 = {}

	for iter2_13, iter3_13 in ipairs(var0_13) do
		local var4_13 = ShipGroup.getSkinList(iter3_13.id)

		for iter4_13, iter5_13 in ipairs(var4_13) do
			local var5_13 = ShipSkin.GetShopTypeIdBySkinId(iter5_13.id, var3_13) == 7 and var1_13 or var2_13

			table.insert(var5_13, iter3_13)
		end
	end

	shuffle(var1_13)
	shuffle(var2_13)

	for iter6_13, iter7_13 in ipairs(var1_13) do
		if table.getCount(arg2_13) == arg3_13 then
			break
		end

		arg2_13[iter7_13.id] = iter7_13
	end

	for iter8_13, iter9_13 in ipairs(var2_13) do
		if table.getCount(arg2_13) == arg3_13 then
			break
		end

		arg2_13[iter9_13.id] = iter9_13
	end
end

function var0_0.RandomShips(arg0_14, arg1_14, arg2_14)
	local var0_14 = pg.activity_partyinvitation_template or {}
	local var1_14 = {}

	for iter0_14, iter1_14 in ipairs(arg1_14) do
		table.insert(var1_14, var0_14[iter1_14].groupid)
	end

	local var2_14 = arg0_14:getRawData():GetFeastShipList()

	for iter2_14, iter3_14 in pairs(var2_14) do
		if not table.contains(var1_14, iter2_14) then
			table.insert(var1_14, iter2_14)
		end
	end

	local var3_14 = getProxy(CollectionProxy):RawgetGroups()
	local var4_14, var5_14 = var3_0(var3_14)
	local var6_14 = {}

	var4_0(var4_14, var1_14, var6_14, arg2_14)
	var4_0(var5_14, var1_14, var6_14, arg2_14)

	local var7_14 = {}

	for iter4_14, iter5_14 in pairs(var6_14) do
		table.insert(var7_14, iter5_14)
	end

	return var7_14
end

function var0_0.AddRefreshTimer(arg0_15)
	arg0_15:RemoveRefreshTimer()

	local var0_15 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_15 = GetZeroTime() - var0_15

	arg0_15.timer = Timer.New(function()
		arg0_15:RemoveRefreshTimer()

		local var0_16 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

		if var0_16 and not var0_16:isEnd() then
			var2_0(arg0_15, var0_16, function()
				return
			end)
		end
	end, var1_15 + 1, 1)

	arg0_15.timer:Start()
end

function var0_0.RemoveRefreshTimer(arg0_18)
	if arg0_18.timer then
		arg0_18.timer:Stop()

		arg0_18.timer = nil
	end
end

function var0_0.remove(arg0_19)
	arg0_19:RemoveRefreshTimer()
end

function var0_0.GetBuffList(arg0_20)
	local var0_20 = getProxy(ActivityProxy):getActivityById(ActivityConst.FEAST_PT_ACT)

	if not var0_20 or var0_20:isEnd() then
		return {}
	end

	return var0_20:GetBuffList()
end

function var0_0.GetTaskList(arg0_21)
	local var0_21 = getProxy(ActivityProxy):getActivityById(ActivityConst.FEAST_TASK_ACT)

	assert(var0_21)

	local var1_21 = {}
	local var2_21 = getProxy(TaskProxy)

	for iter0_21, iter1_21 in ipairs(var0_21:getConfig("config_data")) do
		if var2_21:getTaskById(iter1_21) or var2_21:getFinishTaskById(iter1_21) then
			table.insert(var1_21, iter1_21)
		end
	end

	return var1_21
end

function var0_0.GetPtActData(arg0_22)
	local var0_22 = getProxy(ActivityProxy):getActivityById(ActivityConst.FEAST_PT_ACT)

	assert(var0_22)

	return (ActivityPtData.New(var0_22))
end

function var0_0.GetSubmittedTaskStories(arg0_23)
	local var0_23 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

	if not var0_23 or var0_23:isEnd() then
		return {}
	end

	local var1_23 = var0_23:getConfig("config_client")
	local var2_23 = {
		var1_23[8],
		var1_23[9]
	}
	local var3_23 = {}

	for iter0_23, iter1_23 in ipairs(var2_23) do
		local var4_23 = iter1_23[1]
		local var5_23 = iter1_23[2]

		if not pg.NewStoryMgr.GetInstance():IsPlayed(var5_23) then
			var3_23[var4_23] = var5_23
		end
	end

	return var3_23
end

function var0_0.ShouldTipPt(arg0_24)
	if arg0_24:GetPtActData():AnyAwardCanGet() then
		return true
	end

	return false
end

function var0_0.ShouldTipFeastTask(arg0_25)
	local var0_25 = getProxy(TaskProxy)
	local var1_25 = arg0_25:GetTaskList()

	for iter0_25, iter1_25 in ipairs(var1_25) do
		local var2_25 = var0_25:getTaskById(iter1_25)

		if var2_25 and var2_25:isFinish() and not var2_25:isReceive() then
			return true
		end
	end

	return false
end

function var0_0.ShouldTipTask(arg0_26)
	if arg0_26:ShouldTipPt() then
		return true
	end

	if arg0_26:ShouldTipFeastTask() then
		return true
	end

	return false
end

function var0_0.ShouldTipInvitation(arg0_27)
	local var0_27 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)
	local var1_27, var2_27 = arg0_27:GetConsumeList()
	local var3_27 = var0_27:getVitemNumber(var1_27)
	local var4_27 = var0_27:getVitemNumber(var2_27)
	local var5_27 = arg0_27.data:GetInvitedFeastShipList()

	for iter0_27, iter1_27 in ipairs(var5_27) do
		if not iter1_27:GotGift() and var4_27 > 0 or not iter1_27:GotTicket() and var3_27 > 0 then
			return true
		end
	end

	return false
end

function var0_0.ShouldTip(arg0_28)
	if not arg0_28.data then
		return false
	end

	local var0_28 = getProxy(ActivityProxy):getActivityById(ActivityConst.FEAST_TASK_ACT)

	if not var0_28 or var0_28:isEnd() then
		return false
	end

	local var1_28 = getProxy(ActivityProxy):getActivityById(ActivityConst.FEAST_PT_ACT)

	if not var1_28 or var1_28:isEnd() then
		return false
	end

	local var2_28 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if not var2_28 or var2_28:isEnd() then
		return false
	end

	if arg0_28.data == nil then
		return false
	end

	local var3_28 = arg0_28.data:GetFeastShipList()

	for iter0_28, iter1_28 in pairs(var3_28) do
		if iter1_28:HasBubble() then
			return true
		end
	end

	if arg0_28:ShouldTipTask() then
		return true
	end

	if arg0_28:ShouldTipInvitation() then
		return true
	end

	return false
end

function var0_0.HandleTaskStories(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg0_29:GetSubmittedTaskStories()

	if not var0_29 or table.getCount(var0_29) == 0 then
		if arg2_29 then
			arg2_29()
		end

		return
	end

	local var1_29 = {}

	for iter0_29, iter1_29 in ipairs(arg1_29) do
		if var0_29[iter1_29] ~= nil then
			table.insert(var1_29, var0_29[iter1_29])
		end
	end

	if #var1_29 > 0 then
		if arg2_29 then
			pg.NewStoryMgr.GetInstance():SeriesPlay(var1_29, arg2_29)
		else
			pg.NewStoryMgr.GetInstance():SeriesPlay(var1_29)
		end
	end
end

return var0_0
