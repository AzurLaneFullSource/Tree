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
	arg0_4.closeBtn = arg0_4._tf:Find("top/close")
	arg0_4.sea = arg0_4._tf:Find("bg/sea"):GetComponent(typeof(RawImage))
	arg0_4.titleTxt = arg0_4._tf:Find("top/title/Text"):GetComponent(typeof(Text))
	arg0_4.logBtn = arg0_4._tf:Find("bottom/log_btn")
	arg0_4.formationBtn = arg0_4._tf:Find("bottom/formationBtn")
	arg0_4.doingBtn = arg0_4._tf:Find("bottom/doing_btn")
	arg0_4.helpBtn = arg0_4._tf:Find("bottom/help")
	arg0_4.logPanel = arg0_4._tf:Find("log_panel")
	arg0_4.logList = UIItemList.New(arg0_4.logPanel:Find("scrollrect/content"), arg0_4.logPanel:Find("scrollrect/content/tpl"))
	arg0_4.peopleCnt = arg0_4._tf:Find("bottom/cnt/Text"):GetComponent(typeof(Text))
	arg0_4.effectCnt = arg0_4._tf:Find("bottom/effect/Text"):GetComponent(typeof(Text))

	setText(arg0_4._tf:Find("bottom/cnt"), i18n("guild_join_member_cnt"))
	setText(arg0_4._tf:Find("bottom/effect"), i18n("guild_total_effect"))

	arg0_4.areaTxt = arg0_4._tf:Find("top/title/Text/target/area"):GetComponent(typeof(Text))
	arg0_4.goalTxt = arg0_4._tf:Find("top/title/Text/target/goal"):GetComponent(typeof(Text))
	arg0_4.timeTxt = arg0_4._tf:Find("bottom/progress/time/Text"):GetComponent(typeof(Text))
	arg0_4.nodesUIlist = UIItemList.New(arg0_4._tf:Find("bottom/progress/nodes"), arg0_4._tf:Find("bottom/progress/nodes/tpl"))
	arg0_4.progress = arg0_4._tf:Find("bottom/progress")
	arg0_4.nodeLength = arg0_4.progress.rect.width
	arg0_4.healTF = arg0_4._tf:Find("resources/heal")
	arg0_4.nameTF = arg0_4._tf:Find("resources/name")
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
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_is_finish"))

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
		arg0_22:downloadBattleShipResList(var2_22, var3_22, arg0_24)
	end)
	table.insert(var0_22, function(arg0_25)
		arg0_22.battleView:LoadShip(var2_22, var3_22, var4_22, function()
			if var2_22 then
				arg0_22:CheckNodesState()
			end

			arg0_25()
		end)
	end)
	seriesAsync(var0_22, function()
		arg0_22.loading = false
	end)
end

function var0_0.AddOtherShipMoveTimer(arg0_28)
	local function var0_28(arg0_29)
		local var0_29 = {}
		local var1_29 = arg0_28.mission:GetOtherShips()

		if #var1_29 == 0 then
			return var0_29
		end

		if arg0_29 >= #var1_29 then
			return var1_29
		end

		shuffle(var1_29)

		for iter0_29 = 1, arg0_29 do
			table.insert(var0_29, var1_29[iter0_29])
		end

		return var0_29
	end

	local var1_28

	local function var2_28()
		if arg0_28.timer then
			arg0_28.timer:Stop()

			arg0_28.timer = nil
		end

		local var0_30 = math.random(30, 150)

		arg0_28.timer = Timer.New(function()
			local var0_31 = math.random(1, 2)
			local var1_31 = var0_28(var0_31)

			arg0_28.battleView:PlayOtherShipAnim(var1_31, var2_28)
		end, var0_30, 1)

		arg0_28.timer:Start()
	end

	var2_28()
end

function var0_0.CheckNodesState(arg0_32)
	local function var0_32(arg0_33)
		if arg0_33:IsItemType() then
			arg0_32.battleView:PlayItemAnim()
		elseif arg0_33:IsBattleType() then
			arg0_32.battleView:PlayAttackAnim()
		end
	end

	local var1_32 = arg0_32.mission
	local var2_32 = var1_32:GetNewestSuccessNode()

	if var2_32 then
		local var3_32 = var1_32:GetNodeAnimPosistion()
		local var4_32 = var2_32:GetPosition()

		if var3_32 < var4_32 then
			var0_32(var2_32)
			arg0_32:emit(GuildEventMediator.ON_UPDATE_NODE_ANIM_FLAG, var1_32.id, var4_32)
		end
	end
end

function var0_0.AddRefreshProgressTimer(arg0_34)
	arg0_34:RemoveCdTimer()
	arg0_34:RemoveRefreshTimer()

	local var0_34 = arg0_34.mission
	local var1_34 = var0_34:GetTotalTimeCost()
	local var2_34 = not var0_34:IsFinish() and var1_34 > 0

	if var2_34 then
		assert(var1_34 > 900, var1_34)

		local var3_34 = var1_34 * 0.01

		arg0_34.refreshTimer = Timer.New(function()
			arg0_34:RemoveRefreshTimer()
			arg0_34:emit(GuildEventMediator.FORCE_REFRESH_MISSION, var0_34.id)
		end, var3_34, 1)

		arg0_34.refreshTimer:Start()

		local var4_34 = var0_34:GetRemainingTime()

		if var4_34 > 0 then
			arg0_34.cdTimer = Timer.New(function()
				var4_34 = var4_34 - 1

				if var4_34 <= 0 then
					arg0_34:RemoveCdTimer()
					setActive(arg0_34.timeTxt.gameObject.transform.parent, false)
				else
					arg0_34.timeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var4_34)
				end
			end, 1, -1)

			arg0_34.cdTimer:Start()
			arg0_34.cdTimer.func()
		else
			setActive(arg0_34.timeTxt.gameObject.transform.parent, false)
		end
	end

	setActive(arg0_34.timeTxt.gameObject.transform.parent, var2_34)
end

function var0_0.RemoveCdTimer(arg0_37)
	if arg0_37.cdTimer then
		arg0_37.cdTimer:Stop()

		arg0_37.cdTimer = nil
	end
end

function var0_0.getResource(arg0_38, arg1_38)
	local var0_38 = var0_0.super.getResource(arg0_38, arg1_38)

	local function var1_38(arg0_39)
		if not table.contains(var0_38, arg0_39) then
			table.insert(var0_38, arg0_39)
		end
	end

	var1_38("guildnode/box")
	var1_38("guildnode/battle")
	var1_38("ui/guildmissioninfoui_atlas")
	var1_38("ui/guildformationui_atlas")

	local var2_38 = ys.Battle.BattleResourceManager

	table.insertto(var0_38, var2_38.GetDisplayCommonResource())
	table.insertto(var0_38, var2_38.GetMapResource(var1_0))

	local var3_38 = pg.enemy_data_statistics[10]

	var1_38(var2_38.GetCharacterPath(var3_38.prefab))

	local var4_38 = pg.enemy_data_statistics[1028]

	var1_38(var2_38.GetCharacterPath(var4_38.prefab))

	local var5_38 = getProxy(GuildProxy):getData():GetActiveEvent():GetMissions()

	for iter0_38, iter1_38 in ipairs(var5_38) do
		for iter2_38, iter3_38 in ipairs(iter1_38) do
			local var6_38 = iter3_38:GetMyShips()

			for iter4_38, iter5_38 in ipairs(var6_38) do
				local var7_38 = getProxy(BayProxy):getShipById(iter5_38)

				if var7_38 then
					local var8_38 = var7_38:getPrefab()

					table.insert(var0_38, "char/" .. var8_38)
					table.insert(var0_38, "herohrzicon/" .. var8_38)
				end
			end
		end
	end

	return var0_38
end

function var0_0.downloadBattleShipResList(arg0_40, arg1_40, arg2_40, arg3_40)
	local var0_40 = ys.Battle.BattleResourceManager
	local var1_40 = {}

	if arg1_40 then
		table.insert(var1_40, var0_40.GetCharacterPath(arg1_40:getPrefab()))

		if arg1_40:getShipType() ~= ShipType.WeiXiu then
			for iter0_40, iter1_40 in ipairs(arg2_40) do
				if iter1_40 ~= 0 then
					local var2_40 = ys.Battle.BattleDataFunction.GetWeaponDataFromID(iter1_40).weapon_id

					for iter2_40, iter3_40 in ipairs(var2_40) do
						local var3_40 = var0_40.GetWeaponResource(iter3_40)

						for iter4_40, iter5_40 in ipairs(var3_40) do
							if not table.contains(var1_40, iter5_40) and string.sub(iter5_40, -#"/") ~= "/" then
								table.insert(var1_40, iter5_40)
							end
						end
					end
				end
			end
		end
	end

	if #var1_40 == 0 then
		arg3_40()

		return
	end

	SplitPackConst.DownloadByLuaArr(var1_40, function()
		if not arg0_40.loading then
			return
		end

		arg3_40()
	end)
end

function var0_0.ShowOrHideLogPanel(arg0_42, arg1_42, arg2_42)
	arg2_42 = arg2_42 or 0.3

	if LeanTween.isTweening(arg0_42.logPanel) then
		return
	end

	local var0_42 = arg0_42.logPanel.rect.width + 300
	local var1_42 = arg1_42 and var0_42 or 0
	local var2_42 = arg1_42 and 0 or var0_42

	LeanTween.value(arg0_42.logPanel.gameObject, var1_42, var2_42, arg2_42):setOnUpdate(System.Action_float(function(arg0_43)
		setAnchoredPosition(arg0_42.logPanel, {
			x = arg0_43
		})
	end)):setOnComplete(System.Action(function()
		if not arg1_42 then
			setActive(arg0_42.logPanel, false)
		end
	end))

	arg0_42.isShowLogPanel = arg1_42

	if arg1_42 then
		setActive(arg0_42.logPanel, true)
		arg0_42:InitLogs()
	end
end

function var0_0.InitLogs(arg0_45)
	local var0_45 = arg0_45.mission:GetLogs()

	arg0_45.logList:make(function(arg0_46, arg1_46, arg2_46)
		if arg0_46 == UIItemList.EventUpdate then
			setText(arg2_46, var0_45[arg1_46 + 1])
		end
	end)
	arg0_45.logList:align(#var0_45)
end

function var0_0.RemoveRefreshTimer(arg0_47)
	if arg0_47.refreshTimer then
		arg0_47.refreshTimer:Stop()

		refreshTimer = nil
	end
end

function var0_0.Hide(arg0_48)
	arg0_48:ShowOrHideLogPanel(false, 0)
	var0_0.super.Hide(arg0_48)

	if arg0_48.battleView then
		arg0_48.battleView:clear()

		arg0_48.battleView = nil
	end

	if arg0_48.timer then
		arg0_48.timer:Stop()

		arg0_48.timer = nil
	end

	arg0_48:RemoveRefreshTimer()
	arg0_48:RemoveCdTimer()
end

return var0_0
