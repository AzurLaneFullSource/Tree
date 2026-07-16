local var0_0 = class("AuctionGameMainNoticeBoardPlayer", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.itemViewList = {}
end

function var0_0.didEnter(arg0_3, arg1_3)
	arg0_3.index = arg1_3

	local var0_3 = getProxy(AuctionGameProxy)
	local var1_3 = var0_3:GetPlayerList()[arg1_3]

	setScrollText(arg0_3.uiNameText, var1_3.name)

	local var2_3 = Ship.New({
		configId = var1_3.icon,
		skin_id = var1_3.skinId
	})

	LoadSpriteAsync("qicon/" .. var2_3:getPrefab(), function(arg0_4)
		if not IsNil(arg0_3.uiIconImage) then
			arg0_3.uiIconImage.sprite = arg0_4
		end
	end)

	local var3_3 = AttireFrame.attireFrameRes(var1_3, false, AttireConst.TYPE_ICON_FRAME, var1_3.propose)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var3_3, var3_3, true, function(arg0_5)
		if IsNil(arg0_3.uiFrameGo) then
			return
		end

		if arg0_3.uiFrameGo then
			arg0_5.name = var3_3
			findTF(arg0_5.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0_5, tf(arg0_3.uiFrameGo), false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var3_3, var3_3, arg0_5)
		end
	end)

	local var4_3 = var0_3:GetRoundEventAndBidInfoList()

	for iter0_3 = 1, var0_3:GetRound() - 1 do
		local var5_3 = var4_3[iter0_3][var1_3.id]

		arg0_3.itemViewList[iter0_3] = AuctionGameMainNoticeBoardItem.New(Instantiate(arg0_3.uiItemTf, arg0_3._tf), arg0_3._parentClass)

		arg0_3.itemViewList[iter0_3]:didEnter(var5_3)
	end
end

function var0_0.willExit(arg0_6)
	if not IsNil(arg0_6.uiFrameGo) then
		local var0_6 = tf(arg0_6.uiFrameGo)

		if var0_6.childCount > 0 then
			local var1_6 = var0_6:GetChild(0)
			local var2_6 = var1_6.gameObject.name

			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var2_6, var2_6, var1_6.gameObject)
		end
	end

	for iter0_6, iter1_6 in ipairs(arg0_6.itemViewList) do
		iter1_6:willExit()
	end

	arg0_6.itemViewList = nil

	arg0_6:detach()
end

return var0_0
