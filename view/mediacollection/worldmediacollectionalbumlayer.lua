local var0_0 = class("WorldMediaCollectionAlbumLayer", import(".WorldMediaCollectionTemplateLayer"))

function var0_0.getUIName(arg0_1)
	return "WorldMediaCollectionAlbumUI"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	assert(arg0_2.viewParent, "Need assign ViewParent for " .. arg0_2.__cname)

	arg0_2._top = arg0_2:findTF("Top")
	arg0_2.memoryMask = arg0_2:findTF("StoryMask", arg0_2._top)

	setActive(arg0_2.memoryMask, false)
end

function var0_0.GetDetailLayer(arg0_3)
	if not arg0_3.detailUI then
		arg0_3.detailUI = WorldMediaCollectionMemoryDetailLayer.New(arg0_3, arg0_3._tf, arg0_3.event, arg0_3.contextData)

		arg0_3.detailUI:Load()
		arg0_3.detailUI:SetStoryMask(arg0_3.memoryMask)
	end

	return arg0_3.detailUI
end

function var0_0.GetGroupLayer(arg0_4)
	if not arg0_4.groupUI then
		arg0_4.groupUI = WorldMediaCollectionAlbumGroupLayer.New(arg0_4, arg0_4._tf, arg0_4.event, arg0_4.contextData)

		arg0_4.groupUI:Load()
	end

	return arg0_4.groupUI
end

function var0_0.HideGroupLayer(arg0_5)
	if not arg0_5.groupUI then
		return
	end

	arg0_5.groupUI.buffer:Hide()
end

function var0_0.CloseGroupLayer(arg0_6)
	if arg0_6.groupUI then
		arg0_6.groupUI:Destroy()

		arg0_6.groupUI = nil
	end
end

function var0_0.SwitchBetweenGroupsAndItems(arg0_7, arg1_7)
	if arg0_7.groupUI then
		arg0_7.groupUI.buffer:SetActive(arg1_7)
	end

	if arg0_7.detailUI then
		arg0_7.detailUI.buffer:SetActive(not arg1_7)
	end
end

function var0_0.OnSelected(arg0_8)
	var0_0.super.OnSelected(arg0_8)

	local var0_8 = getProxy(ActivityProxy):getActivityById(ActivityConst.QIXI_ACTIVITY_ID)

	if var0_8 and not var0_8:isEnd() then
		local var1_8 = var0_8:getConfig("config_data")
		local var2_8 = _.flatten(var1_8)
		local var3_8 = var2_8[#var2_8]
		local var4_8 = getProxy(TaskProxy):getTaskById(var3_8)

		if var4_8 and not var4_8:isFinish() then
			pg.NewStoryMgr.GetInstance():Play("HOSHO8", function()
				arg0_8:emit(CollectionScene.ACTIVITY_OP, {
					cmd = 2,
					activity_id = var0_8.id
				})
			end, true)
		end
	end

	local var5_8 = arg0_8.contextData.memoryGroup

	arg0_8.contextData.memoryGroup = nil

	if var5_8 and pg.memory_group[var5_8] then
		arg0_8:ShowSubMemories(pg.memory_group[var5_8])
	else
		arg0_8:MemoryFilter()
		arg0_8:SwitchReddotMemory()
	end
end

function var0_0.OnReselected(arg0_10)
	arg0_10:Return2MemoryGroup()
end

function var0_0.OnDeselected(arg0_11)
	arg0_11.contextData.memoryGroup = nil

	var0_0.super.OnDeselected(arg0_11)
end

function var0_0.Hide(arg0_12)
	arg0_12:HideGroupLayer()
	var0_0.super.Hide(arg0_12)
end

function var0_0.OnBackward(arg0_13)
	return arg0_13:Return2MemoryGroup()
end

function var0_0.SwitchMemoryFilter(arg0_14, arg1_14)
	if arg1_14 == 1 then
		arg0_14.memoryFilterIndex = {
			true,
			true,
			true
		}
	else
		for iter0_14 in ipairs(arg0_14.memoryFilterIndex) do
			arg0_14.memoryFilterIndex[iter0_14] = arg1_14 - 1 == iter0_14
		end
	end
end

function var0_0.MemoryFilter(arg0_15)
	arg0_15:GetGroupLayer().buffer:Show()
end

function var0_0.SwitchReddotMemory(arg0_16)
	arg0_16:GetGroupLayer().buffer:SwitchReddotMemory()
end

function var0_0.ShowAlbum(arg0_17, arg1_17)
	local var0_17 = arg1_17.ui_prefab.scene
	local var1_17 = _G[var0_17]
	local var2_17 = arg1_17.ui_prefab.mediator
	local var3_17 = _G[var2_17]

	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = getProxy(ContextProxy):getCurrentContext(),
		context = Context.New({
			mediator = var3_17,
			viewComponent = var1_17
		})
	})
end

function var0_0.Return2MemoryGroup(arg0_18)
	if not arg0_18.contextData.memoryGroup then
		return
	end

	local var0_18 = arg0_18:GetGroupLayer()

	var0_18.buffer:Show()
	var0_18.buffer:Return2MemoryGroup()

	arg0_18.contextData.memoryGroup = nil

	return true
end

function var0_0.UpdateView(arg0_19)
	local var0_19

	if arg0_19.contextData.memoryGroup then
		var0_19 = arg0_19.groupUI
	else
		var0_19 = arg0_19.detailUI
	end

	if not var0_19 then
		return
	end

	var0_19.buffer:UpdateView()
end

function var0_0.OnDestroy(arg0_20)
	arg0_20:CloseGroupLayer()
	var0_0.super.OnDestroy(arg0_20)
end

return var0_0
