local var0 = class("MemoryBookLayer", import("...base.BaseUI"))
local var1 = 1
local var2 = 2
local var3 = 3

var0.PAGE_ONE = 1
var0.PAGE_TWO = 2

local var4 = 12
local var5 = {
	{
		-503,
		83
	},
	{
		-371.4,
		72.6
	},
	{
		-464,
		-211
	},
	{
		-234.3,
		-176
	},
	{
		-74.5,
		30.1
	},
	{
		80,
		121.5
	},
	{
		80,
		25.4
	},
	{
		80,
		-89
	},
	{
		291,
		25.4
	},
	{
		483,
		-33
	},
	{
		334,
		-246
	},
	{
		483,
		-217.5
	},
	{
		-478.4,
		84.5
	},
	{
		-290,
		44.5
	},
	{
		-137,
		12.5
	},
	{
		100.5,
		92.5
	},
	{
		-364.3,
		-179.6
	},
	{
		-137,
		-176.9
	},
	{
		78,
		-176.9
	},
	{
		247,
		-242
	},
	{
		383,
		33
	},
	{
		548,
		69
	},
	{
		456,
		-184
	},
	{
		573,
		-106
	}
}

local function var6(arg0)
	local var0 = {}

	local function var1(arg0)
		arg0.root = arg0
		arg0.list = {}
	end

	function var0.Get(arg0)
		local var0

		if #arg0.list == 0 then
			var0 = GameObject("Image")

			var0:AddComponent(typeof(Image))
		else
			var0 = table.remove(arg0.list, #arg0.list)
		end

		setActive(var0, true)

		return var0
	end

	function var0.Return(arg0, arg1)
		arg0:Clear(arg1)
		setParent(arg1, arg0.root)
		table.insert(arg0.list, arg1)
	end

	function var0.Clear(arg0, arg1)
		arg1:GetComponent(typeof(Image)).sprite = nil

		setActive(arg1, false)
	end

	function var0.Dispose(arg0)
		_.each(arg0.list, function(arg0)
			Destroy(arg0)
		end)

		arg0.list = nil
	end

	var1(var0)

	return var0
end

function var0.getUIName(arg0)
	return "MemoryBookUI"
end

function var0.setActivity(arg0, arg1)
	arg0.activity = arg1
	arg0.targetItems = arg0.activity:getConfig("config_data")
	arg0.fetchItems = arg0.activity.data1_list
	arg0.unlockItems = arg0.activity.data2_list
	arg0.awardVO = arg0.activity:getConfig("config_client")[1]
end

function var0.getMemoryState(arg0, arg1)
	local var0 = table.contains(arg0.fetchItems, arg1)

	return table.contains(arg0.unlockItems, arg1) and var3 or var0 and var2 or var1
end

function var0.updateMemorys(arg0)
	arg0.memorys = {}

	for iter0, iter1 in ipairs(arg0.targetItems) do
		local var0 = arg0:getMemoryState(iter1)
		local var1 = iter0 % var4

		table.insert(arg0.memorys, {
			id = iter1,
			index = var1 == 0 and var4 or var1,
			pos = var5[iter0],
			state = var0
		})
	end

	local var2 = arg0.contextData.page or 1

	arg0:updateMemoryBook(var2, true)
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("back_btn")
	arg0.page1 = arg0:findTF("page1")
	arg0.page2 = arg0:findTF("page2")

	local var0 = arg0:findTF("get")

	setActive(var0, false)

	arg0.getSprite = var0:GetComponent(typeof(Image)).sprite
	arg0.slider = arg0:findTF("slider"):GetComponent(typeof(Slider))
	arg0.totalTxt = arg0:findTF("progress"):GetComponent(typeof(Text))
	arg0.currValueTxt = arg0:findTF("progress/value"):GetComponent(typeof(Text))
	arg0.awardIcon = arg0:findTF("award_bg/icon")
	arg0.awardLabel = arg0:findTF("award_bg/label")
	arg0.awardLabelGot = arg0:findTF("award_bg/label_got")
	arg0.helpBtn = arg0:findTF("help")
	arg0.pool = var6(arg0._tf)
end

function var0.didEnter(arg0)
	arg0:addRingDragListenter()
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SOUND_BACK)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.memorybook_notice.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.page1:Find("switch"), function()
		arg0:updateMemoryBook(var0.PAGE_TWO)
	end, SFX_PANEL)
	onButton(arg0, arg0.page2:Find("switch"), function()
		arg0:updateMemoryBook(var0.PAGE_ONE)
	end, SFX_PANEL)

	arg0.sprites = {}
	arg0.gameObjects = {}

	arg0:updateMemorys()
	arg0:updateProgress()
end

function var0.getStartAndEndIndex(arg0, arg1)
	local var0 = (arg1 - 1) * var4 + 1
	local var1 = var0 + var4 - 1

	return var0, var1
end

function var0.updateMemoryBook(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg0.gameObjects) do
		arg0.pool:Return(iter1)
	end

	arg0.gameObjects = {}

	local var0 = arg0["page" .. arg1]
	local var1, var2 = arg0:getStartAndEndIndex(arg1)

	for iter2 = var1, var2 do
		local var3 = arg0.memorys[iter2]

		arg0:updateMemoryItem(arg1, var3)
	end

	local var4 = false

	if arg1 == var0.PAGE_ONE then
		var4 = arg0:updatePageTip(var0.PAGE_TWO)
	elseif arg1 == var0.PAGE_TWO then
		var4 = arg0:updatePageTip(var0.PAGE_ONE)
	end

	setActive(var0:Find("switch/tip"), var4)

	arg0.page = arg1
	arg0.contextData.page = arg1

	if arg2 then
		if arg1 == var0.PAGE_TWO then
			local var5 = arg0.page2:Find("switch")

			arg0.page2.localPosition = Vector3.New(0, 0)
			arg0.page1.localPosition = Vector3.New(-1280, 0)

			setActive(var5, true)
		else
			local var6 = arg0.page1:Find("switch")

			arg0.page2.localPosition = Vector3.New(1280, 0)
			arg0.page1.localPosition = Vector3.New(0, 0)

			setActive(var6, true)
		end
	elseif arg1 == var0.PAGE_TWO then
		local var7 = arg0.page2:Find("switch")

		setActive(var7, false)

		arg0.page2.localPosition = Vector3.New(1280, 0)
		arg0.page1.localPosition = Vector3.New(0, 0)

		LeanTween.moveX(arg0.page2, 0, 0.5)
		LeanTween.moveX(arg0.page1, -1280, 0.5):setOnComplete(System.Action(function()
			setActive(var7, true)
		end))
	else
		local var8 = arg0.page1:Find("switch")

		setActive(var8, false)

		arg0.page2.localPosition = Vector3.New(0, 0)
		arg0.page1.localPosition = Vector3.New(-1280, 0)

		LeanTween.moveX(arg0.page2, 1280, 0.5)
		LeanTween.moveX(arg0.page1, 0, 0.5):setOnComplete(System.Action(function()
			setActive(var8, true)
		end))
	end
end

function var0.addRingDragListenter(arg0)
	local var0 = GetOrAddComponent(arg0._tf, "EventTriggerListener")
	local var1 = 0
	local var2

	var0:AddBeginDragFunc(function()
		var1 = 0
		var2 = nil
	end)
	var0:AddDragFunc(function(arg0, arg1)
		local var0 = arg1.position

		if not var2 then
			var2 = var0
		end

		var1 = var0.x - var2.x
	end)
	var0:AddDragEndFunc(function(arg0, arg1)
		if var1 < -50 then
			if arg0.page == var0.PAGE_ONE then
				arg0:updateMemoryBook(var0.PAGE_TWO)
			end
		elseif var1 > 50 and arg0.page == var0.PAGE_TWO then
			arg0:updateMemoryBook(var0.PAGE_ONE)
		end
	end)
end

function var0.updatePageTip(arg0, arg1)
	local var0, var1 = arg0:getStartAndEndIndex(arg1)

	return _.any(_.slice(arg0.memorys, var0, var4), function(arg0)
		return arg0.state == var2
	end)
end

function var0.updateMemoryItem(arg0, arg1, arg2)
	local var0 = arg2.state
	local var1 = arg0["page" .. arg1]
	local var2 = function()
		local var0 = arg0.pool:Get()
		local var1 = var0 == var2 and arg0.getSprite or arg0:GetMemorySprite(arg1, arg2.index)

		setImageSprite(var0, var1, true)

		var0:GetComponent(typeof(Image)).raycastTarget = var0 == var2

		setParent(var0, var1:Find("container"))

		tf(var0).localPosition = Vector3(arg2.pos[1], arg2.pos[2], 0)

		table.insert(arg0.gameObjects, var0)

		return var0
	end

	if var0 == var1 then
		-- block empty
	elseif var0 == var2 then
		local var3 = var2()

		onButton(arg0, var3, function()
			arg0:emit(MemoryBookMediator.ON_UNLOCK, arg2.id, arg0.activity.id)
		end, SFX_PANEL)
	elseif var0 == var3 then
		var2()
	end
end

function var0.GetMemorySprite(arg0, arg1, arg2)
	local var0 = arg1 .. "_" .. arg2

	if arg0.sprites[var0] then
		return arg0.sprites[var0]
	else
		local var1 = GetSpriteFromAtlas("puzzla/bg_2", var0)

		arg0.sprites[var0] = var1

		return var1
	end
end

function var0.updateProgress(arg0)
	local var0 = #arg0.targetItems
	local var1 = #arg0.unlockItems

	arg0.slider.value = var1 / var0
	arg0.totalTxt.text = var0
	arg0.currValueTxt.text = var1

	local var2 = var1 == var0

	arg0:updateAward(var2)
end

function var0.updateAward(arg0, arg1)
	if not arg0.isInitAward then
		arg0.isInitAward = true

		local var0 = arg0.awardVO[1]
		local var1 = arg0.awardVO[2]

		if var0 == DROP_TYPE_FURNITURE then
			local var2 = Furniture.New({
				id = var1
			})

			GetSpriteFromAtlasAsync("furniture/" .. var2:getConfig("picture"), "", function(arg0)
				if arg0.exited then
					return
				end

				setImageSprite(arg0.awardIcon, arg0, true)
			end)
		else
			assert(false, "this award type is not deal")
		end
	end

	local var3 = arg0.activity.data1 == 1

	setGray(arg0.awardIcon, not arg1, false)
	setActive(arg0.awardLabel, arg1 and not var3)
	setActive(arg0.awardLabelGot, var3)

	if LeanTween.isTweening(go(arg0.awardLabel)) then
		LeanTween.cancel(go(arg0.awardLabel))
	end

	if arg1 and not var3 then
		blinkAni(arg0.awardLabel, 0.8, nil, 0.5)
	end

	removeOnButton(arg0.awardIcon)

	if not var3 then
		onButton(arg0, arg0.awardIcon, function()
			if not arg1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("memorybook_get_award_tip"))
			else
				arg0:emit(MemoryBookMediator.EVENT_OPERATION, {
					cmd = 1,
					activity_id = arg0.activity.id
				})
			end
		end, SFX_PANEL)
	end
end

function var0.willExit(arg0)
	arg0.pool:Dispose()

	arg0.sprites = nil
	arg0.getSprite = nil
end

return var0
