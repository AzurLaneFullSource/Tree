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

	local var3_1 = var1_1:GetConfigClientPTActivity()

	arg0_1.viewComponent:SetPTActivity(var3_1)
	arg0_1:sendNotification(GAME.COLLABRATE_BOSS_RUSH_REQUEST_DATA, {
		actId = var1_1.id
	})
	arg0_1.viewComponent:addbubbleMsgBox(function(arg0_4)
		if getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossRushTotalRewardPanelMediator) then
			return
		end

		arg0_4()
	end)
	arg0_1.viewComponent:addbubbleMsgBox(function(arg0_5)
		pg.GuildMsgBoxMgr.GetInstance():NotificationForBattle(arg0_5)
	end)
	arg0_1:bind(var0_0.ON_UPGRADE, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, arg1_6)
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.SUBMIT_TASK_DONE,
		GAME.SUBMIT_ACTIVITY_TASK_DONE,
		GAME.BEGIN_STAGE_DONE,
		BossRushTotalRewardPanelMediator.ON_WILL_EXIT,
		GAME.COLLABRATE_BOSS_RUSH_REQUEST_DATA_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()
	local var2_8 = arg1_8:getType()

	if var0_8 == nil then
		-- block empty
	elseif var0_8 == GAME.BEGIN_STAGE_DONE then
		if not getProxy(ContextProxy):getContextByMediator(BossRushPreCombatMediator) then
			arg0_8:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_8)
		end
	elseif var0_8 == ActivityProxy.ACTIVITY_UPDATED then
		local var3_8 = var1_8

		if var3_8 then
			if var3_8.id == arg0_8.viewComponent.activity.id then
				arg0_8.viewComponent:SetActivity(var3_8)
				arg0_8.viewComponent:UpdateView()
			end

			if var3_8:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF then
				arg0_8.viewComponent.upgradeView:SetData(var3_8)
				arg0_8.viewComponent.upgradeView:UpdateView()
			end
		end
	elseif var0_8 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_8.awards, function()
			arg0_8.viewComponent:UpdateTasks(var2_8)
		end)
	elseif var0_8 == BossRushTotalRewardPanelMediator.ON_WILL_EXIT then
		arg0_8.viewComponent:resumeBubble()
		arg0_8.viewComponent:UpdateView()
	elseif var0_8 == GAME.COLLABRATE_BOSS_RUSH_REQUEST_DATA_DONE then
		local var4_8 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB)

		arg0_8.viewComponent:SetActivity(var4_8)
		arg0_8.viewComponent:UpdateView()
	end
end

function var0_0.remove(arg0_10)
	return
end

return var0_0
