local var0_0 = class("JiuJiuExpeditionCollectionLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "JiuJiuExpeditionCollectionUI"
end

function var0_0.SetData(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	arg0_2.allDatas = arg1_2
	arg0_2.completeDatas = arg2_2
	arg0_2.getRewardIndex = arg3_2
	arg0_2.gotRewardIndex = arg4_2
end

local function var1_0(arg0_3, arg1_3, arg2_3)
	return table.contains(arg0_3.completeDatas, arg2_3)
end

local var2_0 = 0
local var3_0 = 1
local var4_0 = 2

function var0_0.IsGotAward(arg0_4, arg1_4)
	if arg1_4 <= arg0_4.gotRewardIndex then
		return true
	end

	return false
end

function var0_0.GetAwardState(arg0_5, arg1_5)
	if arg1_5 > arg0_5.gotRewardIndex + 1 then
		return var2_0
	elseif arg1_5 <= arg0_5.gotRewardIndex then
		return var4_0
	elseif arg1_5 == arg0_5.gotRewardIndex + 1 and arg1_5 <= arg0_5.getRewardIndex then
		return var3_0
	else
		return var2_0
	end
end

function var0_0.init(arg0_6)
	arg0_6.bookContainer = arg0_6:findTF("books")
	arg0_6.book = arg0_6:findTF("book")
	arg0_6.nextPageBtn = arg0_6:findTF("book/next")
	arg0_6.prevPageBtn = arg0_6:findTF("book/prev")
	arg0_6.scoreList = UIItemList.New(arg0_6:findTF("book/list"), arg0_6:findTF("book/list/tpl"))
	arg0_6.getBtn = arg0_6:findTF("book/get")
	arg0_6.gotBtn = arg0_6:findTF("book/got")
	arg0_6.goBtn = arg0_6:findTF("book/go")
	arg0_6.books = {
		arg0_6:findTF("books/1"),
		arg0_6:findTF("books/2"),
		arg0_6:findTF("books/3")
	}
	arg0_6.parent = arg0_6._tf.parent

	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)
end

function var0_0.didEnter(arg0_7)
	onButton(arg0_7, arg0_7._tf, function()
		if arg0_7.isOpenBook then
			arg0_7:CloseBook()
		else
			arg0_7:emit(var0_0.ON_CLOSE)
		end
	end, SFX_CANCEL)
	arg0_7:InitBooks()
end

function var0_0.InitBooks(arg0_9)
	setActive(arg0_9.bookContainer, true)
	setActive(arg0_9.book, false)
	arg0_9:updateBooks()
	arg0_9:UpdateTip()
end

function var0_0.updateBooks(arg0_10)
	for iter0_10, iter1_10 in ipairs(arg0_10.books) do
		local var0_10 = iter0_10 <= arg0_10.gotRewardIndex + 1

		setActive(iter1_10:Find("lock"), not var0_10)

		iter1_10:GetComponent(typeof(Image)).color = var0_10 and Color.New(1, 1, 1, 1) or Color.New(0.46, 0.46, 0.46, 1)

		onButton(arg0_10, iter1_10, function()
			if var0_10 then
				arg0_10:OpenBook(iter0_10)
			else
				pg.TipsMgr:GetInstance():ShowTips(i18n("jiujiu_expedition_book_tip"))
			end
		end, SFX_PANEL)
	end
end

function var0_0.UpdateTip(arg0_12)
	for iter0_12, iter1_12 in ipairs(arg0_12.books) do
		local var0_12 = arg0_12:GetAwardState(iter0_12) == var3_0

		setActive(iter1_12:Find("tip"), var0_12)
	end
end

function var0_0.OpenBook(arg0_13, arg1_13)
	arg0_13.isOpenBook = true

	setActive(arg0_13.bookContainer, false)
	setActive(arg0_13.book, true)
	setActive(arg0_13.book:Find("1"), arg1_13 == 1)
	setActive(arg0_13.book:Find("2"), arg1_13 == 2)
	setActive(arg0_13.book:Find("3"), arg1_13 == 3)

	local var0_13 = arg0_13.allDatas[arg1_13]

	onButton(arg0_13, arg0_13.nextPageBtn, function()
		setActive(arg0_13.nextPageBtn, false)
		setActive(arg0_13.prevPageBtn, true)

		local var0_14 = _.slice(var0_13, 4, 2)

		arg0_13:UpdatePage(arg1_13, var0_14, 3)
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.prevPageBtn, function()
		setActive(arg0_13.nextPageBtn, true)
		setActive(arg0_13.prevPageBtn, false)

		local var0_15 = _.slice(var0_13, 1, 3)

		arg0_13:UpdatePage(arg1_13, var0_15, 0)
	end, SFX_PANEL)

	local var1_13 = arg0_13:GetAwardState(arg1_13)

	setActive(arg0_13.getBtn, var1_13 == var3_0)
	setActive(arg0_13.gotBtn, var1_13 == var4_0)
	setActive(arg0_13.goBtn, var1_13 == var2_0)
	onButton(arg0_13, arg0_13.getBtn, function()
		arg0_13:emit(JiuJiuExpeditionCollectionMediator.ON_GET, arg1_13)
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.goBtn, function()
		pg.TipsMgr:GetInstance():ShowTips(i18n("jiujiu_expedition_reward_tip"))
	end, SFX_PANEL)
	triggerButton(arg0_13.prevPageBtn)
end

function var0_0.UpdatePage(arg0_18, arg1_18, arg2_18, arg3_18)
	arg0_18.scoreList:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = arg2_18[arg1_19 + 1]
			local var1_19 = "JiuJiuExpeditionCollectionIcon/" .. arg1_18 .. "_" .. arg1_19 + 1 + arg3_18

			GetImageSpriteFromAtlasAsync(var1_19, "", arg2_19:Find("icon"))
			setActive(arg2_19:Find("lock"), not var1_0(arg0_18, arg1_18, var0_19))
		end
	end)
	arg0_18.scoreList:align(#arg2_18)
end

function var0_0.CloseBook(arg0_20)
	arg0_20.isOpenBook = false

	setActive(arg0_20.bookContainer, true)
	setActive(arg0_20.book, false)
end

function var0_0.willExit(arg0_21)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_21._tf, arg0_21.parent)
end

return var0_0
