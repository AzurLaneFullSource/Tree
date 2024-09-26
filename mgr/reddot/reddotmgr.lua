pg = pg or {}
pg.RedDotMgr = singletonClass("RedDotMgr")

require("Mgr/RedDot/Include")

local var0_0 = pg.RedDotMgr
local var1_0 = true

local function var2_0(...)
	if var1_0 then
		originalPrint(...)
	end
end

var0_0.TYPES = {
	COURTYARD = 1,
	MEMORY_REVIEW = 19,
	ACT_RETURN = 16,
	COMMANDER = 10,
	RYZA_TASK = 21,
	BLUEPRINT = 14,
	DORM3D_GIFT = 23,
	SERVER = 12,
	ISLAND = 22,
	TASK = 2,
	ACT_NEWBIE = 17,
	EVENT = 15,
	ATTIRE = 6,
	FRIEND = 8,
	NEW_SERVER = 20,
	BUILD = 4,
	DORM3D_FURNITURE = 24,
	MAIL = 3,
	GUILD = 5,
	SETTTING = 11,
	COMMISSION = 9,
	COLLECTION = 7,
	SCHOOL = 13
}

function var0_0.Init(arg0_2, arg1_2)
	arg0_2.conditions = {}
	arg0_2.nodeList = {}

	arg0_2:BindConditions()

	if arg1_2 then
		arg1_2()
	end
end

function var0_0.BindConditions(arg0_3)
	arg0_3:BindCondition(var0_0.TYPES.COURTYARD, function()
		return getProxy(DormProxy):IsShowRedDot()
	end)
	arg0_3:BindCondition(var0_0.TYPES.TASK, function()
		return getProxy(TaskProxy):getCanReceiveCount() > 0 or getProxy(AvatarFrameProxy):getCanReceiveCount() > 0
	end)
	arg0_3:BindCondition(var0_0.TYPES.MAIL, function()
		return getProxy(MailProxy):GetUnreadCount()
	end)
	arg0_3:BindCondition(var0_0.TYPES.BUILD, function()
		return getProxy(BuildShipProxy):getFinishCount() > 0 or tobool(getProxy(ActivityProxy):IsShowFreeBuildMark(true))
	end)
	arg0_3:BindCondition(var0_0.TYPES.GUILD, function()
		return getProxy(GuildProxy):ShouldShowTip()
	end)
	arg0_3:BindCondition(var0_0.TYPES.ATTIRE, function()
		return getProxy(AttireProxy):IsShowRedDot() or getProxy(SettingsProxy):ShouldEducateCharTip()
	end)
	arg0_3:BindCondition(var0_0.TYPES.COLLECTION, function()
		return getProxy(CollectionProxy):hasFinish() or getProxy(AppreciateProxy):isGalleryHaveNewRes() or getProxy(AppreciateProxy):isMusicHaveNewRes() or getProxy(AppreciateProxy):isMangaHaveNewRes()
	end)
	arg0_3:BindCondition(var0_0.TYPES.FRIEND, function()
		return getProxy(NotificationProxy):getRequestCount() > 0 or getProxy(FriendProxy):getNewMsgCount() > 0
	end)
	arg0_3:BindCondition(var0_0.TYPES.COMMISSION, function()
		return getProxy(PlayerProxy):IsShowCommssionTip()
	end)
	arg0_3:BindCondition(var0_0.TYPES.COMMANDER, function()
		if getProxy(PlayerProxy):getRawData().level < 40 then
			return false
		end

		local var0_13 = getProxy(CommanderProxy):IsFinishAllBox()

		if not LOCK_CATTERY then
			return var0_13 or getProxy(CommanderProxy):AnyCatteryExistOP() or getProxy(CommanderProxy):AnyCatteryCanUse()
		else
			return var0_13
		end
	end)
	arg0_3:BindCondition(var0_0.TYPES.SETTTING, function()
		return PlayerPrefs.GetFloat("firstIntoOtherPanel") == 0
	end)
	arg0_3:BindCondition(var0_0.TYPES.SERVER, function()
		return #getProxy(ServerNoticeProxy):getServerNotices(false) > 0 and getProxy(ServerNoticeProxy):hasNewNotice()
	end)
	arg0_3:BindCondition(var0_0.TYPES.SCHOOL, function()
		return getProxy(NavalAcademyProxy):IsShowTip()
	end)
	arg0_3:BindCondition(var0_0.TYPES.BLUEPRINT, function()
		return getProxy(TechnologyProxy):IsShowTip()
	end)
	arg0_3:BindCondition(var0_0.TYPES.EVENT, function()
		return getProxy(EventProxy):hasFinishState() or LimitChallengeConst.IsShowRedPoint()
	end)
	arg0_3:BindCondition(var0_0.TYPES.ACT_RETURN, function()
		local var0_19 = RefluxTaskView.isAnyTaskCanGetAward()
		local var1_19 = RefluxPTView.isAnyPTCanGetAward()
		local var2_19 = RefluxShopView.isShowRedPot()

		return var0_19 or var1_19 or var2_19
	end)
	arg0_3:BindCondition(var0_0.TYPES.ACT_NEWBIE, function()
		local var0_20, var1_20 = TrainingCampScene.isNormalActOn()
		local var2_20, var3_20 = TrainingCampScene.isTecActOn()

		return var1_20 or var3_20
	end)
	arg0_3:BindCondition(var0_0.TYPES.MEMORY_REVIEW, function()
		local var0_21 = getProxy(PlayerProxy):getRawData()

		if var0_21 then
			local var1_21 = var0_21.id

			do return _.any(pg.memory_group.all, function(arg0_22)
				return PlayerPrefs.GetInt("MEMORY_GROUP_NOTIFICATION" .. var1_21 .. " " .. arg0_22, 0) == 1
			end) end
			return
		end

		return false
	end)
	arg0_3:BindCondition(var0_0.TYPES.NEW_SERVER, function()
		return NewServerCarnivalScene.isTip()
	end)
	arg0_3:BindCondition(var0_0.TYPES.RYZA_TASK, function()
		return getProxy(ActivityTaskProxy):getActTaskTip(ActivityConst.RYZA_TASK)
	end)
	arg0_3:BindCondition(var0_0.TYPES.ISLAND, function()
		local var0_25 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

		return Activity.IsActivityReady(var0_25)
	end)
	arg0_3:BindCondition(var0_0.TYPES.DORM3D_GIFT, function()
		return pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "SelectDorm3DMediator") and Dorm3dGift.NeedViewTip()
	end)
	arg0_3:BindCondition(var0_0.TYPES.DORM3D_FURNITURE, function()
		return pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "SelectDorm3DMediator") and Dorm3dFurniture.NeedViewTip()
	end)
end

function var0_0.BindCondition(arg0_28, arg1_28, arg2_28)
	arg0_28.conditions[arg1_28] = arg2_28
end

function var0_0.RegisterRedDotNodes(arg0_29, arg1_29)
	for iter0_29, iter1_29 in ipairs(arg1_29) do
		arg0_29:RegisterRedDotNode(iter1_29)
	end

	arg0_29:_NotifyAll()
end

function var0_0.RegisterRedDotNode(arg0_30, arg1_30)
	local var0_30 = arg1_30:GetTypes()

	for iter0_30, iter1_30 in ipairs(var0_30) do
		if not arg0_30.nodeList[iter1_30] then
			arg0_30.nodeList[iter1_30] = {}
		end

		table.insert(arg0_30.nodeList[iter1_30], arg1_30)
	end

	arg1_30:Init()
end

function var0_0.UnRegisterRedDotNodes(arg0_31, arg1_31)
	for iter0_31, iter1_31 in ipairs(arg1_31) do
		arg0_31:UnRegisterRedDotNode(iter1_31)
	end

	var0_0.cache = {}
end

function var0_0.UnRegisterRedDotNode(arg0_32, arg1_32)
	local var0_32 = arg1_32:GetTypes()

	for iter0_32, iter1_32 in ipairs(var0_32) do
		local var1_32 = arg0_32.nodeList[iter1_32] or {}

		for iter2_32, iter3_32 in ipairs(var1_32) do
			if iter3_32 == arg1_32 then
				iter3_32:Remove()
				table.remove(var1_32, iter2_32)
			end
		end
	end
end

local function var3_0(arg0_33, arg1_33)
	for iter0_33, iter1_33 in ipairs(arg1_33) do
		local var0_33

		if var0_0.cache[iter1_33] ~= nil then
			var0_33 = var0_0.cache[iter1_33]
		else
			var0_33 = arg0_33.conditions[iter1_33]()
			var0_0.cache[iter1_33] = var0_33
		end

		if var0_33 then
			return var0_33
		end
	end

	return false
end

function var0_0.NotifyAll(arg0_34, arg1_34)
	var0_0.cache = {}

	for iter0_34, iter1_34 in ipairs(arg0_34.nodeList[arg1_34] or {}) do
		local var0_34 = iter1_34:GetTypes()
		local var1_34 = var3_0(arg0_34, var0_34)

		iter1_34:SetData(var1_34)
	end

	var0_0.cache = {}
end

function var0_0._NotifyAll(arg0_35)
	var0_0.cache = {}

	local var0_35 = {}

	local function var1_35(arg0_36, arg1_36)
		local var0_36 = arg0_36:GetTypes()
		local var1_36 = var3_0(arg0_35, var0_36)

		arg0_36:SetData(var1_36)
		onNextTick(arg1_36)
	end

	for iter0_35, iter1_35 in pairs(arg0_35.nodeList) do
		for iter2_35, iter3_35 in ipairs(iter1_35) do
			table.insert(var0_35, function(arg0_37)
				var1_35(iter3_35, arg0_37)
			end)
		end
	end

	seriesAsync(var0_35, function()
		var0_0.cache = {}
	end)
end

function var0_0.DebugNodes(arg0_39)
	for iter0_39, iter1_39 in pairs(arg0_39.nodeList) do
		var2_0("type : ", iter0_39)

		for iter2_39, iter3_39 in ipairs(iter1_39) do
			var2_0(" ", iter3_39:GetName())
		end
	end
end
