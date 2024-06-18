local var0_0 = class("GuideShowSignPlayer", import(".GuidePlayer"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.signTrs = {}
end

function var0_0.OnExecution(arg0_2, arg1_2, arg2_2)
	seriesAsync({
		function(arg0_3)
			arg0_2:loadSigns(arg1_2, arg0_3)
		end,
		function(arg0_4)
			arg0_2:InitSign(arg1_2, arg0_4)
		end
	}, arg2_2)
end

function var0_0.loadSigns(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg1_5:GetSignList()
	local var1_5 = {}

	for iter0_5, iter1_5 in ipairs(var0_5) do
		table.insert(var1_5, function(arg0_6)
			arg0_5:LoadSignRes(iter1_5, function(arg0_7)
				table.insert(arg0_5.signTrs, arg0_7)
				arg0_6()
			end)
		end)
	end

	parallelAsync(var1_5, arg2_5)
end

function var0_0.LoadSignRes(arg0_8, arg1_8, arg2_8)
	arg0_8.uiLoader:Load(arg1_8.signName, function(arg0_9)
		if arg1_8.atlasName and arg1_8.fileName then
			local var0_9 = LoadSprite(arg1_8.atlasName, arg1_8.fileName)

			setImageSprite(findTF(arg0_9, "shadow"), var0_9, true)
		end

		arg0_9.localPosition = arg1_8.pos
		arg0_9.eulerAngles = Vector3(0, 0, 0)
		arg0_9.localScale = Vector3.one

		setActive(arg0_9, true)

		if arg2_8 then
			arg2_8(arg0_9)
		end
	end)
end

function var0_0.InitSign(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg1_10:GetSignType()

	if var0_10 == GuideShowSignStep.SIGN_TYPE_2 then
		arg0_10:UpdateSign2(arg1_10, arg2_10)
	elseif var0_10 == GuideShowSignStep.SIGN_TYPE_3 then
		arg0_10:UpdateSign3(arg1_10, arg2_10)
	else
		arg0_10:UpdateCommonSign(arg1_10, arg2_10)
	end
end

function var0_0.UpdateSign2(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.signTrs[1]
	local var1_11 = findTF(var0_11, "btn")

	if arg1_11:ShouldClick() then
		setActive(var0_11, false)

		local var2_11 = arg1_11:GetClickData()

		arg0_11:SearchUI(var2_11, function(arg0_12)
			if IsNil(arg0_12) then
				pg.NewGuideMgr.GetInstance():Stop()

				return
			end

			local var0_12 = Vector3(arg0_12.sizeDelta.x * (arg0_12.pivot.x - 0.5), arg0_12.sizeDelta.y * (arg0_12.pivot.y - 0.5), 0)
			local var1_12 = var0_11.parent:InverseTransformPoint(arg0_12.position)

			var0_11.localPosition = var1_12 - var0_12
			var1_11.sizeDelta = arg0_12.sizeDelta + var2_11.sizeDeltaPlus

			setActive(var0_11, true)
		end)
	elseif arg1_11:ExistClickArea() then
		var1_11.sizeDelta = arg1_11:GetClickArea()
	end

	local var3_11 = GetOrAddComponent(var1_11, typeof(UILongPressTrigger))

	var3_11.onLongPressed:RemoveAllListeners()
	var3_11.onReleased:RemoveAllListeners()

	if arg1_11:GetTriggerType() == 1 then
		var3_11.onLongPressed:AddListener(arg2_11)
	else
		var3_11.onReleased:AddListener(arg2_11)
	end
end

function var0_0.UpdateSign3(arg0_13, arg1_13, arg2_13)
	arg0_13.signTrs[1].sizeDelta = arg1_13:GetClickArea()

	arg2_13()
end

function var0_0.UpdateCommonSign(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg1_14:GetExitDelay()

	if var0_14 <= 0 then
		arg2_14()
	else
		Timer.New(arg2_14, var0_14, 1):Start()
	end
end

function var0_0.OnClear(arg0_15)
	arg0_15.signTrs = {}
end

return var0_0
