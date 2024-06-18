local var0_0 = class("EducateCollectEntranceLayer", import("..base.EducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "EducateCollectEntranceUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.initData(arg0_3)
	local var0_3 = getProxy(EducateProxy)

	arg0_3.memories = var0_3:GetMemories()
	arg0_3.endings = var0_3:GetFinishEndings()
end

function var0_0.findUI(arg0_4)
	arg0_4.anim = arg0_4:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0_4.animEvent = arg0_4:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0_4.animEvent:SetEndEvent(function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end)

	arg0_4.contentTF = arg0_4:findTF("anim_root/content")
	arg0_4.memoryBtn = arg0_4:findTF("memory_btn", arg0_4.contentTF)
	arg0_4.polaroidBtn = arg0_4:findTF("polaroid_btn", arg0_4.contentTF)
	arg0_4.endingBtn = arg0_4:findTF("ending_btn", arg0_4.contentTF)
	arg0_4.reviewBtn = arg0_4:findTF("review_btn", arg0_4.contentTF)
end

function var0_0.addListener(arg0_6)
	onButton(arg0_6, arg0_6._tf, function()
		arg0_6:_close()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.memoryBtn, function()
		arg0_6:emit(var0_0.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateCollectMediatorTemplate,
			viewComponent = EducateMemoryLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.polaroidBtn, function()
		if isActive(arg0_6:findTF("lock", arg0_6.polaroidBtn)) then
			return
		end

		arg0_6:emit(var0_0.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateCollectMediatorTemplate,
			viewComponent = EducatePolaroidLayer
		}))
		setActive(arg0_6:findTF("new", arg0_6.polaroidBtn), false)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.endingBtn, function()
		if isActive(arg0_6:findTF("lock", arg0_6.endingBtn)) then
			return
		end

		arg0_6:emit(var0_0.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateCollectMediatorTemplate,
			viewComponent = EducateEndingLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.reviewBtn, function()
		arg0_6:emit(var0_0.ON_CLOSE)
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_MEMORTY,
			memoryGroup = EducateConst.REVIEW_GROUP_ID
		})
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_12)
	local var0_12 = #pg.child_memory.all

	setText(arg0_12:findTF("Text", arg0_12.memoryBtn), #arg0_12.memories .. "/" .. var0_12)
	arg0_12:updateMemoryTip()

	local var1_12, var2_12 = getProxy(EducateProxy):GetPolaroidGroupCnt()

	setText(arg0_12:findTF("Text", arg0_12.polaroidBtn), var1_12 .. "/" .. var2_12)
	setActive(arg0_12:findTF("lock", arg0_12.polaroidBtn), not EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_POLAROID))
	setActive(arg0_12:findTF("new", arg0_12.polaroidBtn), EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_POLAROID))

	local var3_12 = #pg.child_ending.all

	setText(arg0_12:findTF("unlock/Text", arg0_12.endingBtn), #arg0_12.endings .. "/" .. var3_12)

	local var4_12 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_ENDING) or #arg0_12.endings > 0

	setActive(arg0_12:findTF("unlock", arg0_12.endingBtn), var4_12)
	setActive(arg0_12:findTF("lock", arg0_12.endingBtn), not var4_12)
	pg.UIMgr.GetInstance():BlurPanel(arg0_12._tf)
	EducateGuideSequence.CheckGuide(arg0_12.__cname, function()
		return
	end)
end

function var0_0.updateMemoryTip(arg0_14)
	local var0_14 = underscore.any(pg.child_memory.all, function(arg0_15)
		return EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_MEMORY, arg0_15)
	end)

	setActive(arg0_14:findTF("new", arg0_14.memoryBtn), var0_14)
end

function var0_0._close(arg0_16)
	arg0_16.anim:Play("anim_educate_collectentrance_out")
end

function var0_0.onBackPressed(arg0_17)
	arg0_17:_close()
end

function var0_0.willExit(arg0_18)
	arg0_18.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_18._tf)
end

return var0_0
