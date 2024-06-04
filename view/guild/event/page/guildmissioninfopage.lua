local var0 = class("GuildMissionInfoPage", import(".GuildEventBasePage"))
local var1 = 10001

function var0.AttrCnt2Desc(arg0, arg1)
	local var0 = pg.attribute_info_by_type[arg0]
	local var1 = arg1.value >= arg1.goal and COLOR_GREEN or COLOR_RED

	return i18n("guild_event_info_desc1", var0.condition, arg1.total, var1, arg1.value, arg1.goal)
end

function var0.AttrAcc2Desc(arg0, arg1)
	local var0 = pg.attribute_info_by_type[arg0]

	assert(var0, arg0)

	local var1

	if arg1.op == 1 then
		var1 = arg1.value >= arg1.goal and COLOR_GREEN or COLOR_RED
	elseif arg1.op == 2 then
		var1 = arg1.value <= arg1.goal and COLOR_GREEN or COLOR_RED
	end

	assert(var1)

	return i18n("guild_event_info_desc2", var0.condition, var1, arg1.value, arg1.goal)
end

function var0.getUIName(arg0)
	return "GuildMissionInfoPage"
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("top/close")
	arg0.sea = arg0:findTF("sea"):GetComponent(typeof(RawImage))
	arg0.titleTxt = arg0:findTF("top/title/Text"):GetComponent(typeof(Text))
	arg0.logBtn = arg0:findTF("bottom/log_btn")
	arg0.formationBtn = arg0:findTF("bottom/formationBtn")
	arg0.doingBtn = arg0:findTF("bottom/doing_btn")
	arg0.helpBtn = arg0:findTF("bottom/help")
	arg0.logPanel = arg0:findTF("log_panel")
	arg0.logList = UIItemList.New(arg0.logPanel:Find("scrollrect/content"), arg0.logPanel:Find("scrollrect/content/tpl"))
	arg0.peopleCnt = arg0:findTF("bottom/cnt/Text"):GetComponent(typeof(Text))
	arg0.effectCnt = arg0:findTF("bottom/effect/Text"):GetComponent(typeof(Text))

	setText(arg0:findTF("bottom/cnt"), i18n("guild_join_member_cnt"))
	setText(arg0:findTF("bottom/effect"), i18n("guild_total_effect"))

	arg0.areaTxt = arg0:findTF("top/title/Text/target/area"):GetComponent(typeof(Text))
	arg0.goalTxt = arg0:findTF("top/title/Text/target/goal"):GetComponent(typeof(Text))
	arg0.timeTxt = arg0:findTF("bottom/progress/time/Text"):GetComponent(typeof(Text))
	arg0.nodesUIlist = UIItemList.New(arg0:findTF("bottom/progress/nodes"), arg0:findTF("bottom/progress/nodes/tpl"))
	arg0.progress = arg0:findTF("bottom/progress")
	arg0.nodeLength = arg0.progress.rect.width
	arg0.healTF = arg0:findTF("resources/heal")
	arg0.nameTF = arg0:findTF("resources/name")
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.closeBtn, function()
		arg0.contextData.mission = nil

		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.guild_mission_info_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.logBtn, function()
		if arg0.isShowLogPanel then
			arg0:ShowOrHideLogPanel(false)
		else
			arg0:ShowOrHideLogPanel(true)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.logPanel, function()
		arg0:ShowOrHideLogPanel(false)
	end, SFX_PANEL)
	onButton(arg0, arg0.formationBtn, function()
		if arg0.mission:IsFinish() then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_event_is_finish"))

			return
		end

		arg0:emit(GuildEventLayer.OPEN_MISSION_FORAMTION, arg0.mission)
	end, SFX_PANEL)
	onButton(arg0, arg0.doingBtn, function()
		triggerButton(arg0.formationBtn)
	end, SFX_PANEL)
end

function var0.OnRefreshMission(arg0, arg1)
	arg0:Flush(arg1)
end

function var0.OnShow(arg0)
	local var0 = arg0.extraData.mission

	arg0:Flush(var0)
	arg0:EnterFormation()
	arg0:AddOtherShipMoveTimer()
end

function var0.Flush(arg0, arg1)
	arg0.mission = arg1

	arg0:InitBattleSea()
	arg0:InitView()
	arg0:AddRefreshProgressTimer()
end

function var0.EnterFormation(arg0)
	if arg0.contextData.missionShips then
		triggerButton(arg0.formationBtn)
	end
end

function var0.InitView(arg0)
	local var0 = arg0.mission
	local var1 = arg0.guild

	arg0.titleTxt.text = var0:GetName()
	arg0.peopleCnt.text = var0:GetJoinMemberCnt() .. "/" .. var1.memberCount .. i18n("guild_word_people")
	arg0.effectCnt.text = var0:GetEfficiency() .. "(" .. var0:GetMyEffect() .. ")"

	local var2 = var0:GetNations()
	local var3 = _.map(var2, function(arg0)
		local var0 = var0:GetShipsByNation(arg0)
		local var1 = Nation.Nation2Name(arg0)

		return i18n("guild_event_info_desc3", var1, #var0)
	end)

	arg0.areaTxt.text = i18n("guild_word_battle_area") .. table.concat(var3, " 、")

	local var4 = var0.GetBattleTarget(var0)
	local var5 = table.concat(var4, " 、")

	if var5 ~= "" then
		arg0.goalTxt.text = i18n("guild_wrod_battle_target") .. var5
	end

	setActive(arg0.goalTxt.gameObject, var5 ~= "")
	arg0:UpdateNodes()
	arg0:UpdateFormationBtn()
end

function var0.UpdateFormationBtn(arg0)
	local var0 = arg0.mission:CanFormation()

	setActive(arg0.formationBtn, var0)
	setActive(arg0.doingBtn, not var0)
end

function var0.GetBattleTarget(arg0)
	local var0 = arg0:GetAttrCntAcc()
	local var1 = arg0:GetAttrAcc()
	local var2 = {}

	for iter0, iter1 in pairs(var0) do
		table.insert(var2, var0.AttrCnt2Desc(iter0, iter1))
	end

	for iter2, iter3 in pairs(var1) do
		table.insert(var2, var0.AttrAcc2Desc(iter2, iter3))
	end

	return var2
end

function var0.UpdateNodes(arg0)
	arg0.nodes = {}

	local var0 = arg0.mission
	local var1 = var0:GetNodes()
	local var2 = 1

	if not var0:IsFinish() then
		arg0.nodesUIlist:make(function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				local var0 = var1[arg1 + 1]
				local var1 = var0:GetPosition()
				local var2 = arg0.nodeLength * (var1 / 100)

				arg2:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/GuildMissionInfoUI_atlas", var1)

				setAnchoredPosition(arg2, {
					x = var2
				})

				local var3 = var0:GetIcon()

				arg2:Find("item"):GetComponent(typeof(Image)).sprite = LoadSprite("GuildNode/" .. var3)

				table.insert(arg0.nodes, arg2)
			end
		end)
		arg0.nodesUIlist:align(#var1)

		var2 = var0:GetProgress()
	end

	setSlider(arg0.progress, 0, 100, var2 * 100)
end

function var0.InitBattleSea(arg0)
	if arg0.loading then
		return
	end

	arg0.loading = true

	local var0 = {}

	if not arg0.battleView then
		arg0.battleView = GuildMissionBattleView.New(arg0.sea)

		arg0.battleView:configUI(arg0.healTF, arg0.nameTF)
		table.insert(var0, function(arg0)
			arg0.battleView:load(var1, arg0)
		end)
	end

	local var1 = arg0.mission:GetMyFlagShip()
	local var2
	local var3 = {}
	local var4 = ""

	if var1 then
		var2 = getProxy(BayProxy):getShipById(var1) or Ship.New({
			id = 9999,
			configId = 101171
		})

		local var5 = math.floor(var2.configId / 10)

		for iter0 = 1, 4 do
			local var6 = pg.ship_data_breakout[tonumber(var5 .. iter0)]
			local var7 = var6 and var6.weapon_ids or {}

			for iter1, iter2 in ipairs(var7) do
				if not table.contains(var3, iter2) then
					table.insert(var3, iter2)
				end
			end
		end

		var4 = getProxy(PlayerProxy):getRawData().name
	end

	table.insert(var0, function(arg0)
		arg0.battleView:LoadShip(var2, var3, var4, function()
			if var2 then
				arg0:CheckNodesState()
			end

			arg0()
		end)
	end)
	seriesAsync(var0, function()
		arg0.loading = false
	end)
end

function var0.AddOtherShipMoveTimer(arg0)
	local function var0(arg0)
		local var0 = {}
		local var1 = arg0.mission:GetOtherShips()

		if #var1 == 0 then
			return var0
		end

		if arg0 >= #var1 then
			return var1
		end

		shuffle(var1)

		for iter0 = 1, arg0 do
			table.insert(var0, var1[iter0])
		end

		return var0
	end

	local var1

	local function var2()
		if arg0.timer then
			arg0.timer:Stop()

			arg0.timer = nil
		end

		local var0 = math.random(30, 150)

		arg0.timer = Timer.New(function()
			local var0 = math.random(1, 2)
			local var1 = var0(var0)

			arg0.battleView:PlayOtherShipAnim(var1, var2)
		end, var0, 1)

		arg0.timer:Start()
	end

	var2()
end

function var0.CheckNodesState(arg0)
	local function var0(arg0)
		if arg0:IsItemType() then
			arg0.battleView:PlayItemAnim()
		elseif arg0:IsBattleType() then
			arg0.battleView:PlayAttackAnim()
		end
	end

	local var1 = arg0.mission
	local var2 = var1:GetNewestSuccessNode()

	if var2 then
		local var3 = var1:GetNodeAnimPosistion()
		local var4 = var2:GetPosition()

		if var3 < var4 then
			var0(var2)
			arg0:emit(GuildEventMediator.ON_UPDATE_NODE_ANIM_FLAG, var1.id, var4)
		end
	end
end

function var0.AddRefreshProgressTimer(arg0)
	arg0:RemoveCdTimer()
	arg0:RemoveRefreshTimer()

	local var0 = arg0.mission
	local var1 = var0:GetTotalTimeCost()
	local var2 = not var0:IsFinish() and var1 > 0

	if var2 then
		assert(var1 > 900, var1)

		local var3 = var1 * 0.01

		arg0.refreshTimer = Timer.New(function()
			arg0:RemoveRefreshTimer()
			arg0:emit(GuildEventMediator.FORCE_REFRESH_MISSION, var0.id)
		end, var3, 1)

		arg0.refreshTimer:Start()

		local var4 = var0:GetRemainingTime()

		if var4 > 0 then
			arg0.cdTimer = Timer.New(function()
				var4 = var4 - 1

				if var4 <= 0 then
					arg0:RemoveCdTimer()
					setActive(arg0.timeTxt.gameObject.transform.parent, false)
				else
					arg0.timeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var4)
				end
			end, 1, -1)

			arg0.cdTimer:Start()
			arg0.cdTimer.func()
		else
			setActive(arg0.timeTxt.gameObject.transform.parent, false)
		end
	end

	setActive(arg0.timeTxt.gameObject.transform.parent, var2)
end

function var0.RemoveCdTimer(arg0)
	if arg0.cdTimer then
		arg0.cdTimer:Stop()

		arg0.cdTimer = nil
	end
end

function var0.ShowOrHideLogPanel(arg0, arg1, arg2)
	arg2 = arg2 or 0.3

	if LeanTween.isTweening(arg0.logPanel) then
		return
	end

	local var0 = arg0.logPanel.rect.width + 300
	local var1 = arg1 and var0 or 0
	local var2 = arg1 and 0 or var0

	LeanTween.value(arg0.logPanel.gameObject, var1, var2, arg2):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0.logPanel, {
			x = arg0
		})
	end)):setOnComplete(System.Action(function()
		if not arg1 then
			setActive(arg0.logPanel, false)
		end
	end))

	arg0.isShowLogPanel = arg1

	if arg1 then
		setActive(arg0.logPanel, true)
		arg0:InitLogs()
	end
end

function var0.InitLogs(arg0)
	local var0 = arg0.mission:GetLogs()

	arg0.logList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			setText(arg2, var0[arg1 + 1])
		end
	end)
	arg0.logList:align(#var0)
end

function var0.RemoveRefreshTimer(arg0)
	if arg0.refreshTimer then
		arg0.refreshTimer:Stop()

		refreshTimer = nil
	end
end

function var0.Hide(arg0)
	arg0:ShowOrHideLogPanel(false, 0)
	var0.super.Hide(arg0)

	if arg0.battleView then
		arg0.battleView:clear()

		arg0.battleView = nil
	end

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	arg0:RemoveRefreshTimer()
	arg0:RemoveCdTimer()
end

return var0
