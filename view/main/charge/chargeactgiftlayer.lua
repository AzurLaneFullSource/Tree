local var0_0 = class("ChargeActGiftLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ChargeIActGiftUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = getProxy(ActivityProxy):getActivityById(arg0_2.contextData.actId)
	local var1_2 = {}

	if var0_2 and not var0_2:isEnd() then
		arg0_2.spriteDic = {
			name = {},
			icon = {}
		}

		for iter0_2, iter1_2 in ipairs(var0_2:getConfig("config_data")[1]) do
			table.insert(var1_2, function(arg0_3)
				LoadSpriteAtlasAsync("actgiftpackages/skin_card_name_" .. iter1_2, "", function(arg0_4)
					arg0_2.spriteDic.name[iter1_2] = arg0_4

					arg0_3()
				end)
			end)
			table.insert(var1_2, function(arg0_5)
				LoadSpriteAtlasAsync("actgiftpackages/skin_card_" .. iter1_2, "", function(arg0_6)
					arg0_2.spriteDic.icon[iter1_2] = arg0_6

					arg0_5()
				end)
			end)
		end
	end

	parallelAsync(var1_2, arg1_2)
end

function var0_0.getResource(arg0_7)
	local var0_7 = var0_0.super.getResource(arg0_7)
	local var1_7 = {}

	local function var2_7(arg0_8)
		if noEmptyStr(arg0_8) and not table.contains(var1_7, arg0_8) then
			table.insert(var1_7, arg0_8)
		end
	end

	local var3_7 = getProxy(ActivityProxy):getActivityById(arg0_7.contextData.actId)

	if var3_7 and not var3_7:isEnd() then
		for iter0_7, iter1_7 in ipairs(var3_7:getConfig("config_data")[1] or {}) do
			var2_7("actgiftpackages/skin_card_name_" .. iter1_7)
			var2_7("actgiftpackages/skin_card_" .. iter1_7)
		end
	end

	for iter2_7, iter3_7 in ipairs(var1_7) do
		if not table.contains(var0_7, iter3_7) then
			table.insert(var0_7, iter3_7)
		end
	end

	return var0_7
end

function var0_0.init(arg0_9)
	setText(arg0_9.rtTip:Find("Text"), i18n("black5_bundle_desc"))
	setText(arg0_9.rtAward:Find("word/Text"), i18n("black5_bundle_tip"))
	setText(arg0_9.btnPay:Find("Text"), i18n("black5_bundle_buy_all"))
	setText(arg0_9.btnGet:Find("Text"), i18n("black5_bundle_receive"))
	arg0_9:BlurPanel(arg0_9._tf)
end

function var0_0.didEnter(arg0_10)
	onButton(arg0_10, arg0_10.rtBg, function()
		arg0_10:closeView()
	end, SFX_CANCEL)
	onButton(arg0_10, arg0_10.rtTip, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("black5_bundle_help")
		})
	end, SFX_PANEL)

	local var0_10 = getProxy(ActivityProxy):getActivityById(arg0_10.contextData.actId)
	local var1_10 = var0_10:getConfig("config_data")[1]

	UIItemList.StaticAlign(arg0_10.rtContainer, arg0_10.rtSkinTpl, #var1_10, function(arg0_13, arg1_13, arg2_13)
		arg1_13 = arg1_13 + 1

		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = var1_10[arg1_13]

			setImageSprite(arg2_13:Find("name"), arg0_10.spriteDic.name[var0_13])
			setImageSprite(arg2_13, arg0_10.spriteDic.icon[var0_13])

			local var1_13 = getProxy(ShipSkinProxy):hasNonLimitSkin(var0_13)

			setActive(arg2_13:Find("btn_skin"), not var1_13)
			setActive(arg2_13:Find("got"), var1_13)

			if var1_13 then
				setText(arg2_13:Find("got/Text"), i18n("black5_bundle_purchased"))
			else
				local var2_13 = Goods.Create({
					id = pg.ship_skin_template[var0_13].shop_id
				}, Goods.TYPE_SKIN):getConfig("resource_num")

				setText(arg2_13:Find("btn_skin/price/Text"), var2_13)
				onButton(arg0_10, arg2_13:Find("btn_skin"), function()
					arg0_10:emit(ChargeActGiftMediator.GO_SHOP, var0_13)
				end, SFX_PANEL)
			end
		end
	end)

	local var2_10 = Drop.Create(var0_10:GetConfigClientSetting("drop"))

	updateDrop(arg0_10.rtAward:Find("icon/bg/IconTpl"), var2_10)
	onButton(arg0_10, arg0_10.rtAward:Find("icon"), function()
		arg0_10:emit(BaseUI.ON_DROP, var2_10)
	end, SFX_PANEL)

	local var3_10, var4_10, var5_10 = GiftActCommodity.CalcPrice(var0_10)

	setActive(arg0_10.rtAward:Find("word"), var3_10 > 0)
	setActive(arg0_10.btnPay, var3_10 > 0)
	setActive(arg0_10.btnGet, var3_10 == 0)

	if var3_10 > 0 then
		setActive(arg0_10.btnPay:Find("price/old"), var3_10 < var5_10)
		setText(arg0_10.btnPay:Find("price/old"), string.format("<material=strike>%d</material>", var5_10))
		setText(arg0_10.btnPay:Find("price/price"), var3_10)
		onButton(arg0_10, arg0_10.btnPay, function()
			local var0_16 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResDiamond,
				count = var3_10
			})

			if var0_16.count > var0_16:getOwnedCount() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("temple_consume_not_enough"))

				return
			end

			local var1_16 = Goods.Create({
				shop_id = var0_10:GetConfigClientSetting("packageID")
			}, Goods.TYPE_GIFT_PACKAGE_ACT)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("black5_bundle_popup", var0_16.count, var1_16:GetName()),
				onYes = function()
					arg0_10:emit(ChargeActGiftMediator.DO_PAY)
				end
			})
		end, SFX_CONFIRM)
	else
		onButton(arg0_10, arg0_10.btnGet, function()
			arg0_10:emit(ChargeActGiftMediator.DO_PAY)
		end, SFX_CONFIRM)
	end
end

function var0_0.willExit(arg0_19)
	arg0_19:UnOverlayPanel(arg0_19._tf)
end

return var0_0
