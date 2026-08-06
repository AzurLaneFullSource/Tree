local var0_0 = class("AppreciatePicViewLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AppreciatePicViewUI"
end

function var0_0.init(arg0_2)
	arg0_2:findUI()
	arg0_2:initData()
	arg0_2:addListener()
	arg0_2:updatePanel()
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_4._tf)
	arg0_4.resLoader:Clear()
end

function var0_0.findUI(arg0_5)
	setText(arg0_5.galleryPicSetLoadingTipText, i18n("loading_set_tip"))
	setText(arg0_5.mangaPicSetLoadingTipText, i18n("loading_set_tip"))
end

function var0_0.initData(arg0_6)
	arg0_6.resLoader = AutoLoader.New()
	arg0_6.curPicInfo = arg0_6.contextData.curPicInfo
	arg0_6.picInfoList = arg0_6.contextData.picInfoList
	arg0_6.isShowLikeBtn = arg0_6.contextData.isShowLikeBtn
	arg0_6.onPicSwitch = arg0_6.contextData.onPicSwitch
	arg0_6.curIndex = arg0_6:getPicInfoIndex(arg0_6.curPicInfo)
	arg0_6.loadingPicProxy = getProxy(LoadingPicProxy)

	arg0_6:addOpenList()
end

function var0_0.addListener(arg0_7)
	onButton(arg0_7, arg0_7.bg, function()
		arg0_7:closeView()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.galleryAddLoadingBtn, function()
		arg0_7:addLoadingPic(arg0_7.curPicInfo)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.galleryRemoveLoadingBtn, function()
		arg0_7:removeLoadingPic(arg0_7.curPicInfo)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.mangaAddLoadingBtn, function()
		arg0_7:addLoadingPic(arg0_7.curPicInfo)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.mangaRemoveLoadingBtn, function()
		arg0_7:removeLoadingPic(arg0_7.curPicInfo)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.galleryAddLikeBtn, function()
		arg0_7:addLike(arg0_7.curPicInfo)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.galleryRemoveLikeBtn, function()
		arg0_7:removeLike(arg0_7.curPicInfo)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.mangaAddLikeBtn, function()
		arg0_7:addLike(arg0_7.curPicInfo)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.mangaRemoveLikeBtn, function()
		arg0_7:removeLike(arg0_7.curPicInfo)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.galleryPicImg, function()
		arg0_7:openFullScreenLayer()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.mangaPicImg, function()
		arg0_7:openFullScreenLayer()
	end, SFX_PANEL)
	addSlip(SLIP_TYPE_HRZ, arg0_7.galleryPicImg, function()
		arg0_7:switchToPrePic()
	end, function()
		arg0_7:switchToNextPic()
	end)
	addSlip(SLIP_TYPE_HRZ, arg0_7.mangaPicImg, function()
		arg0_7:switchToPrePic()
	end, function()
		arg0_7:switchToNextPic()
	end)
	onButton(arg0_7, arg0_7.galleryLeftBtn, function()
		arg0_7:switchToPrePic()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.galleryRightBtn, function()
		arg0_7:switchToNextPic()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.mangaLeftBtn, function()
		arg0_7:switchToPrePic()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.mangaRightBtn, function()
		arg0_7:switchToNextPic()
	end, SFX_PANEL)
end

function var0_0.updatePanel(arg0_27)
	if arg0_27.curPicInfo.type == AppreciatePicConst.TYPE_GALLERY then
		arg0_27:updateGalleryPanel()
		arg0_27:setImage(arg0_27.galleryPicImg, arg0_27.curPicInfo)
		setActive(arg0_27.galleryPanel, true)
		setActive(arg0_27.mangaPanel, false)
	else
		arg0_27:updateMangaPanel()
		arg0_27:setImage(arg0_27.mangaPicImg, arg0_27.curPicInfo)
		setActive(arg0_27.galleryPanel, false)
		setActive(arg0_27.mangaPanel, true)
	end
end

function var0_0.updateGalleryPanel(arg0_28)
	arg0_28:setImage(arg0_28.galleryPicBG, arg0_28.curPicInfo)

	local var0_28 = arg0_28:isPicInfoUsed(arg0_28.curPicInfo)

	setActive(arg0_28.galleryAddLoadingBtn, not var0_28)
	setActive(arg0_28.galleryRemoveLoadingBtn, var0_28)

	local var1_28 = arg0_28:isPicInfoLiked(arg0_28.curPicInfo)
	local var2_28 = arg0_28.isShowLikeBtn

	setActive(arg0_28.galleryLikeBtn, var2_28)
	setActive(arg0_28.galleryAddLikeBtn, not var1_28)
	setActive(arg0_28.galleryRemoveLikeBtn, var1_28)
end

function var0_0.updateMangaPanel(arg0_29)
	arg0_29:setImage(arg0_29.mangaPicBG, arg0_29.curPicInfo)

	local var0_29 = arg0_29:isPicInfoUsed(arg0_29.curPicInfo)

	setActive(arg0_29.mangaAddLoadingBtn, not var0_29)
	setActive(arg0_29.mangaRemoveLoadingBtn, var0_29)

	local var1_29 = arg0_29:isPicInfoLiked(arg0_29.curPicInfo)
	local var2_29 = arg0_29.isShowLikeBtn

	setActive(arg0_29.mangaLikeBtn, var2_29)
	setActive(arg0_29.mangaAddLikeBtn, not var1_29)
	setActive(arg0_29.mangaRemoveLikeBtn, var1_29)
end

function var0_0.setImage(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg2_30.path
	local var1_30 = GetFileName(var0_30)
	local var2_30 = GetComponent(arg1_30, typeof(Image)).sprite

	if not IsNil(var2_30) then
		local var3_30 = var2_30.name

		if string.lower(var3_30) ~= string.lower(var1_30) then
			arg0_30.resLoader:LoadSprite(var0_30, var1_30, arg1_30, false)
		end
	else
		arg0_30.resLoader:LoadSprite(var0_30, var1_30, arg1_30, false)
	end

	setImageAlpha(arg1_30, 1)
end

function var0_0.openFullScreenLayer(arg0_31)
	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = AppreciatePicFullScreenMediator,
		viewComponent = AppreciatePicFullScreenLayer,
		data = {
			curPicInfo = arg0_31.curPicInfo
		}
	}))
end

function var0_0.switchToPrePic(arg0_32)
	if arg0_32.curIndex > 1 then
		arg0_32.curIndex = arg0_32.curIndex - 1
		arg0_32.curPicInfo = arg0_32.picInfoList[arg0_32.curIndex]

		arg0_32:updatePanel()
		existCall(arg0_32.onPicSwitch, arg0_32.curPicInfo)
	end
end

function var0_0.switchToNextPic(arg0_33)
	if arg0_33.curIndex < #arg0_33.picInfoList then
		arg0_33.curIndex = arg0_33.curIndex + 1
		arg0_33.curPicInfo = arg0_33.picInfoList[arg0_33.curIndex]

		arg0_33:updatePanel()
		existCall(arg0_33.onPicSwitch, arg0_33.curPicInfo)
	end
end

function var0_0.isPicInfoUsed(arg0_34, arg1_34)
	return AppreciatePicConst.isUsedPicInfo(arg1_34)
end

function var0_0.removeLoadingPic(arg0_35, arg1_35)
	local var0_35 = {}

	if arg1_35.type == AppreciatePicConst.TYPE_GALLERY then
		local var1_35 = arg0_35.loadingPicProxy:getGalleryPicIDList()

		for iter0_35, iter1_35 in ipairs(var1_35) do
			if iter1_35 == arg1_35.id then
				table.remove(var1_35, iter0_35)

				break
			end
		end

		var0_35.galleryPicIDList = var1_35
	elseif arg1_35.type == AppreciatePicConst.TYPE_MANGA then
		local var2_35 = arg0_35.loadingPicProxy:getMangaPicIDList()

		for iter2_35, iter3_35 in ipairs(var2_35) do
			if iter3_35 == arg1_35.id then
				table.remove(var2_35, iter2_35)

				break
			end
		end

		var0_35.mangaPicIDList = var2_35
	end

	pg.m02:sendNotification(GAME.UPDATE_LOADING_PIC, var0_35)
end

function var0_0.addLoadingPic(arg0_36, arg1_36)
	if arg0_36:isPicInfoUsed(arg1_36) then
		warning("already used.", arg1_36.type, arg1_36.id)

		return
	end

	local var0_36 = {}

	if arg1_36.type == AppreciatePicConst.TYPE_GALLERY then
		local var1_36 = arg0_36.loadingPicProxy:getGalleryPicIDList()

		table.insert(var1_36, arg1_36.id)

		var0_36.galleryPicIDList = var1_36
	elseif arg1_36.type == AppreciatePicConst.TYPE_MANGA then
		local var2_36 = arg0_36.loadingPicProxy:getMangaPicIDList()

		table.insert(var2_36, arg1_36.id)

		var0_36.mangaPicIDList = var2_36
	end

	pg.m02:sendNotification(GAME.UPDATE_LOADING_PIC, var0_36)
end

function var0_0.isPicInfoLiked(arg0_37, arg1_37)
	return AppreciatePicConst.isPicInfoLiked(arg1_37)
end

function var0_0.addLike(arg0_38, arg1_38)
	local var0_38 = {}

	if arg1_38.type == AppreciatePicConst.TYPE_GALLERY then
		var0_38.picID = arg1_38.id
		var0_38.isAdd = 0

		pg.m02:sendNotification(GAME.APPRECIATE_GALLERY_LIKE, var0_38)
	elseif arg1_38.type == AppreciatePicConst.TYPE_MANGA then
		var0_38.mangaID = arg1_38.id
		var0_38.action = 0

		pg.m02:sendNotification(GAME.APPRECIATE_MANGA_LIKE, var0_38)
	end
end

function var0_0.removeLike(arg0_39, arg1_39)
	local var0_39 = {}

	if arg1_39.type == AppreciatePicConst.TYPE_GALLERY then
		var0_39.picID = arg1_39.id
		var0_39.isAdd = 1

		pg.m02:sendNotification(GAME.APPRECIATE_GALLERY_LIKE, var0_39)
	elseif arg1_39.type == AppreciatePicConst.TYPE_MANGA then
		var0_39.mangaID = arg1_39.id
		var0_39.action = 1

		pg.m02:sendNotification(GAME.APPRECIATE_MANGA_LIKE, var0_39)
	end
end

function var0_0.addOpenList(arg0_40)
	if arg0_40.curPicInfo.type == AppreciatePicConst.TYPE_GALLERY then
		getProxy(LoadingPicProxy):addGalleryNewPicOpenList(arg0_40.curPicInfo.id)
	elseif arg0_40.curPicInfo.type == AppreciatePicConst.TYPE_MANGA then
		getProxy(LoadingPicProxy):addMangaNewPicOpenList(arg0_40.curPicInfo.id)
	end
end

function var0_0.getPicInfoIndex(arg0_41, arg1_41)
	for iter0_41, iter1_41 in ipairs(arg0_41.picInfoList) do
		if iter1_41.id == arg1_41.id and iter1_41.type == arg1_41.type then
			return iter0_41
		end
	end

	return nil
end

return var0_0
