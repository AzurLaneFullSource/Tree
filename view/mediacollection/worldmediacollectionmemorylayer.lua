local var0_0 = class("WorldMediaCollectionMemoryLayer", import(".WorldMediaCollectionTemplateLayer"))

function var0_0.getUIName(arg0_1)
	return "WorldMediaCollectionMemoryUI"
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

function var0_0.HideDetailLayer(arg0_4)
	if not arg0_4.detailUI then
		return
	end

	arg0_4.detailUI.buffer:Hide()
end

function var0_0.CloseDetailLayer(arg0_5)
	if arg0_5.detailUI then
		arg0_5.detailUI:Destroy()

		arg0_5.detailUI = nil
	end
end

function var0_0.GetGroupLayer(arg0_6)
	if not arg0_6.groupUI then
		arg0_6.groupUI = WorldMediaCollectionMemoryGroupLayer.New(arg0_6, arg0_6._tf, arg0_6.event, arg0_6.contextData)

		arg0_6.groupUI:Load()
	end

	return arg0_6.groupUI
end

function var0_0.HideGroupLayer(arg0_7)
	if not arg0_7.groupUI then
		return
	end

	arg0_7.groupUI.buffer:Hide()
end

function var0_0.CloseGroupLayer(arg0_8)
	if arg0_8.groupUI then
		arg0_8.groupUI:Destroy()

		arg0_8.groupUI = nil
	end
end

function var0_0.SwitchBetweenGroupsAndItems(arg0_9, arg1_9)
	if arg0_9.groupUI then
		arg0_9.groupUI.buffer:SetActive(arg1_9)
	end

	if arg0_9.detailUI then
		arg0_9.detailUI.buffer:SetActive(not arg1_9)
	end
end

function var0_0.OnSelected(arg0_10)
	var0_0.super.OnSelected(arg0_10)

	local var0_10 = getProxy(ActivityProxy):getActivityById(ActivityConst.QIXI_ACTIVITY_ID)

	if var0_10 and not var0_10:isEnd() then
		local var1_10 = var0_10:getConfig("config_data")
		local var2_10 = _.flatten(var1_10)
		local var3_10 = var2_10[#var2_10]
		local var4_10 = getProxy(TaskProxy):getTaskById(var3_10)

		if var4_10 and not var4_10:isFinish() then
			pg.NewStoryMgr.GetInstance():Play("HOSHO8", function()
				arg0_10:emit(CollectionScene.ACTIVITY_OP, {
					cmd = 2,
					activity_id = var0_10.id
				})
			end, true)
		end
	end

	local var5_10 = arg0_10.contextData.memoryGroup

	arg0_10.contextData.memoryGroup = nil

	if var5_10 and pg.memory_group[var5_10] then
		arg0_10:ShowSubMemories(pg.memory_group[var5_10])
	else
		arg0_10:MemoryFilter()
		arg0_10:SwitchReddotMemory()
	end
end

function var0_0.OnReselected(arg0_12)
	arg0_12:Return2MemoryGroup()
end

function var0_0.OnDeselected(arg0_13)
	arg0_13.contextData.memoryGroup = nil

	var0_0.super.OnDeselected(arg0_13)
end

function var0_0.Hide(arg0_14)
	arg0_14:HideDetailLayer()
	arg0_14:HideGroupLayer()
	var0_0.super.Hide(arg0_14)
end

function var0_0.OnBackward(arg0_15)
	return arg0_15:Return2MemoryGroup()
end

function var0_0.SwitchMemoryFilter(arg0_16, arg1_16)
	if arg1_16 == 1 then
		arg0_16.memoryFilterIndex = {
			true,
			true,
			true
		}
	else
		for iter0_16 in ipairs(arg0_16.memoryFilterIndex) do
			arg0_16.memoryFilterIndex[iter0_16] = arg1_16 - 1 == iter0_16
		end
	end
end

function var0_0.MemoryFilter(arg0_17)
	local var0_17 = arg0_17:GetGroupLayer()

	var0_17.buffer:Show()
	var0_17.buffer:MemoryFilter()
	arg0_17:HideDetailLayer()
end

function var0_0.SwitchReddotMemory(arg0_18)
	arg0_18:GetGroupLayer().buffer:SwitchReddotMemory()
end

function var0_0.ShowSubMemories(arg0_19, ...)
	local var0_19 = arg0_19:GetDetailLayer()

	var0_19.buffer:Show()
	var0_19.buffer:ShowSubMemories(...)
	arg0_19:HideGroupLayer()
end

function var0_0.Return2MemoryGroup(arg0_20)
	if not arg0_20.contextData.memoryGroup then
		return
	end

	local var0_20 = arg0_20:GetGroupLayer()

	var0_20.buffer:Show()
	var0_20.buffer:Return2MemoryGroup()

	arg0_20.contextData.memoryGroup = nil

	arg0_20:HideDetailLayer()

	return true
end

function var0_0.UpdateView(arg0_21)
	local var0_21

	if arg0_21.contextData.memoryGroup then
		var0_21 = arg0_21.groupUI
	else
		var0_21 = arg0_21.detailUI
	end

	if not var0_21 then
		return
	end

	var0_21.buffer:UpdateView()
end

function var0_0.OnDestroy(arg0_22)
	arg0_22:CloseDetailLayer()
	arg0_22:CloseGroupLayer()
	var0_0.super.OnDestroy(arg0_22)
end

return var0_0
