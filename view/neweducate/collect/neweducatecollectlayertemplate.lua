local var0_0 = class("EducateCollectLayerTemplate", import("view.base.BaseUI"))

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
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:PlayAnimClose()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.nextBtn, function()
		arg0_3:PlayAnimChange()

		arg0_3.curPageIndex = arg0_3.curPageIndex + 1

		arg0_3:UpdatePage()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.lastBtn, function()
		arg0_3:PlayAnimChange()

		arg0_3.curPageIndex = arg0_3.curPageIndex - 1

		arg0_3:UpdatePage()
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_3._tf, {
		groupName = arg0_3:getGroupNameFromData(),
		weight = LayerWeightConst.SECOND_LAYER + 2
	})
end

function var0_0.InitPageInfo(arg0_8)
	arg0_8:initConfig()

	arg0_8.onePageCnt = arg0_8.pageTF.childCount
	arg0_8.pages = math.ceil(#arg0_8.allIds / arg0_8.onePageCnt)
	arg0_8.curPageIndex = 1
end

function var0_0.UpdatePage(arg0_9)
	setActive(arg0_9.nextBtn, arg0_9.pages ~= 1 and arg0_9.curPageIndex < arg0_9.pages)
	setActive(arg0_9.lastBtn, arg0_9.pages ~= 1 and arg0_9.curPageIndex > 1)
	setText(arg0_9.paginationTF, arg0_9.curPageIndex .. "/" .. arg0_9.pages)

	local var0_9 = (arg0_9.curPageIndex - 1) * arg0_9.onePageCnt

	for iter0_9 = 1, arg0_9.onePageCnt do
		local var1_9 = arg0_9:findTF("frame_" .. iter0_9, arg0_9.pageTF)
		local var2_9 = arg0_9.allIds[var0_9 + iter0_9]

		if var2_9 then
			setActive(var1_9, true)
			arg0_9:UpdateItem(var2_9, var1_9)
		else
			setActive(var1_9, false)
		end
	end
end

function var0_0.UpdateItem(arg0_10, arg1_10, arg2_10)
	assert(nil, "updateItem方法必须由子类实现")
end

function var0_0.PlayAnimChange(arg0_11)
	assert(nil, "playAnimClose方法必须由子类实现")
end

function var0_0.onBackPressed(arg0_12)
	arg0_12:PlayAnimClose()
end

function var0_0.willExit(arg0_13)
	arg0_13.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13._tf)
end

return var0_0
