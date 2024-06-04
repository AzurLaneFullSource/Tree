local var0 = class("SculpturePuzzlePage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "SculpturePuzzleUI"
end

function var0.OnLoaded(arg0)
	arg0.backBtn = arg0:findTF("back")
	arg0.lineTr = arg0:findTF("frame/line")
	arg0.frameTr = arg0:findTF("frame")
	arg0.tipBtn = arg0:findTF("frame/tip")
	arg0.tipGrayBtn = arg0:findTF("frame/tip_gray")
	arg0.tipGrayBtnTxt = arg0.tipGrayBtn:Find("Text"):GetComponent(typeof(Text))

	setActive(arg0.tipGrayBtn, false)
	setText(arg0:findTF("frame/tip_text"), i18n("sculpture_puzzle_tip"))
end

function var0.OnInit(arg0)
	arg0.slots = {}
end

function var0.Show(arg0, arg1, arg2, arg3)
	var0.super.Show(arg0)
	arg0:Clear()

	arg0.id = arg1
	arg0.activity = arg2

	if arg3 then
		arg3()
	end

	seriesAsync({
		function(arg0)
			arg0:LoadLine(arg0)
		end,
		function(arg0)
			arg0:LoadPuzzle(arg0)
		end
	}, function()
		arg0:RegisterEvent()
	end)
	pg.BgmMgr.GetInstance():Push(arg0.__cname, "bar-soft")
end

function var0.LoadLine(arg0, arg1)
	local var0 = arg0.activity:GetResorceName(arg0.id)

	ResourceMgr.Inst:getAssetAsync("ui/" .. var0 .. "_puzzle_line", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		local var0 = Object.Instantiate(arg0, arg0.lineTr)

		eachChild(var0, function(arg0)
			arg0.slots[arg0.gameObject.name] = {
				flag = false,
				tr = arg0
			}
		end)

		arg0.puzzleLine = var0

		arg1()
	end), true, true)
end

function Screen2Local(arg0, arg1)
	local var0 = GameObject.Find("UICamera"):GetComponent("Camera")
	local var1 = arg0:GetComponent("RectTransform")

	return (LuaHelper.ScreenToLocal(var1, arg1, var0))
end

function TrPosition2LocalPos(arg0, arg1, arg2)
	if arg0 == arg1 then
		return arg2
	else
		local var0 = arg0:TransformPoint(arg2)
		local var1 = arg1:InverseTransformPoint(var0)

		return Vector3(var1.x, var1.y, 0)
	end
end

function var0.HandlePuzzlePart(arg0, arg1)
	eachChild(arg1, function(arg0)
		local var0 = arg0:GetComponent(typeof(EventTriggerListener))
		local var1
		local var2

		var0:AddBeginDragFunc(function()
			var2 = arg0:GetSiblingIndex()

			arg0:SetAsLastSibling()

			var1 = arg0.localPosition
		end)
		var0:AddDragFunc(function(arg0, arg1)
			local var0 = Screen2Local(arg0.parent, arg1.position)

			arg0.localPosition = var0
		end)
		var0:AddDragEndFunc(function(arg0, arg1)
			local var0 = arg0.slots[arg0.gameObject.name].tr
			local var1 = TrPosition2LocalPos(var0.parent, arg0.parent, var0.localPosition)

			if Vector2.Distance(var1, arg0.localPosition) < 50 then
				arg0.slots[arg0.gameObject.name].flag = true
				arg0.localPosition = var1

				ClearEventTrigger(var0)
				Object.Destroy(var0)

				if arg0:IsFinishAll() then
					arg0:emit(SculptureMediator.ON_JOINT_SCULPTURE, arg0.id)
				end
			else
				arg0.localPosition = var1
			end

			arg0:SetSiblingIndex(var2)
		end)
	end)
end

function var0.IsFinishAll(arg0)
	for iter0, iter1 in pairs(arg0.slots) do
		if iter1.flag == false then
			return false
		end
	end

	return true
end

function var0.LoadPuzzle(arg0, arg1)
	local var0 = arg0.activity:GetResorceName(arg0.id)

	ResourceMgr.Inst:getAssetAsync("ui/" .. var0 .. "_puzzle", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		local var0 = Object.Instantiate(arg0, arg0.frameTr)

		arg0:HandlePuzzlePart(var0.transform)

		arg0.puzzle = var0

		arg1()
	end), true, true)
end

function var0.RegisterEvent(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0.contextData.miniMsgBox:ExecuteAction("Show", {
			showNo = true,
			content = i18n("sculpture_drawline_exit"),
			onYes = function()
				arg0:Hide()
			end
		})
	end, SFX_PANEL)

	local var0 = 0

	onButton(arg0, arg0.tipBtn, function()
		if arg0:IsFinishAll() or var0 > 0 then
			return
		end

		local var0 = {}

		for iter0, iter1 in pairs(arg0.slots) do
			if iter1.flag == false then
				table.insert(var0, iter1.tr)
			end
		end

		if #var0 == 0 then
			return
		end

		var0 = 10

		local var1 = math.random(1, #var0)

		arg0:BlinkSlots({
			var0[var1]
		})
		setActive(arg0.tipBtn, false)
		setActive(arg0.tipGrayBtn, true)
		arg0:AddTimer(function()
			var0 = 0

			setActive(arg0.tipBtn, true)
			setActive(arg0.tipGrayBtn, false)
		end)
	end, SFX_PANEL)
end

function var0.AddTimer(arg0, arg1)
	arg0:ClearTimer()

	local var0 = 11

	arg0.timer = Timer.New(function()
		var0 = var0 - 1
		arg0.tipGrayBtnTxt.text = var0 .. "s"

		if var0 <= 0 then
			arg1()
		end
	end, 1, 10)

	arg0.timer.func()
	arg0.timer:Start()
end

function var0.ClearTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.BlinkSlots(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		local var1 = iter1:GetComponent(typeof(Image))
		local var2 = var1.color

		table.insert(var0, function(arg0)
			LeanTween.value(iter1.gameObject, 0.5, 1, 0.3):setLoopPingPong(3):setOnUpdate(System.Action_float(function(arg0)
				var1.color = Color.New(var2.r, var2.g, var2.b, arg0)
			end)):setOnComplete(System.Action(function()
				var1.color = Color.New(var2.r, var2.g, var2.b, 0)

				arg0()
			end))
		end)
	end

	parallelAsync(var0, arg2)
end

function var0.Clear(arg0)
	if arg0.puzzleLine then
		Object.Destroy(arg0.puzzleLine.gameObject)

		arg0.puzzleLine = nil
	end

	if arg0.puzzle then
		Object.Destroy(arg0.puzzle.gameObject)

		arg0.puzzle = nil
	end

	arg0.slots = {}
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.BgmMgr.GetInstance():Pop(arg0.__cname)
end

function var0.OnDestroy(arg0)
	arg0:ClearTimer()

	for iter0, iter1 in pairs(arg0.slots) do
		if LeanTween.isTweening(iter1.tr.gameObject) then
			LeanTween.cancel(iter1.tr.gameObject)
		end
	end
end

return var0
