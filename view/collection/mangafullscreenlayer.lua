local var0 = class("MangaFullScreenLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "MangaViewUI"
end

function var0.init(arg0)
	arg0:findUI()
	arg0:initData()
	arg0:addListener()
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:readManga()
	arg0:updatePicImg()
	arg0:updateLikeBtn()
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	arg0.resLoader:Clear()

	if arg0.contextData.mangaContext then
		local var0 = arg0.mangaIDLIst[arg0.curMangaIndex]

		arg0.contextData.mangaContext:updateToMangaID(var0)
	end
end

function var0.onBackPressed(arg0)
	if not arg0.isShowing then
		arg0:closeView()
	end
end

function var0.findUI(arg0)
	arg0.bg = arg0:findTF("BG")
	arg0.picImg = arg0:findTF("Manga/Pic")
	arg0.indexText = arg0:findTF("Manga/Index")
	arg0.preBtn = arg0:findTF("LeftBtn")
	arg0.rightBtn = arg0:findTF("RightBtn")
	arg0.tipText = arg0:findTF("Tip")
	arg0.likeOnBtn = arg0:findTF("Manga/LikeOn")
	arg0.likeOffBtn = arg0:findTF("Manga/LikeOff")

	setText(arg0.tipText, i18n("world_collection_back"))
end

function var0.initData(arg0)
	arg0.resLoader = AutoLoader.New()
	arg0.curMangaIndex = arg0.contextData.mangaIndex
	arg0.mangaIDLIst = arg0.contextData.mangaIDLIst
end

function var0.addListener(arg0)
	onButton(arg0, arg0.bg, function()
		if not arg0.isShowing then
			arg0:closeView()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.preBtn, function()
		if arg0.curMangaIndex > 1 then
			arg0.curMangaIndex = arg0.curMangaIndex - 1

			arg0:readManga()
			arg0:updatePicImg()
			arg0:updateLikeBtn()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.rightBtn, function()
		if arg0.curMangaIndex < #arg0.mangaIDLIst then
			arg0.curMangaIndex = arg0.curMangaIndex + 1

			arg0:readManga()
			arg0:updatePicImg()
			arg0:updateLikeBtn()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.likeOnBtn, function()
		local var0 = arg0.mangaIDLIst[arg0.curMangaIndex]

		pg.m02:sendNotification(GAME.APPRECIATE_MANGA_LIKE, {
			mangaID = var0,
			action = MangaConst.CANCEL_MANGA_LIKE
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.likeOffBtn, function()
		local var0 = arg0.mangaIDLIst[arg0.curMangaIndex]

		pg.m02:sendNotification(GAME.APPRECIATE_MANGA_LIKE, {
			mangaID = var0,
			action = MangaConst.SET_MANGA_LIKE
		})
	end, SFX_PANEL)
	addSlip(SLIP_TYPE_HRZ, arg0.picImg, function()
		triggerButton(arg0.preBtn)
	end, function()
		triggerButton(arg0.rightBtn)
	end)
	addSlip(SLIP_TYPE_HRZ, arg0.bg, function()
		triggerButton(arg0.preBtn)
	end, function()
		triggerButton(arg0.rightBtn)
	end)
end

function var0.updatePicImg(arg0)
	local var0 = arg0.mangaIDLIst[arg0.curMangaIndex]
	local var1 = pg.cartoon[var0].resource
	local var2 = MangaConst.MANGA_PATH_PREFIX .. var1

	arg0.resLoader:LoadSprite(var2, var1, arg0.picImg, false)

	local var3

	if arg0.contextData.isShowingNotRead then
		var3 = "#" .. pg.cartoon[var0].cartoon_id
	else
		var3 = "#" .. pg.cartoon[var0].cartoon_id .. "/" .. #arg0.mangaIDLIst
	end

	setText(arg0.indexText, var3)

	arg0.isShowing = true

	arg0:managedTween(LeanTween.value, nil, go(arg0.picImg), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0)
		setImageAlpha(arg0.picImg, arg0)
	end)):setOnComplete(System.Action(function()
		arg0.isShowing = false

		setImageAlpha(arg0.picImg, 1)
	end))
	setActive(arg0.preBtn, arg0.curMangaIndex > 1)
	setActive(arg0.rightBtn, arg0.curMangaIndex < #arg0.mangaIDLIst)
end

function var0.updateLikeBtn(arg0)
	local var0 = arg0.mangaIDLIst[arg0.curMangaIndex]
	local var1 = MangaConst.isMangaLikeByID(var0)

	setActive(arg0.likeOnBtn, var1)
	setActive(arg0.likeOffBtn, not var1)
end

function var0.readManga(arg0)
	local var0 = arg0.mangaIDLIst[arg0.curMangaIndex]

	if not MangaConst.isMangaEverReadByID(var0) then
		pg.m02:sendNotification(GAME.APPRECIATE_MANGA_READ, {
			mangaID = var0
		})
	end
end

return var0
