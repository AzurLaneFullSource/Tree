local var0_0 = class("GoldExchangeView")

var0_0.itemid1 = 12
var0_0.itemid2 = 24
var0_0.const = 5
var0_0.goldNum = {
	[1] = 3000,
	[2] = 15000
}
var0_0.gemNum = {
	[1] = 100,
	[2] = 450
}

function var0_0.Ctor(arg0_1)
	pg.DelegateInfo.New(arg0_1)
	PoolMgr.GetInstance():GetUI("GoldExchangeWindow", false, function(arg0_2)
		local var0_2 = pg.UIMgr.GetInstance().UIMain

		arg0_2.transform:SetParent(var0_2.transform, false)

		arg0_1._go = arg0_2
		arg0_1._tf = arg0_2.transform

		arg0_1:init()
	end)
end

function var0_0.init(arg0_3)
	arg0_3:initData()
	arg0_3:initUI()
	arg0_3:addListener()
	arg0_3:overLayMyself(true)
	arg0_3:updateView()
end

function var0_0.exit(arg0_4)
	pg.DelegateInfo.Dispose(arg0_4)
	arg0_4:overLayMyself(false)
	PoolMgr.GetInstance():ReturnUI("GoldExchangeWindow", arg0_4._go)

	pg.goldExchangeMgr = nil
end

function var0_0.initData(arg0_5)
	arg0_5.selectedIndex = 1
	arg0_5.selectedNum = 1
	arg0_5.selectedMax = 10
	arg0_5.player = getProxy(PlayerProxy):getData()
end

function var0_0.initUI(arg0_6)
	arg0_6.bg = arg0_6._tf:Find("BG")
	arg0_6.btnBack = arg0_6._tf:Find("Window/top/btnBack")
	arg0_6.contentTF = arg0_6._tf:Find("Window/Content")
	arg0_6.goldTF = {}
	arg0_6.goldTF[1] = {}
	arg0_6.goldTF_1 = arg0_6.contentTF:Find("Gold1")
	arg0_6.goldTF[1].itemTF = arg0_6.goldTF_1
	arg0_6.goldTF[1].countTF = arg0_6.goldTF_1:Find("item/icon_bg/count")
	arg0_6.goldTF[1].priceTF = arg0_6.goldTF_1:Find("item/consume/contain/price")
	arg0_6.goldTF[1].selectedTF = arg0_6.goldTF_1:Find("item/selected")
	arg0_6.goldTF[1].selectedNumTF = arg0_6.goldTF[1].selectedTF:Find("reduce/Text")

	setText(arg0_6.goldTF[1].countTF, var0_0.goldNum[1])
	setText(arg0_6.goldTF[1].priceTF, var0_0.gemNum[1])

	arg0_6.goldTF[2] = {}
	arg0_6.goldTF_2 = arg0_6.contentTF:Find("Gold2")
	arg0_6.goldTF[2].itemTF = arg0_6.goldTF_2
	arg0_6.goldTF[2].countTF = arg0_6.goldTF_2:Find("item/icon_bg/count")
	arg0_6.goldTF[2].priceTF = arg0_6.goldTF_2:Find("item/consume/contain/price")
	arg0_6.goldTF[2].selectedTF = arg0_6.goldTF_2:Find("item/selected")
	arg0_6.goldTF[2].selectedNumTF = arg0_6.goldTF[2].selectedTF:Find("reduce/Text")

	setText(arg0_6.goldTF[2].countTF, var0_0.goldNum[2])
	setText(arg0_6.goldTF[2].priceTF, var0_0.gemNum[2])

	arg0_6.gemCountText = arg0_6.contentTF:Find("Tip/DiamondCount")
	arg0_6.goldCountText = arg0_6.contentTF:Find("Tip/GoldCount")
	arg0_6.shopBtn = arg0_6._tf:Find("Window/button_container/ShopBtn")
	arg0_6.confirmBtn = arg0_6._tf:Find("Window/button_container/ConfirmBtn")
end

function var0_0.addListener(arg0_7)
	onButton(arg0_7, arg0_7.bg, function()
		arg0_7:exit()
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.btnBack, function()
		arg0_7:exit()
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.shopBtn, function()
		if getProxy(ContextProxy):getContextByMediator(NewShopMainMediator) then
			arg0_7:exit()
		else
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
				wrap = ChargeScene.TYPE_ITEM
			})
		end
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.confirmBtn, function()
		local var0_11

		if arg0_7.selectedIndex == 1 then
			var0_11 = var0_0.itemid1
		elseif arg0_7.selectedIndex == 2 then
			var0_11 = var0_0.itemid2
		end

		pg.m02:sendNotification(GAME.SHOPPING, {
			isQuickShopping = true,
			id = var0_11,
			count = arg0_7.selectedNum
		})
		arg0_7:exit()
	end, SFX_PANEL)

	for iter0_7 = 1, 2 do
		onButton(arg0_7, arg0_7.goldTF[iter0_7].itemTF, function()
			if arg0_7.selectedIndex == iter0_7 then
				arg0_7.selectedNum = math.min(arg0_7.selectedNum + 1, arg0_7.selectedMax)
			else
				arg0_7.selectedIndex = iter0_7
				arg0_7.selectedNum = 1
			end

			arg0_7:updateView()
		end, SFX_PANEL)
		onButton(arg0_7, arg0_7.goldTF[iter0_7].selectedTF, function()
			if arg0_7.selectedNum > 1 then
				arg0_7.selectedNum = arg0_7.selectedNum - 1

				arg0_7:updateView()
			end
		end, SFX_PANEL)
	end
end

function var0_0.updateView(arg0_14)
	for iter0_14 = 1, 2 do
		setActive(arg0_14.goldTF[iter0_14].selectedTF, iter0_14 == arg0_14.selectedIndex)
		setActive(arg0_14.goldTF[3 - iter0_14].selectedTF, iter0_14 ~= arg0_14.selectedIndex)

		if iter0_14 == arg0_14.selectedIndex then
			setText(arg0_14.goldTF[iter0_14].selectedNumTF, arg0_14.selectedNum)
		end
	end

	local var0_14
	local var1_14
	local var2_14 = var0_0.gemNum[arg0_14.selectedIndex] * arg0_14.selectedNum
	local var3_14 = var0_0.goldNum[arg0_14.selectedIndex] * arg0_14.selectedNum

	setText(arg0_14.gemCountText, var2_14)

	if var2_14 > arg0_14.player:getTotalGem() then
		setTextColor(arg0_14.gemCountText, Color.red)
	else
		setTextColor(arg0_14.gemCountText, Color.yellow)
	end

	setText(arg0_14.goldCountText, var3_14)
end

function var0_0.overLayMyself(arg0_15, arg1_15)
	if arg1_15 == true then
		pg.UIMgr.GetInstance():BlurPanel(arg0_15._tf)
	else
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_15._tf)
	end
end

return var0_0
