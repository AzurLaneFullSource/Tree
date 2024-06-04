local var0 = class("CourtYardBottomPanel", import(".CourtYardBasePanel"))

function var0.GetUIName(arg0)
	return "main/bottomPanel"
end

function var0.init(arg0)
	arg0.granaryBtn = arg0:findTF("bottomleft/feed_btn")
	arg0.stockBar = arg0:findTF("progress", arg0.granaryBtn):GetComponent(typeof(Slider))
	arg0.stockTimeTxt = arg0:findTF("time", arg0.granaryBtn):GetComponent(typeof(Text))
	arg0.stockTxt = arg0:findTF("Text", arg0.granaryBtn):GetComponent(typeof(Text))
	arg0.stampBtn = arg0:findTF("stamp")
	arg0.shopBtn = arg0:findTF("bottomright/shop_btn")
	arg0.decorateBtn = arg0:findTF("bottomright/decorate_btn")
	arg0.templateBtn = arg0:findTF("bottomright/theme_template_btn")
	arg0.shareBtn = arg0:findTF("bottomright/share_btn")
	arg0.shopTip = arg0.shopBtn:Find("tip")
	arg0.trainBtn = arg0:findTF("bottomleft/train_btn")
	arg0.trainBtnTxt = arg0.trainBtn:Find("Text"):GetComponent(typeof(Text))
	arg0.trainBtnLabel = arg0.trainBtn:Find("label"):GetComponent(typeof(Text))
	arg0.icon1 = arg0:findTF("bottomleft/train_btn/icon")
	arg0.icon2 = arg0:findTF("bottomleft/train_btn/icon_1")

	setText(arg0.granaryBtn:Find("label"), i18n("courtyard_label_capacity"))
	setText(arg0.shareBtn:Find("Text"), i18n("courtyard_label_share"))
	setText(arg0.shopBtn:Find("Text"), i18n("courtyard_label_shop"))
	setText(arg0.decorateBtn:Find("Text"), i18n("courtyard_label_decoration"))
	setText(arg0.templateBtn:Find("Text"), i18n("courtyard_label_template"))
end

function var0.OnRegister(arg0)
	onButton(arg0, arg0.stampBtn, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(7)
	end, SFX_PANEL)
	onButton(arg0, arg0.shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeBackyard, pg.ShareMgr.PANEL_TYPE_PINK)
	end, SFX_PANEL)
	onButton(arg0, arg0.granaryBtn, function()
		arg0:emit(CourtYardMediator.GO_GRANARY)
	end, SFX_PANEL)
	onButton(arg0, arg0.shopBtn, function()
		arg0:emit(CourtYardMediator.GO_SHOP)
	end, SFX_PANEL)
	onButton(arg0, arg0.decorateBtn, function()
		arg0:emit(CourtYardMediator.OPEN_DECORATION)
	end, SFX_PANEL)
	onButton(arg0, arg0.templateBtn, function()
		if LOCK_BACKYARD_TEMPLATE then
			return
		end

		arg0:emit(CourtYardMediator.GO_THEME_TEMPLATE)
	end, SFX_PANEL)
	onButton(arg0, arg0.trainBtn, function()
		if arg0.contextData.floor == 1 then
			arg0:emit(CourtYardMediator.SEL_TRAIN_SHIP)
		elseif arg0.contextData.floor == 2 then
			arg0:emit(CourtYardMediator.SEL_REST_SHIP)
		end
	end, SFX_PANEL)
	arg0:SetActive(arg0.stampBtn, not LOCK_CLICK_MINGSHI and getProxy(TaskProxy):mingshiTouchFlagEnabled())
	arg0:UpdateShopTip()
end

function var0.OnVisitRegister(arg0)
	setActive(arg0._tf, false)
end

function var0.OnFlush(arg0, arg1)
	arg1 = arg1 or bit.bor(BackYardConst.DORM_UPDATE_TYPE_UPDATEFOOD, BackYardConst.DORM_UPDATE_TYPE_LEVEL, BackYardConst.DORM_UPDATE_TYPE_SHIP, BackYardConst.DORM_UPDATE_TYPE_USEFOOD, BackYardConst.DORM_UPDATE_TYPE_EXTENDFOOD)

	local var0 = arg0.dorm

	if bit.band(arg1, BackYardConst.DORM_UPDATE_TYPE_UPDATEFOOD) > 0 or bit.band(arg1, BackYardConst.DORM_UPDATE_TYPE_USEFOOD) > 0 or bit.band(arg1, BackYardConst.DORM_UPDATE_TYPE_EXTENDFOOD) > 0 then
		arg0:CalcStockLeftTime()
	end

	if bit.band(arg1, BackYardConst.DORM_UPDATE_TYPE_SHIP) > 0 then
		arg0:CalcStockLeftTime()
		arg0:UpdateTrainBtn()
	end

	if bit.band(arg1, BackYardConst.DORM_UPDATE_TYPE_LEVEL) > 0 then
		SetActive(arg0.templateBtn, not LOCK_BACKYARD_TEMPLATE)

		if not LOCK_BACKYARD_TEMPLATE then
			arg0:PlayBackYardThemeTemplate()
			SetActive(arg0.templateBtn, var0:IsMaxLevel() and arg0:IsInner())
		end
	end

	if bit.band(arg1, BackYardConst.DORM_UPDATE_TYPE_UPDATEFOOD) > 0 or bit.band(arg1, BackYardConst.DORM_UPDATE_TYPE_LEVEL) > 0 or bit.band(arg1, BackYardConst.DORM_UPDATE_TYPE_USEFOOD) > 0 or bit.band(arg1, BackYardConst.DORM_UPDATE_TYPE_EXTENDFOOD) > 0 then
		local var1 = pg.dorm_data_template[var0.id].capacity

		arg0.stockBar.value = var0.food / (var1 + var0.dorm_food_max)
		arg0.stockTxt.text = math.ceil(var0.food) .. "/" .. var1 + var0.dorm_food_max
	end

	arg0:UpdateFloor()
end

function var0.PlayBackYardThemeTemplate(arg0)
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

function var0.UpdateTrainBtn(arg0)
	if arg0.contextData.floor == 1 then
		arg0.trainBtnLabel.text = i18n("courtyard_label_train")
		arg0.trainBtnTxt.text = arg0.dorm:GetStateShipCnt(Ship.STATE_TRAIN) .. "/" .. arg0.dorm.exp_pos
	elseif arg0.contextData.floor == 2 then
		arg0.trainBtnLabel.text = i18n("courtyard_label_rest")
		arg0.trainBtnTxt.text = arg0.dorm:GetStateShipCnt(Ship.STATE_REST) .. "/" .. arg0.dorm.rest_pos
	end
end

function var0.UpdateShopTip(arg0)
	setActive(arg0.shopTip, getProxy(SettingsProxy):IsTipNewTheme() or getProxy(SettingsProxy):IsTipNewGemFurniture())
end

function var0.OnRemoveLayer(arg0, arg1)
	if arg1 == NewBackYardShopMediator then
		arg0:UpdateShopTip()
	end
end

function var0.CalcStockLeftTime(arg0)
	local var0 = arg0.dorm

	arg0:RemoveTimer()

	arg0.stockTimeTxt.text = ""

	if var0:GetStateShipCnt(Ship.STATE_TRAIN) <= 0 or var0.food <= 0 then
		return
	end

	local var1 = var0:getFoodLeftTime()

	arg0.timer = Timer.New(function()
		local var0 = math.floor(var1) - pg.TimeMgr.GetInstance():GetServerTime()

		arg0.stockTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var0)

		if var0 <= 0 then
			arg0:RemoveTimer()
		end
	end, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.RemoveTimer(arg0)
	arg0.stockTimeTxt.text = ""

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.GetMoveY(arg0)
	return {
		{
			arg0._tf,
			-1
		}
	}
end

function var0.UpdateFloor(arg0, arg1)
	SetActive(arg0.granaryBtn, arg0:IsInner() and getProxy(DormProxy).floor == 1)
	arg0:UpdateTrainBtn()
	setActive(arg0.icon1, getProxy(DormProxy).floor == 1)
	setActive(arg0.icon2, getProxy(DormProxy).floor == 2)
end

function var0.OnDispose(arg0)
	arg0:RemoveTimer()
end

return var0
