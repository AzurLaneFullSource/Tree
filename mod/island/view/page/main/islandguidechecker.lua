local var0_0 = class("IslandGuideChecker")

var0_0.MOVE_TASK_ID = 10010000
var0_0.FIRST_TASK_ID = 10010001
var0_0.ORDER_TASK_ID = 10010033
var0_0.ORDER_TASK_PRE_ID = 10010008
var0_0.TECH_TASK_ID = 10010037
var0_0.MAP_GUIDE_ABILITY_ID = 5004
var0_0.INVITE_TASK_ID = 10010036
var0_0.INVITE_TASK_PRE_ID = 10010035
var0_0.MANAGE_ABILITY_ID = 26
var0_0.MINING_ABILITY_ID = 2003
var0_0.PASTIRE_ABILITY_ID = 2002
var0_0.COMBP_ABILITY_ID = 29001
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
			return true
		end,
		mapId = IslandConst.AGORA_MAP_ID,
		type = var0_0.FINISH_TYPE.ON_BEGIN
	},
	{
		id = "ISLAND_GUIDE_27",
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
		id = "ISLAND_GUIDE_8",
		interactionId = 10070004,
		condition = function()
			return getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTask(var0_0.TECH_TASK_ID)
		end,
		type = var0_0.FINISH_TYPE.ON_GUIDE
	}
}
var0_0.pageConfig = {
	{
		id = "ISLAND_GUIDE_6",
		page = "IslandMapPage",
		condition = function()
			return getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(var0_0.MAP_GUIDE_ABILITY_ID)
		end,
		type = var0_0.FINISH_TYPE.ON_BEGIN
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
		id = "ISLAND_GUIDE_21",
		page = "IslandShipOrderPage",
		condition = function()
			return true
		end,
		type = var0_0.FINISH_TYPE.ON_BEGIN
	},
	{
		id = "ISLAND_GUIDE_28",
		page = "IslandSetMealHandbookPage",
		condition = function()
			return getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(var0_0.COMBP_ABILITY_ID)
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
		id = "ISLAND_GUIDE_30",
		page = "IslandInventoryPage",
		condition = function()
			return true
		end,
		type = var0_0.FINISH_TYPE.ON_BEGIN
	}
}

function var0_0.CheckOnLoaded(arg0_12, arg1_12)
	local var0_12 = _.detect(var0_0.loadedConfig, function(arg0_13)
		local var0_13 = arg0_13.id
		local var1_13 = arg0_13.mapId
		local var2_13 = arg0_13.condition

		return not pg.NewStoryMgr.GetInstance():IsPlayed(var0_13) and (var1_13 == 0 or var1_13 == arg0_12) and var2_13()
	end)

	if not var0_12 then
		existCall(arg1_12)

		return
	end

	var0_0._PlayGuide(var0_12.id, var0_12.type, arg1_12)
end

function var0_0.CheckOnShowInteraction(arg0_14, arg1_14)
	local var0_14 = _.detect(var0_0.interactionConfig, function(arg0_15)
		local var0_15 = arg0_15.id
		local var1_15 = arg0_15.interactionId
		local var2_15 = arg0_15.condition

		return not pg.NewStoryMgr.GetInstance():IsPlayed(var0_15) and (var1_15 == 0 or var1_15 == arg0_14) and var2_15()
	end)

	if not var0_14 then
		existCall(arg1_14)

		return
	end

	var0_0._PlayGuide(var0_14.id, var0_14.type, arg1_14)
end

function var0_0.CheckOnOpenPage(arg0_16, arg1_16)
	local var0_16 = _.detect(var0_0.pageConfig, function(arg0_17)
		local var0_17 = arg0_17.id
		local var1_17 = arg0_17.page
		local var2_17 = arg0_17.condition

		return not pg.NewStoryMgr.GetInstance():IsPlayed(var0_17) and var1_17 == arg0_16 and var2_17()
	end)

	if not var0_16 then
		existCall(arg1_16)

		return
	end

	var0_0._PlayGuide(var0_16.id, var0_16.type, arg1_16)
end

function var0_0.CheckGuide(arg0_18, arg1_18, arg2_18)
	if pg.NewStoryMgr.GetInstance():IsPlayed(arg0_18) then
		return
	end

	local var0_18 = arg1_18 or var0_0.FINISH_TYPE.ON_BEGIN

	var0_0._PlayGuide(arg0_18, var0_18, arg2_18)
end

function var0_0._PlayGuide(arg0_19, arg1_19, arg2_19)
	if LOCK_ISLAND_GUIDE then
		if arg2_19 then
			arg2_19()
		end

		return
	end

	if pg.SeriesGuideMgr.GetInstance():isRunning() then
		existCall(arg2_19)

		return
	end

	if not pg.NewGuideMgr.GetInstance():CanPlay() then
		existCall(arg2_19)

		return
	end

	if arg1_19 and arg1_19 == var0_0.FINISH_TYPE.ON_BEGIN then
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = arg0_19
		})
	end

	if _IslandCore then
		_IslandCore:Link(ISLAND_EVT.START_GUIDE)
	end

	pg.NewGuideMgr.GetInstance():Play(arg0_19, nil, function()
		if _IslandCore then
			_IslandCore:Link(ISLAND_EVT.END_GUIDE)
		end

		if arg1_19 and arg1_19 == var0_0.FINISH_TYPE.ON_END then
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = arg0_19
			})
		end
	end, arg2_19, function(arg0_21, arg1_21)
		var0_0.Record(arg0_21, arg1_21, arg0_19)
	end)
end

function var0_0.Record(arg0_22, arg1_22, arg2_22)
	local var0_22 = pg.TimeMgr.GetInstance():GetServerTime() - arg1_22

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandGuide(arg0_22, var0_22, arg2_22))
end

return var0_0
