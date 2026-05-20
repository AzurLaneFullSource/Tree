local var0_0 = class("NewWorldMediaCollectionMemoryLayer", import(".WorldMediaCollectionTemplateLayer"))

function var0_0.getUIName(arg0_1)
	return "NewWorldMediaCollectionMemoryUI"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	assert(arg0_2.viewParent, "Need assign ViewParent for " .. arg0_2.__cname)

	arg0_2._top = arg0_2._tf:Find("Top")
	arg0_2.memoryMask = arg0_2._top:Find("StoryMask")

	setActive(arg0_2.memoryMask, false)

	arg0_2.Layer = -1
end

function var0_0.GetDetailLayer(arg0_3)
	setActive(arg0_3._top:Find("RoleTitle"), true)
	setActive(arg0_3._top:Find("HonorTitle"), false)

	if not arg0_3.detailUI then
		arg0_3.detailUI = NewWorldMediaCollectionMemoryDetailLayer.New(arg0_3, arg0_3._tf, arg0_3.event, arg0_3.contextData)

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
	setActive(arg0_6._top:Find("RoleTitle"), true)
	setActive(arg0_6._top:Find("HonorTitle"), false)

	if not arg0_6.groupUI then
		arg0_6.groupUI = NewWorldMediaCollectionMemoryGroupLayer.New(arg0_6, arg0_6._tf, arg0_6.event, arg0_6.contextData)

		arg0_6.groupUI:RegisterView(arg0_6)
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

function var0_0.GetHallGloryLayer(arg0_9)
	setActive(arg0_9._top:Find("RoleTitle"), false)
	setActive(arg0_9._top:Find("HonorTitle"), true)

	if not arg0_9.HallGloryUI then
		arg0_9.HallGloryUI = HallGloryLayer.New(arg0_9, arg0_9._tf, arg0_9.event, arg0_9.contextData)

		arg0_9.HallGloryUI:SetStoryMask(arg0_9.memoryMask)
		arg0_9.HallGloryUI:Load()
	end

	return arg0_9.HallGloryUI
end

function var0_0.HideHallGloryLayer(arg0_10)
	if not arg0_10.HallGloryUI then
		return
	end

	arg0_10.HallGloryUI.buffer:Hide()
end

function var0_0.CloseHallGloryLayer(arg0_11)
	if arg0_11.HallGloryUI then
		arg0_11.HallGloryUI:Destroy()

		arg0_11.HallGloryUI = nil
	end
end

function var0_0.SwitchBetweenGroupsAndItems(arg0_12, arg1_12)
	if arg0_12.groupUI then
		arg0_12.groupUI.buffer:SetActive(arg1_12)
	end

	if arg0_12.detailUI then
		arg0_12.detailUI.buffer:SetActive(not arg1_12)
	end
end

function var0_0.OnSelected(arg0_13)
	var0_0.super.OnSelected(arg0_13)

	local var0_13 = getProxy(ActivityProxy):getActivityById(ActivityConst.QIXI_ACTIVITY_ID)

	if var0_13 and not var0_13:isEnd() then
		local var1_13 = var0_13:getConfig("config_data")
		local var2_13 = _.flatten(var1_13)
		local var3_13 = var2_13[#var2_13]
		local var4_13 = getProxy(TaskProxy):getTaskById(var3_13)

		if var4_13 and not var4_13:isFinish() then
			pg.NewStoryMgr.GetInstance():Play("HOSHO8", function()
				arg0_13:emit(CollectionScene.ACTIVITY_OP, {
					cmd = 2,
					activity_id = var0_13.id
				})
			end, true)
		end
	end

	local var5_13 = arg0_13.contextData.memoryGroup

	arg0_13.contextData.memoryGroup = nil

	if var5_13 and pg.memory_group[var5_13] then
		arg0_13:ShowSubMemories(pg.memory_group[var5_13])
	else
		arg0_13:MemoryFilter()
		arg0_13:SwitchReddotMemory()
	end
end

function var0_0.OnReselected(arg0_15)
	arg0_15:Return2MemoryGroup()
end

function var0_0.OnDeselected(arg0_16)
	arg0_16.contextData.memoryGroup = nil

	var0_0.super.OnDeselected(arg0_16)
end

function var0_0.Hide(arg0_17)
	arg0_17:HideDetailLayer()
	arg0_17:HideGroupLayer()
	arg0_17:HideHallGloryLayer()
	var0_0.super.Hide(arg0_17)
end

function var0_0.OnBackward(arg0_18)
	return arg0_18:Return2MemoryGroup()
end

function var0_0.SwitchMemoryFilter(arg0_19, arg1_19)
	if arg1_19 == 1 then
		arg0_19.memoryFilterIndex = {
			true,
			true,
			true
		}
	else
		for iter0_19 in ipairs(arg0_19.memoryFilterIndex) do
			arg0_19.memoryFilterIndex[iter0_19] = arg1_19 - 1 == iter0_19
		end
	end
end

function var0_0.MemoryFilter(arg0_20)
	local var0_20 = arg0_20:GetGroupLayer()

	var0_20.buffer:Show()
	var0_20.buffer:MemoryFilter()
	arg0_20:HideDetailLayer()
end

function var0_0.SwitchReddotMemory(arg0_21)
	arg0_21:GetGroupLayer().buffer:SwitchReddotMemory()
end

function var0_0.ShowSubMemories(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = arg0_22:GetDetailLayer()

	var0_22.buffer:Show()
	var0_22.buffer:ShowSubMemories(arg1_22, arg3_22)

	if not arg2_22 then
		arg0_22:HideGroupLayer()
		arg0_22:HideHallGloryLayer()
	end
end

function var0_0.ShowHallGloryLayer(arg0_23, arg1_23, arg2_23, arg3_23)
	arg0_23:GetHallGloryLayer().buffer:Show()

	if not arg2_23 then
		arg0_23:HideGroupLayer()
	end
end

function var0_0.Return2MemoryGroup(arg0_24)
	local var0_24 = arg0_24.contextData.memoryGroup
	local var1_24 = arg0_24:GetGroupLayer()

	if var1_24.index == -1 then
		return
	elseif var1_24.index == 1 then
		var1_24.buffer:Show()
		var1_24.buffer:Return2MemoryGroup()
		arg0_24:HideDetailLayer()
	elseif var1_24.index == 2 then
		var1_24.buffer:Show()
		var1_24.buffer:Return2MemoryGroup()
		arg0_24:HideHallGloryLayer()
	end

	return true
end

function var0_0.Return2Line(arg0_25)
	return
end

function var0_0.UpdateView(arg0_26)
	local var0_26

	if arg0_26.contextData.memoryGroup then
		var0_26 = arg0_26.groupUI
	else
		var0_26 = arg0_26.detailUI
	end

	if not var0_26 then
		return
	end

	var0_26.buffer:UpdateView()
end

function var0_0.WrapToStoryLine(arg0_27, arg1_27)
	local var0_27 = arg0_27:GetGroupLayer()

	var0_27:SwitchStoryLineMode(var0_27.LINE_MODE)
	var0_27.storyLineView:ShowNodeDetail(arg1_27)
end

function var0_0.OnDestroy(arg0_28)
	arg0_28:CloseDetailLayer()
	arg0_28:CloseGroupLayer()
	var0_0.super.OnDestroy(arg0_28)
end

return var0_0
