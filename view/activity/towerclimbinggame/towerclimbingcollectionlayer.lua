local var0_0 = class("TowerClimbingCollectionLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "TowerClimbingCollectionUI"
end

function var0_0.SetData(arg0_2, arg1_2)
	arg0_2.miniGameData = arg1_2

	local var0_2 = arg0_2.miniGameData:GetRuntimeData("kvpElements")
	local var1_2, var2_2 = TowerClimbingGameView.GetTowerClimbingPageAndScore(var0_2)

	arg0_2.score = var1_2
	arg0_2.pageIndex = var2_2

	assert(var1_2)
	assert(var2_2)

	arg0_2.config = pg.mini_game[MiniGameDataCreator.TowerClimbingGameID].simple_config_data
end

local function var1_0(arg0_3, arg1_3, arg2_3)
	if arg1_3 < arg0_3.pageIndex then
		return true
	elseif arg1_3 == arg0_3.pageIndex then
		return arg2_3 <= arg0_3.score
	else
		return false
	end
end

local var2_0 = 0
local var3_0 = 1
local var4_0 = 2

function var0_0.IsGotAward(arg0_4, arg1_4)
	local var0_4 = arg0_4.miniGameData:GetRuntimeData("kvpElements")[1] or {}

	for iter0_4, iter1_4 in ipairs(var0_4) do
		if iter1_4.key == arg1_4 and iter1_4.value == 1 then
			return true
		end
	end

	return false
end

function var0_0.GetAwardState(arg0_5, arg1_5)
	local var0_5 = arg0_5.config[arg1_5][1]
	local var1_5 = var0_5[#var0_5]

	if arg1_5 < arg0_5.pageIndex then
		if arg0_5:IsGotAward(arg1_5) then
			return var4_0
		else
			return var3_0
		end
	elseif arg1_5 == arg0_5.pageIndex then
		local var2_5 = arg0_5:IsGotAward(arg1_5)

		if var2_5 then
			return var4_0
		elseif var1_5 <= arg0_5.score and not var2_5 then
			return var3_0
		elseif var1_5 > arg0_5.score then
			return var2_0
		end
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

	for iter0_9, iter1_9 in ipairs(arg0_9.books) do
		local var0_9 = iter0_9 <= arg0_9.pageIndex

		setActive(iter1_9:Find("lock"), not var0_9)

		iter1_9:GetComponent(typeof(Image)).color = var0_9 and Color.New(1, 1, 1, 1) or Color.New(0.46, 0.46, 0.46, 1)

		onButton(arg0_9, iter1_9, function()
			if var0_9 then
				arg0_9:OpenBook(iter0_9)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("towerclimbing_book_tip"))
			end
		end, SFX_PANEL)
	end

	arg0_9:UpdateTip()
end

function var0_0.UpdateTip(arg0_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.books) do
		local var0_11 = arg0_11:GetAwardState(iter0_11) == var3_0

		setActive(iter1_11:Find("tip"), var0_11)
	end
end

function var0_0.OpenBook(arg0_12, arg1_12)
	arg0_12.isOpenBook = true

	setActive(arg0_12.bookContainer, false)
	setActive(arg0_12.book, true)
	setActive(arg0_12.book:Find("1"), arg1_12 == 1)
	setActive(arg0_12.book:Find("2"), arg1_12 == 2)
	setActive(arg0_12.book:Find("3"), arg1_12 == 3)

	local var0_12 = arg0_12.config[arg1_12][1]

	onButton(arg0_12, arg0_12.nextPageBtn, function()
		setActive(arg0_12.nextPageBtn, false)
		setActive(arg0_12.prevPageBtn, true)

		local var0_13 = _.slice(var0_12, 4, 2)

		arg0_12:UpdatePage(arg1_12, var0_13, 3)
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.prevPageBtn, function()
		setActive(arg0_12.nextPageBtn, true)
		setActive(arg0_12.prevPageBtn, false)

		local var0_14 = _.slice(var0_12, 1, 3)

		arg0_12:UpdatePage(arg1_12, var0_14, 0)
	end, SFX_PANEL)

	local var1_12 = arg0_12:GetAwardState(arg1_12)

	setActive(arg0_12.getBtn, var1_12 == var3_0)
	setActive(arg0_12.gotBtn, var1_12 == var4_0)
	setActive(arg0_12.goBtn, var1_12 == var2_0)
	onButton(arg0_12, arg0_12.getBtn, function()
		arg0_12:emit(TowerClimbingCollectionMediator.ON_GET, arg1_12)
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.goBtn, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("towerclimbing_reward_tip"))
	end, SFX_PANEL)
	triggerButton(arg0_12.prevPageBtn)
end

function var0_0.UpdatePage(arg0_17, arg1_17, arg2_17, arg3_17)
	arg0_17.scoreList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			local var0_18 = arg2_17[arg1_18 + 1]
			local var1_18 = "TowerClimbingCollectionIcon/" .. arg1_17 .. "_" .. arg1_18 + 1 + arg3_17

			GetImageSpriteFromAtlasAsync(var1_18, "", arg2_18:Find("icon"))
			setActive(arg2_18:Find("lock"), not var1_0(arg0_17, arg1_17, var0_18))
		end
	end)
	arg0_17.scoreList:align(#arg2_17)
end

function var0_0.CloseBook(arg0_19)
	arg0_19.isOpenBook = false

	setActive(arg0_19.bookContainer, true)
	setActive(arg0_19.book, false)
end

function var0_0.willExit(arg0_20)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_20._tf, arg0_20.parent)
end

return var0_0
