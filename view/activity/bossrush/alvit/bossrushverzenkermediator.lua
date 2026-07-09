local var0_0 = class("BossRushVerZenkerMediator", import("view.base.ContextMediator"))

var0_0.ON_FLEET_SELECT = "BossRushVerZenkerMediator.ON_FLEET_SELECT"
var0_0.ON_EXTRA_RANK = "BossRushVerZenkerMediator.ON_EXTRA_RANK"
var0_0.ON_TASK_SUBMIT = "BossRushVerZenkerMediator.ON_TASK_SUBMIT"
var0_0.ON_PERFORM_COMBAT = "BossRushVerZenkerMediator.ON_PERFORM_COMBAT"
var0_0.GO_SUBLAYER = "BossRushVerZenkerMediator.GO_SUBLAYER"
var0_0.GO_SCENE = "BossRushVerZenkerMediator.GO_SCENE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GO_SUBLAYER, function(arg0_2, arg1_2, arg2_2)
		arg0_1:addSubLayers(arg1_2, nil, arg2_2)
	end)
	arg0_1:bind(var0_0.GO_SCENE, function(arg0_3, arg1_3, ...)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_3, ...)
	end)
	arg0_1:bind(var0_0.ON_FLEET_SELECT, function(arg0_4, arg1_4)
		BossRushVerZenkerPassedLayer.seriesId = arg1_4.configId

		arg0_1:addSubLayers(Context.New({
			mediator = BossRushFleetSelectMediator,
			viewComponent = BossRushVerZenkerFleetSelectView,
			data = {
				seriesData = arg1_4
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_EXTRA_RANK, function(arg0_5)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.BILLBOARD, {
			page = PowerRank.TYPE_BOSSRUSH
		})
	end)
	arg0_1:bind(var0_0.ON_PERFORM_COMBAT, function(arg0_6, arg1_6, arg2_6)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_PERFORM,
			stageId = arg1_6,
			exitCallback = arg2_6
		})
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_7.id)
	end)

	local var0_1 = getProxy(ActivityProxy)
	local var1_1 = arg0_1.contextData.activityID

	assert(var1_1, "activityID is required by BossRushVerZenkerMediator")

	local var2_1 = var0_1:getActivityById(var1_1)

	arg0_1.viewComponent:SetActivity(var2_1)

	local var3_1 = var0_1:getActivityById(ActivityConst.ZENGKEHAIJUNSHANGJIANG_PT_ACT_ID)

	arg0_1.viewComponent:SetPtActivity(var3_1)
	arg0_1.viewComponent:addbubbleMsgBox(function(arg0_8)
		if getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossRushTotalRewardPanelMediator) then
			return
		end

		arg0_8()
	end)
	arg0_1.viewComponent:addbubbleMsgBox(function(arg0_9)
		pg.GuildMsgBoxMgr.GetInstance():NotificationForBattle(arg0_9)
	end)
end

function var0_0.listNotificationInterests(arg0_10)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.SUBMIT_TASK_AWARD_DOWN,
		GAME.BEGIN_STAGE_DONE,
		BossRushTotalRewardPanelMediator.ON_WILL_EXIT
	}
end

function var0_0.handleNotification(arg0_11, arg1_11)
	local var0_11 = arg1_11:getName()
	local var1_11 = arg1_11:getBody()
	local var2_11 = arg1_11:getType()

	if var0_11 == nil then
		-- block empty
	elseif var0_11 == GAME.BEGIN_STAGE_DONE then
		if not getProxy(ContextProxy):getContextByMediator(BossRushPreCombatMediator) then
			arg0_11:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_11)
		end
	elseif var0_11 == ActivityProxy.ACTIVITY_UPDATED then
		local var3_11 = var1_11

		if var3_11 then
			if var3_11.id == arg0_11.contextData.activityID then
				arg0_11.viewComponent:SetActivity(var3_11)
				arg0_11.viewComponent:UpdateView()
			elseif var3_11.id == ActivityConst.ZENGKEHAIJUNSHANGJIANG_PT_ACT_ID then
				arg0_11.viewComponent:SetPtActivity(var3_11)
				arg0_11.viewComponent:UpdateView()
			end
		end
	elseif var0_11 == GAME.SUBMIT_TASK_AWARD_DOWN then
		local var4_11 = {}

		if #var1_11.awards > 0 then
			table.insert(var4_11, function(arg0_12)
				arg0_11.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_11.awards, arg0_12)
			end)
		end

		seriesAsync(var4_11, function()
			arg0_11.viewComponent:UpdateView()
		end)
	elseif var0_11 == BossRushTotalRewardPanelMediator.ON_WILL_EXIT then
		arg0_11.viewComponent:resumeBubble()
		arg0_11.viewComponent:UpdateView()
	end
end

function var0_0.remove(arg0_14)
	return
end

return var0_0
