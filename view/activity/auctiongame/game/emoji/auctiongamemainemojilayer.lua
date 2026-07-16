local var0_0 = class("AuctionGameMainEmojiLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AuctionGameMainEmojiUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiSwitchBtn, function()
		arg0_2:emit(AuctionGameMainEmojiMediator.ON_CLICK_EMOJI_SWITCH, arg0_2.switchOn)
	end, SFX_PANEL)

	arg0_2.uiScrollView = LuaList.New(arg0_2, handler(arg0_2, arg0_2.IndexItem), arg0_2.uiList, AuctionGameMainEmojiListItem)

	arg0_2.uiScrollView:SetPageChangeHandler(handler(arg0_2, arg0_2.OnPageChange))

	arg0_2.dotItemList = {}

	setText(arg0_2.uiSwitchText, i18n("auction_block_emoji"))
end

function var0_0.didEnter(arg0_5)
	arg0_5:GetEmojiList()

	arg0_5.pageIndex = 1

	for iter0_5 = 1, #arg0_5.emojiList do
		arg0_5.dotItemList[iter0_5] = AuctionGameMainEmojiDotItem.New(Instantiate(arg0_5.uiDotItem, arg0_5.uiDotParent), arg0_5)
	end

	arg0_5:OnPageChange(arg0_5.pageIndex)
	arg0_5.uiScrollView:StartScroll(#arg0_5.emojiList)
	arg0_5:OnRefreshSwitchEmojiBtn()
end

function var0_0.OnPageChange(arg0_6, arg1_6)
	arg0_6.pageIndex = arg1_6

	for iter0_6 = 1, #arg0_6.emojiList do
		arg0_6.dotItemList[iter0_6]:didEnter(iter0_6 == arg1_6)
	end
end

function var0_0.IndexItem(arg0_7, arg1_7, arg2_7)
	arg2_7:didEnter(arg0_7.emojiList[arg1_7])
end

function var0_0.GetEmojiList(arg0_8)
	arg0_8.emojiList = {}

	local var0_8 = {}
	local var1_8 = getProxy(EmojiProxy)

	for iter0_8, iter1_8 in ipairs(pg.emoji_template.get_id_list_by_auction[1]) do
		table.insert(var0_8, iter1_8)
	end

	for iter2_8, iter3_8 in ipairs(var0_8) do
		local var2_8 = math.ceil(iter2_8 / 8)

		arg0_8.emojiList[var2_8] = arg0_8.emojiList[var2_8] or {}

		table.insert(arg0_8.emojiList[var2_8], iter3_8)
	end
end

function var0_0.OnRefreshSwitchEmojiBtn(arg0_9)
	local var0_9 = getProxy(AuctionGameProxy):GetSwitchEmojiFlag()

	setActive(arg0_9.uiSelectedGo, var0_9 == 1)
end

function var0_0.willExit(arg0_10)
	arg0_10.uiScrollView:Dispose()

	arg0_10.uiScrollView = nil

	for iter0_10, iter1_10 in ipairs(arg0_10.dotItemList) do
		iter1_10:willExit()
	end

	arg0_10.dotItemList = nil
end

return var0_0
