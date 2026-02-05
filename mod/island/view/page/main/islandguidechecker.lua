local var0_0 = class("IslandGuideChecker")

var0_0.MOVE_TASK_ID = 10001000
var0_0.FIRST_TASK_ID = 10001010
var0_0.ORDER_TASK_ID = 10001071
var0_0.ORDER_TASK_PRE_ID = 10001070
var0_0.ORDER_NEED_ITEMS = {
	{
		2700,
		1
	},
	{
		2800,
		1
	}
}
var0_0.TECH_TASK_ID = 10001141
var0_0.MAP_GUIDE_ABILITY_ID = 5004
var0_0.INVITE_TASK_ID = 10001151
var0_0.INVITE_TASK_PRE_ID = 10001150
var0_0.MANAGE_ABILITY_ID = 26
var0_0.MINING_ABILITY_ID = 2003
var0_0.PASTIRE_ABILITY_ID = 2002
var0_0.COMBP_ABILITY_ID = 29001
var0_0.DAILY_TASK_ABILITY_ID = 30001
var0_0.SIGNIN_STORY_NAME = "ISLAND1001032_1"
var0_0.TECH_FIRST_ID = 100001
var0_0.FISHING_TASK_ID = 20016003
var0_0.PURCHASE_TRADE_TASK_ID = 20017002
var0_0.SELL_TRADE_TASK_ID = 20017003
var0_0.FINISH_TYPE = {
	ON_GUIDE = 2,
	ON_BEGIN = 1,
	ON_END = 3
}
var0_0.loadedConfig = {
	{
		id = "ISLAND_GUIDE_2",
		mapId = 0,
		condition = function()
			return not getProxy(IslandProxy):GetIsland():GetTaskAgency():IsFinishTask(var0_0.MOVE_TASK_ID)
		end,
		type = var0_0.FINISH_TYPE.ON_GUIDE
	},
	{
		id = "ISLAND_GUIDE_25",
		condition = function()
			return getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(var0_0.MANAGE_ABILITY_ID)
		end,
		mapId = IslandConst.COFFEE_SHOP_MAP_ID,
		type = var0_0.FINISH_TYPE.ON_BEGIN
	}
}
var0_0.interactionConfig = {
	{
		id = "ISLAND_GUIDE_3",
		interactionId = 0,
		condition = function()
			return true
		end,
		type = var0_0.FINISH_TYPE.ON_BEGIN
	},
	{
		id = "ISLAND_GUIDE_34",
		interactionId = 10020071,
		condition = function()
			return getProxy(IslandProxy):GetIsland():GetTaskAgency():IsFinishTask(var0_0.FISHING_TASK_ID)
		end,
		type = var0_0.FINISH_TYPE.ON_END
	}
}
var0_0.pageConfig = {
	{
		id = "ISLAND_GUIDE_5",
		page = "IslandUpgradeDisplayPage",
		condition = function()
			return true
		end,
		type = var0_0.FINISH_TYPE.ON_BEGIN
	},
	{
		id = "ISLAND_GUIDE_6",
		page = "IslandMapPage",
		condition = function()
			return getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(var0_0.MAP_GUIDE_ABILITY_ID)
		end,
		type = var0_0.FINISH_TYPE.ON_BEGIN
	},
	{
		id = "ISLAND_GUIDE_8",
		page = "IslandTechnologyPage",
		condition = function()
			local var0_7 = getProxy(IslandProxy):GetIsland()
			local var1_7 = var0_7:GetTaskAgency():GetTask(var0_0.TECH_TASK_ID)
			local var2_7 = var0_7:GetTechnologyAgency():GetTechnology(var0_0.TECH_FIRST_ID):GetStatus()

			return var1_7 and (var2_7 == IslandTechnology.STATUS.LOCK or var2_7 == IslandTechnology.STATUS.UNLOCK or var2_7 == IslandTechnology.STATUS.NORMAL)
		end,
		type = var0_0.FINISH_TYPE.ON_GUIDE
	},
	{
		id = "ISLAND_GUIDE_9",
		page = "IslandInvitePage",
		condition = function()
			local var0_8 = getProxy(IslandProxy):GetIsland():GetTaskAgency()

			return var0_8:IsFinishTask(var0_0.INVITE_TASK_PRE_ID) and not var0_8:IsFinishTask(var0_0.INVITE_TASK_ID)
		end,
		type = var0_0.FINISH_TYPE.ON_GUIDE
	},
	{
		id = "ISLAND_GUIDE_13",
		page = "Island3dTaskPage",
		condition = function()
			return getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(var0_0.DAILY_TASK_ABILITY_ID)
		end,
		type = var0_0.FINISH_TYPE.ON_BEGIN
	},
	{
		id = "ISLAND_GUIDE_21",
		page = "IslandShipOrderPage",
		condition = function()
			return true
		end,
		type = var0_0.FINISH_TYPE.ON_BEGIN
	},
	{
		id = "ISLAND_GUIDE_23",
		page = "IslandBookPage",
		condition = function()
			return true
		end,
		type = var0_0.FINISH_TYPE.ON_BEGIN
	},
	{
		id = "ISLAND_GUIDE_28",
		page = "IslandPhotoMainPage",
		condition = function()
			return true
		end,
		type = var0_0.FINISH_TYPE.ON_BEGIN
	},
	{
		id = "ISLAND_GUIDE_29",
		page = "IslandFriendPage",
		condition = function()
			return true
		end,
		type = var0_0.FINISH_TYPE.ON_BEGIN
	},
	{
		id = "ISLAND_GUIDE_31",
		page = "IslandMallDelegationPage",
		condition = function()
			return getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(var0_0.COMBP_ABILITY_ID)
		end,
		type = var0_0.FINISH_TYPE.ON_BEGIN
	},
	{
		id = "ISLAND_GUIDE_32",
		page = "IslandBookFishPage",
		condition = function()
			return true
		end,
		type = var0_0.FINISH_TYPE.ON_END
	},
	{
		id = "ISLAND_GUIDE_41",
		page = "IslandTradePage",
		condition = function()
			return getProxy(IslandProxy):GetIsland():GetTaskAgency():IsFinishTask(var0_0.PURCHASE_TRADE_TASK_ID)
		end,
		type = var0_0.FINISH_TYPE.ON_END
	},
	{
		id = "ISLAND_GUIDE_42",
		page = "IslandTradePage",
		condition = function()
			return getProxy(IslandProxy):GetIsland():GetTaskAgency():IsFinishTask(var0_0.SELL_TRADE_TASK_ID)
		end,
		type = var0_0.FINISH_TYPE.ON_END
	}
}

function var0_0.CheckOnLoaded(arg0_18, arg1_18)
	local var0_18 = _.detect(var0_0.loadedConfig, function(arg0_19)
		local var0_19 = arg0_19.id
		local var1_19 = arg0_19.mapId
		local var2_19 = arg0_19.condition

		return not pg.NewStoryMgr.GetInstance():IsPlayed(var0_19) and (var1_19 == 0 or var1_19 == arg0_18) and var2_19()
	end)

	if not var0_18 then
		existCall(arg1_18)

		return
	end

	var0_0._PlayGuide(var0_18.id, var0_18.type, arg1_18)
end

function var0_0.CheckOnShowInteraction(arg0_20, arg1_20)
	local var0_20 = _.detect(var0_0.interactionConfig, function(arg0_21)
		local var0_21 = arg0_21.id
		local var1_21 = arg0_21.interactionId
		local var2_21 = arg0_21.condition

		return not pg.NewStoryMgr.GetInstance():IsPlayed(var0_21) and (var1_21 == 0 or var1_21 == arg0_20) and var2_21()
	end)

	if not var0_20 then
		existCall(arg1_20)

		return
	end

	var0_0._PlayGuide(var0_20.id, var0_20.type, arg1_20)
end

function var0_0.CheckOnOpenPage(arg0_22, arg1_22)
	local var0_22 = _.detect(var0_0.pageConfig, function(arg0_23)
		local var0_23 = arg0_23.id
		local var1_23 = arg0_23.page
		local var2_23 = arg0_23.condition

		return not pg.NewStoryMgr.GetInstance():IsPlayed(var0_23) and var1_23 == arg0_22 and var2_23()
	end)

	if not var0_22 then
		existCall(arg1_22)

		return
	end

	var0_0._PlayGuide(var0_22.id, var0_22.type, arg1_22)
end

function var0_0.CheckGuide(arg0_24, arg1_24, arg2_24)
	if pg.NewStoryMgr.GetInstance():IsPlayed(arg0_24) then
		return
	end

	local var0_24 = arg1_24 or var0_0.FINISH_TYPE.ON_BEGIN

	var0_0._PlayGuide(arg0_24, var0_24, arg2_24)
end

function var0_0.CheckGuideWithArgs(arg0_25, arg1_25, arg2_25, arg3_25)
	if pg.NewStoryMgr.GetInstance():IsPlayed(arg0_25) then
		return
	end

	local var0_25 = arg1_25 or var0_0.FINISH_TYPE.ON_BEGIN

	var0_0._PlayGuide(arg0_25, var0_25, arg2_25, arg3_25)
end

function var0_0._PlayGuide(arg0_26, arg1_26, arg2_26, arg3_26)
	if LOCK_ISLAND_GUIDE then
		if arg2_26 then
			arg2_26()
		end

		return
	end

	print("GUIDE:..................." .. arg0_26)

	if pg.SeriesGuideMgr.GetInstance():isRunning() then
		existCall(arg2_26)

		return
	end

	if not pg.NewGuideMgr.GetInstance():CanPlay() then
		existCall(arg2_26)

		return
	end

	if arg1_26 and arg1_26 == var0_0.FINISH_TYPE.ON_BEGIN then
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = arg0_26
		})
	end

	if _IslandCore then
		_IslandCore:Link(ISLAND_EVT.START_GUIDE)
	end

	pg.NewGuideMgr.GetInstance():Play(arg0_26, arg3_26, function()
		if _IslandCore then
			_IslandCore:Link(ISLAND_EVT.END_GUIDE)
		end

		if arg1_26 and arg1_26 == var0_0.FINISH_TYPE.ON_END then
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = arg0_26
			})
		end
	end, arg2_26, function(arg0_28, arg1_28)
		var0_0.Record(arg0_28, arg1_28, arg0_26)
	end)
end

function var0_0.Record(arg0_29, arg1_29, arg2_29)
	local var0_29 = pg.TimeMgr.GetInstance():GetServerTime() - arg1_29

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandGuide(arg0_29, var0_29, arg2_29))
end

return var0_0
