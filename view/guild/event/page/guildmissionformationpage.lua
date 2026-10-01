local var0_0 = class("GuildMissionFormationPage", import(".GuildEventBasePage"))

function var0_0.getUIName(arg0_1)
	return "GuildMissionFormationPage"
end

function var0_0.OnRefreshMission(arg0_2, arg1_2)
	if not arg0_2.mission or arg0_2.mission.id ~= arg1_2.id then
		return
	end

	arg0_2:Flush(arg1_2)
end

function var0_0.OnFormationDone(arg0_3)
	local var0_3 = {}

	arg0_3.loading = true

	for iter0_3, iter1_3 in pairs(arg0_3.shipGos) do
		table.insert(var0_3, function(arg0_4)
			iter1_3:SetAction("victory", 0)
			iter1_3:SetActionCallBack(function(arg0_5)
				if arg0_5 == "finish" then
					iter1_3:SetActionCallBack(nil)
					iter1_3:SetAction("stand", 0)
					arg0_4()
				end
			end)
		end)
	end

	parallelAsync(var0_3, function()
		arg0_3:Hide()

		arg0_3.loading = false
	end)

	local var1_3 = arg0_3.canFormationIndex or 1

	for iter2_3, iter3_3 in ipairs(arg0_3.pageFooter) do
		setActive(iter3_3, iter2_3 <= var1_3)
	end

	setActive(arg0_3.pageFooterAdd, false)
end

function var0_0.OnLoaded(arg0_7)
	arg0_7.closeBtn = arg0_7._tf:Find("frame/close")
	arg0_7.titleTxt = arg0_7._tf:Find("frame/title"):GetComponent(typeof(Text))
	arg0_7.recomBtn = arg0_7._tf:Find("frame/recom")
	arg0_7.clearBtn = arg0_7._tf:Find("frame/clear")
	arg0_7.goBtn = arg0_7._tf:Find("frame/bottom/go")
	arg0_7.inProgressBtn = arg0_7._tf:Find("frame/bottom/doingBtn")
	arg0_7.battleAreaTxt = arg0_7._tf:Find("frame/bottom/desc/area/Text"):GetComponent(typeof(Text))
	arg0_7.battleTypeTxt = arg0_7._tf:Find("frame/bottom/desc/type/Text"):GetComponent(typeof(Text))
	arg0_7.awardList = UIItemList.New(arg0_7._tf:Find("frame/bottom/award/list"), arg0_7._tf:Find("frame/bottom/award/list/item"))
	arg0_7.target1Text = arg0_7._tf:Find("frame/bottom/desc/target/content/Text"):GetComponent(typeof(Text))
	arg0_7.target2Text = arg0_7._tf:Find("frame/bottom/desc/target/content/Text2"):GetComponent(typeof(Text))
	arg0_7.target1Text4Effect = arg0_7._tf:Find("frame/bottom/desc/target/content1/Text"):GetComponent(typeof(Text))
	arg0_7.target2Text4Effect = arg0_7._tf:Find("frame/bottom/desc/target/content1/Text2"):GetComponent(typeof(Text))
	arg0_7.scoreAdditionTxt = arg0_7._tf:Find("frame/bottom/score_addition/Text"):GetComponent(typeof(Text))
	arg0_7.effectAdditionTxt = arg0_7._tf:Find("frame/bottom/effect_addition/Text"):GetComponent(typeof(Text))
	arg0_7.effectTxt = arg0_7._tf:Find("frame/bottom/effect/Text"):GetComponent(typeof(Text))
	arg0_7.bg = arg0_7._tf:Find("frame/bottom/bg"):GetComponent(typeof(Image))
	arg0_7.pageFooter = {
		arg0_7._tf:Find("frame/single/dot/1"),
		arg0_7._tf:Find("frame/single/dot/2"),
		arg0_7._tf:Find("frame/single/dot/3"),
		arg0_7._tf:Find("frame/single/dot/4")
	}
	arg0_7.pageFooterAdd = arg0_7._tf:Find("frame/single/dot/add")
	arg0_7.nextBtn = arg0_7._tf:Find("frame/single/next")
	arg0_7.prevBtn = arg0_7._tf:Find("frame/single/prev")

	setText(arg0_7._tf:Find("frame/bottom/desc/area"), i18n("guild_word_battle_area"))
	setText(arg0_7._tf:Find("frame/bottom/desc/type"), i18n("guild_word_battle_type"))
end

function var0_0.OnInit(arg0_8)
	local function var0_8()
		if arg0_8.contextData.index > 1 then
			triggerToggle(arg0_8.pageFooter[arg0_8.contextData.index - 1], true)
		end
	end

	local function var1_8()
		if arg0_8.contextData.index < arg0_8.mission:GetMaxFleet() then
			local var0_10 = arg0_8.contextData.index + 1

			if var0_10 > arg0_8.mission:GetFleetCnt() then
				triggerToggle(arg0_8.pageFooterAdd, true)
			else
				triggerToggle(arg0_8.pageFooter[var0_10], true)
			end
		end
	end

	addSlip(SLIP_TYPE_HRZ, arg0_8._tf:Find("frame"), var0_8, var1_8)
	onButton(arg0_8, arg0_8.nextBtn, var1_8, SFX_PANEL)
	onButton(arg0_8, arg0_8.prevBtn, var0_8, SFX_PANEL)
	onButton(arg0_8, arg0_8.closeBtn, function()
		arg0_8.contextData.missionShips = nil

		arg0_8:Hide()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.recomBtn, function()
		if not arg0_8:CheckFormation() then
			return
		end

		arg0_8:emit(GuildEventMediator.ON_GET_FORMATION, function()
			local var0_13 = getProxy(GuildProxy):GetRecommendShipsForMission(arg0_8.mission)

			if #var0_13 == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_recomm_ship_failed"))

				return
			end

			arg0_8.contextData.missionShips = var0_13

			local var1_13 = {}

			for iter0_13, iter1_13 in ipairs(var0_13) do
				local var2_13 = getProxy(BayProxy):getShipById(iter1_13)

				if var2_13 then
					local var3_13 = var2_13:getPrefab()

					table.insert(var1_13, "char/" .. var3_13)
				end
			end

			SplitPackConst.DownloadByLuaArr(var1_13, function()
				arg0_8:UpdateFleet(arg0_8.contextData.index)
			end)
		end)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.clearBtn, function()
		if not arg0_8:CheckFormation() then
			return
		end

		arg0_8.contextData.missionShips = {}

		arg0_8:UpdateFleet(arg0_8.contextData.index)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.goBtn, function()
		if arg0_8.mission:IsFinish() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_is_finish"))

			return
		end

		if not arg0_8:CheckFormation() then
			return
		end

		if not arg0_8.contextData.missionShips or #arg0_8.contextData.missionShips == 0 then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("guild_event_start_event_tip"),
			onYes = function()
				arg0_8:emit(GuildEventMediator.JOIN_MISSION, arg0_8.mission.id, arg0_8.contextData.missionShips)
			end
		})
	end, SFX_PANEL)

	arg0_8.shipGos = {}
end

function var0_0.OnShow(arg0_18)
	arg0_18.loading = nil
	arg0_18.maxShipCnt = arg0_18.extraData.shipCnt

	local var0_18 = arg0_18.extraData.mission

	arg0_18:UpdateLayout()
	arg0_18:Flush(var0_18)
	arg0_18:UpdatePageFooter()
	arg0_18:AddNextFormationTimer()
end

function var0_0.UpdatePageFooter(arg0_19)
	local var0_19 = arg0_19.mission
	local var1_19 = var0_19:CanFormation()
	local var2_19 = var0_19:GetFleetCnt()

	for iter0_19, iter1_19 in ipairs(arg0_19.pageFooter) do
		setActive(iter1_19, iter0_19 <= var2_19)
		onToggle(arg0_19, iter1_19, function(arg0_20)
			if arg0_20 then
				arg0_19:UpdateFleet(iter0_19)
				arg0_19:UpdateSwitchBtns()
			end
		end, SFX_PANEL)
	end

	setActive(arg0_19.pageFooterAdd, var1_19)
	onToggle(arg0_19, arg0_19.pageFooterAdd, function(arg0_21)
		if arg0_21 then
			arg0_19:UpdateFleet(var2_19 + 1)
		end
	end, SFX_PANEL)

	local var3_19 = arg0_19.contextData.index or 1

	if var2_19 < var3_19 then
		triggerToggle(arg0_19.pageFooterAdd, true)
	else
		triggerToggle(arg0_19.pageFooter[var3_19], true)
	end
end

function var0_0.UpdateSwitchBtns(arg0_22)
	local var0_22 = arg0_22.mission:GetMaxFleet()
	local var1_22 = arg0_22.contextData.index

	setActive(arg0_22.prevBtn, var1_22 ~= 1)
	setActive(arg0_22.nextBtn, var1_22 < var0_22)
end

function var0_0.AddNextFormationTimer(arg0_23)
	local var0_23 = arg0_23.mission

	if var0_23:IsMaxFleetCnt() then
		return
	end

	local function var1_23(arg0_24)
		arg0_23.canFormationIndex = var0_23:GetCanFormationIndex()

		setActive(arg0_23.pageFooterAdd, true)

		if arg0_24 then
			triggerToggle(arg0_23.pageFooterAdd, false)
		end

		var0_23:RecordFormationTip()
		setActive(arg0_23.pageFooterAdd:Find("tip"), var0_23:ShouldShowFormationTip())
		arg0_23:UpdateSwitchBtns()
	end

	if not var0_23:CanFormation() then
		local var2_23 = var0_23:GetNextFormationTime() - pg.TimeMgr.GetInstance():GetServerTime()

		arg0_23.timer = Timer.New(function()
			arg0_23.timer:Stop()

			arg0_23.timer = nil

			var1_23(true)
		end, var2_23, 1)

		arg0_23.timer:Start()
	else
		var1_23()
	end
end

function var0_0.Flush(arg0_26, arg1_26)
	arg0_26.mission = arg1_26
	arg0_26.canFormationIndex = arg1_26:GetCanFormationIndex()

	arg0_26:InitView()
end

function var0_0.UpdateLayout(arg0_27)
	arg0_27.bg.sprite = GetSpriteFromAtlas("ui/GuildFormationUI_atlas", "bg3")

	local var0_27 = arg0_27._tf:Find("frame/single")

	arg0_27.shipContainer = var0_27
	arg0_27.bg.gameObject.transform.sizeDelta = Vector2(arg0_27.bg.gameObject.transform.sizeDelta.x, 212)

	setActive(var0_27, true)
end

function var0_0.InitView(arg0_28)
	local var0_28 = arg0_28.mission

	if arg0_28.initId ~= var0_28.id then
		local var1_28 = var0_28:GetAwards()

		arg0_28.awardList:make(function(arg0_29, arg1_29, arg2_29)
			if arg0_29 == UIItemList.EventUpdate then
				local var0_29 = var1_28[arg1_29 + 1]
				local var1_29 = {
					type = var0_29[1],
					id = var0_29[2],
					count = var0_29[3]
				}

				updateDrop(arg2_29, var1_29)
				onButton(arg0_28, arg2_29, function()
					arg0_28:send(BaseUI.ON_DROP, var1_29)
				end, SFX_PANEL)
			end
		end)
		arg0_28.awardList:align(#var1_28)

		arg0_28.battleAreaTxt.text = var0_28:getConfig("ship_camp_display")
		arg0_28.battleTypeTxt.text = var0_28:getConfig("ship_type_display")
		arg0_28.titleTxt.text = var0_28:GetName()
		arg0_28.initId = var0_28.id
	end
end

function var0_0.UpdateFleet(arg0_31, arg1_31)
	arg0_31:ClearSlots()

	local var0_31 = arg0_31.mission
	local var1_31 = arg0_31.maxShipCnt
	local var2_31

	if arg1_31 == arg0_31.canFormationIndex then
		var2_31 = arg0_31.contextData.missionShips or var0_31:GetFleetByIndex(arg1_31)
	else
		var2_31 = var0_31:GetFleetByIndex(arg1_31)
	end

	local var3_31 = {}

	var2_31 = var2_31 or {}

	for iter0_31 = 1, var1_31 do
		local var4_31 = arg0_31.shipContainer:GetChild(iter0_31 - 1)

		table.insert(var3_31, function(arg0_32)
			arg0_31:UpdateShipSlot(iter0_31, var4_31, var2_31, arg0_32)
		end)
	end

	pg.UIMgr.GetInstance():LoadingOn(false)
	parallelAsync(var3_31, function()
		pg.UIMgr.GetInstance():LoadingOff()
	end)

	if var0_31:IsEliteType() then
		local var5_31 = arg0_31:GetTagShipCnt(var2_31)
		local var6_31 = var0_31:GetSquadronTargetCnt()
		local var7_31 = var6_31 <= var5_31 and COLOR_GREEN or COLOR_RED
		local var8_31 = var0_31:GetSquadronDisplay()
		local var9_31 = string.format("%s : (<color=%s>%d/%d</color>)", var8_31, var7_31, var5_31, var6_31)

		arg0_31.target2Text.text = HXSet.hxLan(var9_31)
		arg0_31.target2Text4Effect.text = HXSet.hxLan(var9_31)
	else
		arg0_31.target2Text.text = ""
		arg0_31.target2Text4Effect.text = ""
	end

	local var10_31 = GuildMission.CalcMyEffect(var2_31)

	arg0_31.effectTxt.text = var10_31

	local var11_31 = arg0_31:CalcEffectAddition(var2_31)
	local var12_31, var13_31, var14_31 = arg0_31:CalcScoreAddition(var2_31)

	arg0_31.scoreAdditionTxt.text = i18n("guild_word_score_addition") .. var12_31
	arg0_31.effectAdditionTxt.text = i18n("guild_word_effect_addition") .. var11_31

	local var15_31 = arg0_31:GetBattleTarget(var13_31, var14_31)

	arg0_31.target1Text.text = table.concat(var15_31, " 、")
	arg0_31.target1Text4Effect.text = arg0_31.target1Text.text

	setButtonEnabled(arg0_31.goBtn, #var2_31 > 0)

	local var16_31 = var0_31:GetFleetCnt()
	local var17_31 = not var0_31:CanFormation() or arg1_31 <= var16_31

	setActive(arg0_31.inProgressBtn, var17_31)
	setActive(arg0_31.goBtn, not var17_31)

	arg0_31.contextData.index = arg1_31

	if arg0_31.target2Text.text ~= "" and arg0_31.target1Text.text ~= "" then
		setText(arg0_31._tf:Find("frame/bottom/desc/target/content/title"), i18n("guild_wrod_battle_target"))
	else
		setText(arg0_31._tf:Find("frame/bottom/desc/target/content/title"), "")
	end
end

function var0_0.UpdateShipSlot(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34)
	local var0_34 = arg0_34.mission
	local var1_34 = arg3_34[arg1_34]
	local var2_34 = arg2_34:Find("Image")
	local var3_34 = arg2_34:Find("effect")
	local var4_34 = arg2_34:Find("score")

	if var1_34 then
		local var5_34 = getProxy(BayProxy):getShipById(var1_34)

		if var5_34 then
			local var6_34 = var5_34:getPrefab()

			arg0_34.spineChar = SpineAnimChar.New()

			arg0_34.spineChar:SetPaint(var6_34)
			arg0_34.spineChar:Load(true, function(arg0_35)
				arg0_35:SetName(var6_34)
				arg0_35:SetPivot(Vector2(0.5, 0))
				arg0_35:SetSizeDelta(Vector2(200, 300))
				arg0_35:SetParent(arg2_34)
				arg0_35:SetLocalPosition(Vector3(0, 0, 0))
				arg0_35:SetLocalScale(Vector3(0.6, 0.6, 0.6))
				arg0_35:SetAction("stand")
				GetOrAddComponent(arg0_35:GetModel(), "EventTriggerListener"):AddPointClickFunc(function(arg0_36, arg1_36)
					arg0_34:emit(GuildEventMediator.ON_SELECT_MISSION_SHIP, var0_34.id, arg1_34, arg3_34)
				end)

				arg0_34.shipGos[var1_34] = arg0_35

				if arg4_34 then
					arg4_34()
				end
			end)
			setActive(var3_34, arg0_34:HasEffectAddition(var5_34))
			setActive(var4_34, arg0_34:HasScoreAddition(var5_34))
		elseif arg4_34 then
			arg4_34()
		end
	else
		onButton(arg0_34, var2_34, function()
			arg0_34:emit(GuildEventMediator.ON_SELECT_MISSION_SHIP, var0_34.id, arg1_34, arg3_34)
		end, SFX_PANEL)
		setActive(var3_34, false)
		setActive(var4_34, false)

		if arg4_34 then
			arg4_34()
		end
	end

	setActive(var2_34, not var1_34)
end

function var0_0.CheckFormation(arg0_38)
	local var0_38 = arg0_38.mission

	if arg0_38.contextData.index ~= arg0_38.canFormationIndex then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_curr_fleet_can_not_edit"))

		return false
	end

	local var1_38, var2_38 = arg0_38.mission:CanFormation()

	if not var1_38 then
		if var2_38 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_next_edit_fleet_time", var2_38))
		end

		return false
	end

	return true
end

function var0_0.emit(arg0_39, ...)
	if arg0_39.loading then
		return
	end

	if not arg0_39:CheckFormation() then
		return
	end

	var0_0.super.emit(arg0_39, ...)
end

function var0_0.send(arg0_40, ...)
	var0_0.super.emit(arg0_40, ...)
end

function var0_0.GetBattleTarget(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg0_41.mission
	local var1_41 = var0_41:GetAttrCntAcc()
	local var2_41 = var0_41:GetAttrAcc()
	local var3_41 = {}

	for iter0_41, iter1_41 in pairs(var1_41) do
		local var4_41 = arg1_41[iter0_41] or 0

		table.insert(var3_41, GuildMissionInfoPage.AttrCnt2Desc(iter0_41, {
			value = iter1_41.value + var4_41,
			total = iter1_41.total,
			goal = iter1_41.goal,
			score = iter1_41.score
		}))
	end

	for iter2_41, iter3_41 in pairs(var2_41) do
		local var5_41 = arg2_41[iter2_41] or 0

		table.insert(var3_41, GuildMissionInfoPage.AttrAcc2Desc(iter2_41, {
			value = iter3_41.value + var5_41,
			op = iter3_41.op,
			goal = iter3_41.goal,
			score = iter3_41.score
		}))
	end

	return var3_41
end

function var0_0.GetTagShipCnt(arg0_42, arg1_42)
	local var0_42 = arg0_42.mission:GetSquadron()
	local var1_42 = 0
	local var2_42 = getProxy(BayProxy)

	for iter0_42, iter1_42 in ipairs(arg1_42) do
		local var3_42 = var2_42:getShipById(iter1_42)

		if var3_42 and var3_42:IsTagShip(var0_42) then
			var1_42 = var1_42 + 1
		end
	end

	return var1_42
end

function var0_0.CalcScoreAddition(arg0_43, arg1_43)
	local var0_43 = arg0_43.mission
	local var1_43 = var0_43:GetAttrCntAcc()
	local var2_43 = var0_43:GetAttrAcc()
	local var3_43 = pg.attribute_info_by_type
	local var4_43 = 0
	local var5_43 = {}
	local var6_43 = {}
	local var7_43 = getProxy(BayProxy)

	for iter0_43, iter1_43 in ipairs(arg1_43) do
		local var8_43 = var7_43:getShipById(iter1_43)
		local var9_43

		if var8_43 then
			var9_43 = _.detect(var0_43:getConfig("ship_camp_effect"), function(arg0_44)
				return arg0_44[1] == var8_43:getNation()
			end)
		end

		if var9_43 then
			var4_43 = var4_43 + var9_43[2]
		end

		local var10_43 = var8_43 and var8_43:getProperties() or {}

		for iter2_43, iter3_43 in pairs(var1_43) do
			if (var10_43[var3_43[iter2_43].name] or 0) >= iter3_43.total then
				var5_43[iter2_43] = (var5_43[iter2_43] or 0) + 1
			end
		end

		for iter4_43, iter5_43 in pairs(var2_43) do
			local var11_43 = var3_43[iter4_43].name

			var6_43[iter4_43] = (var6_43[iter4_43] or 0) + (var10_43[var11_43] or 0)
		end
	end

	for iter6_43, iter7_43 in pairs(var1_43) do
		if (var5_43[iter6_43] or 0) + iter7_43.value >= iter7_43.goal then
			var4_43 = var4_43 + iter7_43.score
		end
	end

	for iter8_43, iter9_43 in pairs(var2_43) do
		local var12_43 = iter9_43.value + (var6_43[iter8_43] or 0)
		local var13_43

		if iter9_43.op == 1 then
			var13_43 = var12_43 >= iter9_43.goal
		elseif iter9_43.op == 2 then
			var13_43 = var12_43 <= iter9_43.goal
		end

		if var13_43 then
			var4_43 = var4_43 + iter9_43.score
		end
	end

	return var4_43, var5_43, var6_43
end

function var0_0.getResource(arg0_45, arg1_45)
	local var0_45 = var0_0.super.getResource(arg0_45, arg1_45)
	local var1_45 = getProxy(GuildProxy):getData():GetActiveEvent():GetMissions()

	for iter0_45, iter1_45 in ipairs(var1_45) do
		for iter2_45, iter3_45 in ipairs(iter1_45) do
			local var2_45 = iter3_45:GetMyShips()

			for iter4_45, iter5_45 in ipairs(var2_45) do
				local var3_45 = getProxy(BayProxy):getShipById(iter5_45)

				if var3_45 then
					local var4_45 = var3_45:getPrefab()

					table.insert(var0_45, "char/" .. var4_45)
					table.insert(var0_45, "herohrzicon/" .. var4_45)
				end
			end
		end
	end

	return var0_45
end

function var0_0.CalcEffectAddition(arg0_46, arg1_46)
	local var0_46 = arg0_46.mission
	local var1_46 = GuildMission.CalcMyEffect(arg1_46)
	local var2_46 = getProxy(BayProxy)

	for iter0_46, iter1_46 in ipairs(arg1_46) do
		local var3_46 = var2_46:getShipById(iter1_46)
		local var4_46

		if var3_46 then
			var4_46 = _.detect(var0_46:getConfig("ship_type_effect"), function(arg0_47)
				return arg0_47[1] == var3_46:getShipType()
			end)
		end

		if var4_46 then
			var1_46 = var1_46 + var4_46[2]
		end
	end

	local var5_46 = arg0_46:GetTagShipCnt(arg1_46)
	local var6_46 = var0_46:GetSquadronTargetCnt()
	local var7_46 = 1

	if var6_46 <= var5_46 and var0_46:IsEliteType() then
		var7_46 = var0_46:GetSquadronRatio()
	end

	return var1_46 * var7_46
end

function var0_0.HasScoreAddition(arg0_48, arg1_48)
	local var0_48 = arg0_48.mission
	local var1_48 = var0_48:GetRecommendShipNation()
	local var2_48 = var0_48:GetAttrCntAcc()
	local var3_48 = var0_48:GetAttrAcc()

	local function var4_48()
		local var0_49 = arg1_48:getProperties()
		local var1_49 = pg.attribute_info_by_type

		for iter0_49, iter1_49 in pairs(var2_48) do
			local var2_49 = var1_49[iter0_49].name

			assert(var0_49[var2_49], var2_49)

			if (var0_49[var2_49] or 0) >= iter1_49.total then
				return true
			end
		end

		for iter2_49, iter3_49 in pairs(var3_48) do
			local var3_49 = var1_49[iter2_49].name

			assert(var0_49[var3_49], var3_49)

			if iter3_49.op == 1 then
				return (var0_49[var3_49] or 0) > 0
			elseif iter3_49.op == 2 then
				return (var0_49[var3_49] or 0) == 0
			end
		end

		return false
	end

	return table.contains(var1_48, arg1_48:getNation()) or var4_48()
end

function var0_0.HasEffectAddition(arg0_50, arg1_50)
	local var0_50 = arg0_50.mission
	local var1_50 = var0_50:GetRecommendShipTypes()
	local var2_50 = var0_50:GetSquadron()

	return table.contains(var1_50, arg1_50:getShipType()) or arg1_50:IsTagShip(var2_50)
end

function var0_0.ClearSlots(arg0_51)
	for iter0_51, iter1_51 in pairs(arg0_51.shipGos) do
		iter1_51:SetPivot(Vector2(0.5, 0.5))
		GetOrAddComponent(iter1_51:GetModel(), "EventTriggerListener"):RemovePointClickFunc()
		iter1_51:SetActionCallBack(nil)
		iter1_51:Dispose()
	end

	arg0_51.shipGos = {}
end

function var0_0.Hide(arg0_52)
	var0_0.super.Hide(arg0_52)
	arg0_52:ClearSlots()

	if arg0_52.timer then
		arg0_52.timer:Stop()

		arg0_52.timer = nil
	end
end

return var0_0
