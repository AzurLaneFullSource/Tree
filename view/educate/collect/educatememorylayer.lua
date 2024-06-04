local var0 = class("EducateMemoryLayer", import(".EducateCollectLayerTemplate"))

function var0.getUIName(arg0)
	return "EducateMemoryUI"
end

function var0.initConfig(arg0)
	arg0.config = pg.child_memory
end

function var0.didEnter(arg0)
	setText(arg0:findTF("review_btn/Text", arg0.performTF), i18n("child_btn_review"))

	arg0.memories = getProxy(EducateProxy):GetMemories()

	setText(arg0.curCntTF, #arg0.memories)
	setText(arg0.allCntTF, "/" .. #arg0.config.all)
	arg0:updatePage()
end

function var0.updateItem(arg0, arg1, arg2)
	local var0 = table.contains(arg0.memories, arg1.id)

	setActive(arg0:findTF("lock", arg2), not var0)
	setActive(arg0:findTF("unlock", arg2), var0)
	setActive(arg0:findTF("unlock/new", arg2), EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_MEMORY, arg1.id))

	if var0 then
		LoadImageSpriteAsync("bg/" .. arg1.pic, arg0:findTF("unlock/mask/Image", arg2))
		setText(arg0:findTF("unlock/name", arg2), arg1.desc)
		onButton(arg0, arg2, function()
			arg0:showPerformWindow(arg1)
		end, SFX_PANEL)
	else
		removeOnButton(arg2)
		setText(arg0:findTF("lock/Text", arg2), i18n("child_collect_lock"))
	end
end

function var0.showPerformWindow(arg0, arg1)
	EducateTipHelper.ClearNewTip(EducateTipHelper.NEW_MEMORY, arg1.id)

	local var0 = arg0:findTF("Image", arg0.performTF)

	LoadImageSpriteAsync("bg/" .. arg1.pic, var0)
	setActive(arg0.performTF, true)
	onButton(arg0, var0, function()
		setActive(arg0.performTF, false)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("review_btn", arg0.performTF), function()
		pg.PerformMgr.GetInstance():PlayOne(arg1.performance)
	end, SFX_PANEL)
end

function var0.playAnimChange(arg0)
	arg0.anim:Stop()
	arg0.anim:Play("anim_educate_memory_change")
end

function var0.playAnimClose(arg0)
	arg0.anim:Play("anim_educate_memory_out")
end

return var0
