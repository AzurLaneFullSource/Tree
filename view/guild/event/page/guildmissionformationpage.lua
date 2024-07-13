local var0_0 = class("GuildMissionFormationPage", import(".GuildEventBasePage"))

function var0_0.getUIName(arg0_1)
	return "GuildMissionFormationPage"
end

function var0_0.OnRefreshMission(arg0_2, arg1_2)
	arg0_2:Flush(arg1_2)
end

function var0_0.OnFormationDone(arg0_3)
	local var0_3 = {}

	arg0_3.loading = true

	for iter0_3, iter1_3 in pairs(arg0_3.shipGos) do
		table.insert(var0_3, function(arg0_4)
			local var0_4 = iter1_3:GetComponent(typeof(SpineAnimUI))

			var0_4:SetAction("victory", 0)
			var0_4:SetActionCallBack(function(arg0_5)
				if arg0_5 == "finish" then
					var0_4:SetActionCallBack(nil)
					var0_4:SetAction("stand", 0)
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
	arg0_7.closeBtn = arg0_7:findTF("frame/close")
	arg0_7.titleTxt = arg0_7:findTF("frame/title"):GetComponent(typeof(Text))
	arg0_7.recomBtn = arg0_7:findTF("frame/recom")
	arg0_7.clearBtn = arg0_7:findTF("frame/clear")
	arg0_7.goBtn = arg0_7:findTF("frame/bottom/go")
	arg0_7.inProgressBtn = arg0_7:findTF("frame/bottom/doingBtn")
	arg0_7.battleAreaTxt = arg0_7:findTF("frame/bottom/desc/area/Text"):GetComponent(typeof(Text))
	arg0_7.battleTypeTxt = arg0_7:findTF("frame/bottom/desc/type/Text"):GetComponent(typeof(Text))
	arg0_7.awardList = UIItemList.New(arg0_7:findTF("frame/bottom/award/list"), arg0_7:findTF("frame/bottom/award/list/item"))
	arg0_7.target1Text = arg0_7:findTF("frame/bottom/desc/target/content/Text"):GetComponent(typeof(Text))
	arg0_7.target2Text = arg0_7:findTF("frame/bottom/desc/target/content/Text2"):GetComponent(typeof(Text))
	arg0_7.target1Text4Effect = arg0_7:findTF("frame/bottom/desc/target/content1/Text"):GetComponent(typeof(Text))
	arg0_7.target2Text4Effect = arg0_7:findTF("frame/bottom/desc/target/content1/Text2"):GetComponent(typeof(Text))
	arg0_7.scoreAdditionTxt = arg0_7:findTF("frame/bottom/score_addition/Text"):GetComponent(typeof(Text))
	arg0_7.effectAdditionTxt = arg0_7:findTF("frame/bottom/effect_addition/Text"):GetComponent(typeof(Text))
	arg0_7.effectTxt = arg0_7:findTF("frame/bottom/effect/Text"):GetComponent(typeof(Text))
	arg0_7.bg = arg0_7:findTF("frame/bottom/bg"):GetComponent(typeof(Image))
	arg0_7.pageFooter = {
		arg0_7:findTF("frame/single/dot/1"),
		arg0_7:findTF("frame/single/dot/2"),
		arg0_7:findTF("frame/single/dot/3"),
		arg0_7:findTF("frame/single/dot/4")
	}
	arg0_7.pageFooterAdd = arg0_7:findTF("frame/single/dot/add")
	arg0_7.nextBtn = arg0_7:findTF("frame/single/next")
	arg0_7.prevBtn = arg0_7:findTF("frame/single/prev")

	setText(arg0_7:findTF("frame/bottom/desc/area"), i18n("guild_word_battle_area"))
	setText(arg0_7:findTF("frame/bottom/desc/type"), i18n("guild_word_battle_type"))
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

	addSlip(SLIP_TYPE_HRZ, arg0_8:findTF("frame"), var0_8, var1_8)
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

			arg0_8:UpdateFleet(arg0_8.contextData.index)
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
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_event_is_finish"))

			return
		end

		if not arg0_8:CheckFormation() then
			return
		end

		if not arg0_8.contextData.missionShips or #arg0_8.contextData.missionShips == 0 then
			return
		end

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_event_start_event_tip"),
			onYes = function()
				arg0_8:emit(GuildEventMediator.JOIN_MISSION, arg0_8.mission.id, arg0_8.contextData.missionShips)
			end
		})
	end, SFX_PANEL)

	arg0_8.shipGos = {}
end

function var0_0.OnShow(arg0_17)
	arg0_17.loading = nil
	arg0_17.maxShipCnt = arg0_17.extraData.shipCnt

	local var0_17 = arg0_17.extraData.mission

	arg0_17:UpdateLayout()
	arg0_17:Flush(var0_17)
	arg0_17:UpdatePageFooter()
	arg0_17:AddNextFormationTimer()
end

function var0_0.UpdatePageFooter(arg0_18)
	local var0_18 = arg0_18.mission
	local var1_18 = var0_18:CanFormation()
	local var2_18 = var0_18:GetFleetCnt()

	for iter0_18, iter1_18 in ipairs(arg0_18.pageFooter) do
		setActive(iter1_18, iter0_18 <= var2_18)
		onToggle(arg0_18, iter1_18, function(arg0_19)
			if arg0_19 then
				arg0_18:UpdateFleet(iter0_18)
				arg0_18:UpdateSwitchBtns()
			end
		end, SFX_PANEL)
	end

	setActive(arg0_18.pageFooterAdd, var1_18)
	onToggle(arg0_18, arg0_18.pageFooterAdd, function(arg0_20)
		if arg0_20 then
			arg0_18:UpdateFleet(var2_18 + 1)
		end
	end, SFX_PANEL)

	local var3_18 = arg0_18.contextData.index or 1

	if var2_18 < var3_18 then
		triggerToggle(arg0_18.pageFooterAdd, true)
	else
		triggerToggle(arg0_18.pageFooter[var3_18], true)
	end
end

function var0_0.UpdateSwitchBtns(arg0_21)
	local var0_21 = arg0_21.mission:GetMaxFleet()
	local var1_21 = arg0_21.contextData.index

	setActive(arg0_21.prevBtn, var1_21 ~= 1)
	setActive(arg0_21.nextBtn, var1_21 < var0_21)
end

function var0_0.AddNextFormationTimer(arg0_22)
	local var0_22 = arg0_22.mission

	if var0_22:IsMaxFleetCnt() then
		return
	end

	local function var1_22(arg0_23)
		arg0_22.canFormationIndex = var0_22:GetCanFormationIndex()

		setActive(arg0_22.pageFooterAdd, true)

		if arg0_23 then
			triggerToggle(arg0_22.pageFooterAdd, false)
		end

		var0_22:RecordFormationTip()
		setActive(arg0_22.pageFooterAdd:Find("tip"), var0_22:ShouldShowFormationTip())
		arg0_22:UpdateSwitchBtns()
	end

	if not var0_22:CanFormation() then
		local var2_22 = var0_22:GetNextFormationTime() - pg.TimeMgr.GetInstance():GetServerTime()

		arg0_22.timer = Timer.New(function()
			arg0_22.timer:Stop()

			arg0_22.timer = nil

			var1_22(true)
		end, var2_22, 1)

		arg0_22.timer:Start()
	else
		var1_22()
	end
end

function var0_0.Flush(arg0_25, arg1_25)
	arg0_25.mission = arg1_25
	arg0_25.canFormationIndex = arg1_25:GetCanFormationIndex()

	arg0_25:InitView()
end

function var0_0.UpdateLayout(arg0_26)
	arg0_26.bg.sprite = GetSpriteFromAtlas("ui/GuildFormationUI_atlas", "bg3")

	local var0_26 = arg0_26:findTF("frame/single")

	arg0_26.shipContainer = var0_26
	arg0_26.bg.gameObject.transform.sizeDelta = Vector2(arg0_26.bg.gameObject.transform.sizeDelta.x, 212)

	setActive(var0_26, true)
end

function var0_0.InitView(arg0_27)
	local var0_27 = arg0_27.mission

	if arg0_27.initId ~= var0_27.id then
		local var1_27 = var0_27:GetAwards()

		arg0_27.awardList:make(function(arg0_28, arg1_28, arg2_28)
			if arg0_28 == UIItemList.EventUpdate then
				local var0_28 = var1_27[arg1_28 + 1]
				local var1_28 = {
					type = var0_28[1],
					id = var0_28[2],
					count = var0_28[3]
				}

				updateDrop(arg2_28, var1_28)
				onButton(arg0_27, arg2_28, function()
					arg0_27:send(BaseUI.ON_DROP, var1_28)
				end, SFX_PANEL)
			end
		end)
		arg0_27.awardList:align(#var1_27)

		arg0_27.battleAreaTxt.text = var0_27:getConfig("ship_camp_display")
		arg0_27.battleTypeTxt.text = var0_27:getConfig("ship_type_display")
		arg0_27.titleTxt.text = var0_27:GetName()
		arg0_27.initId = var0_27.id
	end
end

function var0_0.UpdateFleet(arg0_30, arg1_30)
	arg0_30:ClearSlots()

	local var0_30 = arg0_30.mission
	local var1_30 = arg0_30.maxShipCnt
	local var2_30

	if arg1_30 == arg0_30.canFormationIndex then
		var2_30 = arg0_30.contextData.missionShips or var0_30:GetFleetByIndex(arg1_30)
	else
		var2_30 = var0_30:GetFleetByIndex(arg1_30)
	end

	local var3_30 = {}

	var2_30 = var2_30 or {}

	for iter0_30 = 1, var1_30 do
		local var4_30 = arg0_30.shipContainer:GetChild(iter0_30 - 1)

		table.insert(var3_30, function(arg0_31)
			arg0_30:UpdateShipSlot(iter0_30, var4_30, var2_30, arg0_31)
		end)
	end

	pg.UIMgr:GetInstance():LoadingOn(false)
	parallelAsync(var3_30, function()
		pg.UIMgr:GetInstance():LoadingOff()
	end)

	if var0_30:IsEliteType() then
		local var5_30 = arg0_30:GetTagShipCnt(var2_30)
		local var6_30 = var0_30:GetSquadronTargetCnt()
		local var7_30 = var6_30 <= var5_30 and COLOR_GREEN or COLOR_RED
		local var8_30 = var0_30:GetSquadronDisplay()
		local var9_30 = string.format("%s : (<color=%s>%d/%d</color>)", var8_30, var7_30, var5_30, var6_30)

		arg0_30.target2Text.text = HXSet.hxLan(var9_30)
		arg0_30.target2Text4Effect.text = HXSet.hxLan(var9_30)
	else
		arg0_30.target2Text.text = ""
		arg0_30.target2Text4Effect.text = ""
	end

	local var10_30 = GuildMission.CalcMyEffect(var2_30)

	arg0_30.effectTxt.text = var10_30

	local var11_30 = arg0_30:CalcEffectAddition(var2_30)
	local var12_30, var13_30, var14_30 = arg0_30:CalcScoreAddition(var2_30)

	arg0_30.scoreAdditionTxt.text = i18n("guild_word_score_addition") .. var12_30
	arg0_30.effectAdditionTxt.text = i18n("guild_word_effect_addition") .. var11_30

	local var15_30 = arg0_30:GetBattleTarget(var13_30, var14_30)

	arg0_30.target1Text.text = table.concat(var15_30, " 、")
	arg0_30.target1Text4Effect.text = arg0_30.target1Text.text

	setButtonEnabled(arg0_30.goBtn, #var2_30 > 0)

	local var16_30 = var0_30:GetFleetCnt()
	local var17_30 = not var0_30:CanFormation() or arg1_30 <= var16_30

	setActive(arg0_30.inProgressBtn, var17_30)
	setActive(arg0_30.goBtn, not var17_30)

	arg0_30.contextData.index = arg1_30

	if arg0_30.target2Text.text ~= "" and arg0_30.target1Text.text ~= "" then
		setText(arg0_30:findTF("frame/bottom/desc/target/content/title"), i18n("guild_wrod_battle_target"))
	else
		setText(arg0_30:findTF("frame/bottom/desc/target/content/title"), "")
	end
end

function var0_0.UpdateShipSlot(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33)
	local var0_33 = arg0_33.mission
	local var1_33 = arg3_33[arg1_33]
	local var2_33 = arg2_33:Find("Image")
	local var3_33 = arg2_33:Find("effect")
	local var4_33 = arg2_33:Find("score")

	if var1_33 then
		local var5_33 = getProxy(BayProxy):getShipById(var1_33)

		if var5_33 then
			local var6_33 = var5_33:getPrefab()

			PoolMgr.GetInstance():GetSpineChar(var6_33, true, function(arg0_34)
				arg0_34.name = var6_33
				tf(arg0_34).pivot = Vector2(0.5, 0)
				tf(arg0_34).sizeDelta = Vector2(200, 300)

				SetParent(arg0_34, arg2_33)

				tf(arg0_34).localPosition = Vector3(0, 0, 0)
				tf(arg0_34).localScale = Vector3(0.6, 0.6, 0.6)

				SetAction(arg0_34, "stand")
				GetOrAddComponent(arg0_34, "EventTriggerListener"):AddPointClickFunc(function(arg0_35, arg1_35)
					arg0_33:emit(GuildEventMediator.ON_SELECT_MISSION_SHIP, var0_33.id, arg1_33, arg3_33)
				end)

				arg0_33.shipGos[var1_33] = arg0_34

				if arg4_33 then
					arg4_33()
				end
			end)
			setActive(var3_33, arg0_33:HasEffectAddition(var5_33))
			setActive(var4_33, arg0_33:HasScoreAddition(var5_33))
		elseif arg4_33 then
			arg4_33()
		end
	else
		onButton(arg0_33, var2_33, function()
			arg0_33:emit(GuildEventMediator.ON_SELECT_MISSION_SHIP, var0_33.id, arg1_33, arg3_33)
		end, SFX_PANEL)
		setActive(var3_33, false)
		setActive(var4_33, false)

		if arg4_33 then
			arg4_33()
		end
	end

	setActive(var2_33, not var1_33)
end

function var0_0.CheckFormation(arg0_37)
	local var0_37 = arg0_37.mission

	if arg0_37.contextData.index ~= arg0_37.canFormationIndex then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_curr_fleet_can_not_edit"))

		return false
	end

	local var1_37, var2_37 = arg0_37.mission:CanFormation()

	if not var1_37 then
		if var2_37 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_next_edit_fleet_time", var2_37))
		end

		return false
	end

	return true
end

function var0_0.emit(arg0_38, ...)
	if arg0_38.loading then
		return
	end

	if not arg0_38:CheckFormation() then
		return
	end

	var0_0.super.emit(arg0_38, ...)
end

function var0_0.send(arg0_39, ...)
	var0_0.super.emit(arg0_39, ...)
end

function var0_0.GetBattleTarget(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg0_40.mission
	local var1_40 = var0_40:GetAttrCntAcc()
	local var2_40 = var0_40:GetAttrAcc()
	local var3_40 = {}

	for iter0_40, iter1_40 in pairs(var1_40) do
		local var4_40 = arg1_40[iter0_40] or 0

		table.insert(var3_40, GuildMissionInfoPage.AttrCnt2Desc(iter0_40, {
			value = iter1_40.value + var4_40,
			total = iter1_40.total,
			goal = iter1_40.goal,
			score = iter1_40.score
		}))
	end

	for iter2_40, iter3_40 in pairs(var2_40) do
		local var5_40 = arg2_40[iter2_40] or 0

		table.insert(var3_40, GuildMissionInfoPage.AttrAcc2Desc(iter2_40, {
			value = iter3_40.value + var5_40,
			op = iter3_40.op,
			goal = iter3_40.goal,
			score = iter3_40.score
		}))
	end

	return var3_40
end

function var0_0.GetTagShipCnt(arg0_41, arg1_41)
	local var0_41 = arg0_41.mission:GetSquadron()
	local var1_41 = 0
	local var2_41 = getProxy(BayProxy)

	for iter0_41, iter1_41 in ipairs(arg1_41) do
		local var3_41 = var2_41:getShipById(iter1_41)

		if var3_41 and var3_41:IsTagShip(var0_41) then
			var1_41 = var1_41 + 1
		end
	end

	return var1_41
end

function var0_0.CalcScoreAddition(arg0_42, arg1_42)
	local var0_42 = arg0_42.mission
	local var1_42 = var0_42:GetAttrCntAcc()
	local var2_42 = var0_42:GetAttrAcc()
	local var3_42 = pg.attribute_info_by_type
	local var4_42 = 0
	local var5_42 = {}
	local var6_42 = {}
	local var7_42 = getProxy(BayProxy)

	for iter0_42, iter1_42 in ipairs(arg1_42) do
		local var8_42 = var7_42:getShipById(iter1_42)
		local var9_42

		if var8_42 then
			var9_42 = _.detect(var0_42:getConfig("ship_camp_effect"), function(arg0_43)
				return arg0_43[1] == var8_42:getNation()
			end)
		end

		if var9_42 then
			var4_42 = var4_42 + var9_42[2]
		end

		local var10_42 = var8_42 and var8_42:getProperties() or {}

		for iter2_42, iter3_42 in pairs(var1_42) do
			if (var10_42[var3_42[iter2_42].name] or 0) >= iter3_42.total then
				var5_42[iter2_42] = (var5_42[iter2_42] or 0) + 1
			end
		end

		for iter4_42, iter5_42 in pairs(var2_42) do
			local var11_42 = var3_42[iter4_42].name

			var6_42[iter4_42] = (var6_42[iter4_42] or 0) + (var10_42[var11_42] or 0)
		end
	end

	for iter6_42, iter7_42 in pairs(var1_42) do
		if (var5_42[iter6_42] or 0) + iter7_42.value >= iter7_42.goal then
			var4_42 = var4_42 + iter7_42.score
		end
	end

	for iter8_42, iter9_42 in pairs(var2_42) do
		local var12_42 = iter9_42.value + (var6_42[iter8_42] or 0)
		local var13_42

		if iter9_42.op == 1 then
			var13_42 = var12_42 >= iter9_42.goal
		elseif iter9_42.op == 2 then
			var13_42 = var12_42 <= iter9_42.goal
		end

		if var13_42 then
			var4_42 = var4_42 + iter9_42.score
		end
	end

	return var4_42, var5_42, var6_42
end

function var0_0.CalcEffectAddition(arg0_44, arg1_44)
	local var0_44 = arg0_44.mission
	local var1_44 = GuildMission.CalcMyEffect(arg1_44)
	local var2_44 = getProxy(BayProxy)

	for iter0_44, iter1_44 in ipairs(arg1_44) do
		local var3_44 = var2_44:getShipById(iter1_44)
		local var4_44

		if var3_44 then
			var4_44 = _.detect(var0_44:getConfig("ship_type_effect"), function(arg0_45)
				return arg0_45[1] == var3_44:getShipType()
			end)
		end

		if var4_44 then
			var1_44 = var1_44 + var4_44[2]
		end
	end

	local var5_44 = arg0_44:GetTagShipCnt(arg1_44)
	local var6_44 = var0_44:GetSquadronTargetCnt()
	local var7_44 = 1

	if var6_44 <= var5_44 and var0_44:IsEliteType() then
		var7_44 = var0_44:GetSquadronRatio()
	end

	return var1_44 * var7_44
end

function var0_0.HasScoreAddition(arg0_46, arg1_46)
	local var0_46 = arg0_46.mission
	local var1_46 = var0_46:GetRecommendShipNation()
	local var2_46 = var0_46:GetAttrCntAcc()
	local var3_46 = var0_46:GetAttrAcc()

	local function var4_46()
		local var0_47 = arg1_46:getProperties()
		local var1_47 = pg.attribute_info_by_type

		for iter0_47, iter1_47 in pairs(var2_46) do
			local var2_47 = var1_47[iter0_47].name

			assert(var0_47[var2_47], var2_47)

			if (var0_47[var2_47] or 0) >= iter1_47.total then
				return true
			end
		end

		for iter2_47, iter3_47 in pairs(var3_46) do
			local var3_47 = var1_47[iter2_47].name

			assert(var0_47[var3_47], var3_47)

			if iter3_47.op == 1 then
				return (var0_47[var3_47] or 0) > 0
			elseif iter3_47.op == 2 then
				return (var0_47[var3_47] or 0) == 0
			end
		end

		return false
	end

	return table.contains(var1_46, arg1_46:getNation()) or var4_46()
end

function var0_0.HasEffectAddition(arg0_48, arg1_48)
	local var0_48 = arg0_48.mission
	local var1_48 = var0_48:GetRecommendShipTypes()
	local var2_48 = var0_48:GetSquadron()

	return table.contains(var1_48, arg1_48:getShipType()) or arg1_48:IsTagShip(var2_48)
end

function var0_0.ClearSlots(arg0_49)
	for iter0_49, iter1_49 in pairs(arg0_49.shipGos) do
		tf(iter1_49).pivot = Vector2(0.5, 0.5)

		GetOrAddComponent(iter1_49, "EventTriggerListener"):RemovePointClickFunc()
		iter1_49:GetComponent(typeof(SpineAnimUI)):SetActionCallBack(nil)
		PoolMgr.GetInstance():ReturnSpineChar(iter1_49.name, iter1_49)
	end

	arg0_49.shipGos = {}
end

function var0_0.Hide(arg0_50)
	var0_0.super.Hide(arg0_50)
	arg0_50:ClearSlots()

	if arg0_50.timer then
		arg0_50.timer:Stop()

		arg0_50.timer = nil
	end
end

return var0_0
