local var0_0 = class("MemoryBookLayer", import("...base.BaseUI"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3

var0_0.PAGE_ONE = 1
var0_0.PAGE_TWO = 2

local var4_0 = 12
local var5_0 = {
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

local function var6_0(arg0_1)
	local var0_1 = {}

	local function var1_1(arg0_2)
		arg0_2.root = arg0_1
		arg0_2.list = {}
	end

	function var0_1.Get(arg0_3)
		local var0_3

		if #arg0_3.list == 0 then
			var0_3 = GameObject("Image")

			var0_3:AddComponent(typeof(Image))
		else
			var0_3 = table.remove(arg0_3.list, #arg0_3.list)
		end

		setActive(var0_3, true)

		return var0_3
	end

	function var0_1.Return(arg0_4, arg1_4)
		arg0_4:Clear(arg1_4)
		setParent(arg1_4, arg0_4.root)
		table.insert(arg0_4.list, arg1_4)
	end

	function var0_1.Clear(arg0_5, arg1_5)
		arg1_5:GetComponent(typeof(Image)).sprite = nil

		setActive(arg1_5, false)
	end

	function var0_1.Dispose(arg0_6)
		_.each(arg0_6.list, function(arg0_7)
			Destroy(arg0_7)
		end)

		arg0_6.list = nil
	end

	var1_1(var0_1)

	return var0_1
end

function var0_0.getUIName(arg0_8)
	return "MemoryBookUI"
end

function var0_0.setActivity(arg0_9, arg1_9)
	arg0_9.activity = arg1_9
	arg0_9.targetItems = arg0_9.activity:getConfig("config_data")
	arg0_9.fetchItems = arg0_9.activity.data1_list
	arg0_9.unlockItems = arg0_9.activity.data2_list
	arg0_9.awardVO = arg0_9.activity:getConfig("config_client")[1]
end

function var0_0.getMemoryState(arg0_10, arg1_10)
	local var0_10 = table.contains(arg0_10.fetchItems, arg1_10)

	return table.contains(arg0_10.unlockItems, arg1_10) and var3_0 or var0_10 and var2_0 or var1_0
end

function var0_0.updateMemorys(arg0_11)
	arg0_11.memorys = {}

	for iter0_11, iter1_11 in ipairs(arg0_11.targetItems) do
		local var0_11 = arg0_11:getMemoryState(iter1_11)
		local var1_11 = iter0_11 % var4_0

		table.insert(arg0_11.memorys, {
			id = iter1_11,
			index = var1_11 == 0 and var4_0 or var1_11,
			pos = var5_0[iter0_11],
			state = var0_11
		})
	end

	local var2_11 = arg0_11.contextData.page or 1

	arg0_11:updateMemoryBook(var2_11, true)
end

function var0_0.init(arg0_12)
	arg0_12.backBtn = arg0_12:findTF("back_btn")
	arg0_12.page1 = arg0_12:findTF("page1")
	arg0_12.page2 = arg0_12:findTF("page2")

	local var0_12 = arg0_12:findTF("get")

	setActive(var0_12, false)

	arg0_12.getSprite = var0_12:GetComponent(typeof(Image)).sprite
	arg0_12.slider = arg0_12:findTF("slider"):GetComponent(typeof(Slider))
	arg0_12.totalTxt = arg0_12:findTF("progress"):GetComponent(typeof(Text))
	arg0_12.currValueTxt = arg0_12:findTF("progress/value"):GetComponent(typeof(Text))
	arg0_12.awardIcon = arg0_12:findTF("award_bg/icon")
	arg0_12.awardLabel = arg0_12:findTF("award_bg/label")
	arg0_12.awardLabelGot = arg0_12:findTF("award_bg/label_got")
	arg0_12.helpBtn = arg0_12:findTF("help")
	arg0_12.pool = var6_0(arg0_12._tf)
end

function var0_0.didEnter(arg0_13)
	arg0_13:addRingDragListenter()
	onButton(arg0_13, arg0_13.backBtn, function()
		arg0_13:emit(var0_0.ON_CLOSE)
	end, SOUND_BACK)
	onButton(arg0_13, arg0_13.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.memorybook_notice.tip
		})
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.page1:Find("switch"), function()
		arg0_13:updateMemoryBook(var0_0.PAGE_TWO)
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.page2:Find("switch"), function()
		arg0_13:updateMemoryBook(var0_0.PAGE_ONE)
	end, SFX_PANEL)

	arg0_13.sprites = {}
	arg0_13.gameObjects = {}

	arg0_13:updateMemorys()
	arg0_13:updateProgress()
end

function var0_0.getStartAndEndIndex(arg0_18, arg1_18)
	local var0_18 = (arg1_18 - 1) * var4_0 + 1
	local var1_18 = var0_18 + var4_0 - 1

	return var0_18, var1_18
end

function var0_0.updateMemoryBook(arg0_19, arg1_19, arg2_19)
	for iter0_19, iter1_19 in ipairs(arg0_19.gameObjects) do
		arg0_19.pool:Return(iter1_19)
	end

	arg0_19.gameObjects = {}

	local var0_19 = arg0_19["page" .. arg1_19]
	local var1_19, var2_19 = arg0_19:getStartAndEndIndex(arg1_19)

	for iter2_19 = var1_19, var2_19 do
		local var3_19 = arg0_19.memorys[iter2_19]

		arg0_19:updateMemoryItem(arg1_19, var3_19)
	end

	local var4_19 = false

	if arg1_19 == var0_0.PAGE_ONE then
		var4_19 = arg0_19:updatePageTip(var0_0.PAGE_TWO)
	elseif arg1_19 == var0_0.PAGE_TWO then
		var4_19 = arg0_19:updatePageTip(var0_0.PAGE_ONE)
	end

	setActive(var0_19:Find("switch/tip"), var4_19)

	arg0_19.page = arg1_19
	arg0_19.contextData.page = arg1_19

	if arg2_19 then
		if arg1_19 == var0_0.PAGE_TWO then
			local var5_19 = arg0_19.page2:Find("switch")

			arg0_19.page2.localPosition = Vector3.New(0, 0)
			arg0_19.page1.localPosition = Vector3.New(-1280, 0)

			setActive(var5_19, true)
		else
			local var6_19 = arg0_19.page1:Find("switch")

			arg0_19.page2.localPosition = Vector3.New(1280, 0)
			arg0_19.page1.localPosition = Vector3.New(0, 0)

			setActive(var6_19, true)
		end
	elseif arg1_19 == var0_0.PAGE_TWO then
		local var7_19 = arg0_19.page2:Find("switch")

		setActive(var7_19, false)

		arg0_19.page2.localPosition = Vector3.New(1280, 0)
		arg0_19.page1.localPosition = Vector3.New(0, 0)

		LeanTween.moveX(arg0_19.page2, 0, 0.5)
		LeanTween.moveX(arg0_19.page1, -1280, 0.5):setOnComplete(System.Action(function()
			setActive(var7_19, true)
		end))
	else
		local var8_19 = arg0_19.page1:Find("switch")

		setActive(var8_19, false)

		arg0_19.page2.localPosition = Vector3.New(0, 0)
		arg0_19.page1.localPosition = Vector3.New(-1280, 0)

		LeanTween.moveX(arg0_19.page2, 1280, 0.5)
		LeanTween.moveX(arg0_19.page1, 0, 0.5):setOnComplete(System.Action(function()
			setActive(var8_19, true)
		end))
	end
end

function var0_0.addRingDragListenter(arg0_22)
	local var0_22 = GetOrAddComponent(arg0_22._tf, "EventTriggerListener")
	local var1_22 = 0
	local var2_22

	var0_22:AddBeginDragFunc(function()
		var1_22 = 0
		var2_22 = nil
	end)
	var0_22:AddDragFunc(function(arg0_24, arg1_24)
		local var0_24 = arg1_24.position

		if not var2_22 then
			var2_22 = var0_24
		end

		var1_22 = var0_24.x - var2_22.x
	end)
	var0_22:AddDragEndFunc(function(arg0_25, arg1_25)
		if var1_22 < -50 then
			if arg0_22.page == var0_0.PAGE_ONE then
				arg0_22:updateMemoryBook(var0_0.PAGE_TWO)
			end
		elseif var1_22 > 50 and arg0_22.page == var0_0.PAGE_TWO then
			arg0_22:updateMemoryBook(var0_0.PAGE_ONE)
		end
	end)
end

function var0_0.updatePageTip(arg0_26, arg1_26)
	local var0_26, var1_26 = arg0_26:getStartAndEndIndex(arg1_26)

	return _.any(_.slice(arg0_26.memorys, var0_26, var4_0), function(arg0_27)
		return arg0_27.state == var2_0
	end)
end

function var0_0.updateMemoryItem(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg2_28.state
	local var1_28 = arg0_28["page" .. arg1_28]

	local function var2_28()
		local var0_29 = arg0_28.pool:Get()
		local var1_29 = var0_28 == var2_0 and arg0_28.getSprite or arg0_28:GetMemorySprite(arg1_28, arg2_28.index)

		setImageSprite(var0_29, var1_29, true)

		var0_29:GetComponent(typeof(Image)).raycastTarget = var0_28 == var2_0

		setParent(var0_29, var1_28:Find("container"))

		tf(var0_29).localPosition = Vector3(arg2_28.pos[1], arg2_28.pos[2], 0)

		table.insert(arg0_28.gameObjects, var0_29)

		return var0_29
	end

	if var0_28 == var1_0 then
		-- block empty
	elseif var0_28 == var2_0 then
		local var3_28 = var2_28()

		onButton(arg0_28, var3_28, function()
			arg0_28:emit(MemoryBookMediator.ON_UNLOCK, arg2_28.id, arg0_28.activity.id)
		end, SFX_PANEL)
	elseif var0_28 == var3_0 then
		var2_28()
	end
end

function var0_0.GetMemorySprite(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg1_31 .. "_" .. arg2_31

	if arg0_31.sprites[var0_31] then
		return arg0_31.sprites[var0_31]
	else
		local var1_31 = GetSpriteFromAtlas("puzzla/bg_2", var0_31)

		arg0_31.sprites[var0_31] = var1_31

		return var1_31
	end
end

function var0_0.updateProgress(arg0_32)
	local var0_32 = #arg0_32.targetItems
	local var1_32 = #arg0_32.unlockItems

	arg0_32.slider.value = var1_32 / var0_32
	arg0_32.totalTxt.text = var0_32
	arg0_32.currValueTxt.text = var1_32

	local var2_32 = var1_32 == var0_32

	arg0_32:updateAward(var2_32)
end

function var0_0.updateAward(arg0_33, arg1_33)
	if not arg0_33.isInitAward then
		arg0_33.isInitAward = true

		local var0_33 = arg0_33.awardVO[1]
		local var1_33 = arg0_33.awardVO[2]

		if var0_33 == DROP_TYPE_FURNITURE then
			local var2_33 = Furniture.New({
				id = var1_33
			})

			GetSpriteFromAtlasAsync("furniture/" .. var2_33:getConfig("picture"), "", function(arg0_34)
				if arg0_33.exited then
					return
				end

				setImageSprite(arg0_33.awardIcon, arg0_34, true)
			end)
		else
			assert(false, "this award type is not deal")
		end
	end

	local var3_33 = arg0_33.activity.data1 == 1

	setGray(arg0_33.awardIcon, not arg1_33, false)
	setActive(arg0_33.awardLabel, arg1_33 and not var3_33)
	setActive(arg0_33.awardLabelGot, var3_33)

	if LeanTween.isTweening(go(arg0_33.awardLabel)) then
		LeanTween.cancel(go(arg0_33.awardLabel))
	end

	if arg1_33 and not var3_33 then
		blinkAni(arg0_33.awardLabel, 0.8, nil, 0.5)
	end

	removeOnButton(arg0_33.awardIcon)

	if not var3_33 then
		onButton(arg0_33, arg0_33.awardIcon, function()
			if not arg1_33 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("memorybook_get_award_tip"))
			else
				arg0_33:emit(MemoryBookMediator.EVENT_OPERATION, {
					cmd = 1,
					activity_id = arg0_33.activity.id
				})
			end
		end, SFX_PANEL)
	end
end

function var0_0.willExit(arg0_36)
	arg0_36.pool:Dispose()

	arg0_36.sprites = nil
	arg0_36.getSprite = nil
end

return var0_0
