local var0_0 = class("AppreciatePicFullScreenLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AppreciatePicFullScreenUI"
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
	return
end

function var0_0.initData(arg0_6)
	arg0_6.resLoader = AutoLoader.New()
	arg0_6.curPicInfo = arg0_6.contextData.curPicInfo
end

function var0_0.addListener(arg0_7)
	onButton(arg0_7, arg0_7.bg, function()
		arg0_7:closeView()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.galleryPicImg, function()
		arg0_7:closeView()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.mangaPicImg, function()
		arg0_7:closeView()
	end, SFX_PANEL)
end

function var0_0.updatePanel(arg0_11)
	setActive(arg0_11.galleryPanel, arg0_11.curPicInfo.type == AppreciatePicConst.TYPE_GALLERY)
	setActive(arg0_11.mangaPanel, arg0_11.curPicInfo.type == AppreciatePicConst.TYPE_MANGA)

	if arg0_11.curPicInfo.type == AppreciatePicConst.TYPE_GALLERY then
		arg0_11:updateGalleryPanel()
	elseif arg0_11.curPicInfo.type == AppreciatePicConst.TYPE_MANGA then
		arg0_11:updateMangaPanel()
	end
end

function var0_0.updateGalleryPanel(arg0_12)
	arg0_12:setImage(arg0_12.galleryPicImg, arg0_12.curPicInfo)
end

function var0_0.updateMangaPanel(arg0_13)
	arg0_13:setImage(arg0_13.mangaPicImg, arg0_13.curPicInfo)
end

function var0_0.setImage(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg2_14.path
	local var1_14 = GetFileName(var0_14)
	local var2_14 = GetComponent(arg1_14, typeof(Image)).sprite

	if not IsNil(var2_14) then
		local var3_14 = var2_14.name

		if string.lower(var3_14) ~= string.lower(var1_14) then
			arg0_14.resLoader:LoadSprite(var0_14, var1_14, arg1_14, false)
		end
	else
		arg0_14.resLoader:LoadSprite(var0_14, var1_14, arg1_14, false)
	end
end

return var0_0
