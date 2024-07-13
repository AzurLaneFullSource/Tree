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

function var0_0.findTF(arg0_4, arg1_4, arg2_4)
	assert(arg0_4._tf, "transform should exist")

	return findTF(arg2_4 or arg0_4._tf, arg1_4)
end

function var0_0.exit(arg0_5)
	pg.DelegateInfo.Dispose(arg0_5)
	arg0_5:overLayMyself(false)
	PoolMgr.GetInstance():ReturnUI("GoldExchangeWindow", arg0_5._go)

	pg.goldExchangeMgr = nil
end

function var0_0.initData(arg0_6)
	arg0_6.selectedIndex = 1
	arg0_6.selectedNum = 1
	arg0_6.selectedMax = 10
	arg0_6.player = getProxy(PlayerProxy):getData()
end

function var0_0.initUI(arg0_7)
	arg0_7.bg = arg0_7:findTF("BG")
	arg0_7.btnBack = arg0_7:findTF("Window/top/btnBack")
	arg0_7.contentTF = arg0_7:findTF("Window/Content")
	arg0_7.goldTF = {}
	arg0_7.goldTF[1] = {}
	arg0_7.goldTF_1 = arg0_7:findTF("Gold1", arg0_7.contentTF)
	arg0_7.goldTF[1].itemTF = arg0_7.goldTF_1
	arg0_7.goldTF[1].countTF = arg0_7:findTF("item/icon_bg/count", arg0_7.goldTF_1)
	arg0_7.goldTF[1].priceTF = arg0_7:findTF("item/consume/contain/price", arg0_7.goldTF_1)
	arg0_7.goldTF[1].selectedTF = arg0_7:findTF("item/selected", arg0_7.goldTF_1)
	arg0_7.goldTF[1].selectedNumTF = arg0_7:findTF("reduce/Text", arg0_7.goldTF[1].selectedTF)

	setText(arg0_7.goldTF[1].countTF, var0_0.goldNum[1])
	setText(arg0_7.goldTF[1].priceTF, var0_0.gemNum[1])

	arg0_7.goldTF[2] = {}
	arg0_7.goldTF_2 = arg0_7:findTF("Gold2", arg0_7.contentTF)
	arg0_7.goldTF[2].itemTF = arg0_7.goldTF_2
	arg0_7.goldTF[2].countTF = arg0_7:findTF("item/icon_bg/count", arg0_7.goldTF_2)
	arg0_7.goldTF[2].priceTF = arg0_7:findTF("item/consume/contain/price", arg0_7.goldTF_2)
	arg0_7.goldTF[2].selectedTF = arg0_7:findTF("item/selected", arg0_7.goldTF_2)
	arg0_7.goldTF[2].selectedNumTF = arg0_7:findTF("reduce/Text", arg0_7.goldTF[2].selectedTF)

	setText(arg0_7.goldTF[2].countTF, var0_0.goldNum[2])
	setText(arg0_7.goldTF[2].priceTF, var0_0.gemNum[2])

	arg0_7.gemCountText = arg0_7:findTF("Tip/DiamondCount", arg0_7.contentTF)
	arg0_7.goldCountText = arg0_7:findTF("Tip/GoldCount", arg0_7.contentTF)
	arg0_7.shopBtn = arg0_7:findTF("Window/button_container/ShopBtn")
	arg0_7.confirmBtn = arg0_7:findTF("Window/button_container/ConfirmBtn")
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.bg, function()
		arg0_8:exit()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.btnBack, function()
		arg0_8:exit()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.shopBtn, function()
		if getProxy(ContextProxy):getContextByMediator(ChargeMediator) then
			arg0_8:exit()
		else
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
				wrap = ChargeScene.TYPE_ITEM
			})
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.confirmBtn, function()
		local var0_12

		if arg0_8.selectedIndex == 1 then
			var0_12 = var0_0.itemid1
		elseif arg0_8.selectedIndex == 2 then
			var0_12 = var0_0.itemid2
		end

		pg.m02:sendNotification(GAME.SHOPPING, {
			isQuickShopping = true,
			id = var0_12,
			count = arg0_8.selectedNum
		})
		arg0_8:exit()
	end, SFX_PANEL)

	for iter0_8 = 1, 2 do
		onButton(arg0_8, arg0_8.goldTF[iter0_8].itemTF, function()
			if arg0_8.selectedIndex == iter0_8 then
				arg0_8.selectedNum = math.min(arg0_8.selectedNum + 1, arg0_8.selectedMax)
			else
				arg0_8.selectedIndex = iter0_8
				arg0_8.selectedNum = 1
			end

			arg0_8:updateView()
		end, SFX_PANEL)
		onButton(arg0_8, arg0_8.goldTF[iter0_8].selectedTF, function()
			if arg0_8.selectedNum > 1 then
				arg0_8.selectedNum = arg0_8.selectedNum - 1

				arg0_8:updateView()
			end
		end, SFX_PANEL)
	end
end

function var0_0.updateView(arg0_15)
	for iter0_15 = 1, 2 do
		setActive(arg0_15.goldTF[iter0_15].selectedTF, iter0_15 == arg0_15.selectedIndex)
		setActive(arg0_15.goldTF[3 - iter0_15].selectedTF, iter0_15 ~= arg0_15.selectedIndex)

		if iter0_15 == arg0_15.selectedIndex then
			setText(arg0_15.goldTF[iter0_15].selectedNumTF, arg0_15.selectedNum)
		end
	end

	local var0_15
	local var1_15
	local var2_15 = var0_0.gemNum[arg0_15.selectedIndex] * arg0_15.selectedNum
	local var3_15 = var0_0.goldNum[arg0_15.selectedIndex] * arg0_15.selectedNum

	setText(arg0_15.gemCountText, var2_15)

	if var2_15 > arg0_15.player:getTotalGem() then
		setTextColor(arg0_15.gemCountText, Color.red)
	else
		setTextColor(arg0_15.gemCountText, Color.yellow)
	end

	setText(arg0_15.goldCountText, var3_15)
end

function var0_0.overLayMyself(arg0_16, arg1_16)
	if arg1_16 == true then
		pg.UIMgr.GetInstance():BlurPanel(arg0_16._tf, false, {
			weight = LayerWeightConst.TOP_LAYER
		})
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0_16._tf)
	end
end

return var0_0
