local var0 = class("ChargeOrPurchaseHandler", pm.Mediator)

function var0.Ctor(arg0)
	var0.super.Ctor(arg0)
	pg.m02:registerMediator(arg0)
end

function var0.ChargeOrPurchaseAsyn(arg0, arg1, arg2)
	local var0

	seriesAsync({
		function(arg0)
			arg0:FetchFirstChargeIds(arg1, function(arg0)
				var0 = arg0

				arg0()
			end)
		end,
		function(arg0)
			arg0:ChargeOrPurchase(var0, arg1)
			arg0()
		end
	}, arg2)
end

function var0.FetchFirstChargeIds(arg0, arg1, arg2)
	if not arg1:isChargeType() then
		arg2()

		return
	end

	local var0 = getProxy(ShopsProxy)

	local function var1()
		local var0 = var0:getFirstChargeList()

		arg2(var0)
	end

	if var0:ShouldRefreshChargeList() then
		pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
			callback = var1
		})
	else
		var1()
	end
end

function var0.ChargeOrPurchase(arg0, arg1, arg2)
	if arg2:isChargeType() then
		if arg2:isMonthCard() or arg2:isGiftBox() or arg2:isItemBox() or arg2:isPassItem() then
			return arg0:ChargeMonthCardAndGiftPack(arg1, arg2)
		elseif arg2:isGem() then
			return arg0:ChargeGem(arg1, arg2)
		end
	else
		arg0:PurchaseItem(arg2)
	end
end

function var0.PurchaseItem(arg0, arg1)
	local var0 = arg1:getDropInfo()

	assert(var0.type == DROP_TYPE_ITEM)

	local var1 = Item.getConfigData(var0.id)
	local var2 = {
		isMonthCard = false,
		isChargeType = false,
		isLocalPrice = false,
		icon = var1.icon,
		name = var1.name,
		tipExtra = i18n("charge_title_getitem"),
		extraItems = arg1:GetDropList(),
		price = arg1:getConfig("resource_num"),
		tagType = arg1:getConfig("tag"),
		onYes = function()
			arg0:Purchase(var1.name, arg1)
		end
	}

	arg0:ShowMsgBox(var2)
end

function var0.ChargeMonthCardAndGiftPack(arg0, arg1, arg2)
	local var0 = arg2:GetExtraServiceItem()
	local var1 = arg2:GetExtraDrop()
	local var2 = arg2:GetGemCnt()
	local var3 = arg2:GetBonusItem()
	local var4, var5 = arg2:GetChargeTip()
	local var6 = "chargeicon/" .. arg2:getConfig("picture")
	local var7 = arg2:getConfig("name_display")
	local var8 = arg2:getConfig("money")
	local var9 = arg2:IsLocalPrice()
	local var10 = arg2:isMonthCard()
	local var11 = arg2:getConfig("descrip_extra")
	local var12 = not table.contains(arg1, arg2.id) and arg2:firstPayDouble() and 4 or arg2:getConfig("tag")
	local var13 = {
		isChargeType = true,
		icon = var6,
		name = var7,
		tipExtra = var4,
		extraItems = var0,
		price = var8,
		isLocalPrice = var9,
		tagType = var12,
		isMonthCard = var10,
		tipBonus = var5,
		bonusItem = var3,
		extraDrop = var1,
		descExtra = var11,
		onYes = function()
			arg0:Charge(arg2)
		end
	}

	arg0:ShowMsgBox(var13)
end

function var0.ChargeGem(arg0, arg1, arg2)
	local var0 = arg2:getConfig("money")
	local var1 = arg2:getConfig("gem")
	local var2 = not table.contains(arg1, arg2.id) and arg2:firstPayDouble()
	local var3 = var2 and 4 or arg2:getConfig("tag")

	if var2 then
		var1 = var1 + arg2:getConfig("gem")
	else
		var1 = var1 + arg2:getConfig("extra_gem")
	end

	local var4 = "chargeicon/" .. arg2:getConfig("picture")
	local var5 = arg2:getConfig("name_display")
	local var6 = arg2:getConfig("money")
	local var7 = arg2:IsLocalPrice()
	local var8 = i18n("charge_start_tip", var0, var1)
	local var9 = {
		isChargeType = true,
		icon = var4,
		name = var5,
		price = var6,
		isLocalPrice = var7,
		tagType = var3,
		normalTip = var8,
		onYes = function()
			arg0:Charge(arg2)
		end
	}

	arg0:ShowMsgBox(var9)
end

function var0.ShowMsgBox(arg0, arg1)
	arg0:addSubLayers(Context.New({
		mediator = ChargeItemPanelMediator,
		viewComponent = ChargeItemPanelLayer,
		data = {
			panelConfig = arg1
		}
	}))
end

function var0.Purchase(arg0, arg1, arg2)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("charge_scene_buy_confirm", arg2:getConfig("resource_num"), arg1),
		onYes = function()
			pg.m02:sendNotification(GAME.SHOPPING, {
				count = 1,
				id = arg2.id
			})
		end
	})
end

function var0.Charge(arg0, arg1)
	if ChargeConst.isNeedSetBirth() then
		arg0:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	else
		pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg1.id
		})
	end
end

function var0.addSubLayers(arg0, arg1, arg2, arg3)
	assert(isa(arg1, Context), "should be an instance of Context")

	local var0 = getProxy(ContextProxy):getCurrentContext()

	if arg2 then
		while var0.parent do
			var0 = var0.parent
		end
	end

	arg0:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0,
		context = arg1,
		callback = arg3
	})
end

function var0.Dispose(arg0)
	pg.m02:removeMediator(arg0.__cname)
end

return var0
