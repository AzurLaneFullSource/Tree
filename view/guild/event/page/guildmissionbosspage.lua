local var0_0 = class("GuildMissionBossPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "GuildMissionBossPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.hp = arg0_2:findTF("hp/bar")
	arg0_2.hpProgress = arg0_2:findTF("hp/bar/Text"):GetComponent(typeof(Text))
	arg0_2.hpL = arg0_2.hp.rect.width
	arg0_2.titleTxt = arg0_2:findTF("title"):GetComponent(typeof(Text))
	arg0_2.assaultBtn = arg0_2:findTF("btn_a_formation")
	arg0_2.battleBtn = arg0_2:findTF("btn_go")
	arg0_2.reportBtn = arg0_2:findTF("btn_report")
	arg0_2.reportTip = arg0_2:findTF("btn_report/tip")
	arg0_2.reportTipTxt = arg0_2:findTF("btn_report/tip/Text"):GetComponent(typeof(Text))
	arg0_2.cntTxt = arg0_2:findTF("btn_go/cnt/Text"):GetComponent(typeof(Text))
	arg0_2.rankList = UIItemList.New(arg0_2:findTF("rank/content"), arg0_2:findTF("rank/content/tpl"))
	arg0_2.paintingTF = arg0_2:findTF("painting")
	arg0_2.prefabTF = arg0_2:findTF("prefab")
	arg0_2.viewAllBtn = arg0_2:findTF("rank/view_all")
	arg0_2.allRankPage = GuildBossRankPage.New(arg0_2._parentTf, arg0_2.event)

	setActive(arg0_2.viewAllBtn, PLATFORM_CODE ~= PLATFORM_JP)

	arg0_2.eventTimerTxt = arg0_2:findTF("timer/Text"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("timer/label"), i18n("guild_time_remaining_tip"))

	arg0_2.timeView = GuildEventTimerView.New()
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.assaultBtn, function()
		arg0_3:emit(GuildEventLayer.OPEN_BOSS_ASSULT)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.battleBtn, function()
		if not arg0_3:ExistActiveEvent() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_battle_is_end"))

			return
		end

		if arg0_3.bossMission:IsReachDailyCnt() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_boss_cnt_no_enough"))

			return
		end

		if arg0_3.bossMission:IsDeath() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_battle_is_end"))

			return
		end

		arg0_3:emit(GuildEventLayer.ON_OPEN_BOSS_FORMATION, arg0_3.bossMission)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.reportBtn, function()
		arg0_3:emit(GuildEventMediator.ON_OPEN_REPORT)
	end, SFX_PANEL)
end

function var0_0.UpdateMission(arg0_7, arg1_7)
	arg0_7.bossMission = arg1_7
end

function var0_0.OnReportUpdated(arg0_8)
	local var0_8 = getProxy(GuildProxy):GetReports()
	local var1_8 = _.select(_.values(var0_8), function(arg0_9)
		return arg0_9:CanSubmit()
	end)

	setActive(arg0_8.reportTip, #var1_8 > 0)

	if #var1_8 > 0 then
		arg0_8.reportTipTxt.text = #var1_8
	end
end

function var0_0.Show(arg0_10, arg1_10)
	arg0_10:UpdateMission(arg1_10)
	arg0_10:InitRanks()
	arg0_10:UpdateView()
	arg0_10:UpdatePainting()

	if arg0_10.contextData.editBossFleet then
		triggerButton(arg0_10.battleBtn)
	end

	local var0_10 = arg1_10:IsReachDailyCnt()

	setActive(arg0_10.battleBtn:Find("selected"), var0_10)
	arg0_10:OnReportUpdated()

	arg0_10.titleTxt.text = arg1_10:getConfig("name")

	arg0_10:CheckFleetShipState()
	arg0_10.timeView:Flush(arg0_10.eventTimerTxt, getProxy(GuildProxy):getRawData():GetActiveEvent())
end

function var0_0.CheckFleetShipState(arg0_11)
	local var0_11 = arg0_11.bossMission
	local var1_11 = {
		var0_11:GetMainFleet(),
		var0_11:GetSubFleet()
	}
	local var2_11 = {}

	for iter0_11, iter1_11 in ipairs(var1_11) do
		if iter1_11:ExistInvailShips() or iter1_11:ExistInvaildCommanders() then
			table.insert(var2_11, iter1_11)
		end
	end

	if #var2_11 > 0 then
		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("guild_boss_formation_exist_invaild_ship")
		})

		arg0_11.contextData.editBossFleet = {}

		for iter2_11, iter3_11 in ipairs(var2_11) do
			arg0_11.contextData.editBossFleet[iter3_11.id] = iter3_11
		end

		arg0_11:emit(GuildEventMediator.ON_CLEAR_BOSS_FLEET_INVAILD_SHIP)
	end
end

function var0_0.UpdateView(arg0_12)
	if getProxy(GuildProxy):ShouldRefreshBoss() then
		arg0_12:emit(GuildEventMediator.ON_GET_BOSS_INFO)
	else
		arg0_12:UpdateBossInfo()
		arg0_12:AddBossTimer()
		var0_0.super.Show(arg0_12)
	end
end

function var0_0.UpdatePainting(arg0_13)
	local var0_13 = arg0_13.bossMission
	local var1_13 = var0_13:GetPainting()
	local var2_13 = var1_13 and var1_13 ~= ""

	if var2_13 then
		setGuildPaintingPrefab(arg0_13.paintingTF, var1_13, "chuanwu", nil)
	else
		local var3_13 = var0_13:GetEmenyId()

		LoadSpriteAsync("guildboss/" .. var3_13, function(arg0_14)
			if arg0_13:CheckState(BaseSubView.STATES.DESTROY) then
				return
			end

			if arg0_14 then
				local var0_14 = GetOrAddComponent(arg0_13.prefabTF:Find("frame/model"), "Image")

				var0_14.sprite = arg0_14

				var0_14:SetNativeSize()
			end
		end)

		local var4_13 = arg0_13:findTF("name/Image", arg0_13.prefabTF):GetComponent(typeof(Image))

		var4_13.sprite = GetSpriteFromAtlas("guildboss/name_" .. var3_13, "")

		var4_13:SetNativeSize()
	end

	setActive(arg0_13.paintingTF, var2_13)
	setActive(arg0_13.prefabTF, not var2_13)
end

function var0_0.UpdateBossInfo(arg0_15)
	local var0_15 = arg0_15.bossMission
	local var1_15 = var0_15:GetHp()
	local var2_15 = var0_15:GetTotalHp()
	local var3_15 = var1_15 / math.max(var2_15, 1)
	local var4_15 = arg0_15.hpL * var3_15
	local var5_15 = tf(arg0_15.hp)

	var5_15.sizeDelta = Vector2(var4_15, var5_15.sizeDelta.y)

	local var6_15 = var3_15 * 100

	arg0_15.hpProgress.text = math.max(var6_15 - var6_15 % 0.1, 1) .. "%"

	local var7_15 = var0_15:GetCanUsageCnt()
	local var8_15 = var7_15 > 0 and COLOR_GREEN or COLOR_RED

	arg0_15.cntTxt.text = "<color=" .. var8_15 .. ">" .. var7_15 .. "</color>/" .. GuildConst.MISSION_BOSS_MAX_CNT()
end

function var0_0.InitRanks(arg0_16)
	if getProxy(GuildProxy):ShouldRefreshBossRank() then
		arg0_16:emit(GuildEventMediator.ON_REFRESH_BOSS_RANK)
	else
		arg0_16:UpdateRank()
		arg0_16:AddRankTimer()
	end
end

function var0_0.UpdateRank(arg0_17)
	local var0_17 = getProxy(GuildProxy):GetBossRank()

	table.sort(var0_17, function(arg0_18, arg1_18)
		return arg0_18.damage > arg1_18.damage
	end)
	arg0_17.rankList:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = var0_17[arg1_19 + 1]

			setText(arg2_19:Find("no"), arg1_19 + 1)
			setText(arg2_19:Find("name"), var0_19.name)
			setText(arg2_19:Find("Text"), var0_19.damage)
		end
	end)
	arg0_17.rankList:align(math.min(3, #var0_17))
	onButton(arg0_17, arg0_17.viewAllBtn, function()
		arg0_17.allRankPage:ExecuteAction("Show", var0_17)
	end, SFX_PANEL)
end

function var0_0.ExistActiveEvent(arg0_21)
	local var0_21 = getProxy(GuildProxy):getRawData():GetActiveEvent()

	return var0_21 and not var0_21:IsExpired()
end

function var0_0.AddRankTimer(arg0_22)
	if not arg0_22:ExistActiveEvent() then
		return
	end

	if arg0_22.rankTimer then
		arg0_22.rankTimer:Stop()

		arg0_22.rankTimer = nil
	end

	local var0_22 = arg0_22.bossMission

	arg0_22.rankTimer = Timer.New(function()
		arg0_22:emit(GuildEventMediator.ON_REFRESH_BOSS_RANK)
	end, GuildConst.FORCE_REFRESH_MISSION_BOSS_RANK_TIME, 1)

	arg0_22.rankTimer:Start()
end

function var0_0.AddBossTimer(arg0_24)
	if not arg0_24:ExistActiveEvent() then
		return
	end

	if arg0_24.bossTimer then
		arg0_24.bossTimer:Stop()

		arg0_24.bossTimer = nil
	end

	arg0_24.bossTimer = Timer.New(function()
		arg0_24:emit(GuildEventMediator.ON_GET_BOSS_INFO)
	end, GuildConst.FORCE_REFRESH_BOSS_TIME, 1)

	arg0_24.bossTimer:Start()
end

function var0_0.OnDestroy(arg0_26)
	if arg0_26.rankTimer then
		arg0_26.rankTimer:Stop()

		arg0_26.rankTimer = nil
	end

	if arg0_26.bossTimer then
		arg0_26.bossTimer:Stop()

		arg0_26.bossTimer = nil
	end

	arg0_26.allRankPage:Destroy()
	arg0_26.timeView:Dispose()
end

return var0_0
