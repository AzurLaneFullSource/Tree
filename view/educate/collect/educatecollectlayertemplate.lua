local var0 = class("EducateCollectLayerTemplate", import("..base.EducateBaseUI"))

function var0.getUIName(arg0)
	assert(nil, "getUIName方法必须由子类实现")
end

function var0.initConfig(arg0)
	assert(nil, "initConfig方法必须由子类实现")
end

function var0.init(arg0)
	arg0.anim = arg0:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0.animEvent = arg0:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0.animEvent:SetEndEvent(function()
		arg0:emit(var0.ON_CLOSE)
	end)

	arg0.closeBtn = arg0:findTF("anim_root/bg")
	arg0.windowTF = arg0:findTF("anim_root/window")
	arg0.curCntTF = arg0:findTF("collect/cur", arg0.windowTF)
	arg0.allCntTF = arg0:findTF("collect/all", arg0.windowTF)
	arg0.pageTF = arg0:findTF("page", arg0.windowTF)
	arg0.nextBtn = arg0:findTF("next_btn", arg0.windowTF)
	arg0.lastBtn = arg0:findTF("last_btn", arg0.windowTF)
	arg0.paginationTF = arg0:findTF("pagination", arg0.windowTF)
	arg0.performTF = arg0:findTF("anim_root/perform")

	setActive(arg0.performTF, false)
	arg0:initConfig()

	arg0.onePageCnt = arg0.pageTF.childCount
	arg0.pages = math.ceil(#arg0.config.all / arg0.onePageCnt)
	arg0.curPageIndex = 1

	onButton(arg0, arg0.closeBtn, function()
		arg0:playAnimClose()
	end, SFX_PANEL)
	onButton(arg0, arg0.nextBtn, function()
		arg0:playAnimChange()

		arg0.curPageIndex = arg0.curPageIndex + 1

		arg0:updatePage()
	end, SFX_PANEL)
	onButton(arg0, arg0.lastBtn, function()
		arg0:playAnimChange()

		arg0.curPageIndex = arg0.curPageIndex - 1

		arg0:updatePage()
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		groupName = arg0:getGroupNameFromData(),
		weight = arg0:getWeightFromData() + 2
	})
end

function var0.updatePage(arg0)
	setActive(arg0.nextBtn, arg0.pages ~= 1 and arg0.curPageIndex < arg0.pages)
	setActive(arg0.lastBtn, arg0.pages ~= 1 and arg0.curPageIndex > 1)
	setText(arg0.paginationTF, arg0.curPageIndex .. "/" .. arg0.pages)

	local var0 = (arg0.curPageIndex - 1) * arg0.onePageCnt

	for iter0 = 1, arg0.onePageCnt do
		local var1 = arg0:findTF("frame_" .. iter0, arg0.pageTF)
		local var2 = arg0.config[arg0.config.all[var0 + iter0]]

		if var2 then
			setActive(var1, true)
			arg0:updateItem(var2, var1)
		else
			setActive(var1, false)
		end
	end
end

function var0.updateItem(arg0, arg1, arg2)
	assert(nil, "updateItem方法必须由子类实现")
end

function var0.playAnimChange(arg0)
	assert(nil, "playAnimClose方法必须由子类实现")
end

function var0.playAnimClose(arg0)
	assert(nil, "playAnimClose方法必须由子类实现")
end

function var0.onBackPressed(arg0)
	arg0:playAnimClose()
end

function var0.willExit(arg0)
	arg0.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

return var0
