local var0 = class("TowerClimbingCollectionLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "TowerClimbingCollectionUI"
end

function var0.SetData(arg0, arg1)
	arg0.miniGameData = arg1

	local var0 = arg0.miniGameData:GetRuntimeData("kvpElements")
	local var1, var2 = TowerClimbingGameView.GetTowerClimbingPageAndScore(var0)

	arg0.score = var1
	arg0.pageIndex = var2

	assert(var1)
	assert(var2)

	arg0.config = pg.mini_game[MiniGameDataCreator.TowerClimbingGameID].simple_config_data
end

local function var1(arg0, arg1, arg2)
	if arg1 < arg0.pageIndex then
		return true
	elseif arg1 == arg0.pageIndex then
		return arg2 <= arg0.score
	else
		return false
	end
end

local var2 = 0
local var3 = 1
local var4 = 2

function var0.IsGotAward(arg0, arg1)
	local var0 = arg0.miniGameData:GetRuntimeData("kvpElements")[1] or {}

	for iter0, iter1 in ipairs(var0) do
		if iter1.key == arg1 and iter1.value == 1 then
			return true
		end
	end

	return false
end

function var0.GetAwardState(arg0, arg1)
	local var0 = arg0.config[arg1][1]
	local var1 = var0[#var0]

	if arg1 < arg0.pageIndex then
		if arg0:IsGotAward(arg1) then
			return var4
		else
			return var3
		end
	elseif arg1 == arg0.pageIndex then
		local var2 = arg0:IsGotAward(arg1)

		if var2 then
			return var4
		elseif var1 <= arg0.score and not var2 then
			return var3
		elseif var1 > arg0.score then
			return var2
		end
	else
		return var2
	end
end

function var0.init(arg0)
	arg0.bookContainer = arg0:findTF("books")
	arg0.book = arg0:findTF("book")
	arg0.nextPageBtn = arg0:findTF("book/next")
	arg0.prevPageBtn = arg0:findTF("book/prev")
	arg0.scoreList = UIItemList.New(arg0:findTF("book/list"), arg0:findTF("book/list/tpl"))
	arg0.getBtn = arg0:findTF("book/get")
	arg0.gotBtn = arg0:findTF("book/got")
	arg0.goBtn = arg0:findTF("book/go")
	arg0.books = {
		arg0:findTF("books/1"),
		arg0:findTF("books/2"),
		arg0:findTF("books/3")
	}
	arg0.parent = arg0._tf.parent

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf, function()
		if arg0.isOpenBook then
			arg0:CloseBook()
		else
			arg0:emit(var0.ON_CLOSE)
		end
	end, SFX_CANCEL)
	arg0:InitBooks()
end

function var0.InitBooks(arg0)
	setActive(arg0.bookContainer, true)
	setActive(arg0.book, false)

	for iter0, iter1 in ipairs(arg0.books) do
		local var0 = iter0 <= arg0.pageIndex

		setActive(iter1:Find("lock"), not var0)

		iter1:GetComponent(typeof(Image)).color = var0 and Color.New(1, 1, 1, 1) or Color.New(0.46, 0.46, 0.46, 1)

		onButton(arg0, iter1, function()
			if var0 then
				arg0:OpenBook(iter0)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("towerclimbing_book_tip"))
			end
		end, SFX_PANEL)
	end

	arg0:UpdateTip()
end

function var0.UpdateTip(arg0)
	for iter0, iter1 in ipairs(arg0.books) do
		local var0 = arg0:GetAwardState(iter0) == var3

		setActive(iter1:Find("tip"), var0)
	end
end

function var0.OpenBook(arg0, arg1)
	arg0.isOpenBook = true

	setActive(arg0.bookContainer, false)
	setActive(arg0.book, true)
	setActive(arg0.book:Find("1"), arg1 == 1)
	setActive(arg0.book:Find("2"), arg1 == 2)
	setActive(arg0.book:Find("3"), arg1 == 3)

	local var0 = arg0.config[arg1][1]

	onButton(arg0, arg0.nextPageBtn, function()
		setActive(arg0.nextPageBtn, false)
		setActive(arg0.prevPageBtn, true)

		local var0 = _.slice(var0, 4, 2)

		arg0:UpdatePage(arg1, var0, 3)
	end, SFX_PANEL)
	onButton(arg0, arg0.prevPageBtn, function()
		setActive(arg0.nextPageBtn, true)
		setActive(arg0.prevPageBtn, false)

		local var0 = _.slice(var0, 1, 3)

		arg0:UpdatePage(arg1, var0, 0)
	end, SFX_PANEL)

	local var1 = arg0:GetAwardState(arg1)

	setActive(arg0.getBtn, var1 == var3)
	setActive(arg0.gotBtn, var1 == var4)
	setActive(arg0.goBtn, var1 == var2)
	onButton(arg0, arg0.getBtn, function()
		arg0:emit(TowerClimbingCollectionMediator.ON_GET, arg1)
	end, SFX_PANEL)
	onButton(arg0, arg0.goBtn, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("towerclimbing_reward_tip"))
	end, SFX_PANEL)
	triggerButton(arg0.prevPageBtn)
end

function var0.UpdatePage(arg0, arg1, arg2, arg3)
	arg0.scoreList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg2[arg1 + 1]
			local var1 = "TowerClimbingCollectionIcon/" .. arg1 .. "_" .. arg1 + 1 + arg3

			GetImageSpriteFromAtlasAsync(var1, "", arg2:Find("icon"))
			setActive(arg2:Find("lock"), not var1(arg0, arg1, var0))
		end
	end)
	arg0.scoreList:align(#arg2)
end

function var0.CloseBook(arg0)
	arg0.isOpenBook = false

	setActive(arg0.bookContainer, true)
	setActive(arg0.book, false)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0.parent)
end

return var0
