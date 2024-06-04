local var0 = class("GuildMissionBossPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "GuildMissionBossPage"
end

function var0.OnLoaded(arg0)
	arg0.hp = arg0:findTF("hp/bar")
	arg0.hpProgress = arg0:findTF("hp/bar/Text"):GetComponent(typeof(Text))
	arg0.hpL = arg0.hp.rect.width
	arg0.titleTxt = arg0:findTF("title"):GetComponent(typeof(Text))
	arg0.assaultBtn = arg0:findTF("btn_a_formation")
	arg0.battleBtn = arg0:findTF("btn_go")
	arg0.reportBtn = arg0:findTF("btn_report")
	arg0.reportTip = arg0:findTF("btn_report/tip")
	arg0.reportTipTxt = arg0:findTF("btn_report/tip/Text"):GetComponent(typeof(Text))
	arg0.cntTxt = arg0:findTF("btn_go/cnt/Text"):GetComponent(typeof(Text))
	arg0.rankList = UIItemList.New(arg0:findTF("rank/content"), arg0:findTF("rank/content/tpl"))
	arg0.paintingTF = arg0:findTF("painting")
	arg0.prefabTF = arg0:findTF("prefab")
	arg0.viewAllBtn = arg0:findTF("rank/view_all")
	arg0.allRankPage = GuildBossRankPage.New(arg0._parentTf, arg0.event)

	setActive(arg0.viewAllBtn, PLATFORM_CODE ~= PLATFORM_JP)

	arg0.eventTimerTxt = arg0:findTF("timer/Text"):GetComponent(typeof(Text))

	setText(arg0:findTF("timer/label"), i18n("guild_time_remaining_tip"))

	arg0.timeView = GuildEventTimerView.New()
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.assaultBtn, function()
		arg0:emit(GuildEventLayer.OPEN_BOSS_ASSULT)
	end, SFX_PANEL)
	onButton(arg0, arg0.battleBtn, function()
		if not arg0:ExistActiveEvent() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_battle_is_end"))

			return
		end

		if arg0.bossMission:IsReachDailyCnt() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_boss_cnt_no_enough"))

			return
		end

		if arg0.bossMission:IsDeath() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_battle_is_end"))

			return
		end

		arg0:emit(GuildEventLayer.ON_OPEN_BOSS_FORMATION, arg0.bossMission)
	end, SFX_PANEL)
	onButton(arg0, arg0.reportBtn, function()
		arg0:emit(GuildEventMediator.ON_OPEN_REPORT)
	end, SFX_PANEL)
end

function var0.UpdateMission(arg0, arg1)
	arg0.bossMission = arg1
end

function var0.OnReportUpdated(arg0)
	local var0 = getProxy(GuildProxy):GetReports()
	local var1 = _.select(_.values(var0), function(arg0)
		return arg0:CanSubmit()
	end)

	setActive(arg0.reportTip, #var1 > 0)

	if #var1 > 0 then
		arg0.reportTipTxt.text = #var1
	end
end

function var0.Show(arg0, arg1)
	arg0:UpdateMission(arg1)
	arg0:InitRanks()
	arg0:UpdateView()
	arg0:UpdatePainting()

	if arg0.contextData.editBossFleet then
		triggerButton(arg0.battleBtn)
	end

	local var0 = arg1:IsReachDailyCnt()

	setActive(arg0.battleBtn:Find("selected"), var0)
	arg0:OnReportUpdated()

	arg0.titleTxt.text = arg1:getConfig("name")

	arg0:CheckFleetShipState()
	arg0.timeView:Flush(arg0.eventTimerTxt, getProxy(GuildProxy):getRawData():GetActiveEvent())
end

function var0.CheckFleetShipState(arg0)
	local var0 = arg0.bossMission
	local var1 = {
		var0:GetMainFleet(),
		var0:GetSubFleet()
	}
	local var2 = {}

	for iter0, iter1 in ipairs(var1) do
		if iter1:ExistInvailShips() or iter1:ExistInvaildCommanders() then
			table.insert(var2, iter1)
		end
	end

	if #var2 > 0 then
		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("guild_boss_formation_exist_invaild_ship")
		})

		arg0.contextData.editBossFleet = {}

		for iter2, iter3 in ipairs(var2) do
			arg0.contextData.editBossFleet[iter3.id] = iter3
		end

		arg0:emit(GuildEventMediator.ON_CLEAR_BOSS_FLEET_INVAILD_SHIP)
	end
end

function var0.UpdateView(arg0)
	if getProxy(GuildProxy):ShouldRefreshBoss() then
		arg0:emit(GuildEventMediator.ON_GET_BOSS_INFO)
	else
		arg0:UpdateBossInfo()
		arg0:AddBossTimer()
		var0.super.Show(arg0)
	end
end

function var0.UpdatePainting(arg0)
	local var0 = arg0.bossMission
	local var1 = var0:GetPainting()
	local var2 = var1 and var1 ~= ""

	if var2 then
		setGuildPaintingPrefab(arg0.paintingTF, var1, "chuanwu", nil)
	else
		local var3 = var0:GetEmenyId()

		LoadSpriteAsync("guildboss/" .. var3, function(arg0)
			if arg0:CheckState(BaseSubView.STATES.DESTROY) then
				return
			end

			if arg0 then
				local var0 = GetOrAddComponent(arg0.prefabTF:Find("frame/model"), "Image")

				var0.sprite = arg0

				var0:SetNativeSize()
			end
		end)

		local var4 = arg0:findTF("name/Image", arg0.prefabTF):GetComponent(typeof(Image))

		var4.sprite = GetSpriteFromAtlas("guildboss/name_" .. var3, "")

		var4:SetNativeSize()
	end

	setActive(arg0.paintingTF, var2)
	setActive(arg0.prefabTF, not var2)
end

function var0.UpdateBossInfo(arg0)
	local var0 = arg0.bossMission
	local var1 = var0:GetHp()
	local var2 = var0:GetTotalHp()
	local var3 = var1 / math.max(var2, 1)
	local var4 = arg0.hpL * var3
	local var5 = tf(arg0.hp)

	var5.sizeDelta = Vector2(var4, var5.sizeDelta.y)

	local var6 = var3 * 100

	arg0.hpProgress.text = math.max(var6 - var6 % 0.1, 1) .. "%"

	local var7 = var0:GetCanUsageCnt()
	local var8 = var7 > 0 and COLOR_GREEN or COLOR_RED

	arg0.cntTxt.text = "<color=" .. var8 .. ">" .. var7 .. "</color>/" .. GuildConst.MISSION_BOSS_MAX_CNT()
end

function var0.InitRanks(arg0)
	if getProxy(GuildProxy):ShouldRefreshBossRank() then
		arg0:emit(GuildEventMediator.ON_REFRESH_BOSS_RANK)
	else
		arg0:UpdateRank()
		arg0:AddRankTimer()
	end
end

function var0.UpdateRank(arg0)
	local var0 = getProxy(GuildProxy):GetBossRank()

	table.sort(var0, function(arg0, arg1)
		return arg0.damage > arg1.damage
	end)
	arg0.rankList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			setText(arg2:Find("no"), arg1 + 1)
			setText(arg2:Find("name"), var0.name)
			setText(arg2:Find("Text"), var0.damage)
		end
	end)
	arg0.rankList:align(math.min(3, #var0))
	onButton(arg0, arg0.viewAllBtn, function()
		arg0.allRankPage:ExecuteAction("Show", var0)
	end, SFX_PANEL)
end

function var0.ExistActiveEvent(arg0)
	local var0 = getProxy(GuildProxy):getRawData():GetActiveEvent()

	return var0 and not var0:IsExpired()
end

function var0.AddRankTimer(arg0)
	if not arg0:ExistActiveEvent() then
		return
	end

	if arg0.rankTimer then
		arg0.rankTimer:Stop()

		arg0.rankTimer = nil
	end

	local var0 = arg0.bossMission

	arg0.rankTimer = Timer.New(function()
		arg0:emit(GuildEventMediator.ON_REFRESH_BOSS_RANK)
	end, GuildConst.FORCE_REFRESH_MISSION_BOSS_RANK_TIME, 1)

	arg0.rankTimer:Start()
end

function var0.AddBossTimer(arg0)
	if not arg0:ExistActiveEvent() then
		return
	end

	if arg0.bossTimer then
		arg0.bossTimer:Stop()

		arg0.bossTimer = nil
	end

	arg0.bossTimer = Timer.New(function()
		arg0:emit(GuildEventMediator.ON_GET_BOSS_INFO)
	end, GuildConst.FORCE_REFRESH_BOSS_TIME, 1)

	arg0.bossTimer:Start()
end

function var0.OnDestroy(arg0)
	if arg0.rankTimer then
		arg0.rankTimer:Stop()

		arg0.rankTimer = nil
	end

	if arg0.bossTimer then
		arg0.bossTimer:Stop()

		arg0.bossTimer = nil
	end

	arg0.allRankPage:Destroy()
	arg0.timeView:Dispose()
end

return var0
