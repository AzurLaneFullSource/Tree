local var0 = class("OtherworldMapMediator", import("view.activity.BossSingle.BossSingleMediatorTemplate"))

var0.ON_EVENT_TRIGGER = "OtherworldMapMediator.ON_EVENT_TRIGGER"

function var0.register(arg0)
	arg0:BindBattleEvents()
	arg0:bind(var0.ON_EVENT_TRIGGER, function(arg0, arg1)
		arg0:sendNotification(GAME.SINGLE_EVENT_TRIGGER, {
			actId = arg1.actId,
			eventId = arg1.eventId
		})
	end)

	local var0 = getProxy(ActivityProxy)
	local var1 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_EVENT_SINGLE)

	if var1 and not var1:isEnd() then
		arg0.viewComponent:SetEventAct(var1)
	else
		arg0.viewComponent:SetEventAct(nil)
	end

	local var2 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

	if not var2 then
		assert(nil, "not exist lottery act")

		return
	end

	local var3 = var2:getConfig("config_data")[1]

	arg0.contextData.resId = pg.activity_random_award_template[var3].resource_type
end

function var0.initNotificationHandleDic(arg0)
	arg0.handleDic = {
		[GAME.BEGIN_STAGE_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.contextData.editFleet = nil

			if not getProxy(ContextProxy):getContextByMediator(PreCombatMediator) then
				arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var0)
			end
		end,
		[GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()
			local var1 = getProxy(FleetProxy):getActivityFleets()[var0.actId]

			arg0.contextData.actFleets = var1

			arg0.viewComponent:updateEditPanel()
			arg0.viewComponent:updateCommanderFleet(var1[var0.fleetId])
		end,
		[CommanderProxy.PREFAB_FLEET_UPDATE] = function(arg0, arg1)
			local var0 = arg1:getBody()
			local var1 = getProxy(CommanderProxy):getPrefabFleet()

			arg0.viewComponent:setCommanderPrefabs(var1)
			arg0.viewComponent:updateCommanderPrefab()
		end,
		[PlayerProxy.UPDATED] = function(arg0, arg1)
			arg0.viewComponent:UpdateRes()
			arg0.viewComponent:UpdateWangduBtn()
		end,
		[ActivityProxy.ACTIVITY_UPDATED] = function(arg0, arg1)
			local var0 = arg1:getBody()

			if not var0 or var0:isEnd() then
				return
			end

			if var0.id == ActivityConst.OTHER_WORLD_TERMINAL_PT_ID then
				arg0.viewComponent:UpdateTerminalTip()
			end
		end,
		[GAME.SINGLE_EVENT_TRIGGER_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()
			local var1 = {}

			if #var0.awards > 0 then
				table.insert(var1, function(arg0)
					arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0.awards, arg0)
				end)
			end

			seriesAsync(var1, function()
				arg0.viewComponent:SetEventAct(var0.activity)
				arg0.viewComponent:UpdateEvents(var0.eventId)
			end)
		end,
		[GAME.SINGLE_EVENT_REFRESH_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:SetEventAct(var0.activity)
			arg0.viewComponent:UpdateEvents()
		end,
		[GAME.ACT_NEW_PT_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:UpdateTerminalTip()
		end,
		[AvatarFrameProxy.FRAME_TASK_UPDATED] = function(arg0, arg1)
			arg0.viewComponent:UpdateWangduBtn()
		end,
		[AvatarFrameProxy.FRAME_TASK_TIME_OUT] = function(arg0, arg1)
			arg0.viewComponent:UpdateWangduBtn()
		end
	}
end

function var0.remove(arg0)
	return
end

return var0
