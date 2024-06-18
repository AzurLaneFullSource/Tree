local var0_0 = class("ChargeOrPurchaseHandler", pm.Mediator)

function var0_0.Ctor(arg0_1)
	var0_0.super.Ctor(arg0_1)
	pg.m02:registerMediator(arg0_1)
end

function var0_0.ChargeOrPurchaseAsyn(arg0_2, arg1_2, arg2_2)
	local var0_2

	seriesAsync({
		function(arg0_3)
			arg0_2:FetchFirstChargeIds(arg1_2, function(arg0_4)
				var0_2 = arg0_4

				arg0_3()
			end)
		end,
		function(arg0_5)
			arg0_2:ChargeOrPurchase(var0_2, arg1_2)
			arg0_5()
		end
	}, arg2_2)
end

function var0_0.FetchFirstChargeIds(arg0_6, arg1_6, arg2_6)
	if not arg1_6:isChargeType() then
		arg2_6()

		return
	end

	local var0_6 = getProxy(ShopsProxy)

	local function var1_6()
		local var0_7 = var0_6:getFirstChargeList()

		arg2_6(var0_7)
	end

	if var0_6:ShouldRefreshChargeList() then
		pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
			callback = var1_6
		})
	else
		var1_6()
	end
end

function var0_0.ChargeOrPurchase(arg0_8, arg1_8, arg2_8)
	if arg2_8:isChargeType() then
		if arg2_8:isMonthCard() or arg2_8:isGiftBox() or arg2_8:isItemBox() or arg2_8:isPassItem() then
			return arg0_8:ChargeMonthCardAndGiftPack(arg1_8, arg2_8)
		elseif arg2_8:isGem() then
			return arg0_8:ChargeGem(arg1_8, arg2_8)
		end
	else
		arg0_8:PurchaseItem(arg2_8)
	end
end

function var0_0.PurchaseItem(arg0_9, arg1_9)
	local var0_9 = arg1_9:getDropInfo()

	assert(var0_9.type == DROP_TYPE_ITEM)

	local var1_9 = Item.getConfigData(var0_9.id)
	local var2_9 = {
		isMonthCard = false,
		isChargeType = false,
		isLocalPrice = false,
		icon = var1_9.icon,
		name = var1_9.name,
		tipExtra = i18n("charge_title_getitem"),
		extraItems = arg1_9:GetDropList(),
		price = arg1_9:getConfig("resource_num"),
		tagType = arg1_9:getConfig("tag"),
		onYes = function()
			arg0_9:Purchase(var1_9.name, arg1_9)
		end
	}

	arg0_9:ShowMsgBox(var2_9)
end

function var0_0.ChargeMonthCardAndGiftPack(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg2_11:GetExtraServiceItem()
	local var1_11 = arg2_11:GetExtraDrop()
	local var2_11 = arg2_11:GetGemCnt()
	local var3_11 = arg2_11:GetBonusItem()
	local var4_11, var5_11 = arg2_11:GetChargeTip()
	local var6_11 = "chargeicon/" .. arg2_11:getConfig("picture")
	local var7_11 = arg2_11:getConfig("name_display")
	local var8_11 = arg2_11:getConfig("money")
	local var9_11 = arg2_11:IsLocalPrice()
	local var10_11 = arg2_11:isMonthCard()
	local var11_11 = arg2_11:getConfig("descrip_extra")
	local var12_11 = not table.contains(arg1_11, arg2_11.id) and arg2_11:firstPayDouble() and 4 or arg2_11:getConfig("tag")
	local var13_11 = {
		isChargeType = true,
		icon = var6_11,
		name = var7_11,
		tipExtra = var4_11,
		extraItems = var0_11,
		price = var8_11,
		isLocalPrice = var9_11,
		tagType = var12_11,
		isMonthCard = var10_11,
		tipBonus = var5_11,
		bonusItem = var3_11,
		extraDrop = var1_11,
		descExtra = var11_11,
		onYes = function()
			arg0_11:Charge(arg2_11)
		end
	}

	arg0_11:ShowMsgBox(var13_11)
end

function var0_0.ChargeGem(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg2_13:getConfig("money")
	local var1_13 = arg2_13:getConfig("gem")
	local var2_13 = not table.contains(arg1_13, arg2_13.id) and arg2_13:firstPayDouble()
	local var3_13 = var2_13 and 4 or arg2_13:getConfig("tag")

	if var2_13 then
		var1_13 = var1_13 + arg2_13:getConfig("gem")
	else
		var1_13 = var1_13 + arg2_13:getConfig("extra_gem")
	end

	local var4_13 = "chargeicon/" .. arg2_13:getConfig("picture")
	local var5_13 = arg2_13:getConfig("name_display")
	local var6_13 = arg2_13:getConfig("money")
	local var7_13 = arg2_13:IsLocalPrice()
	local var8_13 = i18n("charge_start_tip", var0_13, var1_13)
	local var9_13 = {
		isChargeType = true,
		icon = var4_13,
		name = var5_13,
		price = var6_13,
		isLocalPrice = var7_13,
		tagType = var3_13,
		normalTip = var8_13,
		onYes = function()
			arg0_13:Charge(arg2_13)
		end
	}

	arg0_13:ShowMsgBox(var9_13)
end

function var0_0.ShowMsgBox(arg0_15, arg1_15)
	arg0_15:addSubLayers(Context.New({
		mediator = ChargeItemPanelMediator,
		viewComponent = ChargeItemPanelLayer,
		data = {
			panelConfig = arg1_15
		}
	}))
end

function var0_0.Purchase(arg0_16, arg1_16, arg2_16)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("charge_scene_buy_confirm", arg2_16:getConfig("resource_num"), arg1_16),
		onYes = function()
			pg.m02:sendNotification(GAME.SHOPPING, {
				count = 1,
				id = arg2_16.id
			})
		end
	})
end

function var0_0.Charge(arg0_18, arg1_18)
	if ChargeConst.isNeedSetBirth() then
		arg0_18:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	else
		pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg1_18.id
		})
	end
end

function var0_0.addSubLayers(arg0_19, arg1_19, arg2_19, arg3_19)
	assert(isa(arg1_19, Context), "should be an instance of Context")

	local var0_19 = getProxy(ContextProxy):getCurrentContext()

	if arg2_19 then
		while var0_19.parent do
			var0_19 = var0_19.parent
		end
	end

	arg0_19:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0_19,
		context = arg1_19,
		callback = arg3_19
	})
end

function var0_0.Dispose(arg0_20)
	pg.m02:removeMediator(arg0_20.__cname)
end

return var0_0
