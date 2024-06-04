local var0 = class("WorldMediaCollectionMemoryLayer", import(".WorldMediaCollectionTemplateLayer"))

function var0.getUIName(arg0)
	return "WorldMediaCollectionMemoryUI"
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	assert(arg0.viewParent, "Need assign ViewParent for " .. arg0.__cname)

	arg0._top = arg0:findTF("Top")
	arg0.memoryMask = arg0:findTF("StoryMask", arg0._top)

	setActive(arg0.memoryMask, false)
end

function var0.GetDetailLayer(arg0)
	if not arg0.detailUI then
		arg0.detailUI = WorldMediaCollectionMemoryDetailLayer.New(arg0, arg0._tf, arg0.event, arg0.contextData)

		arg0.detailUI:Load()
		arg0.detailUI:SetStoryMask(arg0.memoryMask)
	end

	return arg0.detailUI
end

function var0.HideDetailLayer(arg0)
	if not arg0.detailUI then
		return
	end

	arg0.detailUI.buffer:Hide()
end

function var0.CloseDetailLayer(arg0)
	if arg0.detailUI then
		arg0.detailUI:Destroy()

		arg0.detailUI = nil
	end
end

function var0.GetGroupLayer(arg0)
	if not arg0.groupUI then
		arg0.groupUI = WorldMediaCollectionMemoryGroupLayer.New(arg0, arg0._tf, arg0.event, arg0.contextData)

		arg0.groupUI:Load()
	end

	return arg0.groupUI
end

function var0.HideGroupLayer(arg0)
	if not arg0.groupUI then
		return
	end

	arg0.groupUI.buffer:Hide()
end

function var0.CloseGroupLayer(arg0)
	if arg0.groupUI then
		arg0.groupUI:Destroy()

		arg0.groupUI = nil
	end
end

function var0.SwitchBetweenGroupsAndItems(arg0, arg1)
	if arg0.groupUI then
		arg0.groupUI.buffer:SetActive(arg1)
	end

	if arg0.detailUI then
		arg0.detailUI.buffer:SetActive(not arg1)
	end
end

function var0.OnSelected(arg0)
	var0.super.OnSelected(arg0)

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.QIXI_ACTIVITY_ID)

	if var0 and not var0:isEnd() then
		local var1 = var0:getConfig("config_data")
		local var2 = _.flatten(var1)
		local var3 = var2[#var2]
		local var4 = getProxy(TaskProxy):getTaskById(var3)

		if var4 and not var4:isFinish() then
			pg.NewStoryMgr.GetInstance():Play("HOSHO8", function()
				arg0:emit(CollectionScene.ACTIVITY_OP, {
					cmd = 2,
					activity_id = var0.id
				})
			end, true)
		end
	end

	local var5 = arg0.contextData.memoryGroup

	arg0.contextData.memoryGroup = nil

	if var5 and pg.memory_group[var5] then
		arg0:ShowSubMemories(pg.memory_group[var5])
	else
		arg0:MemoryFilter()
		arg0:SwitchReddotMemory()
	end
end

function var0.OnReselected(arg0)
	arg0:Return2MemoryGroup()
end

function var0.OnDeselected(arg0)
	arg0.contextData.memoryGroup = nil

	var0.super.OnDeselected(arg0)
end

function var0.Hide(arg0)
	arg0:HideDetailLayer()
	arg0:HideGroupLayer()
	var0.super.Hide(arg0)
end

function var0.OnBackward(arg0)
	return arg0:Return2MemoryGroup()
end

function var0.SwitchMemoryFilter(arg0, arg1)
	if arg1 == 1 then
		arg0.memoryFilterIndex = {
			true,
			true,
			true
		}
	else
		for iter0 in ipairs(arg0.memoryFilterIndex) do
			arg0.memoryFilterIndex[iter0] = arg1 - 1 == iter0
		end
	end
end

function var0.MemoryFilter(arg0)
	local var0 = arg0:GetGroupLayer()

	var0.buffer:Show()
	var0.buffer:MemoryFilter()
	arg0:HideDetailLayer()
end

function var0.SwitchReddotMemory(arg0)
	arg0:GetGroupLayer().buffer:SwitchReddotMemory()
end

function var0.ShowSubMemories(arg0, ...)
	local var0 = arg0:GetDetailLayer()

	var0.buffer:Show()
	var0.buffer:ShowSubMemories(...)
	arg0:HideGroupLayer()
end

function var0.Return2MemoryGroup(arg0)
	if not arg0.contextData.memoryGroup then
		return
	end

	local var0 = arg0:GetGroupLayer()

	var0.buffer:Show()
	var0.buffer:Return2MemoryGroup()

	arg0.contextData.memoryGroup = nil

	arg0:HideDetailLayer()

	return true
end

function var0.UpdateView(arg0)
	local var0

	if arg0.contextData.memoryGroup then
		var0 = arg0.groupUI
	else
		var0 = arg0.detailUI
	end

	if not var0 then
		return
	end

	var0.buffer:UpdateView()
end

function var0.OnDestroy(arg0)
	arg0:CloseDetailLayer()
	arg0:CloseGroupLayer()
	var0.super.OnDestroy(arg0)
end

return var0
