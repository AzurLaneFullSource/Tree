local var0_0 = class("LoadPlayerDataCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.isNewPlayer
	local var2_1 = var0_1.id

	originalPrint("loading player data: " .. var2_1)
	arg0_1.facade:registerProxy(PlayerProxy.New())
	arg0_1.facade:registerProxy(BayProxy.New({}))
	arg0_1.facade:registerProxy(FleetProxy.New({}))
	arg0_1.facade:registerProxy(EquipmentProxy.New({}))
	arg0_1.facade:registerProxy(ChapterProxy.New({}))
	arg0_1.facade:registerProxy(WorldProxy.New({}))
	arg0_1.facade:registerProxy(BagProxy.New({}))
	arg0_1.facade:registerProxy(TaskProxy.New({}))
	arg0_1.facade:registerProxy(MailProxy.New({}))
	arg0_1.facade:registerProxy(NavalAcademyProxy.New({}))
	arg0_1.facade:registerProxy(DormProxy.New({}))
	arg0_1.facade:registerProxy(ChatProxy.New({}))
	arg0_1.facade:registerProxy(FriendProxy.New({}))
	arg0_1.facade:registerProxy(NotificationProxy.New({}))
	arg0_1.facade:registerProxy(BuildShipProxy.New({}))
	arg0_1.facade:registerProxy(CollectionProxy.New({}))
	arg0_1.facade:registerProxy(EventProxy.New({}))
	arg0_1.facade:registerProxy(ActivityProxy.New({}))
	arg0_1.facade:registerProxy(ActivityPermanentProxy.New({}))
	arg0_1.facade:registerProxy(MilitaryExerciseProxy.New({}))
	arg0_1.facade:registerProxy(ServerNoticeProxy.New())
	arg0_1.facade:registerProxy(DailyLevelProxy.New())
	arg0_1.facade:registerProxy(ShopsProxy.New())
	arg0_1.facade:registerProxy(GuildProxy.New())
	arg0_1.facade:registerProxy(VoteProxy.New())
	arg0_1.facade:registerProxy(ChallengeProxy.New())
	arg0_1.facade:registerProxy(CommanderProxy.New())
	arg0_1.facade:registerProxy(ColoringProxy.New())
	arg0_1.facade:registerProxy(AnswerProxy.New())
	arg0_1.facade:registerProxy(TechnologyProxy.New())
	arg0_1.facade:registerProxy(BillboardProxy.New())
	arg0_1.facade:registerProxy(MetaCharacterProxy.New())
	arg0_1.facade:registerProxy(TechnologyNationProxy.New())
	arg0_1.facade:registerProxy(AttireProxy.New())
	arg0_1.facade:registerProxy(ShipSkinProxy.New())
	arg0_1.facade:registerProxy(SecondaryPWDProxy.New({}))
	arg0_1.facade:registerProxy(SkirmishProxy.New())
	arg0_1.facade:registerProxy(PrayProxy.New())
	arg0_1.facade:registerProxy(EmojiProxy.New())
	arg0_1.facade:registerProxy(MiniGameProxy.New())
	arg0_1.facade:registerProxy(InstagramProxy.New())
	arg0_1.facade:registerProxy(AppreciateProxy.New())
	arg0_1.facade:registerProxy(AvatarFrameProxy.New())
	arg0_1.facade:registerProxy(ActivityTaskProxy.New())
	arg0_1.facade:registerProxy(RefluxProxy.New())
	arg0_1.facade:registerProxy(IslandProxy.New())
	arg0_1.facade:registerProxy(LimitChallengeProxy.New())
	arg0_1.facade:registerProxy(GameRoomProxy.New())
	arg0_1.facade:registerProxy(FeastProxy.New())

	if not LOCK_EDUCATE_SYSTEM then
		arg0_1.facade:registerProxy(EducateProxy.New())
	end

	arg0_1.facade:registerProxy(ApartmentProxy.New())
	pg.ConnectionMgr.GetInstance():setPacketIdx(1)
	pg.ConnectionMgr.GetInstance():Send(11001, {
		timestamp = 0
	}, 11002, function(arg0_2)
		originalPrint("player loaded: " .. arg0_2.timestamp)
		pg.TimeMgr.GetInstance():SetServerTime(arg0_2.timestamp, arg0_2.monday_0oclock_timestamp)

		local var0_2 = getProxy(PlayerProxy):getRawData()
		local var1_2, var2_2 = getProxy(ActivityProxy):isSurveyOpen()

		if var1_2 then
			arg0_1:sendNotification(GAME.GET_SURVEY_STATE, {
				surveyID = var2_2
			})
		end

		if var1_1 then
			pg.PushNotificationMgr.GetInstance():Reset()
			pg.SdkMgr.GetInstance():CreateRole(var0_2.id, var0_2.name, var0_2.level, var0_2.registerTime, var0_2:getTotalGem())
		end

		pg.SeriesGuideMgr.GetInstance():setPlayer(var0_2)
		WorldGuider.GetInstance():Init()

		local var3_2 = getProxy(UserProxy):getData()
		local var4_2 = getProxy(ServerProxy)
		local var5_2 = var4_2:getLastServer(var3_2.uid)

		pg.SdkMgr.GetInstance():EnterServer(tostring(var5_2.id), var5_2.name, var0_2.id, var0_2.name, var0_2.registerTime, var0_2.level, var0_2:getTotalGem())
		var4_2:recordLoginedServer(var3_2.uid, var5_2.id)
		getProxy(MetaCharacterProxy):requestMetaTacticsInfo(nil, true)
		arg0_1:sendNotification(GAME.REQUEST_META_PT_DATA, {
			isAll = true
		})
		arg0_1:sendNotification(GAME.GET_SEASON_INFO)
		arg0_1:sendNotification(GAME.GET_GUILD_INFO)
		arg0_1:sendNotification(GAME.GET_PUBLIC_GUILD_USER_DATA, {})
		arg0_1:sendNotification(GAME.REQUEST_MINI_GAME, {
			type = MiniGameRequestCommand.REQUEST_HUB_DATA
		})
		LimitChallengeConst.RequestInfo()

		if not LOCK_EDUCATE_SYSTEM then
			arg0_1:sendNotification(GAME.EDUCATE_REQUEST)
		end

		pg.SdkMgr.GetInstance():BindCPU()
		pg.SecondaryPWDMgr.GetInstance():FetchData()
		MonthCardOutDateTipPanel.SetMonthCardEndDateLocal()
		pg.NewStoryMgr.GetInstance():Fix()
		getProxy(SettingsProxy):ResetTimeLimitSkinShopTip()
		getProxy(SettingsProxy):ResetContinuousOperationAutoSub()
		getProxy(PlayerProxy):setInited(true)

		if MainCheckShipNumSequence.New():Check(arg0_2.ship_count) then
			arg0_1:sendNotification(GAME.LOAD_PLAYER_DATA_DONE)
		end
	end, nil, 60)
end

return var0_0
