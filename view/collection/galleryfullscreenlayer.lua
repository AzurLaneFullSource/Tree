local var0 = class("GalleryFullScreenLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "GalleryViewUI"
end

function var0.init(arg0)
	arg0:findUI()
	arg0:initData()
	arg0:addListener()
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)
	arg0:updatePicImg()
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

function var0.onBackPressed(arg0)
	if not arg0.isShowing then
		arg0:closeView()
	end
end

function var0.findUI(arg0)
	arg0.bg = arg0:findTF("BG")
	arg0.picImg = arg0:findTF("Pic")
end

function var0.initData(arg0)
	arg0.picID = arg0.contextData.picID
end

function var0.addListener(arg0)
	onButton(arg0, arg0.bg, function()
		if not arg0.isShowing then
			arg0:closeView()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.picImg, function()
		if not arg0.isShowing then
			arg0:closeView()
		end
	end, SFX_PANEL)
end

function var0.updatePicImg(arg0)
	local var0 = pg.gallery_config[arg0.picID].illustration
	local var1 = GalleryConst.PIC_PATH_PREFIX .. var0

	setImageSprite(arg0.picImg, LoadSprite(var1, var0))

	arg0.isShowing = true

	LeanTween.value(go(arg0.picImg), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0)
		setImageAlpha(arg0.picImg, arg0)
	end)):setOnComplete(System.Action(function()
		arg0.isShowing = false

		setImageAlpha(arg0.picImg, 1)
	end))
end

return var0
