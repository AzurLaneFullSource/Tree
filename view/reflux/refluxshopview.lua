local var0_0 = class("RefluxShopView", import("..base.BaseSubView"))

var0_0.GiftPackType = {
	Gold = 3,
	Money = 1,
	Diamond = 2
}
var0_0.GiftPackTypeName = {
	"pack_type_1",
	"pack_type_2",
	"pack_type_3"
}
var0_0.Special_ID_Gold = 1
var0_0.Special_ID_Gem = 14

function var0_0.getUIName(arg0_1)
	return "RefluxShopUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:updateUI()
	var0_0.SaveEnterTag()
end

function var0_0.OnDestroy(arg0_3)
	for iter0_3, iter1_3 in pairs(var0_0.GiftPackType) do
		local var0_3 = arg0_3.packTimerList[iter1_3]

		if var0_3 then
			var0_3:Stop()

			arg0_3.packTimerList[iter1_3] = nil
		end

		local var1_3 = arg0_3.packNextTimerList[iter1_3]

		if var1_3 then
			var1_3:Stop()

			arg0_3.packNextTimerList[iter1_3] = nil
		end
	end
end

function var0_0.OnBackPress(arg0_4)
	arg0_4:Hide()
end

function var0_0.initData(arg0_5)
	arg0_5.refluxProxy = getProxy(RefluxProxy)
	arg0_5.shopProxy = getProxy(ShopsProxy)
end

function var0_0.initUI(arg0_6)
	local var0_6 = arg0_6:findTF("BG/MoneyTip")

	setActive(var0_6, false)

	arg0_6.itemTpl = arg0_6:findTF("ItemTpl")
	arg0_6.packTpl = arg0_6:findTF("PackTpl")
	arg0_6.packContainerTF = arg0_6:findTF("Container")
	arg0_6.packItemList = UIItemList.New(arg0_6.packContainerTF, arg0_6.packTpl)

	arg0_6.packItemList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg1_7 = arg1_7 + 1

			local var0_7 = arg0_6.goodVOList[arg1_7]

			arg0_6:updatePack(arg2_7, var0_7, arg1_7)
		end
	end)

	arg0_6.packTimerList = {}
	arg0_6.packNextTimerList = {}

	local var1_6 = GetComponent(arg0_6._tf, "ItemList").prefabItem[0]
	local var2_6 = tf(Instantiate(var1_6))

	setActive(arg0_6:findTF("icon_bg/count", var2_6), true)
	setParent(var2_6, arg0_6.itemTpl)
	setLocalScale(var2_6, {
		x = 0.45,
		y = 0.45
	})
end

function var0_0.updateData(arg0_8)
	local var0_8 = arg0_8:getCurDayGiftPackIDList()
	local var1_8 = false

	if var0_8[1] then
		var1_8 = Goods.Create({
			shop_id = var0_8[1]
		}, Goods.TYPE_CHARGE)
	end

	local var2_8 = Goods.Create({
		shop_id = var0_8[2]
	}, Goods.TYPE_GIFT_PACKAGE)
	local var3_8 = Goods.Create({
		shop_id = var0_8[3]
	}, Goods.TYPE_GIFT_PACKAGE)

	arg0_8.goodVOList = {
		var1_8,
		var2_8,
		var3_8
	}
end

function var0_0.updateUI(arg0_9)
	arg0_9:updateData()
	arg0_9:updatePackList()
end

function var0_0.updateOutline(arg0_10)
	local var0_10 = arg0_10.packContainerTF.childCount

	for iter0_10 = 1, var0_10 do
		local var1_10 = iter0_10 - 1
		local var2_10 = arg0_10.packContainerTF:GetChild(var1_10)
		local var3_10 = arg0_10:findTF("TimeLimit/Text", var2_10):GetComponent(typeof(Text))

		var3_10.material = Object.Instantiate(var3_10.material)

		local var4_10 = arg0_10:findTF("Price/Text", var2_10):GetComponent(typeof(Text))

		var4_10.material = Object.Instantiate(var4_10.material)

		local var5_10 = arg0_10:findTF("Mask/Text", var2_10):GetComponent(typeof(Text))

		var5_10.material = Object.Instantiate(var5_10.material)
	end
end

function var0_0.updateItem(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11:findTF("Frame", arg1_11)
	local var1_11 = arg0_11:findTF("Icon", arg1_11)
	local var2_11 = arg0_11:findTF("Count", arg1_11)
	local var3_11 = arg2_11.type or arg2_11[1]
	local var4_11 = arg2_11.id or arg2_11[2]
	local var5_11 = arg2_11.count or arg2_11[3]

	setText(var2_11, var5_11)

	if var3_11 ~= DROP_TYPE_SHIP then
		setImageSprite(var1_11, LoadSprite(Drop.New({
			type = var3_11,
			id = var4_11
		}):getIcon()))
	else
		local var6_11 = Ship.New({
			configId = var4_11
		}):getPainting()

		setImageSprite(var1_11, LoadSprite("QIcon/" .. var6_11))
	end

	setActive(var0_11, false)
	setActive(var1_11, false)
	setActive(var2_11, false)

	local var7_11 = arg0_11:findTF("CommonItemTemplate(Clone)", arg1_11)

	setActive(var7_11, true)
	updateDrop(var7_11, {
		type = var3_11,
		id = var4_11,
		count = var5_11
	})
end

function var0_0.updatePack(arg0_12, arg1_12, arg2_12, arg3_12)
	if arg2_12 == false then
		setActive(arg1_12, false)

		return
	elseif arg3_12 == var0_0.GiftPackType.Money and arg0_12:isBuyEver(arg2_12.id) then
		setActive(arg1_12, false)

		return
	else
		setActive(arg1_12, true)
	end

	local var0_12
	local var1_12

	if arg3_12 == var0_0.GiftPackType.Money then
		-- block empty
	else
		local var2_12 = arg2_12:getConfig("effect_args")

		var1_12 = Item.getConfigData(var2_12[1])
	end

	local var3_12 = arg0_12:findTF("PackIcon", arg1_12)
	local var4_12

	if arg3_12 == var0_0.GiftPackType.Money then
		var4_12 = "chargeicon/" .. arg2_12:getConfig("picture")
	else
		var4_12 = var1_12.icon
	end

	setImageSprite(var3_12, LoadSprite(var4_12), true)

	local var5_12 = arg0_12:findTF("PackName", arg1_12)

	if arg3_12 == var0_0.GiftPackType.Money then
		setText(var5_12, arg2_12:getConfig("name_display"))
	else
		setText(var5_12, var1_12.name)
	end

	local var6_12 = arg0_12:findTF("ItemList", arg1_12)
	local var7_12

	if arg3_12 == var0_0.GiftPackType.Money then
		var7_12 = arg2_12:getConfig("display")
	else
		var7_12 = var1_12.display_icon
	end

	local var8_12 = UIItemList.New(var6_12, arg0_12.itemTpl)

	var8_12:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			arg1_13 = arg1_13 + 1

			local var0_13 = var7_12[arg1_13]

			arg0_12:updateItem(arg2_13, var0_13)
		end
	end)
	var8_12:align(#var7_12)

	local var9_12 = arg0_12:findTF("DescFrame/Text", arg1_12)

	if arg3_12 == var0_0.GiftPackType.Money then
		setText(var9_12, arg2_12:getConfig("descrip"))
	else
		setText(var9_12, var1_12.display)
	end

	local var10_12 = arg0_12:findTF("TimeLimit", arg1_12)
	local var11_12 = arg0_12:findTF("Text", var10_12)
	local var12_12 = arg3_12 ~= var0_0.GiftPackType.Money and arg0_12:isHaveNextPack(var0_0.GiftPackTypeName[arg3_12])

	var12_12 = var12_12 and not arg0_12:isBuyEver(arg2_12.id)

	if var12_12 then
		setActive(var10_12, true)
		arg0_12:updatePackTimeLimit(var11_12, arg3_12)
	else
		setActive(var10_12, false)
	end

	local var13_12 = arg0_12:findTF("MoneyTag", arg1_12)

	setActive(var13_12, arg3_12 == var0_0.GiftPackType.Money)

	local var14_12 = arg0_12:findTF("Price/IconMoney", arg1_12)
	local var15_12 = arg0_12:findTF("Price/Icon", arg1_12)
	local var16_12 = arg0_12:findTF("Price/Icon/Res", arg1_12)
	local var17_12 = arg0_12:findTF("Price/Text", arg1_12)

	if arg3_12 == var0_0.GiftPackType.Money then
		setActive(var14_12, true)
		setActive(var15_12, false)
		setText(var17_12, arg2_12:getConfig("money"))
	else
		setActive(var14_12, false)
		setActive(var15_12, true)
		setText(var17_12, arg2_12:getConfig("resource_num"))

		local var18_12 = arg2_12:getConfig("resource_type")
		local var19_12

		if var18_12 == var0_0.Special_ID_Gem then
			var19_12 = "props/gem"
		elseif var18_12 == var0_0.Special_ID_Gold then
			var19_12 = "props/gold"
		end

		setImageSprite(var16_12, LoadSprite(var19_12), true)
	end

	local var20_12 = arg0_12:findTF("Mask", arg1_12)
	local var21_12 = arg0_12:isBuyEver(arg2_12.id)

	setActive(var20_12, var21_12)

	if var21_12 then
		local var22_12 = arg0_12:findTF("NextTime", var20_12)
		local var23_12 = arg0_12:findTF("Text", var20_12)
		local var24_12 = arg0_12:findTF("Sellout", var20_12)

		if arg0_12:isHaveNextPack(var0_0.GiftPackTypeName[arg3_12]) then
			setActive(var22_12, true)
			setActive(var23_12, true)
			setActive(var24_12, false)
			arg0_12:updatePackNextTime(var23_12, arg3_12)
		else
			setActive(var22_12, false)
			setActive(var23_12, false)
			setActive(var24_12, true)
		end
	end

	onButton(arg0_12, arg1_12, function()
		if not isActive(var20_12) then
			arg0_12:confirm(arg2_12)
		end
	end, SFX_PANEL)
end

function var0_0.updatePackTimeLimit(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15:getCurDay()
	local var1_15 = var0_0.GiftPackTypeName[arg2_15]
	local var2_15 = arg0_15:calcNextGiftPackSecByType(var1_15, var0_15)
	local var3_15 = arg0_15.packTimerList[arg2_15]

	if var3_15 then
		var3_15:Stop()

		arg0_15.packTimerList[arg2_15] = nil
	end

	local function var4_15()
		if var2_15 >= 0 then
			local var0_16 = pg.TimeMgr.GetInstance():DescCDTime(var2_15)

			setText(arg1_15, var0_16)

			var2_15 = var2_15 - 1
		else
			var3_15:Stop()

			arg0_15.packTimerList[arg2_15] = nil
		end
	end

	var3_15 = Timer.New(var4_15, 1, -1)

	var3_15:Start()

	arg0_15.packTimerList[arg2_15] = var3_15

	var4_15()
end

function var0_0.updatePackNextTime(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17:getCurDay()
	local var1_17 = var0_0.GiftPackTypeName[arg2_17]
	local var2_17 = arg0_17:calcNextGiftPackSecByType(var1_17, var0_17)
	local var3_17 = arg0_17.packNextTimerList[arg2_17]

	if var3_17 then
		var3_17:Stop()

		arg0_17.packNextTimerList[arg2_17] = nil
	end

	local function var4_17()
		if var2_17 >= 0 then
			local var0_18 = pg.TimeMgr.GetInstance():DescCDTime(var2_17)

			setText(arg1_17, var0_18)

			var2_17 = var2_17 - 1
		else
			var3_17:Stop()

			arg0_17.packNextTimerList[arg2_17] = nil
		end
	end

	var3_17 = Timer.New(var4_17, 1, -1)

	var3_17:Start()

	arg0_17.packNextTimerList[arg2_17] = var3_17

	var4_17()
end

function var0_0.updatePackList(arg0_19)
	arg0_19.packItemList:align(#arg0_19.goodVOList)
end

function var0_0.isShowRedPot()
	if PlayerPrefs.GetInt("RefluxShop_Enter_Day", 0) < getProxy(RefluxProxy).signCount then
		return true
	else
		return false
	end
end

function var0_0.SaveEnterTag()
	local var0_21 = getProxy(RefluxProxy).signCount

	PlayerPrefs.SetInt("RefluxShop_Enter_Day", var0_21)
end

function var0_0.getCurDay(arg0_22)
	local var0_22 = arg0_22.refluxProxy.returnTimestamp
	local var1_22 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2_22 = pg.TimeMgr.GetInstance():DiffDay(var0_22, var1_22)
	local var3_22 = #pg.return_giftpack_template.all

	if var2_22 < var3_22 then
		return var2_22 + 1
	else
		return var3_22
	end
end

function var0_0.getLevelIndex(arg0_23, arg1_23)
	local var0_23 = arg1_23 or arg0_23:getCurDay()
	local var1_23 = pg.return_giftpack_template[var0_23].level
	local var2_23 = arg0_23.refluxProxy.returnLV
	local var3_23

	for iter0_23, iter1_23 in ipairs(var1_23) do
		local var4_23 = iter1_23[1]
		local var5_23 = iter1_23[2]

		if var4_23 <= var2_23 and var2_23 <= var5_23 then
			return iter0_23
		end
	end
end

function var0_0.getCurDayGiftPackIDByType(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg2_24 or arg0_24:getCurDay()

	if var0_24 > #pg.return_giftpack_template.all then
		return false
	end

	local var1_24 = pg.return_giftpack_template[var0_24][arg1_24]
	local var2_24 = var0_24

	while var1_24 == "" and var2_24 > 1 do
		var2_24 = var2_24 - 1
		var1_24 = pg.return_giftpack_template[var2_24][arg1_24]
	end

	if var1_24 == "" then
		return false
	else
		return var1_24[arg0_24:getLevelIndex(var2_24)]
	end
end

function var0_0.getCurDayGiftPackIDList(arg0_25)
	local var0_25 = arg0_25:getCurDay()

	return {
		[var0_0.GiftPackType.Money] = arg0_25:getCurDayGiftPackIDByType("pack_type_1", var0_25),
		[var0_0.GiftPackType.Diamond] = arg0_25:getCurDayGiftPackIDByType("pack_type_2", var0_25),
		[var0_0.GiftPackType.Gold] = arg0_25:getCurDayGiftPackIDByType("pack_type_3", var0_25)
	}
end

function var0_0.getNextGiftPackDayByType(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg2_26 or arg0_26:getCurDay()

	if var0_26 >= #pg.return_giftpack_template.all then
		return false
	end

	local var1_26 = var0_26 + 1
	local var2_26 = pg.return_giftpack_template[var1_26][arg1_26]
	local var3_26 = var1_26

	while var2_26 == "" and var3_26 > 1 and var3_26 <= #pg.return_giftpack_template.all do
		var2_26 = pg.return_giftpack_template[var3_26][arg1_26]
		var3_26 = var3_26 + 1
	end

	if var2_26 == "" then
		return false
	else
		return var3_26
	end
end

function var0_0.isHaveNextPack(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg2_27 or arg0_27:getCurDay()

	return arg0_27:getNextGiftPackDayByType(arg1_27, var0_27) ~= false
end

function var0_0.calcNextGiftPackSecByType(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg2_28 or arg0_28:getCurDay()
	local var1_28 = arg0_28:getNextGiftPackDayByType(arg1_28, var0_28)
	local var2_28 = 86400

	return arg0_28.refluxProxy.returnTimestamp + (var1_28 - 1) * var2_28 - pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.isBuyEver(arg0_29, arg1_29)
	local var0_29 = getProxy(ShopsProxy)
	local var1_29 = var0_29:getChargedList()
	local var2_29 = var0_29:GetNormalList()

	return 0 + ChargeConst.getBuyCount(var1_29, arg1_29) + ChargeConst.getBuyCount(var2_29, arg1_29) > 0
end

function var0_0.confirm(arg0_30, arg1_30)
	if not arg1_30 then
		return
	end

	arg1_30 = Clone(arg1_30)

	if arg1_30:isChargeType() then
		local var0_30 = not table.contains(arg0_30.firstChargeIds, arg1_30.id) and arg1_30:firstPayDouble()
		local var1_30 = var0_30 and 4 or arg1_30:getConfig("tag")

		if arg1_30:isMonthCard() or arg1_30:isGiftBox() or arg1_30:isItemBox() or arg1_30:isPassItem() then
			local var2_30 = arg1_30:GetExtraServiceItem()
			local var3_30 = arg1_30:GetExtraDrop()
			local var4_30 = arg1_30:GetBonusItem()
			local var5_30
			local var6_30

			if arg1_30:isPassItem() then
				var5_30 = i18n("battlepass_pay_tip")
			elseif arg1_30:isMonthCard() then
				var5_30 = i18n("charge_title_getitem_month")
				var6_30 = i18n("charge_title_getitem_soon")
			else
				var5_30 = i18n("charge_title_getitem")
			end

			local var7_30 = {
				isChargeType = true,
				icon = "chargeicon/" .. arg1_30:getConfig("picture"),
				name = arg1_30:getConfig("name_display"),
				tipExtra = var5_30,
				extraItems = var2_30,
				price = arg1_30:getConfig("money"),
				isLocalPrice = arg1_30:IsLocalPrice(),
				tagType = var1_30,
				isMonthCard = arg1_30:isMonthCard(),
				tipBonus = var6_30,
				bonusItem = var4_30,
				extraDrop = var3_30,
				descExtra = arg1_30:getConfig("descrip_extra"),
				limitArgs = arg1_30:getConfig("limit_args"),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0_30:emit(RefluxMediator.OPEN_CHARGE_BIRTHDAY)
					else
						pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
							shopId = arg1_30.id
						})
					end
				end
			}

			arg0_30:emit(RefluxMediator.OPEN_CHARGE_ITEM_PANEL, var7_30)
		elseif arg1_30:isGem() then
			local var8_30 = arg1_30:getConfig("money")
			local var9_30 = arg1_30:getConfig("gem")

			if var0_30 then
				var9_30 = var9_30 + arg1_30:getConfig("gem")
			else
				var9_30 = var9_30 + arg1_30:getConfig("extra_gem")
			end

			local var10_30 = {
				isChargeType = true,
				icon = "chargeicon/" .. arg1_30:getConfig("picture"),
				name = arg1_30:getConfig("name_display"),
				price = arg1_30:getConfig("money"),
				isLocalPrice = arg1_30:IsLocalPrice(),
				tagType = var1_30,
				normalTip = i18n("charge_start_tip", var8_30, var9_30),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0_30:emit(RefluxMediator.OPEN_CHARGE_BIRTHDAY)
					else
						pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
							shopId = arg1_30.id
						})
					end
				end
			}

			arg0_30:emit(RefluxMediator.OPEN_CHARGE_ITEM_BOX, var10_30)
		end
	else
		local var11_30 = {}
		local var12_30 = arg1_30:getConfig("effect_args")
		local var13_30 = Item.getConfigData(var12_30[1])
		local var14_30 = var13_30.display_icon

		if type(var14_30) == "table" then
			for iter0_30, iter1_30 in ipairs(var14_30) do
				table.insert(var11_30, Drop.Create(iter1_30))
			end
		end

		local var15_30 = arg1_30:getConfig("resource_type") == var0_0.Special_ID_Gold
		local var16_30

		if var15_30 then
			var16_30 = i18n("charge_scene_buy_confirm_gold", arg1_30:getConfig("resource_num"), var13_30.name)
		else
			var16_30 = i18n("charge_scene_buy_confirm", arg1_30:getConfig("resource_num"), var13_30.name)
		end

		local var17_30 = {
			isMonthCard = false,
			isChargeType = false,
			isLocalPrice = false,
			icon = var13_30.icon,
			name = var13_30.name,
			tipExtra = i18n("charge_title_getitem"),
			extraItems = var11_30,
			price = arg1_30:getConfig("resource_num"),
			tagType = arg1_30:getConfig("tag"),
			isForceGold = var15_30,
			onYes = function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = var16_30,
					onYes = function()
						pg.m02:sendNotification(GAME.SHOPPING, {
							count = 1,
							id = arg1_30.id
						})
					end
				})
			end
		}

		arg0_30:emit(RefluxMediator.OPEN_CHARGE_ITEM_PANEL, var17_30)
	end
end

function var0_0.getAllRefluxPackID()
	local var0_35 = {}

	for iter0_35, iter1_35 in ipairs(pg.return_giftpack_template.all) do
		local var1_35 = pg.return_giftpack_template[iter1_35]
		local var2_35 = var1_35.pack_type_1
		local var3_35 = var1_35.pack_type_2
		local var4_35 = var1_35.pack_type_3

		if type(var2_35) == "table" then
			for iter2_35, iter3_35 in pairs(var2_35) do
				table.insert(var0_35, iter3_35)
			end
		end

		if type(var3_35) == "table" then
			for iter4_35, iter5_35 in pairs(var3_35) do
				table.insert(var0_35, iter5_35)
			end
		end

		if type(var4_35) == "table" then
			for iter6_35, iter7_35 in pairs(var4_35) do
				table.insert(var0_35, iter7_35)
			end
		end
	end

	return var0_35
end

return var0_0
