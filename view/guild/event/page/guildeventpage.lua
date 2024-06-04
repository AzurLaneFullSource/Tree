local var0 = class("GuildEventPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "GuildEventPage"
end

function var0.OnLoaded(arg0)
	arg0.eventList = UIItemList.New(arg0:findTF("eventlist/content"), arg0:findTF("eventlist/content/tpl"))
	arg0.reportBtn = arg0:findTF("report_btn")
	arg0.reportTip = arg0.reportBtn:Find("tip")
	arg0.reportTipTxt = arg0.reportBtn:Find("tip/Text"):GetComponent(typeof(Text))
	arg0.formationBtn = arg0:findTF("formation_btn")
	arg0.missionList = arg0:findTF("missionlist")
	arg0.pathContains = arg0:findTF("missionlist/path")
	arg0.tpl = arg0:getTpl("tpl", arg0.pathContains)
	arg0.line = arg0:findTF("resource/line")
	arg0.lineHead = arg0:findTF("resource/head")
	arg0.adapter = arg0:findTF("resource/adapter")
	arg0.bg = arg0:findTF("bg"):GetComponent(typeof(Image))
	arg0.titleTF = arg0:findTF("title")
	arg0.nameTxt = arg0:findTF("title/Text"):GetComponent(typeof(Text))
	arg0.descPanel = arg0:findTF("missionlist/path/desc_panel")
	arg0.descPanelTag = arg0.descPanel:Find("Image"):GetComponent(typeof(Image))

	setText(arg0:findTF("title/timer/label"), i18n("guild_time_remaining_tip"))

	arg0.endEventTimerTxt = arg0:findTF("title/timer/Text"):GetComponent(typeof(Text))
	arg0.timeView = GuildEventTimerView.New()
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.reportBtn, function()
		arg0:emit(GuildEventMediator.ON_OPEN_REPORT)
	end, SFX_PANEL)
	onButton(arg0, arg0.formationBtn, function()
		arg0:emit(GuildEventLayer.ON_OPEN_FORMATION)
	end, SFX_PANEL)
end

function var0.OnReportUpdated(arg0)
	arg0.reports = getProxy(GuildProxy):GetReports()

	arg0:UpdateReportBtn()
end

function var0.Show(arg0, arg1, arg2, arg3)
	var0.super.Show(arg0)
	arg0:UpdateData(arg1, arg2, arg3)
	arg0:SwitchPage()
	arg0:OnReportUpdated()
	arg0._tf:SetAsFirstSibling()
end

function var0.UpdateData(arg0, arg1, arg2, arg3)
	arg0.guildVO = arg1
	arg0.player = arg2
	arg0.events = arg3
	arg0.activeEvent = _.detect(arg0.events, function(arg0)
		return arg0:IsActive()
	end)
end

function var0.SwitchPage(arg0)
	if arg0.contextData.editFleet then
		triggerButton(arg0.formationBtn)
	end

	local var0 = arg0.activeEvent
	local var1 = not var0 or var0 and not var0:IsParticipant()

	if var1 then
		arg0:InitEvents()
	else
		arg0:BuildTree(var0)
		arg0:InitView()
		arg0:GenTree()
		arg0:InitTree()
		arg0:EnterActiveNode()
		arg0:CheckBossNode()
		arg0:RefreshLatelyNode()
		arg0:AddRefreshTime()
		arg0.timeView:Flush(arg0.endEventTimerTxt, var0)
	end

	setActive(arg0.eventList.container, var1)
	setActive(arg0.missionList, not var1)
	setActive(arg0.titleTF, not var1)
end

function var0.UpdateReportBtn(arg0)
	local var0 = _.select(_.values(arg0.reports), function(arg0)
		return arg0:CanSubmit()
	end)
	local var1 = arg0.guildVO:getMemberById(arg0.player.id)
	local var2 = #var0 > 0 and not var1:IsRecruit()

	setActive(arg0.reportTip, var2)

	if var2 then
		arg0.reportTipTxt.text = #var0
	end
end

function var0.InitEvents(arg0)
	arg0.bg.sprite = GetSpriteFromAtlas("commonbg/guild_event_bg", "")
	arg0.displays = {}

	local var0 = {}

	for iter0, iter1 in ipairs(arg0.events) do
		table.insert(arg0.displays, iter1)
	end

	table.insert(arg0.displays, false)
	arg0.eventList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.events[arg1 + 1]

			arg0:UpdateEvent(arg2, var0)

			if var0 then
				var0[var0.id] = arg2
			end
		end
	end)
	arg0.eventList:align(#arg0.displays)

	if arg0.activeEvent and not arg0.contextData.editFleet then
		triggerButton(var0[arg0.activeEvent.id])
	end
end

local var1 = {
	"easy",
	"normal",
	"hard"
}

function var0.UpdateEvent(arg0, arg1, arg2)
	local var0 = arg0.activeEvent
	local var1 = arg2 and arg2.id or 0

	arg1:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("guildevent/" .. var1, "")

	local var2 = arg1:Find("tag")

	if arg2 then
		local var3 = var1[arg2:getConfig("difficulty")]
		local var4

		var4.sprite, var4 = GetSpriteFromAtlas("ui/GuildEventUI_atlas", "tag_" .. var3), var2:GetComponent(typeof(Image))

		var4:SetNativeSize()
	end

	setActive(var2, arg2)

	local var5 = var0 and arg2 and var0.id == arg2.id

	setActive(arg1:Find("state"), var5)
	setActive(arg1:Find("consume"), arg2 and not var5)
	setActive(arg1:Find("timer"), var5)

	if var5 then
		arg0.timeView:Flush(arg1:Find("timer/Text"):GetComponent(typeof(Text)), var0)
	end

	setText(arg1:Find("timer/label"), var5 and i18n("guild_time_remaining_tip") or "")

	if not arg2 then
		removeOnButton(arg1)

		return
	end

	setText(arg1:Find("consume/label"), i18n("guild_word_consume_for_battle"))
	setText(arg1:Find("consume/Text"), arg2:GetConsume())

	local var6 = arg2:IsUnlock(arg0.guildVO.level)

	if not var6 then
		arg1:Find("mask"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("guildevent/" .. "0_0", "")
	end

	setActive(arg1:Find("mask"), not var6)
	onButton(arg0, arg1, function()
		if not arg2 then
			return
		end

		if not arg2:IsUnlock(arg0.guildVO.level) then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_level_no_enough"))

			return
		end

		if var0 and var0.id ~= arg2.id then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_open_event_info_when_exist_active", var0:getConfig("name")))

			return
		end

		arg0:emit(GuildEventLayer.OPEN_EVENT_INFO, arg2)
	end, SFX_PANEL)
end

function var0.OnRefreshNode(arg0, arg1, arg2)
	if not arg0.nodes then
		return
	end

	arg0:BuildTree(arg1)

	for iter0, iter1 in ipairs(arg0.nodes) do
		if iter1.data.id == arg2.id or iter1.data:IsBoss() and arg2:IsBoss() then
			iter1:UpdateData(arg2)
		end
	end

	if not arg2:IsBoss() then
		arg0:CheckBossNode()
	end
end

function var0.EnterActiveNode(arg0)
	if arg0.contextData.mission then
		arg0:emit(GuildEventLayer.ON_OPEN_MISSION, arg0.contextData.mission)
	end
end

function var0.CheckBossNode(arg0)
	local var0 = arg0.nodes[#arg0.nodes]

	if var0:ParentIsFinishByServer() and not var0:IsActive() then
		arg0:emit(GuildEventMediator.ON_GET_BOSS_INFO)
	elseif var0:ParentIFinish() and not var0:IsActive() then
		arg0:emit(GuildEventMediator.REFRESH_MISSION, var0:GetParentId())
	end
end

function var0.InitView(arg0)
	arg0.bg.sprite = GetSpriteFromAtlas("GuildMission/" .. arg0.gevent:GetTheme(), "")
	arg0.nameTxt.text = arg0.gevent:GetName()
end

function var0.BuildTree(arg0, arg1)
	arg0.gevent = arg1
	arg0.missions = {}

	local var0 = arg0.gevent:GetMissions()
	local var1 = arg0.gevent:GetBossMission()

	arg0.bossPosition = var1:GetPosition()
	arg0.lastPosition = -1

	for iter0, iter1 in pairs(var0) do
		arg0.missions[iter0] = iter1

		if _.any(iter1, function(arg0)
			return arg0:IsMain() and arg0:IsFinish()
		end) then
			arg0.lastPosition = iter0
		end
	end

	arg0.lastPosition = arg0.lastPosition + 1
	arg0.missions[arg0.bossPosition] = {
		var1
	}
end

function var0.RefreshLatelyNode(arg0)
	if arg0.lastPosition <= 0 or arg0.lastPosition == arg0.bossPosition then
		return
	end

	local var0 = arg0.lastPosition
	local var1 = arg0.gevent:GetMissions()
	local var2 = {}
	local var3 = var1[var0] or {}

	for iter0, iter1 in ipairs(var3) do
		if not iter1:IsBoss() then
			table.insert(var2, function(arg0)
				arg0:emit(GuildEventMediator.REFRESH_MISSION, iter1.id, arg0)
			end)
		end
	end

	seriesAsync(var2, function()
		if var0 ~= arg0.lastPosition then
			arg0:RefreshLatelyNode()
		end
	end)
end

function var0.AddRefreshTime(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	arg0.timer = Timer.New(function()
		arg0:RefreshLatelyNode()
		arg0:AddRefreshTime()
	end, GuildConst.FORCE_REFRESH_MISSION_TREE_TIME, 1)

	arg0.timer:Start()
end

function var0.GenTree(arg0)
	arg0.nodes = {}

	for iter0, iter1 in pairs(arg0.missions) do
		table.sort(iter1, function(arg0, arg1)
			return arg0:GetSubType() > arg1:GetSubType()
		end)

		for iter2, iter3 in ipairs(iter1) do
			local var0 = cloneTplTo(arg0.tpl, arg0.pathContains, iter0 .. "-" .. iter2)
			local var1 = arg0:CreateNode(var0, iter0, iter3)

			table.insert(arg0.nodes, var1)
		end
	end
end

function var0.CreateNode(arg0, arg1, arg2, arg3)
	local var0 = GuildViewMissionNode.New({
		go = arg1.gameObject,
		slot = arg2,
		data = arg3,
		parent = arg0.last
	})

	if arg0.last then
		arg0.last:AddChild(var0)
	end

	if var0:IsMain() then
		arg0.last = var0
	end

	onButton(arg0, arg1, function()
		if arg0.prevSelected == var0 then
			return
		end

		if not var0:IsUnLock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_is_lock"))

			return
		end

		if var0:IsFinish() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_is_finish"))

			return
		end

		if arg0.prevSelected then
			arg0:HideDesc(arg0.prevSelected)
		end

		arg0:ShowDesc(var0)

		arg0.prevSelected = var0
	end, SFX_PANEL)

	return var0
end

function var0.InitTree(arg0)
	local var0 = {
		0,
		0
	}
	local var1

	for iter0, iter1 in ipairs(arg0.nodes) do
		iter1:Init()

		local var2 = iter1._tf.anchoredPosition
		local var3 = math.abs(var2.x)
		local var4 = math.abs(var2.y)

		if var3 > var0[1] then
			var0[1] = var3 + iter1._tf.sizeDelta.x
		end

		if var4 > var0[2] then
			var0[2] = var4 + iter1._tf.sizeDelta.y / 2
		end

		if iter1:IsMain() and iter1:IsUnLock() then
			var1 = iter1
		end
	end

	for iter2, iter3 in ipairs(arg0.nodes) do
		arg0:CreateLinkLine(iter3)
		iter3:UpdateLineStyle()
	end

	arg0:SetScrollRect(var0)

	if var1 then
		local var5 = -var1._tf.localPosition.x
		local var6 = math.max(var5, -arg0.pathContains.rect.width * 0.5)

		setAnchoredPosition(arg0.pathContains, {
			x = var6
		})
	end
end

function var0.CreateLinkLine(arg0, arg1)
	local function var0(arg0, arg1)
		local var0 = Instantiate(arg0)

		var0.name = arg1

		return var0
	end

	if arg1:HasChild() then
		arg1:AddLine(var0(arg0.adapter, "adapter"), GuildViewMissionNode.LINE_RIGHT, arg1)
	end

	if arg1:HasParent() then
		arg1:AddLine(var0(arg0.adapter, "adapter"), GuildViewMissionNode.LINE_LEFT, arg1)
	end

	local var1 = arg1:GetChilds()

	for iter0, iter1 in ipairs(var1) do
		local var2 = iter1:GetOffset()

		if var2 > 0 then
			arg1:AddLine(var0(arg0.line, "line"), GuildViewMissionNode.TOP_LINK, iter1)
			arg1:AddLine(var0(arg0.line, "line"), GuildViewMissionNode.TOP_HRZ_LINK, iter1)
		elseif var2 < 0 then
			arg1:AddLine(var0(arg0.line, "line"), GuildViewMissionNode.BOTTOM_LINK, iter1)
			arg1:AddLine(var0(arg0.line, "line"), GuildViewMissionNode.BOTTOM_HRZ_LINK, iter1)
		elseif var2 == 0 then
			arg1:AddLine(var0(arg0.line, "line"), GuildViewMissionNode.CENTER_LINK, iter1)
		end
	end
end

function var0.SetScrollRect(arg0, arg1)
	local var0 = arg1[1] + 100
	local var1 = arg1[2] * 2 + 100

	arg0.pathContains.sizeDelta = Vector2(var0, var1)
end

function var0.ShowDesc(arg0, arg1)
	arg1:Selected(true)
	setActive(arg0.descPanel, true)

	local var0 = arg1._tf.localPosition
	local var1 = var0.y + 50 + arg1._tf.rect.height
	local var2 = arg0.pathContains.rect.height / 2

	if var2 < var1 then
		local var3 = var2 + (var1 - var2) * 2

		arg0.chcheSizeDelta = arg0.pathContains.sizeDelta
		arg0.pathContains.sizeDelta = Vector2(arg0.chcheSizeDelta.x, arg0.chcheSizeDelta.y + var3)

		scrollTo(arg0.missionList, false, 1)
	end

	arg0.descPanel.localPosition = Vector3(var0.x, var0.y + 50, 0)

	if not arg1.data:IsBoss() then
		arg0.descPanel:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("GuildMission/" .. arg1.data:GetIcon(), "")
	else
		arg0.descPanel:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("GuildMission/boss_" .. arg1.data:GetIcon(), "")
	end

	local var4 = arg1.data:GetTag()

	arg0.descPanelTag.sprite = GetSpriteFromAtlas("ui/GuildMissionUI_atlas", "tag" .. var4)

	local function var5(arg0)
		if not arg0:IsUnLock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_is_lock"))

			return false
		end

		if arg0:IsFinish() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_is_finish"))

			return false
		end

		return true
	end

	onButton(arg0, arg0.descPanel, function()
		if arg1.data:IsBoss() then
			if not var5(arg1) then
				return
			end

			arg0:emit(GuildEventLayer.ON_OPEN_BOSS, arg1.data)
		else
			arg0:emit(GuildEventMediator.REFRESH_MISSION, arg1.data.id, function()
				if not var5(arg1) then
					return
				end

				arg0.contextData.mission = arg1.data

				arg0:emit(GuildEventLayer.ON_OPEN_MISSION, arg1.data)
			end)
		end
	end, SFX_PANEL)
end

function var0.HideDesc(arg0, arg1)
	arg1:Selected(false)

	if arg0.chcheSizeDelta then
		arg0.pathContains.sizeDelta = arg0.chcheSizeDelta
	end

	setActive(arg0.descPanel, false)
end

function var0.OnDestroy(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	arg0.timeView:Dispose()
end

return var0
