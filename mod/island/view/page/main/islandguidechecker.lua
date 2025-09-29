local var0_0 = class("IslandGuideChecker")

var0_0.MOVE_TASK_ID = 10001000
var0_0.FIRST_TASK_ID = 10001010
var0_0.ORDER_TASK_ID = 10001071
var0_0.ORDER_TASK_PRE_ID = 10001070
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
			local var0_6 = getProxy(IslandProxy):GetIsland()
			local var1_6 = var0_6:GetTaskAgency():GetTask(var0_0.TECH_TASK_ID)
			local var2_6 = var0_6:GetTechnologyAgency():GetTechnology(var0_0.TECH_FIRST_ID):GetStatus()

			return var1_6 and (var2_6 == IslandTechnology.STATUS.LOCK or var2_6 == IslandTechnology.STATUS.UNLOCK or var2_6 == IslandTechnology.STATUS.NORMAL)
		end,
		type = var0_0.FINISH_TYPE.ON_GUIDE
	},
	{
		id = "ISLAND_GUIDE_9",
		page = "IslandInvitePage",
		condition = function()
			local var0_7 = getProxy(IslandProxy):GetIsland():GetTaskAgency()

			return var0_7:IsFinishTask(var0_0.INVITE_TASK_PRE_ID) and not var0_7:IsFinishTask(var0_0.INVITE_TASK_ID)
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
	}
}

function var0_0.CheckOnLoaded(arg0_13, arg1_13)
	local var0_13 = _.detect(var0_0.loadedConfig, function(arg0_14)
		local var0_14 = arg0_14.id
		local var1_14 = arg0_14.mapId
		local var2_14 = arg0_14.condition

		return not pg.NewStoryMgr.GetInstance():IsPlayed(var0_14) and (var1_14 == 0 or var1_14 == arg0_13) and var2_14()
	end)

	if not var0_13 then
		existCall(arg1_13)

		return
	end

	var0_0._PlayGuide(var0_13.id, var0_13.type, arg1_13)
end

function var0_0.CheckOnShowInteraction(arg0_15, arg1_15)
	local var0_15 = _.detect(var0_0.interactionConfig, function(arg0_16)
		local var0_16 = arg0_16.id
		local var1_16 = arg0_16.interactionId
		local var2_16 = arg0_16.condition

		return not pg.NewStoryMgr.GetInstance():IsPlayed(var0_16) and (var1_16 == 0 or var1_16 == arg0_15) and var2_16()
	end)

	if not var0_15 then
		existCall(arg1_15)

		return
	end

	var0_0._PlayGuide(var0_15.id, var0_15.type, arg1_15)
end

function var0_0.CheckOnOpenPage(arg0_17, arg1_17)
	local var0_17 = _.detect(var0_0.pageConfig, function(arg0_18)
		local var0_18 = arg0_18.id
		local var1_18 = arg0_18.page
		local var2_18 = arg0_18.condition

		return not pg.NewStoryMgr.GetInstance():IsPlayed(var0_18) and var1_18 == arg0_17 and var2_18()
	end)

	if not var0_17 then
		existCall(arg1_17)

		return
	end

	var0_0._PlayGuide(var0_17.id, var0_17.type, arg1_17)
end

function var0_0.CheckGuide(arg0_19, arg1_19, arg2_19)
	if pg.NewStoryMgr.GetInstance():IsPlayed(arg0_19) then
		return
	end

	local var0_19 = arg1_19 or var0_0.FINISH_TYPE.ON_BEGIN

	var0_0._PlayGuide(arg0_19, var0_19, arg2_19)
end

function var0_0._PlayGuide(arg0_20, arg1_20, arg2_20)
	if LOCK_ISLAND_GUIDE then
		if arg2_20 then
			arg2_20()
		end

		return
	end

	if pg.SeriesGuideMgr.GetInstance():isRunning() then
		existCall(arg2_20)

		return
	end

	if not pg.NewGuideMgr.GetInstance():CanPlay() then
		existCall(arg2_20)

		return
	end

	if arg1_20 and arg1_20 == var0_0.FINISH_TYPE.ON_BEGIN then
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = arg0_20
		})
	end

	if _IslandCore then
		_IslandCore:Link(ISLAND_EVT.START_GUIDE)
	end

	pg.NewGuideMgr.GetInstance():Play(arg0_20, nil, function()
		if _IslandCore then
			_IslandCore:Link(ISLAND_EVT.END_GUIDE)
		end

		if arg1_20 and arg1_20 == var0_0.FINISH_TYPE.ON_END then
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = arg0_20
			})
		end
	end, arg2_20, function(arg0_22, arg1_22)
		var0_0.Record(arg0_22, arg1_22, arg0_20)
	end)
end

function var0_0.Record(arg0_23, arg1_23, arg2_23)
	local var0_23 = pg.TimeMgr.GetInstance():GetServerTime() - arg1_23

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandGuide(arg0_23, var0_23, arg2_23))
end

return var0_0
