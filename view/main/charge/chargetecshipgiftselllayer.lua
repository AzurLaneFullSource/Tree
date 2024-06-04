local var0 = class("ChargeTecShipGiftSellLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "ChargeTecShipGiftSellLayer"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
	arg0:initUIText()
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:updateGiftList()
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.initData(arg0)
	arg0.showGoodVO = arg0.contextData.showGoodVO
	arg0.chargedList = arg0.contextData.chargedList
	arg0.goodVOList = arg0.showGoodVO:getSameGroupTecShipGift()
	arg0.normalGoodVO = nil
	arg0.highGoodVO = nil
	arg0.upGoodVO = nil

	for iter0, iter1 in ipairs(arg0.goodVOList) do
		if iter1:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.Normal then
			arg0.normalGoodVO = iter1
		elseif iter1:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.High then
			arg0.highGoodVO = iter1
		elseif iter1:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.Up then
			arg0.upGoodVO = iter1
		end
	end

	arg0.goodVOShowList = {}

	local var0 = ChargeConst.getBuyCount(arg0.chargedList, arg0.normalGoodVO.id)
	local var1 = ChargeConst.getBuyCount(arg0.chargedList, arg0.highGoodVO.id)
	local var2 = ChargeConst.getBuyCount(arg0.chargedList, arg0.upGoodVO.id)

	if var0 == 0 and var1 == 0 and var2 == 0 then
		table.insert(arg0.goodVOShowList, arg0.normalGoodVO)
		table.insert(arg0.goodVOShowList, arg0.highGoodVO)
	elseif var0 > 0 and var1 == 0 and var2 == 0 then
		table.insert(arg0.goodVOShowList, arg0.normalGoodVO)
		table.insert(arg0.goodVOShowList, arg0.upGoodVO)
	elseif (not (var0 > 0) or not (var2 > 0)) and var1 > 0 then
		-- block empty
	end
end

function var0.initUIText(arg0)
	local var0 = arg0:findTF("Adapt/TipBG/Text")

	setText(var0, i18n("tech_package_tip"))
end

function var0.findUI(arg0)
	arg0.bg = arg0:findTF("BG")

	local var0 = GetComponent(arg0._tf, "ItemList").prefabItem[0]
	local var1 = Instantiate(var0)

	arg0.itemTpl = arg0:findTF("ItemTpl")

	local var2 = arg0:findTF("Container", arg0.itemTpl)

	setParent(var1, var2, false)

	arg0.giftTpl = arg0:findTF("GiftTpl")
	arg0.giftContainer = arg0:findTF("List")
	arg0.giftUIItemList = UIItemList.New(arg0.giftContainer, arg0.giftTpl)

	arg0.giftUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			local var0 = arg0.goodVOShowList[arg1]

			arg0:updateGiftTF(arg2, var0)
		end
	end)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.bg, function()
		arg0:closeView()
	end, SFX_PANEL)
end

function var0.updateGiftTF(arg0, arg1, arg2)
	local var0 = arg0:findTF("BG/Normal", arg1)
	local var1 = arg0:findTF("BG/Special", arg1)
	local var2 = arg0:findTF("Buy/Normal", arg1)
	local var3 = arg0:findTF("Buy/Special", arg1)
	local var4 = arg0:findTF("Buy/Up", arg1)
	local var5 = arg0:findTF("Buy/Disable", arg1)
	local var6 = arg0:findTF("Title", arg1)
	local var7 = arg0:findTF("GiftImage", arg1)
	local var8 = arg0:findTF("Desc1", arg1)
	local var9 = arg0:findTF("Desc2", arg1)
	local var10 = arg0:findTF("List", arg1)
	local var11 = arg2:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.Normal
	local var12 = arg2:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.High
	local var13 = arg2:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.Up
	local var14 = ChargeConst.getBuyCount(arg0.chargedList, arg0.normalGoodVO.id) > 0

	setActive(var0, var11)
	setActive(var1, not var11)
	setActive(var2, var11 and not var14)
	setActive(var3, var12)
	setActive(var4, var13)
	setActive(var5, var11 and var14)

	if var11 and var14 then
		setGray(arg1, true, true)
	end

	local function var15()
		pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg2.id
		})
		arg0:closeView()
	end

	onButton(arg0, var2, function()
		var15()
	end, SFX_PANEL)
	onButton(arg0, var3, function()
		var15()
	end, SFX_PANEL)
	onButton(arg0, var4, function()
		var15()
	end, SFX_PANEL)
	setText(var6, arg2:getConfig("name_display"))
	setText(var8, arg2:getConfig("descrip"))
	setText(var9, arg2:getConfig("descrip_extra"))
	setImageSprite(var7, LoadSprite("chargeicon/" .. arg2:getConfig("picture")), true)

	local var16 = {}

	for iter0, iter1 in ipairs(arg2:getConfig("display")) do
		table.insert(var16, Drop.Create(iter1))
	end

	local var17 = UIItemList.New(var10, arg0.itemTpl)

	var17:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0:findTF("Container", arg2):GetChild(0)
			local var1 = arg0:findTF("TextMask/Text", arg2)

			arg1 = arg1 + 1

			local var2 = var16[arg1]

			updateDrop(var0, var2)
			onButton(arg0, var0, function()
				arg0:emit(BaseUI.ON_DROP, var2)
			end, SFX_PANEL)
			setScrollText(var1, var2:getName())
		end
	end)
	var17:align(#var16)
end

function var0.updateGiftList(arg0)
	arg0.giftUIItemList:align(#arg0.goodVOShowList)
end

return var0
