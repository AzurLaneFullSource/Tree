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
	local var1_102 = IslandItemRarity.Rarity2FrameName(ItemRarity.Gold)

	GetImageSpriteFromAtlasAsync("island/islandframe", var1_102, findTF(arg0_102, "icon_bg"))

	if not IsNil(findTF(arg0_102, "icon_bg/frame")) then
		GetImageSpriteFromAtlasAsync("island/islandframe", var1_102, findTF(arg0_102, "icon_bg/frame"))
	end

	setActive(findTF(arg0_102, "icon_bg/count_bg"), false)
	GetImageSpriteFromAtlasAsync("island/" .. var0_102, "", findTF(arg0_102, "icon_bg/icon"))
	setIconName(arg0_102, "", {})
end

function updateIslandInvitation(arg0_103, arg1_103)
	local var0_103 = pg.island_chara_template[arg1_103.id].invite_item
	local var1_103 = pg.island_item_data_template[var0_103].icon
	local var2_103 = IslandItemRarity.Rarity2FrameName(ItemRarity.Gold)

	GetImageSpriteFromAtlasAsync("island/islandframe", var2_103, findTF(arg0_103, "icon_bg"))

	if not IsNil(findTF(arg0_103, "icon_bg/frame")) then
		GetImageSpriteFromAtlasAsync("island/islandframe", var2_103, findTF(arg0_103, "icon_bg/frame"))
	end

	setActive(findTF(arg0_103, "icon_bg/count_bg"), arg1_103.count > 0)
	setText(findTF(arg0_103, "icon_bg/count_bg/count"), arg1_103.count)
	GetImageSpriteFromAtlasAsync("island/" .. var1_103, "", findTF(arg0_103, "icon_bg/icon"))
	setIconName(arg0_103, "", {})
end

function updateIslandItem(arg0_104, arg1_104)
	local var0_104 = arg1_104:getConfigTable().rarity
	local var1_104 = arg1_104:getConfigTable().icon
	local var2_104 = arg1_104:getConfigTable().name
	local var3_104 = IslandItemRarity.Rarity2FrameName(var0_104)

	GetImageSpriteFromAtlasAsync("island/islandframe", var3_104, findTF(arg0_104, "icon_bg"))

	if not IsNil(findTF(arg0_104, "icon_bg/frame")) then
		GetImageSpriteFromAtlasAsync("island/islandframe", var3_104, findTF(arg0_104, "icon_bg/frame"))
	end

	setActive(findTF(arg0_104, "icon_bg/count_bg"), arg1_104.count > 0)
	setText(findTF(arg0_104, "icon_bg/count_bg/count"), arg1_104.count)
	GetImageSpriteFromAtlasAsync("island/" .. var1_104, "", findTF(arg0_104, "icon_bg/icon"))
	setIconName(arg0_104, var2_104, {})
end

function updateIslandFurniture(arg0_105, arg1_105)
	local var0_105 = arg1_105:getConfigTable().rarity
	local var1_105 = arg1_105:getConfigTable().icon
	local var2_105 = arg1_105:getConfigTable().name
	local var3_105 = IslandItemRarity.Rarity2FrameName(var0_105)

	GetImageSpriteFromAtlasAsync("island/islandframe", var3_105, findTF(arg0_105, "icon_bg"))

	if not IsNil(findTF(arg0_105, "icon_bg/frame")) then
		GetImageSpriteFromAtlasAsync("island/islandframe", var3_105, findTF(arg0_105, "icon_bg/frame"))
	end

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

function getIslandSeasonPtInfo()
	local var0_107 = pg.island_set.season_pt.key_value_varchar

	return {
		name = var0_107[1],
		icon = var0_107[2]
	}
end

function updateIslandSeasonPt(arg0_108, arg1_108)
	local var0_108 = getIslandSeasonPtInfo()

	GetImageSpriteFromAtlasAsync("island/" .. var0_108.icon, "", findTF(arg0_108, "icon_bg/icon"))
	setActive(findTF(arg0_108, "icon_bg/count_bg"), arg1_108.count > 0)
	setText(findTF(arg0_108, "icon_bg/count_bg/count"), arg1_108.count)
end

function updateIslandWatherCollect(arg0_109, arg1_109)
	local var0_109 = arg1_109:getConfigTable().icon
	local var1_109 = arg1_109:getConfigTable().name

	setText(findTF(arg0_109, "icon_bg/count"), arg1_109.count)
	GetImageSpriteFromAtlasAsync("island/" .. var0_109, "", findTF(arg0_109, "icon_bg/icon"))
	setIconName(arg0_109, var1_109, {})
end

function updateWorldItem(arg0_110, arg1_110, arg2_110)
	arg2_110 = arg2_110 or {}

	local var0_110 = ItemRarity.Rarity2Print(arg1_110:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_110, findTF(arg0_110, "icon_bg"))
	setFrame(findTF(arg0_110, "icon_bg/frame"), var0_110)

	local var1_110 = findTF(arg0_110, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_110.icon or arg1_110:getConfig("icon"), "", var1_110)
	setIconStars(arg0_110, false)
	setIconName(arg0_110, arg1_110:getConfig("name"), arg2_110)
	setIconColorful(arg0_110, arg1_110:getConfig("rarity"), arg2_110)
end

function updateWorldCollection(arg0_111, arg1_111, arg2_111)
	arg2_111 = arg2_111 or {}

	assert(arg1_111:getConfigTable(), "world_collection_file_template 和 world_collection_record_template 表中找不到配置: " .. arg1_111.id)

	local var0_111 = arg1_111:getDropRarity()
	local var1_111 = ItemRarity.Rarity2Print(var0_111)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_111, findTF(arg0_111, "icon_bg"))
	setFrame(findTF(arg0_111, "icon_bg/frame"), var1_111)

	local var2_111 = findTF(arg0_111, "icon_bg/icon")
	local var3_111 = WorldCollectionProxy.GetCollectionType(arg1_111.id) == WorldCollectionProxy.WorldCollectionType.FILE and "shoucangguangdie" or "shoucangjiaojuan"

	GetImageSpriteFromAtlasAsync("props/" .. var3_111, "", var2_111)
	setIconStars(arg0_111, false)
	setIconName(arg0_111, arg1_111:getName(), arg2_111)
	setIconColorful(arg0_111, var0_111, arg2_111)
end

function updateWorldBuff(arg0_112, arg1_112, arg2_112)
	arg2_112 = arg2_112 or {}

	local var0_112 = pg.world_SLGbuff_data[arg1_112]

	assert(var0_112, "找不到大世界buff配置: " .. arg1_112)

	local var1_112 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_112, findTF(arg0_112, "icon_bg"))
	setFrame(findTF(arg0_112, "icon_bg/frame"), var1_112)

	local var2_112 = findTF(arg0_112, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("world/buff/" .. var0_112.icon, "", var2_112)

	local var3_112 = arg0_112:Find("icon_bg/stars")

	if not IsNil(var3_112) then
		setActive(var3_112, false)
	end

	local var4_112 = findTF(arg0_112, "name")

	if not IsNil(var4_112) then
		setText(var4_112, var0_112.name)
	end

	local var5_112 = findTF(arg0_112, "icon_bg/count")

	if not IsNil(var5_112) then
		SetActive(var5_112, false)
	end
end

function updateShip(arg0_113, arg1_113, arg2_113)
	arg2_113 = arg2_113 or {}

	local var0_113 = arg1_113:rarity2bgPrint()
	local var1_113 = arg1_113:getPainting()

	if arg2_113.anonymous then
		var0_113 = "1"
		var1_113 = "unknown"
	end

	if arg2_113.unknown_small then
		var1_113 = "unknown_small"
	end

	local var2_113 = findTF(arg0_113, "icon_bg/new")

	if var2_113 then
		if arg2_113.isSkin then
			setActive(var2_113, not arg2_113.isTimeLimit and arg2_113.isNew)
		else
			setActive(var2_113, arg1_113.virgin)
		end
	end

	local var3_113 = findTF(arg0_113, "icon_bg/timelimit")

	if var3_113 then
		setActive(var3_113, arg2_113.isTimeLimit)
	end

	local var4_113 = findTF(arg0_113, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. (arg2_113.isSkin and "_skin" or var0_113), var4_113)

	local var5_113 = findTF(arg0_113, "icon_bg/frame")
	local var6_113

	if arg1_113.isNpc then
		var6_113 = "frame_npc"
	elseif arg1_113:ShowPropose() then
		var6_113 = "frame_prop"

		if arg1_113:isMetaShip() then
			var6_113 = var6_113 .. "_meta"
		end
	elseif arg2_113.isSkin then
		var6_113 = "frame_skin"
	end

	setFrame(var5_113, var0_113, var6_113)

	if arg2_113.gray then
		setGray(var4_113, true, true)
	end

	local var7_113 = findTF(arg0_113, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg2_113.Q and "QIcon/" or "SquareIcon/") .. var1_113, "", var7_113)

	local var8_113 = findTF(arg0_113, "icon_bg/lv")

	if var8_113 then
		setActive(var8_113, not arg1_113.isNpc)

		if not arg1_113.isNpc then
			local var9_113 = findTF(var8_113, "Text")

			if var9_113 and arg1_113.level then
				setText(var9_113, arg1_113.level)
			end
		end
	end

	local var10_113 = findTF(arg0_113, "ship_type")

	if var10_113 then
		setActive(var10_113, true)
		setImageSprite(var10_113, GetSpriteFromAtlas("shiptype", shipType2print(arg1_113:getShipType())))
	end

	local var11_113 = var4_113:Find("npc")

	if not IsNil(var11_113) then
		if var2_113 and go(var2_113).activeSelf then
			setActive(var11_113, false)
		else
			setActive(var11_113, arg1_113:isActivityNpc())
		end
	end

	local var12_113 = arg0_113:Find("group_locked")

	if var12_113 then
		setActive(var12_113, not arg2_113.isSkin and not getProxy(CollectionProxy):getShipGroup(arg1_113.groupId))
	end

	setIconStars(arg0_113, arg2_113.initStar, arg1_113:getStar())
	setIconName(arg0_113, arg2_113.isSkin and arg1_113:GetSkinConfig().name or arg1_113:getName(), arg2_113)
	setIconColorful(arg0_113, arg2_113.isSkin and ItemRarity.Gold or arg1_113:getRarity() - 1, arg2_113)
end

function updateCommander(arg0_114, arg1_114, arg2_114)
	arg2_114 = arg2_114 or {}

	local var0_114 = arg1_114:getDropRarity()
	local var1_114 = ItemRarity.Rarity2Print(var0_114)
	local var2_114 = arg1_114:getConfig("painting")

	if arg2_114.anonymous then
		var1_114 = 1
		var2_114 = "unknown"
	end

	local var3_114 = findTF(arg0_114, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_114, var3_114)

	local var4_114 = findTF(arg0_114, "icon_bg/frame")

	setFrame(var4_114, var1_114)

	if arg2_114.gray then
		setGray(var3_114, true, true)
	end

	local var5_114 = findTF(arg0_114, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("CommanderIcon/" .. var2_114, "", var5_114)
	setIconStars(arg0_114, arg2_114.initStar, 0)
	setIconName(arg0_114, arg1_114:getName(), arg2_114)
end

function updateStrategy(arg0_115, arg1_115, arg2_115)
	arg2_115 = arg2_115 or {}

	local var0_115 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_115, findTF(arg0_115, "icon_bg"))
	setFrame(findTF(arg0_115, "icon_bg/frame"), var0_115)

	local var1_115 = findTF(arg0_115, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg1_115.isWorldBuff and "world/buff/" or "strategyicon/") .. arg1_115:getIcon(), "", var1_115)
	setIconStars(arg0_115, false)
	setIconName(arg0_115, arg1_115:getName(), arg2_115)
	setIconColorful(arg0_115, ItemRarity.Gray, arg2_115)
end

function updateFurniture(arg0_116, arg1_116, arg2_116)
	arg2_116 = arg2_116 or {}

	local var0_116 = arg1_116:getDropRarity()
	local var1_116 = ItemRarity.Rarity2Print(var0_116)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_116, findTF(arg0_116, "icon_bg"))
	setFrame(findTF(arg0_116, "icon_bg/frame"), var1_116)

	local var2_116 = findTF(arg0_116, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1_116:getIcon(), "", var2_116)
	setIconStars(arg0_116, false)
	setIconName(arg0_116, arg1_116:getName(), arg2_116)
	setIconColorful(arg0_116, var0_116, arg2_116)
end

function updateSpWeapon(arg0_117, arg1_117, arg2_117)
	arg2_117 = arg2_117 or {}

	assert(arg1_117, "spWeaponVO can not be nil.")
	assert(isa(arg1_117, SpWeapon), "spWeaponVO is not Equipment.")

	local var0_117 = ItemRarity.Rarity2Print(arg1_117:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_117, findTF(arg0_117, "icon_bg"))
	setFrame(findTF(arg0_117, "icon_bg/frame"), var0_117)

	local var1_117 = findTF(arg0_117, "icon_bg/icon")

	var4_0(var1_117, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync(arg1_117:GetIconPath(), "", var1_117)
	setIconStars(arg0_117, true, arg1_117:GetRarity())
	var7_0(arg0_117, arg1_117:GetLevel() - 1)
	setIconName(arg0_117, arg1_117:GetName(), arg2_117)
	setIconCount(arg0_117, arg1_117.count)
	setIconColorful(arg0_117, arg1_117:GetRarity(), arg2_117)
end

function UpdateSpWeaponSlot(arg0_118, arg1_118, arg2_118)
	local var0_118 = ItemRarity.Rarity2Print(arg1_118:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_118, findTF(arg0_118, "Icon/Mask/icon_bg"))

	local var1_118 = findTF(arg0_118, "Icon/Mask/icon_bg/icon")

	arg2_118 = arg2_118 or {
		16,
		16,
		16,
		16
	}

	var4_0(var1_118, arg2_118)
	GetImageSpriteFromAtlasAsync(arg1_118:GetIconPath(), "", var1_118)

	local var2_118 = arg1_118:GetLevel() - 1
	local var3_118 = findTF(arg0_118, "Icon/LV")

	setActive(var3_118, var2_118 > 0)
	setText(findTF(var3_118, "Text"), var2_118)
end

function updateDorm3dIcon(arg0_119, arg1_119)
	local var0_119 = arg1_119:getDropRarityDorm()

	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(var0_119), arg0_119)

	local var1_119 = arg0_119:Find("icon")

	GetImageSpriteFromAtlasAsync(arg1_119:getIcon(), "", var1_119)
	setText(arg0_119:Find("count/Text"), "x" .. arg1_119.count)
	setText(arg0_119:Find("name/Text"), arg1_119:getName())
end

local var8_0

function findCullAndClipWorldRect(arg0_120)
	if #arg0_120 == 0 then
		return false
	end

	local var0_120 = arg0_120[1].canvasRect

	for iter0_120 = 1, #arg0_120 do
		var0_120 = rectIntersect(var0_120, arg0_120[iter0_120].canvasRect)
	end

	if var0_120.width <= 0 or var0_120.height <= 0 then
		return false
	end

	var8_0 = var8_0 or GameObject.Find("UICamera/Canvas").transform

	local var1_120 = var8_0:TransformPoint(Vector3(var0_120.x, var0_120.y, 0))
	local var2_120 = var8_0:TransformPoint(Vector3(var0_120.x + var0_120.width, var0_120.y + var0_120.height, 0))

	return true, Vector4(var1_120.x, var1_120.y, var2_120.x, var2_120.y)
end

function rectIntersect(arg0_121, arg1_121)
	local var0_121 = math.max(arg0_121.x, arg1_121.x)
	local var1_121 = math.min(arg0_121.x + arg0_121.width, arg1_121.x + arg1_121.width)
	local var2_121 = math.max(arg0_121.y, arg1_121.y)
	local var3_121 = math.min(arg0_121.y + arg0_121.height, arg1_121.y + arg1_121.height)

	if var0_121 <= var1_121 and var2_121 <= var3_121 then
		return var0_0.Rect.New(var0_121, var2_121, var1_121 - var0_121, var3_121 - var2_121)
	end

	return var0_0.Rect.New(0, 0, 0, 0)
end

function getDropInfo(arg0_122)
	local var0_122 = {}

	for iter0_122, iter1_122 in ipairs(arg0_122) do
		local var1_122 = Drop.Create(iter1_122)

		var1_122.count = var1_122.count or 1

		if var1_122.type == DROP_TYPE_EMOJI then
			table.insert(var0_122, var1_122:getName())
		else
			table.insert(var0_122, var1_122:getName() .. "x" .. var1_122.count)
		end
	end

	return table.concat(var0_122, "、")
end

function updateDrop(arg0_123, arg1_123, arg2_123)
	Drop.Change(arg1_123)

	arg2_123 = arg2_123 or {}

	local var0_123 = {
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
	local var1_123

	for iter0_123, iter1_123 in ipairs(var0_123) do
		local var2_123 = arg0_123:Find(iter1_123[1])

		if arg1_123.type ~= iter1_123[2] and not IsNil(var2_123) then
			setActive(var2_123, false)
		end
	end

	if not IsNil(arg0_123:Find("icon_bg/frame")) then
		arg0_123:Find("icon_bg/frame"):GetComponent(typeof(Image)).enabled = true

		setIconColorful(arg0_123, arg1_123:getDropRarity(), arg2_123, {
			[ItemRarity.Gold] = {
				name = "Item_duang5",
				active = function(arg0_124, arg1_124)
					return arg1_124.fromAwardLayer and arg0_124 >= ItemRarity.Gold
				end
			}
		})
		var4_0(findTF(arg0_123, "icon_bg/icon"), {
			2,
			2,
			2,
			2
		})
	end

	arg1_123:UpdateDropTpl(arg0_123, arg2_123)
	setIconCount(arg0_123, arg2_123.count or arg1_123:getCount())
end

function updateCustomDrop(arg0_125, arg1_125, arg2_125)
	Drop.Change(arg1_125)

	arg2_125 = arg2_125 or {}

	arg1_125:UpdateCustomDropTpl(arg0_125, arg2_125)
end

function updateBuff(arg0_126, arg1_126, arg2_126)
	arg2_126 = arg2_126 or {}

	local var0_126 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_126, findTF(arg0_126, "icon_bg"))

	local var1_126 = pg.benefit_buff_template[arg1_126]

	setFrame(findTF(arg0_126, "icon_bg/frame"), var0_126)
	setText(findTF(arg0_126, "icon_bg/count"), 1)

	local var2_126 = findTF(arg0_126, "icon_bg/icon")
	local var3_126 = var1_126.icon

	GetImageSpriteFromAtlasAsync(var3_126, "", var2_126)
	setIconStars(arg0_126, false)
	setIconName(arg0_126, var1_126.name, arg2_126)
	setIconColorful(arg0_126, ItemRarity.Gold, arg2_126)
end

function updateAttire(arg0_127, arg1_127, arg2_127, arg3_127)
	local var0_127 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_127, findTF(arg0_127, "icon_bg"))
	setFrame(findTF(arg0_127, "icon_bg/frame"), var0_127)

	local var1_127 = findTF(arg0_127, "icon_bg/icon")
	local var2_127

	if arg1_127 == AttireConst.TYPE_CHAT_FRAME then
		var2_127 = "chat_frame"
	elseif arg1_127 == AttireConst.TYPE_ICON_FRAME then
		var2_127 = "icon_frame"
	end

	GetImageSpriteFromAtlasAsync("Props/" .. var2_127, "", var1_127)
	setIconName(arg0_127, arg2_127.name, arg3_127)
end

function updateAttireCombatUI(arg0_128, arg1_128, arg2_128, arg3_128)
	local var0_128 = arg2_128.rare

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_128, findTF(arg0_128, "icon_bg"))
	setFrame(findTF(arg0_128, "icon_bg/frame"), var0_128, "frame_battle_ui")

	local var1_128 = findTF(arg0_128, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("Props/" .. arg2_128.display_icon, "", var1_128)
	setIconName(arg0_128, arg2_128.name, arg3_128)
end

function updateActivityMedal(arg0_129, arg1_129, arg2_129)
	local var0_129 = ItemRarity.Rarity2Print(arg1_129.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_129, findTF(arg0_129, "icon_bg"))
	setFrame(findTF(arg0_129, "icon_bg/frame"), var0_129)

	local var1_129 = findTF(arg0_129, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_129.icon, "", var1_129)
	setIconName(arg0_129, arg1_129.name, arg2_129)
end

function updateCover(arg0_130, arg1_130, arg2_130)
	local var0_130 = arg1_130:getDropRarity()

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_130, findTF(arg0_130, "icon_bg"))
	setFrame(findTF(arg0_130, "icon_bg/frame"), var0_130)

	local var1_130 = findTF(arg0_130, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_130:getIcon(), "", var1_130)
	setIconName(arg0_130, arg1_130:getName(), arg2_130)
	setIconStars(arg0_130, false)
end

function updateEmoji(arg0_131, arg1_131, arg2_131)
	local var0_131 = findTF(arg0_131, "icon_bg/icon")
	local var1_131 = "icon_emoji"

	GetImageSpriteFromAtlasAsync("Props/" .. var1_131, "", var0_131)

	local var2_131 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var2_131, findTF(arg0_131, "icon_bg"))
	setFrame(findTF(arg0_131, "icon_bg/frame"), var2_131)
	setIconName(arg0_131, arg1_131.name, arg2_131)
end

function updateEquipmentSkin(arg0_132, arg1_132, arg2_132)
	arg2_132 = arg2_132 or {}

	local var0_132 = EquipmentRarity.Rarity2Print(arg1_132.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_132, findTF(arg0_132, "icon_bg"))
	setFrame(findTF(arg0_132, "icon_bg/frame"), var0_132, "frame_skin")

	local var1_132 = findTF(arg0_132, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. arg1_132.icon, "", var1_132)
	setIconStars(arg0_132, false)
	setIconName(arg0_132, arg1_132.name, arg2_132)
	setIconCount(arg0_132, arg1_132.count)
	setIconColorful(arg0_132, arg1_132.rarity - 1, arg2_132)
end

function NoPosMsgBox(arg0_133, arg1_133, arg2_133, arg3_133)
	local var0_133
	local var1_133 = {}

	if arg1_133 then
		table.insert(var1_133, {
			text = "text_noPos_clear",
			atuoClose = true,
			onCallback = arg1_133
		})
	end

	if arg2_133 then
		table.insert(var1_133, {
			text = "text_noPos_buy",
			atuoClose = true,
			onCallback = arg2_133
		})
	end

	if arg3_133 then
		table.insert(var1_133, {
			text = "text_noPos_intensify",
			atuoClose = true,
			onCallback = arg3_133
		})
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		hideNo = true,
		content = arg0_133,
		custom = var1_133,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function openDestroyEquip()
	if pg.m02:hasMediator(EquipmentMediator.__cname) then
		local var0_134 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_134 and var0_134.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_134
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
		local var0_135 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_135 and var0_135.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_135
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
		onClick = function(arg0_138, arg1_138)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
				page = 3,
				shipId = arg0_138.id,
				shipVOs = arg1_138
			})
		end
	})
end

function GoShoppingMsgBox(arg0_139, arg1_139, arg2_139)
	if arg2_139 then
		local var0_139 = ""

		for iter0_139, iter1_139 in ipairs(arg2_139) do
			local var1_139 = Item.getConfigData(iter1_139[1])

			var0_139 = var0_139 .. i18n(iter1_139[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var1_139.name, iter1_139[2])

			if iter0_139 < #arg2_139 then
				var0_139 = var0_139 .. i18n("text_noRes_info_tip_link")
			end
		end

		if var0_139 ~= "" then
			arg0_139 = arg0_139 .. "\n" .. i18n("text_noRes_tip", var0_139)
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = arg0_139,
		weight = LayerWeightConst.SECOND_LAYER,
		onYes = function()
			gotoChargeScene(arg1_139, arg2_139)
		end
	})
end

function shoppingBatch(arg0_141, arg1_141, arg2_141, arg3_141, arg4_141)
	local var0_141 = pg.shop_template[arg0_141]

	assert(var0_141, "shop_template中找不到商品id：" .. arg0_141)

	local var1_141 = getProxy(PlayerProxy):getData()[id2res(var0_141.resource_type)]
	local var2_141 = arg1_141.price or var0_141.resource_num
	local var3_141 = math.floor(var1_141 / var2_141)

	var3_141 = var3_141 <= 0 and 1 or var3_141
	var3_141 = arg2_141 ~= nil and arg2_141 < var3_141 and arg2_141 or var3_141

	local var4_141 = true
	local var5_141 = 1

	if var0_141 ~= nil and arg1_141.id then
		print(var3_141 * var0_141.num, "--", var3_141)
		assert(Item.getConfigData(arg1_141.id), "item config should be existence")

		local var6_141 = Item.New({
			id = arg1_141.id
		}):getConfig("name")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			needCounter = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_ITEM,
				id = arg1_141.id
			},
			addNum = var0_141.num,
			maxNum = var3_141 * var0_141.num,
			defaultNum = var0_141.num,
			numUpdate = function(arg0_142, arg1_142)
				var5_141 = math.floor(arg1_142 / var0_141.num)

				local var0_142 = var5_141 * var2_141

				if var0_142 > var1_141 then
					setText(arg0_142, i18n(arg3_141, var0_142, arg1_142, COLOR_RED, var6_141))

					var4_141 = false
				else
					setText(arg0_142, i18n(arg3_141, var0_142, arg1_142, COLOR_GREEN, var6_141))

					var4_141 = true
				end
			end,
			onYes = function()
				if var4_141 then
					pg.m02:sendNotification(GAME.SHOPPING, {
						id = arg0_141,
						count = var5_141
					})
				elseif arg4_141 then
					pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_141))
					pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_OR_SKIN_FAILD)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("main_playerInfoLayer_error_changeNameNoGem"))
				end
			end
		})
	end
end

function shoppingBatchNewStyle(arg0_144, arg1_144, arg2_144, arg3_144, arg4_144)
	local var0_144 = pg.shop_template[arg0_144]

	assert(var0_144, "shop_template中找不到商品id：" .. arg0_144)

	local var1_144 = getProxy(PlayerProxy):getData()[id2res(var0_144.resource_type)]
	local var2_144 = arg1_144.price or var0_144.resource_num
	local var3_144 = math.floor(var1_144 / var2_144)

	var3_144 = var3_144 <= 0 and 1 or var3_144
	var3_144 = arg2_144 ~= nil and arg2_144 < var3_144 and arg2_144 or var3_144

	local var4_144 = true
	local var5_144 = 1

	if var0_144 ~= nil and arg1_144.id then
		print(var3_144 * var0_144.num, "--", var3_144)
		assert(Item.getConfigData(arg1_144.id), "item config should be existence")

		local var6_144 = Item.New({
			id = arg1_144.id
		}):getConfig("name")

		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_SHOPPING, {
			drop = Drop.New({
				count = 1,
				type = DROP_TYPE_ITEM,
				id = arg1_144.id
			}),
			price = var2_144,
			addNum = var0_144.num,
			maxNum = var3_144 * var0_144.num,
			defaultNum = var0_144.num,
			numUpdate = function(arg0_145, arg1_145)
				var5_144 = math.floor(arg1_145 / var0_144.num)

				local var0_145 = var5_144 * var2_144

				if var0_145 > var1_144 then
					setTextInNewStyleBox(arg0_145, i18n(arg3_144, var0_145, arg1_145, COLOR_RED, var6_144))

					var4_144 = false
				else
					setTextInNewStyleBox(arg0_145, i18n(arg3_144, var0_145, arg1_145, "#238C40FF", var6_144))

					var4_144 = true
				end
			end,
			btnList = {
				{
					type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.shopping,
					name = i18n("word_buy"),
					func = function()
						if var4_144 then
							pg.m02:sendNotification(GAME.SHOPPING, {
								id = arg0_144,
								count = var5_144
							})
						elseif arg4_144 then
							pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_144))
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

function gotoChargeScene(arg0_147, arg1_147)
	local var0_147 = getProxy(ContextProxy)
	local var1_147 = getProxy(ContextProxy):getCurrentContext()

	if instanceof(var1_147.mediator, NewShopMainMediator) then
		var1_147.mediator:getViewComponent():switchSubViewByTogger(arg0_147)
	else
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
			wrap = arg0_147 or ChargeScene.TYPE_ITEM,
			noRes = arg1_147
		})
	end

	pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_OR_SKIN_FAILD)
end

function clearDrop(arg0_148)
	local var0_148 = findTF(arg0_148, "icon_bg")
	local var1_148 = findTF(arg0_148, "icon_bg/frame")
	local var2_148 = findTF(arg0_148, "icon_bg/icon")
	local var3_148 = findTF(arg0_148, "icon_bg/icon/icon")

	clearImageSprite(var0_148)
	clearImageSprite(var1_148)
	clearImageSprite(var2_148)

	if var3_148 then
		clearImageSprite(var3_148)
	end
end

local var9_0 = {
	red = Color.New(1, 0.25, 0.25),
	blue = Color.New(0.11, 0.55, 0.64),
	yellow = Color.New(0.92, 0.52, 0)
}

function updateSkill(arg0_149, arg1_149, arg2_149, arg3_149)
	local var0_149 = findTF(arg0_149, "skill")
	local var1_149 = findTF(arg0_149, "lock")
	local var2_149 = findTF(arg0_149, "unknown")

	if arg1_149 then
		setActive(var0_149, true)
		setActive(var2_149, false)
		setActive(var1_149, not arg2_149)
		LoadImageSpriteAsync("skillicon/" .. arg1_149.icon, findTF(var0_149, "icon"))

		local var3_149 = arg1_149.color or "blue"

		setText(findTF(var0_149, "name"), shortenString(getSkillName(arg1_149.id), arg3_149 or 8))

		local var4_149 = findTF(var0_149, "level")

		setText(var4_149, "LEVEL: " .. (arg2_149 and arg2_149.level or "??"))
		setTextColor(var4_149, var9_0[var3_149])
	else
		setActive(var0_149, false)
		setActive(var2_149, true)
		setActive(var1_149, false)
	end
end

local var10_0 = true

function onBackButton(arg0_150, arg1_150, arg2_150, arg3_150)
	local var0_150 = GetOrAddComponent(arg1_150, "UILongPressTrigger")

	assert(arg2_150, "callback should exist")

	var0_150.longPressThreshold = defaultValue(arg3_150, 1)

	local function var1_150(arg0_151)
		return function()
			if var10_0 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SOUND_BACK)
			end

			local var0_152, var1_152 = arg2_150()

			if var0_152 then
				arg0_151(var1_152)
			end
		end
	end

	local var2_150 = var0_150.onReleased

	pg.DelegateInfo.Add(arg0_150, var2_150)
	var2_150:RemoveAllListeners()
	var2_150:AddListener(var1_150(function(arg0_153)
		arg0_153:emit(BaseUI.ON_BACK)
	end))

	local var3_150 = var0_150.onLongPressed

	pg.DelegateInfo.Add(arg0_150, var3_150)
	var3_150:RemoveAllListeners()
	var3_150:AddListener(var1_150(function(arg0_154)
		arg0_154:emit(BaseUI.ON_HOME)
	end))
end

function GetZeroTime()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)
end

function GetHalfHour()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0, 1800)
end

function GetNextHour(arg0_157)
	local var0_157 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_157, var2_157 = pg.TimeMgr.GetInstance():parseTimeFrom(var0_157)

	return var1_157 * 86400 + (var2_157 + arg0_157) * 3600
end

function GetPerceptualSize(arg0_158, arg1_158)
	local function var0_158(arg0_159)
		if not arg0_159 then
			return 0, 1
		elseif arg0_159 > 240 then
			return 4, 1
		elseif arg0_159 > 225 then
			return 3, 1
		elseif arg0_159 > 192 then
			return 2, 1
		elseif arg0_159 < 126 then
			return 1, arg1_158 or 0.5
		else
			return 1, 1
		end
	end

	if type(arg0_158) == "number" then
		return var0_158(arg0_158)
	end

	local var1_158 = 1
	local var2_158 = 0
	local var3_158 = 0
	local var4_158 = #arg0_158

	while var1_158 <= var4_158 do
		local var5_158 = string.byte(arg0_158, var1_158)
		local var6_158, var7_158 = var0_158(var5_158)

		var1_158 = var1_158 + var6_158
		var2_158 = var2_158 + var7_158
	end

	return var2_158
end

function shortenString(arg0_160, arg1_160, arg2_160)
	local var0_160 = 1
	local var1_160 = 0
	local var2_160 = 0
	local var3_160 = #arg0_160

	while var0_160 <= var3_160 do
		local var4_160 = string.byte(arg0_160, var0_160)
		local var5_160, var6_160 = GetPerceptualSize(var4_160, arg2_160)

		var0_160 = var0_160 + var5_160
		var1_160 = var1_160 + var6_160

		if arg1_160 <= math.ceil(var1_160) then
			var2_160 = var0_160

			break
		end
	end

	if var2_160 == 0 or var3_160 < var2_160 then
		return arg0_160
	end

	return string.sub(arg0_160, 1, var2_160 - 1) .. ".."
end

function shouldShortenString(arg0_161, arg1_161)
	local var0_161 = 1
	local var1_161 = 0
	local var2_161 = 0
	local var3_161 = #arg0_161

	while var0_161 <= var3_161 do
		local var4_161 = string.byte(arg0_161, var0_161)
		local var5_161, var6_161 = GetPerceptualSize(var4_161)

		var0_161 = var0_161 + var5_161
		var1_161 = var1_161 + var6_161

		if arg1_161 <= math.ceil(var1_161) then
			var2_161 = var0_161

			break
		end
	end

	if var2_161 == 0 or var3_161 < var2_161 then
		return false
	end

	return true
end

function nameValidityCheck(arg0_162, arg1_162, arg2_162, arg3_162)
	local var0_162 = true
	local var1_162, var2_162 = utf8_to_unicode(arg0_162)
	local var3_162 = filterEgyUnicode(filterSpecChars(arg0_162))
	local var4_162 = wordVer(arg0_162)

	if not checkSpaceValid(arg0_162) then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_162[1]))

		var0_162 = false
	elseif var4_162 > 0 or var3_162 ~= arg0_162 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_162[4]))

		var0_162 = false
	elseif var2_162 < arg1_162 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_162[2]))

		var0_162 = false
	elseif arg2_162 < var2_162 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_162[3]))

		var0_162 = false
	end

	return var0_162
end

function checkSpaceValid(arg0_163)
	if PLATFORM_CODE == PLATFORM_US then
		return true
	end

	local var0_163 = string.gsub(arg0_163, " ", "")

	return arg0_163 == string.gsub(var0_163, "　", "")
end

function filterSpecChars(arg0_164)
	local var0_164 = {}
	local var1_164 = 0
	local var2_164 = 0
	local var3_164 = 0
	local var4_164 = 1

	while var4_164 <= #arg0_164 do
		local var5_164 = string.byte(arg0_164, var4_164)

		if not var5_164 then
			break
		end

		if var5_164 >= 48 and var5_164 <= 57 or var5_164 >= 65 and var5_164 <= 90 or var5_164 == 95 or var5_164 >= 97 and var5_164 <= 122 then
			table.insert(var0_164, string.char(var5_164))
		elseif var5_164 >= 228 and var5_164 <= 233 then
			local var6_164 = string.byte(arg0_164, var4_164 + 1)
			local var7_164 = string.byte(arg0_164, var4_164 + 2)

			if var6_164 and var7_164 and var6_164 >= 128 and var6_164 <= 191 and var7_164 >= 128 and var7_164 <= 191 then
				var4_164 = var4_164 + 2

				table.insert(var0_164, string.char(var5_164, var6_164, var7_164))

				var1_164 = var1_164 + 1
			end
		elseif var5_164 == 45 or var5_164 == 40 or var5_164 == 41 then
			table.insert(var0_164, string.char(var5_164))
		elseif var5_164 == 194 then
			local var8_164 = string.byte(arg0_164, var4_164 + 1)

			if var8_164 == 183 then
				var4_164 = var4_164 + 1

				table.insert(var0_164, string.char(var5_164, var8_164))

				var1_164 = var1_164 + 1
			end
		elseif var5_164 == 239 then
			local var9_164 = string.byte(arg0_164, var4_164 + 1)
			local var10_164 = string.byte(arg0_164, var4_164 + 2)

			if var9_164 == 188 and (var10_164 == 136 or var10_164 == 137) then
				var4_164 = var4_164 + 2

				table.insert(var0_164, string.char(var5_164, var9_164, var10_164))

				var1_164 = var1_164 + 1
			end
		elseif var5_164 == 206 or var5_164 == 207 then
			local var11_164 = string.byte(arg0_164, var4_164 + 1)

			if var5_164 == 206 and var11_164 >= 177 or var5_164 == 207 and var11_164 <= 134 then
				var4_164 = var4_164 + 1

				table.insert(var0_164, string.char(var5_164, var11_164))

				var1_164 = var1_164 + 1
			end
		elseif var5_164 == 227 and PLATFORM_CODE == PLATFORM_JP then
			local var12_164 = string.byte(arg0_164, var4_164 + 1)
			local var13_164 = string.byte(arg0_164, var4_164 + 2)

			if var12_164 and var13_164 and var12_164 > 128 and var12_164 <= 191 and var13_164 >= 128 and var13_164 <= 191 then
				var4_164 = var4_164 + 2

				table.insert(var0_164, string.char(var5_164, var12_164, var13_164))

				var2_164 = var2_164 + 1
			end
		elseif var5_164 >= 224 and PLATFORM_CODE == PLATFORM_KR then
			local var14_164 = string.byte(arg0_164, var4_164 + 1)
			local var15_164 = string.byte(arg0_164, var4_164 + 2)

			if var14_164 and var15_164 and var14_164 >= 128 and var14_164 <= 191 and var15_164 >= 128 and var15_164 <= 191 then
				var4_164 = var4_164 + 2

				table.insert(var0_164, string.char(var5_164, var14_164, var15_164))

				var3_164 = var3_164 + 1
			end
		elseif PLATFORM_CODE == PLATFORM_US then
			if var4_164 ~= 1 and var5_164 == 32 and string.byte(arg0_164, var4_164 + 1) ~= 32 then
				table.insert(var0_164, string.char(var5_164))
			end

			if var5_164 >= 192 and var5_164 <= 223 then
				local var16_164 = string.byte(arg0_164, var4_164 + 1)

				var4_164 = var4_164 + 1

				if var5_164 == 194 and var16_164 and var16_164 >= 128 then
					table.insert(var0_164, string.char(var5_164, var16_164))
				elseif var5_164 == 195 and var16_164 and var16_164 <= 191 then
					table.insert(var0_164, string.char(var5_164, var16_164))
				end
			end
		end

		var4_164 = var4_164 + 1
	end

	return table.concat(var0_164), var1_164 + var2_164 + var3_164
end

function filterEgyUnicode(arg0_165)
	arg0_165 = string.gsub(arg0_165, "�[�-�][�-�]", "")
	arg0_165 = string.gsub(arg0_165, "�[�-�]", "")

	return arg0_165
end

function shiftPanel(arg0_166, arg1_166, arg2_166, arg3_166, arg4_166, arg5_166, arg6_166, arg7_166, arg8_166)
	arg3_166 = arg3_166 or 0.2

	if arg5_166 then
		LeanTween.cancel(go(arg0_166))
	end

	local var0_166 = rtf(arg0_166)

	arg1_166 = arg1_166 or var0_166.anchoredPosition.x
	arg2_166 = arg2_166 or var0_166.anchoredPosition.y

	local var1_166 = LeanTween.move(var0_166, Vector3(arg1_166, arg2_166, 0), arg3_166)

	arg7_166 = arg7_166 or LeanTweenType.easeInOutSine

	var1_166:setEase(arg7_166)

	if arg4_166 then
		var1_166:setDelay(arg4_166)
	end

	if arg6_166 then
		GetOrAddComponent(arg0_166, "CanvasGroup").blocksRaycasts = false
	end

	var1_166:setOnComplete(System.Action(function()
		if arg8_166 then
			arg8_166()
		end

		if arg6_166 then
			GetOrAddComponent(arg0_166, "CanvasGroup").blocksRaycasts = true
		end
	end))

	return var1_166
end

function TweenValue(arg0_168, arg1_168, arg2_168, arg3_168, arg4_168, arg5_168, arg6_168, arg7_168)
	local var0_168 = LeanTween.value(go(arg0_168), arg1_168, arg2_168, arg3_168):setOnUpdate(System.Action_float(function(arg0_169)
		if arg5_168 then
			arg5_168(arg0_169)
		end
	end)):setOnComplete(System.Action(function()
		if arg6_168 then
			arg6_168()
		end
	end)):setDelay(arg4_168 or 0)

	if arg7_168 and arg7_168 > 0 then
		var0_168:setRepeat(arg7_168)
	end

	return var0_168
end

function rotateAni(arg0_171, arg1_171, arg2_171)
	return LeanTween.rotate(rtf(arg0_171), 360 * arg1_171, arg2_171):setLoopClamp()
end

function blinkAni(arg0_172, arg1_172, arg2_172, arg3_172)
	return LeanTween.alpha(rtf(arg0_172), arg3_172 or 0, arg1_172):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(arg2_172 or 0)
end

function scaleAni(arg0_173, arg1_173, arg2_173, arg3_173)
	return LeanTween.scale(rtf(arg0_173), arg3_173 or 0, arg1_173):setLoopPingPong(arg2_173 or 0)
end

function floatAni(arg0_174, arg1_174, arg2_174, arg3_174)
	local var0_174 = arg0_174.localPosition.y + arg1_174

	return LeanTween.moveY(rtf(arg0_174), var0_174, arg2_174):setLoopPingPong(arg3_174 or 0)
end

local var11_0 = tostring

function tostring(arg0_175)
	if arg0_175 == nil then
		return "nil"
	end

	local var0_175 = var11_0(arg0_175)

	if var0_175 == nil then
		if type(arg0_175) == "table" then
			return "{}"
		end

		return " ~nil"
	end

	return var0_175
end

function wordVer(arg0_176, arg1_176)
	if arg0_176.match(arg0_176, ChatConst.EmojiCodeMatch) then
		return 0, arg0_176
	end

	arg1_176 = arg1_176 or {}

	local var0_176 = filterEgyUnicode(arg0_176)

	if #var0_176 ~= #arg0_176 then
		if arg1_176.isReplace then
			arg0_176 = var0_176
		else
			return 1
		end
	end

	local var1_176 = wordSplit(arg0_176)
	local var2_176 = pg.word_template
	local var3_176 = pg.word_legal_template

	arg1_176.isReplace = arg1_176.isReplace or false
	arg1_176.replaceWord = arg1_176.replaceWord or "*"

	local var4_176 = #var1_176
	local var5_176 = 1
	local var6_176 = ""
	local var7_176 = 0

	while var5_176 <= var4_176 do
		local var8_176, var9_176, var10_176 = wordLegalMatch(var1_176, var3_176, var5_176)

		if var8_176 then
			var5_176 = var9_176
			var6_176 = var6_176 .. var10_176
		else
			local var11_176, var12_176, var13_176 = wordVerMatch(var1_176, var2_176, arg1_176, var5_176, "", false, var5_176, "")

			if var11_176 then
				var5_176 = var12_176
				var7_176 = var7_176 + 1

				if arg1_176.isReplace then
					var6_176 = var6_176 .. var13_176
				end
			else
				if arg1_176.isReplace then
					var6_176 = var6_176 .. var1_176[var5_176]
				end

				var5_176 = var5_176 + 1
			end
		end
	end

	if arg1_176.isReplace then
		return var7_176, var6_176
	else
		return var7_176
	end
end

function wordLegalMatch(arg0_177, arg1_177, arg2_177, arg3_177, arg4_177)
	if arg2_177 > #arg0_177 then
		return arg3_177, arg2_177, arg4_177
	end

	local var0_177 = arg0_177[arg2_177]
	local var1_177 = arg1_177[var0_177]

	arg4_177 = arg4_177 == nil and "" or arg4_177

	if var1_177 then
		if var1_177.this then
			return wordLegalMatch(arg0_177, var1_177, arg2_177 + 1, true, arg4_177 .. var0_177)
		else
			return wordLegalMatch(arg0_177, var1_177, arg2_177 + 1, false, arg4_177 .. var0_177)
		end
	else
		return arg3_177, arg2_177, arg4_177
	end
end

local var12_0 = string.byte("a")
local var13_0 = string.byte("z")
local var14_0 = string.byte("A")
local var15_0 = string.byte("Z")

local function var16_0(arg0_178)
	if not arg0_178 then
		return arg0_178
	end

	local var0_178 = string.byte(arg0_178)

	if var0_178 > 128 then
		return
	end

	if var0_178 >= var12_0 and var0_178 <= var13_0 then
		return string.char(var0_178 - 32)
	elseif var0_178 >= var14_0 and var0_178 <= var15_0 then
		return string.char(var0_178 + 32)
	else
		return arg0_178
	end
end

function wordVerMatch(arg0_179, arg1_179, arg2_179, arg3_179, arg4_179, arg5_179, arg6_179, arg7_179)
	if arg3_179 > #arg0_179 then
		return arg5_179, arg6_179, arg7_179
	end

	local var0_179 = arg0_179[arg3_179]
	local var1_179 = arg1_179[var0_179]

	if var1_179 then
		local var2_179, var3_179, var4_179 = wordVerMatch(arg0_179, var1_179, arg2_179, arg3_179 + 1, arg2_179.isReplace and arg4_179 .. arg2_179.replaceWord or arg4_179, var1_179.this or arg5_179, var1_179.this and arg3_179 + 1 or arg6_179, var1_179.this and (arg2_179.isReplace and arg4_179 .. arg2_179.replaceWord or arg4_179) or arg7_179)

		if var2_179 then
			return var2_179, var3_179, var4_179
		end
	end

	local var5_179 = var16_0(var0_179)
	local var6_179 = arg1_179[var5_179]

	if var5_179 ~= var0_179 and var6_179 then
		local var7_179, var8_179, var9_179 = wordVerMatch(arg0_179, var6_179, arg2_179, arg3_179 + 1, arg2_179.isReplace and arg4_179 .. arg2_179.replaceWord or arg4_179, var6_179.this or arg5_179, var6_179.this and arg3_179 + 1 or arg6_179, var6_179.this and (arg2_179.isReplace and arg4_179 .. arg2_179.replaceWord or arg4_179) or arg7_179)

		if var7_179 then
			return var7_179, var8_179, var9_179
		end
	end

	return arg5_179, arg6_179, arg7_179
end

function wordSplit(arg0_180)
	local var0_180 = {}

	for iter0_180 in arg0_180.gmatch(arg0_180, "[\x01-\x7F�-�][�-�]*") do
		var0_180[#var0_180 + 1] = iter0_180
	end

	return var0_180
end

function contentWrap(arg0_181, arg1_181, arg2_181)
	local var0_181 = LuaHelper.WrapContent(arg0_181, arg1_181, arg2_181)

	return #var0_181 ~= #arg0_181, var0_181
end

function cancelRich(arg0_182)
	local var0_182

	for iter0_182 = 1, 20 do
		local var1_182

		arg0_182, var1_182 = string.gsub(arg0_182, "<([^>]*)>", "%1")

		if var1_182 <= 0 then
			break
		end
	end

	return arg0_182
end

function cancelColorRich(arg0_183)
	local var0_183

	for iter0_183 = 1, 20 do
		local var1_183

		arg0_183, var1_183 = string.gsub(arg0_183, "<color=#[a-zA-Z0-9]+>(.-)</color>", "%1")

		if var1_183 <= 0 then
			break
		end
	end

	return arg0_183
end

function getSkillConfig(arg0_184)
	local var0_184 = pg.buffCfg["buff_" .. arg0_184]

	if not var0_184 then
		return
	end

	local var1_184 = Clone(var0_184)

	var1_184.name = getSkillName(arg0_184)
	var1_184.desc = HXSet.hxLan(var1_184.desc)
	var1_184.desc_get = HXSet.hxLan(var1_184.desc_get)

	_.each(var1_184, function(arg0_185)
		arg0_185.desc = HXSet.hxLan(arg0_185.desc)
	end)

	return var1_184
end

function getSkillName(arg0_186)
	local var0_186 = pg.skill_data_template[arg0_186] or pg.skill_data_display[arg0_186]

	if var0_186 then
		return HXSet.hxLan(var0_186.name)
	else
		return ""
	end
end

function getSkillDescGet(arg0_187, arg1_187)
	local var0_187 = arg1_187 and pg.skill_world_display[arg0_187] and setmetatable({}, {
		__index = function(arg0_188, arg1_188)
			return pg.skill_world_display[arg0_187][arg1_188] or pg.skill_data_template[arg0_187][arg1_188]
		end
	}) or pg.skill_data_template[arg0_187]

	if not var0_187 then
		return ""
	end

	local var1_187 = var0_187.desc_get ~= "" and var0_187.desc_get or var0_187.desc

	for iter0_187, iter1_187 in pairs(var0_187.desc_get_add) do
		local var2_187 = setColorStr(iter1_187[1], COLOR_GREEN)

		if iter1_187[2] then
			var2_187 = var2_187 .. specialGSub(i18n("word_skill_desc_get"), "$1", setColorStr(iter1_187[2], COLOR_GREEN))
		end

		var1_187 = specialGSub(var1_187, "$" .. iter0_187, var2_187)
	end

	return HXSet.hxLan(var1_187)
end

function getSkillDescLearn(arg0_189, arg1_189, arg2_189)
	local var0_189 = arg2_189 and pg.skill_world_display[arg0_189] and setmetatable({}, {
		__index = function(arg0_190, arg1_190)
			return pg.skill_world_display[arg0_189][arg1_190] or pg.skill_data_template[arg0_189][arg1_190]
		end
	}) or pg.skill_data_template[arg0_189]

	if not var0_189 then
		return ""
	end

	local var1_189 = var0_189.desc

	if not var0_189.desc_add then
		return HXSet.hxLan(var1_189)
	end

	for iter0_189, iter1_189 in pairs(var0_189.desc_add) do
		local var2_189 = iter1_189[arg1_189][1]

		if iter1_189[arg1_189][2] then
			var2_189 = var2_189 .. specialGSub(i18n("word_skill_desc_learn"), "$1", iter1_189[arg1_189][2])
		end

		var1_189 = specialGSub(var1_189, "$" .. iter0_189, setColorStr(var2_189, COLOR_YELLOW))
	end

	return HXSet.hxLan(var1_189)
end

function getSkillDesc(arg0_191, arg1_191, arg2_191)
	local var0_191 = arg2_191 and pg.skill_world_display[arg0_191] and setmetatable({}, {
		__index = function(arg0_192, arg1_192)
			return pg.skill_world_display[arg0_191][arg1_192] or pg.skill_data_template[arg0_191][arg1_192]
		end
	}) or pg.skill_data_template[arg0_191]

	if not var0_191 then
		return ""
	end

	local var1_191 = var0_191.desc

	if not var0_191.desc_add then
		return HXSet.hxLan(var1_191)
	end

	for iter0_191, iter1_191 in pairs(var0_191.desc_add) do
		local var2_191 = setColorStr(iter1_191[arg1_191][1], COLOR_GREEN)

		var1_191 = specialGSub(var1_191, "$" .. iter0_191, var2_191)
	end

	return HXSet.hxLan(var1_191)
end

function specialGSub(arg0_193, arg1_193, arg2_193)
	arg0_193 = string.gsub(arg0_193, "<color=#", "<color=NNN")
	arg0_193 = string.gsub(arg0_193, "#", "")
	arg2_193 = string.gsub(arg2_193, "%%", "%%%%")
	arg0_193 = string.gsub(arg0_193, arg1_193, arg2_193)
	arg0_193 = string.gsub(arg0_193, "<color=NNN", "<color=#")

	return arg0_193
end

function topAnimation(arg0_194, arg1_194, arg2_194, arg3_194, arg4_194, arg5_194)
	local var0_194 = {}

	arg4_194 = arg4_194 or 0.27

	local var1_194 = 0.05

	if arg0_194 then
		local var2_194 = arg0_194.transform.localPosition.x

		setAnchoredPosition(arg0_194, {
			x = var2_194 - 500
		})
		shiftPanel(arg0_194, var2_194, nil, 0.05, arg4_194, true, true)
		setActive(arg0_194, true)
	end

	setActive(arg1_194, false)
	setActive(arg2_194, false)
	setActive(arg3_194, false)

	for iter0_194 = 1, 3 do
		table.insert(var0_194, LeanTween.delayedCall(arg4_194 + 0.13 + var1_194 * iter0_194, System.Action(function()
			if arg1_194 then
				setActive(arg1_194, not arg1_194.gameObject.activeSelf)
			end
		end)).uniqueId)
		table.insert(var0_194, LeanTween.delayedCall(arg4_194 + 0.02 + var1_194 * iter0_194, System.Action(function()
			if arg2_194 then
				setActive(arg2_194, not go(arg2_194).activeSelf)
			end

			if arg2_194 then
				setActive(arg3_194, not go(arg3_194).activeSelf)
			end
		end)).uniqueId)
	end

	if arg5_194 then
		table.insert(var0_194, LeanTween.delayedCall(arg4_194 + 0.13 + var1_194 * 3 + 0.1, System.Action(function()
			arg5_194()
		end)).uniqueId)
	end

	return var0_194
end

function cancelTweens(arg0_198)
	assert(arg0_198, "must provide cancel targets, LeanTween.cancelAll is not allow")

	for iter0_198, iter1_198 in ipairs(arg0_198) do
		if iter1_198 then
			LeanTween.cancel(iter1_198)
		end
	end
end

function getOfflineTimeStamp(arg0_199)
	local var0_199 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_199
	local var1_199 = ""

	if var0_199 <= 59 then
		var1_199 = i18n("just_now")
	elseif var0_199 <= 3599 then
		var1_199 = i18n("several_minutes_before", math.floor(var0_199 / 60))
	elseif var0_199 <= 86399 then
		var1_199 = i18n("several_hours_before", math.floor(var0_199 / 3600))
	else
		var1_199 = i18n("several_days_before", math.floor(var0_199 / 86400))
	end

	return var1_199
end

function playMovie(arg0_200, arg1_200, arg2_200)
	local var0_200 = GameObject.Find("OverlayCamera/Overlay/UITop/MoviePanel")

	if not IsNil(var0_200) then
		pg.UIMgr.GetInstance():LoadingOn()
		WWWLoader.Inst:LoadStreamingAsset(arg0_200, function(arg0_201)
			pg.UIMgr.GetInstance():LoadingOff()

			local var0_201 = GCHandle.Alloc(arg0_201, GCHandleType.Pinned)

			setActive(var0_200, true)

			local var1_201 = var0_200:AddComponent(typeof(CriManaMovieControllerForUI))

			var1_201.player:SetData(arg0_201, arg0_201.Length)

			var1_201.target = var0_200:GetComponent(typeof(Image))
			var1_201.loop = false
			var1_201.additiveMode = false
			var1_201.playOnStart = true

			local var2_201

			var2_201 = Timer.New(function()
				if var1_201.player.status == CriMana.Player.Status.PlayEnd or var1_201.player.status == CriMana.Player.Status.Stop or var1_201.player.status == CriMana.Player.Status.Error then
					var2_201:Stop()
					Object.Destroy(var1_201)
					GCHandle.Free(var0_201)
					setActive(var0_200, false)

					if arg1_200 then
						arg1_200()
					end
				end
			end, 0.2, -1)

			var2_201:Start()
			removeOnButton(var0_200)

			if arg2_200 then
				onButton(nil, var0_200, function()
					var1_201:Stop()
					GetOrAddComponent(var0_200, typeof(Button)).onClick:RemoveAllListeners()
				end, SFX_CANCEL)
			end
		end)
	elseif arg1_200 then
		arg1_200()
	end
end

PaintCameraAdjustOn = false

function cameraPaintViewAdjust(arg0_204)
	if PaintCameraAdjustOn ~= arg0_204 then
		local var0_204 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(CanvasScaler))

		if arg0_204 then
			var0_204.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight
			var0_204.matchWidthOrHeight = 1
		else
			var0_204.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand
		end

		pg.CameraFixMgr.GetInstance():BlockCameraRatioControll(arg0_204)

		PaintCameraAdjustOn = arg0_204
	end
end

function ManhattonDist(arg0_205, arg1_205)
	return math.abs(arg0_205.row - arg1_205.row) + math.abs(arg0_205.column - arg1_205.column)
end

function checkFirstHelpShow(arg0_206)
	local var0_206 = getProxy(SettingsProxy)

	if not var0_206:checkReadHelp(arg0_206) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[arg0_206].tip
		})
		var0_206:recordReadHelp(arg0_206)
	end
end

preOrientation = nil
preNotchFitterEnabled = false

function openPortrait(arg0_207)
	preOrientation = Input.deviceOrientation:ToString()

	originalPrint("Begining Orientation:" .. preOrientation)

	Screen.autorotateToPortrait = true
	Screen.autorotateToPortraitUpsideDown = true

	cameraPaintViewAdjust(true)
end

function closePortrait(arg0_208)
	Screen.autorotateToPortrait = false
	Screen.autorotateToPortraitUpsideDown = false

	originalPrint("Closing Orientation:" .. preOrientation)

	Screen.orientation = ScreenOrientation.LandscapeLeft

	local var0_208 = Timer.New(function()
		Screen.orientation = ScreenOrientation.AutoRotation
	end, 0.2, 1):Start()

	cameraPaintViewAdjust(false)
end

function enableNotch(arg0_210, arg1_210)
	if arg0_210 == nil then
		return
	end

	arg0_210:GetComponent("NotchAdapt").enabled = arg1_210
end

function comma_value(arg0_211)
	local var0_211 = arg0_211
	local var1_211 = 0

	repeat
		local var2_211

		var0_211, var2_211 = string.gsub(var0_211, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var2_211 == 0

	return var0_211
end

local var17_0 = 0.2

function SwitchPanel(arg0_212, arg1_212, arg2_212, arg3_212, arg4_212, arg5_212)
	arg3_212 = defaultValue(arg3_212, var17_0)

	if arg5_212 then
		LeanTween.cancel(go(arg0_212))
	end

	local var0_212 = Vector3.New(tf(arg0_212).localPosition.x, tf(arg0_212).localPosition.y, tf(arg0_212).localPosition.z)

	if arg1_212 then
		var0_212.x = arg1_212
	end

	if arg2_212 then
		var0_212.y = arg2_212
	end

	local var1_212 = LeanTween.move(rtf(arg0_212), var0_212, arg3_212):setEase(LeanTweenType.easeInOutSine)

	if arg4_212 then
		var1_212:setDelay(arg4_212)
	end

	return var1_212
end

function updateActivityTaskStatus(arg0_213)
	local var0_213 = arg0_213:getConfig("config_id")
	local var1_213, var2_213 = getActivityTask(arg0_213, true)

	if not var2_213 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_213.id
		})

		return true
	end

	return false
end

function updateCrusingActivityTask(arg0_214)
	local var0_214 = getProxy(TaskProxy)
	local var1_214 = arg0_214:getNDay()
	local var2_214 = pg.TimeMgr.GetInstance():GetServerOverWeek(arg0_214:getStartTime())

	for iter0_214, iter1_214 in ipairs(arg0_214:getConfig("config_data")) do
		local var3_214 = pg.battlepass_task_group[iter1_214]

		if var3_214 and var2_214 >= var3_214.group_mask then
			if underscore.any(underscore.flatten(var3_214.task_group), function(arg0_215)
				return var0_214:getTaskVO(arg0_215) == nil
			end) then
				pg.m02:sendNotification(GAME.CRUSING_CMD, {
					cmd = 1,
					activity_id = arg0_214.id
				})

				return true
			end
		elseif not var3_214 then
			warning("battlepass_task_group表中不存在 id = " .. iter1_214)
		end
	end

	return false
end

function setShipCardFrame(arg0_216, arg1_216, arg2_216)
	arg0_216.localScale = Vector3.one
	arg0_216.anchorMin = Vector2.zero
	arg0_216.anchorMax = Vector2.one

	local var0_216 = arg2_216 or arg1_216

	GetImageSpriteFromAtlasAsync("shipframe", var0_216, arg0_216)

	local var1_216 = pg.frame_resource[var0_216]

	if var1_216 then
		local var2_216 = var1_216.param

		arg0_216.offsetMin = Vector2(var2_216[1], var2_216[2])
		arg0_216.offsetMax = Vector2(var2_216[3], var2_216[4])
	else
		arg0_216.offsetMin = Vector2.zero
		arg0_216.offsetMax = Vector2.zero
	end
end

function setRectShipCardFrame(arg0_217, arg1_217, arg2_217)
	arg0_217.localScale = Vector3.one
	arg0_217.anchorMin = Vector2.zero
	arg0_217.anchorMax = Vector2.one

	setImageSprite(arg0_217, GetSpriteFromAtlas("shipframeb", "b" .. (arg2_217 or arg1_217)))

	local var0_217 = "b" .. (arg2_217 or arg1_217)
	local var1_217 = pg.frame_resource[var0_217]

	if var1_217 then
		local var2_217 = var1_217.param

		arg0_217.offsetMin = Vector2(var2_217[1], var2_217[2])
		arg0_217.offsetMax = Vector2(var2_217[3], var2_217[4])
	else
		arg0_217.offsetMin = Vector2.zero
		arg0_217.offsetMax = Vector2.zero
	end
end

function setFrameEffect(arg0_218, arg1_218)
	if arg1_218 then
		local var0_218 = arg1_218 .. "(Clone)"
		local var1_218 = false

		eachChild(arg0_218, function(arg0_219)
			setActive(arg0_219, arg0_219.name == var0_218)

			var1_218 = var1_218 or arg0_219.name == var0_218
		end)

		if not var1_218 then
			LoadAndInstantiateAsync("effect", arg1_218, function(arg0_220)
				if IsNil(arg0_218) or findTF(arg0_218, var0_218) then
					Object.Destroy(arg0_220)
				else
					setParent(arg0_220, arg0_218)
					setActive(arg0_220, true)
				end
			end)
		end
	end

	setActive(arg0_218, arg1_218)
end

function setProposeMarkIcon(arg0_221, arg1_221)
	local var0_221 = arg0_221:Find("proposeShipCard(Clone)")
	local var1_221 = arg1_221.propose and not arg1_221:ShowPropose()

	if var0_221 then
		setActive(var0_221, var1_221)
	elseif var1_221 then
		pg.PoolMgr.GetInstance():GetUI("proposeShipCard", true, function(arg0_222)
			if IsNil(arg0_221) or arg0_221:Find("proposeShipCard(Clone)") then
				pg.PoolMgr.GetInstance():ReturnUI("proposeShipCard", arg0_222)
			else
				setParent(arg0_222, arg0_221, false)
			end
		end)
	end
end

function flushShipCard(arg0_223, arg1_223)
	local var0_223 = arg1_223:rarity2bgPrint()
	local var1_223 = findTF(arg0_223, "content/bg")

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var0_223, "", var1_223)

	local var2_223 = findTF(arg0_223, "content/ship_icon")
	local var3_223 = arg1_223 and {
		"shipYardIcon/" .. arg1_223:getPainting(),
		arg1_223:getPainting()
	} or {
		"shipYardIcon/unknown",
		""
	}

	GetImageSpriteFromAtlasAsync(var3_223[1], var3_223[2], var2_223)

	local var4_223 = arg1_223:getShipType()
	local var5_223 = findTF(arg0_223, "content/info/top/type")

	GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var4_223), var5_223)
	setText(findTF(arg0_223, "content/dockyard/lv/Text"), defaultValue(arg1_223.level, 1))

	local var6_223 = arg1_223:getStar()
	local var7_223 = arg1_223:getMaxStar()
	local var8_223 = findTF(arg0_223, "content/front/stars")

	setActive(var8_223, true)

	local var9_223 = findTF(var8_223, "star_tpl")
	local var10_223 = var8_223.childCount

	for iter0_223 = 1, Ship.CONFIG_MAX_STAR do
		local var11_223 = var10_223 < iter0_223 and cloneTplTo(var9_223, var8_223) or var8_223:GetChild(iter0_223 - 1)

		setActive(var11_223, iter0_223 <= var7_223)
		triggerToggle(var11_223, iter0_223 <= var6_223)
	end

	local var12_223 = findTF(arg0_223, "content/front/frame")
	local var13_223, var14_223 = arg1_223:GetFrameAndEffect()

	setShipCardFrame(var12_223, var0_223, var13_223)
	setFrameEffect(findTF(arg0_223, "content/front/bg_other"), var14_223)
	setProposeMarkIcon(arg0_223:Find("content/dockyard/propose"), arg1_223)
end

function TweenItemAlphaAndWhite(arg0_224)
	LeanTween.cancel(arg0_224)

	local var0_224 = GetOrAddComponent(arg0_224, "CanvasGroup")

	var0_224.alpha = 0

	LeanTween.alphaCanvas(var0_224, 1, 0.2):setUseEstimatedTime(true)

	local var1_224 = findTF(arg0_224.transform, "white_mask")

	if var1_224 then
		setActive(var1_224, false)
	end
end

function ClearTweenItemAlphaAndWhite(arg0_225)
	LeanTween.cancel(arg0_225)

	GetOrAddComponent(arg0_225, "CanvasGroup").alpha = 0
end

function getGroupOwnSkins(arg0_226)
	local var0_226 = {}
	local var1_226 = getProxy(ShipSkinProxy):getSkinList()
	local var2_226 = getProxy(CollectionProxy):getShipGroup(arg0_226)

	if var2_226 then
		local var3_226 = ShipGroup.getSkinList(arg0_226)

		for iter0_226, iter1_226 in ipairs(var3_226) do
			if iter1_226.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var1_226, iter1_226.id) or iter1_226.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var2_226.trans or iter1_226.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var2_226.married == 1 then
				var0_226[iter1_226.id] = true
			end
		end
	end

	return var0_226
end

function split(arg0_227, arg1_227)
	local var0_227 = {}

	if not arg0_227 then
		return nil
	end

	local var1_227 = #arg0_227
	local var2_227 = 1

	while var2_227 <= var1_227 do
		local var3_227 = string.find(arg0_227, arg1_227, var2_227)

		if var3_227 == nil then
			table.insert(var0_227, string.sub(arg0_227, var2_227, var1_227))

			break
		end

		table.insert(var0_227, string.sub(arg0_227, var2_227, var3_227 - 1))

		if var3_227 == var1_227 then
			table.insert(var0_227, "")

			break
		end

		var2_227 = var3_227 + 1
	end

	return var0_227
end

function NumberToChinese(arg0_228, arg1_228)
	local var0_228 = ""
	local var1_228 = #arg0_228

	for iter0_228 = 1, var1_228 do
		local var2_228 = string.sub(arg0_228, iter0_228, iter0_228)

		if var2_228 ~= "0" or var2_228 == "0" and not arg1_228 then
			if arg1_228 then
				if var1_228 >= 2 then
					if iter0_228 == 1 then
						if var2_228 == "1" then
							var0_228 = i18n("number_" .. 10)
						else
							var0_228 = i18n("number_" .. var2_228) .. i18n("number_" .. 10)
						end
					else
						var0_228 = var0_228 .. i18n("number_" .. var2_228)
					end
				else
					var0_228 = var0_228 .. i18n("number_" .. var2_228)
				end
			else
				var0_228 = var0_228 .. i18n("number_" .. var2_228)
			end
		end
	end

	return var0_228
end

function getActivityTask(arg0_229, arg1_229)
	local var0_229 = getProxy(TaskProxy)
	local var1_229 = arg0_229:getConfig("config_data")
	local var2_229 = arg0_229:getNDay(arg0_229.data1)
	local var3_229
	local var4_229
	local var5_229

	for iter0_229 = math.max(arg0_229.data3, 1), math.min(var2_229, #var1_229) do
		local var6_229 = _.flatten({
			var1_229[iter0_229]
		})

		for iter1_229, iter2_229 in ipairs(var6_229) do
			local var7_229 = var0_229:getTaskById(iter2_229)

			if var7_229 then
				return var7_229.id, var7_229
			end

			if var4_229 then
				var5_229 = var0_229:getFinishTaskById(iter2_229)

				if var5_229 then
					var4_229 = var5_229
				elseif arg1_229 then
					return iter2_229
				else
					return var4_229.id, var4_229
				end
			else
				var4_229 = var0_229:getFinishTaskById(iter2_229)
				var5_229 = var5_229 or iter2_229
			end
		end
	end

	if var4_229 then
		return var4_229.id, var4_229
	else
		return var5_229
	end
end

function setImageFromImage(arg0_230, arg1_230, arg2_230)
	local var0_230 = GetComponent(arg0_230, "Image")

	var0_230.sprite = GetComponent(arg1_230, "Image").sprite

	if arg2_230 then
		var0_230:SetNativeSize()
	end
end

function skinTimeStamp(arg0_231)
	local var0_231, var1_231, var2_231, var3_231 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_231)

	if var0_231 >= 1 then
		return i18n("limit_skin_time_day", var0_231)
	elseif var0_231 <= 0 and var1_231 > 0 then
		return i18n("limit_skin_time_day_min", var1_231, var2_231)
	elseif var0_231 <= 0 and var1_231 <= 0 and (var2_231 > 0 or var3_231 > 0) then
		return i18n("limit_skin_time_min", math.max(var2_231, 1))
	elseif var0_231 <= 0 and var1_231 <= 0 and var2_231 <= 0 and var3_231 <= 0 then
		return i18n("limit_skin_time_overtime")
	end
end

function skinCommdityTimeStamp(arg0_232)
	local var0_232 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_232 = math.max(arg0_232 - var0_232, 0)
	local var2_232 = math.floor(var1_232 / 86400)

	if var2_232 > 0 then
		return i18n("time_remaining_tip") .. var2_232 .. i18n("word_date")
	else
		local var3_232 = math.floor(var1_232 / 3600)

		if var3_232 > 0 then
			return i18n("time_remaining_tip") .. var3_232 .. i18n("word_hour")
		else
			local var4_232 = math.floor(var1_232 / 60)

			if var4_232 > 0 then
				return i18n("time_remaining_tip") .. var4_232 .. i18n("word_minute")
			else
				return i18n("time_remaining_tip") .. var1_232 .. i18n("word_second")
			end
		end
	end
end

function InstagramTimeStamp(arg0_233)
	local var0_233 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_233
	local var1_233 = var0_233 / 86400

	if var1_233 > 1 then
		return i18n("ins_word_day", math.floor(var1_233))
	else
		local var2_233 = var0_233 / 3600

		if var2_233 > 1 then
			return i18n("ins_word_hour", math.floor(var2_233))
		else
			local var3_233 = var0_233 / 60

			if var3_233 > 1 then
				return i18n("ins_word_minu", math.floor(var3_233))
			else
				return i18n("ins_word_minu", 1)
			end
		end
	end
end

function InstagramReplyTimeStamp(arg0_234)
	local var0_234 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_234
	local var1_234 = var0_234 / 86400

	if var1_234 > 1 then
		return i18n1(math.floor(var1_234) .. "d")
	else
		local var2_234 = var0_234 / 3600

		if var2_234 > 1 then
			return i18n1(math.floor(var2_234) .. "h")
		else
			local var3_234 = var0_234 / 60

			if var3_234 > 1 then
				return i18n1(math.floor(var3_234) .. "min")
			else
				return i18n1("1min")
			end
		end
	end
end

function attireTimeStamp(arg0_235)
	local var0_235, var1_235, var2_235, var3_235 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_235)

	if var0_235 <= 0 and var1_235 <= 0 and var2_235 <= 0 and var3_235 <= 0 then
		return i18n("limit_skin_time_overtime")
	else
		return i18n("attire_time_stamp", var0_235, var1_235, var2_235)
	end
end

function checkExist(arg0_236, ...)
	local var0_236 = {
		...
	}

	for iter0_236, iter1_236 in ipairs(var0_236) do
		if arg0_236 == nil then
			break
		end

		assert(type(arg0_236) == "table", "type error : intermediate target should be table")
		assert(type(iter1_236) == "table", "type error : param should be table")

		if type(arg0_236[iter1_236[1]]) == "function" then
			arg0_236 = arg0_236[iter1_236[1]](arg0_236, unpack(iter1_236[2] or {}))
		else
			arg0_236 = arg0_236[iter1_236[1]]
		end
	end

	return arg0_236
end

function AcessWithinNull(arg0_237, arg1_237)
	if arg0_237 == nil then
		return
	end

	assert(type(arg0_237) == "table")

	return arg0_237[arg1_237]
end

function showRepairMsgbox()
	local var0_238 = {
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var1_238 = {
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var2_238 = {
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
			var2_238,
			var1_238,
			var0_238
		}
	})
end

function resourceVerify(arg0_242, arg1_242)
	if CSharpVersion > 35 then
		BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()

		return
	end

	local var0_242 = Application.persistentDataPath .. "/hashes.csv"
	local var1_242
	local var2_242 = PathMgr.ReadAllLines(var0_242)
	local var3_242 = {}

	if arg0_242 then
		setActive(arg0_242, true)
	else
		pg.UIMgr.GetInstance():LoadingOn()
	end

	local function var4_242()
		if arg0_242 then
			setActive(arg0_242, false)
		else
			pg.UIMgr.GetInstance():LoadingOff()
		end

		print(var1_242)

		if var1_242 then
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

	local var5_242 = var2_242.Length
	local var6_242

	local function var7_242(arg0_245)
		if arg0_245 < 0 then
			var4_242()

			return
		end

		if arg1_242 then
			setSlider(arg1_242, 0, var5_242, var5_242 - arg0_245)
		end

		local var0_245 = string.split(var2_242[arg0_245], ",")
		local var1_245 = var0_245[1]
		local var2_245 = var0_245[3]
		local var3_245 = PathMgr.getAssetBundle(var1_245)

		if PathMgr.FileExists(var3_245) then
			local var4_245 = PathMgr.ReadAllBytes(PathMgr.getAssetBundle(var1_245))

			if var2_245 == HashUtil.CalcMD5(var4_245) then
				onNextTick(function()
					var7_242(arg0_245 - 1)
				end)

				return
			end
		end

		var1_242 = var1_245

		var4_242()
	end

	var7_242(var5_242 - 1)
end

function splitByWordEN(arg0_247, arg1_247)
	local var0_247 = string.split(arg0_247, " ")
	local var1_247 = ""
	local var2_247 = ""
	local var3_247 = arg1_247:GetComponent(typeof(RectTransform))
	local var4_247 = arg1_247:GetComponent(typeof(Text))
	local var5_247 = var3_247.rect.width

	for iter0_247, iter1_247 in ipairs(var0_247) do
		local var6_247 = var2_247

		var2_247 = var2_247 == "" and iter1_247 or var2_247 .. " " .. iter1_247

		setText(arg1_247, var2_247)

		if var5_247 < var4_247.preferredWidth then
			var1_247 = var1_247 == "" and var6_247 or var1_247 .. "\n" .. var6_247
			var2_247 = iter1_247
		end

		if iter0_247 >= #var0_247 then
			var1_247 = var1_247 == "" and var2_247 or var1_247 .. "\n" .. var2_247
		end
	end

	return var1_247
end

function checkBirthFormat(arg0_248)
	if #arg0_248 ~= 8 then
		return false
	end

	local var0_248 = 0
	local var1_248 = #arg0_248

	while var0_248 < var1_248 do
		local var2_248 = string.byte(arg0_248, var0_248 + 1)

		if var2_248 < 48 or var2_248 > 57 then
			return false
		end

		var0_248 = var0_248 + 1
	end

	return true
end

function isHalfBodyLive2D(arg0_249)
	local var0_249 = {
		"biaoqiang",
		"z23",
		"lafei",
		"lingbo",
		"mingshi",
		"xuefeng"
	}

	return _.any(var0_249, function(arg0_250)
		return arg0_250 == arg0_249
	end)
end

function GetServerState(arg0_251)
	local var0_251 = -1
	local var1_251 = 0
	local var2_251 = 1
	local var3_251 = 2
	local var4_251 = NetConst.GetServerStateUrl()

	if PLATFORM_CODE == PLATFORM_CH then
		var4_251 = string.gsub(var4_251, "https", "http")
	end

	VersionMgr.Inst:WebRequest(var4_251, function(arg0_252, arg1_252)
		local var0_252 = true
		local var1_252 = false

		for iter0_252 in string.gmatch(arg1_252, "\"state\":%d") do
			if iter0_252 ~= "\"state\":1" then
				var0_252 = false
			end

			var1_252 = true
		end

		if not var1_252 then
			var0_252 = false
		end

		if arg0_251 ~= nil then
			arg0_251(var0_252 and var2_251 or var1_251)
		end
	end)
end

function setScrollText(arg0_253, arg1_253)
	GetOrAddComponent(arg0_253, "ScrollText"):SetText(arg1_253)
end

function changeToScrollText(arg0_254, arg1_254)
	local var0_254 = GetComponent(arg0_254, typeof(Text))

	assert(var0_254, "without component<Text>")

	local var1_254 = arg0_254:Find("subText")

	if not var1_254 then
		var1_254 = cloneTplTo(arg0_254, arg0_254, "subText")

		eachChild(arg0_254, function(arg0_255)
			setActive(arg0_255, arg0_255 == var1_254)
		end)

		arg0_254:GetComponent(typeof(Text)).enabled = false
	end

	setScrollText(var1_254, arg1_254)
end

local var18_0
local var19_0
local var20_0
local var21_0

local function var22_0(arg0_256, arg1_256, arg2_256)
	local var0_256 = arg0_256:Find("base")
	local var1_256, var2_256, var3_256 = Equipment.GetInfoTrans(arg1_256, arg2_256)

	if arg1_256.nextValue then
		local var4_256 = {
			name = arg1_256.name,
			type = arg1_256.type,
			value = arg1_256.nextValue
		}
		local var5_256, var6_256 = Equipment.GetInfoTrans(var4_256, arg2_256)

		var2_256 = var2_256 .. setColorStr("   >   " .. var6_256, COLOR_GREEN)
	end

	setText(var0_256:Find("name"), var1_256)

	if var3_256 then
		local var7_256 = "<color=#afff72>(+" .. ys.Battle.BattleConst.UltimateBonus.AuxBoostValue * 100 .. "%)</color>"

		setText(var0_256:Find("value"), var2_256 .. var7_256)
	else
		setText(var0_256:Find("value"), var2_256)
	end

	setActive(var0_256:Find("value/up"), arg1_256.compare and arg1_256.compare > 0)
	setActive(var0_256:Find("value/down"), arg1_256.compare and arg1_256.compare < 0)
	triggerToggle(var0_256, arg1_256.lock_open)

	if not arg1_256.lock_open and arg1_256.sub and #arg1_256.sub > 0 then
		GetComponent(var0_256, typeof(Toggle)).enabled = true
	else
		setActive(var0_256:Find("name/close"), false)
		setActive(var0_256:Find("name/open"), false)

		GetComponent(var0_256, typeof(Toggle)).enabled = false
	end
end

local function var23_0(arg0_257, arg1_257, arg2_257, arg3_257)
	var22_0(arg0_257, arg2_257, arg3_257)

	if not arg2_257.sub or #arg2_257.sub == 0 then
		return
	end

	var20_0(arg0_257:Find("subs"), arg1_257, arg2_257.sub, arg3_257)
end

function var20_0(arg0_258, arg1_258, arg2_258, arg3_258)
	removeAllChildren(arg0_258)
	var21_0(arg0_258, arg1_258, arg2_258, arg3_258)
end

function var21_0(arg0_259, arg1_259, arg2_259, arg3_259)
	for iter0_259, iter1_259 in ipairs(arg2_259) do
		local var0_259 = cloneTplTo(arg1_259, arg0_259)

		var23_0(var0_259, arg1_259, iter1_259, arg3_259)
	end
end

function updateEquipInfo(arg0_260, arg1_260, arg2_260, arg3_260)
	local var0_260 = arg0_260:Find("attr_tpl")

	var20_0(arg0_260:Find("attrs"), var0_260, arg1_260.attrs, arg3_260)
	setActive(arg0_260:Find("skill"), arg2_260)

	if arg2_260 then
		var23_0(arg0_260:Find("skill/attr"), var0_260, {
			name = i18n("skill"),
			value = setColorStr(arg2_260.name, "#FFDE00FF")
		}, arg3_260)
		setText(arg0_260:Find("skill/value/Text"), getSkillDescGet(arg2_260.id))
	end

	setActive(arg0_260:Find("weapon"), #arg1_260.weapon.sub > 0)

	if #arg1_260.weapon.sub > 0 then
		var20_0(arg0_260:Find("weapon"), var0_260, {
			arg1_260.weapon
		}, arg3_260)
	end

	setActive(arg0_260:Find("equip_info"), #arg1_260.equipInfo.sub > 0)

	if #arg1_260.equipInfo.sub > 0 then
		var20_0(arg0_260:Find("equip_info"), var0_260, {
			arg1_260.equipInfo
		}, arg3_260)
	end

	var23_0(arg0_260:Find("part/attr"), var0_260, {
		name = i18n("equip_info_23")
	}, arg3_260)

	local var1_260 = arg0_260:Find("part/value")
	local var2_260 = var1_260:Find("label")
	local var3_260 = {}
	local var4_260 = {}

	if #arg1_260.part[1] == 0 and #arg1_260.part[2] == 0 then
		setmetatable(var3_260, {
			__index = function(arg0_261, arg1_261)
				return true
			end
		})
		setmetatable(var4_260, {
			__index = function(arg0_262, arg1_262)
				return true
			end
		})
	else
		for iter0_260, iter1_260 in ipairs(arg1_260.part[1]) do
			var3_260[iter1_260] = true
		end

		for iter2_260, iter3_260 in ipairs(arg1_260.part[2]) do
			var4_260[iter3_260] = true
		end
	end

	local var5_260 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var3_260, var4_260)

	UIItemList.StaticAlign(var1_260, var2_260, #var5_260, function(arg0_263, arg1_263, arg2_263)
		arg1_263 = arg1_263 + 1

		if arg0_263 == UIItemList.EventUpdate then
			local var0_263 = var5_260[arg1_263]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0_263), arg2_263)
			setActive(arg2_263:Find("main"), var3_260[var0_263] and not var4_260[var0_263])
			setActive(arg2_263:Find("sub"), var4_260[var0_263] and not var3_260[var0_263])
			setImageAlpha(arg2_263, not var3_260[var0_263] and not var4_260[var0_263] and 0.3 or 1)
		end
	end)
end

function updateEquipUpgradeInfo(arg0_264, arg1_264, arg2_264)
	local var0_264 = arg0_264:Find("attr_tpl")

	var20_0(arg0_264:Find("attrs"), var0_264, arg1_264.attrs, arg2_264)
	setActive(arg0_264:Find("weapon"), #arg1_264.weapon.sub > 0)

	if #arg1_264.weapon.sub > 0 then
		var20_0(arg0_264:Find("weapon"), var0_264, {
			arg1_264.weapon
		}, arg2_264)
	end

	setActive(arg0_264:Find("equip_info"), #arg1_264.equipInfo.sub > 0)

	if #arg1_264.equipInfo.sub > 0 then
		var20_0(arg0_264:Find("equip_info"), var0_264, {
			arg1_264.equipInfo
		}, arg2_264)
	end
end

function setCanvasOverrideSorting(arg0_265, arg1_265)
	local var0_265 = arg0_265.parent

	arg0_265:SetParent(pg.LayerWeightMgr.GetInstance().uiOrigin, false)

	if isActive(arg0_265) then
		GetOrAddComponent(arg0_265, typeof(Canvas)).overrideSorting = arg1_265
	else
		setActive(arg0_265, true)

		GetOrAddComponent(arg0_265, typeof(Canvas)).overrideSorting = arg1_265

		setActive(arg0_265, false)
	end

	arg0_265:SetParent(var0_265, false)
end

function createNewGameObject(arg0_266, arg1_266)
	local var0_266 = GameObject.New()

	if arg0_266 then
		var0_266.name = "model"
	end

	var0_266.layer = arg1_266 or Layer.UI

	return GetOrAddComponent(var0_266, "RectTransform")
end

function CreateShell(arg0_267)
	if type(arg0_267) ~= "table" and type(arg0_267) ~= "userdata" then
		return arg0_267
	end

	local var0_267 = setmetatable({
		__index = arg0_267
	}, arg0_267)

	return setmetatable({}, var0_267)
end

function CameraFittingSettin(arg0_268)
	local var0_268 = GetComponent(arg0_268, typeof(Camera))
	local var1_268 = 1.77777777777778
	local var2_268 = Screen.width / Screen.height

	if var2_268 < var1_268 then
		local var3_268 = var2_268 / var1_268

		var0_268.rect = var0_0.Rect.New(0, (1 - var3_268) / 2, 1, var3_268)
	end
end

function SwitchSpecialChar(arg0_269, arg1_269)
	if PLATFORM_CODE ~= PLATFORM_US then
		arg0_269 = arg0_269:gsub(" ", " ")
		arg0_269 = arg0_269:gsub("\t", "    ")
	end

	if not arg1_269 then
		arg0_269 = arg0_269:gsub("\n", " ")
	end

	return arg0_269
end

function AfterCheck(arg0_270, arg1_270)
	local var0_270 = {}

	for iter0_270, iter1_270 in ipairs(arg0_270) do
		var0_270[iter0_270] = iter1_270[1]()
	end

	arg1_270()

	for iter2_270, iter3_270 in ipairs(arg0_270) do
		if var0_270[iter2_270] ~= iter3_270[1]() then
			iter3_270[2]()
		end

		var0_270[iter2_270] = iter3_270[1]()
	end
end

function CompareFuncs(arg0_271, arg1_271)
	local var0_271 = {}

	local function var1_271(arg0_272, arg1_272)
		var0_271[arg0_272] = var0_271[arg0_272] or {}
		var0_271[arg0_272][arg1_272] = var0_271[arg0_272][arg1_272] or arg0_271[arg0_272](arg1_272)

		return var0_271[arg0_272][arg1_272]
	end

	return function(arg0_273, arg1_273)
		local var0_273 = 1

		while var0_273 <= #arg0_271 do
			local var1_273 = var1_271(var0_273, arg0_273)
			local var2_273 = var1_271(var0_273, arg1_273)

			if var1_273 == var2_273 then
				var0_273 = var0_273 + 1
			else
				return var1_273 < var2_273
			end
		end

		return tobool(arg1_271)
	end
end

function DropResultIntegration(arg0_274)
	local var0_274 = {}
	local var1_274 = 1

	while var1_274 <= #arg0_274 do
		local var2_274 = arg0_274[var1_274].type
		local var3_274 = arg0_274[var1_274].id

		var0_274[var2_274] = var0_274[var2_274] or {}

		if var0_274[var2_274][var3_274] then
			local var4_274 = arg0_274[var0_274[var2_274][var3_274]]
			local var5_274 = table.remove(arg0_274, var1_274)

			var4_274.count = var4_274.count + var5_274.count
		else
			var0_274[var2_274][var3_274] = var1_274
			var1_274 = var1_274 + 1
		end
	end

	local var6_274 = {
		function(arg0_275)
			local var0_275 = arg0_275.type
			local var1_275 = arg0_275.id

			if var0_275 == DROP_TYPE_SHIP then
				return 1
			elseif var0_275 == DROP_TYPE_RESOURCE then
				if var1_275 == 1 then
					return 2
				else
					return 3
				end
			elseif var0_275 == DROP_TYPE_ITEM then
				if var1_275 == 59010 then
					return 4
				elseif var1_275 == 59900 then
					return 5
				else
					local var2_275 = Item.getConfigData(var1_275)
					local var3_275 = var2_275 and var2_275.type or 0

					if var3_275 == 9 then
						return 6
					elseif var3_275 == 5 then
						return 7
					elseif var3_275 == 4 then
						return 8
					elseif var3_275 == 7 then
						return 9
					end
				end
			elseif var0_275 == DROP_TYPE_VITEM and var1_275 == 59011 then
				return 4
			end

			return 100
		end,
		function(arg0_276)
			local var0_276

			if arg0_276.type == DROP_TYPE_SHIP then
				var0_276 = pg.ship_data_statistics[arg0_276.id]
			elseif arg0_276.type == DROP_TYPE_ITEM then
				var0_276 = Item.getConfigData(arg0_276.id)
			end

			return (var0_276 and var0_276.rarity or 0) * -1
		end,
		function(arg0_277)
			return arg0_277.id
		end
	}

	table.sort(arg0_274, CompareFuncs(var6_274))
end

function getLoginConfig()
	if LOGIN_HX and PlayerProxy.GetDeviceMaxPlayerLevel() <= pg.gameset.LOGIN_HX_LV.key_value then
		return false, "login", "", false, ""
	end

	local var0_278 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_278 = 1

	for iter0_278, iter1_278 in ipairs(pg.login.all) do
		if pg.login[iter1_278].date ~= "stop" then
			local var2_278, var3_278 = parseTimeConfig(pg.login[iter1_278].date)

			assert(not var3_278)

			if pg.TimeMgr.GetInstance():inTime(var2_278, var0_278) then
				var1_278 = iter1_278

				break
			end
		end
	end

	local var4_278 = pg.login[var1_278].login_static

	var4_278 = var4_278 ~= "" and var4_278 or "login"

	local var5_278 = pg.login[var1_278].login_cri
	local var6_278 = var5_278 ~= "" and true or false
	local var7_278 = pg.login[var1_278].op_play == 1 and true or false
	local var8_278 = pg.login[var1_278].op_time

	if var8_278 == "" or not pg.TimeMgr.GetInstance():inTime(var8_278, var0_278) then
		var7_278 = false
	end

	local var9_278 = var8_278 == "" and var8_278 or table.concat(var8_278[1][1])

	return var6_278, var6_278 and var5_278 or var4_278, pg.login[var1_278].bgm, var7_278, var9_278
end

function setIntimacyIcon(arg0_279, arg1_279, arg2_279)
	local var0_279 = {}
	local var1_279

	seriesAsync({
		function(arg0_280)
			if arg0_279.childCount > 0 then
				var1_279 = arg0_279:GetChild(0)

				arg0_280()
			else
				LoadAndInstantiateAsync("template", "intimacytpl", function(arg0_281)
					var1_279 = tf(arg0_281)

					setParent(var1_279, arg0_279)
					arg0_280()
				end)
			end
		end,
		function(arg0_282)
			setImageAlpha(var1_279, arg2_279 and 0 or 1)
			eachChild(var1_279, function(arg0_283)
				setActive(arg0_283, false)
			end)

			if arg2_279 then
				local var0_282 = var1_279:Find(arg2_279 .. "(Clone)")

				if not var0_282 then
					LoadAndInstantiateAsync("ui", arg2_279, function(arg0_284)
						setParent(arg0_284, var1_279)
						setActive(arg0_284, true)
					end)
				else
					setActive(var0_282, true)
				end
			elseif arg1_279 then
				setImageSprite(var1_279, GetSpriteFromAtlas("energy", arg1_279), true)
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

function switch(arg0_287, arg1_287, arg2_287, ...)
	if arg1_287[arg0_287] then
		return arg1_287[arg0_287](...)
	elseif arg2_287 then
		return arg2_287(...)
	end
end

function parseTimeConfig(arg0_288)
	if type(arg0_288[1]) == "table" then
		return arg0_288[2], arg0_288[1]
	else
		return arg0_288
	end
end

local var25_0 = {
	__add = function(arg0_289, arg1_289)
		return NewPos(arg0_289.x + arg1_289.x, arg0_289.y + arg1_289.y)
	end,
	__sub = function(arg0_290, arg1_290)
		return NewPos(arg0_290.x - arg1_290.x, arg0_290.y - arg1_290.y)
	end,
	__mul = function(arg0_291, arg1_291)
		if type(arg1_291) == "number" then
			return NewPos(arg0_291.x * arg1_291, arg0_291.y * arg1_291)
		else
			return NewPos(arg0_291.x * arg1_291.x, arg0_291.y * arg1_291.y)
		end
	end,
	__eq = function(arg0_292, arg1_292)
		return arg0_292.x == arg1_292.x and arg0_292.y == arg1_292.y
	end,
	__tostring = function(arg0_293)
		return arg0_293.x .. "_" .. arg0_293.y
	end
}

function NewPos(arg0_294, arg1_294)
	assert(arg0_294 and arg1_294)

	local var0_294 = setmetatable({
		x = arg0_294,
		y = arg1_294
	}, var25_0)

	function var0_294.SqrMagnitude(arg0_295)
		return arg0_295.x * arg0_295.x + arg0_295.y * arg0_295.y
	end

	function var0_294.Normalize(arg0_296)
		local var0_296 = arg0_296:SqrMagnitude()

		if var0_296 > 1e-05 then
			return arg0_296 * (1 / math.sqrt(var0_296))
		else
			return NewPos(0, 0)
		end
	end

	return var0_294
end

local var26_0

function Timekeeping()
	warning(Time.realtimeSinceStartup - (var26_0 or Time.realtimeSinceStartup), Time.realtimeSinceStartup)

	var26_0 = Time.realtimeSinceStartup
end

function GetRomanDigit(arg0_298)
	return (string.char(226, 133, 160 + (arg0_298 - 1)))
end

function quickPlayAnimator(arg0_299, arg1_299)
	arg0_299:GetComponent(typeof(Animator)):Play(arg1_299, -1, 0)
end

function quickCheckAndPlayAnimator(arg0_300, arg1_300)
	local var0_300 = arg0_300:GetComponent(typeof(Animator))

	var0_300.enabled = true

	local var1_300 = Animator.StringToHash(arg1_300)

	if var0_300:HasState(0, var1_300) then
		var0_300:Play(arg1_300, -1, 0)
	end
end

function quickPlayAnimation(arg0_301, arg1_301)
	local var0_301 = arg0_301:GetComponent(typeof(Animation))

	var0_301:Stop()
	var0_301:Play(arg1_301)
end

function getSurveyUrl(arg0_302)
	local var0_302 = pg.survey_data_template[arg0_302]
	local var1_302

	if not IsUnityEditor then
		if PLATFORM_CODE == PLATFORM_CH then
			local var2_302 = getProxy(UserProxy):GetCacheGatewayInServerLogined()

			if var2_302 == PLATFORM_ANDROID then
				if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_BILI then
					var1_302 = var0_302.main_url
				else
					var1_302 = var0_302.uo_url
				end
			elseif var2_302 == PLATFORM_IPHONEPLAYER then
				var1_302 = var0_302.ios_url
			end
		elseif PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_KR then
			var1_302 = var0_302.main_url
		end
	else
		var1_302 = var0_302.main_url
	end

	local var3_302 = getProxy(PlayerProxy):getRawData().id
	local var4_302 = getProxy(UserProxy):getRawData().arg2 or ""
	local var5_302
	local var6_302 = PLATFORM == PLATFORM_ANDROID and 1 or PLATFORM == PLATFORM_IPHONEPLAYER and 2 or 3
	local var7_302 = getProxy(UserProxy):getRawData()
	local var8_302 = getProxy(ServerProxy):getRawData()[var7_302 and var7_302.server or 0]
	local var9_302 = var8_302 and var8_302.id or ""
	local var10_302 = getProxy(PlayerProxy):getRawData().level
	local var11_302 = var3_302 .. "_" .. arg0_302
	local var12_302 = var1_302
	local var13_302 = {
		var3_302,
		var4_302,
		var6_302,
		var9_302,
		var10_302,
		var11_302
	}

	if var12_302 then
		for iter0_302, iter1_302 in ipairs(var13_302) do
			var12_302 = string.gsub(var12_302, "$" .. iter0_302, tostring(iter1_302))
		end
	end

	originalPrint("survey url", tostring(var12_302))

	return var12_302
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

function FilterVarchar(arg0_304)
	assert(type(arg0_304) == "string" or type(arg0_304) == "table")

	if arg0_304 == "" then
		return nil
	end

	return arg0_304
end

function getGameset(arg0_305)
	local var0_305 = pg.gameset[arg0_305]

	assert(var0_305)

	return {
		var0_305.key_value,
		var0_305.description
	}
end

function getDorm3dGameset(arg0_306)
	local var0_306 = pg.dorm3d_set[arg0_306]

	assert(var0_306)

	return {
		var0_306.key_value_int,
		var0_306.key_value_varchar
	}
end

function GetItemsOverflowDic(arg0_307)
	arg0_307 = arg0_307 or {}

	local var0_307 = {
		[DROP_TYPE_ITEM] = {},
		[DROP_TYPE_RESOURCE] = {},
		[DROP_TYPE_EQUIP] = 0,
		[DROP_TYPE_SHIP] = 0,
		[DROP_TYPE_WORLD_ITEM] = 0
	}

	while #arg0_307 > 0 do
		local var1_307 = table.remove(arg0_307)

		switch(var1_307.type, {
			[DROP_TYPE_ITEM] = function()
				if var1_307:getConfig("open_directly") == 1 then
					for iter0_308, iter1_308 in ipairs(var1_307:getConfig("display_icon")) do
						local var0_308 = Drop.Create(iter1_308)

						var0_308.count = var0_308.count * var1_307.count

						table.insert(arg0_307, var0_308)
					end
				elseif var1_307:getSubClass():IsShipExpType() then
					var0_307[var1_307.type][var1_307.id] = defaultValue(var0_307[var1_307.type][var1_307.id], 0) + var1_307.count
				end
			end,
			[DROP_TYPE_RESOURCE] = function()
				var0_307[var1_307.type][var1_307.id] = defaultValue(var0_307[var1_307.type][var1_307.id], 0) + var1_307.count
			end,
			[DROP_TYPE_EQUIP] = function()
				var0_307[var1_307.type] = var0_307[var1_307.type] + var1_307.count
			end,
			[DROP_TYPE_SHIP] = function()
				var0_307[var1_307.type] = var0_307[var1_307.type] + var1_307.count
			end,
			[DROP_TYPE_WORLD_ITEM] = function()
				var0_307[var1_307.type] = var0_307[var1_307.type] + var1_307.count
			end
		})
	end

	return var0_307
end

function CheckOverflow(arg0_313, arg1_313)
	local var0_313 = {}
	local var1_313 = arg0_313[DROP_TYPE_RESOURCE][PlayerConst.ResGold] or 0
	local var2_313 = arg0_313[DROP_TYPE_RESOURCE][PlayerConst.ResOil] or 0
	local var3_313 = arg0_313[DROP_TYPE_EQUIP]
	local var4_313 = arg0_313[DROP_TYPE_SHIP]
	local var5_313 = getProxy(PlayerProxy):getRawData()
	local var6_313 = false

	if arg1_313 then
		local var7_313 = var5_313:OverStore(PlayerConst.ResStoreGold, var1_313)
		local var8_313 = var5_313:OverStore(PlayerConst.ResStoreOil, var2_313)

		if var7_313 > 0 or var8_313 > 0 then
			var0_313.isStoreOverflow = {
				var7_313,
				var8_313
			}
		end
	else
		if var1_313 > 0 and var5_313:GoldMax(var1_313) then
			return false, "gold"
		end

		if var2_313 > 0 and var5_313:OilMax(var2_313) then
			return false, "oil"
		end
	end

	var0_313.isExpBookOverflow = {}

	for iter0_313, iter1_313 in pairs(arg0_313[DROP_TYPE_ITEM]) do
		local var9_313 = Item.getConfigData(iter0_313)

		if getProxy(BagProxy):getItemCountById(iter0_313) + iter1_313 > var9_313.max_num then
			table.insert(var0_313.isExpBookOverflow, iter0_313)
		end
	end

	local var10_313 = getProxy(EquipmentProxy):getCapacity()

	if var3_313 > 0 and var10_313 >= var5_313:getMaxEquipmentBag() then
		return false, "equip"
	end

	local var11_313 = getProxy(BayProxy):getShipCount()

	if var4_313 > 0 and var4_313 + var11_313 > var5_313:getMaxShipBag() then
		return false, "ship"
	end

	return true, var0_313
end

function CheckShipExpOverflow(arg0_314)
	local var0_314 = getProxy(BagProxy)

	for iter0_314, iter1_314 in pairs(arg0_314[DROP_TYPE_ITEM]) do
		if var0_314:getItemCountById(iter0_314) + iter1_314 > Item.getConfigData(iter0_314).max_num then
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

function RegisterDetailButton(arg0_315, arg1_315, arg2_315)
	Drop.Change(arg2_315)
	switch(arg2_315.type, {
		[DROP_TYPE_ITEM] = function()
			if arg2_315:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
				local var0_316 = Item.getConfigData(arg2_315.id).usage_arg
				local var1_316 = var0_316[3]

				if Item.InTimeLimitSkinAssigned(arg2_315.id) then
					var1_316 = table.mergeArray(var0_316[2], var1_316, true)
				end

				local var2_316 = {}

				for iter0_316, iter1_316 in ipairs(var0_316[2]) do
					var2_316[iter1_316] = true
				end

				onButton(arg0_315, arg1_315, function()
					arg0_315:closeView()
					pg.m02:sendNotification(GAME.LOAD_LAYERS, {
						parentContext = getProxy(ContextProxy):getCurrentContext(),
						context = Context.New({
							viewComponent = NewSelectSkinLayer,
							mediator = NewSkinAtlasMediator,
							data = {
								mode = SelectSkinLayer.MODE_VIEW,
								itemId = arg2_315.id,
								selectableSkinList = underscore.map(var1_316, function(arg0_318)
									return SelectableSkin.New({
										id = arg0_318,
										isTimeLimit = var2_316[arg0_318] or false
									})
								end)
							}
						})
					})
				end, SFX_PANEL)
				setActive(arg1_315, true)
			else
				local var3_316 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_315.id) and "tech" or arg2_315:getConfig("type")

				if var27_0[var3_316] then
					local var4_316 = {
						item2Row = true,
						content = i18n(var27_0[var3_316]),
						itemList = underscore.map(arg2_315:getConfig("display_icon"), function(arg0_319)
							return Drop.Create(arg0_319)
						end)
					}

					if var3_316 == 11 then
						onButton(arg0_315, arg1_315, function()
							arg0_315:emit(BaseUI.ON_DROP_LIST_OWN, var4_316)
						end, SFX_PANEL)
					else
						onButton(arg0_315, arg1_315, function()
							arg0_315:emit(BaseUI.ON_DROP_LIST, var4_316)
						end, SFX_PANEL)
					end
				end

				setActive(arg1_315, tobool(var27_0[var3_316]))
			end
		end,
		[DROP_TYPE_EQUIP] = function()
			onButton(arg0_315, arg1_315, function()
				arg0_315:emit(BaseUI.ON_DROP, arg2_315)
			end, SFX_PANEL)
			setActive(arg1_315, true)
		end,
		[DROP_TYPE_SPWEAPON] = function()
			onButton(arg0_315, arg1_315, function()
				arg0_315:emit(BaseUI.ON_DROP, arg2_315)
			end, SFX_PANEL)
			setActive(arg1_315, true)
		end
	}, function()
		setActive(arg1_315, false)
	end)
end

function RegisterNewStyleDetailButton(arg0_327, arg1_327, arg2_327)
	Drop.Change(arg2_327)
	switch(arg2_327.type, {
		[DROP_TYPE_ITEM] = function()
			local var0_328 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_327.id) and "tech" or arg2_327:getConfig("type")

			if var27_0[var0_328] then
				local var1_328 = {
					useDeepShow = true,
					showOwn = var0_328 == 11,
					content = i18n(var27_0[var0_328]),
					itemList = underscore.map(arg2_327:getConfig("display_icon"), function(arg0_329)
						return Drop.Create(arg0_329)
					end)
				}

				onButton(arg0_327, arg1_327, function()
					arg0_327:emit(BaseUI.ON_NEW_STYLE_ITEMS, var1_328)
				end, SFX_PANEL)
			end

			setActive(arg1_327, tobool(var27_0[var0_328]))
		end
	}, function()
		setActive(arg1_327, false)
	end)
end

function UpdateOwnDisplay(arg0_332, arg1_332)
	local var0_332, var1_332 = arg1_332:getOwnedCount()

	setActive(arg0_332, var1_332 and var0_332 > 0)

	if var1_332 and var0_332 > 0 then
		setText(arg0_332:Find("label"), i18n("word_own1"))
		setText(arg0_332:Find("Text"), var0_332)
	end
end

function Damp(arg0_333, arg1_333, arg2_333)
	arg1_333 = Mathf.Max(1, arg1_333)

	local var0_333 = Mathf.Epsilon

	if arg1_333 < var0_333 or var0_333 > Mathf.Abs(arg0_333) then
		return arg0_333
	end

	if arg2_333 < var0_333 then
		return 0
	end

	local var1_333 = -4.605170186

	return arg0_333 * (1 - Mathf.Exp(var1_333 * arg2_333 / arg1_333))
end

function checkCullResume(arg0_334, arg1_334)
	if arg1_334 or not ReflectionHelp.RefCallMethodEx(typeof("UnityEngine.CanvasRenderer"), "GetMaterial", GetComponent(arg0_334, "CanvasRenderer"), {
		typeof("System.Int32")
	}, {
		0
	}) then
		local var0_334 = arg0_334:GetComponentsInChildren(typeof(var0_0.UI.Graphic)):ToTable()

		for iter0_334, iter1_334 in ipairs(var0_334) do
			iter1_334:SetVerticesDirty()
		end

		return false
	end

	return true
end

function parseEquipCode(arg0_335)
	local var0_335 = {}

	if arg0_335 and arg0_335 ~= "" then
		local var1_335 = base64.dec(arg0_335)

		var0_335 = string.split(var1_335, "/")
		var0_335[5], var0_335[6] = unpack(string.split(var0_335[5], "\\"))

		if #var0_335 < 6 or arg0_335 ~= base64.enc(table.concat({
			table.concat(underscore.first(var0_335, 5), "/"),
			var0_335[6]
		}, "\\")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_illegal"))

			var0_335 = {}
		end
	end

	for iter0_335 = 1, 6 do
		var0_335[iter0_335] = var0_335[iter0_335] and tonumber(var0_335[iter0_335], 32) or 0
	end

	return var0_335
end

function buildEquipCode(arg0_336)
	local var0_336 = underscore.map(arg0_336:getAllEquipments(), function(arg0_337)
		return ConversionBase(32, arg0_337 and arg0_337.id or 0)
	end)
	local var1_336 = {
		table.concat(var0_336, "/"),
		ConversionBase(32, checkExist(arg0_336:GetSpWeapon(), {
			"id"
		}) or 0)
	}

	return base64.enc(table.concat(var1_336, "\\"))
end

function setDirectorSpeed(arg0_338, arg1_338)
	GetComponent(arg0_338, typeof(TimelineSpeed)):SetTimelineSpeed(arg1_338)
end

function setDefaultZeroMetatable(arg0_339)
	return setmetatable(arg0_339, {
		__index = function(arg0_340, arg1_340)
			if rawget(arg0_340, arg1_340) == nil then
				arg0_340[arg1_340] = 0
			end

			return arg0_340[arg1_340]
		end
	})
end

function checkABExist(arg0_341)
	if EDITOR_TOOL then
		return ResourceMgr.Inst:AssetExist(arg0_341)
	else
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_341))
	end
end

function compareNumber(arg0_342, arg1_342, arg2_342)
	return switch(arg1_342, {
		[">"] = function()
			return arg0_342 > arg2_342
		end,
		[">="] = function()
			return arg0_342 >= arg2_342
		end,
		["="] = function()
			return arg0_342 == arg2_342
		end,
		["<"] = function()
			return arg0_342 < arg2_342
		end,
		["<="] = function()
			return arg0_342 <= arg2_342
		end
	})
end

function ArabicToRoman(arg0_348)
	local var0_348 = {
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

	local function var1_348(arg0_349, arg1_349)
		return select(2, arg0_349:gsub(arg1_349, ""))
	end

	local var2_348 = ""

	while arg0_348 > 0 do
		for iter0_348, iter1_348 in pairs(var0_348) do
			local var3_348 = iter1_348[2]
			local var4_348 = iter1_348[1]

			while var4_348 <= arg0_348 do
				var2_348 = var2_348 .. var3_348
				arg0_348 = arg0_348 - var4_348
			end
		end
	end

	if arg0_348 > 10000 then
		local var5_348 = var1_348(var2_348, "M")

		var2_348 = "M*" .. var5_348 .. " " .. var2_348
	end

	return var2_348
end

function stringInset(arg0_350, ...)
	for iter0_350, iter1_350 in ipairs({
		...
	}) do
		arg0_350 = string.gsub(arg0_350, "$" .. iter0_350, iter1_350)
	end

	return arg0_350
end

function addSubLayer(arg0_351, arg1_351, arg2_351, arg3_351, arg4_351)
	if arg2_351 then
		while arg1_351.parent do
			arg1_351 = arg1_351.parent
		end
	end

	local var0_351 = {
		parentContext = arg1_351,
		context = arg0_351,
		callback = arg3_351
	}

	var0_351 = arg4_351 and table.merge(var0_351, arg4_351) or var0_351

	pg.m02:sendNotification(GAME.LOAD_LAYERS, var0_351)
end
