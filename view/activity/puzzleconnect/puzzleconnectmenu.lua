local var0_0 = class("PuzzleConnectMenu")
local var1_0 = 3
local var2_0 = 3

local function var3_0(arg0_1, arg1_1, arg2_1)
	local var0_1 = {
		Ctor = function(arg0_2)
			arg0_2._tf = arg0_1
			arg0_2._event = arg1_1
			arg0_2._index = arg2_1
			arg0_2._shipDescTf = findTF(arg0_2._tf, "desc/text")
			arg0_2._titleTf = findTF(arg0_2._tf, "title_text")
			arg0_2._iconTf = findTF(arg0_2._tf, "icon")
			arg0_2._awardTfs = findTF(arg0_2._tf, "iconBg")
			arg0_2._newTf = findTF(arg0_2._tf, "new")
			arg0_2._progressTf = findTF(arg0_2._tf, "progress")
			arg0_2._btnDetail = findTF(arg0_2._tf, "btnDetail")
			arg0_2._btnDetailText = findTF(arg0_2._btnDetail, "text")
			arg0_2._lockMask = findTF(arg0_2._tf, "lockMask")

			onButton(arg0_2._event, arg0_2._btnDetail, function()
				if arg0_2._progressCount and arg0_2._progressCount == 3 then
					return
				end

				PlayerPrefs.SetInt("puzzle_connect_new_" .. tostring(getProxy(PlayerProxy):getPlayerId()) .. "_" .. arg0_2._configId, 1)
				arg0_2:setItemNew(false)
				arg0_2._event:emit(PuzzleConnectLayer.OPEN_DETAIL, {
					index = arg0_2._index,
					data = arg0_2._data
				})
			end, SFX_CONFIRM)
		end,
		setActive = function(arg0_4, arg1_4)
			setActive(arg0_4._tf, arg1_4)
		end,
		setContent = function(arg0_5, arg1_5)
			setParent(arg0_5._tf, arg1_5)
		end,
		setData = function(arg0_6, arg1_6)
			arg0_6._configId = arg1_6
			arg0_6._data = pg.activity_tolove_jigsaw[arg0_6._configId]
			arg0_6._progressCount = 0

			arg0_6:updateUI()
		end,
		updateUI = function(arg0_7)
			setActive(arg0_7._iconTf, false)
			GetSpriteFromAtlasAsync("ui/puzzleconnecticon_atlas", arg0_7._data.item_icon, function(arg0_8)
				setImageSprite(arg0_7._iconTf, arg0_8, true)
				setActive(arg0_7._iconTf, true)
			end)

			local var0_7 = arg0_7._data.show_award

			for iter0_7 = 1, var1_0 do
				local var1_7 = findTF(arg0_7._tf, "awards/icon" .. iter0_7)
				local var2_7 = findTF(arg0_7._tf, "iconBg/" .. iter0_7)

				if iter0_7 <= #var0_7 then
					local var3_7 = {
						type = var0_7[iter0_7][1],
						id = var0_7[iter0_7][2],
						amount = var0_7[iter0_7][3]
					}

					updateDrop(var1_7, var3_7)
					onButton(arg0_7._event, var1_7, function()
						arg0_7._event:emit(BaseUI.ON_DROP, var3_7)
					end, SFX_PANEL)
					setActive(var1_7, true)
					setActive(var2_7, true)
				else
					setActive(var1_7, false)
					setActive(var2_7, false)
				end
			end

			arg0_7:setItemNew(false)
			arg0_7:updateProgress()
			arg0_7:setItemMask(false, true, 0, 0)
		end,
		getConfigId = function(arg0_10)
			return arg0_10._configId
		end,
		setItemMask = function(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
			arg0_11._progressCount = arg4_11

			local var0_11 = false
			local var1_11 = false
			local var2_11

			if arg1_11 then
				var1_11 = true
				var0_11 = true
				var2_11 = i18n("tolovegame_puzzle_lock_by_time", math.floor(arg3_11 / 24), arg3_11 % 24)
			elseif arg2_11 then
				if arg4_11 ~= 3 then
					var1_11 = false
					var0_11 = false
					var2_11 = i18n("tolovegame_puzzle_open_detail")
				else
					var1_11 = false
					var0_11 = false
					var2_11 = i18n("tolovegame_puzzle_finished")
				end
			else
				var1_11 = true
				var0_11 = true
				var2_11 = i18n("tolovegame_puzzle_lock_by_front")
			end

			arg0_11._maskAble = var0_11

			if var0_11 then
				setText(arg0_11._shipDescTf, i18n("tolovegame_puzzle_ship_unknown"))
				setText(arg0_11._titleTf, i18n("tolovegame_puzzle_lock"))
			else
				setText(arg0_11._shipDescTf, pg.ship_data_statistics[arg0_11._data.ship_id].name)
				setText(arg0_11._titleTf, i18n("tolovegame_puzzle_unlock"))
			end

			if var1_11 then
				GetComponent(arg0_11._iconTf, typeof(Image)).color = Color.New(1, 1, 1, 0.5)
			else
				GetComponent(arg0_11._iconTf, typeof(Image)).color = Color.New(1, 1, 1, 1)
			end

			setActive(arg0_11._lockMask, var0_11)
			arg0_11:updateDetailBtn(var2_11)
			arg0_11:updateProgress()
		end,
		updateDetailBtn = function(arg0_12, arg1_12)
			local var0_12
			local var1_12

			if arg0_12._maskAble then
				var1_12 = false
			elseif arg0_12._progressCount == 3 then
				GetComponent(arg0_12._btnDetail, typeof(CanvasGroup)).interactable = false
				var1_12 = false
			else
				var1_12 = true
			end

			setText(arg0_12._btnDetailText, arg1_12)
			setActive(findTF(arg0_12._btnDetail, "on"), var1_12)
			setActive(findTF(arg0_12._btnDetail, "off"), not var1_12)
		end,
		setItemNew = function(arg0_13, arg1_13)
			setActive(arg0_13._newTf, arg1_13)
		end,
		updateProgress = function(arg0_14)
			local var0_14 = arg0_14._progressCount

			for iter0_14 = 1, var2_0 do
				local var1_14
				local var2_14 = findTF(arg0_14._progressTf, tostring(iter0_14))

				if iter0_14 ~= 1 then
					var1_14 = findTF(arg0_14._progressTf, "line" .. iter0_14)
				end

				if var1_14 then
					setActive(findTF(var1_14, "on"), iter0_14 <= var0_14)
					setActive(findTF(var1_14, "off"), var0_14 < iter0_14)
				end

				if var2_14 then
					setActive(findTF(var2_14, "on"), iter0_14 <= var0_14)
					setActive(findTF(var2_14, "off"), var0_14 < iter0_14)
				end
			end
		end,
		setBtnGray = function(arg0_15, arg1_15)
			setGray(arg0_15._btnDetail, arg1_15, true)
		end,
		setActiveData = function(arg0_16)
			return
		end,
		getChapterIndex = function(arg0_17)
			return arg0_17._configId
		end
	}

	var0_1:Ctor()

	return var0_1
end

function var0_0.Ctor(arg0_18, arg1_18, arg2_18)
	arg0_18._tf = arg1_18
	arg0_18._event = arg2_18
	arg0_18.itemContent = findTF(arg0_18._tf, "list/content")
	arg0_18.itemTpl = findTF(arg0_18._tf, "itemTpl")

	setActive(arg0_18.itemTpl, false)

	arg0_18.items = {}

	onButton(arg0_18._event, findTF(arg0_18._tf, "back"), function()
		arg0_18._event:emit(BaseUI.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_18._event, findTF(arg0_18._tf, "home"), function()
		arg0_18._event:emit(BaseUI.ON_HOME)
	end, SFX_CANCEL)
end

function var0_0.setData(arg0_21, arg1_21)
	local var0_21 = #arg1_21 > #arg0_21.items and #arg1_21 or #arg0_21.items

	for iter0_21 = 1, var0_21 do
		if var0_21 > #arg0_21.items then
			table.insert(arg0_21.items, arg0_21:createItem(arg1_21[iter0_21], iter0_21))
		elseif var0_21 > #arg1_21 then
			arg0_21.items[iter0_21]:setActive(false)
		else
			arg0_21.items[iter0_21]:setData(arg1_21[iter0_21])
		end
	end
end

function var0_0.setActivity(arg0_22, arg1_22)
	local var0_22 = arg1_22.data1_list
	local var1_22 = arg1_22.data2_list
	local var2_22 = arg1_22.data3_list
	local var3_22 = arg1_22:getDayIndex()
	local var4_22, var5_22 = parseTimeConfig(arg1_22:getConfig("time"))
	local var6_22 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var4_22[2])
	local var7_22 = pg.TimeMgr.GetInstance():GetServerTime()

	for iter0_22 = 1, #arg0_22.items do
		local var8_22 = var3_22 < iter0_22 and true or false
		local var9_22 = var6_22 + 86400 * (iter0_22 - 1)
		local var10_22 = math.floor((var9_22 - var7_22) / 3600)
		local var11_22 = true
		local var12_22 = arg0_22.items[iter0_22]:getConfigId()

		if iter0_22 > 1 then
			local var13_22 = arg0_22.items[iter0_22 - 1]:getConfigId()

			if not table.contains(var2_22, var13_22) then
				var11_22 = false
			end
		end

		local var14_22 = PuzzleConnectMediator.GetPuzzleActivityState(var12_22, arg1_22)
		local var15_22 = false

		if var14_22 ~= PuzzleConnectMediator.state_complete and not var8_22 and var11_22 and PlayerPrefs.GetInt("puzzle_connect_new_" .. tostring(getProxy(PlayerProxy):getPlayerId()) .. "_" .. var12_22) ~= 1 then
			var15_22 = true
		end

		local var16_22

		if var14_22 == PuzzleConnectMediator.state_collection then
			var16_22 = 0
		elseif var14_22 == PuzzleConnectMediator.state_puzzle then
			var16_22 = 1
		elseif var14_22 == PuzzleConnectMediator.state_connection then
			var16_22 = 2
		elseif var14_22 == PuzzleConnectMediator.state_complete then
			var16_22 = 3
		end

		arg0_22.items[iter0_22]:setItemNew(var15_22)
		arg0_22.items[iter0_22]:setItemMask(var8_22, var11_22, var10_22, var16_22)
	end
end

function var0_0.createItem(arg0_23, arg1_23, arg2_23)
	local var0_23 = var3_0(tf(instantiate(arg0_23.itemTpl)), arg0_23._event, arg2_23)

	var0_23:setContent(arg0_23.itemContent)
	var0_23:setData(arg1_23)
	var0_23:setActive(true)

	return var0_23
end

function var0_0.show(arg0_24)
	setActive(arg0_24._tf, true)
end

function var0_0.hide(arg0_25)
	setActive(arg0_25._tf, false)
end

function var0_0.dispose(arg0_26)
	return
end

return var0_0
