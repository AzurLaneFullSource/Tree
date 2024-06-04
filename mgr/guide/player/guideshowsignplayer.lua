local var0 = class("GuideShowSignPlayer", import(".GuidePlayer"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.signTrs = {}
end

function var0.OnExecution(arg0, arg1, arg2)
	seriesAsync({
		function(arg0)
			arg0:loadSigns(arg1, arg0)
		end,
		function(arg0)
			arg0:InitSign(arg1, arg0)
		end
	}, arg2)
end

function var0.loadSigns(arg0, arg1, arg2)
	local var0 = arg1:GetSignList()
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(var1, function(arg0)
			arg0:LoadSignRes(iter1, function(arg0)
				table.insert(arg0.signTrs, arg0)
				arg0()
			end)
		end)
	end

	parallelAsync(var1, arg2)
end

function var0.LoadSignRes(arg0, arg1, arg2)
	arg0.uiLoader:Load(arg1.signName, function(arg0)
		if arg1.atlasName and arg1.fileName then
			local var0 = LoadSprite(arg1.atlasName, arg1.fileName)

			setImageSprite(findTF(arg0, "shadow"), var0, true)
		end

		arg0.localPosition = arg1.pos
		arg0.eulerAngles = Vector3(0, 0, 0)
		arg0.localScale = Vector3.one

		setActive(arg0, true)

		if arg2 then
			arg2(arg0)
		end
	end)
end

function var0.InitSign(arg0, arg1, arg2)
	local var0 = arg1:GetSignType()

	if var0 == GuideShowSignStep.SIGN_TYPE_2 then
		arg0:UpdateSign2(arg1, arg2)
	elseif var0 == GuideShowSignStep.SIGN_TYPE_3 then
		arg0:UpdateSign3(arg1, arg2)
	else
		arg0:UpdateCommonSign(arg1, arg2)
	end
end

function var0.UpdateSign2(arg0, arg1, arg2)
	local var0 = arg0.signTrs[1]
	local var1 = findTF(var0, "btn")

	if arg1:ShouldClick() then
		setActive(var0, false)

		local var2 = arg1:GetClickData()

		arg0:SearchUI(var2, function(arg0)
			if IsNil(arg0) then
				pg.NewGuideMgr.GetInstance():Stop()

				return
			end

			local var0 = Vector3(arg0.sizeDelta.x * (arg0.pivot.x - 0.5), arg0.sizeDelta.y * (arg0.pivot.y - 0.5), 0)
			local var1 = var0.parent:InverseTransformPoint(arg0.position)

			var0.localPosition = var1 - var0
			var1.sizeDelta = arg0.sizeDelta + var2.sizeDeltaPlus

			setActive(var0, true)
		end)
	elseif arg1:ExistClickArea() then
		var1.sizeDelta = arg1:GetClickArea()
	end

	local var3 = GetOrAddComponent(var1, typeof(UILongPressTrigger))

	var3.onLongPressed:RemoveAllListeners()
	var3.onReleased:RemoveAllListeners()

	if arg1:GetTriggerType() == 1 then
		var3.onLongPressed:AddListener(arg2)
	else
		var3.onReleased:AddListener(arg2)
	end
end

function var0.UpdateSign3(arg0, arg1, arg2)
	arg0.signTrs[1].sizeDelta = arg1:GetClickArea()

	arg2()
end

function var0.UpdateCommonSign(arg0, arg1, arg2)
	local var0 = arg1:GetExitDelay()

	if var0 <= 0 then
		arg2()
	else
		Timer.New(arg2, var0, 1):Start()
	end
end

function var0.OnClear(arg0)
	arg0.signTrs = {}
end

return var0
