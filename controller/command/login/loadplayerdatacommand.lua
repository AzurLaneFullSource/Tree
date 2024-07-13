local var0_0 = class("LoadPlayerDataCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.isNewPlayer
	local var2_1 = var0_1.id

	originalPrint("loading player data: " .. var2_1)

	pg.proxyRegister = ProxyRegister.New({
		{
			PlayerProxy,
			true
		},
		{
			BayProxy,
			true,
			{}
		},
		{
			FleetProxy,
			true,
			{}
		},
		{
			EquipmentProxy,
			true,
			{}
		},
		{
			ChapterProxy,
			true,
			{}
		},
		{
			WorldProxy,
			true,
			{}
		},
		{
			BagProxy,
			true,
			{}
		},
		{
			TaskProxy,
			true,
			{}
		},
		{
			MailProxy,
			true,
			{}
		},
		{
			NavalAcademyProxy,
			true,
			{}
		},
		{
			DormProxy,
			true,
			{}
		},
		{
			ChatProxy,
			true,
			{}
		},
		{
			FriendProxy,
			true,
			{}
		},
		{
			NotificationProxy,
			true,
			{}
		},
		{
			BuildShipProxy,
			true,
			{}
		},
		{
			CollectionProxy,
			true,
			{}
		},
		{
			EventProxy,
			true,
			{}
		},
		{
			ActivityProxy,
			true,
			{}
		},
		{
			ActivityPermanentProxy,
			true,
			{}
		},
		{
			MilitaryExerciseProxy,
			true
		},
		{
			ServerNoticeProxy,
			true
		},
		{
			DailyLevelProxy,
			true
		},
		{
			ShopsProxy,
			true
		},
		{
			GuildProxy,
			true
		},
		{
			VoteProxy,
			true
		},
		{
			ChallengeProxy,
			true
		},
		{
			CommanderProxy,
			true
		},
		{
			ColoringProxy,
			true
		},
		{
			AnswerProxy,
			true
		},
		{
			TechnologyProxy,
			true
		},
		{
			BillboardProxy,
			true
		},
		{
			MetaCharacterProxy,
			true
		},
		{
			TechnologyNationProxy,
			true
		},
		{
			AttireProxy,
			true
		},
		{
			ShipSkinProxy,
			true
		},
		{
			SecondaryPWDProxy,
			true,
			{}
		},
		{
			SkirmishProxy,
			true
		},
		{
			PrayProxy,
			true
		},
		{
			EmojiProxy,
			true
		},
		{
			MiniGameProxy,
			true
		},
		{
			InstagramProxy,
			true
		},
		{
			AppreciateProxy,
			true
		},
		{
			AvatarFrameProxy,
			true
		},
		{
			ActivityTaskProxy,
			true
		},
		{
			TotalTaskProxy,
			true
		},
		{
			RefluxProxy,
			true
		},
		{
			IslandProxy,
			true
		},
		{
			LimitChallengeProxy,
			true
		},
		{
			GameRoomProxy,
			true
		},
		{
			FeastProxy,
			true
		},
		{
			EducateProxy,
			not LOCK_EDUCATE_SYSTEM
		},
		{
			ApartmentProxy,
			true
		}
	})

	pg.proxyRegister:RgisterProxy(arg0_1.facade)
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
