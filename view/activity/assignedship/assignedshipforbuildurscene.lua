local var0_0 = class("AssignedShipForBuildURScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AssignedShipBuildURUI"
end

function var0_0.setItemVO(arg0_2, arg1_2)
	arg0_2.itemVO = arg1_2
end

function var0_0.preload(arg0_3, arg1_3)
	arg0_3.shipUsageDic = {}
	arg0_3.ids = underscore.map(arg0_3.contextData.itemVO:getConfig("usage_arg"), function(arg0_4)
		local var0_4 = pg.item_usage_invitation[arg0_4].ship_id

		arg0_3.shipUsageDic[var0_4] = arg0_4

		return var0_4
	end)
	arg0_3.iconSprites = {}

	local var0_3 = {}

	for iter0_3, iter1_3 in ipairs(arg0_3.ids) do
		table.insert(var0_3, function(arg0_5)
			GetSpriteFromAtlasAsync("RegularExchangeIcon", tostring(iter1_3), function(arg0_6)
				arg0_3.iconSprites[iter1_3] = arg0_6

				arg0_5()
			end)
		end)
	end

	seriesAsync(var0_3, arg1_3)
end

function var0_0.init(arg0_7)
	arg0_7.backBtn = arg0_7._tf:Find("top/bg/btn_back")

	onButton(arg0_7, arg0_7.backBtn, function()
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

	arg0_7.btnConfirm = arg0_7._tf:Find("select/operation/confirm")

	onButton(arg0_7, arg0_7.btnConfirm, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("handbook_ur_double_check", arg0_7.shipVO:getName()),
			onYes = function()
				arg0_7:emit(AssignedShipMediator.ON_USE_ITEM, arg0_7.itemVO.id, 1, {
					arg0_7.shipUsageDic[arg0_7.shipVO:GetConfigID()]
				})
			end
		})
	end, SFX_CONFIRM)

	arg0_7.rtName = arg0_7._tf:Find("select/name_bg")
	arg0_7.rtPaint = arg0_7._tf:Find("main/paint")
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

function var0_0.flush(arg0_14)
	arg0_14.iconList:align(#arg0_14.ids)
end

function var0_0.didEnter(arg0_15)
	arg0_15:flush()
end

function var0_0.willExit(arg0_16)
	arg0_16.iconSprites = nil

	if arg0_16.shipVO then
		retPaintingPrefab(arg0_16.rtPaint, arg0_16.shipVO:getPainting())
	end
end

return var0_0
