local var0 = class("BlackWhiteGridLayer", import("...base.BaseUI"))
local var1 = "create cell"
local var2 = "reach turn cnt"
local var3 = "cell type changed"
local var4 = "cell check changed"
local var5 = "highest score updated"
local var6 = "destroy cells"
local var7 = "cell tip"
local var8 = "map init done"
local var9 = 1
local var10 = -1
local var11 = {
	Color.New(1, 1, 1, 1),
	[-1] = Color.New(0.37, 0.37, 0.37, 1)
}
local var12 = Color.New(0.972549019607843, 0.650980392156863, 0.850980392156863, 1)
local var13 = 5
local var14 = 3
local var15 = 5
local var16 = pg.activity_event_blackwhite
local var17

local function var18()
	local var0 = {}

	local function var1(arg0, arg1, arg2, arg3, arg4)
		local var0 = {}
		local var1 = math.min(arg0 + arg4 - 1, arg3 - 1)
		local var2 = math.min(arg1 + arg4 - 1, arg2 - 1)

		for iter0 = arg0, var1 do
			for iter1 = arg1, var2 do
				table.insert(var0, Vector2(iter0, iter1))
			end
		end

		return var0
	end

	local function var2(arg0, arg1)
		assert(#arg0 ~= 0 and arg1 <= #arg0)

		local var0 = {}
		local var1 = 0

		while var1 < arg1 do
			local var2 = math.random(1, #arg0)

			if not table.contains(var0, var2) then
				table.insert(var0, var2)

				var1 = var1 + 1
			end
		end

		local var3 = {}

		for iter0 = 1, #arg0 do
			local var4 = arg0[iter0]
			local var5 = table.contains(var0, iter0) and -1 or 1

			table.insert(var3, {
				var4.x,
				var4.y,
				var5
			})
		end

		return var3
	end

	function var0.RandomMap(arg0, arg1, arg2, arg3, arg4)
		local var0 = {}

		for iter0 = 0, arg2 - 1, arg3 do
			for iter1 = 0, arg1 - 1, arg3 do
				local var1 = var1(iter0, iter1, arg1, arg2, arg3)
				local var2 = var2(var1, arg4)

				_.each(var2, function(arg0)
					table.insert(var0, arg0)
				end)
			end
		end

		return var0
	end

	function var0.Dispose(arg0)
		return
	end

	return var0
end

local function var19(arg0, arg1)
	local var0 = {}

	local function var1(arg0)
		arg0._go = arg0
		arg0._root = arg1
		arg0.maxCnt = 20
		arg0.stack = {}
	end

	function var0.Get(arg0)
		local var0

		if #arg0.stack == 0 then
			var0 = instantiate(arg0._go)
		else
			var0 = table.remove(arg0.stack, 1)
		end

		setActive(var0, true)

		return var0
	end

	function var0.Return(arg0, arg1)
		setActive(arg1, false)

		if #arg0.stack >= arg0.maxCnt then
			Object.Destroy(arg1)
		else
			table.insert(arg0.stack, arg1)
			setParent(arg1, arg0._root)
		end
	end

	function var0.Dispose(arg0)
		for iter0, iter1 in ipairs(arg0.stack) do
			Destroy(iter1)
		end
	end

	var1(var0)

	return var0
end

local function var20(arg0)
	local var0 = {}

	local function var1(arg0)
		arg0.root = arg0
		arg0.white = arg0:Find("white")
		arg0.black = arg0:Find("black")
		arg0.pools = {}
	end

	function var0.Get(arg0, arg1)
		local var0 = arg0.pools[arg1]

		if not var0 then
			var0 = var19(arg0[arg1], arg0.root)
			arg0.pools[arg1] = var0
		end

		return var0:Get()
	end

	function var0.Return(arg0, arg1, arg2)
		local var0 = arg0.pools[arg1]

		if var0 then
			var0:Return(arg2)
		else
			Destroy(arg2)
		end
	end

	function var0.Dispose(arg0)
		for iter0, iter1 in pairs(arg0.pools) do
			iter1:Dispose()
		end
	end

	var1(var0)

	return var0
end

local function var21(arg0)
	local var0 = {}

	local function var1(arg0)
		arg0.events = {}
		arg0.sender = arg0
	end

	function var0.AddListener(arg0, arg1, arg2)
		if not arg0.events[arg1] then
			arg0.events[arg1] = {}
		end

		table.insert(arg0.events[arg1], arg2)
	end

	function var0.RemoveListener(arg0, arg1, arg2)
		local var0 = arg0.events[arg1]

		for iter0 = #var0, 1, -1 do
			if var0[iter0] == arg2 then
				table.remove(var0, iter0)
			end
		end
	end

	function var0.Notify(arg0, arg1, arg2)
		local var0 = arg0.events[arg1]

		assert(var0, arg1)

		for iter0, iter1 in ipairs(var0) do
			iter1(arg0.sender, arg2)
		end
	end

	var1(var0)

	return var0
end

local function var22(arg0)
	local var0 = {}

	local function var1(arg0)
		arg0.x = arg0.x
		arg0.y = arg0.y
		arg0.color = arg0.color
		arg0.check = false
		arg0.initData = {
			check = false,
			x = arg0.x,
			y = arg0.y,
			color = arg0.color
		}
	end

	function var0.Reset(arg0)
		arg0.x = arg0.initData.x
		arg0.y = arg0.initData.y
		arg0.color = arg0.initData.color
		arg0.check = arg0.initData.check

		arg0:Notify(var3, {
			type = arg0.color
		})
	end

	function var0.GetType(arg0)
		return arg0.color
	end

	function var0.GetPosition(arg0)
		return Vector2(arg0.x, arg0.y)
	end

	function var0.OnAnimDone(arg0)
		if arg0.animCb then
			arg0.animCb()
		end
	end

	function var0.SetAnimDoneCallback(arg0, arg1)
		arg0.animCb = arg1
	end

	function var0.Reverse(arg0)
		if var9 == arg0.color then
			arg0.color = var10
		elseif var10 == arg0.color then
			arg0.color = var9
		end

		arg0:Notify(var3, {
			anim = true,
			type = arg0.color
		})
	end

	function var0.GetCellColorStr(arg0)
		if var9 == arg0.color then
			return "white"
		elseif var10 == arg0.color then
			return "black"
		end
	end

	function var0.ClearCheck(arg0)
		arg0.check = false

		arg0:Notify(var4, arg0.check)
	end

	function var0.Check(arg0)
		arg0.check = true

		arg0:Notify(var4, arg0.check)
	end

	function var0.IsSame(arg0, arg1)
		return arg0.x == arg1.x and arg0.y == arg1.y
	end

	function var0.GetScore(arg0)
		if var9 == arg0.color then
			return 1
		elseif var10 == arg0.color then
			return -1
		end

		return 0
	end

	function var0.Serialize(arg0)
		local var0 = arg0:GetType() == var9 and 1 or -1

		return string.format("{%d,%d,%d}", arg0.x, arg0.y, var0)
	end

	function var0.Dispose(arg0)
		return
	end

	var1(var0)

	return setmetatable(var0, {
		__index = var21(var0)
	})
end

local function var23(arg0)
	local var0 = {
		id = arg0.id,
		maxCount = arg0.maxCount,
		calcStep = arg0.calcStep,
		condition = arg0.condition,
		maps = arg0.maps,
		started = arg0.started or false,
		UpdateData = function(arg0, arg1)
			arg0.highestScore = arg1.highestScore or 0
			arg0.isUnlock = arg1.isUnlock
			arg0.isFinished = arg1.isFinished
		end,
		Init = function(arg0)
			arg0.isInited = true
			arg0.randomer = var18()

			local var0 = arg0.maps

			if not var0 or #var0 == 0 then
				var0 = arg0:GenRandomMap()
			end

			arg0:CreatNewMap(var0)
			arg0:Notify(var8)
		end,
		CreatNewMap = function(arg0, arg1)
			arg0.cells = {}

			for iter0, iter1 in ipairs(arg1) do
				local var0 = arg0:CreateCell(iter1[1], iter1[2], iter1[3])

				table.insert(arg0.cells, var0)
				arg0:Notify(var1, var0)
			end
		end,
		GenRandomMap = function(arg0)
			local var0 = var16[arg0.id].theme
			local var1 = var0[1]
			local var2 = var0[2]

			return arg0.randomer:RandomMap(var1, var2, var14, var15)
		end,
		TriggerTip = function(arg0)
			arg0:Notify(var7, arg0.primaryCell)
		end,
		NeedTip = function(arg0)
			return arg0.primaryCell ~= nil
		end,
		UpdateTurnCnt = function(arg0, arg1)
			arg0.calcStep = arg1

			arg0:Notify(var2, arg0.calcStep)

			if arg0.calcStep == 0 then
				local var0 = arg0:CalcScore()

				if var0 > arg0.highestScore then
					arg0.highestScore = var0

					if arg0.isFinished then
						arg0:Notify(var5, var0)
					end
				end

				arg0.isFinished = true
			end
		end,
		CalcScore = function(arg0)
			local var0 = 0

			_.each(arg0.cells, function(arg0)
				var0 = var0 + arg0:GetScore()
			end)

			return var0
		end,
		CreateCell = function(arg0, arg1, arg2, arg3)
			return var22({
				x = arg1,
				y = arg2,
				color = arg3
			})
		end,
		GetCellByPosition = function(arg0, arg1)
			return _.detect(arg0.cells, function(arg0)
				return arg0:IsSame(arg1)
			end)
		end,
		GetAroundCells = function(arg0, arg1)
			local var0 = {}
			local var1 = arg1:GetPosition()
			local var2 = {
				Vector2(var1.x + 1, var1.y),
				Vector2(var1.x - 1, var1.y),
				Vector2(var1.x, var1.y - 1),
				Vector2(var1.x, var1.y + 1),
				Vector2(var1.x - 1, var1.y - 1),
				Vector2(var1.x + 1, var1.y + 1),
				Vector2(var1.x + 1, var1.y - 1),
				Vector2(var1.x - 1, var1.y + 1),
				Vector2(var1.x, var1.y)
			}

			_.each(var2, function(arg0)
				local var0 = arg0:GetCellByPosition(arg0)

				if var0 then
					table.insert(var0, var0)
				end
			end)

			return var0
		end,
		inProcess = function(arg0)
			return arg0.started
		end,
		Start = function(arg0)
			arg0.started = true
		end,
		Reverse = function(arg0, arg1)
			local var0 = #arg0.primaryCells
			local var1 = 0

			_.each(arg0.primaryCells, function(arg0)
				arg0:SetAnimDoneCallback(function()
					var1 = var1 + 1

					if var1 == var0 then
						arg1()
					end

					arg0:SetAnimDoneCallback(nil)
				end)
				arg0:Reverse()
			end)
		end,
		Primary = function(arg0, arg1)
			if arg0.isStartReverse then
				return
			end

			local function var0()
				_.each(arg0.primaryCells or {}, function(arg0)
					arg0:ClearCheck()
				end)
			end

			if arg0.primaryCells and arg0.primaryCell and arg1:IsSame(arg0.primaryCell) then
				arg0.isStartReverse = true

				arg0:Reverse(function()
					var0()

					arg0.primaryCell = nil
					arg0.primaryCells = nil

					arg0:UpdateTurnCnt(arg0.calcStep - 1)

					arg0.isStartReverse = false
				end)

				return
			end

			arg0.primaryCell = arg1

			var0()

			arg0.primaryCells = arg0:GetAroundCells(arg1)

			_.each(arg0.primaryCells, function(arg0)
				arg0:Check()
			end)
		end,
		ReStart = function(arg0)
			arg0:Notify(var6)

			local var0

			if #var16[arg0.id].map == 0 then
				var0 = arg0:GenRandomMap()
			else
				var0 = var16[arg0.id].map
			end

			arg0:CreatNewMap(var0)
			arg0:UpdateTurnCnt(arg0.maxCount)

			arg0.started = false
		end,
		Serialize = function(arg0)
			if not arg0.isInited then
				return ""
			end

			local var0 = "{"

			_.each(arg0.cells, function(arg0)
				var0 = var0 .. arg0:Serialize() .. ","
			end)

			var0 = var0 .. "}#" .. arg0.calcStep .. "#" .. (arg0.started and "1" or "0")

			return var0
		end,
		Dispose = function(arg0)
			_.each(arg0.cells, function(arg0)
				arg0:Dispose()
			end)

			arg0.started = false
		end
	}

	return setmetatable(var0, {
		__index = var21(var0)
	})
end

local function var24(arg0, arg1)
	local var0 = {}

	local function var1(arg0, arg1, arg2)
		if arg2.anim then
			arg0.dftAniEvent:SetEndEvent(function()
				arg0.dftAniEvent:SetEndEvent(nil)
				arg0.cell:OnAnimDone()
			end)
			arg0.animation:Stop()

			local var0 = arg0:GetAnimationKey(arg2.type)

			arg0.animation:Play(var0)
		else
			local var1 = var11[arg2.type]

			arg0.img.color = var1
		end
	end

	function var0.onCellTypeChanged(arg0, arg1)
		var1(var0, arg0, arg1)
	end

	local function var2(arg0, arg1, arg2)
		if arg2 then
			arg0.animation:Stop()
			arg0.animation:Play("blink")
		else
			arg0:ResetAlhpa()
			arg0.animation:Stop("blink")
		end
	end

	function var0.onCellCheckChanged(arg0, arg1)
		var2(var0, arg0, arg1)
	end

	local function var3(arg0)
		arg0.maxSpriteIndexX = #var17
		arg0.maxSpriteIndexY = #var17[#var17]
		arg0.cell = arg1
		arg0._tf = arg0
		arg0.cellImage = arg0._tf:Find("image")
		arg0.checkTF = arg0.cellImage:Find("check")
		arg0.dftAniEvent = arg0.cellImage:GetComponent(typeof(DftAniEvent))
		arg0.animation = arg0.cellImage:GetComponent(typeof(Animation))

		arg0.animation:Stop()

		arg0.img = arg0.cellImage:GetComponent(typeof(Image))
		arg0.width = arg0._tf.sizeDelta.x
		arg0.height = arg0._tf.sizeDelta.y
		arg0.offsetX = 2
		arg0.offsetY = 0

		arg0:AddListener()

		arg0.img.color = var11[arg0.cell:GetType()]
		arg0.img.sprite = arg0:GetSprite()

		arg0.img:SetNativeSize()
		setAnchoredPosition(arg0.cellImage, Vector2(arg0.cellImage.sizeDelta.x / 2, -arg0.cellImage.sizeDelta.y / 2))
		arg0:SetScale()
		arg0:SetPosition()
	end

	function var0.SetCheck(arg0, arg1)
		setActive(arg0.checkTF, arg1)
	end

	function var0.GetSprite(arg0)
		local var0 = arg0.cell
		local var1 = var0.x
		local var2 = var0.y

		if var1 > arg0.maxSpriteIndexX and var0.x % arg0.maxSpriteIndexX == 0 then
			var1 = 0
		elseif var1 > arg0.maxSpriteIndexX then
			var1 = arg0.maxSpriteIndexX - var0.x % arg0.maxSpriteIndexX
		end

		if var2 > arg0.maxSpriteIndexY then
			var2 = arg0.maxSpriteIndexY - var2 % (arg0.maxSpriteIndexY + 1)
		end

		return var17[var1][var2]
	end

	function var0.GetAnimationKey(arg0, arg1)
		local var0 = ""

		if arg1 == var9 then
			var0 = "b2w"
		elseif arg1 == var10 then
			var0 = "w2b"
		end

		return var0
	end

	function var0.SetScale(arg0)
		local var0 = arg0.cell
		local var1 = var0.x / arg0.maxSpriteIndexX > 1 and -1 or 1
		local var2 = var0.y / arg0.maxSpriteIndexY > 1 and -1 or 1

		arg0.cellImage.localScale = Vector3(var1, var2, 1)

		local var3 = arg0.cellImage.anchoredPosition

		setAnchoredPosition(arg0.cellImage, Vector2(var3.x * var1, var3.y * var2))
	end

	function var0.ResetAlhpa(arg0)
		local var0 = arg0.img.color

		arg0.img.color = Color.New(var0.r, var0.g, var0.b, 1)
	end

	function var0.SetPosition(arg0)
		local var0 = arg0.cell:GetPosition()

		go(arg0._tf).name = var0.x .. "_" .. var0.y

		local var1 = arg0.width
		local var2 = arg0.height

		if var0.x > arg0.maxSpriteIndexX then
			var1 = arg0.width - arg0.offsetX
		end

		if var0.y > arg0.maxSpriteIndexY then
			var2 = arg0.height - arg0.offsetY
		end

		local var3 = var0.x * var1
		local var4 = var0.y * var2

		arg0._tf.localPosition = Vector3(var3, -var4, 0)

		local var5 = arg0.cellImage.localScale.x
		local var6 = arg0.cellImage.localScale.y

		if var5 == -1 and var6 == -1 then
			anchorMax = Vector2(1, 0)
			anchorMin = Vector2(1, 0)
		elseif var5 == 1 and var6 == -1 then
			anchorMax = Vector2(0, 0)
			anchorMin = Vector2(0, 0)
		elseif var5 == -1 and var6 == 1 then
			anchorMax = Vector2(1, 1)
			anchorMin = Vector2(1, 1)
		else
			anchorMax = Vector2(0, 1)
			anchorMin = Vector2(0, 1)
		end

		arg0.cellImage.anchorMax = anchorMax
		arg0.cellImage.anchorMin = anchorMin
	end

	function var0.AddListener(arg0)
		arg0.cell:AddListener(var3, arg0.onCellTypeChanged)
		arg0.cell:AddListener(var4, arg0.onCellCheckChanged)
	end

	function var0.RemoveListener(arg0)
		arg0.cell:RemoveListener(var3, arg0.onCellTypeChanged)
		arg0.cell:RemoveListener(var4, arg0.onCellCheckChanged)
	end

	function var0.Dispose(arg0)
		arg0:ResetAlhpa()
		arg0.animation:Stop()

		arg0._tf.localPosition = Vector3(0, 0, 0)
		arg0._tf.localScale = Vector3(1, 1, 1)
		arg0.cellImage.localPosition = Vector3(0, 0, 0)
		arg0.cellImage.localScale = Vector3(1, 1, 1)
		arg0.img.sprite = nil
		arg0.img.color = var11[1]

		arg0:RemoveListener()
		removeOnButton(arg0._tf)
		setActive(arg0.checkTF, false)
	end

	var3(var0)

	return var0
end

local function var25(arg0, arg1, arg2)
	local var0 = {
		poolMgr = arg2,
		onFirstFinished = function(arg0, arg1)
			return
		end,
		onHighestScore = function(arg0, arg1)
			return
		end,
		onShowResult = function(arg0, arg1, arg2)
			return
		end
	}

	local function var1(arg0, arg1, arg2)
		local var0 = arg0:GetCellTpl(arg2).transform

		setParent(var0, arg0.cellContainer)

		local var1 = var24(var0, arg2)

		table.insert(arg0.cells, var1)
		onButton(nil, var0, function()
			if arg0.tipCellView then
				arg0.tipCellView:SetCheck(false)

				arg0.tipCellView = nil
			end

			if arg0.map.calcStep == 0 then
				arg0:ResetMap()

				return
			end

			if not arg0.map.primaryCell or arg0.map.primaryCell and arg0.map.primaryCell ~= arg2 then
				arg0:AddTipTimer()
			else
				arg0:StopTipTimer()
			end

			arg0.map:Primary(arg2)
		end, SFX_PANEL)
	end

	function var0.onCellCreate(arg0, arg1)
		var1(var0, arg0, arg1)
	end

	local function var2(arg0, arg1, arg2)
		arg0.leftCountTxt.text = arg2

		local var0 = arg0.map:CalcScore()

		if arg2 == 0 then
			if not arg0.map.isFinished then
				arg0.onFirstFinished(arg0.map.id, var0)

				arg0.highestScoreTxt.text = var0
			end

			arg0.onShowResult(arg0.map.id, var0, function()
				arg0:Reset()
			end)

			arg0.currScoreTxt.text = "-"
		else
			arg0.currScoreTxt.text = var0
		end
	end

	function var0.onTurnCntUpdated(arg0, arg1)
		var2(var0, arg0, arg1)
	end

	local function var3(arg0, arg1, arg2)
		arg0.highestScoreTxt.text = arg2

		arg0.onHighestScore(arg0.map.id, arg2)
	end

	function var0.onHighestUpdated(arg0, arg1)
		var3(var0, arg0, arg1)
	end

	local function var4(arg0, arg1)
		for iter0, iter1 in ipairs(arg0.cells) do
			iter1:Dispose()

			local var0 = iter1.cell:GetType()

			arg0.poolMgr:Return(var0, iter1._tf.gameObject)
		end

		arg0.cells = {}
	end

	function var0.onDestoryCells(arg0)
		var4(var0, arg0)
	end

	local function var5(arg0, arg1, arg2)
		local var0 = _.detect(arg0.cells, function(arg0)
			return arg0.cell:IsSame(arg2)
		end)

		if var0 then
			arg0.tipCellView = var0

			var0:SetCheck(true)
		end
	end

	function var0.onCellTip(arg0, arg1)
		var5(var0, arg0, arg1)
	end

	local function var6(arg0, arg1)
		arg0.highestScoreTxt.text = arg0.map.highestScore
		arg0.leftCountTxt.text = arg0.map.calcStep

		local var0 = arg0.map:CalcScore()
		local var1 = arg0:ShouldShowStartBg()

		arg0.currScoreTxt.text = var1 and "-" or var0

		setActive(arg0.startBg, var1)
		onButton(nil, arg0.startBg, function()
			if not arg0.map.isUnlock then
				return
			end

			setActive(arg0.startBg, false)
			arg0:RecordStartBg()

			arg0.currScoreTxt.text = var0

			setActive(arg0.cellContainer, true)
			arg0.map:Start()
		end)

		if not var1 then
			setActive(arg0.cellContainer, true)
		end
	end

	function var0.onMapInitDone(arg0)
		var6(var0, arg0)
	end

	local function var7(arg0)
		arg0._tf = arg0
		arg0.cellWhite = arg0._tf:Find("cell")
		arg0.cellContainer = arg0._tf:Find("container")
		arg0.restartBtn = arg0._tf:Find("restart")
		arg0.leftCountTxt = arg0._tf:Find("left_count"):GetComponent(typeof(Text))
		arg0.highestScoreTxt = arg0._tf:Find("highest"):GetComponent(typeof(Text))
		arg0.currScoreTxt = arg0._tf:Find("curr_score"):GetComponent(typeof(Text))
		arg0.startBg = arg0._tf:Find("start_bg")
		arg0.startBgText = arg0.startBg:Find("Text"):GetComponent(typeof(Text))
		arg0.startLabel = arg0.startBg:Find("Image")
		arg0.map = arg1
		arg0.cells = {}

		arg0:AddListener()

		arg0.startBgText.text = arg0.map.isUnlock and "" or arg0.map.condition

		setActive(arg0.startLabel, arg0.map.isUnlock)
		setActive(arg0.cellContainer, false)
		onButton(nil, arg0.restartBtn, function()
			arg0:ResetMap()
		end, SFX_PANEL)
	end

	function var0.Reset(arg0)
		arg0.map:ReStart()
		setActive(arg0.startBg, true)
		setActive(arg0.cellContainer, false)

		arg0.currScoreTxt.text = "-"
	end

	function var0.ResetMap(arg0)
		if arg0.map.calcStep == arg0.map.maxCount then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("black_white_grid_reset"),
			onYes = function()
				arg0:Reset()
			end
		})
	end

	function var0.AddTipTimer(arg0)
		if arg0.timer then
			arg0.timer:Stop()
		end

		arg0.timer = Timer.New(function()
			if arg0.map:NeedTip() then
				arg0.map:TriggerTip()
			end
		end, var13, 1)

		arg0.timer:Start()
	end

	function var0.StopTipTimer(arg0)
		if arg0.timer then
			arg0.timer:Stop()

			arg0.timer = nil
		end
	end

	function var0.ShouldShowStartBg(arg0)
		return not arg0.map:inProcess()
	end

	function var0.RecordStartBg(arg0)
		return
	end

	function var0.GetCellTpl(arg0, arg1)
		return arg0.poolMgr:Get(arg1:GetCellColorStr())
	end

	function var0.AddListener(arg0)
		arg0.map:AddListener(var1, arg0.onCellCreate)
		arg0.map:AddListener(var2, arg0.onTurnCntUpdated)
		arg0.map:AddListener(var5, arg0.onHighestUpdated)
		arg0.map:AddListener(var6, arg0.onDestoryCells)
		arg0.map:AddListener(var7, arg0.onCellTip)
		arg0.map:AddListener(var8, arg0.onMapInitDone)
	end

	function var0.RemoveListener(arg0)
		arg0.map:RemoveListener(var1, arg0.onCellCreate)
		arg0.map:RemoveListener(var2, arg0.onTurnCntUpdated)
		arg0.map:RemoveListener(var5, arg0.onHighestUpdated)
		arg0.map:RemoveListener(var6, arg0.onDestoryCells)
		arg0.map:RemoveListener(var7, arg0.onCellTip)
		arg0.map:RemoveListener(var8, arg0.onMapInitDone)
	end

	function var0.Dispose(arg0)
		arg0.map:Dispose()
		removeOnButton(arg0.restartBtn)
		arg0:RemoveListener()
		var4(arg0, nil)
		arg0:StopTipTimer()

		arg0.tipCellView = nil
	end

	var7(var0)

	return var0
end

local function var26(arg0)
	local var0 = {
		_tf = arg0
	}

	local function var1(arg0)
		setActive(arg0._tf, false)

		arg0.scoreTxt = arg0._tf:Find("score/Text"):GetComponent(typeof(Text))

		onButton(nil, arg0._tf, function()
			arg0:Hide()
		end, SFX_PANEL)
	end

	function var0.Show(arg0, arg1, arg2)
		setActive(arg0._tf, true)

		arg0.scoreTxt.text = arg1
		arg0.cb = arg2
	end

	function var0.Hide(arg0)
		if arg0.cb then
			arg0.cb()
		end

		setActive(arg0._tf, false)

		arg0.scoreTxt.text = ""
		arg0.cb = nil
	end

	function var0.Dispose(arg0)
		arg0:Hide()
	end

	var1(var0)

	return var0
end

function var0.getUIName(arg0)
	return "BlackWhiteGridUI"
end

function var0.preload(arg0, arg1)
	var17 = {}

	buildTempAB("ui/blackwhitegrid_atlas", function(arg0)
		for iter0 = 0, 4 do
			var17[iter0] = {}

			for iter1 = 0, 2 do
				local var0 = arg0:LoadAssetSync(iter0 .. "_" .. iter1, nil, true, false)

				var17[iter0][iter1] = var0
			end
		end
	end)

	arg0.bgSprite = nil

	LoadSpriteAsync("clutter/blackwhite_bg", function(arg0)
		arg0.bgSprite = arg0

		arg1()
	end)
end

function var0.setActivity(arg0, arg1)
	arg0.activityVO = arg1
	arg0.passIds = arg1.data1_list
	arg0.scores = arg1.data2_list

	arg0:updateFur()
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.init(arg0)
	arg0.mapTF = arg0:findTF("map")
	arg0.backBtn = arg0:findTF("back")
	arg0.toggleTFs = arg0:findTF("toggles")
	arg0.poolMgr = var20(arg0.mapTF:Find("root"))
	arg0.successMsgbox = var26(arg0:findTF("success_bg"))
	arg0.failedMsgbox = var26(arg0:findTF("failed_bg"))
	arg0.furGot = arg0:findTF("fur/got")
	arg0.helpBtn = arg0:findTF("help")
	arg0._tf:GetComponent(typeof(Image)).sprite = arg0.bgSprite
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.black_white_grid_notice.tip
		})
	end, SFX_PANEL)

	local var0 = arg0.activityVO

	arg0.selecteds = {}

	local function var1(arg0)
		eachChild(arg0, function(arg0)
			if go(arg0).name ~= "text" and go(arg0).activeSelf then
				local var0 = arg0:GetComponent(typeof(Image))

				var0.color = var12

				table.insert(arg0.selecteds, var0)
			end
		end)
	end

	local function var2()
		for iter0, iter1 in ipairs(arg0.selecteds) do
			iter1.color = Color.New(1, 1, 1, 1)
		end

		arg0.selecteds = {}
	end

	arg0.btns = {}
	arg0.maps = {}

	for iter0, iter1 in ipairs(var0:getConfig("config_data")) do
		local var3 = var16[iter1]
		local var4 = arg0.toggleTFs:GetChild(iter0 - 1)

		arg0.maps[iter1] = arg0:GetMapVO(var3)

		onButton(arg0, var4, function()
			if arg0.id == iter1 then
				return
			end

			if arg0.mapView and arg0.mapView.map:inProcess() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("black_white_grid_switch_tip"))

				return
			end

			arg0.id = iter1

			local var0 = arg0:GetMapVO(var3)

			arg0:loadMap(var0)

			if #arg0.selecteds > 0 then
				var2()
			end

			var1(var4)
		end, SFX_PANEL)

		arg0.btns[iter1] = var4
	end

	local var5 = arg0:GetLastestUnlockMap()

	if var5 then
		triggerButton(var5)
	end

	arg0:updateBtnsState()
end

function var0.updateFur(arg0)
	if arg0.furGot then
		local var0 = arg0.activityVO:getConfig("config_data")
		local var1 = var0[#var0 - 1]

		setActive(arg0.furGot, table.contains(arg0.passIds, var1))
	end
end

function var0.isUnlock(arg0, arg1)
	local var0 = arg1.unlock[1]
	local var1 = arg1.unlock[2]
	local var2 = getProxy(ChapterProxy):getChapterById(var1)
	local var3 = var2 and var2:isUnlock() and var2:isAllAchieve()
	local var4 = var0 == 0 or table.contains(arg0.passIds, var0)

	return var3 and var4
end

function var0.GetLastestUnlockMap(arg0)
	local var0 = arg0:GetMapIndex()

	if arg0.btns[var0] then
		return arg0.btns[var0]
	else
		local var1
		local var2 = 0

		for iter0, iter1 in pairs(arg0.btns) do
			var2 = var2 + 1

			if arg0:isUnlock(var16[iter0]) or var2 == 1 then
				var1 = iter1
			end
		end

		return var1
	end
end

function var0.updateBtnsState(arg0)
	for iter0, iter1 in pairs(arg0.btns) do
		local var0 = table.contains(arg0.passIds, iter0)
		local var1 = arg0:isUnlock(var16[iter0])

		setActive(iter1:Find("finished"), var0)
		setActive(iter1:Find("locked"), not var1)
		setActive(iter1:Find("opening"), not var0 and var1)
	end
end

function var0.GetMapVO(arg0, arg1)
	local var0
	local var1 = table.indexof(arg0.passIds, arg1.id)
	local var2 = table.contains(arg0.passIds, arg1.id)
	local var3 = var1 and arg0.scores[var1] or 0
	local var4 = {
		highestScore = var3,
		isFinished = var2,
		isUnlock = arg0:isUnlock(arg1)
	}

	if arg0.maps[arg1.id] then
		var0 = arg0.maps[arg1.id]

		var0:UpdateData(var4)
	else
		local var5, var6, var7 = arg0:parseMap(arg1)
		local var8 = {
			id = arg1.id,
			maps = var5,
			calcStep = var6,
			maxCount = arg1.num,
			condition = arg1.condition,
			started = var7
		}

		var0 = var23(var8)

		var0:UpdateData(var4)
	end

	return var0
end

function var0.parseMap(arg0, arg1)
	local var0 = PlayerPrefs.GetString("BlackWhiteGridMapData-" .. arg1.id .. "-" .. arg0.player.id, "")

	if not var0 or var0 == "" then
		return arg1.map, arg1.num, false
	else
		local var1 = var0:split("#")

		return loadstring("return " .. var1[1])(), tonumber(var1[2]), var1[3] == "1"
	end
end

function var0.SaveMapsData(arg0)
	local var0 = arg0.maps

	for iter0, iter1 in ipairs(var0) do
		local var1 = iter1:Serialize()

		if var1 and var1 ~= "" then
			PlayerPrefs.SetString("BlackWhiteGridMapData-" .. iter1.id .. "-" .. arg0.player.id, var1)
		end
	end

	PlayerPrefs.Save()
end

function var0.GetMapIndex(arg0)
	return (PlayerPrefs.GetInt("BlackWhiteGridMapIndex-" .. arg0.player.id, 1))
end

function var0.SaveMapIndex(arg0)
	local var0 = arg0.id or 1

	PlayerPrefs.SetInt("BlackWhiteGridMapIndex-" .. arg0.player.id, var0)
	PlayerPrefs.Save()
end

function var0.loadMap(arg0, arg1)
	if arg0.mapView then
		arg0.mapView:Dispose()
	end

	arg0.mapView = var25(arg0.mapTF, arg1, arg0.poolMgr)

	function arg0.mapView.onFirstFinished(arg0, arg1)
		arg0:emit(BlackWhiteGridMediator.ON_FINISH, arg0, arg1)
	end

	function arg0.mapView.onHighestScore(arg0, arg1)
		arg0:emit(BlackWhiteGridMediator.ON_UPDATE_SCORE, arg0, arg1)
	end

	function arg0.mapView.onShowResult(arg0, arg1, arg2)
		if arg1 >= 0 then
			arg0.successMsgbox:Show(arg1, arg2)
		else
			arg0.failedMsgbox:Show(arg1, arg2)
		end
	end

	arg1:Init()
end

function var0.playStory(arg0, arg1)
	local var0 = var16[arg0.mapView.map.id].story

	if var0 and var0 ~= "" then
		pg.NewStoryMgr.GetInstance():Play(var0, arg1, true, true)
	else
		arg1()
	end
end

function var0.willExit(arg0)
	arg0:SaveMapsData()
	arg0:SaveMapIndex()

	if arg0.mapView then
		arg0.mapView:Dispose()
	end

	arg0.successMsgbox:Dispose()
	arg0.failedMsgbox:Dispose()
	arg0.poolMgr:Dispose()

	var17 = nil
end

return var0
