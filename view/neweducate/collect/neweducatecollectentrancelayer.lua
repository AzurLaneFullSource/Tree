local var0_0 = class("NewEducateCollectEntranceLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewEducateCollectEntranceUI"
end

function var0_0.getGroupName(arg0_2)
	return "NewEducateBaseUI"
end

function var0_0.init(arg0_3)
	arg0_3.anim = arg0_3._tf:Find("anim_root"):GetComponent(typeof(Animation))
	arg0_3.animEvent = arg0_3._tf:Find("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0_3.animEvent:SetEndEvent(function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end)

	arg0_3.contentTF = arg0_3._tf:Find("anim_root/content")
	arg0_3.contentTF.offsetMin = Vector2(arg0_3.contextData.isSelect and 208 or 0, 0)
	arg0_3.contentTF.offsetMax = Vector2(0, 0)
	arg0_3.memoryBtn = arg0_3.contentTF:Find("memory_btn")
	arg0_3.polaroidBtn = arg0_3.contentTF:Find("polaroid_btn")
	arg0_3.endingBtn = arg0_3.contentTF:Find("ending_btn")
	arg0_3.reviewBtn = arg0_3.contentTF:Find("review_btn")
	arg0_3.leftTF = arg0_3._tf:Find("anim_root/left")
	arg0_3.togglesTF = arg0_3.leftTF:Find("toggles")
	arg0_3.ids = {
		0
	}
	arg0_3.ids = table.mergeArray(arg0_3.ids, pg.child2_data.all)
	arg0_3.toggleList = UIItemList.New(arg0_3.togglesTF, arg0_3.togglesTF:Find("tpl"))
end

function var0_0.didEnter(arg0_5)
	arg0_5:BlurPanel(arg0_5._tf)
	onButton(arg0_5, arg0_5._tf, function()
		arg0_5:_close()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.memoryBtn, function()
		if arg0_5.contextData.id == 0 then
			arg0_5:emit(NewEducateCollectEntranceMediator.GO_SUBLAYER, Context.New({
				mediator = EducateCollectMediatorTemplate,
				viewComponent = EducateMemoryLayer
			}))
		else
			arg0_5:emit(NewEducateCollectEntranceMediator.GO_SUBLAYER, Context.New({
				mediator = NewEducateCollectMediatorTemplate,
				viewComponent = NewEducateMemoryLayer,
				data = {
					permanentData = arg0_5.permanentData
				}
			}))
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.polaroidBtn, function()
		if arg0_5.contextData.id == 0 then
			if isActive(arg0_5.polaroidBtn:Find("lock")) then
				return
			end

			arg0_5:emit(NewEducateCollectEntranceMediator.GO_SUBLAYER, Context.New({
				mediator = EducateCollectMediatorTemplate,
				viewComponent = EducatePolaroidLayer
			}))
			setActive(arg0_5.polaroidBtn:Find("new"), false)
		else
			arg0_5:emit(NewEducateCollectEntranceMediator.GO_SUBLAYER, Context.New({
				mediator = NewEducateCollectMediatorTemplate,
				viewComponent = NewEducatePolaroidLayer,
				data = {
					permanentData = arg0_5.permanentData
				}
			}))
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.endingBtn:Find("unlock"), function()
		if arg0_5.contextData.id == 0 then
			if isActive(arg0_5.endingBtn:Find("lock")) then
				return
			end

			arg0_5:emit(NewEducateCollectEntranceMediator.GO_SUBLAYER, Context.New({
				mediator = EducateCollectMediatorTemplate,
				viewComponent = EducateEndingLayer
			}))
		else
			arg0_5:emit(NewEducateCollectEntranceMediator.GO_SUBLAYER, Context.New({
				mediator = NewEducateCollectMediatorTemplate,
				viewComponent = NewEducateEndingLayer,
				data = {
					permanentData = arg0_5.permanentData
				}
			}))
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.reviewBtn, function()
		if arg0_5.contextData.id == 0 then
			arg0_5:emit(var0_0.ON_CLOSE)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
				page = WorldMediaCollectionScene.PAGE_MEMORTY,
				memoryGroup = EducateConst.REVIEW_GROUP_ID
			})
		else
			local var0_10 = pg.child2_data[arg0_5.contextData.id].memory_group

			arg0_5:emit(var0_0.ON_CLOSE)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
				page = WorldMediaCollectionScene.PAGE_MEMORTY,
				memoryGroup = var0_10
			})
		end
	end, SFX_PANEL)
	arg0_5.toggleList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventInit then
			local var0_11 = arg0_5.ids[arg1_11 + 1]

			arg2_11.name = var0_11

			local var1_11 = var0_11 == 0 and "linghangyuan1_1" or pg.child2_data[var0_11].head

			LoadImageSpriteAsync("qicon/" .. var1_11, arg2_11:Find("icon"))
			onToggle(arg0_5, arg2_11, function(arg0_12)
				if arg0_12 then
					arg0_5.contextData.id = var0_11

					if arg0_5.contextData.id == 0 then
						arg0_5:FlushTBView()
					else
						arg0_5:FlushView(arg0_5.contextData.id)
					end
				end
			end, SFX_PANEL)
		end
	end)
	arg0_5.toggleList:align(#arg0_5.ids)
	setActive(arg0_5.leftTF, arg0_5.contextData.isSelect)

	if arg0_5.contextData.isSelect then
		triggerToggle(arg0_5.togglesTF:Find(tostring(arg0_5.contextData.id)), true)
	else
		arg0_5:FlushView(arg0_5.contextData.id)
	end
end

function var0_0.FlushView(arg0_13, arg1_13)
	arg0_13.permanentData = getProxy(NewEducateProxy):GetChar(arg1_13):GetPermanentData()

	local var0_13 = #arg0_13.permanentData:GetUnlockMemoryIds()
	local var1_13 = #arg0_13.permanentData:GetAllMemoryIds()

	setText(arg0_13.memoryBtn:Find("Text"), var0_13 .. "/" .. var1_13)
	setActive(arg0_13.memoryBtn:Find("new"), false)

	local var2_13 = #arg0_13.permanentData:GetUnlockPolaroidGroups()
	local var3_13 = #arg0_13.permanentData:GetAllPolaroidGroups()

	setActive(arg0_13.polaroidBtn:Find("lock"), false)
	setText(arg0_13.polaroidBtn:Find("Text"), var2_13 .. "/" .. var3_13)
	setActive(arg0_13.polaroidBtn:Find("new"), false)

	local var4_13 = #arg0_13.permanentData:GetActivatedEndings()
	local var5_13 = #arg0_13.permanentData:GetAllEndingIds()

	setText(arg0_13.endingBtn:Find("unlock/Text"), var4_13 .. "/" .. var5_13)

	local var6_13 = NewEducateConst.LOCK_ENDING and arg0_13.permanentData:GetGameCnt()

	setActive(arg0_13.endingBtn:Find("unlock"), not var6_13)
	setActive(arg0_13.endingBtn:Find("lock"), var6_13)
end

function var0_0.FlushTBView(arg0_14)
	local var0_14 = getProxy(EducateProxy)
	local var1_14 = var0_14:GetMemories()
	local var2_14 = var0_14:GetFinishEndings()
	local var3_14 = #pg.child_memory.all

	setText(arg0_14.memoryBtn:Find("Text"), #var1_14 .. "/" .. var3_14)
	arg0_14:UpdateMemoryTip()

	local var4_14, var5_14 = var0_14:GetPolaroidGroupCnt()

	setText(arg0_14.polaroidBtn:Find("Text"), var4_14 .. "/" .. var5_14)
	setActive(arg0_14.polaroidBtn:Find("lock"), not EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_POLAROID))
	setActive(arg0_14.polaroidBtn:Find("new"), EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_POLAROID))

	local var6_14 = #pg.child_ending.all

	setText(arg0_14.endingBtn:Find("unlock/Text"), #var2_14 .. "/" .. var6_14)

	local var7_14 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_ENDING) or #var2_14 > 0

	setActive(arg0_14.endingBtn:Find("unlock"), var7_14)
	setActive(arg0_14.endingBtn:Find("lock"), not var7_14)
end

function var0_0.UpdateMemoryTip(arg0_15)
	local var0_15 = underscore.any(pg.child_memory.all, function(arg0_16)
		return EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_MEMORY, arg0_16)
	end)

	setActive(arg0_15.memoryBtn:Find("new"), var0_15)
end

function var0_0._close(arg0_17)
	arg0_17.anim:Play("anim_educate_collectentrance_out")
end

function var0_0.onBackPressed(arg0_18)
	arg0_18:_close()
end

function var0_0.willExit(arg0_19)
	arg0_19.animEvent:SetEndEvent(nil)
	arg0_19:UnOverlayPanel(arg0_19._tf)
end

return var0_0
