local var0_0 = class("CourtYardPedestalWallPaper", import(".CourtYardPedestalStructure"))

function var0_0.Update(arg0_1, arg1_1, arg2_1)
	arg0_1.paper = arg1_1

	if not arg0_1.paper then
		arg0_1:Unload()

		return
	end

	var0_0.super.Update(arg0_1, arg2_1)
end

function var0_0.GetAssetPath(arg0_2)
	local var0_2 = arg0_2.paper:GetObjType()

	if var0_2 == CourtYardConst.OBJ_TYPE_COMMOM then
		return "furnitrues/" .. arg0_2.paper:GetPicture() .. arg0_2.level
	elseif var0_2 == CourtYardConst.OBJ_TYPE_SPINE then
		local var1_2, var2_2 = arg0_2.paper:GetSpineNameAndAction()

		return "sfurniture/" .. var1_2 .. arg0_2.level
	end
end

function var0_0.GetParent(arg0_3)
	return arg0_3.parent._tf:Find("paper")
end

function var0_0.OnLoaded(arg0_4, arg1_4)
	rtf(arg1_4).anchorMin = Vector2(0.5, 1)
	rtf(arg1_4).anchorMax = Vector2(0.5, 1)
	rtf(arg1_4).pivot = Vector2(0.5, 1)
	rtf(arg1_4).localScale = Vector3(1, 1, 1)

	local var0_4 = arg0_4.paper:GetObjType()

	if var0_4 == CourtYardConst.OBJ_TYPE_COMMOM then
		arg0_4:InitCommon(arg1_4)
	elseif var0_4 == CourtYardConst.OBJ_TYPE_SPINE then
		arg0_4:InitSpine(arg1_4)
	end

	tf(arg1_4):SetSiblingIndex(1)
end

function var0_0.InitCommon(arg0_5, arg1_5)
	setAnchoredPosition(arg1_5, {
		x = 0,
		y = -6
	})
end

function var0_0.InitSpine(arg0_6, arg1_6)
	setAnchoredPosition(arg1_6, Vector3(0, -10, 0))

	local var0_6, var1_6 = arg0_6.paper:GetSpineNameAndAction()

	if var1_6 then
		GetOrAddComponent(tf(arg1_6):GetChild(0), typeof(SpineAnimUI)):SetAction(var1_6, 0)
	end
end

return var0_0
