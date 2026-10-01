local var0_0 = class("BuildShipRegularExchangeLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "BuildShipRegularExchangeUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"regularexchangeicon",
		"shiptype"
	}
	local var1_2 = pg.ship_data_create_exchange[REGULAR_BUILD_POOL_EXCHANGE_ID]

	for iter0_2, iter1_2 in ipairs(var1_2.exchange_ship_id or {}) do
		local var2_2 = pg.ship_data_statistics[iter1_2]
		local var3_2 = var2_2 and pg.ship_skin_template[var2_2.skin_id]

		if var3_2 and noEmptyStr(var3_2.painting) then
			table.insertto(var0_2, ResPathSupport.GetPaintingListByPaintingName(var3_2.painting))
		end
	end

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2))
end

function var0_0.preload(arg0_3, arg1_3)
	arg0_3.cfg = pg.ship_data_create_exchange[REGULAR_BUILD_POOL_EXCHANGE_ID]
	arg0_3.ids = arg0_3.cfg.exchange_ship_id
	arg0_3.iconSprites = {}

	AssetBundleHelper.LoadManyAssets("RegularExchangeIcon", underscore.map(arg0_3.ids, function(arg0_4)
		return tostring(arg0_4)
	end), nil, true, function(arg0_5)
		for iter0_5, iter1_5 in pairs(arg0_5) do
			arg0_3.iconSprites[tonumber(iter0_5)] = iter1_5
		end

		existCall(arg1_3)
	end, true)
end

function var0_0.setCount(arg0_6, arg1_6)
	arg0_6.count = arg1_6

	setText(arg0_6.textCount, arg0_6.count .. "/" .. arg0_6.cfg.exchange_request)
	setGray(arg0_6.btnConfirm, arg0_6.count < arg0_6.cfg.exchange_request)
end

function var0_0.init(arg0_7)
	arg0_7.btnBack = arg0_7._tf:Find("top/bg/btn_back")

	onButton(arg0_7, arg0_7.btnBack, function()
		arg0_7:closeView()
	end, SFX_CANCEL)

	local var0_7 = arg0_7._tf:Find("select/view/container")

	arg0_7.iconList = UIItemList.New(var0_7, var0_7:Find("tpl"))

	arg0_7.iconList:make(function(arg0_9, arg1_9, arg2_9)
		arg1_9 = arg1_9 + 1

		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = Ship.New({
				configId = arg0_7.ids[arg1_9]
			})

			setImageSprite(arg2_9:Find("Image"), arg0_7.iconSprites[var0_9.configId], true)
			setActive(arg2_9:Find("noget"), not getProxy(CollectionProxy):getShipGroup(var0_9:getGroupId()))
			onToggle(arg0_7, arg2_9, function(arg0_10)
				if arg0_10 then
					arg0_7:setSelectedShip(var0_9)
				end
			end, SFX_PANEL)
			triggerToggle(arg2_9, arg1_9 == 1)
		end
	end)
	onButton(arg0_7, arg0_7._tf:Find("select/operation/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("Normalbuild_URexchange_help")
		})
	end, SFX_PANEL)
	setText(arg0_7._tf:Find("select/operation/count/Text"), i18n("Normalbuild_URexchange_text2") .. ":")

	arg0_7.textCount = arg0_7._tf:Find("select/operation/count/num")
	arg0_7.btnConfirm = arg0_7._tf:Find("select/operation/confirm")

	onButton(arg0_7, arg0_7.btnConfirm, function()
		if arg0_7.count < arg0_7.cfg.exchange_request then
			pg.TipsMgr.GetInstance():ShowTips(i18n("Normalbuild_URexchange_warning1"))
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("Normalbuild_URexchange_confirm", arg0_7.shipVO:getName()),
				onYes = function()
					arg0_7:emit(BuildShipRegularExchangeMediator.EXCHAGNE_SHIP, arg0_7.shipVO.configId)
					arg0_7:closeView()
				end
			})
		end
	end, SFX_CONFIRM)

	arg0_7.rtName = arg0_7._tf:Find("select/name_bg")
	arg0_7.rtPaint = arg0_7._tf:Find("main/paint")

	arg0_7:OverlayPanel(arg0_7._tf)
end

function var0_0.setSelectedShip(arg0_14, arg1_14)
	if arg0_14.shipVO then
		retPaintingPrefab(arg0_14.rtPaint, arg0_14.shipVO:getPainting())
	end

	arg0_14.shipVO = arg1_14

	local var0_14 = ShipType.Type2BattlePrint(arg1_14:getShipType())

	GetImageSpriteFromAtlasAsync("shiptype", var0_14, arg0_14.rtName:Find("shiptype/Image"), true)
	setText(arg0_14.rtName:Find("name"), arg1_14:getName())
	setText(arg0_14.rtName:Find("english"), string.upper(arg1_14:getConfig("english_name")))
	setPaintingPrefabAsync(arg0_14.rtPaint, arg1_14:getPainting(), "huode")
end

function var0_0.flush(arg0_15)
	mergeSort(arg0_15.ids, CompareFuncs({
		function(arg0_16)
			local var0_16 = Ship.New({
				configId = arg0_16
			})

			return getProxy(CollectionProxy):getShipGroup(var0_16:getGroupId()) and 1 or 0
		end
	}, true))
	arg0_15.iconList:align(#arg0_15.ids)
end

function var0_0.didEnter(arg0_17)
	arg0_17:flush()
end

function var0_0.willExit(arg0_18)
	arg0_18.iconSprites = nil

	if arg0_18.shipVO then
		retPaintingPrefab(arg0_18.rtPaint, arg0_18.shipVO:getPainting())
	end

	arg0_18:UnOverlayPanel(arg0_18._tf)
end

return var0_0
