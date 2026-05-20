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

function var0_0.updatePanel(arg0_23)
	if arg0_23.curPicInfo.type == AppreciatePicConst.TYPE_GALLERY then
		arg0_23:updateGalleryPanel()
		arg0_23:setImage(arg0_23.galleryPicImg, arg0_23.curPicInfo)
		setActive(arg0_23.galleryPanel, true)
		setActive(arg0_23.mangaPanel, false)
	else
		arg0_23:updateMangaPanel()
		arg0_23:setImage(arg0_23.mangaPicImg, arg0_23.curPicInfo)
		setActive(arg0_23.galleryPanel, false)
		setActive(arg0_23.mangaPanel, true)
	end
end

function var0_0.updateGalleryPanel(arg0_24)
	arg0_24:setImage(arg0_24.galleryPicBG, arg0_24.curPicInfo)

	local var0_24 = arg0_24:isPicInfoUsed(arg0_24.curPicInfo)

	setActive(arg0_24.galleryAddLoadingBtn, not var0_24)
	setActive(arg0_24.galleryRemoveLoadingBtn, var0_24)
end

function var0_0.updateMangaPanel(arg0_25)
	arg0_25:setImage(arg0_25.mangaPicBG, arg0_25.curPicInfo)

	local var0_25 = arg0_25:isPicInfoUsed(arg0_25.curPicInfo)

	setActive(arg0_25.mangaAddLoadingBtn, not var0_25)
	setActive(arg0_25.mangaRemoveLoadingBtn, var0_25)
end

function var0_0.setImage(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg2_26.path
	local var1_26 = GetFileName(var0_26)
	local var2_26 = GetComponent(arg1_26, typeof(Image)).sprite

	if not IsNil(var2_26) then
		local var3_26 = var2_26.name

		if string.lower(var3_26) ~= string.lower(var1_26) then
			arg0_26.resLoader:LoadSprite(var0_26, var1_26, arg1_26, false)
		end
	else
		arg0_26.resLoader:LoadSprite(var0_26, var1_26, arg1_26, false)
	end

	setImageAlpha(arg1_26, 1)
end

function var0_0.openFullScreenLayer(arg0_27)
	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = AppreciatePicFullScreenMediator,
		viewComponent = AppreciatePicFullScreenLayer,
		data = {
			curPicInfo = arg0_27.curPicInfo
		}
	}))
end

function var0_0.switchToPrePic(arg0_28)
	if arg0_28.curIndex > 1 then
		arg0_28.curIndex = arg0_28.curIndex - 1
		arg0_28.curPicInfo = arg0_28.picInfoList[arg0_28.curIndex]

		arg0_28:updatePanel()
	end
end

function var0_0.switchToNextPic(arg0_29)
	if arg0_29.curIndex < #arg0_29.picInfoList then
		arg0_29.curIndex = arg0_29.curIndex + 1
		arg0_29.curPicInfo = arg0_29.picInfoList[arg0_29.curIndex]

		arg0_29:updatePanel()
	end
end

function var0_0.isPicInfoUsed(arg0_30, arg1_30)
	return AppreciatePicConst.isUsedPicInfo(arg1_30)
end

function var0_0.removeLoadingPic(arg0_31, arg1_31)
	local var0_31 = {}

	if arg1_31.type == AppreciatePicConst.TYPE_GALLERY then
		local var1_31 = arg0_31.loadingPicProxy:getGalleryPicIDList()

		for iter0_31, iter1_31 in ipairs(var1_31) do
			if iter1_31 == arg1_31.id then
				table.remove(var1_31, iter0_31)

				break
			end
		end

		var0_31.galleryPicIDList = var1_31
	elseif arg1_31.type == AppreciatePicConst.TYPE_MANGA then
		local var2_31 = arg0_31.loadingPicProxy:getMangaPicIDList()

		for iter2_31, iter3_31 in ipairs(var2_31) do
			if iter3_31 == arg1_31.id then
				table.remove(var2_31, iter2_31)

				break
			end
		end

		var0_31.mangaPicIDList = var2_31
	end

	pg.m02:sendNotification(GAME.UPDATE_LOADING_PIC, var0_31)
end

function var0_0.addLoadingPic(arg0_32, arg1_32)
	if arg0_32:isPicInfoUsed(arg1_32) then
		warning("already used.", arg1_32.type, arg1_32.id)

		return
	end

	local var0_32 = {}

	if arg1_32.type == AppreciatePicConst.TYPE_GALLERY then
		local var1_32 = arg0_32.loadingPicProxy:getGalleryPicIDList()

		table.insert(var1_32, arg1_32.id)

		var0_32.galleryPicIDList = var1_32
	elseif arg1_32.type == AppreciatePicConst.TYPE_MANGA then
		local var2_32 = arg0_32.loadingPicProxy:getMangaPicIDList()

		table.insert(var2_32, arg1_32.id)

		var0_32.mangaPicIDList = var2_32
	end

	pg.m02:sendNotification(GAME.UPDATE_LOADING_PIC, var0_32)
end

function var0_0.addOpenList(arg0_33)
	if arg0_33.curPicInfo.type == AppreciatePicConst.TYPE_GALLERY then
		getProxy(LoadingPicProxy):addGalleryNewPicOpenList(arg0_33.curPicInfo.id)
	elseif arg0_33.curPicInfo.type == AppreciatePicConst.TYPE_MANGA then
		getProxy(LoadingPicProxy):addMangaNewPicOpenList(arg0_33.curPicInfo.id)
	end
end

function var0_0.getPicInfoIndex(arg0_34, arg1_34)
	for iter0_34, iter1_34 in ipairs(arg0_34.picInfoList) do
		if iter1_34.id == arg1_34.id and iter1_34.type == arg1_34.type then
			return iter0_34
		end
	end

	return nil
end

return var0_0
