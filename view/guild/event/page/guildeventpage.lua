local var0_0 = class("GuildEventPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "GuildEventPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.eventList = UIItemList.New(arg0_2:findTF("eventlist/content"), arg0_2:findTF("eventlist/content/tpl"))
	arg0_2.reportBtn = arg0_2:findTF("report_btn")
	arg0_2.reportTip = arg0_2.reportBtn:Find("tip")
	arg0_2.reportTipTxt = arg0_2.reportBtn:Find("tip/Text"):GetComponent(typeof(Text))
	arg0_2.formationBtn = arg0_2:findTF("formation_btn")
	arg0_2.missionList = arg0_2:findTF("missionlist")
	arg0_2.pathContains = arg0_2:findTF("missionlist/path")
	arg0_2.tpl = arg0_2:getTpl("tpl", arg0_2.pathContains)
	arg0_2.line = arg0_2:findTF("resource/line")
	arg0_2.lineHead = arg0_2:findTF("resource/head")
	arg0_2.adapter = arg0_2:findTF("resource/adapter")
	arg0_2.bg = arg0_2:findTF("bg"):GetComponent(typeof(Image))
	arg0_2.titleTF = arg0_2:findTF("title")
	arg0_2.nameTxt = arg0_2:findTF("title/Text"):GetComponent(typeof(Text))
	arg0_2.descPanel = arg0_2:findTF("missionlist/path/desc_panel")
	arg0_2.descPanelTag = arg0_2.descPanel:Find("Image"):GetComponent(typeof(Image))

	setText(arg0_2:findTF("title/timer/label"), i18n("guild_time_remaining_tip"))

	arg0_2.endEventTimerTxt = arg0_2:findTF("title/timer/Text"):GetComponent(typeof(Text))
	arg0_2.timeView = GuildEventTimerView.New()
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.reportBtn, function()
		arg0_3:emit(GuildEventMediator.ON_OPEN_REPORT)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.formationBtn, function()
		arg0_3:emit(GuildEventLayer.ON_OPEN_FORMATION)
	end, SFX_PANEL)
end

function var0_0.OnReportUpdated(arg0_6)
	arg0_6.reports = getProxy(GuildProxy):GetReports()

	arg0_6:UpdateReportBtn()
end

function var0_0.Show(arg0_7, arg1_7, arg2_7, arg3_7)
	var0_0.super.Show(arg0_7)
	arg0_7:UpdateData(arg1_7, arg2_7, arg3_7)
	arg0_7:SwitchPage()
	arg0_7:OnReportUpdated()
	arg0_7._tf:SetAsFirstSibling()
end

function var0_0.UpdateData(arg0_8, arg1_8, arg2_8, arg3_8)
	arg0_8.guildVO = arg1_8
	arg0_8.player = arg2_8
	arg0_8.events = arg3_8
	arg0_8.activeEvent = _.detect(arg0_8.events, function(arg0_9)
		return arg0_9:IsActive()
	end)
end

function var0_0.SwitchPage(arg0_10)
	if arg0_10.contextData.editFleet then
		triggerButton(arg0_10.formationBtn)
	end

	local var0_10 = arg0_10.activeEvent
	local var1_10 = not var0_10 or var0_10 and not var0_10:IsParticipant()

	if var1_10 then
		arg0_10:InitEvents()
	else
		arg0_10:BuildTree(var0_10)
		arg0_10:InitView()
		arg0_10:GenTree()
		arg0_10:InitTree()
		arg0_10:EnterActiveNode()
		arg0_10:CheckBossNode()
		arg0_10:RefreshLatelyNode()
		arg0_10:AddRefreshTime()
		arg0_10.timeView:Flush(arg0_10.endEventTimerTxt, var0_10)
	end

	setActive(arg0_10.eventList.container, var1_10)
	setActive(arg0_10.missionList, not var1_10)
	setActive(arg0_10.titleTF, not var1_10)
end

function var0_0.UpdateReportBtn(arg0_11)
	local var0_11 = _.select(_.values(arg0_11.reports), function(arg0_12)
		return arg0_12:CanSubmit()
	end)
	local var1_11 = arg0_11.guildVO:getMemberById(arg0_11.player.id)
	local var2_11 = #var0_11 > 0 and not var1_11:IsRecruit()

	setActive(arg0_11.reportTip, var2_11)

	if var2_11 then
		arg0_11.reportTipTxt.text = #var0_11
	end
end

function var0_0.InitEvents(arg0_13)
	arg0_13.bg.sprite = GetSpriteFromAtlas("commonbg/guild_event_bg", "")
	arg0_13.displays = {}

	local var0_13 = {}

	for iter0_13, iter1_13 in ipairs(arg0_13.events) do
		table.insert(arg0_13.displays, iter1_13)
	end

	table.insert(arg0_13.displays, false)
	arg0_13.eventList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = arg0_13.events[arg1_14 + 1]

			arg0_13:UpdateEvent(arg2_14, var0_14)

			if var0_14 then
				var0_13[var0_14.id] = arg2_14
			end
		end
	end)
	arg0_13.eventList:align(#arg0_13.displays)

	if arg0_13.activeEvent and not arg0_13.contextData.editFleet then
		triggerButton(var0_13[arg0_13.activeEvent.id])
	end
end

local var1_0 = {
	"easy",
	"normal",
	"hard"
}

function var0_0.UpdateEvent(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.activeEvent
	local var1_15 = arg2_15 and arg2_15.id or 0

	arg1_15:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("guildevent/" .. var1_15, "")

	local var2_15 = arg1_15:Find("tag")

	if arg2_15 then
		local var3_15 = var1_0[arg2_15:getConfig("difficulty")]
		local var4_15

		var4_15.sprite, var4_15 = GetSpriteFromAtlas("ui/GuildEventUI_atlas", "tag_" .. var3_15), var2_15:GetComponent(typeof(Image))

		var4_15:SetNativeSize()
	end

	setActive(var2_15, arg2_15)

	local var5_15 = var0_15 and arg2_15 and var0_15.id == arg2_15.id

	setActive(arg1_15:Find("state"), var5_15)
	setActive(arg1_15:Find("consume"), arg2_15 and not var5_15)
	setActive(arg1_15:Find("timer"), var5_15)

	if var5_15 then
		arg0_15.timeView:Flush(arg1_15:Find("timer/Text"):GetComponent(typeof(Text)), var0_15)
	end

	setText(arg1_15:Find("timer/label"), var5_15 and i18n("guild_time_remaining_tip") or "")

	if not arg2_15 then
		removeOnButton(arg1_15)

		return
	end

	setText(arg1_15:Find("consume/label"), i18n("guild_word_consume_for_battle"))
	setText(arg1_15:Find("consume/Text"), arg2_15:GetConsume())

	local var6_15 = arg2_15:IsUnlock(arg0_15.guildVO.level)

	if not var6_15 then
		arg1_15:Find("mask"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("guildevent/" .. "0_0", "")
	end

	setActive(arg1_15:Find("mask"), not var6_15)
	onButton(arg0_15, arg1_15, function()
		if not arg2_15 then
			return
		end

		if not arg2_15:IsUnlock(arg0_15.guildVO.level) then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_level_no_enough"))

			return
		end

		if var0_15 and var0_15.id ~= arg2_15.id then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_open_event_info_when_exist_active", var0_15:getConfig("name")))

			return
		end

		arg0_15:emit(GuildEventLayer.OPEN_EVENT_INFO, arg2_15)
	end, SFX_PANEL)
end

function var0_0.OnRefreshNode(arg0_17, arg1_17, arg2_17)
	if not arg0_17.nodes then
		return
	end

	arg0_17:BuildTree(arg1_17)

	for iter0_17, iter1_17 in ipairs(arg0_17.nodes) do
		if iter1_17.data.id == arg2_17.id or iter1_17.data:IsBoss() and arg2_17:IsBoss() then
			iter1_17:UpdateData(arg2_17)
		end
	end

	if not arg2_17:IsBoss() then
		arg0_17:CheckBossNode()
	end
end

function var0_0.EnterActiveNode(arg0_18)
	if arg0_18.contextData.mission then
		arg0_18:emit(GuildEventLayer.ON_OPEN_MISSION, arg0_18.contextData.mission)
	end
end

function var0_0.CheckBossNode(arg0_19)
	local var0_19 = arg0_19.nodes[#arg0_19.nodes]

	if var0_19:ParentIsFinishByServer() and not var0_19:IsActive() then
		arg0_19:emit(GuildEventMediator.ON_GET_BOSS_INFO)
	elseif var0_19:ParentIFinish() and not var0_19:IsActive() then
		arg0_19:emit(GuildEventMediator.REFRESH_MISSION, var0_19:GetParentId())
	end
end

function var0_0.InitView(arg0_20)
	arg0_20.bg.sprite = GetSpriteFromAtlas("GuildMission/" .. arg0_20.gevent:GetTheme(), "")
	arg0_20.nameTxt.text = arg0_20.gevent:GetName()
end

function var0_0.BuildTree(arg0_21, arg1_21)
	arg0_21.gevent = arg1_21
	arg0_21.missions = {}

	local var0_21 = arg0_21.gevent:GetMissions()
	local var1_21 = arg0_21.gevent:GetBossMission()

	arg0_21.bossPosition = var1_21:GetPosition()
	arg0_21.lastPosition = -1

	for iter0_21, iter1_21 in pairs(var0_21) do
		arg0_21.missions[iter0_21] = iter1_21

		if _.any(iter1_21, function(arg0_22)
			return arg0_22:IsMain() and arg0_22:IsFinish()
		end) then
			arg0_21.lastPosition = iter0_21
		end
	end

	arg0_21.lastPosition = arg0_21.lastPosition + 1
	arg0_21.missions[arg0_21.bossPosition] = {
		var1_21
	}
end

function var0_0.RefreshLatelyNode(arg0_23)
	if arg0_23.lastPosition <= 0 or arg0_23.lastPosition == arg0_23.bossPosition then
		return
	end

	local var0_23 = arg0_23.lastPosition
	local var1_23 = arg0_23.gevent:GetMissions()
	local var2_23 = {}
	local var3_23 = var1_23[var0_23] or {}

	for iter0_23, iter1_23 in ipairs(var3_23) do
		if not iter1_23:IsBoss() then
			table.insert(var2_23, function(arg0_24)
				arg0_23:emit(GuildEventMediator.REFRESH_MISSION, iter1_23.id, arg0_24)
			end)
		end
	end

	seriesAsync(var2_23, function()
		if var0_23 ~= arg0_23.lastPosition then
			arg0_23:RefreshLatelyNode()
		end
	end)
end

function var0_0.AddRefreshTime(arg0_26)
	if arg0_26.timer then
		arg0_26.timer:Stop()

		arg0_26.timer = nil
	end

	arg0_26.timer = Timer.New(function()
		arg0_26:RefreshLatelyNode()
		arg0_26:AddRefreshTime()
	end, GuildConst.FORCE_REFRESH_MISSION_TREE_TIME, 1)

	arg0_26.timer:Start()
end

function var0_0.GenTree(arg0_28)
	arg0_28.nodes = {}

	for iter0_28, iter1_28 in pairs(arg0_28.missions) do
		table.sort(iter1_28, function(arg0_29, arg1_29)
			return arg0_29:GetSubType() > arg1_29:GetSubType()
		end)

		for iter2_28, iter3_28 in ipairs(iter1_28) do
			local var0_28 = cloneTplTo(arg0_28.tpl, arg0_28.pathContains, iter0_28 .. "-" .. iter2_28)
			local var1_28 = arg0_28:CreateNode(var0_28, iter0_28, iter3_28)

			table.insert(arg0_28.nodes, var1_28)
		end
	end
end

function var0_0.CreateNode(arg0_30, arg1_30, arg2_30, arg3_30)
	local var0_30 = GuildViewMissionNode.New({
		go = arg1_30.gameObject,
		slot = arg2_30,
		data = arg3_30,
		parent = arg0_30.last
	})

	if arg0_30.last then
		arg0_30.last:AddChild(var0_30)
	end

	if var0_30:IsMain() then
		arg0_30.last = var0_30
	end

	onButton(arg0_30, arg1_30, function()
		if arg0_30.prevSelected == var0_30 then
			return
		end

		if not var0_30:IsUnLock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_is_lock"))

			return
		end

		if var0_30:IsFinish() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_is_finish"))

			return
		end

		if arg0_30.prevSelected then
			arg0_30:HideDesc(arg0_30.prevSelected)
		end

		arg0_30:ShowDesc(var0_30)

		arg0_30.prevSelected = var0_30
	end, SFX_PANEL)

	return var0_30
end

function var0_0.InitTree(arg0_32)
	local var0_32 = {
		0,
		0
	}
	local var1_32

	for iter0_32, iter1_32 in ipairs(arg0_32.nodes) do
		iter1_32:Init()

		local var2_32 = iter1_32._tf.anchoredPosition
		local var3_32 = math.abs(var2_32.x)
		local var4_32 = math.abs(var2_32.y)

		if var3_32 > var0_32[1] then
			var0_32[1] = var3_32 + iter1_32._tf.sizeDelta.x
		end

		if var4_32 > var0_32[2] then
			var0_32[2] = var4_32 + iter1_32._tf.sizeDelta.y / 2
		end

		if iter1_32:IsMain() and iter1_32:IsUnLock() then
			var1_32 = iter1_32
		end
	end

	for iter2_32, iter3_32 in ipairs(arg0_32.nodes) do
		arg0_32:CreateLinkLine(iter3_32)
		iter3_32:UpdateLineStyle()
	end

	arg0_32:SetScrollRect(var0_32)

	if var1_32 then
		local var5_32 = -var1_32._tf.localPosition.x
		local var6_32 = math.max(var5_32, -arg0_32.pathContains.rect.width * 0.5)

		setAnchoredPosition(arg0_32.pathContains, {
			x = var6_32
		})
	end
end

function var0_0.CreateLinkLine(arg0_33, arg1_33)
	local function var0_33(arg0_34, arg1_34)
		local var0_34 = Instantiate(arg0_34)

		var0_34.name = arg1_34

		return var0_34
	end

	if arg1_33:HasChild() then
		arg1_33:AddLine(var0_33(arg0_33.adapter, "adapter"), GuildViewMissionNode.LINE_RIGHT, arg1_33)
	end

	if arg1_33:HasParent() then
		arg1_33:AddLine(var0_33(arg0_33.adapter, "adapter"), GuildViewMissionNode.LINE_LEFT, arg1_33)
	end

	local var1_33 = arg1_33:GetChilds()

	for iter0_33, iter1_33 in ipairs(var1_33) do
		local var2_33 = iter1_33:GetOffset()

		if var2_33 > 0 then
			arg1_33:AddLine(var0_33(arg0_33.line, "line"), GuildViewMissionNode.TOP_LINK, iter1_33)
			arg1_33:AddLine(var0_33(arg0_33.line, "line"), GuildViewMissionNode.TOP_HRZ_LINK, iter1_33)
		elseif var2_33 < 0 then
			arg1_33:AddLine(var0_33(arg0_33.line, "line"), GuildViewMissionNode.BOTTOM_LINK, iter1_33)
			arg1_33:AddLine(var0_33(arg0_33.line, "line"), GuildViewMissionNode.BOTTOM_HRZ_LINK, iter1_33)
		elseif var2_33 == 0 then
			arg1_33:AddLine(var0_33(arg0_33.line, "line"), GuildViewMissionNode.CENTER_LINK, iter1_33)
		end
	end
end

function var0_0.SetScrollRect(arg0_35, arg1_35)
	local var0_35 = arg1_35[1] + 100
	local var1_35 = arg1_35[2] * 2 + 100

	arg0_35.pathContains.sizeDelta = Vector2(var0_35, var1_35)
end

function var0_0.ShowDesc(arg0_36, arg1_36)
	arg1_36:Selected(true)
	setActive(arg0_36.descPanel, true)

	local var0_36 = arg1_36._tf.localPosition
	local var1_36 = var0_36.y + 50 + arg1_36._tf.rect.height
	local var2_36 = arg0_36.pathContains.rect.height / 2

	if var2_36 < var1_36 then
		local var3_36 = var2_36 + (var1_36 - var2_36) * 2

		arg0_36.chcheSizeDelta = arg0_36.pathContains.sizeDelta
		arg0_36.pathContains.sizeDelta = Vector2(arg0_36.chcheSizeDelta.x, arg0_36.chcheSizeDelta.y + var3_36)

		scrollTo(arg0_36.missionList, false, 1)
	end

	arg0_36.descPanel.localPosition = Vector3(var0_36.x, var0_36.y + 50, 0)

	if not arg1_36.data:IsBoss() then
		arg0_36.descPanel:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("GuildMission/" .. arg1_36.data:GetIcon(), "")
	else
		arg0_36.descPanel:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("GuildMission/boss_" .. arg1_36.data:GetIcon(), "")
	end

	local var4_36 = arg1_36.data:GetTag()

	arg0_36.descPanelTag.sprite = GetSpriteFromAtlas("ui/GuildMissionUI_atlas", "tag" .. var4_36)

	local function var5_36(arg0_37)
		if not arg0_37:IsUnLock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_is_lock"))

			return false
		end

		if arg0_37:IsFinish() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_is_finish"))

			return false
		end

		return true
	end

	onButton(arg0_36, arg0_36.descPanel, function()
		if arg1_36.data:IsBoss() then
			if not var5_36(arg1_36) then
				return
			end

			arg0_36:emit(GuildEventLayer.ON_OPEN_BOSS, arg1_36.data)
		else
			arg0_36:emit(GuildEventMediator.REFRESH_MISSION, arg1_36.data.id, function()
				if not var5_36(arg1_36) then
					return
				end

				arg0_36.contextData.mission = arg1_36.data

				arg0_36:emit(GuildEventLayer.ON_OPEN_MISSION, arg1_36.data)
			end)
		end
	end, SFX_PANEL)
end

function var0_0.HideDesc(arg0_40, arg1_40)
	arg1_40:Selected(false)

	if arg0_40.chcheSizeDelta then
		arg0_40.pathContains.sizeDelta = arg0_40.chcheSizeDelta
	end

	setActive(arg0_40.descPanel, false)
end

function var0_0.OnDestroy(arg0_41)
	if arg0_41.timer then
		arg0_41.timer:Stop()

		arg0_41.timer = nil
	end

	arg0_41.timeView:Dispose()
end

return var0_0
