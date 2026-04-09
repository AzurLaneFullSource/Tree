local var0_0 = class("LuaList")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.parentClass_ = arg1_1
	arg0_1.uiListGo_ = arg3_1.gameObject
	arg0_1.itemClass_ = arg4_1
	arg0_1.itemRenderer_ = arg2_1
	arg0_1.itemOfInstanceID_ = {}
	arg0_1.itemOfIndex_ = {}

	arg0_1:InitUI()
	arg0_1:AddListeners()
end

function var0_0.InitUI(arg0_2)
	arg0_2.uiList_ = arg0_2.uiListGo_:GetComponent(typeof(UIList))
end

function var0_0.AddListeners(arg0_3)
	if arg0_3.uiList_ ~= nil then
		arg0_3.uiList_:SetItemRenderer(handler(arg0_3, arg0_3.ItemRenderer))
		arg0_3.uiList_:SetItemRecycleHandler(handler(arg0_3, arg0_3.ItemRecycleHandler))
		arg0_3.uiList_:SetPageChangeHandler(handler(arg0_3, arg0_3.PageChangeHandler))
		arg0_3.uiList_:SetHeadTailChangeHandler(handler(arg0_3, arg0_3.HeadTailChangeHandler))
	end
end

function var0_0.RemoveListeners(arg0_4)
	if arg0_4.uiList_ ~= nil then
		arg0_4.uiList_:SetItemRenderer(nil)
		arg0_4.uiList_:SetItemRecycleHandler(nil)
		arg0_4.uiList_:SetPageChangeHandler(nil)
		arg0_4.uiList_:SetHeadTailChangeHandler(nil)
	end
end

function var0_0.HeadTailChangeHandler(arg0_5, arg1_5, arg2_5)
	if arg0_5.headTailChangeHandler_ ~= nil then
		arg0_5.headTailChangeHandler_(arg1_5, arg2_5)
	end
end

function var0_0.ItemRenderer(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg1_6 + 1
	local var1_6 = arg2_6:GetInstanceID()
	local var2_6

	if arg0_6.itemOfInstanceID_[var1_6] then
		var2_6 = arg0_6.itemOfInstanceID_[var1_6]
	else
		var2_6 = arg0_6.itemClass_.New(arg2_6.transform, arg0_6.parentClass_)
		arg0_6.itemOfInstanceID_[var1_6] = var2_6
	end

	arg0_6.itemOfIndex_[arg1_6 + 1] = var2_6

	if var0_6 > arg0_6.num_ then
		return
	end

	if arg0_6.itemRenderer_ then
		arg0_6.itemRenderer_(var0_6, var2_6)
	end
end

function var0_0.GetItemByIndex(arg0_7, arg1_7)
	local var0_7, var1_7 = arg0_7:GetHeadAndTail()

	if var0_7 == 0 then
		return
	end

	if arg1_7 < var0_7 or var1_7 < arg1_7 then
		return nil
	end

	return arg0_7.itemOfIndex_[arg1_7]
end

function var0_0.ItemRecycleHandler(arg0_8, arg1_8, arg2_8)
	return
end

function var0_0.SetPageChangeHandler(arg0_9, arg1_9)
	arg0_9.pageChangeHandler_ = arg1_9
end

function var0_0.SetHeadTailChangeHandler(arg0_10, arg1_10)
	arg0_10.headTailChangeHandler_ = arg1_10
end

function var0_0.PageChangeHandler(arg0_11, arg1_11)
	if arg0_11.pageChangeHandler_ ~= nil then
		arg0_11.pageChangeHandler_(arg1_11 + 1)
	end
end

function var0_0.ScrollToIndex(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
	local var0_12 = arg1_12 - 1

	arg2_12 = arg2_12 or false
	arg3_12 = arg3_12 or false
	arg4_12 = arg4_12 or -1

	arg0_12.uiList_:ScrollToIndex(var0_12, arg2_12, arg3_12, arg4_12)
end

function var0_0.RemoveTween(arg0_13)
	arg0_13.uiList_:RemoveTween()
end

function var0_0.SwitchToPage(arg0_14, arg1_14)
	local var0_14 = arg1_14 - 1

	arg0_14.uiList_:SwitchToPageIndex(var0_14)
end

function var0_0.GetItemList(arg0_15)
	local var0_15 = {}
	local var1_15, var2_15 = arg0_15:GetHeadAndTail()

	if var1_15 == 0 then
		return {}
	end

	for iter0_15 = var1_15, var2_15 do
		var0_15[iter0_15] = arg0_15.itemOfIndex_[iter0_15]
	end

	return var0_15
end

function var0_0.GetHeadAndTail(arg0_16)
	local var0_16 = arg0_16.uiList_:GetHeadAndTail()

	return var0_16.x + 1, var0_16.y + 1
end

function var0_0.SetAlignment(arg0_17, arg1_17)
	arg0_17.uiList_:SetAlignment(arg1_17)
end

function var0_0.StartScroll(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18, arg5_18)
	arg2_18 = arg2_18 or 0
	arg5_18 = arg5_18 or -1

	local var0_18 = arg2_18 - 1

	arg0_18.num_ = arg1_18

	arg0_18:UpdateUIList(arg1_18)

	if var0_18 >= 0 then
		arg0_18.uiList_:ScrollToIndex(var0_18, arg3_18, arg4_18, arg5_18)
	end
end

function var0_0.StartScrollWithoutAnimator(arg0_19, arg1_19, arg2_19)
	arg0_19.num_ = arg1_19

	arg0_19.uiList_:SetNumItems(arg1_19, true)

	if arg2_19 then
		arg0_19.uiList_:SetScrolledPosition(arg2_19)
	end
end

function var0_0.Refresh(arg0_20)
	local var0_20, var1_20 = arg0_20:GetHeadAndTail()

	if var0_20 == 0 then
		return
	end

	for iter0_20 = var0_20, var1_20 do
		if arg0_20.itemRenderer_ then
			local var2_20 = arg0_20.itemOfIndex_[iter0_20]

			if var2_20 then
				arg0_20.itemRenderer_(iter0_20, var2_20)
			end
		end
	end
end

function var0_0.SetScrolledPosition(arg0_21, arg1_21)
	arg0_21.uiList_:SetScrolledPosition(arg1_21)
end

function var0_0.GetScrolledPosition(arg0_22)
	return arg0_22.uiList_:GetScrolledPosition()
end

function var0_0.StartScrollByPosition(arg0_23, arg1_23, arg2_23)
	arg0_23.num_ = arg1_23

	arg0_23:UpdateUIList(arg1_23)
	arg0_23:SetScrolledPosition(arg2_23 or Vector2.zero)
end

function var0_0.UpdateUIList(arg0_24, arg1_24)
	arg0_24.uiList_:SetNumItems(arg1_24)
end

function var0_0.StopRender(arg0_25)
	if arg0_25.uiList_ then
		arg0_25.uiList_:StopRender()
	end
end

function var0_0.Dispose(arg0_26)
	arg0_26:RemoveListeners()

	if arg0_26.uiList_ ~= nil then
		arg0_26:RemoveTween()
		arg0_26.uiList_:StopRender()
		arg0_26.uiList_:HideBlock()

		arg0_26.uiList_ = nil
	end

	if arg0_26.itemOfInstanceID_ then
		for iter0_26, iter1_26 in pairs(arg0_26.itemOfInstanceID_) do
			iter1_26:willExit()
		end

		arg0_26.itemOfInstanceID_ = nil
	end

	arg0_26.pageChangeHandler_ = nil
end

function var0_0.SetOrientation(arg0_27, arg1_27)
	if arg1_27 == 0 then
		arg0_27.uiList_:SetOrientation(Orientation.Horizontal)
	else
		arg0_27.uiList_:SetOrientation(Orientation.Vertical)
	end
end

function var0_0.GetNum(arg0_28)
	return arg0_28.num_
end

function var0_0.SetAppearType(arg0_29, arg1_29)
	arg0_29.uiList_:SetAppearType(arg1_29)
end

return var0_0
