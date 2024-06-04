local var0 = class("BossRushKurskMediator", import("view.base.ContextMediator"))

var0.ON_FLEET_SELECT = "BossRushKurskMediator:ON_FLEET_SELECT"
var0.ON_EXTRA_RANK = "BossRushKurskMediator:ON_EXTRA_RANK"
var0.GO_ACT_SHOP = "BossRushKurskMediator:GO_ACT_SHOP"
var0.ON_TASK_SUBMIT = "BossRushKurskMediator:ON_TASK_SUBMIT"
var0.ON_PERFORM_COMBAT = "BossRushKurskMediator:ON_PERFORM_COMBAT"

function var0.register(arg0)
	arg0:bind(var0.ON_FLEET_SELECT, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = BossRushFleetSelectMediator,
			viewComponent = BossRushFleetSelectView,
			data = {
				seriesData = arg1
			}
		}))
	end)
	arg0:bind(var0.ON_EXTRA_RANK, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.BILLBOARD, {
			page = PowerRank.TYPE_BOSSRUSH
		})
	end)
	arg0:bind(var0.ON_PERFORM_COMBAT, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_PERFORM,
			stageId = arg1,
			exitCallback = arg2
		})
	end)
	arg0:bind(var0.GO_ACT_SHOP, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = PtAwardMediator,
			viewComponent = PtAwardLayer,
			data = {
				ptData = arg1,
				ptId = pg.gameset.activity_res_id.key_value
			}
		}))
	end)
	arg0:bind(var0.ON_TASK_SUBMIT, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1.id)
	end)

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSRUSH)

	arg0.viewComponent:SetActivity(var0)

	local var1 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF)

	for iter0, iter1 in ipairs(var1) do
		if iter1:getDataConfig("pt") == pg.gameset.activity_res_id.key_value then
			arg0.viewComponent:SetPtActivity(iter1)

			break
		end
	end

	arg0.viewComponent:addbubbleMsgBox(function(arg0)
		if getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossRushTotalRewardPanelMediator) then
			return
		end

		arg0()
	end)
	arg0.viewComponent:addbubbleMsgBox(function(arg0)
		pg.GuildMsgBoxMgr.GetInstance():NotificationForBattle(arg0)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.SUBMIT_TASK_DONE,
		GAME.BEGIN_STAGE_DONE,
		BossRushTotalRewardPanelMediator.ON_WILL_EXIT
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
	local var2 = arg1:getType()

	if var0 == nil then
		-- block empty
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		if not getProxy(ContextProxy):getContextByMediator(BossRushPreCombatMediator) then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
		end
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED then
		local var3 = var1

		if var3 then
			if var3:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BOSSRUSH then
				arg0.viewComponent:SetActivity(var3)
				arg0.viewComponent:UpdateView()
			elseif var3:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_BUFF and var3:getDataConfig("pt") == pg.gameset.activity_res_id.key_value then
				arg0.viewComponent:SetPtActivity(var3)
				arg0.viewComponent:UpdateView()
			end
		end
	elseif var0 == GAME.SUBMIT_TASK_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1, function()
			arg0.viewComponent:UpdateTasks(var2)
		end)
	elseif var0 == BossRushTotalRewardPanelMediator.ON_WILL_EXIT then
		arg0.viewComponent:resumeBubble()
		arg0.viewComponent:UpdateView()
	end
end

function var0.remove(arg0)
	return
end

return var0
