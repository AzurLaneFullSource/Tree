local var0_0 = class("BlackWhiteGridLayer", import("...base.BaseUI"))
local var1_0 = "create cell"
local var2_0 = "reach turn cnt"
local var3_0 = "cell type changed"
local var4_0 = "cell check changed"
local var5_0 = "highest score updated"
local var6_0 = "destroy cells"
local var7_0 = "cell tip"
local var8_0 = "map init done"
local var9_0 = 1
local var10_0 = -1
local var11_0 = {
	Color.New(1, 1, 1, 1),
	[-1] = Color.New(0.37, 0.37, 0.37, 1)
}
local var12_0 = Color.New(0.972549019607843, 0.650980392156863, 0.850980392156863, 1)
local var13_0 = 5
local var14_0 = 3
local var15_0 = 5
local var16_0 = pg.activity_event_blackwhite
local var17_0

local function var18_0()
	local var0_1 = {}

	local function var1_1(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
		local var0_2 = {}
		local var1_2 = math.min(arg0_2 + arg4_2 - 1, arg3_2 - 1)
		local var2_2 = math.min(arg1_2 + arg4_2 - 1, arg2_2 - 1)

		for iter0_2 = arg0_2, var1_2 do
			for iter1_2 = arg1_2, var2_2 do
				table.insert(var0_2, Vector2(iter0_2, iter1_2))
			end
		end

		return var0_2
	end

	local function var2_1(arg0_3, arg1_3)
		assert(#arg0_3 ~= 0 and arg1_3 <= #arg0_3)

		local var0_3 = {}
		local var1_3 = 0

		while var1_3 < arg1_3 do
			local var2_3 = math.random(1, #arg0_3)

			if not table.contains(var0_3, var2_3) then
				table.insert(var0_3, var2_3)

				var1_3 = var1_3 + 1
			end
		end

		local var3_3 = {}

		for iter0_3 = 1, #arg0_3 do
			local var4_3 = arg0_3[iter0_3]
			local var5_3 = table.contains(var0_3, iter0_3) and -1 or 1

			table.insert(var3_3, {
				var4_3.x,
				var4_3.y,
				var5_3
			})
		end

		return var3_3
	end

	function var0_1.RandomMap(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
		local var0_4 = {}

		for iter0_4 = 0, arg2_4 - 1, arg3_4 do
			for iter1_4 = 0, arg1_4 - 1, arg3_4 do
				local var1_4 = var1_1(iter0_4, iter1_4, arg1_4, arg2_4, arg3_4)
				local var2_4 = var2_1(var1_4, arg4_4)

				_.each(var2_4, function(arg0_5)
					table.insert(var0_4, arg0_5)
				end)
			end
		end

		return var0_4
	end

	function var0_1.Dispose(arg0_6)
		return
	end

	return var0_1
end

local function var19_0(arg0_7, arg1_7)
	local var0_7 = {}

	local function var1_7(arg0_8)
		arg0_8._go = arg0_7
		arg0_8._root = arg1_7
		arg0_8.maxCnt = 20
		arg0_8.stack = {}
	end

	function var0_7.Get(arg0_9)
		local var0_9

		if #arg0_9.stack == 0 then
			var0_9 = instantiate(arg0_9._go)
		else
			var0_9 = table.remove(arg0_9.stack, 1)
		end

		setActive(var0_9, true)

		return var0_9
	end

	function var0_7.Return(arg0_10, arg1_10)
		setActive(arg1_10, false)

		if #arg0_10.stack >= arg0_10.maxCnt then
			Object.Destroy(arg1_10)
		else
			table.insert(arg0_10.stack, arg1_10)
			setParent(arg1_10, arg0_10._root)
		end
	end

	function var0_7.Dispose(arg0_11)
		for iter0_11, iter1_11 in ipairs(arg0_11.stack) do
			Destroy(iter1_11)
		end
	end

	var1_7(var0_7)

	return var0_7
end

local function var20_0(arg0_12)
	local var0_12 = {}

	local function var1_12(arg0_13)
		arg0_13.root = arg0_12
		arg0_13.white = arg0_12:Find("white")
		arg0_13.black = arg0_12:Find("black")
		arg0_13.pools = {}
	end

	function var0_12.Get(arg0_14, arg1_14)
		local var0_14 = arg0_14.pools[arg1_14]

		if not var0_14 then
			var0_14 = var19_0(arg0_14[arg1_14], arg0_14.root)
			arg0_14.pools[arg1_14] = var0_14
		end

		return var0_14:Get()
	end

	function var0_12.Return(arg0_15, arg1_15, arg2_15)
		local var0_15 = arg0_15.pools[arg1_15]

		if var0_15 then
			var0_15:Return(arg2_15)
		else
			Destroy(arg2_15)
		end
	end

	function var0_12.Dispose(arg0_16)
		for iter0_16, iter1_16 in pairs(arg0_16.pools) do
			iter1_16:Dispose()
		end
	end

	var1_12(var0_12)

	return var0_12
end

local function var21_0(arg0_17)
	local var0_17 = {}

	local function var1_17(arg0_18)
		arg0_18.events = {}
		arg0_18.sender = arg0_17
	end

	function var0_17.AddListener(arg0_19, arg1_19, arg2_19)
		if not arg0_19.events[arg1_19] then
			arg0_19.events[arg1_19] = {}
		end

		table.insert(arg0_19.events[arg1_19], arg2_19)
	end

	function var0_17.RemoveListener(arg0_20, arg1_20, arg2_20)
		local var0_20 = arg0_20.events[arg1_20]

		for iter0_20 = #var0_20, 1, -1 do
			if var0_20[iter0_20] == arg2_20 then
				table.remove(var0_20, iter0_20)
			end
		end
	end

	function var0_17.Notify(arg0_21, arg1_21, arg2_21)
		local var0_21 = arg0_21.events[arg1_21]

		assert(var0_21, arg1_21)

		for iter0_21, iter1_21 in ipairs(var0_21) do
			iter1_21(arg0_21.sender, arg2_21)
		end
	end

	var1_17(var0_17)

	return var0_17
end

local function var22_0(arg0_22)
	local var0_22 = {}

	local function var1_22(arg0_23)
		arg0_23.x = arg0_22.x
		arg0_23.y = arg0_22.y
		arg0_23.color = arg0_22.color
		arg0_23.check = false
		arg0_23.initData = {
			check = false,
			x = arg0_23.x,
			y = arg0_23.y,
			color = arg0_23.color
		}
	end

	function var0_22.Reset(arg0_24)
		arg0_24.x = arg0_24.initData.x
		arg0_24.y = arg0_24.initData.y
		arg0_24.color = arg0_24.initData.color
		arg0_24.check = arg0_24.initData.check

		arg0_24:Notify(var3_0, {
			type = arg0_24.color
		})
	end

	function var0_22.GetType(arg0_25)
		return arg0_25.color
	end

	function var0_22.GetPosition(arg0_26)
		return Vector2(arg0_26.x, arg0_26.y)
	end

	function var0_22.OnAnimDone(arg0_27)
		if arg0_27.animCb then
			arg0_27.animCb()
		end
	end

	function var0_22.SetAnimDoneCallback(arg0_28, arg1_28)
		arg0_28.animCb = arg1_28
	end

	function var0_22.Reverse(arg0_29)
		if var9_0 == arg0_29.color then
			arg0_29.color = var10_0
		elseif var10_0 == arg0_29.color then
			arg0_29.color = var9_0
		end

		arg0_29:Notify(var3_0, {
			anim = true,
			type = arg0_29.color
		})
	end

	function var0_22.GetCellColorStr(arg0_30)
		if var9_0 == arg0_30.color then
			return "white"
		elseif var10_0 == arg0_30.color then
			return "black"
		end
	end

	function var0_22.ClearCheck(arg0_31)
		arg0_31.check = false

		arg0_31:Notify(var4_0, arg0_31.check)
	end

	function var0_22.Check(arg0_32)
		arg0_32.check = true

		arg0_32:Notify(var4_0, arg0_32.check)
	end

	function var0_22.IsSame(arg0_33, arg1_33)
		return arg0_33.x == arg1_33.x and arg0_33.y == arg1_33.y
	end

	function var0_22.GetScore(arg0_34)
		if var9_0 == arg0_34.color then
			return 1
		elseif var10_0 == arg0_34.color then
			return -1
		end

		return 0
	end

	function var0_22.Serialize(arg0_35)
		local var0_35 = arg0_35:GetType() == var9_0 and 1 or -1

		return string.format("{%d,%d,%d}", arg0_35.x, arg0_35.y, var0_35)
	end

	function var0_22.Dispose(arg0_36)
		return
	end

	var1_22(var0_22)

	return setmetatable(var0_22, {
		__index = var21_0(var0_22)
	})
end

local function var23_0(arg0_37)
	local var0_37 = {
		id = arg0_37.id,
		maxCount = arg0_37.maxCount,
		calcStep = arg0_37.calcStep,
		condition = arg0_37.condition,
		maps = arg0_37.maps,
		started = arg0_37.started or false,
		UpdateData = function(arg0_38, arg1_38)
			arg0_38.highestScore = arg1_38.highestScore or 0
			arg0_38.isUnlock = arg1_38.isUnlock
			arg0_38.isFinished = arg1_38.isFinished
		end,
		Init = function(arg0_39)
			arg0_39.isInited = true
			arg0_39.randomer = var18_0()

			local var0_39 = arg0_39.maps

			if not var0_39 or #var0_39 == 0 then
				var0_39 = arg0_39:GenRandomMap()
			end

			arg0_39:CreatNewMap(var0_39)
			arg0_39:Notify(var8_0)
		end,
		CreatNewMap = function(arg0_40, arg1_40)
			arg0_40.cells = {}

			for iter0_40, iter1_40 in ipairs(arg1_40) do
				local var0_40 = arg0_40:CreateCell(iter1_40[1], iter1_40[2], iter1_40[3])

				table.insert(arg0_40.cells, var0_40)
				arg0_40:Notify(var1_0, var0_40)
			end
		end,
		GenRandomMap = function(arg0_41)
			local var0_41 = var16_0[arg0_41.id].theme
			local var1_41 = var0_41[1]
			local var2_41 = var0_41[2]

			return arg0_41.randomer:RandomMap(var1_41, var2_41, var14_0, var15_0)
		end,
		TriggerTip = function(arg0_42)
			arg0_42:Notify(var7_0, arg0_42.primaryCell)
		end,
		NeedTip = function(arg0_43)
			return arg0_43.primaryCell ~= nil
		end,
		UpdateTurnCnt = function(arg0_44, arg1_44)
			arg0_44.calcStep = arg1_44

			arg0_44:Notify(var2_0, arg0_44.calcStep)

			if arg0_44.calcStep == 0 then
				local var0_44 = arg0_44:CalcScore()

				if var0_44 > arg0_44.highestScore then
					arg0_44.highestScore = var0_44

					if arg0_44.isFinished then
						arg0_44:Notify(var5_0, var0_44)
					end
				end

				arg0_44.isFinished = true
			end
		end,
		CalcScore = function(arg0_45)
			local var0_45 = 0

			_.each(arg0_45.cells, function(arg0_46)
				var0_45 = var0_45 + arg0_46:GetScore()
			end)

			return var0_45
		end,
		CreateCell = function(arg0_47, arg1_47, arg2_47, arg3_47)
			return var22_0({
				x = arg1_47,
				y = arg2_47,
				color = arg3_47
			})
		end,
		GetCellByPosition = function(arg0_48, arg1_48)
			return _.detect(arg0_48.cells, function(arg0_49)
				return arg0_49:IsSame(arg1_48)
			end)
		end,
		GetAroundCells = function(arg0_50, arg1_50)
			local var0_50 = {}
			local var1_50 = arg1_50:GetPosition()
			local var2_50 = {
				Vector2(var1_50.x + 1, var1_50.y),
				Vector2(var1_50.x - 1, var1_50.y),
				Vector2(var1_50.x, var1_50.y - 1),
				Vector2(var1_50.x, var1_50.y + 1),
				Vector2(var1_50.x - 1, var1_50.y - 1),
				Vector2(var1_50.x + 1, var1_50.y + 1),
				Vector2(var1_50.x + 1, var1_50.y - 1),
				Vector2(var1_50.x - 1, var1_50.y + 1),
				Vector2(var1_50.x, var1_50.y)
			}

			_.each(var2_50, function(arg0_51)
				local var0_51 = arg0_50:GetCellByPosition(arg0_51)

				if var0_51 then
					table.insert(var0_50, var0_51)
				end
			end)

			return var0_50
		end,
		inProcess = function(arg0_52)
			return arg0_52.started
		end,
		Start = function(arg0_53)
			arg0_53.started = true
		end,
		Reverse = function(arg0_54, arg1_54)
			local var0_54 = #arg0_54.primaryCells
			local var1_54 = 0

			_.each(arg0_54.primaryCells, function(arg0_55)
				arg0_55:SetAnimDoneCallback(function()
					var1_54 = var1_54 + 1

					if var1_54 == var0_54 then
						arg1_54()
					end

					arg0_55:SetAnimDoneCallback(nil)
				end)
				arg0_55:Reverse()
			end)
		end,
		Primary = function(arg0_57, arg1_57)
			if arg0_57.isStartReverse then
				return
			end

			local function var0_57()
				_.each(arg0_57.primaryCells or {}, function(arg0_59)
					arg0_59:ClearCheck()
				end)
			end

			if arg0_57.primaryCells and arg0_57.primaryCell and arg1_57:IsSame(arg0_57.primaryCell) then
				arg0_57.isStartReverse = true

				arg0_57:Reverse(function()
					var0_57()

					arg0_57.primaryCell = nil
					arg0_57.primaryCells = nil

					arg0_57:UpdateTurnCnt(arg0_57.calcStep - 1)

					arg0_57.isStartReverse = false
				end)

				return
			end

			arg0_57.primaryCell = arg1_57

			var0_57()

			arg0_57.primaryCells = arg0_57:GetAroundCells(arg1_57)

			_.each(arg0_57.primaryCells, function(arg0_61)
				arg0_61:Check()
			end)
		end,
		ReStart = function(arg0_62)
			arg0_62:Notify(var6_0)

			local var0_62

			if #var16_0[arg0_62.id].map == 0 then
				var0_62 = arg0_62:GenRandomMap()
			else
				var0_62 = var16_0[arg0_62.id].map
			end

			arg0_62:CreatNewMap(var0_62)
			arg0_62:UpdateTurnCnt(arg0_62.maxCount)

			arg0_62.started = false
		end,
		Serialize = function(arg0_63)
			if not arg0_63.isInited then
				return ""
			end

			local var0_63 = "{"

			_.each(arg0_63.cells, function(arg0_64)
				var0_63 = var0_63 .. arg0_64:Serialize() .. ","
			end)

			var0_63 = var0_63 .. "}#" .. arg0_63.calcStep .. "#" .. (arg0_63.started and "1" or "0")

			return var0_63
		end,
		Dispose = function(arg0_65)
			_.each(arg0_65.cells, function(arg0_66)
				arg0_66:Dispose()
			end)

			arg0_65.started = false
		end
	}

	return setmetatable(var0_37, {
		__index = var21_0(var0_37)
	})
end

local function var24_0(arg0_67, arg1_67)
	local var0_67 = {}

	local function var1_67(arg0_68, arg1_68, arg2_68)
		if arg2_68.anim then
			arg0_68.dftAniEvent:SetEndEvent(function()
				arg0_68.dftAniEvent:SetEndEvent(nil)
				arg0_68.cell:OnAnimDone()
			end)
			arg0_68.animation:Stop()

			local var0_68 = arg0_68:GetAnimationKey(arg2_68.type)

			arg0_68.animation:Play(var0_68)
		else
			local var1_68 = var11_0[arg2_68.type]

			arg0_68.img.color = var1_68
		end
	end

	function var0_67.onCellTypeChanged(arg0_70, arg1_70)
		var1_67(var0_67, arg0_70, arg1_70)
	end

	local function var2_67(arg0_71, arg1_71, arg2_71)
		if arg2_71 then
			arg0_71.animation:Stop()
			arg0_71.animation:Play("blink")
		else
			arg0_71:ResetAlhpa()
			arg0_71.animation:Stop("blink")
		end
	end

	function var0_67.onCellCheckChanged(arg0_72, arg1_72)
		var2_67(var0_67, arg0_72, arg1_72)
	end

	local function var3_67(arg0_73)
		arg0_73.maxSpriteIndexX = #var17_0
		arg0_73.maxSpriteIndexY = #var17_0[#var17_0]
		arg0_73.cell = arg1_67
		arg0_73._tf = arg0_67
		arg0_73.cellImage = arg0_73._tf:Find("image")
		arg0_73.checkTF = arg0_73.cellImage:Find("check")
		arg0_73.dftAniEvent = arg0_73.cellImage:GetComponent(typeof(DftAniEvent))
		arg0_73.animation = arg0_73.cellImage:GetComponent(typeof(Animation))

		arg0_73.animation:Stop()

		arg0_73.img = arg0_73.cellImage:GetComponent(typeof(Image))
		arg0_73.width = arg0_73._tf.sizeDelta.x
		arg0_73.height = arg0_73._tf.sizeDelta.y
		arg0_73.offsetX = 2
		arg0_73.offsetY = 0

		arg0_73:AddListener()

		arg0_73.img.color = var11_0[arg0_73.cell:GetType()]
		arg0_73.img.sprite = arg0_73:GetSprite()

		arg0_73.img:SetNativeSize()
		setAnchoredPosition(arg0_73.cellImage, Vector2(arg0_73.cellImage.sizeDelta.x / 2, -arg0_73.cellImage.sizeDelta.y / 2))
		arg0_73:SetScale()
		arg0_73:SetPosition()
	end

	function var0_67.SetCheck(arg0_74, arg1_74)
		setActive(arg0_74.checkTF, arg1_74)
	end

	function var0_67.GetSprite(arg0_75)
		local var0_75 = arg0_75.cell
		local var1_75 = var0_75.x
		local var2_75 = var0_75.y

		if var1_75 > arg0_75.maxSpriteIndexX and var0_75.x % arg0_75.maxSpriteIndexX == 0 then
			var1_75 = 0
		elseif var1_75 > arg0_75.maxSpriteIndexX then
			var1_75 = arg0_75.maxSpriteIndexX - var0_75.x % arg0_75.maxSpriteIndexX
		end

		if var2_75 > arg0_75.maxSpriteIndexY then
			var2_75 = arg0_75.maxSpriteIndexY - var2_75 % (arg0_75.maxSpriteIndexY + 1)
		end

		return var17_0[var1_75][var2_75]
	end

	function var0_67.GetAnimationKey(arg0_76, arg1_76)
		local var0_76 = ""

		if arg1_76 == var9_0 then
			var0_76 = "b2w"
		elseif arg1_76 == var10_0 then
			var0_76 = "w2b"
		end

		return var0_76
	end

	function var0_67.SetScale(arg0_77)
		local var0_77 = arg0_77.cell
		local var1_77 = var0_77.x / arg0_77.maxSpriteIndexX > 1 and -1 or 1
		local var2_77 = var0_77.y / arg0_77.maxSpriteIndexY > 1 and -1 or 1

		arg0_77.cellImage.localScale = Vector3(var1_77, var2_77, 1)

		local var3_77 = arg0_77.cellImage.anchoredPosition

		setAnchoredPosition(arg0_77.cellImage, Vector2(var3_77.x * var1_77, var3_77.y * var2_77))
	end

	function var0_67.ResetAlhpa(arg0_78)
		local var0_78 = arg0_78.img.color

		arg0_78.img.color = Color.New(var0_78.r, var0_78.g, var0_78.b, 1)
	end

	function var0_67.SetPosition(arg0_79)
		local var0_79 = arg0_79.cell:GetPosition()

		go(arg0_79._tf).name = var0_79.x .. "_" .. var0_79.y

		local var1_79 = arg0_79.width
		local var2_79 = arg0_79.height

		if var0_79.x > arg0_79.maxSpriteIndexX then
			var1_79 = arg0_79.width - arg0_79.offsetX
		end

		if var0_79.y > arg0_79.maxSpriteIndexY then
			var2_79 = arg0_79.height - arg0_79.offsetY
		end

		local var3_79 = var0_79.x * var1_79
		local var4_79 = var0_79.y * var2_79

		arg0_79._tf.localPosition = Vector3(var3_79, -var4_79, 0)

		local var5_79 = arg0_79.cellImage.localScale.x
		local var6_79 = arg0_79.cellImage.localScale.y

		if var5_79 == -1 and var6_79 == -1 then
			anchorMax = Vector2(1, 0)
			anchorMin = Vector2(1, 0)
		elseif var5_79 == 1 and var6_79 == -1 then
			anchorMax = Vector2(0, 0)
			anchorMin = Vector2(0, 0)
		elseif var5_79 == -1 and var6_79 == 1 then
			anchorMax = Vector2(1, 1)
			anchorMin = Vector2(1, 1)
		else
			anchorMax = Vector2(0, 1)
			anchorMin = Vector2(0, 1)
		end

		arg0_79.cellImage.anchorMax = anchorMax
		arg0_79.cellImage.anchorMin = anchorMin
	end

	function var0_67.AddListener(arg0_80)
		arg0_80.cell:AddListener(var3_0, arg0_80.onCellTypeChanged)
		arg0_80.cell:AddListener(var4_0, arg0_80.onCellCheckChanged)
	end

	function var0_67.RemoveListener(arg0_81)
		arg0_81.cell:RemoveListener(var3_0, arg0_81.onCellTypeChanged)
		arg0_81.cell:RemoveListener(var4_0, arg0_81.onCellCheckChanged)
	end

	function var0_67.Dispose(arg0_82)
		arg0_82:ResetAlhpa()
		arg0_82.animation:Stop()

		arg0_82._tf.localPosition = Vector3(0, 0, 0)
		arg0_82._tf.localScale = Vector3(1, 1, 1)
		arg0_82.cellImage.localPosition = Vector3(0, 0, 0)
		arg0_82.cellImage.localScale = Vector3(1, 1, 1)
		arg0_82.img.sprite = nil
		arg0_82.img.color = var11_0[1]

		arg0_82:RemoveListener()
		removeOnButton(arg0_82._tf)
		setActive(arg0_82.checkTF, false)
	end

	var3_67(var0_67)

	return var0_67
end

local function var25_0(arg0_83, arg1_83, arg2_83)
	local var0_83 = {
		poolMgr = arg2_83,
		onFirstFinished = function(arg0_84, arg1_84)
			return
		end,
		onHighestScore = function(arg0_85, arg1_85)
			return
		end,
		onShowResult = function(arg0_86, arg1_86, arg2_86)
			return
		end
	}

	local function var1_83(arg0_87, arg1_87, arg2_87)
		local var0_87 = arg0_87:GetCellTpl(arg2_87).transform

		setParent(var0_87, arg0_87.cellContainer)

		local var1_87 = var24_0(var0_87, arg2_87)

		table.insert(arg0_87.cells, var1_87)
		onButton(nil, var0_87, function()
			if arg0_87.tipCellView then
				arg0_87.tipCellView:SetCheck(false)

				arg0_87.tipCellView = nil
			end

			if arg0_87.map.calcStep == 0 then
				arg0_87:ResetMap()

				return
			end

			if not arg0_87.map.primaryCell or arg0_87.map.primaryCell and arg0_87.map.primaryCell ~= arg2_87 then
				arg0_87:AddTipTimer()
			else
				arg0_87:StopTipTimer()
			end

			arg0_87.map:Primary(arg2_87)
		end, SFX_PANEL)
	end

	function var0_83.onCellCreate(arg0_89, arg1_89)
		var1_83(var0_83, arg0_89, arg1_89)
	end

	local function var2_83(arg0_90, arg1_90, arg2_90)
		arg0_90.leftCountTxt.text = arg2_90

		local var0_90 = arg0_90.map:CalcScore()

		if arg2_90 == 0 then
			if not arg0_90.map.isFinished then
				arg0_90.onFirstFinished(arg0_90.map.id, var0_90)

				arg0_90.highestScoreTxt.text = var0_90
			end

			arg0_90.onShowResult(arg0_90.map.id, var0_90, function()
				arg0_90:Reset()
			end)

			arg0_90.currScoreTxt.text = "-"
		else
			arg0_90.currScoreTxt.text = var0_90
		end
	end

	function var0_83.onTurnCntUpdated(arg0_92, arg1_92)
		var2_83(var0_83, arg0_92, arg1_92)
	end

	local function var3_83(arg0_93, arg1_93, arg2_93)
		arg0_93.highestScoreTxt.text = arg2_93

		arg0_93.onHighestScore(arg0_93.map.id, arg2_93)
	end

	function var0_83.onHighestUpdated(arg0_94, arg1_94)
		var3_83(var0_83, arg0_94, arg1_94)
	end

	local function var4_83(arg0_95, arg1_95)
		for iter0_95, iter1_95 in ipairs(arg0_95.cells) do
			iter1_95:Dispose()

			local var0_95 = iter1_95.cell:GetType()

			arg0_95.poolMgr:Return(var0_95, iter1_95._tf.gameObject)
		end

		arg0_95.cells = {}
	end

	function var0_83.onDestoryCells(arg0_96)
		var4_83(var0_83, arg0_96)
	end

	local function var5_83(arg0_97, arg1_97, arg2_97)
		local var0_97 = _.detect(arg0_97.cells, function(arg0_98)
			return arg0_98.cell:IsSame(arg2_97)
		end)

		if var0_97 then
			arg0_97.tipCellView = var0_97

			var0_97:SetCheck(true)
		end
	end

	function var0_83.onCellTip(arg0_99, arg1_99)
		var5_83(var0_83, arg0_99, arg1_99)
	end

	local function var6_83(arg0_100, arg1_100)
		arg0_100.highestScoreTxt.text = arg0_100.map.highestScore
		arg0_100.leftCountTxt.text = arg0_100.map.calcStep

		local var0_100 = arg0_100.map:CalcScore()
		local var1_100 = arg0_100:ShouldShowStartBg()

		arg0_100.currScoreTxt.text = var1_100 and "-" or var0_100

		setActive(arg0_100.startBg, var1_100)
		onButton(nil, arg0_100.startBg, function()
			if not arg0_100.map.isUnlock then
				return
			end

			setActive(arg0_100.startBg, false)
			arg0_100:RecordStartBg()

			arg0_100.currScoreTxt.text = var0_100

			setActive(arg0_100.cellContainer, true)
			arg0_100.map:Start()
		end)

		if not var1_100 then
			setActive(arg0_100.cellContainer, true)
		end
	end

	function var0_83.onMapInitDone(arg0_102)
		var6_83(var0_83, arg0_102)
	end

	local function var7_83(arg0_103)
		arg0_103._tf = arg0_83
		arg0_103.cellWhite = arg0_103._tf:Find("cell")
		arg0_103.cellContainer = arg0_103._tf:Find("container")
		arg0_103.restartBtn = arg0_103._tf:Find("restart")
		arg0_103.leftCountTxt = arg0_103._tf:Find("left_count"):GetComponent(typeof(Text))
		arg0_103.highestScoreTxt = arg0_103._tf:Find("highest"):GetComponent(typeof(Text))
		arg0_103.currScoreTxt = arg0_103._tf:Find("curr_score"):GetComponent(typeof(Text))
		arg0_103.startBg = arg0_103._tf:Find("start_bg")
		arg0_103.startBgText = arg0_103.startBg:Find("Text"):GetComponent(typeof(Text))
		arg0_103.startLabel = arg0_103.startBg:Find("Image")
		arg0_103.map = arg1_83
		arg0_103.cells = {}

		arg0_103:AddListener()

		arg0_103.startBgText.text = arg0_103.map.isUnlock and "" or arg0_103.map.condition

		setActive(arg0_103.startLabel, arg0_103.map.isUnlock)
		setActive(arg0_103.cellContainer, false)
		onButton(nil, arg0_103.restartBtn, function()
			arg0_103:ResetMap()
		end, SFX_PANEL)
	end

	function var0_83.Reset(arg0_105)
		arg0_105.map:ReStart()
		setActive(arg0_105.startBg, true)
		setActive(arg0_105.cellContainer, false)

		arg0_105.currScoreTxt.text = "-"
	end

	function var0_83.ResetMap(arg0_106)
		if arg0_106.map.calcStep == arg0_106.map.maxCount then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("black_white_grid_reset"),
			onYes = function()
				arg0_106:Reset()
			end
		})
	end

	function var0_83.AddTipTimer(arg0_108)
		if arg0_108.timer then
			arg0_108.timer:Stop()
		end

		arg0_108.timer = Timer.New(function()
			if arg0_108.map:NeedTip() then
				arg0_108.map:TriggerTip()
			end
		end, var13_0, 1)

		arg0_108.timer:Start()
	end

	function var0_83.StopTipTimer(arg0_110)
		if arg0_110.timer then
			arg0_110.timer:Stop()

			arg0_110.timer = nil
		end
	end

	function var0_83.ShouldShowStartBg(arg0_111)
		return not arg0_111.map:inProcess()
	end

	function var0_83.RecordStartBg(arg0_112)
		return
	end

	function var0_83.GetCellTpl(arg0_113, arg1_113)
		return arg0_113.poolMgr:Get(arg1_113:GetCellColorStr())
	end

	function var0_83.AddListener(arg0_114)
		arg0_114.map:AddListener(var1_0, arg0_114.onCellCreate)
		arg0_114.map:AddListener(var2_0, arg0_114.onTurnCntUpdated)
		arg0_114.map:AddListener(var5_0, arg0_114.onHighestUpdated)
		arg0_114.map:AddListener(var6_0, arg0_114.onDestoryCells)
		arg0_114.map:AddListener(var7_0, arg0_114.onCellTip)
		arg0_114.map:AddListener(var8_0, arg0_114.onMapInitDone)
	end

	function var0_83.RemoveListener(arg0_115)
		arg0_115.map:RemoveListener(var1_0, arg0_115.onCellCreate)
		arg0_115.map:RemoveListener(var2_0, arg0_115.onTurnCntUpdated)
		arg0_115.map:RemoveListener(var5_0, arg0_115.onHighestUpdated)
		arg0_115.map:RemoveListener(var6_0, arg0_115.onDestoryCells)
		arg0_115.map:RemoveListener(var7_0, arg0_115.onCellTip)
		arg0_115.map:RemoveListener(var8_0, arg0_115.onMapInitDone)
	end

	function var0_83.Dispose(arg0_116)
		arg0_116.map:Dispose()
		removeOnButton(arg0_116.restartBtn)
		arg0_116:RemoveListener()
		var4_83(arg0_116, nil)
		arg0_116:StopTipTimer()

		arg0_116.tipCellView = nil
	end

	var7_83(var0_83)

	return var0_83
end

local function var26_0(arg0_117)
	local var0_117 = {
		_tf = arg0_117
	}

	local function var1_117(arg0_118)
		setActive(arg0_118._tf, false)

		arg0_118.scoreTxt = arg0_118._tf:Find("score/Text"):GetComponent(typeof(Text))

		onButton(nil, arg0_118._tf, function()
			arg0_118:Hide()
		end, SFX_PANEL)
	end

	function var0_117.Show(arg0_120, arg1_120, arg2_120)
		setActive(arg0_120._tf, true)

		arg0_120.scoreTxt.text = arg1_120
		arg0_120.cb = arg2_120
	end

	function var0_117.Hide(arg0_121)
		if arg0_121.cb then
			arg0_121.cb()
		end

		setActive(arg0_121._tf, false)

		arg0_121.scoreTxt.text = ""
		arg0_121.cb = nil
	end

	function var0_117.Dispose(arg0_122)
		arg0_122:Hide()
	end

	var1_117(var0_117)

	return var0_117
end

function var0_0.getUIName(arg0_123)
	return "BlackWhiteGridUI"
end

function var0_0.preload(arg0_124, arg1_124)
	local var0_124 = {}

	for iter0_124 = 0, 4 do
		for iter1_124 = 0, 2 do
			table.insert(var0_124, iter0_124 .. "_" .. iter1_124)
		end
	end

	var17_0 = {}

	AssetBundleHelper.LoadManyAssets("ui/blackwhitegrid_atlas", var0_124, nil, true, function(arg0_125)
		for iter0_125 = 0, 4 do
			var17_0[iter0_125] = {}

			for iter1_125 = 0, 2 do
				var17_0[iter0_125][iter1_125] = arg0_125[iter0_125 .. "_" .. iter1_125]
			end
		end
	end, true)

	arg0_124.bgSprite = nil

	LoadSpriteAsync("clutter/blackwhite_bg", function(arg0_126)
		arg0_124.bgSprite = arg0_126

		arg1_124()
	end)
end

function var0_0.setActivity(arg0_127, arg1_127)
	arg0_127.activityVO = arg1_127
	arg0_127.passIds = arg1_127.data1_list
	arg0_127.scores = arg1_127.data2_list

	arg0_127:updateFur()
end

function var0_0.setPlayer(arg0_128, arg1_128)
	arg0_128.player = arg1_128
end

function var0_0.init(arg0_129)
	arg0_129.mapTF = arg0_129:findTF("map")
	arg0_129.backBtn = arg0_129:findTF("back")
	arg0_129.toggleTFs = arg0_129:findTF("toggles")
	arg0_129.poolMgr = var20_0(arg0_129.mapTF:Find("root"))
	arg0_129.successMsgbox = var26_0(arg0_129:findTF("success_bg"))
	arg0_129.failedMsgbox = var26_0(arg0_129:findTF("failed_bg"))
	arg0_129.furGot = arg0_129:findTF("fur/got")
	arg0_129.helpBtn = arg0_129:findTF("help")
	arg0_129._tf:GetComponent(typeof(Image)).sprite = arg0_129.bgSprite
end

function var0_0.didEnter(arg0_130)
	onButton(arg0_130, arg0_130.backBtn, function()
		arg0_130:emit(var0_0.ON_CLOSE)
	end, SFX_PANEL)
	onButton(arg0_130, arg0_130.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.black_white_grid_notice.tip
		})
	end, SFX_PANEL)

	local var0_130 = arg0_130.activityVO

	arg0_130.selecteds = {}

	local function var1_130(arg0_133)
		eachChild(arg0_133, function(arg0_134)
			if go(arg0_134).name ~= "text" and go(arg0_134).activeSelf then
				local var0_134 = arg0_134:GetComponent(typeof(Image))

				var0_134.color = var12_0

				table.insert(arg0_130.selecteds, var0_134)
			end
		end)
	end

	local function var2_130()
		for iter0_135, iter1_135 in ipairs(arg0_130.selecteds) do
			iter1_135.color = Color.New(1, 1, 1, 1)
		end

		arg0_130.selecteds = {}
	end

	arg0_130.btns = {}
	arg0_130.maps = {}

	for iter0_130, iter1_130 in ipairs(var0_130:getConfig("config_data")) do
		local var3_130 = var16_0[iter1_130]
		local var4_130 = arg0_130.toggleTFs:GetChild(iter0_130 - 1)

		arg0_130.maps[iter1_130] = arg0_130:GetMapVO(var3_130)

		onButton(arg0_130, var4_130, function()
			if arg0_130.id == iter1_130 then
				return
			end

			if arg0_130.mapView and arg0_130.mapView.map:inProcess() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("black_white_grid_switch_tip"))

				return
			end

			arg0_130.id = iter1_130

			local var0_136 = arg0_130:GetMapVO(var3_130)

			arg0_130:loadMap(var0_136)

			if #arg0_130.selecteds > 0 then
				var2_130()
			end

			var1_130(var4_130)
		end, SFX_PANEL)

		arg0_130.btns[iter1_130] = var4_130
	end

	local var5_130 = arg0_130:GetLastestUnlockMap()

	if var5_130 then
		triggerButton(var5_130)
	end

	arg0_130:updateBtnsState()
end

function var0_0.updateFur(arg0_137)
	if arg0_137.furGot then
		local var0_137 = arg0_137.activityVO:getConfig("config_data")
		local var1_137 = var0_137[#var0_137 - 1]

		setActive(arg0_137.furGot, table.contains(arg0_137.passIds, var1_137))
	end
end

function var0_0.isUnlock(arg0_138, arg1_138)
	local var0_138 = arg1_138.unlock[1]
	local var1_138 = arg1_138.unlock[2]
	local var2_138 = getProxy(ChapterProxy):getChapterById(var1_138)
	local var3_138 = var2_138 and var2_138:isUnlock() and var2_138:isAllAchieve()
	local var4_138 = var0_138 == 0 or table.contains(arg0_138.passIds, var0_138)

	return var3_138 and var4_138
end

function var0_0.GetLastestUnlockMap(arg0_139)
	local var0_139 = arg0_139:GetMapIndex()

	if arg0_139.btns[var0_139] then
		return arg0_139.btns[var0_139]
	else
		local var1_139
		local var2_139 = 0

		for iter0_139, iter1_139 in pairs(arg0_139.btns) do
			var2_139 = var2_139 + 1

			if arg0_139:isUnlock(var16_0[iter0_139]) or var2_139 == 1 then
				var1_139 = iter1_139
			end
		end

		return var1_139
	end
end

function var0_0.updateBtnsState(arg0_140)
	for iter0_140, iter1_140 in pairs(arg0_140.btns) do
		local var0_140 = table.contains(arg0_140.passIds, iter0_140)
		local var1_140 = arg0_140:isUnlock(var16_0[iter0_140])

		setActive(iter1_140:Find("finished"), var0_140)
		setActive(iter1_140:Find("locked"), not var1_140)
		setActive(iter1_140:Find("opening"), not var0_140 and var1_140)
	end
end

function var0_0.GetMapVO(arg0_141, arg1_141)
	local var0_141
	local var1_141 = table.indexof(arg0_141.passIds, arg1_141.id)
	local var2_141 = table.contains(arg0_141.passIds, arg1_141.id)
	local var3_141 = var1_141 and arg0_141.scores[var1_141] or 0
	local var4_141 = {
		highestScore = var3_141,
		isFinished = var2_141,
		isUnlock = arg0_141:isUnlock(arg1_141)
	}

	if arg0_141.maps[arg1_141.id] then
		var0_141 = arg0_141.maps[arg1_141.id]

		var0_141:UpdateData(var4_141)
	else
		local var5_141, var6_141, var7_141 = arg0_141:parseMap(arg1_141)
		local var8_141 = {
			id = arg1_141.id,
			maps = var5_141,
			calcStep = var6_141,
			maxCount = arg1_141.num,
			condition = arg1_141.condition,
			started = var7_141
		}

		var0_141 = var23_0(var8_141)

		var0_141:UpdateData(var4_141)
	end

	return var0_141
end

function var0_0.parseMap(arg0_142, arg1_142)
	local var0_142 = PlayerPrefs.GetString("BlackWhiteGridMapData-" .. arg1_142.id .. "-" .. arg0_142.player.id, "")

	if not var0_142 or var0_142 == "" then
		return arg1_142.map, arg1_142.num, false
	else
		local var1_142 = var0_142:split("#")

		return loadstring("return " .. var1_142[1])(), tonumber(var1_142[2]), var1_142[3] == "1"
	end
end

function var0_0.SaveMapsData(arg0_143)
	local var0_143 = arg0_143.maps

	for iter0_143, iter1_143 in ipairs(var0_143) do
		local var1_143 = iter1_143:Serialize()

		if var1_143 and var1_143 ~= "" then
			PlayerPrefs.SetString("BlackWhiteGridMapData-" .. iter1_143.id .. "-" .. arg0_143.player.id, var1_143)
		end
	end

	PlayerPrefs.Save()
end

function var0_0.GetMapIndex(arg0_144)
	return (PlayerPrefs.GetInt("BlackWhiteGridMapIndex-" .. arg0_144.player.id, 1))
end

function var0_0.SaveMapIndex(arg0_145)
	local var0_145 = arg0_145.id or 1

	PlayerPrefs.SetInt("BlackWhiteGridMapIndex-" .. arg0_145.player.id, var0_145)
	PlayerPrefs.Save()
end

function var0_0.loadMap(arg0_146, arg1_146)
	if arg0_146.mapView then
		arg0_146.mapView:Dispose()
	end

	arg0_146.mapView = var25_0(arg0_146.mapTF, arg1_146, arg0_146.poolMgr)

	function arg0_146.mapView.onFirstFinished(arg0_147, arg1_147)
		arg0_146:emit(BlackWhiteGridMediator.ON_FINISH, arg0_147, arg1_147)
	end

	function arg0_146.mapView.onHighestScore(arg0_148, arg1_148)
		arg0_146:emit(BlackWhiteGridMediator.ON_UPDATE_SCORE, arg0_148, arg1_148)
	end

	function arg0_146.mapView.onShowResult(arg0_149, arg1_149, arg2_149)
		if arg1_149 >= 0 then
			arg0_146.successMsgbox:Show(arg1_149, arg2_149)
		else
			arg0_146.failedMsgbox:Show(arg1_149, arg2_149)
		end
	end

	arg1_146:Init()
end

function var0_0.playStory(arg0_150, arg1_150)
	local var0_150 = var16_0[arg0_150.mapView.map.id].story

	if var0_150 and var0_150 ~= "" then
		pg.NewStoryMgr.GetInstance():Play(var0_150, arg1_150, true, true)
	else
		arg1_150()
	end
end

function var0_0.willExit(arg0_151)
	arg0_151:SaveMapsData()
	arg0_151:SaveMapIndex()

	if arg0_151.mapView then
		arg0_151.mapView:Dispose()
	end

	arg0_151.successMsgbox:Dispose()
	arg0_151.failedMsgbox:Dispose()
	arg0_151.poolMgr:Dispose()

	var17_0 = nil
end

return var0_0
