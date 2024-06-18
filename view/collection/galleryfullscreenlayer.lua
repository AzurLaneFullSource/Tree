local var0_0 = class("GalleryFullScreenLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "GalleryViewUI"
end

function var0_0.init(arg0_2)
	arg0_2:findUI()
	arg0_2:initData()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_3._tf)
	arg0_3:updatePicImg()
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_4._tf)
end

function var0_0.onBackPressed(arg0_5)
	if not arg0_5.isShowing then
		arg0_5:closeView()
	end
end

function var0_0.findUI(arg0_6)
	arg0_6.bg = arg0_6:findTF("BG")
	arg0_6.picImg = arg0_6:findTF("Pic")
end

function var0_0.initData(arg0_7)
	arg0_7.picID = arg0_7.contextData.picID
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.bg, function()
		if not arg0_8.isShowing then
			arg0_8:closeView()
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.picImg, function()
		if not arg0_8.isShowing then
			arg0_8:closeView()
		end
	end, SFX_PANEL)
end

function var0_0.updatePicImg(arg0_11)
	local var0_11 = pg.gallery_config[arg0_11.picID].illustration
	local var1_11 = GalleryConst.PIC_PATH_PREFIX .. var0_11

	setImageSprite(arg0_11.picImg, LoadSprite(var1_11, var0_11))

	arg0_11.isShowing = true

	LeanTween.value(go(arg0_11.picImg), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0_12)
		setImageAlpha(arg0_11.picImg, arg0_12)
	end)):setOnComplete(System.Action(function()
		arg0_11.isShowing = false

		setImageAlpha(arg0_11.picImg, 1)
	end))
end

return var0_0
