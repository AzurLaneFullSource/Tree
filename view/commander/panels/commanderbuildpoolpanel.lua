local var0_0 = class("CommanderBuildPoolPanel", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CommanderBuildPoolUI"
end

local var1_0 = 10

function var0_0.OnLoaded(arg0_2)
	arg0_2.buildPoolList = UIItemList.New(arg0_2._tf:Find("frame/bg/content/list"), arg0_2._tf:Find("frame/bg/content/list/1"))

	local var0_2 = arg0_2._tf:Find("frame/bg/content/queue/list1/pos")

	arg0_2.posListTop = UIItemList.New(arg0_2._tf:Find("frame/bg/content/queue/list1"), var0_2)
	arg0_2.posListBottom = UIItemList.New(arg0_2._tf:Find("frame/bg/content/queue/list2"), var0_2)
	arg0_2.autoBtn = arg0_2._tf:Find("frame/bg/auto_btn")
	arg0_2.startBtn = arg0_2._tf:Find("frame/bg/start_btn")
	arg0_2.selectedTxt = arg0_2._tf:Find("statistics/Text"):GetComponent(typeof(Text))
	arg0_2.sprites = {
		arg0_2._tf:Find("frame/bg/content/list/1/icon/iconImg"):GetComponent(typeof(Image)).sprite,
		arg0_2._tf:Find("frame/bg/content/list/2/icon/iconImg"):GetComponent(typeof(Image)).sprite,
		arg0_2._tf:Find("frame/bg/content/list/3/icon/iconImg"):GetComponent(typeof(Image)).sprite
	}

	setText(arg0_2:findTF("frame/bg/content/Text"), i18n("commander_use_box_tip"))
	setText(arg0_2:findTF("frame/bg/content/queue/title/Text"), i18n("commander_use_box_queue"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("frame/bg/close_btn"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.autoBtn, function()
		if #arg0_3.selected >= var1_0 then
			return
		end

		arg0_3:AutoSelect()
		arg0_3:UpdatePos()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.startBtn, function()
		if #arg0_3.selected == 0 then
			return
		end

		arg0_3.contextData.msgBox:ExecuteAction("Show", {
			content = i18n("commander_select_box_tip", #arg0_3.selected),
			onYes = function()
				arg0_3:emit(CommanderCatMediator.BATCH_BUILD, arg0_3.selected)
				arg0_3:Hide()
			end
		})
	end, SFX_PANEL)
end

function var0_0.AutoSelect(arg0_9)
	local var0_9 = arg0_9.pools

	local function var1_9()
		local var0_10

		for iter0_10, iter1_10 in pairs(arg0_9.counts) do
			if iter1_10 > 0 then
				var0_10 = iter0_10
			end
		end

		return var0_10
	end

	local var2_9 = var1_0 - #arg0_9.selected

	for iter0_9 = 1, var2_9 do
		local var3_9 = var1_9()

		if var3_9 then
			arg0_9:ReduceCount(var3_9, -1)
		end
	end
end

function var0_0.Show(arg0_11, arg1_11, arg2_11)
	var1_0 = arg2_11
	arg0_11.selected = {}
	arg0_11.pools = arg1_11

	local var0_11 = arg0_11.pools

	arg0_11.counts = {}

	for iter0_11, iter1_11 in ipairs(arg0_11.pools) do
		arg0_11.counts[iter1_11.id] = iter1_11:getItemCount()
	end

	arg0_11.boxesTxt = {}

	table.sort(var0_11, function(arg0_12, arg1_12)
		return arg0_12.id < arg1_12.id
	end)
	arg0_11.buildPoolList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = var0_11[arg1_13 + 1]

			pressPersistTrigger(arg2_13:Find("icon"), 0.5, function(arg0_14)
				if #arg0_11.selected < var1_0 and arg0_11.counts[var0_13.id] > 0 then
					arg0_11:ReduceCount(var0_13.id, -1)
				else
					arg0_14()
				end
			end, nil, true, true, 0.15, SFX_PANEL)
			setText(arg2_13:Find("name"), var0_13:getName())

			arg0_11.boxesTxt[var0_13.id] = arg2_13:Find("Text")

			arg0_11:ReduceCount(var0_13.id, 0)
		end
	end)
	arg0_11.buildPoolList:align(#var0_11)
	arg0_11:UpdatePos()
	setActive(arg0_11._tf, true)

	arg0_11.isShow = true
end

function var0_0.ReduceCount(arg0_15, arg1_15, arg2_15, arg3_15)
	assert(arg2_15 == 1 or arg2_15 == 0 or arg2_15 == -1)

	local var0_15 = arg0_15.boxesTxt[arg1_15]
	local var1_15 = arg0_15.counts[arg1_15] + arg2_15

	arg0_15.counts[arg1_15] = var1_15

	setText(var0_15, var1_15)

	if arg2_15 < 0 then
		table.insert(arg0_15.selected, arg1_15)
		arg0_15:UpdatePos()
	elseif arg2_15 > 0 then
		table.remove(arg0_15.selected, arg3_15)
		arg0_15:UpdatePos()
	end
end

function var0_0.poolId2Sprite(arg0_16, arg1_16)
	return arg0_16.sprites[arg1_16]
end

function var0_0.UpdatePos(arg0_17)
	local function var0_17(arg0_18, arg1_18)
		local var0_18 = arg0_17.selected[arg0_18]
		local var1_18 = arg1_18:Find("icon")

		if var0_18 then
			var1_18:GetComponent(typeof(Image)).sprite = arg0_17:poolId2Sprite(var0_18)

			onButton(arg0_17, var1_18, function()
				arg0_17:ReduceCount(var0_18, 1, arg0_18)
			end, SFX_PANEL)
		else
			setText(arg1_18:Find("empty/Text"), arg0_18)
		end

		setActive(arg1_18:Find("empty"), not var0_18)
		setActive(var1_18, var0_18)
	end

	arg0_17.posListTop:make(function(arg0_20, arg1_20, arg2_20)
		if arg0_20 == UIItemList.EventUpdate then
			var0_17(arg1_20 + 1, arg2_20)
		end
	end)
	arg0_17.posListTop:align(math.min(5, var1_0))
	arg0_17.posListBottom:make(function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventUpdate then
			var0_17(arg1_21 + 6, arg2_21)
		end
	end)
	arg0_17.posListBottom:align(math.max(0, math.min(5, var1_0 - 5)))

	arg0_17.selectedTxt.text = #arg0_17.selected .. "/" .. var1_0
end

function var0_0.Hide(arg0_22)
	setActive(arg0_22._tf, false)

	arg0_22.isShow = false
end

function var0_0.OnDestroy(arg0_23)
	return
end

return var0_0
