local var0_0 = class("CourtYardPedestalWallBase", import(".CourtYardPedestalStructure"))

function var0_0.GetAssetPath(arg0_1)
	return "furnitrues/base/wall_" .. arg0_1.level
end

function var0_0.OnLoaded(arg0_2, arg1_2)
	arg1_2.transform:SetAsFirstSibling()
end

function var0_0.GetParent(arg0_3)
	return arg0_3.parent._tf:Find("base")
end

return var0_0
