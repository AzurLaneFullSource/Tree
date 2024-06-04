local var0 = class("FeastProxy", import("model.proxy.NetProxy"))

function var0.register(arg0)
	return
end

local function var1(arg0, arg1, arg2)
	if arg0:getRawData() ~= nil then
		arg2()

		return
	end

	arg0:sendNotification(GAME.GET_FEAST_DATA, {
		activityId = arg1.id,
		callback = arg2
	})
end

local function var2(arg0, arg1, arg2)
	local var0 = arg1:getConfig("config_data")
	local var1 = var0[1] or 5

	if not arg0:getRawData():ShouldRandomShips() then
		arg2()

		return
	end

	local var2 = var0[3] or {}
	local var3 = arg0:RandomShips(var2, var1)
	local var4 = _.map(var3, function(arg0)
		return arg0.id
	end)

	arg0:sendNotification(GAME.FEAST_OP, {
		activityId = arg1.id,
		cmd = FeastDorm.OP_RANDOM_SHIPS,
		argList = var4,
		callback = arg2
	})
end

function var0.RequestData(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

	if not var0 or var0:isEnd() then
		arg1()

		return
	end

	seriesAsync({
		function(arg0)
			var1(arg0, var0, arg0)
		end,
		function(arg0)
			var2(arg0, var0, arg0)
		end
	}, arg1)
end

function var0.SetData(arg0, arg1)
	assert(isa(arg1, FeastDorm))

	arg0.data = arg1

	arg0:AddRefreshTimer()
end

function var0.UpdateData(arg0, arg1)
	assert(isa(arg1, FeastDorm))

	arg0.data = arg1
end

function var0.GetConsumeList(arg0)
	local var0 = (getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST):getConfig("config_data")[3] or {})[1]
	local var1 = pg.activity_partyinvitation_template[var0]
	local var2 = var1.invitationID[2]
	local var3 = var1.giftID[2]

	return var2, var3
end

local function var3(arg0)
	local var0 = _.filter(pg.ship_data_group.all, function(arg0)
		return pg.ship_data_group[arg0].handbook_type ~= 1
	end)
	local var1 = {}
	local var2 = {}

	for iter0, iter1 in ipairs(var0) do
		local var3 = pg.ship_data_group[iter1]
		local var4 = arg0[var3.group_type]

		if var4 then
			table.insert(var1, var4)
		else
			table.insert(var1, ShipGroup.New({
				id = var3.group_type
			}))
		end
	end

	return var1, var2
end

local function var4(arg0, arg1, arg2, arg3)
	local var0 = {}

	for iter0, iter1 in pairs(arg0) do
		if not table.contains(arg1, iter1.id) then
			table.insert(var0, iter1)
		end
	end

	local var1 = {}
	local var2 = {}
	local var3 = {}

	for iter2, iter3 in ipairs(var0) do
		local var4 = ShipGroup.getSkinList(iter3.id)

		for iter4, iter5 in ipairs(var4) do
			local var5 = ShipSkin.GetShopTypeIdBySkinId(iter5.id, var3) == 7 and var1 or var2

			table.insert(var5, iter3)
		end
	end

	shuffle(var1)
	shuffle(var2)

	for iter6, iter7 in ipairs(var1) do
		if table.getCount(arg2) == arg3 then
			break
		end

		arg2[iter7.id] = iter7
	end

	for iter8, iter9 in ipairs(var2) do
		if table.getCount(arg2) == arg3 then
			break
		end

		arg2[iter9.id] = iter9
	end
end

function var0.RandomShips(arg0, arg1, arg2)
	local var0 = pg.activity_partyinvitation_template or {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg1) do
		table.insert(var1, var0[iter1].groupid)
	end

	local var2 = arg0:getRawData():GetFeastShipList()

	for iter2, iter3 in pairs(var2) do
		if not table.contains(var1, iter2) then
			table.insert(var1, iter2)
		end
	end

	local var3 = getProxy(CollectionProxy):RawgetGroups()
	local var4, var5 = var3(var3)
	local var6 = {}

	var4(var4, var1, var6, arg2)
	var4(var5, var1, var6, arg2)

	local var7 = {}

	for iter4, iter5 in pairs(var6) do
		table.insert(var7, iter5)
	end

	return var7
end

function var0.AddRefreshTimer(arg0)
	arg0:RemoveRefreshTimer()

	local var0 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1 = GetZeroTime() - var0

	arg0.timer = Timer.New(function()
		arg0:RemoveRefreshTimer()

		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

		if var0 and not var0:isEnd() then
			var2(arg0, var0, function()
				return
			end)
		end
	end, var1 + 1, 1)

	arg0.timer:Start()
end

function var0.RemoveRefreshTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.remove(arg0)
	arg0:RemoveRefreshTimer()
end

function var0.GetBuffList(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.FEAST_PT_ACT)

	if not var0 or var0:isEnd() then
		return {}
	end

	return var0:GetBuffList()
end

function var0.GetTaskList(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.FEAST_TASK_ACT)

	assert(var0)

	local var1 = {}
	local var2 = getProxy(TaskProxy)

	for iter0, iter1 in ipairs(var0:getConfig("config_data")) do
		if var2:getTaskById(iter1) or var2:getFinishTaskById(iter1) then
			table.insert(var1, iter1)
		end
	end

	return var1
end

function var0.GetPtActData(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.FEAST_PT_ACT)

	assert(var0)

	return (ActivityPtData.New(var0))
end

function var0.GetSubmittedTaskStories(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

	if not var0 or var0:isEnd() then
		return {}
	end

	local var1 = var0:getConfig("config_client")
	local var2 = {
		var1[8],
		var1[9]
	}
	local var3 = {}

	for iter0, iter1 in ipairs(var2) do
		local var4 = iter1[1]
		local var5 = iter1[2]

		if not pg.NewStoryMgr.GetInstance():IsPlayed(var5) then
			var3[var4] = var5
		end
	end

	return var3
end

function var0.ShouldTipPt(arg0)
	if arg0:GetPtActData():AnyAwardCanGet() then
		return true
	end

	return false
end

function var0.ShouldTipFeastTask(arg0)
	local var0 = getProxy(TaskProxy)
	local var1 = arg0:GetTaskList()

	for iter0, iter1 in ipairs(var1) do
		local var2 = var0:getTaskById(iter1)

		if var2 and var2:isFinish() and not var2:isReceive() then
			return true
		end
	end

	return false
end

function var0.ShouldTipTask(arg0)
	if arg0:ShouldTipPt() then
		return true
	end

	if arg0:ShouldTipFeastTask() then
		return true
	end

	return false
end

function var0.ShouldTipInvitation(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)
	local var1, var2 = arg0:GetConsumeList()
	local var3 = var0:getVitemNumber(var1)
	local var4 = var0:getVitemNumber(var2)
	local var5 = arg0.data:GetInvitedFeastShipList()

	for iter0, iter1 in ipairs(var5) do
		if not iter1:GotGift() and var4 > 0 or not iter1:GotTicket() and var3 > 0 then
			return true
		end
	end

	return false
end

function var0.ShouldTip(arg0)
	if not arg0.data then
		return false
	end

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.FEAST_TASK_ACT)

	if not var0 or var0:isEnd() then
		return false
	end

	local var1 = getProxy(ActivityProxy):getActivityById(ActivityConst.FEAST_PT_ACT)

	if not var1 or var1:isEnd() then
		return false
	end

	local var2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if not var2 or var2:isEnd() then
		return false
	end

	if arg0.data == nil then
		return false
	end

	local var3 = arg0.data:GetFeastShipList()

	for iter0, iter1 in pairs(var3) do
		if iter1:HasBubble() then
			return true
		end
	end

	if arg0:ShouldTipTask() then
		return true
	end

	if arg0:ShouldTipInvitation() then
		return true
	end

	return false
end

function var0.HandleTaskStories(arg0, arg1, arg2)
	local var0 = arg0:GetSubmittedTaskStories()

	if not var0 or table.getCount(var0) == 0 then
		if arg2 then
			arg2()
		end

		return
	end

	local var1 = {}

	for iter0, iter1 in ipairs(arg1) do
		if var0[iter1] ~= nil then
			table.insert(var1, var0[iter1])
		end
	end

	if #var1 > 0 then
		if arg2 then
			pg.NewStoryMgr.GetInstance():SeriesPlay(var1, arg2)
		else
			pg.NewStoryMgr.GetInstance():SeriesPlay(var1)
		end
	end
end

return var0
