pg = pg or {}
pg.RedDotMgr = singletonClass("RedDotMgr")

require("Mgr/RedDot/Include")

local var0 = pg.RedDotMgr
local var1 = true

local function var2(...)
	if var1 then
		originalPrint(...)
	end
end

var0.TYPES = {
	COURTYARD = 1,
	MEMORY_REVIEW = 19,
	ACT_RETURN = 16,
	COMMANDER = 10,
	RYZA_TASK = 21,
	BLUEPRINT = 14,
	BUILD = 4,
	SERVER = 12,
	ISLAND = 22,
	ACT_NEWBIE = 17,
	EVENT = 15,
	ATTIRE = 6,
	FRIEND = 8,
	NEW_SERVER = 20,
	TASK = 2,
	MAIL = 3,
	GUILD = 5,
	SETTTING = 11,
	COMMISSION = 9,
	COLLECTION = 7,
	SCHOOL = 13
}

function var0.Init(arg0, arg1)
	arg0.conditions = {}
	arg0.nodeList = {}

	arg0:BindConditions()

	if arg1 then
		arg1()
	end
end

function var0.BindConditions(arg0)
	arg0:BindCondition(var0.TYPES.COURTYARD, function()
		return getProxy(DormProxy):IsShowRedDot()
	end)
	arg0:BindCondition(var0.TYPES.TASK, function()
		return getProxy(TaskProxy):getCanReceiveCount() > 0 or getProxy(AvatarFrameProxy):getCanReceiveCount() > 0
	end)
	arg0:BindCondition(var0.TYPES.MAIL, function()
		return getProxy(MailProxy):GetUnreadCount()
	end)
	arg0:BindCondition(var0.TYPES.BUILD, function()
		return getProxy(BuildShipProxy):getFinishCount() > 0 or tobool(getProxy(ActivityProxy):IsShowFreeBuildMark(true))
	end)
	arg0:BindCondition(var0.TYPES.GUILD, function()
		return getProxy(GuildProxy):ShouldShowTip()
	end)
	arg0:BindCondition(var0.TYPES.ATTIRE, function()
		return getProxy(AttireProxy):IsShowRedDot() or getProxy(SettingsProxy):ShouldEducateCharTip()
	end)
	arg0:BindCondition(var0.TYPES.COLLECTION, function()
		return getProxy(CollectionProxy):hasFinish() or getProxy(AppreciateProxy):isGalleryHaveNewRes() or getProxy(AppreciateProxy):isMusicHaveNewRes() or getProxy(AppreciateProxy):isMangaHaveNewRes()
	end)
	arg0:BindCondition(var0.TYPES.FRIEND, function()
		return getProxy(NotificationProxy):getRequestCount() > 0 or getProxy(FriendProxy):getNewMsgCount() > 0
	end)
	arg0:BindCondition(var0.TYPES.COMMISSION, function()
		return getProxy(PlayerProxy):IsShowCommssionTip()
	end)
	arg0:BindCondition(var0.TYPES.COMMANDER, function()
		if getProxy(PlayerProxy):getRawData().level < 40 then
			return false
		end

		local var0 = getProxy(CommanderProxy):IsFinishAllBox()

		if not LOCK_CATTERY then
			return var0 or getProxy(CommanderProxy):AnyCatteryExistOP() or getProxy(CommanderProxy):AnyCatteryCanUse()
		else
			return var0
		end
	end)
	arg0:BindCondition(var0.TYPES.SETTTING, function()
		return PlayerPrefs.GetFloat("firstIntoOtherPanel") == 0
	end)
	arg0:BindCondition(var0.TYPES.SERVER, function()
		return #getProxy(ServerNoticeProxy):getServerNotices(false) > 0 and getProxy(ServerNoticeProxy):hasNewNotice()
	end)
	arg0:BindCondition(var0.TYPES.SCHOOL, function()
		return getProxy(NavalAcademyProxy):IsShowTip()
	end)
	arg0:BindCondition(var0.TYPES.BLUEPRINT, function()
		return getProxy(TechnologyProxy):IsShowTip()
	end)
	arg0:BindCondition(var0.TYPES.EVENT, function()
		return getProxy(EventProxy):hasFinishState() or LimitChallengeConst.IsShowRedPoint()
	end)
	arg0:BindCondition(var0.TYPES.ACT_RETURN, function()
		local var0 = RefluxTaskView.isAnyTaskCanGetAward()
		local var1 = RefluxPTView.isAnyPTCanGetAward()
		local var2 = RefluxShopView.isShowRedPot()

		return var0 or var1 or var2
	end)
	arg0:BindCondition(var0.TYPES.ACT_NEWBIE, function()
		local var0, var1 = TrainingCampScene.isNormalActOn()
		local var2, var3 = TrainingCampScene.isTecActOn()

		return var1 or var3
	end)
	arg0:BindCondition(var0.TYPES.MEMORY_REVIEW, function()
		local var0 = getProxy(PlayerProxy):getRawData()

		if var0 then
			local var1 = var0.id

			do return _.any(pg.memory_group.all, function(arg0)
				return PlayerPrefs.GetInt("MEMORY_GROUP_NOTIFICATION" .. var1 .. " " .. arg0, 0) == 1
			end) end
			return
		end

		return false
	end)
	arg0:BindCondition(var0.TYPES.NEW_SERVER, function()
		return NewServerCarnivalScene.isTip()
	end)
	arg0:BindCondition(var0.TYPES.RYZA_TASK, function()
		return getProxy(ActivityTaskProxy):getActTaskTip(ActivityConst.RYZA_TASK)
	end)
	arg0:BindCondition(var0.TYPES.ISLAND, function()
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

		return Activity.IsActivityReady(var0)
	end)
end

function var0.BindCondition(arg0, arg1, arg2)
	arg0.conditions[arg1] = arg2
end

function var0.RegisterRedDotNodes(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		arg0:RegisterRedDotNode(iter1)
	end

	arg0:_NotifyAll()
end

function var0.RegisterRedDotNode(arg0, arg1)
	local var0 = arg1:GetTypes()

	for iter0, iter1 in ipairs(var0) do
		if not arg0.nodeList[iter1] then
			arg0.nodeList[iter1] = {}
		end

		table.insert(arg0.nodeList[iter1], arg1)
	end

	arg1:Init()
end

function var0.UnRegisterRedDotNodes(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		arg0:UnRegisterRedDotNode(iter1)
	end

	var0.cache = {}
end

function var0.UnRegisterRedDotNode(arg0, arg1)
	local var0 = arg1:GetTypes()

	for iter0, iter1 in ipairs(var0) do
		local var1 = arg0.nodeList[iter1] or {}

		for iter2, iter3 in ipairs(var1) do
			if iter3 == arg1 then
				iter3:Remove()
				table.remove(var1, iter2)
			end
		end
	end
end

local function var3(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		local var0

		if var0.cache[iter1] ~= nil then
			var0 = var0.cache[iter1]
		else
			var0 = arg0.conditions[iter1]()
			var0.cache[iter1] = var0
		end

		if var0 then
			return var0
		end
	end

	return false
end

function var0.NotifyAll(arg0, arg1)
	var0.cache = {}

	for iter0, iter1 in ipairs(arg0.nodeList[arg1] or {}) do
		local var0 = iter1:GetTypes()
		local var1 = var3(arg0, var0)

		iter1:SetData(var1)
	end

	var0.cache = {}
end

function var0._NotifyAll(arg0)
	var0.cache = {}

	local var0 = {}

	local function var1(arg0, arg1)
		local var0 = arg0:GetTypes()
		local var1 = var3(arg0, var0)

		arg0:SetData(var1)
		onNextTick(arg1)
	end

	for iter0, iter1 in pairs(arg0.nodeList) do
		for iter2, iter3 in ipairs(iter1) do
			table.insert(var0, function(arg0)
				var1(iter3, arg0)
			end)
		end
	end

	seriesAsync(var0, function()
		var0.cache = {}
	end)
end

function var0.DebugNodes(arg0)
	for iter0, iter1 in pairs(arg0.nodeList) do
		var2("type : ", iter0)

		for iter2, iter3 in ipairs(iter1) do
			var2(" ", iter3:GetName())
		end
	end
end
