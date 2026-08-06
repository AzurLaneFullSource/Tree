local var0_0 = class("IslandAniamtionOpView", import(".IslandBaseOpView"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3

function var0_0.GetUIName(arg0_1)
	return "IslandActionOpUI"
end

function var0_0.GetEnterAnimationName(arg0_2)
	return "Anim_IslandActionOpUI_In"
end

function var0_0.GetExitAnimationName(arg0_3)
	return "Anim_IslandActionOpUI_Out"
end

function var0_0.GetUIParent(arg0_4, arg1_4)
	return arg0_4:GetView().topContainer
end

function var0_0.FirstFlush(arg0_5)
	arg0_5.waitTime = pg.island_set.action_waiting_time.key_value_int
	arg0_5.scrollrect = arg0_5._tf:Find("adapt/frame/scrollrect"):GetComponent("LScrollRect")
	arg0_5.opPanel = arg0_5._tf:Find("adapt/opPanel")
	arg0_5.lookParent = arg0_5.opPanel.parent
	arg0_5.moveBtn = arg0_5.opPanel:Find("move")
	arg0_5.lookBtn = arg0_5.opPanel:Find("look")
	arg0_5.moveBtnCg = GetOrAddComponent(arg0_5.moveBtn, typeof(CanvasGroup))

	function arg0_5.scrollrect.onInitItem(arg0_6)
		arg0_5:OnInitItem(arg0_6)
	end

	function arg0_5.scrollrect.onUpdateItem(arg0_7, arg1_7)
		arg0_5:OnUpdateItem(arg0_7, arg1_7)
	end

	onNextTick(function()
		arg0_5:TryDisable(false)
	end)

	arg0_5.chatView = IslandChatView.New(arg0_5:GetView(), arg0_5._tf:Find("adapt/chat"))

	onButton(arg0_5, arg0_5._go, function()
		arg0_5:TryDisable()
	end, SFX_PANEL)
	onToggle(arg0_5, arg0_5._tf:Find("adapt/tags/1"), function(arg0_10)
		if arg0_10 then
			arg0_5:SwitchPage(var1_0)
		end
	end, SFX_PANEL)
	onToggle(arg0_5, arg0_5._tf:Find("adapt/tags/2"), function(arg0_11)
		if arg0_11 then
			arg0_5:SwitchPage(var2_0)
		end
	end, SFX_PANEL)
	onToggle(arg0_5, arg0_5._tf:Find("adapt/tags/3"), function(arg0_12)
		if arg0_12 then
			arg0_5:SwitchPage(var3_0)
		end
	end, SFX_PANEL)

	arg0_5.cards = {}
	arg0_5.isShowing = false
	arg0_5.isInitList = false
	arg0_5.page = var1_0
end

function var0_0.SwitchPage(arg0_13, arg1_13)
	arg0_13.page = arg1_13

	if arg1_13 == var1_0 then
		arg0_13:InitList()

		arg0_13.lookBtn.offsetMax = Vector2(-594, arg0_13.lookBtn.offsetMax.y)
	elseif arg1_13 == var2_0 then
		arg0_13:InitList()

		arg0_13.lookBtn.offsetMax = Vector2(-594, arg0_13.lookBtn.offsetMax.y)
	elseif arg1_13 == var3_0 then
		arg0_13.chatView:Execute("Show", true)

		arg0_13.lookBtn.offsetMax = Vector2(-985, arg0_13.lookBtn.offsetMax.y)
	end
end

function var0_0.UpdateMoveBtn(arg0_14)
	local var0_14 = tf(GameObject.Find("UICamera/Canvas")).sizeDelta
	local var1_14 = var0_14.x / IslandSettingsConst.settingRectSize.x
	local var2_14 = var0_14.y / IslandSettingsConst.settingRectSize.y
	local var3_14 = IslandSettingsConst.ISLAND_JOY_STICK_DEFAULT_PREFERENCE
	local var4_14 = PlayerPrefs.GetFloat(IslandSettingsConst.ISLAND_KEY_JOYSTICK_ANCHORX, var3_14.x)
	local var5_14 = PlayerPrefs.GetFloat(IslandSettingsConst.ISLAND_KEY_JOYSTICK_ANCHORY, var3_14.y)

	arg0_14.moveBtn.anchoredPosition = Vector2(var4_14 * var1_14, var5_14 * var2_14)
end

function var0_0.OnStartCoupleAction(arg0_15)
	arg0_15.moveBtnCg.alpha = 0
	arg0_15.moveBtnCg.blocksRaycasts = false
end

function var0_0.OnEndCoupleAction(arg0_16)
	arg0_16.moveBtnCg.alpha = 1
	arg0_16.moveBtnCg.blocksRaycasts = true
end

function var0_0.UpdateChatRoom(arg0_17)
	if not arg0_17.isShowing then
		return
	end

	if not arg0_17.chatView:IsLoaded() then
		return
	end

	arg0_17.chatView:Execute("Flush")
end

function var0_0.UpdateMsgList(arg0_18)
	if not arg0_18.isShowing then
		return
	end

	if not arg0_18.chatView:IsLoaded() then
		return
	end

	arg0_18.chatView:Execute("Flush", true)
end

function var0_0.OnMovePlayerBefore(arg0_19)
	if not arg0_19.isShowing then
		return
	end

	arg0_19:RemoveWaitTimer()

	arg0_19.startSingleActionId = nil

	arg0_19:ClearSelected()
end

function var0_0.OnEnable(arg0_20)
	arg0_20:InitList()
	arg0_20:UpdateMoveBtn()

	arg0_20.isShowing = true

	setParent(arg0_20.opPanel, arg0_20:GetView().layer2UIContianer)
end

function var0_0.GetData(arg0_21)
	local var0_21 = {}
	local var1_21 = {}
	local var2_21 = getProxy(IslandProxy):GetIsland():GetActionAgency():GetActionList()

	for iter0_21, iter1_21 in ipairs(var2_21) do
		local var3_21 = pg.island_action[iter1_21]

		if var3_21.type == IslandConst.ANIMATION_OP_SIGNLE then
			table.insert(var0_21, iter1_21)
		elseif var3_21.type == IslandConst.ANIMATION_OP_DOUBLE then
			table.insert(var1_21, iter1_21)
		end
	end

	if arg0_21.markActionId then
		table.sort(var0_21, function(arg0_22, arg1_22)
			local var0_22 = arg0_22 == arg0_21.markActionId and 1 or 0
			local var1_22 = arg1_22 == arg0_21.markActionId and 1 or 0

			if var0_22 == var1_22 then
				return arg0_22 < arg1_22
			else
				return var1_22 < var0_22
			end
		end)
	end

	return var0_21, var1_21
end

local function var4_0(arg0_23)
	local var0_23 = {}

	for iter0_23 = 1, #arg0_23, 2 do
		local var1_23 = arg0_23[iter0_23]
		local var2_23 = arg0_23[iter0_23 + 1]

		table.insert(var0_23, {
			var1_23,
			var2_23
		})
	end

	return var0_23
end

function var0_0.InitList(arg0_24)
	local var0_24, var1_24 = arg0_24:GetData()
	local var2_24 = {}

	if arg0_24.page == var1_0 then
		local var3_24 = var4_0(var0_24)

		for iter0_24, iter1_24 in ipairs(var3_24) do
			table.insert(var2_24, iter1_24)
		end
	end

	if arg0_24.page == var2_0 then
		local var4_24 = var4_0(var1_24)

		for iter2_24, iter3_24 in ipairs(var4_24) do
			table.insert(var2_24, iter3_24)
		end
	end

	arg0_24.displays = var2_24
	arg0_24.scrollrect.enabled = true

	arg0_24.scrollrect:SetTotalCount(#var2_24, 0)

	arg0_24.isInitList = true
end

function var0_0.SortForNpcAction(arg0_25, arg1_25)
	if not arg1_25 then
		arg0_25.markActionId = nil

		arg0_25:InitList()

		return
	end

	local var0_25, var1_25 = IslandCalcUtil.GetTypeAndIdByUniqueId(arg1_25)
	local var2_25 = arg0_25:GetView():GetUnitModuleWithType(var0_25, var1_25)

	if not var2_25 then
		return
	end

	if not var2_25.data or not isa(var2_25.data, IslandStrollUnitVO) then
		return
	end

	local var3_25 = var2_25.data:GetGreetingFeedback()

	if not var3_25 then
		return
	end

	arg0_25.markActionId = var3_25

	arg0_25:InitList()
end

function var0_0.OnInitItem(arg0_26, arg1_26)
	local var0_26 = IslandAniamtionOpCard.New(arg1_26)

	onButton(arg0_26, var0_26.item1, function()
		arg0_26.selectedId = var0_26.firstId

		arg0_26:UpdateCardsSelected()
		arg0_26:PlayAniamtion(var0_26.firstId)
	end, SFX_PANEL)
	onButton(arg0_26, var0_26.item2, function()
		arg0_26.selectedId = var0_26.secondId

		arg0_26:UpdateCardsSelected()
		arg0_26:PlayAniamtion(var0_26.secondId)
	end, SFX_PANEL)

	arg0_26.cards[arg1_26] = var0_26
end

function var0_0.CanPlayCoupleAction(arg0_29, arg1_29)
	local var0_29 = arg0_29:GetPlayerUnit()
	local var1_29 = BuildVector3(arg1_29.respond_point).magnitude

	return IslandCalcUtil.IsCircleInsideNavMesh(var0_29.agent, var0_29._tf.position, var1_29, 12)
end

function var0_0.PlayAniamtion(arg0_30, arg1_30)
	if not arg1_30 then
		return
	end

	local var0_30 = pg.island_action[arg1_30]

	if var0_30.type == IslandConst.ANIMATION_OP_DOUBLE then
		if arg0_30.startCoupleActionId == arg1_30 then
			return
		end

		if not arg0_30:CanPlayCoupleAction(var0_30) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_position_cant_play_cp_action"))

			return
		end

		arg0_30:NotifiyCore(ISLAND_EVT.LOCK_PLAYER_INPUT)

		arg0_30.startSingleActionId = nil

		arg0_30:AddWaitTimer(arg1_30)
		arg0_30:GetPlayerUnit():PlayAnimation(var0_30.resource, 0.25, function()
			if not arg0_30.startCoupleActionId then
				return
			end

			if arg0_30:HasFollowerAndNoVisitorAround() then
				arg0_30:NotifiyCore(ISLAND_EVT.COUPLE_ACTION_WITH_FOLLOWER, arg0_30.startCoupleActionId)
			else
				arg0_30.isWaitingCoupleAction = true

				arg0_30:NotifiyMeditor(IslandBaseMediator.ANIMATION_OP, 0, arg0_30.startCoupleActionId)
			end
		end)
		arg0_30:ApplyEffect(arg1_30)
	elseif var0_30.type == IslandConst.ANIMATION_OP_SIGNLE then
		if arg0_30.startSingleActionId == arg1_30 then
			return
		end

		arg0_30:NotifiyCore(ISLAND_EVT.LOCK_PLAYER_INPUT)

		arg0_30.startSingleActionId = arg1_30

		arg0_30:RemoveWaitTimer()
		arg0_30:GetPlayerUnit():PlayAnimation(var0_30.resource, 0.25, function()
			arg0_30.startSingleActionId = nil

			IslandTaskHelper.OnActionEnd(var0_30.id)
			arg0_30:NotifiyCore(ISLAND_EVT.PLAY_SIGNLE_ANIMATION_END, var0_30.id)
			arg0_30:ClearSelected()
		end)
	end
end

function var0_0.ClearSelected(arg0_33, ...)
	arg0_33.selectedId = nil

	arg0_33:UpdateCardsSelected()
end

function var0_0.HasFollowerAndNoVisitorAround(arg0_34)
	local var0_34 = pg.island_set.action_bubble_range.key_value_int
	local var1_34 = arg0_34:GetView()
	local var2_34 = var1_34:GetPlayerPosition()
	local var3_34 = var1_34:GetUnitListByKey(IslandConst.UNIT_LIST_PLAYER)
	local var4_34 = _.any(var3_34, function(arg0_35)
		return arg0_35 ~= var1_34.player and Vector3.Distance(arg0_35:GetPosition(), var2_34) <= var0_34
	end)
	local var5_34 = var1_34:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)
	local var6_34 = _.any(var3_34, function(arg0_36)
		return Vector3.Distance(arg0_36:GetPosition(), var2_34) <= var0_34
	end)

	return not var4_34 and var6_34
end

function var0_0.ApplyEffect(arg0_37, arg1_37)
	arg0_37:CancelEffect()

	local var0_37 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_37 = pg.TimeMgr.GetInstance():GetServerTime() + arg0_37.waitTime

	arg0_37.loadingData = {
		id = arg1_37,
		startTime = var0_37,
		endTime = var1_37
	}

	for iter0_37, iter1_37 in pairs(arg0_37.cards) do
		if iter1_37:Contains(arg1_37) then
			iter1_37:LoadingEffect(arg0_37.loadingData)

			break
		end
	end
end

function var0_0.CancelEffect(arg0_38)
	if arg0_38.loadingData then
		local var0_38 = arg0_38.loadingData.id

		arg0_38.loadingData = nil

		for iter0_38, iter1_38 in pairs(arg0_38.cards) do
			if iter1_38:Contains(var0_38) then
				iter1_38:ClearLoadingEffect()

				break
			end
		end
	end
end

function var0_0.AddWaitTimer(arg0_39, arg1_39)
	arg0_39:RemoveWaitTimer()

	arg0_39.startCoupleActionId = arg1_39
	arg0_39.timer = Timer.New(function()
		arg0_39:RemoveWaitTimer()
		arg0_39:ClearSelected()
	end, arg0_39.waitTime, 1)

	arg0_39.timer:Start()
end

function var0_0.RemoveWaitTimer(arg0_41, arg1_41)
	arg1_41 = defaultValue(arg1_41, true)

	if not arg1_41 then
		arg0_41:ClearSelected()
	end

	arg0_41:CancelEffect()

	if arg0_41.timer then
		arg0_41.timer:Stop()

		arg0_41.timer = nil
	end

	if arg0_41.startCoupleActionId then
		if arg1_41 then
			arg0_41:GetPlayerUnit():CheckMovement()
		end

		arg0_41.startCoupleActionId = nil
	end

	if arg0_41.isWaitingCoupleAction then
		arg0_41.isWaitingCoupleAction = false

		arg0_41:NotifiyMeditor(IslandBaseMediator.ANIMATION_OP, 0, 0)
	end
end

function var0_0.UpdateCardsSelected(arg0_42)
	for iter0_42, iter1_42 in pairs(arg0_42.cards) do
		iter1_42:UpdateSelected(arg0_42.selectedId)
	end
end

function var0_0.OnUpdateItem(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg0_43.cards[arg2_43]

	if not var0_43 then
		arg0_43:OnInitItem(arg2_43)

		var0_43 = arg0_43.cards[arg2_43]
	end

	local var1_43 = arg0_43.displays[arg1_43 + 1]

	var0_43:Update(var1_43, arg0_43.selectedId, arg0_43.loadingData, arg0_43.markActionId)
end

function var0_0.OnDisable(arg0_44)
	if arg0_44.isShowing then
		arg0_44:NotifiyCore(ISLAND_EVT.CLOSE_ANIMATION_OP)

		arg0_44.isShowing = false

		for iter0_44, iter1_44 in pairs(arg0_44.cards) do
			iter1_44:Clear()
		end

		setParent(arg0_44.opPanel, arg0_44.lookParent)
	end
end

function var0_0.OnDispose(arg0_45)
	var0_0.super.OnDispose(arg0_45)
	ClearLScrollrect(arg0_45.scrollrect)
	arg0_45.chatView:Dispose()

	arg0_45.chatView = nil

	arg0_45:RemoveWaitTimer()

	for iter0_45, iter1_45 in pairs(arg0_45.cards) do
		iter1_45:Dispose()
	end

	arg0_45.cards = nil
	arg0_45.isShowing = false
	arg0_45.markActionId = nil
end

return var0_0
