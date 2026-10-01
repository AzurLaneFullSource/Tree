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

function var0_0.getResource(arg0_7)
	local var0_7 = var0_0.super.getResource(arg0_7)
	local var1_7 = {
		"RegularExchangeIcon"
	}
	local var2_7 = arg0_7.contextData.itemVO or arg0_7.itemVO

	if var2_7 then
		for iter0_7, iter1_7 in ipairs(var2_7:getConfig("usage_arg")) do
			local var3_7 = pg.item_usage_invitation[iter1_7].ship_id
			local var4_7 = Ship.New({
				configId = var3_7
			}):getPainting()

			if noEmptyStr(var4_7) then
				table.insert(var1_7, "painting/" .. var4_7)
			end
		end
	end

	for iter2_7, iter3_7 in ipairs(var1_7) do
		if not table.contains(var0_7, iter3_7) then
			table.insert(var0_7, iter3_7)
		end
	end

	return var0_7
end

function var0_0.init(arg0_8)
	arg0_8.backBtn = arg0_8._tf:Find("top/bg/btn_back")

	onButton(arg0_8, arg0_8.backBtn, function()
		arg0_8:closeView()
	end, SFX_CANCEL)

	local var0_8 = arg0_8._tf:Find("select/view/container")

	arg0_8.iconList = UIItemList.New(var0_8, var0_8:Find("tpl"))

	arg0_8.iconList:make(function(arg0_10, arg1_10, arg2_10)
		arg1_10 = arg1_10 + 1

		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = Ship.New({
				configId = arg0_8.ids[arg1_10]
			})

			setImageSprite(arg2_10:Find("Image"), arg0_8.iconSprites[var0_10.configId], true)
			setActive(arg2_10:Find("noget"), not getProxy(CollectionProxy):getShipGroup(var0_10:getGroupId()))
			onToggle(arg0_8, arg2_10, function(arg0_11)
				if arg0_11 then
					arg0_8:setSelectedShip(var0_10)
				end
			end, SFX_PANEL)
			triggerToggle(arg2_10, arg1_10 == 1)
		end
	end)

	arg0_8.btnConfirm = arg0_8._tf:Find("select/operation/confirm")

	onButton(arg0_8, arg0_8.btnConfirm, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("handbook_ur_double_check", arg0_8.shipVO:getName()),
			onYes = function()
				arg0_8:emit(AssignedShipMediator.ON_USE_ITEM, arg0_8.itemVO.id, 1, {
					arg0_8.shipUsageDic[arg0_8.shipVO:GetConfigID()]
				})
			end
		})
	end, SFX_CONFIRM)

	arg0_8.rtName = arg0_8._tf:Find("select/name_bg")
	arg0_8.rtPaint = arg0_8._tf:Find("main/paint")
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
	arg0_15.iconList:align(#arg0_15.ids)
end

function var0_0.didEnter(arg0_16)
	arg0_16:flush()
end

function var0_0.willExit(arg0_17)
	arg0_17.iconSprites = nil

	if arg0_17.shipVO then
		retPaintingPrefab(arg0_17.rtPaint, arg0_17.shipVO:getPainting())
	end
end

return var0_0
