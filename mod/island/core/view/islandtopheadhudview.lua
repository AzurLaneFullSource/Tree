local var0_0 = class("IslandTopHeadHudView", import(".IslandBaseHudView"))

function var0_0.GetUIName(arg0_1)
	return "IslandTopHeadHudUI"
end

function var0_0.GetHeadOffset(arg0_2)
	return Vector3(0, 1.8, 0)
end

function var0_0.SubViewInit(arg0_3)
	table.insert(arg0_3.views, IslandHudView.New(arg0_3.view))
end

function var0_0.OnInit(arg0_4, arg1_4)
	arg0_4.time = 0

	local var0_4 = arg0_4._tf:GetComponent(typeof(ItemList))

	arg0_4.chatTpl = var0_4.prefabItem[3]
	arg0_4.animationOpTpl = var0_4.prefabItem[1]
	arg0_4.animationOpTpls = {}
	arg0_4.animationOpShowFlags = {}
	arg0_4.isResponeAnimationOp = {}
	arg0_4.bubblePlayers = {}
	arg0_4.chatPlayers = {}
	arg0_4.includePlayerStorys = {}
	arg0_4.animationOpShowDistance = pg.island_set.action_detection.key_value_int
	arg0_4.chatBubbleShowDistance = pg.island_set.island_message_bubble_range.key_value_int
	arg0_4.bubbleTasks = {}

	var0_0.super.OnInit(arg0_4, arg1_4)
end

function var0_0.OnLateUpdate(arg0_5)
	var0_0.super.OnLateUpdate(arg0_5)

	arg0_5.time = arg0_5.time + Time.deltaTime

	if arg0_5.time > 1 then
		arg0_5.time = 0

		local var0_5 = arg0_5:GetView().player

		if var0_5 then
			arg0_5:CheckAnimationOpDistance(var0_5)
			arg0_5:CheckChatBubbleDistance(var0_5)
		end
	end
end

function var0_0.CheckAnimationOpDistance(arg0_6, arg1_6)
	for iter0_6, iter1_6 in pairs(arg0_6.animationOpShowFlags) do
		local var0_6 = arg0_6.animationOpTpls[iter0_6]
		local var1_6 = arg0_6:UnitKey2unitData(iter0_6)
		local var2_6 = arg0_6:GetView():GetUnitModuleWithType(var1_6.type, var1_6.id)

		if var2_6 then
			local var3_6 = Vector3.Distance(arg1_6._go.transform.position, var2_6._go.transform.position) <= arg0_6.animationOpShowDistance
			local var4_6 = isActive(var0_6)

			setActive(var0_6, var3_6)

			if var3_6 then
				arg0_6:PlayAnimationOpEffect(iter0_6, var4_6, iter1_6, var0_6)
			end
		end
	end
end

function var0_0.PlayAnimationOpEffect(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	if arg0_7.animationOpShowFlags[arg1_7] then
		arg0_7.animationOpShowFlags[arg1_7] = true
	end

	local var0_7 = arg4_7.transform:Find("tpl")
	local var1_7 = var0_7:GetComponent(typeof(Animation))
	local var2_7 = var0_7:GetComponent(typeof(DftAniEvent))

	if not arg3_7 and not arg2_7 then
		var2_7:SetEndEvent(nil)
		var2_7:SetEndEvent(function()
			var2_7:SetEndEvent(nil)
			var1_7:Play("anim_IslandAnimationOpTpl_loadingcallback")
		end)
		var1_7:Play("anim_IslandAnimationOpTpl_In")
	elseif not arg2_7 then
		var2_7:SetEndEvent(nil)
		var1_7:Play("anim_IslandAnimationOpTpl_loadingcallback")
	end
end

function var0_0.CheckChatBubbleDistance(arg0_9, arg1_9)
	for iter0_9, iter1_9 in pairs(arg0_9.chatPlayers) do
		if iter1_9:IsPlaying() then
			local var0_9 = arg1_9.role

			if var0_9 then
				local var1_9 = Vector3.Distance(arg1_9._go.transform.position, var0_9._go.transform.position) <= arg0_9.chatBubbleShowDistance

				iter1_9:SetShowFlag(var1_9)
			end
		end
	end
end

function var0_0.CheckPlayerStory(arg0_10, arg1_10)
	return arg1_10 == arg0_10:GetView().player and #arg0_10.includePlayerStorys > 0
end

function var0_0.PlayChat(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	if arg0_11:CheckPlayerStory() then
		return
	end

	local var0_11 = arg0_11:GenUnitData(arg1_11.id, arg1_11.unitType)

	if arg0_11.chatPlayers[var0_11.key] and arg0_11.chatPlayers[var0_11.key]:IsPlaying() then
		arg0_11.chatPlayers[var0_11.key]:Stop()
	end

	local var1_11 = arg0_11:GetUnitHudRoot(var0_11):Find("chatContainer")
	local var2_11 = arg0_11.chatPlayers[var0_11.key] or IslandChatBubblePlayer.New(Object.Instantiate(arg0_11.chatTpl, var1_11), arg1_11._go)
	local var3_11 = BubbleStep.New({
		say = arg3_11,
		emoji = arg2_11
	})

	var2_11:Play(var3_11, arg4_11)

	arg0_11.chatPlayers[var0_11.key] = var2_11
end

function var0_0.TryHidePlayerChat(arg0_12)
	local var0_12 = arg0_12:GetView().player
	local var1_12 = arg0_12:GenUnitData(var0_12.id, var0_12.unitType)
	local var2_12 = arg0_12.chatPlayers[var1_12.key]

	if var2_12 and var2_12:IsPlaying() then
		var2_12:Stop()
	end
end

function var0_0.RawPlayBubble(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = arg1_13.id
	local var1_13 = IslandStory.New(arg1_13, arg2_13, IslandStory.MODE_BUBBLE)

	arg0_13:TryHidePlayerChat()

	if var1_13:ContainerPlayer() then
		table.insert(arg0_13.includePlayerStorys, var0_13)
	end

	local var2_13 = {}

	for iter0_13, iter1_13 in ipairs(var1_13.steps) do
		local var3_13 = iter1_13:GetUnitData()
		local var4_13 = arg0_13:GetUnitHudRoot(var3_13):Find("bubleContainer")
		local var5_13 = arg0_13:GetView():GetUnitModuleWithType(var3_13.type, var3_13.id)

		assert(var5_13)
		table.insert(var2_13, function(arg0_14)
			local var0_14 = arg0_13.bubblePlayers[var3_13.key] or IslandChatBubblePlayer.New(Object.Instantiate(arg0_13.chatTpl, var4_13), var5_13._go)

			var0_14:Play(iter1_13, arg0_14)

			arg0_13.bubblePlayers[var3_13.key] = var0_14
		end)
	end

	seriesAsyncExtend(var2_13, function()
		table.removebyvalue(arg0_13.includePlayerStorys, var0_13)

		arg0_13.bubbleTasks[arg1_13.id] = nil

		if arg3_13 then
			arg3_13()
		end
	end)

	arg0_13.bubbleTasks[arg1_13.id] = var2_13
end

function var0_0.PlayBubble(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = pg.NewStoryMgr.GetInstance():GetScript(arg1_16)

	arg0_16:RawPlayBubble(var0_16, arg2_16, arg3_16)
end

function var0_0.StopBubble(arg0_17, arg1_17)
	local var0_17 = pg.NewStoryMgr.GetInstance():GetScript(arg1_17)

	arg0_17:RawStopBubble(var0_17)
end

function var0_0.RawStopBubble(arg0_18, arg1_18)
	if not arg0_18.bubbleTasks[arg1_18.id] then
		return
	end

	arg0_18.bubbleTasks[arg1_18.id] = {}

	local var0_18 = IslandStory.New(arg1_18, unitList, IslandStory.MODE_BUBBLE)

	for iter0_18, iter1_18 in ipairs(var0_18.steps) do
		local var1_18 = iter1_18:GetUnitData()
		local var2_18 = arg0_18.bubblePlayers[var1_18.key]

		if var2_18 then
			var2_18:Stop()
			var2_18:Dispose()
		end

		arg0_18.bubblePlayers[var1_18.key] = nil
	end
end

function var0_0.ShowAnimationOp(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19:GenUnitData(arg1_19.id, arg1_19.unitType)
	local var1_19 = arg0_19:GetUnitHudRoot(var0_19):Find("aniamtionOpContainer")
	local var2_19 = arg0_19.animationOpTpls[var0_19.key] or Object.Instantiate(arg0_19.animationOpTpl, var1_19)

	setParent(var2_19, var1_19)
	setActive(var2_19, false)

	arg0_19.animationOpTpls[var0_19.key] = var2_19

	onButton(arg0_19, var2_19, function()
		if not arg0_19:CanReponseAnimationOp(arg1_19, arg2_19) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_position_cant_response_cp_action"))

			return
		end

		arg0_19.isResponeAnimationOp[var0_19.key] = true

		arg0_19:NotifiyMeditor(IslandBaseMediator.ANIMATION_OP, arg1_19.id, arg2_19)
	end, SFX_PANEL)

	arg0_19.animationOpShowFlags[var0_19.key] = false
end

function var0_0.CanReponseAnimationOp(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21:GetView().player
	local var1_21 = pg.island_action[arg2_21]
	local var2_21 = BuildVector3(var1_21.respond_point).magnitude

	return IslandCalcUtil.CanReachPoint(var0_21._go.transform.position, var2_21, arg1_21.agent, arg1_21._tf.position, 36)
end

function var0_0.HideAnimationOp(arg0_22, arg1_22)
	local var0_22 = arg0_22:GenUnitData(arg1_22.id, arg1_22.unitType)

	if arg0_22.animationOpShowFlags[var0_22.key] == nil then
		return
	end

	arg0_22.animationOpShowFlags[var0_22.key] = nil

	local var1_22 = arg0_22.animationOpTpls[var0_22.key]

	if not var1_22 then
		return
	end

	local var2_22 = var1_22.transform:Find("tpl")
	local var3_22 = var2_22:GetComponent(typeof(DftAniEvent))
	local var4_22 = var2_22:GetComponent(typeof(Animation))

	var3_22:SetEndEvent(nil)
	var3_22:SetEndEvent(function()
		var3_22:SetEndEvent(nil)
		setActive(var1_22, false)
		removeOnButton(var1_22)
	end)

	if arg0_22.isResponeAnimationOp[var0_22.key] then
		var4_22:Play("anim_IslandAnimationOpTpl_callback")
	else
		var4_22:Play("anim_IslandAnimationOpTpl_Out")
	end

	arg0_22.isResponeAnimationOp[var0_22.key] = nil
end

function var0_0.ShowHud(arg0_24, arg1_24)
	local var0_24 = IslandHudView.LuaName2ContainerName[arg1_24.uiLuaName]
	local var1_24 = arg0_24:GetUnitHudRoot(arg0_24:GenUnitData(arg1_24.id, arg1_24.type)):Find(var0_24)

	arg0_24:GetSubView(IslandHudView):ShowHud(arg1_24, var1_24)
end

function var0_0.RefreshHud(arg0_25, arg1_25)
	local var0_25 = IslandHudView.LuaName2ContainerName[arg1_25.uiLuaName]
	local var1_25 = arg0_25:GetUnitHudRoot(arg0_25:GenUnitData(arg1_25.id, arg1_25.type)):Find(var0_25)

	arg0_25:GetSubView(IslandHudView):RefreshHud(arg1_25, var1_25)
end

function var0_0.HideHud(arg0_26, arg1_26)
	arg0_26:GetSubView(IslandHudView):HideHud(arg1_26)
end

function var0_0.UpdateAllHud(arg0_27)
	arg0_27:GetSubView(IslandHudView):UpdateAllHud()
end

function var0_0.OnDispose(arg0_28)
	var0_0.super.OnDispose(arg0_28)

	for iter0_28, iter1_28 in ipairs(arg0_28.views) do
		iter1_28:Dispose()
	end

	for iter2_28, iter3_28 in pairs(arg0_28.bubblePlayers) do
		iter3_28:Dispose()
	end

	for iter4_28, iter5_28 in ipairs(arg0_28.views) do
		iter5_28:Dispose()
	end

	arg0_28.bubblePlayers = nil

	for iter6_28, iter7_28 in pairs(arg0_28.chatPlayers) do
		iter7_28:Dispose()
	end

	arg0_28.chatPlayers = nil

	for iter8_28, iter9_28 in pairs(arg0_28.animationOpTpls) do
		iter9_28.transform:Find("tpl"):GetComponent(typeof(DftAniEvent)):SetEndEvent(nil)
		Object.Destroy(iter9_28)
	end

	arg0_28.animationOpTpls = nil
	arg0_28.animationOpShowFlags = nil
	arg0_28.includePlayerStorys = nil
	arg0_28.isResponeAnimationOp = nil
	arg0_28.bubbleTasks = nil
end

return var0_0
