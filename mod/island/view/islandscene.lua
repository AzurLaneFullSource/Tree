local var0_0 = class("IslandScene", import(".base.IslandBaseScene"))

var0_0.ON_INVENTORY_FILTER = "IslandScene:ON_INVENTORY_FILTER"
var0_0.ON_CHECK_ORDER_EXP_AWARD = "IslandScene:ON_CHECK_ORDER_EXP_AWARD"

function var0_0.getUIName(arg0_1)
	return "IslandUI"
end

function var0_0.GetIsland(arg0_2)
	return getProxy(IslandProxy):GetIsland()
end

function var0_0.PlayBGM(arg0_3)
	pg.BgmMgr.GetInstance():StopPlay()
end

function var0_0.init(arg0_4)
	arg0_4.visitorBtn = arg0_4:findTF("top/visitor")
	arg0_4.levelPanel = IslandLevelPanel.New(arg0_4._tf, arg0_4.event)
	arg0_4.taskTrackPanel = Island3dTaskTrackPanel.New(arg0_4._tf, arg0_4.event)
	arg0_4.awardDisplayPanel = IslandAwardDisplayInMainPanel.New(arg0_4._tf, arg0_4.event)
	arg0_4.btnContainer = IslandMainBtnContainer.New(arg0_4._tf:Find("top/btn_container"), arg0_4.event)
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5.visitorBtn, function()
		arg0_5:OpenPage(IslandVisitorPage)
	end, SFX_PANEL)
	arg0_5:SetUp()
end

function var0_0.SetUp(arg0_7)
	seriesAsync({
		function(arg0_8)
			arg0_7:SetDressUpIsEmpty(arg0_8)
		end
	}, function()
		arg0_7:StartCore()
	end)
end

function var0_0.SetNameIfIsEmpty(arg0_10, arg1_10)
	if not arg0_10:GetIsland():IsNew() then
		arg1_10()

		return
	end

	local var0_10 = IslandSetNamePage.New(arg0_10)

	var0_10:ExecuteAction("Show", function()
		var0_10:Destroy()
		arg1_10()
	end)
end

function var0_0.SetDressUpIsEmpty(arg0_12, arg1_12)
	if not arg0_12:GetIsland():GetDressUpAgency():IsNew() then
		arg1_12()

		return
	end

	arg0_12:OpenPage(IslandShipFirstDressupPage, arg1_12)
end

function var0_0.AddListeners(arg0_13)
	arg0_13:AddListener(GAME.ISLAND_UPGRADE_DONE, arg0_13.OnUpgrade)
	arg0_13:AddListener(Island.EXP_ADD, arg0_13.OnExpChange)
	arg0_13:AddListener(GAME.ISLAND_SET_NAME_DONE, arg0_13.OnModifyName)
	arg0_13:AddListener(GAME.ISLAND_PROSPERITY_AWARD_DONE, arg0_13.OnGetProsperityAward)
	arg0_13:AddListener(IslandTaskAgency.TASK_ADDED, arg0_13.OnAddedTask)
	arg0_13:AddListener(IslandTaskAgency.TASK_UPDATED, arg0_13.OnUpdateTask)
	arg0_13:AddListener(IslandTaskAgency.TASK_REMOVED, arg0_13.OnRemoveTask)
	arg0_13:AddListener(IslandAchievementAgency.NEW_CAN_GET, arg0_13.OnNewAchievementCanGet)
	arg0_13:AddListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_13.OnFinishDelegation)
	arg0_13:AddListener(GAME.ISLAND_UNLOCK_TECH_DONE, arg0_13.OnUnlockTechnology)
	arg0_13:AddListener(IslandCharacterAgency.ADD_SHIP, arg0_13.OnAddShip)
	arg0_13:AddListener(IslandCharacterAgency.SHIP_LEVEL_UP, arg0_13.OnShipLevelUp)
	arg0_13:AddListener(IslandCharacterAgency.SHIP_GET_STATE, arg0_13.OnShipGetState)
	arg0_13:AddListener(IslandAblityAgency.UNLOCK_SYSTEM, arg0_13.OnUnlockSystem)
	arg0_13:AddListener(IslandVisitorAgency.PLAYER_ADD, arg0_13.OnVisitorNumChange)
	arg0_13:AddListener(IslandVisitorAgency.PLAYER_EXIT, arg0_13.OnVisitorNumChange)
	arg0_13:AddListener(ISLAND_EX_EVT.ENTER_EDIT_AGORA, arg0_13.OnAgoraEnterEditMode)
	arg0_13:AddListener(ISLAND_EX_EVT.EXIT_EDIT_AGORA, arg0_13.OnAgoraExitEditMode)
	arg0_13:AddListener(ISLAND_EX_EVT.TRIGGER_TASK, arg0_13.OnTriggerTask)
	arg0_13:AddListener(ISLAND_EX_EVT.SUBMIT_TASK, arg0_13.OnSubmitTask)
	arg0_13:AddListener(ISLAND_EX_EVT.ADD_TASK_PROGRESS, arg0_13.OnAddTaskProgress)
	arg0_13:AddListener(ISLAND_EX_EVT.PLAY_STORY, arg0_13.OnPlayStory)
	arg0_13:AddListener(ISLAND_EX_EVT.SWITCH_MAP, arg0_13.OnSwitchMap)
	arg0_13:AddListener(ISLAND_EX_EVT.SEEK_GAME_START, arg0_13.OnSeekGameStart)
	arg0_13:AddListener(ISLAND_EX_EVT.SEEK_GAME_END, arg0_13.OnSeekGameEnd)
	arg0_13:AddListener(ISLAND_EX_EVT.APPROACH_OBJECT, arg0_13.OnApproachObject)
	arg0_13:AddListener(ISLAND_EX_EVT.PLAY_PERFORMANCE, arg0_13.OnPlayPerformance)
	arg0_13:AddListener(ISLAND_EX_EVT.SHOW_INTERACTION, arg0_13.OnShowInteraction)
	arg0_13:AddListener(ISLAND_EX_EVT.SWITCH_MAP_BY_POINT, arg0_13.OnSwitchMapByPoint)
	arg0_13:AddListener(ISLAND_EX_EVT.NAV_PATH_DONE, arg0_13.OnNavPathDone)
	arg0_13:AddListener(ISLAND_EX_EVT.OPEN_ANIMATION_OP, arg0_13.OnOpenAnimatonOpPage)
	arg0_13:AddListener(ISLAND_EX_EVT.CLOSE_ANIMATION_OP, arg0_13.OnCloseAnimatonOpPage)
end

function var0_0.RemoveListeners(arg0_14)
	arg0_14:RemoveListener(GAME.ISLAND_UPGRADE_DONE, arg0_14.OnUpgrade)
	arg0_14:RemoveListener(Island.EXP_ADD, arg0_14.OnExpChange)
	arg0_14:RemoveListener(GAME.ISLAND_SET_NAME_DONE, arg0_14.OnModifyName)
	arg0_14:RemoveListener(GAME.ISLAND_PROSPERITY_AWARD_DONE, arg0_14.OnGetProsperityAward)
	arg0_14:RemoveListener(IslandTaskAgency.TASK_ADDED, arg0_14.OnAddedTask)
	arg0_14:RemoveListener(IslandTaskAgency.TASK_UPDATED, arg0_14.OnUpdateTask)
	arg0_14:RemoveListener(IslandTaskAgency.TASK_REMOVED, arg0_14.OnRemoveTask)
	arg0_14:RemoveListener(IslandAchievementAgency.NEW_CAN_GET, arg0_14.OnNewAchievementCanGet)
	arg0_14:RemoveListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_14.OnFinishDelegation)
	arg0_14:RemoveListener(GAME.ISLAND_UNLOCK_TECH_DONE, arg0_14.OnUnlockTechnology)
	arg0_14:RemoveListener(IslandCharacterAgency.ADD_SHIP, arg0_14.OnAddShip)
	arg0_14:RemoveListener(IslandCharacterAgency.SHIP_LEVEL_UP, arg0_14.OnShipLevelUp)
	arg0_14:RemoveListener(IslandCharacterAgency.SHIP_GET_STATE, arg0_14.OnShipGetState)
	arg0_14:RemoveListener(IslandAblityAgency.UNLOCK_SYSTEM, arg0_14.OnUnlockSystem)
	arg0_14:RemoveListener(IslandVisitorAgency.PLAYER_ADD, arg0_14.OnVisitorNumChange)
	arg0_14:RemoveListener(IslandVisitorAgency.PLAYER_EXIT, arg0_14.OnVisitorNumChange)
	arg0_14:RemoveListener(ISLAND_EX_EVT.ENTER_EDIT_AGORA, arg0_14.OnAgoraEnterEditMode)
	arg0_14:RemoveListener(ISLAND_EX_EVT.EXIT_EDIT_AGORA, arg0_14.OnAgoraExitEditMode)
	arg0_14:RemoveListener(ISLAND_EX_EVT.TRIGGER_TASK, arg0_14.OnTriggerTask)
	arg0_14:RemoveListener(ISLAND_EX_EVT.SUBMIT_TASK, arg0_14.OnSubmitTask)
	arg0_14:RemoveListener(ISLAND_EX_EVT.ADD_TASK_PROGRESS, arg0_14.OnAddTaskProgress)
	arg0_14:RemoveListener(ISLAND_EX_EVT.PLAY_STORY, arg0_14.OnPlayStory)
	arg0_14:RemoveListener(ISLAND_EX_EVT.SWITCH_MAP, arg0_14.OnSwitchMap)
	arg0_14:RemoveListener(ISLAND_EX_EVT.SEEK_GAME_START, arg0_14.OnSeekGameStart)
	arg0_14:RemoveListener(ISLAND_EX_EVT.SEEK_GAME_END, arg0_14.OnSeekGameEnd)
	arg0_14:RemoveListener(ISLAND_EX_EVT.APPROACH_OBJECT, arg0_14.OnApproachObject)
	arg0_14:RemoveListener(ISLAND_EX_EVT.PLAY_PERFORMANCE, arg0_14.OnPlayPerformance)
	arg0_14:RemoveListener(ISLAND_EX_EVT.SHOW_INTERACTION, arg0_14.OnShowInteraction)
	arg0_14:RemoveListener(ISLAND_EX_EVT.SWITCH_MAP_BY_POINT, arg0_14.OnSwitchMapByPoint)
	arg0_14:RemoveListener(ISLAND_EX_EVT.NAV_PATH_DONE, arg0_14.OnNavPathDone)
	arg0_14:RemoveListener(ISLAND_EX_EVT.OPEN_ANIMATION_OP, arg0_14.OnOpenAnimatonOpPage)
	arg0_14:RemoveListener(ISLAND_EX_EVT.CLOSE_ANIMATION_OP, arg0_14.OnCloseAnimatonOpPage)
end

function var0_0.OnOpenAnimatonOpPage(arg0_15)
	arg0_15.btnContainer:ActiveOrDisactive(false)
end

function var0_0.OnCloseAnimatonOpPage(arg0_16)
	arg0_16.btnContainer:ActiveOrDisactive(true)
end

function var0_0.OnNavPathDone(arg0_17, arg1_17)
	if arg1_17 then
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = arg1_17,
			callback = function()
				arg0_17:GetIsland():DispatchEvent(IslandProxy.END_PATHFINDER)
			end
		})
	end
end

function var0_0.OnExpChange(arg0_19)
	arg0_19.levelPanel:ExecuteAction("UpdateIslandInfo")
end

function var0_0.ShowExpAdd(arg0_20, arg1_20, arg2_20)
	arg0_20.levelPanel:ExecuteAction("ShowExpAdd", arg1_20, arg2_20)
end

function var0_0.OnSwitchMapByPoint(arg0_21, arg1_21)
	local var0_21 = arg1_21.mapId

	arg0_21:GetIsland():SetLastExitPosition(arg1_21.mapId, arg1_21.position, arg1_21.rotation)
	arg0_21:emit(IslandBaseMediator.SWITCH_MAP, var0_21)
end

function var0_0.OnShowInteraction(arg0_22, arg1_22)
	IslandGuideChecker.CheckOnShowInteraction(arg1_22)
end

function var0_0.OnPlayPerformance(arg0_23, arg1_23)
	arg0_23:PlayPerformance(arg1_23)
end

function var0_0.OnSeekGameStart(arg0_24)
	arg0_24:TryDisVisible()
end

function var0_0.OnSeekGameEnd(arg0_25)
	arg0_25:TryVisible()
end

function var0_0.OnSwitchMap(arg0_26, arg1_26)
	local var0_26 = pg.island_world_objects[arg1_26].mapId

	arg0_26:emit(IslandBaseMediator.SWITCH_MAP, var0_26, arg1_26)
end

function var0_0.OnPlayStory(arg0_27, arg1_27)
	arg0_27:PlayStory(arg1_27)
end

function var0_0.OnTriggerTask(arg0_28, arg1_28)
	local var0_28 = arg0_28:GetIsland():GetTaskAgency():GetFutureTask(arg1_28)

	if var0_28 and var0_28:IsUnlock() then
		arg0_28:emit(IslandMediator.ON_ACCEPT_TASK, {
			arg1_28
		})
	end
end

function var0_0.OnSubmitTask(arg0_29, arg1_29)
	local var0_29 = arg0_29:GetIsland():GetTaskAgency():GetTask(arg1_29)

	if var0_29 and var0_29:IsFinish() then
		arg0_29:emit(IslandMediator.ON_SUBMIT_TASK, arg1_29)
	end
end

function var0_0.OnAddTaskProgress(arg0_30, arg1_30, arg2_30)
	IslandTaskHelper.UpdateClientTaskProgress(arg1_30, arg2_30)
end

function var0_0.OnApproachObject(arg0_31, arg1_31)
	IslandTaskHelper.OnApproach(arg1_31)
end

function var0_0.OnUpdateTrackTask(arg0_32, arg1_32)
	arg0_32.traceTaskId = arg1_32

	if arg0_32.traceTaskId ~= 0 then
		if not arg0_32.taskTrackPanel:isShowing() then
			arg0_32.taskTrackPanel:ExecuteAction("Show")
		else
			arg0_32.taskTrackPanel:ExecuteAction("UpdateTask")
		end
	end

	arg0_32.btnContainer:OnTrackTaskChange()
end

function var0_0.OnAddedTask(arg0_33, arg1_33)
	arg0_33.btnContainer:OnTrackTaskChange()
end

function var0_0.OnUpdateTask(arg0_34, arg1_34)
	if arg0_34.traceTaskId and arg0_34.traceTaskId ~= arg1_34.id then
		return
	end

	arg0_34.taskTrackPanel:ExecuteAction("UpdateProgress", arg1_34)
	arg0_34.btnContainer:OnTrackTaskChange()
end

function var0_0.OnRemoveTask(arg0_35, arg1_35)
	if arg0_35.traceTaskId and arg0_35.traceTaskId ~= arg1_35.id then
		return
	end

	arg0_35.taskTrackPanel:ExecuteAction("RemoveTask")
	arg0_35.btnContainer:OnTrackTaskChange()
end

function var0_0.UpdateTaskInfo(arg0_36)
	local var0_36 = arg0_36:GetIsland():GetTaskAgency():GetTraceTask()

	if var0_36 then
		arg0_36.traceTaskId = var0_36.id
	end

	if arg0_36.traceTaskId and arg0_36.traceTaskId ~= 0 then
		arg0_36.taskTrackPanel:ExecuteAction("Show")
	else
		arg0_36.taskTrackPanel:ExecuteAction("Hide")
	end

	arg0_36.btnContainer:OnTrackTaskChange()
end

function var0_0.OnSetUpCore(arg0_37, arg1_37, arg2_37)
	arg0_37.approachSpawnPointId = arg2_37
end

function var0_0.OnAgoraEnterEditMode(arg0_38)
	setActive(arg0_38._tf, false)
end

function var0_0.OnAgoraExitEditMode(arg0_39)
	setActive(arg0_39._tf, true)
end

function var0_0.OnShipGetState(arg0_40, arg1_40)
	local var0_40 = arg1_40.ship
	local var1_40 = arg1_40.status
	local var2_40 = var0_40:GetName()

	arg0_40:ShowToast({
		type = IslandToast.TYPE_STATE,
		content = i18n("island_toast_status", var1_40:GetName(), var2_40)
	})
end

function var0_0.OnShipLevelUp(arg0_41, arg1_41)
	local var0_41 = arg1_41:GetName()
	local var1_41 = arg1_41:GetLevel()

	arg0_41:ShowToast({
		content = i18n("island_toast_level", var1_41, var0_41)
	})
end

function var0_0.OnAddShip(arg0_42, arg1_42)
	local var0_42 = arg1_42:GetName()
	local var1_42 = arg0_42:GetIsland():GetName()

	arg0_42:ShowToast({
		content = i18n("island_toast_ship", var1_42, var0_42)
	})
end

function var0_0.OnNewAchievementCanGet(arg0_43, arg1_43)
	arg0_43:ShowToast({
		content = i18n("island_achv_finish_tip", arg1_43:getConfig("name"))
	})
end

function var0_0.OnFinishDelegation(arg0_44)
	arg0_44.btnContainer:OnFinishDelegation()
end

function var0_0.OnUnlockTechnology(arg0_45)
	arg0_45.btnContainer:OnUnlockTechnology()
end

function var0_0.OnUpgrade(arg0_46, arg1_46)
	arg0_46.levelPanel:ExecuteAction("UpdateTip")
	arg0_46.levelPanel:ExecuteAction("UpdateIslandInfo")
	arg0_46:OpenPage(IslandUpgradeDisplayPage, arg1_46.dropData.abilitys, arg1_46.callback)
	IslandGuideChecker.CheckGuide("ISLAND_GUIDE_5")
end

function var0_0.OnModifyName(arg0_47)
	arg0_47.levelPanel:ExecuteAction("UpdateIslandInfo")
end

function var0_0.OnGetProsperityAward(arg0_48)
	arg0_48.levelPanel:ExecuteAction("UpdateTip")
end

function var0_0.OnUnlockSystem(arg0_49, arg1_49)
	arg0_49.btnContainer:OnUnlockSystem(arg1_49)
	switch(arg1_49, {
		[pg.island_set.main_page_function_unlock.key_value_varchar[1]] = function()
			arg0_49.levelPanel:ExecuteAction("Show")
		end,
		[pg.island_set.main_page_function_unlock.key_value_varchar[2]] = function()
			arg0_49.unlockTask = true

			arg0_49.taskTrackPanel:ExecuteAction("SetUnlock")
			arg0_49:UpdateTaskInfo()
		end,
		[pg.island_set.main_page_function_unlock.key_value_varchar[3]] = function()
			setActive(arg0_49.visitorBtn, true)
			arg0_49:UpdateVisitorBtn()
		end
	}, function()
		return
	end)
end

function var0_0.OnVisitorNumChange(arg0_54)
	arg0_54:UpdateVisitorBtn()
end

function var0_0.OnSceneLoaded(arg0_55)
	arg0_55:HandleAwardDisplay({})
	var0_0.super.OnSceneLoaded(arg0_55)

	local var0_55 = arg0_55:GetIsland():GetAblityAgency()

	if var0_55:HasAbility(pg.island_set.main_page_function_unlock.key_value_varchar[1]) then
		arg0_55.levelPanel:ExecuteAction("Show")
	end

	arg0_55.unlockTask = var0_55:HasAbility(pg.island_set.main_page_function_unlock.key_value_varchar[2])

	if arg0_55.unlockTask then
		arg0_55:UpdateTaskInfo()
	end

	local var1_55 = var0_55:HasAbility(pg.island_set.main_page_function_unlock.key_value_varchar[3])

	setActive(arg0_55.visitorBtn, var1_55)

	if var1_55 then
		arg0_55:UpdateVisitorBtn()
	end

	if arg0_55.approachSpawnPointId then
		arg0_55:OnApproachObject(arg0_55.approachSpawnPointId)

		arg0_55.approachSpawnPointId = nil
	end

	arg0_55:SequenceCheck()
end

function var0_0.SequenceCheck(arg0_56)
	seriesAsync({
		function(arg0_57)
			if pg.NewStoryMgr.GetInstance():IsPlayed("ISLAND1001000") then
				arg0_57()
			else
				pg.NewStoryMgr.GetInstance():Play("ISLAND1001000", arg0_57)
			end
		end,
		function(arg0_58)
			if pg.NewStoryMgr.GetInstance():IsPlayed("ISLAND1001001_1") then
				arg0_58()
			else
				arg0_56:PlayPerformance({
					name = "ISLANDPERFORMANCE1",
					callback = arg0_58
				})
			end
		end,
		function(arg0_59)
			if arg0_56:GetIsland():GetSeasonAgency():NeedReset() then
				arg0_56:emit(IslandMediator.ON_RESET_SEASON, arg0_59)
			else
				arg0_59()
			end
		end,
		function(arg0_60)
			local var0_60, var1_60, var2_60 = arg0_56:GetIsland():GetSeasonAgency():IsShowResetTip()

			if var0_60 then
				local var3_60 = var1_60 > 0 and i18n("island_season_window_end2", var1_60) or i18n("island_season_window_end")

				arg0_56:ShowMsgbox({
					hideNo = true,
					type = IslandMsgBox.TYPE_SEASON_TIP,
					tipTitle = var3_60,
					content = i18n("island_season_window_rule"),
					onHide = function()
						arg0_56:GetIsland():GetSeasonAgency():SetResetTipFlag(var1_60)
						arg0_60()
					end
				})
			else
				arg0_60()
			end
		end,
		function(arg0_62)
			arg0_56:GetIsland():GetTaskAgency():TrySubmitAutoTasks(arg0_62)
		end,
		function(arg0_63)
			arg0_56:GetIsland():GetTaskAgency():TryAcceptAutoTasks(arg0_63)
		end
	}, function()
		IslandGuideChecker.CheckOnLoaded(arg0_56:GetIsland():GetMapId())
	end)
end

function var0_0.UpdateVisitorBtn(arg0_65)
	setText(arg0_65.visitorBtn:Find("num"), arg0_65:GetIsland():GetVisitorAgency():GetVisitorCnt())
end

function var0_0.UpdateMainAwardReward(arg0_66, arg1_66)
	arg0_66.awardDisplayPanel:ExecuteAction("ShowAwards", arg1_66)
end

function var0_0.OnUnloadScene(arg0_67)
	return
end

function var0_0.OnVisible(arg0_68)
	arg0_68:UpdateTaskInfo()
	arg0_68.btnContainer:Flush()

	if not arg0_68:GetSubView(IslandStoryMgr):IsRunning() and not arg0_68.poppingQueue:AnyPlayerIsRunning() then
		IslandGuideChecker.CheckOnLoaded(arg0_68:GetIsland():GetMapId())
	end
end

function var0_0.willExit(arg0_69)
	if arg0_69.btnContainer then
		arg0_69.btnContainer:Dispose()

		arg0_69.btnContainer = nil
	end

	if arg0_69.levelPanel then
		arg0_69.levelPanel:Destroy()

		arg0_69.levelPanel = nil
	end

	if arg0_69.taskTrackPanel then
		arg0_69.taskTrackPanel:Destroy()

		arg0_69.taskTrackPanel = nil
	end

	if arg0_69.awardDisplayPanel then
		arg0_69.awardDisplayPanel:Destroy()

		arg0_69.awardDisplayPanel = nil
	end
end

return var0_0
