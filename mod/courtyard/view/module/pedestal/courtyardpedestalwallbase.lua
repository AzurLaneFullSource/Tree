local var0 = class("CourtYardPedestalWallBase", import(".CourtYardPedestalStructure"))

function var0.GetAssetPath(arg0)
	return "furnitrues/base/wall_" .. arg0.level
end

function var0.OnLoaded(arg0, arg1)
	arg1.transform:SetAsFirstSibling()
end

return var0
