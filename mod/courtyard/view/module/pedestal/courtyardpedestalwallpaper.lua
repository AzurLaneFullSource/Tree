local var0 = class("CourtYardPedestalWallPaper", import(".CourtYardPedestalStructure"))

function var0.Update(arg0, arg1, arg2)
	arg0.paper = arg1

	if not arg0.paper then
		arg0:Unload()

		return
	end

	var0.super.Update(arg0, arg2)
end

function var0.GetAssetPath(arg0)
	local var0 = arg0.paper:GetObjType()

	if var0 == CourtYardConst.OBJ_TYPE_COMMOM then
		return "furnitrues/" .. arg0.paper:GetPicture() .. arg0.level
	elseif var0 == CourtYardConst.OBJ_TYPE_SPINE then
		local var1, var2 = arg0.paper:GetSpineNameAndAction()

		return "sfurniture/" .. var1 .. arg0.level
	end
end

function var0.OnLoaded(arg0, arg1)
	rtf(arg1).anchorMin = Vector2(0.5, 1)
	rtf(arg1).anchorMax = Vector2(0.5, 1)
	rtf(arg1).pivot = Vector2(0.5, 1)
	rtf(arg1).localScale = Vector3(1, 1, 1)

	local var0 = arg0.paper:GetObjType()

	if var0 == CourtYardConst.OBJ_TYPE_COMMOM then
		arg0:InitCommon(arg1)
	elseif var0 == CourtYardConst.OBJ_TYPE_SPINE then
		arg0:InitSpine(arg1)
	end

	tf(arg1):SetSiblingIndex(1)
end

function var0.InitCommon(arg0, arg1)
	setAnchoredPosition(arg1, {
		x = 0,
		y = -6
	})
end

function var0.InitSpine(arg0, arg1)
	setAnchoredPosition(arg1, Vector3(0, -10, 0))

	local var0, var1 = arg0.paper:GetSpineNameAndAction()

	if var1 then
		GetOrAddComponent(tf(arg1):GetChild(0), typeof(SpineAnimUI)):SetAction(var1, 0)
	end
end

return var0
