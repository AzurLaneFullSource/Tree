local var0 = class("DecodeGameView")

function var0.Ctor(arg0, arg1)
	pg.DelegateInfo.New(arg0)

	arg0.controller = arg1
end

function var0.SetUI(arg0, arg1)
	arg0._tf = arg1
	arg0._go = go(arg1)
	arg0.mapItemContainer = arg0._tf:Find("game/container")
	arg0.itemList = UIItemList.New(arg0.mapItemContainer, arg0._tf:Find("game/container/tpl"))
	arg0.mapLine = arg0._tf:Find("game/line")

	setActive(arg0.mapLine, false)

	arg0.mapBtns = {
		arg0._tf:Find("btn/btn1"),
		arg0._tf:Find("btn/btn2"),
		arg0._tf:Find("btn/btn3")
	}
	arg0.engines = {
		arg0._tf:Find("tuitong/1"),
		arg0._tf:Find("tuitong/2"),
		arg0._tf:Find("tuitong/3")
	}
	arg0.engineBottom = arg0._tf:Find("tuitong/4")
	arg0.number1 = arg0._tf:Find("shuzi/1"):GetComponent(typeof(Image))
	arg0.number2 = arg0._tf:Find("shuzi/2"):GetComponent(typeof(Image))
	arg0.awardProgressTF = arg0._tf:Find("zhuanpanxinxi/jindu")
	arg0.awardProgress1TF = arg0._tf:Find("zhuanpanxinxi/jindu/zhuanpan")
	arg0.mapProgreeses = {
		arg0._tf:Find("zhuanpanxinxi/deng1"),
		arg0._tf:Find("zhuanpanxinxi/deng2"),
		arg0._tf:Find("zhuanpanxinxi/deng3")
	}
	arg0.mapPasswords = {
		arg0._tf:Find("dengguang/code1/1"),
		arg0._tf:Find("dengguang/code1/2"),
		arg0._tf:Find("dengguang/code1/3"),
		arg0._tf:Find("dengguang/code1/4"),
		arg0._tf:Find("dengguang/code1/5"),
		arg0._tf:Find("dengguang/code1/6")
	}
	arg0.encodingPanel = arg0._tf:Find("encoding")
	arg0.encodingSlider = arg0._tf:Find("encoding/slider/bar")

	setActive(arg0.encodingPanel, false)

	arg0.enterAnim = arg0._tf:Find("enter_anim")
	arg0.enterAnimTop = arg0._tf:Find("enter_anim/top")
	arg0.enterAnimBottom = arg0._tf:Find("enter_anim/bottom")

	setActive(arg0.enterAnim, false)

	arg0.bookBtn = arg0._tf:Find("btn/mima/unlock")
	arg0.mimaLockBtn = arg0._tf:Find("btn/mima/lock")
	arg0.mimaLockBlink = arg0._tf:Find("btn/mima/blink")
	arg0.code1Panel = arg0._tf:Find("dengguang/code1")
	arg0.code2Panel = arg0._tf:Find("dengguang/code2")
	arg0.passWordTF = arg0._tf:Find("game/password")
	arg0.containerSize = arg0.mapItemContainer.sizeDelta
	arg0.mosaic = arg0._tf:Find("game/Mosaic")
	arg0.lines = arg0._tf:Find("game/grids")
	arg0.code2 = {
		arg0._tf:Find("dengguang/code2/1"),
		arg0._tf:Find("dengguang/code2/2"),
		arg0._tf:Find("dengguang/code2/3"),
		arg0._tf:Find("dengguang/code2/4"),
		arg0._tf:Find("dengguang/code2/5"),
		arg0._tf:Find("dengguang/code2/6"),
		arg0._tf:Find("dengguang/code2/7"),
		arg0._tf:Find("dengguang/code2/8"),
		arg0._tf:Find("dengguang/code2/9")
	}
	arg0.lightRight = arg0._tf:Find("dengguang/code2/light_right")
	arg0.lightLeft = arg0._tf:Find("dengguang/code2/light_left")
	arg0.awardLock = arg0._tf:Find("zhuanpanxinxi/item/lock")
	arg0.awardGot = arg0._tf:Find("zhuanpanxinxi/item/got")
	arg0.screenHeight = arg0._tf.rect.height
	arg0.engineBottom.localPosition = Vector3(arg0.engineBottom.localPosition.x, -arg0.screenHeight / 2, 0)
	arg0.code2Panel.localPosition = Vector3(arg0.code2Panel.localPosition.x, arg0.screenHeight / 2, 0)
	arg0.line1 = arg0._tf:Find("game/lines/line1")
	arg0.blinkFlag = false
	arg0.helperTF = arg0._tf:Find("helper")
	arg0.tips = arg0._tf:Find("btn/tips")
	arg0.animCallbacks = {}
	arg0.decodeTV = arg0._tf:Find("game/zhezhao/DecodeTV")
	arg0.anim = arg0.decodeTV:GetComponent(typeof(Animator))
	arg0.dftAniEvent = arg0.decodeTV:GetComponent(typeof(DftAniEvent))

	arg0.dftAniEvent:SetEndEvent(function(arg0)
		for iter0, iter1 in ipairs(arg0.animCallbacks) do
			iter1()
		end

		arg0.animCallbacks = {}

		setActive(arg0.decodeTV, false)
	end)

	arg0.codeHeight = arg0.screenHeight / 2 - arg0.code1Panel.anchoredPosition.y
	arg0.code2Panel.sizeDelta = Vector2(arg0.code2Panel.sizeDelta.x, arg0.codeHeight)
	arg0.code1Panel.sizeDelta = Vector2(arg0.code1Panel.sizeDelta.x, arg0.codeHeight)
end

function var0.DoEnterAnim(arg0, arg1)
	setActive(arg0.enterAnim, true)
	LeanTween.moveLocalY(go(arg0.enterAnimTop), arg0.screenHeight / 2, 1):setFrom(-75):setDelay(DecodeGameConst.OPEN_DOOR_DELAY)
	LeanTween.moveLocalY(go(arg0.enterAnimBottom), -arg0.screenHeight / 2, 1):setFrom(75):setDelay(DecodeGameConst.OPEN_DOOR_DELAY):setOnComplete(System.Action(function()
		arg1()
		setActive(arg0.enterAnim, false)
	end))
	updateDrop(arg0._tf:Find("zhuanpanxinxi/item"), {
		id = DecodeGameConst.AWARD[2],
		type = DecodeGameConst.AWARD[1],
		count = DecodeGameConst.AWARD[3]
	})
end

function var0.Inited(arg0, arg1)
	onButton(arg0, arg0._tf:Find("btn/back"), function()
		arg0.controller:ExitGame()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("btn/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.decodegame_gametip.tip
		})
	end, SFX_PANEL)

	arg0.ison = false

	onButton(arg0, arg0.bookBtn, function()
		if arg0.controller:CanSwitch() then
			arg0.ison = not arg0.ison

			arg0.controller:SwitchToDecodeMap(arg0.ison)
			setActive(arg0.bookBtn:Find("Image"), arg0.ison)
		end
	end)

	for iter0, iter1 in ipairs(arg0.mapBtns) do
		onButton(arg0, iter1, function()
			arg0.controller:SwitchMap(iter0)
		end)
	end

	setActive(arg0.awardLock, not arg1)
	setActive(arg0.awardGot, arg1)
end

function var0.UpdateMap(arg0, arg1)
	arg0.mapItems = {}

	arg0.itemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1.items[arg1 + 1]

			arg0:UpdateMapItem(arg2, arg1, var0, arg1 + 1)
		end
	end)
	arg0.itemList:align(#arg1.items)

	local var0 = _.flatten(arg1.password)

	for iter0, iter1 in ipairs(arg0.mapPasswords) do
		local var1 = "-"

		if arg1.isUnlock then
			var1 = var0[iter0]
		end

		iter1:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/DecodeGameNumber_atlas", var1 .. "-1")
	end

	setActive(arg0.mosaic, not arg1.isUnlock)
end

function var0.UpdateMapItem(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg2.id

	arg1.localPosition = arg3.position
	go(arg1).name = arg3.index

	local var1 = arg1:Find("rect/icon")
	local var2 = var1:GetComponent(typeof(Image))
	local var3 = arg2.isUnlock and arg4 or DecodeGameConst.DISORDER[arg4]

	var2.sprite = GetSpriteFromAtlas("puzzla/bg_" .. var0 + DecodeGameConst.MAP_NAME_OFFSET, var0 .. "-" .. var3)

	var2:SetNativeSize()

	var1:GetComponent(typeof(CanvasGroup)).alpha = arg3.isUnlock and 1 or 0

	setActive(arg1:Find("rays"), false)
	setActive(arg1:Find("rays/yellow"), false)
	setActive(arg1:Find("rays/blue"), false)
	onButton(arg0, arg1, function()
		arg0.controller:Unlock(arg3.index)
	end, SFX_PANEL)

	arg0.mapItems[arg3.index] = arg1
end

function var0.OnMapRepairing(arg0, arg1)
	pg.UIMgr.GetInstance():BlurPanel(arg0.encodingPanel)
	setActive(arg0.encodingPanel, true)
	LeanTween.value(go(arg0.encodingSlider), 0, 1, DecodeGameConst.DECODE_MAP_TIME):setOnUpdate(System.Action_float(function(arg0)
		setFillAmount(arg0.encodingSlider, arg0)
	end)):setOnComplete(System.Action(function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0.encodingPanel, arg0._tf)
		setActive(arg0.encodingPanel, false)
		arg1()
	end))
end

function var0.OnSwitch(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	local var0 = arg0.mapBtns[arg1]
	local var1 = arg0.engines[arg1]

	assert(var1, arg1)

	local var2 = go(var1:Find("xinx"))
	local var3 = var1:Find("tui")
	local var4 = var3.sizeDelta.y

	LeanTween.moveLocalX(var2, arg2, DecodeGameConst.SWITCH_MAP):setFrom(arg3)
	LeanTween.value(go(var3), arg4, arg5, DecodeGameConst.SWITCH_MAP):setOnUpdate(System.Action_float(function(arg0)
		var3.sizeDelta = Vector2(arg0, var4)
	end))
	LeanTween.rotateZ(go(var0), arg6, DecodeGameConst.SWITCH_MAP):setOnComplete(System.Action(arg7))
end

function var0.OnExitMap(arg0, arg1, arg2, arg3)
	if arg2 then
		arg0.mapItemContainer.sizeDelta = Vector2(arg0.containerSize.x, 0)
	end

	arg0:OnSwitch(arg1, -11, -150, 158, 23, 0, arg3)
end

function var0.OnEnterMap(arg0, arg1, arg2, arg3)
	parallelAsync({
		function(arg0)
			arg0:OnSwitch(arg1, -150, -11, 23, 158, 90, function()
				arg0()
			end)
		end,
		function(arg0)
			if not arg2 then
				arg0()

				return
			end

			setActive(arg0.mapLine, true)
			LeanTween.value(go(arg0.mapItemContainer), 0, arg0.containerSize.y, DecodeGameConst.SCAN_MAP_TIME):setOnUpdate(System.Action_float(function(arg0)
				arg0.mapItemContainer.sizeDelta = Vector2(arg0.containerSize.x, arg0)
			end)):setOnComplete(System.Action(function()
				setActive(arg0.mapLine, false)
				arg0()
			end))
			LeanTween.value(go(arg0.mapLine), 286, 286 - arg0.containerSize.y, DecodeGameConst.SCAN_MAP_TIME):setOnUpdate(System.Action_float(function(arg0)
				arg0.mapLine.localPosition = Vector2(arg0.mapLine.localPosition.x, arg0, 0)
			end))
		end
	}, arg3)
end

function var0.UnlockMapItem(arg0, arg1, arg2)
	local var0 = arg0.mapItems[arg1]

	assert(var0)

	local var1 = var0:Find("rect/icon")
	local var2 = var1:GetComponent(typeof(CanvasGroup))

	LeanTween.value(go(var1), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0)
		var2.alpha = arg0
	end)):setOnComplete(System.Action(arg2))
end

function var0.UpdateCanUseCnt(arg0, arg1)
	local var0 = math.floor(arg1 / 10)
	local var1 = arg1 % 10

	arg0.number1.sprite = GetSpriteFromAtlas("ui/DecodeGameNumber_atlas", var0)
	arg0.number2.sprite = GetSpriteFromAtlas("ui/DecodeGameNumber_atlas", var1)
	tf(arg0.number1).localPosition = var0 == 1 and Vector3(-625, -17) or Vector3(-660, -17)
	tf(arg0.number2).localPosition = var1 == 1 and Vector3(-516.8, -17) or Vector3(-546.3, -17)
end

function var0.UpdateProgress(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg1

	if var0 < DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN * DecodeGameConst.MAX_MAP_COUNT then
		setFillAmount(arg0.awardProgressTF, var0 * DecodeGameConst.PROGRESS2FILLAMOUMT)
	else
		setFillAmount(arg0.awardProgressTF, 1)
	end

	arg0.awardProgress1TF.eulerAngles = Vector3(0, 0, 180 - var0 * DecodeGameConst.PROGRESS2ANGLE)

	setActive(arg0.bookBtn, arg2 == DecodeGameConst.MAX_MAP_COUNT)
	setActive(arg0.mapProgreeses[1], arg3[1])
	setActive(arg0.mapProgreeses[2], arg3[2])
	setActive(arg0.mapProgreeses[3], arg3[3])

	if arg2 == DecodeGameConst.MAX_MAP_COUNT and not arg0.blinkFlag then
		LeanTween.moveLocalX(go(arg0.mimaLockBtn), 150, 0.3):setOnComplete(System.Action(function()
			setActive(arg0.mimaLockBlink, true)
			blinkAni(go(arg0.mimaLockBlink), 0.2, 2):setOnComplete(System.Action(function()
				setActive(arg0.mimaLockBlink, false)
				arg4()
			end))
		end))

		arg0.blinkFlag = true
	elseif arg2 == DecodeGameConst.MAX_MAP_COUNT then
		arg0.mimaLockBtn.localPosition = Vector3(150, 0, 0)

		setActive(arg0.mimaLockBlink, false)
	else
		arg0.mimaLockBtn.localPosition = Vector3(0, 0, 0)

		arg4()
	end
end

function var0.OnEnterDecodeMapBefore(arg0, arg1)
	setActive(arg0.mosaic, true)
	setActive(arg0.lines, false)
	LeanTween.moveLocalY(go(arg0.code1Panel), arg0.screenHeight / 2, DecodeGameConst.SWITCH_TO_DECODE_TIME / 2):setOnComplete(System.Action(arg1))
end

function var0.OnEnterDecodeMap(arg0, arg1, arg2)
	parallelAsync({
		function(arg0)
			_.each(arg0.code2, function(arg0)
				setActive(arg0, false)
			end)
			LeanTween.moveLocalY(go(arg0.engineBottom), -500, DecodeGameConst.SWITCH_TO_DECODE_TIME / 2)
			LeanTween.moveLocalY(go(arg0.code2Panel), 303, DecodeGameConst.SWITCH_TO_DECODE_TIME / 2):setOnComplete(System.Action(arg0))
		end
	}, function()
		setActive(arg0.mosaic, false)
		setActive(arg0.lines, false)

		for iter0, iter1 in ipairs(arg1) do
			arg0:UpdatePassWord(iter1, iter0)
		end

		setActive(arg0.passWordTF, true)
		arg2()
	end)
end

function var0.OnEnterNormalMapBefore(arg0, arg1)
	parallelAsync({
		function(arg0)
			LeanTween.moveLocalY(go(arg0.code2Panel), arg0.screenHeight / 2, DecodeGameConst.SWITCH_TO_DECODE_TIME / 2):setOnComplete(System.Action(arg0))
		end,
		function(arg0)
			LeanTween.moveLocalY(go(arg0.engineBottom), -arg0.screenHeight / 2, DecodeGameConst.SWITCH_TO_DECODE_TIME / 2):setOnComplete(System.Action(arg0))
		end
	}, arg1)
end

function var0.OnEnterNormalMap(arg0, arg1, arg2)
	seriesAsync({
		function(arg0)
			LeanTween.moveLocalY(go(arg0.code1Panel), 303, DecodeGameConst.SWITCH_TO_DECODE_TIME / 2):setOnComplete(System.Action(arg0))
		end,
		function(arg0)
			setActive(arg0.passWordTF, false)
			arg0()
		end,
		function(arg0)
			arg0.mapItemContainer.sizeDelta = arg0.containerSize

			for iter0, iter1 in ipairs(arg1.passwordIndexs) do
				local var0 = arg0.mapItems[iter1]

				var0:Find("rect/icon"):GetComponent(typeof(CanvasGroup)).alpha = 1

				setActive(var0:Find("rays"), false)
			end

			arg0()
		end
	}, arg2)
end

function var0.OnDecodeMap(arg0, arg1, arg2)
	local var0 = {}

	local function var1(arg0)
		for iter0, iter1 in ipairs(arg1.items) do
			if iter1.index == arg0 then
				return iter1
			end
		end
	end

	for iter0, iter1 in ipairs(arg1.passwordIndexs) do
		local var2 = arg0.mapItems[iter1]
		local var3 = var2:Find("rect").sizeDelta
		local var4 = var2.localPosition
		local var5 = Vector2(var4.x + var3.x / 2, var4.y - var3.y / 2)
		local var6 = Vector2(var4.x - var3.x / 2, var4.y + var3.y / 2)

		var2:SetAsLastSibling()
		table.insert(var0, {
			target = var2,
			sizeDelta = var3,
			starPosition = var5,
			endPosition = var6,
			item = var1(iter1)
		})
	end

	local function var7()
		local var0 = Vector2(0, arg0.line1.localPosition.y)

		for iter0, iter1 in ipairs(var0) do
			local var1 = iter1.target
			local var2 = iter1.starPosition
			local var3 = iter1.endPosition
			local var4 = var1:Find("rect")
			local var5 = var4.sizeDelta

			if var0.y >= var2.y and var0.y <= var3.y then
				local var6 = var0.y - var2.y

				var4.sizeDelta = Vector2(var5.x, iter1.sizeDelta.y - var6)
			end
		end
	end

	setActive(arg0.line1, true)

	local var8 = DecodeGameConst.BLOCK_SIZE[1] * DecodeGameConst.MAP_ROW

	LeanTween.value(go(arg0.line1), 0, var8, DecodeGameConst.SCAN_GRID_TIME):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0.line1, {
			y = arg0
		})
		var7()
	end)):setOnComplete(System.Action(function()
		setActive(arg0.line1, false)

		for iter0, iter1 in ipairs(var0) do
			iter1.target:Find("rect/icon"):GetComponent(typeof(CanvasGroup)).alpha = 0
			iter1.target:Find("rect").sizeDelta = iter1.sizeDelta

			setActive(iter1.target:Find("rays"), true)
			setActive(iter1.target:Find("rays/blue"), iter1.item.isUsed)
		end

		arg2()
	end))
end

function var0.UpdatePassWord(arg0, arg1, arg2)
	if arg1 == false then
		return
	end

	local var0 = arg0.code2[arg2]

	var0:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/DecodeGameNumber_atlas", arg1 .. "-1")

	setActive(var0, true)
end

function var0.OnRightCode(arg0, arg1, arg2, arg3)
	arg0:UpdatePassWord(arg2, arg3)

	local var0 = arg0.mapItems[arg1]

	setActive(var0:Find("rays/blue"), true)
	setActive(arg0.lightRight, true)

	arg0.timer2 = Timer.New(function()
		setActive(arg0.lightRight, false)
	end, 1, 1)

	arg0.timer2:Start()
end

function var0.OnFalseCode(arg0, arg1)
	arg0:RemoveTimers()
	setActive(arg0.lightLeft, true)

	arg0.timer1 = Timer.New(function()
		setActive(arg0.lightLeft, false)
	end, 1, 1)

	arg0.timer1:Start()

	local var0 = arg0.mapItems[arg1]:Find("rays/yellow")

	setActive(var0, true)
	blinkAni(var0, 0.2, 2):setOnComplete(System.Action(function(...)
		setActive(var0, false)
	end))
end

function var0.RemoveTimers(arg0)
	if arg0.timer1 then
		arg0.timer1:Stop()

		arg0.timer1 = nil
	end

	if arg0.timer2 then
		arg0.timer2:Stop()

		arg0.timer2 = nil
	end
end

function var0.OnSuccess(arg0, arg1)
	local var0 = go(arg0.awardLock:Find("icon"))

	LeanTween.value(var0, 0, -140, DecodeGameConst.GET_AWARD_ANIM_TIME / 2):setOnUpdate(System.Action_float(function(arg0)
		tf(var0).eulerAngles = Vector3(0, 0, arg0)
	end)):setOnComplete(System.Action(function()
		LeanTween.moveLocalX(var0, 132, DecodeGameConst.GET_AWARD_ANIM_TIME / 2):setFrom(0):setOnComplete(System.Action(function()
			setActive(arg0.awardLock, false)
			setActive(arg0.awardGot, true)
			arg1()
		end))
	end))
end

function var0.ShowHelper(arg0, arg1, arg2)
	local var0 = getProxy(PlayerProxy):getRawData().id

	if PlayerPrefs.GetInt("DecodeGameHelpBg" .. var0 .. arg1, 0) > 0 then
		arg2()

		return
	end

	PlayerPrefs.SetInt("DecodeGameHelpBg" .. var0 .. arg1, 1)
	PlayerPrefs.Save()
	setActive(arg0.helperTF, true)

	local var1 = arg0.helperTF:Find("Image")
	local var2 = DecodeGameConst.HELP_BGS[arg1]
	local var3 = var2[1]
	local var4 = LoadSprite("helpbg/" .. var3, "")

	setImageSprite(var1, var4)

	var1.sizeDelta = Vector2(var2[2][1], var2[2][2])
	var1.localPosition = Vector3(var2[3][1], var2[3][2], 0)

	onButton(arg0, arg0.helperTF, function()
		setActive(arg0.helperTF, false)
		arg2()
	end, SFX_PANEL)
end

function var0.ShowTip(arg0, arg1)
	eachChild(arg0.tips, function(arg0)
		setActive(arg0, go(arg0).name == tostring(arg1))
	end)
end

function var0.PlayVoice(arg0, arg1)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1)
end

function var0.OnSwitchMap(arg0, arg1)
	arg0:PlayerMapStartAnim(arg1)
end

function var0.PlayerMapStartAnim(arg0, arg1)
	setActive(arg0.decodeTV, true)
	table.insert(arg0.animCallbacks, arg1)
	arg0.anim:SetTrigger("trigger")
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)

	arg0.mapItems = nil

	arg0:RemoveTimers()
	arg0.dftAniEvent:SetEndEvent(nil)

	arg0.animCallbacks = nil
end

return var0
