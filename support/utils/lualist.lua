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
	if arg0_8.itemRecycleHandler_ then
		arg0_8.itemRecycleHandler_(arg1_8, arg2_8)
	end
end

function var0_0.SetItemRecycleHandler(arg0_9, arg1_9)
	arg0_9.itemRecycleHandler_ = arg1_9
end

function var0_0.SetPageChangeHandler(arg0_10, arg1_10)
	arg0_10.pageChangeHandler_ = arg1_10
end

function var0_0.SetHeadTailChangeHandler(arg0_11, arg1_11)
	arg0_11.headTailChangeHandler_ = arg1_11
end

function var0_0.PageChangeHandler(arg0_12, arg1_12)
	if arg0_12.pageChangeHandler_ ~= nil then
		arg0_12.pageChangeHandler_(arg1_12 + 1)
	end
end

function var0_0.ScrollToIndex(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	local var0_13 = arg1_13 - 1

	arg2_13 = arg2_13 or false
	arg3_13 = arg3_13 or false
	arg4_13 = arg4_13 or -1

	arg0_13.uiList_:ScrollToIndex(var0_13, arg2_13, arg3_13, arg4_13)
end

function var0_0.RemoveTween(arg0_14)
	arg0_14.uiList_:RemoveTween()
end

function var0_0.SwitchToPage(arg0_15, arg1_15)
	local var0_15 = arg1_15 - 1

	arg0_15.uiList_:SwitchToPageIndex(var0_15)
end

function var0_0.GetItemList(arg0_16)
	local var0_16 = {}
	local var1_16, var2_16 = arg0_16:GetHeadAndTail()

	if var1_16 == 0 then
		return {}
	end

	for iter0_16 = var1_16, var2_16 do
		var0_16[iter0_16] = arg0_16.itemOfIndex_[iter0_16]
	end

	return var0_16
end

function var0_0.GetHeadAndTail(arg0_17)
	local var0_17 = arg0_17.uiList_:GetHeadAndTail()

	return var0_17.x + 1, var0_17.y + 1
end

function var0_0.SetAlignment(arg0_18, arg1_18)
	arg0_18.uiList_:SetAlignment(arg1_18)
end

function var0_0.StartScroll(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19, arg5_19)
	arg2_19 = arg2_19 or 0
	arg5_19 = arg5_19 or -1

	local var0_19 = arg2_19 - 1

	arg0_19.num_ = arg1_19

	arg0_19:UpdateUIList(arg1_19)

	if var0_19 >= 0 then
		arg0_19.uiList_:ScrollToIndex(var0_19, arg3_19, arg4_19, arg5_19)
	end
end

function var0_0.StartScrollWithoutAnimator(arg0_20, arg1_20, arg2_20)
	arg0_20.num_ = arg1_20

	arg0_20.uiList_:SetNumItems(arg1_20, true)

	if arg2_20 then
		arg0_20.uiList_:SetScrolledPosition(arg2_20)
	end
end

function var0_0.Refresh(arg0_21)
	local var0_21, var1_21 = arg0_21:GetHeadAndTail()

	if var0_21 == 0 then
		return
	end

	for iter0_21 = var0_21, var1_21 do
		if arg0_21.itemRenderer_ then
			local var2_21 = arg0_21.itemOfIndex_[iter0_21]

			if var2_21 then
				arg0_21.itemRenderer_(iter0_21, var2_21)
			end
		end
	end
end

function var0_0.SetScrolledPosition(arg0_22, arg1_22)
	arg0_22.uiList_:SetScrolledPosition(arg1_22)
end

function var0_0.GetScrolledPosition(arg0_23)
	return arg0_23.uiList_:GetScrolledPosition()
end

function var0_0.StartScrollByPosition(arg0_24, arg1_24, arg2_24)
	arg0_24.num_ = arg1_24

	arg0_24:UpdateUIList(arg1_24)
	arg0_24:SetScrolledPosition(arg2_24 or Vector2.zero)
end

function var0_0.UpdateUIList(arg0_25, arg1_25)
	arg0_25.uiList_:SetNumItems(arg1_25)
end

function var0_0.StopRender(arg0_26)
	if arg0_26.uiList_ then
		arg0_26.uiList_:StopRender()
	end
end

function var0_0.Dispose(arg0_27)
	arg0_27:RemoveListeners()

	if arg0_27.uiList_ ~= nil then
		arg0_27:RemoveTween()
		arg0_27.uiList_:StopRender()
		arg0_27.uiList_:HideBlock()

		arg0_27.uiList_ = nil
	end

	if arg0_27.itemOfInstanceID_ then
		for iter0_27, iter1_27 in pairs(arg0_27.itemOfInstanceID_) do
			iter1_27:willExit()
		end

		arg0_27.itemOfInstanceID_ = nil
	end

	arg0_27.pageChangeHandler_ = nil
	arg0_27.itemRecycleHandler_ = nil
end

function var0_0.SetOrientation(arg0_28, arg1_28)
	if arg1_28 == 0 then
		arg0_28.uiList_:SetOrientation(Orientation.Horizontal)
	else
		arg0_28.uiList_:SetOrientation(Orientation.Vertical)
	end
end

function var0_0.GetNum(arg0_29)
	return arg0_29.num_
end

function var0_0.SetAppearType(arg0_30, arg1_30)
	arg0_30.uiList_:SetAppearType(arg1_30)
end

return var0_0
