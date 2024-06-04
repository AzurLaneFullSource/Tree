local var0 = class("RefluxShopView", import("..base.BaseSubView"))

var0.GiftPackType = {
	Gold = 3,
	Money = 1,
	Diamond = 2
}
var0.GiftPackTypeName = {
	"pack_type_1",
	"pack_type_2",
	"pack_type_3"
}
var0.Special_ID_Gold = 1
var0.Special_ID_Gem = 14

function var0.getUIName(arg0)
	return "RefluxShopUI"
end

function var0.OnInit(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:updateUI()
	var0.SaveEnterTag()
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in pairs(var0.GiftPackType) do
		local var0 = arg0.packTimerList[iter1]

		if var0 then
			var0:Stop()

			arg0.packTimerList[iter1] = nil
		end

		local var1 = arg0.packNextTimerList[iter1]

		if var1 then
			var1:Stop()

			arg0.packNextTimerList[iter1] = nil
		end
	end
end

function var0.OnBackPress(arg0)
	arg0:Hide()
end

function var0.initData(arg0)
	arg0.refluxProxy = getProxy(RefluxProxy)
	arg0.shopProxy = getProxy(ShopsProxy)
end

function var0.initUI(arg0)
	local var0 = arg0:findTF("BG/MoneyTip")

	setActive(var0, false)

	arg0.itemTpl = arg0:findTF("ItemTpl")
	arg0.packTpl = arg0:findTF("PackTpl")
	arg0.packContainerTF = arg0:findTF("Container")
	arg0.packItemList = UIItemList.New(arg0.packContainerTF, arg0.packTpl)

	arg0.packItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			local var0 = arg0.goodVOList[arg1]

			arg0:updatePack(arg2, var0, arg1)
		end
	end)

	arg0.packTimerList = {}
	arg0.packNextTimerList = {}

	local var1 = GetComponent(arg0._tf, "ItemList").prefabItem[0]
	local var2 = tf(Instantiate(var1))

	setActive(arg0:findTF("icon_bg/count", var2), true)
	setParent(var2, arg0.itemTpl)
	setLocalScale(var2, {
		x = 0.45,
		y = 0.45
	})
end

function var0.updateData(arg0)
	local var0 = arg0:getCurDayGiftPackIDList()
	local var1 = false

	if var0[1] then
		var1 = Goods.Create({
			shop_id = var0[1]
		}, Goods.TYPE_CHARGE)
	end

	local var2 = Goods.Create({
		shop_id = var0[2]
	}, Goods.TYPE_GIFT_PACKAGE)
	local var3 = Goods.Create({
		shop_id = var0[3]
	}, Goods.TYPE_GIFT_PACKAGE)

	arg0.goodVOList = {
		var1,
		var2,
		var3
	}
end

function var0.updateUI(arg0)
	arg0:updateData()
	arg0:updatePackList()
end

function var0.updateOutline(arg0)
	local var0 = arg0.packContainerTF.childCount

	for iter0 = 1, var0 do
		local var1 = iter0 - 1
		local var2 = arg0.packContainerTF:GetChild(var1)
		local var3 = arg0:findTF("TimeLimit/Text", var2):GetComponent(typeof(Text))

		var3.material = Object.Instantiate(var3.material)

		local var4 = arg0:findTF("Price/Text", var2):GetComponent(typeof(Text))

		var4.material = Object.Instantiate(var4.material)

		local var5 = arg0:findTF("Mask/Text", var2):GetComponent(typeof(Text))

		var5.material = Object.Instantiate(var5.material)
	end
end

function var0.updateItem(arg0, arg1, arg2)
	local var0 = arg0:findTF("Frame", arg1)
	local var1 = arg0:findTF("Icon", arg1)
	local var2 = arg0:findTF("Count", arg1)
	local var3 = arg2.type or arg2[1]
	local var4 = arg2.id or arg2[2]
	local var5 = arg2.count or arg2[3]

	setText(var2, var5)

	if var3 ~= DROP_TYPE_SHIP then
		setImageSprite(var1, LoadSprite(Drop.New({
			type = var3,
			id = var4
		}):getIcon()))
	else
		local var6 = Ship.New({
			configId = var4
		}):getPainting()

		setImageSprite(var1, LoadSprite("QIcon/" .. var6))
	end

	setActive(var0, false)
	setActive(var1, false)
	setActive(var2, false)

	local var7 = arg0:findTF("CommonItemTemplate(Clone)", arg1)

	setActive(var7, true)
	updateDrop(var7, {
		type = var3,
		id = var4,
		count = var5
	})
end

function var0.updatePack(arg0, arg1, arg2, arg3)
	if arg2 == false then
		setActive(arg1, false)

		return
	elseif arg3 == var0.GiftPackType.Money and arg0:isBuyEver(arg2.id) then
		setActive(arg1, false)

		return
	else
		setActive(arg1, true)
	end

	local var0
	local var1

	if arg3 == var0.GiftPackType.Money then
		-- block empty
	else
		local var2 = arg2:getConfig("effect_args")

		var1 = Item.getConfigData(var2[1])
	end

	local var3 = arg0:findTF("PackIcon", arg1)
	local var4

	if arg3 == var0.GiftPackType.Money then
		var4 = "chargeicon/" .. arg2:getConfig("picture")
	else
		var4 = var1.icon
	end

	setImageSprite(var3, LoadSprite(var4), true)

	local var5 = arg0:findTF("PackName", arg1)

	if arg3 == var0.GiftPackType.Money then
		setText(var5, arg2:getConfig("name_display"))
	else
		setText(var5, var1.name)
	end

	local var6 = arg0:findTF("ItemList", arg1)
	local var7

	if arg3 == var0.GiftPackType.Money then
		var7 = arg2:getConfig("display")
	else
		var7 = var1.display_icon
	end

	local var8 = UIItemList.New(var6, arg0.itemTpl)

	var8:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			local var0 = var7[arg1]

			arg0:updateItem(arg2, var0)
		end
	end)
	var8:align(#var7)

	local var9 = arg0:findTF("DescFrame/Text", arg1)

	if arg3 == var0.GiftPackType.Money then
		setText(var9, arg2:getConfig("descrip"))
	else
		setText(var9, var1.display)
	end

	local var10 = arg0:findTF("TimeLimit", arg1)
	local var11 = arg0:findTF("Text", var10)
	local var12 = arg3 ~= var0.GiftPackType.Money and arg0:isHaveNextPack(var0.GiftPackTypeName[arg3])

	var12 = var12 and not arg0:isBuyEver(arg2.id)

	if var12 then
		setActive(var10, true)
		arg0:updatePackTimeLimit(var11, arg3)
	else
		setActive(var10, false)
	end

	local var13 = arg0:findTF("MoneyTag", arg1)

	setActive(var13, arg3 == var0.GiftPackType.Money)

	local var14 = arg0:findTF("Price/IconMoney", arg1)
	local var15 = arg0:findTF("Price/Icon", arg1)
	local var16 = arg0:findTF("Price/Icon/Res", arg1)
	local var17 = arg0:findTF("Price/Text", arg1)

	if arg3 == var0.GiftPackType.Money then
		setActive(var14, true)
		setActive(var15, false)
		setText(var17, arg2:getConfig("money"))
	else
		setActive(var14, false)
		setActive(var15, true)
		setText(var17, arg2:getConfig("resource_num"))

		local var18 = arg2:getConfig("resource_type")
		local var19

		if var18 == var0.Special_ID_Gem then
			var19 = "props/gem"
		elseif var18 == var0.Special_ID_Gold then
			var19 = "props/gold"
		end

		setImageSprite(var16, LoadSprite(var19), true)
	end

	local var20 = arg0:findTF("Mask", arg1)
	local var21 = arg0:isBuyEver(arg2.id)

	setActive(var20, var21)

	if var21 then
		local var22 = arg0:findTF("NextTime", var20)
		local var23 = arg0:findTF("Text", var20)
		local var24 = arg0:findTF("Sellout", var20)

		if arg0:isHaveNextPack(var0.GiftPackTypeName[arg3]) then
			setActive(var22, true)
			setActive(var23, true)
			setActive(var24, false)
			arg0:updatePackNextTime(var23, arg3)
		else
			setActive(var22, false)
			setActive(var23, false)
			setActive(var24, true)
		end
	end

	onButton(arg0, arg1, function()
		if not isActive(var20) then
			arg0:confirm(arg2)
		end
	end, SFX_PANEL)
end

function var0.updatePackTimeLimit(arg0, arg1, arg2)
	local var0 = arg0:getCurDay()
	local var1 = var0.GiftPackTypeName[arg2]
	local var2 = arg0:calcNextGiftPackSecByType(var1, var0)
	local var3 = arg0.packTimerList[arg2]

	if var3 then
		var3:Stop()

		arg0.packTimerList[arg2] = nil
	end

	local function var4()
		if var2 >= 0 then
			local var0 = pg.TimeMgr.GetInstance():DescCDTime(var2)

			setText(arg1, var0)

			var2 = var2 - 1
		else
			var3:Stop()

			arg0.packTimerList[arg2] = nil
		end
	end

	var3 = Timer.New(var4, 1, -1)

	var3:Start()

	arg0.packTimerList[arg2] = var3

	var4()
end

function var0.updatePackNextTime(arg0, arg1, arg2)
	local var0 = arg0:getCurDay()
	local var1 = var0.GiftPackTypeName[arg2]
	local var2 = arg0:calcNextGiftPackSecByType(var1, var0)
	local var3 = arg0.packNextTimerList[arg2]

	if var3 then
		var3:Stop()

		arg0.packNextTimerList[arg2] = nil
	end

	local function var4()
		if var2 >= 0 then
			local var0 = pg.TimeMgr.GetInstance():DescCDTime(var2)

			setText(arg1, var0)

			var2 = var2 - 1
		else
			var3:Stop()

			arg0.packNextTimerList[arg2] = nil
		end
	end

	var3 = Timer.New(var4, 1, -1)

	var3:Start()

	arg0.packNextTimerList[arg2] = var3

	var4()
end

function var0.updatePackList(arg0)
	arg0.packItemList:align(#arg0.goodVOList)
end

function var0.isShowRedPot()
	if PlayerPrefs.GetInt("RefluxShop_Enter_Day", 0) < getProxy(RefluxProxy).signCount then
		return true
	else
		return false
	end
end

function var0.SaveEnterTag()
	local var0 = getProxy(RefluxProxy).signCount

	PlayerPrefs.SetInt("RefluxShop_Enter_Day", var0)
end

function var0.getCurDay(arg0)
	local var0 = arg0.refluxProxy.returnTimestamp
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2 = pg.TimeMgr.GetInstance():DiffDay(var0, var1)
	local var3 = #pg.return_giftpack_template.all

	if var2 < var3 then
		return var2 + 1
	else
		return var3
	end
end

function var0.getLevelIndex(arg0, arg1)
	local var0 = arg1 or arg0:getCurDay()
	local var1 = pg.return_giftpack_template[var0].level
	local var2 = arg0.refluxProxy.returnLV
	local var3

	for iter0, iter1 in ipairs(var1) do
		local var4 = iter1[1]
		local var5 = iter1[2]

		if var4 <= var2 and var2 <= var5 then
			return iter0
		end
	end
end

function var0.getCurDayGiftPackIDByType(arg0, arg1, arg2)
	local var0 = arg2 or arg0:getCurDay()

	if var0 > #pg.return_giftpack_template.all then
		return false
	end

	local var1 = pg.return_giftpack_template[var0][arg1]
	local var2 = var0

	while var1 == "" and var2 > 1 do
		var2 = var2 - 1
		var1 = pg.return_giftpack_template[var2][arg1]
	end

	if var1 == "" then
		return false
	else
		return var1[arg0:getLevelIndex(var2)]
	end
end

function var0.getCurDayGiftPackIDList(arg0)
	local var0 = arg0:getCurDay()

	return {
		[var0.GiftPackType.Money] = arg0:getCurDayGiftPackIDByType("pack_type_1", var0),
		[var0.GiftPackType.Diamond] = arg0:getCurDayGiftPackIDByType("pack_type_2", var0),
		[var0.GiftPackType.Gold] = arg0:getCurDayGiftPackIDByType("pack_type_3", var0)
	}
end

function var0.getNextGiftPackDayByType(arg0, arg1, arg2)
	local var0 = arg2 or arg0:getCurDay()

	if var0 >= #pg.return_giftpack_template.all then
		return false
	end

	local var1 = var0 + 1
	local var2 = pg.return_giftpack_template[var1][arg1]
	local var3 = var1

	while var2 == "" and var3 > 1 and var3 <= #pg.return_giftpack_template.all do
		var2 = pg.return_giftpack_template[var3][arg1]
		var3 = var3 + 1
	end

	if var2 == "" then
		return false
	else
		return var3
	end
end

function var0.isHaveNextPack(arg0, arg1, arg2)
	local var0 = arg2 or arg0:getCurDay()

	return arg0:getNextGiftPackDayByType(arg1, var0) ~= false
end

function var0.calcNextGiftPackSecByType(arg0, arg1, arg2)
	local var0 = arg2 or arg0:getCurDay()
	local var1 = arg0:getNextGiftPackDayByType(arg1, var0)
	local var2 = 86400

	return arg0.refluxProxy.returnTimestamp + (var1 - 1) * var2 - pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.isBuyEver(arg0, arg1)
	local var0 = getProxy(ShopsProxy)
	local var1 = var0:getChargedList()
	local var2 = var0:GetNormalList()

	return 0 + ChargeConst.getBuyCount(var1, arg1) + ChargeConst.getBuyCount(var2, arg1) > 0
end

function var0.confirm(arg0, arg1)
	if not arg1 then
		return
	end

	arg1 = Clone(arg1)

	if arg1:isChargeType() then
		local var0 = not table.contains(arg0.firstChargeIds, arg1.id) and arg1:firstPayDouble()
		local var1 = var0 and 4 or arg1:getConfig("tag")

		if arg1:isMonthCard() or arg1:isGiftBox() or arg1:isItemBox() or arg1:isPassItem() then
			local var2 = underscore.map(arg1:getConfig("extra_service_item"), function(arg0)
				return Drop.Create(arg0)
			end)
			local var3

			if arg1:isPassItem() then
				local var4 = arg1:getConfig("sub_display")
				local var5 = var4[1]
				local var6 = pg.battlepass_event_pt[var5].pt

				var3 = Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = pg.battlepass_event_pt[var5].pt,
					count = var4[2]
				})
				var2 = PlayerConst.MergePassItemDrop(underscore.map(pg.battlepass_event_pt[var5].drop_client_pay, function(arg0)
					return Drop.Create(arg0)
				end))
			end

			local var7 = arg1:getConfig("gem") + arg1:getConfig("extra_gem")
			local var8

			if arg1:isMonthCard() then
				var8 = Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = PlayerConst.ResDiamond,
					count = var7
				})
			elseif var7 > 0 then
				table.insert(var2, Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = PlayerConst.ResDiamond,
					count = var7
				}))
			end

			local var9
			local var10

			if arg1:isPassItem() then
				var9 = i18n("battlepass_pay_tip")
			elseif arg1:isMonthCard() then
				var9 = i18n("charge_title_getitem_month")
				var10 = i18n("charge_title_getitem_soon")
			else
				var9 = i18n("charge_title_getitem")
			end

			local var11 = {
				isChargeType = true,
				icon = "chargeicon/" .. arg1:getConfig("picture"),
				name = arg1:getConfig("name_display"),
				tipExtra = var9,
				extraItems = var2,
				price = arg1:getConfig("money"),
				isLocalPrice = arg1:IsLocalPrice(),
				tagType = var1,
				isMonthCard = arg1:isMonthCard(),
				tipBonus = var10,
				bonusItem = var8,
				extraDrop = var3,
				descExtra = arg1:getConfig("descrip_extra"),
				limitArgs = arg1:getConfig("limit_args"),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0:emit(RefluxMediator.OPEN_CHARGE_BIRTHDAY)
					else
						pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
							shopId = arg1.id
						})
					end
				end
			}

			arg0:emit(RefluxMediator.OPEN_CHARGE_ITEM_PANEL, var11)
		elseif arg1:isGem() then
			local var12 = arg1:getConfig("money")
			local var13 = arg1:getConfig("gem")

			if var0 then
				var13 = var13 + arg1:getConfig("gem")
			else
				var13 = var13 + arg1:getConfig("extra_gem")
			end

			local var14 = {
				isChargeType = true,
				icon = "chargeicon/" .. arg1:getConfig("picture"),
				name = arg1:getConfig("name_display"),
				price = arg1:getConfig("money"),
				isLocalPrice = arg1:IsLocalPrice(),
				tagType = var1,
				normalTip = i18n("charge_start_tip", var12, var13),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0:emit(RefluxMediator.OPEN_CHARGE_BIRTHDAY)
					else
						pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
							shopId = arg1.id
						})
					end
				end
			}

			arg0:emit(RefluxMediator.OPEN_CHARGE_ITEM_BOX, var14)
		end
	else
		local var15 = {}
		local var16 = arg1:getConfig("effect_args")
		local var17 = Item.getConfigData(var16[1])
		local var18 = var17.display_icon

		if type(var18) == "table" then
			for iter0, iter1 in ipairs(var18) do
				table.insert(var15, Drop.Create(iter1))
			end
		end

		local var19 = arg1:getConfig("resource_type") == var0.Special_ID_Gold
		local var20

		if var19 then
			var20 = i18n("charge_scene_buy_confirm_gold", arg1:getConfig("resource_num"), var17.name)
		else
			var20 = i18n("charge_scene_buy_confirm", arg1:getConfig("resource_num"), var17.name)
		end

		local var21 = {
			isMonthCard = false,
			isChargeType = false,
			isLocalPrice = false,
			icon = var17.icon,
			name = var17.name,
			tipExtra = i18n("charge_title_getitem"),
			extraItems = var15,
			price = arg1:getConfig("resource_num"),
			tagType = arg1:getConfig("tag"),
			isForceGold = var19,
			onYes = function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = var20,
					onYes = function()
						pg.m02:sendNotification(GAME.SHOPPING, {
							count = 1,
							id = arg1.id
						})
					end
				})
			end
		}

		arg0:emit(RefluxMediator.OPEN_CHARGE_ITEM_PANEL, var21)
	end
end

function var0.getAllRefluxPackID()
	local var0 = {}

	for iter0, iter1 in ipairs(pg.return_giftpack_template.all) do
		local var1 = pg.return_giftpack_template[iter1]
		local var2 = var1.pack_type_1
		local var3 = var1.pack_type_2
		local var4 = var1.pack_type_3

		if type(var2) == "table" then
			for iter2, iter3 in pairs(var2) do
				table.insert(var0, iter3)
			end
		end

		if type(var3) == "table" then
			for iter4, iter5 in pairs(var3) do
				table.insert(var0, iter5)
			end
		end

		if type(var4) == "table" then
			for iter6, iter7 in pairs(var4) do
				table.insert(var0, iter7)
			end
		end
	end

	return var0
end

return var0
