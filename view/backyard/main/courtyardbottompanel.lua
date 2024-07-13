local var0_0 = class("CourtYardBottomPanel", import(".CourtYardBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "main/bottomPanel"
end

function var0_0.init(arg0_2)
	arg0_2.granaryBtn = arg0_2:findTF("bottomleft/feed_btn")
	arg0_2.stockBar = arg0_2:findTF("progress", arg0_2.granaryBtn):GetComponent(typeof(Slider))
	arg0_2.stockTimeTxt = arg0_2:findTF("time", arg0_2.granaryBtn):GetComponent(typeof(Text))
	arg0_2.stockTxt = arg0_2:findTF("Text", arg0_2.granaryBtn):GetComponent(typeof(Text))
	arg0_2.stampBtn = arg0_2:findTF("stamp")
	arg0_2.shopBtn = arg0_2:findTF("bottomright/shop_btn")
	arg0_2.decorateBtn = arg0_2:findTF("bottomright/decorate_btn")
	arg0_2.templateBtn = arg0_2:findTF("bottomright/theme_template_btn")
	arg0_2.shareBtn = arg0_2:findTF("bottomright/share_btn")
	arg0_2.shopTip = arg0_2.shopBtn:Find("tip")
	arg0_2.trainBtn = arg0_2:findTF("bottomleft/train_btn")
	arg0_2.trainBtnTxt = arg0_2.trainBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_2.trainBtnLabel = arg0_2.trainBtn:Find("label"):GetComponent(typeof(Text))
	arg0_2.icon1 = arg0_2:findTF("bottomleft/train_btn/icon")
	arg0_2.icon2 = arg0_2:findTF("bottomleft/train_btn/icon_1")

	setText(arg0_2.granaryBtn:Find("label"), i18n("courtyard_label_capacity"))
	setText(arg0_2.shareBtn:Find("Text"), i18n("courtyard_label_share"))
	setText(arg0_2.shopBtn:Find("Text"), i18n("courtyard_label_shop"))
	setText(arg0_2.decorateBtn:Find("Text"), i18n("courtyard_label_decoration"))
	setText(arg0_2.templateBtn:Find("Text"), i18n("courtyard_label_template"))
end

function var0_0.OnRegister(arg0_3)
	onButton(arg0_3, arg0_3.stampBtn, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(7)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeBackyard, pg.ShareMgr.PANEL_TYPE_PINK)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.granaryBtn, function()
		arg0_3:emit(CourtYardMediator.GO_GRANARY)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.shopBtn, function()
		arg0_3:emit(CourtYardMediator.GO_SHOP)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.decorateBtn, function()
		arg0_3:emit(CourtYardMediator.OPEN_DECORATION)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.templateBtn, function()
		if LOCK_BACKYARD_TEMPLATE then
			return
		end

		arg0_3:emit(CourtYardMediator.GO_THEME_TEMPLATE)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.trainBtn, function()
		if arg0_3.contextData.floor == 1 then
			arg0_3:emit(CourtYardMediator.SEL_TRAIN_SHIP)
		elseif arg0_3.contextData.floor == 2 then
			arg0_3:emit(CourtYardMediator.SEL_REST_SHIP)
		end
	end, SFX_PANEL)
	arg0_3:SetActive(arg0_3.stampBtn, not LOCK_CLICK_MINGSHI and getProxy(TaskProxy):mingshiTouchFlagEnabled())
	arg0_3:UpdateShopTip()
end

function var0_0.OnVisitRegister(arg0_11)
	setActive(arg0_11._tf, false)
end

function var0_0.OnFlush(arg0_12, arg1_12)
	arg1_12 = arg1_12 or bit.bor(BackYardConst.DORM_UPDATE_TYPE_UPDATEFOOD, BackYardConst.DORM_UPDATE_TYPE_LEVEL, BackYardConst.DORM_UPDATE_TYPE_SHIP, BackYardConst.DORM_UPDATE_TYPE_USEFOOD, BackYardConst.DORM_UPDATE_TYPE_EXTENDFOOD)

	local var0_12 = arg0_12.dorm

	if bit.band(arg1_12, BackYardConst.DORM_UPDATE_TYPE_UPDATEFOOD) > 0 or bit.band(arg1_12, BackYardConst.DORM_UPDATE_TYPE_USEFOOD) > 0 or bit.band(arg1_12, BackYardConst.DORM_UPDATE_TYPE_EXTENDFOOD) > 0 then
		arg0_12:CalcStockLeftTime()
	end

	if bit.band(arg1_12, BackYardConst.DORM_UPDATE_TYPE_SHIP) > 0 then
		arg0_12:CalcStockLeftTime()
		arg0_12:UpdateTrainBtn()
	end

	if bit.band(arg1_12, BackYardConst.DORM_UPDATE_TYPE_LEVEL) > 0 then
		SetActive(arg0_12.templateBtn, not LOCK_BACKYARD_TEMPLATE)

		if not LOCK_BACKYARD_TEMPLATE then
			arg0_12:PlayBackYardThemeTemplate()
			SetActive(arg0_12.templateBtn, var0_12:IsMaxLevel() and arg0_12:IsInner())
		end
	end

	if bit.band(arg1_12, BackYardConst.DORM_UPDATE_TYPE_UPDATEFOOD) > 0 or bit.band(arg1_12, BackYardConst.DORM_UPDATE_TYPE_LEVEL) > 0 or bit.band(arg1_12, BackYardConst.DORM_UPDATE_TYPE_USEFOOD) > 0 or bit.band(arg1_12, BackYardConst.DORM_UPDATE_TYPE_EXTENDFOOD) > 0 then
		local var1_12 = pg.dorm_data_template[var0_12.id].capacity

		arg0_12.stockBar.value = var0_12.food / (var1_12 + var0_12.dorm_food_max)
		arg0_12.stockTxt.text = math.ceil(var0_12.food) .. "/" .. var1_12 + var0_12.dorm_food_max
	end

	arg0_12:UpdateFloor()
end

function var0_0.PlayBackYardThemeTemplate(arg0_13)
	if getProxy(DormProxy):getRawData():IsMaxLevel() and not pg.NewStoryMgr.GetInstance():GetPlayedFlag(90021) then
		_BackyardMsgBoxMgr:Show({
			modal = true,
			hideNo = true,
			hideClose = true,
			content = i18n("open_backyard_theme_template_tip"),
			weight = LayerWeightConst.TOP_LAYER
		})
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = "NG0020"
		})
	end
end

function var0_0.UpdateTrainBtn(arg0_14)
	if arg0_14.contextData.floor == 1 then
		arg0_14.trainBtnLabel.text = i18n("courtyard_label_train")
		arg0_14.trainBtnTxt.text = arg0_14.dorm:GetStateShipCnt(Ship.STATE_TRAIN) .. "/" .. arg0_14.dorm.exp_pos
	elseif arg0_14.contextData.floor == 2 then
		arg0_14.trainBtnLabel.text = i18n("courtyard_label_rest")
		arg0_14.trainBtnTxt.text = arg0_14.dorm:GetStateShipCnt(Ship.STATE_REST) .. "/" .. arg0_14.dorm.rest_pos
	end
end

function var0_0.UpdateShopTip(arg0_15)
	setActive(arg0_15.shopTip, getProxy(SettingsProxy):IsTipNewTheme() or getProxy(SettingsProxy):IsTipNewGemFurniture())
end

function var0_0.OnRemoveLayer(arg0_16, arg1_16)
	if arg1_16 == NewBackYardShopMediator then
		arg0_16:UpdateShopTip()
	end
end

function var0_0.CalcStockLeftTime(arg0_17)
	local var0_17 = arg0_17.dorm

	arg0_17:RemoveTimer()

	arg0_17.stockTimeTxt.text = ""

	if var0_17:GetStateShipCnt(Ship.STATE_TRAIN) <= 0 or var0_17.food <= 0 then
		return
	end

	local var1_17 = var0_17:getFoodLeftTime()

	arg0_17.timer = Timer.New(function()
		local var0_18 = math.floor(var1_17) - pg.TimeMgr.GetInstance():GetServerTime()

		arg0_17.stockTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var0_18)

		if var0_18 <= 0 then
			arg0_17:RemoveTimer()
		end
	end, 1, -1)

	arg0_17.timer:Start()
	arg0_17.timer.func()
end

function var0_0.RemoveTimer(arg0_19)
	arg0_19.stockTimeTxt.text = ""

	if arg0_19.timer then
		arg0_19.timer:Stop()

		arg0_19.timer = nil
	end
end

function var0_0.GetMoveY(arg0_20)
	return {
		{
			arg0_20._tf,
			-1
		}
	}
end

function var0_0.UpdateFloor(arg0_21, arg1_21)
	SetActive(arg0_21.granaryBtn, arg0_21:IsInner() and getProxy(DormProxy).floor == 1)
	arg0_21:UpdateTrainBtn()
	setActive(arg0_21.icon1, getProxy(DormProxy).floor == 1)
	setActive(arg0_21.icon2, getProxy(DormProxy).floor == 2)
end

function var0_0.OnDispose(arg0_22)
	arg0_22:RemoveTimer()
end

return var0_0
