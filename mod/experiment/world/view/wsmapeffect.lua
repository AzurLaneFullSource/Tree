local var0_0 = class("WSMapEffect", import(".WSMapTransform"))

var0_0.Fields = {
	resPath = "string",
	resName = "string"
}

function var0_0.Dispose(arg0_1)
	arg0_1:Unload()
	var0_0.super.Dispose(arg0_1)
end

function var0_0.Setup(arg0_2, arg1_2, arg2_2)
	arg0_2.resPath = arg1_2
	arg0_2.resName = arg2_2
end

function var0_0.Load(arg0_3, arg1_3)
	arg0_3:LoadModel(WorldConst.ModelPrefab, arg0_3.resPath, arg0_3.resName, true, function()
		setParent(arg0_3.model, arg0_3.transform, false)

		return existCall(arg1_3)
	end)
end

function var0_0.Unload(arg0_5)
	arg0_5:UnloadModel()
end

return var0_0
