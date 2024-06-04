local var0 = class("GuildEventLayer", import("...base.BaseUI"))

var0.OPEN_EVENT_INFO = "GuildEventLayer:OPEN_EVENT_INFO"
var0.ON_OPEN_FORMATION = "GuildEventLayer:ON_OPEN_FORMATION"
var0.ON_OPEN_MISSION = "GuildEventLayer:ON_OPEN_MISSION"
var0.OPEN_MISSION_FORAMTION = "GuildEventLayer:OPEN_MISSION_FORAMTION"
var0.ON_OPEN_BOSS = "GuildEventLayer:ON_OPEN_BOSS"
var0.ON_OPEN_BOSS_FORMATION = "GuildEventLayer:ON_OPEN_BOSS_FORMATION"
var0.OPEN_BOSS_ASSULT = "GuildEventLayer:OPEN_BOSS_ASSULT"
var0.SHOW_SHIP_EQUIPMENTS = "GuildEventLayer:SHOW_SHIP_EQUIPMENTS"

function var0.getUIName(arg0)
	return "GuildEmptyUI"
end

function var0.SetPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.SetGuild(arg0, arg1)
	arg0.guildVO = arg1
	arg0.events = {}
	arg0.activeEvent = nil

	arg0:SetEvents(arg1:GetEvents())

	arg0.myAssaultFleet = arg1:getMemberById(arg0.player.id):GetExternalAssaultFleet()
end

function var0.SetEvents(arg0, arg1)
	arg0.events = arg1
	arg0.activeEvent = _.detect(arg0.events, function(arg0)
		return arg0:IsActive()
	end)
end

function var0.UpdateFleet(arg0)
	if arg0.formationPage:GetLoaded() then
		arg0.formationPage:ExecuteAction("OnFleetUpdated", arg0.myAssaultFleet)
	end
end

function var0.preload(arg0, arg1)
	seriesAsync({
		function(arg0)
			pg.m02:sendNotification(GAME.GET_GUILD_REPORT, {
				callback = arg0
			})
		end,
		function(arg0)
			local var0 = getProxy(GuildProxy):getRawData():GetActiveEvent()

			if not var0 then
				pg.m02:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT, {
					force = false,
					callback = arg0
				})
			elseif var0 and var0:IsExpired() then
				pg.m02:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT, {
					force = true,
					callback = arg0
				})
			else
				arg0()
			end
		end
	}, arg1)
end

function var0.UpdateGuild(arg0, arg1)
	arg0:SetGuild(arg1)

	if arg0.formationPage and arg0.formationPage:GetLoaded() then
		arg0.formationPage:UpdateData(arg0.guildVO, arg0.player, {
			fleet = arg0.myAssaultFleet
		})
	end

	if arg0.eventPage and arg0.eventPage:GetLoaded() then
		arg0.eventPage:UpdateData(arg0.guildVO, arg0.player, arg0.events)
	end

	if arg0.eventInfoPage and arg0.eventInfoPage:GetLoaded() and arg0.eventInfoPage:isShowing() then
		arg0.eventInfoPage:Refresh(arg1, arg0.player)
	end

	if arg0.showAssultShipPage and arg0.showAssultShipPage:GetLoaded() and arg0.showAssultShipPage:isShowing() then
		arg0:OnMemberAssultFleetUpdate()
	end
end

function var0.RefreshMission(arg0, arg1)
	local var0 = arg0.activeEvent:GetMissionById(arg1)

	if arg0.eventPage and arg0.eventPage:GetLoaded() then
		arg0.eventPage:OnRefreshNode(arg0.activeEvent, var0)
	end

	if arg0.missionInfoPage and arg0.missionInfoPage:GetLoaded() then
		arg0.missionInfoPage:OnRefreshMission(var0)
	end

	if arg0.missionFormationPage and arg0.missionFormationPage:GetLoaded() then
		arg0.missionFormationPage:OnRefreshMission(var0)
	end
end

function var0.RefreshBossMission(arg0, arg1)
	local var0 = arg0.activeEvent:GetBossMission()

	if arg0.eventPage and arg0.eventPage:GetLoaded() then
		arg0.eventPage:OnRefreshNode(arg0.activeEvent, var0)
	end

	if arg0.missionBossPage and arg0.missionBossPage:GetLoaded() then
		arg0.missionBossPage:UpdateMission(var0)
		arg0.missionBossPage:UpdateView()
	end
end

function var0.OnBossRankUpdate(arg0)
	local var0 = arg0.activeEvent:GetBossMission()

	if arg0.missionBossPage and arg0.missionBossPage:GetLoaded() then
		arg0.missionBossPage:UpdateMission(var0)
		arg0.missionBossPage:UpdateRank()
	end
end

function var0.OnBossMissionFormationChanged(arg0)
	local var0 = arg0.activeEvent:GetBossMission()

	if arg0.missionBossPage and arg0.missionBossPage:GetLoaded() then
		arg0.missionBossPage:UpdateMission(var0)
	end

	if arg0.missBossForamtionPage and arg0.missBossForamtionPage:GetLoaded() then
		arg0.missBossForamtionPage:UpdateMission(var0, false)
	end
end

function var0.OnMemberAssultFleetUpdate(arg0)
	if arg0.showAssultShipPage and arg0.showAssultShipPage:GetLoaded() then
		arg0.showAssultShipPage:UpdateData(arg0.guildVO, arg0.player)
	end
end

function var0.OnMyAssultFleetUpdate(arg0)
	if arg0.formationPage and arg0.formationPage:GetLoaded() then
		arg0.formationPage:OnFleetUpdated(arg0.myAssaultFleet)
	end
end

function var0.OnMyAssultFleetFormationDone(arg0)
	if arg0.formationPage and arg0.formationPage:GetLoaded() then
		arg0.formationPage:OnFleetFormationDone()
	end
end

function var0.OnReportUpdated(arg0)
	if arg0.eventPage and arg0.eventPage:GetLoaded() then
		arg0.eventPage:OnReportUpdated()
	end

	if arg0.missionBossPage and arg0.missionBossPage:GetLoaded() then
		arg0.missionBossPage:OnReportUpdated()
	end
end

function var0.OnMissionFormationDone(arg0)
	if arg0.missionFormationPage and arg0.missionFormationPage:GetLoaded() and arg0.missionFormationPage:isShowing() then
		arg0.missionFormationPage:OnFormationDone()
	end
end

function var0.OnMemberDeleted(arg0)
	if arg0.missionBossPage and arg0.missionBossPage:GetLoaded() then
		arg0.missionBossPage:CheckFleetShipState()
	end
end

function var0.OnAssultShipBeRecommanded(arg0, arg1)
	if arg0.showAssultShipPage and arg0.showAssultShipPage:GetLoaded() then
		arg0.showAssultShipPage:OnAssultShipBeRecommanded(arg1)
	end
end

function var0.OnRefreshAllAssultShipRecommandState(arg0)
	if arg0.showAssultShipPage and arg0.showAssultShipPage:GetLoaded() then
		arg0.showAssultShipPage:OnRefreshAll()
	end
end

function var0.OnBossCommanderFormationChange(arg0)
	if arg0.missBossForamtionPage and arg0.missBossForamtionPage:GetLoaded() then
		arg0.missBossForamtionPage:OnBossCommanderFormationChange()
	end
end

function var0.OnBossCommanderPrefabFormationChange(arg0)
	if arg0.missBossForamtionPage and arg0.missBossForamtionPage:GetLoaded() then
		arg0.missBossForamtionPage:OnBossCommanderPrefabFormationChange()
	end
end

function var0.init(arg0)
	arg0:bind(var0.OPEN_EVENT_INFO, function(arg0, arg1)
		arg0.eventInfoPage:ExecuteAction("Show", arg0.guildVO, arg0.player, {
			gevent = arg1
		})
	end)
	arg0:bind(var0.ON_OPEN_FORMATION, function(arg0)
		arg0.formationPage:ExecuteAction("Show", arg0.guildVO, arg0.player, {
			fleet = arg0.myAssaultFleet
		})
	end)
	arg0:bind(var0.ON_OPEN_MISSION, function(arg0, arg1)
		arg0.missionInfoPage:ExecuteAction("Show", arg0.guildVO, arg0.player, {
			mission = arg1
		})
	end)
	arg0:bind(var0.OPEN_MISSION_FORAMTION, function(arg0, arg1)
		arg0.missionFormationPage:ExecuteAction("Show", arg0.guildVO, arg0.player, {
			mission = arg1,
			shipCnt = GuildConst.MISSION_MAX_SHIP_CNT
		})
	end)
	arg0:bind(var0.ON_OPEN_BOSS, function(arg0, arg1)
		arg0.missionBossPage:ExecuteAction("Show", arg1)
	end)
	arg0:bind(var0.ON_OPEN_BOSS_FORMATION, function(arg0, arg1)
		arg0.missBossForamtionPage:ExecuteAction("Show", arg0.guildVO, arg0.player, {
			mission = arg1
		})
	end)
	arg0:bind(var0.OPEN_BOSS_ASSULT, function()
		arg0.showAssultShipPage:ExecuteAction("Show", arg0.guildVO, arg0.player)
	end)
	arg0:bind(var0.SHOW_SHIP_EQUIPMENTS, function(arg0, arg1, arg2, arg3)
		arg0.shipEquipmentsPage:ExecuteAction("Show", arg1, arg2, arg3)
	end)

	arg0.eventPage = GuildEventPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.eventInfoPage = GuildEventInfoPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.formationPage = GuildEventFormationPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.missionInfoPage = GuildMissionInfoPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.missionFormationPage = GuildMissionFormationPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.missionBossPage = GuildMissionBossPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.missBossForamtionPage = GuildMissionBossFormationPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.showAssultShipPage = GuildShowAssultShipPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.shipEquipmentsPage = GuildShipEquipmentsPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.helpBtn = arg0:findTF("frame/help")
end

function var0.didEnter(arg0)
	getProxy(GuildProxy):SetBattleBtnRecord()
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.guild_event_help_tip.tip
		})
	end, SFX_PANEL)
	arg0:EnterEvent()
	arg0:TryPlayGuide()
end

function var0.TryPlayGuide(arg0)
	pg.SystemGuideMgr.GetInstance():PlayGuildAssaultFleet()
end

function var0.EnterEvent(arg0)
	if not arg0:isLoaded() then
		return
	end

	local var0 = arg0.activeEvent and arg0.activeEvent:GetBossMission()

	if arg0.activeEvent and var0 and var0:IsActive() and not var0:IsDeath() and arg0.activeEvent:IsParticipant() then
		arg0.missionBossPage:ExecuteAction("Show", var0)
	else
		arg0.eventPage:ExecuteAction("Show", arg0.guildVO, arg0.player, arg0.events)
	end

	if arg0.missionBossPage and arg0.missionBossPage:GetLoaded() and not arg0.activeEvent then
		arg0.missionBossPage:Destroy()

		arg0.missionBossPage = nil
	end

	if arg0.activeEvent and arg0.eventInfoPage and arg0.eventInfoPage:GetLoaded() and arg0.activeEvent:IsParticipant() then
		arg0.eventInfoPage:Destroy()

		arg0.eventInfoPage = nil
	end
end

function var0.OnEventEnd(arg0)
	arg0:EnterEvent()
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0:emit(var0.ON_BACK)
end

function var0.willExit(arg0)
	if arg0.eventInfoPage then
		arg0.eventInfoPage:Destroy()
	end

	arg0.missBossForamtionPage:Destroy()
	arg0.formationPage:Destroy()
	arg0.missionFormationPage:Destroy()
	arg0.missionInfoPage:Destroy()
	arg0.showAssultShipPage:Destroy()
	arg0.eventPage:Destroy()
	arg0.shipEquipmentsPage:Destroy()

	if arg0.missionBossPage then
		arg0.missionBossPage:Destroy()
	end

	if isActive(pg.MsgboxMgr:GetInstance()._go) then
		triggerButton(pg.MsgboxMgr:GetInstance()._closeBtn)
	end
end

return var0
