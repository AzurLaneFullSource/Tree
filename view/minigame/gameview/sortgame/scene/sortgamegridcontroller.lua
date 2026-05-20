local var0_0 = class("SortGameGridController")
local var1_0 = 3
local var2_0 = 4
local var3_0 = 3
local var4_0 = Vector2(0, -25)

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._runtimeData = arg3_1
	arg0_1._gridTpl = findTF(arg0_1._tf, "grids/grid_tpl")

	setActive(arg0_1._gridTpl, false)

	arg0_1._dragGridTF = findTF(arg0_1._tf, "drag_grid")

	setActive(arg0_1._dragGridTF, false)

	arg0_1._contentAniamtor = arg0_1._tf:GetComponent(typeof(Animator))
	arg0_1._contentDftEvent = arg0_1._tf:GetComponent(typeof(DftAniEvent))

	arg0_1._contentDftEvent:SetEndEvent(function()
		arg0_1:ResetGrid()
	end)

	arg0_1._grids = {}

	for iter0_1 = 1, var1_0 * var2_0 do
		local var0_1 = iter0_1
		local var1_1 = findTF(arg0_1._tf, "grids/grid_" .. var0_1)

		setParent(var1_1, arg0_1._gridTpl.parent)
		setActive(var1_1, true)

		local var2_1 = SortGameGrid.New(var1_1, arg0_1._event, var0_1)

		arg0_1._grids[iter0_1] = var2_1

		arg0_1._grids[iter0_1]:SetRemoveEventCallback(function(arg0_3, arg1_3)
			arg0_1:removeItemIds(arg1_3)
			arg0_1:checkGameOver()
		end)
		arg0_1._grids[iter0_1]:SetMoveBottomCallback(function(arg0_4)
			arg0_1:checkGridInput(arg0_1._grids[arg0_4])
		end)
		arg0_1._grids[iter0_1]:SetScoreCallback(function(arg0_5, arg1_5)
			if arg0_1._comboIndex then
				arg0_1._comboIndex = arg0_1._comboIndex + 1
			else
				arg0_1._comboIndex = 0
			end

			arg0_1._comboTime = SortGameConst.combo_time
			arg0_1._waitTime = 0

			arg0_1._event:emit(SimpleMGEvent.ADD_SCORE, {
				num = arg0_1:GetScore(arg1_5),
				combo = arg0_1._comboIndex,
				position = arg0_1._grids[arg0_5]:GetPosition()
			})

			if arg0_1._wantedItem and arg0_1._wantedItem == arg1_5 then
				arg0_1._wantedItem = nil
				arg0_1._wantedStepTime = nil

				arg0_1._event:emit(SortGameView.WANTED_ITEM_REFRESH, {})

				local var0_5 = arg0_1._runtimeData:GetPlayerName(arg0_1._runtimeData:GetPlayerIdByItem(arg1_5))

				arg0_1._event:emit(SortGameView.PLAYER_SPEAK, arg0_1._runtimeData:GetSpeakData(SortGameConst.sort_conifg_type_chat, var0_5))
			end

			if table.contains(SortGameConst.combo_speak_num, arg0_1._comboIndex) then
				arg0_1._event:emit(SortGameView.PLAYER_SPEAK, arg0_1._runtimeData:GetSpeakData(SortGameConst.sort_conifg_type_combo))
			end
		end)
		var2_1:AddItemEventCallback(function(arg0_6, arg1_6, arg2_6)
			arg0_1:onGridDrag(arg0_6, arg1_6, arg2_6)
		end, function(arg0_7, arg1_7, arg2_7)
			arg0_1:onGridDragEnd(arg0_7, arg1_7, arg2_7)
		end, function(arg0_8, arg1_8, arg2_8)
			arg0_1:onGridEnter(arg0_8, arg1_8, arg2_8)
		end, function(arg0_9, arg1_9, arg2_9)
			arg0_1:onGridExit(arg0_9, arg1_9, arg2_9)
		end)
	end

	arg0_1._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
end

function var0_0.checkGameOver(arg0_10)
	if #arg0_10._itemIds == 0 and #arg0_10._itemIdsPool == 0 then
		arg0_10._event:emit(SortGameView.GAME_OVER_TIME)
	end
end

function var0_0.removeItemIds(arg0_11, arg1_11)
	for iter0_11 = 1, #arg0_11._itemIds do
		if arg0_11._itemIds[iter0_11] == arg1_11 then
			print("item_id = " .. arg1_11 .. " 被消除了")
			table.remove(arg0_11._itemIds, iter0_11)

			return
		end
	end

	warning("没有在格子中找到这个id = " .. arg1_11)
end

function var0_0.onGridDrag(arg0_12, arg1_12, arg2_12, arg3_12)
	if arg0_12._dragGridIndex ~= nil and arg0_12._dragGridIndex ~= arg1_12 then
		return
	end

	local var0_12 = arg0_12._grids[arg1_12]

	if not var0_12 then
		return
	end

	if not arg0_12._dragGridIndex then
		arg0_12._startDragPos = arg3_12.position
		arg0_12._dragGridStartPos = arg0_12._tf:InverseTransformPoint(arg0_12._uiCamera:ScreenToWorldPoint(arg0_12._startDragPos))

		setActive(arg0_12._dragGridTF, true)

		arg0_12._dragGridIndex = arg1_12
		arg0_12._dragGridItemIndex = arg2_12

		local var1_12 = var0_12:GetItemBottomId(arg2_12)

		var0_12:SetItemAlpha(arg2_12, true)

		if var1_12 and var1_12 > 0 then
			GetSpriteFromAtlasAsync(SortGameConst.ui_atlas, "item_" .. var1_12, function(arg0_13)
				setImageSprite(arg0_12._dragGridTF, arg0_13, true)
			end)
		end

		arg0_12._dragScreenRate = arg0_12:GetScreentScaleRate()
	end

	local var2_12 = arg0_12._dragGridStartPos.x + (var4_0.x + (arg3_12.position.x - arg0_12._startDragPos.x)) * arg0_12._dragScreenRate.x
	local var3_12 = arg0_12._dragGridStartPos.y + (var4_0.y + (arg3_12.position.y - arg0_12._startDragPos.y)) * arg0_12._dragScreenRate.y

	arg0_12._dragGridTF.anchoredPosition = Vector2(var2_12, var3_12)
end

function var0_0.Start(arg0_14)
	return
end

function var0_0.onGridDragEnd(arg0_15, arg1_15, arg2_15, arg3_15)
	if not arg0_15._dragGridIndex then
		return
	end

	setActive(arg0_15._dragGridTF, false)

	local var0_15 = false

	if arg0_15._dragGridIndex and arg0_15._enterGridIndex then
		if arg0_15._dragGridIndex == arg0_15._enterGridIndex and arg0_15._dragGridItemIndex ~= arg0_15._enterGridItemIndex then
			var0_15 = true
		elseif arg0_15._dragGridIndex ~= arg0_15._enterGridIndex then
			var0_15 = true
		end
	end

	arg0_15._grids[arg1_15]:SetItemAlpha(arg2_15, false)

	if var0_15 then
		local var1_15 = arg0_15._grids[arg0_15._dragGridIndex]
		local var2_15 = arg0_15._grids[arg0_15._enterGridIndex]
		local var3_15 = var1_15:GetItemBottomId(arg0_15._dragGridItemIndex)
		local var4_15 = var2_15:GetItemBottomId(arg0_15._enterGridItemIndex)

		var1_15:InSertItem(arg0_15._dragGridItemIndex, var4_15)
		var2_15:InSertItem(arg0_15._enterGridItemIndex, var3_15)
		var1_15:CheckMoveBottom()
		var2_15:CheckMoveBottom()
	end

	if arg0_15._enterGridIndex and arg0_15._grids[arg0_15._enterGridIndex] then
		arg0_15._grids[arg0_15._enterGridIndex]:SetItemSelect(arg0_15._enterGridItemIndex, false)
	end

	if arg0_15._dragGridIndex and arg0_15._grids[arg0_15._dragGridIndex] and arg0_15._grids[arg0_15._dragGridIndex]:GetType() == SortGameConst.grid_type_out and arg0_15._grids[arg0_15._dragGridIndex]:GetInputEmptyLayer() == 1 then
		arg0_15._grids[arg0_15._dragGridIndex]:SetItemLock(2, true)
	end

	arg0_15._dragGridIndex = nil
	arg0_15._enterGridIndex = nil
	arg0_15._dragGridItemIndex = nil
	arg0_15._enterGridItemIndex = nil
end

function var0_0.onGridEnter(arg0_16, arg1_16, arg2_16, arg3_16)
	if not arg0_16._dragGridIndex then
		return
	end

	if arg0_16._dragGridIndex == arg1_16 and arg0_16._dragGridItemIndex == arg2_16 then
		return
	end

	if arg0_16._enterGridIndex and arg0_16._grids[arg0_16._enterGridIndex] then
		arg0_16._grids[arg0_16._enterGridIndex]:SetItemSelect(arg0_16._enterGridItemIndex, false)
	end

	arg0_16._enterGridIndex = arg1_16
	arg0_16._enterGridItemIndex = arg2_16

	if arg1_16 and arg0_16._grids[arg1_16] then
		arg0_16._grids[arg0_16._enterGridIndex]:SetItemSelect(arg2_16, true)
	end
end

function var0_0.onGridExit(arg0_17, arg1_17, arg2_17, arg3_17)
	if not arg0_17._dragGridIndex then
		return
	end

	if not arg0_17._enterGridIndex then
		return
	end

	if arg0_17._enterGridIndex == arg1_17 and arg0_17._enterGridItemIndex == arg2_17 then
		if arg0_17._enterGridIndex and arg0_17._grids[arg0_17._enterGridIndex] then
			arg0_17._grids[arg0_17._enterGridIndex]:SetItemSelect(arg0_17._enterGridItemIndex, false)
		end

		arg0_17._enterGridIndex = nil
		arg0_17._enterGridItemIndex = nil
	end
end

function var0_0.checkGridInput(arg0_18, arg1_18)
	if arg1_18:GetInputLayerCount() < arg0_18._itemLayerMax and arg1_18:GetInputEmptyLayer() <= SortGameConst.grid_max_layer then
		arg0_18:InPutGrid(arg1_18, true)

		arg0_18._checkLockTime = 0

		return true
	end

	return false
end

function var0_0.GetItemIdList(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = {}
	local var1_19 = Clone(arg1_19)
	local var2_19 = 1

	for iter0_19 = 1, arg2_19 do
		for iter1_19 = 1, var3_0 * arg3_19 do
			table.insert(var0_19, var1_19[var2_19])
		end

		var2_19 = var2_19 + 1 > #var1_19 and 1 or var2_19 + 1
	end

	return var0_19
end

function var0_0.ShuffleList(arg0_20, arg1_20, arg2_20)
	randomRange = arg2_20 and math.min(arg2_20, #arg1_20) or #arg1_20

	for iter0_20 = randomRange, 2, -1 do
		local var0_20 = math.random(1, iter0_20)

		arg1_20[iter0_20], arg1_20[var0_20] = arg1_20[var0_20], arg1_20[iter0_20]
	end
end

function var0_0.InPutGrid(arg0_21, arg1_21, arg2_21)
	local var0_21 = 0

	if arg1_21:GetType() > 0 then
		local var1_21 = {}
		local var2_21 = arg0_21:GetGridIdMap(arg1_21, arg0_21._normalItemWeight)
		local var3_21

		if arg2_21 then
			var3_21 = arg0_21:GetIdsDic(arg0_21._itemIds)
		end

		for iter0_21 = 1, #var2_21 do
			if var2_21[iter0_21] ~= 0 and #arg0_21._itemIdsPool > 0 then
				local var4_21

				if iter0_21 == 3 and var1_21[1] == var1_21[2] and var1_21[1] ~= 0 then
					print("当前第三个格子需要优先匹配前两个格子的id，id = " .. var1_21[1])

					var4_21 = var1_21[1]
				end

				local var5_21 = arg0_21:GetIdFromPool(var3_21, var4_21)

				var0_21 = var0_21 + 1

				table.insert(var1_21, var5_21)
			else
				table.insert(var1_21, 0)
			end
		end

		print("插入id列表 = " .. table.concat(var1_21, ","))
		arg1_21:InputIds(var1_21)
	end

	return var0_21
end

function var0_0.GetIdFromPool(arg0_22, arg1_22, arg2_22)
	if arg0_22._itemIdsPool and #arg0_22._itemIdsPool > 0 then
		if arg1_22 then
			if arg0_22:GetPassItemCount(arg1_22) <= SortGameConst.pass_limit_num then
				local var0_22
				local var1_22 = 0

				for iter0_22, iter1_22 in pairs(arg1_22) do
					if var1_22 < iter1_22 and arg0_22:checkIdExist(arg0_22._itemIdsPool, iter0_22) and iter0_22 ~= arg2_22 then
						var1_22 = iter1_22
						var0_22 = iter0_22
					end
				end

				if var0_22 then
					for iter2_22 = 1, #arg0_22._itemIdsPool do
						if arg0_22._itemIdsPool[iter2_22] == var0_22 then
							local var2_22 = table.remove(arg0_22._itemIdsPool, iter2_22)

							table.insert(arg0_22._itemIds, var2_22)

							arg1_22[var0_22] = arg1_22[var0_22] + 1

							print("匹配成功，匹配id = " .. var0_22)

							return var0_22
						end
					end
				end
			else
				print("本次从池子中取不到元素， 长度 = " .. #arg0_22._itemIdsPool)
			end
		end

		local var3_22 = table.remove(arg0_22._itemIdsPool, 1)

		table.insert(arg0_22._itemIds, var3_22)

		return var3_22
	end

	warning("id池已经没有id了")

	return 0
end

function var0_0.checkIdExist(arg0_23, arg1_23, arg2_23)
	return table.contains(arg1_23, arg2_23)
end

function var0_0.GetScreentScaleRate(arg0_24)
	local var0_24 = UnityEngine.Screen.width
	local var1_24 = UnityEngine.Screen.height
	local var2_24 = tf(GameObject.Find("UICamera/Canvas"))
	local var3_24 = var2_24.sizeDelta.x
	local var4_24 = var2_24.sizeDelta.y

	return Vector2(var3_24 / var0_24, var4_24 / var1_24)
end

function var0_0.GetGridIdMap(arg0_25, arg1_25, arg2_25)
	local var0_25 = {
		0,
		0,
		0
	}
	local var1_25 = arg1_25:GetType()

	if var1_25 == SortGameConst.grid_type_empty then
		var0_25 = {
			0,
			0,
			0
		}
	elseif var1_25 == SortGameConst.grid_type_normal then
		local var2_25 = math.random()
		local var3_25 = 1

		for iter0_25 = 1, #arg2_25 do
			if iter0_25 == 1 then
				if var2_25 <= arg2_25[iter0_25] then
					var3_25 = iter0_25
				end
			elseif var2_25 > arg2_25[iter0_25 - 1] and var2_25 <= arg2_25[iter0_25] then
				var3_25 = iter0_25

				break
			end
		end

		if var3_25 == 1 then
			var0_25 = {
				1,
				0,
				0
			}
		elseif var3_25 == 2 then
			var0_25 = {
				1,
				1,
				0
			}
		else
			var0_25 = {
				1,
				1,
				1
			}
		end

		arg0_25:shuffleArray(var0_25)
	elseif var1_25 == SortGameConst.grid_type_two then
		var0_25 = {
			1,
			1,
			0
		}

		arg0_25:shuffleArray(var0_25)
	elseif var1_25 == SortGameConst.grid_type_out then
		var0_25 = {
			0,
			1,
			0
		}
	end

	return var0_25
end

function var0_0.shuffleArray(arg0_26, arg1_26)
	for iter0_26 = #arg1_26, 2, -1 do
		local var0_26 = math.random(1, iter0_26)

		arg1_26[iter0_26], arg1_26[var0_26] = arg1_26[var0_26], arg1_26[iter0_26]
	end
end

function var0_0.CalculateWeight(arg0_27, arg1_27)
	local var0_27 = {}
	local var1_27 = 0

	for iter0_27 = 1, #arg1_27 do
		var1_27 = var1_27 + arg1_27[iter0_27]
	end

	local var2_27 = 0

	for iter1_27 = 1, #arg1_27 do
		var2_27 = var2_27 + arg1_27[iter1_27]

		table.insert(var0_27, var2_27 / var1_27)
	end

	return var0_27
end

function var0_0.GetScore(arg0_28, arg1_28)
	local var0_28 = arg0_28._wantedItem and arg1_28 == arg0_28._wantedItem and SortGameConst.wanted_score_num or SortGameConst.score_num

	if not arg0_28._comboIndex or arg0_28._comboIndex == 0 then
		return var0_28
	else
		for iter0_28 = 1, #SortGameConst.combo_rate do
			local var1_28 = SortGameConst.combo_rate[iter0_28]

			if arg0_28._comboIndex >= var1_28.range[1] and arg0_28._comboIndex <= var1_28.range[2] then
				return math.floor(var0_28 * var1_28.rate)
			end
		end

		return var0_28
	end
end

function var0_0.Prepare(arg0_29)
	arg0_29._dragGridIndex = nil
	arg0_29._enterGridIndex = nil
	arg0_29._dragGridItemIndex = nil
	arg0_29._enterGridItemIndex = nil
	arg0_29._waitTime = 0
	arg0_29._comboIndex = 0
	arg0_29._comboTime = nil

	local var0_29 = arg0_29._runtimeData:GetComonItems()
	local var1_29 = arg0_29._runtimeData:GetPlayers()
	local var2_29 = arg0_29._runtimeData:GetChapterConfig("item_count")
	local var3_29 = arg0_29._runtimeData:GetChapterConfig("player_own_item_count") or 1
	local var4_29 = arg0_29._runtimeData:GetChapterConfig("item_rate")
	local var5_29 = arg0_29._runtimeData:GetChapterConfig("grid_weight")

	arg0_29._normalItemWeight = arg0_29:CalculateWeight(var5_29)

	local var6_29 = arg0_29:GetItemIdList(var0_29, var2_29, var4_29)
	local var7_29 = {}

	for iter0_29 = 1, #var1_29 do
		local var8_29 = arg0_29._runtimeData:GetPlayerItems(var1_29[iter0_29])

		for iter1_29 = 1, #var8_29 do
			table.insert(var7_29, var8_29[iter1_29])
		end
	end

	local var9_29 = arg0_29:GetItemIdList(var7_29, var3_29, 1)

	arg0_29._itemIdsPool = {}

	for iter2_29 = 1, #var6_29 do
		table.insert(arg0_29._itemIdsPool, var6_29[iter2_29])
	end

	for iter3_29 = 1, #var9_29 do
		table.insert(arg0_29._itemIdsPool, var9_29[iter3_29])
	end

	arg0_29._itemIds = {}

	local var10_29 = {}

	for iter4_29 = 1, SortGameConst.init_pass_num do
		local var11_29 = arg0_29._itemIdsPool[math.random(1, #arg0_29._itemIdsPool)]
		local var12_29 = 0

		for iter5_29 = #arg0_29._itemIdsPool, 1, -1 do
			if arg0_29._itemIdsPool[iter5_29] == var11_29 then
				table.insert(var10_29, table.remove(arg0_29._itemIdsPool, iter5_29))

				var12_29 = var12_29 + 1

				if var12_29 == 3 then
					break
				end
			end
		end
	end

	arg0_29:ShuffleList(arg0_29._itemIdsPool)

	if #var10_29 > 0 then
		for iter6_29 = 1, #var10_29 do
			table.insert(arg0_29._itemIdsPool, 1, var10_29[iter6_29])
		end

		local var13_29 = {}
	end

	arg0_29:ShuffleList(arg0_29._itemIdsPool, 18)

	arg0_29._activeGridCount = 0
	arg0_29._boundsData = arg0_29._runtimeData:GetBoundConfig()
	arg0_29._offsetData = arg0_29._runtimeData:GetOffsetConfig()
	arg0_29._itemLayerMax = arg0_29._runtimeData:GetChapterConfig("item_layer_max")

	for iter7_29 = 1, #arg0_29._boundsData do
		local var14_29 = iter7_29
		local var15_29 = arg0_29._boundsData[iter7_29]

		for iter8_29 = 1, #var15_29 do
			local var16_29 = iter8_29
			local var17_29 = (var14_29 - 1) * var2_0 + iter8_29

			arg0_29._activeGridCount = var15_29[iter8_29] > 0 and arg0_29._activeGridCount + 1 or arg0_29._activeGridCount

			arg0_29._grids[var17_29]:SetType(var15_29[iter8_29])
		end
	end

	for iter9_29 = 1, #arg0_29._offsetData do
		local var18_29 = arg0_29._offsetData[iter9_29]
		local var19_29 = arg0_29._grids[iter9_29]

		if var19_29 then
			var19_29:SetOffset(var18_29)
		end
	end

	for iter10_29 = 1, SortGameConst.grid_max_layer do
		for iter11_29 = 1, #arg0_29._grids do
			arg0_29:InPutGrid(arg0_29._grids[iter11_29], false)
		end
	end

	arg0_29._wantedStepTime = nil
	arg0_29._wantedItem = nil
	arg0_29._wantedRefreshTime = nil
	arg0_29._checkLockTime = 0
end

function var0_0.Step(arg0_30, arg1_30, arg2_30)
	arg0_30._gameTime = arg2_30

	if arg0_30._comboTime and arg0_30._comboTime >= 0 then
		arg0_30._comboTime = arg0_30._comboTime - arg1_30

		if arg0_30._comboTime <= 0 then
			arg0_30._comboIndex = nil
			arg0_30._comboTime = nil
		end
	end

	arg0_30._waitTime = arg0_30._waitTime + arg1_30

	if arg0_30._waitTime >= SortGameConst.wait_speak_time then
		arg0_30._waitTime = 0

		arg0_30._event:emit(SortGameView.PLAYER_SPEAK, arg0_30._runtimeData:GetSpeakData(SortGameConst.sort_conifg_type_wait))
	end

	if not arg0_30._wantedStepTime then
		if not arg0_30._wantedRefreshTime then
			arg0_30._wantedRefreshTime = SortGameConst.wanted_refresh_time
		end

		if arg0_30._wantedRefreshTime >= 0 then
			arg0_30._wantedRefreshTime = arg0_30._wantedRefreshTime - arg1_30

			if arg0_30._wantedRefreshTime <= 0 then
				if math.random() < SortGameConst.wanted_rate then
					arg0_30._wantedItem = arg0_30._runtimeData:GetRandomWantedItem(arg0_30:GetAllBottomIds())

					if arg0_30._wantedItem then
						local var0_30 = arg0_30._runtimeData:GetPlayerIdByItem(arg0_30._wantedItem)

						arg0_30._event:emit(SortGameView.WANTED_ITEM_REFRESH, {
							item_id = arg0_30._wantedItem,
							player_prefab = SortGameConst.player_data[var0_30].prefab
						})

						arg0_30._wantedStepTime = SortGameConst.wanted_step_time
					end
				end

				arg0_30._wantedRefreshTime = nil
			end
		end
	elseif arg0_30._wantedStepTime >= 0 then
		arg0_30._wantedStepTime = arg0_30._wantedStepTime - arg1_30

		if arg0_30._wantedStepTime <= 0 then
			arg0_30._wantedItem = nil
			arg0_30._wantedStepTime = nil

			arg0_30._event:emit(SortGameView.WANTED_ITEM_REFRESH, {})
		end
	end

	if arg0_30._wantedItem then
		if arg0_30._wantedStepIndexCheck == nil then
			arg0_30._wantedStepIndexCheck = 30
		end

		arg0_30._wantedStepIndexCheck = arg0_30._wantedStepIndexCheck - 1

		if arg0_30._wantedStepIndexCheck <= 0 then
			arg0_30._wantedStepIndexCheck = nil

			if not arg0_30:checkIdExist(arg0_30:GetAllBottomIds(), arg0_30._wantedItem) then
				arg0_30._wantedStepTime = 0
			end
		end
	end

	arg0_30._checkLockTime = arg0_30._checkLockTime + arg1_30

	if arg0_30._checkLockTime >= 1.3 then
		local var1_30 = 0

		for iter0_30 = 1, #arg0_30._grids do
			var1_30 = var1_30 + arg0_30._grids[iter0_30]:GetInputEmptyCount()
		end

		local var2_30 = arg0_30:GetIdsDic(arg0_30:GetAllBottomIds())
		local var3_30 = arg0_30:GetPassItemCount(var2_30)

		if var1_30 == 0 or var1_30 == 1 and var3_30 == 0 or var1_30 == 2 and var3_30 == 0 then
			arg0_30._contentAniamtor:SetTrigger("reset")
		end

		arg0_30._checkLockTime = 0
	end
end

function var0_0.ResetGrid(arg0_31)
	arg0_31._dragGridIndex = nil
	arg0_31._enterGridIndex = nil
	arg0_31._dragGridItemIndex = nil
	arg0_31._enterGridItemIndex = nil

	setActive(arg0_31._dragGridTF, false)

	for iter0_31 = 1, #arg0_31._grids do
		arg0_31._grids[iter0_31]:ClearItems()
	end

	for iter1_31 = #arg0_31._itemIds, 1, -1 do
		table.insert(arg0_31._itemIdsPool, arg0_31._itemIds[iter1_31])
	end

	arg0_31:shuffleArray(arg0_31._itemIdsPool)

	arg0_31._itemIds = {}

	for iter2_31 = 1, #arg0_31._grids do
		for iter3_31 = 1, SortGameConst.grid_max_layer do
			arg0_31:checkGridInput(arg0_31._grids[iter2_31])
		end

		arg0_31._grids[iter2_31]:SetShowAniamtion()
	end

	arg0_31._wantedItem = nil
	arg0_31._wantedStepTime = nil

	arg0_31._event:emit(SortGameView.WANTED_ITEM_REFRESH, {})
end

function var0_0.GetPassItemCount(arg0_32, arg1_32)
	local var0_32 = 0

	for iter0_32, iter1_32 in pairs(arg1_32) do
		if iter1_32 >= 3 then
			var0_32 = var0_32 + 1
		end
	end

	return var0_32
end

function var0_0.GetAllBottomIds(arg0_33)
	local var0_33 = {}

	for iter0_33 = 1, #arg0_33._grids do
		local var1_33 = arg0_33._grids[iter0_33]:GetBottomIds()

		for iter1_33, iter2_33 in ipairs(var1_33) do
			if iter2_33 and iter2_33 > 0 then
				table.insert(var0_33, iter2_33)
			end
		end
	end

	return var0_33
end

function var0_0.GetIdsDic(arg0_34, arg1_34)
	local var0_34 = {}

	for iter0_34 = 1, #arg1_34 do
		local var1_34 = arg1_34[iter0_34]

		if var1_34 and var1_34 > 0 then
			if not var0_34[var1_34] then
				var0_34[var1_34] = 1
			else
				var0_34[var1_34] = var0_34[var1_34] + 1
			end
		end
	end

	return var0_34
end

function var0_0.Stop(arg0_35)
	for iter0_35 = 1, #arg0_35._grids do
		arg0_35._grids[iter0_35]:Stop()
	end
end

function var0_0.Resume(arg0_36)
	for iter0_36 = 1, #arg0_36._grids do
		arg0_36._grids[iter0_36]:Resume()
	end
end

function var0_0.Dispose(arg0_37)
	for iter0_37 = 1, #arg0_37._grids do
		arg0_37._grids[iter0_37]:Dispose()
	end
end

function var0_0.Clear(arg0_38)
	arg0_38._dragGridIndex = nil
	arg0_38._enterGridIndex = nil
	arg0_38._dragGridItemIndex = nil
	arg0_38._enterGridItemIndex = nil

	for iter0_38 = 1, #arg0_38._grids do
		arg0_38._grids[iter0_38]:Clear()
	end
end

return var0_0
