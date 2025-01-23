local var0_0 = class("NewEducateCollectEntranceLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewEducateCollectEntranceUI"
end

function var0_0.init(arg0_2)
	arg0_2.anim = arg0_2._tf:Find("anim_root"):GetComponent(typeof(Animation))
	arg0_2.animEvent = arg0_2._tf:Find("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0_2.animEvent:SetEndEvent(function()
		arg0_2:emit(var0_0.ON_CLOSE)
	end)

	arg0_2.contentTF = arg0_2._tf:Find("anim_root/content")
	arg0_2.contentTF.offsetMin = Vector2(arg0_2.contextData.isSelect and 208 or 0, 0)
	arg0_2.contentTF.offsetMax = Vector2(0, 0)
	arg0_2.memoryBtn = arg0_2.contentTF:Find("memory_btn")
	arg0_2.polaroidBtn = arg0_2.contentTF:Find("polaroid_btn")
	arg0_2.endingBtn = arg0_2.contentTF:Find("ending_btn")
	arg0_2.reviewBtn = arg0_2.contentTF:Find("review_btn")
	arg0_2.leftTF = arg0_2._tf:Find("anim_root/left")
	arg0_2.togglesTF = arg0_2.leftTF:Find("toggles")
	arg0_2.ids = {
		0
	}
	arg0_2.ids = table.mergeArray(arg0_2.ids, pg.child2_data.all)
	arg0_2.toggleList = UIItemList.New(arg0_2.togglesTF, arg0_2.togglesTF:Find("tpl"))
end

function var0_0.didEnter(arg0_4)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
	onButton(arg0_4, arg0_4._tf, function()
		arg0_4:_close()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.memoryBtn, function()
		if arg0_4.contextData.id == 0 then
			arg0_4:emit(NewEducateCollectEntranceMediator.GO_SUBLAYER, Context.New({
				mediator = EducateCollectMediatorTemplate,
				viewComponent = EducateMemoryLayer
			}))
		else
			arg0_4:emit(NewEducateCollectEntranceMediator.GO_SUBLAYER, Context.New({
				mediator = NewEducateCollectMediatorTemplate,
				viewComponent = NewEducateMemoryLayer,
				data = {
					permanentData = arg0_4.permanentData
				}
			}))
		end
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.polaroidBtn, function()
		if arg0_4.contextData.id == 0 then
			if isActive(arg0_4.polaroidBtn:Find("lock")) then
				return
			end

			arg0_4:emit(NewEducateCollectEntranceMediator.GO_SUBLAYER, Context.New({
				mediator = EducateCollectMediatorTemplate,
				viewComponent = EducatePolaroidLayer
			}))
			setActive(arg0_4.polaroidBtn:Find("new"), false)
		else
			arg0_4:emit(NewEducateCollectEntranceMediator.GO_SUBLAYER, Context.New({
				mediator = NewEducateCollectMediatorTemplate,
				viewComponent = NewEducatePolaroidLayer,
				data = {
					permanentData = arg0_4.permanentData
				}
			}))
		end
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.endingBtn:Find("unlock"), function()
		if arg0_4.contextData.id == 0 then
			if isActive(arg0_4.endingBtn:Find("lock")) then
				return
			end

			arg0_4:emit(NewEducateCollectEntranceMediator.GO_SUBLAYER, Context.New({
				mediator = EducateCollectMediatorTemplate,
				viewComponent = EducateEndingLayer
			}))
		else
			arg0_4:emit(NewEducateCollectEntranceMediator.GO_SUBLAYER, Context.New({
				mediator = NewEducateCollectMediatorTemplate,
				viewComponent = NewEducateEndingLayer,
				data = {
					permanentData = arg0_4.permanentData
				}
			}))
		end
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.reviewBtn, function()
		if arg0_4.contextData.id == 0 then
			arg0_4:emit(var0_0.ON_CLOSE)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
				page = WorldMediaCollectionScene.PAGE_MEMORTY,
				memoryGroup = EducateConst.REVIEW_GROUP_ID
			})
		else
			local var0_9 = pg.child2_data[arg0_4.contextData.id].memory_group

			arg0_4:emit(var0_0.ON_CLOSE)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
				page = WorldMediaCollectionScene.PAGE_MEMORTY,
				memoryGroup = var0_9
			})
		end
	end, SFX_PANEL)
	arg0_4.toggleList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventInit then
			local var0_10 = arg0_4.ids[arg1_10 + 1]

			arg2_10.name = var0_10

			local var1_10 = var0_10 == 0 and "linghangyuan1_1" or pg.child2_data[var0_10].head

			LoadImageSpriteAsync("qicon/" .. var1_10, arg2_10:Find("icon"))
			onToggle(arg0_4, arg2_10, function(arg0_11)
				if arg0_11 then
					arg0_4.contextData.id = var0_10

					if arg0_4.contextData.id == 0 then
						arg0_4:FlushTBView()
					else
						arg0_4:FlushView(arg0_4.contextData.id)
					end
				end
			end, SFX_PANEL)
		end
	end)
	arg0_4.toggleList:align(#arg0_4.ids)
	setActive(arg0_4.leftTF, arg0_4.contextData.isSelect)

	if arg0_4.contextData.isSelect then
		triggerToggle(arg0_4.togglesTF:Find(tostring(arg0_4.contextData.id)), true)
	else
		arg0_4:FlushView(arg0_4.contextData.id)
	end
end

function var0_0.FlushView(arg0_12, arg1_12)
	arg0_12.permanentData = getProxy(NewEducateProxy):GetChar(arg1_12):GetPermanentData()

	local var0_12 = #arg0_12.permanentData:GetUnlockMemoryIds()
	local var1_12 = #arg0_12.permanentData:GetAllMemoryIds()

	setText(arg0_12.memoryBtn:Find("Text"), var0_12 .. "/" .. var1_12)
	setActive(arg0_12.memoryBtn:Find("new"), false)

	local var2_12 = #arg0_12.permanentData:GetUnlockPolaroidGroups()
	local var3_12 = #arg0_12.permanentData:GetAllPolaroidGroups()

	setActive(arg0_12.polaroidBtn:Find("lock"), false)
	setText(arg0_12.polaroidBtn:Find("Text"), var2_12 .. "/" .. var3_12)
	setActive(arg0_12.polaroidBtn:Find("new"), false)

	local var4_12 = #arg0_12.permanentData:GetActivatedEndings()
	local var5_12 = #arg0_12.permanentData:GetAllEndingIds()

	setText(arg0_12.endingBtn:Find("unlock/Text"), var4_12 .. "/" .. var5_12)

	local var6_12 = NewEducateConst.LOCK_ENDING and arg0_12.permanentData:GetGameCnt()

	setActive(arg0_12.endingBtn:Find("unlock"), not var6_12)
	setActive(arg0_12.endingBtn:Find("lock"), var6_12)
end

function var0_0.FlushTBView(arg0_13)
	local var0_13 = getProxy(EducateProxy)
	local var1_13 = var0_13:GetMemories()
	local var2_13 = var0_13:GetFinishEndings()
	local var3_13 = #pg.child_memory.all

	setText(arg0_13.memoryBtn:Find("Text"), #var1_13 .. "/" .. var3_13)
	arg0_13:UpdateMemoryTip()

	local var4_13, var5_13 = var0_13:GetPolaroidGroupCnt()

	setText(arg0_13.polaroidBtn:Find("Text"), var4_13 .. "/" .. var5_13)
	setActive(arg0_13.polaroidBtn:Find("lock"), not EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_POLAROID))
	setActive(arg0_13.polaroidBtn:Find("new"), EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_POLAROID))

	local var6_13 = #pg.child_ending.all

	setText(arg0_13.endingBtn:Find("unlock/Text"), #var2_13 .. "/" .. var6_13)

	local var7_13 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_ENDING) or #var2_13 > 0

	setActive(arg0_13.endingBtn:Find("unlock"), var7_13)
	setActive(arg0_13.endingBtn:Find("lock"), not var7_13)
end

function var0_0.UpdateMemoryTip(arg0_14)
	local var0_14 = underscore.any(pg.child_memory.all, function(arg0_15)
		return EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_MEMORY, arg0_15)
	end)

	setActive(arg0_14.memoryBtn:Find("new"), var0_14)
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
