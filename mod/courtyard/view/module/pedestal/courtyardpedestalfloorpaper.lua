local var0 = class("CourtYardPedestalFloorPaper", import(".CourtYardPedestalStructure"))
local var1 = {
	0.5,
	0.67,
	0.83,
	1
}

function var0.Update(arg0, arg1, arg2)
	arg0.paper = arg1

	var0.super.Update(arg0, arg2)
end

function var0.GetAssetPath(arg0)
	if not arg0.paper then
		return "furnitrues/base/floor_4"
	end

	local var0 = arg0.paper:GetObjType()

	if var0 == CourtYardConst.OBJ_TYPE_COMMOM then
		return "furnitrues/" .. arg0.paper:GetPicture()
	elseif var0 == CourtYardConst.OBJ_TYPE_SPINE then
		local var1, var2 = arg0.paper:GetSpineNameAndAction()

		return "sfurniture/" .. var1
	end
end

function var0.OnLoaded(arg0, arg1)
	rtf(arg1).sizeDelta = Vector2(1888, 944)
	rtf(arg1).anchorMin = Vector2(0.5, 1)
	rtf(arg1).anchorMax = Vector2(0.5, 1)
	rtf(arg1).pivot = Vector2(0.5, 1)
	rtf(arg1).localScale = Vector3(1, 1, 1)

	setAnchoredPosition(rtf(arg1), Vector3(0, -280, 0))

	if arg0.paper and arg0.paper:GetObjType() == CourtYardConst.OBJ_TYPE_SPINE then
		arg0:InitSpine(arg1)
	end

	local var0 = arg0:GetRect():GetSiblingIndex()

	tf(arg1):SetSiblingIndex(var0)

	local var1 = var1[arg0.level]

	arg1.transform.localScale = Vector3(var1, var1, 1)
end

function var0.InitSpine(arg0, arg1)
	local var0, var1 = arg0.paper:GetSpineNameAndAction()

	if var1 then
		GetOrAddComponent(tf(arg1):GetChild(0), typeof(SpineAnimUI)):SetAction(var1, 0)
	end
end

return var0
