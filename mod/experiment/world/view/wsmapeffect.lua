local var0 = class("WSMapEffect", import(".WSMapTransform"))

var0.Fields = {
	resPath = "string",
	resName = "string"
}

function var0.Dispose(arg0)
	arg0:Unload()
	var0.super.Dispose(arg0)
end

function var0.Setup(arg0, arg1, arg2)
	arg0.resPath = arg1
	arg0.resName = arg2
end

function var0.Load(arg0, arg1)
	arg0:LoadModel(WorldConst.ModelPrefab, arg0.resPath, arg0.resName, true, function()
		setParent(arg0.model, arg0.transform, false)

		return existCall(arg1)
	end)
end

function var0.Unload(arg0)
	arg0:UnloadModel()
end

return var0
