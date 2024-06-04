local var0 = class("GameRoomMatch3View", import("..BaseMiniGameView"))
local var1 = 6
local var2 = 7
local var3 = -405
local var4 = -275
local var5 = 135
local var6 = 110
local var7 = false
local var8 = 0.1
local var9 = 0
local var10 = 0.3
local var11 = 0.5
local var12 = 100
local var13 = 0.2
local var14 = 0.4
local var15 = 180
local var16 = 60
local var17 = 3
local var18 = 2
local var19 = 0.3
local var20 = 0.3
local var21 = 2.5
local var22 = "event:/ui/ddldaoshu2"
local var23 = "event:/ui/boat_drag"
local var24 = "event:/ui/break_out_full"
local var25 = "event:/ui/sx-good"
local var26 = "event:/ui/sx-perfect"
local var27 = "event:/ui/sx-jishu"
local var28 = "event:/ui/furnitrue_save"

function var0.getUIName(arg0)
	return "GameRoomMatch3UI"
end

function var0.getBGM(arg0)
	return "backyard"
end

function var0.init(arg0)
	arg0.matchEffect = arg0:findTF("effects/sanxiaoxiaoshi")
	arg0.goodEffect = arg0:findTF("effects/sanxiaoGood")
	arg0.greatEffect = arg0:findTF("effects/sanxiaoGreat")
	arg0.perfectEffect = arg0:findTF("effects/sanxiaoPerfect")
	arg0.hintEffect = arg0:findTF("effects/hint")
	arg0.selectedEffect = arg0:findTF("effects/selected")
	arg0.whitenMat = arg0:findTF("effects/whiten"):GetComponent("Image").material
	arg0.backBtn = arg0:findTF("button/back")
	arg0.mainPage = arg0:findTF("main")
	arg0.startBtn = arg0:findTF("main/start")
	arg0.helpBtn = arg0:findTF("main/rule")
	arg0.countdownPage = arg0:findTF("countdown")
	arg0.countdownAnim = arg0:findTF("countdown")
	arg0.gamePage = arg0:findTF("game")
	arg0.gameMask = arg0:findTF("game/mask")
	arg0.warning = arg0:findTF("game/warning")
	arg0.countdownTf = arg0:findTF("game/countdown")
	arg0.countdownText = arg0:findTF("game/countdown/Text")
	arg0.inf = arg0:findTF("game/countdown/inf")
	arg0.scoreText = arg0:findTF("game/score/Text")
	arg0.floatText = arg0:findTF("game/floatText")
	arg0.floatChar = {}
	arg0.pausePage = arg0:findTF("game/pause")
	arg0.pauseYes = arg0:findTF("game/pause/yes")
	arg0.pauseNo = arg0:findTF("game/pause/no")

	for iter0 = 0, 9 do
		arg0.floatChar[iter0] = arg0:findTF("game/floatText/" .. iter0)
	end

	arg0.tilesRoot = arg0:findTF("game/tiles")
	arg0.gameListener = arg0.tilesRoot:GetComponent("EventTriggerListener")
	arg0.longPressListener = arg0.tilesRoot:GetComponent("UILongPressTrigger")
	arg0.endPage = arg0:findTF("end")
	arg0.endBtn = arg0:findTF("end/end_btn")
	arg0.endScore = arg0:findTF("end/score/Text")
	arg0.newSign = arg0:findTF("end/score/Text/new")
	arg0.bestScore = arg0:findTF("end/highest/Text")
	arg0.tiles = {
		arg0:findTF("tiles/Akashi"),
		arg0:findTF("tiles/Ayanami"),
		arg0:findTF("tiles/Javelin"),
		arg0:findTF("tiles/Laffey"),
		arg0:findTF("tiles/Z23")
	}
end

function var0.onBackPressed(arg0)
	if isActive(arg0.mainPage) then
		arg0:emit(var0.ON_BACK)
	elseif isActive(arg0.pausePage) then
		triggerButton(arg0.pauseNo)
	elseif isActive(arg0.gamePage) then
		arg0:pause()
	elseif isActive(arg0.endPage) and arg0.endBtn:GetComponent("Button").enabled then
		triggerButton(arg0.endBtn)
	end
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0, arg0.startBtn, function()
		arg0:openCoinLayer(false)

		if var7 then
			setActive(arg0.mainPage, false)
			setActive(arg0.gamePage, true)
			arg0:startGame()
		else
			arg0.mainPage:GetComponent("CanvasGroup").blocksRaycasts = false

			arg0:managedTween(LeanTween.value, function()
				arg0.mainPage:GetComponent("CanvasGroup").alpha = 1
				arg0.mainPage:GetComponent("CanvasGroup").blocksRaycasts = true

				setActive(arg0.mainPage, false)
				setActive(arg0.countdownPage, true)
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var22)
			end, go(arg0.mainPage), 1, 0, var20):setOnUpdate(System.Action_float(function(arg0)
				arg0.mainPage:GetComponent("CanvasGroup").alpha = arg0
			end))
		end
	end)

	if arg0:getGameRoomData() then
		arg0.gameHelpTip = arg0:getGameRoomData().game_help
	end

	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = arg0.gameHelpTip
		})
	end, SFX_PANEL)
	arg0.countdownAnim:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
		setActive(arg0.countdownPage, false)
		setActive(arg0.gamePage, true)
		arg0:startGame()
	end)
	onButton(arg0, arg0.endBtn, function()
		arg0.mainPage:GetComponent("CanvasGroup").blocksRaycasts = false

		arg0:managedTween(LeanTween.value, function()
			arg0.mainPage:GetComponent("CanvasGroup").alpha = 1
			arg0.mainPage:GetComponent("CanvasGroup").blocksRaycasts = true
		end, go(arg0.endPage), 0, 1, var20):setOnUpdate(System.Action_float(function(arg0)
			arg0.mainPage:GetComponent("CanvasGroup").alpha = arg0
		end))
		setActive(arg0.mainPage, true)
		setActive(arg0.countdownPage, false)
		setActive(arg0.gamePage, false)
		setActive(arg0.endPage, false)
		arg0:openCoinLayer(true)
	end)
	onButton(arg0, arg0.pauseYes, function()
		arg0:stopGame()
	end)
	onButton(arg0, arg0.pauseNo, function()
		setActive(arg0.pausePage, false)
		arg0:resumeGame()
	end)

	local var0 = false

	arg0.gameListener:AddPointClickFunc(function(arg0, arg1)
		if var0 then
			var0 = false

			return
		end

		if arg0.updating then
			return
		end

		if not arg0.inGame then
			return
		end

		local var0 = LuaHelper.ScreenToLocal(arg0.tilesRoot, arg1.position, GameObject.Find("UICamera"):GetComponent(typeof(Camera)))
		local var1, var2 = arg0:pos2index(var0)

		if arg0.selected then
			if arg0.selected == arg0.tileTfs[var1][var2] then
				arg0:unselect()
			elseif math.abs(var1 - arg0.selectedIndex.i) + math.abs(var2 - arg0.selectedIndex.j) == 1 then
				arg0:tryMoveTo({
					i = var1,
					j = var2
				})
			else
				arg0:select(var1, var2)
			end
		else
			arg0:select(var1, var2)
		end
	end)
	arg0.longPressListener.onLongPressed:AddListener(function()
		if arg0.updating then
			return
		end

		if not arg0.inGame then
			return
		end

		local var0 = LuaHelper.ScreenToLocal(arg0.tilesRoot, Input.mousePosition, GameObject.Find("UICamera"):GetComponent(typeof(Camera)))
		local var1, var2 = arg0:pos2index(var0)

		arg0:unselect()
		arg0:animate(var1, var2, true)
	end)
	arg0.gameListener:AddBeginDragFunc(function(arg0, arg1)
		if arg0.updating then
			return
		end

		if not arg0.inGame then
			return
		end

		var0 = true

		local var0 = arg1.delta
		local var1 = LuaHelper.ScreenToLocal(arg0.tilesRoot, arg1.position, GameObject.Find("UICamera"):GetComponent(typeof(Camera)))
		local var2, var3 = arg0:pos2index(var1)

		arg0:animate(var2, var3, false)
		arg0:unselect()

		arg0.selected = arg0.tileTfs[var2][var3]
		arg0.selectedIndex = {
			i = var2,
			j = var3
		}

		if math.abs(var0.x) > math.abs(var0.y) then
			var2 = 0
			var3 = var0.x > 0 and 1 or -1
		else
			var2 = var0.y > 0 and 1 or -1
			var3 = 0
		end

		arg0:tryMoveTo({
			i = arg0.selectedIndex.i + var2,
			j = arg0.selectedIndex.j + var3
		})
	end)
	setActive(arg0.mainPage, true)
	arg0:updateData()
end

function var0.updateData(arg0)
	arg0.infinite = arg0:GetMGHubData().count == 0

	local var0 = arg0:GetMGData():GetRuntimeData("elements")

	arg0.best = var0 and var0[1] or 0
end

function var0.index2pos(arg0, arg1, arg2)
	return Vector3.New(var3 + (arg2 - 1) * var5, var4 + (arg1 - 1) * var6)
end

function var0.pos2index(arg0, arg1)
	local var0 = var3 - var5 / 2
	local var1 = var4 - var6 / 2

	return math.ceil((arg1.y - var1) / var6), math.ceil((arg1.x - var0) / var5)
end

function var0.dropTime(arg0)
	return math.max(arg0 * var8, var9)
end

function var0.cancelHint(arg0)
	if arg0.hint then
		Destroy(arg0.hint)
		arg0.hint1:GetComponent("Animator"):SetBool("selected", false)
		arg0.hint2:GetComponent("Animator"):SetBool("selected", false)

		arg0.hint = nil
		arg0.hint1 = nil
		arg0.hint2 = nil
	end
end

local var29 = {
	{
		0,
		1
	},
	{
		0,
		-1
	},
	{
		-1,
		0
	},
	{
		1,
		0
	}
}

function var0.unselect(arg0)
	if arg0.selectedEffectTf then
		Destroy(arg0.selectedEffectTf)

		arg0.selectedEffectTf = nil
	end

	if arg0.selected then
		arg0:animate(arg0.selectedIndex.i, arg0.selectedIndex.j, false)

		arg0.selected = nil
		arg0.selectedIndex = nil

		arg0:reorderTiles()
	end
end

function var0.select(arg0, arg1, arg2)
	arg0:unselect()

	arg0.selected = arg0.tileTfs[arg1][arg2]
	arg0.selectedIndex = {
		i = arg1,
		j = arg2
	}
	arg0.selectedEffectTf = rtf(cloneTplTo(arg0.selectedEffect, arg0.tilesRoot))
	arg0.selectedEffectTf.anchoredPosition = arg0.selected.anchoredPosition

	arg0.selected:SetAsLastSibling()
	arg0:animate(arg1, arg2, true)
end

function var0.animate(arg0, arg1, arg2, arg3)
	if not arg0.tileTfs[arg1][arg2] then
		warning("bad position", arg1, arg2)
	end

	arg0.tileTfs[arg1][arg2]:GetComponent("Animator"):SetBool("selected", arg3)

	for iter0, iter1 in pairs(var29) do
		local var0 = arg0.tileTfs[arg1 + iter1[1]][arg2 + iter1[2]]

		if var0 then
			var0:GetComponent("Animator"):SetBool("selected", arg3)
		end
	end

	if arg0.hint then
		arg0.hint1:GetComponent("Animator"):SetBool("selected", true)
		arg0.hint2:GetComponent("Animator"):SetBool("selected", true)
	end
end

function var0.tryMoveTo(arg0, arg1)
	if arg0.selectedIndex == nil then
		return
	end

	if arg0.hintTimer then
		arg0.hintTimer:Pause()
	end

	if not arg0.tileIndicies[arg1.i][arg1.j] then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var23)

	if arg0:moveValid(arg0.selectedIndex, arg1) then
		local var0 = arg0.selectedIndex

		arg0:unselect()

		arg0.updating = true

		arg0:swap(var0, arg1)
		arg0:managedTween(LeanTween.delayedCall, function()
			if not arg0.inGame then
				return
			end

			arg0.combo = 0

			arg0:update()
		end, var13, nil)
	else
		local var1 = arg0.tileTfs[arg0.selectedIndex.i][arg0.selectedIndex.j]
		local var2 = arg0.tileTfs[arg1.i][arg1.j]
		local var3 = arg0:index2pos(arg0.selectedIndex.i, arg0.selectedIndex.j)
		local var4 = arg0:index2pos(arg1.i, arg1.j)

		arg0:managedTween(LeanTween.move, nil, var1, var4, var13):setLoopPingPong(1)
		arg0:managedTween(LeanTween.move, nil, var2, var3, var13):setLoopPingPong(1)

		arg0.updating = true

		arg0:managedTween(LeanTween.delayedCall, function()
			arg0.updating = false

			arg0.hintTimer:Resume()
		end, var13 * 2 + 0.1, nil)
		arg0:unselect()
	end
end

local var30 = {
	{
		{
			0,
			-2
		},
		{
			0,
			-1
		}
	},
	{
		{
			0,
			-1
		},
		{
			0,
			1
		}
	},
	{
		{
			0,
			1
		},
		{
			0,
			2
		}
	}
}

function var0.isConnected(arg0, arg1)
	for iter0, iter1 in pairs(var30) do
		local var0
		local var1
		local var2
		local var3 = arg0.tileIndicies[arg1.i][arg1.j]
		local var4 = arg0.tileIndicies[arg1.i + iter1[1][1]][arg1.j + iter1[1][2]]
		local var5 = arg0.tileIndicies[arg1.i + iter1[2][1]][arg1.j + iter1[2][2]]

		if var3 == var4 and var3 == var5 then
			return true
		end

		local var6 = arg0.tileIndicies[arg1.i + iter1[1][2]][arg1.j + iter1[1][1]]
		local var7 = arg0.tileIndicies[arg1.i + iter1[2][2]][arg1.j + iter1[2][1]]

		if var3 == var6 and var3 == var7 then
			return true
		end
	end

	return false
end

function var0.moveValid(arg0, arg1, arg2)
	arg0.tileIndicies[arg1.i][arg1.j], arg0.tileIndicies[arg2.i][arg2.j] = arg0.tileIndicies[arg2.i][arg2.j], arg0.tileIndicies[arg1.i][arg1.j]

	local var0 = arg0:isConnected(arg1) or arg0:isConnected(arg2)

	arg0.tileIndicies[arg1.i][arg1.j], arg0.tileIndicies[arg2.i][arg2.j] = arg0.tileIndicies[arg2.i][arg2.j], arg0.tileIndicies[arg1.i][arg1.j]

	return var0
end

function var0.moveTile(arg0, arg1, arg2, arg3)
	local var0 = arg0:index2pos(arg2.i, arg2.j)

	arg0:managedTween(LeanTween.move, nil, arg1, var0, arg3 or 0):setEase(LeanTweenType.easeInQuad)
end

function var0.swap(arg0, arg1, arg2)
	local var0 = arg0.tileTfs[arg1.i][arg1.j]
	local var1 = arg0.tileTfs[arg2.i][arg2.j]

	arg0:moveTile(var0, arg2, var13)
	arg0:moveTile(var1, arg1, var13)

	arg0.tileTfs[arg1.i][arg1.j], arg0.tileTfs[arg2.i][arg2.j] = arg0.tileTfs[arg2.i][arg2.j], arg0.tileTfs[arg1.i][arg1.j]
	arg0.tileIndicies[arg1.i][arg1.j], arg0.tileIndicies[arg2.i][arg2.j] = arg0.tileIndicies[arg2.i][arg2.j], arg0.tileIndicies[arg1.i][arg1.j]
end

function var0.formatTime(arg0, arg1)
	local var0 = math.floor(arg1 / 60)

	arg1 = arg1 - var0 * 60

	local var1 = math.floor(arg1)

	return var0 .. ":" .. var1
end

function dir2Angle(arg0)
	if arg0[1] == 1 then
		return -90
	elseif arg0[1] == -1 then
		return 90
	elseif arg0[2] == 1 then
		return 180
	elseif arg0[2] == -1 then
		return 0
	end
end

function var0.startGame(arg0)
	arg0:updateData()

	local var0 = Timer.New(function()
		arg0:managedTween(LeanTween.value, function()
			arg0.gamePage:GetComponent("CanvasGroup").alpha = 1

			arg0:stopGame()
		end, go(arg0.gamePage), 1, 0, var10):setOnUpdate(System.Action_float(function(arg0)
			arg0.gamePage:GetComponent("CanvasGroup").alpha = arg0
		end))
		UpdateBeat:RemoveListener(arg0.handle)
	end, arg0.infinite and var15 or var16)

	arg0.handle = UpdateBeat:CreateListener(function()
		setText(arg0.countdownText, math.floor(var0.time))

		if var0.time <= var17 and not isActive(arg0.warning) then
			setActive(arg0.warning, true)
		end
	end, arg0)

	var0:Start()
	UpdateBeat:AddListener(arg0.handle)

	arg0.timer = var0

	setActive(arg0.inf, false)
	setActive(arg0.countdownText, true)

	arg0.tileIndicies = {}

	for iter0 = -1, var1 + 2 do
		arg0.tileIndicies[iter0] = {}
	end

	arg0.tileTfs = {}

	for iter1 = -1, var1 + 2 do
		arg0.tileTfs[iter1] = {}
	end

	arg0:fillTileIndicies()
	arg0:fillTiles(true)

	arg0.selected = nil
	arg0.updating = false
	arg0.score = 0
	arg0.combo = 0
	arg0.inGame = true

	setText(arg0.scoreText, arg0.score)

	function arg0.hintFunc()
		if arg0.hint then
			return
		end

		local var0, var1, var2 = arg0:findMove()
		local var3

		var3.anchoredPosition, var3 = (arg0:index2pos(var0, var1) + arg0:index2pos(var0 + var2[1], var1 + var2[2])) / 2, rtf(cloneTplTo(arg0.hintEffect, arg0.tilesRoot))
		var3.localEulerAngles = Vector3.New(0, 0, dir2Angle(var2))
		arg0.hint = var3
		arg0.hint1 = arg0.tileTfs[var0][var1]
		arg0.hint2 = arg0.tileTfs[var0 + var2[1]][var1 + var2[2]]

		arg0.hint1:GetComponent("Animator"):SetBool("selected", true)
		arg0.hint2:GetComponent("Animator"):SetBool("selected", true)
	end

	arg0.hintTimer = Timer.New(arg0.hintFunc, var21)

	arg0.hintTimer:Start()
end

function var0.pauseGame(arg0)
	if arg0.timer then
		arg0.timer:Pause()
	end

	if arg0.hintTimer then
		arg0.hintTimer:Pause()
	end

	if arg0.warning then
		arg0.warning:GetComponent("Animator").enabled = false
	end

	arg0:pauseManagedTween()
end

function var0.pause(arg0)
	setActive(arg0.pausePage, true)
	arg0:pauseGame()
end

function var0.resumeGame(arg0)
	if arg0.timer then
		arg0.timer:Resume()
	end

	if arg0.hintTimer then
		arg0.hintTimer:Resume()
	end

	if arg0.warning then
		arg0.warning:GetComponent("Animator").enabled = true
	end

	arg0:resumeManagedTween()
end

function var0.fillTileIndicies(arg0)
	local var0 = {}

	for iter0 = -1, var1 + 2 do
		var0[iter0] = {}

		for iter1 = 1, var2 do
			var0[iter0][iter1] = arg0.tileIndicies[iter0][iter1]
		end
	end

	repeat
		arg0.tileIndicies = {}

		for iter2 = -1, var1 + 2 do
			arg0.tileIndicies[iter2] = {}

			for iter3 = 1, var2 do
				arg0.tileIndicies[iter2][iter3] = var0[iter2][iter3]
			end
		end

		for iter4 = 1, var1 do
			for iter5 = 1, var2 do
				if not arg0.tileIndicies[iter4][iter5] then
					local var1
					local var2

					if arg0.tileIndicies[iter4 - 1][iter5] and arg0.tileIndicies[iter4 - 1][iter5] == arg0.tileIndicies[iter4 - 2][iter5] then
						var1 = arg0.tileIndicies[iter4 - 1][iter5]
					end

					if arg0.tileIndicies[iter4][iter5 - 1] and arg0.tileIndicies[iter4][iter5 - 1] == arg0.tileIndicies[iter4][iter5 - 2] then
						var2 = arg0.tileIndicies[iter4][iter5 - 2]
					end

					local var3 = math.random(1, #arg0.tiles)

					while var3 == var1 or var3 == var2 do
						var3 = math.random(1, #arg0.tiles)
					end

					arg0.tileIndicies[iter4][iter5] = var3
				end
			end
		end
	until arg0:findMove()
end

function var0.reorderTiles(arg0)
	for iter0 = 1, var1 do
		for iter1 = 1, var2 do
			if arg0.tileTfs[iter0][iter1] then
				arg0.tileTfs[iter0][iter1]:SetAsFirstSibling()
			end
		end
	end
end

function var0.fillTiles(arg0, arg1)
	local var0 = 0

	for iter0 = 1, var2 do
		local var1 = 0

		for iter1 = var1, 1, -1 do
			if not arg0.tileTfs[iter1][iter0] then
				var1 = var1 + 1
			end
		end

		var0 = math.max(var1, var0)

		for iter2 = 1, var1 do
			if not arg0.tileTfs[iter2][iter0] then
				local var2 = rtf(cloneTplTo(arg0.tiles[arg0.tileIndicies[iter2][iter0]], arg0.tilesRoot))

				if arg1 then
					var2.anchoredPosition = arg0:index2pos(iter2, iter0)
				else
					var2.anchoredPosition = arg0:index2pos(iter2 + var1, iter0)

					arg0:moveTile(var2, {
						i = iter2,
						j = iter0
					}, arg0.dropTime(var1))
				end

				arg0.tileTfs[iter2][iter0] = var2
			end
		end
	end

	arg0:reorderTiles()

	return var0
end

local var31 = {
	{
		{
			-1,
			-2
		},
		{
			-1,
			-1
		}
	},
	{
		{
			-1,
			-1
		},
		{
			-1,
			1
		}
	},
	{
		{
			-1,
			1
		},
		{
			-1,
			2
		}
	}
}

function var0.findMove(arg0)
	for iter0 = 1, var1 do
		for iter1 = 1, var2 do
			local var0 = arg0.tileIndicies[iter0][iter1]
			local var1
			local var2

			for iter2, iter3 in pairs(var31) do
				local var3 = arg0.tileIndicies[iter0 + iter3[1][1]][iter1 + iter3[1][2]]
				local var4 = arg0.tileIndicies[iter0 + iter3[2][1]][iter1 + iter3[2][2]]

				if var0 == var3 and var0 == var4 then
					return iter0, iter1, {
						-1,
						0
					}
				end

				local var5 = arg0.tileIndicies[iter0 - iter3[1][1]][iter1 - iter3[1][2]]
				local var6 = arg0.tileIndicies[iter0 - iter3[2][1]][iter1 - iter3[2][2]]

				if var0 == var5 and var0 == var6 then
					return iter0, iter1, {
						1,
						0
					}
				end

				local var7 = arg0.tileIndicies[iter0 - iter3[1][2]][iter1 + iter3[1][1]]
				local var8 = arg0.tileIndicies[iter0 - iter3[2][2]][iter1 + iter3[2][1]]

				if var0 == var7 and var0 == var8 then
					return iter0, iter1, {
						0,
						-1
					}
				end

				local var9 = arg0.tileIndicies[iter0 + iter3[1][2]][iter1 - iter3[1][1]]
				local var10 = arg0.tileIndicies[iter0 + iter3[2][2]][iter1 - iter3[2][1]]

				if var0 == var9 and var0 == var10 then
					return iter0, iter1, {
						0,
						1
					}
				end
			end
		end
	end
end

function var0.stopGame(arg0)
	arg0.inGame = false

	setActive(arg0.warning, false)
	arg0.hintTimer:Reset(arg0.hintFunc, 5)
	arg0.hintTimer:Stop()
	arg0:cleanManagedTween(true)
	arg0:cancelHint()

	if arg0.timer then
		arg0.timer:Pause()
	end

	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end

	for iter0 = 1, var1 do
		for iter1 = 1, var2 do
			if arg0.tileTfs[iter0][iter1] then
				Destroy(arg0.tileTfs[iter0][iter1])
			end
		end
	end

	if arg0.selectedEffectTf then
		Destroy(arg0.selectedEffectTf)

		arg0.selectedEffectTf = nil
	end

	setText(arg0.bestScore, math.max(arg0.best, arg0.score))
	setActive(arg0.gamePage, false)
	setActive(arg0.pausePage, false)
	setActive(arg0.endBtn, false)
	setActive(arg0.endPage, true)

	if arg0.score > 0 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var27)
	end

	setActive(arg0.newSign, false)
	setText(arg0.endScore, 0)
	arg0:managedTween(LeanTween.value, function()
		setActive(arg0.newSign, arg0.best < arg0.score)
		setActive(arg0.endBtn, true)
		setImageAlpha(arg0.endBtn, 0)

		arg0.endBtn:GetComponent("Button").enabled = false

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var28)
		arg0:managedTween(LeanTween.value, function()
			arg0.endBtn:GetComponent("Button").enabled = true
			arg0.timer = nil

			arg0:SendSuccess(arg0.score)
		end, go(arg0.endBtn), 0, 1, var19):setOnUpdate(System.Action_float(function(arg0)
			setImageAlpha(arg0.endBtn, arg0)
		end))
	end, go(arg0.endScore), 0, arg0.score, arg0.score > 0 and var18 or 0):setOnUpdate(System.Action_float(function(arg0)
		setText(arg0.endScore, math.floor(arg0))
	end))
end

function var0.formatScore(arg0, arg1, arg2)
	local var0 = {}

	while arg2 > 0 do
		table.insert(var0, math.fmod(arg2, 10))

		arg2 = math.floor(arg2 / 10)
	end

	for iter0 = #var0, 1, -1 do
		cloneTplTo(arg0.floatChar[var0[iter0]], arg1)
	end
end

function var0.update(arg0)
	arg0.hintTimer:Stop()

	local var0 = true

	arg0.updating = true

	local var1 = arg0:tryMatch()

	if next(var1) ~= nil then
		arg0:cancelHint()

		var0 = false
		arg0.combo = arg0.combo + 1

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var24)

		local var2

		for iter0, iter1 in pairs(var1) do
			if #iter1 == 3 then
				var2 = 30 * arg0.combo
			elseif #iter1 == 4 then
				var2 = 60 * arg0.combo
			else
				var2 = 20 * #iter1 * arg0.combo
			end

			arg0.score = arg0.score + var2

			setText(arg0.scoreText, arg0.score)

			local var3 = Vector2.zero

			_.each(iter1, function(arg0)
				arg0.tileIndicies[arg0[1]][arg0[2]] = nil

				if arg0.tileTfs[arg0[1]][arg0[2]] then
					local var0 = arg0.tileTfs[arg0[1]][arg0[2]]

					var3 = var3 + var0.anchoredPosition
					var0:GetComponent("Image").material = arg0.whitenMat

					local var1 = var0.localPosition

					var1.z = -50

					local var2 = cloneTplTo(arg0.matchEffect, arg0.tilesRoot)

					var2.localPosition = var1

					arg0:managedTween(LeanTween.value, function()
						Destroy(var0)
						Destroy(var2)
					end, go(var0), 1, 0, var10):setOnUpdate(System.Action_float(function(arg0)
						setImageAlpha(var0, arg0)
						setLocalScale(var0, Vector3.one * arg0 * 2.7)
					end))
				end

				arg0.tileTfs[arg0[1]][arg0[2]] = nil
			end)

			var3 = var3 / #iter1

			local var4 = rtf(cloneTplTo(arg0.floatText, arg0.tilesRoot))

			var4.anchoredPosition = var3

			arg0:formatScore(var4, var2)
			arg0:managedTween(LeanTween.moveY, function()
				Destroy(var4)
			end, var4, var3.y + var12, var11)
		end

		arg0:managedTween(LeanTween.delayedCall, function()
			if not arg0.inGame then
				return
			end

			local var0 = 0

			for iter0 = 1, var1 do
				for iter1 = 1, var2 do
					if arg0.tileIndicies[iter0][iter1] then
						local var1 = iter0

						for iter2 = iter0, 1, -1 do
							if arg0.tileIndicies[iter2 - 1][iter1] or iter2 == 1 then
								var1 = iter2

								break
							end
						end

						if var1 ~= iter0 then
							local var2 = iter0 - var1

							var0 = math.max(var2, var0)

							arg0:moveTile(arg0.tileTfs[iter0][iter1], {
								i = var1,
								j = iter1
							}, arg0.dropTime(var2))

							arg0.tileTfs[var1][iter1] = arg0.tileTfs[iter0][iter1]
							arg0.tileIndicies[var1][iter1] = arg0.tileIndicies[iter0][iter1]
							arg0.tileTfs[iter0][iter1] = nil
							arg0.tileIndicies[iter0][iter1] = nil
						end
					end
				end
			end

			arg0:fillTileIndicies()

			local var3 = arg0:tryMatch()

			if arg0.combo > 1 and next(var3) == nil then
				local var4
				local var5 = Vector3.New(0, 0, -50)

				if arg0.combo == 2 then
					var4 = cloneTplTo(arg0.goodEffect, arg0.tilesRoot)

					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var25)
				elseif arg0.combo == 3 then
					var4 = cloneTplTo(arg0.greatEffect, arg0.tilesRoot)

					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var25)
				else
					var4 = cloneTplTo(arg0.perfectEffect, arg0.tilesRoot)

					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var26)
				end

				var4.localPosition = var5

				arg0:managedTween(LeanTween.delayedCall, function()
					Destroy(var4)
				end, var14, nil)
			end

			local var6 = math.max(arg0:fillTiles(), var0)

			arg0:managedTween(LeanTween.delayedCall, function()
				if not arg0.inGame then
					return
				end

				arg0:update()
			end, math.max(var14, arg0.dropTime(var6)), nil)
		end, var10, nil)
	end

	if arg0.inGame then
		arg0.hintTimer:Reset(arg0.hintFunc, var21)
		arg0.hintTimer:Start()
	end

	arg0.updating = not var0
end

function var0.tryMatch(arg0)
	local var0 = {}

	for iter0 = 1, var1 do
		var0[iter0] = {}
	end

	return arg0:bfs(var0)
end

function var0.bfs(arg0, arg1)
	local var0 = {}

	for iter0 = 1, var1 do
		for iter1 = 1, var2 do
			if not arg1[iter0][iter1] then
				if not arg0:isConnected({
					i = iter0,
					j = iter1
				}) then
					arg1[iter0][iter1] = true
				else
					local var1 = {
						{
							iter0,
							iter1
						}
					}
					local var2 = {
						{
							iter0,
							iter1
						}
					}
					local var3 = arg0.tileIndicies[iter0][iter1]

					while next(var1) ~= nil do
						local var4, var5 = unpack(table.remove(var1))

						arg1[var4][var5] = true

						for iter2, iter3 in pairs(var29) do
							local var6 = var4 + iter3[1]
							local var7 = var5 + iter3[2]

							if arg0.tileIndicies[var6][var7] and not arg1[var6][var7] and arg0.tileIndicies[var6][var7] == var3 and arg0:isConnected({
								i = var6,
								j = var7
							}) then
								table.insert(var1, {
									var6,
									var7
								})
								table.insert(var2, {
									var6,
									var7
								})
							end
						end
					end

					if #var2 >= 3 then
						table.insert(var0, var2)
					end
				end
			end
		end
	end

	return var0
end

return var0
