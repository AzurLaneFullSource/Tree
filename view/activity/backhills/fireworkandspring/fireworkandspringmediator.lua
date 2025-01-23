local var0_0 = class("FireworkAndSpringMediator", import("view.activity.BackHills.TemplateMV.BackHillMediatorTemplate"))

var0_0.EVENT_PT_OPERATION = "FireworkAndSpringMediator:event pt op"
var0_0.ON_TASK_GO = "FireworkAndSpringMediator:event on task go"
var0_0.ON_TASK_SUBMIT = "FireworkAndSpringMediator:event on task submit"
var0_0.ON_TASK_SUBMIT_ONESTEP = "FireworkAndSpringMediator:event on task submit one step"
var0_0.ACTIVITY_OPERATION = "FireworkAndSpringMediator:event activity op"
var0_0.OPEN_CHUANWU = "FireworkAndSpringMediator:Open chuanwu"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.EVENT_PT_OPERATION, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ACT_NEW_PT, arg1_2)
	end)
	arg0_1:bind(var0_0.ON_TASK_GO, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_3
		})
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_4.id, arg2_4)
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT_ONESTEP, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
			act_id = arg1_5,
			task_ids = arg2_5
		})
	end)
	arg0_1:bind(var0_0.ACTIVITY_OPERATION, function(arg0_6, arg1_6, arg2_6)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = arg1_6,
			cmd = PuzzleActivity.CMD_ACTIVATE,
			arg1 = arg2_6
		})
	end)
	arg0_1:bind(var0_0.OPEN_CHUANWU, function(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
		arg0_1:OnSelShips(arg1_7, arg2_7, arg3_7, arg4_7)
	end)
end

function var0_0.OnSelShips(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	local var0_8 = getProxy(ActivityProxy):getActivityById(arg1_8)
	local var1_8 = arg0_8:GetSelectedShipIds(arg1_8, arg3_8)
	local var2_8 = {
		callbackQuit = true,
		selectedMax = arg4_8,
		quitTeam = arg3_8 ~= nil,
		ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
			isActivityNpc = true
		}),
		selectedIds = Clone(var1_8),
		preView = arg0_8.viewComponent.__cname,
		hideTagFlags = ShipStatus.TAG_HIDE_BACKYARD,
		blockTagFlags = ShipStatus.TAG_BLOCK_BACKYARD,
		onShip = function(arg0_9, arg1_9, arg2_9)
			return arg0_8:OnShip(arg0_9, arg1_9, arg2_9)
		end,
		onSelected = function(arg0_10, arg1_10)
			arg0_8:OnSelected(arg1_8, arg2_8, arg0_10, arg1_10)
		end,
		priorEquipUpShipIDList = _.filter(var0_8:GetShipIds(), function(arg0_11)
			return arg0_11 > 0
		end),
		leftTopWithFrameInfo = i18n("backyard_longpress_ship_tip")
	}

	var2_8.isLayer = true
	var2_8.energyDisplay = true

	arg0_8:addSubLayers(Context.New({
		viewComponent = DockyardScene,
		mediator = DockyardMediator,
		data = var2_8
	}))
end

function var0_0.GetSelectedShipIds(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg2_12 and arg2_12.id or -1
	local var1_12 = getProxy(ActivityProxy):getActivityById(arg1_12)
	local var2_12 = {}

	for iter0_12, iter1_12 in ipairs(var1_12:GetShipIds()) do
		local var3_12 = iter1_12 > 0 and getProxy(BayProxy):RawGetShipById(iter1_12)

		if var3_12 and var3_12.id ~= var0_12 then
			table.insert(var2_12, var3_12.id)
		end
	end

	return var2_12
end

function var0_0.OnShip(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13, var1_13 = ShipStatus.ShipStatusCheck("inBackyard", arg1_13, function(arg0_14)
		arg2_13()
	end)

	return var0_13, var1_13
end

function var0_0.OnSelected(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	local var0_15 = getProxy(ActivityProxy):getActivityById(arg1_15)
	local var1_15 = Clone(var0_15:GetShipIds())

	_.each(_.range(var0_15:GetSlotCount()), function(arg0_16)
		var1_15[arg0_16] = var1_15[arg0_16] or 0
	end)

	if arg3_15 == nil or #arg3_15 == 0 then
		if var1_15[arg2_15] > 0 then
			arg0_15:sendNotification(GAME.ACTIVITY_OPERATION, {
				activity_id = var0_15.id,
				cmd = Spring2Activity.OPERATION_SETSHIP,
				kvargs1 = {
					{
						value = 0,
						key = arg2_15
					}
				}
			})
		end

		existCall(arg4_15)

		return
	end

	local var2_15 = _.filter(arg3_15, function(arg0_17)
		return not table.contains(var1_15, arg0_17)
	end)

	table.Foreach(var1_15, function(arg0_18, arg1_18)
		if arg1_18 == 0 or table.contains(arg3_15, arg1_18) then
			return
		end

		var1_15[arg0_18] = 0
	end)

	if #var2_15 == 1 and var1_15[arg2_15] == 0 then
		var1_15[arg2_15] = var2_15[1]
	else
		local var3_15 = 0

		_.each(var2_15, function(arg0_19)
			while var3_15 <= #var1_15 do
				var3_15 = var3_15 + 1

				if var1_15[var3_15] == 0 then
					break
				end
			end

			var1_15[var3_15] = arg0_19
		end)
	end

	local var4_15 = {}
	local var5_15 = var0_15:GetShipIds()

	table.Foreach(var1_15, function(arg0_20, arg1_20)
		if (var5_15[arg0_20] or 0) ~= arg1_20 then
			table.insert(var4_15, {
				key = arg0_20,
				value = arg1_20
			})
		end
	end)

	if #var4_15 > 0 then
		arg0_15:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = var0_15.id,
			cmd = Spring2Activity.OPERATION_SETSHIP,
			kvargs1 = var4_15
		})
	end

	arg4_15()
end

function var0_0.listNotificationInterests(arg0_21)
	return {
		GAME.ACT_NEW_PT_DONE,
		GAME.SUBMIT_TASK_DONE,
		GAME.SUBMIT_AVATAR_TASK_DONE,
		GAME.SUBMIT_ACTIVITY_TASK_DONE,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		ActivityProxy.ACTIVITY_OPERATION_DONE,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_22, arg1_22)
	local var0_22 = arg1_22:getName()
	local var1_22 = arg1_22:getBody()

	if var0_22 == GAME.ACT_NEW_PT_DONE then
		arg0_22.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_22.awards, var1_22.callback)
		arg0_22.viewComponent:UpdatePtData()
		arg0_22.viewComponent:UpdateMainPt()
		arg0_22.viewComponent:SetPtPanel()
	elseif var0_22 == GAME.SUBMIT_TASK_DONE then
		arg0_22.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_22)
		arg0_22.viewComponent:UpdateTaskData()
		arg0_22.viewComponent:UpdatePtData()
		arg0_22.viewComponent:UpdateMainPt()
		arg0_22.viewComponent:SetTaskPanel()
		arg0_22.viewComponent:UpdateSpringData()
	elseif var0_22 == GAME.SUBMIT_AVATAR_TASK_DONE or var0_22 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		arg0_22.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_22.awards)
		arg0_22.viewComponent:UpdateTaskData()
		arg0_22.viewComponent:UpdatePtData()
		arg0_22.viewComponent:UpdateMainPt()
		arg0_22.viewComponent:SetTaskPanel()
		arg0_22.viewComponent:UpdateSpringData()
	elseif var0_22 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0_22.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_22.awards)
	elseif var0_22 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		if getProxy(ActivityProxy):getActivityById(var1_22):getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING_2 then
			arg0_22.viewComponent:UpdateSpringActivityAndUI()
		end
	elseif var0_22 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_22:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PUZZLA then
			arg0_22.viewComponent:UpdateFireworkData()
			arg0_22.viewComponent:UpdatePtData()
			arg0_22.viewComponent:UpdateMainPt()
			arg0_22.viewComponent:SetFireWorkPanel()
		elseif var1_22:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING_2 then
			arg0_22.viewComponent:UpdateSpringActivityAndUI()
		end
	end

	arg0_22.viewComponent:SetTips()
end

return var0_0
