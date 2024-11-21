local var0_0 = {}

var0_0.clearSprites = true

function var0_0.Destroy(arg0_1)
	local var0_1 = UIUtil.IsGameObject(arg0_1)
	local var1_1 = var0_1 and UIUtil.IsPrefab(arg0_1)

	if var0_1 and not var1_1 then
		Object.Destroy(arg0_1)
	end
end

return var0_0
