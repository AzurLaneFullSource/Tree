local var0_0 = class("NewEducateCollectLayerTemplate", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	assert(nil, "getUIName方法必须由子类实现")
end

function var0_0.getGroupName(arg0_2)
	return "NewEducateBaseUI"
end

function var0_0.initConfig(arg0_3)
	assert(nil, "initConfig方法必须由子类实现")
end

function var0_0.init(arg0_4)
	arg0_4.anim = arg0_4:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0_4.animEvent = arg0_4:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0_4.animEvent:SetEndEvent(function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end)

	arg0_4.closeBtn = arg0_4:findTF("anim_root/bg")
	arg0_4.windowTF = arg0_4:findTF("anim_root/window")
	arg0_4.curCntTF = arg0_4:findTF("collect/cur", arg0_4.windowTF)
	arg0_4.allCntTF = arg0_4:findTF("collect/all", arg0_4.windowTF)
	arg0_4.pageTF = arg0_4:findTF("page", arg0_4.windowTF)
	arg0_4.nextBtn = arg0_4:findTF("next_btn", arg0_4.windowTF)
	arg0_4.lastBtn = arg0_4:findTF("last_btn", arg0_4.windowTF)
	arg0_4.paginationTF = arg0_4:findTF("pagination", arg0_4.windowTF)
	arg0_4.performTF = arg0_4:findTF("anim_root/perform")

	setActive(arg0_4.performTF, false)
	onButton(arg0_4, arg0_4.closeBtn, function()
		arg0_4:PlayAnimClose()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.nextBtn, function()
		arg0_4:PlayAnimChange()

		arg0_4.curPageIndex = arg0_4.curPageIndex + 1

		arg0_4:UpdatePage()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.lastBtn, function()
		arg0_4:PlayAnimChange()

		arg0_4.curPageIndex = arg0_4.curPageIndex - 1

		arg0_4:UpdatePage()
	end, SFX_PANEL)
	arg0_4:OverlayPanel(arg0_4._tf, {
		groupDelta = 2
	})
end

function var0_0.InitPageInfo(arg0_9)
	arg0_9:initConfig()

	arg0_9.onePageCnt = arg0_9.pageTF.childCount
	arg0_9.pages = math.ceil(#arg0_9.allIds / arg0_9.onePageCnt)
	arg0_9.curPageIndex = 1
end

function var0_0.UpdatePage(arg0_10)
	setActive(arg0_10.nextBtn, arg0_10.pages ~= 1 and arg0_10.curPageIndex < arg0_10.pages)
	setActive(arg0_10.lastBtn, arg0_10.pages ~= 1 and arg0_10.curPageIndex > 1)
	setText(arg0_10.paginationTF, arg0_10.curPageIndex .. "/" .. arg0_10.pages)

	local var0_10 = (arg0_10.curPageIndex - 1) * arg0_10.onePageCnt

	for iter0_10 = 1, arg0_10.onePageCnt do
		local var1_10 = arg0_10:findTF("frame_" .. iter0_10, arg0_10.pageTF)
		local var2_10 = arg0_10.allIds[var0_10 + iter0_10]

		if var2_10 then
			setActive(var1_10, true)
			arg0_10:UpdateItem(var2_10, var1_10)
		else
			setActive(var1_10, false)
		end
	end
end

function var0_0.UpdateItem(arg0_11, arg1_11, arg2_11)
	assert(nil, "updateItem方法必须由子类实现")
end

function var0_0.PlayAnimChange(arg0_12)
	assert(nil, "playAnimClose方法必须由子类实现")
end

function var0_0.onBackPressed(arg0_13)
	arg0_13:PlayAnimClose()
end

function var0_0.willExit(arg0_14)
	arg0_14.animEvent:SetEndEvent(nil)
	arg0_14:UnOverlayPanel(arg0_14._tf)
end

return var0_0
