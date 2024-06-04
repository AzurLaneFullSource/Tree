local var0 = class("GuildMissionFormationPage", import(".GuildEventBasePage"))

function var0.getUIName(arg0)
	return "GuildMissionFormationPage"
end

function var0.OnRefreshMission(arg0, arg1)
	arg0:Flush(arg1)
end

function var0.OnFormationDone(arg0)
	local var0 = {}

	arg0.loading = true

	for iter0, iter1 in pairs(arg0.shipGos) do
		table.insert(var0, function(arg0)
			local var0 = iter1:GetComponent(typeof(SpineAnimUI))

			var0:SetAction("victory", 0)
			var0:SetActionCallBack(function(arg0)
				if arg0 == "finish" then
					var0:SetActionCallBack(nil)
					var0:SetAction("stand", 0)
					arg0()
				end
			end)
		end)
	end

	parallelAsync(var0, function()
		arg0:Hide()

		arg0.loading = false
	end)

	local var1 = arg0.canFormationIndex or 1

	for iter2, iter3 in ipairs(arg0.pageFooter) do
		setActive(iter3, iter2 <= var1)
	end

	setActive(arg0.pageFooterAdd, false)
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("frame/close")
	arg0.titleTxt = arg0:findTF("frame/title"):GetComponent(typeof(Text))
	arg0.recomBtn = arg0:findTF("frame/recom")
	arg0.clearBtn = arg0:findTF("frame/clear")
	arg0.goBtn = arg0:findTF("frame/bottom/go")
	arg0.inProgressBtn = arg0:findTF("frame/bottom/doingBtn")
	arg0.battleAreaTxt = arg0:findTF("frame/bottom/desc/area/Text"):GetComponent(typeof(Text))
	arg0.battleTypeTxt = arg0:findTF("frame/bottom/desc/type/Text"):GetComponent(typeof(Text))
	arg0.awardList = UIItemList.New(arg0:findTF("frame/bottom/award/list"), arg0:findTF("frame/bottom/award/list/item"))
	arg0.target1Text = arg0:findTF("frame/bottom/desc/target/content/Text"):GetComponent(typeof(Text))
	arg0.target2Text = arg0:findTF("frame/bottom/desc/target/content/Text2"):GetComponent(typeof(Text))
	arg0.target1Text4Effect = arg0:findTF("frame/bottom/desc/target/content1/Text"):GetComponent(typeof(Text))
	arg0.target2Text4Effect = arg0:findTF("frame/bottom/desc/target/content1/Text2"):GetComponent(typeof(Text))
	arg0.scoreAdditionTxt = arg0:findTF("frame/bottom/score_addition/Text"):GetComponent(typeof(Text))
	arg0.effectAdditionTxt = arg0:findTF("frame/bottom/effect_addition/Text"):GetComponent(typeof(Text))
	arg0.effectTxt = arg0:findTF("frame/bottom/effect/Text"):GetComponent(typeof(Text))
	arg0.bg = arg0:findTF("frame/bottom/bg"):GetComponent(typeof(Image))
	arg0.pageFooter = {
		arg0:findTF("frame/single/dot/1"),
		arg0:findTF("frame/single/dot/2"),
		arg0:findTF("frame/single/dot/3"),
		arg0:findTF("frame/single/dot/4")
	}
	arg0.pageFooterAdd = arg0:findTF("frame/single/dot/add")
	arg0.nextBtn = arg0:findTF("frame/single/next")
	arg0.prevBtn = arg0:findTF("frame/single/prev")

	setText(arg0:findTF("frame/bottom/desc/area"), i18n("guild_word_battle_area"))
	setText(arg0:findTF("frame/bottom/desc/type"), i18n("guild_word_battle_type"))
end

function var0.OnInit(arg0)
	local function var0()
		if arg0.contextData.index > 1 then
			triggerToggle(arg0.pageFooter[arg0.contextData.index - 1], true)
		end
	end

	local function var1()
		if arg0.contextData.index < arg0.mission:GetMaxFleet() then
			local var0 = arg0.contextData.index + 1

			if var0 > arg0.mission:GetFleetCnt() then
				triggerToggle(arg0.pageFooterAdd, true)
			else
				triggerToggle(arg0.pageFooter[var0], true)
			end
		end
	end

	addSlip(SLIP_TYPE_HRZ, arg0:findTF("frame"), var0, var1)
	onButton(arg0, arg0.nextBtn, var1, SFX_PANEL)
	onButton(arg0, arg0.prevBtn, var0, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0.contextData.missionShips = nil

		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.recomBtn, function()
		if not arg0:CheckFormation() then
			return
		end

		arg0:emit(GuildEventMediator.ON_GET_FORMATION, function()
			local var0 = getProxy(GuildProxy):GetRecommendShipsForMission(arg0.mission)

			if #var0 == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_recomm_ship_failed"))

				return
			end

			arg0.contextData.missionShips = var0

			arg0:UpdateFleet(arg0.contextData.index)
		end)
	end, SFX_PANEL)
	onButton(arg0, arg0.clearBtn, function()
		if not arg0:CheckFormation() then
			return
		end

		arg0.contextData.missionShips = {}

		arg0:UpdateFleet(arg0.contextData.index)
	end, SFX_PANEL)
	onButton(arg0, arg0.goBtn, function()
		if arg0.mission:IsFinish() then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_event_is_finish"))

			return
		end

		if not arg0:CheckFormation() then
			return
		end

		if not arg0.contextData.missionShips or #arg0.contextData.missionShips == 0 then
			return
		end

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_event_start_event_tip"),
			onYes = function()
				arg0:emit(GuildEventMediator.JOIN_MISSION, arg0.mission.id, arg0.contextData.missionShips)
			end
		})
	end, SFX_PANEL)

	arg0.shipGos = {}
end

function var0.OnShow(arg0)
	arg0.loading = nil
	arg0.maxShipCnt = arg0.extraData.shipCnt

	local var0 = arg0.extraData.mission

	arg0:UpdateLayout()
	arg0:Flush(var0)
	arg0:UpdatePageFooter()
	arg0:AddNextFormationTimer()
end

function var0.UpdatePageFooter(arg0)
	local var0 = arg0.mission
	local var1 = var0:CanFormation()
	local var2 = var0:GetFleetCnt()

	for iter0, iter1 in ipairs(arg0.pageFooter) do
		setActive(iter1, iter0 <= var2)
		onToggle(arg0, iter1, function(arg0)
			if arg0 then
				arg0:UpdateFleet(iter0)
				arg0:UpdateSwitchBtns()
			end
		end, SFX_PANEL)
	end

	setActive(arg0.pageFooterAdd, var1)
	onToggle(arg0, arg0.pageFooterAdd, function(arg0)
		if arg0 then
			arg0:UpdateFleet(var2 + 1)
		end
	end, SFX_PANEL)

	local var3 = arg0.contextData.index or 1

	if var2 < var3 then
		triggerToggle(arg0.pageFooterAdd, true)
	else
		triggerToggle(arg0.pageFooter[var3], true)
	end
end

function var0.UpdateSwitchBtns(arg0)
	local var0 = arg0.mission:GetMaxFleet()
	local var1 = arg0.contextData.index

	setActive(arg0.prevBtn, var1 ~= 1)
	setActive(arg0.nextBtn, var1 < var0)
end

function var0.AddNextFormationTimer(arg0)
	local var0 = arg0.mission

	if var0:IsMaxFleetCnt() then
		return
	end

	local function var1(arg0)
		arg0.canFormationIndex = var0:GetCanFormationIndex()

		setActive(arg0.pageFooterAdd, true)

		if arg0 then
			triggerToggle(arg0.pageFooterAdd, false)
		end

		var0:RecordFormationTip()
		setActive(arg0.pageFooterAdd:Find("tip"), var0:ShouldShowFormationTip())
		arg0:UpdateSwitchBtns()
	end

	if not var0:CanFormation() then
		local var2 = var0:GetNextFormationTime() - pg.TimeMgr.GetInstance():GetServerTime()

		arg0.timer = Timer.New(function()
			arg0.timer:Stop()

			arg0.timer = nil

			var1(true)
		end, var2, 1)

		arg0.timer:Start()
	else
		var1()
	end
end

function var0.Flush(arg0, arg1)
	arg0.mission = arg1
	arg0.canFormationIndex = arg1:GetCanFormationIndex()

	arg0:InitView()
end

function var0.UpdateLayout(arg0)
	arg0.bg.sprite = GetSpriteFromAtlas("ui/GuildFormationUI_atlas", "bg3")

	local var0 = arg0:findTF("frame/single")

	arg0.shipContainer = var0
	arg0.bg.gameObject.transform.sizeDelta = Vector2(arg0.bg.gameObject.transform.sizeDelta.x, 212)

	setActive(var0, true)
end

function var0.InitView(arg0)
	local var0 = arg0.mission

	if arg0.initId ~= var0.id then
		local var1 = var0:GetAwards()

		arg0.awardList:make(function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				local var0 = var1[arg1 + 1]
				local var1 = {
					type = var0[1],
					id = var0[2],
					count = var0[3]
				}

				updateDrop(arg2, var1)
				onButton(arg0, arg2, function()
					arg0:send(BaseUI.ON_DROP, var1)
				end, SFX_PANEL)
			end
		end)
		arg0.awardList:align(#var1)

		arg0.battleAreaTxt.text = var0:getConfig("ship_camp_display")
		arg0.battleTypeTxt.text = var0:getConfig("ship_type_display")
		arg0.titleTxt.text = var0:GetName()
		arg0.initId = var0.id
	end
end

function var0.UpdateFleet(arg0, arg1)
	arg0:ClearSlots()

	local var0 = arg0.mission
	local var1 = arg0.maxShipCnt
	local var2

	if arg1 == arg0.canFormationIndex then
		var2 = arg0.contextData.missionShips or var0:GetFleetByIndex(arg1)
	else
		var2 = var0:GetFleetByIndex(arg1)
	end

	local var3 = {}

	var2 = var2 or {}

	for iter0 = 1, var1 do
		local var4 = arg0.shipContainer:GetChild(iter0 - 1)

		table.insert(var3, function(arg0)
			arg0:UpdateShipSlot(iter0, var4, var2, arg0)
		end)
	end

	pg.UIMgr:GetInstance():LoadingOn(false)
	parallelAsync(var3, function()
		pg.UIMgr:GetInstance():LoadingOff()
	end)

	if var0:IsEliteType() then
		local var5 = arg0:GetTagShipCnt(var2)
		local var6 = var0:GetSquadronTargetCnt()
		local var7 = var6 <= var5 and COLOR_GREEN or COLOR_RED
		local var8 = var0:GetSquadronDisplay()
		local var9 = string.format("%s : (<color=%s>%d/%d</color>)", var8, var7, var5, var6)

		arg0.target2Text.text = HXSet.hxLan(var9)
		arg0.target2Text4Effect.text = HXSet.hxLan(var9)
	else
		arg0.target2Text.text = ""
		arg0.target2Text4Effect.text = ""
	end

	local var10 = GuildMission.CalcMyEffect(var2)

	arg0.effectTxt.text = var10

	local var11 = arg0:CalcEffectAddition(var2)
	local var12, var13, var14 = arg0:CalcScoreAddition(var2)

	arg0.scoreAdditionTxt.text = i18n("guild_word_score_addition") .. var12
	arg0.effectAdditionTxt.text = i18n("guild_word_effect_addition") .. var11

	local var15 = arg0:GetBattleTarget(var13, var14)

	arg0.target1Text.text = table.concat(var15, " 、")
	arg0.target1Text4Effect.text = arg0.target1Text.text

	setButtonEnabled(arg0.goBtn, #var2 > 0)

	local var16 = var0:GetFleetCnt()
	local var17 = not var0:CanFormation() or arg1 <= var16

	setActive(arg0.inProgressBtn, var17)
	setActive(arg0.goBtn, not var17)

	arg0.contextData.index = arg1

	if arg0.target2Text.text ~= "" and arg0.target1Text.text ~= "" then
		setText(arg0:findTF("frame/bottom/desc/target/content/title"), i18n("guild_wrod_battle_target"))
	else
		setText(arg0:findTF("frame/bottom/desc/target/content/title"), "")
	end
end

function var0.UpdateShipSlot(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0.mission
	local var1 = arg3[arg1]
	local var2 = arg2:Find("Image")
	local var3 = arg2:Find("effect")
	local var4 = arg2:Find("score")

	if var1 then
		local var5 = getProxy(BayProxy):getShipById(var1)

		if var5 then
			local var6 = var5:getPrefab()

			PoolMgr.GetInstance():GetSpineChar(var6, true, function(arg0)
				arg0.name = var6
				tf(arg0).pivot = Vector2(0.5, 0)
				tf(arg0).sizeDelta = Vector2(200, 300)

				SetParent(arg0, arg2)

				tf(arg0).localPosition = Vector3(0, 0, 0)
				tf(arg0).localScale = Vector3(0.6, 0.6, 0.6)

				SetAction(arg0, "stand")
				GetOrAddComponent(arg0, "EventTriggerListener"):AddPointClickFunc(function(arg0, arg1)
					arg0:emit(GuildEventMediator.ON_SELECT_MISSION_SHIP, var0.id, arg1, arg3)
				end)

				arg0.shipGos[var1] = arg0

				if arg4 then
					arg4()
				end
			end)
			setActive(var3, arg0:HasEffectAddition(var5))
			setActive(var4, arg0:HasScoreAddition(var5))
		elseif arg4 then
			arg4()
		end
	else
		onButton(arg0, var2, function()
			arg0:emit(GuildEventMediator.ON_SELECT_MISSION_SHIP, var0.id, arg1, arg3)
		end, SFX_PANEL)
		setActive(var3, false)
		setActive(var4, false)

		if arg4 then
			arg4()
		end
	end

	setActive(var2, not var1)
end

function var0.CheckFormation(arg0)
	local var0 = arg0.mission

	if arg0.contextData.index ~= arg0.canFormationIndex then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_curr_fleet_can_not_edit"))

		return false
	end

	local var1, var2 = arg0.mission:CanFormation()

	if not var1 then
		if var2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_next_edit_fleet_time", var2))
		end

		return false
	end

	return true
end

function var0.emit(arg0, ...)
	if arg0.loading then
		return
	end

	if not arg0:CheckFormation() then
		return
	end

	var0.super.emit(arg0, ...)
end

function var0.send(arg0, ...)
	var0.super.emit(arg0, ...)
end

function var0.GetBattleTarget(arg0, arg1, arg2)
	local var0 = arg0.mission
	local var1 = var0:GetAttrCntAcc()
	local var2 = var0:GetAttrAcc()
	local var3 = {}

	for iter0, iter1 in pairs(var1) do
		local var4 = arg1[iter0] or 0

		table.insert(var3, GuildMissionInfoPage.AttrCnt2Desc(iter0, {
			value = iter1.value + var4,
			total = iter1.total,
			goal = iter1.goal,
			score = iter1.score
		}))
	end

	for iter2, iter3 in pairs(var2) do
		local var5 = arg2[iter2] or 0

		table.insert(var3, GuildMissionInfoPage.AttrAcc2Desc(iter2, {
			value = iter3.value + var5,
			op = iter3.op,
			goal = iter3.goal,
			score = iter3.score
		}))
	end

	return var3
end

function var0.GetTagShipCnt(arg0, arg1)
	local var0 = arg0.mission:GetSquadron()
	local var1 = 0
	local var2 = getProxy(BayProxy)

	for iter0, iter1 in ipairs(arg1) do
		local var3 = var2:getShipById(iter1)

		if var3 and var3:IsTagShip(var0) then
			var1 = var1 + 1
		end
	end

	return var1
end

function var0.CalcScoreAddition(arg0, arg1)
	local var0 = arg0.mission
	local var1 = var0:GetAttrCntAcc()
	local var2 = var0:GetAttrAcc()
	local var3 = pg.attribute_info_by_type
	local var4 = 0
	local var5 = {}
	local var6 = {}
	local var7 = getProxy(BayProxy)

	for iter0, iter1 in ipairs(arg1) do
		local var8 = var7:getShipById(iter1)
		local var9

		if var8 then
			var9 = _.detect(var0:getConfig("ship_camp_effect"), function(arg0)
				return arg0[1] == var8:getNation()
			end)
		end

		if var9 then
			var4 = var4 + var9[2]
		end

		local var10 = var8 and var8:getProperties() or {}

		for iter2, iter3 in pairs(var1) do
			if (var10[var3[iter2].name] or 0) >= iter3.total then
				var5[iter2] = (var5[iter2] or 0) + 1
			end
		end

		for iter4, iter5 in pairs(var2) do
			local var11 = var3[iter4].name

			var6[iter4] = (var6[iter4] or 0) + (var10[var11] or 0)
		end
	end

	for iter6, iter7 in pairs(var1) do
		if (var5[iter6] or 0) + iter7.value >= iter7.goal then
			var4 = var4 + iter7.score
		end
	end

	for iter8, iter9 in pairs(var2) do
		local var12 = iter9.value + (var6[iter8] or 0)
		local var13

		if iter9.op == 1 then
			var13 = var12 >= iter9.goal
		elseif iter9.op == 2 then
			var13 = var12 <= iter9.goal
		end

		if var13 then
			var4 = var4 + iter9.score
		end
	end

	return var4, var5, var6
end

function var0.CalcEffectAddition(arg0, arg1)
	local var0 = arg0.mission
	local var1 = GuildMission.CalcMyEffect(arg1)
	local var2 = getProxy(BayProxy)

	for iter0, iter1 in ipairs(arg1) do
		local var3 = var2:getShipById(iter1)
		local var4

		if var3 then
			var4 = _.detect(var0:getConfig("ship_type_effect"), function(arg0)
				return arg0[1] == var3:getShipType()
			end)
		end

		if var4 then
			var1 = var1 + var4[2]
		end
	end

	local var5 = arg0:GetTagShipCnt(arg1)
	local var6 = var0:GetSquadronTargetCnt()
	local var7 = 1

	if var6 <= var5 and var0:IsEliteType() then
		var7 = var0:GetSquadronRatio()
	end

	return var1 * var7
end

function var0.HasScoreAddition(arg0, arg1)
	local var0 = arg0.mission
	local var1 = var0:GetRecommendShipNation()
	local var2 = var0:GetAttrCntAcc()
	local var3 = var0:GetAttrAcc()

	local function var4()
		local var0 = arg1:getProperties()
		local var1 = pg.attribute_info_by_type

		for iter0, iter1 in pairs(var2) do
			local var2 = var1[iter0].name

			assert(var0[var2], var2)

			if (var0[var2] or 0) >= iter1.total then
				return true
			end
		end

		for iter2, iter3 in pairs(var3) do
			local var3 = var1[iter2].name

			assert(var0[var3], var3)

			if iter3.op == 1 then
				return (var0[var3] or 0) > 0
			elseif iter3.op == 2 then
				return (var0[var3] or 0) == 0
			end
		end

		return false
	end

	return table.contains(var1, arg1:getNation()) or var4()
end

function var0.HasEffectAddition(arg0, arg1)
	local var0 = arg0.mission
	local var1 = var0:GetRecommendShipTypes()
	local var2 = var0:GetSquadron()

	return table.contains(var1, arg1:getShipType()) or arg1:IsTagShip(var2)
end

function var0.ClearSlots(arg0)
	for iter0, iter1 in pairs(arg0.shipGos) do
		tf(iter1).pivot = Vector2(0.5, 0.5)

		GetOrAddComponent(iter1, "EventTriggerListener"):RemovePointClickFunc()
		iter1:GetComponent(typeof(SpineAnimUI)):SetActionCallBack(nil)
		PoolMgr.GetInstance():ReturnSpineChar(iter1.name, iter1)
	end

	arg0.shipGos = {}
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	arg0:ClearSlots()

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

return var0
