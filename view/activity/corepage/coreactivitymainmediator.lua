local var0_0 = class("CoreActivityMainMediator", import("view.activity.ActivityMediator"))

var0_0.OPEN_CHUANWU = "CoreActivityMainMediator:Open chuanwu"

function var0_0.getDisplayActivity(arg0_1)
	return getProxy(ActivityProxy):getCorePanelActivities(arg0_1.contextData.coreName)
end

function var0_0.register(arg0_2)
	var0_0.super.register(arg0_2)
	arg0_2:bind(var0_0.OPEN_CHUANWU, function(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
		arg0_2:OnSelShips(arg1_3, arg2_3, arg3_3, arg4_3)
	end)
end

function var0_0.initNotificationHandleDic(arg0_4)
	var0_0.super.initNotificationHandleDic(arg0_4)

	arg0_4.handleDic[ActivityProxy.ACTIVITY_SHOW_RED_PACKET_AWARDS] = function(arg0_5, arg1_5)
		local var0_5 = arg1_5:getBody()

		arg0_5.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_5.awards, var0_5.callback)
	end
	arg0_4.handleDic[GAME.ACT_NEW_PT_DONE] = function(arg0_6, arg1_6)
		if getProxy(ContextProxy):getContextByMediator(ActivityBossMediatorTemplate) then
			arg0_6.viewComponent:updateTaskLayers()

			return
		end

		local var0_6 = arg1_6:getBody()

		arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_6.awards, function()
			arg0_6.viewComponent:updateTaskLayers()
			existCall(var0_6.callback)
		end)
	end
end

function var0_0.tryColoringAchieve(arg0_8)
	local var0_8 = getProxy(ColoringProxy):getColorGroups()

	for iter0_8, iter1_8 in ipairs(var0_8) do
		if iter1_8:getState() == ColorGroup.StateFinish and iter1_8:getHasAward() then
			arg0_8:sendNotification(GAME.COLORING_ACHIEVE, {
				activityId = arg0_8.viewComponent.activity.id,
				id = iter1_8.id
			})

			break
		end
	end
end

function var0_0.OnSelShips(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	local var0_9 = getProxy(ActivityProxy):getActivityById(arg1_9)
	local var1_9 = arg0_9:GetSelectedShipIds(arg1_9, arg3_9)
	local var2_9 = {
		callbackQuit = true,
		selectedMax = arg4_9,
		quitTeam = arg3_9 ~= nil,
		ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
			isActivityNpc = true
		}),
		selectedIds = Clone(var1_9),
		preView = arg0_9.viewComponent.__cname,
		hideTagFlags = ShipStatus.TAG_HIDE_BACKYARD,
		blockTagFlags = ShipStatus.TAG_BLOCK_BACKYARD,
		onShip = function(arg0_10, arg1_10, arg2_10)
			return arg0_9:OnShip(arg0_10, arg1_10, arg2_10)
		end,
		onSelected = function(arg0_11, arg1_11)
			arg0_9:OnSelected(arg1_9, arg2_9, arg0_11, arg1_11)
		end,
		priorEquipUpShipIDList = _.filter(var0_9:GetShipIds(), function(arg0_12)
			return arg0_12 > 0
		end),
		leftTopWithFrameInfo = i18n("backyard_longpress_ship_tip")
	}

	var2_9.isLayer = true
	var2_9.energyDisplay = true

	arg0_9:addSubLayers(Context.New({
		viewComponent = DockyardScene,
		mediator = DockyardMediator,
		data = var2_9
	}))
end

function var0_0.GetSelectedShipIds(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg2_13 and arg2_13.id or -1
	local var1_13 = getProxy(ActivityProxy):getActivityById(arg1_13)
	local var2_13 = {}

	for iter0_13, iter1_13 in ipairs(var1_13:GetShipIds()) do
		local var3_13 = iter1_13 > 0 and getProxy(BayProxy):RawGetShipById(iter1_13)

		if var3_13 and var3_13.id ~= var0_13 then
			table.insert(var2_13, var3_13.id)
		end
	end

	return var2_13
end

function var0_0.OnShip(arg0_14, arg1_14, arg2_14, arg3_14)
	local var0_14, var1_14 = ShipStatus.ShipStatusCheck("inBackyard", arg1_14, function(arg0_15)
		arg2_14()
	end)

	return var0_14, var1_14
end

function var0_0.OnSelected(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16)
	local var0_16 = getProxy(ActivityProxy):getActivityById(arg1_16)
	local var1_16 = Clone(var0_16:GetShipIds())

	_.each(_.range(var0_16:GetSlotCount()), function(arg0_17)
		var1_16[arg0_17] = var1_16[arg0_17] or 0
	end)

	if arg3_16 == nil or #arg3_16 == 0 then
		if var1_16[arg2_16] > 0 then
			arg0_16:sendNotification(GAME.ACTIVITY_OPERATION, {
				activity_id = var0_16.id,
				cmd = Spring2Activity.OPERATION_SETSHIP,
				kvargs1 = {
					{
						value = 0,
						key = arg2_16
					}
				}
			})
		end

		existCall(arg4_16)

		return
	end

	local var2_16 = _.filter(arg3_16, function(arg0_18)
		return not table.contains(var1_16, arg0_18)
	end)

	table.Foreach(var1_16, function(arg0_19, arg1_19)
		if arg1_19 == 0 or table.contains(arg3_16, arg1_19) then
			return
		end

		var1_16[arg0_19] = 0
	end)

	if #var2_16 == 1 and var1_16[arg2_16] == 0 then
		var1_16[arg2_16] = var2_16[1]
	else
		local var3_16 = 0

		_.each(var2_16, function(arg0_20)
			while var3_16 <= #var1_16 do
				var3_16 = var3_16 + 1

				if var1_16[var3_16] == 0 then
					break
				end
			end

			var1_16[var3_16] = arg0_20
		end)
	end

	local var4_16 = {}
	local var5_16 = var0_16:GetShipIds()

	table.Foreach(var1_16, function(arg0_21, arg1_21)
		if (var5_16[arg0_21] or 0) ~= arg1_21 then
			table.insert(var4_16, {
				key = arg0_21,
				value = arg1_21
			})
		end
	end)

	if #var4_16 > 0 then
		arg0_16:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = var0_16.id,
			cmd = Spring2Activity.OPERATION_SETSHIP,
			kvargs1 = var4_16
		})
	end

	arg4_16()
end

return var0_0
