local var0_0 = class("CommissionInfoLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	if getProxy(SettingsProxy):IsMellowStyle() then
		return "CommissionInfoUI4Mellow"
	else
		return "CommissionInfoUI"
	end
end

function var0_0.getResource(arg0_2)
	local var0_2 = {
		"ui/commissioninfoui4mellow",
		"ui/commissioninfoui",
		"ui/CommissionInfoUI4Mellow_atlas",
		"ui/commissioninfoui_atlas"
	}

	local function var1_2(arg0_3, arg1_3)
		if noEmptyStr(arg1_3) and not table.contains(arg0_3, arg1_3) then
			table.insert(arg0_3, arg1_3)
		end
	end

	local function var2_2()
		local var0_4 = {}
		local var1_4 = getProxy(NavalAcademyProxy):GetClassVO():GetResourceType()
		local var2_4 = Item.getConfigData(var1_4)

		table.insert(var0_4, var2_4.icon)

		return var0_4
	end

	local function var3_2()
		local var0_5 = {}
		local var1_5 = {}

		local function var2_5(arg0_6)
			var1_2(var0_5, arg0_6)
		end

		local function var3_5(arg0_7)
			for iter0_7, iter1_7 in ipairs(arg0_7 or {}) do
				var2_5(iter1_7)
			end
		end

		local function var4_5(arg0_8)
			var3_5(ResPathSupport.GetPaintingSquareIconListByPaintingName(arg0_8:getPainting()))
			var3_5(ResPathSupport.GetPaintingShipYardIconListByPaintingName(arg0_8:getPainting()))
			var2_5(string.format(ResPathSupport.ConstPath.BG.ShipCard, arg0_8:rarity2bgPrint()))

			local var0_8, var1_8 = arg0_8:GetFrameAndEffect()

			var2_5(ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.Effect, var1_8))
		end

		local function var5_5(arg0_9)
			Drop.Change(arg0_9)

			if arg0_9.type == DROP_TYPE_SHIP then
				var4_5(Ship.New({
					configId = arg0_9.id,
					skin_id = arg0_9.skinId,
					propose = arg0_9.propose
				}))
			else
				var2_5(arg0_9:getIcon())
			end
		end

		local function var6_5(arg0_10)
			local var0_10 = arg0_10.template

			var2_5("eventtype/" .. var0_10.icon)

			for iter0_10, iter1_10 in ipairs(var0_10.ship_type or {}) do
				var1_5[iter1_10] = true
			end

			for iter2_10, iter3_10 in ipairs(var0_10.drop_display or {}) do
				var5_5({
					type = iter3_10.type,
					id = iter3_10.id,
					count = iter3_10.nums
				})
			end

			if var0_10.special_drop and var0_10.special_drop.type then
				var5_5({
					type = var0_10.special_drop.type,
					id = var0_10.special_drop.id,
					count = var0_10.special_drop.nums
				})
			end

			for iter4_10, iter5_10 in ipairs(arg0_10:getShipList() or {}) do
				var4_5(iter5_10)
			end
		end

		var2_5("ui/EventUI")
		var2_5("ui/eventui_atlas")
		var2_5("ui/ShipExpUI")
		var2_5("ui/proposeshipcard")
		var2_5("battlescore/grade_label_task_complete")

		local var7_5 = getProxy(EventProxy)

		for iter0_5, iter1_5 in ipairs(var7_5:getEventList() or {}) do
			var6_5(iter1_5)
		end

		local var8_5 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT)

		if var8_5 and not var8_5:isEnd() then
			var6_5(var7_5:GetEventByActivityId(var8_5.id))
		end

		local var9_5 = getProxy(BayProxy)

		for iter2_5, iter3_5 in pairs(var9_5:getRawData() or {}) do
			if var1_5[iter3_5:getShipType()] and not iter3_5:isActivityNpc() then
				var4_5(iter3_5)
			end
		end

		return var0_5
	end

	local var4_2 = var2_2()
	local var5_2 = var3_2()

	return ResPathSupport.MergeLuaArr(var0_2, var4_2, var5_2)
end

function var0_0.init(arg0_11)
	arg0_11.frame = arg0_11._tf:Find("frame")
	arg0_11.parentTr = arg0_11._tf.parent
	arg0_11.resourcesTF = arg0_11.frame:Find("resources")
	arg0_11.oilTF = arg0_11.resourcesTF:Find("canteen/bubble/Text"):GetComponent(typeof(Text))
	arg0_11.goldTF = arg0_11.resourcesTF:Find("merchant/bubble/Text"):GetComponent(typeof(Text))
	arg0_11.classTF = arg0_11.resourcesTF:Find("class/bubble/Text"):GetComponent(typeof(Text))
	arg0_11.classLockTF = arg0_11.resourcesTF:Find("class/lock")
	arg0_11.oilbubbleTF = arg0_11.resourcesTF:Find("canteen/bubble")
	arg0_11.goldbubbleTF = arg0_11.resourcesTF:Find("merchant/bubble")
	arg0_11.classbubbleTF = arg0_11.resourcesTF:Find("class/bubble")
	arg0_11.oilbubbleCG = GetOrAddComponent(arg0_11.oilbubbleTF, typeof(CanvasGroup))
	arg0_11.goldbubbleCG = GetOrAddComponent(arg0_11.goldbubbleTF, typeof(CanvasGroup))
	arg0_11.classbubbleCG = GetOrAddComponent(arg0_11.classbubbleTF, typeof(CanvasGroup))

	local var0_11 = getProxy(NavalAcademyProxy):GetClassVO():GetResourceType()
	local var1_11 = Item.getConfigData(var0_11).icon

	arg0_11.classbubbleTF:Find("icon"):GetComponent(typeof(Image)).sprite = LoadSprite(var1_11)
	arg0_11.projectContainer = arg0_11.frame:Find("main/content")
	arg0_11.items = {
		CommissionInfoEventItem.New(arg0_11._tf:Find("frame/main/content/event"), arg0_11),
		CommissionInfoClassItem.New(arg0_11._tf:Find("frame/main/content/class"), arg0_11),
		CommissionInfoTechnologyItem.New(arg0_11._tf:Find("frame/main/content/technology"), arg0_11),
		CommissionInfoChapterAutoItem.New(arg0_11._tf:Find("frame/main/content/chapterauto"), arg0_11)
	}

	arg0_11:BlurPanel()

	arg0_11.linkBtnPanel = arg0_11._tf:Find("frame/link_btns/btns")
	arg0_11.activityInsBtn = arg0_11._tf:Find("frame/link_btns/btns/ins")
	arg0_11.activtyUrExchangeBtn = arg0_11._tf:Find("frame/link_btns/btns/urEx")
	arg0_11.activtyUrExchangeTxt = arg0_11._tf:Find("frame/link_btns/btns/urEx/Text"):GetComponent(typeof(Text))
	arg0_11.activtyUrExchangeCG = arg0_11.activtyUrExchangeBtn:GetComponent(typeof(CanvasGroup))
	arg0_11.activtyUrExchangeTip = arg0_11._tf:Find("frame/link_btns/btns/urEx/tip")
	arg0_11.activityCrusingBtn = arg0_11._tf:Find("frame/link_btns/btns/crusing")
	arg0_11.metaBossBtn = CommissionMetaBossBtn.New(arg0_11._tf:Find("frame/link_btns/btns/meta_boss"), arg0_11.event)
end

function var0_0.BlurPanel(arg0_12)
	pg.UIMgr.GetInstance():BlurPanel(arg0_12._tf)
end

function var0_0.UnBlurPanel(arg0_13)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13._tf, arg0_13.parentTr)
end

function var0_0.UpdataClassUnlock(arg0_14)
	local var0_14 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_14.playerVO.level, "ClassMediator")

	setActive(arg0_14.classLockTF, not var0_14)
end

function var0_0.UpdateUrItemEntrance(arg0_15)
	if pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_15.playerVO.level, "FragmentShop") and not LOCK_UR_SHIP then
		local var0_15 = pg.gameset.urpt_chapter_max.description
		local var1_15 = var0_15[1]
		local var2_15 = var0_15[2]
		local var3_15 = getProxy(BagProxy):GetLimitCntById(var1_15)

		arg0_15.activtyUrExchangeTxt.text = var3_15 .. "/" .. var2_15

		local var4_15 = var3_15 == var2_15

		arg0_15.activtyUrExchangeCG.alpha = var4_15 and 0.6 or 1

		setActive(arg0_15.activtyUrExchangeTip, NotifyTipHelper.ShouldShowUrTip())
		onButton(arg0_15, arg0_15.activtyUrExchangeBtn, function()
			arg0_15:emit(CommissionInfoMediator.ON_UR_ACTIVITY)
		end, SFX_PANEL)
	else
		setActive(arg0_15.activtyUrExchangeBtn, false)
	end
end

function var0_0.updateCrusingEntrance(arg0_17)
	local var0_17 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	if var0_17 and not var0_17:isEnd() then
		setActive(arg0_17.activityCrusingBtn, true)

		local var1_17 = var0_17:GetCrusingInfo()
		local var2_17 = var0_17.stopTime - pg.TimeMgr.GetInstance():GetServerTime()
		local var3_17 = math.floor(var2_17 / 86400)

		if var3_17 <= pg.gameset.world_cruise_due_days.key_value then
			setActive(arg0_17.activityCrusingBtn:Find("LastDay"), true)
			setText(arg0_17.activityCrusingBtn:Find("LastDay/text"), i18n("guild_left_supply_day", var3_17))
		else
			setActive(arg0_17.activityCrusingBtn:Find("LastDay"), false)
		end

		setText(arg0_17.activityCrusingBtn:Find("Text"), var1_17.phase .. "/" .. #var1_17.awardList)
		setActive(arg0_17.activityCrusingBtn:Find("tip"), #var0_17:GetCrusingUnreceiveAward() > 0)
	else
		setActive(arg0_17.activityCrusingBtn, false)
	end

	onButton(arg0_17, arg0_17.activityCrusingBtn, function()
		arg0_17:emit(CommissionInfoMediator.ON_CRUSING)
	end, SFX_PANEL)
end

function var0_0.NotifyIns(arg0_19)
	setActive(arg0_19.activityInsBtn, false)
end

function var0_0.UpdateLinkPanel(arg0_20)
	local var0_20 = false

	for iter0_20 = 1, arg0_20.linkBtnPanel.childCount do
		if isActive(arg0_20.linkBtnPanel:GetChild(iter0_20 - 1)) then
			var0_20 = true

			break
		end
	end

	setActive(arg0_20.linkBtnPanel.parent, var0_20)
end

function var0_0.didEnter(arg0_21)
	onButton(arg0_21, arg0_21.oilbubbleTF, function()
		if not getProxy(PlayerProxy):getRawData():CanGetResource(PlayerConst.ResOil) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("player_harvestResource_error_fullBag"))

			return
		end

		arg0_21:PlayGetResAnimation(arg0_21.oilbubbleTF, function()
			arg0_21:emit(CommissionInfoMediator.GET_OIL_RES)
		end)
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.goldbubbleTF, function()
		if not getProxy(PlayerProxy):getRawData():CanGetResource(PlayerConst.ResGold) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("player_harvestResource_error_fullBag"))

			return
		end

		arg0_21:PlayGetResAnimation(arg0_21.goldbubbleTF, function()
			arg0_21:emit(CommissionInfoMediator.GET_GOLD_RES)
		end)
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.classbubbleTF, function()
		if not getProxy(NavalAcademyProxy):GetClassVO():CanGetRes() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("player_harvestResource_error_fullBag"))

			return
		end

		arg0_21:PlayGetResAnimation(arg0_21.classbubbleTF, function()
			arg0_21:emit(CommissionInfoMediator.GET_CLASS_RES)
		end)
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21._tf, function()
		if arg0_21.contextData.inFinished then
			return
		end

		arg0_21.isPaying = true

		arg0_21:PlayUIAnimation(arg0_21._tf, "exit", function()
			arg0_21:emit(var0_0.ON_CLOSE)

			arg0_21.isPaying = false
		end)
	end, SOUND_BACK)
	onButton(arg0_21, arg0_21.classLockTF, function()
		local var0_30 = pg.open_systems_limited[9]

		pg.TipsMgr.GetInstance():ShowTips(i18n("no_open_system_tip", var0_30.name, var0_30.level))
	end, SFX_PANEL)
	arg0_21:InitItems()
	arg0_21:UpdataClassUnlock()
	arg0_21:UpdateUrItemEntrance()
	arg0_21:updateCrusingEntrance()
	arg0_21.metaBossBtn:Flush()
end

function var0_0.PlayGetResAnimation(arg0_31, arg1_31, arg2_31)
	arg0_31.isPaying = true

	local var0_31 = arg1_31:GetComponent(typeof(Animation))
	local var1_31 = arg1_31:GetComponent(typeof(DftAniEvent))

	var1_31:SetEndEvent(nil)
	var1_31:SetEndEvent(function()
		var1_31:SetEndEvent(nil)
		arg2_31()

		arg0_31.isPaying = false
	end)
	var0_31:Play("anim_commission_bubble_get")
end

function var0_0.InitItems(arg0_33)
	for iter0_33, iter1_33 in ipairs(arg0_33.items) do
		iter1_33:Init()
	end
end

function var0_0.OnUpdateEventInfo(arg0_34)
	arg0_34.items[1]:Update()
end

function var0_0.OnUpdateClass(arg0_35)
	arg0_35.items[2]:Update()
end

function var0_0.OnUpdateTechnology(arg0_36)
	arg0_36.items[3]:Update()
end

function var0_0.OnUpdateChapterAuto(arg0_37)
	arg0_37.items[4]:Update()
end

function var0_0.setPlayer(arg0_38, arg1_38)
	arg0_38.playerVO = arg1_38

	arg0_38:UpdateOilRes(arg1_38)
	arg0_38:UpdateGoldRes(arg1_38)
	arg0_38:UpdateClassRes()
end

function var0_0.OnPlayerUpdate(arg0_39, arg1_39)
	local var0_39 = arg0_39.playerVO
	local var1_39 = arg1_39

	if var1_39.oilField ~= var0_39.oilField then
		arg0_39:UpdateOilRes(var1_39)
	end

	if var1_39.goldField ~= var0_39.goldField then
		arg0_39:UpdateGoldRes(var1_39)
	end

	if var1_39.expField ~= var0_39.expField then
		arg0_39:UpdateClassRes()
	end

	arg0_39.playerVO = var1_39
end

function var0_0.UpdateOilRes(arg0_40, arg1_40)
	arg0_40.oilbubbleCG.alpha = 1
	arg0_40.oilbubbleTF.localScale = Vector3.one

	setActive(arg0_40.oilbubbleTF, arg1_40.oilField ~= 0)

	arg0_40.oilTF.text = arg1_40.oilField
end

function var0_0.UpdateGoldRes(arg0_41, arg1_41)
	arg0_41.goldbubbleCG.alpha = 1
	arg0_41.goldbubbleTF.localScale = Vector3.one

	setActive(arg0_41.goldbubbleTF, arg1_41.goldField ~= 0)

	arg0_41.goldTF.text = arg1_41.goldField
end

function var0_0.UpdateClassRes(arg0_42)
	local var0_42 = getProxy(NavalAcademyProxy):GetClassVO():GetGenResCnt()

	arg0_42.classbubbleCG.alpha = 1
	arg0_42.classbubbleTF.localScale = Vector3.one

	setActive(arg0_42.classbubbleTF, var0_42 > 0)

	arg0_42.classTF.text = var0_42
end

function var0_0.onBackPressed(arg0_43)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_43._tf)
end

function var0_0.willExit(arg0_44)
	arg0_44:UnBlurPanel()

	for iter0_44, iter1_44 in ipairs(arg0_44.items) do
		iter1_44:Dispose()
	end

	arg0_44.items = nil

	arg0_44.metaBossBtn:Dispose()

	arg0_44.metaBossBtn = nil
end

return var0_0
