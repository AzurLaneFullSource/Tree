local var0_0 = class("SortGameGrid")
local var1_0 = 3

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._ad = findTF(arg0_1._tf, "ad")
	arg0_1._gridEventTriggerList = {}
	arg0_1._index = arg3_1
	arg0_1._itemsTF = {}
	arg0_1._itemsAnimator = {}
	arg0_1._itemsDftEvent = {}

	for iter0_1 = 1, var1_0 do
		local var0_1 = iter0_1
		local var1_1 = findTF(arg0_1._tf, "ad/" .. var0_1)

		table.insert(arg0_1._itemsTF, var1_1)

		local var2_1 = GetOrAddComponent(findTF(var1_1, "trigger"), typeof(EventTriggerListener))

		table.insert(arg0_1._gridEventTriggerList, var2_1)

		local var3_1 = GetOrAddComponent(var1_1, typeof(Animator))

		table.insert(arg0_1._itemsAnimator, var3_1)

		local var4_1 = GetOrAddComponent(var1_1, typeof(DftAniEvent))

		var4_1:SetEndEvent(function()
			if arg0_1._removeDic and arg0_1._removeDic[var0_1] then
				arg0_1._removeDic[var0_1] = nil

				local var0_2 = arg0_1._itemIdDic[var0_1][1]

				arg0_1._itemIdDic[var0_1][1] = 0

				if not arg0_1:MoveItemToBottom() then
					arg0_1:UpdateItem(var0_1)
				elseif arg0_1._moveBottomCallback then
					arg0_1._moveBottomCallback(arg0_1._index)
				end
			end
		end)
		table.insert(arg0_1._itemsDftEvent, var4_1)
		arg0_1:SetItemSelect(var0_1, false)
		arg0_1:SetItemLock(var0_1, false)
	end

	arg0_1._currentInputCount = 0
	arg0_1._left, arg0_1._middle, arg0_1._right = {}, {}, {}
	arg0_1._itemIdDic = {
		arg0_1._left,
		arg0_1._middle,
		arg0_1._right
	}

	for iter1_1 = 1, SortGameConst.grid_max_layer do
		table.insert(arg0_1._left, 0)
		table.insert(arg0_1._middle, 0)
		table.insert(arg0_1._right, 0)
	end
end

function var0_0.SetRemoveEventCallback(arg0_3, arg1_3)
	arg0_3._itemRemoveCallback = arg1_3
end

function var0_0.SetMoveBottomCallback(arg0_4, arg1_4)
	arg0_4._moveBottomCallback = arg1_4
end

function var0_0.SetScoreCallback(arg0_5, arg1_5)
	arg0_5._scoreCallback = arg1_5
end

function var0_0.SetType(arg0_6, arg1_6)
	arg0_6._gridType = arg1_6

	arg0_6:UpdateUI()
end

function var0_0.GetType(arg0_7)
	return arg0_7._gridType
end

function var0_0.GetInputLayerCount(arg0_8)
	return arg0_8._currentInputCount
end

function var0_0.HasInputEmptyLayer(arg0_9)
	if arg0_9._gridType == SortGameConst.grid_type_empty then
		return false
	end

	return arg0_9:GetInputEmptyLayer() <= SortGameConst.grid_max_layer
end

function var0_0.GetInputEmptyLayer(arg0_10)
	local var0_10 = 1

	for iter0_10 = 1, SortGameConst.grid_max_layer do
		local var1_10 = false

		for iter1_10 = 1, var1_0 do
			if arg0_10._itemIdDic[iter1_10][iter0_10] ~= 0 then
				var1_10 = true

				break
			end
		end

		if var1_10 then
			var0_10 = iter0_10 + 1
		end
	end

	return var0_10
end

function var0_0.UpdateUI(arg0_11)
	if arg0_11._gridType == SortGameConst.grid_type_empty then
		arg0_11:SetVisible(false)
	else
		arg0_11:SetVisible(true)
	end

	for iter0_11 = 1, var1_0 do
		if arg0_11._gridType == SortGameConst.grid_type_out then
			arg0_11:SetItemLock(iter0_11, iter0_11 ~= 2)
		else
			arg0_11:SetItemLock(iter0_11, false)
		end
	end
end

function var0_0.SetItemLock(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12._itemsTF[arg1_12]

	setActive(findTF(var0_12, "lock"), arg2_12)
end

function var0_0.PassItem(arg0_13)
	arg0_13._removeDic = {}

	for iter0_13 = 1, #arg0_13._itemsAnimator do
		arg0_13._removeDic[iter0_13] = true

		arg0_13._itemsAnimator[iter0_13]:SetTrigger("pass")
	end

	if arg0_13._scoreCallback then
		arg0_13._scoreCallback(arg0_13._index, arg0_13._itemIdDic[1][1])
	end
end

function var0_0.GetPosition(arg0_14)
	return arg0_14._tf.position
end

function var0_0.SetVisible(arg0_15, arg1_15)
	setActive(arg0_15._ad, arg1_15)
end

function var0_0.GetEmptyLayerFirst(arg0_16)
	local var0_16 = 0

	for iter0_16 = 1, SortGameConst.grid_max_layer do
		local var1_16 = false

		for iter1_16 = 1, var1_0 do
			if arg0_16._itemIdDic[iter1_16][iter0_16] ~= 0 then
				var1_16 = true

				break
			end
		end

		if not var1_16 then
			var0_16 = iter0_16

			break
		end
	end

	return var0_16
end

function var0_0.GetLayerEmptyFlag(arg0_17, arg1_17)
	if arg1_17 > SortGameConst.grid_max_layer then
		return true
	end

	local var0_17 = false

	for iter0_17 = 1, var1_0 do
		if arg0_17._itemIdDic[iter0_17][arg1_17] ~= 0 then
			var0_17 = true

			break
		end
	end

	return not var0_17
end

function var0_0.GetBottomIds(arg0_18)
	local var0_18 = {}

	for iter0_18 = 1, var1_0 do
		table.insert(var0_18, arg0_18._itemIdDic[iter0_18][1])
	end

	return var0_18
end

function var0_0.GetBottomId(arg0_19, arg1_19)
	return arg0_19._itemIdDic[arg1_19][1]
end

function var0_0.GetAllIds(arg0_20)
	local var0_20 = {}

	for iter0_20 = 1, var1_0 do
		local var1_20 = {}

		for iter1_20 = 1, SortGameConst.grid_max_layer do
			table.insert(var0_20, arg0_20._itemIdDic[iter0_20][iter1_20])
		end
	end

	return var0_20
end

function var0_0.SetOffset(arg0_21, arg1_21)
	arg0_21._offset = arg1_21
	arg0_21._ad.anchoredPosition = Vector2(arg1_21[1] * SortGameConst.grid_bound[1], arg1_21[2] * SortGameConst.grid_bound[2])
end

function var0_0.checkItemPass(arg0_22)
	if arg0_22._gridType == SortGameConst.grid_type_empty or arg0_22._gridType == SortGameConst.grid_type_out then
		return false
	end

	local var0_22 = arg0_22:GetItemBottomId(1)
	local var1_22 = arg0_22:GetItemBottomId(2)
	local var2_22 = arg0_22:GetItemBottomId(3)

	if var0_22 and var1_22 and var2_22 and var0_22 ~= 0 and var1_22 ~= 0 and var2_22 ~= 0 and var0_22 == var1_22 and var1_22 == var2_22 then
		if arg0_22._itemRemoveCallback then
			arg0_22._itemRemoveCallback(arg0_22._index, var0_22)
			arg0_22._itemRemoveCallback(arg0_22._index, var1_22)
			arg0_22._itemRemoveCallback(arg0_22._index, var2_22)
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SortGameConst.SFX_PASS)
		arg0_22:PassItem()
	end
end

function var0_0.InputIds(arg0_23, arg1_23)
	local var0_23 = arg0_23:GetInputEmptyLayer()

	if var0_23 <= SortGameConst.grid_max_layer then
		print("插入层数 = " .. var0_23)

		for iter0_23 = 1, var1_0 do
			arg0_23._itemIdDic[iter0_23][var0_23] = arg1_23[iter0_23]

			arg0_23:UpdateItem(iter0_23)
		end

		setActive(arg0_23._ad, true)

		arg0_23._currentInputCount = arg0_23._currentInputCount + 1
	else
		warning("插入失败！数据对齐出问题，需要排查")
	end
end

function var0_0.ReplaceId(arg0_24, arg1_24, arg2_24)
	arg0_24._itemIdDic[arg1_24][1] = arg2_24

	arg0_24:UpdateItem(arg1_24)
end

function var0_0.UpdateItem(arg0_25, arg1_25)
	if arg0_25._itemIdDic[arg1_25][1] ~= 0 then
		arg0_25:SetItemIcon(arg1_25, arg0_25._itemIdDic[arg1_25][1], "top")
	end

	if arg0_25._itemIdDic[arg1_25][2] ~= 0 then
		arg0_25:SetItemIcon(arg1_25, arg0_25._itemIdDic[arg1_25][2], "bottom")
	end

	setActive(findTF(arg0_25._itemsTF[arg1_25], "top"), arg0_25._itemIdDic[arg1_25][1] ~= 0)
	setActive(findTF(arg0_25._itemsTF[arg1_25], "bottom"), arg0_25._itemIdDic[arg1_25][2] ~= 0)
end

function var0_0.MoveItemToBottom(arg0_26, arg1_26)
	local var0_26 = arg1_26 and arg1_26 + 1 or 1
	local var1_26 = arg0_26:GetEmptyLayerFirst()

	if var1_26 >= 1 and not arg0_26:GetLayerEmptyFlag(var1_26 + 1) then
		for iter0_26 = 1, var1_0 do
			arg0_26._itemIdDic[iter0_26][var1_26] = arg0_26._itemIdDic[iter0_26][var1_26 + 1]
			arg0_26._itemIdDic[iter0_26][var1_26 + 1] = 0
		end

		return arg0_26:MoveItemToBottom(var0_26)
	end

	if var0_26 > 1 then
		for iter1_26 = 1, var1_0 do
			arg0_26:UpdateItem(iter1_26)
			arg0_26._itemsAnimator[iter1_26]:SetTrigger("show")
		end
	end

	return var0_26 > 1
end

function var0_0.SetShowAniamtion(arg0_27)
	for iter0_27 = 1, var1_0 do
		arg0_27._itemsAnimator[iter0_27]:SetTrigger("show")
	end
end

function var0_0.GetItemBottomId(arg0_28, arg1_28)
	return arg0_28._itemIdDic[arg1_28][1]
end

function var0_0.InSertItem(arg0_29, arg1_29, arg2_29)
	if arg0_29._itemIdDic and arg0_29._itemIdDic[arg1_29] then
		arg0_29._itemIdDic[arg1_29][1] = arg2_29

		arg0_29:UpdateItem(arg1_29)
	end

	if not arg0_29:checkItemPass() then
		arg0_29:UpdateItem(arg1_29)
	end
end

function var0_0.CheckMoveBottom(arg0_30)
	if arg0_30:MoveItemToBottom() and arg0_30._moveBottomCallback then
		arg0_30._moveBottomCallback(arg0_30._index)
	end
end

function var0_0.SetItemAlpha(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg0_31._itemsTF[arg1_31]
	local var1_31 = arg2_31 and "alpha" or "normal"

	arg0_31._itemsAnimator[arg1_31]:SetTrigger(var1_31)
	print("set alpha " .. arg1_31 .. " " .. tostring(arg2_31))
end

function var0_0.SetItemSelect(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg0_32._itemsTF[arg1_32]

	setActive(findTF(var0_32, "select"), arg2_32)
end

function var0_0.SetItemIcon(arg0_33, arg1_33, arg2_33, arg3_33)
	local var0_33 = arg0_33._itemsTF[arg1_33]
	local var1_33 = findTF(var0_33, arg3_33 .. "/icon")

	setActive(var1_33, false)
	GetSpriteFromAtlasAsync(SortGameConst.ui_atlas, "item_" .. arg2_33, function(arg0_34)
		if var1_33 then
			setImageSprite(var1_33, arg0_34, true)
			setActive(var1_33, true)
		end
	end)
end

function var0_0.AddItemEventCallback(arg0_35, arg1_35, arg2_35, arg3_35, arg4_35)
	for iter0_35 = 1, var1_0 do
		local var0_35 = iter0_35
		local var1_35 = arg0_35._gridEventTriggerList[var0_35]

		if var1_35 then
			var1_35:AddDragFunc(function(arg0_36, arg1_36)
				if arg0_35._itemIdDic[var0_35][1] == 0 then
					return
				end

				if arg1_35 then
					arg1_35(arg0_35._index, var0_35, arg1_36)
				end
			end)
			var1_35:AddDragEndFunc(function(arg0_37, arg1_37)
				if arg0_35._itemIdDic[var0_35][1] == 0 then
					return
				end

				if arg2_35 then
					arg2_35(arg0_35._index, var0_35, arg1_37)
				end

				setActive(arg0_35._itemsTF[var0_35], true)
			end)
			var1_35:AddPointEnterFunc(function(arg0_38, arg1_38)
				if arg0_35._gridType == SortGameConst.grid_type_out then
					return
				end

				if arg0_35._itemIdDic[var0_35][1] ~= 0 then
					return
				end

				if arg3_35 then
					arg3_35(arg0_35._index, var0_35, arg1_38)
				end
			end)
			var1_35:AddPointExitFunc(function(arg0_39, arg1_39)
				if arg0_35._gridType == SortGameConst.grid_type_out then
					return
				end

				if arg0_35._itemIdDic[var0_35][1] ~= 0 then
					return
				end

				if arg4_35 then
					arg4_35(arg0_35._index, var0_35, arg1_39)
				end
			end)
		end
	end
end

function var0_0.ClearItems(arg0_40)
	arg0_40._currentInputCount = 0

	for iter0_40 = 1, var1_0 do
		for iter1_40 = 1, SortGameConst.grid_max_layer do
			arg0_40._itemIdDic[iter0_40][iter1_40] = 0
		end

		arg0_40:UpdateItem(iter0_40)
	end
end

function var0_0.GetInputEmptyCount(arg0_41)
	local var0_41 = 0

	for iter0_41 = 1, var1_0 do
		if arg0_41._gridType ~= SortGameConst.grid_type_out and arg0_41._gridType ~= SortGameConst.grid_type_empty and arg0_41._itemIdDic[iter0_41][1] == 0 then
			var0_41 = var0_41 + 1
		end
	end

	return var0_41
end

function var0_0.Stop(arg0_42)
	for iter0_42 = 1, #arg0_42._itemsAnimator do
		arg0_42._itemsAnimator[iter0_42].speed = 0
	end
end

function var0_0.Resume(arg0_43)
	for iter0_43 = 1, #arg0_43._itemsAnimator do
		arg0_43._itemsAnimator[iter0_43].speed = 1
	end
end

function var0_0.Clear(arg0_44)
	arg0_44._currentInputCount = 0

	for iter0_44 = 1, #arg0_44._itemsAnimator do
		arg0_44._itemsAnimator[iter0_44].speed = 1
	end

	for iter1_44 = 1, var1_0 do
		for iter2_44 = 1, SortGameConst.grid_max_layer do
			arg0_44._itemIdDic[iter1_44][iter2_44] = 0
		end

		arg0_44:SetItemSelect(iter1_44, false)
	end

	setActive(arg0_44._ad, false)

	for iter3_44 = 1, var1_0 do
		arg0_44:UpdateItem(iter3_44)
	end

	arg0_44._removeDic = {}
end

function var0_0.Dispose(arg0_45)
	for iter0_45 = 1, #arg0_45._gridEventTriggerList do
		ClearEventTrigger(arg0_45._gridEventTriggerList[iter0_45])
	end
end

return var0_0
