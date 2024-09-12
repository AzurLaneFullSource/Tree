local var0_0 = class("NewYearHotSpringMediator", import("view.base.ContextMediator"))

var0_0.UNLOCK_SLOT = "UNLOCK_SLOT"
var0_0.OPEN_INFO = "OPEN_INFO"
var0_0.OPEN_CHUANWU = "NewYearHotSpringMediator:Open chuanwu"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.UNLOCK_SLOT, function(arg0_2, arg1_2)
		local var0_2, var1_2 = arg0_1.activity:GetUpgradeCost()

		MsgboxMediator.ShowMsgBox({
			type = MSGBOX_TYPE_NORMAL,
			content = i18n("hotspring_expand", var1_2),
			contextSprites = {
				{
					name = "wenquanbi",
					path = "props/wenquanbi"
				}
			},
			onYes = function()
				if arg0_1.activity:GetCoins() < var1_2 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("hotspring_tip2"))

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

	arg0_1.activity = var0_1

	arg0_1.viewComponent:SetActivity(var0_1)
	arg0_1:bind(var0_0.OPEN_INFO, function()
		arg0_1:addSubLayers(Context.New({
			mediator = NewYearHotSpringShipSelectMediator,
			viewComponent = NewYearHotSpringShipSelectLayer,
			data = {
				actId = var0_1.id
			}
		}))
	end)
end

function var0_0.GetGetSlotCount(arg0_6)
	return arg0_6.activity:GetSlotCount()
end

function var0_0.OnSelShips(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7:GetSelectedShipIds(arg2_7)
	local var1_7 = {
		callbackQuit = true,
		selectedMax = arg0_7:GetGetSlotCount(),
		quitTeam = arg2_7 ~= nil,
		ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
			isActivityNpc = true
		}),
		selectedIds = Clone(var0_7),
		preView = arg0_7.viewComponent.__cname,
		hideTagFlags = ShipStatus.TAG_HIDE_BACKYARD,
		blockTagFlags = ShipStatus.TAG_BLOCK_BACKYARD,
		onShip = function(arg0_8, arg1_8, arg2_8)
			return arg0_7:OnShip(arg0_8, arg1_8, arg2_8)
		end,
		onSelected = function(arg0_9, arg1_9)
			arg0_7:OnSelected(arg1_7, arg0_9, arg1_9)
		end,
		priorEquipUpShipIDList = _.filter(arg0_7.activity:GetShipIds(), function(arg0_10)
			return arg0_10 > 0
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

function var0_0.OnShip(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12, var1_12 = ShipStatus.ShipStatusCheck("inBackyard", arg1_12, function(arg0_13)
		arg2_12()
	end)

	return var0_12, var1_12
end

function var0_0.OnSelected(arg0_14, arg1_14, arg2_14, arg3_14)
	local var0_14 = Clone(arg0_14.activity:GetShipIds())

	_.each(_.range(arg0_14.activity:GetSlotCount()), function(arg0_15)
		var0_14[arg0_15] = var0_14[arg0_15] or 0
	end)

	if arg2_14 == nil or #arg2_14 == 0 then
		if var0_14[arg1_14] > 0 then
			arg0_14:sendNotification(GAME.ACTIVITY_OPERATION, {
				activity_id = arg0_14.activity.id,
				cmd = SpringActivity.OPERATION_SETSHIP,
				kvargs1 = {
					{
						value = 0,
						key = arg1_14
					}
				}
			})
		end

		existCall(arg3_14)

		return
	end

	local var1_14 = _.filter(arg2_14, function(arg0_16)
		return not table.contains(var0_14, arg0_16)
	end)

	table.Foreach(var0_14, function(arg0_17, arg1_17)
		if arg1_17 == 0 or table.contains(arg2_14, arg1_17) then
			return
		end

		var0_14[arg0_17] = 0
	end)

	if #var1_14 == 1 and var0_14[arg1_14] == 0 then
		var0_14[arg1_14] = var1_14[1]
	else
		local var2_14 = 0

		_.each(var1_14, function(arg0_18)
			while var2_14 <= #var0_14 do
				var2_14 = var2_14 + 1

				if var0_14[var2_14] == 0 then
					break
				end
			end

			var0_14[var2_14] = arg0_18
		end)
	end

	local var3_14 = {}
	local var4_14 = arg0_14.activity:GetShipIds()

	table.Foreach(var0_14, function(arg0_19, arg1_19)
		if (var4_14[arg0_19] or 0) ~= arg1_19 then
			table.insert(var3_14, {
				key = arg0_19,
				value = arg1_19
			})
		end
	end)

	if #var3_14 > 0 then
		arg0_14:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = arg0_14.activity.id,
			cmd = SpringActivity.OPERATION_SETSHIP,
			kvargs1 = var3_14
		})
	end

	arg3_14()
end

function var0_0.listNotificationInterests(arg0_20)
	return {
		PlayerProxy.UPDATED,
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		var0_0.OPEN_CHUANWU,
		var0_0.UNLOCK_SLOT
	}
end

function var0_0.handleNotification(arg0_21, arg1_21)
	local var0_21 = arg1_21:getName()
	local var1_21 = arg1_21:getBody()

	if var0_21 == nil then
		-- block empty
	elseif var0_21 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0_21.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_21.awards, var1_21.callback)
	elseif var0_21 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_21:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
			arg0_21.activity = var1_21

			arg0_21.viewComponent:SetActivity(var1_21)
			arg0_21.viewComponent:UpdateView()
		end
	elseif var0_21 == var0_0.OPEN_CHUANWU then
		arg0_21.viewComponent:emit(var0_0.OPEN_CHUANWU, unpack(var1_21))
	elseif var0_21 == var0_0.UNLOCK_SLOT then
		arg0_21.viewComponent:emit(var0_0.UNLOCK_SLOT, var1_21)
	end
end

function var0_0.remove(arg0_22)
	return
end

return var0_0
