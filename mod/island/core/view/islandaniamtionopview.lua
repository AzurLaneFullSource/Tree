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

function var0_0.SetUIParent(arg0_4, arg1_4)
	setParent(arg1_4, arg0_4:GetView().topContainer)
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
end

function var0_0.OnEnable(arg0_20)
	if not arg0_20.isInitList then
		arg0_20:InitList()
	end

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

	return var0_21, var1_21
end

local function var4_0(arg0_22)
	local var0_22 = {}

	for iter0_22 = 1, #arg0_22, 2 do
		local var1_22 = arg0_22[iter0_22]
		local var2_22 = arg0_22[iter0_22 + 1]

		table.insert(var0_22, {
			var1_22,
			var2_22
		})
	end

	return var0_22
end

function var0_0.InitList(arg0_23)
	local var0_23, var1_23 = arg0_23:GetData()
	local var2_23 = {}

	if arg0_23.page == var1_0 then
		local var3_23 = var4_0(var0_23)

		for iter0_23, iter1_23 in ipairs(var3_23) do
			table.insert(var2_23, iter1_23)
		end
	end

	if arg0_23.page == var2_0 then
		local var4_23 = var4_0(var1_23)

		for iter2_23, iter3_23 in ipairs(var4_23) do
			table.insert(var2_23, iter3_23)
		end
	end

	arg0_23.displays = var2_23
	arg0_23.scrollrect.enabled = true

	arg0_23.scrollrect:SetTotalCount(#var2_23, 0)

	arg0_23.isInitList = true
end

function var0_0.OnInitItem(arg0_24, arg1_24)
	local var0_24 = IslandAniamtionOpCard.New(arg1_24)

	onButton(arg0_24, var0_24.item1, function()
		arg0_24.selectedId = var0_24.firstId

		arg0_24:UpdateCardsSelected()
		arg0_24:PlayAniamtion(var0_24.firstId)
	end, SFX_PANEL)
	onButton(arg0_24, var0_24.item2, function()
		arg0_24.selectedId = var0_24.secondId

		arg0_24:UpdateCardsSelected()
		arg0_24:PlayAniamtion(var0_24.secondId)
	end, SFX_PANEL)

	arg0_24.cards[arg1_24] = var0_24
end

function var0_0.CanPlayCoupleAction(arg0_27, arg1_27)
	local var0_27 = arg0_27:GetPlayerUnit()
	local var1_27 = BuildVector3(arg1_27.respond_point).magnitude

	return IslandCalcUtil.IsCircleInsideNavMesh(var0_27.agent, var0_27._tf.position, var1_27, 12)
end

function var0_0.PlayAniamtion(arg0_28, arg1_28)
	if not arg1_28 then
		return
	end

	local var0_28 = pg.island_action[arg1_28]

	if var0_28.type == IslandConst.ANIMATION_OP_DOUBLE then
		if arg0_28.startCoupleActionId == arg1_28 then
			return
		end

		if not arg0_28:CanPlayCoupleAction(var0_28) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_position_cant_play_cp_action"))

			return
		end

		arg0_28:NotifiyCore(ISLAND_EVT.LOCK_PLAYER_INPUT)

		arg0_28.startSingleActionId = nil

		arg0_28:AddWaitTimer(arg1_28)
		arg0_28:GetPlayerUnit():PlayAnimation(var0_28.resource, 0.25, function()
			if not arg0_28.startCoupleActionId then
				return
			end

			if arg0_28:HasFollowerAndNoVisitorAround() then
				arg0_28:NotifiyCore(ISLAND_EVT.COUPLE_ACTION_WITH_FOLLOWER, arg0_28.startCoupleActionId)
			else
				arg0_28.isWaitingCoupleAction = true

				arg0_28:NotifiyMeditor(IslandBaseMediator.ANIMATION_OP, 0, arg0_28.startCoupleActionId)
			end
		end)
		arg0_28:ApplyEffect(arg1_28)
	elseif var0_28.type == IslandConst.ANIMATION_OP_SIGNLE then
		if arg0_28.startSingleActionId == arg1_28 then
			return
		end

		arg0_28:NotifiyCore(ISLAND_EVT.LOCK_PLAYER_INPUT)

		arg0_28.startSingleActionId = arg1_28

		arg0_28:RemoveWaitTimer()
		arg0_28:GetPlayerUnit():PlayAnimation(var0_28.resource, 0.25, function()
			arg0_28.startSingleActionId = nil

			IslandTaskHelper.OnActionEnd(var0_28.id)
			arg0_28:NotifiyCore(ISLAND_EVT.PLAY_SIGNLE_ANIMATION_END, var0_28.id)
		end)
	end
end

function var0_0.HasFollowerAndNoVisitorAround(arg0_31)
	local var0_31 = pg.island_set.action_bubble_range.key_value_int
	local var1_31 = arg0_31:GetView()
	local var2_31 = var1_31:GetPlayerPosition()
	local var3_31 = var1_31:GetUnitListByKey(IslandConst.UNIT_LIST_PLAYER)
	local var4_31 = _.any(var3_31, function(arg0_32)
		return arg0_32 ~= var1_31.player and Vector3.Distance(arg0_32:GetPosition(), var2_31) <= var0_31
	end)
	local var5_31 = var1_31:GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)
	local var6_31 = _.any(var3_31, function(arg0_33)
		return Vector3.Distance(arg0_33:GetPosition(), var2_31) <= var0_31
	end)

	return not var4_31 and var6_31
end

function var0_0.ApplyEffect(arg0_34, arg1_34)
	arg0_34:CancelEffect()

	local var0_34 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_34 = pg.TimeMgr.GetInstance():GetServerTime() + arg0_34.waitTime

	arg0_34.loadingData = {
		id = arg1_34,
		startTime = var0_34,
		endTime = var1_34
	}

	for iter0_34, iter1_34 in pairs(arg0_34.cards) do
		if iter1_34:Contains(arg1_34) then
			iter1_34:LoadingEffect(arg0_34.loadingData)

			break
		end
	end
end

function var0_0.CancelEffect(arg0_35)
	if arg0_35.loadingData then
		local var0_35 = arg0_35.loadingData.id

		arg0_35.loadingData = nil

		for iter0_35, iter1_35 in pairs(arg0_35.cards) do
			if iter1_35:Contains(var0_35) then
				iter1_35:ClearLoadingEffect()

				break
			end
		end
	end
end

function var0_0.AddWaitTimer(arg0_36, arg1_36)
	arg0_36:RemoveWaitTimer()

	arg0_36.startCoupleActionId = arg1_36
	arg0_36.timer = Timer.New(function()
		arg0_36:RemoveWaitTimer()
	end, arg0_36.waitTime, 1)

	arg0_36.timer:Start()
end

function var0_0.RemoveWaitTimer(arg0_38, arg1_38)
	arg1_38 = defaultValue(arg1_38, true)

	arg0_38:CancelEffect()

	if arg0_38.timer then
		arg0_38.timer:Stop()

		arg0_38.timer = nil
	end

	if arg0_38.startCoupleActionId then
		if arg1_38 then
			arg0_38:GetPlayerUnit():CheckMovement()
		end

		arg0_38.startCoupleActionId = nil
	end

	if arg0_38.isWaitingCoupleAction then
		arg0_38.isWaitingCoupleAction = false

		arg0_38:NotifiyMeditor(IslandBaseMediator.ANIMATION_OP, 0, 0)
	end
end

function var0_0.UpdateCardsSelected(arg0_39)
	for iter0_39, iter1_39 in pairs(arg0_39.cards) do
		iter1_39:UpdateSelected(arg0_39.selectedId)
	end
end

function var0_0.OnUpdateItem(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg0_40.cards[arg2_40]

	if not var0_40 then
		arg0_40:OnInitItem(arg2_40)

		var0_40 = arg0_40.cards[arg2_40]
	end

	local var1_40 = arg0_40.displays[arg1_40 + 1]

	var0_40:Update(var1_40, arg0_40.selectedId, arg0_40.loadingData)
end

function var0_0.OnDisable(arg0_41)
	if arg0_41.isShowing then
		arg0_41:NotifiyCore(ISLAND_EVT.CLOSE_ANIMATION_OP)

		arg0_41.isShowing = false

		for iter0_41, iter1_41 in pairs(arg0_41.cards) do
			iter1_41:Clear()
		end

		setParent(arg0_41.opPanel, arg0_41.lookParent)
	end
end

function var0_0.OnDispose(arg0_42)
	var0_0.super.OnDispose(arg0_42)
	ClearLScrollrect(arg0_42.scrollrect)
	arg0_42.chatView:Dispose()

	arg0_42.chatView = nil

	arg0_42:RemoveWaitTimer()

	for iter0_42, iter1_42 in pairs(arg0_42.cards) do
		iter1_42:Dispose()
	end

	arg0_42.cards = nil
	arg0_42.isShowing = false
end

return var0_0
