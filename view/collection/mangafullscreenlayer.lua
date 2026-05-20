local var0_0 = class("MangaFullScreenLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "MangaViewUI"
end

function var0_0.init(arg0_2)
	arg0_2:findUI()
	arg0_2:initData()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
	arg0_3:readManga()
	arg0_3:updatePicImg()
	arg0_3:updateLikeBtn()
	arg0_3:updateLoadingBtn()
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_4._tf)
	arg0_4.resLoader:Clear()

	if arg0_4.contextData.mangaContext then
		local var0_4 = arg0_4.mangaIDLIst[arg0_4.curMangaIndex]

		arg0_4.contextData.mangaContext:updateToMangaID(var0_4)
	end
end

function var0_0.onBackPressed(arg0_5)
	if not arg0_5.isShowing then
		arg0_5:closeView()
	end
end

function var0_0.findUI(arg0_6)
	arg0_6.bg = arg0_6._tf:Find("BG")
	arg0_6.picImg = arg0_6._tf:Find("Manga/Pic")
	arg0_6.indexText = arg0_6._tf:Find("Manga/Index")
	arg0_6.preBtn = arg0_6._tf:Find("LeftBtn")
	arg0_6.rightBtn = arg0_6._tf:Find("RightBtn")
	arg0_6.tipText = arg0_6._tf:Find("Tip")
	arg0_6.likeOnBtn = arg0_6._tf:Find("Manga/LikeOn")
	arg0_6.likeOffBtn = arg0_6._tf:Find("Manga/LikeOff")
	arg0_6.addLoadingBtn = arg0_6._tf:Find("Manga/LoadingBtn/Off")
	arg0_6.removeLoadingBtn = arg0_6._tf:Find("Manga/LoadingBtn/On")

	setText(arg0_6.tipText, i18n("world_collection_back"))
end

function var0_0.initData(arg0_7)
	arg0_7.resLoader = AutoLoader.New()
	arg0_7.curMangaIndex = arg0_7.contextData.mangaIndex
	arg0_7.mangaIDLIst = arg0_7.contextData.mangaIDLIst
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.bg, function()
		if not arg0_8.isShowing then
			arg0_8:closeView()
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.preBtn, function()
		if arg0_8.curMangaIndex > 1 then
			arg0_8.curMangaIndex = arg0_8.curMangaIndex - 1

			arg0_8:readManga()
			arg0_8:updatePicImg()
			arg0_8:updateLikeBtn()
			arg0_8:updateLoadingBtn()
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.rightBtn, function()
		if arg0_8.curMangaIndex < #arg0_8.mangaIDLIst then
			arg0_8.curMangaIndex = arg0_8.curMangaIndex + 1

			arg0_8:readManga()
			arg0_8:updatePicImg()
			arg0_8:updateLikeBtn()
			arg0_8:updateLoadingBtn()
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.likeOnBtn, function()
		local var0_12 = arg0_8.mangaIDLIst[arg0_8.curMangaIndex]

		pg.m02:sendNotification(GAME.APPRECIATE_MANGA_LIKE, {
			mangaID = var0_12,
			action = MangaConst.CANCEL_MANGA_LIKE
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.likeOffBtn, function()
		local var0_13 = arg0_8.mangaIDLIst[arg0_8.curMangaIndex]

		pg.m02:sendNotification(GAME.APPRECIATE_MANGA_LIKE, {
			mangaID = var0_13,
			action = MangaConst.SET_MANGA_LIKE
		})
	end, SFX_PANEL)
	addSlip(SLIP_TYPE_HRZ, arg0_8.picImg, function()
		triggerButton(arg0_8.preBtn)
	end, function()
		triggerButton(arg0_8.rightBtn)
	end)
	addSlip(SLIP_TYPE_HRZ, arg0_8.bg, function()
		triggerButton(arg0_8.preBtn)
	end, function()
		triggerButton(arg0_8.rightBtn)
	end)
	onButton(arg0_8, arg0_8.addLoadingBtn, function()
		arg0_8:addLoadingPic(arg0_8.mangaIDLIst[arg0_8.curMangaIndex])
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.removeLoadingBtn, function()
		arg0_8:removeLoadingPic(arg0_8.mangaIDLIst[arg0_8.curMangaIndex])
	end, SFX_PANEL)
end

function var0_0.updatePicImg(arg0_20)
	local var0_20 = arg0_20.mangaIDLIst[arg0_20.curMangaIndex]
	local var1_20 = pg.cartoon[var0_20].resource
	local var2_20 = MangaConst.MANGA_PATH_PREFIX .. var1_20

	arg0_20.resLoader:LoadSprite(var2_20, var1_20, arg0_20.picImg, false)

	local var3_20

	if arg0_20.contextData.isShowingNotRead then
		var3_20 = "#" .. pg.cartoon[var0_20].cartoon_id
	else
		var3_20 = "#" .. pg.cartoon[var0_20].cartoon_id .. "/" .. #arg0_20.mangaIDLIst
	end

	setText(arg0_20.indexText, var3_20)

	arg0_20.isShowing = true

	arg0_20:managedTween(LeanTween.value, nil, go(arg0_20.picImg), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0_21)
		setImageAlpha(arg0_20.picImg, arg0_21)
	end)):setOnComplete(System.Action(function()
		arg0_20.isShowing = false

		setImageAlpha(arg0_20.picImg, 1)
	end))
	setActive(arg0_20.preBtn, arg0_20.curMangaIndex > 1)
	setActive(arg0_20.rightBtn, arg0_20.curMangaIndex < #arg0_20.mangaIDLIst)
end

function var0_0.updateLikeBtn(arg0_23)
	local var0_23 = arg0_23.mangaIDLIst[arg0_23.curMangaIndex]
	local var1_23 = MangaConst.isMangaLikeByID(var0_23)

	setActive(arg0_23.likeOnBtn, var1_23)
	setActive(arg0_23.likeOffBtn, not var1_23)
end

function var0_0.updateLoadingBtn(arg0_24)
	local var0_24 = arg0_24.mangaIDLIst[arg0_24.curMangaIndex]
	local var1_24 = arg0_24:isPicUsed(var0_24)

	setActive(arg0_24.addLoadingBtn, not var1_24)
	setActive(arg0_24.removeLoadingBtn, var1_24)
end

function var0_0.readManga(arg0_25)
	local var0_25 = arg0_25.mangaIDLIst[arg0_25.curMangaIndex]

	if not MangaConst.isMangaEverReadByID(var0_25) then
		pg.m02:sendNotification(GAME.APPRECIATE_MANGA_READ, {
			mangaID = var0_25
		})
	end
end

function var0_0.isPicUsed(arg0_26, arg1_26)
	return table.contains(getProxy(LoadingPicProxy):getMangaPicIDList(true), arg1_26)
end

function var0_0.removeLoadingPic(arg0_27, arg1_27)
	local var0_27 = {}
	local var1_27 = getProxy(LoadingPicProxy):getMangaPicIDList()

	for iter0_27, iter1_27 in ipairs(var1_27) do
		if iter1_27 == arg1_27 then
			table.remove(var1_27, iter0_27)

			break
		end
	end

	var0_27.mangaPicIDList = var1_27

	pg.m02:sendNotification(GAME.UPDATE_LOADING_PIC, var0_27)
end

function var0_0.addLoadingPic(arg0_28, arg1_28)
	if arg0_28:isPicUsed(arg1_28) then
		warning("already used.", arg1_28)

		return
	end

	local var0_28 = {}
	local var1_28 = getProxy(LoadingPicProxy):getMangaPicIDList()

	table.insert(var1_28, arg1_28)

	var0_28.mangaPicIDList = var1_28

	pg.m02:sendNotification(GAME.UPDATE_LOADING_PIC, var0_28)
end

return var0_0
