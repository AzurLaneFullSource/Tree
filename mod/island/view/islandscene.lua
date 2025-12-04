local var0_0 = class("IslandScene", import(".base.IslandBaseScene"))

var0_0.ON_INVENTORY_FILTER = "IslandScene:ON_INVENTORY_FILTER"
var0_0.ON_CHECK_ORDER_EXP_AWARD = "IslandScene:ON_CHECK_ORDER_EXP_AWARD"

function var0_0.getUIName(arg0_1)
	return "IslandUI"
end

function var0_0.preload(arg0_2, arg1_2)
	seriesAsync({
		function(arg0_3)
			var0_0.super.preload(arg0_2, arg0_3)
		end,
		function(arg0_4)
			IslandTaskHelper.FixTaskLinksStory(arg0_4)
		end
	}, function()
		arg1_2()
	end)
end

function var0_0.loadingQueue(arg0_6)
	return function(arg0_7)
		pg.SceneAnimMgr.GetInstance():CommonSceneChange("Dorm3DLoading", function(arg0_8)
			return arg0_7(arg0_8)
		end)
	end
end

function var0_0.GetIsland(arg0_9)
	return getProxy(IslandProxy):GetIsland()
end

function var0_0.init(arg0_10)
	arg0_10.visitorBtn = arg0_10._tf:Find("top/visitor")
	arg0_10.levelPanel = IslandLevelPanel.New(arg0_10._tf, arg0_10.event)
	arg0_10.taskTrackPanel = Island3dTaskTrackPanel.New(arg0_10._tf:Find("track_container"), arg0_10.event)
	arg0_10.awardDisplayPanel = IslandAwardDisplayInMainPanel.New(arg0_10._tf, arg0_10.event, setmetatable({
		needAdapt = true
	}, {
		__index = arg0_10.contextData
	}))
	arg0_10.btnContainer = IslandMainBtnContainer.New(arg0_10._tf:Find("top/btn_container"), arg0_10.event)
end

function var0_0.didEnter(arg0_11)
	onButton(arg0_11, arg0_11.visitorBtn, function()
		arg0_11:OpenPage(IslandVisitorPage)
	end, SFX_PANEL)
	arg0_11:SetUp()

	local var0_11 = arg0_11.contextData.resumeCallback

	arg0_11.contextData.resumeCallback = nil

	existCall(var0_11)
end

function var0_0.SetUp(arg0_13)
	seriesAsync({
		function(arg0_14)
			arg0_13:SetDressUpIsEmpty(arg0_14)
		end
	}, function()
		arg0_13:StartCore()
	end)
end

function var0_0.SetNameIfIsEmpty(arg0_16, arg1_16)
	if not arg0_16:GetIsland():IsNew() then
		arg1_16()

		return
	end

	local var0_16 = IslandSetNamePage.New(arg0_16)

	var0_16:ExecuteAction("Show", function()
		var0_16:Destroy()
		arg1_16()
	end)
end

function var0_0.SetDressUpIsEmpty(arg0_18, arg1_18)
	if not arg0_18:GetIsland():GetDressUpAgency():IsNew() then
		arg1_18()

		return
	end

	arg0_18:OpenPage(IslandShipFirstDressupPage, arg1_18)
end

function var0_0.AddListeners(arg0_19)
	arg0_19:AddListener(GAME.ISLAND_UPGRADE_DONE, arg0_19.OnUpgrade)
	arg0_19:AddListener(Island.EXP_ADD, arg0_19.OnExpChange)
	arg0_19:AddListener(GAME.ISLAND_SET_NAME_DONE, arg0_19.OnModifyName)
	arg0_19:AddListener(GAME.ISLAND_PROSPERITY_AWARD_DONE, arg0_19.OnGetProsperityAward)
	arg0_19:AddListener(IslandTaskAgency.TASK_ADDED, arg0_19.OnAddedTask)
	arg0_19:AddListener(IslandTaskAgency.TASK_UPDATED, arg0_19.OnUpdateTask)
	arg0_19:AddListener(IslandTaskAgency.TASK_REMOVED, arg0_19.OnRemoveTask)
	arg0_19:AddListener(IslandAchievementAgency.NEW_CAN_GET, arg0_19.OnNewAchievementCanGet)
	arg0_19:AddListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_19.OnFinishDelegation)
	arg0_19:AddListener(GAME.ISLAND_UNLOCK_TECH_DONE, arg0_19.OnUnlockTechnology)
	arg0_19:AddListener(IslandCharacterAgency.ADD_SHIP, arg0_19.OnAddShip)
	arg0_19:AddListener(IslandCharacterAgency.SHIP_LEVEL_UP, arg0_19.OnShipLevelUp)
	arg0_19:AddListener(IslandCharacterAgency.SHIP_GET_STATE, arg0_19.OnShipGetState)
	arg0_19:AddListener(IslandAblityAgency.UNLOCK_SYSTEM, arg0_19.OnUnlockSystem)
	arg0_19:AddListener(IslandVisitorAgency.PLAYER_ADD, arg0_19.OnVisitorNumChange)
	arg0_19:AddListener(IslandVisitorAgency.PLAYER_EXIT, arg0_19.OnVisitorNumChange)
	arg0_19:AddListener(ISLAND_EX_EVT.ENTER_EDIT_AGORA, arg0_19.OnAgoraEnterEditMode)
	arg0_19:AddListener(ISLAND_EX_EVT.EXIT_EDIT_AGORA, arg0_19.OnAgoraExitEditMode)
	arg0_19:AddListener(ISLAND_EX_EVT.TRIGGER_TASK, arg0_19.OnTriggerTask)
	arg0_19:AddListener(ISLAND_EX_EVT.SUBMIT_TASK, arg0_19.OnSubmitTask)
	arg0_19:AddListener(ISLAND_EX_EVT.ADD_TASK_PROGRESS, arg0_19.OnAddTaskProgress)
	arg0_19:AddListener(ISLAND_EX_EVT.PLAY_STORY, arg0_19.OnPlayStory)
	arg0_19:AddListener(ISLAND_EX_EVT.SWITCH_MAP, arg0_19.OnSwitchMap)
	arg0_19:AddListener(ISLAND_EX_EVT.SEEK_GAME_START, arg0_19.OnSeekGameStart)
	arg0_19:AddListener(ISLAND_EX_EVT.SEEK_GAME_END, arg0_19.OnSeekGameEnd)
	arg0_19:AddListener(ISLAND_EX_EVT.ENTER_FISH_POINT, arg0_19.OnEnterFishPoint)
	arg0_19:AddListener(ISLAND_EX_EVT.EXIT_FISH_POINT, arg0_19.OnExitFishPoint)
	arg0_19:AddListener(ISLAND_EX_EVT.APPROACH_OBJECT, arg0_19.OnApproachObject)
	arg0_19:AddListener(ISLAND_EX_EVT.PLAY_PERFORMANCE, arg0_19.OnPlayPerformance)
	arg0_19:AddListener(ISLAND_EX_EVT.SHOW_INTERACTION, arg0_19.OnShowInteraction)
	arg0_19:AddListener(ISLAND_EX_EVT.SWITCH_MAP_BY_POINT, arg0_19.OnSwitchMapByPoint)
	arg0_19:AddListener(ISLAND_EX_EVT.NAV_PATH, arg0_19.OnStartNavPath)
	arg0_19:AddListener(ISLAND_EX_EVT.NAV_PATH_DONE, arg0_19.OnNavPathDone)
end

function var0_0.RemoveListeners(arg0_20)
	arg0_20:RemoveListener(GAME.ISLAND_UPGRADE_DONE, arg0_20.OnUpgrade)
	arg0_20:RemoveListener(Island.EXP_ADD, arg0_20.OnExpChange)
	arg0_20:RemoveListener(GAME.ISLAND_SET_NAME_DONE, arg0_20.OnModifyName)
	arg0_20:RemoveListener(GAME.ISLAND_PROSPERITY_AWARD_DONE, arg0_20.OnGetProsperityAward)
	arg0_20:RemoveListener(IslandTaskAgency.TASK_ADDED, arg0_20.OnAddedTask)
	arg0_20:RemoveListener(IslandTaskAgency.TASK_UPDATED, arg0_20.OnUpdateTask)
	arg0_20:RemoveListener(IslandTaskAgency.TASK_REMOVED, arg0_20.OnRemoveTask)
	arg0_20:RemoveListener(IslandAchievementAgency.NEW_CAN_GET, arg0_20.OnNewAchievementCanGet)
	arg0_20:RemoveListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_20.OnFinishDelegation)
	arg0_20:RemoveListener(GAME.ISLAND_UNLOCK_TECH_DONE, arg0_20.OnUnlockTechnology)
	arg0_20:RemoveListener(IslandCharacterAgency.ADD_SHIP, arg0_20.OnAddShip)
	arg0_20:RemoveListener(IslandCharacterAgency.SHIP_LEVEL_UP, arg0_20.OnShipLevelUp)
	arg0_20:RemoveListener(IslandCharacterAgency.SHIP_GET_STATE, arg0_20.OnShipGetState)
	arg0_20:RemoveListener(IslandAblityAgency.UNLOCK_SYSTEM, arg0_20.OnUnlockSystem)
	arg0_20:RemoveListener(IslandVisitorAgency.PLAYER_ADD, arg0_20.OnVisitorNumChange)
	arg0_20:RemoveListener(IslandVisitorAgency.PLAYER_EXIT, arg0_20.OnVisitorNumChange)
	arg0_20:RemoveListener(ISLAND_EX_EVT.ENTER_EDIT_AGORA, arg0_20.OnAgoraEnterEditMode)
	arg0_20:RemoveListener(ISLAND_EX_EVT.EXIT_EDIT_AGORA, arg0_20.OnAgoraExitEditMode)
	arg0_20:RemoveListener(ISLAND_EX_EVT.TRIGGER_TASK, arg0_20.OnTriggerTask)
	arg0_20:RemoveListener(ISLAND_EX_EVT.SUBMIT_TASK, arg0_20.OnSubmitTask)
	arg0_20:RemoveListener(ISLAND_EX_EVT.ADD_TASK_PROGRESS, arg0_20.OnAddTaskProgress)
	arg0_20:RemoveListener(ISLAND_EX_EVT.PLAY_STORY, arg0_20.OnPlayStory)
	arg0_20:RemoveListener(ISLAND_EX_EVT.SWITCH_MAP, arg0_20.OnSwitchMap)
	arg0_20:RemoveListener(ISLAND_EX_EVT.SEEK_GAME_START, arg0_20.OnSeekGameStart)
	arg0_20:RemoveListener(ISLAND_EX_EVT.SEEK_GAME_END, arg0_20.OnSeekGameEnd)
	arg0_20:RemoveListener(ISLAND_EX_EVT.ENTER_FISH_POINT, arg0_20.OnEnterFishPoint)
	arg0_20:RemoveListener(ISLAND_EX_EVT.EXIT_FISH_POINT, arg0_20.OnExitFishPoint)
	arg0_20:RemoveListener(ISLAND_EX_EVT.APPROACH_OBJECT, arg0_20.OnApproachObject)
	arg0_20:RemoveListener(ISLAND_EX_EVT.PLAY_PERFORMANCE, arg0_20.OnPlayPerformance)
	arg0_20:RemoveListener(ISLAND_EX_EVT.SHOW_INTERACTION, arg0_20.OnShowInteraction)
	arg0_20:RemoveListener(ISLAND_EX_EVT.SWITCH_MAP_BY_POINT, arg0_20.OnSwitchMapByPoint)
	arg0_20:RemoveListener(ISLAND_EX_EVT.NAV_PATH, arg0_20.OnStartNavPath)
	arg0_20:RemoveListener(ISLAND_EX_EVT.NAV_PATH_DONE, arg0_20.OnNavPathDone)
end

function var0_0.OnEnterFishPoint(arg0_21)
	arg0_21:TryDisVisible()
end

function var0_0.OnExitFishPoint(arg0_22)
	arg0_22:TryVisible()
end

function var0_0.OnOpenAnimatonOpPage(arg0_23)
	arg0_23.btnContainer:ActiveOrDisactive(false)
end

function var0_0.OnCloseAnimatonOpPage(arg0_24)
	arg0_24.btnContainer:ActiveOrDisactive(true)
end

function var0_0.OnStartNavPath(arg0_25, arg1_25)
	if arg1_25 then
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = arg1_25
		})
	end
end

function var0_0.OnNavPathDone(arg0_26, arg1_26)
	arg0_26:GetIsland():DispatchEvent(IslandProxy.END_PATHFINDER)
end

function var0_0.OnExpChange(arg0_27)
	arg0_27.levelPanel:ExecuteAction("UpdateIslandInfo")
end

function var0_0.ShowExpAdd(arg0_28, arg1_28, arg2_28)
	arg0_28.levelPanel:ExecuteAction("ShowExpAdd", arg1_28, arg2_28)
end

function var0_0.OnSwitchMapByPoint(arg0_29, arg1_29)
	local var0_29 = arg1_29.mapId

	arg0_29:GetIsland():SetLastExitPosition(arg1_29.mapId, arg1_29.position, arg1_29.rotation)
	arg0_29:emit(IslandBaseMediator.SWITCH_MAP, var0_29)
end

function var0_0.OnShowInteraction(arg0_30, arg1_30)
	IslandGuideChecker.CheckOnShowInteraction(arg1_30)
end

function var0_0.OnPlayPerformance(arg0_31, arg1_31)
	arg0_31:PlayPerformance(arg1_31)
end

function var0_0.OnSeekGameStart(arg0_32)
	arg0_32:TryDisVisible()
end

function var0_0.OnSeekGameEnd(arg0_33)
	arg0_33:TryVisible()
end

function var0_0.OnSwitchMap(arg0_34, arg1_34)
	local var0_34 = pg.island_world_objects[arg1_34].mapId

	arg0_34:emit(IslandBaseMediator.SWITCH_MAP, var0_34, arg1_34)
end

function var0_0.OnPlayStory(arg0_35, arg1_35)
	arg0_35:PlayStory(arg1_35)
end

function var0_0.OnTriggerTask(arg0_36, arg1_36)
	local var0_36 = arg0_36:GetIsland():GetTaskAgency():GetFutureTask(arg1_36)

	if var0_36 and var0_36:IsUnlock() then
		arg0_36:emit(IslandMediator.ON_ACCEPT_TASK, {
			arg1_36
		})
	end
end

function var0_0.OnSubmitTask(arg0_37, arg1_37)
	local var0_37 = arg0_37:GetIsland():GetTaskAgency():GetTask(arg1_37)

	if var0_37 and var0_37:IsFinish() then
		arg0_37:emit(IslandMediator.ON_SUBMIT_TASK, arg1_37)
	end
end

function var0_0.OnAddTaskProgress(arg0_38, arg1_38, arg2_38)
	IslandTaskHelper.UpdateClientTaskProgress(arg1_38, arg2_38)
end

function var0_0.OnApproachObject(arg0_39, arg1_39)
	IslandTaskHelper.OnApproach(arg1_39)
end

function var0_0.OnUpdateTrackTask(arg0_40, arg1_40, arg2_40)
	if arg2_40 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_40.mainTraceTaskId = arg1_40
	elseif arg2_40 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_40.otherTraceTaskId = arg1_40
	end

	if arg0_40.mainTraceTaskId and arg0_40.mainTraceTaskId ~= 0 or arg0_40.otherTraceTaskId and arg0_40.otherTraceTaskId ~= 0 then
		arg0_40.taskTrackPanel:ExecuteAction("Show")
	end

	arg0_40.btnContainer:OnTrackTaskChange()
end

function var0_0.OnAddedTask(arg0_41, arg1_41)
	return
end

function var0_0.OnUpdateTask(arg0_42, arg1_42)
	if arg0_42.mainTraceTaskId and arg0_42.mainTraceTaskId == arg1_42.id then
		arg0_42.taskTrackPanel:ExecuteAction("UpdateProgress", IslandTaskTrackCard.TYPES.MAIN)
		arg0_42.btnContainer:OnTrackTaskChange()
	elseif arg0_42.otherTraceTaskId and arg0_42.otherTraceTaskId == arg1_42.id then
		arg0_42.taskTrackPanel:ExecuteAction("UpdateProgress", IslandTaskTrackCard.TYPES.OTHER)
		arg0_42.btnContainer:OnTrackTaskChange()
	end
end

function var0_0.OnRemoveTask(arg0_43, arg1_43)
	if arg0_43.mainTraceTaskId and arg0_43.mainTraceTaskId == arg1_43.id then
		arg0_43.taskTrackPanel:ExecuteAction("RemoveTask", IslandTaskTrackCard.TYPES.MAIN)
		arg0_43.btnContainer:OnTrackTaskChange()
	elseif arg0_43.otherTraceTaskId and arg0_43.otherTraceTaskId == arg1_43.id then
		arg0_43.taskTrackPanel:ExecuteAction("RemoveTask", IslandTaskTrackCard.TYPES.OTHER)
		arg0_43.btnContainer:OnTrackTaskChange()
	end
end

function var0_0.UpdateTaskInfo(arg0_44)
	local var0_44 = arg0_44:GetIsland():GetTaskAgency():GetMainTraceTask()
	local var1_44 = arg0_44:GetIsland():GetTaskAgency():GetTraceTask()

	if var0_44 then
		arg0_44.mainTraceTaskId = var0_44.id
	end

	if var1_44 then
		arg0_44.otherTraceTaskId = var1_44.id
	end

	if arg0_44.otherTraceTaskId and arg0_44.otherTraceTaskId ~= 0 or arg0_44.mainTraceTaskId and arg0_44.mainTraceTaskId ~= 0 then
		arg0_44.taskTrackPanel:ExecuteAction("Show")
	else
		arg0_44.taskTrackPanel:ExecuteAction("Hide")
	end

	arg0_44.btnContainer:OnTrackTaskChange()
end

function var0_0.OnSetUpCore(arg0_45, arg1_45, arg2_45)
	arg0_45.approachSpawnPointId = arg2_45
end

function var0_0.OnAgoraEnterEditMode(arg0_46)
	setActive(arg0_46._tf, false)
end

function var0_0.OnAgoraExitEditMode(arg0_47)
	setActive(arg0_47._tf, true)
end

function var0_0.OnShipGetState(arg0_48, arg1_48)
	local var0_48 = arg1_48.ship
	local var1_48 = arg1_48.status
	local var2_48 = var0_48:GetName()

	arg0_48:ShowToast({
		type = IslandToast.TYPE_STATE,
		content = i18n("island_toast_status", var1_48:GetName(), var2_48)
	})
end

function var0_0.OnShipLevelUp(arg0_49, arg1_49)
	local var0_49 = arg1_49:GetName()
	local var1_49 = arg1_49:GetLevel()

	arg0_49:ShowToast({
		content = i18n("island_toast_level", var1_49, var0_49)
	})
end

function var0_0.OnAddShip(arg0_50, arg1_50)
	local var0_50 = arg1_50:GetName()
	local var1_50 = arg0_50:GetIsland():GetName()

	arg0_50:ShowToast({
		content = i18n("island_toast_ship", var1_50, var0_50)
	})
end

function var0_0.OnNewAchievementCanGet(arg0_51, arg1_51)
	if not IslandMainBtnTipHelper.IsUnlock("achievement") then
		return
	end

	arg0_51:ShowToast({
		content = i18n("island_achv_finish_tip", arg1_51:getConfig("name"))
	})
end

function var0_0.OnFinishDelegation(arg0_52)
	arg0_52.btnContainer:OnFinishDelegation()
end

function var0_0.OnUnlockTechnology(arg0_53)
	arg0_53.btnContainer:OnUnlockTechnology()
end

function var0_0.OnUpgrade(arg0_54, arg1_54)
	arg0_54.levelPanel:ExecuteAction("UpdateTip")
	arg0_54.levelPanel:ExecuteAction("UpdateIslandInfo")

	local var0_54 = {}

	seriesAsync({
		function(arg0_55)
			arg0_54:OpenPage(IslandUpgradeDisplayPage, arg1_54.dropData.abilitys, arg0_55)
		end,
		function(arg0_56)
			arg0_54:DisplaySystemUnlock(arg1_54.dropData.abilitys, arg0_56)
		end
	}, arg1_54.callback)
end

function var0_0.OnModifyName(arg0_57)
	arg0_57.levelPanel:ExecuteAction("UpdateIslandInfo")
end

function var0_0.OnGetProsperityAward(arg0_58)
	arg0_58.levelPanel:ExecuteAction("UpdateTip")
end

function var0_0.OnUnlockSystem(arg0_59, arg1_59)
	arg0_59.btnContainer:OnUnlockSystem(arg1_59)
	switch(arg1_59, {
		[pg.island_set.main_page_function_unlock.key_value_varchar[1]] = function()
			arg0_59.levelPanel:ExecuteAction("Show")
		end,
		[pg.island_set.main_page_function_unlock.key_value_varchar[2]] = function()
			arg0_59.unlockTask = true

			arg0_59.taskTrackPanel:ExecuteAction("SetUnlock")
			arg0_59:UpdateTaskInfo()
		end,
		[pg.island_set.main_page_function_unlock.key_value_varchar[3]] = function()
			setActive(arg0_59.visitorBtn, true)
			arg0_59:UpdateVisitorBtn()
		end
	}, function()
		return
	end)
end

function var0_0.OnVisitorNumChange(arg0_64)
	arg0_64:UpdateVisitorBtn()
end

function var0_0.OnSceneLoaded(arg0_65)
	arg0_65:HandleAwardDisplay({})
	var0_0.super.OnSceneLoaded(arg0_65)

	local var0_65 = arg0_65:GetIsland():GetAblityAgency()

	if var0_65:HasAbility(pg.island_set.main_page_function_unlock.key_value_varchar[1]) then
		arg0_65.levelPanel:ExecuteAction("Show")
	end

	arg0_65.unlockTask = var0_65:HasAbility(pg.island_set.main_page_function_unlock.key_value_varchar[2])

	if arg0_65.unlockTask then
		arg0_65:UpdateTaskInfo()
	end

	local var1_65 = var0_65:HasAbility(pg.island_set.main_page_function_unlock.key_value_varchar[3])

	setActive(arg0_65.visitorBtn, var1_65)

	if var1_65 then
		arg0_65:UpdateVisitorBtn()
	end

	if arg0_65.approachSpawnPointId then
		arg0_65:OnApproachObject(arg0_65.approachSpawnPointId)

		arg0_65.approachSpawnPointId = nil
	end

	arg0_65:SequenceCheck()
end

function var0_0.SequenceCheck(arg0_66)
	seriesAsync({
		function(arg0_67)
			if pg.NewStoryMgr.GetInstance():IsPlayed("ISLAND1001001_1") then
				arg0_67()
			else
				arg0_66:PlayPerformance({
					name = "ISLANDPERFORMANCE1",
					callback = arg0_67
				})
			end
		end,
		function(arg0_68)
			if arg0_66:GetIsland():GetSeasonAgency():NeedReset() then
				arg0_66:emit(IslandMediator.ON_RESET_SEASON, arg0_68)
			else
				arg0_68()
			end
		end,
		function(arg0_69)
			local var0_69, var1_69, var2_69 = arg0_66:GetIsland():GetSeasonAgency():IsShowResetTip()

			if var0_69 then
				local var3_69 = var1_69 > 0 and i18n("island_season_window_end2", var1_69) or i18n("island_season_window_end")

				arg0_66:ShowMsgbox({
					hideNo = true,
					type = IslandMsgBox.TYPE_SEASON_TIP,
					tipTitle = var3_69,
					content = i18n("island_season_window_rule"),
					onHide = function()
						arg0_66:GetIsland():GetSeasonAgency():SetResetTipFlag(var1_69)
						arg0_69()
					end
				})
			else
				arg0_69()
			end
		end,
		function(arg0_71)
			local var0_71 = arg0_66:GetIsland():GetTicketAgency():GetExpiredTickets()

			if #var0_71 > 0 then
				arg0_66:emit(IslandMediator.REMOVE_EXPIRED_TICKETS, var0_71, arg0_71)
			else
				arg0_71()
			end
		end,
		function(arg0_72)
			local var0_72 = arg0_66:GetIsland():GetTicketAgency():GetExpireRemindTickets()

			if #var0_72 > 0 then
				arg0_66:ShowMsgbox({
					hideNo = true,
					type = IslandMsgBox.TYPE_TICKET_EXPIRED,
					body = {
						type = IslandTicketExpiredMsgBoxWindow.TYPES.REMIND,
						tickets = var0_72
					},
					onHide = function()
						arg0_66:GetIsland():GetTicketAgency():SetRemindFlag()
						arg0_72()
					end
				})
			else
				arg0_72()
			end
		end,
		function(arg0_74)
			arg0_66:GetIsland():GetTaskAgency():TrySubmitAutoTasks(arg0_74)
		end,
		function(arg0_75)
			arg0_66:GetIsland():GetTaskAgency():TryAcceptAutoTasks(arg0_75)
		end
	}, function()
		IslandGuideChecker.CheckOnLoaded(arg0_66:GetIsland():GetMapId())
	end)
end

function var0_0.UpdateVisitorBtn(arg0_77)
	setText(arg0_77.visitorBtn:Find("num"), arg0_77:GetIsland():GetVisitorAgency():GetVisitorCnt())
	setText(arg0_77.visitorBtn:Find("Text"), i18n("island_visitor_button"))
end

function var0_0.UpdateMainAwardReward(arg0_78, arg1_78)
	arg0_78.awardDisplayPanel:ExecuteAction("ShowAwards", arg1_78)
end

function var0_0.OnUnloadScene(arg0_79)
	return
end

function var0_0.OnVisible(arg0_80)
	arg0_80:UpdateTaskInfo()
	arg0_80.btnContainer:Flush()

	if not arg0_80:GetSubView(IslandStoryMgr):IsRunning() and not arg0_80.poppingQueue:AnyPlayerIsRunning() then
		IslandGuideChecker.CheckOnLoaded(arg0_80:GetIsland():GetMapId())
	end
end

function var0_0.willExit(arg0_81)
	if arg0_81.btnContainer then
		arg0_81.btnContainer:Dispose()

		arg0_81.btnContainer = nil
	end

	if arg0_81.levelPanel then
		arg0_81.levelPanel:Destroy()

		arg0_81.levelPanel = nil
	end

	if arg0_81.taskTrackPanel then
		arg0_81.taskTrackPanel:Destroy()

		arg0_81.taskTrackPanel = nil
	end

	if arg0_81.awardDisplayPanel then
		arg0_81.awardDisplayPanel:Destroy()

		arg0_81.awardDisplayPanel = nil
	end
end

return var0_0
