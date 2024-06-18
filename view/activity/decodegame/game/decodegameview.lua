local var0_0 = class("DecodeGameView")

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.controller = arg1_1
end

function var0_0.SetUI(arg0_2, arg1_2)
	arg0_2._tf = arg1_2
	arg0_2._go = go(arg1_2)
	arg0_2.mapItemContainer = arg0_2._tf:Find("game/container")
	arg0_2.itemList = UIItemList.New(arg0_2.mapItemContainer, arg0_2._tf:Find("game/container/tpl"))
	arg0_2.mapLine = arg0_2._tf:Find("game/line")

	setActive(arg0_2.mapLine, false)

	arg0_2.mapBtns = {
		arg0_2._tf:Find("btn/btn1"),
		arg0_2._tf:Find("btn/btn2"),
		arg0_2._tf:Find("btn/btn3")
	}
	arg0_2.engines = {
		arg0_2._tf:Find("tuitong/1"),
		arg0_2._tf:Find("tuitong/2"),
		arg0_2._tf:Find("tuitong/3")
	}
	arg0_2.engineBottom = arg0_2._tf:Find("tuitong/4")
	arg0_2.number1 = arg0_2._tf:Find("shuzi/1"):GetComponent(typeof(Image))
	arg0_2.number2 = arg0_2._tf:Find("shuzi/2"):GetComponent(typeof(Image))
	arg0_2.awardProgressTF = arg0_2._tf:Find("zhuanpanxinxi/jindu")
	arg0_2.awardProgress1TF = arg0_2._tf:Find("zhuanpanxinxi/jindu/zhuanpan")
	arg0_2.mapProgreeses = {
		arg0_2._tf:Find("zhuanpanxinxi/deng1"),
		arg0_2._tf:Find("zhuanpanxinxi/deng2"),
		arg0_2._tf:Find("zhuanpanxinxi/deng3")
	}
	arg0_2.mapPasswords = {
		arg0_2._tf:Find("dengguang/code1/1"),
		arg0_2._tf:Find("dengguang/code1/2"),
		arg0_2._tf:Find("dengguang/code1/3"),
		arg0_2._tf:Find("dengguang/code1/4"),
		arg0_2._tf:Find("dengguang/code1/5"),
		arg0_2._tf:Find("dengguang/code1/6")
	}
	arg0_2.encodingPanel = arg0_2._tf:Find("encoding")
	arg0_2.encodingSlider = arg0_2._tf:Find("encoding/slider/bar")

	setActive(arg0_2.encodingPanel, false)

	arg0_2.enterAnim = arg0_2._tf:Find("enter_anim")
	arg0_2.enterAnimTop = arg0_2._tf:Find("enter_anim/top")
	arg0_2.enterAnimBottom = arg0_2._tf:Find("enter_anim/bottom")

	setActive(arg0_2.enterAnim, false)

	arg0_2.bookBtn = arg0_2._tf:Find("btn/mima/unlock")
	arg0_2.mimaLockBtn = arg0_2._tf:Find("btn/mima/lock")
	arg0_2.mimaLockBlink = arg0_2._tf:Find("btn/mima/blink")
	arg0_2.code1Panel = arg0_2._tf:Find("dengguang/code1")
	arg0_2.code2Panel = arg0_2._tf:Find("dengguang/code2")
	arg0_2.passWordTF = arg0_2._tf:Find("game/password")
	arg0_2.containerSize = arg0_2.mapItemContainer.sizeDelta
	arg0_2.mosaic = arg0_2._tf:Find("game/Mosaic")
	arg0_2.lines = arg0_2._tf:Find("game/grids")
	arg0_2.code2 = {
		arg0_2._tf:Find("dengguang/code2/1"),
		arg0_2._tf:Find("dengguang/code2/2"),
		arg0_2._tf:Find("dengguang/code2/3"),
		arg0_2._tf:Find("dengguang/code2/4"),
		arg0_2._tf:Find("dengguang/code2/5"),
		arg0_2._tf:Find("dengguang/code2/6"),
		arg0_2._tf:Find("dengguang/code2/7"),
		arg0_2._tf:Find("dengguang/code2/8"),
		arg0_2._tf:Find("dengguang/code2/9")
	}
	arg0_2.lightRight = arg0_2._tf:Find("dengguang/code2/light_right")
	arg0_2.lightLeft = arg0_2._tf:Find("dengguang/code2/light_left")
	arg0_2.awardLock = arg0_2._tf:Find("zhuanpanxinxi/item/lock")
	arg0_2.awardGot = arg0_2._tf:Find("zhuanpanxinxi/item/got")
	arg0_2.screenHeight = arg0_2._tf.rect.height
	arg0_2.engineBottom.localPosition = Vector3(arg0_2.engineBottom.localPosition.x, -arg0_2.screenHeight / 2, 0)
	arg0_2.code2Panel.localPosition = Vector3(arg0_2.code2Panel.localPosition.x, arg0_2.screenHeight / 2, 0)
	arg0_2.line1 = arg0_2._tf:Find("game/lines/line1")
	arg0_2.blinkFlag = false
	arg0_2.helperTF = arg0_2._tf:Find("helper")
	arg0_2.tips = arg0_2._tf:Find("btn/tips")
	arg0_2.animCallbacks = {}
	arg0_2.decodeTV = arg0_2._tf:Find("game/zhezhao/DecodeTV")
	arg0_2.anim = arg0_2.decodeTV:GetComponent(typeof(Animator))
	arg0_2.dftAniEvent = arg0_2.decodeTV:GetComponent(typeof(DftAniEvent))

	arg0_2.dftAniEvent:SetEndEvent(function(arg0_3)
		for iter0_3, iter1_3 in ipairs(arg0_2.animCallbacks) do
			iter1_3()
		end

		arg0_2.animCallbacks = {}

		setActive(arg0_2.decodeTV, false)
	end)

	arg0_2.codeHeight = arg0_2.screenHeight / 2 - arg0_2.code1Panel.anchoredPosition.y
	arg0_2.code2Panel.sizeDelta = Vector2(arg0_2.code2Panel.sizeDelta.x, arg0_2.codeHeight)
	arg0_2.code1Panel.sizeDelta = Vector2(arg0_2.code1Panel.sizeDelta.x, arg0_2.codeHeight)
end

function var0_0.DoEnterAnim(arg0_4, arg1_4)
	setActive(arg0_4.enterAnim, true)
	LeanTween.moveLocalY(go(arg0_4.enterAnimTop), arg0_4.screenHeight / 2, 1):setFrom(-75):setDelay(DecodeGameConst.OPEN_DOOR_DELAY)
	LeanTween.moveLocalY(go(arg0_4.enterAnimBottom), -arg0_4.screenHeight / 2, 1):setFrom(75):setDelay(DecodeGameConst.OPEN_DOOR_DELAY):setOnComplete(System.Action(function()
		arg1_4()
		setActive(arg0_4.enterAnim, false)
	end))
	updateDrop(arg0_4._tf:Find("zhuanpanxinxi/item"), {
		id = DecodeGameConst.AWARD[2],
		type = DecodeGameConst.AWARD[1],
		count = DecodeGameConst.AWARD[3]
	})
end

function var0_0.Inited(arg0_6, arg1_6)
	onButton(arg0_6, arg0_6._tf:Find("btn/back"), function()
		arg0_6.controller:ExitGame()
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6._tf:Find("btn/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.decodegame_gametip.tip
		})
	end, SFX_PANEL)

	arg0_6.ison = false

	onButton(arg0_6, arg0_6.bookBtn, function()
		if arg0_6.controller:CanSwitch() then
			arg0_6.ison = not arg0_6.ison

			arg0_6.controller:SwitchToDecodeMap(arg0_6.ison)
			setActive(arg0_6.bookBtn:Find("Image"), arg0_6.ison)
		end
	end)

	for iter0_6, iter1_6 in ipairs(arg0_6.mapBtns) do
		onButton(arg0_6, iter1_6, function()
			arg0_6.controller:SwitchMap(iter0_6)
		end)
	end

	setActive(arg0_6.awardLock, not arg1_6)
	setActive(arg0_6.awardGot, arg1_6)
end

function var0_0.UpdateMap(arg0_11, arg1_11)
	arg0_11.mapItems = {}

	arg0_11.itemList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = arg1_11.items[arg1_12 + 1]

			arg0_11:UpdateMapItem(arg2_12, arg1_11, var0_12, arg1_12 + 1)
		end
	end)
	arg0_11.itemList:align(#arg1_11.items)

	local var0_11 = _.flatten(arg1_11.password)

	for iter0_11, iter1_11 in ipairs(arg0_11.mapPasswords) do
		local var1_11 = "-"

		if arg1_11.isUnlock then
			var1_11 = var0_11[iter0_11]
		end

		iter1_11:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/DecodeGameNumber_atlas", var1_11 .. "-1")
	end

	setActive(arg0_11.mosaic, not arg1_11.isUnlock)
end

function var0_0.UpdateMapItem(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	local var0_13 = arg2_13.id

	arg1_13.localPosition = arg3_13.position
	go(arg1_13).name = arg3_13.index

	local var1_13 = arg1_13:Find("rect/icon")
	local var2_13 = var1_13:GetComponent(typeof(Image))
	local var3_13 = arg2_13.isUnlock and arg4_13 or DecodeGameConst.DISORDER[arg4_13]

	var2_13.sprite = GetSpriteFromAtlas("puzzla/bg_" .. var0_13 + DecodeGameConst.MAP_NAME_OFFSET, var0_13 .. "-" .. var3_13)

	var2_13:SetNativeSize()

	var1_13:GetComponent(typeof(CanvasGroup)).alpha = arg3_13.isUnlock and 1 or 0

	setActive(arg1_13:Find("rays"), false)
	setActive(arg1_13:Find("rays/yellow"), false)
	setActive(arg1_13:Find("rays/blue"), false)
	onButton(arg0_13, arg1_13, function()
		arg0_13.controller:Unlock(arg3_13.index)
	end, SFX_PANEL)

	arg0_13.mapItems[arg3_13.index] = arg1_13
end

function var0_0.OnMapRepairing(arg0_15, arg1_15)
	pg.UIMgr.GetInstance():BlurPanel(arg0_15.encodingPanel)
	setActive(arg0_15.encodingPanel, true)
	LeanTween.value(go(arg0_15.encodingSlider), 0, 1, DecodeGameConst.DECODE_MAP_TIME):setOnUpdate(System.Action_float(function(arg0_16)
		setFillAmount(arg0_15.encodingSlider, arg0_16)
	end)):setOnComplete(System.Action(function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0_15.encodingPanel, arg0_15._tf)
		setActive(arg0_15.encodingPanel, false)
		arg1_15()
	end))
end

function var0_0.OnSwitch(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18, arg5_18, arg6_18, arg7_18)
	local var0_18 = arg0_18.mapBtns[arg1_18]
	local var1_18 = arg0_18.engines[arg1_18]

	assert(var1_18, arg1_18)

	local var2_18 = go(var1_18:Find("xinx"))
	local var3_18 = var1_18:Find("tui")
	local var4_18 = var3_18.sizeDelta.y

	LeanTween.moveLocalX(var2_18, arg2_18, DecodeGameConst.SWITCH_MAP):setFrom(arg3_18)
	LeanTween.value(go(var3_18), arg4_18, arg5_18, DecodeGameConst.SWITCH_MAP):setOnUpdate(System.Action_float(function(arg0_19)
		var3_18.sizeDelta = Vector2(arg0_19, var4_18)
	end))
	LeanTween.rotateZ(go(var0_18), arg6_18, DecodeGameConst.SWITCH_MAP):setOnComplete(System.Action(arg7_18))
end

function var0_0.OnExitMap(arg0_20, arg1_20, arg2_20, arg3_20)
	if arg2_20 then
		arg0_20.mapItemContainer.sizeDelta = Vector2(arg0_20.containerSize.x, 0)
	end

	arg0_20:OnSwitch(arg1_20, -11, -150, 158, 23, 0, arg3_20)
end

function var0_0.OnEnterMap(arg0_21, arg1_21, arg2_21, arg3_21)
	parallelAsync({
		function(arg0_22)
			arg0_21:OnSwitch(arg1_21, -150, -11, 23, 158, 90, function()
				arg0_22()
			end)
		end,
		function(arg0_24)
			if not arg2_21 then
				arg0_24()

				return
			end

			setActive(arg0_21.mapLine, true)
			LeanTween.value(go(arg0_21.mapItemContainer), 0, arg0_21.containerSize.y, DecodeGameConst.SCAN_MAP_TIME):setOnUpdate(System.Action_float(function(arg0_25)
				arg0_21.mapItemContainer.sizeDelta = Vector2(arg0_21.containerSize.x, arg0_25)
			end)):setOnComplete(System.Action(function()
				setActive(arg0_21.mapLine, false)
				arg0_24()
			end))
			LeanTween.value(go(arg0_21.mapLine), 286, 286 - arg0_21.containerSize.y, DecodeGameConst.SCAN_MAP_TIME):setOnUpdate(System.Action_float(function(arg0_27)
				arg0_21.mapLine.localPosition = Vector2(arg0_21.mapLine.localPosition.x, arg0_27, 0)
			end))
		end
	}, arg3_21)
end

function var0_0.UnlockMapItem(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg0_28.mapItems[arg1_28]

	assert(var0_28)

	local var1_28 = var0_28:Find("rect/icon")
	local var2_28 = var1_28:GetComponent(typeof(CanvasGroup))

	LeanTween.value(go(var1_28), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0_29)
		var2_28.alpha = arg0_29
	end)):setOnComplete(System.Action(arg2_28))
end

function var0_0.UpdateCanUseCnt(arg0_30, arg1_30)
	local var0_30 = math.floor(arg1_30 / 10)
	local var1_30 = arg1_30 % 10

	arg0_30.number1.sprite = GetSpriteFromAtlas("ui/DecodeGameNumber_atlas", var0_30)
	arg0_30.number2.sprite = GetSpriteFromAtlas("ui/DecodeGameNumber_atlas", var1_30)
	tf(arg0_30.number1).localPosition = var0_30 == 1 and Vector3(-625, -17) or Vector3(-660, -17)
	tf(arg0_30.number2).localPosition = var1_30 == 1 and Vector3(-516.8, -17) or Vector3(-546.3, -17)
end

function var0_0.UpdateProgress(arg0_31, arg1_31, arg2_31, arg3_31, arg4_31)
	local var0_31 = arg1_31

	if var0_31 < DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN * DecodeGameConst.MAX_MAP_COUNT then
		setFillAmount(arg0_31.awardProgressTF, var0_31 * DecodeGameConst.PROGRESS2FILLAMOUMT)
	else
		setFillAmount(arg0_31.awardProgressTF, 1)
	end

	arg0_31.awardProgress1TF.eulerAngles = Vector3(0, 0, 180 - var0_31 * DecodeGameConst.PROGRESS2ANGLE)

	setActive(arg0_31.bookBtn, arg2_31 == DecodeGameConst.MAX_MAP_COUNT)
	setActive(arg0_31.mapProgreeses[1], arg3_31[1])
	setActive(arg0_31.mapProgreeses[2], arg3_31[2])
	setActive(arg0_31.mapProgreeses[3], arg3_31[3])

	if arg2_31 == DecodeGameConst.MAX_MAP_COUNT and not arg0_31.blinkFlag then
		LeanTween.moveLocalX(go(arg0_31.mimaLockBtn), 150, 0.3):setOnComplete(System.Action(function()
			setActive(arg0_31.mimaLockBlink, true)
			blinkAni(go(arg0_31.mimaLockBlink), 0.2, 2):setOnComplete(System.Action(function()
				setActive(arg0_31.mimaLockBlink, false)
				arg4_31()
			end))
		end))

		arg0_31.blinkFlag = true
	elseif arg2_31 == DecodeGameConst.MAX_MAP_COUNT then
		arg0_31.mimaLockBtn.localPosition = Vector3(150, 0, 0)

		setActive(arg0_31.mimaLockBlink, false)
	else
		arg0_31.mimaLockBtn.localPosition = Vector3(0, 0, 0)

		arg4_31()
	end
end

function var0_0.OnEnterDecodeMapBefore(arg0_34, arg1_34)
	setActive(arg0_34.mosaic, true)
	setActive(arg0_34.lines, false)
	LeanTween.moveLocalY(go(arg0_34.code1Panel), arg0_34.screenHeight / 2, DecodeGameConst.SWITCH_TO_DECODE_TIME / 2):setOnComplete(System.Action(arg1_34))
end

function var0_0.OnEnterDecodeMap(arg0_35, arg1_35, arg2_35)
	parallelAsync({
		function(arg0_36)
			_.each(arg0_35.code2, function(arg0_37)
				setActive(arg0_37, false)
			end)
			LeanTween.moveLocalY(go(arg0_35.engineBottom), -500, DecodeGameConst.SWITCH_TO_DECODE_TIME / 2)
			LeanTween.moveLocalY(go(arg0_35.code2Panel), 303, DecodeGameConst.SWITCH_TO_DECODE_TIME / 2):setOnComplete(System.Action(arg0_36))
		end
	}, function()
		setActive(arg0_35.mosaic, false)
		setActive(arg0_35.lines, false)

		for iter0_38, iter1_38 in ipairs(arg1_35) do
			arg0_35:UpdatePassWord(iter1_38, iter0_38)
		end

		setActive(arg0_35.passWordTF, true)
		arg2_35()
	end)
end

function var0_0.OnEnterNormalMapBefore(arg0_39, arg1_39)
	parallelAsync({
		function(arg0_40)
			LeanTween.moveLocalY(go(arg0_39.code2Panel), arg0_39.screenHeight / 2, DecodeGameConst.SWITCH_TO_DECODE_TIME / 2):setOnComplete(System.Action(arg0_40))
		end,
		function(arg0_41)
			LeanTween.moveLocalY(go(arg0_39.engineBottom), -arg0_39.screenHeight / 2, DecodeGameConst.SWITCH_TO_DECODE_TIME / 2):setOnComplete(System.Action(arg0_41))
		end
	}, arg1_39)
end

function var0_0.OnEnterNormalMap(arg0_42, arg1_42, arg2_42)
	seriesAsync({
		function(arg0_43)
			LeanTween.moveLocalY(go(arg0_42.code1Panel), 303, DecodeGameConst.SWITCH_TO_DECODE_TIME / 2):setOnComplete(System.Action(arg0_43))
		end,
		function(arg0_44)
			setActive(arg0_42.passWordTF, false)
			arg0_44()
		end,
		function(arg0_45)
			arg0_42.mapItemContainer.sizeDelta = arg0_42.containerSize

			for iter0_45, iter1_45 in ipairs(arg1_42.passwordIndexs) do
				local var0_45 = arg0_42.mapItems[iter1_45]

				var0_45:Find("rect/icon"):GetComponent(typeof(CanvasGroup)).alpha = 1

				setActive(var0_45:Find("rays"), false)
			end

			arg0_45()
		end
	}, arg2_42)
end

function var0_0.OnDecodeMap(arg0_46, arg1_46, arg2_46)
	local var0_46 = {}

	local function var1_46(arg0_47)
		for iter0_47, iter1_47 in ipairs(arg1_46.items) do
			if iter1_47.index == arg0_47 then
				return iter1_47
			end
		end
	end

	for iter0_46, iter1_46 in ipairs(arg1_46.passwordIndexs) do
		local var2_46 = arg0_46.mapItems[iter1_46]
		local var3_46 = var2_46:Find("rect").sizeDelta
		local var4_46 = var2_46.localPosition
		local var5_46 = Vector2(var4_46.x + var3_46.x / 2, var4_46.y - var3_46.y / 2)
		local var6_46 = Vector2(var4_46.x - var3_46.x / 2, var4_46.y + var3_46.y / 2)

		var2_46:SetAsLastSibling()
		table.insert(var0_46, {
			target = var2_46,
			sizeDelta = var3_46,
			starPosition = var5_46,
			endPosition = var6_46,
			item = var1_46(iter1_46)
		})
	end

	local function var7_46()
		local var0_48 = Vector2(0, arg0_46.line1.localPosition.y)

		for iter0_48, iter1_48 in ipairs(var0_46) do
			local var1_48 = iter1_48.target
			local var2_48 = iter1_48.starPosition
			local var3_48 = iter1_48.endPosition
			local var4_48 = var1_48:Find("rect")
			local var5_48 = var4_48.sizeDelta

			if var0_48.y >= var2_48.y and var0_48.y <= var3_48.y then
				local var6_48 = var0_48.y - var2_48.y

				var4_48.sizeDelta = Vector2(var5_48.x, iter1_48.sizeDelta.y - var6_48)
			end
		end
	end

	setActive(arg0_46.line1, true)

	local var8_46 = DecodeGameConst.BLOCK_SIZE[1] * DecodeGameConst.MAP_ROW

	LeanTween.value(go(arg0_46.line1), 0, var8_46, DecodeGameConst.SCAN_GRID_TIME):setOnUpdate(System.Action_float(function(arg0_49)
		setAnchoredPosition(arg0_46.line1, {
			y = arg0_49
		})
		var7_46()
	end)):setOnComplete(System.Action(function()
		setActive(arg0_46.line1, false)

		for iter0_50, iter1_50 in ipairs(var0_46) do
			iter1_50.target:Find("rect/icon"):GetComponent(typeof(CanvasGroup)).alpha = 0
			iter1_50.target:Find("rect").sizeDelta = iter1_50.sizeDelta

			setActive(iter1_50.target:Find("rays"), true)
			setActive(iter1_50.target:Find("rays/blue"), iter1_50.item.isUsed)
		end

		arg2_46()
	end))
end

function var0_0.UpdatePassWord(arg0_51, arg1_51, arg2_51)
	if arg1_51 == false then
		return
	end

	local var0_51 = arg0_51.code2[arg2_51]

	var0_51:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/DecodeGameNumber_atlas", arg1_51 .. "-1")

	setActive(var0_51, true)
end

function var0_0.OnRightCode(arg0_52, arg1_52, arg2_52, arg3_52)
	arg0_52:UpdatePassWord(arg2_52, arg3_52)

	local var0_52 = arg0_52.mapItems[arg1_52]

	setActive(var0_52:Find("rays/blue"), true)
	setActive(arg0_52.lightRight, true)

	arg0_52.timer2 = Timer.New(function()
		setActive(arg0_52.lightRight, false)
	end, 1, 1)

	arg0_52.timer2:Start()
end

function var0_0.OnFalseCode(arg0_54, arg1_54)
	arg0_54:RemoveTimers()
	setActive(arg0_54.lightLeft, true)

	arg0_54.timer1 = Timer.New(function()
		setActive(arg0_54.lightLeft, false)
	end, 1, 1)

	arg0_54.timer1:Start()

	local var0_54 = arg0_54.mapItems[arg1_54]:Find("rays/yellow")

	setActive(var0_54, true)
	blinkAni(var0_54, 0.2, 2):setOnComplete(System.Action(function(...)
		setActive(var0_54, false)
	end))
end

function var0_0.RemoveTimers(arg0_57)
	if arg0_57.timer1 then
		arg0_57.timer1:Stop()

		arg0_57.timer1 = nil
	end

	if arg0_57.timer2 then
		arg0_57.timer2:Stop()

		arg0_57.timer2 = nil
	end
end

function var0_0.OnSuccess(arg0_58, arg1_58)
	local var0_58 = go(arg0_58.awardLock:Find("icon"))

	LeanTween.value(var0_58, 0, -140, DecodeGameConst.GET_AWARD_ANIM_TIME / 2):setOnUpdate(System.Action_float(function(arg0_59)
		tf(var0_58).eulerAngles = Vector3(0, 0, arg0_59)
	end)):setOnComplete(System.Action(function()
		LeanTween.moveLocalX(var0_58, 132, DecodeGameConst.GET_AWARD_ANIM_TIME / 2):setFrom(0):setOnComplete(System.Action(function()
			setActive(arg0_58.awardLock, false)
			setActive(arg0_58.awardGot, true)
			arg1_58()
		end))
	end))
end

function var0_0.ShowHelper(arg0_62, arg1_62, arg2_62)
	local var0_62 = getProxy(PlayerProxy):getRawData().id

	if PlayerPrefs.GetInt("DecodeGameHelpBg" .. var0_62 .. arg1_62, 0) > 0 then
		arg2_62()

		return
	end

	PlayerPrefs.SetInt("DecodeGameHelpBg" .. var0_62 .. arg1_62, 1)
	PlayerPrefs.Save()
	setActive(arg0_62.helperTF, true)

	local var1_62 = arg0_62.helperTF:Find("Image")
	local var2_62 = DecodeGameConst.HELP_BGS[arg1_62]
	local var3_62 = var2_62[1]
	local var4_62 = LoadSprite("helpbg/" .. var3_62, "")

	setImageSprite(var1_62, var4_62)

	var1_62.sizeDelta = Vector2(var2_62[2][1], var2_62[2][2])
	var1_62.localPosition = Vector3(var2_62[3][1], var2_62[3][2], 0)

	onButton(arg0_62, arg0_62.helperTF, function()
		setActive(arg0_62.helperTF, false)
		arg2_62()
	end, SFX_PANEL)
end

function var0_0.ShowTip(arg0_64, arg1_64)
	eachChild(arg0_64.tips, function(arg0_65)
		setActive(arg0_65, go(arg0_65).name == tostring(arg1_64))
	end)
end

function var0_0.PlayVoice(arg0_66, arg1_66)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_66)
end

function var0_0.OnSwitchMap(arg0_67, arg1_67)
	arg0_67:PlayerMapStartAnim(arg1_67)
end

function var0_0.PlayerMapStartAnim(arg0_68, arg1_68)
	setActive(arg0_68.decodeTV, true)
	table.insert(arg0_68.animCallbacks, arg1_68)
	arg0_68.anim:SetTrigger("trigger")
end

function var0_0.Dispose(arg0_69)
	pg.DelegateInfo.Dispose(arg0_69)

	arg0_69.mapItems = nil

	arg0_69:RemoveTimers()
	arg0_69.dftAniEvent:SetEndEvent(nil)

	arg0_69.animCallbacks = nil
end

return var0_0
