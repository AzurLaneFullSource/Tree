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
	DORM3D_FURNITURE = 24,
	ACT_NEWBIE = 17,
	EVENT = 15,
	ATTIRE = 6,
	FRIEND = 8,
	NEW_SERVER = 20,
	DORM3D_SHOP_TIMELIMIT = 25,
	TASK = 2,
	EDUCATE_NEW_CHILD = 26,
	COMMANDER_MANUAL = 27,
	BUILD = 4,
	MAIL = 3,
	GUILD = 5,
	SETTTING = 11,
	SCHOOL = 13,
	COMMISSION = 9,
	COLLECTION = 7,
	ISLAND_3D = 28
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
		return PlayerPrefs.GetInt("firstIntoOtherPanel", 0) == 0
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
		local var0_20, var1_20 = TechnologyConst.isNormalActOn()
		local var2_20, var3_20 = TechnologyConst.isTecActOn()

		return var1_20 or var3_20
	end)
	arg0_3:BindCondition(var0_0.TYPES.MEMORY_REVIEW, function()
		local var0_21 = getProxy(PlayerProxy):getRawData()

		if var0_21 and _.any(pg.memory_group.all, function(arg0_22)
			return PlayerPrefs.GetInt("MEMORY_GROUP_NOTIFICATION" .. var0_21.id .. " " .. arg0_22, 0) == 1
		end) then
			return true
		end

		if getProxy(LoveLetterProxy):getRawData() and getProxy(LoveLetterProxy):IsTipUnlockLetter() then
			return true
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
	arg0_3:BindCondition(var0_0.TYPES.DORM3D_SHOP_TIMELIMIT, function()
		return pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "SelectDorm3DMediator") and Dorm3dShopUI.ShouldShowAllTip()
	end)
	arg0_3:BindCondition(var0_0.TYPES.EDUCATE_NEW_CHILD, function()
		return NewEducateHelper.IsShowNewChildTip()
	end)
	arg0_3:BindCondition(var0_0.TYPES.COMMANDER_MANUAL, function()
		local var0_30 = getProxy(CommanderManualProxy):ShouldShowTaskOrGuideTip()
		local var1_30, var2_30 = TechnologyConst.isTecActOn()

		return var0_30 or var2_30
	end)
	arg0_3:BindCondition(var0_0.TYPES.ISLAND_3D, function()
		return getProxy(SystemTipProxy):IsIslandRedDotTip()
	end)
end

function var0_0.BindCondition(arg0_32, arg1_32, arg2_32)
	arg0_32.conditions[arg1_32] = arg2_32
end

function var0_0.RegisterRedDotNodes(arg0_33, arg1_33)
	for iter0_33, iter1_33 in ipairs(arg1_33) do
		arg0_33:RegisterRedDotNode(iter1_33)
	end

	arg0_33:_NotifyAll()
end

function var0_0.RegisterRedDotNode(arg0_34, arg1_34)
	local var0_34 = arg1_34:GetTypes()

	for iter0_34, iter1_34 in ipairs(var0_34) do
		if not arg0_34.nodeList[iter1_34] then
			arg0_34.nodeList[iter1_34] = {}
		end

		table.insert(arg0_34.nodeList[iter1_34], arg1_34)
	end

	arg1_34:Init()
end

function var0_0.UnRegisterRedDotNodes(arg0_35, arg1_35)
	for iter0_35, iter1_35 in ipairs(arg1_35) do
		arg0_35:UnRegisterRedDotNode(iter1_35)
	end

	var0_0.cache = {}
end

function var0_0.UnRegisterRedDotNode(arg0_36, arg1_36)
	local var0_36 = arg1_36:GetTypes()

	for iter0_36, iter1_36 in ipairs(var0_36) do
		local var1_36 = arg0_36.nodeList[iter1_36] or {}

		for iter2_36, iter3_36 in ipairs(var1_36) do
			if iter3_36 == arg1_36 then
				iter3_36:Remove()
				table.remove(var1_36, iter2_36)
			end
		end
	end
end

local function var3_0(arg0_37, arg1_37)
	for iter0_37, iter1_37 in ipairs(arg1_37) do
		local var0_37

		if var0_0.cache[iter1_37] ~= nil then
			var0_37 = var0_0.cache[iter1_37]
		else
			var0_37 = arg0_37.conditions[iter1_37]()
			var0_0.cache[iter1_37] = var0_37
		end

		if var0_37 then
			return var0_37
		end
	end

	return false
end

function var0_0.NotifyAll(arg0_38, arg1_38)
	var0_0.cache = {}

	for iter0_38, iter1_38 in ipairs(arg0_38.nodeList[arg1_38] or {}) do
		local var0_38 = iter1_38:GetTypes()
		local var1_38 = var3_0(arg0_38, var0_38)

		iter1_38:SetData(var1_38)
	end

	var0_0.cache = {}
end

function var0_0._NotifyAll(arg0_39)
	var0_0.cache = {}

	local var0_39 = {}

	local function var1_39(arg0_40, arg1_40)
		local var0_40 = arg0_40:GetTypes()
		local var1_40 = var3_0(arg0_39, var0_40)

		arg0_40:SetData(var1_40)
		onNextTick(arg1_40)
	end

	for iter0_39, iter1_39 in pairs(arg0_39.nodeList) do
		for iter2_39, iter3_39 in ipairs(iter1_39) do
			table.insert(var0_39, function(arg0_41)
				var1_39(iter3_39, arg0_41)
			end)
		end
	end

	seriesAsync(var0_39, function()
		var0_0.cache = {}
	end)
end

function var0_0.DebugNodes(arg0_43)
	for iter0_43, iter1_43 in pairs(arg0_43.nodeList) do
		var2_0("type : ", iter0_43)

		for iter2_43, iter3_43 in ipairs(iter1_43) do
			var2_0(" ", iter3_43:GetName())
		end
	end
end
