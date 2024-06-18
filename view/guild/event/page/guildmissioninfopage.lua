local var0_0 = class("GuildMissionInfoPage", import(".GuildEventBasePage"))
local var1_0 = 10001

function var0_0.AttrCnt2Desc(arg0_1, arg1_1)
	local var0_1 = pg.attribute_info_by_type[arg0_1]
	local var1_1 = arg1_1.value >= arg1_1.goal and COLOR_GREEN or COLOR_RED

	return i18n("guild_event_info_desc1", var0_1.condition, arg1_1.total, var1_1, arg1_1.value, arg1_1.goal)
end

function var0_0.AttrAcc2Desc(arg0_2, arg1_2)
	local var0_2 = pg.attribute_info_by_type[arg0_2]

	assert(var0_2, arg0_2)

	local var1_2

	if arg1_2.op == 1 then
		var1_2 = arg1_2.value >= arg1_2.goal and COLOR_GREEN or COLOR_RED
	elseif arg1_2.op == 2 then
		var1_2 = arg1_2.value <= arg1_2.goal and COLOR_GREEN or COLOR_RED
	end

	assert(var1_2)

	return i18n("guild_event_info_desc2", var0_2.condition, var1_2, arg1_2.value, arg1_2.goal)
end

function var0_0.getUIName(arg0_3)
	return "GuildMissionInfoPage"
end

function var0_0.OnLoaded(arg0_4)
	arg0_4.closeBtn = arg0_4:findTF("top/close")
	arg0_4.sea = arg0_4:findTF("sea"):GetComponent(typeof(RawImage))
	arg0_4.titleTxt = arg0_4:findTF("top/title/Text"):GetComponent(typeof(Text))
	arg0_4.logBtn = arg0_4:findTF("bottom/log_btn")
	arg0_4.formationBtn = arg0_4:findTF("bottom/formationBtn")
	arg0_4.doingBtn = arg0_4:findTF("bottom/doing_btn")
	arg0_4.helpBtn = arg0_4:findTF("bottom/help")
	arg0_4.logPanel = arg0_4:findTF("log_panel")
	arg0_4.logList = UIItemList.New(arg0_4.logPanel:Find("scrollrect/content"), arg0_4.logPanel:Find("scrollrect/content/tpl"))
	arg0_4.peopleCnt = arg0_4:findTF("bottom/cnt/Text"):GetComponent(typeof(Text))
	arg0_4.effectCnt = arg0_4:findTF("bottom/effect/Text"):GetComponent(typeof(Text))

	setText(arg0_4:findTF("bottom/cnt"), i18n("guild_join_member_cnt"))
	setText(arg0_4:findTF("bottom/effect"), i18n("guild_total_effect"))

	arg0_4.areaTxt = arg0_4:findTF("top/title/Text/target/area"):GetComponent(typeof(Text))
	arg0_4.goalTxt = arg0_4:findTF("top/title/Text/target/goal"):GetComponent(typeof(Text))
	arg0_4.timeTxt = arg0_4:findTF("bottom/progress/time/Text"):GetComponent(typeof(Text))
	arg0_4.nodesUIlist = UIItemList.New(arg0_4:findTF("bottom/progress/nodes"), arg0_4:findTF("bottom/progress/nodes/tpl"))
	arg0_4.progress = arg0_4:findTF("bottom/progress")
	arg0_4.nodeLength = arg0_4.progress.rect.width
	arg0_4.healTF = arg0_4:findTF("resources/heal")
	arg0_4.nameTF = arg0_4:findTF("resources/name")
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5.closeBtn, function()
		arg0_5.contextData.mission = nil

		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.guild_mission_info_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.logBtn, function()
		if arg0_5.isShowLogPanel then
			arg0_5:ShowOrHideLogPanel(false)
		else
			arg0_5:ShowOrHideLogPanel(true)
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.logPanel, function()
		arg0_5:ShowOrHideLogPanel(false)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.formationBtn, function()
		if arg0_5.mission:IsFinish() then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_event_is_finish"))

			return
		end

		arg0_5:emit(GuildEventLayer.OPEN_MISSION_FORAMTION, arg0_5.mission)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.doingBtn, function()
		triggerButton(arg0_5.formationBtn)
	end, SFX_PANEL)
end

function var0_0.OnRefreshMission(arg0_12, arg1_12)
	arg0_12:Flush(arg1_12)
end

function var0_0.OnShow(arg0_13)
	local var0_13 = arg0_13.extraData.mission

	arg0_13:Flush(var0_13)
	arg0_13:EnterFormation()
	arg0_13:AddOtherShipMoveTimer()
end

function var0_0.Flush(arg0_14, arg1_14)
	arg0_14.mission = arg1_14

	arg0_14:InitBattleSea()
	arg0_14:InitView()
	arg0_14:AddRefreshProgressTimer()
end

function var0_0.EnterFormation(arg0_15)
	if arg0_15.contextData.missionShips then
		triggerButton(arg0_15.formationBtn)
	end
end

function var0_0.InitView(arg0_16)
	local var0_16 = arg0_16.mission
	local var1_16 = arg0_16.guild

	arg0_16.titleTxt.text = var0_16:GetName()
	arg0_16.peopleCnt.text = var0_16:GetJoinMemberCnt() .. "/" .. var1_16.memberCount .. i18n("guild_word_people")
	arg0_16.effectCnt.text = var0_16:GetEfficiency() .. "(" .. var0_16:GetMyEffect() .. ")"

	local var2_16 = var0_16:GetNations()
	local var3_16 = _.map(var2_16, function(arg0_17)
		local var0_17 = var0_16:GetShipsByNation(arg0_17)
		local var1_17 = Nation.Nation2Name(arg0_17)

		return i18n("guild_event_info_desc3", var1_17, #var0_17)
	end)

	arg0_16.areaTxt.text = i18n("guild_word_battle_area") .. table.concat(var3_16, " 、")

	local var4_16 = var0_0.GetBattleTarget(var0_16)
	local var5_16 = table.concat(var4_16, " 、")

	if var5_16 ~= "" then
		arg0_16.goalTxt.text = i18n("guild_wrod_battle_target") .. var5_16
	end

	setActive(arg0_16.goalTxt.gameObject, var5_16 ~= "")
	arg0_16:UpdateNodes()
	arg0_16:UpdateFormationBtn()
end

function var0_0.UpdateFormationBtn(arg0_18)
	local var0_18 = arg0_18.mission:CanFormation()

	setActive(arg0_18.formationBtn, var0_18)
	setActive(arg0_18.doingBtn, not var0_18)
end

function var0_0.GetBattleTarget(arg0_19)
	local var0_19 = arg0_19:GetAttrCntAcc()
	local var1_19 = arg0_19:GetAttrAcc()
	local var2_19 = {}

	for iter0_19, iter1_19 in pairs(var0_19) do
		table.insert(var2_19, var0_0.AttrCnt2Desc(iter0_19, iter1_19))
	end

	for iter2_19, iter3_19 in pairs(var1_19) do
		table.insert(var2_19, var0_0.AttrAcc2Desc(iter2_19, iter3_19))
	end

	return var2_19
end

function var0_0.UpdateNodes(arg0_20)
	arg0_20.nodes = {}

	local var0_20 = arg0_20.mission
	local var1_20 = var0_20:GetNodes()
	local var2_20 = 1

	if not var0_20:IsFinish() then
		arg0_20.nodesUIlist:make(function(arg0_21, arg1_21, arg2_21)
			if arg0_21 == UIItemList.EventUpdate then
				local var0_21 = var1_20[arg1_21 + 1]
				local var1_21 = var0_21:GetPosition()
				local var2_21 = arg0_20.nodeLength * (var1_21 / 100)

				arg2_21:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/GuildMissionInfoUI_atlas", var1_21)

				setAnchoredPosition(arg2_21, {
					x = var2_21
				})

				local var3_21 = var0_21:GetIcon()

				arg2_21:Find("item"):GetComponent(typeof(Image)).sprite = LoadSprite("GuildNode/" .. var3_21)

				table.insert(arg0_20.nodes, arg2_21)
			end
		end)
		arg0_20.nodesUIlist:align(#var1_20)

		var2_20 = var0_20:GetProgress()
	end

	setSlider(arg0_20.progress, 0, 100, var2_20 * 100)
end

function var0_0.InitBattleSea(arg0_22)
	if arg0_22.loading then
		return
	end

	arg0_22.loading = true

	local var0_22 = {}

	if not arg0_22.battleView then
		arg0_22.battleView = GuildMissionBattleView.New(arg0_22.sea)

		arg0_22.battleView:configUI(arg0_22.healTF, arg0_22.nameTF)
		table.insert(var0_22, function(arg0_23)
			arg0_22.battleView:load(var1_0, arg0_23)
		end)
	end

	local var1_22 = arg0_22.mission:GetMyFlagShip()
	local var2_22
	local var3_22 = {}
	local var4_22 = ""

	if var1_22 then
		var2_22 = getProxy(BayProxy):getShipById(var1_22) or Ship.New({
			id = 9999,
			configId = 101171
		})

		local var5_22 = math.floor(var2_22.configId / 10)

		for iter0_22 = 1, 4 do
			local var6_22 = pg.ship_data_breakout[tonumber(var5_22 .. iter0_22)]
			local var7_22 = var6_22 and var6_22.weapon_ids or {}

			for iter1_22, iter2_22 in ipairs(var7_22) do
				if not table.contains(var3_22, iter2_22) then
					table.insert(var3_22, iter2_22)
				end
			end
		end

		var4_22 = getProxy(PlayerProxy):getRawData().name
	end

	table.insert(var0_22, function(arg0_24)
		arg0_22.battleView:LoadShip(var2_22, var3_22, var4_22, function()
			if var2_22 then
				arg0_22:CheckNodesState()
			end

			arg0_24()
		end)
	end)
	seriesAsync(var0_22, function()
		arg0_22.loading = false
	end)
end

function var0_0.AddOtherShipMoveTimer(arg0_27)
	local function var0_27(arg0_28)
		local var0_28 = {}
		local var1_28 = arg0_27.mission:GetOtherShips()

		if #var1_28 == 0 then
			return var0_28
		end

		if arg0_28 >= #var1_28 then
			return var1_28
		end

		shuffle(var1_28)

		for iter0_28 = 1, arg0_28 do
			table.insert(var0_28, var1_28[iter0_28])
		end

		return var0_28
	end

	local var1_27

	local function var2_27()
		if arg0_27.timer then
			arg0_27.timer:Stop()

			arg0_27.timer = nil
		end

		local var0_29 = math.random(30, 150)

		arg0_27.timer = Timer.New(function()
			local var0_30 = math.random(1, 2)
			local var1_30 = var0_27(var0_30)

			arg0_27.battleView:PlayOtherShipAnim(var1_30, var2_27)
		end, var0_29, 1)

		arg0_27.timer:Start()
	end

	var2_27()
end

function var0_0.CheckNodesState(arg0_31)
	local function var0_31(arg0_32)
		if arg0_32:IsItemType() then
			arg0_31.battleView:PlayItemAnim()
		elseif arg0_32:IsBattleType() then
			arg0_31.battleView:PlayAttackAnim()
		end
	end

	local var1_31 = arg0_31.mission
	local var2_31 = var1_31:GetNewestSuccessNode()

	if var2_31 then
		local var3_31 = var1_31:GetNodeAnimPosistion()
		local var4_31 = var2_31:GetPosition()

		if var3_31 < var4_31 then
			var0_31(var2_31)
			arg0_31:emit(GuildEventMediator.ON_UPDATE_NODE_ANIM_FLAG, var1_31.id, var4_31)
		end
	end
end

function var0_0.AddRefreshProgressTimer(arg0_33)
	arg0_33:RemoveCdTimer()
	arg0_33:RemoveRefreshTimer()

	local var0_33 = arg0_33.mission
	local var1_33 = var0_33:GetTotalTimeCost()
	local var2_33 = not var0_33:IsFinish() and var1_33 > 0

	if var2_33 then
		assert(var1_33 > 900, var1_33)

		local var3_33 = var1_33 * 0.01

		arg0_33.refreshTimer = Timer.New(function()
			arg0_33:RemoveRefreshTimer()
			arg0_33:emit(GuildEventMediator.FORCE_REFRESH_MISSION, var0_33.id)
		end, var3_33, 1)

		arg0_33.refreshTimer:Start()

		local var4_33 = var0_33:GetRemainingTime()

		if var4_33 > 0 then
			arg0_33.cdTimer = Timer.New(function()
				var4_33 = var4_33 - 1

				if var4_33 <= 0 then
					arg0_33:RemoveCdTimer()
					setActive(arg0_33.timeTxt.gameObject.transform.parent, false)
				else
					arg0_33.timeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var4_33)
				end
			end, 1, -1)

			arg0_33.cdTimer:Start()
			arg0_33.cdTimer.func()
		else
			setActive(arg0_33.timeTxt.gameObject.transform.parent, false)
		end
	end

	setActive(arg0_33.timeTxt.gameObject.transform.parent, var2_33)
end

function var0_0.RemoveCdTimer(arg0_36)
	if arg0_36.cdTimer then
		arg0_36.cdTimer:Stop()

		arg0_36.cdTimer = nil
	end
end

function var0_0.ShowOrHideLogPanel(arg0_37, arg1_37, arg2_37)
	arg2_37 = arg2_37 or 0.3

	if LeanTween.isTweening(arg0_37.logPanel) then
		return
	end

	local var0_37 = arg0_37.logPanel.rect.width + 300
	local var1_37 = arg1_37 and var0_37 or 0
	local var2_37 = arg1_37 and 0 or var0_37

	LeanTween.value(arg0_37.logPanel.gameObject, var1_37, var2_37, arg2_37):setOnUpdate(System.Action_float(function(arg0_38)
		setAnchoredPosition(arg0_37.logPanel, {
			x = arg0_38
		})
	end)):setOnComplete(System.Action(function()
		if not arg1_37 then
			setActive(arg0_37.logPanel, false)
		end
	end))

	arg0_37.isShowLogPanel = arg1_37

	if arg1_37 then
		setActive(arg0_37.logPanel, true)
		arg0_37:InitLogs()
	end
end

function var0_0.InitLogs(arg0_40)
	local var0_40 = arg0_40.mission:GetLogs()

	arg0_40.logList:make(function(arg0_41, arg1_41, arg2_41)
		if arg0_41 == UIItemList.EventUpdate then
			setText(arg2_41, var0_40[arg1_41 + 1])
		end
	end)
	arg0_40.logList:align(#var0_40)
end

function var0_0.RemoveRefreshTimer(arg0_42)
	if arg0_42.refreshTimer then
		arg0_42.refreshTimer:Stop()

		refreshTimer = nil
	end
end

function var0_0.Hide(arg0_43)
	arg0_43:ShowOrHideLogPanel(false, 0)
	var0_0.super.Hide(arg0_43)

	if arg0_43.battleView then
		arg0_43.battleView:clear()

		arg0_43.battleView = nil
	end

	if arg0_43.timer then
		arg0_43.timer:Stop()

		arg0_43.timer = nil
	end

	arg0_43:RemoveRefreshTimer()
	arg0_43:RemoveCdTimer()
end

return var0_0
