local var0_0 = class("WSMapObject", import("...BaseEntity"))

var0_0.Fields = {
	modelType = "number",
	modelAction = "string",
	modelResPath = "string",
	modelParent = "userdata",
	modelAngles = "table",
	modelActionTimer = "table",
	modelScale = "table",
	model = "userdata",
	modelComps = "table",
	modelResAsync = "boolean",
	modelResName = "string"
}

function var0_0.GetModelAngles(arg0_1)
	return arg0_1.modelAngles and arg0_1.modelAngles:Clone() or Vector3.zero
end

function var0_0.UpdateModelAngles(arg0_2, arg1_2)
	if arg0_2.modelAngles ~= arg1_2 then
		arg0_2.modelAngles = arg1_2

		arg0_2:FlushModelAngles()
	end
end

function var0_0.FlushModelAngles(arg0_3)
	if arg0_3.model and arg0_3.modelAngles then
		arg0_3.model.localEulerAngles = arg0_3.modelAngles
	end
end

function var0_0.GetModelScale(arg0_4)
	return arg0_4.modelScale and arg0_4.modelScale:Clone() or Vector3.one
end

function var0_0.UpdateModelScale(arg0_5, arg1_5)
	if arg0_5.modelScale ~= arg1_5 then
		arg0_5.modelScale = arg1_5

		arg0_5:FlushModelScale()
	end
end

function var0_0.GetModelAction(arg0_6)
	return arg0_6.modelAction
end

function var0_0.FlushModelScale(arg0_7)
	if arg0_7.model and arg0_7.modelScale then
		arg0_7.model.localScale = arg0_7.modelScale
	end
end

function var0_0.UpdateModelAction(arg0_8, arg1_8)
	if arg0_8.modelAction ~= arg1_8 then
		arg0_8.modelAction = arg1_8

		arg0_8:FlushModelAction()
	end
end

function var0_0.FlushModelAction(arg0_9)
	if arg0_9.model and arg0_9.modelAction then
		if arg0_9.modelType == WorldConst.ModelSpine then
			local var0_9 = arg0_9.modelComps and arg0_9.modelComps[1]

			if var0_9 then
				var0_9:SetAction(arg0_9.modelAction, 0)
			end
		elseif arg0_9.modelType == WorldConst.ModelPrefab then
			local var1_9 = arg0_9.modelComps and arg0_9.modelComps[1]

			if var1_9 then
				local var2_9 = Animator.StringToHash(arg0_9.modelAction)

				if var1_9:HasState(0, var2_9) then
					var1_9:Play(var2_9)
				end
			end
		end
	end
end

function var0_0.PlayModelAction(arg0_10, arg1_10, arg2_10, arg3_10)
	assert(arg1_10)

	local var0_10 = {}

	if arg0_10.model then
		if arg0_10.modelType == WorldConst.ModelSpine then
			local var1_10 = arg0_10.modelComps and arg0_10.modelComps[1]

			if var1_10 and var1_10.transform.gameObject.activeInHierarchy then
				table.insert(var0_10, function(arg0_11)
					var1_10:SetAction(arg1_10, 0)

					if arg2_10 then
						arg0_10:NewActionTimer(arg2_10, arg0_11)
					else
						var1_10:SetActionCallBack(function(arg0_12)
							if arg0_12 == "finish" then
								var1_10:SetActionCallBack(nil)
								arg0_11()
							end
						end)
					end
				end)
			end
		elseif arg0_10.modelType == WorldConst.ModelPrefab then
			local var2_10 = arg0_10.modelComps and arg0_10.modelComps[1]

			if var2_10 and var2_10.transform.gameObject.activeInHierarchy then
				local var3_10 = Animator.StringToHash(arg1_10)

				if var2_10:HasState(0, var3_10) then
					table.insert(var0_10, function(arg0_13)
						var2_10:Play(var3_10)

						if arg2_10 then
							arg0_10:NewActionTimer(arg2_10, arg0_13)
						else
							local var0_13 = arg0_10.modelComps[2]

							var0_13:SetEndEvent(function()
								var0_13:SetEndEvent(nil)
								arg0_13()
							end)
						end
					end)
				end
			end
		end
	end

	seriesAsync(var0_10, arg3_10)
end

function var0_0.LoadModel(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15, arg5_15)
	if arg0_15.modelType ~= arg1_15 or arg0_15.modelResPath ~= arg2_15 or arg0_15.modelResName ~= arg3_15 then
		arg0_15:UnloadModel()

		arg0_15.model = createNewGameObject("model")
		arg0_15.modelType = arg1_15
		arg0_15.modelResPath = arg2_15
		arg0_15.modelResName = arg3_15
		arg0_15.modelResAsync = defaultValue(arg4_15, true)

		local var0_15 = {}

		if arg0_15.modelType == WorldConst.ModelSpine then
			arg0_15.modelAction = arg0_15.modelAction or WorldConst.ActionIdle

			table.insert(var0_15, function(arg0_16)
				arg0_15:LoadSpine(arg0_16)
			end)
		elseif arg0_15.modelType == WorldConst.ModelPrefab then
			arg0_15.modelAction = arg0_15.modelAction or "idle"

			table.insert(var0_15, function(arg0_17)
				arg0_15:LoadPrefab(arg0_17)
			end)
		else
			assert("invalid model type: " .. arg1_15)
		end

		seriesAsync(var0_15, function()
			if arg0_15.modelScale == nil then
				arg0_15.modelScale = arg0_15.model.localScale
			else
				arg0_15:FlushModelScale()
			end

			if arg0_15.modelAngles == nil then
				arg0_15.modelAngles = arg0_15.model.localEulerAngles
			else
				arg0_15:FlushModelAngles()
			end

			arg0_15:FlushModelAction()

			if arg5_15 then
				arg5_15()
			end
		end)
	end
end

function var0_0.UnloadModel(arg0_19)
	arg0_19:DisposeActionTimer()

	if arg0_19.model then
		if arg0_19.model.childCount > 0 then
			if arg0_19.modelType == WorldConst.ModelSpine then
				arg0_19:UnloadSpine()
			elseif arg0_19.modelType == WorldConst.ModelPrefab then
				arg0_19:UnloadPrefab()
			end
		end

		Destroy(arg0_19.model)
	end

	arg0_19.model = nil
	arg0_19.modelComps = nil
	arg0_19.modelType = nil
	arg0_19.modelResPath = nil
	arg0_19.modelResName = nil
	arg0_19.modelResAsync = nil
end

function var0_0.LoadSpine(arg0_20, arg1_20)
	local var0_20 = arg0_20.modelResPath
	local var1_20 = arg0_20.modelResAsync

	PoolMgr.GetInstance():GetSpineChar(var0_20, var1_20, function(arg0_21)
		if arg0_20.modelType ~= WorldConst.ModelSpine or arg0_20.modelResPath ~= var0_20 then
			PoolMgr.GetInstance():ReturnSpineChar(var0_20, arg0_21)

			return
		end

		local var0_21 = arg0_21.transform

		var0_21:GetComponent("SkeletonGraphic").raycastTarget = false
		var0_21.anchoredPosition3D = Vector3.zero
		var0_21.localScale = Vector3.one

		pg.ViewUtils.SetLayer(var0_21, Layer.UI)
		var0_21:SetParent(arg0_20.model, false)

		arg0_20.modelComps = {
			var0_21:GetComponent("SpineAnimUI")
		}

		arg1_20()
	end)
end

function var0_0.LoadPrefab(arg0_22, arg1_22)
	local var0_22 = arg0_22.modelResPath
	local var1_22 = arg0_22.modelResName
	local var2_22 = arg0_22.modelResAsync

	PoolMgr.GetInstance():GetPrefab(var0_22, var1_22, var2_22, function(arg0_23)
		if arg0_22.modelType ~= WorldConst.ModelPrefab or arg0_22.modelResPath ~= var0_22 or arg0_22.modelResName ~= var1_22 then
			PoolMgr.GetInstance():ReturnPrefab(var0_22, var1_22, arg0_23, true)

			return
		end

		local var0_23 = arg0_23:GetComponentsInChildren(typeof(Image))

		for iter0_23 = 0, var0_23.Length - 1 do
			var0_23[iter0_23].raycastTarget = false
		end

		arg0_23.transform:SetParent(arg0_22.model, false)

		arg0_22.modelComps = {}

		local var1_23 = arg0_23:GetComponentInChildren(typeof(Animator))

		if var1_23 then
			local var2_23 = var1_23:GetComponent("DftAniEvent")

			arg0_22.modelComps = {
				var1_23,
				var2_23
			}
		end

		arg1_22()
	end)
end

function var0_0.UnloadSpine(arg0_24)
	arg0_24.modelComps[1]:SetActionCallBack(nil)
	PoolMgr.GetInstance():ReturnSpineChar(arg0_24.modelResPath, arg0_24.model:GetChild(0).gameObject)
end

function var0_0.UnloadPrefab(arg0_25)
	local var0_25 = arg0_25.modelComps[2]

	if var0_25 then
		var0_25:SetEndEvent(nil)
	end

	PoolMgr.GetInstance():ReturnPrefab(arg0_25.modelResPath, arg0_25.modelResName, arg0_25.model:GetChild(0).gameObject, true)
end

function var0_0.NewActionTimer(arg0_26, arg1_26, arg2_26)
	arg0_26:DisposeActionTimer()

	arg0_26.modelActionTimer = Timer.New(arg2_26, arg1_26, 1)

	arg0_26.modelActionTimer:Start()
end

function var0_0.DisposeActionTimer(arg0_27)
	if arg0_27.modelActionTimer then
		arg0_27.modelActionTimer:Stop()

		arg0_27.modelActionTimer = nil
	end
end

return var0_0
