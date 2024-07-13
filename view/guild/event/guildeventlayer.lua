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

function var0_0.UpdateGuild(arg0_10, arg1_10)
	arg0_10:SetGuild(arg1_10)

	if arg0_10.formationPage and arg0_10.formationPage:GetLoaded() then
		arg0_10.formationPage:UpdateData(arg0_10.guildVO, arg0_10.player, {
			fleet = arg0_10.myAssaultFleet
		})
	end

	if arg0_10.eventPage and arg0_10.eventPage:GetLoaded() then
		arg0_10.eventPage:UpdateData(arg0_10.guildVO, arg0_10.player, arg0_10.events)
	end

	if arg0_10.eventInfoPage and arg0_10.eventInfoPage:GetLoaded() and arg0_10.eventInfoPage:isShowing() then
		arg0_10.eventInfoPage:Refresh(arg1_10, arg0_10.player)
	end

	if arg0_10.showAssultShipPage and arg0_10.showAssultShipPage:GetLoaded() and arg0_10.showAssultShipPage:isShowing() then
		arg0_10:OnMemberAssultFleetUpdate()
	end
end

function var0_0.RefreshMission(arg0_11, arg1_11)
	local var0_11 = arg0_11.activeEvent:GetMissionById(arg1_11)

	if arg0_11.eventPage and arg0_11.eventPage:GetLoaded() then
		arg0_11.eventPage:OnRefreshNode(arg0_11.activeEvent, var0_11)
	end

	if arg0_11.missionInfoPage and arg0_11.missionInfoPage:GetLoaded() then
		arg0_11.missionInfoPage:OnRefreshMission(var0_11)
	end

	if arg0_11.missionFormationPage and arg0_11.missionFormationPage:GetLoaded() then
		arg0_11.missionFormationPage:OnRefreshMission(var0_11)
	end
end

function var0_0.RefreshBossMission(arg0_12, arg1_12)
	local var0_12 = arg0_12.activeEvent:GetBossMission()

	if arg0_12.eventPage and arg0_12.eventPage:GetLoaded() then
		arg0_12.eventPage:OnRefreshNode(arg0_12.activeEvent, var0_12)
	end

	if arg0_12.missionBossPage and arg0_12.missionBossPage:GetLoaded() then
		arg0_12.missionBossPage:UpdateMission(var0_12)
		arg0_12.missionBossPage:UpdateView()
	end
end

function var0_0.OnBossRankUpdate(arg0_13)
	local var0_13 = arg0_13.activeEvent:GetBossMission()

	if arg0_13.missionBossPage and arg0_13.missionBossPage:GetLoaded() then
		arg0_13.missionBossPage:UpdateMission(var0_13)
		arg0_13.missionBossPage:UpdateRank()
	end
end

function var0_0.OnBossMissionFormationChanged(arg0_14)
	local var0_14 = arg0_14.activeEvent:GetBossMission()

	if arg0_14.missionBossPage and arg0_14.missionBossPage:GetLoaded() then
		arg0_14.missionBossPage:UpdateMission(var0_14)
	end

	if arg0_14.missBossForamtionPage and arg0_14.missBossForamtionPage:GetLoaded() then
		arg0_14.missBossForamtionPage:UpdateMission(var0_14, false)
	end
end

function var0_0.OnMemberAssultFleetUpdate(arg0_15)
	if arg0_15.showAssultShipPage and arg0_15.showAssultShipPage:GetLoaded() then
		arg0_15.showAssultShipPage:UpdateData(arg0_15.guildVO, arg0_15.player)
	end
end

function var0_0.OnMyAssultFleetUpdate(arg0_16)
	if arg0_16.formationPage and arg0_16.formationPage:GetLoaded() then
		arg0_16.formationPage:OnFleetUpdated(arg0_16.myAssaultFleet)
	end
end

function var0_0.OnMyAssultFleetFormationDone(arg0_17)
	if arg0_17.formationPage and arg0_17.formationPage:GetLoaded() then
		arg0_17.formationPage:OnFleetFormationDone()
	end
end

function var0_0.OnReportUpdated(arg0_18)
	if arg0_18.eventPage and arg0_18.eventPage:GetLoaded() then
		arg0_18.eventPage:OnReportUpdated()
	end

	if arg0_18.missionBossPage and arg0_18.missionBossPage:GetLoaded() then
		arg0_18.missionBossPage:OnReportUpdated()
	end
end

function var0_0.OnMissionFormationDone(arg0_19)
	if arg0_19.missionFormationPage and arg0_19.missionFormationPage:GetLoaded() and arg0_19.missionFormationPage:isShowing() then
		arg0_19.missionFormationPage:OnFormationDone()
	end
end

function var0_0.OnMemberDeleted(arg0_20)
	if arg0_20.missionBossPage and arg0_20.missionBossPage:GetLoaded() then
		arg0_20.missionBossPage:CheckFleetShipState()
	end
end

function var0_0.OnAssultShipBeRecommanded(arg0_21, arg1_21)
	if arg0_21.showAssultShipPage and arg0_21.showAssultShipPage:GetLoaded() then
		arg0_21.showAssultShipPage:OnAssultShipBeRecommanded(arg1_21)
	end
end

function var0_0.OnRefreshAllAssultShipRecommandState(arg0_22)
	if arg0_22.showAssultShipPage and arg0_22.showAssultShipPage:GetLoaded() then
		arg0_22.showAssultShipPage:OnRefreshAll()
	end
end

function var0_0.OnBossCommanderFormationChange(arg0_23)
	if arg0_23.missBossForamtionPage and arg0_23.missBossForamtionPage:GetLoaded() then
		arg0_23.missBossForamtionPage:OnBossCommanderFormationChange()
	end
end

function var0_0.OnBossCommanderPrefabFormationChange(arg0_24)
	if arg0_24.missBossForamtionPage and arg0_24.missBossForamtionPage:GetLoaded() then
		arg0_24.missBossForamtionPage:OnBossCommanderPrefabFormationChange()
	end
end

function var0_0.init(arg0_25)
	arg0_25:bind(var0_0.OPEN_EVENT_INFO, function(arg0_26, arg1_26)
		arg0_25.eventInfoPage:ExecuteAction("Show", arg0_25.guildVO, arg0_25.player, {
			gevent = arg1_26
		})
	end)
	arg0_25:bind(var0_0.ON_OPEN_FORMATION, function(arg0_27)
		arg0_25.formationPage:ExecuteAction("Show", arg0_25.guildVO, arg0_25.player, {
			fleet = arg0_25.myAssaultFleet
		})
	end)
	arg0_25:bind(var0_0.ON_OPEN_MISSION, function(arg0_28, arg1_28)
		arg0_25.missionInfoPage:ExecuteAction("Show", arg0_25.guildVO, arg0_25.player, {
			mission = arg1_28
		})
	end)
	arg0_25:bind(var0_0.OPEN_MISSION_FORAMTION, function(arg0_29, arg1_29)
		arg0_25.missionFormationPage:ExecuteAction("Show", arg0_25.guildVO, arg0_25.player, {
			mission = arg1_29,
			shipCnt = GuildConst.MISSION_MAX_SHIP_CNT
		})
	end)
	arg0_25:bind(var0_0.ON_OPEN_BOSS, function(arg0_30, arg1_30)
		arg0_25.missionBossPage:ExecuteAction("Show", arg1_30)
	end)
	arg0_25:bind(var0_0.ON_OPEN_BOSS_FORMATION, function(arg0_31, arg1_31)
		arg0_25.missBossForamtionPage:ExecuteAction("Show", arg0_25.guildVO, arg0_25.player, {
			mission = arg1_31
		})
	end)
	arg0_25:bind(var0_0.OPEN_BOSS_ASSULT, function()
		arg0_25.showAssultShipPage:ExecuteAction("Show", arg0_25.guildVO, arg0_25.player)
	end)
	arg0_25:bind(var0_0.SHOW_SHIP_EQUIPMENTS, function(arg0_33, arg1_33, arg2_33, arg3_33)
		arg0_25.shipEquipmentsPage:ExecuteAction("Show", arg1_33, arg2_33, arg3_33)
	end)

	arg0_25.eventPage = GuildEventPage.New(arg0_25._tf, arg0_25.event, arg0_25.contextData)
	arg0_25.eventInfoPage = GuildEventInfoPage.New(arg0_25._tf, arg0_25.event, arg0_25.contextData)
	arg0_25.formationPage = GuildEventFormationPage.New(arg0_25._tf, arg0_25.event, arg0_25.contextData)
	arg0_25.missionInfoPage = GuildMissionInfoPage.New(arg0_25._tf, arg0_25.event, arg0_25.contextData)
	arg0_25.missionFormationPage = GuildMissionFormationPage.New(arg0_25._tf, arg0_25.event, arg0_25.contextData)
	arg0_25.missionBossPage = GuildMissionBossPage.New(arg0_25._tf, arg0_25.event, arg0_25.contextData)
	arg0_25.missBossForamtionPage = GuildMissionBossFormationPage.New(arg0_25._tf, arg0_25.event, arg0_25.contextData)
	arg0_25.showAssultShipPage = GuildShowAssultShipPage.New(arg0_25._tf, arg0_25.event, arg0_25.contextData)
	arg0_25.shipEquipmentsPage = GuildShipEquipmentsPage.New(arg0_25._tf, arg0_25.event, arg0_25.contextData)
	arg0_25.helpBtn = arg0_25:findTF("frame/help")
end

function var0_0.didEnter(arg0_34)
	getProxy(GuildProxy):SetBattleBtnRecord()
	onButton(arg0_34, arg0_34.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.guild_event_help_tip.tip
		})
	end, SFX_PANEL)
	arg0_34:EnterEvent()
	arg0_34:TryPlayGuide()
end

function var0_0.TryPlayGuide(arg0_36)
	pg.SystemGuideMgr.GetInstance():PlayGuildAssaultFleet()
end

function var0_0.EnterEvent(arg0_37)
	if not arg0_37:isLoaded() then
		return
	end

	local var0_37 = arg0_37.activeEvent and arg0_37.activeEvent:GetBossMission()

	if arg0_37.activeEvent and var0_37 and var0_37:IsActive() and not var0_37:IsDeath() and arg0_37.activeEvent:IsParticipant() then
		arg0_37.missionBossPage:ExecuteAction("Show", var0_37)
	else
		arg0_37.eventPage:ExecuteAction("Show", arg0_37.guildVO, arg0_37.player, arg0_37.events)
	end

	if arg0_37.missionBossPage and arg0_37.missionBossPage:GetLoaded() and not arg0_37.activeEvent then
		arg0_37.missionBossPage:Destroy()

		arg0_37.missionBossPage = nil
	end

	if arg0_37.activeEvent and arg0_37.eventInfoPage and arg0_37.eventInfoPage:GetLoaded() and arg0_37.activeEvent:IsParticipant() then
		arg0_37.eventInfoPage:Destroy()

		arg0_37.eventInfoPage = nil
	end
end

function var0_0.OnEventEnd(arg0_38)
	arg0_38:EnterEvent()
end

function var0_0.onBackPressed(arg0_39)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0_39:emit(var0_0.ON_BACK)
end

function var0_0.willExit(arg0_40)
	if arg0_40.eventInfoPage then
		arg0_40.eventInfoPage:Destroy()
	end

	arg0_40.missBossForamtionPage:Destroy()
	arg0_40.formationPage:Destroy()
	arg0_40.missionFormationPage:Destroy()
	arg0_40.missionInfoPage:Destroy()
	arg0_40.showAssultShipPage:Destroy()
	arg0_40.eventPage:Destroy()
	arg0_40.shipEquipmentsPage:Destroy()

	if arg0_40.missionBossPage then
		arg0_40.missionBossPage:Destroy()
	end

	if isActive(pg.MsgboxMgr:GetInstance()._go) then
		triggerButton(pg.MsgboxMgr:GetInstance()._closeBtn)
	end
end

return var0_0
