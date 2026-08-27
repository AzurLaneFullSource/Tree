local var0_0 = class("CommissionInfoLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	if getProxy(SettingsProxy):IsMellowStyle() then
		return "CommissionInfoUI4Mellow"
	else
		return "CommissionInfoUI"
	end
end

function var0_0.init(arg0_2)
	arg0_2.frame = arg0_2._tf:Find("frame")
	arg0_2.parentTr = arg0_2._tf.parent
	arg0_2.resourcesTF = arg0_2.frame:Find("resources")
	arg0_2.oilTF = arg0_2.resourcesTF:Find("canteen/bubble/Text"):GetComponent(typeof(Text))
	arg0_2.goldTF = arg0_2.resourcesTF:Find("merchant/bubble/Text"):GetComponent(typeof(Text))
	arg0_2.classTF = arg0_2.resourcesTF:Find("class/bubble/Text"):GetComponent(typeof(Text))
	arg0_2.classLockTF = arg0_2.resourcesTF:Find("class/lock")
	arg0_2.oilbubbleTF = arg0_2.resourcesTF:Find("canteen/bubble")
	arg0_2.goldbubbleTF = arg0_2.resourcesTF:Find("merchant/bubble")
	arg0_2.classbubbleTF = arg0_2.resourcesTF:Find("class/bubble")
	arg0_2.oilbubbleCG = GetOrAddComponent(arg0_2.oilbubbleTF, typeof(CanvasGroup))
	arg0_2.goldbubbleCG = GetOrAddComponent(arg0_2.goldbubbleTF, typeof(CanvasGroup))
	arg0_2.classbubbleCG = GetOrAddComponent(arg0_2.classbubbleTF, typeof(CanvasGroup))

	local var0_2 = getProxy(NavalAcademyProxy):GetClassVO():GetResourceType()
	local var1_2 = Item.getConfigData(var0_2).icon

	arg0_2.classbubbleTF:Find("icon"):GetComponent(typeof(Image)).sprite = LoadSprite(var1_2)
	arg0_2.projectContainer = arg0_2.frame:Find("main/content")
	arg0_2.items = {
		CommissionInfoEventItem.New(arg0_2._tf:Find("frame/main/content/event"), arg0_2),
		CommissionInfoClassItem.New(arg0_2._tf:Find("frame/main/content/class"), arg0_2),
		CommissionInfoTechnologyItem.New(arg0_2._tf:Find("frame/main/content/technology"), arg0_2),
		CommissionInfoChapterAutoItem.New(arg0_2._tf:Find("frame/main/content/chapterauto"), arg0_2)
	}

	arg0_2:BlurPanel()

	arg0_2.linkBtnPanel = arg0_2._tf:Find("frame/link_btns/btns")
	arg0_2.activityInsBtn = arg0_2._tf:Find("frame/link_btns/btns/ins")
	arg0_2.activtyUrExchangeBtn = arg0_2._tf:Find("frame/link_btns/btns/urEx")
	arg0_2.activtyUrExchangeTxt = arg0_2._tf:Find("frame/link_btns/btns/urEx/Text"):GetComponent(typeof(Text))
	arg0_2.activtyUrExchangeCG = arg0_2.activtyUrExchangeBtn:GetComponent(typeof(CanvasGroup))
	arg0_2.activtyUrExchangeTip = arg0_2._tf:Find("frame/link_btns/btns/urEx/tip")
	arg0_2.activityCrusingBtn = arg0_2._tf:Find("frame/link_btns/btns/crusing")
	arg0_2.metaBossBtn = CommissionMetaBossBtn.New(arg0_2._tf:Find("frame/link_btns/btns/meta_boss"), arg0_2.event)
end

function var0_0.BlurPanel(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.UnBlurPanel(arg0_4)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_4._tf, arg0_4.parentTr)
end

function var0_0.UpdataClassUnlock(arg0_5)
	local var0_5 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_5.playerVO.level, "ClassMediator")

	setActive(arg0_5.classLockTF, not var0_5)
end

function var0_0.UpdateUrItemEntrance(arg0_6)
	if pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_6.playerVO.level, "FragmentShop") and not LOCK_UR_SHIP then
		local var0_6 = pg.gameset.urpt_chapter_max.description
		local var1_6 = var0_6[1]
		local var2_6 = var0_6[2]
		local var3_6 = getProxy(BagProxy):GetLimitCntById(var1_6)

		arg0_6.activtyUrExchangeTxt.text = var3_6 .. "/" .. var2_6

		local var4_6 = var3_6 == var2_6

		arg0_6.activtyUrExchangeCG.alpha = var4_6 and 0.6 or 1

		setActive(arg0_6.activtyUrExchangeTip, NotifyTipHelper.ShouldShowUrTip())
		onButton(arg0_6, arg0_6.activtyUrExchangeBtn, function()
			arg0_6:emit(CommissionInfoMediator.ON_UR_ACTIVITY)
		end, SFX_PANEL)
	else
		setActive(arg0_6.activtyUrExchangeBtn, false)
	end
end

function var0_0.updateCrusingEntrance(arg0_8)
	local var0_8 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	if var0_8 and not var0_8:isEnd() then
		setActive(arg0_8.activityCrusingBtn, true)

		local var1_8 = var0_8:GetCrusingInfo()
		local var2_8 = var0_8.stopTime - pg.TimeMgr.GetInstance():GetServerTime()
		local var3_8 = math.floor(var2_8 / 86400)

		if var3_8 <= pg.gameset.world_cruise_due_days.key_value then
			setActive(arg0_8.activityCrusingBtn:Find("LastDay"), true)
			setText(arg0_8.activityCrusingBtn:Find("LastDay/text"), i18n("guild_left_supply_day", var3_8))
		else
			setActive(arg0_8.activityCrusingBtn:Find("LastDay"), false)
		end

		setText(arg0_8.activityCrusingBtn:Find("Text"), var1_8.phase .. "/" .. #var1_8.awardList)
		setActive(arg0_8.activityCrusingBtn:Find("tip"), #var0_8:GetCrusingUnreceiveAward() > 0)
	else
		setActive(arg0_8.activityCrusingBtn, false)
	end

	onButton(arg0_8, arg0_8.activityCrusingBtn, function()
		arg0_8:emit(CommissionInfoMediator.ON_CRUSING)
	end, SFX_PANEL)
end

function var0_0.NotifyIns(arg0_10)
	setActive(arg0_10.activityInsBtn, false)
end

function var0_0.UpdateLinkPanel(arg0_11)
	local var0_11 = false

	for iter0_11 = 1, arg0_11.linkBtnPanel.childCount do
		if isActive(arg0_11.linkBtnPanel:GetChild(iter0_11 - 1)) then
			var0_11 = true

			break
		end
	end

	setActive(arg0_11.linkBtnPanel.parent, var0_11)
end

function var0_0.didEnter(arg0_12)
	onButton(arg0_12, arg0_12.oilbubbleTF, function()
		if not getProxy(PlayerProxy):getRawData():CanGetResource(PlayerConst.ResOil) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("player_harvestResource_error_fullBag"))

			return
		end

		arg0_12:PlayGetResAnimation(arg0_12.oilbubbleTF, function()
			arg0_12:emit(CommissionInfoMediator.GET_OIL_RES)
		end)
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.goldbubbleTF, function()
		if not getProxy(PlayerProxy):getRawData():CanGetResource(PlayerConst.ResGold) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("player_harvestResource_error_fullBag"))

			return
		end

		arg0_12:PlayGetResAnimation(arg0_12.goldbubbleTF, function()
			arg0_12:emit(CommissionInfoMediator.GET_GOLD_RES)
		end)
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.classbubbleTF, function()
		if not getProxy(NavalAcademyProxy):GetClassVO():CanGetRes() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("player_harvestResource_error_fullBag"))

			return
		end

		arg0_12:PlayGetResAnimation(arg0_12.classbubbleTF, function()
			arg0_12:emit(CommissionInfoMediator.GET_CLASS_RES)
		end)
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12._tf, function()
		if arg0_12.contextData.inFinished then
			return
		end

		arg0_12.isPaying = true

		arg0_12:PlayUIAnimation(arg0_12._tf, "exit", function()
			arg0_12:emit(var0_0.ON_CLOSE)

			arg0_12.isPaying = false
		end)
	end, SOUND_BACK)
	onButton(arg0_12, arg0_12.classLockTF, function()
		local var0_21 = pg.open_systems_limited[9]

		pg.TipsMgr.GetInstance():ShowTips(i18n("no_open_system_tip", var0_21.name, var0_21.level))
	end, SFX_PANEL)
	arg0_12:InitItems()
	arg0_12:UpdataClassUnlock()
	arg0_12:UpdateUrItemEntrance()
	arg0_12:updateCrusingEntrance()
	arg0_12.metaBossBtn:Flush()
end

function var0_0.PlayGetResAnimation(arg0_22, arg1_22, arg2_22)
	arg0_22.isPaying = true

	local var0_22 = arg1_22:GetComponent(typeof(Animation))
	local var1_22 = arg1_22:GetComponent(typeof(DftAniEvent))

	var1_22:SetEndEvent(nil)
	var1_22:SetEndEvent(function()
		var1_22:SetEndEvent(nil)
		arg2_22()

		arg0_22.isPaying = false
	end)
	var0_22:Play("anim_commission_bubble_get")
end

function var0_0.InitItems(arg0_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.items) do
		iter1_24:Init()
	end
end

function var0_0.OnUpdateEventInfo(arg0_25)
	arg0_25.items[1]:Update()
end

function var0_0.OnUpdateClass(arg0_26)
	arg0_26.items[2]:Update()
end

function var0_0.OnUpdateTechnology(arg0_27)
	arg0_27.items[3]:Update()
end

function var0_0.OnUpdateChapterAuto(arg0_28)
	arg0_28.items[4]:Update()
end

function var0_0.setPlayer(arg0_29, arg1_29)
	arg0_29.playerVO = arg1_29

	arg0_29:UpdateOilRes(arg1_29)
	arg0_29:UpdateGoldRes(arg1_29)
	arg0_29:UpdateClassRes()
end

function var0_0.OnPlayerUpdate(arg0_30, arg1_30)
	local var0_30 = arg0_30.playerVO
	local var1_30 = arg1_30

	if var1_30.oilField ~= var0_30.oilField then
		arg0_30:UpdateOilRes(var1_30)
	end

	if var1_30.goldField ~= var0_30.goldField then
		arg0_30:UpdateGoldRes(var1_30)
	end

	if var1_30.expField ~= var0_30.expField then
		arg0_30:UpdateClassRes()
	end

	arg0_30.playerVO = var1_30
end

function var0_0.UpdateOilRes(arg0_31, arg1_31)
	arg0_31.oilbubbleCG.alpha = 1
	arg0_31.oilbubbleTF.localScale = Vector3.one

	setActive(arg0_31.oilbubbleTF, arg1_31.oilField ~= 0)

	arg0_31.oilTF.text = arg1_31.oilField
end

function var0_0.UpdateGoldRes(arg0_32, arg1_32)
	arg0_32.goldbubbleCG.alpha = 1
	arg0_32.goldbubbleTF.localScale = Vector3.one

	setActive(arg0_32.goldbubbleTF, arg1_32.goldField ~= 0)

	arg0_32.goldTF.text = arg1_32.goldField
end

function var0_0.UpdateClassRes(arg0_33)
	local var0_33 = getProxy(NavalAcademyProxy):GetClassVO():GetGenResCnt()

	arg0_33.classbubbleCG.alpha = 1
	arg0_33.classbubbleTF.localScale = Vector3.one

	setActive(arg0_33.classbubbleTF, var0_33 > 0)

	arg0_33.classTF.text = var0_33
end

function var0_0.onBackPressed(arg0_34)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_34._tf)
end

function var0_0.willExit(arg0_35)
	arg0_35:UnBlurPanel()

	for iter0_35, iter1_35 in ipairs(arg0_35.items) do
		iter1_35:Dispose()
	end

	arg0_35.items = nil

	arg0_35.metaBossBtn:Dispose()

	arg0_35.metaBossBtn = nil
end

return var0_0
