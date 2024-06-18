local var0_0 = class("EducateMemoryLayer", import(".EducateCollectLayerTemplate"))

function var0_0.getUIName(arg0_1)
	return "EducateMemoryUI"
end

function var0_0.initConfig(arg0_2)
	arg0_2.config = pg.child_memory
end

function var0_0.didEnter(arg0_3)
	setText(arg0_3:findTF("review_btn/Text", arg0_3.performTF), i18n("child_btn_review"))

	arg0_3.memories = getProxy(EducateProxy):GetMemories()

	setText(arg0_3.curCntTF, #arg0_3.memories)
	setText(arg0_3.allCntTF, "/" .. #arg0_3.config.all)
	arg0_3:updatePage()
end

function var0_0.updateItem(arg0_4, arg1_4, arg2_4)
	local var0_4 = table.contains(arg0_4.memories, arg1_4.id)

	setActive(arg0_4:findTF("lock", arg2_4), not var0_4)
	setActive(arg0_4:findTF("unlock", arg2_4), var0_4)
	setActive(arg0_4:findTF("unlock/new", arg2_4), EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_MEMORY, arg1_4.id))

	if var0_4 then
		LoadImageSpriteAsync("bg/" .. arg1_4.pic, arg0_4:findTF("unlock/mask/Image", arg2_4))
		setText(arg0_4:findTF("unlock/name", arg2_4), arg1_4.desc)
		onButton(arg0_4, arg2_4, function()
			arg0_4:showPerformWindow(arg1_4)
		end, SFX_PANEL)
	else
		removeOnButton(arg2_4)
		setText(arg0_4:findTF("lock/Text", arg2_4), i18n("child_collect_lock"))
	end
end

function var0_0.showPerformWindow(arg0_6, arg1_6)
	EducateTipHelper.ClearNewTip(EducateTipHelper.NEW_MEMORY, arg1_6.id)

	local var0_6 = arg0_6:findTF("Image", arg0_6.performTF)

	LoadImageSpriteAsync("bg/" .. arg1_6.pic, var0_6)
	setActive(arg0_6.performTF, true)
	onButton(arg0_6, var0_6, function()
		setActive(arg0_6.performTF, false)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6:findTF("review_btn", arg0_6.performTF), function()
		pg.PerformMgr.GetInstance():PlayOne(arg1_6.performance)
	end, SFX_PANEL)
end

function var0_0.playAnimChange(arg0_9)
	arg0_9.anim:Stop()
	arg0_9.anim:Play("anim_educate_memory_change")
end

function var0_0.playAnimClose(arg0_10)
	arg0_10.anim:Play("anim_educate_memory_out")
end

return var0_0
