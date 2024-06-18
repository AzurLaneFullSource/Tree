local var0_0 = class("EducateCollectLayerTemplate", import("..base.EducateBaseUI"))

function var0_0.getUIName(arg0_1)
	assert(nil, "getUIName方法必须由子类实现")
end

function var0_0.initConfig(arg0_2)
	assert(nil, "initConfig方法必须由子类实现")
end

function var0_0.init(arg0_3)
	arg0_3.anim = arg0_3:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0_3.animEvent = arg0_3:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0_3.animEvent:SetEndEvent(function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end)

	arg0_3.closeBtn = arg0_3:findTF("anim_root/bg")
	arg0_3.windowTF = arg0_3:findTF("anim_root/window")
	arg0_3.curCntTF = arg0_3:findTF("collect/cur", arg0_3.windowTF)
	arg0_3.allCntTF = arg0_3:findTF("collect/all", arg0_3.windowTF)
	arg0_3.pageTF = arg0_3:findTF("page", arg0_3.windowTF)
	arg0_3.nextBtn = arg0_3:findTF("next_btn", arg0_3.windowTF)
	arg0_3.lastBtn = arg0_3:findTF("last_btn", arg0_3.windowTF)
	arg0_3.paginationTF = arg0_3:findTF("pagination", arg0_3.windowTF)
	arg0_3.performTF = arg0_3:findTF("anim_root/perform")

	setActive(arg0_3.performTF, false)
	arg0_3:initConfig()

	arg0_3.onePageCnt = arg0_3.pageTF.childCount
	arg0_3.pages = math.ceil(#arg0_3.config.all / arg0_3.onePageCnt)
	arg0_3.curPageIndex = 1

	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:playAnimClose()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.nextBtn, function()
		arg0_3:playAnimChange()

		arg0_3.curPageIndex = arg0_3.curPageIndex + 1

		arg0_3:updatePage()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.lastBtn, function()
		arg0_3:playAnimChange()

		arg0_3.curPageIndex = arg0_3.curPageIndex - 1

		arg0_3:updatePage()
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_3._tf, {
		groupName = arg0_3:getGroupNameFromData(),
		weight = arg0_3:getWeightFromData() + 2
	})
end

function var0_0.updatePage(arg0_8)
	setActive(arg0_8.nextBtn, arg0_8.pages ~= 1 and arg0_8.curPageIndex < arg0_8.pages)
	setActive(arg0_8.lastBtn, arg0_8.pages ~= 1 and arg0_8.curPageIndex > 1)
	setText(arg0_8.paginationTF, arg0_8.curPageIndex .. "/" .. arg0_8.pages)

	local var0_8 = (arg0_8.curPageIndex - 1) * arg0_8.onePageCnt

	for iter0_8 = 1, arg0_8.onePageCnt do
		local var1_8 = arg0_8:findTF("frame_" .. iter0_8, arg0_8.pageTF)
		local var2_8 = arg0_8.config[arg0_8.config.all[var0_8 + iter0_8]]

		if var2_8 then
			setActive(var1_8, true)
			arg0_8:updateItem(var2_8, var1_8)
		else
			setActive(var1_8, false)
		end
	end
end

function var0_0.updateItem(arg0_9, arg1_9, arg2_9)
	assert(nil, "updateItem方法必须由子类实现")
end

function var0_0.playAnimChange(arg0_10)
	assert(nil, "playAnimClose方法必须由子类实现")
end

function var0_0.playAnimClose(arg0_11)
	assert(nil, "playAnimClose方法必须由子类实现")
end

function var0_0.onBackPressed(arg0_12)
	arg0_12:playAnimClose()
end

function var0_0.willExit(arg0_13)
	arg0_13.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13._tf)
end

return var0_0
