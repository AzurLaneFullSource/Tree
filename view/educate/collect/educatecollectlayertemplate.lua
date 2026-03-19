local var0_0 = class("EducateCollectLayerTemplate", import("..base.EducateBaseUI"))

function var0_0.getUIName(arg0_1)
	assert(nil, "getUIName方法必须由子类实现")
end

function var0_0.initConfig(arg0_2)
	assert(nil, "initConfig方法必须由子类实现")
end

function var0_0.init(arg0_3)
	arg0_3.anim = arg0_3._tf:Find("anim_root"):GetComponent(typeof(Animation))
	arg0_3.animEvent = arg0_3._tf:Find("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0_3.animEvent:SetEndEvent(function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end)

	arg0_3.closeBtn = arg0_3._tf:Find("anim_root/bg")
	arg0_3.windowTF = arg0_3._tf:Find("anim_root/window")
	arg0_3.curCntTF = arg0_3.windowTF:Find("collect/cur")
	arg0_3.allCntTF = arg0_3.windowTF:Find("collect/all")
	arg0_3.pageTF = arg0_3.windowTF:Find("page")
	arg0_3.nextBtn = arg0_3.windowTF:Find("next_btn")
	arg0_3.lastBtn = arg0_3.windowTF:Find("last_btn")
	arg0_3.paginationTF = arg0_3.windowTF:Find("pagination")
	arg0_3.performTF = arg0_3._tf:Find("anim_root/perform")

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
	arg0_3:OverlayPanel(arg0_3._tf, {
		groupDelta = 2
	})
	eachChild(arg0_3.pageTF, function(arg0_8)
		local var0_8 = arg0_8:Find("lock/unlock_btn/Text")

		var0_8:GetComponent("RichText"):AddSprite("gold", arg0_3._tf:Find("res/gold"):GetComponent(typeof(Image)).sprite)
		setText(var0_8, i18n("child_could_buy"))
	end)
end

function var0_0.updatePage(arg0_9)
	setActive(arg0_9.nextBtn, arg0_9.pages ~= 1 and arg0_9.curPageIndex < arg0_9.pages)
	setActive(arg0_9.lastBtn, arg0_9.pages ~= 1 and arg0_9.curPageIndex > 1)
	setText(arg0_9.paginationTF, arg0_9.curPageIndex .. "/" .. arg0_9.pages)

	local var0_9 = (arg0_9.curPageIndex - 1) * arg0_9.onePageCnt

	for iter0_9 = 1, arg0_9.onePageCnt do
		local var1_9 = arg0_9.pageTF:Find("frame_" .. iter0_9)
		local var2_9 = arg0_9.config[arg0_9.config.all[var0_9 + iter0_9]]

		if var2_9 then
			setActive(var1_9, true)
			arg0_9:updateItem(var2_9, var1_9)
		else
			setActive(var1_9, false)
		end
	end
end

function var0_0.updateItem(arg0_10, arg1_10, arg2_10)
	assert(nil, "updateItem方法必须由子类实现")
end

function var0_0.playAnimChange(arg0_11)
	assert(nil, "playAnimClose方法必须由子类实现")
end

function var0_0.playAnimClose(arg0_12)
	assert(nil, "playAnimClose方法必须由子类实现")
end

function var0_0.onBackPressed(arg0_13)
	arg0_13:playAnimClose()
end

function var0_0.willExit(arg0_14)
	arg0_14.animEvent:SetEndEvent(nil)
	arg0_14:UnOverlayPanel(arg0_14._tf)
end

return var0_0
