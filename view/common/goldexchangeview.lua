local var0 = class("GoldExchangeView")

var0.itemid1 = 12
var0.itemid2 = 24
var0.const = 5
var0.goldNum = {
	[1] = 3000,
	[2] = 15000
}
var0.gemNum = {
	[1] = 100,
	[2] = 450
}

function var0.Ctor(arg0)
	pg.DelegateInfo.New(arg0)
	PoolMgr.GetInstance():GetUI("GoldExchangeWindow", false, function(arg0)
		local var0 = pg.UIMgr.GetInstance().UIMain

		arg0.transform:SetParent(var0.transform, false)

		arg0._go = arg0
		arg0._tf = arg0.transform

		arg0:init()
	end)
end

function var0.init(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:addListener()
	arg0:overLayMyself(true)
	arg0:updateView()
end

function var0.findTF(arg0, arg1, arg2)
	assert(arg0._tf, "transform should exist")

	return findTF(arg2 or arg0._tf, arg1)
end

function var0.exit(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:overLayMyself(false)
	PoolMgr.GetInstance():ReturnUI("GoldExchangeWindow", arg0._go)

	pg.goldExchangeMgr = nil
end

function var0.initData(arg0)
	arg0.selectedIndex = 1
	arg0.selectedNum = 1
	arg0.selectedMax = 10
	arg0.player = getProxy(PlayerProxy):getData()
end

function var0.initUI(arg0)
	arg0.bg = arg0:findTF("BG")
	arg0.btnBack = arg0:findTF("Window/top/btnBack")
	arg0.contentTF = arg0:findTF("Window/Content")
	arg0.goldTF = {}
	arg0.goldTF[1] = {}
	arg0.goldTF_1 = arg0:findTF("Gold1", arg0.contentTF)
	arg0.goldTF[1].itemTF = arg0.goldTF_1
	arg0.goldTF[1].countTF = arg0:findTF("item/icon_bg/count", arg0.goldTF_1)
	arg0.goldTF[1].priceTF = arg0:findTF("item/consume/contain/price", arg0.goldTF_1)
	arg0.goldTF[1].selectedTF = arg0:findTF("item/selected", arg0.goldTF_1)
	arg0.goldTF[1].selectedNumTF = arg0:findTF("reduce/Text", arg0.goldTF[1].selectedTF)

	setText(arg0.goldTF[1].countTF, var0.goldNum[1])
	setText(arg0.goldTF[1].priceTF, var0.gemNum[1])

	arg0.goldTF[2] = {}
	arg0.goldTF_2 = arg0:findTF("Gold2", arg0.contentTF)
	arg0.goldTF[2].itemTF = arg0.goldTF_2
	arg0.goldTF[2].countTF = arg0:findTF("item/icon_bg/count", arg0.goldTF_2)
	arg0.goldTF[2].priceTF = arg0:findTF("item/consume/contain/price", arg0.goldTF_2)
	arg0.goldTF[2].selectedTF = arg0:findTF("item/selected", arg0.goldTF_2)
	arg0.goldTF[2].selectedNumTF = arg0:findTF("reduce/Text", arg0.goldTF[2].selectedTF)

	setText(arg0.goldTF[2].countTF, var0.goldNum[2])
	setText(arg0.goldTF[2].priceTF, var0.gemNum[2])

	arg0.gemCountText = arg0:findTF("Tip/DiamondCount", arg0.contentTF)
	arg0.goldCountText = arg0:findTF("Tip/GoldCount", arg0.contentTF)
	arg0.shopBtn = arg0:findTF("Window/button_container/ShopBtn")
	arg0.confirmBtn = arg0:findTF("Window/button_container/ConfirmBtn")
end

function var0.addListener(arg0)
	onButton(arg0, arg0.bg, function()
		arg0:exit()
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnBack, function()
		arg0:exit()
	end, SFX_CANCEL)
	onButton(arg0, arg0.shopBtn, function()
		if getProxy(ContextProxy):getContextByMediator(ChargeMediator) then
			arg0:exit()
		else
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
				wrap = ChargeScene.TYPE_ITEM
			})
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		local var0

		if arg0.selectedIndex == 1 then
			var0 = var0.itemid1
		elseif arg0.selectedIndex == 2 then
			var0 = var0.itemid2
		end

		pg.m02:sendNotification(GAME.SHOPPING, {
			isQuickShopping = true,
			id = var0,
			count = arg0.selectedNum
		})
		arg0:exit()
	end, SFX_PANEL)

	for iter0 = 1, 2 do
		onButton(arg0, arg0.goldTF[iter0].itemTF, function()
			if arg0.selectedIndex == iter0 then
				arg0.selectedNum = math.min(arg0.selectedNum + 1, arg0.selectedMax)
			else
				arg0.selectedIndex = iter0
				arg0.selectedNum = 1
			end

			arg0:updateView()
		end, SFX_PANEL)
		onButton(arg0, arg0.goldTF[iter0].selectedTF, function()
			if arg0.selectedNum > 1 then
				arg0.selectedNum = arg0.selectedNum - 1

				arg0:updateView()
			end
		end, SFX_PANEL)
	end
end

function var0.updateView(arg0)
	for iter0 = 1, 2 do
		setActive(arg0.goldTF[iter0].selectedTF, iter0 == arg0.selectedIndex)
		setActive(arg0.goldTF[3 - iter0].selectedTF, iter0 ~= arg0.selectedIndex)

		if iter0 == arg0.selectedIndex then
			setText(arg0.goldTF[iter0].selectedNumTF, arg0.selectedNum)
		end
	end

	local var0
	local var1
	local var2 = var0.gemNum[arg0.selectedIndex] * arg0.selectedNum
	local var3 = var0.goldNum[arg0.selectedIndex] * arg0.selectedNum

	setText(arg0.gemCountText, var2)

	if var2 > arg0.player:getTotalGem() then
		setTextColor(arg0.gemCountText, Color.red)
	else
		setTextColor(arg0.gemCountText, Color.yellow)
	end

	setText(arg0.goldCountText, var3)
end

function var0.overLayMyself(arg0, arg1)
	if arg1 == true then
		pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
			weight = LayerWeightConst.TOP_LAYER
		})
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	end
end

return var0
