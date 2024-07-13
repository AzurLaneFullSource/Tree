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
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf)
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
	arg0_6.bg = arg0_6:findTF("BG")
	arg0_6.picImg = arg0_6:findTF("Manga/Pic")
	arg0_6.indexText = arg0_6:findTF("Manga/Index")
	arg0_6.preBtn = arg0_6:findTF("LeftBtn")
	arg0_6.rightBtn = arg0_6:findTF("RightBtn")
	arg0_6.tipText = arg0_6:findTF("Tip")
	arg0_6.likeOnBtn = arg0_6:findTF("Manga/LikeOn")
	arg0_6.likeOffBtn = arg0_6:findTF("Manga/LikeOff")

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
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.rightBtn, function()
		if arg0_8.curMangaIndex < #arg0_8.mangaIDLIst then
			arg0_8.curMangaIndex = arg0_8.curMangaIndex + 1

			arg0_8:readManga()
			arg0_8:updatePicImg()
			arg0_8:updateLikeBtn()
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
end

function var0_0.updatePicImg(arg0_18)
	local var0_18 = arg0_18.mangaIDLIst[arg0_18.curMangaIndex]
	local var1_18 = pg.cartoon[var0_18].resource
	local var2_18 = MangaConst.MANGA_PATH_PREFIX .. var1_18

	arg0_18.resLoader:LoadSprite(var2_18, var1_18, arg0_18.picImg, false)

	local var3_18

	if arg0_18.contextData.isShowingNotRead then
		var3_18 = "#" .. pg.cartoon[var0_18].cartoon_id
	else
		var3_18 = "#" .. pg.cartoon[var0_18].cartoon_id .. "/" .. #arg0_18.mangaIDLIst
	end

	setText(arg0_18.indexText, var3_18)

	arg0_18.isShowing = true

	arg0_18:managedTween(LeanTween.value, nil, go(arg0_18.picImg), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0_19)
		setImageAlpha(arg0_18.picImg, arg0_19)
	end)):setOnComplete(System.Action(function()
		arg0_18.isShowing = false

		setImageAlpha(arg0_18.picImg, 1)
	end))
	setActive(arg0_18.preBtn, arg0_18.curMangaIndex > 1)
	setActive(arg0_18.rightBtn, arg0_18.curMangaIndex < #arg0_18.mangaIDLIst)
end

function var0_0.updateLikeBtn(arg0_21)
	local var0_21 = arg0_21.mangaIDLIst[arg0_21.curMangaIndex]
	local var1_21 = MangaConst.isMangaLikeByID(var0_21)

	setActive(arg0_21.likeOnBtn, var1_21)
	setActive(arg0_21.likeOffBtn, not var1_21)
end

function var0_0.readManga(arg0_22)
	local var0_22 = arg0_22.mangaIDLIst[arg0_22.curMangaIndex]

	if not MangaConst.isMangaEverReadByID(var0_22) then
		pg.m02:sendNotification(GAME.APPRECIATE_MANGA_READ, {
			mangaID = var0_22
		})
	end
end

return var0_0
