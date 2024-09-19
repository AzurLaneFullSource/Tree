local var0_0 = class("CommissionInfoLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	if getProxy(SettingsProxy):IsMellowStyle() then
		return "CommissionInfoUI4Mellow"
	else
		return "CommissionInfoUI"
	end
end

function var0_0.init(arg0_2)
	arg0_2.frame = arg0_2:findTF("frame")
	arg0_2.parentTr = arg0_2._tf.parent
	arg0_2.resourcesTF = arg0_2:findTF("resources", arg0_2.frame)
	arg0_2.oilTF = arg0_2:findTF("canteen/bubble/Text", arg0_2.resourcesTF):GetComponent(typeof(Text))
	arg0_2.goldTF = arg0_2:findTF("merchant/bubble/Text", arg0_2.resourcesTF):GetComponent(typeof(Text))
	arg0_2.classTF = arg0_2:findTF("class/bubble/Text", arg0_2.resourcesTF):GetComponent(typeof(Text))
	arg0_2.oilbubbleTF = arg0_2:findTF("canteen/bubble", arg0_2.resourcesTF)
	arg0_2.goldbubbleTF = arg0_2:findTF("merchant/bubble", arg0_2.resourcesTF)
	arg0_2.classbubbleTF = arg0_2:findTF("class/bubble", arg0_2.resourcesTF)
	arg0_2.oilbubbleCG = GetOrAddComponent(arg0_2.oilbubbleTF, typeof(CanvasGroup))
	arg0_2.goldbubbleCG = GetOrAddComponent(arg0_2.goldbubbleTF, typeof(CanvasGroup))
	arg0_2.classbubbleCG = GetOrAddComponent(arg0_2.classbubbleTF, typeof(CanvasGroup))

	local var0_2 = getProxy(NavalAcademyProxy):GetClassVO():GetResourceType()
	local var1_2 = Item.getConfigData(var0_2).icon

	arg0_2.classbubbleTF:Find("icon"):GetComponent(typeof(Image)).sprite = LoadSprite(var1_2)
	arg0_2.projectContainer = arg0_2:findTF("main/content", arg0_2.frame)
	arg0_2.items = {
		CommissionInfoEventItem.New(arg0_2:findTF("frame/main/content/event"), arg0_2),
		CommissionInfoClassItem.New(arg0_2:findTF("frame/main/content/class"), arg0_2),
		CommissionInfoTechnologyItem.New(arg0_2:findTF("frame/main/content/technology"), arg0_2)
	}

	arg0_2:BlurPanel()

	arg0_2.linkBtnPanel = arg0_2:findTF("frame/link_btns/btns")
	arg0_2.activityInsBtn = arg0_2:findTF("frame/link_btns/btns/ins")
	arg0_2.activtyUrExchangeBtn = arg0_2:findTF("frame/link_btns/btns/urEx")
	arg0_2.activtyUrExchangeTxt = arg0_2:findTF("frame/link_btns/btns/urEx/Text"):GetComponent(typeof(Text))
	arg0_2.activtyUrExchangeCG = arg0_2.activtyUrExchangeBtn:GetComponent(typeof(CanvasGroup))
	arg0_2.activtyUrExchangeTip = arg0_2:findTF("frame/link_btns/btns/urEx/tip")
	arg0_2.activityCrusingBtn = arg0_2:findTF("frame/link_btns/btns/crusing")
	arg0_2.metaBossBtn = CommissionMetaBossBtn.New(arg0_2:findTF("frame/link_btns/btns/meta_boss"), arg0_2.event)
end

function var0_0.BlurPanel(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.UnBlurPanel(arg0_4)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf, arg0_4.parentTr)
end

function var0_0.UpdateUrItemEntrance(arg0_5)
	if not LOCK_UR_SHIP then
		local var0_5 = pg.gameset.urpt_chapter_max.description
		local var1_5 = var0_5[1]
		local var2_5 = var0_5[2]
		local var3_5 = getProxy(BagProxy):GetLimitCntById(var1_5)

		arg0_5.activtyUrExchangeTxt.text = var3_5 .. "/" .. var2_5

		local var4_5 = var3_5 == var2_5

		arg0_5.activtyUrExchangeCG.alpha = var4_5 and 0.6 or 1

		setActive(arg0_5.activtyUrExchangeTip, NotifyTipHelper.ShouldShowUrTip())
		onButton(arg0_5, arg0_5.activtyUrExchangeBtn, function()
			arg0_5:emit(CommissionInfoMediator.ON_UR_ACTIVITY)
		end, SFX_PANEL)
	else
		setActive(arg0_5.activtyUrExchangeBtn, false)
	end
end

function var0_0.updateCrusingEntrance(arg0_7)
	local var0_7 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	if var0_7 and not var0_7:isEnd() then
		setActive(arg0_7.activityCrusingBtn, true)

		local var1_7 = var0_7:GetCrusingInfo()

		setText(arg0_7.activityCrusingBtn:Find("Text"), var1_7.phase .. "/" .. #var1_7.awardList)
		setActive(arg0_7.activityCrusingBtn:Find("tip"), #var0_7:GetCrusingUnreceiveAward() > 0)
	else
		setActive(arg0_7.activityCrusingBtn, false)
	end

	onButton(arg0_7, arg0_7.activityCrusingBtn, function()
		arg0_7:emit(CommissionInfoMediator.ON_CRUSING)
	end, SFX_PANEL)
end

function var0_0.NotifyIns(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg1_9:ExistMsg() and (not arg2_9 or arg2_9:isEnd())

	setActive(arg0_9.activityInsBtn, var0_9)

	if var0_9 then
		setActive(arg0_9.activityInsBtn:Find("tip"), arg1_9:ShouldShowTip())
		onButton(arg0_9, arg0_9.activityInsBtn, function()
			arg0_9:emit(CommissionInfoMediator.ON_INS)
		end, SFX_PANEL)
	end
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

		arg0_12:PlayExitAnimation(function()
			arg0_12:emit(var0_0.ON_CLOSE)

			arg0_12.isPaying = false
		end)
	end, SOUND_BACK)
	arg0_12:InitItems()
	arg0_12:UpdateUrItemEntrance()
	arg0_12:updateCrusingEntrance()
	arg0_12.metaBossBtn:Flush()
end

function var0_0.PlayGetResAnimation(arg0_21, arg1_21, arg2_21)
	arg0_21.isPaying = true

	local var0_21 = arg1_21:GetComponent(typeof(Animation))
	local var1_21 = arg1_21:GetComponent(typeof(DftAniEvent))

	var1_21:SetEndEvent(nil)
	var1_21:SetEndEvent(function()
		var1_21:SetEndEvent(nil)
		arg2_21()

		arg0_21.isPaying = false
	end)
	var0_21:Play("anim_commission_bubble_get")
end

function var0_0.InitItems(arg0_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.items) do
		iter1_23:Init()
	end
end

function var0_0.OnUpdateEventInfo(arg0_24)
	arg0_24.items[1]:Update()
end

function var0_0.OnUpdateClass(arg0_25)
	arg0_25.items[2]:Update()
end

function var0_0.OnUpdateTechnology(arg0_26)
	arg0_26.items[3]:Update()
end

function var0_0.setPlayer(arg0_27, arg1_27)
	arg0_27.playerVO = arg1_27

	arg0_27:UpdateOilRes(arg1_27)
	arg0_27:UpdateGoldRes(arg1_27)
	arg0_27:UpdateClassRes()
end

function var0_0.OnPlayerUpdate(arg0_28, arg1_28)
	local var0_28 = arg0_28.playerVO
	local var1_28 = arg1_28

	if var1_28.oilField ~= var0_28.oilField then
		arg0_28:UpdateOilRes(var1_28)
	end

	if var1_28.goldField ~= var0_28.goldField then
		arg0_28:UpdateGoldRes(var1_28)
	end

	if var1_28.expField ~= var0_28.expField then
		arg0_28:UpdateClassRes()
	end

	arg0_28.playerVO = var1_28
end

function var0_0.UpdateOilRes(arg0_29, arg1_29)
	arg0_29.oilbubbleCG.alpha = 1
	arg0_29.oilbubbleTF.localScale = Vector3.one

	setActive(arg0_29.oilbubbleTF, arg1_29.oilField ~= 0)

	arg0_29.oilTF.text = arg1_29.oilField
end

function var0_0.UpdateGoldRes(arg0_30, arg1_30)
	arg0_30.goldbubbleCG.alpha = 1
	arg0_30.goldbubbleTF.localScale = Vector3.one

	setActive(arg0_30.goldbubbleTF, arg1_30.goldField ~= 0)

	arg0_30.goldTF.text = arg1_30.goldField
end

function var0_0.UpdateClassRes(arg0_31)
	local var0_31 = getProxy(NavalAcademyProxy):GetClassVO():GetGenResCnt()

	arg0_31.classbubbleCG.alpha = 1
	arg0_31.classbubbleTF.localScale = Vector3.one

	setActive(arg0_31.classbubbleTF, var0_31 > 0)

	arg0_31.classTF.text = var0_31
end

function var0_0.onBackPressed(arg0_32)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_32._tf)
end

function var0_0.willExit(arg0_33)
	arg0_33:UnBlurPanel()

	for iter0_33, iter1_33 in ipairs(arg0_33.items) do
		iter1_33:Dispose()
	end

	arg0_33.items = nil

	arg0_33.metaBossBtn:Dispose()

	arg0_33.metaBossBtn = nil
end

return var0_0
