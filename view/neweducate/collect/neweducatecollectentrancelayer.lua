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
	arg0_3.polaroidBtn2 = arg0_3.contentTF:Find("polaroid_btn2")
	arg0_3.buffBtn = arg0_3.contentTF:Find("buff_btn")
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
	onButton(arg0_5, arg0_5.polaroidBtn2, function()
		arg0_5:emit(NewEducateCollectEntranceMediator.GO_SUBLAYER, Context.New({
			mediator = NewEducateCollectMediatorTemplate,
			viewComponent = NewEducatePolaroidLayer,
			data = {
				permanentData = arg0_5.permanentData
			}
		}))
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
			local var0_11 = pg.child2_data[arg0_5.contextData.id].memory_group

			arg0_5:emit(var0_0.ON_CLOSE)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
				page = WorldMediaCollectionScene.PAGE_MEMORTY,
				memoryGroup = var0_11
			})
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.buffBtn, function()
		arg0_5:emit(NewEducateCollectEntranceMediator.GO_SUBLAYER, Context.New({
			mediator = NewEducateCollectMediatorTemplate,
			viewComponent = NewEducateBuffLayer,
			data = {
				permanentData = arg0_5.permanentData
			}
		}))
	end, SFX_PANEL)
	arg0_5.toggleList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventInit then
			local var0_13 = arg0_5.ids[arg1_13 + 1]

			arg2_13.name = var0_13

			local var1_13 = var0_13 == 0 and "linghangyuan1_1" or pg.child2_data[var0_13].head

			LoadImageSpriteAsync("qicon/" .. var1_13, arg2_13:Find("icon"))
			onToggle(arg0_5, arg2_13, function(arg0_14)
				if arg0_14 then
					arg0_5.contextData.id = var0_13

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

function var0_0.FlushView(arg0_15, arg1_15)
	arg0_15.permanentData = getProxy(NewEducateProxy):GetChar(arg1_15):GetPermanentData()

	local var0_15 = #arg0_15.permanentData:GetUnlockMemoryIds()
	local var1_15 = #arg0_15.permanentData:GetAllMemoryIds()

	setText(arg0_15.memoryBtn:Find("Text"), var0_15 .. "/" .. var1_15)
	setActive(arg0_15.memoryBtn:Find("new"), false)

	local var2_15 = arg0_15.permanentData:IsTarotType()
	local var3_15 = #arg0_15.permanentData:GetUnlockPolaroidGroups()
	local var4_15 = #arg0_15.permanentData:GetAllPolaroidGroups()

	setText(arg0_15.polaroidBtn:Find("Text"), var3_15 .. "/" .. var4_15)
	setText(arg0_15.polaroidBtn2:Find("Text"), var3_15 .. "/" .. var4_15)
	setActive(arg0_15.polaroidBtn:Find("new"), false)
	setActive(arg0_15.polaroidBtn2:Find("new"), false)
	setActive(arg0_15.polaroidBtn, not var2_15)
	setActive(arg0_15.polaroidBtn2, var2_15)
	setActive(arg0_15.buffBtn, var2_15)

	if var2_15 then
		local var5_15 = arg0_15.permanentData:GetAllBuffCnt()
		local var6_15 = arg0_15.permanentData:GetAllUnlockBuffCnt()

		setText(arg0_15.buffBtn:Find("Text"), var6_15 .. "/" .. var5_15)
	end

	local var7_15 = #arg0_15.permanentData:GetActivatedEndings()
	local var8_15 = #arg0_15.permanentData:GetAllEndingIds()

	setText(arg0_15.endingBtn:Find("unlock/Text"), var7_15 .. "/" .. var8_15)

	local var9_15 = NewEducateConst.LOCK_ENDING and arg0_15.permanentData:GetGameCnt()

	setActive(arg0_15.endingBtn:Find("unlock"), not var9_15)
	setActive(arg0_15.endingBtn:Find("lock"), var9_15)
end

function var0_0.FlushTBView(arg0_16)
	local var0_16 = getProxy(EducateProxy)
	local var1_16 = var0_16:GetMemories()
	local var2_16 = var0_16:GetAllEndings()
	local var3_16 = #pg.child_memory.all

	setText(arg0_16.memoryBtn:Find("Text"), #var1_16 .. "/" .. var3_16)
	arg0_16:UpdateMemoryTip()

	local var4_16, var5_16 = var0_16:GetPolaroidGroupCnt()

	setText(arg0_16.polaroidBtn:Find("Text"), var4_16 .. "/" .. var5_16)
	setActive(arg0_16.polaroidBtn:Find("lock"), not EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_POLAROID))
	setActive(arg0_16.polaroidBtn:Find("new"), EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_POLAROID))
	setActive(arg0_16.polaroidBtn, true)
	setActive(arg0_16.polaroidBtn2, false)
	setActive(arg0_16.buffBtn, false)

	local var6_16 = #pg.child_ending.all

	setText(arg0_16.endingBtn:Find("unlock/Text"), #var2_16 .. "/" .. var6_16)

	local var7_16 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_ENDING) or #var2_16 > 0

	setActive(arg0_16.endingBtn:Find("unlock"), var7_16)
	setActive(arg0_16.endingBtn:Find("lock"), not var7_16)
end

function var0_0.UpdateMemoryTip(arg0_17)
	local var0_17 = underscore.any(pg.child_memory.all, function(arg0_18)
		return EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_MEMORY, arg0_18)
	end)

	setActive(arg0_17.memoryBtn:Find("new"), var0_17)
end

function var0_0._close(arg0_19)
	arg0_19.anim:Play("anim_educate_collectentrance_out")
end

function var0_0.onBackPressed(arg0_20)
	arg0_20:_close()
end

function var0_0.willExit(arg0_21)
	arg0_21.animEvent:SetEndEvent(nil)
	arg0_21:UnOverlayPanel(arg0_21._tf)
end

return var0_0
