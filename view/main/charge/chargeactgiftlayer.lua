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

function var0_0.init(arg0_7)
	setText(arg0_7.rtTip:Find("Text"), i18n("black5_bundle_desc"))
	setText(arg0_7.rtAward:Find("word/Text"), i18n("black5_bundle_tip"))
	setText(arg0_7.btnPay:Find("Text"), i18n("black5_bundle_buy_all"))
	setText(arg0_7.btnGet:Find("Text"), i18n("black5_bundle_receive"))
	arg0_7:BlurPanel(arg0_7._tf)
end

function var0_0.didEnter(arg0_8)
	onButton(arg0_8, arg0_8.rtBg, function()
		arg0_8:closeView()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.rtTip, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("black5_bundle_help")
		})
	end, SFX_PANEL)

	local var0_8 = getProxy(ActivityProxy):getActivityById(arg0_8.contextData.actId)
	local var1_8 = var0_8:getConfig("config_data")[1]

	UIItemList.StaticAlign(arg0_8.rtContainer, arg0_8.rtSkinTpl, #var1_8, function(arg0_11, arg1_11, arg2_11)
		arg1_11 = arg1_11 + 1

		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = var1_8[arg1_11]

			setImageSprite(arg2_11:Find("name"), arg0_8.spriteDic.name[var0_11])
			setImageSprite(arg2_11, arg0_8.spriteDic.icon[var0_11])

			local var1_11 = getProxy(ShipSkinProxy):hasNonLimitSkin(var0_11)

			setActive(arg2_11:Find("btn_skin"), not var1_11)
			setActive(arg2_11:Find("got"), var1_11)

			if var1_11 then
				setText(arg2_11:Find("got/Text"), i18n("black5_bundle_purchased"))
			else
				local var2_11 = Goods.Create({
					id = pg.ship_skin_template[var0_11].shop_id
				}, Goods.TYPE_SKIN):getConfig("resource_num")

				setText(arg2_11:Find("btn_skin/price/Text"), var2_11)
				onButton(arg0_8, arg2_11:Find("btn_skin"), function()
					arg0_8:emit(ChargeActGiftMediator.GO_SHOP, var0_11)
				end, SFX_PANEL)
			end
		end
	end)

	local var2_8 = Drop.Create(var0_8:GetConfigClientSetting("drop"))

	updateDrop(arg0_8.rtAward:Find("icon/bg/IconTpl"), var2_8)
	onButton(arg0_8, arg0_8.rtAward:Find("icon"), function()
		arg0_8:emit(BaseUI.ON_DROP, var2_8)
	end, SFX_PANEL)

	local var3_8, var4_8, var5_8 = GiftActCommodity.CalcPrice(var0_8)

	setActive(arg0_8.rtAward:Find("word"), var3_8 > 0)
	setActive(arg0_8.btnPay, var3_8 > 0)
	setActive(arg0_8.btnGet, var3_8 == 0)

	if var3_8 > 0 then
		setActive(arg0_8.btnPay:Find("price/old"), var3_8 < var5_8)
		setText(arg0_8.btnPay:Find("price/old"), string.format("<material=strike>%d</material>", var5_8))
		setText(arg0_8.btnPay:Find("price/price"), var3_8)
		onButton(arg0_8, arg0_8.btnPay, function()
			local var0_14 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResDiamond,
				count = var3_8
			})

			if var0_14.count > var0_14:getOwnedCount() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("temple_consume_not_enough"))

				return
			end

			local var1_14 = Goods.Create({
				shop_id = var0_8:GetConfigClientSetting("packageID")
			}, Goods.TYPE_GIFT_PACKAGE_ACT)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("black5_bundle_popup", var0_14.count, var1_14:GetName()),
				onYes = function()
					arg0_8:emit(ChargeActGiftMediator.DO_PAY)
				end
			})
		end, SFX_CONFIRM)
	else
		onButton(arg0_8, arg0_8.btnGet, function()
			arg0_8:emit(ChargeActGiftMediator.DO_PAY)
		end, SFX_CONFIRM)
	end
end

function var0_0.willExit(arg0_17)
	arg0_17:UnOverlayPanel(arg0_17._tf)
end

return var0_0
