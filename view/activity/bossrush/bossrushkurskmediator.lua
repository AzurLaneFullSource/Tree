local var0_0 = class("BossRushKurskMediator", import("view.base.ContextMediator"))

var0_0.ON_FLEET_SELECT = "BossRushKurskMediator:ON_FLEET_SELECT"
var0_0.ON_EXTRA_RANK = "BossRushKurskMediator:ON_EXTRA_RANK"
var0_0.GO_ACT_SHOP = "BossRushKurskMediator:GO_ACT_SHOP"
var0_0.ON_TASK_SUBMIT = "BossRushKurskMediator:ON_TASK_SUBMIT"
var0_0.ON_PERFORM_COMBAT = "BossRushKurskMediator:ON_PERFORM_COMBAT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_FLEET_SELECT, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			mediator = BossRushFleetSelectMediator,
			viewComponent = BossRushFleetSelectView,
			data = {
				seriesData = arg1_2
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_EXTRA_RANK, function(arg0_3)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.BILLBOARD, {
			page = PowerRank.TYPE_BOSSRUSH
		})
	end)
	arg0_1:bind(var0_0.ON_PERFORM_COMBAT, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_PERFORM,
			stageId = arg1_4,
			exitCallback = arg2_4
		})
	end)
	arg0_1:bind(var0_0.GO_ACT_SHOP, function(arg0_5, arg1_5)
		arg0_1:addSubLayers(Context.New({
			mediator = PtAwardMediator,
			viewComponent = PtAwardLayer,
			data = {
				ptData = arg1_5,
				ptId = arg1_5.resId
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_6.id)
	end)

	local var0_1 = arg0_1.contextData.activityID

	assert(var0_1, "activityID is required by BossRushVerZenkerMediator")

	local var1_1 = getProxy(ActivityProxy):getActivityById(var0_1)

	arg0_1.viewComponent:SetActivity(var1_1)

	local var2_1 = var1_1:GetConfigClientSetting("PTID")
	local var3_1 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF)

	for iter0_1, iter1_1 in ipairs(var3_1) do
		if iter1_1:getDataConfig("pt") == var2_1 then
			arg0_1.viewComponent:SetPtActivity(iter1_1)

			break
		end
	end

	arg0_1.viewComponent:addbubbleMsgBox(function(arg0_7)
		if getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossRushTotalRewardPanelMediator) then
			return
		end

		arg0_7()
	end)
	arg0_1.viewComponent:addbubbleMsgBox(function(arg0_8)
		pg.GuildMsgBoxMgr.GetInstance():NotificationForBattle(arg0_8)
	end)
end

function var0_0.listNotificationInterests(arg0_9)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.SUBMIT_TASK_DONE,
		GAME.SUBMIT_ACTIVITY_TASK_DONE,
		GAME.BEGIN_STAGE_DONE,
		BossRushTotalRewardPanelMediator.ON_WILL_EXIT
	}
end

function var0_0.handleNotification(arg0_10, arg1_10)
	local var0_10 = arg1_10:getName()
	local var1_10 = arg1_10:getBody()
	local var2_10 = arg1_10:getType()

	if var0_10 == nil then
		-- block empty
	elseif var0_10 == GAME.BEGIN_STAGE_DONE then
		if not getProxy(ContextProxy):getContextByMediator(BossRushPreCombatMediator) then
			arg0_10:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_10)
		end
	elseif var0_10 == ActivityProxy.ACTIVITY_UPDATED then
		local var3_10 = var1_10

		if var3_10 then
			if var3_10.id == arg0_10.viewComponent.activity.id then
				arg0_10.viewComponent:SetActivity(var3_10)
				arg0_10.viewComponent:UpdateView()
			elseif var3_10.id == arg0_10.viewComponent.ptActivity.id then
				arg0_10.viewComponent:SetPtActivity(var3_10)
				arg0_10.viewComponent:UpdateView()
			end
		end
	elseif var0_10 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		arg0_10.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_10.awards, function()
			arg0_10.viewComponent:UpdateTasks(var2_10)
		end)
	elseif var0_10 == BossRushTotalRewardPanelMediator.ON_WILL_EXIT then
		arg0_10.viewComponent:resumeBubble()
		arg0_10.viewComponent:UpdateView()
	end
end

function var0_0.remove(arg0_12)
	return
end

return var0_0
