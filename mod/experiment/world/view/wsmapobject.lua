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
			local var1_10 = arg0_10.modelComps[1]

			if var1_10 and isa(var1_10, SpineAnimChar) and var1_10:GetModel().transform.gameObject.activeInHierarchy then
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
			elseif var1_10 and isa(var1_10, SpineRole) and var1_10:GetRootModel().transform.gameObject.activeInHierarchy then
				table.insert(var0_10, function(arg0_13)
					var1_10:SetAction(arg1_10, 0)

					if arg2_10 then
						arg0_10:NewActionTimer(arg2_10, arg0_13)
					else
						var1_10:SetActionCallBack(function(arg0_14)
							if arg0_14 == "finish" then
								var1_10:SetActionCallBack(nil)
								arg0_13()
							end
						end)
					end
				end)
			elseif var1_10 and var1_10.transform.gameObject.activeInHierarchy then
				table.insert(var0_10, function(arg0_15)
					var1_10:SetAction(arg1_10, 0)

					if arg2_10 then
						arg0_10:NewActionTimer(arg2_10, arg0_15)
					else
						var1_10:SetActionCallBack(function(arg0_16)
							if arg0_16 == "finish" then
								var1_10:SetActionCallBack(nil)
								arg0_15()
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
					table.insert(var0_10, function(arg0_17)
						var2_10:Play(var3_10)

						if arg2_10 then
							arg0_10:NewActionTimer(arg2_10, arg0_17)
						else
							local var0_17 = arg0_10.modelComps[2]

							var0_17:SetEndEvent(function()
								var0_17:SetEndEvent(nil)
								arg0_17()
							end)
						end
					end)
				end
			end
		end
	end

	seriesAsync(var0_10, arg3_10)
end

function var0_0.LoadModel(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19, arg5_19)
	if arg0_19.modelType ~= arg1_19 or arg0_19.modelResPath ~= arg2_19 or arg0_19.modelResName ~= arg3_19 then
		arg0_19:UnloadModel()

		arg0_19.model = createNewGameObject("model")
		arg0_19.modelType = arg1_19
		arg0_19.modelResPath = arg2_19
		arg0_19.modelResName = arg3_19
		arg0_19.modelResAsync = defaultValue(arg4_19, true)

		local var0_19 = {}

		if arg0_19.modelType == WorldConst.ModelSpine then
			arg0_19.modelAction = arg0_19.modelAction or WorldConst.ActionIdle

			table.insert(var0_19, function(arg0_20)
				arg0_19:LoadSpine(arg0_20)
			end)
		elseif arg0_19.modelType == WorldConst.ModelPrefab then
			arg0_19.modelAction = arg0_19.modelAction or "idle"

			table.insert(var0_19, function(arg0_21)
				arg0_19:LoadPrefab(arg0_21)
			end)
		else
			assert("invalid model type: " .. arg1_19)
		end

		seriesAsync(var0_19, function()
			if arg0_19.modelScale == nil then
				arg0_19.modelScale = arg0_19.model.localScale
			else
				arg0_19:FlushModelScale()
			end

			if arg0_19.modelAngles == nil then
				arg0_19.modelAngles = arg0_19.model.localEulerAngles
			else
				arg0_19:FlushModelAngles()
			end

			arg0_19:FlushModelAction()

			if arg5_19 then
				arg5_19()
			end
		end)
	end
end

function var0_0.UnloadModel(arg0_23)
	arg0_23:DisposeActionTimer()

	if arg0_23.model then
		if arg0_23.model.childCount > 0 then
			if arg0_23.modelType == WorldConst.ModelSpine then
				arg0_23:UnloadSpine()
			elseif arg0_23.modelType == WorldConst.ModelPrefab then
				arg0_23:UnloadPrefab()
			end
		end

		Destroy(arg0_23.model)
	end

	arg0_23.model = nil
	arg0_23.modelComps = nil
	arg0_23.modelType = nil
	arg0_23.modelResPath = nil
	arg0_23.modelResName = nil
	arg0_23.modelResAsync = nil
end

function var0_0.LoadSpine(arg0_24, arg1_24)
	local var0_24 = arg0_24.modelResPath
	local var1_24 = arg0_24.modelResAsync
	local var2_24 = SpineAnimChar.New()

	var2_24:SetPaint(var0_24)
	var2_24:Load(var1_24, function(arg0_25)
		if arg0_24.modelType ~= WorldConst.ModelSpine or arg0_24.modelResPath ~= var0_24 then
			arg0_25:Dispose()

			var2_24 = nil

			return
		end

		arg0_25:GetSkeletonGraphic().raycastTarget = false

		arg0_25:SetAnchoredPosition3D(Vector3.zero)
		arg0_25:SetLocalScale(Vector3.one)
		arg0_25:SetLayer(Layer.UI)
		arg0_25:SetParent(arg0_24.model)

		arg0_24.modelComps = {
			arg0_25
		}

		arg1_24()
	end)
end

function var0_0.LoadPrefab(arg0_26, arg1_26)
	local var0_26 = arg0_26.modelResPath
	local var1_26 = arg0_26.modelResName
	local var2_26 = arg0_26.modelResAsync

	PoolMgr.GetInstance():GetPrefab(var0_26, var1_26, var2_26, function(arg0_27)
		if arg0_26.modelType ~= WorldConst.ModelPrefab or arg0_26.modelResPath ~= var0_26 or arg0_26.modelResName ~= var1_26 then
			PoolMgr.GetInstance():ReturnPrefab(var0_26, var1_26, arg0_27, true)

			return
		end

		local var0_27 = arg0_27:GetComponentsInChildren(typeof(Image)):ToTable()

		for iter0_27, iter1_27 in ipairs(var0_27) do
			iter1_27.raycastTarget = false
		end

		arg0_27.transform:SetParent(arg0_26.model, false)

		arg0_26.modelComps = {}

		local var1_27 = arg0_27:GetComponentInChildren(typeof(Animator))

		if var1_27 then
			local var2_27 = var1_27:GetComponent("DftAniEvent")

			arg0_26.modelComps = {
				var1_27,
				var2_27
			}
		end

		arg1_26()
	end)
end

function var0_0.UnloadSpine(arg0_28)
	local var0_28 = arg0_28.modelComps[1]

	if var0_28 and isa(var0_28, SpineAnimChar) then
		var0_28:SetActionCallBack(nil)
		var0_28:Dispose()
	end
end

function var0_0.UnloadPrefab(arg0_29)
	local var0_29 = arg0_29.modelComps[2]

	if var0_29 then
		var0_29:SetEndEvent(nil)
	end

	PoolMgr.GetInstance():ReturnPrefab(arg0_29.modelResPath, arg0_29.modelResName, arg0_29.model:GetChild(0).gameObject, true)
end

function var0_0.NewActionTimer(arg0_30, arg1_30, arg2_30)
	arg0_30:DisposeActionTimer()

	arg0_30.modelActionTimer = Timer.New(arg2_30, arg1_30, 1)

	arg0_30.modelActionTimer:Start()
end

function var0_0.DisposeActionTimer(arg0_31)
	if arg0_31.modelActionTimer then
		arg0_31.modelActionTimer:Stop()

		arg0_31.modelActionTimer = nil
	end
end

return var0_0
