local var0_0 = class("CourtYardPedestalFloorPaper", import(".CourtYardPedestalStructure"))
local var1_0 = {
	0.5,
	0.67,
	0.83,
	1
}

function var0_0.Update(arg0_1, arg1_1, arg2_1)
	arg0_1.paper = arg1_1

	var0_0.super.Update(arg0_1, arg2_1)
end

function var0_0.GetAssetPath(arg0_2)
	if not arg0_2.paper then
		return "furnitrues/base/floor_4"
	end

	local var0_2 = arg0_2.paper:GetObjType()

	if var0_2 == CourtYardConst.OBJ_TYPE_COMMOM then
		return "furnitrues/" .. arg0_2.paper:GetPicture()
	elseif var0_2 == CourtYardConst.OBJ_TYPE_SPINE then
		local var1_2, var2_2 = arg0_2.paper:GetSpineNameAndAction()

		return "sfurniture/" .. var1_2
	end
end

function var0_0.GetParent(arg0_3)
	return arg0_3.parent._tf:Find("paper")
end

function var0_0.OnLoaded(arg0_4, arg1_4)
	rtf(arg1_4).sizeDelta = Vector2(1888, 944)
	rtf(arg1_4).anchorMin = Vector2(0.5, 1)
	rtf(arg1_4).anchorMax = Vector2(0.5, 1)
	rtf(arg1_4).pivot = Vector2(0.5, 1)
	rtf(arg1_4).localScale = Vector3(1, 1, 1)

	setAnchoredPosition(rtf(arg1_4), Vector3(0, -280, 0))

	if arg0_4.paper and arg0_4.paper:GetObjType() == CourtYardConst.OBJ_TYPE_SPINE then
		arg0_4:InitSpine(arg1_4)
	end

	local var0_4 = arg0_4:GetRect():GetSiblingIndex()

	tf(arg1_4):SetSiblingIndex(var0_4)

	local var1_4 = var1_0[arg0_4.level]

	arg1_4.transform.localScale = Vector3(var1_4, var1_4, 1)
end

function var0_0.InitSpine(arg0_5, arg1_5)
	local var0_5, var1_5 = arg0_5.paper:GetSpineNameAndAction()

	if var1_5 then
		GetOrAddComponent(tf(arg1_5):GetChild(0), typeof(SpineAnimUI)):SetAction(var1_5, 0)
	end
end

return var0_0
