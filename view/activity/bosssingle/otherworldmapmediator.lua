local var0_0 = class("OtherworldMapMediator", import("view.activity.BossSingle.BossSingleMediatorTemplate"))

var0_0.ON_EVENT_TRIGGER = "OtherworldMapMediator.ON_EVENT_TRIGGER"

function var0_0.register(arg0_1)
	arg0_1:BindBattleEvents()
	arg0_1:bind(var0_0.ON_EVENT_TRIGGER, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.SINGLE_EVENT_TRIGGER, {
			actId = arg1_2.actId,
			eventId = arg1_2.eventId
		})
	end)

	local var0_1 = getProxy(ActivityProxy)
	local var1_1 = var0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_EVENT_SINGLE)

	if var1_1 and not var1_1:isEnd() then
		arg0_1.viewComponent:SetEventAct(var1_1)
	else
		arg0_1.viewComponent:SetEventAct(nil)
	end

	local var2_1 = var0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

	if not var2_1 then
		assert(nil, "not exist lottery act")

		return
	end

	local var3_1 = var2_1:getConfig("config_data")[1]

	arg0_1.contextData.resId = pg.activity_random_award_template[var3_1].resource_type
end

function var0_0.initNotificationHandleDic(arg0_3)
	arg0_3.handleDic = {
		[GAME.BEGIN_STAGE_DONE] = function(arg0_4, arg1_4)
			local var0_4 = arg1_4:getBody()

			arg0_4.contextData.editFleet = nil

			if not getProxy(ContextProxy):getContextByMediator(PreCombatMediator) then
				arg0_4:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var0_4)
			end
		end,
		[GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE] = function(arg0_5, arg1_5)
			local var0_5 = arg1_5:getBody()
			local var1_5 = getProxy(FleetProxy):getActivityFleets()[var0_5.actId]

			arg0_5.contextData.actFleets = var1_5

			arg0_5.viewComponent:updateEditPanel()
			arg0_5.viewComponent:updateCommanderFleet(var1_5[var0_5.fleetId])
		end,
		[CommanderProxy.PREFAB_FLEET_UPDATE] = function(arg0_6, arg1_6)
			local var0_6 = arg1_6:getBody()
			local var1_6 = getProxy(CommanderProxy):getPrefabFleet()

			arg0_6.viewComponent:setCommanderPrefabs(var1_6)
			arg0_6.viewComponent:updateCommanderPrefab()
		end,
		[PlayerProxy.UPDATED] = function(arg0_7, arg1_7)
			arg0_7.viewComponent:UpdateRes()
			arg0_7.viewComponent:UpdateWangduBtn()
		end,
		[ActivityProxy.ACTIVITY_UPDATED] = function(arg0_8, arg1_8)
			local var0_8 = arg1_8:getBody()

			if not var0_8 or var0_8:isEnd() then
				return
			end

			if var0_8.id == ActivityConst.OTHER_WORLD_TERMINAL_PT_ID then
				arg0_8.viewComponent:UpdateTerminalTip()
			end
		end,
		[GAME.SINGLE_EVENT_TRIGGER_DONE] = function(arg0_9, arg1_9)
			local var0_9 = arg1_9:getBody()
			local var1_9 = {}

			if #var0_9.awards > 0 then
				table.insert(var1_9, function(arg0_10)
					arg0_9.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_9.awards, arg0_10)
				end)
			end

			seriesAsync(var1_9, function()
				arg0_9.viewComponent:SetEventAct(var0_9.activity)
				arg0_9.viewComponent:UpdateEvents(var0_9.eventId)
			end)
		end,
		[GAME.SINGLE_EVENT_REFRESH_DONE] = function(arg0_12, arg1_12)
			local var0_12 = arg1_12:getBody()

			arg0_12.viewComponent:SetEventAct(var0_12.activity)
			arg0_12.viewComponent:UpdateEvents()
		end,
		[GAME.ACT_NEW_PT_DONE] = function(arg0_13, arg1_13)
			local var0_13 = arg1_13:getBody()

			arg0_13.viewComponent:UpdateTerminalTip()
		end,
		[AvatarFrameProxy.FRAME_TASK_UPDATED] = function(arg0_14, arg1_14)
			arg0_14.viewComponent:UpdateWangduBtn()
		end,
		[AvatarFrameProxy.FRAME_TASK_TIME_OUT] = function(arg0_15, arg1_15)
			arg0_15.viewComponent:UpdateWangduBtn()
		end
	}
end

function var0_0.remove(arg0_16)
	return
end

return var0_0
