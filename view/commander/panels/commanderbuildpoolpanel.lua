local var0 = class("CommanderBuildPoolPanel", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "CommanderBuildPoolUI"
end

local var1 = 10

function var0.OnLoaded(arg0)
	arg0.buildPoolList = UIItemList.New(arg0._tf:Find("frame/bg/content/list"), arg0._tf:Find("frame/bg/content/list/1"))

	local var0 = arg0._tf:Find("frame/bg/content/queue/list1/pos")

	arg0.posListTop = UIItemList.New(arg0._tf:Find("frame/bg/content/queue/list1"), var0)
	arg0.posListBottom = UIItemList.New(arg0._tf:Find("frame/bg/content/queue/list2"), var0)
	arg0.autoBtn = arg0._tf:Find("frame/bg/auto_btn")
	arg0.startBtn = arg0._tf:Find("frame/bg/start_btn")
	arg0.selectedTxt = arg0._tf:Find("statistics/Text"):GetComponent(typeof(Text))
	arg0.sprites = {
		arg0._tf:Find("frame/bg/content/list/1/icon/iconImg"):GetComponent(typeof(Image)).sprite,
		arg0._tf:Find("frame/bg/content/list/2/icon/iconImg"):GetComponent(typeof(Image)).sprite,
		arg0._tf:Find("frame/bg/content/list/3/icon/iconImg"):GetComponent(typeof(Image)).sprite
	}

	setText(arg0:findTF("frame/bg/content/Text"), i18n("commander_use_box_tip"))
	setText(arg0:findTF("frame/bg/content/queue/title/Text"), i18n("commander_use_box_queue"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("frame/bg/close_btn"), function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.autoBtn, function()
		if #arg0.selected >= var1 then
			return
		end

		arg0:AutoSelect()
		arg0:UpdatePos()
	end, SFX_PANEL)
	onButton(arg0, arg0.startBtn, function()
		if #arg0.selected == 0 then
			return
		end

		arg0.contextData.msgBox:ExecuteAction("Show", {
			content = i18n("commander_select_box_tip", #arg0.selected),
			onYes = function()
				arg0:emit(CommanderCatMediator.BATCH_BUILD, arg0.selected)
				arg0:Hide()
			end
		})
	end, SFX_PANEL)
end

function var0.AutoSelect(arg0)
	local var0 = arg0.pools

	local function var1()
		local var0

		for iter0, iter1 in pairs(arg0.counts) do
			if iter1 > 0 then
				var0 = iter0
			end
		end

		return var0
	end

	local var2 = var1 - #arg0.selected

	for iter0 = 1, var2 do
		local var3 = var1()

		if var3 then
			arg0:ReduceCount(var3, -1)
		end
	end
end

function var0.Show(arg0, arg1, arg2)
	var1 = arg2
	arg0.selected = {}
	arg0.pools = arg1

	local var0 = arg0.pools

	arg0.counts = {}

	for iter0, iter1 in ipairs(arg0.pools) do
		arg0.counts[iter1.id] = iter1:getItemCount()
	end

	arg0.boxesTxt = {}

	table.sort(var0, function(arg0, arg1)
		return arg0.id < arg1.id
	end)
	arg0.buildPoolList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			pressPersistTrigger(arg2:Find("icon"), 0.5, function(arg0)
				if #arg0.selected < var1 and arg0.counts[var0.id] > 0 then
					arg0:ReduceCount(var0.id, -1)
				else
					arg0()
				end
			end, nil, true, true, 0.15, SFX_PANEL)
			setText(arg2:Find("name"), var0:getName())

			arg0.boxesTxt[var0.id] = arg2:Find("Text")

			arg0:ReduceCount(var0.id, 0)
		end
	end)
	arg0.buildPoolList:align(#var0)
	arg0:UpdatePos()
	setActive(arg0._tf, true)

	arg0.isShow = true
end

function var0.ReduceCount(arg0, arg1, arg2, arg3)
	assert(arg2 == 1 or arg2 == 0 or arg2 == -1)

	local var0 = arg0.boxesTxt[arg1]
	local var1 = arg0.counts[arg1] + arg2

	arg0.counts[arg1] = var1

	setText(var0, var1)

	if arg2 < 0 then
		table.insert(arg0.selected, arg1)
		arg0:UpdatePos()
	elseif arg2 > 0 then
		table.remove(arg0.selected, arg3)
		arg0:UpdatePos()
	end
end

function var0.poolId2Sprite(arg0, arg1)
	return arg0.sprites[arg1]
end

function var0.UpdatePos(arg0)
	local function var0(arg0, arg1)
		local var0 = arg0.selected[arg0]
		local var1 = arg1:Find("icon")

		if var0 then
			var1:GetComponent(typeof(Image)).sprite = arg0:poolId2Sprite(var0)

			onButton(arg0, var1, function()
				arg0:ReduceCount(var0, 1, arg0)
			end, SFX_PANEL)
		else
			setText(arg1:Find("empty/Text"), arg0)
		end

		setActive(arg1:Find("empty"), not var0)
		setActive(var1, var0)
	end

	arg0.posListTop:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			var0(arg1 + 1, arg2)
		end
	end)
	arg0.posListTop:align(math.min(5, var1))
	arg0.posListBottom:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			var0(arg1 + 6, arg2)
		end
	end)
	arg0.posListBottom:align(math.max(0, math.min(5, var1 - 5)))

	arg0.selectedTxt.text = #arg0.selected .. "/" .. var1
end

function var0.Hide(arg0)
	setActive(arg0._tf, false)

	arg0.isShow = false
end

function var0.OnDestroy(arg0)
	return
end

return var0
