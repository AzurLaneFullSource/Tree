local var0 = class("LoadPlayerDataCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.isNewPlayer
	local var2 = var0.id

	originalPrint("loading player data: " .. var2)
	arg0.facade:registerProxy(PlayerProxy.New())
	arg0.facade:registerProxy(BayProxy.New({}))
	arg0.facade:registerProxy(FleetProxy.New({}))
	arg0.facade:registerProxy(EquipmentProxy.New({}))
	arg0.facade:registerProxy(ChapterProxy.New({}))
	arg0.facade:registerProxy(WorldProxy.New({}))
	arg0.facade:registerProxy(BagProxy.New({}))
	arg0.facade:registerProxy(TaskProxy.New({}))
	arg0.facade:registerProxy(MailProxy.New({}))
	arg0.facade:registerProxy(NavalAcademyProxy.New({}))
	arg0.facade:registerProxy(DormProxy.New({}))
	arg0.facade:registerProxy(ChatProxy.New({}))
	arg0.facade:registerProxy(FriendProxy.New({}))
	arg0.facade:registerProxy(NotificationProxy.New({}))
	arg0.facade:registerProxy(BuildShipProxy.New({}))
	arg0.facade:registerProxy(CollectionProxy.New({}))
	arg0.facade:registerProxy(EventProxy.New({}))
	arg0.facade:registerProxy(ActivityProxy.New({}))
	arg0.facade:registerProxy(ActivityPermanentProxy.New({}))
	arg0.facade:registerProxy(MilitaryExerciseProxy.New({}))
	arg0.facade:registerProxy(ServerNoticeProxy.New())
	arg0.facade:registerProxy(DailyLevelProxy.New())
	arg0.facade:registerProxy(ShopsProxy.New())
	arg0.facade:registerProxy(GuildProxy.New())
	arg0.facade:registerProxy(VoteProxy.New())
	arg0.facade:registerProxy(ChallengeProxy.New())
	arg0.facade:registerProxy(CommanderProxy.New())
	arg0.facade:registerProxy(ColoringProxy.New())
	arg0.facade:registerProxy(AnswerProxy.New())
	arg0.facade:registerProxy(TechnologyProxy.New())
	arg0.facade:registerProxy(BillboardProxy.New())
	arg0.facade:registerProxy(MetaCharacterProxy.New())
	arg0.facade:registerProxy(TechnologyNationProxy.New())
	arg0.facade:registerProxy(AttireProxy.New())
	arg0.facade:registerProxy(ShipSkinProxy.New())
	arg0.facade:registerProxy(SecondaryPWDProxy.New({}))
	arg0.facade:registerProxy(SkirmishProxy.New())
	arg0.facade:registerProxy(PrayProxy.New())
	arg0.facade:registerProxy(EmojiProxy.New())
	arg0.facade:registerProxy(MiniGameProxy.New())
	arg0.facade:registerProxy(InstagramProxy.New())
	arg0.facade:registerProxy(AppreciateProxy.New())
	arg0.facade:registerProxy(AvatarFrameProxy.New())
	arg0.facade:registerProxy(ActivityTaskProxy.New())
	arg0.facade:registerProxy(RefluxProxy.New())
	arg0.facade:registerProxy(IslandProxy.New())
	arg0.facade:registerProxy(LimitChallengeProxy.New())
	arg0.facade:registerProxy(GameRoomProxy.New())
	arg0.facade:registerProxy(FeastProxy.New())

	if not LOCK_EDUCATE_SYSTEM then
		arg0.facade:registerProxy(EducateProxy.New())
	end

	arg0.facade:registerProxy(ApartmentProxy.New())
	pg.ConnectionMgr.GetInstance():setPacketIdx(1)
	pg.ConnectionMgr.GetInstance():Send(11001, {
		timestamp = 0
	}, 11002, function(arg0)
		originalPrint("player loaded: " .. arg0.timestamp)
		pg.TimeMgr.GetInstance():SetServerTime(arg0.timestamp, arg0.monday_0oclock_timestamp)

		local var0 = getProxy(PlayerProxy):getRawData()
		local var1, var2 = getProxy(ActivityProxy):isSurveyOpen()

		if var1 then
			arg0:sendNotification(GAME.GET_SURVEY_STATE, {
				surveyID = var2
			})
		end

		if var1 then
			pg.PushNotificationMgr.GetInstance():Reset()
			pg.SdkMgr.GetInstance():CreateRole(var0.id, var0.name, var0.level, var0.registerTime, var0:getTotalGem())
		end

		pg.SeriesGuideMgr.GetInstance():setPlayer(var0)
		WorldGuider.GetInstance():Init()

		local var3 = getProxy(UserProxy):getData()
		local var4 = getProxy(ServerProxy)
		local var5 = var4:getLastServer(var3.uid)

		pg.SdkMgr.GetInstance():EnterServer(tostring(var5.id), var5.name, var0.id, var0.name, var0.registerTime, var0.level, var0:getTotalGem())
		var4:recordLoginedServer(var3.uid, var5.id)
		getProxy(MetaCharacterProxy):requestMetaTacticsInfo(nil, true)
		arg0:sendNotification(GAME.REQUEST_META_PT_DATA, {
			isAll = true
		})
		arg0:sendNotification(GAME.GET_SEASON_INFO)
		arg0:sendNotification(GAME.GET_GUILD_INFO)
		arg0:sendNotification(GAME.GET_PUBLIC_GUILD_USER_DATA, {})
		arg0:sendNotification(GAME.REQUEST_MINI_GAME, {
			type = MiniGameRequestCommand.REQUEST_HUB_DATA
		})
		LimitChallengeConst.RequestInfo()

		if not LOCK_EDUCATE_SYSTEM then
			arg0:sendNotification(GAME.EDUCATE_REQUEST)
		end

		pg.SdkMgr.GetInstance():BindCPU()
		pg.SecondaryPWDMgr.GetInstance():FetchData()
		MonthCardOutDateTipPanel.SetMonthCardEndDateLocal()
		pg.NewStoryMgr.GetInstance():Fix()
		getProxy(SettingsProxy):ResetTimeLimitSkinShopTip()
		getProxy(SettingsProxy):ResetContinuousOperationAutoSub()
		getProxy(PlayerProxy):setInited(true)

		if MainCheckShipNumSequence.New():Check(arg0.ship_count) then
			arg0:sendNotification(GAME.LOAD_PLAYER_DATA_DONE)
		end
	end, nil, 60)
end

return var0
