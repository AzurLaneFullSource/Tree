local var0 = class("BuildShipRegularExchangeLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "BuildShipRegularExchangeUI"
end

function var0.preload(arg0, arg1)
	arg0.cfg = pg.ship_data_create_exchange[REGULAR_BUILD_POOL_EXCHANGE_ID]
	arg0.ids = arg0.cfg.exchange_ship_id
	arg0.iconSprites = {}

	local var0 = {}

	for iter0, iter1 in ipairs(arg0.ids) do
		table.insert(var0, function(arg0)
			GetSpriteFromAtlasAsync("RegularExchangeIcon", tostring(iter1), function(arg0)
				arg0.iconSprites[iter1] = arg0

				arg0()
			end)
		end)
	end

	seriesAsync(var0, arg1)
end

function var0.setCount(arg0, arg1)
	arg0.count = arg1

	setText(arg0.textCount, arg0.count .. "/" .. arg0.cfg.exchange_request)
	setGray(arg0.btnConfirm, arg0.count < arg0.cfg.exchange_request)
end

function var0.init(arg0)
	arg0.btnBack = arg0._tf:Find("top/bg/btn_back")

	onButton(arg0, arg0.btnBack, function()
		arg0:closeView()
	end, SFX_CANCEL)

	local var0 = arg0._tf:Find("select/container")

	arg0.iconList = UIItemList.New(var0, var0:Find("tpl"))

	arg0.iconList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = Ship.New({
				configId = arg0.ids[arg1]
			})

			setImageSprite(arg2:Find("Image"), arg0.iconSprites[var0.configId], true)
			setActive(arg2:Find("noget"), not getProxy(CollectionProxy):getShipGroup(var0:getGroupId()))
			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					arg0:setSelectedShip(var0)
				end
			end, SFX_PANEL)
			triggerToggle(arg2, arg1 == 1)
		end
	end)
	onButton(arg0, arg0._tf:Find("select/operation/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("Normalbuild_URexchange_help")
		})
	end, SFX_PANEL)
	setText(arg0._tf:Find("select/operation/count/Text"), i18n("Normalbuild_URexchange_text2") .. ":")

	arg0.textCount = arg0._tf:Find("select/operation/count/num")
	arg0.btnConfirm = arg0._tf:Find("select/operation/confirm")

	onButton(arg0, arg0.btnConfirm, function()
		if arg0.count < arg0.cfg.exchange_request then
			pg.TipsMgr.GetInstance():ShowTips(i18n("Normalbuild_URexchange_warning1"))
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("Normalbuild_URexchange_confirm", arg0.shipVO:getName()),
				onYes = function()
					arg0:emit(BuildShipRegularExchangeMediator.EXCHAGNE_SHIP, arg0.shipVO.configId)
					arg0:closeView()
				end
			})
		end
	end, SFX_CONFIRM)

	arg0.rtName = arg0._tf:Find("select/name_bg")
	arg0.rtPaint = arg0._tf:Find("main/paint")
end

function var0.setSelectedShip(arg0, arg1)
	if arg0.shipVO then
		retPaintingPrefab(arg0.rtPaint, arg0.shipVO:getPainting())
	end

	arg0.shipVO = arg1

	local var0 = ShipType.Type2BattlePrint(arg1:getShipType())

	eachChild(arg0.rtName:Find("shiptype"), function(arg0)
		setActive(arg0, arg0.name == var0)
	end)
	setText(arg0.rtName:Find("name"), arg1:getName())
	setText(arg0.rtName:Find("english"), string.upper(arg1:getConfig("english_name")))
	setPaintingPrefabAsync(arg0.rtPaint, arg1:getPainting(), "huode")
end

function var0.didEnter(arg0)
	arg0.iconList:align(#arg0.ids)
end

function var0.willExit(arg0)
	arg0.iconSprites = nil

	if arg0.shipVO then
		retPaintingPrefab(arg0.rtPaint, arg0.shipVO:getPainting())
	end
end

return var0
