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

function var0_0.OnLoaded(arg0_3, arg1_3)
	rtf(arg1_3).anchorMin = Vector2(0.5, 1)
	rtf(arg1_3).anchorMax = Vector2(0.5, 1)
	rtf(arg1_3).pivot = Vector2(0.5, 1)
	rtf(arg1_3).localScale = Vector3(1, 1, 1)

	local var0_3 = arg0_3.paper:GetObjType()

	if var0_3 == CourtYardConst.OBJ_TYPE_COMMOM then
		arg0_3:InitCommon(arg1_3)
	elseif var0_3 == CourtYardConst.OBJ_TYPE_SPINE then
		arg0_3:InitSpine(arg1_3)
	end

	tf(arg1_3):SetSiblingIndex(1)
end

function var0_0.InitCommon(arg0_4, arg1_4)
	setAnchoredPosition(arg1_4, {
		x = 0,
		y = -6
	})
end

function var0_0.InitSpine(arg0_5, arg1_5)
	setAnchoredPosition(arg1_5, Vector3(0, -10, 0))

	local var0_5, var1_5 = arg0_5.paper:GetSpineNameAndAction()

	if var1_5 then
		GetOrAddComponent(tf(arg1_5):GetChild(0), typeof(SpineAnimUI)):SetAction(var1_5, 0)
	end
end

return var0_0
