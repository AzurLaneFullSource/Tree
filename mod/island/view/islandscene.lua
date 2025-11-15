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
	arg0_20:RemoveListener(ISLAND_EX_EVT.APPROACH_OBJECT, arg0_20.OnApproachObject)
	arg0_20:RemoveListener(ISLAND_EX_EVT.PLAY_PERFORMANCE, arg0_20.OnPlayPerformance)
	arg0_20:RemoveListener(ISLAND_EX_EVT.SHOW_INTERACTION, arg0_20.OnShowInteraction)
	arg0_20:RemoveListener(ISLAND_EX_EVT.SWITCH_MAP_BY_POINT, arg0_20.OnSwitchMapByPoint)
	arg0_20:RemoveListener(ISLAND_EX_EVT.NAV_PATH, arg0_20.OnStartNavPath)
	arg0_20:RemoveListener(ISLAND_EX_EVT.NAV_PATH_DONE, arg0_20.OnNavPathDone)
end

function var0_0.OnOpenAnimatonOpPage(arg0_21)
	arg0_21.btnContainer:ActiveOrDisactive(false)
end

function var0_0.OnCloseAnimatonOpPage(arg0_22)
	arg0_22.btnContainer:ActiveOrDisactive(true)
end

function var0_0.OnStartNavPath(arg0_23, arg1_23)
	if arg1_23 then
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = arg1_23
		})
	end
end

function var0_0.OnNavPathDone(arg0_24, arg1_24)
	arg0_24:GetIsland():DispatchEvent(IslandProxy.END_PATHFINDER)
end

function var0_0.OnExpChange(arg0_25)
	arg0_25.levelPanel:ExecuteAction("UpdateIslandInfo")
end

function var0_0.ShowExpAdd(arg0_26, arg1_26, arg2_26)
	arg0_26.levelPanel:ExecuteAction("ShowExpAdd", arg1_26, arg2_26)
end

function var0_0.OnSwitchMapByPoint(arg0_27, arg1_27)
	local var0_27 = arg1_27.mapId

	arg0_27:GetIsland():SetLastExitPosition(arg1_27.mapId, arg1_27.position, arg1_27.rotation)
	arg0_27:emit(IslandBaseMediator.SWITCH_MAP, var0_27)
end

function var0_0.OnShowInteraction(arg0_28, arg1_28)
	IslandGuideChecker.CheckOnShowInteraction(arg1_28)
end

function var0_0.OnPlayPerformance(arg0_29, arg1_29)
	arg0_29:PlayPerformance(arg1_29)
end

function var0_0.OnSeekGameStart(arg0_30)
	arg0_30:TryDisVisible()
end

function var0_0.OnSeekGameEnd(arg0_31)
	arg0_31:TryVisible()
end

function var0_0.OnSwitchMap(arg0_32, arg1_32)
	local var0_32 = pg.island_world_objects[arg1_32].mapId

	arg0_32:emit(IslandBaseMediator.SWITCH_MAP, var0_32, arg1_32)
end

function var0_0.OnPlayStory(arg0_33, arg1_33)
	arg0_33:PlayStory(arg1_33)
end

function var0_0.OnTriggerTask(arg0_34, arg1_34)
	local var0_34 = arg0_34:GetIsland():GetTaskAgency():GetFutureTask(arg1_34)

	if var0_34 and var0_34:IsUnlock() then
		arg0_34:emit(IslandMediator.ON_ACCEPT_TASK, {
			arg1_34
		})
	end
end

function var0_0.OnSubmitTask(arg0_35, arg1_35)
	local var0_35 = arg0_35:GetIsland():GetTaskAgency():GetTask(arg1_35)

	if var0_35 and var0_35:IsFinish() then
		arg0_35:emit(IslandMediator.ON_SUBMIT_TASK, arg1_35)
	end
end

function var0_0.OnAddTaskProgress(arg0_36, arg1_36, arg2_36)
	IslandTaskHelper.UpdateClientTaskProgress(arg1_36, arg2_36)
end

function var0_0.OnApproachObject(arg0_37, arg1_37)
	IslandTaskHelper.OnApproach(arg1_37)
end

function var0_0.OnUpdateTrackTask(arg0_38, arg1_38, arg2_38)
	if arg2_38 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_38.mainTraceTaskId = arg1_38
	elseif arg2_38 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_38.otherTraceTaskId = arg1_38
	end

	if arg0_38.mainTraceTaskId and arg0_38.mainTraceTaskId ~= 0 or arg0_38.otherTraceTaskId and arg0_38.otherTraceTaskId ~= 0 then
		arg0_38.taskTrackPanel:ExecuteAction("Show")
	end

	arg0_38.btnContainer:OnTrackTaskChange()
end

function var0_0.OnAddedTask(arg0_39, arg1_39)
	return
end

function var0_0.OnUpdateTask(arg0_40, arg1_40)
	if arg0_40.mainTraceTaskId and arg0_40.mainTraceTaskId == arg1_40.id then
		arg0_40.taskTrackPanel:ExecuteAction("UpdateProgress", IslandTaskTrackCard.TYPES.MAIN)
		arg0_40.btnContainer:OnTrackTaskChange()
	elseif arg0_40.otherTraceTaskId and arg0_40.otherTraceTaskId == arg1_40.id then
		arg0_40.taskTrackPanel:ExecuteAction("UpdateProgress", IslandTaskTrackCard.TYPES.OTHER)
		arg0_40.btnContainer:OnTrackTaskChange()
	end
end

function var0_0.OnRemoveTask(arg0_41, arg1_41)
	if arg0_41.mainTraceTaskId and arg0_41.mainTraceTaskId == arg1_41.id then
		arg0_41.taskTrackPanel:ExecuteAction("RemoveTask", IslandTaskTrackCard.TYPES.MAIN)
		arg0_41.btnContainer:OnTrackTaskChange()
	elseif arg0_41.otherTraceTaskId and arg0_41.otherTraceTaskId == arg1_41.id then
		arg0_41.taskTrackPanel:ExecuteAction("RemoveTask", IslandTaskTrackCard.TYPES.OTHER)
		arg0_41.btnContainer:OnTrackTaskChange()
	end
end

function var0_0.UpdateTaskInfo(arg0_42)
	local var0_42 = arg0_42:GetIsland():GetTaskAgency():GetMainTraceTask()
	local var1_42 = arg0_42:GetIsland():GetTaskAgency():GetTraceTask()

	if var0_42 then
		arg0_42.mainTraceTaskId = var0_42.id
	end

	if var1_42 then
		arg0_42.otherTraceTaskId = var1_42.id
	end

	if arg0_42.otherTraceTaskId and arg0_42.otherTraceTaskId ~= 0 or arg0_42.mainTraceTaskId and arg0_42.mainTraceTaskId ~= 0 then
		arg0_42.taskTrackPanel:ExecuteAction("Show")
	else
		arg0_42.taskTrackPanel:ExecuteAction("Hide")
	end

	arg0_42.btnContainer:OnTrackTaskChange()
end

function var0_0.OnSetUpCore(arg0_43, arg1_43, arg2_43)
	arg0_43.approachSpawnPointId = arg2_43
end

function var0_0.OnAgoraEnterEditMode(arg0_44)
	setActive(arg0_44._tf, false)
end

function var0_0.OnAgoraExitEditMode(arg0_45)
	setActive(arg0_45._tf, true)
end

function var0_0.OnShipGetState(arg0_46, arg1_46)
	local var0_46 = arg1_46.ship
	local var1_46 = arg1_46.status
	local var2_46 = var0_46:GetName()

	arg0_46:ShowToast({
		type = IslandToast.TYPE_STATE,
		content = i18n("island_toast_status", var1_46:GetName(), var2_46)
	})
end

function var0_0.OnShipLevelUp(arg0_47, arg1_47)
	local var0_47 = arg1_47:GetName()
	local var1_47 = arg1_47:GetLevel()

	arg0_47:ShowToast({
		content = i18n("island_toast_level", var1_47, var0_47)
	})
end

function var0_0.OnAddShip(arg0_48, arg1_48)
	local var0_48 = arg1_48:GetName()
	local var1_48 = arg0_48:GetIsland():GetName()

	arg0_48:ShowToast({
		content = i18n("island_toast_ship", var1_48, var0_48)
	})
end

function var0_0.OnNewAchievementCanGet(arg0_49, arg1_49)
	if not IslandMainBtnTipHelper.IsUnlock("achievement") then
		return
	end

	arg0_49:ShowToast({
		content = i18n("island_achv_finish_tip", arg1_49:getConfig("name"))
	})
end

function var0_0.OnFinishDelegation(arg0_50)
	arg0_50.btnContainer:OnFinishDelegation()
end

function var0_0.OnUnlockTechnology(arg0_51)
	arg0_51.btnContainer:OnUnlockTechnology()
end

function var0_0.OnUpgrade(arg0_52, arg1_52)
	arg0_52.levelPanel:ExecuteAction("UpdateTip")
	arg0_52.levelPanel:ExecuteAction("UpdateIslandInfo")

	local var0_52 = {}

	seriesAsync({
		function(arg0_53)
			arg0_52:OpenPage(IslandUpgradeDisplayPage, arg1_52.dropData.abilitys, arg0_53)
		end,
		function(arg0_54)
			arg0_52:DisplaySystemUnlock(arg1_52.dropData.abilitys, arg0_54)
		end
	}, arg1_52.callback)
end

function var0_0.OnModifyName(arg0_55)
	arg0_55.levelPanel:ExecuteAction("UpdateIslandInfo")
end

function var0_0.OnGetProsperityAward(arg0_56)
	arg0_56.levelPanel:ExecuteAction("UpdateTip")
end

function var0_0.OnUnlockSystem(arg0_57, arg1_57)
	arg0_57.btnContainer:OnUnlockSystem(arg1_57)
	switch(arg1_57, {
		[pg.island_set.main_page_function_unlock.key_value_varchar[1]] = function()
			arg0_57.levelPanel:ExecuteAction("Show")
		end,
		[pg.island_set.main_page_function_unlock.key_value_varchar[2]] = function()
			arg0_57.unlockTask = true

			arg0_57.taskTrackPanel:ExecuteAction("SetUnlock")
			arg0_57:UpdateTaskInfo()
		end,
		[pg.island_set.main_page_function_unlock.key_value_varchar[3]] = function()
			setActive(arg0_57.visitorBtn, true)
			arg0_57:UpdateVisitorBtn()
		end
	}, function()
		return
	end)
end

function var0_0.OnVisitorNumChange(arg0_62)
	arg0_62:UpdateVisitorBtn()
end

function var0_0.OnSceneLoaded(arg0_63)
	arg0_63:HandleAwardDisplay({})
	var0_0.super.OnSceneLoaded(arg0_63)

	local var0_63 = arg0_63:GetIsland():GetAblityAgency()

	if var0_63:HasAbility(pg.island_set.main_page_function_unlock.key_value_varchar[1]) then
		arg0_63.levelPanel:ExecuteAction("Show")
	end

	arg0_63.unlockTask = var0_63:HasAbility(pg.island_set.main_page_function_unlock.key_value_varchar[2])

	if arg0_63.unlockTask then
		arg0_63:UpdateTaskInfo()
	end

	local var1_63 = var0_63:HasAbility(pg.island_set.main_page_function_unlock.key_value_varchar[3])

	setActive(arg0_63.visitorBtn, var1_63)

	if var1_63 then
		arg0_63:UpdateVisitorBtn()
	end

	if arg0_63.approachSpawnPointId then
		arg0_63:OnApproachObject(arg0_63.approachSpawnPointId)

		arg0_63.approachSpawnPointId = nil
	end

	arg0_63:SequenceCheck()
end

function var0_0.SequenceCheck(arg0_64)
	seriesAsync({
		function(arg0_65)
			if pg.NewStoryMgr.GetInstance():IsPlayed("ISLAND1001001_1") then
				arg0_65()
			else
				arg0_64:PlayPerformance({
					name = "ISLANDPERFORMANCE1",
					callback = arg0_65
				})
			end
		end,
		function(arg0_66)
			if arg0_64:GetIsland():GetSeasonAgency():NeedReset() then
				arg0_64:emit(IslandMediator.ON_RESET_SEASON, arg0_66)
			else
				arg0_66()
			end
		end,
		function(arg0_67)
			local var0_67, var1_67, var2_67 = arg0_64:GetIsland():GetSeasonAgency():IsShowResetTip()

			if var0_67 then
				local var3_67 = var1_67 > 0 and i18n("island_season_window_end2", var1_67) or i18n("island_season_window_end")

				arg0_64:ShowMsgbox({
					hideNo = true,
					type = IslandMsgBox.TYPE_SEASON_TIP,
					tipTitle = var3_67,
					content = i18n("island_season_window_rule"),
					onHide = function()
						arg0_64:GetIsland():GetSeasonAgency():SetResetTipFlag(var1_67)
						arg0_67()
					end
				})
			else
				arg0_67()
			end
		end,
		function(arg0_69)
			local var0_69 = arg0_64:GetIsland():GetTicketAgency():GetExpiredTickets()

			if #var0_69 > 0 then
				arg0_64:emit(IslandMediator.REMOVE_EXPIRED_TICKETS, var0_69, arg0_69)
			else
				arg0_69()
			end
		end,
		function(arg0_70)
			local var0_70 = arg0_64:GetIsland():GetTicketAgency():GetExpireRemindTickets()

			if #var0_70 > 0 then
				arg0_64:ShowMsgbox({
					hideNo = true,
					type = IslandMsgBox.TYPE_TICKET_EXPIRED,
					body = {
						type = IslandTicketExpiredMsgBoxWindow.TYPES.REMIND,
						tickets = var0_70
					},
					onHide = function()
						arg0_64:GetIsland():GetTicketAgency():SetRemindFlag()
						arg0_70()
					end
				})
			else
				arg0_70()
			end
		end,
		function(arg0_72)
			arg0_64:GetIsland():GetTaskAgency():TrySubmitAutoTasks(arg0_72)
		end,
		function(arg0_73)
			arg0_64:GetIsland():GetTaskAgency():TryAcceptAutoTasks(arg0_73)
		end
	}, function()
		IslandGuideChecker.CheckOnLoaded(arg0_64:GetIsland():GetMapId())
	end)
end

function var0_0.UpdateVisitorBtn(arg0_75)
	setText(arg0_75.visitorBtn:Find("num"), arg0_75:GetIsland():GetVisitorAgency():GetVisitorCnt())
	setText(arg0_75.visitorBtn:Find("Text"), i18n("island_visitor_button"))
end

function var0_0.UpdateMainAwardReward(arg0_76, arg1_76)
	arg0_76.awardDisplayPanel:ExecuteAction("ShowAwards", arg1_76)
end

function var0_0.OnUnloadScene(arg0_77)
	return
end

function var0_0.OnVisible(arg0_78)
	arg0_78:UpdateTaskInfo()
	arg0_78.btnContainer:Flush()

	if not arg0_78:GetSubView(IslandStoryMgr):IsRunning() and not arg0_78.poppingQueue:AnyPlayerIsRunning() then
		IslandGuideChecker.CheckOnLoaded(arg0_78:GetIsland():GetMapId())
	end
end

function var0_0.willExit(arg0_79)
	if arg0_79.btnContainer then
		arg0_79.btnContainer:Dispose()

		arg0_79.btnContainer = nil
	end

	if arg0_79.levelPanel then
		arg0_79.levelPanel:Destroy()

		arg0_79.levelPanel = nil
	end

	if arg0_79.taskTrackPanel then
		arg0_79.taskTrackPanel:Destroy()

		arg0_79.taskTrackPanel = nil
	end

	if arg0_79.awardDisplayPanel then
		arg0_79.awardDisplayPanel:Destroy()

		arg0_79.awardDisplayPanel = nil
	end
end

return var0_0
