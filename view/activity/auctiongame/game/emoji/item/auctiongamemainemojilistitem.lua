local var0_0 = class("AuctionGameMainEmojiListItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.itemList = {}
end

function var0_0.didEnter(arg0_3, arg1_3)
	for iter0_3 = 1, #arg1_3 do
		arg0_3.itemList[iter0_3] = arg0_3.itemList[iter0_3] or AuctionGameMainEmojiItem.New(Instantiate(arg0_3.uiEmojiItem, arg0_3._tf), arg0_3)

		arg0_3.itemList[iter0_3]:didEnter(arg1_3[iter0_3])
	end

	for iter1_3 = #arg1_3 + 1, #arg0_3.itemList do
		arg0_3.itemList[iter1_3]:Show(false)
	end
end

function var0_0.willExit(arg0_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.itemList) do
		iter1_4:willExit()
	end

	arg0_4.itemList = nil

	arg0_4:detach()
end

return var0_0
