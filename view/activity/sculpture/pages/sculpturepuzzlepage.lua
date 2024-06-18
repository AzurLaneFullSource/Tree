local var0_0 = class("SculpturePuzzlePage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SculpturePuzzleUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("back")
	arg0_2.lineTr = arg0_2:findTF("frame/line")
	arg0_2.frameTr = arg0_2:findTF("frame")
	arg0_2.tipBtn = arg0_2:findTF("frame/tip")
	arg0_2.tipGrayBtn = arg0_2:findTF("frame/tip_gray")
	arg0_2.tipGrayBtnTxt = arg0_2.tipGrayBtn:Find("Text"):GetComponent(typeof(Text))

	setActive(arg0_2.tipGrayBtn, false)
	setText(arg0_2:findTF("frame/tip_text"), i18n("sculpture_puzzle_tip"))
end

function var0_0.OnInit(arg0_3)
	arg0_3.slots = {}
end

function var0_0.Show(arg0_4, arg1_4, arg2_4, arg3_4)
	var0_0.super.Show(arg0_4)
	arg0_4:Clear()

	arg0_4.id = arg1_4
	arg0_4.activity = arg2_4

	if arg3_4 then
		arg3_4()
	end

	seriesAsync({
		function(arg0_5)
			arg0_4:LoadLine(arg0_5)
		end,
		function(arg0_6)
			arg0_4:LoadPuzzle(arg0_6)
		end
	}, function()
		arg0_4:RegisterEvent()
	end)
	pg.BgmMgr.GetInstance():Push(arg0_4.__cname, "bar-soft")
end

function var0_0.LoadLine(arg0_8, arg1_8)
	local var0_8 = arg0_8.activity:GetResorceName(arg0_8.id)

	ResourceMgr.Inst:getAssetAsync("ui/" .. var0_8 .. "_puzzle_line", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_9)
		local var0_9 = Object.Instantiate(arg0_9, arg0_8.lineTr)

		eachChild(var0_9, function(arg0_10)
			arg0_8.slots[arg0_10.gameObject.name] = {
				flag = false,
				tr = arg0_10
			}
		end)

		arg0_8.puzzleLine = var0_9

		arg1_8()
	end), true, true)
end

function Screen2Local(arg0_11, arg1_11)
	local var0_11 = GameObject.Find("UICamera"):GetComponent("Camera")
	local var1_11 = arg0_11:GetComponent("RectTransform")

	return (LuaHelper.ScreenToLocal(var1_11, arg1_11, var0_11))
end

function TrPosition2LocalPos(arg0_12, arg1_12, arg2_12)
	if arg0_12 == arg1_12 then
		return arg2_12
	else
		local var0_12 = arg0_12:TransformPoint(arg2_12)
		local var1_12 = arg1_12:InverseTransformPoint(var0_12)

		return Vector3(var1_12.x, var1_12.y, 0)
	end
end

function var0_0.HandlePuzzlePart(arg0_13, arg1_13)
	eachChild(arg1_13, function(arg0_14)
		local var0_14 = arg0_14:GetComponent(typeof(EventTriggerListener))
		local var1_14
		local var2_14

		var0_14:AddBeginDragFunc(function()
			var2_14 = arg0_14:GetSiblingIndex()

			arg0_14:SetAsLastSibling()

			var1_14 = arg0_14.localPosition
		end)
		var0_14:AddDragFunc(function(arg0_16, arg1_16)
			local var0_16 = Screen2Local(arg0_14.parent, arg1_16.position)

			arg0_14.localPosition = var0_16
		end)
		var0_14:AddDragEndFunc(function(arg0_17, arg1_17)
			local var0_17 = arg0_13.slots[arg0_14.gameObject.name].tr
			local var1_17 = TrPosition2LocalPos(var0_17.parent, arg0_14.parent, var0_17.localPosition)

			if Vector2.Distance(var1_17, arg0_14.localPosition) < 50 then
				arg0_13.slots[arg0_14.gameObject.name].flag = true
				arg0_14.localPosition = var1_17

				ClearEventTrigger(var0_14)
				Object.Destroy(var0_14)

				if arg0_13:IsFinishAll() then
					arg0_13:emit(SculptureMediator.ON_JOINT_SCULPTURE, arg0_13.id)
				end
			else
				arg0_14.localPosition = var1_14
			end

			arg0_14:SetSiblingIndex(var2_14)
		end)
	end)
end

function var0_0.IsFinishAll(arg0_18)
	for iter0_18, iter1_18 in pairs(arg0_18.slots) do
		if iter1_18.flag == false then
			return false
		end
	end

	return true
end

function var0_0.LoadPuzzle(arg0_19, arg1_19)
	local var0_19 = arg0_19.activity:GetResorceName(arg0_19.id)

	ResourceMgr.Inst:getAssetAsync("ui/" .. var0_19 .. "_puzzle", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_20)
		local var0_20 = Object.Instantiate(arg0_20, arg0_19.frameTr)

		arg0_19:HandlePuzzlePart(var0_20.transform)

		arg0_19.puzzle = var0_20

		arg1_19()
	end), true, true)
end

function var0_0.RegisterEvent(arg0_21)
	onButton(arg0_21, arg0_21.backBtn, function()
		arg0_21.contextData.miniMsgBox:ExecuteAction("Show", {
			showNo = true,
			content = i18n("sculpture_drawline_exit"),
			onYes = function()
				arg0_21:Hide()
			end
		})
	end, SFX_PANEL)

	local var0_21 = 0

	onButton(arg0_21, arg0_21.tipBtn, function()
		if arg0_21:IsFinishAll() or var0_21 > 0 then
			return
		end

		local var0_24 = {}

		for iter0_24, iter1_24 in pairs(arg0_21.slots) do
			if iter1_24.flag == false then
				table.insert(var0_24, iter1_24.tr)
			end
		end

		if #var0_24 == 0 then
			return
		end

		var0_21 = 10

		local var1_24 = math.random(1, #var0_24)

		arg0_21:BlinkSlots({
			var0_24[var1_24]
		})
		setActive(arg0_21.tipBtn, false)
		setActive(arg0_21.tipGrayBtn, true)
		arg0_21:AddTimer(function()
			var0_21 = 0

			setActive(arg0_21.tipBtn, true)
			setActive(arg0_21.tipGrayBtn, false)
		end)
	end, SFX_PANEL)
end

function var0_0.AddTimer(arg0_26, arg1_26)
	arg0_26:ClearTimer()

	local var0_26 = 11

	arg0_26.timer = Timer.New(function()
		var0_26 = var0_26 - 1
		arg0_26.tipGrayBtnTxt.text = var0_26 .. "s"

		if var0_26 <= 0 then
			arg1_26()
		end
	end, 1, 10)

	arg0_26.timer.func()
	arg0_26.timer:Start()
end

function var0_0.ClearTimer(arg0_28)
	if arg0_28.timer then
		arg0_28.timer:Stop()

		arg0_28.timer = nil
	end
end

function var0_0.BlinkSlots(arg0_29, arg1_29, arg2_29)
	local var0_29 = {}

	for iter0_29, iter1_29 in ipairs(arg1_29) do
		local var1_29 = iter1_29:GetComponent(typeof(Image))
		local var2_29 = var1_29.color

		table.insert(var0_29, function(arg0_30)
			LeanTween.value(iter1_29.gameObject, 0.5, 1, 0.3):setLoopPingPong(3):setOnUpdate(System.Action_float(function(arg0_31)
				var1_29.color = Color.New(var2_29.r, var2_29.g, var2_29.b, arg0_31)
			end)):setOnComplete(System.Action(function()
				var1_29.color = Color.New(var2_29.r, var2_29.g, var2_29.b, 0)

				arg0_30()
			end))
		end)
	end

	parallelAsync(var0_29, arg2_29)
end

function var0_0.Clear(arg0_33)
	if arg0_33.puzzleLine then
		Object.Destroy(arg0_33.puzzleLine.gameObject)

		arg0_33.puzzleLine = nil
	end

	if arg0_33.puzzle then
		Object.Destroy(arg0_33.puzzle.gameObject)

		arg0_33.puzzle = nil
	end

	arg0_33.slots = {}
end

function var0_0.Hide(arg0_34)
	var0_0.super.Hide(arg0_34)
	pg.BgmMgr.GetInstance():Pop(arg0_34.__cname)
end

function var0_0.OnDestroy(arg0_35)
	arg0_35:ClearTimer()

	for iter0_35, iter1_35 in pairs(arg0_35.slots) do
		if LeanTween.isTweening(iter1_35.tr.gameObject) then
			LeanTween.cancel(iter1_35.tr.gameObject)
		end
	end
end

return var0_0
