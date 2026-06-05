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
			IslandTaskActhelper.TriggerActTasks(arg0_4)
		end,
		function(arg0_5)
			IslandTaskHelper.FixTaskLinksStory(arg0_5)
		end
	}, function()
		arg1_2()
	end)
end

function var0_0.loadingQueue(arg0_7)
	return function(arg0_8)
		pg.SceneAnimMgr.GetInstance():CommonSceneChange("Dorm3DLoading", function(arg0_9)
			return arg0_8(arg0_9)
		end)
	end
end

function var0_0.GetIsland(arg0_10)
	return getProxy(IslandProxy):GetIsland()
end

function var0_0.init(arg0_11)
	arg0_11.visitorBtn = arg0_11._tf:Find("top/visitor")
	arg0_11.levelPanel = IslandLevelPanel.New(arg0_11._tf, arg0_11.event)
	arg0_11.taskTrackPanel = Island3dTaskTrackPanel.New(arg0_11._tf:Find("track_container"), arg0_11.event)
	arg0_11.awardDisplayPanel = IslandAwardDisplayInMainPanel.New(arg0_11._tf, arg0_11.event, setmetatable({
		needAdapt = true
	}, {
		__index = arg0_11.contextData
	}))
	arg0_11.btnContainer = IslandMainBtnContainer.New(arg0_11._tf:Find("top/btn_container"), arg0_11.event)
end

function var0_0.didEnter(arg0_12)
	onButton(arg0_12, arg0_12.visitorBtn, function()
		arg0_12:OpenPage(IslandVisitorPage)
	end, SFX_PANEL)
	arg0_12:SetUp()

	local var0_12 = arg0_12.contextData.resumeCallback

	arg0_12.contextData.resumeCallback = nil

	existCall(var0_12)
end

function var0_0.SetUp(arg0_14)
	seriesAsync({
		function(arg0_15)
			arg0_14:SetDressUpIsEmpty(arg0_15)
		end
	}, function()
		arg0_14:StartCore()
	end)
end

function var0_0.SetNameIfIsEmpty(arg0_17, arg1_17)
	if not arg0_17:GetIsland():IsNew() then
		arg1_17()

		return
	end

	local var0_17 = IslandSetNamePage.New(arg0_17)

	var0_17:ExecuteAction("Show", function()
		var0_17:Destroy()
		arg1_17()
	end)
end

function var0_0.SetDressUpIsEmpty(arg0_19, arg1_19)
	if not arg0_19:GetIsland():GetDressUpAgency():IsNew() then
		arg1_19()

		return
	end

	arg0_19:OpenPage(IslandShipFirstDressupPage, arg1_19)
end

function var0_0.AddListeners(arg0_20)
	arg0_20:AddListener(GAME.ISLAND_UPGRADE_DONE, arg0_20.OnUpgrade)
	arg0_20:AddListener(Island.EXP_ADD, arg0_20.OnExpChange)
	arg0_20:AddListener(GAME.ISLAND_SET_NAME_DONE, arg0_20.OnModifyName)
	arg0_20:AddListener(GAME.ISLAND_PROSPERITY_AWARD_DONE, arg0_20.OnGetProsperityAward)
	arg0_20:AddListener(IslandTaskAgency.TASK_ADDED, arg0_20.OnAddedTask)
	arg0_20:AddListener(IslandTaskAgency.TASK_UPDATED, arg0_20.OnUpdateTask)
	arg0_20:AddListener(IslandTaskAgency.TASK_REMOVED, arg0_20.OnRemoveTask)
	arg0_20:AddListener(IslandAchievementAgency.NEW_CAN_GET, arg0_20.OnNewAchievementCanGet)
	arg0_20:AddListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_20.OnFinishDelegation)
	arg0_20:AddListener(GAME.ISLAND_UNLOCK_TECH_DONE, arg0_20.OnUnlockTechnology)
	arg0_20:AddListener(IslandCharacterAgency.ADD_SHIP, arg0_20.OnAddShip)
	arg0_20:AddListener(IslandCharacterAgency.SHIP_LEVEL_UP, arg0_20.OnShipLevelUp)
	arg0_20:AddListener(IslandCharacterAgency.SHIP_GET_STATE, arg0_20.OnShipGetState)
	arg0_20:AddListener(IslandAblityAgency.UNLOCK_SYSTEM, arg0_20.OnUnlockSystem)
	arg0_20:AddListener(IslandVisitorAgency.PLAYER_ADD, arg0_20.OnVisitorNumChange)
	arg0_20:AddListener(IslandVisitorAgency.PLAYER_EXIT, arg0_20.OnVisitorNumChange)
	arg0_20:AddListener(ISLAND_EX_EVT.ENTER_EDIT_AGORA, arg0_20.OnAgoraEnterEditMode)
	arg0_20:AddListener(ISLAND_EX_EVT.EXIT_EDIT_AGORA, arg0_20.OnAgoraExitEditMode)
	arg0_20:AddListener(ISLAND_EX_EVT.TRIGGER_TASK, arg0_20.OnTriggerTask)
	arg0_20:AddListener(ISLAND_EX_EVT.SUBMIT_TASK, arg0_20.OnSubmitTask)
	arg0_20:AddListener(ISLAND_EX_EVT.ADD_TASK_PROGRESS, arg0_20.OnAddTaskProgress)
	arg0_20:AddListener(ISLAND_EX_EVT.PLAY_STORY, arg0_20.OnPlayStory)
	arg0_20:AddListener(ISLAND_EX_EVT.SWITCH_MAP, arg0_20.OnSwitchMap)
	arg0_20:AddListener(ISLAND_EX_EVT.SEEK_GAME_START, arg0_20.OnSeekGameStart)
	arg0_20:AddListener(ISLAND_EX_EVT.SEEK_GAME_END, arg0_20.OnSeekGameEnd)
	arg0_20:AddListener(ISLAND_EX_EVT.ENTER_FISH_POINT, arg0_20.OnEnterFishPoint)
	arg0_20:AddListener(ISLAND_EX_EVT.EXIT_FISH_POINT, arg0_20.OnExitFishPoint)
	arg0_20:AddListener(ISLAND_EX_EVT.APPROACH_OBJECT, arg0_20.OnApproachObject)
	arg0_20:AddListener(ISLAND_EX_EVT.PLAY_PERFORMANCE, arg0_20.OnPlayPerformance)
	arg0_20:AddListener(ISLAND_EX_EVT.SHOW_INTERACTION, arg0_20.OnShowInteraction)
	arg0_20:AddListener(ISLAND_EX_EVT.SWITCH_MAP_BY_POINT, arg0_20.OnSwitchMapByPoint)
	arg0_20:AddListener(ISLAND_EX_EVT.NAV_PATH, arg0_20.OnStartNavPath)
	arg0_20:AddListener(ISLAND_EX_EVT.NAV_PATH_DONE, arg0_20.OnNavPathDone)
end

function var0_0.RemoveListeners(arg0_21)
	arg0_21:RemoveListener(GAME.ISLAND_UPGRADE_DONE, arg0_21.OnUpgrade)
	arg0_21:RemoveListener(Island.EXP_ADD, arg0_21.OnExpChange)
	arg0_21:RemoveListener(GAME.ISLAND_SET_NAME_DONE, arg0_21.OnModifyName)
	arg0_21:RemoveListener(GAME.ISLAND_PROSPERITY_AWARD_DONE, arg0_21.OnGetProsperityAward)
	arg0_21:RemoveListener(IslandTaskAgency.TASK_ADDED, arg0_21.OnAddedTask)
	arg0_21:RemoveListener(IslandTaskAgency.TASK_UPDATED, arg0_21.OnUpdateTask)
	arg0_21:RemoveListener(IslandTaskAgency.TASK_REMOVED, arg0_21.OnRemoveTask)
	arg0_21:RemoveListener(IslandAchievementAgency.NEW_CAN_GET, arg0_21.OnNewAchievementCanGet)
	arg0_21:RemoveListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_21.OnFinishDelegation)
	arg0_21:RemoveListener(GAME.ISLAND_UNLOCK_TECH_DONE, arg0_21.OnUnlockTechnology)
	arg0_21:RemoveListener(IslandCharacterAgency.ADD_SHIP, arg0_21.OnAddShip)
	arg0_21:RemoveListener(IslandCharacterAgency.SHIP_LEVEL_UP, arg0_21.OnShipLevelUp)
	arg0_21:RemoveListener(IslandCharacterAgency.SHIP_GET_STATE, arg0_21.OnShipGetState)
	arg0_21:RemoveListener(IslandAblityAgency.UNLOCK_SYSTEM, arg0_21.OnUnlockSystem)
	arg0_21:RemoveListener(IslandVisitorAgency.PLAYER_ADD, arg0_21.OnVisitorNumChange)
	arg0_21:RemoveListener(IslandVisitorAgency.PLAYER_EXIT, arg0_21.OnVisitorNumChange)
	arg0_21:RemoveListener(ISLAND_EX_EVT.ENTER_EDIT_AGORA, arg0_21.OnAgoraEnterEditMode)
	arg0_21:RemoveListener(ISLAND_EX_EVT.EXIT_EDIT_AGORA, arg0_21.OnAgoraExitEditMode)
	arg0_21:RemoveListener(ISLAND_EX_EVT.TRIGGER_TASK, arg0_21.OnTriggerTask)
	arg0_21:RemoveListener(ISLAND_EX_EVT.SUBMIT_TASK, arg0_21.OnSubmitTask)
	arg0_21:RemoveListener(ISLAND_EX_EVT.ADD_TASK_PROGRESS, arg0_21.OnAddTaskProgress)
	arg0_21:RemoveListener(ISLAND_EX_EVT.PLAY_STORY, arg0_21.OnPlayStory)
	arg0_21:RemoveListener(ISLAND_EX_EVT.SWITCH_MAP, arg0_21.OnSwitchMap)
	arg0_21:RemoveListener(ISLAND_EX_EVT.SEEK_GAME_START, arg0_21.OnSeekGameStart)
	arg0_21:RemoveListener(ISLAND_EX_EVT.SEEK_GAME_END, arg0_21.OnSeekGameEnd)
	arg0_21:RemoveListener(ISLAND_EX_EVT.ENTER_FISH_POINT, arg0_21.OnEnterFishPoint)
	arg0_21:RemoveListener(ISLAND_EX_EVT.EXIT_FISH_POINT, arg0_21.OnExitFishPoint)
	arg0_21:RemoveListener(ISLAND_EX_EVT.APPROACH_OBJECT, arg0_21.OnApproachObject)
	arg0_21:RemoveListener(ISLAND_EX_EVT.PLAY_PERFORMANCE, arg0_21.OnPlayPerformance)
	arg0_21:RemoveListener(ISLAND_EX_EVT.SHOW_INTERACTION, arg0_21.OnShowInteraction)
	arg0_21:RemoveListener(ISLAND_EX_EVT.SWITCH_MAP_BY_POINT, arg0_21.OnSwitchMapByPoint)
	arg0_21:RemoveListener(ISLAND_EX_EVT.NAV_PATH, arg0_21.OnStartNavPath)
	arg0_21:RemoveListener(ISLAND_EX_EVT.NAV_PATH_DONE, arg0_21.OnNavPathDone)
end

function var0_0.OnEnterFishPoint(arg0_22)
	arg0_22:TryDisVisible()
end

function var0_0.OnExitFishPoint(arg0_23)
	arg0_23:TryVisible()
end

function var0_0.OnOpenAnimatonOpPage(arg0_24)
	arg0_24.btnContainer:ActiveOrDisactive(false)
end

function var0_0.OnCloseAnimatonOpPage(arg0_25)
	arg0_25.btnContainer:ActiveOrDisactive(true)
end

function var0_0.OnStartNavPath(arg0_26, arg1_26)
	if arg1_26 then
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = arg1_26
		})
	end
end

function var0_0.OnNavPathDone(arg0_27, arg1_27)
	arg0_27:GetIsland():DispatchEvent(IslandProxy.END_PATHFINDER)
end

function var0_0.OnExpChange(arg0_28)
	arg0_28.levelPanel:ExecuteAction("UpdateIslandInfo")
end

function var0_0.ShowExpAdd(arg0_29, arg1_29, arg2_29)
	arg0_29.levelPanel:ExecuteAction("ShowExpAdd", arg1_29, arg2_29)
end

function var0_0.OnSwitchMapByPoint(arg0_30, arg1_30)
	local var0_30 = arg1_30.mapId

	arg0_30:GetIsland():SetLastExitPosition(arg1_30.mapId, arg1_30.position, arg1_30.rotation)
	arg0_30:emit(IslandBaseMediator.SWITCH_MAP, var0_30)
end

function var0_0.OnShowInteraction(arg0_31, arg1_31)
	IslandGuideChecker.CheckOnShowInteraction(arg1_31)
end

function var0_0.OnPlayPerformance(arg0_32, arg1_32)
	arg0_32:PlayPerformance(arg1_32)
end

function var0_0.OnSeekGameStart(arg0_33)
	arg0_33:TryDisVisible()
end

function var0_0.OnSeekGameEnd(arg0_34)
	arg0_34:TryVisible()
end

function var0_0.OnSwitchMap(arg0_35, arg1_35)
	local var0_35 = pg.island_world_objects[arg1_35].mapId

	arg0_35:emit(IslandBaseMediator.SWITCH_MAP, var0_35, arg1_35)
end

function var0_0.OnPlayStory(arg0_36, arg1_36)
	arg0_36:PlayStory(arg1_36)
end

function var0_0.OnTriggerTask(arg0_37, arg1_37)
	local var0_37 = arg0_37:GetIsland():GetTaskAgency():GetFutureTask(arg1_37)

	if var0_37 and var0_37:IsUnlock() then
		arg0_37:emit(IslandMediator.ON_ACCEPT_TASK, {
			arg1_37
		})
	end
end

function var0_0.OnSubmitTask(arg0_38, arg1_38)
	local var0_38 = arg0_38:GetIsland():GetTaskAgency():GetTask(arg1_38)

	if var0_38 and var0_38:IsFinish() then
		arg0_38:emit(IslandMediator.ON_SUBMIT_TASK, arg1_38)
	end
end

function var0_0.OnAddTaskProgress(arg0_39, arg1_39, arg2_39)
	IslandTaskHelper.UpdateClientTaskProgress(arg1_39, arg2_39)
end

function var0_0.OnApproachObject(arg0_40, arg1_40)
	IslandTaskHelper.OnApproach(arg1_40)
end

function var0_0.OnUpdateTrackTask(arg0_41, arg1_41, arg2_41)
	if arg2_41 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_41.mainTraceTaskId = arg1_41
	elseif arg2_41 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_41.otherTraceTaskId = arg1_41
	end

	if arg0_41.mainTraceTaskId and arg0_41.mainTraceTaskId ~= 0 or arg0_41.otherTraceTaskId and arg0_41.otherTraceTaskId ~= 0 then
		arg0_41.taskTrackPanel:ExecuteAction("Show")
	end

	arg0_41.btnContainer:OnTrackTaskChange()
end

function var0_0.OnAddedTask(arg0_42, arg1_42)
	arg0_42.btnContainer:OnTaskUpdate()
end

function var0_0.OnUpdateTask(arg0_43, arg1_43)
	if arg0_43.mainTraceTaskId and arg0_43.mainTraceTaskId == arg1_43.id then
		arg0_43.taskTrackPanel:ExecuteAction("UpdateProgress", IslandTaskTrackCard.TYPES.MAIN)
		arg0_43.btnContainer:OnTrackTaskChange()
	elseif arg0_43.otherTraceTaskId and arg0_43.otherTraceTaskId == arg1_43.id then
		arg0_43.taskTrackPanel:ExecuteAction("UpdateProgress", IslandTaskTrackCard.TYPES.OTHER)
		arg0_43.btnContainer:OnTrackTaskChange()
	end

	arg0_43.btnContainer:OnTaskUpdate()
end

function var0_0.OnRemoveTask(arg0_44, arg1_44)
	if arg0_44.mainTraceTaskId and arg0_44.mainTraceTaskId == arg1_44.id then
		arg0_44.taskTrackPanel:ExecuteAction("RemoveTask", IslandTaskTrackCard.TYPES.MAIN)
		arg0_44.btnContainer:OnTrackTaskChange()
	elseif arg0_44.otherTraceTaskId and arg0_44.otherTraceTaskId == arg1_44.id then
		arg0_44.taskTrackPanel:ExecuteAction("RemoveTask", IslandTaskTrackCard.TYPES.OTHER)
		arg0_44.btnContainer:OnTrackTaskChange()
	end

	arg0_44.btnContainer:OnTaskUpdate()
end

function var0_0.UpdateTaskInfo(arg0_45)
	local var0_45 = arg0_45:GetIsland():GetTaskAgency():GetMainTraceTask()
	local var1_45 = arg0_45:GetIsland():GetTaskAgency():GetTraceTask()

	if var0_45 then
		arg0_45.mainTraceTaskId = var0_45.id
	end

	if var1_45 then
		arg0_45.otherTraceTaskId = var1_45.id
	end

	if arg0_45.otherTraceTaskId and arg0_45.otherTraceTaskId ~= 0 or arg0_45.mainTraceTaskId and arg0_45.mainTraceTaskId ~= 0 then
		arg0_45.taskTrackPanel:ExecuteAction("Show")
	else
		arg0_45.taskTrackPanel:ExecuteAction("Hide")
	end

	arg0_45.btnContainer:OnTrackTaskChange()
	arg0_45.btnContainer:OnTaskUpdate()
end

function var0_0.OnSetUpCore(arg0_46, arg1_46, arg2_46)
	arg0_46.approachSpawnPointId = arg2_46
end

function var0_0.OnAgoraEnterEditMode(arg0_47)
	setActive(arg0_47._tf, false)
end

function var0_0.OnAgoraExitEditMode(arg0_48)
	setActive(arg0_48._tf, true)
end

function var0_0.OnShipGetState(arg0_49, arg1_49)
	local var0_49 = arg1_49.ship
	local var1_49 = arg1_49.status
	local var2_49 = var0_49:GetName()

	arg0_49:ShowToast({
		type = IslandToast.TYPE_STATE,
		content = i18n("island_toast_status", var1_49:GetName(), var2_49)
	})
end

function var0_0.OnShipLevelUp(arg0_50, arg1_50)
	local var0_50 = arg1_50:GetName()
	local var1_50 = arg1_50:GetLevel()

	arg0_50:ShowToast({
		content = i18n("island_toast_level", var1_50, var0_50)
	})
end

function var0_0.OnAddShip(arg0_51, arg1_51)
	local var0_51 = arg1_51:GetName()
	local var1_51 = arg0_51:GetIsland():GetName()

	arg0_51:ShowToast({
		content = i18n("island_toast_ship", var1_51, var0_51)
	})
end

function var0_0.OnNewAchievementCanGet(arg0_52, arg1_52)
	if not IslandMainBtnTipHelper.IsUnlock("achievement") then
		return
	end

	arg0_52:ShowToast({
		content = i18n("island_achv_finish_tip", arg1_52:getConfig("name"))
	})
end

function var0_0.OnFinishDelegation(arg0_53)
	arg0_53.btnContainer:OnFinishDelegation()
end

function var0_0.OnUnlockTechnology(arg0_54)
	arg0_54.btnContainer:OnUnlockTechnology()
end

function var0_0.OnUpgrade(arg0_55, arg1_55)
	arg0_55.levelPanel:ExecuteAction("UpdateTip")
	arg0_55.levelPanel:ExecuteAction("UpdateIslandInfo")

	local var0_55 = {}

	seriesAsync({
		function(arg0_56)
			arg0_55:OpenPage(IslandUpgradeDisplayPage, arg1_55.dropData.abilitys, arg0_56)
		end,
		function(arg0_57)
			arg0_55:DisplaySystemUnlock(arg1_55.dropData.abilitys, arg0_57)
		end
	}, arg1_55.callback)
end

function var0_0.OnModifyName(arg0_58)
	arg0_58.levelPanel:ExecuteAction("UpdateIslandInfo")
end

function var0_0.OnGetProsperityAward(arg0_59)
	arg0_59.levelPanel:ExecuteAction("UpdateTip")
end

function var0_0.OnUnlockSystem(arg0_60, arg1_60)
	arg0_60.btnContainer:OnUnlockSystem(arg1_60)
	switch(arg1_60, {
		[pg.island_set.main_page_function_unlock.key_value_varchar[1]] = function()
			arg0_60.levelPanel:ExecuteAction("Show")
		end,
		[pg.island_set.main_page_function_unlock.key_value_varchar[2]] = function()
			arg0_60.unlockTask = true

			arg0_60.taskTrackPanel:ExecuteAction("SetUnlock")
			arg0_60:UpdateTaskInfo()
		end,
		[pg.island_set.main_page_function_unlock.key_value_varchar[3]] = function()
			setActive(arg0_60.visitorBtn, true)
			arg0_60:UpdateVisitorBtn()
		end
	}, function()
		return
	end)
end

function var0_0.OnVisitorNumChange(arg0_65)
	arg0_65:UpdateVisitorBtn()
end

function var0_0.OnSceneLoaded(arg0_66)
	arg0_66:HandleAwardDisplay({})
	var0_0.super.OnSceneLoaded(arg0_66)

	local var0_66 = arg0_66:GetIsland():GetAblityAgency()

	if var0_66:HasAbility(pg.island_set.main_page_function_unlock.key_value_varchar[1]) then
		arg0_66.levelPanel:ExecuteAction("Show")
	end

	arg0_66.unlockTask = var0_66:HasAbility(pg.island_set.main_page_function_unlock.key_value_varchar[2])

	if arg0_66.unlockTask then
		arg0_66:UpdateTaskInfo()
	end

	local var1_66 = var0_66:HasAbility(pg.island_set.main_page_function_unlock.key_value_varchar[3])

	setActive(arg0_66.visitorBtn, var1_66)

	if var1_66 then
		arg0_66:UpdateVisitorBtn()
	end

	if arg0_66.approachSpawnPointId then
		arg0_66:OnApproachObject(arg0_66.approachSpawnPointId)

		arg0_66.approachSpawnPointId = nil
	end

	arg0_66:SequenceCheck()
end

function var0_0.SequenceCheck(arg0_67)
	seriesAsync({
		function(arg0_68)
			if pg.NewStoryMgr.GetInstance():IsPlayed("ISLAND1001001_1") then
				arg0_68()
			else
				arg0_67:PlayPerformance({
					name = "ISLANDPERFORMANCE1",
					callback = arg0_68
				})
			end
		end,
		function(arg0_69)
			arg0_67:SeasonResetCheck(arg0_69)
		end,
		function(arg0_70)
			local var0_70, var1_70, var2_70 = arg0_67:GetIsland():GetSeasonAgency():IsShowResetTip()

			if var0_70 then
				local var3_70 = var1_70 > 0 and i18n("island_season_window_end2", var1_70) or i18n("island_season_window_end")

				arg0_67:ShowMsgbox({
					hideNo = true,
					type = IslandMsgBox.TYPE_SEASON_TIP,
					tipTitle = var3_70,
					content = i18n("island_season_window_rule"),
					onHide = function()
						arg0_67:GetIsland():GetSeasonAgency():SetResetTipFlag(var1_70)
						arg0_70()
					end
				})
			else
				arg0_70()
			end
		end,
		function(arg0_72)
			local var0_72 = arg0_67:GetIsland():GetTicketAgency():GetExpiredTickets()

			if #var0_72 > 0 then
				arg0_67:emit(IslandMediator.REMOVE_EXPIRED_TICKETS, var0_72, arg0_72)
			else
				arg0_72()
			end
		end,
		function(arg0_73)
			local var0_73 = arg0_67:GetIsland():GetTicketAgency():GetExpireRemindTickets()

			if #var0_73 > 0 then
				arg0_67:ShowMsgbox({
					hideNo = true,
					type = IslandMsgBox.TYPE_TICKET_EXPIRED,
					body = {
						type = IslandTicketExpiredMsgBoxWindow.TYPES.REMIND,
						tickets = var0_73
					},
					onHide = function()
						arg0_67:GetIsland():GetTicketAgency():SetRemindFlag()
						arg0_73()
					end
				})
			else
				arg0_73()
			end
		end,
		function(arg0_75)
			arg0_67:GetIsland():GetTaskAgency():TrySubmitAutoTasks(arg0_75)
		end,
		function(arg0_76)
			arg0_67:GetIsland():GetTaskAgency():TryAcceptAutoTasks(arg0_76)
		end
	}, function()
		IslandGuideChecker.CheckOnLoaded(arg0_67:GetIsland():GetMapId())
	end)
end

function var0_0.SeasonResetCheck(arg0_78, arg1_78)
	local var0_78, var1_78 = IslandSeasonAgency.CheckReset()

	if var0_78 then
		seriesAsync({
			function(arg0_79)
				arg0_78:ShowMsgbox({
					hideNo = true,
					type = IslandMsgBox.TYPE_COMMON,
					content = i18n("island_season_reset"),
					onHide = arg0_79
				})
			end
		}, function()
			arg0_78:ShowMsgbox({
				type = IslandMsgBox.TYPE_SEASON_RESET,
				body = var1_78,
				onHide = arg1_78
			})
		end)
	else
		arg1_78()
	end
end

function var0_0.UpdateVisitorBtn(arg0_81)
	setText(arg0_81.visitorBtn:Find("num"), arg0_81:GetIsland():GetVisitorAgency():GetVisitorCnt())
	setText(arg0_81.visitorBtn:Find("Text"), i18n("island_visitor_button"))
end

function var0_0.UpdateMainAwardReward(arg0_82, arg1_82)
	arg0_82.awardDisplayPanel:ExecuteAction("ShowAwards", arg1_82)
end

function var0_0.OnUnloadScene(arg0_83)
	return
end

function var0_0.OnVisible(arg0_84)
	arg0_84:UpdateTaskInfo()
	arg0_84.btnContainer:Flush()

	if not arg0_84:GetSubView(IslandStoryMgr):IsRunning() and not arg0_84.poppingQueue:AnyPlayerIsRunning() then
		IslandGuideChecker.CheckOnLoaded(arg0_84:GetIsland():GetMapId())
	end
end

function var0_0.willExit(arg0_85)
	if arg0_85.btnContainer then
		arg0_85.btnContainer:Dispose()

		arg0_85.btnContainer = nil
	end

	if arg0_85.levelPanel then
		arg0_85.levelPanel:Destroy()

		arg0_85.levelPanel = nil
	end

	if arg0_85.taskTrackPanel then
		arg0_85.taskTrackPanel:Destroy()

		arg0_85.taskTrackPanel = nil
	end

	if arg0_85.awardDisplayPanel then
		arg0_85.awardDisplayPanel:Destroy()

		arg0_85.awardDisplayPanel = nil
	end
end

function var0_0.onBackPressed(arg0_86)
	if arg0_86.sceneMgr:GetPage(IslandCheaterTavernMainPage) then
		pg.m02:sendNotification(IslandProxy.PRESS_BACK)

		return
	end

	var0_0.super.onBackPressed(arg0_86)
end

return var0_0
