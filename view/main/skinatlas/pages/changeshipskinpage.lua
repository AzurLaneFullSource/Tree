local var0_0 = class("ChangeShipSkinPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ChangeShipSkinPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.cancelBtn = arg0_2:findTF("window/cancel_btn")
	arg0_2.confirmBtn = arg0_2:findTF("window/exchange_btn")
	arg0_2.closeBtn = arg0_2:findTF("window/top/btnBack")
	arg0_2.shipContent = arg0_2:findTF("window/sliders/scroll_rect/content")
	arg0_2.shipCardTpl = arg0_2.shipContent:GetChild(0)
	arg0_2.flagShipToggle = arg0_2:findTF("window/flag_bg/flag_ship")
	arg0_2.flagRandomToggle = arg0_2:findTF("window/flag_bg/flag_random")

	setText(arg0_2:findTF("window/top/title_list/infomation/title"), i18n("chang_ship_skin_window_title"))
	setText(arg0_2:findTF("window/sliders/please/Text"), i18n("choose_ship_to_wear_this_skin"))
	setText(arg0_2:findTF("window/exchange_btn/Image"), i18n("change"))
	setText(arg0_2._tf:Find("window/cancel_btn/Image"), i18n("word_cancel"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		arg0_3:OnConfirm()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3._tf:Find("bg0"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.flagShipToggle, function(arg0_8)
		arg0_3.flagShipMark = arg0_8
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.flagRandomToggle, function(arg0_9)
		arg0_3.flagRandomMark = arg0_9
	end, SFX_PANEL)
end

function var0_0.OnConfirm(arg0_10)
	if not arg0_10.selectIds or #arg0_10.selectIds <= 0 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("new_skin_no_choose"),
			onYes = function()
				arg0_10:Hide()
			end
		})

		return
	end

	for iter0_10, iter1_10 in ipairs(arg0_10.selectIds) do
		local var0_10, var1_10 = ShipPhantom.UnpackMark(iter1_10)

		pg.m02:sendNotification(GAME.SET_SHIP_SKIN, {
			shipId = var0_10,
			phantomId = var1_10,
			skinId = arg0_10.skin.id
		})
	end

	arg0_10:SetFlagRandomMark(arg0_10.flagRandomMark)

	if arg0_10.flagRandomMark then
		pg.m02:sendNotification(GAME.CHANGE_RANDOM_SHIPS, {
			addList = underscore.to_array(arg0_10.selectIds),
			deleteList = {}
		})
	end

	arg0_10:SetFlagShipMark(arg0_10.flagShipMark)

	if arg0_10.flagShipMark then
		arg0_10:ShowAdmiral()
	else
		arg0_10:Hide()
	end
end

function var0_0.Show(arg0_12, arg1_12)
	var0_0.super.Show(arg0_12)
	setActive(arg0_12._tf:Find("window"), true)
	setActive(arg0_12._tf:Find("select_skin"), false)
	pg.UIMgr.GetInstance():BlurPanel(arg0_12._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	arg0_12.selectIds = {}
	arg0_12.skin = arg1_12
	arg0_12.ships = arg0_12:GetShips(arg1_12)

	triggerToggle(arg0_12.flagShipToggle, arg0_12:GetFlagShipMark())
	triggerToggle(arg0_12.flagRandomToggle, arg0_12:GetFlagRandomMark())
	arg0_12:FlushShips()
end

function var0_0.ShowAdmiral(arg0_13)
	setActive(arg0_13._tf:Find("window"), false)
	setActive(arg0_13._tf:Find("select_skin"), true)

	local var0_13 = arg0_13._tf:Find("select_skin")

	onButton(arg0_13, var0_13:Find("btnBack"), function()
		arg0_13:Hide()
	end, SFX_CANCEL)

	arg0_13.selectIndex = 1

	onButton(arg0_13, var0_13:Find("exchange_btn"), function()
		local var0_15 = arg0_13.selectIds[1]
		local var1_15 = getProxy(PlayerProxy):getRawData():GetShipPhantomMarks()

		var1_15[arg0_13.selectIndex] = var0_15

		pg.m02:sendNotification(GAME.CHANGE_PLAYER_ICON, {
			skinPage = true,
			after = var1_15
		})
		arg0_13:Hide()
	end, SFX_CONFIGM)

	arg0_13.paintingInfo = {}

	local var1_13, var2_13 = PlayerVitaeShipsPage.GetSlotMaxCnt()
	local var3_13 = getProxy(PlayerProxy):getRawData():GetShipPhantomMarks()
	local var4_13 = var0_13:Find("frame/style_scroll/view_port")

	UIItemList.StaticAlign(var4_13, var4_13:GetChild(0), var1_13, function(arg0_16, arg1_16, arg2_16)
		arg1_16 = arg1_16 + 1

		if arg0_16 == UIItemList.EventUpdate then
			onToggle(arg0_13, arg2_16, function(arg0_17)
				if arg0_17 then
					arg0_13.selectIndex = arg1_16
				end
			end, SFX_PANEL)

			local var0_16 = var3_13[arg1_16] and getProxy(BayProxy):GetShipPhantom(var3_13[arg1_16]) or nil

			setActive(arg2_16:Find("Style_card"), var0_16)
			setActive(arg2_16:Find("empty"), not var0_16)

			if var0_16 then
				local var1_16 = var0_16:getSkinId()
				local var2_16 = pg.ship_skin_template[var1_16]

				arg0_13.paintingInfo[arg1_16] = {
					paintingName = var2_16.painting or "unknown",
					painting = arg2_16:Find("Style_card/bg/mask/painting")
				}

				arg0_13:loadPainting(arg0_13.paintingInfo[arg1_16])
				changeToScrollText(arg2_16:Find("Style_card/bg/desc/name_bar/name"), var2_16.name)
				setToggleEnabled(arg2_16, true)
			else
				local var3_16 = arg1_16 > var2_13

				setActive(arg2_16:Find("empty/add"), not var3_16)
				setActive(arg2_16:Find("empty/lock"), var3_16)
				setText(arg2_16:Find("empty/lock/Text"), i18n("secretary_unlock" .. arg1_16))
				setToggleEnabled(arg2_16, not var3_16)
			end

			triggerToggle(arg2_16, arg1_16 == arg0_13.selectIndex)
		end
	end)
	setText(arg0_13._tf:Find("select_skin/title/Text"), i18n("choose_secretary_change_title"))
	setText(arg0_13._tf:Find("select_skin/please"), i18n("choose_secretary_change_to_this_ship"))
	setText(arg0_13._tf:Find("select_skin/exchange_btn/Image"), i18n("change"))
end

function var0_0.GetFlagShipMark(arg0_18)
	if arg0_18.isNew then
		return getProxy(SettingsProxy):GetSetFlagShip()
	else
		return getProxy(SettingsProxy):GetSetFlagShipForSkinAtlas()
	end
end

function var0_0.SetFlagShipMark(arg0_19, arg1_19)
	if arg0_19.isNew then
		getProxy(SettingsProxy):SetFlagShip(arg1_19)
	else
		getProxy(SettingsProxy):SetFlagShipForSkinAtlas(arg1_19)
	end
end

function var0_0.GetFlagRandomMark(arg0_20)
	return getProxy(SettingsProxy):GetFlagRandom()
end

function var0_0.SetFlagRandomMark(arg0_21, arg1_21)
	getProxy(SettingsProxy):SetFlagRandom(arg1_21)
end

function var0_0.GetShips(arg0_22, arg1_22)
	local var0_22 = getProxy(BayProxy):CanUseShareSkinPhantoms(arg1_22.id)

	table.sort(var0_22, CompareFuncs({
		function(arg0_23)
			return -arg0_23.level
		end,
		function(arg0_24)
			return -arg0_24:getStar()
		end,
		function(arg0_25)
			return arg0_25.inFleet and 0 or 1
		end,
		function(arg0_26)
			return arg0_26.createTime
		end,
		function(arg0_27)
			return arg0_27.phantomId
		end
	}))

	return var0_22
end

function var0_0.FlushShips(arg0_28)
	UIItemList.StaticAlign(arg0_28.shipContent, arg0_28.shipCardTpl, #arg0_28.ships, function(arg0_29, arg1_29, arg2_29)
		arg1_29 = arg1_29 + 1

		if arg0_29 == UIItemList.EventUpdate then
			local var0_29 = arg0_28.ships[arg1_29]
			local var1_29 = ShipDetailCard.New(arg2_29.gameObject)

			var1_29:update(var0_29, arg0_28.skin.id)

			local var2_29 = var0_29:getSkinId() == arg0_28.skin.id

			setActive(var1_29.maskStatusOb, var2_29)
			setText(var1_29.maskStatusOb:Find("Text"), "-  " .. i18n("index_CANTUSE") .. "  -")
			setActive(arg2_29:Find("phantom_mark"), var0_29.phantomId > 0)
			onToggle(arg0_28, var1_29.tr, function(arg0_30)
				if var0_29:getSkinId() == arg0_28.skin.id then
					return
				end

				var1_29:updateSelected(arg0_30)

				if arg0_30 then
					table.insert(arg0_28.selectIds, var1_29.shipVO:GetSelectMark())
				else
					table.removebyvalue(arg0_28.selectIds, var1_29.shipVO:GetSelectMark())
				end
			end, SFX_PANEL)
		end
	end)
end

function var0_0.Hide(arg0_31)
	var0_0.super.Hide(arg0_31)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_31._tf, arg0_31._parentTf)

	arg0_31.selectIds = {}

	existCall(arg0_31.hideCallback)
end

function var0_0.loadPainting(arg0_32, arg1_32)
	local var0_32 = checkABExist("painting/" .. arg1_32.paintingName .. "_n")

	setPaintingPrefabAsync(arg1_32.painting, arg1_32.paintingName, "pifu")
end

function var0_0.clearPainting(arg0_33, arg1_33)
	if arg1_33.paintingName then
		retPaintingPrefab(arg1_33.painting, arg1_33.paintingName)

		arg1_33.paintingName = nil
	end
end

function var0_0.OnDestroy(arg0_34)
	if arg0_34:isShowing() then
		arg0_34:Hide()
	end

	if arg0_34.paintingInfo then
		for iter0_34, iter1_34 in pairs(arg0_34.paintingInfo) do
			arg0_34:clearPainting(iter1_34)
		end
	end

	arg0_34.shipCards = nil
	arg0_34.selectIds = nil
end

return var0_0
