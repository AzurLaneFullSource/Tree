local var0 = {}

var0.clearSprites = true

function var0.Destroy(arg0, arg1)
	local var0 = UIUtil.IsGameObject(arg0)
	local var1 = var0 and UIUtil.IsPrefab(arg0)

	if var0 and var0.clearSprites and not arg1 then
		UIUtil.ClearTextureRef(arg0)
	end

	if var0 and not var1 then
		Object.Destroy(arg0)
	end
end

return var0
