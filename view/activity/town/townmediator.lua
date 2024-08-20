local var0_0 = class("TownMediator", import("view.base.ContextMediator"))

var0_0.OPEN_CHUANWU = "TownMediator:OPEN_CHUANWU"
var0_0.UPGRADE_TOWN = "TownMediator:UPGRADE_TOWN"
var0_0.UPGRADE_WORKPLACE = "TownMediator:UPGRADE_WORKPLACE"
var0_0.CLICK_BUBBLE = "TownMediator:CLICK_BUBBLE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_CHUANWU, function(arg0_2, arg1_2, arg2_2)
		arg0_1:OnSelShips(arg1_2, arg2_2)
	end)
	arg0_1:bind(var0_0.UPGRADE_TOWN, function(arg0_3)
		arg0_1:sendNotification(GAME.ACTIVITY_TOWN_OP, {
			activity_id = arg0_1.activity.id,
			cmd = TownActivity.OPERATION.UPGRADE_TOWN
		})
	end)
	arg0_1:bind(var0_0.UPGRADE_WORKPLACE, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.ACTIVITY_TOWN_OP, {
			activity_id = arg0_1.activity.id,
			cmd = TownActivity.OPERATION.UPGRADE_PLACE,
			arg1 = arg1_4
		})
	end)
	arg0_1:bind(var0_0.CLICK_BUBBLE, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.ACTIVITY_TOWN_OP, {
			activity_id = arg0_1.activity.id,
			cmd = TownActivity.OPERATION.CLICK_BUBBLE,
			arg_list = arg1_5
		})
	end)

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN)

	if not var0_1 or var0_1:isEnd() then
		assert(nil, "not exist act")

		return
	end

	arg0_1.activity = var0_1

	arg0_1.viewComponent:SetActivity(var0_1)
end

function var0_0.ChangeShips(arg0_6, arg1_6)
	arg0_6:sendNotification(GAME.ACTIVITY_TOWN_OP, {
		activity_id = arg0_6.activity.id,
		cmd = TownActivity.OPERATION.CHANGE_SHIPS,
		kvargs1 = arg1_6
	})
end

function var0_0.OnSelShips(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7:GetSelectedShipIds(arg2_7)
	local var1_7 = {
		selectedMin = 0,
		callbackQuit = true,
		selectedMax = arg0_7.activity:GetUnlockSlotCnt(),
		quitTeam = arg2_7 ~= nil,
		ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
			isActivityNpc = true
		}),
		selectedIds = Clone(var0_7),
		preView = arg0_7.viewComponent.__cname,
		hideTagFlags = ShipStatus.TAG_HIDE_BACKYARD,
		blockTagFlags = ShipStatus.TAG_BLOCK_BACKYARD,
		onSelected = function(arg0_8, arg1_8)
			arg0_7:OnSelected(arg1_7, arg0_8, arg1_8)
		end,
		priorEquipUpShipIDList = _.filter(arg0_7.activity:GetShipIds(), function(arg0_9)
			return arg0_9 > 0
		end),
		leftTopWithFrameInfo = i18n("backyard_longpress_ship_tip")
	}

	var1_7.isLayer = true
	var1_7.energyDisplay = true

	arg0_7:addSubLayers(Context.New({
		viewComponent = DockyardScene,
		mediator = DockyardMediator,
		data = var1_7
	}))
end

function var0_0.OnSelected(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = Clone(arg0_10.activity:GetShipIds())
	local var1_10 = {}
	local var2_10 = {}

	if arg2_10 == nil or #arg2_10 == 0 then
		for iter0_10, iter1_10 in ipairs(var0_10) do
			if iter1_10 > 0 then
				table.insert(var2_10, {
					value = 0,
					key = iter0_10
				})
			end
		end
	else
		for iter2_10, iter3_10 in ipairs(var0_10) do
			local var3_10 = arg2_10[iter2_10]

			if not var3_10 then
				table.insert(var2_10, {
					value = 0,
					key = iter2_10
				})
			elseif var3_10 ~= iter3_10 then
				table.insert(var2_10, {
					key = iter2_10,
					value = var3_10
				})
			end
		end
	end

	if #var2_10 > 0 then
		arg0_10:ChangeShips(var2_10)
	end

	existCall(arg3_10)
end

function var0_0.GetSelectedShipIds(arg0_11, arg1_11)
	local var0_11 = arg1_11 and arg1_11.id or -1
	local var1_11 = {}

	for iter0_11, iter1_11 in ipairs(arg0_11.activity:GetShipIds()) do
		local var2_11 = iter1_11 > 0 and getProxy(BayProxy):RawGetShipById(iter1_11)

		if var2_11 and var2_11.id ~= var0_11 then
			table.insert(var1_11, var2_11.id)
		end
	end

	return var1_11
end

function var0_0.listNotificationInterests(arg0_12)
	return {
		GAME.ACTIVITY_TOWN_OP_DONE,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_13, arg1_13)
	local var0_13 = arg1_13:getName()
	local var1_13 = arg1_13:getBody()

	if var0_13 == GAME.ACTIVITY_TOWN_OP_DONE then
		switch(var1_13.cmd, {
			[TownActivity.OPERATION.UPGRADE_TOWN] = function()
				local var0_14 = pg.activity_town_level[arg0_13.activity:GetTownLevel()]

				seriesAsync({
					function(arg0_15)
						arg0_13.viewComponent:OnTownUpgrade(arg0_15)
					end,
					function(arg0_16)
						local var0_16 = var0_14.unlock_story

						if var0_16 ~= "" then
							pg.NewStoryMgr.GetInstance():Play(var0_16, arg0_16)
						else
							arg0_16()
						end
					end,
					function(arg0_17)
						local var0_17 = var0_14.unlock_work

						if #var0_17[1] > 0 or #var0_17[2] > 0 then
							arg0_13:addSubLayers(Context.New({
								mediator = TownUnlockMediator,
								viewComponent = TownUnlockLayer,
								data = {
									newIds = var0_17[1],
									limitIds = var0_17[2],
									removeFunc = arg0_17
								}
							}))
						else
							arg0_17()
						end
					end
				}, function()
					return
				end)
			end,
			[TownActivity.OPERATION.UPGRADE_PLACE] = function()
				seriesAsync({
					function(arg0_20)
						arg0_13.viewComponent:OnPlaceUpgrade(arg0_20)
					end,
					function(arg0_21)
						arg0_13.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_13.awards)
					end
				}, function()
					return
				end)
			end,
			[TownActivity.OPERATION.CHANGE_SHIPS] = function()
				arg0_13.viewComponent:UpdateShips()
				arg0_13.viewComponent:UpdateInfoPage()
			end,
			[TownActivity.OPERATION.CLICK_BUBBLE] = function()
				arg0_13.viewComponent:UpdateBubbles()
				arg0_13.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_13.awards)
			end
		})
	elseif var0_13 == ActivityProxy.ACTIVITY_UPDATED and var1_13:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TOWN then
		arg0_13.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN)

		arg0_13.viewComponent:SetActivity(arg0_13.activity)
		arg0_13.viewComponent:UpdateGold()
		arg0_13.viewComponent:OnExpUpdate()
	end
end

return var0_0
