local var0 = class("WSMapObject", import("...BaseEntity"))

var0.Fields = {
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

function var0.GetModelAngles(arg0)
	return arg0.modelAngles and arg0.modelAngles:Clone() or Vector3.zero
end

function var0.UpdateModelAngles(arg0, arg1)
	if arg0.modelAngles ~= arg1 then
		arg0.modelAngles = arg1

		arg0:FlushModelAngles()
	end
end

function var0.FlushModelAngles(arg0)
	if arg0.model and arg0.modelAngles then
		arg0.model.localEulerAngles = arg0.modelAngles
	end
end

function var0.GetModelScale(arg0)
	return arg0.modelScale and arg0.modelScale:Clone() or Vector3.one
end

function var0.UpdateModelScale(arg0, arg1)
	if arg0.modelScale ~= arg1 then
		arg0.modelScale = arg1

		arg0:FlushModelScale()
	end
end

function var0.GetModelAction(arg0)
	return arg0.modelAction
end

function var0.FlushModelScale(arg0)
	if arg0.model and arg0.modelScale then
		arg0.model.localScale = arg0.modelScale
	end
end

function var0.UpdateModelAction(arg0, arg1)
	if arg0.modelAction ~= arg1 then
		arg0.modelAction = arg1

		arg0:FlushModelAction()
	end
end

function var0.FlushModelAction(arg0)
	if arg0.model and arg0.modelAction then
		if arg0.modelType == WorldConst.ModelSpine then
			local var0 = arg0.modelComps and arg0.modelComps[1]

			if var0 then
				var0:SetAction(arg0.modelAction, 0)
			end
		elseif arg0.modelType == WorldConst.ModelPrefab then
			local var1 = arg0.modelComps and arg0.modelComps[1]

			if var1 then
				local var2 = Animator.StringToHash(arg0.modelAction)

				if var1:HasState(0, var2) then
					var1:Play(var2)
				end
			end
		end
	end
end

function var0.PlayModelAction(arg0, arg1, arg2, arg3)
	assert(arg1)

	local var0 = {}

	if arg0.model then
		if arg0.modelType == WorldConst.ModelSpine then
			local var1 = arg0.modelComps and arg0.modelComps[1]

			if var1 and var1.transform.gameObject.activeInHierarchy then
				table.insert(var0, function(arg0)
					var1:SetAction(arg1, 0)

					if arg2 then
						arg0:NewActionTimer(arg2, arg0)
					else
						var1:SetActionCallBack(function(arg0)
							if arg0 == "finish" then
								var1:SetActionCallBack(nil)
								arg0()
							end
						end)
					end
				end)
			end
		elseif arg0.modelType == WorldConst.ModelPrefab then
			local var2 = arg0.modelComps and arg0.modelComps[1]

			if var2 and var2.transform.gameObject.activeInHierarchy then
				local var3 = Animator.StringToHash(arg1)

				if var2:HasState(0, var3) then
					table.insert(var0, function(arg0)
						var2:Play(var3)

						if arg2 then
							arg0:NewActionTimer(arg2, arg0)
						else
							local var0 = arg0.modelComps[2]

							var0:SetEndEvent(function()
								var0:SetEndEvent(nil)
								arg0()
							end)
						end
					end)
				end
			end
		end
	end

	seriesAsync(var0, arg3)
end

function var0.LoadModel(arg0, arg1, arg2, arg3, arg4, arg5)
	if arg0.modelType ~= arg1 or arg0.modelResPath ~= arg2 or arg0.modelResName ~= arg3 then
		arg0:UnloadModel()

		arg0.model = createNewGameObject("model")
		arg0.modelType = arg1
		arg0.modelResPath = arg2
		arg0.modelResName = arg3
		arg0.modelResAsync = defaultValue(arg4, true)

		local var0 = {}

		if arg0.modelType == WorldConst.ModelSpine then
			arg0.modelAction = arg0.modelAction or WorldConst.ActionIdle

			table.insert(var0, function(arg0)
				arg0:LoadSpine(arg0)
			end)
		elseif arg0.modelType == WorldConst.ModelPrefab then
			arg0.modelAction = arg0.modelAction or "idle"

			table.insert(var0, function(arg0)
				arg0:LoadPrefab(arg0)
			end)
		else
			assert("invalid model type: " .. arg1)
		end

		seriesAsync(var0, function()
			if arg0.modelScale == nil then
				arg0.modelScale = arg0.model.localScale
			else
				arg0:FlushModelScale()
			end

			if arg0.modelAngles == nil then
				arg0.modelAngles = arg0.model.localEulerAngles
			else
				arg0:FlushModelAngles()
			end

			arg0:FlushModelAction()

			if arg5 then
				arg5()
			end
		end)
	end
end

function var0.UnloadModel(arg0)
	arg0:DisposeActionTimer()

	if arg0.model then
		if arg0.model.childCount > 0 then
			if arg0.modelType == WorldConst.ModelSpine then
				arg0:UnloadSpine()
			elseif arg0.modelType == WorldConst.ModelPrefab then
				arg0:UnloadPrefab()
			end
		end

		Destroy(arg0.model)
	end

	arg0.model = nil
	arg0.modelComps = nil
	arg0.modelType = nil
	arg0.modelResPath = nil
	arg0.modelResName = nil
	arg0.modelResAsync = nil
end

function var0.LoadSpine(arg0, arg1)
	local var0 = arg0.modelResPath
	local var1 = arg0.modelResAsync

	PoolMgr.GetInstance():GetSpineChar(var0, var1, function(arg0)
		if arg0.modelType ~= WorldConst.ModelSpine or arg0.modelResPath ~= var0 then
			PoolMgr.GetInstance():ReturnSpineChar(var0, arg0)

			return
		end

		local var0 = arg0.transform

		var0:GetComponent("SkeletonGraphic").raycastTarget = false
		var0.anchoredPosition3D = Vector3.zero
		var0.localScale = Vector3.one

		pg.ViewUtils.SetLayer(var0, Layer.UI)
		var0:SetParent(arg0.model, false)

		arg0.modelComps = {
			var0:GetComponent("SpineAnimUI")
		}

		arg1()
	end)
end

function var0.LoadPrefab(arg0, arg1)
	local var0 = arg0.modelResPath
	local var1 = arg0.modelResName
	local var2 = arg0.modelResAsync

	PoolMgr.GetInstance():GetPrefab(var0, var1, var2, function(arg0)
		if arg0.modelType ~= WorldConst.ModelPrefab or arg0.modelResPath ~= var0 or arg0.modelResName ~= var1 then
			PoolMgr.GetInstance():ReturnPrefab(var0, var1, arg0, true)

			return
		end

		local var0 = arg0:GetComponentsInChildren(typeof(Image))

		for iter0 = 0, var0.Length - 1 do
			var0[iter0].raycastTarget = false
		end

		arg0.transform:SetParent(arg0.model, false)

		arg0.modelComps = {}

		local var1 = arg0:GetComponentInChildren(typeof(Animator))

		if var1 then
			local var2 = var1:GetComponent("DftAniEvent")

			arg0.modelComps = {
				var1,
				var2
			}
		end

		arg1()
	end)
end

function var0.UnloadSpine(arg0)
	arg0.modelComps[1]:SetActionCallBack(nil)
	PoolMgr.GetInstance():ReturnSpineChar(arg0.modelResPath, arg0.model:GetChild(0).gameObject)
end

function var0.UnloadPrefab(arg0)
	local var0 = arg0.modelComps[2]

	if var0 then
		var0:SetEndEvent(nil)
	end

	PoolMgr.GetInstance():ReturnPrefab(arg0.modelResPath, arg0.modelResName, arg0.model:GetChild(0).gameObject, true)
end

function var0.NewActionTimer(arg0, arg1, arg2)
	arg0:DisposeActionTimer()

	arg0.modelActionTimer = Timer.New(arg2, arg1, 1)

	arg0.modelActionTimer:Start()
end

function var0.DisposeActionTimer(arg0)
	if arg0.modelActionTimer then
		arg0.modelActionTimer:Stop()

		arg0.modelActionTimer = nil
	end
end

return var0
