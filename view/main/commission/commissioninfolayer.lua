local var0 = class("CommissionInfoLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	if getProxy(SettingsProxy):IsMellowStyle() then
		return "CommissionInfoUI4Mellow"
	else
		return "CommissionInfoUI"
	end
end

function var0.init(arg0)
	arg0.frame = arg0:findTF("frame")
	arg0.parentTr = arg0._tf.parent
	arg0.resourcesTF = arg0:findTF("resources", arg0.frame)
	arg0.oilTF = arg0:findTF("canteen/bubble/Text", arg0.resourcesTF):GetComponent(typeof(Text))
	arg0.goldTF = arg0:findTF("merchant/bubble/Text", arg0.resourcesTF):GetComponent(typeof(Text))
	arg0.classTF = arg0:findTF("class/bubble/Text", arg0.resourcesTF):GetComponent(typeof(Text))
	arg0.oilbubbleTF = arg0:findTF("canteen/bubble", arg0.resourcesTF)
	arg0.goldbubbleTF = arg0:findTF("merchant/bubble", arg0.resourcesTF)
	arg0.classbubbleTF = arg0:findTF("class/bubble", arg0.resourcesTF)
	arg0.oilbubbleCG = GetOrAddComponent(arg0.oilbubbleTF, typeof(CanvasGroup))
	arg0.goldbubbleCG = GetOrAddComponent(arg0.goldbubbleTF, typeof(CanvasGroup))
	arg0.classbubbleCG = GetOrAddComponent(arg0.classbubbleTF, typeof(CanvasGroup))

	local var0 = getProxy(NavalAcademyProxy):GetClassVO():GetResourceType()
	local var1 = Item.getConfigData(var0).icon

	arg0.classbubbleTF:Find("icon"):GetComponent(typeof(Image)).sprite = LoadSprite(var1)
	arg0.projectContainer = arg0:findTF("main/content", arg0.frame)
	arg0.items = {
		CommissionInfoEventItem.New(arg0:findTF("frame/main/content/event"), arg0),
		CommissionInfoClassItem.New(arg0:findTF("frame/main/content/class"), arg0),
		CommissionInfoTechnologyItem.New(arg0:findTF("frame/main/content/technology"), arg0)
	}

	arg0:BlurPanel()

	arg0.linkBtnPanel = arg0:findTF("frame/link_btns/btns")
	arg0.activityInsBtn = arg0:findTF("frame/link_btns/btns/ins")
	arg0.activtyUrExchangeBtn = arg0:findTF("frame/link_btns/btns/urEx")
	arg0.activtyUrExchangeTxt = arg0:findTF("frame/link_btns/btns/urEx/Text"):GetComponent(typeof(Text))
	arg0.activtyUrExchangeCG = arg0.activtyUrExchangeBtn:GetComponent(typeof(CanvasGroup))
	arg0.activtyUrExchangeTip = arg0:findTF("frame/link_btns/btns/urEx/tip")
	arg0.activityCrusingBtn = arg0:findTF("frame/link_btns/btns/crusing")
	arg0.metaBossBtn = CommissionMetaBossBtn.New(arg0:findTF("frame/link_btns/btns/meta_boss"), arg0.event)
end

function var0.BlurPanel(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0.UnBlurPanel(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0.parentTr)
end

function var0.UpdateUrItemEntrance(arg0)
	if not LOCK_UR_SHIP then
		local var0 = pg.gameset.urpt_chapter_max.description
		local var1 = var0[1]
		local var2 = var0[2]
		local var3 = getProxy(BagProxy):GetLimitCntById(var1)

		arg0.activtyUrExchangeTxt.text = var3 .. "/" .. var2

		local var4 = var3 == var2

		arg0.activtyUrExchangeCG.alpha = var4 and 0.6 or 1

		setActive(arg0.activtyUrExchangeTip, NotifyTipHelper.ShouldShowUrTip())
		onButton(arg0, arg0.activtyUrExchangeBtn, function()
			arg0:emit(CommissionInfoMediator.ON_UR_ACTIVITY)
		end, SFX_PANEL)
	else
		setActive(arg0.activtyUrExchangeBtn, false)
	end
end

function var0.updateCrusingEntrance(arg0)
	local var0 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	if var0 and not var0:isEnd() then
		setActive(arg0.activityCrusingBtn, true)

		local var1 = var0:GetCrusingInfo()

		setText(arg0.activityCrusingBtn:Find("Text"), var1.phase .. "/" .. #var1.awardList)
		setActive(arg0.activityCrusingBtn:Find("tip"), #var0:GetCrusingUnreceiveAward() > 0)
	else
		setActive(arg0.activityCrusingBtn, false)
	end

	onButton(arg0, arg0.activityCrusingBtn, function()
		arg0:emit(CommissionInfoMediator.ON_CRUSING)
	end, SFX_PANEL)
end

function var0.NotifyIns(arg0, arg1, arg2)
	local var0 = arg1:ExistMsg() and (not arg2 or arg2:isEnd())

	setActive(arg0.activityInsBtn, var0)

	if var0 then
		onButton(arg0, arg0.activityInsBtn, function()
			arg0:emit(CommissionInfoMediator.ON_INS)
		end, SFX_PANEL)
	end
end

function var0.UpdateLinkPanel(arg0)
	local var0 = false

	for iter0 = 1, arg0.linkBtnPanel.childCount do
		if isActive(arg0.linkBtnPanel:GetChild(iter0 - 1)) then
			var0 = true

			break
		end
	end

	setActive(arg0.linkBtnPanel.parent, var0)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.oilbubbleTF, function()
		if arg0.isPaying then
			return
		end

		if not getProxy(PlayerProxy):getRawData():CanGetResource(PlayerConst.ResOil) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("player_harvestResource_error_fullBag"))

			return
		end

		arg0:PlayGetResAnimation(arg0.oilbubbleTF, function()
			arg0:emit(CommissionInfoMediator.GET_OIL_RES)
		end)
	end, SFX_PANEL)
	onButton(arg0, arg0.goldbubbleTF, function()
		if arg0.isPaying then
			return
		end

		if not getProxy(PlayerProxy):getRawData():CanGetResource(PlayerConst.ResGold) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("player_harvestResource_error_fullBag"))

			return
		end

		arg0:PlayGetResAnimation(arg0.goldbubbleTF, function()
			arg0:emit(CommissionInfoMediator.GET_GOLD_RES)
		end)
	end, SFX_PANEL)
	onButton(arg0, arg0.classbubbleTF, function()
		if arg0.isPaying then
			return
		end

		if not getProxy(NavalAcademyProxy):GetClassVO():CanGetRes() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("player_harvestResource_error_fullBag"))

			return
		end

		arg0:PlayGetResAnimation(arg0.classbubbleTF, function()
			arg0:emit(CommissionInfoMediator.GET_CLASS_RES)
		end)
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		if arg0.contextData.inFinished then
			return
		end

		arg0.isPaying = true

		arg0:PlayExitAnimation(function()
			arg0:emit(var0.ON_CLOSE)

			arg0.isPaying = false
		end)
	end, SOUND_BACK)
	arg0:InitItems()
	arg0:UpdateUrItemEntrance()
	arg0:updateCrusingEntrance()
	arg0.metaBossBtn:Flush()
end

function var0.PlayGetResAnimation(arg0, arg1, arg2)
	arg0.isPaying = true

	local var0 = arg1:GetComponent(typeof(Animation))
	local var1 = arg1:GetComponent(typeof(DftAniEvent))

	var1:SetEndEvent(nil)
	var1:SetEndEvent(function()
		var1:SetEndEvent(nil)
		arg2()

		arg0.isPaying = false
	end)
	var0:Play("anim_commission_bubble_get")
end

function var0.InitItems(arg0)
	for iter0, iter1 in ipairs(arg0.items) do
		iter1:Init()
	end
end

function var0.OnUpdateEventInfo(arg0)
	arg0.items[1]:Update()
end

function var0.OnUpdateClass(arg0)
	arg0.items[2]:Update()
end

function var0.OnUpdateTechnology(arg0)
	arg0.items[3]:Update()
end

function var0.setPlayer(arg0, arg1)
	arg0.playerVO = arg1

	arg0:updateResource(arg1)
end

function var0.updateResource(arg0, arg1)
	local var0 = getProxy(NavalAcademyProxy):GetClassVO():GetGenResCnt()

	arg0.oilbubbleCG.alpha = 1
	arg0.goldbubbleCG.alpha = 1
	arg0.classbubbleCG.alpha = 1
	arg0.oilbubbleTF.localScale = Vector3.one
	arg0.goldbubbleTF.localScale = Vector3.one
	arg0.classbubbleTF.localScale = Vector3.one

	setActive(arg0.oilbubbleTF, arg1.oilField ~= 0)
	setActive(arg0.goldbubbleTF, arg1.goldField ~= 0)
	setActive(arg0.classbubbleTF, var0 > 0)

	arg0.oilTF.text = arg1.oilField
	arg0.goldTF.text = arg1.goldField
	arg0.classTF.text = var0
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0._tf)
end

function var0.willExit(arg0)
	arg0:UnBlurPanel()

	for iter0, iter1 in ipairs(arg0.items) do
		iter1:Dispose()
	end

	arg0.items = nil

	arg0.metaBossBtn:Dispose()

	arg0.metaBossBtn = nil
end

return var0
