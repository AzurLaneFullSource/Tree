local var0_0 = class("NewMainClassicTheme", import(".NewMainSceneBaseTheme"))

function var0_0.getUIName(arg0_1)
	return "NewMainClassicTheme"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.adapterView = MainAdpterView.New(arg0_2._tf:Find("top_bg"), arg0_2._tf:Find("bottom_bg"), arg0_2._tf:Find("bg/right"))

	arg0_2.changeView:SetAsmrTurnningParent(arg0_2._tf:Find("frame/right/asmrToggleContainer"))
end

function var0_0.PlayEnterAnimation(arg0_3, arg1_3, arg2_3)
	arg0_3.adapterView:Init()
	var0_0.super.PlayEnterAnimation(arg0_3, arg1_3, arg2_3)
end

function var0_0._FoldPanels(arg0_4, arg1_4, arg2_4)
	var0_0.super._FoldPanels(arg0_4, arg1_4, arg2_4)
	arg0_4.adapterView:Fold(arg1_4, arg2_4)
end

function var0_0.OnDestroy(arg0_5)
	var0_0.super.OnDestroy(arg0_5)

	if arg0_5.adapterView then
		arg0_5.adapterView:Dispose()

		arg0_5.adapterView = nil
	end
end

function var0_0.SetEffectPanelVisible(arg0_6, arg1_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.panels) do
		if isa(iter1_6, MainRightPanel) then
			iter1_6:SetEffectVisible(arg1_6)
		end
	end
end

function var0_0.GetCalibrationBG(arg0_7)
	return "mainui_calibration"
end

function var0_0.GetPbList(arg0_8)
	return {
		arg0_8._tf:Find("frame/chatPreview"),
		arg0_8._tf:Find("frame/eventPanel")
	}
end

function var0_0.GetPaintingOffset(arg0_9, arg1_9)
	return MainPaintingShift.New({
		-600,
		-10,
		170,
		0,
		170,
		0,
		1,
		1,
		1
	})
end

function var0_0.GetWordView(arg0_10)
	return MainWordView.New(arg0_10._tf:Find("chat"), arg0_10.event)
end

function var0_0.GetTagView(arg0_11)
	return MainTagsView.New(arg0_11._tf:Find("frame/bottom/tags"), arg0_11.event)
end

function var0_0.GetTopPanel(arg0_12)
	return MainTopPanel.New(arg0_12._tf:Find("frame/top"), arg0_12.event, arg0_12.contextData)
end

function var0_0.GetRightPanel(arg0_13)
	return MainRightPanel.New(arg0_13._tf:Find("frame/right"), arg0_13.event, arg0_13.contextData)
end

function var0_0.GetLeftPanel(arg0_14)
	return MainLeftPanel.New(arg0_14._tf:Find("frame/left"), arg0_14.event, arg0_14.contextData)
end

function var0_0.GetBottomPanel(arg0_15)
	return MainBottomPanel.New(arg0_15._tf:Find("frame/bottom"), arg0_15.event, arg0_15.contextData)
end

function var0_0.GetIconView(arg0_16)
	return MainIconView.New(arg0_16._tf:Find("frame/char"))
end

function var0_0.GetChatRoomView(arg0_17)
	return MainChatRoomView.New(arg0_17._tf:Find("frame/chatPreview"), arg0_17.event)
end

function var0_0.GetBannerView(arg0_18)
	return MainBannerView.New(arg0_18._tf:Find("frame/eventPanel"), arg0_18.event)
end

function var0_0.GetActBtnView(arg0_19)
	return MainActivityBtnView.New(arg0_19._tf:Find("frame/linkBtns"), arg0_19.event)
end

function var0_0.GetBuffView(arg0_20)
	return MainBuffView.New(arg0_20._tf:Find("frame/buffs"), arg0_20.event)
end

function var0_0.GetCalibrationView(arg0_21)
	return MainCalibrationPage.New(arg0_21._tf, arg0_21.event)
end

function var0_0.GetChangeSkinView(arg0_22)
	return MainChangeSkinView.New(arg0_22._tf:Find("frame/bottom/change_skin"), arg0_22.event)
end

function var0_0.GetAsmrChatView(arg0_23)
	return MainAsmrChatView.New(arg0_23._tf:Find("frame/bottom/asmr_chat"), arg0_23.event)
end

function var0_0.RegisterRedDots(arg0_24)
	local var0_24 = pg.EasyRedDotMgr.GetInstance()
	local var1_24 = {}

	local function var2_24(arg0_25, arg1_25, arg2_25)
		var0_24:RegisterRedDot(arg0_25, arg1_25, arg2_25)
		table.insert(var1_24, arg0_25)
	end

	var2_24(arg0_24._tf:Find("frame/bottom/taskButton/tip"), {
		"TASK"
	}, function(arg0_26)
		setActive(arg0_26, getProxy(TaskProxy):getCanReceiveCount() > 0 or getProxy(AvatarFrameProxy):getCanReceiveCount() > 0)
	end)

	local var3_24 = arg0_24._tf:Find("frame/right/mailButton")
	local var4_24 = findTF(var3_24, "unread")
	local var5_24 = findTF(var3_24, "read")
	local var6_24 = findTF(var3_24, "attachmentLabel")
	local var7_24 = findTF(var6_24, "attachmentCountText"):GetComponent(typeof(Text))
	local var8_24 = getProxy(MailProxy)

	if var8_24.total == math.clamp(var8_24.total, MAIL_COUNT_LIMIT * 0.9, MAIL_COUNT_LIMIT) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("warning_mail_max_1", var8_24.total, MAIL_COUNT_LIMIT))
	end

	var2_24(var3_24, {
		"MAIL"
	}, function(arg0_27)
		local var0_27 = getProxy(MailProxy):GetUnreadCount()
		local var1_27 = 99

		if var0_27 > 0 then
			SetActive(var6_24, true)
			SetActive(var5_24, false)
			SetActive(var4_24, true)

			arg0_27:GetComponent(typeof(Button)).targetGraphic = var4_24:GetComponent(typeof(Image))
			var7_24.text = var1_27 < var0_27 and var1_27 .. "+" or tostring(var0_27)
		else
			SetActive(var5_24, true)
			SetActive(var4_24, false)
			SetActive(var6_24, false)

			arg0_27:GetComponent(typeof(Button)).targetGraphic = var5_24:GetComponent(typeof(Image))
		end
	end)
	var2_24(arg0_24._tf:Find("frame/bottom/buildButton/tip"), {
		"BUILD"
	}, function(arg0_28)
		setActive(arg0_28, getProxy(BuildShipProxy):getFinishCount() > 0 or tobool(getProxy(ActivityProxy):IsShowFreeBuildMark(true)))
	end)
	var2_24(arg0_24._tf:Find("frame/bottom/guildButton/tip"), {
		"GUILD"
	}, function(arg0_29)
		setActive(arg0_29, getProxy(GuildProxy):ShouldShowTip())
	end)
	var2_24(arg0_24._tf:Find("frame/top/tip"), {
		"ATTIRE"
	}, function(arg0_30)
		setActive(arg0_30, getProxy(AttireProxy):IsShowRedDot() or getProxy(SettingsProxy):ShouldEducateCharTip() or getProxy(ActivityProxy):IsTipLoveLetterMail())
	end)
	var2_24(arg0_24._tf:Find("frame/right/memoryButton/tip"), {
		"MEMORY_REVIEW"
	}, function(arg0_31)
		local var0_31 = getProxy(PlayerProxy):getRawData()
		local var1_31 = var0_31 and _.any(pg.memory_group.all, function(arg0_32)
			return PlayerPrefs.GetInt("MEMORY_GROUP_NOTIFICATION" .. var0_31.id .. " " .. arg0_32, 0) == 1
		end)

		if not var1_31 and getProxy(LoveLetterProxy):getRawData() and getProxy(LoveLetterProxy):IsTipUnlockLetter() then
			var1_31 = true
		end

		setActive(arg0_31, tobool(var1_31))
	end)
	var2_24(arg0_24._tf:Find("frame/right/collectionButton/tip"), {
		"COLLECTION"
	}, function(arg0_33)
		setActive(arg0_33, getProxy(CollectionProxy):hasFinish() or getProxy(AppreciateProxy):isGalleryHaveNewRes() or getProxy(AppreciateProxy):isMusicHaveNewRes() or getProxy(AppreciateProxy):isMangaHaveNewRes())
	end)
	var2_24(arg0_24._tf:Find("frame/right/friendButton/tip"), {
		"FRIEND"
	}, function(arg0_34)
		setActive(arg0_34, getProxy(NotificationProxy):getRequestCount() > 0 or getProxy(FriendProxy):getNewMsgCount() > 0)
	end)
	var2_24(arg0_24._tf:Find("frame/left/commissionButton/tip"), {
		"COMMISSION"
	}, function(arg0_35)
		setActive(arg0_35, getProxy(PlayerProxy):IsShowCommssionTip())
	end)
	var2_24(arg0_24._tf:Find("frame/right/settingButton/tip"), {
		"SETTING"
	}, function(arg0_36)
		setActive(arg0_36, PlayerPrefs.GetInt("firstIntoOtherPanel", 0) == 0)
	end)
	var2_24(arg0_24._tf:Find("frame/right/noticeButton/tip"), {
		"SERVER"
	}, function(arg0_37)
		local var0_37 = getProxy(ServerNoticeProxy):getServerNotices(false)

		setActive(arg0_37, #var0_37 > 0 and getProxy(ServerNoticeProxy):hasNewNotice())
	end)
	var2_24(arg0_24._tf:Find("frame/bottom/technologyButton/tip"), {
		"BLUEPRINT"
	}, function(arg0_38)
		setActive(arg0_38, getProxy(TechnologyProxy):IsShowTip())
	end)
	var2_24(arg0_24._tf:Find("frame/right/combatBtn/tip"), {
		"EVENT"
	}, function(arg0_39)
		setActive(arg0_39, getProxy(EventProxy):hasFinishState() or LimitChallengeConst.IsShowRedPoint())
	end)
	var2_24(arg0_24._tf:Find("frame/bottom/liveButton/tip"), {
		"COURTYARD",
		"SCHOOL",
		"COMMANDER",
		"DORM3D_SHOP_TIMELIMIT",
		"EDUCATE_NEW_CHILD",
		"ISLAND_3D"
	}, function(arg0_40)
		local var0_40 = getProxy(PlayerProxy):getRawData()
		local var1_40 = false

		if var0_40.level >= 40 then
			local var2_40 = getProxy(CommanderProxy):IsFinishAllBox()

			if not LOCK_CATTERY then
				var1_40 = var2_40 or getProxy(CommanderProxy):AnyCatteryExistOP() or getProxy(CommanderProxy):AnyCatteryCanUse()
			else
				var1_40 = var2_40
			end
		end

		local var3_40 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_40.level, "SelectDorm3DMediator")

		setActive(arg0_40, getProxy(DormProxy):IsShowRedDot() or getProxy(NavalAcademyProxy):IsShowTip() or var1_40 or var3_40 and Dorm3dShopUI.ShouldShowAllTip() or NewEducateHelper.IsShowNewChildTip() or getProxy(SystemTipProxy):IsIslandRedDotTip())
	end)

	return var1_24
end

function var0_0.OnAsmrTurnning(arg0_41, arg1_41)
	var0_0.super.OnAsmrTurnning(arg0_41, arg1_41)
	setActive(findTF(arg0_41._tf, "top_bg"), not arg1_41)
	setActive(findTF(arg0_41._tf, "bottom_bg"), not arg1_41)
	setActive(findTF(arg0_41._tf, "bg"), not arg1_41)

	GetOrAddComponent(findTF(arg0_41._tf, "frame"), typeof(CanvasGroup)).alpha = arg1_41 ~= true and 1 or 0
	GetOrAddComponent(findTF(arg0_41._tf, "frame"), typeof(CanvasGroup)).interactable = arg1_41 ~= true and true or false
end

return var0_0
