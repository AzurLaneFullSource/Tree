local var0 = class("EducateCollectEntranceLayer", import("..base.EducateBaseUI"))

function var0.getUIName(arg0)
	return "EducateCollectEntranceUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.initData(arg0)
	local var0 = getProxy(EducateProxy)

	arg0.memories = var0:GetMemories()
	arg0.endings = var0:GetFinishEndings()
end

function var0.findUI(arg0)
	arg0.anim = arg0:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0.animEvent = arg0:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0.animEvent:SetEndEvent(function()
		arg0:emit(var0.ON_CLOSE)
	end)

	arg0.contentTF = arg0:findTF("anim_root/content")
	arg0.memoryBtn = arg0:findTF("memory_btn", arg0.contentTF)
	arg0.polaroidBtn = arg0:findTF("polaroid_btn", arg0.contentTF)
	arg0.endingBtn = arg0:findTF("ending_btn", arg0.contentTF)
	arg0.reviewBtn = arg0:findTF("review_btn", arg0.contentTF)
end

function var0.addListener(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:_close()
	end, SFX_PANEL)
	onButton(arg0, arg0.memoryBtn, function()
		arg0:emit(var0.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateCollectMediatorTemplate,
			viewComponent = EducateMemoryLayer
		}))
	end, SFX_PANEL)
	onButton(arg0, arg0.polaroidBtn, function()
		if isActive(arg0:findTF("lock", arg0.polaroidBtn)) then
			return
		end

		arg0:emit(var0.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateCollectMediatorTemplate,
			viewComponent = EducatePolaroidLayer
		}))
		setActive(arg0:findTF("new", arg0.polaroidBtn), false)
	end, SFX_PANEL)
	onButton(arg0, arg0.endingBtn, function()
		if isActive(arg0:findTF("lock", arg0.endingBtn)) then
			return
		end

		arg0:emit(var0.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateCollectMediatorTemplate,
			viewComponent = EducateEndingLayer
		}))
	end, SFX_PANEL)
	onButton(arg0, arg0.reviewBtn, function()
		arg0:emit(var0.ON_CLOSE)
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_MEMORTY,
			memoryGroup = EducateConst.REVIEW_GROUP_ID
		})
	end, SFX_PANEL)
end

function var0.didEnter(arg0)
	local var0 = #pg.child_memory.all

	setText(arg0:findTF("Text", arg0.memoryBtn), #arg0.memories .. "/" .. var0)
	arg0:updateMemoryTip()

	local var1, var2 = getProxy(EducateProxy):GetPolaroidGroupCnt()

	setText(arg0:findTF("Text", arg0.polaroidBtn), var1 .. "/" .. var2)
	setActive(arg0:findTF("lock", arg0.polaroidBtn), not EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_POLAROID))
	setActive(arg0:findTF("new", arg0.polaroidBtn), EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_POLAROID))

	local var3 = #pg.child_ending.all

	setText(arg0:findTF("unlock/Text", arg0.endingBtn), #arg0.endings .. "/" .. var3)

	local var4 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_ENDING) or #arg0.endings > 0

	setActive(arg0:findTF("unlock", arg0.endingBtn), var4)
	setActive(arg0:findTF("lock", arg0.endingBtn), not var4)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	EducateGuideSequence.CheckGuide(arg0.__cname, function()
		return
	end)
end

function var0.updateMemoryTip(arg0)
	local var0 = underscore.any(pg.child_memory.all, function(arg0)
		return EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_MEMORY, arg0)
	end)

	setActive(arg0:findTF("new", arg0.memoryBtn), var0)
end

function var0._close(arg0)
	arg0.anim:Play("anim_educate_collectentrance_out")
end

function var0.onBackPressed(arg0)
	arg0:_close()
end

function var0.willExit(arg0)
	arg0.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
