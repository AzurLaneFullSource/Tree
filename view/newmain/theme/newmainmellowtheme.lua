local var0_0 = class("NewMainMellowTheme", import(".NewMainSceneBaseTheme"))

function var0_0.getUIName(arg0_1)
	return "NewMainMellowTheme"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.switcherAnimationPlayer = arg0_2._tf:Find("frame/right"):GetComponent(typeof(Animation))
	arg0_2.animationPlayer = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.dftAniEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))
	arg0_2.switcher = arg0_2._tf:Find("frame/right/switch")

	onToggle(arg0_2, arg0_2.switcher, function(arg0_3)
		local var0_3 = arg0_3 and "anim_newmain_switch_1to2" or "anim_newmain_switch_2to1"

		arg0_2.switcherAnimationPlayer:Play(var0_3)
		pg.EasyRedDotMgr.GetInstance():TriggerMarks("COLLECTION", "FRIEND", "MEMORY_REVIEW", "EVENT")
	end, SFX_PANEL)
	arg0_2:Register()
end

function var0_0.Register(arg0_4)
	return
end

function var0_0.PlayEnterAnimation(arg0_5, arg1_5, arg2_5)
	arg0_5.bannerView:Init()
	arg0_5.actBtnView:Init()
	arg0_5.dftAniEvent:SetStartEvent(nil)
	arg0_5.dftAniEvent:SetStartEvent(function()
		arg0_5.dftAniEvent:SetStartEvent(nil)

		arg0_5.mainCG.alpha = 1
	end)
	arg0_5.animationPlayer:Play("anim_newmain_open")
	onDelayTick(arg2_5, 0.51)
end

function var0_0.Refresh(arg0_7, arg1_7)
	var0_0.super.Refresh(arg0_7, arg1_7)
	originalPrint(" >>>>>>>>>> run in play open anim")
	arg0_7.animationPlayer:Play("anim_newmain_open")
end

function var0_0.OnFoldPanels(arg0_8, arg1_8)
	if arg1_8 then
		arg0_8.animationPlayer:Play("anim_newmain_hide")
	else
		arg0_8.animationPlayer:Play("anim_newmain_show")
	end
end

function var0_0.Disable(arg0_9)
	var0_0.super.Disable(arg0_9)
	arg0_9.dftAniEvent:SetStartEvent(nil)
	triggerToggle(arg0_9.switcher, false)
end

function var0_0.OnDestroy(arg0_10)
	var0_0.super.OnDestroy(arg0_10)
	arg0_10.dftAniEvent:SetStartEvent(nil)
end

function var0_0.SetEffectPanelVisible(arg0_11, arg1_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.panels) do
		if isa(iter1_11, MainRightPanel4Mellow) then
			iter1_11:SetEffectVisible(arg1_11)
		end
	end
end

function var0_0.ApplyDefaultResUI(arg0_12)
	return false
end

function var0_0.GetCalibrationBG(arg0_13)
	return "mainui_calibration_mellow"
end

function var0_0.GetPbList(arg0_14)
	return {
		arg0_14._tf:Find("frame/bottom/frame")
	}
end

function var0_0.GetPaintingOffset(arg0_15, arg1_15)
	local var0_15 = pg.ship_skin_newmainui_shift[arg1_15:getSkinId()]

	if var0_15 then
		local var1_15 = arg0_15:GetConfigShift(var0_15)

		return MainPaintingShift.New(var1_15, Vector3(-MainPaintingView.MESH_POSITION_X_OFFSET, -10, 0))
	else
		return MainPaintingShift.New({
			-MainPaintingView.MESH_POSITION_X_OFFSET,
			-10,
			MainPaintingView.MESH_POSITION_X_OFFSET,
			0,
			MainPaintingView.MESH_POSITION_X_OFFSET,
			0,
			1,
			1,
			1
		})
	end
end

function var0_0.GetConfigShift(arg0_16, arg1_16)
	local var0_16 = arg1_16.skin_shift
	local var1_16 = arg1_16.l2d_shift
	local var2_16 = var1_16[1] - var0_16[1]
	local var3_16 = var1_16[2] - var0_16[2]
	local var4_16 = arg1_16.spine_shift
	local var5_16 = var4_16[1] - var0_16[1]
	local var6_16 = var4_16[2] - var0_16[2]

	return {
		var0_16[1],
		var0_16[2],
		var2_16,
		var3_16,
		var5_16,
		var6_16,
		var0_16[4],
		var1_16[4],
		var4_16[4]
	}
end

function var0_0.GetWordView(arg0_17)
	return MainWordView4Mellow.New(arg0_17._tf:Find("chat"), arg0_17.event)
end

function var0_0.GetTagView(arg0_18)
	return MainTagsView.New(arg0_18._tf:Find("frame/bottom/tags"), arg0_18.event)
end

function var0_0.GetTopPanel(arg0_19)
	return MainTopPanel4Mellow.New(arg0_19._tf:Find("frame/top"), arg0_19.event, arg0_19.contextData)
end

function var0_0.GetRightPanel(arg0_20)
	return MainRightPanel4Mellow.New(arg0_20._tf:Find("frame/right"), arg0_20.event, arg0_20.contextData)
end

function var0_0.GetLeftPanel(arg0_21)
	return MainLeftPanel4Mellow.New(arg0_21._tf:Find("frame/left"), arg0_21.event, arg0_21.contextData)
end

function var0_0.GetBottomPanel(arg0_22)
	return MainBottomPanel4Mellow.New(arg0_22._tf:Find("frame/bottom"), arg0_22.event, arg0_22.contextData)
end

function var0_0.GetIconView(arg0_23)
	return MainIconView4Mellow.New(arg0_23._tf:Find("frame/top/icon"), arg0_23.event)
end

function var0_0.GetChatRoomView(arg0_24)
	return MainChatRoomView4Mellow.New(arg0_24._tf:Find("frame/right/chat_room"), arg0_24.event)
end

function var0_0.GetBannerView(arg0_25)
	return MainBannerView4Mellow.New(arg0_25._tf:Find("frame/left/banner"), arg0_25.event)
end

function var0_0.GetActBtnView(arg0_26)
	return MainActivityBtnView4Mellow.New(arg0_26._tf:Find("frame"), arg0_26.event)
end

function var0_0.GetBuffView(arg0_27)
	return MainBuffView4Mellow.New(arg0_27._tf:Find("frame/top/buff_list"), arg0_27.event)
end

function var0_0.GetChangeSkinView(arg0_28)
	return MainChangeSkinView.New(arg0_28._tf:Find("frame/right/change_skin"), arg0_28.event)
end

function var0_0.GetAsmrChatView(arg0_29)
	return MainAsmrChatView.New(arg0_29._tf:Find("frame/bottom/asmr_chat"), arg0_29.event)
end

function var0_0.OnAsmrTurnning(arg0_30, arg1_30)
	var0_0.super.OnAsmrTurnning(arg0_30, arg1_30)
	setActive(findTF(arg0_30._tf, "s"), not arg1_30)
end

function var0_0.RegisterRedDots(arg0_31)
	local var0_31 = pg.EasyRedDotMgr.GetInstance()
	local var1_31 = {}

	local function var2_31(arg0_32, arg1_32, arg2_32)
		var0_31:RegisterRedDot(arg0_32, arg1_32, arg2_32)
		table.insert(var1_31, arg0_32)
	end

	var2_31(arg0_31._tf:Find("frame/bottom/frame/task/tip"), {
		"TASK"
	}, function(arg0_33)
		setActive(arg0_33, getProxy(TaskProxy):getCanReceiveCount() > 0 or getProxy(AvatarFrameProxy):getCanReceiveCount() > 0)
	end)

	local var3_31 = arg0_31._tf:Find("frame/top/btns/mail")
	local var4_31 = findTF(var3_31, "tip")
	local var5_31 = findTF(var3_31, "Text"):GetComponent(typeof(Text))
	local var6_31 = getProxy(MailProxy)

	if var6_31.total >= MAIL_COUNT_LIMIT then
		pg.TipsMgr.GetInstance():ShowTips(i18n("warning_mail_max_2"))
	elseif var6_31.total > MAIL_COUNT_LIMIT * 0.9 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("warning_mail_max_1", var6_31.total, MAIL_COUNT_LIMIT))
	end

	var2_31(var3_31, {
		"MAIL"
	}, function(arg0_34)
		local var0_34 = getProxy(MailProxy):GetUnreadCount()
		local var1_34 = 99

		if var0_34 > 0 then
			SetActive(var4_31, true)

			var5_31.text = var1_34 < var0_34 and var1_34 .. "+" or tostring(var0_34)
		else
			SetActive(var4_31, false)

			var5_31.text = ""
		end
	end)
	var2_31(arg0_31._tf:Find("frame/bottom/frame/build/tip"), {
		"BUILD"
	}, function(arg0_35)
		setActive(arg0_35, getProxy(BuildShipProxy):getFinishCount() > 0 or tobool(getProxy(ActivityProxy):IsShowFreeBuildMark(true)))
	end)
	var2_31(arg0_31._tf:Find("frame/bottom/frame/guild/tip"), {
		"GUILD"
	}, function(arg0_36)
		setActive(arg0_36, getProxy(GuildProxy):ShouldShowTip())
	end)
	var2_31(arg0_31._tf:Find("frame/top/icon_front/tip"), {
		"ATTIRE"
	}, function(arg0_37)
		setActive(arg0_37, getProxy(AttireProxy):IsShowRedDot() or getProxy(SettingsProxy):ShouldEducateCharTip() or getProxy(ActivityProxy):IsTipLoveLetterMail())
	end)
	var2_31(arg0_31._tf:Find("frame/right/2/menor/root/tip"), {
		"MEMORY_REVIEW"
	}, function(arg0_38)
		local var0_38 = getProxy(PlayerProxy):getRawData()
		local var1_38 = var0_38 and _.any(pg.memory_group.all, function(arg0_39)
			return PlayerPrefs.GetInt("MEMORY_GROUP_NOTIFICATION" .. var0_38.id .. " " .. arg0_39, 0) == 1
		end)

		if not var1_38 and getProxy(LoveLetterProxy):getRawData() and getProxy(LoveLetterProxy):IsTipUnlockLetter() then
			var1_38 = true
		end

		setActive(arg0_38, tobool(var1_38))
	end)
	var2_31(arg0_31._tf:Find("frame/right/2/collection/root/tip"), {
		"COLLECTION"
	}, function(arg0_40)
		setActive(arg0_40, getProxy(CollectionProxy):hasFinish() or getProxy(AppreciateProxy):isGalleryHaveNewRes() or getProxy(AppreciateProxy):isMusicHaveNewRes() or getProxy(AppreciateProxy):isMangaHaveNewRes())
	end)
	var2_31(arg0_31._tf:Find("frame/right/2/friend/root/tip"), {
		"FRIEND"
	}, function(arg0_41)
		setActive(arg0_41, getProxy(NotificationProxy):getRequestCount() > 0 or getProxy(FriendProxy):getNewMsgCount() > 0)
	end)
	var2_31(arg0_31._tf:Find("frame/left/extend/tip"), {
		"COMMISSION"
	}, function(arg0_42)
		setActive(arg0_42, getProxy(PlayerProxy):IsShowCommssionTip())
	end)
	var2_31(arg0_31._tf:Find("frame/top/btns/settings/tip"), {
		"SETTING"
	}, function(arg0_43)
		setActive(arg0_43, PlayerPrefs.GetInt("firstIntoOtherPanel", 0) == 0)
	end)
	var2_31(arg0_31._tf:Find("frame/top/btns/noti/tip"), {
		"SERVER"
	}, function(arg0_44)
		local var0_44 = getProxy(ServerNoticeProxy):getServerNotices(false)

		setActive(arg0_44, #var0_44 > 0 and getProxy(ServerNoticeProxy):hasNewNotice())
	end)
	var2_31(arg0_31._tf:Find("frame/bottom/frame/tech/tip"), {
		"BLUEPRINT"
	}, function(arg0_45)
		setActive(arg0_45, getProxy(TechnologyProxy):IsShowTip())
	end)
	var2_31(arg0_31._tf:Find("frame/right/1/battle/root/tip"), {
		"EVENT"
	}, function(arg0_46)
		setActive(arg0_46, getProxy(EventProxy):hasFinishState() or LimitChallengeConst.IsShowRedPoint())
	end)
	var2_31(arg0_31._tf:Find("frame/bottom/frame/live/tip"), {
		"COURTYARD",
		"SCHOOL",
		"COMMANDER",
		"DORM3D_SHOP_TIMELIMIT",
		"EDUCATE_NEW_CHILD",
		"ISLAND_3D"
	}, function(arg0_47)
		local var0_47 = getProxy(PlayerProxy):getRawData()
		local var1_47 = false

		if var0_47.level >= 40 then
			local var2_47 = getProxy(CommanderProxy):IsFinishAllBox()

			if not LOCK_CATTERY then
				var1_47 = var2_47 or getProxy(CommanderProxy):AnyCatteryExistOP() or getProxy(CommanderProxy):AnyCatteryCanUse()
			else
				var1_47 = var2_47
			end
		end

		local var3_47 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_47.level, "SelectDorm3DMediator")

		setActive(arg0_47, getProxy(DormProxy):IsShowRedDot() or getProxy(NavalAcademyProxy):IsShowTip() or var1_47 or var3_47 and Dorm3dShopUI.ShouldShowAllTip() or NewEducateHelper.IsShowNewChildTip() or getProxy(SystemTipProxy):IsIslandRedDotTip())
	end)

	local var7_31 = arg0_31._tf:Find("frame/right/switch")
	local var8_31 = var7_31:GetComponent(typeof(Toggle))
	local var9_31 = var7_31:Find("on")

	var2_31(var9_31, {
		"COLLECTION",
		"FRIEND",
		"MEMORY_REVIEW"
	}, function(arg0_48)
		local var0_48 = getProxy(CollectionProxy):hasFinish() or getProxy(AppreciateProxy):isGalleryHaveNewRes() or getProxy(AppreciateProxy):isMusicHaveNewRes() or getProxy(AppreciateProxy):isMangaHaveNewRes() or getProxy(NotificationProxy):getRequestCount() > 0 or getProxy(FriendProxy):getNewMsgCount() > 0 or (function()
			local var0_49 = getProxy(PlayerProxy):getRawData()

			if var0_49 and _.any(pg.memory_group.all, function(arg0_50)
				return PlayerPrefs.GetInt("MEMORY_GROUP_NOTIFICATION" .. var0_49.id .. " " .. arg0_50, 0) == 1
			end) then
				return true
			end

			return tobool(getProxy(LoveLetterProxy):getRawData() and getProxy(LoveLetterProxy):IsTipUnlockLetter())
		end)()

		setActive(arg0_48, var0_48 and not var8_31.isOn)
	end)

	local var10_31 = var7_31:Find("off")

	var2_31(var10_31, {
		"EVENT"
	}, function(arg0_51)
		setActive(arg0_51, (getProxy(EventProxy):hasFinishState() or LimitChallengeConst.IsShowRedPoint()) and var8_31.isOn)
	end)

	return var1_31
end

return var0_0
