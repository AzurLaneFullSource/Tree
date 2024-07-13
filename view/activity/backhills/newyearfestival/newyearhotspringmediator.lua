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

function var0_0.OnSelShips(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6:GetSelectedShipIds(arg2_6)
	local var1_6 = {
		callbackQuit = true,
		selectedMax = arg0_6.activity:GetSlotCount(),
		quitTeam = arg2_6 ~= nil,
		ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
			isActivityNpc = true
		}),
		selectedIds = Clone(var0_6),
		preView = arg0_6.viewComponent.__cname,
		hideTagFlags = ShipStatus.TAG_HIDE_BACKYARD,
		blockTagFlags = ShipStatus.TAG_BLOCK_BACKYARD,
		onShip = function(arg0_7, arg1_7, arg2_7)
			return arg0_6:OnShip(arg0_7, arg1_7, arg2_7)
		end,
		onSelected = function(arg0_8, arg1_8)
			arg0_6:OnSelected(arg1_6, arg0_8, arg1_8)
		end,
		priorEquipUpShipIDList = _.filter(arg0_6.activity:GetShipIds(), function(arg0_9)
			return arg0_9 > 0
		end),
		leftTopWithFrameInfo = i18n("backyard_longpress_ship_tip")
	}

	var1_6.isLayer = true
	var1_6.energyDisplay = true

	arg0_6:addSubLayers(Context.New({
		viewComponent = DockyardScene,
		mediator = DockyardMediator,
		data = var1_6
	}))
end

function var0_0.GetSelectedShipIds(arg0_10, arg1_10)
	local var0_10 = arg1_10 and arg1_10.id or -1
	local var1_10 = {}

	for iter0_10, iter1_10 in ipairs(arg0_10.activity:GetShipIds()) do
		local var2_10 = iter1_10 > 0 and getProxy(BayProxy):RawGetShipById(iter1_10)

		if var2_10 and var2_10.id ~= var0_10 then
			table.insert(var1_10, var2_10.id)
		end
	end

	return var1_10
end

function var0_0.OnShip(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11, var1_11 = ShipStatus.ShipStatusCheck("inBackyard", arg1_11, function(arg0_12)
		arg2_11()
	end)

	return var0_11, var1_11
end

function var0_0.OnSelected(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = Clone(arg0_13.activity:GetShipIds())

	_.each(_.range(arg0_13.activity:GetSlotCount()), function(arg0_14)
		var0_13[arg0_14] = var0_13[arg0_14] or 0
	end)

	if arg2_13 == nil or #arg2_13 == 0 then
		if var0_13[arg1_13] > 0 then
			arg0_13:sendNotification(GAME.ACTIVITY_OPERATION, {
				activity_id = arg0_13.activity.id,
				cmd = SpringActivity.OPERATION_SETSHIP,
				kvargs1 = {
					{
						value = 0,
						key = arg1_13
					}
				}
			})
		end

		existCall(arg3_13)

		return
	end

	local var1_13 = _.filter(arg2_13, function(arg0_15)
		return not table.contains(var0_13, arg0_15)
	end)

	table.Foreach(var0_13, function(arg0_16, arg1_16)
		if arg1_16 == 0 or table.contains(arg2_13, arg1_16) then
			return
		end

		var0_13[arg0_16] = 0
	end)

	if #var1_13 == 1 and var0_13[arg1_13] == 0 then
		var0_13[arg1_13] = var1_13[1]
	else
		local var2_13 = 0

		_.each(var1_13, function(arg0_17)
			while var2_13 <= #var0_13 do
				var2_13 = var2_13 + 1

				if var0_13[var2_13] == 0 then
					break
				end
			end

			var0_13[var2_13] = arg0_17
		end)
	end

	local var3_13 = {}
	local var4_13 = arg0_13.activity:GetShipIds()

	table.Foreach(var0_13, function(arg0_18, arg1_18)
		if (var4_13[arg0_18] or 0) ~= arg1_18 then
			table.insert(var3_13, {
				key = arg0_18,
				value = arg1_18
			})
		end
	end)

	if #var3_13 > 0 then
		arg0_13:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = arg0_13.activity.id,
			cmd = SpringActivity.OPERATION_SETSHIP,
			kvargs1 = var3_13
		})
	end

	arg3_13()
end

function var0_0.listNotificationInterests(arg0_19)
	return {
		PlayerProxy.UPDATED,
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		var0_0.OPEN_CHUANWU,
		var0_0.UNLOCK_SLOT
	}
end

function var0_0.handleNotification(arg0_20, arg1_20)
	local var0_20 = arg1_20:getName()
	local var1_20 = arg1_20:getBody()

	if var0_20 == nil then
		-- block empty
	elseif var0_20 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0_20.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_20.awards, var1_20.callback)
	elseif var0_20 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_20:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
			arg0_20.activity = var1_20

			arg0_20.viewComponent:SetActivity(var1_20)
			arg0_20.viewComponent:UpdateView()
		end
	elseif var0_20 == var0_0.OPEN_CHUANWU then
		arg0_20.viewComponent:emit(var0_0.OPEN_CHUANWU, unpack(var1_20))
	elseif var0_20 == var0_0.UNLOCK_SLOT then
		arg0_20.viewComponent:emit(var0_0.UNLOCK_SLOT, var1_20)
	end
end

function var0_0.remove(arg0_21)
	return
end

return var0_0
