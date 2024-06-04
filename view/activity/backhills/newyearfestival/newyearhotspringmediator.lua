local var0 = class("NewYearHotSpringMediator", import("view.base.ContextMediator"))

var0.UNLOCK_SLOT = "UNLOCK_SLOT"
var0.OPEN_INFO = "OPEN_INFO"
var0.OPEN_CHUANWU = "NewYearHotSpringMediator:Open chuanwu"

function var0.register(arg0)
	arg0:bind(var0.UNLOCK_SLOT, function(arg0, arg1)
		local var0, var1 = arg0.activity:GetUpgradeCost()

		MsgboxMediator.ShowMsgBox({
			type = MSGBOX_TYPE_NORMAL,
			content = i18n("hotspring_expand", var1),
			contextSprites = {
				{
					name = "wenquanbi",
					path = "props/wenquanbi"
				}
			},
			onYes = function()
				if arg0.activity:GetCoins() < var1 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("hotspring_tip2"))

					return
				end

				arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
					activity_id = arg1,
					cmd = SpringActivity.OPERATION_UNLOCK
				})
			end
		})
	end)
	arg0:bind(var0.OPEN_CHUANWU, function(arg0, arg1, arg2)
		arg0:OnSelShips(arg1, arg2)
	end)

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)

	arg0.activity = var0

	arg0.viewComponent:SetActivity(var0)
	arg0:bind(var0.OPEN_INFO, function()
		arg0:addSubLayers(Context.New({
			mediator = NewYearHotSpringShipSelectMediator,
			viewComponent = NewYearHotSpringShipSelectLayer,
			data = {
				actId = var0.id
			}
		}))
	end)
end

function var0.OnSelShips(arg0, arg1, arg2)
	local var0 = arg0:GetSelectedShipIds(arg2)
	local var1 = {
		callbackQuit = true,
		selectedMax = arg0.activity:GetSlotCount(),
		quitTeam = arg2 ~= nil,
		ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
			isActivityNpc = true
		}),
		selectedIds = Clone(var0),
		preView = arg0.viewComponent.__cname,
		hideTagFlags = ShipStatus.TAG_HIDE_BACKYARD,
		blockTagFlags = ShipStatus.TAG_BLOCK_BACKYARD,
		onShip = function(arg0, arg1, arg2)
			return arg0:OnShip(arg0, arg1, arg2)
		end,
		onSelected = function(arg0, arg1)
			arg0:OnSelected(arg1, arg0, arg1)
		end,
		priorEquipUpShipIDList = _.filter(arg0.activity:GetShipIds(), function(arg0)
			return arg0 > 0
		end),
		leftTopWithFrameInfo = i18n("backyard_longpress_ship_tip")
	}

	var1.isLayer = true
	var1.energyDisplay = true

	arg0:addSubLayers(Context.New({
		viewComponent = DockyardScene,
		mediator = DockyardMediator,
		data = var1
	}))
end

function var0.GetSelectedShipIds(arg0, arg1)
	local var0 = arg1 and arg1.id or -1
	local var1 = {}

	for iter0, iter1 in ipairs(arg0.activity:GetShipIds()) do
		local var2 = iter1 > 0 and getProxy(BayProxy):RawGetShipById(iter1)

		if var2 and var2.id ~= var0 then
			table.insert(var1, var2.id)
		end
	end

	return var1
end

function var0.OnShip(arg0, arg1, arg2, arg3)
	local var0, var1 = ShipStatus.ShipStatusCheck("inBackyard", arg1, function(arg0)
		arg2()
	end)

	return var0, var1
end

function var0.OnSelected(arg0, arg1, arg2, arg3)
	local var0 = Clone(arg0.activity:GetShipIds())

	_.each(_.range(arg0.activity:GetSlotCount()), function(arg0)
		var0[arg0] = var0[arg0] or 0
	end)

	if arg2 == nil or #arg2 == 0 then
		if var0[arg1] > 0 then
			arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
				activity_id = arg0.activity.id,
				cmd = SpringActivity.OPERATION_SETSHIP,
				kvargs1 = {
					{
						value = 0,
						key = arg1
					}
				}
			})
		end

		existCall(arg3)

		return
	end

	local var1 = _.filter(arg2, function(arg0)
		return not table.contains(var0, arg0)
	end)

	table.Foreach(var0, function(arg0, arg1)
		if arg1 == 0 or table.contains(arg2, arg1) then
			return
		end

		var0[arg0] = 0
	end)

	if #var1 == 1 and var0[arg1] == 0 then
		var0[arg1] = var1[1]
	else
		local var2 = 0

		_.each(var1, function(arg0)
			while var2 <= #var0 do
				var2 = var2 + 1

				if var0[var2] == 0 then
					break
				end
			end

			var0[var2] = arg0
		end)
	end

	local var3 = {}
	local var4 = arg0.activity:GetShipIds()

	table.Foreach(var0, function(arg0, arg1)
		if (var4[arg0] or 0) ~= arg1 then
			table.insert(var3, {
				key = arg0,
				value = arg1
			})
		end
	end)

	if #var3 > 0 then
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = arg0.activity.id,
			cmd = SpringActivity.OPERATION_SETSHIP,
			kvargs1 = var3
		})
	end

	arg3()
end

function var0.listNotificationInterests(arg0)
	return {
		PlayerProxy.UPDATED,
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		var0.OPEN_CHUANWU,
		var0.UNLOCK_SLOT
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == nil then
		-- block empty
	elseif var0 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
			arg0.activity = var1

			arg0.viewComponent:SetActivity(var1)
			arg0.viewComponent:UpdateView()
		end
	elseif var0 == var0.OPEN_CHUANWU then
		arg0.viewComponent:emit(var0.OPEN_CHUANWU, unpack(var1))
	elseif var0 == var0.UNLOCK_SLOT then
		arg0.viewComponent:emit(var0.UNLOCK_SLOT, var1)
	end
end

function var0.remove(arg0)
	return
end

return var0
