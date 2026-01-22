local var0_0 = class("BossRushVerSardiniaSPMediator", import("view.base.ContextMediator"))

var0_0.ON_FLEET_SELECT = "BossRushVerSardiniaSPMediator.ON_FLEET_SELECT"
var0_0.ON_EXTRA_RANK = "BossRushVerSardiniaSPMediator.ON_EXTRA_RANK"
var0_0.ON_TASK_SUBMIT = "BossRushVerSardiniaSPMediator.ON_TASK_SUBMIT"
var0_0.ON_PERFORM_COMBAT = "BossRushVerSardiniaSPMediator.ON_PERFORM_COMBAT"
var0_0.ON_ACTIVITY_UNLOCKSTOIRY = "BossRushVerSardiniaSPMediator.ON_ACTIVITY_UNLOCKSTOIRY"
var0_0.GO_SUBLAYER = "BossRushVerSardiniaSPMediator.GO_SUBLAYER"
var0_0.GO_SCENE = "BossRushVerSardiniaSPMediator.GO_SCENE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_ACTIVITY_UNLOCKSTOIRY, function(arg0_2, arg1_2, arg2_2)
		pg.m02:sendNotification(GAME.ACTIVITY_UNLOCKSTORY, {
			cmd = 1,
			activity_id = arg1_2,
			arg1 = arg2_2
		})
	end)
	arg0_1:bind(var0_0.GO_SUBLAYER, function(arg0_3, arg1_3, arg2_3)
		arg0_1:addSubLayers(arg1_3, nil, arg2_3)
	end)
	arg0_1:bind(var0_0.GO_SCENE, function(arg0_4, arg1_4, ...)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_4, ...)
	end)
	arg0_1:bind(var0_0.ON_FLEET_SELECT, function(arg0_5, arg1_5)
		BossRushVerZenkerPassedLayer.seriesId = arg1_5.configId

		arg0_1:addSubLayers(Context.New({
			mediator = BossRushFleetSelectMediator,
			viewComponent = BossRushSardiniaFleetSelectView,
			data = {
				seriesData = arg1_5
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_EXTRA_RANK, function(arg0_6)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.BILLBOARD, {
			page = PowerRank.TYPE_BOSSRUSH
		})
	end)
	arg0_1:bind(var0_0.ON_PERFORM_COMBAT, function(arg0_7, arg1_7, arg2_7)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_PERFORM,
			stageId = arg1_7,
			exitCallback = arg2_7
		})
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_8.id)
	end)

	local var0_1 = getProxy(ActivityProxy)
	local var1_1 = var0_1:getActivityById(arg0_1.contextData.activityID)

	arg0_1.viewComponent:SetActivity(var1_1)

	local var2_1 = var1_1:GetConfigClientSetting("activity_ids")

	arg0_1.contextData.activityStoryID = var2_1.story

	local var3_1 = var0_1:getActivityById(arg0_1.contextData.activityStoryID)

	arg0_1.viewComponent:SetStoryActivity(var3_1)

	arg0_1.contextData.activityPTID = var2_1.pt

	local var4_1 = var0_1:getActivityById(arg0_1.contextData.activityPTID)

	arg0_1.viewComponent:SetPtActivity(var4_1)

	arg0_1.contextData.activityTaskID = var2_1.tasks

	local var5_1 = var0_1:getActivityById(arg0_1.contextData.activityTaskID)

	arg0_1.viewComponent:SetTasksActivity(var5_1)
	arg0_1.viewComponent:addbubbleMsgBox(function(arg0_9)
		if getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossRushTotalRewardPanelMediator) then
			return
		end

		arg0_9()
	end)
	arg0_1.viewComponent:addbubbleMsgBox(function(arg0_10)
		pg.GuildMsgBoxMgr.GetInstance():NotificationForBattle(arg0_10)
	end)
end

function var0_0.listNotificationInterests(arg0_11)
	return {
		GAME.ACTIVITY_STORYUNLOCKED_DONE,
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.SUBMIT_TASK_AWARD_DOWN,
		GAME.BEGIN_STAGE_DONE,
		BossRushTotalRewardPanelMediator.ON_WILL_EXIT
	}
end

function var0_0.handleNotification(arg0_12, arg1_12)
	local var0_12 = arg1_12:getName()
	local var1_12 = arg1_12:getBody()
	local var2_12 = arg1_12:getType()

	if var0_12 == GAME.ACTIVITY_STORYUNLOCKED_DONE then
		arg0_12.viewComponent:UpdataStoryState(var1_12.storyId)
	elseif var0_12 == GAME.BEGIN_STAGE_DONE then
		if not getProxy(ContextProxy):getContextByMediator(BossRushPreCombatMediator) then
			arg0_12:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_12)
		end
	elseif var0_12 == ActivityProxy.ACTIVITY_UPDATED then
		local var3_12 = var1_12

		switch(var3_12.id, {
			[arg0_12.contextData.activityID] = function()
				arg0_12.viewComponent:SetActivity(var3_12)
				arg0_12.viewComponent:UpdateView()
			end,
			[arg0_12.contextData.activityPTID] = function()
				arg0_12.viewComponent:SetPtActivity(var3_12)
				arg0_12.viewComponent:UpdateView()
			end,
			[arg0_12.contextData.activityStoryID] = function()
				arg0_12.viewComponent:SetStoryActivity(var3_12)
			end
		})
	elseif var0_12 == GAME.SUBMIT_TASK_AWARD_DOWN then
		local var4_12 = {}

		if #var1_12.awards > 0 then
			table.insert(var4_12, function(arg0_16)
				arg0_12.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_12.awards, arg0_16)
			end)
		end

		seriesAsync(var4_12, function()
			arg0_12.viewComponent:UpdateView()
		end)
	elseif var0_12 == BossRushTotalRewardPanelMediator.ON_WILL_EXIT then
		arg0_12.contextData.showFlash = true

		arg0_12.viewComponent:resumeBubble()
		arg0_12.viewComponent:UpdateView()
	end
end

function var0_0.remove(arg0_18)
	return
end

return var0_0
