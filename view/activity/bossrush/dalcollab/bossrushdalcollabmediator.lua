local var0_0 = class("BossRushDALCollabMediator", import("view.base.ContextMediator"))

var0_0.ON_FLEET_SELECT = "BossRushDALCollabMediator:ON_FLEET_SELECT"
var0_0.ON_PERFORM_COMBAT = "BossRushDALCollabMediator:ON_PERFORM_COMBAT"
var0_0.ON_UPGRADE = "BossRushDALCollabMediator:ON_UPGRADE"
var0_0.GO_SHOPS_LAYER = "BossRushDALCollabMediator:GO_SHOPS_LAYER"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_FLEET_SELECT, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			mediator = BossRushFleetSelectMediator,
			viewComponent = BossRushDALFleetSelectView,
			data = {
				seriesData = arg1_2
			}
		}))
	end)
	arg0_1:bind(var0_0.GO_SHOPS_LAYER, function(arg0_3, arg1_3)
		if not getProxy(ActivityProxy):getActivityById(arg1_3.actId) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, arg1_3 or {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)

	local var0_1 = getProxy(ActivityProxy)
	local var1_1 = var0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB)

	arg0_1.viewComponent:SetActivity(var1_1)

	local var2_1 = var0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

	arg0_1.viewComponent:SetUpgradeActvity(var2_1)

	local var3_1 = var1_1:getConfig("config_client").PTID

	arg0_1.viewComponent:SetPTActivity(underscore.detect(var0_1:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_4)
		return arg0_4:getConfig("config_id") == var3_1
	end))
	arg0_1:sendNotification(GAME.COLLABRATE_BOSS_RUSH_REQUEST_DATA, {
		actId = var1_1.id
	})
	arg0_1.viewComponent:addbubbleMsgBox(function(arg0_5)
		if getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossRushTotalRewardPanelMediator) then
			return
		end

		arg0_5()
	end)
	arg0_1.viewComponent:addbubbleMsgBox(function(arg0_6)
		pg.GuildMsgBoxMgr.GetInstance():NotificationForBattle(arg0_6)
	end)
	arg0_1:bind(var0_0.ON_UPGRADE, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, arg1_7)
	end)
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.SUBMIT_TASK_DONE,
		GAME.SUBMIT_ACTIVITY_TASK_DONE,
		GAME.BEGIN_STAGE_DONE,
		BossRushTotalRewardPanelMediator.ON_WILL_EXIT,
		GAME.COLLABRATE_BOSS_RUSH_REQUEST_DATA_DONE
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()
	local var2_9 = arg1_9:getType()

	if var0_9 == nil then
		-- block empty
	elseif var0_9 == GAME.BEGIN_STAGE_DONE then
		if not getProxy(ContextProxy):getContextByMediator(BossRushPreCombatMediator) then
			arg0_9:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_9)
		end
	elseif var0_9 == ActivityProxy.ACTIVITY_UPDATED then
		local var3_9 = var1_9

		if var3_9 then
			if var3_9.id == arg0_9.viewComponent.activity.id then
				arg0_9.viewComponent:SetActivity(var3_9)
				arg0_9.viewComponent:UpdateView()
			end

			if var3_9:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF then
				arg0_9.viewComponent.upgradeView:SetData(var3_9)
				arg0_9.viewComponent.upgradeView:UpdateView()
			end
		end
	elseif var0_9 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		arg0_9.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_9.awards, function()
			arg0_9.viewComponent:UpdateTasks(var2_9)
		end)
	elseif var0_9 == BossRushTotalRewardPanelMediator.ON_WILL_EXIT then
		arg0_9.viewComponent:resumeBubble()
		arg0_9.viewComponent:UpdateView()
	elseif var0_9 == GAME.COLLABRATE_BOSS_RUSH_REQUEST_DATA_DONE then
		local var4_9 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB)

		arg0_9.viewComponent:SetActivity(var4_9)
		arg0_9.viewComponent:UpdateView()
	end
end

function var0_0.remove(arg0_11)
	return
end

return var0_0
