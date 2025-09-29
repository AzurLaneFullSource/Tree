local var0_0 = class("IslandScene", import(".base.IslandBaseScene"))

var0_0.ON_INVENTORY_FILTER = "IslandScene:ON_INVENTORY_FILTER"
var0_0.ON_CHECK_ORDER_EXP_AWARD = "IslandScene:ON_CHECK_ORDER_EXP_AWARD"

function var0_0.getUIName(arg0_1)
	return "IslandUI"
end

function var0_0.loadingQueue(arg0_2)
	return function(arg0_3)
		pg.SceneAnimMgr.GetInstance():CommonSceneChange("Dorm3DLoading", function(arg0_4)
			return arg0_3(arg0_4)
		end)
	end
end

function var0_0.GetIsland(arg0_5)
	return getProxy(IslandProxy):GetIsland()
end

function var0_0.init(arg0_6)
	arg0_6.visitorBtn = arg0_6:findTF("top/visitor")
	arg0_6.levelPanel = IslandLevelPanel.New(arg0_6._tf, arg0_6.event)
	arg0_6.taskTrackPanel = Island3dTaskTrackPanel.New(arg0_6._tf, arg0_6.event)
	arg0_6.awardDisplayPanel = IslandAwardDisplayInMainPanel.New(arg0_6._tf, arg0_6.event)
	arg0_6.btnContainer = IslandMainBtnContainer.New(arg0_6._tf:Find("top/btn_container"), arg0_6.event)
end

function var0_0.didEnter(arg0_7)
	onButton(arg0_7, arg0_7.visitorBtn, function()
		arg0_7:OpenPage(IslandVisitorPage)
	end, SFX_PANEL)
	arg0_7:SetUp()

	local var0_7 = arg0_7.contextData.resumeCallback

	arg0_7.contextData.resumeCallback = nil

	existCall(var0_7)
end

function var0_0.SetUp(arg0_9)
	seriesAsync({
		function(arg0_10)
			arg0_9:SetDressUpIsEmpty(arg0_10)
		end
	}, function()
		arg0_9:StartCore()
	end)
end

function var0_0.SetNameIfIsEmpty(arg0_12, arg1_12)
	if not arg0_12:GetIsland():IsNew() then
		arg1_12()

		return
	end

	local var0_12 = IslandSetNamePage.New(arg0_12)

	var0_12:ExecuteAction("Show", function()
		var0_12:Destroy()
		arg1_12()
	end)
end

function var0_0.SetDressUpIsEmpty(arg0_14, arg1_14)
	if not arg0_14:GetIsland():GetDressUpAgency():IsNew() then
		arg1_14()

		return
	end

	arg0_14:OpenPage(IslandShipFirstDressupPage, arg1_14)
end

function var0_0.AddListeners(arg0_15)
	arg0_15:AddListener(GAME.ISLAND_UPGRADE_DONE, arg0_15.OnUpgrade)
	arg0_15:AddListener(Island.EXP_ADD, arg0_15.OnExpChange)
	arg0_15:AddListener(GAME.ISLAND_SET_NAME_DONE, arg0_15.OnModifyName)
	arg0_15:AddListener(GAME.ISLAND_PROSPERITY_AWARD_DONE, arg0_15.OnGetProsperityAward)
	arg0_15:AddListener(IslandTaskAgency.TASK_ADDED, arg0_15.OnAddedTask)
	arg0_15:AddListener(IslandTaskAgency.TASK_UPDATED, arg0_15.OnUpdateTask)
	arg0_15:AddListener(IslandTaskAgency.TASK_REMOVED, arg0_15.OnRemoveTask)
	arg0_15:AddListener(IslandAchievementAgency.NEW_CAN_GET, arg0_15.OnNewAchievementCanGet)
	arg0_15:AddListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_15.OnFinishDelegation)
	arg0_15:AddListener(GAME.ISLAND_UNLOCK_TECH_DONE, arg0_15.OnUnlockTechnology)
	arg0_15:AddListener(IslandCharacterAgency.ADD_SHIP, arg0_15.OnAddShip)
	arg0_15:AddListener(IslandCharacterAgency.SHIP_LEVEL_UP, arg0_15.OnShipLevelUp)
	arg0_15:AddListener(IslandCharacterAgency.SHIP_GET_STATE, arg0_15.OnShipGetState)
	arg0_15:AddListener(IslandAblityAgency.UNLOCK_SYSTEM, arg0_15.OnUnlockSystem)
	arg0_15:AddListener(IslandVisitorAgency.PLAYER_ADD, arg0_15.OnVisitorNumChange)
	arg0_15:AddListener(IslandVisitorAgency.PLAYER_EXIT, arg0_15.OnVisitorNumChange)
	arg0_15:AddListener(ISLAND_EX_EVT.ENTER_EDIT_AGORA, arg0_15.OnAgoraEnterEditMode)
	arg0_15:AddListener(ISLAND_EX_EVT.EXIT_EDIT_AGORA, arg0_15.OnAgoraExitEditMode)
	arg0_15:AddListener(ISLAND_EX_EVT.TRIGGER_TASK, arg0_15.OnTriggerTask)
	arg0_15:AddListener(ISLAND_EX_EVT.SUBMIT_TASK, arg0_15.OnSubmitTask)
	arg0_15:AddListener(ISLAND_EX_EVT.ADD_TASK_PROGRESS, arg0_15.OnAddTaskProgress)
	arg0_15:AddListener(ISLAND_EX_EVT.PLAY_STORY, arg0_15.OnPlayStory)
	arg0_15:AddListener(ISLAND_EX_EVT.SWITCH_MAP, arg0_15.OnSwitchMap)
	arg0_15:AddListener(ISLAND_EX_EVT.SEEK_GAME_START, arg0_15.OnSeekGameStart)
	arg0_15:AddListener(ISLAND_EX_EVT.SEEK_GAME_END, arg0_15.OnSeekGameEnd)
	arg0_15:AddListener(ISLAND_EX_EVT.APPROACH_OBJECT, arg0_15.OnApproachObject)
	arg0_15:AddListener(ISLAND_EX_EVT.PLAY_PERFORMANCE, arg0_15.OnPlayPerformance)
	arg0_15:AddListener(ISLAND_EX_EVT.SHOW_INTERACTION, arg0_15.OnShowInteraction)
	arg0_15:AddListener(ISLAND_EX_EVT.SWITCH_MAP_BY_POINT, arg0_15.OnSwitchMapByPoint)
	arg0_15:AddListener(ISLAND_EX_EVT.NAV_PATH, arg0_15.OnStartNavPath)
	arg0_15:AddListener(ISLAND_EX_EVT.NAV_PATH_DONE, arg0_15.OnNavPathDone)
end

function var0_0.RemoveListeners(arg0_16)
	arg0_16:RemoveListener(GAME.ISLAND_UPGRADE_DONE, arg0_16.OnUpgrade)
	arg0_16:RemoveListener(Island.EXP_ADD, arg0_16.OnExpChange)
	arg0_16:RemoveListener(GAME.ISLAND_SET_NAME_DONE, arg0_16.OnModifyName)
	arg0_16:RemoveListener(GAME.ISLAND_PROSPERITY_AWARD_DONE, arg0_16.OnGetProsperityAward)
	arg0_16:RemoveListener(IslandTaskAgency.TASK_ADDED, arg0_16.OnAddedTask)
	arg0_16:RemoveListener(IslandTaskAgency.TASK_UPDATED, arg0_16.OnUpdateTask)
	arg0_16:RemoveListener(IslandTaskAgency.TASK_REMOVED, arg0_16.OnRemoveTask)
	arg0_16:RemoveListener(IslandAchievementAgency.NEW_CAN_GET, arg0_16.OnNewAchievementCanGet)
	arg0_16:RemoveListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_16.OnFinishDelegation)
	arg0_16:RemoveListener(GAME.ISLAND_UNLOCK_TECH_DONE, arg0_16.OnUnlockTechnology)
	arg0_16:RemoveListener(IslandCharacterAgency.ADD_SHIP, arg0_16.OnAddShip)
	arg0_16:RemoveListener(IslandCharacterAgency.SHIP_LEVEL_UP, arg0_16.OnShipLevelUp)
	arg0_16:RemoveListener(IslandCharacterAgency.SHIP_GET_STATE, arg0_16.OnShipGetState)
	arg0_16:RemoveListener(IslandAblityAgency.UNLOCK_SYSTEM, arg0_16.OnUnlockSystem)
	arg0_16:RemoveListener(IslandVisitorAgency.PLAYER_ADD, arg0_16.OnVisitorNumChange)
	arg0_16:RemoveListener(IslandVisitorAgency.PLAYER_EXIT, arg0_16.OnVisitorNumChange)
	arg0_16:RemoveListener(ISLAND_EX_EVT.ENTER_EDIT_AGORA, arg0_16.OnAgoraEnterEditMode)
	arg0_16:RemoveListener(ISLAND_EX_EVT.EXIT_EDIT_AGORA, arg0_16.OnAgoraExitEditMode)
	arg0_16:RemoveListener(ISLAND_EX_EVT.TRIGGER_TASK, arg0_16.OnTriggerTask)
	arg0_16:RemoveListener(ISLAND_EX_EVT.SUBMIT_TASK, arg0_16.OnSubmitTask)
	arg0_16:RemoveListener(ISLAND_EX_EVT.ADD_TASK_PROGRESS, arg0_16.OnAddTaskProgress)
	arg0_16:RemoveListener(ISLAND_EX_EVT.PLAY_STORY, arg0_16.OnPlayStory)
	arg0_16:RemoveListener(ISLAND_EX_EVT.SWITCH_MAP, arg0_16.OnSwitchMap)
	arg0_16:RemoveListener(ISLAND_EX_EVT.SEEK_GAME_START, arg0_16.OnSeekGameStart)
	arg0_16:RemoveListener(ISLAND_EX_EVT.SEEK_GAME_END, arg0_16.OnSeekGameEnd)
	arg0_16:RemoveListener(ISLAND_EX_EVT.APPROACH_OBJECT, arg0_16.OnApproachObject)
	arg0_16:RemoveListener(ISLAND_EX_EVT.PLAY_PERFORMANCE, arg0_16.OnPlayPerformance)
	arg0_16:RemoveListener(ISLAND_EX_EVT.SHOW_INTERACTION, arg0_16.OnShowInteraction)
	arg0_16:RemoveListener(ISLAND_EX_EVT.SWITCH_MAP_BY_POINT, arg0_16.OnSwitchMapByPoint)
	arg0_16:RemoveListener(ISLAND_EX_EVT.NAV_PATH, arg0_16.OnStartNavPath)
	arg0_16:RemoveListener(ISLAND_EX_EVT.NAV_PATH_DONE, arg0_16.OnNavPathDone)
end

function var0_0.OnOpenAnimatonOpPage(arg0_17)
	arg0_17.btnContainer:ActiveOrDisactive(false)
end

function var0_0.OnCloseAnimatonOpPage(arg0_18)
	arg0_18.btnContainer:ActiveOrDisactive(true)
end

function var0_0.OnStartNavPath(arg0_19, arg1_19)
	if arg1_19 then
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = arg1_19
		})
	end
end

function var0_0.OnNavPathDone(arg0_20, arg1_20)
	arg0_20:GetIsland():DispatchEvent(IslandProxy.END_PATHFINDER)
end

function var0_0.OnExpChange(arg0_21)
	arg0_21.levelPanel:ExecuteAction("UpdateIslandInfo")
end

function var0_0.ShowExpAdd(arg0_22, arg1_22, arg2_22)
	arg0_22.levelPanel:ExecuteAction("ShowExpAdd", arg1_22, arg2_22)
end

function var0_0.OnSwitchMapByPoint(arg0_23, arg1_23)
	local var0_23 = arg1_23.mapId

	arg0_23:GetIsland():SetLastExitPosition(arg1_23.mapId, arg1_23.position, arg1_23.rotation)
	arg0_23:emit(IslandBaseMediator.SWITCH_MAP, var0_23)
end

function var0_0.OnShowInteraction(arg0_24, arg1_24)
	IslandGuideChecker.CheckOnShowInteraction(arg1_24)
end

function var0_0.OnPlayPerformance(arg0_25, arg1_25)
	arg0_25:PlayPerformance(arg1_25)
end

function var0_0.OnSeekGameStart(arg0_26)
	arg0_26:TryDisVisible()
end

function var0_0.OnSeekGameEnd(arg0_27)
	arg0_27:TryVisible()
end

function var0_0.OnSwitchMap(arg0_28, arg1_28)
	local var0_28 = pg.island_world_objects[arg1_28].mapId

	arg0_28:emit(IslandBaseMediator.SWITCH_MAP, var0_28, arg1_28)
end

function var0_0.OnPlayStory(arg0_29, arg1_29)
	arg0_29:PlayStory(arg1_29)
end

function var0_0.OnTriggerTask(arg0_30, arg1_30)
	local var0_30 = arg0_30:GetIsland():GetTaskAgency():GetFutureTask(arg1_30)

	if var0_30 and var0_30:IsUnlock() then
		arg0_30:emit(IslandMediator.ON_ACCEPT_TASK, {
			arg1_30
		})
	end
end

function var0_0.OnSubmitTask(arg0_31, arg1_31)
	local var0_31 = arg0_31:GetIsland():GetTaskAgency():GetTask(arg1_31)

	if var0_31 and var0_31:IsFinish() then
		arg0_31:emit(IslandMediator.ON_SUBMIT_TASK, arg1_31)
	end
end

function var0_0.OnAddTaskProgress(arg0_32, arg1_32, arg2_32)
	IslandTaskHelper.UpdateClientTaskProgress(arg1_32, arg2_32)
end

function var0_0.OnApproachObject(arg0_33, arg1_33)
	IslandTaskHelper.OnApproach(arg1_33)
end

function var0_0.OnUpdateTrackTask(arg0_34, arg1_34)
	arg0_34.traceTaskId = arg1_34

	if arg0_34.traceTaskId ~= 0 then
		if not arg0_34.taskTrackPanel:isShowing() then
			arg0_34.taskTrackPanel:ExecuteAction("Show")
		else
			arg0_34.taskTrackPanel:ExecuteAction("UpdateTask")
		end
	end

	arg0_34.btnContainer:OnTrackTaskChange()
end

function var0_0.OnAddedTask(arg0_35, arg1_35)
	arg0_35.btnContainer:OnTrackTaskChange()
end

function var0_0.OnUpdateTask(arg0_36, arg1_36)
	if arg0_36.traceTaskId and arg0_36.traceTaskId ~= arg1_36.id then
		return
	end

	arg0_36.taskTrackPanel:ExecuteAction("UpdateProgress", arg1_36)
	arg0_36.btnContainer:OnTrackTaskChange()
end

function var0_0.OnRemoveTask(arg0_37, arg1_37)
	if arg0_37.traceTaskId and arg0_37.traceTaskId ~= arg1_37.id then
		return
	end

	arg0_37.taskTrackPanel:ExecuteAction("RemoveTask")
	arg0_37.btnContainer:OnTrackTaskChange()
end

function var0_0.UpdateTaskInfo(arg0_38)
	local var0_38 = arg0_38:GetIsland():GetTaskAgency():GetTraceTask()

	if var0_38 then
		arg0_38.traceTaskId = var0_38.id
	end

	if arg0_38.traceTaskId and arg0_38.traceTaskId ~= 0 then
		arg0_38.taskTrackPanel:ExecuteAction("Show")
	else
		arg0_38.taskTrackPanel:ExecuteAction("Hide")
	end

	arg0_38.btnContainer:OnTrackTaskChange()
end

function var0_0.OnSetUpCore(arg0_39, arg1_39, arg2_39)
	arg0_39.approachSpawnPointId = arg2_39
end

function var0_0.OnAgoraEnterEditMode(arg0_40)
	setActive(arg0_40._tf, false)
end

function var0_0.OnAgoraExitEditMode(arg0_41)
	setActive(arg0_41._tf, true)
end

function var0_0.OnShipGetState(arg0_42, arg1_42)
	local var0_42 = arg1_42.ship
	local var1_42 = arg1_42.status
	local var2_42 = var0_42:GetName()

	arg0_42:ShowToast({
		type = IslandToast.TYPE_STATE,
		content = i18n("island_toast_status", var1_42:GetName(), var2_42)
	})
end

function var0_0.OnShipLevelUp(arg0_43, arg1_43)
	local var0_43 = arg1_43:GetName()
	local var1_43 = arg1_43:GetLevel()

	arg0_43:ShowToast({
		content = i18n("island_toast_level", var1_43, var0_43)
	})
end

function var0_0.OnAddShip(arg0_44, arg1_44)
	local var0_44 = arg1_44:GetName()
	local var1_44 = arg0_44:GetIsland():GetName()

	arg0_44:ShowToast({
		content = i18n("island_toast_ship", var1_44, var0_44)
	})
end

function var0_0.OnNewAchievementCanGet(arg0_45, arg1_45)
	if not IslandMainBtnTipHelper.IsUnlock("achievement") then
		return
	end

	arg0_45:ShowToast({
		content = i18n("island_achv_finish_tip", arg1_45:getConfig("name"))
	})
end

function var0_0.OnFinishDelegation(arg0_46)
	arg0_46.btnContainer:OnFinishDelegation()
end

function var0_0.OnUnlockTechnology(arg0_47)
	arg0_47.btnContainer:OnUnlockTechnology()
end

function var0_0.OnUpgrade(arg0_48, arg1_48)
	arg0_48.levelPanel:ExecuteAction("UpdateTip")
	arg0_48.levelPanel:ExecuteAction("UpdateIslandInfo")
	arg0_48:OpenPage(IslandUpgradeDisplayPage, arg1_48.dropData.abilitys, arg1_48.callback)
end

function var0_0.OnModifyName(arg0_49)
	arg0_49.levelPanel:ExecuteAction("UpdateIslandInfo")
end

function var0_0.OnGetProsperityAward(arg0_50)
	arg0_50.levelPanel:ExecuteAction("UpdateTip")
end

function var0_0.OnUnlockSystem(arg0_51, arg1_51)
	arg0_51.btnContainer:OnUnlockSystem(arg1_51)
	switch(arg1_51, {
		[pg.island_set.main_page_function_unlock.key_value_varchar[1]] = function()
			arg0_51.levelPanel:ExecuteAction("Show")
		end,
		[pg.island_set.main_page_function_unlock.key_value_varchar[2]] = function()
			arg0_51.unlockTask = true

			arg0_51.taskTrackPanel:ExecuteAction("SetUnlock")
			arg0_51:UpdateTaskInfo()
		end,
		[pg.island_set.main_page_function_unlock.key_value_varchar[3]] = function()
			setActive(arg0_51.visitorBtn, true)
			arg0_51:UpdateVisitorBtn()
		end
	}, function()
		return
	end)
end

function var0_0.OnVisitorNumChange(arg0_56)
	arg0_56:UpdateVisitorBtn()
end

function var0_0.OnSceneLoaded(arg0_57)
	arg0_57:HandleAwardDisplay({})
	var0_0.super.OnSceneLoaded(arg0_57)

	local var0_57 = arg0_57:GetIsland():GetAblityAgency()

	if var0_57:HasAbility(pg.island_set.main_page_function_unlock.key_value_varchar[1]) then
		arg0_57.levelPanel:ExecuteAction("Show")
	end

	arg0_57.unlockTask = var0_57:HasAbility(pg.island_set.main_page_function_unlock.key_value_varchar[2])

	if arg0_57.unlockTask then
		arg0_57:UpdateTaskInfo()
	end

	local var1_57 = var0_57:HasAbility(pg.island_set.main_page_function_unlock.key_value_varchar[3])

	setActive(arg0_57.visitorBtn, var1_57)

	if var1_57 then
		arg0_57:UpdateVisitorBtn()
	end

	if arg0_57.approachSpawnPointId then
		arg0_57:OnApproachObject(arg0_57.approachSpawnPointId)

		arg0_57.approachSpawnPointId = nil
	end

	arg0_57:SequenceCheck()
end

function var0_0.SequenceCheck(arg0_58)
	seriesAsync({
		function(arg0_59)
			if pg.NewStoryMgr.GetInstance():IsPlayed("ISLAND1001001_1") then
				arg0_59()
			else
				arg0_58:PlayPerformance({
					name = "ISLANDPERFORMANCE1",
					callback = arg0_59
				})
			end
		end,
		function(arg0_60)
			if arg0_58:GetIsland():GetSeasonAgency():NeedReset() then
				arg0_58:emit(IslandMediator.ON_RESET_SEASON, arg0_60)
			else
				arg0_60()
			end
		end,
		function(arg0_61)
			local var0_61, var1_61, var2_61 = arg0_58:GetIsland():GetSeasonAgency():IsShowResetTip()

			if var0_61 then
				local var3_61 = var1_61 > 0 and i18n("island_season_window_end2", var1_61) or i18n("island_season_window_end")

				arg0_58:ShowMsgbox({
					hideNo = true,
					type = IslandMsgBox.TYPE_SEASON_TIP,
					tipTitle = var3_61,
					content = i18n("island_season_window_rule"),
					onHide = function()
						arg0_58:GetIsland():GetSeasonAgency():SetResetTipFlag(var1_61)
						arg0_61()
					end
				})
			else
				arg0_61()
			end
		end,
		function(arg0_63)
			local var0_63 = arg0_58:GetIsland():GetTicketAgency():GetExpiredTickets()

			if #var0_63 > 0 then
				arg0_58:emit(IslandMediator.REMOVE_EXPIRED_TICKETS, var0_63, arg0_63)
			else
				arg0_63()
			end
		end,
		function(arg0_64)
			local var0_64 = arg0_58:GetIsland():GetTicketAgency():GetExpireRemindTickets()

			if #var0_64 > 0 then
				arg0_58:ShowMsgbox({
					hideNo = true,
					type = IslandMsgBox.TYPE_TICKET_EXPIRED,
					body = {
						type = IslandTicketExpiredMsgBoxWindow.TYPES.REMIND,
						tickets = var0_64
					},
					onHide = function()
						arg0_58:GetIsland():GetTicketAgency():SetRemindFlag()
						arg0_64()
					end
				})
			else
				arg0_64()
			end
		end,
		function(arg0_66)
			arg0_58:GetIsland():GetTaskAgency():TrySubmitAutoTasks(arg0_66)
		end,
		function(arg0_67)
			arg0_58:GetIsland():GetTaskAgency():TryAcceptAutoTasks(arg0_67)
		end
	}, function()
		IslandGuideChecker.CheckOnLoaded(arg0_58:GetIsland():GetMapId())
	end)
end

function var0_0.UpdateVisitorBtn(arg0_69)
	setText(arg0_69.visitorBtn:Find("num"), arg0_69:GetIsland():GetVisitorAgency():GetVisitorCnt())
	setText(arg0_69.visitorBtn:Find("Text"), i18n("island_visitor_button"))
end

function var0_0.UpdateMainAwardReward(arg0_70, arg1_70)
	arg0_70.awardDisplayPanel:ExecuteAction("ShowAwards", arg1_70)
end

function var0_0.OnUnloadScene(arg0_71)
	return
end

function var0_0.OnVisible(arg0_72)
	arg0_72:UpdateTaskInfo()
	arg0_72.btnContainer:Flush()

	if not arg0_72:GetSubView(IslandStoryMgr):IsRunning() and not arg0_72.poppingQueue:AnyPlayerIsRunning() then
		IslandGuideChecker.CheckOnLoaded(arg0_72:GetIsland():GetMapId())
	end
end

function var0_0.willExit(arg0_73)
	if arg0_73.btnContainer then
		arg0_73.btnContainer:Dispose()

		arg0_73.btnContainer = nil
	end

	if arg0_73.levelPanel then
		arg0_73.levelPanel:Destroy()

		arg0_73.levelPanel = nil
	end

	if arg0_73.taskTrackPanel then
		arg0_73.taskTrackPanel:Destroy()

		arg0_73.taskTrackPanel = nil
	end

	if arg0_73.awardDisplayPanel then
		arg0_73.awardDisplayPanel:Destroy()

		arg0_73.awardDisplayPanel = nil
	end
end

return var0_0
