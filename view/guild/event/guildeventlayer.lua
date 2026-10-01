local var0_0 = class("GuildEventLayer", import("...base.BaseUI"))

var0_0.OPEN_EVENT_INFO = "GuildEventLayer:OPEN_EVENT_INFO"
var0_0.ON_OPEN_FORMATION = "GuildEventLayer:ON_OPEN_FORMATION"
var0_0.ON_OPEN_MISSION = "GuildEventLayer:ON_OPEN_MISSION"
var0_0.OPEN_MISSION_FORAMTION = "GuildEventLayer:OPEN_MISSION_FORAMTION"
var0_0.ON_OPEN_BOSS = "GuildEventLayer:ON_OPEN_BOSS"
var0_0.ON_OPEN_BOSS_FORMATION = "GuildEventLayer:ON_OPEN_BOSS_FORMATION"
var0_0.OPEN_BOSS_ASSULT = "GuildEventLayer:OPEN_BOSS_ASSULT"
var0_0.SHOW_SHIP_EQUIPMENTS = "GuildEventLayer:SHOW_SHIP_EQUIPMENTS"

function var0_0.getUIName(arg0_1)
	return "GuildEmptyUI"
end

function var0_0.SetPlayer(arg0_2, arg1_2)
	arg0_2.player = arg1_2
end

function var0_0.SetGuild(arg0_3, arg1_3)
	arg0_3.guildVO = arg1_3
	arg0_3.events = {}
	arg0_3.activeEvent = nil

	arg0_3:SetEvents(arg1_3:GetEvents())

	arg0_3.myAssaultFleet = arg1_3:getMemberById(arg0_3.player.id):GetExternalAssaultFleet()
end

function var0_0.SetEvents(arg0_4, arg1_4)
	arg0_4.events = arg1_4
	arg0_4.activeEvent = _.detect(arg0_4.events, function(arg0_5)
		return arg0_5:IsActive()
	end)
end

function var0_0.UpdateFleet(arg0_6)
	if arg0_6.formationPage:GetLoaded() then
		arg0_6.formationPage:ExecuteAction("OnFleetUpdated", arg0_6.myAssaultFleet)
	end
end

function var0_0.preload(arg0_7, arg1_7)
	seriesAsync({
		function(arg0_8)
			pg.m02:sendNotification(GAME.GET_GUILD_REPORT, {
				callback = arg0_8
			})
		end,
		function(arg0_9)
			local var0_9 = getProxy(GuildProxy):getRawData():GetActiveEvent()

			if not var0_9 then
				pg.m02:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT, {
					force = false,
					callback = arg0_9
				})
			elseif var0_9 and var0_9:IsExpired() then
				pg.m02:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT, {
					force = true,
					callback = arg0_9
				})
			else
				arg0_9()
			end
		end
	}, arg1_7)
end

function var0_0.getResource(arg0_10)
	local var0_10 = var0_0.super.getResource(arg0_10)
	local var1_10 = {
		"ui/GuildEventPage",
		"ui/GuildMissionBossPage",
		"ui/GuildEventUI_atlas",
		"ui/GuildMissionUI_atlas",
		"ui/guildmissionui_atlas",
		"commonbg/guild_event_bg",
		"guildevent/0",
		"guildevent/0_0"
	}

	local function var2_10(arg0_11)
		if noEmptyStr(arg0_11) and not table.contains(var1_10, arg0_11) then
			table.insert(var1_10, arg0_11)
		end
	end

	local var3_10 = getProxy(GuildProxy):getRawData()
	local var4_10 = var3_10 and var3_10:GetEvents() or {}

	for iter0_10, iter1_10 in ipairs(var4_10) do
		var2_10("guildevent/" .. iter1_10.id)

		if iter1_10:IsActive() then
			var2_10("GuildMission/" .. iter1_10:GetTheme())

			local var5_10 = iter1_10:GetMissions() or {}

			for iter2_10, iter3_10 in pairs(var5_10) do
				for iter4_10, iter5_10 in ipairs(iter3_10) do
					var2_10("GuildMission/" .. iter5_10:GetIcon())
				end
			end

			local var6_10 = iter1_10:GetBossMission()

			if var6_10 then
				var2_10("GuildMission/boss_" .. var6_10:GetIcon())

				if var6_10:IsActive() then
					local var7_10 = var6_10:GetPainting()

					if noEmptyStr(var7_10) then
						var2_10("guildpainting/" .. var7_10)
					else
						local var8_10 = var6_10:GetEmenyId()

						var2_10("guildboss/" .. var8_10)
						var2_10("guildboss/name_" .. var8_10)
					end
				end
			end
		end
	end

	for iter6_10, iter7_10 in ipairs(var1_10) do
		if not table.contains(var0_10, iter7_10) then
			table.insert(var0_10, iter7_10)
		end
	end

	return var0_10
end

function var0_0.getResource(arg0_12)
	local var0_12 = var0_0.super.getResource(arg0_12)
	local var1_12 = {}

	return var0_12
end

function var0_0.UpdateGuild(arg0_13, arg1_13)
	arg0_13:SetGuild(arg1_13)

	if arg0_13.formationPage and arg0_13.formationPage:GetLoaded() then
		arg0_13.formationPage:UpdateData(arg0_13.guildVO, arg0_13.player, {
			fleet = arg0_13.myAssaultFleet
		})
	end

	if arg0_13.eventPage and arg0_13.eventPage:GetLoaded() then
		arg0_13.eventPage:UpdateData(arg0_13.guildVO, arg0_13.player, arg0_13.events)
	end

	if arg0_13.eventInfoPage and arg0_13.eventInfoPage:GetLoaded() and arg0_13.eventInfoPage:isShowing() then
		arg0_13.eventInfoPage:Refresh(arg1_13, arg0_13.player)
	end

	if arg0_13.showAssultShipPage and arg0_13.showAssultShipPage:GetLoaded() and arg0_13.showAssultShipPage:isShowing() then
		arg0_13:OnMemberAssultFleetUpdate()
	end
end

function var0_0.RefreshMission(arg0_14, arg1_14)
	local var0_14 = arg0_14.activeEvent:GetMissionById(arg1_14)

	if arg0_14.eventPage and arg0_14.eventPage:GetLoaded() then
		arg0_14.eventPage:OnRefreshNode(arg0_14.activeEvent, var0_14)
	end

	if arg0_14.missionInfoPage and arg0_14.missionInfoPage:GetLoaded() then
		arg0_14.missionInfoPage:OnRefreshMission(var0_14)
	end

	if arg0_14.missionFormationPage and arg0_14.missionFormationPage:GetLoaded() then
		arg0_14.missionFormationPage:OnRefreshMission(var0_14)
	end
end

function var0_0.RefreshBossMission(arg0_15, arg1_15)
	local var0_15 = arg0_15.activeEvent:GetBossMission()

	if arg0_15.eventPage and arg0_15.eventPage:GetLoaded() then
		arg0_15.eventPage:OnRefreshNode(arg0_15.activeEvent, var0_15)
	end

	if arg0_15.missionBossPage and arg0_15.missionBossPage:GetLoaded() then
		arg0_15.missionBossPage:UpdateMission(var0_15)
		arg0_15.missionBossPage:UpdateView()
	end
end

function var0_0.OnBossRankUpdate(arg0_16)
	local var0_16 = arg0_16.activeEvent:GetBossMission()

	if arg0_16.missionBossPage and arg0_16.missionBossPage:GetLoaded() then
		arg0_16.missionBossPage:UpdateMission(var0_16)
		arg0_16.missionBossPage:UpdateRank()
	end
end

function var0_0.OnBossMissionFormationChanged(arg0_17)
	local var0_17 = arg0_17.activeEvent:GetBossMission()

	if arg0_17.missionBossPage and arg0_17.missionBossPage:GetLoaded() then
		arg0_17.missionBossPage:UpdateMission(var0_17)
	end

	if arg0_17.missBossForamtionPage and arg0_17.missBossForamtionPage:GetLoaded() then
		arg0_17.missBossForamtionPage:UpdateMission(var0_17, false)
	end
end

function var0_0.OnMemberAssultFleetUpdate(arg0_18)
	if arg0_18.showAssultShipPage and arg0_18.showAssultShipPage:GetLoaded() then
		arg0_18.showAssultShipPage:UpdateData(arg0_18.guildVO, arg0_18.player)
	end
end

function var0_0.OnMyAssultFleetUpdate(arg0_19)
	if arg0_19.formationPage and arg0_19.formationPage:GetLoaded() then
		arg0_19.formationPage:OnFleetUpdated(arg0_19.myAssaultFleet)
	end
end

function var0_0.OnMyAssultFleetFormationDone(arg0_20)
	if arg0_20.formationPage and arg0_20.formationPage:GetLoaded() then
		arg0_20.formationPage:OnFleetFormationDone()
	end
end

function var0_0.OnReportUpdated(arg0_21)
	if arg0_21.eventPage and arg0_21.eventPage:GetLoaded() then
		arg0_21.eventPage:OnReportUpdated()
	end

	if arg0_21.missionBossPage and arg0_21.missionBossPage:GetLoaded() then
		arg0_21.missionBossPage:OnReportUpdated()
	end
end

function var0_0.OnMissionFormationDone(arg0_22)
	if arg0_22.missionFormationPage and arg0_22.missionFormationPage:GetLoaded() and arg0_22.missionFormationPage:isShowing() then
		arg0_22.missionFormationPage:OnFormationDone()
	end
end

function var0_0.OnMemberDeleted(arg0_23)
	if arg0_23.missionBossPage and arg0_23.missionBossPage:GetLoaded() then
		arg0_23.missionBossPage:CheckFleetShipState()
	end
end

function var0_0.OnAssultShipBeRecommanded(arg0_24, arg1_24)
	if arg0_24.showAssultShipPage and arg0_24.showAssultShipPage:GetLoaded() then
		arg0_24.showAssultShipPage:OnAssultShipBeRecommanded(arg1_24)
	end
end

function var0_0.OnRefreshAllAssultShipRecommandState(arg0_25)
	if arg0_25.showAssultShipPage and arg0_25.showAssultShipPage:GetLoaded() then
		arg0_25.showAssultShipPage:OnRefreshAll()
	end
end

function var0_0.OnBossCommanderFormationChange(arg0_26)
	if arg0_26.missBossForamtionPage and arg0_26.missBossForamtionPage:GetLoaded() then
		arg0_26.missBossForamtionPage:OnBossCommanderFormationChange()
	end
end

function var0_0.OnBossCommanderPrefabFormationChange(arg0_27)
	if arg0_27.missBossForamtionPage and arg0_27.missBossForamtionPage:GetLoaded() then
		arg0_27.missBossForamtionPage:OnBossCommanderPrefabFormationChange()
	end
end

function var0_0.init(arg0_28)
	arg0_28:bind(var0_0.OPEN_EVENT_INFO, function(arg0_29, arg1_29)
		arg0_28.eventInfoPage:ExecuteAction("Show", arg0_28.guildVO, arg0_28.player, {
			gevent = arg1_29
		})
	end)
	arg0_28:bind(var0_0.ON_OPEN_FORMATION, function(arg0_30)
		arg0_28.formationPage:ExecuteAction("Show", arg0_28.guildVO, arg0_28.player, {
			fleet = arg0_28.myAssaultFleet
		})
	end)
	arg0_28:bind(var0_0.ON_OPEN_MISSION, function(arg0_31, arg1_31)
		arg0_28.missionInfoPage:ExecuteAction("Show", arg0_28.guildVO, arg0_28.player, {
			mission = arg1_31
		})
	end)
	arg0_28:bind(var0_0.OPEN_MISSION_FORAMTION, function(arg0_32, arg1_32)
		arg0_28.missionFormationPage:ExecuteAction("Show", arg0_28.guildVO, arg0_28.player, {
			mission = arg1_32,
			shipCnt = GuildConst.MISSION_MAX_SHIP_CNT
		})
	end)
	arg0_28:bind(var0_0.ON_OPEN_BOSS, function(arg0_33, arg1_33)
		arg0_28.missionBossPage:ExecuteAction("Show", arg1_33)
	end)
	arg0_28:bind(var0_0.ON_OPEN_BOSS_FORMATION, function(arg0_34, arg1_34)
		arg0_28.missBossForamtionPage:ExecuteAction("Show", arg0_28.guildVO, arg0_28.player, {
			mission = arg1_34
		})
	end)
	arg0_28:bind(var0_0.OPEN_BOSS_ASSULT, function()
		arg0_28.showAssultShipPage:ExecuteAction("Show", arg0_28.guildVO, arg0_28.player)
	end)
	arg0_28:bind(var0_0.SHOW_SHIP_EQUIPMENTS, function(arg0_36, arg1_36, arg2_36, arg3_36)
		arg0_28.shipEquipmentsPage:ExecuteAction("Show", arg1_36, arg2_36, arg3_36)
	end)

	arg0_28.eventPage = GuildEventPage.New(arg0_28._tf, arg0_28.event, arg0_28.contextData)
	arg0_28.eventInfoPage = GuildEventInfoPage.New(arg0_28._tf, arg0_28.event, arg0_28.contextData)
	arg0_28.formationPage = GuildEventFormationPage.New(arg0_28._tf, arg0_28.event, arg0_28.contextData)
	arg0_28.missionInfoPage = GuildMissionInfoPage.New(arg0_28._tf, arg0_28.event, arg0_28.contextData)
	arg0_28.missionFormationPage = GuildMissionFormationPage.New(arg0_28._tf, arg0_28.event, arg0_28.contextData)
	arg0_28.missionBossPage = GuildMissionBossPage.New(arg0_28._tf, arg0_28.event, arg0_28.contextData)
	arg0_28.missBossForamtionPage = GuildMissionBossFormationPage.New(arg0_28._tf, arg0_28.event, arg0_28.contextData)
	arg0_28.showAssultShipPage = GuildShowAssultShipPage.New(arg0_28._tf, arg0_28.event, arg0_28.contextData)
	arg0_28.shipEquipmentsPage = GuildShipEquipmentsPage.New(arg0_28._tf, arg0_28.event, arg0_28.contextData)
	arg0_28.helpBtn = arg0_28._tf:Find("frame/help")
end

function var0_0.didEnter(arg0_37)
	getProxy(GuildProxy):SetBattleBtnRecord()
	onButton(arg0_37, arg0_37.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.guild_event_help_tip.tip
		})
	end, SFX_PANEL)
	arg0_37:EnterEvent()
	arg0_37:TryPlayGuide()
end

function var0_0.TryPlayGuide(arg0_39)
	pg.SystemGuideMgr.GetInstance():PlayGuildAssaultFleet()
end

function var0_0.EnterEvent(arg0_40)
	if not arg0_40:isLoaded() then
		return
	end

	local var0_40 = arg0_40.activeEvent and arg0_40.activeEvent:GetBossMission()

	if arg0_40.activeEvent and var0_40 and var0_40:IsActive() and not var0_40:IsDeath() and arg0_40.activeEvent:IsParticipant() then
		arg0_40.missionBossPage:ExecuteAction("Show", var0_40)
	else
		arg0_40.eventPage:ExecuteAction("Show", arg0_40.guildVO, arg0_40.player, arg0_40.events)
	end

	if arg0_40.missionBossPage and arg0_40.missionBossPage:GetLoaded() and not arg0_40.activeEvent then
		arg0_40.missionBossPage:Destroy()

		arg0_40.missionBossPage = nil
	end

	if arg0_40.activeEvent and arg0_40.eventInfoPage and arg0_40.eventInfoPage:GetLoaded() and arg0_40.activeEvent:IsParticipant() then
		arg0_40.eventInfoPage:Destroy()

		arg0_40.eventInfoPage = nil
	end
end

function var0_0.OnEventEnd(arg0_41)
	arg0_41:EnterEvent()
end

function var0_0.onBackPressed(arg0_42)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0_42:emit(var0_0.ON_BACK)
end

function var0_0.willExit(arg0_43)
	if arg0_43.eventInfoPage then
		arg0_43.eventInfoPage:Destroy()
	end

	arg0_43.missBossForamtionPage:Destroy()
	arg0_43.formationPage:Destroy()
	arg0_43.missionFormationPage:Destroy()
	arg0_43.missionInfoPage:Destroy()
	arg0_43.showAssultShipPage:Destroy()
	arg0_43.eventPage:Destroy()
	arg0_43.shipEquipmentsPage:Destroy()

	if arg0_43.missionBossPage then
		arg0_43.missionBossPage:Destroy()
	end

	if isActive(pg.MsgboxMgr.GetInstance()._go) then
		triggerButton(pg.MsgboxMgr.GetInstance()._closeBtn)
	end
end

return var0_0
