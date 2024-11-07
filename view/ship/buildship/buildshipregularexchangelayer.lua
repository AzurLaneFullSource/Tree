local var0_0 = class("BuildShipRegularExchangeLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "BuildShipRegularExchangeUI"
end

function var0_0.preload(arg0_2, arg1_2)
	arg0_2.cfg = pg.ship_data_create_exchange[REGULAR_BUILD_POOL_EXCHANGE_ID]
	arg0_2.ids = arg0_2.cfg.exchange_ship_id
	arg0_2.iconSprites = {}

	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.ids) do
		table.insert(var0_2, function(arg0_3)
			GetSpriteFromAtlasAsync("RegularExchangeIcon", string.format("Assets/ArtResource/Atlas/RegularExchangeIcon/%d.png", iter1_2), function(arg0_4)
				arg0_2.iconSprites[iter1_2] = arg0_4

				arg0_3()
			end)
		end)
	end

	seriesAsync(var0_2, arg1_2)
end

function var0_0.setCount(arg0_5, arg1_5)
	arg0_5.count = arg1_5

	setText(arg0_5.textCount, arg0_5.count .. "/" .. arg0_5.cfg.exchange_request)
	setGray(arg0_5.btnConfirm, arg0_5.count < arg0_5.cfg.exchange_request)
end

function var0_0.init(arg0_6)
	arg0_6.btnBack = arg0_6._tf:Find("top/bg/btn_back")

	onButton(arg0_6, arg0_6.btnBack, function()
		arg0_6:closeView()
	end, SFX_CANCEL)

	local var0_6 = arg0_6._tf:Find("select/container")

	arg0_6.iconList = UIItemList.New(var0_6, var0_6:Find("tpl"))

	arg0_6.iconList:make(function(arg0_8, arg1_8, arg2_8)
		arg1_8 = arg1_8 + 1

		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = Ship.New({
				configId = arg0_6.ids[arg1_8]
			})

			setImageSprite(arg2_8:Find("Image"), arg0_6.iconSprites[var0_8.configId], true)
			setActive(arg2_8:Find("noget"), not getProxy(CollectionProxy):getShipGroup(var0_8:getGroupId()))
			onToggle(arg0_6, arg2_8, function(arg0_9)
				if arg0_9 then
					arg0_6:setSelectedShip(var0_8)
				end
			end, SFX_PANEL)
			triggerToggle(arg2_8, arg1_8 == 1)
		end
	end)
	onButton(arg0_6, arg0_6._tf:Find("select/operation/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("Normalbuild_URexchange_help")
		})
	end, SFX_PANEL)
	setText(arg0_6._tf:Find("select/operation/count/Text"), i18n("Normalbuild_URexchange_text2") .. ":")

	arg0_6.textCount = arg0_6._tf:Find("select/operation/count/num")
	arg0_6.btnConfirm = arg0_6._tf:Find("select/operation/confirm")

	onButton(arg0_6, arg0_6.btnConfirm, function()
		if arg0_6.count < arg0_6.cfg.exchange_request then
			pg.TipsMgr.GetInstance():ShowTips(i18n("Normalbuild_URexchange_warning1"))
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("Normalbuild_URexchange_confirm", arg0_6.shipVO:getName()),
				onYes = function()
					arg0_6:emit(BuildShipRegularExchangeMediator.EXCHAGNE_SHIP, arg0_6.shipVO.configId)
					arg0_6:closeView()
				end
			})
		end
	end, SFX_CONFIRM)

	arg0_6.rtName = arg0_6._tf:Find("select/name_bg")
	arg0_6.rtPaint = arg0_6._tf:Find("main/paint")
end

function var0_0.setSelectedShip(arg0_13, arg1_13)
	if arg0_13.shipVO then
		retPaintingPrefab(arg0_13.rtPaint, arg0_13.shipVO:getPainting())
	end

	arg0_13.shipVO = arg1_13

	local var0_13 = ShipType.Type2BattlePrint(arg1_13:getShipType())

	GetImageSpriteFromAtlasAsync("shiptype", var0_13, arg0_13.rtName:Find("shiptype/Image"), true)
	setText(arg0_13.rtName:Find("name"), arg1_13:getName())
	setText(arg0_13.rtName:Find("english"), string.upper(arg1_13:getConfig("english_name")))
	setPaintingPrefabAsync(arg0_13.rtPaint, arg1_13:getPainting(), "huode")
end

function var0_0.didEnter(arg0_14)
	arg0_14.iconList:align(#arg0_14.ids)
end

function var0_0.willExit(arg0_15)
	arg0_15.iconSprites = nil

	if arg0_15.shipVO then
		retPaintingPrefab(arg0_15.rtPaint, arg0_15.shipVO:getPainting())
	end
end

return var0_0
