local var0_0 = class("TongXinSpringMediator", import("..base.ContextMediator"))

var0_0.UNLOCK_SLOT = "TongXinSpringMediator:UNLOCK_SLOT"
var0_0.OPEN_CHUANWU = "TongXinSpringMediator:Open chuanwu"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.UNLOCK_SLOT, function(arg0_2, arg1_2)
		local var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)
		local var1_2, var2_2 = var0_2:GetUpgradeCost()

		MsgboxMediator.ShowMsgBox({
			type = MSGBOX_TYPE_NORMAL,
			content = i18n("202406_wenquan_unlock", var2_2),
			contextSprites = {
				{
					name = "wenquanbi",
					path = "props/wenquanbi"
				}
			},
			onYes = function()
				if var0_2:GetCoins() < var2_2 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("202406_wenquan_unlock_tip2"))

					return
				end

				arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
					activity_id = arg1_2,
					cmd = SpringActivity.OPERATION_UNLOCK
				})
			end
		})
	end)
	arg0_1:bind(var0_0.OPEN_CHUANWU, function(arg0_4, arg1_4, arg2_4)
		arg0_1:OnSelShips(arg1_4, arg2_4)
	end)

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)

	arg0_1.viewComponent:InitActivity(var0_1)
end

function var0_0.OnSelShips(arg0_5, arg1_5, arg2_5)
	local var0_5 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)
	local var1_5 = arg0_5:GetSelectedShipIds(arg2_5)
	local var2_5 = {
		callbackQuit = true,
		selectedMax = var0_5:GetSlotCount(),
		quitTeam = arg2_5 ~= nil,
		ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
			isActivityNpc = true
		}),
		selectedIds = Clone(var1_5),
		preView = arg0_5.viewComponent.__cname,
		hideTagFlags = ShipStatus.TAG_HIDE_BACKYARD,
		blockTagFlags = ShipStatus.TAG_BLOCK_BACKYARD,
		onShip = function(arg0_6, arg1_6, arg2_6)
			return arg0_5:OnShip(arg0_6, arg1_6, arg2_6)
		end,
		onSelected = function(arg0_7, arg1_7)
			arg0_5:OnSelected(arg1_5, arg0_7, arg1_7)
		end,
		priorEquipUpShipIDList = _.filter(var0_5:GetShipIds(), function(arg0_8)
			return arg0_8 > 0
		end),
		leftTopWithFrameInfo = i18n("backyard_longpress_ship_tip")
	}

	var2_5.isLayer = true
	var2_5.energyDisplay = true

	arg0_5:addSubLayers(Context.New({
		viewComponent = DockyardScene,
		mediator = DockyardMediator,
		data = var2_5
	}))
end

function var0_0.OnSelected(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)
	local var1_9 = Clone(var0_9:GetShipIds())

	_.each(_.range(var0_9:GetSlotCount()), function(arg0_10)
		var1_9[arg0_10] = var1_9[arg0_10] or 0
	end)

	if arg2_9 == nil or #arg2_9 == 0 then
		if var1_9[arg1_9] > 0 then
			arg0_9:sendNotification(GAME.ACTIVITY_OPERATION, {
				activity_id = var0_9.id,
				cmd = SpringActivity.OPERATION_SETSHIP,
				kvargs1 = {
					{
						value = 0,
						key = arg1_9
					}
				}
			})
		end

		existCall(arg3_9)

		return
	end

	local var2_9 = _.filter(arg2_9, function(arg0_11)
		return not table.contains(var1_9, arg0_11)
	end)

	table.Foreach(var1_9, function(arg0_12, arg1_12)
		if arg1_12 == 0 or table.contains(arg2_9, arg1_12) then
			return
		end

		var1_9[arg0_12] = 0
	end)

	if #var2_9 == 1 and var1_9[arg1_9] == 0 then
		var1_9[arg1_9] = var2_9[1]
	else
		local var3_9 = 0

		_.each(var2_9, function(arg0_13)
			while var3_9 <= #var1_9 do
				var3_9 = var3_9 + 1

				if var1_9[var3_9] == 0 then
					break
				end
			end

			var1_9[var3_9] = arg0_13
		end)
	end

	local var4_9 = {}
	local var5_9 = var0_9:GetShipIds()

	table.Foreach(var1_9, function(arg0_14, arg1_14)
		if (var5_9[arg0_14] or 0) ~= arg1_14 then
			table.insert(var4_9, {
				key = arg0_14,
				value = arg1_14
			})
		end
	end)

	if #var4_9 > 0 then
		arg0_9:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = var0_9.id,
			cmd = SpringActivity.OPERATION_SETSHIP,
			kvargs1 = var4_9
		})
	end

	arg3_9()
end

function var0_0.GetSelectedShipIds(arg0_15, arg1_15)
	local var0_15 = arg1_15 and arg1_15.id or -1
	local var1_15 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)
	local var2_15 = {}

	for iter0_15, iter1_15 in ipairs(var1_15:GetShipIds()) do
		local var3_15 = iter1_15 > 0 and getProxy(BayProxy):RawGetShipById(iter1_15)

		if var3_15 and var3_15.id ~= var0_15 then
			table.insert(var2_15, var3_15.id)
		end
	end

	return var2_15
end

function var0_0.OnShip(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16, var1_16 = ShipStatus.ShipStatusCheck("inBackyard", arg1_16, function(arg0_17)
		arg2_16()
	end)

	return var0_16, var1_16
end

function var0_0.listNotificationInterests(arg0_18)
	return {
		ActivityProxy.ACTIVITY_OPERATION_DONE,
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		var0_0.OPEN_CHUANWU,
		var0_0.UNLOCK_SLOT
	}
end

function var0_0.handleNotification(arg0_19, arg1_19)
	local var0_19 = arg1_19:getName()
	local var1_19 = arg1_19:getBody()

	if var0_19 == nil then
		-- block empty
	elseif var0_19 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0_19.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_19.awards, var1_19.callback)
	elseif var0_19 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_19:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
			arg0_19.viewComponent:UpdateActivity(var1_19)
		end
	elseif var0_19 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		local var2_19 = getProxy(ActivityProxy):getActivityById(var1_19)

		if var2_19:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
			arg0_19.viewComponent:UpdateActivity(var2_19)
		end
	elseif var0_19 == var0_0.OPEN_CHUANWU then
		arg0_19.viewComponent:emit(var0_0.OPEN_CHUANWU, unpack(var1_19))
	elseif var0_19 == var0_0.UNLOCK_SLOT then
		arg0_19.viewComponent:emit(var0_0.UNLOCK_SLOT, var1_19)
	end
end

return var0_0
