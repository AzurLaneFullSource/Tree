local var0_0 = class("IslandInventoryIndexPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandInventoryIndexUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.uiItemList = UIItemList.New(arg0_2:findTF("frame/list"), arg0_2:findTF("frame/list/tpl"))
	arg0_2.closeBtn = arg0_2:findTF("frame/top/close_btn")
	arg0_2.cancelBtn = arg0_2:findTF("frame/button_list/cancel")
	arg0_2.confirmBtn = arg0_2:findTF("frame/button_list/confirm")

	setText(arg0_2:findTF("frame/top/title"), i18n("child_filter_title"))
	setText(arg0_2.cancelBtn:Find("Text"), i18n("island_word_reset"))
	setText(arg0_2.confirmBtn:Find("Text"), i18n("word_ok"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:ResetData()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		arg0_3:emit(IslandScene.ON_INVENTORY_FILTER, arg0_3.values)
		arg0_3:Hide()
	end, SFX_PANEL)

	arg0_3.btns = {}
end

function var0_0.Show(arg0_8, arg1_8)
	var0_0.super.Show(arg0_8)
	assert(arg1_8)

	arg0_8.values = arg1_8:GetData()

	local var0_8 = arg1_8:GetLayoutData()

	arg0_8:Flush(var0_8)
end

function var0_0.Flush(arg0_9, arg1_9)
	arg0_9.uiItemList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg1_9[arg1_10 + 1]
			local var1_10 = arg0_9:InitLayout(var0_10, arg1_10 + 1, arg2_10)

			table.insert(arg0_9.btns, var1_10)
		end
	end)
	arg0_9.uiItemList:align(#arg1_9)
end

function var0_0.InitLayout(arg0_11, arg1_11, arg2_11, arg3_11)
	setText(arg3_11:Find("title/title"), arg1_11.title)

	local var0_11 = UIItemList.New(arg3_11:Find("buttons"), arg3_11:Find("buttons/tpl"))
	local var1_11 = {}

	var0_11:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			setText(arg2_12:Find("Text"), arg1_11.names[arg1_12 + 1])
			setText(arg2_12:Find("mark/Text"), arg1_11.names[arg1_12 + 1])
			setActive(arg2_12:Find("line"), (not (arg1_12 > 0) or arg1_12 % 4 ~= 0) and arg1_12 + 1 ~= #arg1_11.list)

			local var0_12 = arg1_11.list[arg1_12 + 1]
			local var1_12 = arg1_12 == 0

			onButton(arg0_11, arg2_12, function()
				local var0_13 = arg0_11.values[arg2_11]

				if arg1_11.mode == IslandInventoryIndexData.MODE_SINGLE then
					var0_13 = var0_12
				else
					local var1_13 = IslandInventoryIndexData.CheckSelectedAll(arg1_11.list, var0_13)

					var0_13 = arg0_11:HandleMultiClick(var0_12, var0_13, var1_13, var1_12, arg1_11.list[1])
				end

				arg0_11:FlushBtns(var1_11, arg1_11.list, var0_13, arg1_11.mode)

				arg0_11.values[arg2_11] = var0_13
			end, SFX_PANEL)
			table.insert(var1_11, {
				mark = arg2_12:Find("trigger"),
				isAll = var1_12
			})
		end
	end)
	var0_11:align(#arg1_11.list)
	arg0_11:FlushBtns(var1_11, arg1_11.list, arg0_11.values[arg2_11], arg1_11.mode)

	return var1_11
end

function var0_0.HandleMultiClick(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14, arg5_14)
	if arg3_14 and arg1_14 == arg2_14 then
		-- block empty
	elseif arg3_14 and arg1_14 ~= arg2_14 then
		arg2_14 = arg1_14
	elseif arg4_14 then
		arg2_14 = arg5_14
	elseif bit.band(arg2_14, arg1_14) > 0 then
		arg2_14 = bit.bxor(arg2_14, arg1_14)
	else
		arg2_14 = bit.bor(arg2_14, arg1_14)
	end

	arg2_14 = arg2_14 ~= 0 and arg2_14 or arg5_14

	return arg2_14
end

function var0_0.FlushBtns(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	if arg4_15 == IslandInventoryIndexData.MODE_SINGLE then
		for iter0_15, iter1_15 in ipairs(arg1_15) do
			local var0_15 = arg2_15[iter0_15]

			triggerToggle(iter1_15.mark, bit.band(var0_15, arg3_15) > 0)
		end
	elseif arg4_15 == IslandInventoryIndexData.MODE_MULTI then
		if IslandInventoryIndexData.CheckSelectedAll(arg2_15, arg3_15) then
			for iter2_15, iter3_15 in ipairs(arg1_15) do
				triggerToggle(iter3_15.mark, iter3_15.isAll)
			end
		else
			for iter4_15, iter5_15 in ipairs(arg1_15) do
				local var1_15 = arg2_15[iter4_15]

				triggerToggle(iter5_15.mark, not iter5_15.isAll and bit.band(var1_15, arg3_15) > 0)
			end
		end
	end
end

function var0_0.ResetData(arg0_16)
	for iter0_16, iter1_16 in ipairs(arg0_16.btns) do
		for iter2_16, iter3_16 in ipairs(iter1_16) do
			if iter3_16.isAll then
				triggerButton(iter3_16.mark.parent)
			end
		end
	end
end

function var0_0.OnDestroy(arg0_17)
	return
end

return var0_0
