local var0_0 = class("IslandScene", import(".base.IslandBaseScene"))

var0_0.ON_INVENTORY_FILTER = "IslandScene:ON_INVENTORY_FILTER"
var0_0.ON_CHECK_ORDER_EXP_AWARD = "IslandScene:ON_CHECK_ORDER_EXP_AWARD"

function var0_0.getUIName(arg0_1)
	return "IslandUI"
end

function var0_0.GetIsland(arg0_2)
	return getProxy(IslandProxy):GetIsland()
end

function var0_0.init(arg0_3)
	arg0_3.technologyBtn = arg0_3:findTF("bottom/list/technology")
	arg0_3.friendBtn = arg0_3:findTF("bottom/list/friend")
	arg0_3.visitorBtn = arg0_3:findTF("bottom/list/visitor")
	arg0_3.dressBtn = arg0_3:findTF("bottom/list/skin")
	arg0_3.delegationBtn = arg0_3:findTF("bottom/list/delegation")
	arg0_3.btnContainer = arg0_3:findTF("top/list")
	arg0_3.btnUIList = UIItemList.New(arg0_3.btnContainer, arg0_3.btnContainer:Find("tpl"))
	arg0_3.levelPanel = arg0_3:findTF("top/level_panel")
	arg0_3.levelTxt = arg0_3:findTF("top/level_panel/level"):GetComponent(typeof(Text))
	arg0_3.expTr = arg0_3:findTF("top/level_panel/exp")
	arg0_3.nameTxt = arg0_3:findTF("top/level_panel/name"):GetComponent(typeof(Text))
	arg0_3.prosperityTxt = arg0_3:findTF("top/level_panel/prosperity/Text"):GetComponent(typeof(Text))
	arg0_3.prosperityLabel = arg0_3:findTF("top/level_panel/prosperity"):GetComponent(typeof(Text))
	arg0_3.levelTip = arg0_3.levelPanel:Find("red_dot")
	arg0_3.taskTrackPanel = Island3dTaskTrackPanel.New(arg0_3._tf, arg0_3.event, setmetatable({
		onClick = function()
			arg0_3:OpenPage(Island3dTaskPage, arg0_3:GetIsland():GetTaskAgency():GetTraceId())
		end
	}, {
		__index = arg0_3.contextData
	}))
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5.levelPanel, function()
		arg0_5:OpenPage(IslandInfoPage)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.technologyBtn, function()
		arg0_5:OpenPage(IslandTechnologyPage)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.friendBtn, function()
		arg0_5:emit(IslandMediator.OPEN_FRIEND)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.visitorBtn, function()
		arg0_5:OpenPage(IslandVisitorPage)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.dressBtn, function()
		arg0_5:OpenPage(IslandShipIslandCommanderMainPage)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.delegationBtn, function()
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.ROLEDELEGATION_CAMERA_NAME)
		_IslandCore:GetController():NotifiyCore(ISLAND_EVT.INTERACTION_UNIT_BEGIN)
		arg0_5:OpenPage(IslandRoleDelegationPage)
	end, SFX_PANEL)
	arg0_5.btnUIList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = arg0_5.btnList[arg1_12 + 1]
			local var1_12 = pg.island_main_btns[var0_12]

			arg2_12.name = var1_12.btn_name

			LoadImageSpriteAsync("islandbtnicon/" .. var1_12.icon, arg2_12, true)

			if var1_12.open_page ~= "" then
				onButton(arg0_5, arg2_12, function()
					arg0_5:OpenPage(_G[var1_12.open_page], unpack(var1_12.page_param))
				end, SFX_PANEL)
			end
		end
	end)
	arg0_5:SetUp()
end

function var0_0.SetUp(arg0_14)
	seriesAsync({
		function(arg0_15)
			arg0_14:SetNameIfIsEmpty(arg0_15)
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

function var0_0.UpdateTip(arg0_19)
	setActive(arg0_19.levelTip, getProxy(IslandProxy):ShouldTip())
end

function var0_0.UpdateIslandInfo(arg0_20)
	local var0_20 = arg0_20:GetIsland()

	arg0_20.levelTxt.text = var0_20:GetLevel()
	arg0_20.nameTxt.text = var0_20:GetName()

	if var0_20:IsMaxLevel() then
		setFillAmount(arg0_20.expTr, 1)
	else
		setFillAmount(arg0_20.expTr, var0_20:GetExp() / var0_20:GetTargeExp())
	end

	if var0_20:CanAddProsperity() then
		arg0_20.prosperityTxt.text = var0_20:GetProsperity() .. "/" .. var0_20:GetTargetProsperity()
	else
		arg0_20.prosperityTxt.text = "MAX"
	end

	arg0_20.prosperityLabel.text = i18n1("繁荣度")
end

function var0_0.AddListeners(arg0_21)
	arg0_21:AddListener(GAME.ISLAND_UPGRADE_DONE, arg0_21.OnUpgrade)
	arg0_21:AddListener(GAME.ISLAND_SET_NAME_DONE, arg0_21.OnModifyName)
	arg0_21:AddListener(GAME.ISLAND_PROSPERITY_AWARD_DONE, arg0_21.OnGetProsperityAward)
	arg0_21:AddListener(IslandTaskAgency.TASK_ADDED, arg0_21.OnUpdateTask)
	arg0_21:AddListener(IslandTaskAgency.TASK_UPDATED, arg0_21.OnUpdateTask)
	arg0_21:AddListener(IslandTaskAgency.TASK_REMOVED, arg0_21.OnUpdateTask)
	arg0_21:AddListener(IslandCharacterAgency.ADD_SHIP, arg0_21.OnAddShip)
	arg0_21:AddListener(IslandCharacterAgency.SHIP_LEVEL_UP, arg0_21.OnShipLevelUp)
	arg0_21:AddListener(IslandCharacterAgency.SHIP_GET_STATE, arg0_21.OnShipGetState)
	arg0_21:AddListener(IslandAblityAgency.UNLCOK_SYSTEM, arg0_21.OnUnlockSystem)
	arg0_21:AddListener(ISLAND_EX_EVT.INIT_FINISH, arg0_21.OnSceneLoaded)
	arg0_21:AddListener(ISLAND_EX_EVT.SAVE_AGORA, arg0_21.OnAgoraSave)
	arg0_21:AddListener(ISLAND_EX_EVT.UPGRADE_AGORA, arg0_21.OnAgoraUpgrade)
	arg0_21:AddListener(ISLAND_EX_EVT.ENTER_EDIT_AGORA, arg0_21.OnAgoraEnterEditMode)
	arg0_21:AddListener(ISLAND_EX_EVT.EXIT_EDIT_AGORA, arg0_21.OnAgoraExitEditMode)
	arg0_21:AddListener(ISLAND_EX_EVT.OPEN_PAGE, arg0_21.OnOpenPage)
	arg0_21:AddListener(ISLAND_EX_EVT.TRIGGER_TASK, arg0_21.OnTriggerTask)
	arg0_21:AddListener(ISLAND_EX_EVT.SUBMIT_TASK, arg0_21.OnSubmitTask)
	arg0_21:AddListener(ISLAND_EX_EVT.ADD_TASK_PROGRESS, arg0_21.OnAddTaskProgress)
	arg0_21:AddListener(ISLAND_EX_EVT.PLAY_STORY, arg0_21.OnPlayStory)
	arg0_21:AddListener(ISLAND_EX_EVT.SWITCH_MAP, arg0_21.OnSwitchMap)
	arg0_21:AddListener(ISLAND_EX_EVT.SEEK_GAME_START, arg0_21.OnSeekGameStart)
	arg0_21:AddListener(ISLAND_EX_EVT.SEEK_GAME_END, arg0_21.OnSeekGameEnd)
end

function var0_0.RemoveListeners(arg0_22)
	arg0_22:RemoveListener(GAME.ISLAND_UPGRADE_DONE, arg0_22.OnUpgrade)
	arg0_22:RemoveListener(GAME.ISLAND_SET_NAME_DONE, arg0_22.OnModifyName)
	arg0_22:RemoveListener(GAME.ISLAND_PROSPERITY_AWARD_DONE, arg0_22.OnGetProsperityAward)
	arg0_22:RemoveListener(IslandTaskAgency.TASK_ADDED, arg0_22.OnUpdateTask)
	arg0_22:RemoveListener(IslandTaskAgency.TASK_UPDATED, arg0_22.OnUpdateTask)
	arg0_22:RemoveListener(IslandTaskAgency.TASK_REMOVED, arg0_22.OnUpdateTask)
	arg0_22:RemoveListener(IslandCharacterAgency.ADD_SHIP, arg0_22.OnAddShip)
	arg0_22:RemoveListener(IslandCharacterAgency.SHIP_LEVEL_UP, arg0_22.OnShipLevelUp)
	arg0_22:RemoveListener(IslandCharacterAgency.SHIP_GET_STATE, arg0_22.OnShipGetState)
	arg0_22:RemoveListener(IslandAblityAgency.UNLCOK_SYSTEM, arg0_22.OnUnlockSystem)
	arg0_22:RemoveListener(ISLAND_EX_EVT.INIT_FINISH, arg0_22.OnSceneLoaded)
	arg0_22:RemoveListener(ISLAND_EX_EVT.SAVE_AGORA, arg0_22.OnAgoraSave)
	arg0_22:RemoveListener(ISLAND_EX_EVT.UPGRADE_AGORA, arg0_22.OnAgoraUpgrade)
	arg0_22:RemoveListener(ISLAND_EX_EVT.ENTER_EDIT_AGORA, arg0_22.OnAgoraEnterEditMode)
	arg0_22:RemoveListener(ISLAND_EX_EVT.EXIT_EDIT_AGORA, arg0_22.OnAgoraExitEditMode)
	arg0_22:RemoveListener(ISLAND_EX_EVT.OPEN_PAGE, arg0_22.OnOpenPage)
	arg0_22:RemoveListener(ISLAND_EX_EVT.TRIGGER_TASK, arg0_22.OnTriggerTask)
	arg0_22:RemoveListener(ISLAND_EX_EVT.SUBMIT_TASK, arg0_22.OnSubmitTask)
	arg0_22:RemoveListener(ISLAND_EX_EVT.ADD_TASK_PROGRESS, arg0_22.OnAddTaskProgress)
	arg0_22:RemoveListener(ISLAND_EX_EVT.PLAY_STORY, arg0_22.OnPlayStory)
	arg0_22:RemoveListener(ISLAND_EX_EVT.SWITCH_MAP, arg0_22.OnSwitchMap)
	arg0_22:RemoveListener(ISLAND_EX_EVT.SEEK_GAME_START, arg0_22.OnSeekGameStart)
	arg0_22:RemoveListener(ISLAND_EX_EVT.SEEK_GAME_END, arg0_22.OnSeekGameEnd)
end

function var0_0.OnSeekGameStart(arg0_23)
	setActive(arg0_23._tf, false)
end

function var0_0.OnSeekGameEnd(arg0_24)
	setActive(arg0_24._tf, true)
end

function var0_0.OnSwitchMap(arg0_25, arg1_25)
	local var0_25 = pg.island_world_objects[arg1_25].mapId

	arg0_25:emit(IslandMediator.SWITCH_MAP, var0_25, arg1_25)
end

function var0_0.OnPlayStory(arg0_26, arg1_26)
	arg0_26:PlayStory(arg1_26)
end

function var0_0.OnTriggerTask(arg0_27, arg1_27)
	local var0_27 = arg0_27:GetIsland():GetTaskAgency():GetFutureTask(arg1_27)

	if var0_27 and var0_27:IsUnlock() then
		arg0_27:emit(IslandMediator.ON_ACCEPT_TASK, {
			taskIds = {
				arg1_27
			}
		})
	end
end

function var0_0.OnSubmitTask(arg0_28, arg1_28)
	local var0_28 = arg0_28:GetIsland():GetTaskAgency():GetTask(arg1_28)

	if var0_28 and var0_28:IsFinish() then
		arg0_28:emit(IslandMediator.ON_SUBMIT_TASK, arg1_28)
	end
end

function var0_0.OnAddTaskProgress(arg0_29, arg1_29, arg2_29)
	for iter0_29, iter1_29 in pairs(arg0_29:GetIsland():GetTaskAgency():GetTasks()) do
		local var0_29 = false
		local var1_29

		if arg1_29 == 1 then
			var0_29, var1_29 = iter1_29:ExistApproachTarget(arg2_29)
		elseif arg1_29 == 2 then
			var0_29, var1_29 = iter1_29:ExistInteractionTarget(arg2_29)
		end

		if var0_29 then
			arg0_29:emit(IslandMediator.ON_CLIENT_UPDATE_TASK, {
				taskId = 0,
				progress = 1,
				targetId = var1_29.id
			})

			return
		end
	end
end

function var0_0.OnOpenPage(arg0_30, arg1_30, ...)
	arg0_30:OpenPage(arg1_30, ...)
end

function var0_0.OnAgoraEnterEditMode(arg0_31)
	setActive(arg0_31._tf, false)
end

function var0_0.OnAgoraExitEditMode(arg0_32)
	setActive(arg0_32._tf, true)
end

function var0_0.OnAgoraSave(arg0_33, arg1_33)
	arg0_33:emit(IslandMediator.SAVE_AGORA, arg1_33)
end

function var0_0.OnAgoraUpgrade(arg0_34)
	arg0_34:emit(IslandMediator.UPGRADE_AGORA)
end

function var0_0.OnShipGetState(arg0_35, arg1_35)
	local var0_35 = arg1_35.ship
	local var1_35 = arg1_35.status
	local var2_35 = var0_35:GetName()

	arg0_35:ShowToast({
		type = IslandToast.TYPE_STATE,
		content = var2_35 .. i18n1("获得状态\n[") .. var1_35:GetName() .. "]"
	})
end

function var0_0.OnShipLevelUp(arg0_36, arg1_36)
	local var0_36 = arg1_36:GetName()
	local var1_36 = arg1_36:GetLevel()

	arg0_36:ShowToast({
		content = var0_36 .. i18n1("提升至等级") .. var1_36
	})
end

function var0_0.OnAddShip(arg0_37, arg1_37)
	local var0_37 = arg1_37:GetName()
	local var1_37 = arg0_37:GetIsland():GetName()

	arg0_37:ShowToast({
		content = var0_37 .. i18n1("正式加入") .. var1_37
	})
end

function var0_0.OnUpgrade(arg0_38, arg1_38)
	arg0_38:UpdateTip()
	arg0_38:UpdateIslandInfo()
	arg0_38:OpenPage(IslandUpgradeDisplayPage, arg1_38.awards)
end

function var0_0.OnModifyName(arg0_39)
	arg0_39:UpdateIslandInfo()
end

function var0_0.OnGetProsperityAward(arg0_40)
	arg0_40:UpdateTip()
end

function var0_0.OnUnlockSystem(arg0_41, arg1_41)
	if underscore.any(pg.island_main_btns.get_id_list_by_main_type[1], function(arg0_42)
		return pg.island_main_btns[arg0_42].ability_id == arg0_42
	end) then
		arg0_41:UpdateBtnList()
	end
end

function var0_0.OnSceneLoaded(arg0_43)
	arg0_43:UpdateTip()
	arg0_43:UpdateIslandInfo()
	arg0_43:UpdateTaskInfo()
	arg0_43:UpdateBtnList()
end

function var0_0.UpdateBtnList(arg0_44)
	local var0_44 = arg0_44:GetIsland():GetAblityAgency()

	arg0_44.btnList = underscore.select(pg.island_main_btns.get_id_list_by_main_type[1], function(arg0_45)
		local var0_45 = pg.island_main_btns[arg0_45].ability_id

		return var0_45 == 0 or var0_44:HasAbility(var0_45)
	end)

	arg0_44.btnUIList:align(#arg0_44.btnList)
end

function var0_0.UpdateTaskInfo(arg0_46)
	arg0_46.taskTrackPanel:ExecuteAction("Show")
	arg0_46:UpdateTrackBtnUI()
end

function var0_0.OnUpdateTrackTask(arg0_47, arg1_47)
	arg0_47.taskTrackPanel:ExecuteAction("UpdateTrackTask", arg1_47)
	arg0_47:UpdateTrackBtnUI()
end

function var0_0.OnUpdateTask(arg0_48, arg1_48)
	arg0_48.taskTrackPanel:ExecuteAction("UpdateTask", arg1_48)
	arg0_48:UpdateTrackBtnUI()
end

function var0_0.UpdateTrackBtnUI(arg0_49)
	local var0_49 = arg0_49:GetIsland():GetTaskAgency():GetTraceTask()

	eachChild(arg0_49.btnContainer, function(arg0_50)
		local var0_50 = arg0_50:Find("track")

		if var0_50 then
			if var0_49 then
				local var1_50 = var0_49:GetTraceParam()

				setActive(var0_50, arg0_50.name == var1_50)

				if arg0_50.name == "map" then
					local var2_50 = tonumber(var1_50)

					if var2_50 and arg0_49:GetIsland():GetMapId() ~= pg.island_world_objects[var2_50].mapId then
						setActive(var0_50, true)
					end
				end
			else
				setActive(var0_50, false)
			end
		end
	end)
end

function var0_0.OnUnloadScene(arg0_51)
	return
end

function var0_0.willExit(arg0_52)
	if arg0_52.taskTrackPanel then
		arg0_52.taskTrackPanel:Destroy()

		arg0_52.taskTrackPanel = nil
	end
end

return var0_0
