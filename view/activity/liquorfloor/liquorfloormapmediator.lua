local var0_0 = class("LiquorFloorMapMediator", import("view.base.ContextMediator"))

var0_0.ADD_WORKPLACE = "LiquorFloorMapMediator:ADD_WORKPLACE"
var0_0.ALL_WORKPLACE = "LiquorFloorMapMediator:ALL_WORKPLACE"
var0_0.OPEN_CHUANWU = "LiquorFloorMapMediator:OPEN_CHUANWU"
var0_0.UPGRADE_WORKPLACE = "LiquorFloorMapMediator:UPGRADE_WORKPLACE"
var0_0.CLICK_BUBBLE = "LiquorFloorMapMediator:CLICK_BUBBLE"
var0_0.GO_FIGHT = "LiquorFloorMapMediator:GO_FIGHT"
var0_0.OPEN_CLUE_BOOK = "LiquorFloorMapMediator.OPEN_CLUE_BOOK"
var0_0.OPEN_LAYER = "LiquorFloorMapMediator:OPEN_LAYER"

function var0_0.register(arg0_1)
	arg0_1.upgradeplaceData = nil
	arg0_1.indexplaceData = nil

	arg0_1:bind(var0_0.OPEN_CHUANWU, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:OnSelShips(arg1_2, arg2_2, arg3_2)
	end)
	arg0_1:bind(var0_0.ADD_WORKPLACE, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.ACTIVITY_TOWN_OP, {
			activity_id = arg0_1.activity.id,
			arg1 = arg1_3,
			cmd = TownActivity2.OPERATION.SETTLE_GOLD
		})
	end)
	arg0_1:bind(var0_0.ALL_WORKPLACE, function(arg0_4)
		arg0_1:sendNotification(GAME.ACTIVITY_TOWN_OP, {
			activity_id = arg0_1.activity.id,
			cmd = TownActivity2.OPERATION.ALL_GOLD
		})
	end)
	arg0_1:bind(var0_0.UPGRADE_WORKPLACE, function(arg0_5, arg1_5, arg2_5, arg3_5)
		arg0_1.upgradeplaceData = arg2_5
		arg0_1.indexplaceData = arg3_5

		arg0_1:sendNotification(GAME.ACTIVITY_TOWN_OP, {
			activity_id = arg0_1.activity.id,
			cmd = TownActivity2.OPERATION.UPGRADE_PLACE,
			arg1 = arg1_5
		})
	end)
	arg0_1:bind(var0_0.CLICK_BUBBLE, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.ACTIVITY_TOWN_OP, {
			activity_id = arg0_1.activity.id,
			cmd = TownActivity2.OPERATION.CLICK_BUBBLE,
			arg_list = arg1_6
		})
	end)
	arg0_1:bind(var0_0.OPEN_CLUE_BOOK, function(arg0_7, arg1_7)
		arg0_1:addSubLayers(Context.New({
			viewComponent = LiquorFloorBookLayer,
			mediator = LiquorFloorBookMediator
		}))
	end)
	arg0_1:bind(var0_0.GO_FIGHT, function(arg0_8, arg1_8)
		local var0_8 = getProxy(ChapterProxy)
		local var1_8, var2_8 = var0_8:getLastMapForActivity()

		if not var1_8 or not var0_8:getMapById(var1_8):isUnlock() then
			local var3_8 = getProxy(ChapterProxy)
			local var4_8 = var3_8:getActiveChapter()

			var1_8 = var4_8 and var4_8:getConfig("map")

			if not var4_8 then
				var1_8 = var3_8:GetLastNormalMap()
			end

			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var4_8 and var4_8.id,
				mapIdx = var1_8
			})
		else
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_8,
				mapIdx = var1_8
			})
		end
	end)
	arg0_1:bind(var0_0.OPEN_LAYER, function(arg0_9, arg1_9)
		arg0_1:addSubLayers(arg1_9)
	end)

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN2)

	if not var0_1 or var0_1:isEnd() then
		assert(nil, "not exist act")

		return
	end

	arg0_1.activity = var0_1

	arg0_1.viewComponent:SetActivity(var0_1)
end

function var0_0.ChangeShips(arg0_10, arg1_10, arg2_10)
	arg0_10:sendNotification(GAME.ACTIVITY_TOWN_OP, {
		activity_id = arg0_10.activity.id,
		cmd = TownActivity.OPERATION.CHANGE_SHIPS,
		kvargs1 = arg1_10,
		arg1 = arg2_10
	})
end

function var0_0.OnSelShips(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = arg0_11:GetSelectedShipIds(arg2_11)
	local var1_11 = {
		selectedMin = 0,
		callbackQuit = true,
		selectedMax = arg0_11.activity:GetUnlockSlotCnt(),
		quitTeam = arg2_11 ~= nil,
		ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
			isActivityNpc = true
		}),
		selectedIds = Clone(var0_11),
		preView = arg0_11.viewComponent.__cname,
		hideTagFlags = ShipStatus.TAG_HIDE_BACKYARD,
		blockTagFlags = ShipStatus.TAG_BLOCK_BACKYARD,
		onSelected = function(arg0_12, arg1_12)
			arg0_11:OnSelected(arg1_11, arg0_12, arg1_12, arg3_11)
		end,
		priorEquipUpShipIDList = _.filter(arg0_11.activity:GetShipIds(), function(arg0_13)
			return arg0_13 > 0
		end),
		leftTopWithFrameInfo = i18n("backyard_longpress_ship_tip")
	}

	var1_11.isLayer = true
	var1_11.energyDisplay = true

	arg0_11:addSubLayers(Context.New({
		viewComponent = DockyardScene,
		mediator = DockyardMediator,
		data = var1_11
	}))
end

function var0_0.OnSelected(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14)
	local var0_14 = Clone(arg0_14.activity:GetShipIds())
	local var1_14 = {}
	local var2_14 = {}

	if arg2_14 == nil or #arg2_14 == 0 then
		for iter0_14, iter1_14 in ipairs(var0_14) do
			if iter1_14 > 0 then
				table.insert(var2_14, {
					value = 0,
					key = iter0_14
				})
			end
		end
	else
		for iter2_14, iter3_14 in ipairs(var0_14) do
			local var3_14 = arg2_14[iter2_14]

			if not var3_14 then
				table.insert(var2_14, {
					value = 0,
					key = iter2_14
				})
			elseif var3_14 ~= iter3_14 then
				table.insert(var2_14, {
					key = iter2_14,
					value = var3_14
				})
			end
		end
	end

	if #var2_14 > 0 then
		arg0_14:ChangeShips(var2_14, arg4_14)
	end

	existCall(arg3_14)
end

function var0_0.GetSelectedShipIds(arg0_15, arg1_15)
	local var0_15 = arg1_15 and arg1_15.id or -1
	local var1_15 = {}

	for iter0_15, iter1_15 in ipairs(arg0_15.activity:GetShipIds()) do
		local var2_15 = iter1_15 > 0 and getProxy(BayProxy):RawGetShipById(iter1_15)

		if var2_15 and var2_15.id ~= var0_15 then
			table.insert(var1_15, var2_15.id)
		end
	end

	return var1_15
end

function var0_0.listNotificationInterests(arg0_16)
	return {
		GAME.ACTIVITY_TOWN_OP_DONE,
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.SUBMIT_TASK_AWARD_DOWN,
		GAME.TOTAL_TASK_UPDATED
	}
end

function var0_0.handleNotification(arg0_17, arg1_17)
	local var0_17 = arg1_17:getName()
	local var1_17 = arg1_17:getBody()

	if var0_17 == GAME.ACTIVITY_TOWN_OP_DONE then
		switch(var1_17.cmd, {
			[TownActivity2.OPERATION.UPGRADE_PLACE] = function()
				arg0_17.viewComponent:InitData()

				arg0_17.placeData = arg0_17.activity:GetPlaceList()

				arg0_17.viewComponent:OnBox(arg0_17.placeData[arg0_17.indexplaceData], arg0_17.indexplaceData, arg0_17.activity)
				arg0_17.viewComponent:OnBox(arg0_17.placeData[arg0_17.indexplaceData], arg0_17.indexplaceData, arg0_17.activity)

				arg0_17.upgradeplaceData = nil
				arg0_17.indexplaceData = nil
			end,
			[TownActivity2.OPERATION.CHANGE_SHIPS] = function()
				arg0_17.viewComponent:InitData()
				arg0_17.viewComponent:UpdateBubbles()
				setActive(arg0_17.viewComponent.box, false)
			end,
			[TownActivity2.OPERATION.CLICK_BUBBLE] = function()
				arg0_17.viewComponent:InitData()
				arg0_17.viewComponent:UpdateBubbles()
				arg0_17.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_17.awards)
			end,
			[TownActivity2.OPERATION.SETTLE_GOLD] = function()
				arg0_17.viewComponent:InitData()
				arg0_17.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_17.awards)
			end,
			[TownActivity2.OPERATION.ALL_GOLD] = function()
				arg0_17.viewComponent:InitData()
				arg0_17.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_17.awards)
			end
		})
	elseif var0_17 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_17:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TOWN2 then
			arg0_17.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN2)

			arg0_17.viewComponent:SetActivity(arg0_17.activity)
			arg0_17.viewComponent:InitData()
		end
	elseif var0_17 == GAME.SUBMIT_TASK_AWARD_DOWN or var0_17 == GAME.TOTAL_TASK_UPDATED then
		arg0_17.viewComponent:RefreshRedPoint()
	end

	arg0_17.viewComponent:OnStoryList()
end

return var0_0
