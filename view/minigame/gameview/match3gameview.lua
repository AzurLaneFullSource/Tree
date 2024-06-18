local var0_0 = class("Match3GameView", import("..BaseMiniGameView"))
local var1_0 = 6
local var2_0 = 7
local var3_0 = -405
local var4_0 = -275
local var5_0 = 135
local var6_0 = 110
local var7_0 = false
local var8_0 = 0.1
local var9_0 = 0
local var10_0 = 0.3
local var11_0 = 0.5
local var12_0 = 100
local var13_0 = 0.2
local var14_0 = 0.4
local var15_0 = 180
local var16_0 = 60
local var17_0 = 3
local var18_0 = 2
local var19_0 = 0.3
local var20_0 = 0.3
local var21_0 = 2.5
local var22_0 = "event:/ui/ddldaoshu2"
local var23_0 = "event:/ui/boat_drag"
local var24_0 = "event:/ui/break_out_full"
local var25_0 = "event:/ui/sx-good"
local var26_0 = "event:/ui/sx-perfect"
local var27_0 = "event:/ui/sx-jishu"
local var28_0 = "event:/ui/furnitrue_save"

function var0_0.getUIName(arg0_1)
	return "Match3GameUI"
end

function var0_0.getBGM(arg0_2)
	return "backyard"
end

function var0_0.init(arg0_3)
	arg0_3.matchEffect = arg0_3:findTF("effects/sanxiaoxiaoshi")
	arg0_3.goodEffect = arg0_3:findTF("effects/sanxiaoGood")
	arg0_3.greatEffect = arg0_3:findTF("effects/sanxiaoGreat")
	arg0_3.perfectEffect = arg0_3:findTF("effects/sanxiaoPerfect")
	arg0_3.hintEffect = arg0_3:findTF("effects/hint")
	arg0_3.selectedEffect = arg0_3:findTF("effects/selected")
	arg0_3.whitenMat = arg0_3:findTF("effects/whiten"):GetComponent("Image").material
	arg0_3.backBtn = arg0_3:findTF("button/back")
	arg0_3.mainPage = arg0_3:findTF("main")
	arg0_3.startBtn = arg0_3:findTF("main/start")
	arg0_3.helpBtn = arg0_3:findTF("main/rule")
	arg0_3.countdownPage = arg0_3:findTF("countdown")
	arg0_3.countdownAnim = arg0_3:findTF("countdown")
	arg0_3.gamePage = arg0_3:findTF("game")
	arg0_3.gameMask = arg0_3:findTF("game/mask")
	arg0_3.warning = arg0_3:findTF("game/warning")
	arg0_3.countdownTf = arg0_3:findTF("game/countdown")
	arg0_3.countdownText = arg0_3:findTF("game/countdown/Text")
	arg0_3.inf = arg0_3:findTF("game/countdown/inf")
	arg0_3.scoreText = arg0_3:findTF("game/score/Text")
	arg0_3.floatText = arg0_3:findTF("game/floatText")
	arg0_3.floatChar = {}
	arg0_3.pausePage = arg0_3:findTF("game/pause")
	arg0_3.pauseYes = arg0_3:findTF("game/pause/yes")
	arg0_3.pauseNo = arg0_3:findTF("game/pause/no")

	for iter0_3 = 0, 9 do
		arg0_3.floatChar[iter0_3] = arg0_3:findTF("game/floatText/" .. iter0_3)
	end

	arg0_3.tilesRoot = arg0_3:findTF("game/tiles")
	arg0_3.gameListener = arg0_3.tilesRoot:GetComponent("EventTriggerListener")
	arg0_3.longPressListener = arg0_3.tilesRoot:GetComponent("UILongPressTrigger")
	arg0_3.endPage = arg0_3:findTF("end")
	arg0_3.endBtn = arg0_3:findTF("end/end_btn")
	arg0_3.endScore = arg0_3:findTF("end/score/Text")
	arg0_3.newSign = arg0_3:findTF("end/score/Text/new")
	arg0_3.bestScore = arg0_3:findTF("end/highest/Text")
	arg0_3.tiles = {
		arg0_3:findTF("tiles/Akashi"),
		arg0_3:findTF("tiles/Ayanami"),
		arg0_3:findTF("tiles/Javelin"),
		arg0_3:findTF("tiles/Laffey"),
		arg0_3:findTF("tiles/Z23")
	}
end

function var0_0.onBackPressed(arg0_4)
	if isActive(arg0_4.mainPage) then
		arg0_4:emit(var0_0.ON_BACK)
	elseif isActive(arg0_4.pausePage) then
		triggerButton(arg0_4.pauseNo)
	elseif isActive(arg0_4.gamePage) then
		arg0_4:pause()
	elseif isActive(arg0_4.endPage) and arg0_4.endBtn:GetComponent("Button").enabled then
		triggerButton(arg0_4.endBtn)
	end
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5.backBtn, function()
		arg0_5:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.startBtn, function()
		if var7_0 then
			setActive(arg0_5.mainPage, false)
			setActive(arg0_5.gamePage, true)
			arg0_5:startGame()
		else
			arg0_5.mainPage:GetComponent("CanvasGroup").blocksRaycasts = false

			arg0_5:managedTween(LeanTween.value, function()
				arg0_5.mainPage:GetComponent("CanvasGroup").alpha = 1
				arg0_5.mainPage:GetComponent("CanvasGroup").blocksRaycasts = true

				setActive(arg0_5.mainPage, false)
				setActive(arg0_5.countdownPage, true)
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var22_0)
			end, go(arg0_5.mainPage), 1, 0, var20_0):setOnUpdate(System.Action_float(function(arg0_9)
				arg0_5.mainPage:GetComponent("CanvasGroup").alpha = arg0_9
			end))
		end
	end)
	onButton(arg0_5, arg0_5.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("3match_tip")
		})
	end, SFX_PANEL)
	arg0_5.countdownAnim:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_11)
		setActive(arg0_5.countdownPage, false)
		setActive(arg0_5.gamePage, true)
		arg0_5:startGame()
	end)
	onButton(arg0_5, arg0_5.endBtn, function()
		arg0_5.mainPage:GetComponent("CanvasGroup").blocksRaycasts = false

		arg0_5:managedTween(LeanTween.value, function()
			arg0_5.mainPage:GetComponent("CanvasGroup").alpha = 1
			arg0_5.mainPage:GetComponent("CanvasGroup").blocksRaycasts = true
		end, go(arg0_5.endPage), 0, 1, var20_0):setOnUpdate(System.Action_float(function(arg0_14)
			arg0_5.mainPage:GetComponent("CanvasGroup").alpha = arg0_14
		end))
		setActive(arg0_5.mainPage, true)
		setActive(arg0_5.countdownPage, false)
		setActive(arg0_5.gamePage, false)
		setActive(arg0_5.endPage, false)
	end)
	onButton(arg0_5, arg0_5.pauseYes, function()
		arg0_5:stopGame()
	end)
	onButton(arg0_5, arg0_5.pauseNo, function()
		setActive(arg0_5.pausePage, false)
		arg0_5:resumeGame()
	end)

	local var0_5 = false

	arg0_5.gameListener:AddPointClickFunc(function(arg0_17, arg1_17)
		if var0_5 then
			var0_5 = false

			return
		end

		if arg0_5.updating then
			return
		end

		if not arg0_5.inGame then
			return
		end

		local var0_17 = LuaHelper.ScreenToLocal(arg0_5.tilesRoot, arg1_17.position, GameObject.Find("UICamera"):GetComponent(typeof(Camera)))
		local var1_17, var2_17 = arg0_5:pos2index(var0_17)

		if arg0_5.selected then
			if arg0_5.selected == arg0_5.tileTfs[var1_17][var2_17] then
				arg0_5:unselect()
			elseif math.abs(var1_17 - arg0_5.selectedIndex.i) + math.abs(var2_17 - arg0_5.selectedIndex.j) == 1 then
				arg0_5:tryMoveTo({
					i = var1_17,
					j = var2_17
				})
			else
				arg0_5:select(var1_17, var2_17)
			end
		else
			arg0_5:select(var1_17, var2_17)
		end
	end)
	arg0_5.longPressListener.onLongPressed:AddListener(function()
		if arg0_5.updating then
			return
		end

		if not arg0_5.inGame then
			return
		end

		local var0_18 = LuaHelper.ScreenToLocal(arg0_5.tilesRoot, Input.mousePosition, GameObject.Find("UICamera"):GetComponent(typeof(Camera)))
		local var1_18, var2_18 = arg0_5:pos2index(var0_18)

		arg0_5:unselect()
		arg0_5:animate(var1_18, var2_18, true)
	end)
	arg0_5.gameListener:AddBeginDragFunc(function(arg0_19, arg1_19)
		if arg0_5.updating then
			return
		end

		if not arg0_5.inGame then
			return
		end

		var0_5 = true

		local var0_19 = arg1_19.delta
		local var1_19 = LuaHelper.ScreenToLocal(arg0_5.tilesRoot, arg1_19.position, GameObject.Find("UICamera"):GetComponent(typeof(Camera)))
		local var2_19, var3_19 = arg0_5:pos2index(var1_19)

		arg0_5:animate(var2_19, var3_19, false)
		arg0_5:unselect()

		arg0_5.selected = arg0_5.tileTfs[var2_19][var3_19]
		arg0_5.selectedIndex = {
			i = var2_19,
			j = var3_19
		}

		if math.abs(var0_19.x) > math.abs(var0_19.y) then
			var2_19 = 0
			var3_19 = var0_19.x > 0 and 1 or -1
		else
			var2_19 = var0_19.y > 0 and 1 or -1
			var3_19 = 0
		end

		arg0_5:tryMoveTo({
			i = arg0_5.selectedIndex.i + var2_19,
			j = arg0_5.selectedIndex.j + var3_19
		})
	end)
	setActive(arg0_5.mainPage, true)
	arg0_5:updateData()
end

function var0_0.updateData(arg0_20)
	arg0_20.infinite = arg0_20:GetMGHubData().count == 0

	local var0_20 = arg0_20:GetMGData():GetRuntimeData("elements")

	arg0_20.best = var0_20 and var0_20[1] or 0
end

function var0_0.index2pos(arg0_21, arg1_21, arg2_21)
	return Vector3.New(var3_0 + (arg2_21 - 1) * var5_0, var4_0 + (arg1_21 - 1) * var6_0)
end

function var0_0.pos2index(arg0_22, arg1_22)
	local var0_22 = var3_0 - var5_0 / 2
	local var1_22 = var4_0 - var6_0 / 2

	return math.ceil((arg1_22.y - var1_22) / var6_0), math.ceil((arg1_22.x - var0_22) / var5_0)
end

function var0_0.dropTime(arg0_23)
	return math.max(arg0_23 * var8_0, var9_0)
end

function var0_0.cancelHint(arg0_24)
	if arg0_24.hint then
		Destroy(arg0_24.hint)
		arg0_24.hint1:GetComponent("Animator"):SetBool("selected", false)
		arg0_24.hint2:GetComponent("Animator"):SetBool("selected", false)

		arg0_24.hint = nil
		arg0_24.hint1 = nil
		arg0_24.hint2 = nil
	end
end

local var29_0 = {
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

function var0_0.unselect(arg0_25)
	if arg0_25.selectedEffectTf then
		Destroy(arg0_25.selectedEffectTf)

		arg0_25.selectedEffectTf = nil
	end

	if arg0_25.selected then
		arg0_25:animate(arg0_25.selectedIndex.i, arg0_25.selectedIndex.j, false)

		arg0_25.selected = nil
		arg0_25.selectedIndex = nil

		arg0_25:reorderTiles()
	end
end

function var0_0.select(arg0_26, arg1_26, arg2_26)
	arg0_26:unselect()

	arg0_26.selected = arg0_26.tileTfs[arg1_26][arg2_26]
	arg0_26.selectedIndex = {
		i = arg1_26,
		j = arg2_26
	}
	arg0_26.selectedEffectTf = rtf(cloneTplTo(arg0_26.selectedEffect, arg0_26.tilesRoot))
	arg0_26.selectedEffectTf.anchoredPosition = arg0_26.selected.anchoredPosition

	arg0_26.selected:SetAsLastSibling()
	arg0_26:animate(arg1_26, arg2_26, true)
end

function var0_0.animate(arg0_27, arg1_27, arg2_27, arg3_27)
	if not arg0_27.tileTfs[arg1_27][arg2_27] then
		warning("bad position", arg1_27, arg2_27)
	end

	arg0_27.tileTfs[arg1_27][arg2_27]:GetComponent("Animator"):SetBool("selected", arg3_27)

	for iter0_27, iter1_27 in pairs(var29_0) do
		local var0_27 = arg0_27.tileTfs[arg1_27 + iter1_27[1]][arg2_27 + iter1_27[2]]

		if var0_27 then
			var0_27:GetComponent("Animator"):SetBool("selected", arg3_27)
		end
	end

	if arg0_27.hint then
		arg0_27.hint1:GetComponent("Animator"):SetBool("selected", true)
		arg0_27.hint2:GetComponent("Animator"):SetBool("selected", true)
	end
end

function var0_0.tryMoveTo(arg0_28, arg1_28)
	if arg0_28.selectedIndex == nil then
		return
	end

	if arg0_28.hintTimer then
		arg0_28.hintTimer:Pause()
	end

	if not arg0_28.tileIndicies[arg1_28.i][arg1_28.j] then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var23_0)

	if arg0_28:moveValid(arg0_28.selectedIndex, arg1_28) then
		local var0_28 = arg0_28.selectedIndex

		arg0_28:unselect()

		arg0_28.updating = true

		arg0_28:swap(var0_28, arg1_28)
		arg0_28:managedTween(LeanTween.delayedCall, function()
			if not arg0_28.inGame then
				return
			end

			arg0_28.combo = 0

			arg0_28:update()
		end, var13_0, nil)
	else
		local var1_28 = arg0_28.tileTfs[arg0_28.selectedIndex.i][arg0_28.selectedIndex.j]
		local var2_28 = arg0_28.tileTfs[arg1_28.i][arg1_28.j]
		local var3_28 = arg0_28:index2pos(arg0_28.selectedIndex.i, arg0_28.selectedIndex.j)
		local var4_28 = arg0_28:index2pos(arg1_28.i, arg1_28.j)

		arg0_28:managedTween(LeanTween.move, nil, var1_28, var4_28, var13_0):setLoopPingPong(1)
		arg0_28:managedTween(LeanTween.move, nil, var2_28, var3_28, var13_0):setLoopPingPong(1)

		arg0_28.updating = true

		arg0_28:managedTween(LeanTween.delayedCall, function()
			arg0_28.updating = false

			arg0_28.hintTimer:Resume()
		end, var13_0 * 2 + 0.1, nil)
		arg0_28:unselect()
	end
end

local var30_0 = {
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

function var0_0.isConnected(arg0_31, arg1_31)
	for iter0_31, iter1_31 in pairs(var30_0) do
		local var0_31
		local var1_31
		local var2_31
		local var3_31 = arg0_31.tileIndicies[arg1_31.i][arg1_31.j]
		local var4_31 = arg0_31.tileIndicies[arg1_31.i + iter1_31[1][1]][arg1_31.j + iter1_31[1][2]]
		local var5_31 = arg0_31.tileIndicies[arg1_31.i + iter1_31[2][1]][arg1_31.j + iter1_31[2][2]]

		if var3_31 == var4_31 and var3_31 == var5_31 then
			return true
		end

		local var6_31 = arg0_31.tileIndicies[arg1_31.i + iter1_31[1][2]][arg1_31.j + iter1_31[1][1]]
		local var7_31 = arg0_31.tileIndicies[arg1_31.i + iter1_31[2][2]][arg1_31.j + iter1_31[2][1]]

		if var3_31 == var6_31 and var3_31 == var7_31 then
			return true
		end
	end

	return false
end

function var0_0.moveValid(arg0_32, arg1_32, arg2_32)
	arg0_32.tileIndicies[arg1_32.i][arg1_32.j], arg0_32.tileIndicies[arg2_32.i][arg2_32.j] = arg0_32.tileIndicies[arg2_32.i][arg2_32.j], arg0_32.tileIndicies[arg1_32.i][arg1_32.j]

	local var0_32 = arg0_32:isConnected(arg1_32) or arg0_32:isConnected(arg2_32)

	arg0_32.tileIndicies[arg1_32.i][arg1_32.j], arg0_32.tileIndicies[arg2_32.i][arg2_32.j] = arg0_32.tileIndicies[arg2_32.i][arg2_32.j], arg0_32.tileIndicies[arg1_32.i][arg1_32.j]

	return var0_32
end

function var0_0.moveTile(arg0_33, arg1_33, arg2_33, arg3_33)
	local var0_33 = arg0_33:index2pos(arg2_33.i, arg2_33.j)

	arg0_33:managedTween(LeanTween.move, nil, arg1_33, var0_33, arg3_33 or 0):setEase(LeanTweenType.easeInQuad)
end

function var0_0.swap(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34.tileTfs[arg1_34.i][arg1_34.j]
	local var1_34 = arg0_34.tileTfs[arg2_34.i][arg2_34.j]

	arg0_34:moveTile(var0_34, arg2_34, var13_0)
	arg0_34:moveTile(var1_34, arg1_34, var13_0)

	arg0_34.tileTfs[arg1_34.i][arg1_34.j], arg0_34.tileTfs[arg2_34.i][arg2_34.j] = arg0_34.tileTfs[arg2_34.i][arg2_34.j], arg0_34.tileTfs[arg1_34.i][arg1_34.j]
	arg0_34.tileIndicies[arg1_34.i][arg1_34.j], arg0_34.tileIndicies[arg2_34.i][arg2_34.j] = arg0_34.tileIndicies[arg2_34.i][arg2_34.j], arg0_34.tileIndicies[arg1_34.i][arg1_34.j]
end

function var0_0.formatTime(arg0_35, arg1_35)
	local var0_35 = math.floor(arg1_35 / 60)

	arg1_35 = arg1_35 - var0_35 * 60

	local var1_35 = math.floor(arg1_35)

	return var0_35 .. ":" .. var1_35
end

function dir2Angle(arg0_36)
	if arg0_36[1] == 1 then
		return -90
	elseif arg0_36[1] == -1 then
		return 90
	elseif arg0_36[2] == 1 then
		return 180
	elseif arg0_36[2] == -1 then
		return 0
	end
end

function var0_0.startGame(arg0_37)
	arg0_37:updateData()

	local var0_37 = Timer.New(function()
		arg0_37:managedTween(LeanTween.value, function()
			arg0_37.gamePage:GetComponent("CanvasGroup").alpha = 1

			arg0_37:stopGame()
		end, go(arg0_37.gamePage), 1, 0, var10_0):setOnUpdate(System.Action_float(function(arg0_40)
			arg0_37.gamePage:GetComponent("CanvasGroup").alpha = arg0_40
		end))
		UpdateBeat:RemoveListener(arg0_37.handle)
	end, arg0_37.infinite and var15_0 or var16_0)

	arg0_37.handle = UpdateBeat:CreateListener(function()
		setText(arg0_37.countdownText, math.floor(var0_37.time))

		if var0_37.time <= var17_0 and not isActive(arg0_37.warning) then
			setActive(arg0_37.warning, true)
		end
	end, arg0_37)

	var0_37:Start()
	UpdateBeat:AddListener(arg0_37.handle)

	arg0_37.timer = var0_37

	setActive(arg0_37.inf, false)
	setActive(arg0_37.countdownText, true)

	arg0_37.tileIndicies = {}

	for iter0_37 = -1, var1_0 + 2 do
		arg0_37.tileIndicies[iter0_37] = {}
	end

	arg0_37.tileTfs = {}

	for iter1_37 = -1, var1_0 + 2 do
		arg0_37.tileTfs[iter1_37] = {}
	end

	arg0_37:fillTileIndicies()
	arg0_37:fillTiles(true)

	arg0_37.selected = nil
	arg0_37.updating = false
	arg0_37.score = 0
	arg0_37.combo = 0
	arg0_37.inGame = true

	setText(arg0_37.scoreText, arg0_37.score)

	function arg0_37.hintFunc()
		if arg0_37.hint then
			return
		end

		local var0_42, var1_42, var2_42 = arg0_37:findMove()
		local var3_42

		var3_42.anchoredPosition, var3_42 = (arg0_37:index2pos(var0_42, var1_42) + arg0_37:index2pos(var0_42 + var2_42[1], var1_42 + var2_42[2])) / 2, rtf(cloneTplTo(arg0_37.hintEffect, arg0_37.tilesRoot))
		var3_42.localEulerAngles = Vector3.New(0, 0, dir2Angle(var2_42))
		arg0_37.hint = var3_42
		arg0_37.hint1 = arg0_37.tileTfs[var0_42][var1_42]
		arg0_37.hint2 = arg0_37.tileTfs[var0_42 + var2_42[1]][var1_42 + var2_42[2]]

		arg0_37.hint1:GetComponent("Animator"):SetBool("selected", true)
		arg0_37.hint2:GetComponent("Animator"):SetBool("selected", true)
	end

	arg0_37.hintTimer = Timer.New(arg0_37.hintFunc, var21_0)

	arg0_37.hintTimer:Start()
end

function var0_0.pauseGame(arg0_43)
	if arg0_43.timer then
		arg0_43.timer:Pause()
	end

	if arg0_43.hintTimer then
		arg0_43.hintTimer:Pause()
	end

	if arg0_43.warning then
		arg0_43.warning:GetComponent("Animator").enabled = false
	end

	arg0_43:pauseManagedTween()
end

function var0_0.pause(arg0_44)
	setActive(arg0_44.pausePage, true)
	arg0_44:pauseGame()
end

function var0_0.resumeGame(arg0_45)
	if arg0_45.timer then
		arg0_45.timer:Resume()
	end

	if arg0_45.hintTimer then
		arg0_45.hintTimer:Resume()
	end

	if arg0_45.warning then
		arg0_45.warning:GetComponent("Animator").enabled = true
	end

	arg0_45:resumeManagedTween()
end

function var0_0.fillTileIndicies(arg0_46)
	local var0_46 = {}

	for iter0_46 = -1, var1_0 + 2 do
		var0_46[iter0_46] = {}

		for iter1_46 = 1, var2_0 do
			var0_46[iter0_46][iter1_46] = arg0_46.tileIndicies[iter0_46][iter1_46]
		end
	end

	repeat
		arg0_46.tileIndicies = {}

		for iter2_46 = -1, var1_0 + 2 do
			arg0_46.tileIndicies[iter2_46] = {}

			for iter3_46 = 1, var2_0 do
				arg0_46.tileIndicies[iter2_46][iter3_46] = var0_46[iter2_46][iter3_46]
			end
		end

		for iter4_46 = 1, var1_0 do
			for iter5_46 = 1, var2_0 do
				if not arg0_46.tileIndicies[iter4_46][iter5_46] then
					local var1_46
					local var2_46

					if arg0_46.tileIndicies[iter4_46 - 1][iter5_46] and arg0_46.tileIndicies[iter4_46 - 1][iter5_46] == arg0_46.tileIndicies[iter4_46 - 2][iter5_46] then
						var1_46 = arg0_46.tileIndicies[iter4_46 - 1][iter5_46]
					end

					if arg0_46.tileIndicies[iter4_46][iter5_46 - 1] and arg0_46.tileIndicies[iter4_46][iter5_46 - 1] == arg0_46.tileIndicies[iter4_46][iter5_46 - 2] then
						var2_46 = arg0_46.tileIndicies[iter4_46][iter5_46 - 2]
					end

					local var3_46 = math.random(1, #arg0_46.tiles)

					while var3_46 == var1_46 or var3_46 == var2_46 do
						var3_46 = math.random(1, #arg0_46.tiles)
					end

					arg0_46.tileIndicies[iter4_46][iter5_46] = var3_46
				end
			end
		end
	until arg0_46:findMove()
end

function var0_0.reorderTiles(arg0_47)
	for iter0_47 = 1, var1_0 do
		for iter1_47 = 1, var2_0 do
			if arg0_47.tileTfs[iter0_47][iter1_47] then
				arg0_47.tileTfs[iter0_47][iter1_47]:SetAsFirstSibling()
			end
		end
	end
end

function var0_0.fillTiles(arg0_48, arg1_48)
	local var0_48 = 0

	for iter0_48 = 1, var2_0 do
		local var1_48 = 0

		for iter1_48 = var1_0, 1, -1 do
			if not arg0_48.tileTfs[iter1_48][iter0_48] then
				var1_48 = var1_48 + 1
			end
		end

		var0_48 = math.max(var1_48, var0_48)

		for iter2_48 = 1, var1_0 do
			if not arg0_48.tileTfs[iter2_48][iter0_48] then
				local var2_48 = rtf(cloneTplTo(arg0_48.tiles[arg0_48.tileIndicies[iter2_48][iter0_48]], arg0_48.tilesRoot))

				if arg1_48 then
					var2_48.anchoredPosition = arg0_48:index2pos(iter2_48, iter0_48)
				else
					var2_48.anchoredPosition = arg0_48:index2pos(iter2_48 + var1_48, iter0_48)

					arg0_48:moveTile(var2_48, {
						i = iter2_48,
						j = iter0_48
					}, arg0_48.dropTime(var1_48))
				end

				arg0_48.tileTfs[iter2_48][iter0_48] = var2_48
			end
		end
	end

	arg0_48:reorderTiles()

	return var0_48
end

local var31_0 = {
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

function var0_0.findMove(arg0_49)
	for iter0_49 = 1, var1_0 do
		for iter1_49 = 1, var2_0 do
			local var0_49 = arg0_49.tileIndicies[iter0_49][iter1_49]
			local var1_49
			local var2_49

			for iter2_49, iter3_49 in pairs(var31_0) do
				local var3_49 = arg0_49.tileIndicies[iter0_49 + iter3_49[1][1]][iter1_49 + iter3_49[1][2]]
				local var4_49 = arg0_49.tileIndicies[iter0_49 + iter3_49[2][1]][iter1_49 + iter3_49[2][2]]

				if var0_49 == var3_49 and var0_49 == var4_49 then
					return iter0_49, iter1_49, {
						-1,
						0
					}
				end

				local var5_49 = arg0_49.tileIndicies[iter0_49 - iter3_49[1][1]][iter1_49 - iter3_49[1][2]]
				local var6_49 = arg0_49.tileIndicies[iter0_49 - iter3_49[2][1]][iter1_49 - iter3_49[2][2]]

				if var0_49 == var5_49 and var0_49 == var6_49 then
					return iter0_49, iter1_49, {
						1,
						0
					}
				end

				local var7_49 = arg0_49.tileIndicies[iter0_49 - iter3_49[1][2]][iter1_49 + iter3_49[1][1]]
				local var8_49 = arg0_49.tileIndicies[iter0_49 - iter3_49[2][2]][iter1_49 + iter3_49[2][1]]

				if var0_49 == var7_49 and var0_49 == var8_49 then
					return iter0_49, iter1_49, {
						0,
						-1
					}
				end

				local var9_49 = arg0_49.tileIndicies[iter0_49 + iter3_49[1][2]][iter1_49 - iter3_49[1][1]]
				local var10_49 = arg0_49.tileIndicies[iter0_49 + iter3_49[2][2]][iter1_49 - iter3_49[2][1]]

				if var0_49 == var9_49 and var0_49 == var10_49 then
					return iter0_49, iter1_49, {
						0,
						1
					}
				end
			end
		end
	end
end

function var0_0.stopGame(arg0_50)
	arg0_50.inGame = false

	setActive(arg0_50.warning, false)
	arg0_50.hintTimer:Reset(arg0_50.hintFunc, 5)
	arg0_50.hintTimer:Stop()
	arg0_50:cleanManagedTween(true)
	arg0_50:cancelHint()

	if arg0_50.timer then
		arg0_50.timer:Pause()
	end

	if arg0_50.handle then
		UpdateBeat:RemoveListener(arg0_50.handle)
	end

	for iter0_50 = 1, var1_0 do
		for iter1_50 = 1, var2_0 do
			if arg0_50.tileTfs[iter0_50][iter1_50] then
				Destroy(arg0_50.tileTfs[iter0_50][iter1_50])
			end
		end
	end

	if arg0_50.selectedEffectTf then
		Destroy(arg0_50.selectedEffectTf)

		arg0_50.selectedEffectTf = nil
	end

	setText(arg0_50.bestScore, math.max(arg0_50.best, arg0_50.score))
	setActive(arg0_50.gamePage, false)
	setActive(arg0_50.pausePage, false)
	setActive(arg0_50.endBtn, false)
	setActive(arg0_50.endPage, true)

	if arg0_50.score > 0 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var27_0)
	end

	setActive(arg0_50.newSign, false)
	setText(arg0_50.endScore, 0)
	arg0_50:managedTween(LeanTween.value, function()
		setActive(arg0_50.newSign, arg0_50.best < arg0_50.score)
		setActive(arg0_50.endBtn, true)
		setImageAlpha(arg0_50.endBtn, 0)

		arg0_50.endBtn:GetComponent("Button").enabled = false

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var28_0)
		arg0_50:managedTween(LeanTween.value, function()
			arg0_50.endBtn:GetComponent("Button").enabled = true

			if arg0_50.infinite or arg0_50.timer and arg0_50.timer.time <= 0 then
				if not arg0_50.infinite then
					arg0_50:SendSuccess(0)
				end

				if arg0_50.score > arg0_50.best then
					arg0_50:StoreDataToServer({
						arg0_50.score
					})
				end
			end

			arg0_50.timer = nil
		end, go(arg0_50.endBtn), 0, 1, var19_0):setOnUpdate(System.Action_float(function(arg0_53)
			setImageAlpha(arg0_50.endBtn, arg0_53)
		end))
	end, go(arg0_50.endScore), 0, arg0_50.score, arg0_50.score > 0 and var18_0 or 0):setOnUpdate(System.Action_float(function(arg0_54)
		setText(arg0_50.endScore, math.floor(arg0_54))
	end))
end

function var0_0.formatScore(arg0_55, arg1_55, arg2_55)
	local var0_55 = {}

	while arg2_55 > 0 do
		table.insert(var0_55, math.fmod(arg2_55, 10))

		arg2_55 = math.floor(arg2_55 / 10)
	end

	for iter0_55 = #var0_55, 1, -1 do
		cloneTplTo(arg0_55.floatChar[var0_55[iter0_55]], arg1_55)
	end
end

function var0_0.update(arg0_56)
	arg0_56.hintTimer:Stop()

	local var0_56 = true

	arg0_56.updating = true

	local var1_56 = arg0_56:tryMatch()

	if next(var1_56) ~= nil then
		arg0_56:cancelHint()

		var0_56 = false
		arg0_56.combo = arg0_56.combo + 1

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var24_0)

		local var2_56

		for iter0_56, iter1_56 in pairs(var1_56) do
			if #iter1_56 == 3 then
				var2_56 = 30 * arg0_56.combo
			elseif #iter1_56 == 4 then
				var2_56 = 60 * arg0_56.combo
			else
				var2_56 = 20 * #iter1_56 * arg0_56.combo
			end

			arg0_56.score = arg0_56.score + var2_56

			setText(arg0_56.scoreText, arg0_56.score)

			local var3_56 = Vector2.zero

			_.each(iter1_56, function(arg0_57)
				arg0_56.tileIndicies[arg0_57[1]][arg0_57[2]] = nil

				if arg0_56.tileTfs[arg0_57[1]][arg0_57[2]] then
					local var0_57 = arg0_56.tileTfs[arg0_57[1]][arg0_57[2]]

					var3_56 = var3_56 + var0_57.anchoredPosition
					var0_57:GetComponent("Image").material = arg0_56.whitenMat

					local var1_57 = var0_57.localPosition

					var1_57.z = -50

					local var2_57 = cloneTplTo(arg0_56.matchEffect, arg0_56.tilesRoot)

					var2_57.localPosition = var1_57

					arg0_56:managedTween(LeanTween.value, function()
						Destroy(var0_57)
						Destroy(var2_57)
					end, go(var0_57), 1, 0, var10_0):setOnUpdate(System.Action_float(function(arg0_59)
						setImageAlpha(var0_57, arg0_59)
						setLocalScale(var0_57, Vector3.one * arg0_59 * 2.7)
					end))
				end

				arg0_56.tileTfs[arg0_57[1]][arg0_57[2]] = nil
			end)

			var3_56 = var3_56 / #iter1_56

			local var4_56 = rtf(cloneTplTo(arg0_56.floatText, arg0_56.tilesRoot))

			var4_56.anchoredPosition = var3_56

			arg0_56:formatScore(var4_56, var2_56)
			arg0_56:managedTween(LeanTween.moveY, function()
				Destroy(var4_56)
			end, var4_56, var3_56.y + var12_0, var11_0)
		end

		arg0_56:managedTween(LeanTween.delayedCall, function()
			if not arg0_56.inGame then
				return
			end

			local var0_61 = 0

			for iter0_61 = 1, var1_0 do
				for iter1_61 = 1, var2_0 do
					if arg0_56.tileIndicies[iter0_61][iter1_61] then
						local var1_61 = iter0_61

						for iter2_61 = iter0_61, 1, -1 do
							if arg0_56.tileIndicies[iter2_61 - 1][iter1_61] or iter2_61 == 1 then
								var1_61 = iter2_61

								break
							end
						end

						if var1_61 ~= iter0_61 then
							local var2_61 = iter0_61 - var1_61

							var0_61 = math.max(var2_61, var0_61)

							arg0_56:moveTile(arg0_56.tileTfs[iter0_61][iter1_61], {
								i = var1_61,
								j = iter1_61
							}, arg0_56.dropTime(var2_61))

							arg0_56.tileTfs[var1_61][iter1_61] = arg0_56.tileTfs[iter0_61][iter1_61]
							arg0_56.tileIndicies[var1_61][iter1_61] = arg0_56.tileIndicies[iter0_61][iter1_61]
							arg0_56.tileTfs[iter0_61][iter1_61] = nil
							arg0_56.tileIndicies[iter0_61][iter1_61] = nil
						end
					end
				end
			end

			arg0_56:fillTileIndicies()

			local var3_61 = arg0_56:tryMatch()

			if arg0_56.combo > 1 and next(var3_61) == nil then
				local var4_61
				local var5_61 = Vector3.New(0, 0, -50)

				if arg0_56.combo == 2 then
					var4_61 = cloneTplTo(arg0_56.goodEffect, arg0_56.tilesRoot)

					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var25_0)
				elseif arg0_56.combo == 3 then
					var4_61 = cloneTplTo(arg0_56.greatEffect, arg0_56.tilesRoot)

					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var25_0)
				else
					var4_61 = cloneTplTo(arg0_56.perfectEffect, arg0_56.tilesRoot)

					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var26_0)
				end

				var4_61.localPosition = var5_61

				arg0_56:managedTween(LeanTween.delayedCall, function()
					Destroy(var4_61)
				end, var14_0, nil)
			end

			local var6_61 = math.max(arg0_56:fillTiles(), var0_61)

			arg0_56:managedTween(LeanTween.delayedCall, function()
				if not arg0_56.inGame then
					return
				end

				arg0_56:update()
			end, math.max(var14_0, arg0_56.dropTime(var6_61)), nil)
		end, var10_0, nil)
	end

	if arg0_56.inGame then
		arg0_56.hintTimer:Reset(arg0_56.hintFunc, var21_0)
		arg0_56.hintTimer:Start()
	end

	arg0_56.updating = not var0_56
end

function var0_0.tryMatch(arg0_64)
	local var0_64 = {}

	for iter0_64 = 1, var1_0 do
		var0_64[iter0_64] = {}
	end

	return arg0_64:bfs(var0_64)
end

function var0_0.bfs(arg0_65, arg1_65)
	local var0_65 = {}

	for iter0_65 = 1, var1_0 do
		for iter1_65 = 1, var2_0 do
			if not arg1_65[iter0_65][iter1_65] then
				if not arg0_65:isConnected({
					i = iter0_65,
					j = iter1_65
				}) then
					arg1_65[iter0_65][iter1_65] = true
				else
					local var1_65 = {
						{
							iter0_65,
							iter1_65
						}
					}
					local var2_65 = {
						{
							iter0_65,
							iter1_65
						}
					}
					local var3_65 = arg0_65.tileIndicies[iter0_65][iter1_65]

					while next(var1_65) ~= nil do
						local var4_65, var5_65 = unpack(table.remove(var1_65))

						arg1_65[var4_65][var5_65] = true

						for iter2_65, iter3_65 in pairs(var29_0) do
							local var6_65 = var4_65 + iter3_65[1]
							local var7_65 = var5_65 + iter3_65[2]

							if arg0_65.tileIndicies[var6_65][var7_65] and not arg1_65[var6_65][var7_65] and arg0_65.tileIndicies[var6_65][var7_65] == var3_65 and arg0_65:isConnected({
								i = var6_65,
								j = var7_65
							}) then
								table.insert(var1_65, {
									var6_65,
									var7_65
								})
								table.insert(var2_65, {
									var6_65,
									var7_65
								})
							end
						end
					end

					if #var2_65 >= 3 then
						table.insert(var0_65, var2_65)
					end
				end
			end
		end
	end

	return var0_65
end

return var0_0
