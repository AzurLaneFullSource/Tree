local var0_0 = class("LogoutCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	arg0_1:sendNotification(GAME.WILL_LOGOUT)

	if PLATFORM ~= PLATFORM_WINDOWSEDITOR and PLATFORM_CHT == PLATFORM_CODE and var0_1.code ~= SDK_EXIT_CODE then
		pg.SdkMgr.GetInstance():LogoutSDK()

		return
	end

	pg.TrackerMgr.GetInstance():Tracking(TRACKING_ROLE_LOGOUT)

	local var1_1 = ys.Battle.BattleState.GetInstance()

	if var1_1:GetState() ~= ys.Battle.BattleState.BATTLE_STATE_IDLE then
		warning("stop and clean battle.")
		var1_1:Stop("kick")
	end

	arg0_1:sendNotification(GAME.STOP_BATTLE_LOADING, {})
	pg.NewStoryMgr:GetInstance():Quit()

	if pg.MsgboxMgr.GetInstance()._go.activeSelf then
		pg.MsgboxMgr.GetInstance():hide()
	end

	getProxy(SettingsProxy):Reset()
	originalPrint("disconnect from server...-" .. tostring(var0_1.code))
	pg.ConnectionMgr.GetInstance():Disconnect()

	BillboardMediator.time = nil
	Map.lastMap = nil
	Map.lastMapForActivity = nil
	BuildShipScene.projectName = nil
	DockyardScene.selectAsc = nil
	DockyardScene.sortIndex = nil
	DockyardScene.typeIndex = nil
	DockyardScene.campIndex = nil
	DockyardScene.rarityIndex = nil
	DockyardScene.extraIndex = nil
	DockyardScene.commonTag = nil
	LevelMediator2.prevRefreshBossTimeTime = nil
	ActivityMainScene.FetchReturnersTime = nil
	ActivityMainScene.Data2Time = nil

	pg.BrightnessMgr.GetInstance():ExitManualMode()
	pg.SeriesGuideMgr.GetInstance():dispose()
	pg.NewGuideMgr.GetInstance():Exit()
	PoolMgr.GetInstance():DestroyAllPrefab()
	pg.GuildMsgBoxMgr.GetInstance():Hide()

	local var2_1 = getProxy(UserProxy)

	if var2_1 then
		local var3_1 = var2_1:getRawData()

		if var3_1 then
			var3_1:clear()
		end

		var2_1:SetLoginedFlag(false)
	end

	local function var4_1()
		arg0_1.facade:removeProxy(PlayerProxy.__cname)
		arg0_1.facade:removeProxy(BayProxy.__cname)
		arg0_1.facade:removeProxy(FleetProxy.__cname)
		arg0_1.facade:removeProxy(EquipmentProxy.__cname)
		arg0_1.facade:removeProxy(ChapterProxy.__cname)
		arg0_1.facade:removeProxy(WorldProxy.__cname)
		arg0_1.facade:removeProxy(BagProxy.__cname)
		arg0_1.facade:removeProxy(TaskProxy.__cname)
		arg0_1.facade:removeProxy(MailProxy.__cname)
		arg0_1.facade:removeProxy(NavalAcademyProxy.__cname)
		arg0_1.facade:removeProxy(DormProxy.__cname)
		arg0_1.facade:removeProxy(ChatProxy.__cname)
		arg0_1.facade:removeProxy(FriendProxy.__cname)
		arg0_1.facade:removeProxy(NotificationProxy.__cname)
		arg0_1.facade:removeProxy(BuildShipProxy.__cname)
		arg0_1.facade:removeProxy(CollectionProxy.__cname)
		arg0_1.facade:removeProxy(EventProxy.__cname)
		arg0_1.facade:removeProxy(ActivityProxy.__cname)
		arg0_1.facade:removeProxy(MilitaryExerciseProxy.__cname)
		arg0_1.facade:removeProxy(ServerNoticeProxy.__cname)
		arg0_1.facade:removeProxy(DailyLevelProxy.__cname)
		arg0_1.facade:removeProxy(ShopsProxy.__cname)
		arg0_1.facade:removeProxy(GuildProxy.__cname)
		arg0_1.facade:removeProxy(VoteProxy.__cname)
		arg0_1.facade:removeProxy(ChallengeProxy.__cname)
		arg0_1.facade:removeProxy(ColoringProxy.__cname)
		arg0_1.facade:removeProxy(AnswerProxy.__cname)
		arg0_1.facade:removeProxy(TechnologyProxy.__cname)
		arg0_1.facade:removeProxy(BillboardProxy.__cname)
		arg0_1.facade:removeProxy(TechnologyNationProxy.__cname)
		arg0_1.facade:removeProxy(AttireProxy.__cname)
		arg0_1.facade:removeProxy(ShipSkinProxy.__cname)
		arg0_1.facade:removeProxy(PrayProxy.__cname)
		arg0_1.facade:removeProxy(SecondaryPWDProxy.__cname)
		arg0_1.facade:removeProxy(SkirmishProxy.__cname)
		arg0_1.facade:removeProxy(InstagramProxy.__cname)
		arg0_1.facade:removeProxy(MiniGameProxy.__cname)
		arg0_1.facade:removeProxy(EmojiProxy.__cname)
		arg0_1.facade:removeProxy(AppreciateProxy.__cname)
		arg0_1.facade:removeProxy(MetaCharacterProxy.__cname)
		arg0_1.facade:removeProxy(AvatarFrameProxy.__cname)
		arg0_1.facade:removeProxy(RefluxProxy.__cname)
		arg0_1.facade:removeProxy(IslandProxy.__cname)
		arg0_1.facade:removeProxy(ActivityTaskProxy.__cname)
		arg0_1.facade:removeProxy(FeastProxy.__cname)
		arg0_1.facade:removeProxy(EducateProxy.__cname)
		arg0_1.facade:removeProxy(ApartmentProxy.__cname)
		arg0_1.facade:removeCommand(GAME.LOAD_SCENE_DONE)
	end

	arg0_1:sendNotification(GAME.LOAD_SCENE, {
		context = Context.New({
			cleanStack = true,
			scene = SCENE.LOGIN,
			mediator = LoginMediator,
			viewComponent = LoginScene,
			data = var0_1
		}),
		callback = var4_1
	})

	if var0_1.code ~= SDK_EXIT_CODE then
		pg.SdkMgr.GetInstance():LogoutSDK(var0_1.code)
	end
end

return var0_0
