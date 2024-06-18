local var0_0 = class("ChargeTecShipGiftSellLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ChargeTecShipGiftSellLayer"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
	arg0_2:initUIText()
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
	arg0_3:updateGiftList()
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf)
end

function var0_0.initData(arg0_5)
	arg0_5.showGoodVO = arg0_5.contextData.showGoodVO
	arg0_5.chargedList = arg0_5.contextData.chargedList
	arg0_5.goodVOList = arg0_5.showGoodVO:getSameGroupTecShipGift()
	arg0_5.normalGoodVO = nil
	arg0_5.highGoodVO = nil
	arg0_5.upGoodVO = nil

	for iter0_5, iter1_5 in ipairs(arg0_5.goodVOList) do
		if iter1_5:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.Normal then
			arg0_5.normalGoodVO = iter1_5
		elseif iter1_5:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.High then
			arg0_5.highGoodVO = iter1_5
		elseif iter1_5:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.Up then
			arg0_5.upGoodVO = iter1_5
		end
	end

	arg0_5.goodVOShowList = {}

	local var0_5 = ChargeConst.getBuyCount(arg0_5.chargedList, arg0_5.normalGoodVO.id)
	local var1_5 = ChargeConst.getBuyCount(arg0_5.chargedList, arg0_5.highGoodVO.id)
	local var2_5 = ChargeConst.getBuyCount(arg0_5.chargedList, arg0_5.upGoodVO.id)

	if var0_5 == 0 and var1_5 == 0 and var2_5 == 0 then
		table.insert(arg0_5.goodVOShowList, arg0_5.normalGoodVO)
		table.insert(arg0_5.goodVOShowList, arg0_5.highGoodVO)
	elseif var0_5 > 0 and var1_5 == 0 and var2_5 == 0 then
		table.insert(arg0_5.goodVOShowList, arg0_5.normalGoodVO)
		table.insert(arg0_5.goodVOShowList, arg0_5.upGoodVO)
	elseif (not (var0_5 > 0) or not (var2_5 > 0)) and var1_5 > 0 then
		-- block empty
	end
end

function var0_0.initUIText(arg0_6)
	local var0_6 = arg0_6:findTF("Adapt/TipBG/Text")

	setText(var0_6, i18n("tech_package_tip"))
end

function var0_0.findUI(arg0_7)
	arg0_7.bg = arg0_7:findTF("BG")

	local var0_7 = GetComponent(arg0_7._tf, "ItemList").prefabItem[0]
	local var1_7 = Instantiate(var0_7)

	arg0_7.itemTpl = arg0_7:findTF("ItemTpl")

	local var2_7 = arg0_7:findTF("Container", arg0_7.itemTpl)

	setParent(var1_7, var2_7, false)

	arg0_7.giftTpl = arg0_7:findTF("GiftTpl")
	arg0_7.giftContainer = arg0_7:findTF("List")
	arg0_7.giftUIItemList = UIItemList.New(arg0_7.giftContainer, arg0_7.giftTpl)

	arg0_7.giftUIItemList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			arg1_8 = arg1_8 + 1

			local var0_8 = arg0_7.goodVOShowList[arg1_8]

			arg0_7:updateGiftTF(arg2_8, var0_8)
		end
	end)
end

function var0_0.addListener(arg0_9)
	onButton(arg0_9, arg0_9.bg, function()
		arg0_9:closeView()
	end, SFX_PANEL)
end

function var0_0.updateGiftTF(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11:findTF("BG/Normal", arg1_11)
	local var1_11 = arg0_11:findTF("BG/Special", arg1_11)
	local var2_11 = arg0_11:findTF("Buy/Normal", arg1_11)
	local var3_11 = arg0_11:findTF("Buy/Special", arg1_11)
	local var4_11 = arg0_11:findTF("Buy/Up", arg1_11)
	local var5_11 = arg0_11:findTF("Buy/Disable", arg1_11)
	local var6_11 = arg0_11:findTF("Title", arg1_11)
	local var7_11 = arg0_11:findTF("GiftImage", arg1_11)
	local var8_11 = arg0_11:findTF("Desc1", arg1_11)
	local var9_11 = arg0_11:findTF("Desc2", arg1_11)
	local var10_11 = arg0_11:findTF("List", arg1_11)
	local var11_11 = arg2_11:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.Normal
	local var12_11 = arg2_11:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.High
	local var13_11 = arg2_11:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.Up
	local var14_11 = ChargeConst.getBuyCount(arg0_11.chargedList, arg0_11.normalGoodVO.id) > 0

	setActive(var0_11, var11_11)
	setActive(var1_11, not var11_11)
	setActive(var2_11, var11_11 and not var14_11)
	setActive(var3_11, var12_11)
	setActive(var4_11, var13_11)
	setActive(var5_11, var11_11 and var14_11)

	if var11_11 and var14_11 then
		setGray(arg1_11, true, true)
	end

	local function var15_11()
		pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg2_11.id
		})
		arg0_11:closeView()
	end

	onButton(arg0_11, var2_11, function()
		var15_11()
	end, SFX_PANEL)
	onButton(arg0_11, var3_11, function()
		var15_11()
	end, SFX_PANEL)
	onButton(arg0_11, var4_11, function()
		var15_11()
	end, SFX_PANEL)
	setText(var6_11, arg2_11:getConfig("name_display"))
	setText(var8_11, arg2_11:getConfig("descrip"))
	setText(var9_11, arg2_11:getConfig("descrip_extra"))
	setImageSprite(var7_11, LoadSprite("chargeicon/" .. arg2_11:getConfig("picture")), true)

	local var16_11 = {}

	for iter0_11, iter1_11 in ipairs(arg2_11:getConfig("display")) do
		table.insert(var16_11, Drop.Create(iter1_11))
	end

	local var17_11 = UIItemList.New(var10_11, arg0_11.itemTpl)

	var17_11:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = arg0_11:findTF("Container", arg2_16):GetChild(0)
			local var1_16 = arg0_11:findTF("TextMask/Text", arg2_16)

			arg1_16 = arg1_16 + 1

			local var2_16 = var16_11[arg1_16]

			updateDrop(var0_16, var2_16)
			onButton(arg0_11, var0_16, function()
				arg0_11:emit(BaseUI.ON_DROP, var2_16)
			end, SFX_PANEL)
			setScrollText(var1_16, var2_16:getName())
		end
	end)
	var17_11:align(#var16_11)
end

function var0_0.updateGiftList(arg0_18)
	arg0_18.giftUIItemList:align(#arg0_18.goodVOShowList)
end

return var0_0
