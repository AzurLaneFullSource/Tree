local var0_0 = UnityEngine

function flog(arg0_1, arg1_1)
	if arg0_1 and arg1_1 and pg.ConnectionMgr.GetInstance():isConnected() then
		pg.m02:sendNotification(GAME.SEND_CMD, {
			cmd = "log",
			arg1 = arg0_1,
			arg2 = arg1_1
		})
	end
end

function throttle(arg0_2, arg1_2, arg2_2)
	local var0_2
	local var1_2
	local var2_2
	local var3_2 = 0

	local function var4_2()
		var3_2 = arg2_2 and Time.unscaledTime or 0
		var0_2 = nil
		var2_2 = arg0_2(unpackEx(var1_2))

		if not var0_2 then
			var1_2 = nil
		end
	end

	return function(...)
		local var0_4 = Time.unscaledTime

		if not var3_2 and not arg2_2 then
			var3_2 = var0_4
		end

		local var1_4 = arg1_2 - (var0_4 - var3_2)

		var1_2 = packEx(...)

		if var1_4 <= 0 or var1_4 > arg1_2 then
			if var0_2 then
				var0_2:Stop()

				var0_2 = nil
			end

			var3_2 = var0_4
			var2_2 = arg0_2(unpackEx(var1_2))

			if not var0_2 then
				var1_2 = nil
			end
		elseif not var0_2 and arg2_2 then
			var0_2 = Timer.New(var4_2, var1_4, 1)

			var0_2:Start()
		end

		return var2_2
	end
end

function debounce(arg0_5, arg1_5, arg2_5)
	local var0_5
	local var1_5
	local var2_5
	local var3_5
	local var4_5

	local function var5_5()
		local var0_6 = Time.unscaledTime - var2_5

		if var0_6 < arg1_5 and var0_6 > 0 then
			var0_5 = Timer.New(var5_5, arg1_5 - var0_6, 1)

			var0_5:Start()
		else
			var0_5 = nil

			if not arg2_5 then
				var3_5 = arg0_5(unpackEx(var1_5))

				if not var0_5 then
					var1_5 = nil
				end
			else
				arg2_5 = false
			end
		end
	end

	return function(...)
		var1_5 = packEx(...)
		var2_5 = Time.unscaledTime

		local var0_7 = arg2_5 and not var0_5

		if not var0_5 then
			var0_5 = Timer.New(var5_5, arg1_5, 1)

			var0_5:Start()
		end

		if var0_7 then
			var3_5 = arg0_5(unpackEx(var1_5))
			var1_5 = nil
		end

		return var3_5
	end
end

function createLog(arg0_8, arg1_8)
	if LOG and arg1_8 then
		return function(...)
			print(arg0_8 .. ": ", ...)
		end
	else
		print(arg0_8 .. ": log disabled")

		return function()
			return
		end
	end
end

function getProxy(arg0_11)
	assert(pg.m02, "game is not started")

	return pg.m02:retrieveProxy(arg0_11.__cname)
end

function LoadAndInstantiateAsync(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
	arg4_12 = defaultValue(arg4_12, true)
	arg3_12 = defaultValue(arg3_12, true)
	arg0_12, arg1_12 = HXSet.autoHxShift(arg0_12 .. "/", arg1_12)

	ResourceMgr.Inst:getAssetAsync(arg0_12 .. arg1_12, "", var0_0.Events.UnityAction_UnityEngine_Object(function(arg0_13)
		local var0_13 = Instantiate(arg0_13)

		arg2_12(var0_13)
	end), arg3_12, arg4_12)
end

function LoadAndInstantiateSync(arg0_14, arg1_14, arg2_14, arg3_14)
	arg3_14 = defaultValue(arg3_14, true)
	arg2_14 = defaultValue(arg2_14, true)
	arg0_14, arg1_14 = HXSet.autoHxShift(arg0_14 .. "/", arg1_14)

	local var0_14 = ResourceMgr.Inst:getAssetSync(arg0_14 .. arg1_14, "", arg2_14, arg3_14)

	return (Instantiate(var0_14))
end

local var1_0 = {}

function LoadSprite(arg0_15, arg1_15)
	return LoadAny(arg0_15, arg1_15, typeof(Sprite))
end

function LoadSpriteAtlasAsync(arg0_16, arg1_16, arg2_16)
	LoadAnyAsync(arg0_16, arg1_16, typeof(Sprite), arg2_16)
end

function LoadSpriteAsync(arg0_17, arg1_17)
	LoadSpriteAtlasAsync(arg0_17, "", arg1_17)
end

function LoadAny(arg0_18, arg1_18, arg2_18)
	arg0_18, arg1_18 = HXSet.autoHxShiftPath(arg0_18, arg1_18)

	return AssetBundleHelper.LoadAsset(arg0_18, arg1_18, arg2_18, false, nil, true)
end

function LoadAnyAsync(arg0_19, arg1_19, arg2_19, arg3_19)
	arg0_19, arg1_19 = HXSet.autoHxShiftPath(arg0_19, arg1_19)

	AssetBundleHelper.LoadAsset(arg0_19, arg1_19, arg2_19, true, arg3_19, true)
end

function LoadImageSpriteAtlasAsync(arg0_20, arg1_20, arg2_20, arg3_20)
	local var0_20 = arg2_20:GetComponent(typeof(Image))

	var0_20.enabled = false
	var1_0[var0_20] = arg0_20

	LoadSpriteAtlasAsync(arg0_20, arg1_20, function(arg0_21)
		if not IsNil(var0_20) and var1_0[var0_20] == arg0_20 then
			var1_0[var0_20] = nil
			var0_20.enabled = true
			var0_20.sprite = arg0_21

			if arg3_20 then
				var0_20:SetNativeSize()
			end
		end
	end)
end

function LoadImageSpriteAsync(arg0_22, arg1_22, arg2_22)
	LoadImageSpriteAtlasAsync(arg0_22, nil, arg1_22, arg2_22)
end

function GetSpriteFromAtlas(arg0_23, arg1_23)
	local var0_23

	arg0_23, arg1_23 = HXSet.autoHxShiftPath(arg0_23, arg1_23)

	PoolMgr.GetInstance():GetSprite(arg0_23, arg1_23, false, function(arg0_24)
		var0_23 = arg0_24
	end)

	return var0_23
end

function GetSpriteFromAtlasAsync(arg0_25, arg1_25, arg2_25)
	arg0_25, arg1_25 = HXSet.autoHxShiftPath(arg0_25, arg1_25)

	PoolMgr.GetInstance():GetSprite(arg0_25, arg1_25, true, function(arg0_26)
		arg2_25(arg0_26)
	end)
end

function GetImageSpriteFromAtlasAsync(arg0_27, arg1_27, arg2_27, arg3_27)
	arg0_27, arg1_27 = HXSet.autoHxShiftPath(arg0_27, arg1_27)

	local var0_27 = arg2_27:GetComponent(typeof(Image))

	var0_27.enabled = false
	var1_0[var0_27] = arg0_27 .. arg1_27

	GetSpriteFromAtlasAsync(arg0_27, arg1_27, function(arg0_28)
		if not IsNil(var0_27) and var1_0[var0_27] == arg0_27 .. arg1_27 then
			var1_0[var0_27] = nil
			var0_27.enabled = true
			var0_27.sprite = arg0_28

			if arg3_27 then
				var0_27:SetNativeSize()
			end
		end
	end)
end

function SetAction(arg0_29, arg1_29, arg2_29)
	local var0_29 = GetComponent(arg0_29, "SkeletonGraphic").AnimationState

	var0_29:SetAnimation(0, arg1_29, defaultValue(arg2_29, true))
	var0_29:Update(Time.deltaTime)
end

function SetActionCallback(arg0_30, arg1_30)
	GetOrAddComponent(arg0_30, typeof(SpineAnimUI)):SetActionCallBack(arg1_30)
end

function emojiText(arg0_31, arg1_31)
	local var0_31 = GetComponent(arg0_31, "TextMesh")
	local var1_31 = GetComponent(arg0_31, "MeshRenderer")
	local var2_31 = Shader.Find("UI/Unlit/Transparent")
	local var3_31 = var1_31.materials
	local var4_31 = {
		var3_31[0]
	}
	local var5_31 = {}
	local var6_31 = 0
	local var7_31 = {}
	local var8_31 = string.gsub(arg1_31, "#(%d+)#", function(arg0_32)
		if not var5_31[arg0_32] then
			var6_31 = var6_31 + 1
			var7_31["emoji" .. arg0_32] = Material.New(var2_31)

			table.insert(var4_31, mat)

			var5_31[arg0_32] = var6_31

			local var0_32 = var6_31
		end

		return "<quad material=" .. var6_31 .. " />"
	end)
	local var9_31 = AssetBundleHelper.LoadManyAssets("emojis", underscore.keys(var7_31), nil, false, nil, true)

	for iter0_31, iter1_31 in pairs(var7_31) do
		iter1_31.mainTexture = var9_31[iter0_31]
	end

	var0_31.text = var8_31
	var1_31.materials = var4_31
end

function setPaintingImg(arg0_33, arg1_33)
	local var0_33 = LoadSprite("painting/" .. arg1_33) or LoadSprite("painting/unknown")

	setImageSprite(arg0_33, var0_33)
	resetAspectRatio(arg0_33)
end

function setPaintingPrefab(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34)
	local var0_34 = findTF(arg0_34, "fitter")

	assert(var0_34, "请添加子物体fitter")
	removeAllChildren(var0_34)

	local var1_34 = GetOrAddComponent(var0_34, "PaintingScaler")

	var1_34.FrameName = arg2_34 or ""
	var1_34.Tween = 1

	local var2_34 = arg1_34

	if not arg3_34 and checkABExist("painting/" .. arg1_34 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg1_34, 0) ~= 0 then
		arg1_34 = arg1_34 .. "_n"
	end

	PoolMgr.GetInstance():GetPainting(arg1_34, false, function(arg0_35)
		setParent(arg0_35, var0_34, false)

		local var0_35 = findTF(arg0_35, "Touch")

		if not IsNil(var0_35) then
			setActive(var0_35, false)
		end

		local var1_35 = findTF(arg0_35, "hx")

		if not IsNil(var1_35) then
			setActive(var1_35, HXSet.isHx())
		end

		ShipExpressionHelper.SetExpression(var0_34:GetChild(0), var2_34)
	end)
	PaintingShiftTransform(var0_34, arg2_34, arg4_34)
end

local var2_0 = {}

function setPaintingPrefabAsync(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36)
	local var0_36 = arg1_36

	if checkABExist("painting/" .. arg1_36 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg1_36, 0) ~= 0 then
		arg1_36 = arg1_36 .. "_n"
	end

	LoadPaintingPrefabAsync(arg0_36, var0_36, arg1_36, arg2_36, arg3_36, arg4_36)
end

function LoadPaintingPrefabAsync(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37, arg5_37)
	local var0_37 = findTF(arg0_37, "fitter")

	assert(var0_37, "请添加子物体fitter")
	removeAllChildren(var0_37)

	local var1_37 = GetOrAddComponent(var0_37, "PaintingScaler")

	var1_37.FrameName = arg3_37 or ""
	var1_37.Tween = 1
	var2_0[arg0_37] = arg2_37

	PoolMgr.GetInstance():GetPainting(arg2_37, true, function(arg0_38)
		if IsNil(arg0_37) or var2_0[arg0_37] ~= arg2_37 then
			PoolMgr.GetInstance():ReturnPainting(arg2_37, arg0_38)

			return
		else
			setParent(arg0_38, var0_37, false)

			var2_0[arg0_37] = nil

			ShipExpressionHelper.SetExpression(arg0_38, arg1_37)
		end

		local var0_38 = findTF(arg0_38, "Touch")

		if not IsNil(var0_38) then
			setActive(var0_38, false)
		end

		local var1_38 = findTF(arg0_38, "Drag")

		if not IsNil(var1_38) then
			setActive(var1_38, false)
		end

		local var2_38 = findTF(arg0_38, "hx")

		if not IsNil(var2_38) then
			setActive(var2_38, HXSet.isHx())
		end

		if arg4_37 then
			arg4_37(arg0_38)
		end
	end)
	PaintingShiftTransform(var0_37, arg3_37, arg5_37)
end

local var3_0 = {
	pifu = "skin_card_shift",
	biandui = "formation_shift"
}

function PaintingShiftTransform(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg0_39.parent:GetComponent(typeof(RectTransform))
	local var1_39 = var3_0[arg1_39]

	if var1_39 ~= nil and arg2_39 ~= nil then
		local var2_39 = pg.ship_skin_newmainui_shift[arg2_39.skinID]

		if var2_39 then
			local var3_39 = var2_39[var1_39]

			var0_39.localEulerAngles = Vector3(0, 0, var3_39[5] and var3_39[5] or 0)

			return
		end
	end

	var0_39.localEulerAngles = Vector3(0, 0, 0)
end

function retPaintingPrefab(arg0_40, arg1_40, arg2_40)
	if arg0_40 and arg1_40 then
		local var0_40 = findTF(arg0_40, "fitter")

		if var0_40 and var0_40.childCount > 0 then
			local var1_40 = var0_40:GetChild(0)

			if not IsNil(var1_40) then
				local var2_40 = findTF(var1_40, "Touch")

				if not IsNil(var2_40) then
					eachChild(var2_40, function(arg0_41)
						local var0_41 = arg0_41:GetComponent(typeof(Button))

						if not IsNil(var0_41) then
							removeOnButton(arg0_41)
						end
					end)
				end

				if not arg2_40 then
					PoolMgr.GetInstance():ReturnPainting(string.gsub(var1_40.name, "%(Clone%)", ""), var1_40.gameObject)
				else
					PoolMgr.GetInstance():ReturnPaintingWithPrefix(string.gsub(var1_40.name, "%(Clone%)", ""), var1_40.gameObject, arg2_40)
				end
			end
		end

		var2_0[arg0_40] = nil
	end
end

function checkPaintingPrefab(arg0_42, arg1_42, arg2_42, arg3_42, arg4_42)
	local var0_42 = findTF(arg0_42, "fitter")

	assert(var0_42, "请添加子物体fitter")
	removeAllChildren(var0_42)

	local var1_42 = GetOrAddComponent(var0_42, "PaintingScaler")

	var1_42.FrameName = arg2_42 or ""
	var1_42.Tween = 1

	local var2_42 = arg4_42 or "painting/"
	local var3_42 = arg1_42

	if not arg3_42 and checkABExist(var2_42 .. arg1_42 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg1_42, 0) ~= 0 then
		arg1_42 = arg1_42 .. "_n"
	end

	return var0_42, arg1_42, var3_42
end

function onLoadedPaintingPrefab(arg0_43)
	local var0_43 = arg0_43.paintingTF
	local var1_43 = arg0_43.fitterTF
	local var2_43 = arg0_43.defaultPaintingName

	setParent(var0_43, var1_43, false)

	local var3_43 = findTF(var0_43, "Touch")

	if not IsNil(var3_43) then
		setActive(var3_43, false)
	end

	local var4_43 = findTF(var0_43, "hx")

	if not IsNil(var4_43) then
		setActive(var4_43, HXSet.isHx())
	end

	ShipExpressionHelper.SetExpression(var1_43:GetChild(0), var2_43)
end

function onLoadedPaintingPrefabAsync(arg0_44)
	local var0_44 = arg0_44.paintingTF
	local var1_44 = arg0_44.fitterTF
	local var2_44 = arg0_44.objectOrTransform
	local var3_44 = arg0_44.paintingName
	local var4_44 = arg0_44.defaultPaintingName
	local var5_44 = arg0_44.callback

	if IsNil(var2_44) or var2_0[var2_44] ~= var3_44 then
		PoolMgr.GetInstance():ReturnPainting(var3_44, var0_44)

		return
	else
		setParent(var0_44, var1_44, false)

		var2_0[var2_44] = nil

		ShipExpressionHelper.SetExpression(var0_44, var4_44)
	end

	local var6_44 = findTF(var0_44, "Touch")

	if not IsNil(var6_44) then
		setActive(var6_44, false)
	end

	local var7_44 = findTF(var0_44, "hx")

	if not IsNil(var7_44) then
		setActive(var7_44, HXSet.isHx())
	end

	if var5_44 then
		var5_44()
	end
end

function setCommanderPaintingPrefab(arg0_45, arg1_45, arg2_45, arg3_45)
	local var0_45, var1_45, var2_45 = checkPaintingPrefab(arg0_45, arg1_45, arg2_45, arg3_45)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_45, false, function(arg0_46)
		local var0_46 = {
			paintingTF = arg0_46,
			fitterTF = var0_45,
			defaultPaintingName = var2_45
		}

		onLoadedPaintingPrefab(var0_46)
	end, "commanderpainting/")
end

function setCommanderPaintingPrefabAsync(arg0_47, arg1_47, arg2_47, arg3_47, arg4_47)
	local var0_47, var1_47, var2_47 = checkPaintingPrefab(arg0_47, arg1_47, arg2_47, arg4_47)

	var2_0[arg0_47] = var1_47

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_47, true, function(arg0_48)
		local var0_48 = {
			paintingTF = arg0_48,
			fitterTF = var0_47,
			objectOrTransform = arg0_47,
			paintingName = var1_47,
			defaultPaintingName = var2_47,
			callback = arg3_47
		}

		onLoadedPaintingPrefabAsync(var0_48)
	end, "commanderpainting/")
end

function retCommanderPaintingPrefab(arg0_49, arg1_49)
	retPaintingPrefab(arg0_49, arg1_49, "commanderpainting/")
end

function setMetaPaintingPrefab(arg0_50, arg1_50, arg2_50, arg3_50)
	local var0_50, var1_50, var2_50 = checkPaintingPrefab(arg0_50, arg1_50, arg2_50, arg3_50)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_50, false, function(arg0_51)
		local var0_51 = {
			paintingTF = arg0_51,
			fitterTF = var0_50,
			defaultPaintingName = var2_50
		}

		onLoadedPaintingPrefab(var0_51)
	end, "metapainting/")
end

function setMetaPaintingPrefabAsync(arg0_52, arg1_52, arg2_52, arg3_52, arg4_52)
	local var0_52, var1_52, var2_52 = checkPaintingPrefab(arg0_52, arg1_52, arg2_52, arg4_52)

	var2_0[arg0_52] = var1_52

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_52, true, function(arg0_53)
		local var0_53 = {
			paintingTF = arg0_53,
			fitterTF = var0_52,
			objectOrTransform = arg0_52,
			paintingName = var1_52,
			defaultPaintingName = var2_52,
			callback = arg3_52
		}

		onLoadedPaintingPrefabAsync(var0_53)
	end, "metapainting/")
end

function retMetaPaintingPrefab(arg0_54, arg1_54)
	retPaintingPrefab(arg0_54, arg1_54, "metapainting/")
end

function setGuildPaintingPrefab(arg0_55, arg1_55, arg2_55, arg3_55)
	local var0_55, var1_55, var2_55 = checkPaintingPrefab(arg0_55, arg1_55, arg2_55, arg3_55)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_55, false, function(arg0_56)
		local var0_56 = {
			paintingTF = arg0_56,
			fitterTF = var0_55,
			defaultPaintingName = var2_55
		}

		onLoadedPaintingPrefab(var0_56)
	end, "guildpainting/")
end

function setGuildPaintingPrefabAsync(arg0_57, arg1_57, arg2_57, arg3_57, arg4_57)
	local var0_57, var1_57, var2_57 = checkPaintingPrefab(arg0_57, arg1_57, arg2_57, arg4_57)

	var2_0[arg0_57] = var1_57

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_57, true, function(arg0_58)
		local var0_58 = {
			paintingTF = arg0_58,
			fitterTF = var0_57,
			objectOrTransform = arg0_57,
			paintingName = var1_57,
			defaultPaintingName = var2_57,
			callback = arg3_57
		}

		onLoadedPaintingPrefabAsync(var0_58)
	end, "guildpainting/")
end

function retGuildPaintingPrefab(arg0_59, arg1_59)
	retPaintingPrefab(arg0_59, arg1_59, "guildpainting/")
end

function setShopPaintingPrefab(arg0_60, arg1_60, arg2_60, arg3_60)
	local var0_60, var1_60, var2_60 = checkPaintingPrefab(arg0_60, arg1_60, arg2_60, arg3_60)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_60, false, function(arg0_61)
		local var0_61 = {
			paintingTF = arg0_61,
			fitterTF = var0_60,
			defaultPaintingName = var2_60
		}

		onLoadedPaintingPrefab(var0_61)
	end, "shoppainting/")
end

function retShopPaintingPrefab(arg0_62, arg1_62)
	retPaintingPrefab(arg0_62, arg1_62, "shoppainting/")
end

function setBuildPaintingPrefabAsync(arg0_63, arg1_63, arg2_63, arg3_63, arg4_63)
	local var0_63, var1_63, var2_63 = checkPaintingPrefab(arg0_63, arg1_63, arg2_63, arg4_63)

	var2_0[arg0_63] = var1_63

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_63, true, function(arg0_64)
		local var0_64 = {
			paintingTF = arg0_64,
			fitterTF = var0_63,
			objectOrTransform = arg0_63,
			paintingName = var1_63,
			defaultPaintingName = var2_63,
			callback = arg3_63
		}

		onLoadedPaintingPrefabAsync(var0_64)
	end, "buildpainting/")
end

function retBuildPaintingPrefab(arg0_65, arg1_65)
	retPaintingPrefab(arg0_65, arg1_65, "buildpainting/")
end

function setColorCount(arg0_66, arg1_66, arg2_66)
	setText(arg0_66, string.format(arg1_66 < arg2_66 and "<color=" .. COLOR_RED .. ">%d</color>/%d" or "%d/%d", arg1_66, arg2_66))
end

function customColorCount(arg0_67, arg1_67, arg2_67, arg3_67, arg4_67)
	arg0_67.text = _customColorCount(arg1_67, arg2_67, arg3_67, arg4_67)
end

function _customColorCount(arg0_68, arg1_68, arg2_68, arg3_68)
	local var0_68 = arg0_68 < arg1_68 and arg3_68 or arg2_68

	return string.format("<color=" .. var0_68 .. ">%d</color>/%d" or "%d/%d", arg0_68, arg1_68)
end

function setColorStr(arg0_69, arg1_69)
	return "<color=" .. arg1_69 .. ">" .. arg0_69 .. "</color>"
end

function setSizeStr(arg0_70, arg1_70)
	local var0_70, var1_70 = string.gsub(arg0_70, "[<]size=%d+[>]", "<size=" .. arg1_70 .. ">")

	if var1_70 == 0 then
		var0_70 = "<size=" .. arg1_70 .. ">" .. var0_70 .. "</size>"
	end

	return var0_70
end

function getBgm(arg0_71, arg1_71)
	local var0_71 = pg.voice_bgm[arg0_71]

	if pg.CriMgr.GetInstance():IsDefaultBGM() then
		return var0_71 and var0_71.default_bgm or nil
	elseif var0_71 then
		if var0_71.special_bgm and type(var0_71.special_bgm) == "table" and #var0_71.special_bgm > 0 and _.all(var0_71.special_bgm, function(arg0_72)
			return type(arg0_72) == "table" and #arg0_72 > 2 and type(arg0_72[2]) == "number"
		end) then
			local var1_71 = Clone(var0_71.special_bgm)

			table.sort(var1_71, function(arg0_73, arg1_73)
				return arg0_73[2] > arg1_73[2]
			end)

			local var2_71 = ""

			_.each(var1_71, function(arg0_74)
				if var2_71 ~= "" then
					return
				end

				local var0_74 = arg0_74[1]
				local var1_74 = arg0_74[3]

				switch(var0_74, {
					function()
						local var0_75 = var1_74[1]
						local var1_75 = var1_74[2]

						if #var0_75 == 1 then
							if var0_75[1] ~= "always" then
								return
							end
						elseif not pg.TimeMgr.GetInstance():inTime(var0_75) then
							return
						end

						_.each(var1_75, function(arg0_76)
							if var2_71 ~= "" then
								return
							end

							if #arg0_76 == 2 and pg.TimeMgr.GetInstance():inPeriod(arg0_76[1]) then
								var2_71 = arg0_76[2]
							elseif #arg0_76 == 3 and pg.TimeMgr.GetInstance():inPeriod(arg0_76[1], arg0_76[2]) then
								var2_71 = arg0_76[3]
							end
						end)
					end,
					function()
						local var0_77 = false
						local var1_77 = ""

						_.each(var1_74, function(arg0_78)
							if #arg0_78 ~= 2 or var0_77 then
								return
							end

							if pg.NewStoryMgr.GetInstance():IsPlayed(arg0_78[1]) then
								var2_71 = arg0_78[2]

								if var2_71 ~= "" then
									var1_77 = var2_71
								else
									var2_71 = var1_77
								end
							else
								var0_77 = true
							end
						end)
					end,
					function()
						if not arg1_71 then
							return
						end

						_.each(var1_74, function(arg0_80)
							if #arg0_80 == 2 and arg0_80[1] == arg1_71 then
								var2_71 = arg0_80[2]

								return
							end
						end)
					end
				})
			end)

			return var2_71 ~= "" and var2_71 or var0_71.bgm
		else
			return var0_71 and var0_71.bgm or nil
		end
	else
		return nil
	end
end

function playStory(arg0_81, arg1_81)
	pg.NewStoryMgr.GetInstance():Play(arg0_81, arg1_81)
end

function errorMessage(arg0_82)
	local var0_82 = ERROR_MESSAGE[arg0_82]

	if var0_82 == nil then
		var0_82 = ERROR_MESSAGE[9999] .. ":" .. arg0_82
	end

	return var0_82
end

function errorTip(arg0_83, arg1_83, ...)
	local var0_83 = pg.gametip[arg0_83 .. "_error"]
	local var1_83

	if var0_83 then
		var1_83 = var0_83.tip
	else
		var1_83 = pg.gametip.common_error.tip
	end

	local var2_83 = arg0_83 .. "_error_" .. arg1_83

	if pg.gametip[var2_83] then
		local var3_83 = i18n(var2_83, ...)

		return var1_83 .. var3_83
	else
		local var4_83 = "common_error_" .. arg1_83

		if pg.gametip[var4_83] then
			local var5_83 = i18n(var4_83, ...)

			return var1_83 .. var5_83
		else
			local var6_83 = errorMessage(arg1_83)

			return var1_83 .. arg1_83 .. ":" .. var6_83
		end
	end
end

function colorNumber(arg0_84, arg1_84)
	local var0_84 = "@COLOR_SCOPE"
	local var1_84 = {}

	arg0_84 = string.gsub(arg0_84, "<color=#%x+>", function(arg0_85)
		table.insert(var1_84, arg0_85)

		return var0_84
	end)
	arg0_84 = string.gsub(arg0_84, "%d+%.?%d*%%*", function(arg0_86)
		return "<color=" .. arg1_84 .. ">" .. arg0_86 .. "</color>"
	end)

	if #var1_84 > 0 then
		local var2_84 = 0

		return (string.gsub(arg0_84, var0_84, function(arg0_87)
			var2_84 = var2_84 + 1

			return var1_84[var2_84]
		end))
	else
		return arg0_84
	end
end

function getBounds(arg0_88)
	local var0_88 = LuaHelper.GetWorldCorners(rtf(arg0_88))
	local var1_88 = Bounds.New(var0_88[0], Vector3.zero)

	var1_88:Encapsulate(var0_88[2])

	return var1_88
end

local function var4_0(arg0_89, arg1_89)
	arg0_89.localScale = Vector3.one
	arg0_89.anchorMin = Vector2.zero
	arg0_89.anchorMax = Vector2.one
	arg0_89.offsetMin = Vector2(arg1_89[1], arg1_89[2])
	arg0_89.offsetMax = Vector2(-arg1_89[3], -arg1_89[4])
end

local var5_0 = {
	frame4_0 = {
		-8,
		-8.5,
		-8,
		-8
	},
	frame5_0 = {
		-8,
		-8.5,
		-8,
		-8
	},
	frame4_1 = {
		-8,
		-8.5,
		-8,
		-8
	},
	frame_design = {
		-16.5,
		-2.5,
		-3.5,
		-16.5
	},
	frame_skin = {
		-16.5,
		-2.5,
		-3.5,
		-16.5
	},
	frame_npc = {
		-4,
		-4,
		-4,
		-4
	},
	frame_store = {
		-17,
		-3,
		-3,
		-18
	},
	frame_prop = {
		-11,
		-12,
		-14,
		-14
	},
	frame_prop_meta = {
		-11,
		-12,
		-14,
		-14
	},
	frame_battle_ui = {
		-16,
		-3.4,
		-2.6,
		-31
	},
	other = {
		-2.5,
		-4.5,
		-3,
		-4.5
	},
	frame_dorm = {
		-16.5,
		-2.5,
		-3.5,
		-16.5
	}
}
local var6_0 = {
	["IconColorful(Clone)"] = 1,
	["Item_duang5(Clone)"] = 99,
	specialFrame = 2
}

function setFrame(arg0_90, arg1_90, arg2_90)
	arg1_90 = tostring(arg1_90)

	local var0_90, var1_90 = unpack((string.split(arg1_90, "_")))

	if var1_90 or tonumber(var0_90) > 5 then
		arg2_90 = arg2_90 or "frame" .. arg1_90
	end

	GetImageSpriteFromAtlasAsync("weaponframes", "frame", arg0_90)

	local var2_90 = arg2_90 and Color.white or Color.NewHex(ItemRarity.Rarity2FrameHexColor(var0_90 and tonumber(var0_90) or ItemRarity.Gray))

	setImageColor(arg0_90, var2_90)

	local var3_90 = findTF(arg0_90, "specialFrame")

	if arg2_90 then
		if var3_90 then
			setActive(var3_90, true)
		else
			var3_90 = cloneTplTo(arg0_90, arg0_90, "specialFrame")

			removeAllChildren(var3_90)
		end

		var4_0(var3_90, var5_0[arg2_90] or var5_0.other)
		GetImageSpriteFromAtlasAsync("weaponframes", arg2_90, var3_90)
	elseif var3_90 then
		setActive(var3_90, false)
	end
end

function setIconColorful(arg0_91, arg1_91, arg2_91, arg3_91)
	arg3_91 = arg3_91 or {
		[ItemRarity.SSR] = {
			name = "IconColorful",
			active = function(arg0_92, arg1_92)
				return not arg1_92.noIconColorful and arg0_92 == ItemRarity.SSR
			end
		}
	}

	local var0_91 = findTF(arg0_91, "icon_bg/frame")

	for iter0_91, iter1_91 in pairs(arg3_91) do
		local var1_91 = iter1_91.name
		local var2_91 = iter1_91.active(arg1_91, arg2_91)
		local var3_91 = var0_91:Find(var1_91 .. "(Clone)")

		if var3_91 then
			setActive(var3_91, var2_91)
		elseif var2_91 then
			LoadAndInstantiateAsync("ui", string.lower(var1_91), function(arg0_93)
				if IsNil(arg0_91) or var0_91:Find(var1_91 .. "(Clone)") then
					Object.Destroy(arg0_93)
				else
					local var0_93 = var6_0[arg0_93.name] or 999
					local var1_93 = underscore.range(var0_91.childCount):chain():map(function(arg0_94)
						return var0_91:GetChild(arg0_94 - 1)
					end):map(function(arg0_95)
						return var6_0[arg0_95.name] or 0
					end):value()
					local var2_93 = 0

					for iter0_93 = #var1_93, 1, -1 do
						if var0_93 > var1_93[iter0_93] then
							var2_93 = iter0_93

							break
						end
					end

					setParent(arg0_93, var0_91)
					tf(arg0_93):SetSiblingIndex(var2_93)
					setActive(arg0_93, var2_91)
				end
			end)
		end
	end
end

function setIconStars(arg0_96, arg1_96, arg2_96)
	local var0_96 = findTF(arg0_96, "icon_bg/startpl")
	local var1_96 = findTF(arg0_96, "icon_bg/stars")

	if var1_96 and var0_96 then
		setActive(var1_96, false)
		setActive(var0_96, false)
	end

	if not var1_96 or not arg1_96 then
		return
	end

	for iter0_96 = 1, math.max(arg2_96, var1_96.childCount) do
		setActive(iter0_96 > var1_96.childCount and cloneTplTo(var0_96, var1_96) or var1_96:GetChild(iter0_96 - 1), iter0_96 <= arg2_96)
	end

	setActive(var1_96, true)
end

local function var7_0(arg0_97, arg1_97)
	local var0_97 = findTF(arg0_97, "icon_bg/slv")

	if not IsNil(var0_97) then
		setActive(var0_97, arg1_97 > 0)
		setText(findTF(var0_97, "Text"), arg1_97)
	end
end

function setIconName(arg0_98, arg1_98, arg2_98)
	local var0_98 = findTF(arg0_98, "name")

	if not IsNil(var0_98) then
		setText(var0_98, arg1_98)
		setTextAlpha(var0_98, (arg2_98.hideName or arg2_98.anonymous) and 0 or 1)
	end
end

function setIconCount(arg0_99, arg1_99)
	local var0_99 = findTF(arg0_99, "icon_bg/count")

	if not IsNil(var0_99) then
		setText(var0_99, arg1_99 and (type(arg1_99) ~= "number" or arg1_99 > 0) and arg1_99 or "")
	end
end

function updateEquipment(arg0_100, arg1_100, arg2_100)
	arg2_100 = arg2_100 or {}

	assert(arg1_100, "equipmentVo can not be nil.")

	local var0_100 = EquipmentRarity.Rarity2Print(arg1_100:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_100, findTF(arg0_100, "icon_bg"))
	setFrame(findTF(arg0_100, "icon_bg/frame"), var0_100)

	local var1_100 = findTF(arg0_100, "icon_bg/icon")

	var4_0(var1_100, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync("equips/" .. arg1_100:getConfig("icon"), "", var1_100)
	setIconStars(arg0_100, true, arg1_100:getConfig("rarity"))
	var7_0(arg0_100, arg1_100:getConfig("level") - 1)
	setIconName(arg0_100, arg1_100:getConfig("name"), arg2_100)
	setIconCount(arg0_100, arg1_100.count)
	setIconColorful(arg0_100, arg1_100:getConfig("rarity") - 1, arg2_100)
end

function updateItem(arg0_101, arg1_101, arg2_101)
	arg2_101 = arg2_101 or {}

	local var0_101 = ItemRarity.Rarity2Print(arg1_101:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_101, findTF(arg0_101, "icon_bg"))

	local var1_101

	if arg1_101:getConfig("type") == 9 then
		var1_101 = "frame_design"
	elseif arg1_101:getConfig("type") == 100 then
		var1_101 = "frame_dorm"
	elseif arg2_101.frame then
		var1_101 = arg2_101.frame
	end

	setFrame(findTF(arg0_101, "icon_bg/frame"), var0_101, var1_101)

	local var2_101 = findTF(arg0_101, "icon_bg/icon")
	local var3_101 = arg1_101.icon or arg1_101:getConfig("icon")

	if arg1_101:getConfig("type") == Item.LOVE_LETTER_TYPE then
		assert(arg1_101.extra, "without extra data")

		var3_101 = "SquareIcon/" .. ShipGroup.getDefaultSkin(arg1_101.extra).painting
	end

	GetImageSpriteFromAtlasAsync(var3_101, "", var2_101)
	setIconStars(arg0_101, false)
	setIconName(arg0_101, arg1_101:getName(), arg2_101)
	setIconColorful(arg0_101, arg1_101:getConfig("rarity"), arg2_101)
end

function updateIslandUnlock(arg0_102, arg1_102)
	local var0_102 = arg1_102:getConfigTable().cmd_icon

	setIslandRarityFrame(arg0_102, arg1_102)
	setActive(findTF(arg0_102, "icon_bg/count_bg"), false)
	GetImageSpriteFromAtlasAsync("island/" .. var0_102, "", findTF(arg0_102, "icon_bg/icon"))
	setIconName(arg0_102, "", {})
end

function updateIslandInvitation(arg0_103, arg1_103)
	local var0_103 = pg.island_chara_template[arg1_103.id].invite_item
	local var1_103 = pg.island_item_data_template[var0_103].icon

	setIslandRarityFrame(arg0_103, arg1_103)
	setActive(findTF(arg0_103, "icon_bg/count_bg"), arg1_103.count > 0)
	setText(findTF(arg0_103, "icon_bg/count_bg/count"), arg1_103.count)
	GetImageSpriteFromAtlasAsync("island/" .. var1_103, "", findTF(arg0_103, "icon_bg/icon"))
	setIconName(arg0_103, "", {})
end

function updateIslandItem(arg0_104, arg1_104)
	local var0_104 = arg1_104:getConfigTable().icon
	local var1_104 = arg1_104:getConfigTable().name

	setIslandRarityFrame(arg0_104, arg1_104)
	setActive(findTF(arg0_104, "icon_bg/count_bg"), arg1_104.count > 0)
	setText(findTF(arg0_104, "icon_bg/count_bg/count"), arg1_104.count)
	GetImageSpriteFromAtlasAsync("island/" .. var0_104, "", findTF(arg0_104, "icon_bg/icon"))
	setIconName(arg0_104, var1_104, {})
end

function updateIslandFurniture(arg0_105, arg1_105)
	local var0_105 = arg1_105:getConfigTable().rarity
	local var1_105 = arg1_105:getConfigTable().icon
	local var2_105 = arg1_105:getConfigTable().name

	setIslandRarityFrame(arg0_105, arg1_105)
	setActive(findTF(arg0_105, "icon_bg/count_bg"), arg1_105.count > 0)
	setText(findTF(arg0_105, "icon_bg/count_bg/count"), arg1_105.count)
	GetImageSpriteFromAtlasAsync("island/IslandFurnitureIcon/" .. var1_105, "", findTF(arg0_105, "icon_bg/icon"))
	setIconName(arg0_105, var2_105, {})
end

function updateDefaultIconTpl(arg0_106, arg1_106, arg2_106)
	arg2_106 = arg2_106 or {}

	local var0_106 = arg1_106:getDropRarity()
	local var1_106 = ItemRarity.Rarity2Print(var0_106)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_106, arg0_106:Find("icon_bg"))
	setFrame(arg0_106:Find("icon_bg/frame"), var1_106)

	local var2_106 = arg0_106:Find("icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_106:getIcon(), "", var2_106)
	setIconStars(arg0_106, false)
	setIconName(arg0_106, arg1_106:getName(), arg2_106)
	setIconColorful(arg0_106, var0_106, arg2_106)
end

function updateIslandDefaultIconTpl(arg0_107, arg1_107, arg2_107)
	GetImageSpriteFromAtlasAsync(arg1_107:getIcon(), "", findTF(arg0_107, "icon_bg/icon"))
	setActive(findTF(arg0_107, "icon_bg/count_bg"), arg1_107.count > 0)
	setText(findTF(arg0_107, "icon_bg/count_bg/count"), arg1_107.count)
	setIconName(arg0_107, arg1_107:getName(), {})
	setIslandRarityFrame(arg0_107, arg1_107)
end

function setIslandRarityFrame(arg0_108, arg1_108)
	local var0_108 = arg1_108:getIslandRarity()
	local var1_108 = IslandItemRarity.Rarity2FrameName(var0_108)

	GetImageSpriteFromAtlasAsync("island/islandframe", var1_108, findTF(arg0_108, "icon_bg"))

	if not IsNil(findTF(arg0_108, "icon_bg/frame")) then
		GetImageSpriteFromAtlasAsync("island/islandframe", var1_108, findTF(arg0_108, "icon_bg/frame"))
	end
end

function getIslandSeasonPtInfo()
	local var0_109 = pg.island_set.season_pt.key_value_varchar

	return {
		name = var0_109[1],
		icon = var0_109[2]
	}
end

function updateIslandSeasonPt(arg0_110, arg1_110)
	local var0_110 = getIslandSeasonPtInfo()

	GetImageSpriteFromAtlasAsync("island/" .. var0_110.icon, "", findTF(arg0_110, "icon_bg/icon"))
	setActive(findTF(arg0_110, "icon_bg/count_bg"), arg1_110.count > 0)
	setText(findTF(arg0_110, "icon_bg/count_bg/count"), arg1_110.count)
	setIslandRarityFrame(arg0_110, arg1_110)
end

function updateIslandCardDiy(arg0_111, arg1_111)
	GetImageSpriteFromAtlasAsync(arg1_111:getIcon(), "", findTF(arg0_111, "icon_bg/icon"))
	setActive(findTF(arg0_111, "icon_bg/count_bg"), arg1_111.count > 0)
	setText(findTF(arg0_111, "icon_bg/count_bg/count"), arg1_111.count)
	setIconName(arg0_111, arg1_111:getConfigTable().name, {})
	setIslandRarityFrame(arg0_111, arg1_111)
end

function updateIslandSpeedupTicket(arg0_112, arg1_112)
	local var0_112 = arg1_112:getConfigTable().icon

	GetImageSpriteFromAtlasAsync("island/" .. var0_112, "", findTF(arg0_112, "icon_bg/icon"))
	setActive(findTF(arg0_112, "icon_bg/count_bg"), arg1_112.count > 0)
	setText(findTF(arg0_112, "icon_bg/count_bg/count"), arg1_112.count)
	setIconName(arg0_112, arg1_112:getConfigTable().name, {})
	setIslandRarityFrame(arg0_112, arg1_112)
end

function updateIslandWatherCollect(arg0_113, arg1_113)
	local var0_113 = arg1_113:getConfigTable().icon
	local var1_113 = arg1_113:getConfigTable().name

	setText(findTF(arg0_113, "icon_bg/count"), arg1_113.count)
	GetImageSpriteFromAtlasAsync("island/" .. var0_113, "", findTF(arg0_113, "icon_bg/icon"))
	setIconName(arg0_113, var1_113, {})
	setIslandRarityFrame(arg0_113, arg1_113)
end

function updateWorldItem(arg0_114, arg1_114, arg2_114)
	arg2_114 = arg2_114 or {}

	local var0_114 = ItemRarity.Rarity2Print(arg1_114:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_114, findTF(arg0_114, "icon_bg"))
	setFrame(findTF(arg0_114, "icon_bg/frame"), var0_114)

	local var1_114 = findTF(arg0_114, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_114.icon or arg1_114:getConfig("icon"), "", var1_114)
	setIconStars(arg0_114, false)
	setIconName(arg0_114, arg1_114:getConfig("name"), arg2_114)
	setIconColorful(arg0_114, arg1_114:getConfig("rarity"), arg2_114)
end

function updateWorldCollection(arg0_115, arg1_115, arg2_115)
	arg2_115 = arg2_115 or {}

	assert(arg1_115:getConfigTable(), "world_collection_file_template 和 world_collection_record_template 表中找不到配置: " .. arg1_115.id)

	local var0_115 = arg1_115:getDropRarity()
	local var1_115 = ItemRarity.Rarity2Print(var0_115)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_115, findTF(arg0_115, "icon_bg"))
	setFrame(findTF(arg0_115, "icon_bg/frame"), var1_115)

	local var2_115 = findTF(arg0_115, "icon_bg/icon")
	local var3_115 = WorldCollectionProxy.GetCollectionType(arg1_115.id) == WorldCollectionProxy.WorldCollectionType.FILE and "shoucangguangdie" or "shoucangjiaojuan"

	GetImageSpriteFromAtlasAsync("props/" .. var3_115, "", var2_115)
	setIconStars(arg0_115, false)
	setIconName(arg0_115, arg1_115:getName(), arg2_115)
	setIconColorful(arg0_115, var0_115, arg2_115)
end

function updateWorldBuff(arg0_116, arg1_116, arg2_116)
	arg2_116 = arg2_116 or {}

	local var0_116 = pg.world_SLGbuff_data[arg1_116]

	assert(var0_116, "找不到大世界buff配置: " .. arg1_116)

	local var1_116 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_116, findTF(arg0_116, "icon_bg"))
	setFrame(findTF(arg0_116, "icon_bg/frame"), var1_116)

	local var2_116 = findTF(arg0_116, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("world/buff/" .. var0_116.icon, "", var2_116)

	local var3_116 = arg0_116:Find("icon_bg/stars")

	if not IsNil(var3_116) then
		setActive(var3_116, false)
	end

	local var4_116 = findTF(arg0_116, "name")

	if not IsNil(var4_116) then
		setText(var4_116, var0_116.name)
	end

	local var5_116 = findTF(arg0_116, "icon_bg/count")

	if not IsNil(var5_116) then
		SetActive(var5_116, false)
	end
end

function updateShip(arg0_117, arg1_117, arg2_117)
	arg2_117 = arg2_117 or {}

	local var0_117 = arg1_117:rarity2bgPrint()
	local var1_117 = arg1_117:getPainting()

	if arg2_117.anonymous then
		var0_117 = "1"
		var1_117 = "unknown"
	end

	if arg2_117.unknown_small then
		var1_117 = "unknown_small"
	end

	local var2_117 = findTF(arg0_117, "icon_bg/new")

	if var2_117 then
		if arg2_117.isSkin then
			setActive(var2_117, not arg2_117.isTimeLimit and arg2_117.isNew)
		else
			setActive(var2_117, arg1_117.virgin)
		end
	end

	local var3_117 = findTF(arg0_117, "icon_bg/timelimit")

	if var3_117 then
		setActive(var3_117, arg2_117.isTimeLimit)
	end

	local var4_117 = findTF(arg0_117, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. (arg2_117.isSkin and "_skin" or var0_117), var4_117)

	local var5_117 = findTF(arg0_117, "icon_bg/frame")
	local var6_117

	if arg1_117.isNpc then
		var6_117 = "frame_npc"
	elseif arg1_117:ShowPropose() then
		var6_117 = "frame_prop"

		if arg1_117:isMetaShip() then
			var6_117 = var6_117 .. "_meta"
		end
	elseif arg2_117.isSkin then
		var6_117 = "frame_skin"
	end

	setFrame(var5_117, var0_117, var6_117)

	if arg2_117.gray then
		setGray(var4_117, true, true)
	end

	local var7_117 = findTF(arg0_117, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg2_117.Q and "QIcon/" or "SquareIcon/") .. var1_117, "", var7_117)

	local var8_117 = findTF(arg0_117, "icon_bg/lv")

	if var8_117 then
		setActive(var8_117, not arg1_117.isNpc)

		if not arg1_117.isNpc then
			local var9_117 = findTF(var8_117, "Text")

			if var9_117 and arg1_117.level then
				setText(var9_117, arg1_117.level)
			end
		end
	end

	local var10_117 = findTF(arg0_117, "ship_type")

	if var10_117 then
		setActive(var10_117, true)
		setImageSprite(var10_117, GetSpriteFromAtlas("shiptype", shipType2print(arg1_117:getShipType())))
	end

	local var11_117 = var4_117:Find("npc")

	if not IsNil(var11_117) then
		if var2_117 and go(var2_117).activeSelf then
			setActive(var11_117, false)
		else
			setActive(var11_117, arg1_117:isActivityNpc())
		end
	end

	local var12_117 = arg0_117:Find("group_locked")

	if var12_117 then
		setActive(var12_117, not arg2_117.isSkin and not getProxy(CollectionProxy):getShipGroup(arg1_117.groupId))
	end

	setIconStars(arg0_117, arg2_117.initStar, arg1_117:getStar())
	setIconName(arg0_117, arg2_117.isSkin and arg1_117:GetSkinConfig().name or arg1_117:getName(), arg2_117)
	setIconColorful(arg0_117, arg2_117.isSkin and ItemRarity.Gold or arg1_117:getRarity() - 1, arg2_117)
end

function updateCommander(arg0_118, arg1_118, arg2_118)
	arg2_118 = arg2_118 or {}

	local var0_118 = arg1_118:getDropRarity()
	local var1_118 = ItemRarity.Rarity2Print(var0_118)
	local var2_118 = arg1_118:getConfig("painting")

	if arg2_118.anonymous then
		var1_118 = 1
		var2_118 = "unknown"
	end

	local var3_118 = findTF(arg0_118, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_118, var3_118)

	local var4_118 = findTF(arg0_118, "icon_bg/frame")

	setFrame(var4_118, var1_118)

	if arg2_118.gray then
		setGray(var3_118, true, true)
	end

	local var5_118 = findTF(arg0_118, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("CommanderIcon/" .. var2_118, "", var5_118)
	setIconStars(arg0_118, arg2_118.initStar, 0)
	setIconName(arg0_118, arg1_118:getName(), arg2_118)
end

function updateStrategy(arg0_119, arg1_119, arg2_119)
	arg2_119 = arg2_119 or {}

	local var0_119 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_119, findTF(arg0_119, "icon_bg"))
	setFrame(findTF(arg0_119, "icon_bg/frame"), var0_119)

	local var1_119 = findTF(arg0_119, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg1_119.isWorldBuff and "world/buff/" or "strategyicon/") .. arg1_119:getIcon(), "", var1_119)
	setIconStars(arg0_119, false)
	setIconName(arg0_119, arg1_119:getName(), arg2_119)
	setIconColorful(arg0_119, ItemRarity.Gray, arg2_119)
end

function updateFurniture(arg0_120, arg1_120, arg2_120)
	arg2_120 = arg2_120 or {}

	local var0_120 = arg1_120:getDropRarity()
	local var1_120 = ItemRarity.Rarity2Print(var0_120)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_120, findTF(arg0_120, "icon_bg"))
	setFrame(findTF(arg0_120, "icon_bg/frame"), var1_120)

	local var2_120 = findTF(arg0_120, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1_120:getIcon(), "", var2_120)
	setIconStars(arg0_120, false)
	setIconName(arg0_120, arg1_120:getName(), arg2_120)
	setIconColorful(arg0_120, var0_120, arg2_120)
end

function updateSpWeapon(arg0_121, arg1_121, arg2_121)
	arg2_121 = arg2_121 or {}

	assert(arg1_121, "spWeaponVO can not be nil.")
	assert(isa(arg1_121, SpWeapon), "spWeaponVO is not Equipment.")

	local var0_121 = ItemRarity.Rarity2Print(arg1_121:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_121, findTF(arg0_121, "icon_bg"))
	setFrame(findTF(arg0_121, "icon_bg/frame"), var0_121)

	local var1_121 = findTF(arg0_121, "icon_bg/icon")

	var4_0(var1_121, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync(arg1_121:GetIconPath(), "", var1_121)
	setIconStars(arg0_121, true, arg1_121:GetRarity())
	var7_0(arg0_121, arg1_121:GetLevel() - 1)
	setIconName(arg0_121, arg1_121:GetName(), arg2_121)
	setIconCount(arg0_121, arg1_121.count)
	setIconColorful(arg0_121, arg1_121:GetRarity(), arg2_121)
end

function UpdateSpWeaponSlot(arg0_122, arg1_122, arg2_122)
	local var0_122 = ItemRarity.Rarity2Print(arg1_122:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_122, findTF(arg0_122, "Icon/Mask/icon_bg"))

	local var1_122 = findTF(arg0_122, "Icon/Mask/icon_bg/icon")

	arg2_122 = arg2_122 or {
		16,
		16,
		16,
		16
	}

	var4_0(var1_122, arg2_122)
	GetImageSpriteFromAtlasAsync(arg1_122:GetIconPath(), "", var1_122)

	local var2_122 = arg1_122:GetLevel() - 1
	local var3_122 = findTF(arg0_122, "Icon/LV")

	setActive(var3_122, var2_122 > 0)
	setText(findTF(var3_122, "Text"), var2_122)
end

function updateDorm3dIcon(arg0_123, arg1_123)
	local var0_123 = arg1_123:getDropRarityDorm()

	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(var0_123), arg0_123)

	local var1_123 = arg0_123:Find("icon")

	GetImageSpriteFromAtlasAsync(arg1_123:getIcon(), "", var1_123)
	setText(arg0_123:Find("count/Text"), "x" .. arg1_123.count)
	setText(arg0_123:Find("name/Text"), arg1_123:getName())
end

local var8_0

function findCullAndClipWorldRect(arg0_124)
	if #arg0_124 == 0 then
		return false
	end

	local var0_124 = arg0_124[1].canvasRect

	for iter0_124 = 1, #arg0_124 do
		var0_124 = rectIntersect(var0_124, arg0_124[iter0_124].canvasRect)
	end

	if var0_124.width <= 0 or var0_124.height <= 0 then
		return false
	end

	var8_0 = var8_0 or GameObject.Find("UICamera/Canvas").transform

	local var1_124 = var8_0:TransformPoint(Vector3(var0_124.x, var0_124.y, 0))
	local var2_124 = var8_0:TransformPoint(Vector3(var0_124.x + var0_124.width, var0_124.y + var0_124.height, 0))

	return true, Vector4(var1_124.x, var1_124.y, var2_124.x, var2_124.y)
end

function rectIntersect(arg0_125, arg1_125)
	local var0_125 = math.max(arg0_125.x, arg1_125.x)
	local var1_125 = math.min(arg0_125.x + arg0_125.width, arg1_125.x + arg1_125.width)
	local var2_125 = math.max(arg0_125.y, arg1_125.y)
	local var3_125 = math.min(arg0_125.y + arg0_125.height, arg1_125.y + arg1_125.height)

	if var0_125 <= var1_125 and var2_125 <= var3_125 then
		return var0_0.Rect.New(var0_125, var2_125, var1_125 - var0_125, var3_125 - var2_125)
	end

	return var0_0.Rect.New(0, 0, 0, 0)
end

function getDropInfo(arg0_126)
	local var0_126 = {}

	for iter0_126, iter1_126 in ipairs(arg0_126) do
		local var1_126 = Drop.Create(iter1_126)

		var1_126.count = var1_126.count or 1

		if var1_126.type == DROP_TYPE_EMOJI then
			table.insert(var0_126, var1_126:getName())
		else
			table.insert(var0_126, var1_126:getName() .. "x" .. var1_126.count)
		end
	end

	return table.concat(var0_126, "、")
end

function updateDrop(arg0_127, arg1_127, arg2_127)
	Drop.Change(arg1_127)

	arg2_127 = arg2_127 or {}

	local var0_127 = {
		{
			"icon_bg/slv"
		},
		{
			"icon_bg/frame/specialFrame"
		},
		{
			"ship_type",
			DROP_TYPE_SHIP
		},
		{
			"icon_bg/new",
			DROP_TYPE_SHIP
		},
		{
			"icon_bg/npc",
			DROP_TYPE_SHIP
		},
		{
			"group_locked",
			DROP_TYPE_SHIP
		}
	}
	local var1_127

	for iter0_127, iter1_127 in ipairs(var0_127) do
		local var2_127 = arg0_127:Find(iter1_127[1])

		if arg1_127.type ~= iter1_127[2] and not IsNil(var2_127) then
			setActive(var2_127, false)
		end
	end

	if not IsNil(arg0_127:Find("icon_bg/frame")) then
		arg0_127:Find("icon_bg/frame"):GetComponent(typeof(Image)).enabled = true

		setIconColorful(arg0_127, arg1_127:getDropRarity(), arg2_127, {
			[ItemRarity.Gold] = {
				name = "Item_duang5",
				active = function(arg0_128, arg1_128)
					return arg1_128.fromAwardLayer and arg0_128 >= ItemRarity.Gold
				end
			}
		})
		var4_0(findTF(arg0_127, "icon_bg/icon"), {
			2,
			2,
			2,
			2
		})
	end

	arg1_127:UpdateDropTpl(arg0_127, arg2_127)
	setIconCount(arg0_127, arg2_127.count or arg1_127:getCount())
end

function updateCustomDrop(arg0_129, arg1_129, arg2_129)
	Drop.Change(arg1_129)

	arg2_129 = arg2_129 or {}

	arg1_129:UpdateCustomDropTpl(arg0_129, arg2_129)
end

function updateBuff(arg0_130, arg1_130, arg2_130)
	arg2_130 = arg2_130 or {}

	local var0_130 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_130, findTF(arg0_130, "icon_bg"))

	local var1_130 = pg.benefit_buff_template[arg1_130]

	setFrame(findTF(arg0_130, "icon_bg/frame"), var0_130)
	setText(findTF(arg0_130, "icon_bg/count"), 1)

	local var2_130 = findTF(arg0_130, "icon_bg/icon")
	local var3_130 = var1_130.icon

	GetImageSpriteFromAtlasAsync(var3_130, "", var2_130)
	setIconStars(arg0_130, false)
	setIconName(arg0_130, var1_130.name, arg2_130)
	setIconColorful(arg0_130, ItemRarity.Gold, arg2_130)
end

function updateAttire(arg0_131, arg1_131, arg2_131, arg3_131)
	local var0_131 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_131, findTF(arg0_131, "icon_bg"))
	setFrame(findTF(arg0_131, "icon_bg/frame"), var0_131)

	local var1_131 = findTF(arg0_131, "icon_bg/icon")
	local var2_131

	if arg1_131 == AttireConst.TYPE_CHAT_FRAME then
		var2_131 = "chat_frame"
	elseif arg1_131 == AttireConst.TYPE_ICON_FRAME then
		var2_131 = "icon_frame"
	end

	GetImageSpriteFromAtlasAsync("Props/" .. var2_131, "", var1_131)
	setIconName(arg0_131, arg2_131.name, arg3_131)
end

function updateAttireCombatUI(arg0_132, arg1_132, arg2_132, arg3_132)
	local var0_132 = arg2_132.rare

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_132, findTF(arg0_132, "icon_bg"))
	setFrame(findTF(arg0_132, "icon_bg/frame"), var0_132, "frame_battle_ui")

	local var1_132 = findTF(arg0_132, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("Props/" .. arg2_132.display_icon, "", var1_132)
	setIconName(arg0_132, arg2_132.name, arg3_132)
end

function updateActivityMedal(arg0_133, arg1_133, arg2_133)
	local var0_133 = ItemRarity.Rarity2Print(arg1_133.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_133, findTF(arg0_133, "icon_bg"))
	setFrame(findTF(arg0_133, "icon_bg/frame"), var0_133)

	local var1_133 = findTF(arg0_133, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_133.icon, "", var1_133)
	setIconName(arg0_133, arg1_133.name, arg2_133)
end

function updateCover(arg0_134, arg1_134, arg2_134)
	local var0_134 = arg1_134:getDropRarity()

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_134, findTF(arg0_134, "icon_bg"))
	setFrame(findTF(arg0_134, "icon_bg/frame"), var0_134)

	local var1_134 = findTF(arg0_134, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_134:getIcon(), "", var1_134)
	setIconName(arg0_134, arg1_134:getName(), arg2_134)
	setIconStars(arg0_134, false)
end

function updateEmoji(arg0_135, arg1_135, arg2_135)
	local var0_135 = findTF(arg0_135, "icon_bg/icon")
	local var1_135 = "icon_emoji"

	GetImageSpriteFromAtlasAsync("Props/" .. var1_135, "", var0_135)

	local var2_135 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var2_135, findTF(arg0_135, "icon_bg"))
	setFrame(findTF(arg0_135, "icon_bg/frame"), var2_135)
	setIconName(arg0_135, arg1_135.name, arg2_135)
end

function updateEquipmentSkin(arg0_136, arg1_136, arg2_136)
	arg2_136 = arg2_136 or {}

	local var0_136 = EquipmentRarity.Rarity2Print(arg1_136.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_136, findTF(arg0_136, "icon_bg"))
	setFrame(findTF(arg0_136, "icon_bg/frame"), var0_136, "frame_skin")

	local var1_136 = findTF(arg0_136, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. arg1_136.icon, "", var1_136)
	setIconStars(arg0_136, false)
	setIconName(arg0_136, arg1_136.name, arg2_136)
	setIconCount(arg0_136, arg1_136.count)
	setIconColorful(arg0_136, arg1_136.rarity - 1, arg2_136)
end

function NoPosMsgBox(arg0_137, arg1_137, arg2_137, arg3_137)
	local var0_137
	local var1_137 = {}

	if arg1_137 then
		table.insert(var1_137, {
			text = "text_noPos_clear",
			atuoClose = true,
			onCallback = arg1_137
		})
	end

	if arg2_137 then
		table.insert(var1_137, {
			text = "text_noPos_buy",
			atuoClose = true,
			onCallback = arg2_137
		})
	end

	if arg3_137 then
		table.insert(var1_137, {
			text = "text_noPos_intensify",
			atuoClose = true,
			onCallback = arg3_137
		})
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		hideNo = true,
		content = arg0_137,
		custom = var1_137
	})
end

function openDestroyEquip()
	if pg.m02:hasMediator(EquipmentMediator.__cname) then
		local var0_138 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_138 and var0_138.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_138
			})
		else
			pg.m02:sendNotification(EquipmentMediator.BATCHDESTROY_MODE)

			return
		end
	end

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
		warp = StoreHouseConst.WARP_TO_WEAPON,
		mode = StoreHouseConst.DESTROY
	})
end

function OpenSpWeaponPage()
	if pg.m02:hasMediator(EquipmentMediator.__cname) then
		local var0_139 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_139 and var0_139.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_139
			})
		else
			pg.m02:sendNotification(EquipmentMediator.SWITCH_TO_SPWEAPON_PAGE)

			return
		end
	end

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
		warp = StoreHouseConst.WARP_TO_WEAPON,
		mode = StoreHouseConst.SPWEAPON
	})
end

function openDockyardClear()
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
		blockLock = true,
		mode = DockyardScene.MODE_DESTROY,
		leftTopInfo = i18n("word_destroy"),
		selectedMax = getGameset("ship_select_limit")[1],
		onShip = ShipStatus.canDestroyShip,
		ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
			isActivityNpc = true
		})
	})
end

function openDockyardIntensify()
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
		mode = DockyardScene.MODE_OVERVIEW,
		onClick = function(arg0_142, arg1_142)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
				page = 3,
				shipId = arg0_142.id,
				shipVOs = arg1_142
			})
		end
	})
end

function GoShoppingMsgBox(arg0_143, arg1_143, arg2_143)
	if arg2_143 then
		local var0_143 = ""

		for iter0_143, iter1_143 in ipairs(arg2_143) do
			local var1_143 = Item.getConfigData(iter1_143[1])

			var0_143 = var0_143 .. i18n(iter1_143[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var1_143.name, iter1_143[2])

			if iter0_143 < #arg2_143 then
				var0_143 = var0_143 .. i18n("text_noRes_info_tip_link")
			end
		end

		if var0_143 ~= "" then
			arg0_143 = arg0_143 .. "\n" .. i18n("text_noRes_tip", var0_143)
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = arg0_143,
		onYes = function()
			gotoChargeScene(arg1_143, arg2_143)
		end
	})
end

function shoppingBatch(arg0_145, arg1_145, arg2_145, arg3_145, arg4_145)
	local var0_145 = pg.shop_template[arg0_145]

	assert(var0_145, "shop_template中找不到商品id：" .. arg0_145)

	local var1_145 = getProxy(PlayerProxy):getData()[id2res(var0_145.resource_type)]
	local var2_145 = arg1_145.price or var0_145.resource_num
	local var3_145 = math.floor(var1_145 / var2_145)

	var3_145 = var3_145 <= 0 and 1 or var3_145
	var3_145 = arg2_145 ~= nil and arg2_145 < var3_145 and arg2_145 or var3_145

	local var4_145 = true
	local var5_145 = 1

	if var0_145 ~= nil and arg1_145.id then
		print(var3_145 * var0_145.num, "--", var3_145)
		assert(Item.getConfigData(arg1_145.id), "item config should be existence")

		local var6_145 = Item.New({
			id = arg1_145.id
		}):getConfig("name")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			needCounter = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_ITEM,
				id = arg1_145.id
			},
			addNum = var0_145.num,
			maxNum = var3_145 * var0_145.num,
			defaultNum = var0_145.num,
			numUpdate = function(arg0_146, arg1_146)
				var5_145 = math.floor(arg1_146 / var0_145.num)

				local var0_146 = var5_145 * var2_145

				if var0_146 > var1_145 then
					setText(arg0_146, i18n(arg3_145, var0_146, arg1_146, COLOR_RED, var6_145))

					var4_145 = false
				else
					setText(arg0_146, i18n(arg3_145, var0_146, arg1_146, COLOR_GREEN, var6_145))

					var4_145 = true
				end
			end,
			onYes = function()
				if var4_145 then
					pg.m02:sendNotification(GAME.SHOPPING, {
						id = arg0_145,
						count = var5_145
					})
				elseif arg4_145 then
					pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_145))
					pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_OR_SKIN_FAILD)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("main_playerInfoLayer_error_changeNameNoGem"))
				end
			end
		})
	end
end

function shoppingBatchNewStyle(arg0_148, arg1_148, arg2_148, arg3_148, arg4_148)
	local var0_148 = pg.shop_template[arg0_148]

	assert(var0_148, "shop_template中找不到商品id：" .. arg0_148)

	local var1_148 = getProxy(PlayerProxy):getData()[id2res(var0_148.resource_type)]
	local var2_148 = arg1_148.price or var0_148.resource_num
	local var3_148 = math.floor(var1_148 / var2_148)

	var3_148 = var3_148 <= 0 and 1 or var3_148
	var3_148 = arg2_148 ~= nil and arg2_148 < var3_148 and arg2_148 or var3_148

	local var4_148 = true
	local var5_148 = 1

	if var0_148 ~= nil and arg1_148.id then
		print(var3_148 * var0_148.num, "--", var3_148)
		assert(Item.getConfigData(arg1_148.id), "item config should be existence")

		local var6_148 = Item.New({
			id = arg1_148.id
		}):getConfig("name")

		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_SHOPPING, {
			drop = Drop.New({
				count = 1,
				type = DROP_TYPE_ITEM,
				id = arg1_148.id
			}),
			price = var2_148,
			addNum = var0_148.num,
			maxNum = var3_148 * var0_148.num,
			defaultNum = var0_148.num,
			numUpdate = function(arg0_149, arg1_149)
				var5_148 = math.floor(arg1_149 / var0_148.num)

				local var0_149 = var5_148 * var2_148

				if var0_149 > var1_148 then
					setTextInNewStyleBox(arg0_149, i18n(arg3_148, var0_149, arg1_149, COLOR_RED, var6_148))

					var4_148 = false
				else
					setTextInNewStyleBox(arg0_149, i18n(arg3_148, var0_149, arg1_149, "#238C40FF", var6_148))

					var4_148 = true
				end
			end,
			btnList = {
				{
					type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.shopping,
					name = i18n("word_buy"),
					func = function()
						if var4_148 then
							pg.m02:sendNotification(GAME.SHOPPING, {
								id = arg0_148,
								count = var5_148
							})
						elseif arg4_148 then
							pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_148))
						else
							pg.TipsMgr.GetInstance():ShowTips(i18n("main_playerInfoLayer_error_changeNameNoGem"))
						end
					end,
					sound = SFX_CONFIRM
				}
			}
		})
	end
end

function gotoChargeScene(arg0_151, arg1_151)
	local var0_151 = getProxy(ContextProxy)
	local var1_151 = getProxy(ContextProxy):getCurrentContext()

	if instanceof(var1_151.mediator, NewShopMainMediator) then
		var1_151.mediator:getViewComponent():switchSubViewByTogger(arg0_151)
	else
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
			wrap = arg0_151 or ChargeScene.TYPE_ITEM,
			noRes = arg1_151
		})
	end

	pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_OR_SKIN_FAILD)
end

function clearDrop(arg0_152)
	local var0_152 = findTF(arg0_152, "icon_bg")
	local var1_152 = findTF(arg0_152, "icon_bg/frame")
	local var2_152 = findTF(arg0_152, "icon_bg/icon")
	local var3_152 = findTF(arg0_152, "icon_bg/icon/icon")

	clearImageSprite(var0_152)
	clearImageSprite(var1_152)
	clearImageSprite(var2_152)

	if var3_152 then
		clearImageSprite(var3_152)
	end
end

local var9_0 = {
	red = Color.New(1, 0.25, 0.25),
	blue = Color.New(0.11, 0.55, 0.64),
	yellow = Color.New(0.92, 0.52, 0)
}

function updateSkill(arg0_153, arg1_153, arg2_153, arg3_153)
	local var0_153 = findTF(arg0_153, "skill")
	local var1_153 = findTF(arg0_153, "lock")
	local var2_153 = findTF(arg0_153, "unknown")

	if arg1_153 then
		setActive(var0_153, true)
		setActive(var2_153, false)
		setActive(var1_153, not arg2_153)
		LoadImageSpriteAsync("skillicon/" .. arg1_153.icon, findTF(var0_153, "icon"))

		local var3_153 = arg1_153.color or "blue"

		setText(findTF(var0_153, "name"), shortenString(getSkillName(arg1_153.id), arg3_153 or 8))

		local var4_153 = findTF(var0_153, "level")

		setText(var4_153, "LEVEL: " .. (arg2_153 and arg2_153.level or "??"))
		setTextColor(var4_153, var9_0[var3_153])
	else
		setActive(var0_153, false)
		setActive(var2_153, true)
		setActive(var1_153, false)
	end
end

local var10_0 = true

function onBackButton(arg0_154, arg1_154, arg2_154, arg3_154)
	local var0_154 = GetOrAddComponent(arg1_154, "UILongPressTrigger")

	assert(arg2_154, "callback should exist")

	var0_154.longPressThreshold = defaultValue(arg3_154, 1)

	local function var1_154(arg0_155)
		return function()
			if var10_0 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SOUND_BACK)
			end

			local var0_156, var1_156 = arg2_154()

			if var0_156 then
				arg0_155(var1_156)
			end
		end
	end

	local var2_154 = var0_154.onReleased

	pg.DelegateInfo.Add(arg0_154, var2_154)
	var2_154:RemoveAllListeners()
	var2_154:AddListener(var1_154(function(arg0_157)
		arg0_157:emit(BaseUI.ON_BACK)
	end))

	local var3_154 = var0_154.onLongPressed

	pg.DelegateInfo.Add(arg0_154, var3_154)
	var3_154:RemoveAllListeners()
	var3_154:AddListener(var1_154(function(arg0_158)
		arg0_158:emit(BaseUI.ON_HOME)
	end))
end

function GetZeroTime()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)
end

function GetHalfHour()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0, 1800)
end

function GetNextHour(arg0_161)
	local var0_161 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_161, var2_161 = pg.TimeMgr.GetInstance():parseTimeFrom(var0_161)

	return var1_161 * 86400 + (var2_161 + arg0_161) * 3600
end

function GetPerceptualSize(arg0_162, arg1_162)
	local function var0_162(arg0_163)
		if not arg0_163 then
			return 0, 1
		elseif arg0_163 > 240 then
			return 4, 1
		elseif arg0_163 > 225 then
			return 3, 1
		elseif arg0_163 > 192 then
			return 2, 1
		elseif arg0_163 < 126 then
			return 1, arg1_162 or 0.5
		else
			return 1, 1
		end
	end

	if type(arg0_162) == "number" then
		return var0_162(arg0_162)
	end

	local var1_162 = 1
	local var2_162 = 0
	local var3_162 = 0
	local var4_162 = #arg0_162

	while var1_162 <= var4_162 do
		local var5_162 = string.byte(arg0_162, var1_162)
		local var6_162, var7_162 = var0_162(var5_162)

		var1_162 = var1_162 + var6_162
		var2_162 = var2_162 + var7_162
	end

	return var2_162
end

function shortenString(arg0_164, arg1_164, arg2_164)
	local var0_164 = 1
	local var1_164 = 0
	local var2_164 = 0
	local var3_164 = #arg0_164

	while var0_164 <= var3_164 do
		local var4_164 = string.byte(arg0_164, var0_164)
		local var5_164, var6_164 = GetPerceptualSize(var4_164, arg2_164)

		var0_164 = var0_164 + var5_164
		var1_164 = var1_164 + var6_164

		if arg1_164 <= math.ceil(var1_164) then
			var2_164 = var0_164

			break
		end
	end

	if var2_164 == 0 or var3_164 < var2_164 then
		return arg0_164
	end

	return string.sub(arg0_164, 1, var2_164 - 1) .. ".."
end

function shouldShortenString(arg0_165, arg1_165)
	local var0_165 = 1
	local var1_165 = 0
	local var2_165 = 0
	local var3_165 = #arg0_165

	while var0_165 <= var3_165 do
		local var4_165 = string.byte(arg0_165, var0_165)
		local var5_165, var6_165 = GetPerceptualSize(var4_165)

		var0_165 = var0_165 + var5_165
		var1_165 = var1_165 + var6_165

		if arg1_165 <= math.ceil(var1_165) then
			var2_165 = var0_165

			break
		end
	end

	if var2_165 == 0 or var3_165 < var2_165 then
		return false
	end

	return true
end

function nameValidityCheck(arg0_166, arg1_166, arg2_166, arg3_166)
	local var0_166 = true
	local var1_166, var2_166 = utf8_to_unicode(arg0_166)
	local var3_166 = filterEgyUnicode(filterSpecChars(arg0_166))
	local var4_166 = wordVer(arg0_166)

	if not checkSpaceValid(arg0_166) then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_166[1]))

		var0_166 = false
	elseif var4_166 > 0 or var3_166 ~= arg0_166 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_166[4]))

		var0_166 = false
	elseif var2_166 < arg1_166 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_166[2]))

		var0_166 = false
	elseif arg2_166 < var2_166 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_166[3]))

		var0_166 = false
	end

	return var0_166
end

function checkSpaceValid(arg0_167)
	if PLATFORM_CODE == PLATFORM_US then
		return true
	end

	local var0_167 = string.gsub(arg0_167, " ", "")

	return arg0_167 == string.gsub(var0_167, "　", "")
end

function filterSpecChars(arg0_168)
	local var0_168 = {}
	local var1_168 = 0
	local var2_168 = 0
	local var3_168 = 0
	local var4_168 = 1

	while var4_168 <= #arg0_168 do
		local var5_168 = string.byte(arg0_168, var4_168)

		if not var5_168 then
			break
		end

		if var5_168 >= 48 and var5_168 <= 57 or var5_168 >= 65 and var5_168 <= 90 or var5_168 == 95 or var5_168 >= 97 and var5_168 <= 122 then
			table.insert(var0_168, string.char(var5_168))
		elseif var5_168 >= 228 and var5_168 <= 233 then
			local var6_168 = string.byte(arg0_168, var4_168 + 1)
			local var7_168 = string.byte(arg0_168, var4_168 + 2)

			if var6_168 and var7_168 and var6_168 >= 128 and var6_168 <= 191 and var7_168 >= 128 and var7_168 <= 191 then
				var4_168 = var4_168 + 2

				table.insert(var0_168, string.char(var5_168, var6_168, var7_168))

				var1_168 = var1_168 + 1
			end
		elseif var5_168 == 45 or var5_168 == 40 or var5_168 == 41 then
			table.insert(var0_168, string.char(var5_168))
		elseif var5_168 == 194 then
			local var8_168 = string.byte(arg0_168, var4_168 + 1)

			if var8_168 == 183 then
				var4_168 = var4_168 + 1

				table.insert(var0_168, string.char(var5_168, var8_168))

				var1_168 = var1_168 + 1
			end
		elseif var5_168 == 239 then
			local var9_168 = string.byte(arg0_168, var4_168 + 1)
			local var10_168 = string.byte(arg0_168, var4_168 + 2)

			if var9_168 == 188 and (var10_168 == 136 or var10_168 == 137) then
				var4_168 = var4_168 + 2

				table.insert(var0_168, string.char(var5_168, var9_168, var10_168))

				var1_168 = var1_168 + 1
			end
		elseif var5_168 == 206 or var5_168 == 207 then
			local var11_168 = string.byte(arg0_168, var4_168 + 1)

			if var5_168 == 206 and var11_168 >= 177 or var5_168 == 207 and var11_168 <= 134 then
				var4_168 = var4_168 + 1

				table.insert(var0_168, string.char(var5_168, var11_168))

				var1_168 = var1_168 + 1
			end
		elseif var5_168 == 227 and PLATFORM_CODE == PLATFORM_JP then
			local var12_168 = string.byte(arg0_168, var4_168 + 1)
			local var13_168 = string.byte(arg0_168, var4_168 + 2)

			if var12_168 and var13_168 and var12_168 > 128 and var12_168 <= 191 and var13_168 >= 128 and var13_168 <= 191 then
				var4_168 = var4_168 + 2

				table.insert(var0_168, string.char(var5_168, var12_168, var13_168))

				var2_168 = var2_168 + 1
			end
		elseif var5_168 >= 224 and PLATFORM_CODE == PLATFORM_KR then
			local var14_168 = string.byte(arg0_168, var4_168 + 1)
			local var15_168 = string.byte(arg0_168, var4_168 + 2)

			if var14_168 and var15_168 and var14_168 >= 128 and var14_168 <= 191 and var15_168 >= 128 and var15_168 <= 191 then
				var4_168 = var4_168 + 2

				table.insert(var0_168, string.char(var5_168, var14_168, var15_168))

				var3_168 = var3_168 + 1
			end
		elseif PLATFORM_CODE == PLATFORM_US then
			if var4_168 ~= 1 and var5_168 == 32 and string.byte(arg0_168, var4_168 + 1) ~= 32 then
				table.insert(var0_168, string.char(var5_168))
			end

			if var5_168 >= 192 and var5_168 <= 223 then
				local var16_168 = string.byte(arg0_168, var4_168 + 1)

				var4_168 = var4_168 + 1

				if var5_168 == 194 and var16_168 and var16_168 >= 128 then
					table.insert(var0_168, string.char(var5_168, var16_168))
				elseif var5_168 == 195 and var16_168 and var16_168 <= 191 then
					table.insert(var0_168, string.char(var5_168, var16_168))
				end
			end
		end

		var4_168 = var4_168 + 1
	end

	return table.concat(var0_168), var1_168 + var2_168 + var3_168
end

function filterEgyUnicode(arg0_169)
	arg0_169 = string.gsub(arg0_169, "�[�-�][�-�]", "")
	arg0_169 = string.gsub(arg0_169, "�[�-�]", "")

	return arg0_169
end

function shiftPanel(arg0_170, arg1_170, arg2_170, arg3_170, arg4_170, arg5_170, arg6_170, arg7_170, arg8_170)
	arg3_170 = arg3_170 or 0.2

	if arg5_170 then
		LeanTween.cancel(go(arg0_170))
	end

	local var0_170 = rtf(arg0_170)

	arg1_170 = arg1_170 or var0_170.anchoredPosition.x
	arg2_170 = arg2_170 or var0_170.anchoredPosition.y

	local var1_170 = LeanTween.move(var0_170, Vector3(arg1_170, arg2_170, 0), arg3_170)

	arg7_170 = arg7_170 or LeanTweenType.easeInOutSine

	var1_170:setEase(arg7_170)

	if arg4_170 then
		var1_170:setDelay(arg4_170)
	end

	if arg6_170 then
		GetOrAddComponent(arg0_170, "CanvasGroup").blocksRaycasts = false
	end

	var1_170:setOnComplete(System.Action(function()
		if arg8_170 then
			arg8_170()
		end

		if arg6_170 then
			GetOrAddComponent(arg0_170, "CanvasGroup").blocksRaycasts = true
		end
	end))

	return var1_170
end

function TweenValue(arg0_172, arg1_172, arg2_172, arg3_172, arg4_172, arg5_172, arg6_172, arg7_172)
	local var0_172 = LeanTween.value(go(arg0_172), arg1_172, arg2_172, arg3_172):setOnUpdate(System.Action_float(function(arg0_173)
		if arg5_172 then
			arg5_172(arg0_173)
		end
	end)):setOnComplete(System.Action(function()
		if arg6_172 then
			arg6_172()
		end
	end)):setDelay(arg4_172 or 0)

	if arg7_172 and arg7_172 > 0 then
		var0_172:setRepeat(arg7_172)
	end

	return var0_172
end

function rotateAni(arg0_175, arg1_175, arg2_175)
	return LeanTween.rotate(rtf(arg0_175), 360 * arg1_175, arg2_175):setLoopClamp()
end

function blinkAni(arg0_176, arg1_176, arg2_176, arg3_176)
	return LeanTween.alpha(rtf(arg0_176), arg3_176 or 0, arg1_176):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(arg2_176 or 0)
end

function scaleAni(arg0_177, arg1_177, arg2_177, arg3_177)
	return LeanTween.scale(rtf(arg0_177), arg3_177 or 0, arg1_177):setLoopPingPong(arg2_177 or 0)
end

function floatAni(arg0_178, arg1_178, arg2_178, arg3_178)
	local var0_178 = arg0_178.localPosition.y + arg1_178

	return LeanTween.moveY(rtf(arg0_178), var0_178, arg2_178):setLoopPingPong(arg3_178 or 0)
end

local var11_0 = tostring

function tostring(arg0_179)
	if arg0_179 == nil then
		return "nil"
	end

	local var0_179 = var11_0(arg0_179)

	if var0_179 == nil then
		if type(arg0_179) == "table" then
			return "{}"
		end

		return " ~nil"
	end

	return var0_179
end

function wordVer(arg0_180, arg1_180)
	if arg0_180.match(arg0_180, ChatConst.EmojiCodeMatch) then
		return 0, arg0_180
	end

	arg1_180 = arg1_180 or {}

	local var0_180 = filterEgyUnicode(arg0_180)

	if #var0_180 ~= #arg0_180 then
		if arg1_180.isReplace then
			arg0_180 = var0_180
		else
			return 1
		end
	end

	local var1_180 = wordSplit(arg0_180)
	local var2_180 = pg.word_template
	local var3_180 = pg.word_legal_template

	arg1_180.isReplace = arg1_180.isReplace or false
	arg1_180.replaceWord = arg1_180.replaceWord or "*"

	local var4_180 = #var1_180
	local var5_180 = 1
	local var6_180 = ""
	local var7_180 = 0

	while var5_180 <= var4_180 do
		local var8_180, var9_180, var10_180 = wordLegalMatch(var1_180, var3_180, var5_180)

		if var8_180 then
			var5_180 = var9_180
			var6_180 = var6_180 .. var10_180
		else
			local var11_180, var12_180, var13_180 = wordVerMatch(var1_180, var2_180, arg1_180, var5_180, "", false, var5_180, "")

			if var11_180 then
				var5_180 = var12_180
				var7_180 = var7_180 + 1

				if arg1_180.isReplace then
					var6_180 = var6_180 .. var13_180
				end
			else
				if arg1_180.isReplace then
					var6_180 = var6_180 .. var1_180[var5_180]
				end

				var5_180 = var5_180 + 1
			end
		end
	end

	if arg1_180.isReplace then
		return var7_180, var6_180
	else
		return var7_180
	end
end

function wordLegalMatch(arg0_181, arg1_181, arg2_181, arg3_181, arg4_181)
	if arg2_181 > #arg0_181 then
		return arg3_181, arg2_181, arg4_181
	end

	local var0_181 = arg0_181[arg2_181]
	local var1_181 = arg1_181[var0_181]

	arg4_181 = arg4_181 == nil and "" or arg4_181

	if var1_181 then
		if var1_181.this then
			return wordLegalMatch(arg0_181, var1_181, arg2_181 + 1, true, arg4_181 .. var0_181)
		else
			return wordLegalMatch(arg0_181, var1_181, arg2_181 + 1, false, arg4_181 .. var0_181)
		end
	else
		return arg3_181, arg2_181, arg4_181
	end
end

local var12_0 = string.byte("a")
local var13_0 = string.byte("z")
local var14_0 = string.byte("A")
local var15_0 = string.byte("Z")

local function var16_0(arg0_182)
	if not arg0_182 then
		return arg0_182
	end

	local var0_182 = string.byte(arg0_182)

	if var0_182 > 128 then
		return
	end

	if var0_182 >= var12_0 and var0_182 <= var13_0 then
		return string.char(var0_182 - 32)
	elseif var0_182 >= var14_0 and var0_182 <= var15_0 then
		return string.char(var0_182 + 32)
	else
		return arg0_182
	end
end

function wordVerMatch(arg0_183, arg1_183, arg2_183, arg3_183, arg4_183, arg5_183, arg6_183, arg7_183)
	if arg3_183 > #arg0_183 then
		return arg5_183, arg6_183, arg7_183
	end

	local var0_183 = arg0_183[arg3_183]
	local var1_183 = arg1_183[var0_183]

	if var1_183 then
		local var2_183, var3_183, var4_183 = wordVerMatch(arg0_183, var1_183, arg2_183, arg3_183 + 1, arg2_183.isReplace and arg4_183 .. arg2_183.replaceWord or arg4_183, var1_183.this or arg5_183, var1_183.this and arg3_183 + 1 or arg6_183, var1_183.this and (arg2_183.isReplace and arg4_183 .. arg2_183.replaceWord or arg4_183) or arg7_183)

		if var2_183 then
			return var2_183, var3_183, var4_183
		end
	end

	local var5_183 = var16_0(var0_183)
	local var6_183 = arg1_183[var5_183]

	if var5_183 ~= var0_183 and var6_183 then
		local var7_183, var8_183, var9_183 = wordVerMatch(arg0_183, var6_183, arg2_183, arg3_183 + 1, arg2_183.isReplace and arg4_183 .. arg2_183.replaceWord or arg4_183, var6_183.this or arg5_183, var6_183.this and arg3_183 + 1 or arg6_183, var6_183.this and (arg2_183.isReplace and arg4_183 .. arg2_183.replaceWord or arg4_183) or arg7_183)

		if var7_183 then
			return var7_183, var8_183, var9_183
		end
	end

	return arg5_183, arg6_183, arg7_183
end

function wordSplit(arg0_184)
	local var0_184 = {}

	for iter0_184 in arg0_184.gmatch(arg0_184, "[\x01-\x7F�-�][�-�]*") do
		var0_184[#var0_184 + 1] = iter0_184
	end

	return var0_184
end

function contentWrap(arg0_185, arg1_185, arg2_185)
	local var0_185 = LuaHelper.WrapContent(arg0_185, arg1_185, arg2_185)

	return #var0_185 ~= #arg0_185, var0_185
end

function cancelRich(arg0_186)
	local var0_186

	for iter0_186 = 1, 20 do
		local var1_186

		arg0_186, var1_186 = string.gsub(arg0_186, "<([^>]*)>", "%1")

		if var1_186 <= 0 then
			break
		end
	end

	return arg0_186
end

function cancelColorRich(arg0_187)
	local var0_187

	for iter0_187 = 1, 20 do
		local var1_187

		arg0_187, var1_187 = string.gsub(arg0_187, "<color=#[a-zA-Z0-9]+>(.-)</color>", "%1")

		if var1_187 <= 0 then
			break
		end
	end

	return arg0_187
end

function getSkillConfig(arg0_188)
	local var0_188 = pg.buffCfg["buff_" .. arg0_188]

	if not var0_188 then
		return
	end

	local var1_188 = Clone(var0_188)

	var1_188.name = getSkillName(arg0_188)
	var1_188.desc = HXSet.hxLan(var1_188.desc)
	var1_188.desc_get = HXSet.hxLan(var1_188.desc_get)

	_.each(var1_188, function(arg0_189)
		arg0_189.desc = HXSet.hxLan(arg0_189.desc)
	end)

	return var1_188
end

function getSkillName(arg0_190)
	local var0_190 = pg.skill_data_template[arg0_190] or pg.skill_data_display[arg0_190]

	if var0_190 then
		return HXSet.hxLan(var0_190.name)
	else
		return ""
	end
end

function getSkillDescGet(arg0_191, arg1_191)
	local var0_191 = arg1_191 and pg.skill_world_display[arg0_191] and setmetatable({}, {
		__index = function(arg0_192, arg1_192)
			return pg.skill_world_display[arg0_191][arg1_192] or pg.skill_data_template[arg0_191][arg1_192]
		end
	}) or pg.skill_data_template[arg0_191]

	if not var0_191 then
		return ""
	end

	local var1_191 = var0_191.desc_get ~= "" and var0_191.desc_get or var0_191.desc

	for iter0_191, iter1_191 in pairs(var0_191.desc_get_add) do
		local var2_191 = setColorStr(iter1_191[1], COLOR_GREEN)

		if iter1_191[2] then
			var2_191 = var2_191 .. specialGSub(i18n("word_skill_desc_get"), "$1", setColorStr(iter1_191[2], COLOR_GREEN))
		end

		var1_191 = specialGSub(var1_191, "$" .. iter0_191, var2_191)
	end

	return HXSet.hxLan(var1_191)
end

function getSkillDescLearn(arg0_193, arg1_193, arg2_193)
	local var0_193 = arg2_193 and pg.skill_world_display[arg0_193] and setmetatable({}, {
		__index = function(arg0_194, arg1_194)
			return pg.skill_world_display[arg0_193][arg1_194] or pg.skill_data_template[arg0_193][arg1_194]
		end
	}) or pg.skill_data_template[arg0_193]

	if not var0_193 then
		return ""
	end

	local var1_193 = var0_193.desc

	if not var0_193.desc_add then
		return HXSet.hxLan(var1_193)
	end

	for iter0_193, iter1_193 in pairs(var0_193.desc_add) do
		local var2_193 = iter1_193[arg1_193][1]

		if iter1_193[arg1_193][2] then
			var2_193 = var2_193 .. specialGSub(i18n("word_skill_desc_learn"), "$1", iter1_193[arg1_193][2])
		end

		var1_193 = specialGSub(var1_193, "$" .. iter0_193, setColorStr(var2_193, COLOR_YELLOW))
	end

	return HXSet.hxLan(var1_193)
end

function getSkillDesc(arg0_195, arg1_195, arg2_195)
	local var0_195 = arg2_195 and pg.skill_world_display[arg0_195] and setmetatable({}, {
		__index = function(arg0_196, arg1_196)
			return pg.skill_world_display[arg0_195][arg1_196] or pg.skill_data_template[arg0_195][arg1_196]
		end
	}) or pg.skill_data_template[arg0_195]

	if not var0_195 then
		return ""
	end

	local var1_195 = var0_195.desc

	if not var0_195.desc_add then
		return HXSet.hxLan(var1_195)
	end

	for iter0_195, iter1_195 in pairs(var0_195.desc_add) do
		local var2_195 = setColorStr(iter1_195[arg1_195][1], COLOR_GREEN)

		var1_195 = specialGSub(var1_195, "$" .. iter0_195, var2_195)
	end

	return HXSet.hxLan(var1_195)
end

function specialGSub(arg0_197, arg1_197, arg2_197)
	arg0_197 = string.gsub(arg0_197, "<color=#", "<color=NNN")
	arg0_197 = string.gsub(arg0_197, "#", "")
	arg2_197 = string.gsub(arg2_197, "%%", "%%%%")
	arg0_197 = string.gsub(arg0_197, arg1_197, arg2_197)
	arg0_197 = string.gsub(arg0_197, "<color=NNN", "<color=#")

	return arg0_197
end

function topAnimation(arg0_198, arg1_198, arg2_198, arg3_198, arg4_198, arg5_198)
	local var0_198 = {}

	arg4_198 = arg4_198 or 0.27

	local var1_198 = 0.05

	if arg0_198 then
		local var2_198 = arg0_198.transform.localPosition.x

		setAnchoredPosition(arg0_198, {
			x = var2_198 - 500
		})
		shiftPanel(arg0_198, var2_198, nil, 0.05, arg4_198, true, true)
		setActive(arg0_198, true)
	end

	setActive(arg1_198, false)
	setActive(arg2_198, false)
	setActive(arg3_198, false)

	for iter0_198 = 1, 3 do
		table.insert(var0_198, LeanTween.delayedCall(arg4_198 + 0.13 + var1_198 * iter0_198, System.Action(function()
			if arg1_198 then
				setActive(arg1_198, not arg1_198.gameObject.activeSelf)
			end
		end)).uniqueId)
		table.insert(var0_198, LeanTween.delayedCall(arg4_198 + 0.02 + var1_198 * iter0_198, System.Action(function()
			if arg2_198 then
				setActive(arg2_198, not go(arg2_198).activeSelf)
			end

			if arg2_198 then
				setActive(arg3_198, not go(arg3_198).activeSelf)
			end
		end)).uniqueId)
	end

	if arg5_198 then
		table.insert(var0_198, LeanTween.delayedCall(arg4_198 + 0.13 + var1_198 * 3 + 0.1, System.Action(function()
			arg5_198()
		end)).uniqueId)
	end

	return var0_198
end

function cancelTweens(arg0_202)
	assert(arg0_202, "must provide cancel targets, LeanTween.cancelAll is not allow")

	for iter0_202, iter1_202 in ipairs(arg0_202) do
		if iter1_202 then
			LeanTween.cancel(iter1_202)
		end
	end
end

function getOfflineTimeStamp(arg0_203)
	local var0_203 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_203
	local var1_203 = ""

	if var0_203 <= 59 then
		var1_203 = i18n("just_now")
	elseif var0_203 <= 3599 then
		var1_203 = i18n("several_minutes_before", math.floor(var0_203 / 60))
	elseif var0_203 <= 86399 then
		var1_203 = i18n("several_hours_before", math.floor(var0_203 / 3600))
	else
		var1_203 = i18n("several_days_before", math.floor(var0_203 / 86400))
	end

	return var1_203
end

function playMovie(arg0_204, arg1_204, arg2_204)
	local var0_204 = GameObject.Find("OverlayCamera/Overlay/UITop/MoviePanel")

	if not IsNil(var0_204) then
		pg.UIMgr.GetInstance():LoadingOn()
		WWWLoader.Inst:LoadStreamingAsset(arg0_204, function(arg0_205)
			pg.UIMgr.GetInstance():LoadingOff()

			local var0_205 = GCHandle.Alloc(arg0_205, GCHandleType.Pinned)

			setActive(var0_204, true)

			local var1_205 = var0_204:AddComponent(typeof(CriManaMovieControllerForUI))

			var1_205.player:SetData(arg0_205, arg0_205.Length)

			var1_205.target = var0_204:GetComponent(typeof(Image))
			var1_205.loop = false
			var1_205.additiveMode = false
			var1_205.playOnStart = true

			local var2_205

			var2_205 = Timer.New(function()
				if var1_205.player.status == CriMana.Player.Status.PlayEnd or var1_205.player.status == CriMana.Player.Status.Stop or var1_205.player.status == CriMana.Player.Status.Error then
					var2_205:Stop()
					Object.Destroy(var1_205)
					GCHandle.Free(var0_205)
					setActive(var0_204, false)

					if arg1_204 then
						arg1_204()
					end
				end
			end, 0.2, -1)

			var2_205:Start()
			removeOnButton(var0_204)

			if arg2_204 then
				onButton(nil, var0_204, function()
					var1_205:Stop()
					GetOrAddComponent(var0_204, typeof(Button)).onClick:RemoveAllListeners()
				end, SFX_CANCEL)
			end
		end)
	elseif arg1_204 then
		arg1_204()
	end
end

PaintCameraAdjustOn = false

function cameraPaintViewAdjust(arg0_208)
	if PaintCameraAdjustOn ~= arg0_208 then
		local var0_208 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(CanvasScaler))

		if arg0_208 then
			var0_208.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight
			var0_208.matchWidthOrHeight = 1
		else
			var0_208.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand
		end

		pg.CameraFixMgr.GetInstance():BlockCameraRatioControll(arg0_208)

		PaintCameraAdjustOn = arg0_208
	end
end

function ManhattonDist(arg0_209, arg1_209)
	return math.abs(arg0_209.row - arg1_209.row) + math.abs(arg0_209.column - arg1_209.column)
end

function checkFirstHelpShow(arg0_210)
	local var0_210 = getProxy(SettingsProxy)

	if not var0_210:checkReadHelp(arg0_210) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[arg0_210].tip
		})
		var0_210:recordReadHelp(arg0_210)
	end
end

preOrientation = nil
preNotchFitterEnabled = false

function openPortrait(arg0_211)
	preOrientation = Input.deviceOrientation:ToString()

	originalPrint("Begining Orientation:" .. preOrientation)

	Screen.autorotateToPortrait = true
	Screen.autorotateToPortraitUpsideDown = true

	cameraPaintViewAdjust(true)
end

function closePortrait(arg0_212)
	Screen.autorotateToPortrait = false
	Screen.autorotateToPortraitUpsideDown = false

	originalPrint("Closing Orientation:" .. preOrientation)

	Screen.orientation = ScreenOrientation.LandscapeLeft

	local var0_212 = Timer.New(function()
		Screen.orientation = ScreenOrientation.AutoRotation
	end, 0.2, 1):Start()

	cameraPaintViewAdjust(false)
end

function enableNotch(arg0_214, arg1_214)
	if arg0_214 == nil then
		return
	end

	arg0_214:GetComponent("NotchAdapt").enabled = arg1_214
end

function comma_value(arg0_215)
	local var0_215 = arg0_215
	local var1_215 = 0

	repeat
		local var2_215

		var0_215, var2_215 = string.gsub(var0_215, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var2_215 == 0

	return var0_215
end

local var17_0 = 0.2

function SwitchPanel(arg0_216, arg1_216, arg2_216, arg3_216, arg4_216, arg5_216)
	arg3_216 = defaultValue(arg3_216, var17_0)

	if arg5_216 then
		LeanTween.cancel(go(arg0_216))
	end

	local var0_216 = Vector3.New(tf(arg0_216).localPosition.x, tf(arg0_216).localPosition.y, tf(arg0_216).localPosition.z)

	if arg1_216 then
		var0_216.x = arg1_216
	end

	if arg2_216 then
		var0_216.y = arg2_216
	end

	local var1_216 = LeanTween.move(rtf(arg0_216), var0_216, arg3_216):setEase(LeanTweenType.easeInOutSine)

	if arg4_216 then
		var1_216:setDelay(arg4_216)
	end

	return var1_216
end

function updateActivityTaskStatus(arg0_217)
	local var0_217 = arg0_217:getConfig("config_id")
	local var1_217, var2_217 = getActivityTask(arg0_217, true)

	if not var2_217 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_217.id
		})

		return true
	end

	return false
end

function updateCrusingActivityTask(arg0_218)
	local var0_218 = getProxy(TaskProxy)
	local var1_218 = arg0_218:getNDay()
	local var2_218 = pg.TimeMgr.GetInstance():GetServerOverWeek(arg0_218:getStartTime())

	for iter0_218, iter1_218 in ipairs(arg0_218:getConfig("config_data")) do
		local var3_218 = pg.battlepass_task_group[iter1_218]

		if var3_218 and var2_218 >= var3_218.group_mask then
			if underscore.any(underscore.flatten(var3_218.task_group), function(arg0_219)
				return var0_218:getTaskVO(arg0_219) == nil
			end) then
				pg.m02:sendNotification(GAME.CRUSING_CMD, {
					cmd = 1,
					activity_id = arg0_218.id
				})

				return true
			end
		elseif not var3_218 then
			warning("battlepass_task_group表中不存在 id = " .. iter1_218)
		end
	end

	return false
end

function setShipCardFrame(arg0_220, arg1_220, arg2_220)
	arg0_220.localScale = Vector3.one
	arg0_220.anchorMin = Vector2.zero
	arg0_220.anchorMax = Vector2.one

	local var0_220 = arg2_220 or arg1_220

	GetImageSpriteFromAtlasAsync("shipframe", var0_220, arg0_220)

	local var1_220 = pg.frame_resource[var0_220]

	if var1_220 then
		local var2_220 = var1_220.param

		arg0_220.offsetMin = Vector2(var2_220[1], var2_220[2])
		arg0_220.offsetMax = Vector2(var2_220[3], var2_220[4])
	else
		arg0_220.offsetMin = Vector2.zero
		arg0_220.offsetMax = Vector2.zero
	end
end

function setRectShipCardFrame(arg0_221, arg1_221, arg2_221)
	arg0_221.localScale = Vector3.one
	arg0_221.anchorMin = Vector2.zero
	arg0_221.anchorMax = Vector2.one

	setImageSprite(arg0_221, GetSpriteFromAtlas("shipframeb", "b" .. (arg2_221 or arg1_221)))

	local var0_221 = "b" .. (arg2_221 or arg1_221)
	local var1_221 = pg.frame_resource[var0_221]

	if var1_221 then
		local var2_221 = var1_221.param

		arg0_221.offsetMin = Vector2(var2_221[1], var2_221[2])
		arg0_221.offsetMax = Vector2(var2_221[3], var2_221[4])
	else
		arg0_221.offsetMin = Vector2.zero
		arg0_221.offsetMax = Vector2.zero
	end
end

function setFrameEffect(arg0_222, arg1_222)
	if arg1_222 then
		local var0_222 = arg1_222 .. "(Clone)"
		local var1_222 = false

		eachChild(arg0_222, function(arg0_223)
			setActive(arg0_223, arg0_223.name == var0_222)

			var1_222 = var1_222 or arg0_223.name == var0_222
		end)

		if not var1_222 then
			LoadAndInstantiateAsync("effect", arg1_222, function(arg0_224)
				if IsNil(arg0_222) or findTF(arg0_222, var0_222) then
					Object.Destroy(arg0_224)
				else
					setParent(arg0_224, arg0_222)
					setActive(arg0_224, true)
				end
			end)
		end
	end

	setActive(arg0_222, arg1_222)
end

function setProposeMarkIcon(arg0_225, arg1_225)
	local var0_225 = arg0_225:Find("proposeShipCard(Clone)")
	local var1_225 = arg1_225.propose and not arg1_225:ShowPropose()

	if var0_225 then
		setActive(var0_225, var1_225)
	elseif var1_225 then
		pg.PoolMgr.GetInstance():GetUI("proposeShipCard", true, function(arg0_226)
			if IsNil(arg0_225) or arg0_225:Find("proposeShipCard(Clone)") then
				pg.PoolMgr.GetInstance():ReturnUI("proposeShipCard", arg0_226)
			else
				setParent(arg0_226, arg0_225, false)
			end
		end)
	end
end

function flushShipCard(arg0_227, arg1_227)
	local var0_227 = arg1_227:rarity2bgPrint()
	local var1_227 = findTF(arg0_227, "content/bg")

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var0_227, "", var1_227)

	local var2_227 = findTF(arg0_227, "content/ship_icon")
	local var3_227 = arg1_227 and {
		"shipYardIcon/" .. arg1_227:getPainting(),
		arg1_227:getPainting()
	} or {
		"shipYardIcon/unknown",
		""
	}

	GetImageSpriteFromAtlasAsync(var3_227[1], var3_227[2], var2_227)

	local var4_227 = arg1_227:getShipType()
	local var5_227 = findTF(arg0_227, "content/info/top/type")

	GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var4_227), var5_227)
	setText(findTF(arg0_227, "content/dockyard/lv/Text"), defaultValue(arg1_227.level, 1))

	local var6_227 = arg1_227:getStar()
	local var7_227 = arg1_227:getMaxStar()
	local var8_227 = findTF(arg0_227, "content/front/stars")

	setActive(var8_227, true)

	local var9_227 = findTF(var8_227, "star_tpl")
	local var10_227 = var8_227.childCount

	for iter0_227 = 1, Ship.CONFIG_MAX_STAR do
		local var11_227 = var10_227 < iter0_227 and cloneTplTo(var9_227, var8_227) or var8_227:GetChild(iter0_227 - 1)

		setActive(var11_227, iter0_227 <= var7_227)
		triggerToggle(var11_227, iter0_227 <= var6_227)
	end

	local var12_227 = findTF(arg0_227, "content/front/frame")
	local var13_227, var14_227 = arg1_227:GetFrameAndEffect()

	setShipCardFrame(var12_227, var0_227, var13_227)
	setFrameEffect(findTF(arg0_227, "content/front/bg_other"), var14_227)
	setProposeMarkIcon(arg0_227:Find("content/dockyard/propose"), arg1_227)
end

function TweenItemAlphaAndWhite(arg0_228)
	LeanTween.cancel(arg0_228)

	local var0_228 = GetOrAddComponent(arg0_228, "CanvasGroup")

	var0_228.alpha = 0

	LeanTween.alphaCanvas(var0_228, 1, 0.2):setUseEstimatedTime(true)

	local var1_228 = findTF(arg0_228.transform, "white_mask")

	if var1_228 then
		setActive(var1_228, false)
	end
end

function ClearTweenItemAlphaAndWhite(arg0_229)
	LeanTween.cancel(arg0_229)

	GetOrAddComponent(arg0_229, "CanvasGroup").alpha = 0
end

function getGroupOwnSkins(arg0_230)
	local var0_230 = {}
	local var1_230 = getProxy(ShipSkinProxy):getSkinList()
	local var2_230 = getProxy(CollectionProxy):getShipGroup(arg0_230)

	if var2_230 then
		local var3_230 = ShipGroup.getSkinList(arg0_230)

		for iter0_230, iter1_230 in ipairs(var3_230) do
			if iter1_230.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var1_230, iter1_230.id) or iter1_230.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var2_230.trans or iter1_230.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var2_230.married == 1 then
				var0_230[iter1_230.id] = true
			end
		end
	end

	return var0_230
end

function split(arg0_231, arg1_231)
	local var0_231 = {}

	if not arg0_231 then
		return nil
	end

	local var1_231 = #arg0_231
	local var2_231 = 1

	while var2_231 <= var1_231 do
		local var3_231 = string.find(arg0_231, arg1_231, var2_231)

		if var3_231 == nil then
			table.insert(var0_231, string.sub(arg0_231, var2_231, var1_231))

			break
		end

		table.insert(var0_231, string.sub(arg0_231, var2_231, var3_231 - 1))

		if var3_231 == var1_231 then
			table.insert(var0_231, "")

			break
		end

		var2_231 = var3_231 + 1
	end

	return var0_231
end

function NumberToChinese(arg0_232, arg1_232)
	local var0_232 = ""
	local var1_232 = #arg0_232

	for iter0_232 = 1, var1_232 do
		local var2_232 = string.sub(arg0_232, iter0_232, iter0_232)

		if var2_232 ~= "0" or var2_232 == "0" and not arg1_232 then
			if arg1_232 then
				if var1_232 >= 2 then
					if iter0_232 == 1 then
						if var2_232 == "1" then
							var0_232 = i18n("number_" .. 10)
						else
							var0_232 = i18n("number_" .. var2_232) .. i18n("number_" .. 10)
						end
					else
						var0_232 = var0_232 .. i18n("number_" .. var2_232)
					end
				else
					var0_232 = var0_232 .. i18n("number_" .. var2_232)
				end
			else
				var0_232 = var0_232 .. i18n("number_" .. var2_232)
			end
		end
	end

	return var0_232
end

function getActivityTask(arg0_233, arg1_233)
	local var0_233 = getProxy(TaskProxy)
	local var1_233 = arg0_233:getConfig("config_data")
	local var2_233 = arg0_233:getNDay(arg0_233.data1)
	local var3_233
	local var4_233
	local var5_233

	for iter0_233 = math.max(arg0_233.data3, 1), math.min(var2_233, #var1_233) do
		local var6_233 = _.flatten({
			var1_233[iter0_233]
		})

		for iter1_233, iter2_233 in ipairs(var6_233) do
			local var7_233 = var0_233:getTaskById(iter2_233)

			if var7_233 then
				return var7_233.id, var7_233
			end

			if var4_233 then
				var5_233 = var0_233:getFinishTaskById(iter2_233)

				if var5_233 then
					var4_233 = var5_233
				elseif arg1_233 then
					return iter2_233
				else
					return var4_233.id, var4_233
				end
			else
				var4_233 = var0_233:getFinishTaskById(iter2_233)
				var5_233 = var5_233 or iter2_233
			end
		end
	end

	if var4_233 then
		return var4_233.id, var4_233
	else
		return var5_233
	end
end

function setImageFromImage(arg0_234, arg1_234, arg2_234)
	local var0_234 = GetComponent(arg0_234, "Image")

	var0_234.sprite = GetComponent(arg1_234, "Image").sprite

	if arg2_234 then
		var0_234:SetNativeSize()
	end
end

function skinTimeStamp(arg0_235)
	local var0_235, var1_235, var2_235, var3_235 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_235)

	if var0_235 >= 1 then
		return i18n("limit_skin_time_day", var0_235)
	elseif var0_235 <= 0 and var1_235 > 0 then
		return i18n("limit_skin_time_day_min", var1_235, var2_235)
	elseif var0_235 <= 0 and var1_235 <= 0 and (var2_235 > 0 or var3_235 > 0) then
		return i18n("limit_skin_time_min", math.max(var2_235, 1))
	elseif var0_235 <= 0 and var1_235 <= 0 and var2_235 <= 0 and var3_235 <= 0 then
		return i18n("limit_skin_time_overtime")
	end
end

function skinCommdityTimeStamp(arg0_236)
	local var0_236 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_236 = math.max(arg0_236 - var0_236, 0)
	local var2_236 = math.floor(var1_236 / 86400)

	if var2_236 > 0 then
		return i18n("time_remaining_tip") .. var2_236 .. i18n("word_date")
	else
		local var3_236 = math.floor(var1_236 / 3600)

		if var3_236 > 0 then
			return i18n("time_remaining_tip") .. var3_236 .. i18n("word_hour")
		else
			local var4_236 = math.floor(var1_236 / 60)

			if var4_236 > 0 then
				return i18n("time_remaining_tip") .. var4_236 .. i18n("word_minute")
			else
				return i18n("time_remaining_tip") .. var1_236 .. i18n("word_second")
			end
		end
	end
end

function InstagramTimeStamp(arg0_237)
	local var0_237 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_237
	local var1_237 = var0_237 / 86400

	if var1_237 > 1 then
		return i18n("ins_word_day", math.floor(var1_237))
	else
		local var2_237 = var0_237 / 3600

		if var2_237 > 1 then
			return i18n("ins_word_hour", math.floor(var2_237))
		else
			local var3_237 = var0_237 / 60

			if var3_237 > 1 then
				return i18n("ins_word_minu", math.floor(var3_237))
			else
				return i18n("ins_word_minu", 1)
			end
		end
	end
end

function InstagramReplyTimeStamp(arg0_238)
	local var0_238 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_238
	local var1_238 = var0_238 / 86400

	if var1_238 > 1 then
		return i18n1(math.floor(var1_238) .. "d")
	else
		local var2_238 = var0_238 / 3600

		if var2_238 > 1 then
			return i18n1(math.floor(var2_238) .. "h")
		else
			local var3_238 = var0_238 / 60

			if var3_238 > 1 then
				return i18n1(math.floor(var3_238) .. "min")
			else
				return i18n1("1min")
			end
		end
	end
end

function attireTimeStamp(arg0_239)
	local var0_239, var1_239, var2_239, var3_239 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_239)

	if var0_239 <= 0 and var1_239 <= 0 and var2_239 <= 0 and var3_239 <= 0 then
		return i18n("limit_skin_time_overtime")
	else
		return i18n("attire_time_stamp", var0_239, var1_239, var2_239)
	end
end

function checkExist(arg0_240, ...)
	local var0_240 = {
		...
	}

	for iter0_240, iter1_240 in ipairs(var0_240) do
		if arg0_240 == nil then
			break
		end

		assert(type(arg0_240) == "table", "type error : intermediate target should be table")
		assert(type(iter1_240) == "table", "type error : param should be table")

		if type(arg0_240[iter1_240[1]]) == "function" then
			arg0_240 = arg0_240[iter1_240[1]](arg0_240, unpack(iter1_240[2] or {}))
		else
			arg0_240 = arg0_240[iter1_240[1]]
		end
	end

	return arg0_240
end

function AcessWithinNull(arg0_241, arg1_241)
	if arg0_241 == nil then
		return
	end

	assert(type(arg0_241) == "table")

	return arg0_241[arg1_241]
end

function showRepairMsgbox()
	local var0_242 = {
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var1_242 = {
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var2_242 = {
		text = i18n("msgbox_repair_painting"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-painting.csv") then
				BundleWizard.Inst:GetGroupMgr("PAINTING"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		hideNo = true,
		content = i18n("resource_verify_warn"),
		custom = {
			var2_242,
			var1_242,
			var0_242
		}
	})
end

function resourceVerify(arg0_246, arg1_246)
	if CSharpVersion > 35 then
		BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()

		return
	end

	local var0_246 = Application.persistentDataPath .. "/hashes.csv"
	local var1_246
	local var2_246 = PathMgr.ReadAllLines(var0_246)
	local var3_246 = {}

	if arg0_246 then
		setActive(arg0_246, true)
	else
		pg.UIMgr.GetInstance():LoadingOn()
	end

	local function var4_246()
		if arg0_246 then
			setActive(arg0_246, false)
		else
			pg.UIMgr.GetInstance():LoadingOff()
		end

		print(var1_246)

		if var1_246 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("resource_verify_fail", ""),
				onYes = function()
					VersionMgr.Inst:DeleteCacheFiles()
					Application.Quit()
				end
			})
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("resource_verify_success")
			})
		end
	end

	local var5_246 = var2_246.Length
	local var6_246

	local function var7_246(arg0_249)
		if arg0_249 < 0 then
			var4_246()

			return
		end

		if arg1_246 then
			setSlider(arg1_246, 0, var5_246, var5_246 - arg0_249)
		end

		local var0_249 = string.split(var2_246[arg0_249], ",")
		local var1_249 = var0_249[1]
		local var2_249 = var0_249[3]
		local var3_249 = PathMgr.getAssetBundle(var1_249)

		if PathMgr.FileExists(var3_249) then
			local var4_249 = PathMgr.ReadAllBytes(PathMgr.getAssetBundle(var1_249))

			if var2_249 == HashUtil.CalcMD5(var4_249) then
				onNextTick(function()
					var7_246(arg0_249 - 1)
				end)

				return
			end
		end

		var1_246 = var1_249

		var4_246()
	end

	var7_246(var5_246 - 1)
end

function splitByWordEN(arg0_251, arg1_251)
	local var0_251 = string.split(arg0_251, " ")
	local var1_251 = ""
	local var2_251 = ""
	local var3_251 = arg1_251:GetComponent(typeof(RectTransform))
	local var4_251 = arg1_251:GetComponent(typeof(Text))
	local var5_251 = var3_251.rect.width

	for iter0_251, iter1_251 in ipairs(var0_251) do
		local var6_251 = var2_251

		var2_251 = var2_251 == "" and iter1_251 or var2_251 .. " " .. iter1_251

		setText(arg1_251, var2_251)

		if var5_251 < var4_251.preferredWidth then
			var1_251 = var1_251 == "" and var6_251 or var1_251 .. "\n" .. var6_251
			var2_251 = iter1_251
		end

		if iter0_251 >= #var0_251 then
			var1_251 = var1_251 == "" and var2_251 or var1_251 .. "\n" .. var2_251
		end
	end

	return var1_251
end

function checkBirthFormat(arg0_252)
	if #arg0_252 ~= 8 then
		return false
	end

	local var0_252 = 0
	local var1_252 = #arg0_252

	while var0_252 < var1_252 do
		local var2_252 = string.byte(arg0_252, var0_252 + 1)

		if var2_252 < 48 or var2_252 > 57 then
			return false
		end

		var0_252 = var0_252 + 1
	end

	return true
end

function isHalfBodyLive2D(arg0_253)
	local var0_253 = {
		"biaoqiang",
		"z23",
		"lafei",
		"lingbo",
		"mingshi",
		"xuefeng"
	}

	return _.any(var0_253, function(arg0_254)
		return arg0_254 == arg0_253
	end)
end

function GetServerState(arg0_255)
	local var0_255 = -1
	local var1_255 = 0
	local var2_255 = 1
	local var3_255 = 2
	local var4_255 = NetConst.GetServerStateUrl()

	if PLATFORM_CODE == PLATFORM_CH then
		var4_255 = string.gsub(var4_255, "https", "http")
	end

	VersionMgr.Inst:WebRequest(var4_255, function(arg0_256, arg1_256)
		local var0_256 = true
		local var1_256 = false

		for iter0_256 in string.gmatch(arg1_256, "\"state\":%d") do
			if iter0_256 ~= "\"state\":1" then
				var0_256 = false
			end

			var1_256 = true
		end

		if not var1_256 then
			var0_256 = false
		end

		if arg0_255 ~= nil then
			arg0_255(var0_256 and var2_255 or var1_255)
		end
	end)
end

function setScrollText(arg0_257, arg1_257)
	GetOrAddComponent(arg0_257, "ScrollText"):SetText(arg1_257)
end

function changeToScrollText(arg0_258, arg1_258)
	local var0_258 = GetComponent(arg0_258, typeof(Text))

	assert(var0_258, "without component<Text>")

	local var1_258 = arg0_258:Find("subText")

	if not var1_258 then
		var1_258 = cloneTplTo(arg0_258, arg0_258, "subText")

		eachChild(arg0_258, function(arg0_259)
			setActive(arg0_259, arg0_259 == var1_258)
		end)

		arg0_258:GetComponent(typeof(Text)).enabled = false
	end

	setScrollText(var1_258, arg1_258)
end

local var18_0
local var19_0
local var20_0
local var21_0

local function var22_0(arg0_260, arg1_260, arg2_260)
	local var0_260 = arg0_260:Find("base")
	local var1_260, var2_260, var3_260 = Equipment.GetInfoTrans(arg1_260, arg2_260)

	if arg1_260.nextValue then
		local var4_260 = {
			name = arg1_260.name,
			type = arg1_260.type,
			value = arg1_260.nextValue
		}
		local var5_260, var6_260 = Equipment.GetInfoTrans(var4_260, arg2_260)

		var2_260 = var2_260 .. setColorStr("   >   " .. var6_260, COLOR_GREEN)
	end

	setText(var0_260:Find("name"), var1_260)

	if var3_260 then
		local var7_260 = "<color=#afff72>(+" .. ys.Battle.BattleConst.UltimateBonus.AuxBoostValue * 100 .. "%)</color>"

		setText(var0_260:Find("value"), var2_260 .. var7_260)
	else
		setText(var0_260:Find("value"), var2_260)
	end

	setActive(var0_260:Find("value/up"), arg1_260.compare and arg1_260.compare > 0)
	setActive(var0_260:Find("value/down"), arg1_260.compare and arg1_260.compare < 0)
	triggerToggle(var0_260, arg1_260.lock_open)

	if not arg1_260.lock_open and arg1_260.sub and #arg1_260.sub > 0 then
		GetComponent(var0_260, typeof(Toggle)).enabled = true
	else
		setActive(var0_260:Find("name/close"), false)
		setActive(var0_260:Find("name/open"), false)

		GetComponent(var0_260, typeof(Toggle)).enabled = false
	end
end

local function var23_0(arg0_261, arg1_261, arg2_261, arg3_261)
	var22_0(arg0_261, arg2_261, arg3_261)

	if not arg2_261.sub or #arg2_261.sub == 0 then
		return
	end

	var20_0(arg0_261:Find("subs"), arg1_261, arg2_261.sub, arg3_261)
end

function var20_0(arg0_262, arg1_262, arg2_262, arg3_262)
	removeAllChildren(arg0_262)
	var21_0(arg0_262, arg1_262, arg2_262, arg3_262)
end

function var21_0(arg0_263, arg1_263, arg2_263, arg3_263)
	for iter0_263, iter1_263 in ipairs(arg2_263) do
		local var0_263 = cloneTplTo(arg1_263, arg0_263)

		var23_0(var0_263, arg1_263, iter1_263, arg3_263)
	end
end

function updateEquipInfo(arg0_264, arg1_264, arg2_264, arg3_264)
	local var0_264 = arg0_264:Find("attr_tpl")

	var20_0(arg0_264:Find("attrs"), var0_264, arg1_264.attrs, arg3_264)
	setActive(arg0_264:Find("skill"), arg2_264)

	if arg2_264 then
		var23_0(arg0_264:Find("skill/attr"), var0_264, {
			name = i18n("skill"),
			value = setColorStr(arg2_264.name, "#FFDE00FF")
		}, arg3_264)
		setText(arg0_264:Find("skill/value/Text"), getSkillDescGet(arg2_264.id))
	end

	setActive(arg0_264:Find("weapon"), #arg1_264.weapon.sub > 0)

	if #arg1_264.weapon.sub > 0 then
		var20_0(arg0_264:Find("weapon"), var0_264, {
			arg1_264.weapon
		}, arg3_264)
	end

	setActive(arg0_264:Find("equip_info"), #arg1_264.equipInfo.sub > 0)

	if #arg1_264.equipInfo.sub > 0 then
		var20_0(arg0_264:Find("equip_info"), var0_264, {
			arg1_264.equipInfo
		}, arg3_264)
	end

	var23_0(arg0_264:Find("part/attr"), var0_264, {
		name = i18n("equip_info_23")
	}, arg3_264)

	local var1_264 = arg0_264:Find("part/value")
	local var2_264 = var1_264:Find("label")
	local var3_264 = {}
	local var4_264 = {}

	if #arg1_264.part[1] == 0 and #arg1_264.part[2] == 0 then
		setmetatable(var3_264, {
			__index = function(arg0_265, arg1_265)
				return true
			end
		})
		setmetatable(var4_264, {
			__index = function(arg0_266, arg1_266)
				return true
			end
		})
	else
		for iter0_264, iter1_264 in ipairs(arg1_264.part[1]) do
			var3_264[iter1_264] = true
		end

		for iter2_264, iter3_264 in ipairs(arg1_264.part[2]) do
			var4_264[iter3_264] = true
		end
	end

	local var5_264 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var3_264, var4_264)

	UIItemList.StaticAlign(var1_264, var2_264, #var5_264, function(arg0_267, arg1_267, arg2_267)
		arg1_267 = arg1_267 + 1

		if arg0_267 == UIItemList.EventUpdate then
			local var0_267 = var5_264[arg1_267]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0_267), arg2_267)
			setActive(arg2_267:Find("main"), var3_264[var0_267] and not var4_264[var0_267])
			setActive(arg2_267:Find("sub"), var4_264[var0_267] and not var3_264[var0_267])
			setImageAlpha(arg2_267, not var3_264[var0_267] and not var4_264[var0_267] and 0.3 or 1)
		end
	end)
end

function updateEquipUpgradeInfo(arg0_268, arg1_268, arg2_268)
	local var0_268 = arg0_268:Find("attr_tpl")

	var20_0(arg0_268:Find("attrs"), var0_268, arg1_268.attrs, arg2_268)
	setActive(arg0_268:Find("weapon"), #arg1_268.weapon.sub > 0)

	if #arg1_268.weapon.sub > 0 then
		var20_0(arg0_268:Find("weapon"), var0_268, {
			arg1_268.weapon
		}, arg2_268)
	end

	setActive(arg0_268:Find("equip_info"), #arg1_268.equipInfo.sub > 0)

	if #arg1_268.equipInfo.sub > 0 then
		var20_0(arg0_268:Find("equip_info"), var0_268, {
			arg1_268.equipInfo
		}, arg2_268)
	end
end

function setCanvasOverrideSorting(arg0_269, arg1_269)
	local var0_269 = arg0_269.parent

	arg0_269:SetParent(pg.LayerWeightMgr.GetInstance().uiOrigin, false)

	if isActive(arg0_269) then
		GetOrAddComponent(arg0_269, typeof(Canvas)).overrideSorting = arg1_269
	else
		setActive(arg0_269, true)

		GetOrAddComponent(arg0_269, typeof(Canvas)).overrideSorting = arg1_269

		setActive(arg0_269, false)
	end

	arg0_269:SetParent(var0_269, false)
end

function createNewGameObject(arg0_270, arg1_270)
	local var0_270 = GameObject.New()

	if arg0_270 then
		var0_270.name = "model"
	end

	var0_270.layer = arg1_270 or Layer.UI

	return GetOrAddComponent(var0_270, "RectTransform")
end

function CreateShell(arg0_271)
	if type(arg0_271) ~= "table" and type(arg0_271) ~= "userdata" then
		return arg0_271
	end

	local var0_271 = setmetatable({
		__index = arg0_271
	}, arg0_271)

	return setmetatable({}, var0_271)
end

function CameraFittingSettin(arg0_272)
	local var0_272 = GetComponent(arg0_272, typeof(Camera))
	local var1_272 = 1.77777777777778
	local var2_272 = Screen.width / Screen.height

	if var2_272 < var1_272 then
		local var3_272 = var2_272 / var1_272

		var0_272.rect = var0_0.Rect.New(0, (1 - var3_272) / 2, 1, var3_272)
	end
end

function SwitchSpecialChar(arg0_273, arg1_273)
	if PLATFORM_CODE ~= PLATFORM_US then
		arg0_273 = arg0_273:gsub(" ", " ")
		arg0_273 = arg0_273:gsub("\t", "    ")
	end

	if not arg1_273 then
		arg0_273 = arg0_273:gsub("\n", " ")
	end

	return arg0_273
end

function AfterCheck(arg0_274, arg1_274)
	local var0_274 = {}

	for iter0_274, iter1_274 in ipairs(arg0_274) do
		var0_274[iter0_274] = iter1_274[1]()
	end

	arg1_274()

	for iter2_274, iter3_274 in ipairs(arg0_274) do
		if var0_274[iter2_274] ~= iter3_274[1]() then
			iter3_274[2]()
		end

		var0_274[iter2_274] = iter3_274[1]()
	end
end

function CompareFuncs(arg0_275, arg1_275)
	local var0_275 = {}

	local function var1_275(arg0_276, arg1_276)
		var0_275[arg0_276] = var0_275[arg0_276] or {}
		var0_275[arg0_276][arg1_276] = var0_275[arg0_276][arg1_276] or arg0_275[arg0_276](arg1_276)

		return var0_275[arg0_276][arg1_276]
	end

	return function(arg0_277, arg1_277)
		local var0_277 = 1

		while var0_277 <= #arg0_275 do
			local var1_277 = var1_275(var0_277, arg0_277)
			local var2_277 = var1_275(var0_277, arg1_277)

			if var1_277 == var2_277 then
				var0_277 = var0_277 + 1
			else
				return var1_277 < var2_277
			end
		end

		return tobool(arg1_275)
	end
end

function DropResultIntegration(arg0_278)
	local var0_278 = {}
	local var1_278 = 1

	while var1_278 <= #arg0_278 do
		local var2_278 = arg0_278[var1_278].type
		local var3_278 = arg0_278[var1_278].id

		var0_278[var2_278] = var0_278[var2_278] or {}

		if var0_278[var2_278][var3_278] then
			local var4_278 = arg0_278[var0_278[var2_278][var3_278]]
			local var5_278 = table.remove(arg0_278, var1_278)

			var4_278.count = var4_278.count + var5_278.count
		else
			var0_278[var2_278][var3_278] = var1_278
			var1_278 = var1_278 + 1
		end
	end

	local var6_278 = {
		function(arg0_279)
			local var0_279 = arg0_279.type
			local var1_279 = arg0_279.id

			if var0_279 == DROP_TYPE_SHIP then
				return 1
			elseif var0_279 == DROP_TYPE_RESOURCE then
				if var1_279 == 1 then
					return 2
				else
					return 3
				end
			elseif var0_279 == DROP_TYPE_ITEM then
				if var1_279 == 59010 then
					return 4
				elseif var1_279 == 59900 then
					return 5
				else
					local var2_279 = Item.getConfigData(var1_279)
					local var3_279 = var2_279 and var2_279.type or 0

					if var3_279 == 9 then
						return 6
					elseif var3_279 == 5 then
						return 7
					elseif var3_279 == 4 then
						return 8
					elseif var3_279 == 7 then
						return 9
					end
				end
			elseif var0_279 == DROP_TYPE_VITEM and var1_279 == 59011 then
				return 4
			end

			return 100
		end,
		function(arg0_280)
			local var0_280

			if arg0_280.type == DROP_TYPE_SHIP then
				var0_280 = pg.ship_data_statistics[arg0_280.id]
			elseif arg0_280.type == DROP_TYPE_ITEM then
				var0_280 = Item.getConfigData(arg0_280.id)
			end

			return (var0_280 and var0_280.rarity or 0) * -1
		end,
		function(arg0_281)
			return arg0_281.id
		end
	}

	table.sort(arg0_278, CompareFuncs(var6_278))
end

function getLoginConfig()
	if LOGIN_HX and PlayerProxy.GetDeviceMaxPlayerLevel() <= pg.gameset.LOGIN_HX_LV.key_value then
		return false, "login", "", false, ""
	end

	local var0_282 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_282 = 1

	for iter0_282, iter1_282 in ipairs(pg.login.all) do
		if pg.login[iter1_282].date ~= "stop" then
			local var2_282, var3_282 = parseTimeConfig(pg.login[iter1_282].date)

			assert(not var3_282)

			if pg.TimeMgr.GetInstance():inTime(var2_282, var0_282) then
				var1_282 = iter1_282

				break
			end
		end
	end

	local var4_282 = pg.login[var1_282].login_static

	var4_282 = var4_282 ~= "" and var4_282 or "login"

	local var5_282 = pg.login[var1_282].login_cri
	local var6_282 = var5_282 ~= "" and true or false
	local var7_282 = pg.login[var1_282].op_play == 1 and true or false
	local var8_282 = pg.login[var1_282].op_time

	if var8_282 == "" or not pg.TimeMgr.GetInstance():inTime(var8_282, var0_282) then
		var7_282 = false
	end

	local var9_282 = var8_282 == "" and var8_282 or table.concat(var8_282[1][1])

	return var6_282, var6_282 and var5_282 or var4_282, pg.login[var1_282].bgm, var7_282, var9_282
end

function setIntimacyIcon(arg0_283, arg1_283, arg2_283)
	local var0_283 = {}
	local var1_283

	seriesAsync({
		function(arg0_284)
			if arg0_283.childCount > 0 then
				var1_283 = arg0_283:GetChild(0)

				arg0_284()
			else
				LoadAndInstantiateAsync("template", "intimacytpl", function(arg0_285)
					var1_283 = tf(arg0_285)

					setParent(var1_283, arg0_283)
					arg0_284()
				end)
			end
		end,
		function(arg0_286)
			setImageAlpha(var1_283, arg2_283 and 0 or 1)
			eachChild(var1_283, function(arg0_287)
				setActive(arg0_287, false)
			end)

			if arg2_283 then
				local var0_286 = var1_283:Find(arg2_283 .. "(Clone)")

				if not var0_286 then
					LoadAndInstantiateAsync("ui", arg2_283, function(arg0_288)
						setParent(arg0_288, var1_283)
						setActive(arg0_288, true)
					end)
				else
					setActive(var0_286, true)
				end
			elseif arg1_283 then
				setImageSprite(var1_283, GetSpriteFromAtlas("energy", arg1_283), true)
			else
				assert(false, "param error")
			end
		end
	})
end

local var24_0

function nowWorld()
	var24_0 = var24_0 or getProxy(WorldProxy)

	return var24_0 and var24_0.world
end

function removeWorld()
	var24_0.world:Dispose()

	var24_0.world = nil
	var24_0 = nil
end

function switch(arg0_291, arg1_291, arg2_291, ...)
	if arg1_291[arg0_291] then
		return arg1_291[arg0_291](...)
	elseif arg2_291 then
		return arg2_291(...)
	end
end

function parseTimeConfig(arg0_292)
	if type(arg0_292[1]) == "table" then
		return arg0_292[2], arg0_292[1]
	else
		return arg0_292
	end
end

local var25_0 = {
	__add = function(arg0_293, arg1_293)
		return NewPos(arg0_293.x + arg1_293.x, arg0_293.y + arg1_293.y)
	end,
	__sub = function(arg0_294, arg1_294)
		return NewPos(arg0_294.x - arg1_294.x, arg0_294.y - arg1_294.y)
	end,
	__mul = function(arg0_295, arg1_295)
		if type(arg1_295) == "number" then
			return NewPos(arg0_295.x * arg1_295, arg0_295.y * arg1_295)
		else
			return NewPos(arg0_295.x * arg1_295.x, arg0_295.y * arg1_295.y)
		end
	end,
	__eq = function(arg0_296, arg1_296)
		return arg0_296.x == arg1_296.x and arg0_296.y == arg1_296.y
	end,
	__tostring = function(arg0_297)
		return arg0_297.x .. "_" .. arg0_297.y
	end
}

function NewPos(arg0_298, arg1_298)
	assert(arg0_298 and arg1_298)

	local var0_298 = setmetatable({
		x = arg0_298,
		y = arg1_298
	}, var25_0)

	function var0_298.SqrMagnitude(arg0_299)
		return arg0_299.x * arg0_299.x + arg0_299.y * arg0_299.y
	end

	function var0_298.Normalize(arg0_300)
		local var0_300 = arg0_300:SqrMagnitude()

		if var0_300 > 1e-05 then
			return arg0_300 * (1 / math.sqrt(var0_300))
		else
			return NewPos(0, 0)
		end
	end

	return var0_298
end

local var26_0

function Timekeeping()
	warning(Time.realtimeSinceStartup - (var26_0 or Time.realtimeSinceStartup), Time.realtimeSinceStartup)

	var26_0 = Time.realtimeSinceStartup
end

function GetRomanDigit(arg0_302)
	return (string.char(226, 133, 160 + (arg0_302 - 1)))
end

function quickPlayAnimator(arg0_303, arg1_303)
	arg0_303:GetComponent(typeof(Animator)):Play(arg1_303, -1, 0)
end

function quickCheckAndPlayAnimator(arg0_304, arg1_304)
	local var0_304 = arg0_304:GetComponent(typeof(Animator))

	var0_304.enabled = true

	local var1_304 = Animator.StringToHash(arg1_304)

	if var0_304:HasState(0, var1_304) then
		var0_304:Play(arg1_304, -1, 0)
	end
end

function quickPlayAnimation(arg0_305, arg1_305)
	local var0_305 = arg0_305:GetComponent(typeof(Animation))

	var0_305:Stop()
	var0_305:Play(arg1_305)
end

function getSurveyUrl(arg0_306)
	local var0_306 = pg.survey_data_template[arg0_306]
	local var1_306

	if not IsUnityEditor then
		if PLATFORM_CODE == PLATFORM_CH then
			local var2_306 = getProxy(UserProxy):GetCacheGatewayInServerLogined()

			if var2_306 == PLATFORM_ANDROID then
				if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_BILI then
					var1_306 = var0_306.main_url
				else
					var1_306 = var0_306.uo_url
				end
			elseif var2_306 == PLATFORM_IPHONEPLAYER then
				var1_306 = var0_306.ios_url
			end
		elseif PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_KR then
			var1_306 = var0_306.main_url
		end
	else
		var1_306 = var0_306.main_url
	end

	local var3_306 = getProxy(PlayerProxy):getRawData().id
	local var4_306 = getProxy(UserProxy):getRawData().arg2 or ""
	local var5_306
	local var6_306 = PLATFORM == PLATFORM_ANDROID and 1 or PLATFORM == PLATFORM_IPHONEPLAYER and 2 or 3
	local var7_306 = getProxy(UserProxy):getRawData()
	local var8_306 = getProxy(ServerProxy):getRawData()[var7_306 and var7_306.server or 0]
	local var9_306 = var8_306 and var8_306.id or ""
	local var10_306 = getProxy(PlayerProxy):getRawData().level
	local var11_306 = var3_306 .. "_" .. arg0_306
	local var12_306 = var1_306
	local var13_306 = {
		var3_306,
		var4_306,
		var6_306,
		var9_306,
		var10_306,
		var11_306
	}

	if var12_306 then
		for iter0_306, iter1_306 in ipairs(var13_306) do
			var12_306 = string.gsub(var12_306, "$" .. iter0_306, tostring(iter1_306))
		end
	end

	originalPrint("survey url", tostring(var12_306))

	return var12_306
end

function GetMoneySymbol()
	if PLATFORM_CH == PLATFORM_CODE then
		return "￥"
	elseif PLATFORM_JP == PLATFORM_CODE then
		return "￥"
	elseif PLATFORM_KR == PLATFORM_CODE then
		return "₩"
	elseif PLATFORM_US == PLATFORM_CODE then
		return "$"
	elseif PLATFORM_CHT == PLATFORM_CODE then
		return "TWD"
	end

	return ""
end

function FilterVarchar(arg0_308)
	assert(type(arg0_308) == "string" or type(arg0_308) == "table")

	if arg0_308 == "" then
		return nil
	end

	return arg0_308
end

function getGameset(arg0_309)
	local var0_309 = pg.gameset[arg0_309]

	assert(var0_309)

	return {
		var0_309.key_value,
		var0_309.description
	}
end

function getDorm3dGameset(arg0_310)
	local var0_310 = pg.dorm3d_set[arg0_310]

	assert(var0_310)

	return {
		var0_310.key_value_int,
		var0_310.key_value_varchar
	}
end

function GetItemsOverflowDic(arg0_311)
	arg0_311 = arg0_311 or {}

	local var0_311 = {
		[DROP_TYPE_ITEM] = {},
		[DROP_TYPE_RESOURCE] = {},
		[DROP_TYPE_EQUIP] = 0,
		[DROP_TYPE_SHIP] = 0,
		[DROP_TYPE_WORLD_ITEM] = 0
	}

	while #arg0_311 > 0 do
		local var1_311 = table.remove(arg0_311)

		switch(var1_311.type, {
			[DROP_TYPE_ITEM] = function()
				if var1_311:getConfig("open_directly") == 1 then
					for iter0_312, iter1_312 in ipairs(var1_311:getConfig("display_icon")) do
						local var0_312 = Drop.Create(iter1_312)

						var0_312.count = var0_312.count * var1_311.count

						table.insert(arg0_311, var0_312)
					end
				elseif var1_311:getSubClass():IsShipExpType() then
					var0_311[var1_311.type][var1_311.id] = defaultValue(var0_311[var1_311.type][var1_311.id], 0) + var1_311.count
				end
			end,
			[DROP_TYPE_RESOURCE] = function()
				var0_311[var1_311.type][var1_311.id] = defaultValue(var0_311[var1_311.type][var1_311.id], 0) + var1_311.count
			end,
			[DROP_TYPE_EQUIP] = function()
				var0_311[var1_311.type] = var0_311[var1_311.type] + var1_311.count
			end,
			[DROP_TYPE_SHIP] = function()
				var0_311[var1_311.type] = var0_311[var1_311.type] + var1_311.count
			end,
			[DROP_TYPE_WORLD_ITEM] = function()
				var0_311[var1_311.type] = var0_311[var1_311.type] + var1_311.count
			end
		})
	end

	return var0_311
end

function CheckOverflow(arg0_317, arg1_317)
	local var0_317 = {}
	local var1_317 = arg0_317[DROP_TYPE_RESOURCE][PlayerConst.ResGold] or 0
	local var2_317 = arg0_317[DROP_TYPE_RESOURCE][PlayerConst.ResOil] or 0
	local var3_317 = arg0_317[DROP_TYPE_EQUIP]
	local var4_317 = arg0_317[DROP_TYPE_SHIP]
	local var5_317 = getProxy(PlayerProxy):getRawData()
	local var6_317 = false

	if arg1_317 then
		local var7_317 = var5_317:OverStore(PlayerConst.ResStoreGold, var1_317)
		local var8_317 = var5_317:OverStore(PlayerConst.ResStoreOil, var2_317)

		if var7_317 > 0 or var8_317 > 0 then
			var0_317.isStoreOverflow = {
				var7_317,
				var8_317
			}
		end
	else
		if var1_317 > 0 and var5_317:GoldMax(var1_317) then
			return false, "gold"
		end

		if var2_317 > 0 and var5_317:OilMax(var2_317) then
			return false, "oil"
		end
	end

	var0_317.isExpBookOverflow = {}

	for iter0_317, iter1_317 in pairs(arg0_317[DROP_TYPE_ITEM]) do
		local var9_317 = Item.getConfigData(iter0_317)

		if getProxy(BagProxy):getItemCountById(iter0_317) + iter1_317 > var9_317.max_num then
			table.insert(var0_317.isExpBookOverflow, iter0_317)
		end
	end

	local var10_317 = getProxy(EquipmentProxy):getCapacity()

	if var3_317 > 0 and var10_317 >= var5_317:getMaxEquipmentBag() then
		return false, "equip"
	end

	local var11_317 = getProxy(BayProxy):getShipCount()

	if var4_317 > 0 and var4_317 + var11_317 > var5_317:getMaxShipBag() then
		return false, "ship"
	end

	return true, var0_317
end

function CheckShipExpOverflow(arg0_318)
	local var0_318 = getProxy(BagProxy)

	for iter0_318, iter1_318 in pairs(arg0_318[DROP_TYPE_ITEM]) do
		if var0_318:getItemCountById(iter0_318) + iter1_318 > Item.getConfigData(iter0_318).max_num then
			return false
		end
	end

	return true
end

local var27_0 = {
	[17] = "item_type17_tip2",
	tech = "techpackage_item_use_confirm",
	[16] = "item_type16_tip2",
	[11] = "equip_skin_detail_tip",
	[13] = "item_type13_tip2"
}

function RegisterDetailButton(arg0_319, arg1_319, arg2_319)
	Drop.Change(arg2_319)
	switch(arg2_319.type, {
		[DROP_TYPE_ITEM] = function()
			if arg2_319:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
				local var0_320 = Item.getConfigData(arg2_319.id).usage_arg
				local var1_320 = var0_320[3]

				if Item.InTimeLimitSkinAssigned(arg2_319.id) then
					var1_320 = table.mergeArray(var0_320[2], var1_320, true)
				end

				local var2_320 = {}

				for iter0_320, iter1_320 in ipairs(var0_320[2]) do
					var2_320[iter1_320] = true
				end

				onButton(arg0_319, arg1_319, function()
					arg0_319:closeView()
					pg.m02:sendNotification(GAME.LOAD_LAYERS, {
						parentContext = getProxy(ContextProxy):getCurrentContext(),
						context = Context.New({
							viewComponent = NewSelectSkinLayer,
							mediator = NewSkinAtlasMediator,
							data = {
								mode = SelectSkinLayer.MODE_VIEW,
								itemId = arg2_319.id,
								selectableSkinList = underscore.map(var1_320, function(arg0_322)
									return SelectableSkin.New({
										id = arg0_322,
										isTimeLimit = var2_320[arg0_322] or false
									})
								end)
							}
						})
					})
				end, SFX_PANEL)
				setActive(arg1_319, true)
			else
				local var3_320 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_319.id) and "tech" or arg2_319:getConfig("type")

				if var27_0[var3_320] then
					local var4_320 = {
						item2Row = true,
						content = i18n(var27_0[var3_320]),
						itemList = underscore.map(arg2_319:getConfig("display_icon"), function(arg0_323)
							return Drop.Create(arg0_323)
						end)
					}

					if var3_320 == 11 then
						onButton(arg0_319, arg1_319, function()
							arg0_319:emit(BaseUI.ON_DROP_LIST_OWN, var4_320)
						end, SFX_PANEL)
					else
						onButton(arg0_319, arg1_319, function()
							arg0_319:emit(BaseUI.ON_DROP_LIST, var4_320)
						end, SFX_PANEL)
					end
				end

				setActive(arg1_319, tobool(var27_0[var3_320]))
			end
		end,
		[DROP_TYPE_EQUIP] = function()
			onButton(arg0_319, arg1_319, function()
				arg0_319:emit(BaseUI.ON_DROP, arg2_319)
			end, SFX_PANEL)
			setActive(arg1_319, true)
		end,
		[DROP_TYPE_SPWEAPON] = function()
			onButton(arg0_319, arg1_319, function()
				arg0_319:emit(BaseUI.ON_DROP, arg2_319)
			end, SFX_PANEL)
			setActive(arg1_319, true)
		end
	}, function()
		setActive(arg1_319, false)
	end)
end

function RegisterNewStyleDetailButton(arg0_331, arg1_331, arg2_331)
	Drop.Change(arg2_331)
	switch(arg2_331.type, {
		[DROP_TYPE_ITEM] = function()
			local var0_332 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_331.id) and "tech" or arg2_331:getConfig("type")

			if var27_0[var0_332] then
				local var1_332 = {
					useDeepShow = true,
					showOwn = var0_332 == 11,
					content = i18n(var27_0[var0_332]),
					itemList = underscore.map(arg2_331:getConfig("display_icon"), function(arg0_333)
						return Drop.Create(arg0_333)
					end)
				}

				onButton(arg0_331, arg1_331, function()
					arg0_331:emit(BaseUI.ON_NEW_STYLE_ITEMS, var1_332)
				end, SFX_PANEL)
			end

			setActive(arg1_331, tobool(var27_0[var0_332]))
		end
	}, function()
		setActive(arg1_331, false)
	end)
end

function UpdateOwnDisplay(arg0_336, arg1_336)
	local var0_336, var1_336 = arg1_336:getOwnedCount()

	setActive(arg0_336, var1_336 and var0_336 > 0)

	if var1_336 and var0_336 > 0 then
		setText(arg0_336:Find("label"), i18n("word_own1"))
		setText(arg0_336:Find("Text"), var0_336)
	end
end

function Damp(arg0_337, arg1_337, arg2_337)
	arg1_337 = Mathf.Max(1, arg1_337)

	local var0_337 = Mathf.Epsilon

	if arg1_337 < var0_337 or var0_337 > Mathf.Abs(arg0_337) then
		return arg0_337
	end

	if arg2_337 < var0_337 then
		return 0
	end

	local var1_337 = -4.605170186

	return arg0_337 * (1 - Mathf.Exp(var1_337 * arg2_337 / arg1_337))
end

function checkCullResume(arg0_338, arg1_338)
	if arg1_338 or not ReflectionHelp.RefCallMethodEx(typeof("UnityEngine.CanvasRenderer"), "GetMaterial", GetComponent(arg0_338, "CanvasRenderer"), {
		typeof("System.Int32")
	}, {
		0
	}) then
		local var0_338 = arg0_338:GetComponentsInChildren(typeof(var0_0.UI.Graphic)):ToTable()

		for iter0_338, iter1_338 in ipairs(var0_338) do
			iter1_338:SetVerticesDirty()
		end

		return false
	end

	return true
end

function parseEquipCode(arg0_339)
	local var0_339 = {}

	if arg0_339 and arg0_339 ~= "" then
		local var1_339 = base64.dec(arg0_339)

		var0_339 = string.split(var1_339, "/")
		var0_339[5], var0_339[6] = unpack(string.split(var0_339[5], "\\"))

		if #var0_339 < 6 or arg0_339 ~= base64.enc(table.concat({
			table.concat(underscore.first(var0_339, 5), "/"),
			var0_339[6]
		}, "\\")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_illegal"))

			var0_339 = {}
		end
	end

	for iter0_339 = 1, 6 do
		var0_339[iter0_339] = var0_339[iter0_339] and tonumber(var0_339[iter0_339], 32) or 0
	end

	return var0_339
end

function buildEquipCode(arg0_340)
	local var0_340 = underscore.map(arg0_340:getAllEquipments(), function(arg0_341)
		return ConversionBase(32, arg0_341 and arg0_341.id or 0)
	end)
	local var1_340 = {
		table.concat(var0_340, "/"),
		ConversionBase(32, checkExist(arg0_340:GetSpWeapon(), {
			"id"
		}) or 0)
	}

	return base64.enc(table.concat(var1_340, "\\"))
end

function setDirectorSpeed(arg0_342, arg1_342)
	GetComponent(arg0_342, typeof(TimelineSpeed)):SetTimelineSpeed(arg1_342)
end

function setDefaultZeroMetatable(arg0_343)
	return setmetatable(arg0_343, {
		__index = function(arg0_344, arg1_344)
			if rawget(arg0_344, arg1_344) == nil then
				arg0_344[arg1_344] = 0
			end

			return arg0_344[arg1_344]
		end
	})
end

function checkABExist(arg0_345)
	if EDITOR_TOOL then
		return ResourceMgr.Inst:AssetExist(arg0_345)
	else
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_345))
	end
end

function compareNumber(arg0_346, arg1_346, arg2_346)
	return switch(arg1_346, {
		[">"] = function()
			return arg0_346 > arg2_346
		end,
		[">="] = function()
			return arg0_346 >= arg2_346
		end,
		["="] = function()
			return arg0_346 == arg2_346
		end,
		["<"] = function()
			return arg0_346 < arg2_346
		end,
		["<="] = function()
			return arg0_346 <= arg2_346
		end
	})
end

function ArabicToRoman(arg0_352)
	local var0_352 = {
		{
			1000,
			"M"
		},
		{
			900,
			"CM"
		},
		{
			500,
			"D"
		},
		{
			400,
			"CD"
		},
		{
			100,
			"C"
		},
		{
			90,
			"XC"
		},
		{
			50,
			"L"
		},
		{
			40,
			"XL"
		},
		{
			10,
			"X"
		},
		{
			9,
			"IX"
		},
		{
			5,
			"V"
		},
		{
			4,
			"IV"
		},
		{
			1,
			"I"
		}
	}

	local function var1_352(arg0_353, arg1_353)
		return select(2, arg0_353:gsub(arg1_353, ""))
	end

	local var2_352 = ""

	while arg0_352 > 0 do
		for iter0_352, iter1_352 in pairs(var0_352) do
			local var3_352 = iter1_352[2]
			local var4_352 = iter1_352[1]

			while var4_352 <= arg0_352 do
				var2_352 = var2_352 .. var3_352
				arg0_352 = arg0_352 - var4_352
			end
		end
	end

	if arg0_352 > 10000 then
		local var5_352 = var1_352(var2_352, "M")

		var2_352 = "M*" .. var5_352 .. " " .. var2_352
	end

	return var2_352
end

function stringInset(arg0_354, ...)
	for iter0_354, iter1_354 in ipairs({
		...
	}) do
		arg0_354 = string.gsub(arg0_354, "$" .. iter0_354, iter1_354)
	end

	return arg0_354
end

function addSubLayer(arg0_355, arg1_355, arg2_355, arg3_355, arg4_355)
	if arg2_355 then
		while arg1_355.parent do
			arg1_355 = arg1_355.parent
		end
	end

	local var0_355 = {
		parentContext = arg1_355,
		context = arg0_355,
		callback = arg3_355
	}

	var0_355 = arg4_355 and table.merge(var0_355, arg4_355) or var0_355

	pg.m02:sendNotification(GAME.LOAD_LAYERS, var0_355)
end
