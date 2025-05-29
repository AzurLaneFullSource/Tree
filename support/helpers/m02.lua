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

function setPaintingPrefab(arg0_34, arg1_34, arg2_34, arg3_34)
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
end

local var2_0 = {}

function setPaintingPrefabAsync(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36)
	local var0_36 = arg1_36

	if checkABExist("painting/" .. arg1_36 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg1_36, 0) ~= 0 then
		arg1_36 = arg1_36 .. "_n"
	end

	LoadPaintingPrefabAsync(arg0_36, var0_36, arg1_36, arg2_36, arg3_36)
end

function LoadPaintingPrefabAsync(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37)
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
			arg4_37()
		end
	end)
end

function retPaintingPrefab(arg0_39, arg1_39, arg2_39)
	if arg0_39 and arg1_39 then
		local var0_39 = findTF(arg0_39, "fitter")

		if var0_39 and var0_39.childCount > 0 then
			local var1_39 = var0_39:GetChild(0)

			if not IsNil(var1_39) then
				local var2_39 = findTF(var1_39, "Touch")

				if not IsNil(var2_39) then
					eachChild(var2_39, function(arg0_40)
						local var0_40 = arg0_40:GetComponent(typeof(Button))

						if not IsNil(var0_40) then
							removeOnButton(arg0_40)
						end
					end)
				end

				if not arg2_39 then
					PoolMgr.GetInstance():ReturnPainting(string.gsub(var1_39.name, "%(Clone%)", ""), var1_39.gameObject)
				else
					PoolMgr.GetInstance():ReturnPaintingWithPrefix(string.gsub(var1_39.name, "%(Clone%)", ""), var1_39.gameObject, arg2_39)
				end
			end
		end

		var2_0[arg0_39] = nil
	end
end

function checkPaintingPrefab(arg0_41, arg1_41, arg2_41, arg3_41, arg4_41)
	local var0_41 = findTF(arg0_41, "fitter")

	assert(var0_41, "请添加子物体fitter")
	removeAllChildren(var0_41)

	local var1_41 = GetOrAddComponent(var0_41, "PaintingScaler")

	var1_41.FrameName = arg2_41 or ""
	var1_41.Tween = 1

	local var2_41 = arg4_41 or "painting/"
	local var3_41 = arg1_41

	if not arg3_41 and checkABExist(var2_41 .. arg1_41 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg1_41, 0) ~= 0 then
		arg1_41 = arg1_41 .. "_n"
	end

	return var0_41, arg1_41, var3_41
end

function onLoadedPaintingPrefab(arg0_42)
	local var0_42 = arg0_42.paintingTF
	local var1_42 = arg0_42.fitterTF
	local var2_42 = arg0_42.defaultPaintingName

	setParent(var0_42, var1_42, false)

	local var3_42 = findTF(var0_42, "Touch")

	if not IsNil(var3_42) then
		setActive(var3_42, false)
	end

	local var4_42 = findTF(var0_42, "hx")

	if not IsNil(var4_42) then
		setActive(var4_42, HXSet.isHx())
	end

	ShipExpressionHelper.SetExpression(var1_42:GetChild(0), var2_42)
end

function onLoadedPaintingPrefabAsync(arg0_43)
	local var0_43 = arg0_43.paintingTF
	local var1_43 = arg0_43.fitterTF
	local var2_43 = arg0_43.objectOrTransform
	local var3_43 = arg0_43.paintingName
	local var4_43 = arg0_43.defaultPaintingName
	local var5_43 = arg0_43.callback

	if IsNil(var2_43) or var2_0[var2_43] ~= var3_43 then
		PoolMgr.GetInstance():ReturnPainting(var3_43, var0_43)

		return
	else
		setParent(var0_43, var1_43, false)

		var2_0[var2_43] = nil

		ShipExpressionHelper.SetExpression(var0_43, var4_43)
	end

	local var6_43 = findTF(var0_43, "Touch")

	if not IsNil(var6_43) then
		setActive(var6_43, false)
	end

	local var7_43 = findTF(var0_43, "hx")

	if not IsNil(var7_43) then
		setActive(var7_43, HXSet.isHx())
	end

	if var5_43 then
		var5_43()
	end
end

function setCommanderPaintingPrefab(arg0_44, arg1_44, arg2_44, arg3_44)
	local var0_44, var1_44, var2_44 = checkPaintingPrefab(arg0_44, arg1_44, arg2_44, arg3_44)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_44, false, function(arg0_45)
		local var0_45 = {
			paintingTF = arg0_45,
			fitterTF = var0_44,
			defaultPaintingName = var2_44
		}

		onLoadedPaintingPrefab(var0_45)
	end, "commanderpainting/")
end

function setCommanderPaintingPrefabAsync(arg0_46, arg1_46, arg2_46, arg3_46, arg4_46)
	local var0_46, var1_46, var2_46 = checkPaintingPrefab(arg0_46, arg1_46, arg2_46, arg4_46)

	var2_0[arg0_46] = var1_46

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_46, true, function(arg0_47)
		local var0_47 = {
			paintingTF = arg0_47,
			fitterTF = var0_46,
			objectOrTransform = arg0_46,
			paintingName = var1_46,
			defaultPaintingName = var2_46,
			callback = arg3_46
		}

		onLoadedPaintingPrefabAsync(var0_47)
	end, "commanderpainting/")
end

function retCommanderPaintingPrefab(arg0_48, arg1_48)
	retPaintingPrefab(arg0_48, arg1_48, "commanderpainting/")
end

function setMetaPaintingPrefab(arg0_49, arg1_49, arg2_49, arg3_49)
	local var0_49, var1_49, var2_49 = checkPaintingPrefab(arg0_49, arg1_49, arg2_49, arg3_49)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_49, false, function(arg0_50)
		local var0_50 = {
			paintingTF = arg0_50,
			fitterTF = var0_49,
			defaultPaintingName = var2_49
		}

		onLoadedPaintingPrefab(var0_50)
	end, "metapainting/")
end

function setMetaPaintingPrefabAsync(arg0_51, arg1_51, arg2_51, arg3_51, arg4_51)
	local var0_51, var1_51, var2_51 = checkPaintingPrefab(arg0_51, arg1_51, arg2_51, arg4_51)

	var2_0[arg0_51] = var1_51

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_51, true, function(arg0_52)
		local var0_52 = {
			paintingTF = arg0_52,
			fitterTF = var0_51,
			objectOrTransform = arg0_51,
			paintingName = var1_51,
			defaultPaintingName = var2_51,
			callback = arg3_51
		}

		onLoadedPaintingPrefabAsync(var0_52)
	end, "metapainting/")
end

function retMetaPaintingPrefab(arg0_53, arg1_53)
	retPaintingPrefab(arg0_53, arg1_53, "metapainting/")
end

function setGuildPaintingPrefab(arg0_54, arg1_54, arg2_54, arg3_54)
	local var0_54, var1_54, var2_54 = checkPaintingPrefab(arg0_54, arg1_54, arg2_54, arg3_54)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_54, false, function(arg0_55)
		local var0_55 = {
			paintingTF = arg0_55,
			fitterTF = var0_54,
			defaultPaintingName = var2_54
		}

		onLoadedPaintingPrefab(var0_55)
	end, "guildpainting/")
end

function setGuildPaintingPrefabAsync(arg0_56, arg1_56, arg2_56, arg3_56, arg4_56)
	local var0_56, var1_56, var2_56 = checkPaintingPrefab(arg0_56, arg1_56, arg2_56, arg4_56)

	var2_0[arg0_56] = var1_56

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_56, true, function(arg0_57)
		local var0_57 = {
			paintingTF = arg0_57,
			fitterTF = var0_56,
			objectOrTransform = arg0_56,
			paintingName = var1_56,
			defaultPaintingName = var2_56,
			callback = arg3_56
		}

		onLoadedPaintingPrefabAsync(var0_57)
	end, "guildpainting/")
end

function retGuildPaintingPrefab(arg0_58, arg1_58)
	retPaintingPrefab(arg0_58, arg1_58, "guildpainting/")
end

function setShopPaintingPrefab(arg0_59, arg1_59, arg2_59, arg3_59)
	local var0_59, var1_59, var2_59 = checkPaintingPrefab(arg0_59, arg1_59, arg2_59, arg3_59)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_59, false, function(arg0_60)
		local var0_60 = {
			paintingTF = arg0_60,
			fitterTF = var0_59,
			defaultPaintingName = var2_59
		}

		onLoadedPaintingPrefab(var0_60)
	end, "shoppainting/")
end

function retShopPaintingPrefab(arg0_61, arg1_61)
	retPaintingPrefab(arg0_61, arg1_61, "shoppainting/")
end

function setBuildPaintingPrefabAsync(arg0_62, arg1_62, arg2_62, arg3_62, arg4_62)
	local var0_62, var1_62, var2_62 = checkPaintingPrefab(arg0_62, arg1_62, arg2_62, arg4_62)

	var2_0[arg0_62] = var1_62

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_62, true, function(arg0_63)
		local var0_63 = {
			paintingTF = arg0_63,
			fitterTF = var0_62,
			objectOrTransform = arg0_62,
			paintingName = var1_62,
			defaultPaintingName = var2_62,
			callback = arg3_62
		}

		onLoadedPaintingPrefabAsync(var0_63)
	end, "buildpainting/")
end

function retBuildPaintingPrefab(arg0_64, arg1_64)
	retPaintingPrefab(arg0_64, arg1_64, "buildpainting/")
end

function setColorCount(arg0_65, arg1_65, arg2_65)
	setText(arg0_65, string.format(arg1_65 < arg2_65 and "<color=" .. COLOR_RED .. ">%d</color>/%d" or "%d/%d", arg1_65, arg2_65))
end

function customColorCount(arg0_66, arg1_66, arg2_66, arg3_66, arg4_66)
	arg0_66.text = _customColorCount(arg1_66, arg2_66, arg3_66, arg4_66)
end

function _customColorCount(arg0_67, arg1_67, arg2_67, arg3_67)
	local var0_67 = arg0_67 < arg1_67 and arg3_67 or arg2_67

	return string.format("<color=" .. var0_67 .. ">%d</color>/%d" or "%d/%d", arg0_67, arg1_67)
end

function setColorStr(arg0_68, arg1_68)
	return "<color=" .. arg1_68 .. ">" .. arg0_68 .. "</color>"
end

function setSizeStr(arg0_69, arg1_69)
	local var0_69, var1_69 = string.gsub(arg0_69, "[<]size=%d+[>]", "<size=" .. arg1_69 .. ">")

	if var1_69 == 0 then
		var0_69 = "<size=" .. arg1_69 .. ">" .. var0_69 .. "</size>"
	end

	return var0_69
end

function getBgm(arg0_70, arg1_70)
	local var0_70 = pg.voice_bgm[arg0_70]

	if pg.CriMgr.GetInstance():IsDefaultBGM() then
		return var0_70 and var0_70.default_bgm or nil
	elseif var0_70 then
		if var0_70.special_bgm and type(var0_70.special_bgm) == "table" and #var0_70.special_bgm > 0 and _.all(var0_70.special_bgm, function(arg0_71)
			return type(arg0_71) == "table" and #arg0_71 > 2 and type(arg0_71[2]) == "number"
		end) then
			local var1_70 = Clone(var0_70.special_bgm)

			table.sort(var1_70, function(arg0_72, arg1_72)
				return arg0_72[2] > arg1_72[2]
			end)

			local var2_70 = ""

			_.each(var1_70, function(arg0_73)
				if var2_70 ~= "" then
					return
				end

				local var0_73 = arg0_73[1]
				local var1_73 = arg0_73[3]

				switch(var0_73, {
					function()
						local var0_74 = var1_73[1]
						local var1_74 = var1_73[2]

						if #var0_74 == 1 then
							if var0_74[1] ~= "always" then
								return
							end
						elseif not pg.TimeMgr.GetInstance():inTime(var0_74) then
							return
						end

						_.each(var1_74, function(arg0_75)
							if var2_70 ~= "" then
								return
							end

							if #arg0_75 == 2 and pg.TimeMgr.GetInstance():inPeriod(arg0_75[1]) then
								var2_70 = arg0_75[2]
							elseif #arg0_75 == 3 and pg.TimeMgr.GetInstance():inPeriod(arg0_75[1], arg0_75[2]) then
								var2_70 = arg0_75[3]
							end
						end)
					end,
					function()
						local var0_76 = false
						local var1_76 = ""

						_.each(var1_73, function(arg0_77)
							if #arg0_77 ~= 2 or var0_76 then
								return
							end

							if pg.NewStoryMgr.GetInstance():IsPlayed(arg0_77[1]) then
								var2_70 = arg0_77[2]

								if var2_70 ~= "" then
									var1_76 = var2_70
								else
									var2_70 = var1_76
								end
							else
								var0_76 = true
							end
						end)
					end,
					function()
						if not arg1_70 then
							return
						end

						_.each(var1_73, function(arg0_79)
							if #arg0_79 == 2 and arg0_79[1] == arg1_70 then
								var2_70 = arg0_79[2]

								return
							end
						end)
					end
				})
			end)

			return var2_70 ~= "" and var2_70 or var0_70.bgm
		else
			return var0_70 and var0_70.bgm or nil
		end
	else
		return nil
	end
end

function playStory(arg0_80, arg1_80)
	pg.NewStoryMgr.GetInstance():Play(arg0_80, arg1_80)
end

function errorMessage(arg0_81)
	local var0_81 = ERROR_MESSAGE[arg0_81]

	if var0_81 == nil then
		var0_81 = ERROR_MESSAGE[9999] .. ":" .. arg0_81
	end

	return var0_81
end

function errorTip(arg0_82, arg1_82, ...)
	local var0_82 = pg.gametip[arg0_82 .. "_error"]
	local var1_82

	if var0_82 then
		var1_82 = var0_82.tip
	else
		var1_82 = pg.gametip.common_error.tip
	end

	local var2_82 = arg0_82 .. "_error_" .. arg1_82

	if pg.gametip[var2_82] then
		local var3_82 = i18n(var2_82, ...)

		return var1_82 .. var3_82
	else
		local var4_82 = "common_error_" .. arg1_82

		if pg.gametip[var4_82] then
			local var5_82 = i18n(var4_82, ...)

			return var1_82 .. var5_82
		else
			local var6_82 = errorMessage(arg1_82)

			return var1_82 .. arg1_82 .. ":" .. var6_82
		end
	end
end

function colorNumber(arg0_83, arg1_83)
	local var0_83 = "@COLOR_SCOPE"
	local var1_83 = {}

	arg0_83 = string.gsub(arg0_83, "<color=#%x+>", function(arg0_84)
		table.insert(var1_83, arg0_84)

		return var0_83
	end)
	arg0_83 = string.gsub(arg0_83, "%d+%.?%d*%%*", function(arg0_85)
		return "<color=" .. arg1_83 .. ">" .. arg0_85 .. "</color>"
	end)

	if #var1_83 > 0 then
		local var2_83 = 0

		return (string.gsub(arg0_83, var0_83, function(arg0_86)
			var2_83 = var2_83 + 1

			return var1_83[var2_83]
		end))
	else
		return arg0_83
	end
end

function getBounds(arg0_87)
	local var0_87 = LuaHelper.GetWorldCorners(rtf(arg0_87))
	local var1_87 = Bounds.New(var0_87[0], Vector3.zero)

	var1_87:Encapsulate(var0_87[2])

	return var1_87
end

local function var3_0(arg0_88, arg1_88)
	arg0_88.localScale = Vector3.one
	arg0_88.anchorMin = Vector2.zero
	arg0_88.anchorMax = Vector2.one
	arg0_88.offsetMin = Vector2(arg1_88[1], arg1_88[2])
	arg0_88.offsetMax = Vector2(-arg1_88[3], -arg1_88[4])
end

local var4_0 = {
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
local var5_0 = {
	["IconColorful(Clone)"] = 1,
	["Item_duang5(Clone)"] = 99,
	specialFrame = 2
}

function setFrame(arg0_89, arg1_89, arg2_89)
	arg1_89 = tostring(arg1_89)

	local var0_89, var1_89 = unpack((string.split(arg1_89, "_")))

	if var1_89 or tonumber(var0_89) > 5 then
		arg2_89 = arg2_89 or "frame" .. arg1_89
	end

	GetImageSpriteFromAtlasAsync("weaponframes", "frame", arg0_89)

	local var2_89 = arg2_89 and Color.white or Color.NewHex(ItemRarity.Rarity2FrameHexColor(var0_89 and tonumber(var0_89) or ItemRarity.Gray))

	setImageColor(arg0_89, var2_89)

	local var3_89 = findTF(arg0_89, "specialFrame")

	if arg2_89 then
		if var3_89 then
			setActive(var3_89, true)
		else
			var3_89 = cloneTplTo(arg0_89, arg0_89, "specialFrame")

			removeAllChildren(var3_89)
		end

		var3_0(var3_89, var4_0[arg2_89] or var4_0.other)
		GetImageSpriteFromAtlasAsync("weaponframes", arg2_89, var3_89)
	elseif var3_89 then
		setActive(var3_89, false)
	end
end

function setIconColorful(arg0_90, arg1_90, arg2_90, arg3_90)
	arg3_90 = arg3_90 or {
		[ItemRarity.SSR] = {
			name = "IconColorful",
			active = function(arg0_91, arg1_91)
				return not arg1_91.noIconColorful and arg0_91 == ItemRarity.SSR
			end
		}
	}

	local var0_90 = findTF(arg0_90, "icon_bg/frame")

	for iter0_90, iter1_90 in pairs(arg3_90) do
		local var1_90 = iter1_90.name
		local var2_90 = iter1_90.active(arg1_90, arg2_90)
		local var3_90 = var0_90:Find(var1_90 .. "(Clone)")

		if var3_90 then
			setActive(var3_90, var2_90)
		elseif var2_90 then
			LoadAndInstantiateAsync("ui", string.lower(var1_90), function(arg0_92)
				if IsNil(arg0_90) or var0_90:Find(var1_90 .. "(Clone)") then
					Object.Destroy(arg0_92)
				else
					local var0_92 = var5_0[arg0_92.name] or 999
					local var1_92 = underscore.range(var0_90.childCount):chain():map(function(arg0_93)
						return var0_90:GetChild(arg0_93 - 1)
					end):map(function(arg0_94)
						return var5_0[arg0_94.name] or 0
					end):value()
					local var2_92 = 0

					for iter0_92 = #var1_92, 1, -1 do
						if var0_92 > var1_92[iter0_92] then
							var2_92 = iter0_92

							break
						end
					end

					setParent(arg0_92, var0_90)
					tf(arg0_92):SetSiblingIndex(var2_92)
					setActive(arg0_92, var2_90)
				end
			end)
		end
	end
end

function setIconStars(arg0_95, arg1_95, arg2_95)
	local var0_95 = findTF(arg0_95, "icon_bg/startpl")
	local var1_95 = findTF(arg0_95, "icon_bg/stars")

	if var1_95 and var0_95 then
		setActive(var1_95, false)
		setActive(var0_95, false)
	end

	if not var1_95 or not arg1_95 then
		return
	end

	for iter0_95 = 1, math.max(arg2_95, var1_95.childCount) do
		setActive(iter0_95 > var1_95.childCount and cloneTplTo(var0_95, var1_95) or var1_95:GetChild(iter0_95 - 1), iter0_95 <= arg2_95)
	end

	setActive(var1_95, true)
end

local function var6_0(arg0_96, arg1_96)
	local var0_96 = findTF(arg0_96, "icon_bg/slv")

	if not IsNil(var0_96) then
		setActive(var0_96, arg1_96 > 0)
		setText(findTF(var0_96, "Text"), arg1_96)
	end
end

function setIconName(arg0_97, arg1_97, arg2_97)
	local var0_97 = findTF(arg0_97, "name")

	if not IsNil(var0_97) then
		setText(var0_97, arg1_97)
		setTextAlpha(var0_97, (arg2_97.hideName or arg2_97.anonymous) and 0 or 1)
	end
end

function setIconCount(arg0_98, arg1_98)
	local var0_98 = findTF(arg0_98, "icon_bg/count")

	if not IsNil(var0_98) then
		setText(var0_98, arg1_98 and (type(arg1_98) ~= "number" or arg1_98 > 0) and arg1_98 or "")
	end
end

function updateEquipment(arg0_99, arg1_99, arg2_99)
	arg2_99 = arg2_99 or {}

	assert(arg1_99, "equipmentVo can not be nil.")

	local var0_99 = EquipmentRarity.Rarity2Print(arg1_99:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_99, findTF(arg0_99, "icon_bg"))
	setFrame(findTF(arg0_99, "icon_bg/frame"), var0_99)

	local var1_99 = findTF(arg0_99, "icon_bg/icon")

	var3_0(var1_99, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync("equips/" .. arg1_99:getConfig("icon"), "", var1_99)
	setIconStars(arg0_99, true, arg1_99:getConfig("rarity"))
	var6_0(arg0_99, arg1_99:getConfig("level") - 1)
	setIconName(arg0_99, arg1_99:getConfig("name"), arg2_99)
	setIconCount(arg0_99, arg1_99.count)
	setIconColorful(arg0_99, arg1_99:getConfig("rarity") - 1, arg2_99)
end

function updateItem(arg0_100, arg1_100, arg2_100)
	arg2_100 = arg2_100 or {}

	local var0_100 = ItemRarity.Rarity2Print(arg1_100:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_100, findTF(arg0_100, "icon_bg"))

	local var1_100

	if arg1_100:getConfig("type") == 9 then
		var1_100 = "frame_design"
	elseif arg1_100:getConfig("type") == 100 then
		var1_100 = "frame_dorm"
	elseif arg2_100.frame then
		var1_100 = arg2_100.frame
	end

	setFrame(findTF(arg0_100, "icon_bg/frame"), var0_100, var1_100)

	local var2_100 = findTF(arg0_100, "icon_bg/icon")
	local var3_100 = arg1_100.icon or arg1_100:getConfig("icon")

	if arg1_100:getConfig("type") == Item.LOVE_LETTER_TYPE then
		assert(arg1_100.extra, "without extra data")

		var3_100 = "SquareIcon/" .. ShipGroup.getDefaultSkin(arg1_100.extra).painting
	end

	GetImageSpriteFromAtlasAsync(var3_100, "", var2_100)
	setIconStars(arg0_100, false)
	setIconName(arg0_100, arg1_100:getName(), arg2_100)
	setIconColorful(arg0_100, arg1_100:getConfig("rarity"), arg2_100)
end

function updateIslandUnlock(arg0_101, arg1_101)
	local var0_101 = arg1_101:getConfigTable().cmd_icon
	local var1_101 = IslandItemRarity.Rarity2FrameName(ItemRarity.Gold)

	GetImageSpriteFromAtlasAsync("islandframe", var1_101, findTF(arg0_101, "icon_bg"))

	if not IsNil(findTF(arg0_101, "icon_bg/frame")) then
		GetImageSpriteFromAtlasAsync("islandframe", var1_101, findTF(arg0_101, "icon_bg/frame"))
	end

	setActive(findTF(arg0_101, "icon_bg/count_bg/count"), false)
	GetImageSpriteFromAtlasAsync(var0_101, "", findTF(arg0_101, "icon_bg/icon"))
	setIconName(arg0_101, "", {})
end

function updateIslandItem(arg0_102, arg1_102)
	local var0_102 = arg1_102:getConfigTable().rarity
	local var1_102 = arg1_102:getConfigTable().icon
	local var2_102 = arg1_102:getConfigTable().name
	local var3_102 = IslandItemRarity.Rarity2FrameName(var0_102)

	GetImageSpriteFromAtlasAsync("islandframe", var3_102, findTF(arg0_102, "icon_bg"))

	if not IsNil(findTF(arg0_102, "icon_bg/frame")) then
		GetImageSpriteFromAtlasAsync("islandframe", var3_102, findTF(arg0_102, "icon_bg/frame"))
	end

	setActive(findTF(arg0_102, "icon_bg/count_bg"), arg1_102.count > 0)
	setText(findTF(arg0_102, "icon_bg/count_bg/count"), arg1_102.count)
	GetImageSpriteFromAtlasAsync(var1_102, "", findTF(arg0_102, "icon_bg/icon"))
	setIconName(arg0_102, var2_102, {})
end

function updateWorldItem(arg0_103, arg1_103, arg2_103)
	arg2_103 = arg2_103 or {}

	local var0_103 = ItemRarity.Rarity2Print(arg1_103:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_103, findTF(arg0_103, "icon_bg"))
	setFrame(findTF(arg0_103, "icon_bg/frame"), var0_103)

	local var1_103 = findTF(arg0_103, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_103.icon or arg1_103:getConfig("icon"), "", var1_103)
	setIconStars(arg0_103, false)
	setIconName(arg0_103, arg1_103:getConfig("name"), arg2_103)
	setIconColorful(arg0_103, arg1_103:getConfig("rarity"), arg2_103)
end

function updateWorldCollection(arg0_104, arg1_104, arg2_104)
	arg2_104 = arg2_104 or {}

	assert(arg1_104:getConfigTable(), "world_collection_file_template 和 world_collection_record_template 表中找不到配置: " .. arg1_104.id)

	local var0_104 = arg1_104:getDropRarity()
	local var1_104 = ItemRarity.Rarity2Print(var0_104)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_104, findTF(arg0_104, "icon_bg"))
	setFrame(findTF(arg0_104, "icon_bg/frame"), var1_104)

	local var2_104 = findTF(arg0_104, "icon_bg/icon")
	local var3_104 = WorldCollectionProxy.GetCollectionType(arg1_104.id) == WorldCollectionProxy.WorldCollectionType.FILE and "shoucangguangdie" or "shoucangjiaojuan"

	GetImageSpriteFromAtlasAsync("props/" .. var3_104, "", var2_104)
	setIconStars(arg0_104, false)
	setIconName(arg0_104, arg1_104:getName(), arg2_104)
	setIconColorful(arg0_104, var0_104, arg2_104)
end

function updateWorldBuff(arg0_105, arg1_105, arg2_105)
	arg2_105 = arg2_105 or {}

	local var0_105 = pg.world_SLGbuff_data[arg1_105]

	assert(var0_105, "找不到大世界buff配置: " .. arg1_105)

	local var1_105 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_105, findTF(arg0_105, "icon_bg"))
	setFrame(findTF(arg0_105, "icon_bg/frame"), var1_105)

	local var2_105 = findTF(arg0_105, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("world/buff/" .. var0_105.icon, "", var2_105)

	local var3_105 = arg0_105:Find("icon_bg/stars")

	if not IsNil(var3_105) then
		setActive(var3_105, false)
	end

	local var4_105 = findTF(arg0_105, "name")

	if not IsNil(var4_105) then
		setText(var4_105, var0_105.name)
	end

	local var5_105 = findTF(arg0_105, "icon_bg/count")

	if not IsNil(var5_105) then
		SetActive(var5_105, false)
	end
end

function updateShip(arg0_106, arg1_106, arg2_106)
	arg2_106 = arg2_106 or {}

	local var0_106 = arg1_106:rarity2bgPrint()
	local var1_106 = arg1_106:getPainting()

	if arg2_106.anonymous then
		var0_106 = "1"
		var1_106 = "unknown"
	end

	if arg2_106.unknown_small then
		var1_106 = "unknown_small"
	end

	local var2_106 = findTF(arg0_106, "icon_bg/new")

	if var2_106 then
		if arg2_106.isSkin then
			setActive(var2_106, not arg2_106.isTimeLimit and arg2_106.isNew)
		else
			setActive(var2_106, arg1_106.virgin)
		end
	end

	local var3_106 = findTF(arg0_106, "icon_bg/timelimit")

	if var3_106 then
		setActive(var3_106, arg2_106.isTimeLimit)
	end

	local var4_106 = findTF(arg0_106, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. (arg2_106.isSkin and "_skin" or var0_106), var4_106)

	local var5_106 = findTF(arg0_106, "icon_bg/frame")
	local var6_106

	if arg1_106.isNpc then
		var6_106 = "frame_npc"
	elseif arg1_106:ShowPropose() then
		var6_106 = "frame_prop"

		if arg1_106:isMetaShip() then
			var6_106 = var6_106 .. "_meta"
		end
	elseif arg2_106.isSkin then
		var6_106 = "frame_skin"
	end

	setFrame(var5_106, var0_106, var6_106)

	if arg2_106.gray then
		setGray(var4_106, true, true)
	end

	local var7_106 = findTF(arg0_106, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg2_106.Q and "QIcon/" or "SquareIcon/") .. var1_106, "", var7_106)

	local var8_106 = findTF(arg0_106, "icon_bg/lv")

	if var8_106 then
		setActive(var8_106, not arg1_106.isNpc)

		if not arg1_106.isNpc then
			local var9_106 = findTF(var8_106, "Text")

			if var9_106 and arg1_106.level then
				setText(var9_106, arg1_106.level)
			end
		end
	end

	local var10_106 = findTF(arg0_106, "ship_type")

	if var10_106 then
		setActive(var10_106, true)
		setImageSprite(var10_106, GetSpriteFromAtlas("shiptype", shipType2print(arg1_106:getShipType())))
	end

	local var11_106 = var4_106:Find("npc")

	if not IsNil(var11_106) then
		if var2_106 and go(var2_106).activeSelf then
			setActive(var11_106, false)
		else
			setActive(var11_106, arg1_106:isActivityNpc())
		end
	end

	local var12_106 = arg0_106:Find("group_locked")

	if var12_106 then
		setActive(var12_106, not arg2_106.isSkin and not getProxy(CollectionProxy):getShipGroup(arg1_106.groupId))
	end

	setIconStars(arg0_106, arg2_106.initStar, arg1_106:getStar())
	setIconName(arg0_106, arg2_106.isSkin and arg1_106:GetSkinConfig().name or arg1_106:getName(), arg2_106)
	setIconColorful(arg0_106, arg2_106.isSkin and ItemRarity.Gold or arg1_106:getRarity() - 1, arg2_106)
end

function updateCommander(arg0_107, arg1_107, arg2_107)
	arg2_107 = arg2_107 or {}

	local var0_107 = arg1_107:getDropRarity()
	local var1_107 = ItemRarity.Rarity2Print(var0_107)
	local var2_107 = arg1_107:getConfig("painting")

	if arg2_107.anonymous then
		var1_107 = 1
		var2_107 = "unknown"
	end

	local var3_107 = findTF(arg0_107, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_107, var3_107)

	local var4_107 = findTF(arg0_107, "icon_bg/frame")

	setFrame(var4_107, var1_107)

	if arg2_107.gray then
		setGray(var3_107, true, true)
	end

	local var5_107 = findTF(arg0_107, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("CommanderIcon/" .. var2_107, "", var5_107)
	setIconStars(arg0_107, arg2_107.initStar, 0)
	setIconName(arg0_107, arg1_107:getName(), arg2_107)
end

function updateStrategy(arg0_108, arg1_108, arg2_108)
	arg2_108 = arg2_108 or {}

	local var0_108 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_108, findTF(arg0_108, "icon_bg"))
	setFrame(findTF(arg0_108, "icon_bg/frame"), var0_108)

	local var1_108 = findTF(arg0_108, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg1_108.isWorldBuff and "world/buff/" or "strategyicon/") .. arg1_108:getIcon(), "", var1_108)
	setIconStars(arg0_108, false)
	setIconName(arg0_108, arg1_108:getName(), arg2_108)
	setIconColorful(arg0_108, ItemRarity.Gray, arg2_108)
end

function updateFurniture(arg0_109, arg1_109, arg2_109)
	arg2_109 = arg2_109 or {}

	local var0_109 = arg1_109:getDropRarity()
	local var1_109 = ItemRarity.Rarity2Print(var0_109)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_109, findTF(arg0_109, "icon_bg"))
	setFrame(findTF(arg0_109, "icon_bg/frame"), var1_109)

	local var2_109 = findTF(arg0_109, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1_109:getIcon(), "", var2_109)
	setIconStars(arg0_109, false)
	setIconName(arg0_109, arg1_109:getName(), arg2_109)
	setIconColorful(arg0_109, var0_109, arg2_109)
end

function updateSpWeapon(arg0_110, arg1_110, arg2_110)
	arg2_110 = arg2_110 or {}

	assert(arg1_110, "spWeaponVO can not be nil.")
	assert(isa(arg1_110, SpWeapon), "spWeaponVO is not Equipment.")

	local var0_110 = ItemRarity.Rarity2Print(arg1_110:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_110, findTF(arg0_110, "icon_bg"))
	setFrame(findTF(arg0_110, "icon_bg/frame"), var0_110)

	local var1_110 = findTF(arg0_110, "icon_bg/icon")

	var3_0(var1_110, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync(arg1_110:GetIconPath(), "", var1_110)
	setIconStars(arg0_110, true, arg1_110:GetRarity())
	var6_0(arg0_110, arg1_110:GetLevel() - 1)
	setIconName(arg0_110, arg1_110:GetName(), arg2_110)
	setIconCount(arg0_110, arg1_110.count)
	setIconColorful(arg0_110, arg1_110:GetRarity(), arg2_110)
end

function UpdateSpWeaponSlot(arg0_111, arg1_111, arg2_111)
	local var0_111 = ItemRarity.Rarity2Print(arg1_111:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_111, findTF(arg0_111, "Icon/Mask/icon_bg"))

	local var1_111 = findTF(arg0_111, "Icon/Mask/icon_bg/icon")

	arg2_111 = arg2_111 or {
		16,
		16,
		16,
		16
	}

	var3_0(var1_111, arg2_111)
	GetImageSpriteFromAtlasAsync(arg1_111:GetIconPath(), "", var1_111)

	local var2_111 = arg1_111:GetLevel() - 1
	local var3_111 = findTF(arg0_111, "Icon/LV")

	setActive(var3_111, var2_111 > 0)
	setText(findTF(var3_111, "Text"), var2_111)
end

function updateDorm3dFurniture(arg0_112, arg1_112, arg2_112)
	arg2_112 = arg2_112 or {}

	local var0_112 = arg1_112:getDropRarity()
	local var1_112 = ItemRarity.Rarity2Print(var0_112)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_112, findTF(arg0_112, "icon_bg"))
	setFrame(findTF(arg0_112, "icon_bg/frame"), var1_112)

	local var2_112 = findTF(arg0_112, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_112:getIcon(), "", var2_112)
	setIconStars(arg0_112, false)
	setIconName(arg0_112, arg1_112:getName(), arg2_112)
	setIconColorful(arg0_112, var0_112, arg2_112)
end

function updateDorm3dGift(arg0_113, arg1_113, arg2_113)
	arg2_113 = arg2_113 or {}

	local var0_113 = arg1_113:getDropRarity()
	local var1_113 = ItemRarity.Rarity2Print(var0_113) or ItemRarity.Gray

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_113, arg0_113:Find("icon_bg"))
	setFrame(arg0_113:Find("icon_bg/frame"), var1_113)

	local var2_113 = arg0_113:Find("icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_113:getIcon(), "", var2_113)
	setIconStars(arg0_113, false)
	setIconName(arg0_113, arg1_113:getName(), arg2_113)
	setIconColorful(arg0_113, var0_113, arg2_113)
end

function updateDorm3dSkin(arg0_114, arg1_114, arg2_114)
	arg2_114 = arg2_114 or {}

	local var0_114 = arg1_114:getDropRarity()
	local var1_114 = ItemRarity.Rarity2Print(var0_114) or ItemRarity.Gray

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_114, arg0_114:Find("icon_bg"))
	setFrame(arg0_114:Find("icon_bg/frame"), var1_114)

	local var2_114 = arg0_114:Find("icon_bg/icon")

	setIconStars(arg0_114, false)
	setIconName(arg0_114, arg1_114:getName(), arg2_114)
	setIconColorful(arg0_114, var0_114, arg2_114)
end

function updateDorm3dIcon(arg0_115, arg1_115)
	local var0_115 = arg1_115:getDropRarityDorm()

	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(var0_115), arg0_115)

	local var1_115 = arg0_115:Find("icon")

	GetImageSpriteFromAtlasAsync(arg1_115:getIcon(), "", var1_115)
	setText(arg0_115:Find("count/Text"), "x" .. arg1_115.count)
	setText(arg0_115:Find("name/Text"), arg1_115:getName())
end

local var7_0

function findCullAndClipWorldRect(arg0_116)
	if #arg0_116 == 0 then
		return false
	end

	local var0_116 = arg0_116[1].canvasRect

	for iter0_116 = 1, #arg0_116 do
		var0_116 = rectIntersect(var0_116, arg0_116[iter0_116].canvasRect)
	end

	if var0_116.width <= 0 or var0_116.height <= 0 then
		return false
	end

	var7_0 = var7_0 or GameObject.Find("UICamera/Canvas").transform

	local var1_116 = var7_0:TransformPoint(Vector3(var0_116.x, var0_116.y, 0))
	local var2_116 = var7_0:TransformPoint(Vector3(var0_116.x + var0_116.width, var0_116.y + var0_116.height, 0))

	return true, Vector4(var1_116.x, var1_116.y, var2_116.x, var2_116.y)
end

function rectIntersect(arg0_117, arg1_117)
	local var0_117 = math.max(arg0_117.x, arg1_117.x)
	local var1_117 = math.min(arg0_117.x + arg0_117.width, arg1_117.x + arg1_117.width)
	local var2_117 = math.max(arg0_117.y, arg1_117.y)
	local var3_117 = math.min(arg0_117.y + arg0_117.height, arg1_117.y + arg1_117.height)

	if var0_117 <= var1_117 and var2_117 <= var3_117 then
		return var0_0.Rect.New(var0_117, var2_117, var1_117 - var0_117, var3_117 - var2_117)
	end

	return var0_0.Rect.New(0, 0, 0, 0)
end

function getDropInfo(arg0_118)
	local var0_118 = {}

	for iter0_118, iter1_118 in ipairs(arg0_118) do
		local var1_118 = Drop.Create(iter1_118)

		var1_118.count = var1_118.count or 1

		if var1_118.type == DROP_TYPE_EMOJI then
			table.insert(var0_118, var1_118:getName())
		else
			table.insert(var0_118, var1_118:getName() .. "x" .. var1_118.count)
		end
	end

	return table.concat(var0_118, "、")
end

function updateDrop(arg0_119, arg1_119, arg2_119)
	Drop.Change(arg1_119)

	arg2_119 = arg2_119 or {}

	local var0_119 = {
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
	local var1_119

	for iter0_119, iter1_119 in ipairs(var0_119) do
		local var2_119 = arg0_119:Find(iter1_119[1])

		if arg1_119.type ~= iter1_119[2] and not IsNil(var2_119) then
			setActive(var2_119, false)
		end
	end

	if not IsNil(arg0_119:Find("icon_bg/frame")) then
		arg0_119:Find("icon_bg/frame"):GetComponent(typeof(Image)).enabled = true

		setIconColorful(arg0_119, arg1_119:getDropRarity(), arg2_119, {
			[ItemRarity.Gold] = {
				name = "Item_duang5",
				active = function(arg0_120, arg1_120)
					return arg1_120.fromAwardLayer and arg0_120 >= ItemRarity.Gold
				end
			}
		})
		var3_0(findTF(arg0_119, "icon_bg/icon"), {
			2,
			2,
			2,
			2
		})
	end

	arg1_119:UpdateDropTpl(arg0_119, arg2_119)
	setIconCount(arg0_119, arg2_119.count or arg1_119:getCount())
end

function updateBuff(arg0_121, arg1_121, arg2_121)
	arg2_121 = arg2_121 or {}

	local var0_121 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_121, findTF(arg0_121, "icon_bg"))

	local var1_121 = pg.benefit_buff_template[arg1_121]

	setFrame(findTF(arg0_121, "icon_bg/frame"), var0_121)
	setText(findTF(arg0_121, "icon_bg/count"), 1)

	local var2_121 = findTF(arg0_121, "icon_bg/icon")
	local var3_121 = var1_121.icon

	GetImageSpriteFromAtlasAsync(var3_121, "", var2_121)
	setIconStars(arg0_121, false)
	setIconName(arg0_121, var1_121.name, arg2_121)
	setIconColorful(arg0_121, ItemRarity.Gold, arg2_121)
end

function updateAttire(arg0_122, arg1_122, arg2_122, arg3_122)
	local var0_122 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_122, findTF(arg0_122, "icon_bg"))
	setFrame(findTF(arg0_122, "icon_bg/frame"), var0_122)

	local var1_122 = findTF(arg0_122, "icon_bg/icon")
	local var2_122

	if arg1_122 == AttireConst.TYPE_CHAT_FRAME then
		var2_122 = "chat_frame"
	elseif arg1_122 == AttireConst.TYPE_ICON_FRAME then
		var2_122 = "icon_frame"
	end

	GetImageSpriteFromAtlasAsync("Props/" .. var2_122, "", var1_122)
	setIconName(arg0_122, arg2_122.name, arg3_122)
end

function updateAttireCombatUI(arg0_123, arg1_123, arg2_123, arg3_123)
	local var0_123 = arg2_123.rare

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_123, findTF(arg0_123, "icon_bg"))
	setFrame(findTF(arg0_123, "icon_bg/frame"), var0_123, "frame_battle_ui")

	local var1_123 = findTF(arg0_123, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("Props/" .. arg2_123.display_icon, "", var1_123)
	setIconName(arg0_123, arg2_123.name, arg3_123)
end

function updateActivityMedal(arg0_124, arg1_124, arg2_124)
	local var0_124 = ItemRarity.Rarity2Print(arg1_124.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_124, findTF(arg0_124, "icon_bg"))
	setFrame(findTF(arg0_124, "icon_bg/frame"), var0_124)

	local var1_124 = findTF(arg0_124, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_124.icon, "", var1_124)
	setIconName(arg0_124, arg1_124.name, arg2_124)
end

function updateCover(arg0_125, arg1_125, arg2_125)
	local var0_125 = arg1_125:getDropRarity()

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_125, findTF(arg0_125, "icon_bg"))
	setFrame(findTF(arg0_125, "icon_bg/frame"), var0_125)

	local var1_125 = findTF(arg0_125, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_125:getIcon(), "", var1_125)
	setIconName(arg0_125, arg1_125:getName(), arg2_125)
	setIconStars(arg0_125, false)
end

function updateEmoji(arg0_126, arg1_126, arg2_126)
	local var0_126 = findTF(arg0_126, "icon_bg/icon")
	local var1_126 = "icon_emoji"

	GetImageSpriteFromAtlasAsync("Props/" .. var1_126, "", var0_126)

	local var2_126 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var2_126, findTF(arg0_126, "icon_bg"))
	setFrame(findTF(arg0_126, "icon_bg/frame"), var2_126)
	setIconName(arg0_126, arg1_126.name, arg2_126)
end

function updateEquipmentSkin(arg0_127, arg1_127, arg2_127)
	arg2_127 = arg2_127 or {}

	local var0_127 = EquipmentRarity.Rarity2Print(arg1_127.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_127, findTF(arg0_127, "icon_bg"))
	setFrame(findTF(arg0_127, "icon_bg/frame"), var0_127, "frame_skin")

	local var1_127 = findTF(arg0_127, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. arg1_127.icon, "", var1_127)
	setIconStars(arg0_127, false)
	setIconName(arg0_127, arg1_127.name, arg2_127)
	setIconCount(arg0_127, arg1_127.count)
	setIconColorful(arg0_127, arg1_127.rarity - 1, arg2_127)
end

function NoPosMsgBox(arg0_128, arg1_128, arg2_128, arg3_128)
	local var0_128
	local var1_128 = {}

	if arg1_128 then
		table.insert(var1_128, {
			text = "text_noPos_clear",
			atuoClose = true,
			onCallback = arg1_128
		})
	end

	if arg2_128 then
		table.insert(var1_128, {
			text = "text_noPos_buy",
			atuoClose = true,
			onCallback = arg2_128
		})
	end

	if arg3_128 then
		table.insert(var1_128, {
			text = "text_noPos_intensify",
			atuoClose = true,
			onCallback = arg3_128
		})
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		hideNo = true,
		content = arg0_128,
		custom = var1_128,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function openDestroyEquip()
	if pg.m02:hasMediator(EquipmentMediator.__cname) then
		local var0_129 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_129 and var0_129.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_129
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
		local var0_130 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_130 and var0_130.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_130
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
		onClick = function(arg0_133, arg1_133)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
				page = 3,
				shipId = arg0_133.id,
				shipVOs = arg1_133
			})
		end
	})
end

function GoShoppingMsgBox(arg0_134, arg1_134, arg2_134)
	if arg2_134 then
		local var0_134 = ""

		for iter0_134, iter1_134 in ipairs(arg2_134) do
			local var1_134 = Item.getConfigData(iter1_134[1])

			var0_134 = var0_134 .. i18n(iter1_134[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var1_134.name, iter1_134[2])

			if iter0_134 < #arg2_134 then
				var0_134 = var0_134 .. i18n("text_noRes_info_tip_link")
			end
		end

		if var0_134 ~= "" then
			arg0_134 = arg0_134 .. "\n" .. i18n("text_noRes_tip", var0_134)
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = arg0_134,
		weight = LayerWeightConst.SECOND_LAYER,
		onYes = function()
			gotoChargeScene(arg1_134, arg2_134)
		end
	})
end

function shoppingBatch(arg0_136, arg1_136, arg2_136, arg3_136, arg4_136)
	local var0_136 = pg.shop_template[arg0_136]

	assert(var0_136, "shop_template中找不到商品id：" .. arg0_136)

	local var1_136 = getProxy(PlayerProxy):getData()[id2res(var0_136.resource_type)]
	local var2_136 = arg1_136.price or var0_136.resource_num
	local var3_136 = math.floor(var1_136 / var2_136)

	var3_136 = var3_136 <= 0 and 1 or var3_136
	var3_136 = arg2_136 ~= nil and arg2_136 < var3_136 and arg2_136 or var3_136

	local var4_136 = true
	local var5_136 = 1

	if var0_136 ~= nil and arg1_136.id then
		print(var3_136 * var0_136.num, "--", var3_136)
		assert(Item.getConfigData(arg1_136.id), "item config should be existence")

		local var6_136 = Item.New({
			id = arg1_136.id
		}):getConfig("name")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			needCounter = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_ITEM,
				id = arg1_136.id
			},
			addNum = var0_136.num,
			maxNum = var3_136 * var0_136.num,
			defaultNum = var0_136.num,
			numUpdate = function(arg0_137, arg1_137)
				var5_136 = math.floor(arg1_137 / var0_136.num)

				local var0_137 = var5_136 * var2_136

				if var0_137 > var1_136 then
					setText(arg0_137, i18n(arg3_136, var0_137, arg1_137, COLOR_RED, var6_136))

					var4_136 = false
				else
					setText(arg0_137, i18n(arg3_136, var0_137, arg1_137, COLOR_GREEN, var6_136))

					var4_136 = true
				end
			end,
			onYes = function()
				if var4_136 then
					pg.m02:sendNotification(GAME.SHOPPING, {
						id = arg0_136,
						count = var5_136
					})
				elseif arg4_136 then
					pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_136))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("main_playerInfoLayer_error_changeNameNoGem"))
				end
			end
		})
	end
end

function shoppingBatchNewStyle(arg0_139, arg1_139, arg2_139, arg3_139, arg4_139)
	local var0_139 = pg.shop_template[arg0_139]

	assert(var0_139, "shop_template中找不到商品id：" .. arg0_139)

	local var1_139 = getProxy(PlayerProxy):getData()[id2res(var0_139.resource_type)]
	local var2_139 = arg1_139.price or var0_139.resource_num
	local var3_139 = math.floor(var1_139 / var2_139)

	var3_139 = var3_139 <= 0 and 1 or var3_139
	var3_139 = arg2_139 ~= nil and arg2_139 < var3_139 and arg2_139 or var3_139

	local var4_139 = true
	local var5_139 = 1

	if var0_139 ~= nil and arg1_139.id then
		print(var3_139 * var0_139.num, "--", var3_139)
		assert(Item.getConfigData(arg1_139.id), "item config should be existence")

		local var6_139 = Item.New({
			id = arg1_139.id
		}):getConfig("name")

		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_SHOPPING, {
			drop = Drop.New({
				count = 1,
				type = DROP_TYPE_ITEM,
				id = arg1_139.id
			}),
			price = var2_139,
			addNum = var0_139.num,
			maxNum = var3_139 * var0_139.num,
			defaultNum = var0_139.num,
			numUpdate = function(arg0_140, arg1_140)
				var5_139 = math.floor(arg1_140 / var0_139.num)

				local var0_140 = var5_139 * var2_139

				if var0_140 > var1_139 then
					setTextInNewStyleBox(arg0_140, i18n(arg3_139, var0_140, arg1_140, COLOR_RED, var6_139))

					var4_139 = false
				else
					setTextInNewStyleBox(arg0_140, i18n(arg3_139, var0_140, arg1_140, "#238C40FF", var6_139))

					var4_139 = true
				end
			end,
			btnList = {
				{
					type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.shopping,
					name = i18n("word_buy"),
					func = function()
						if var4_139 then
							pg.m02:sendNotification(GAME.SHOPPING, {
								id = arg0_139,
								count = var5_139
							})
						elseif arg4_139 then
							pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_139))
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

function gotoChargeScene(arg0_142, arg1_142)
	local var0_142 = getProxy(ContextProxy)
	local var1_142 = getProxy(ContextProxy):getCurrentContext()

	if instanceof(var1_142.mediator, ChargeMediator) then
		var1_142.mediator:getViewComponent():switchSubViewByTogger(arg0_142)
	else
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
			wrap = arg0_142 or ChargeScene.TYPE_ITEM,
			noRes = arg1_142
		})
	end
end

function clearDrop(arg0_143)
	local var0_143 = findTF(arg0_143, "icon_bg")
	local var1_143 = findTF(arg0_143, "icon_bg/frame")
	local var2_143 = findTF(arg0_143, "icon_bg/icon")
	local var3_143 = findTF(arg0_143, "icon_bg/icon/icon")

	clearImageSprite(var0_143)
	clearImageSprite(var1_143)
	clearImageSprite(var2_143)

	if var3_143 then
		clearImageSprite(var3_143)
	end
end

local var8_0 = {
	red = Color.New(1, 0.25, 0.25),
	blue = Color.New(0.11, 0.55, 0.64),
	yellow = Color.New(0.92, 0.52, 0)
}

function updateSkill(arg0_144, arg1_144, arg2_144, arg3_144)
	local var0_144 = findTF(arg0_144, "skill")
	local var1_144 = findTF(arg0_144, "lock")
	local var2_144 = findTF(arg0_144, "unknown")

	if arg1_144 then
		setActive(var0_144, true)
		setActive(var2_144, false)
		setActive(var1_144, not arg2_144)
		LoadImageSpriteAsync("skillicon/" .. arg1_144.icon, findTF(var0_144, "icon"))

		local var3_144 = arg1_144.color or "blue"

		setText(findTF(var0_144, "name"), shortenString(getSkillName(arg1_144.id), arg3_144 or 8))

		local var4_144 = findTF(var0_144, "level")

		setText(var4_144, "LEVEL: " .. (arg2_144 and arg2_144.level or "??"))
		setTextColor(var4_144, var8_0[var3_144])
	else
		setActive(var0_144, false)
		setActive(var2_144, true)
		setActive(var1_144, false)
	end
end

local var9_0 = true

function onBackButton(arg0_145, arg1_145, arg2_145, arg3_145)
	local var0_145 = GetOrAddComponent(arg1_145, "UILongPressTrigger")

	assert(arg2_145, "callback should exist")

	var0_145.longPressThreshold = defaultValue(arg3_145, 1)

	local function var1_145(arg0_146)
		return function()
			if var9_0 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SOUND_BACK)
			end

			local var0_147, var1_147 = arg2_145()

			if var0_147 then
				arg0_146(var1_147)
			end
		end
	end

	local var2_145 = var0_145.onReleased

	pg.DelegateInfo.Add(arg0_145, var2_145)
	var2_145:RemoveAllListeners()
	var2_145:AddListener(var1_145(function(arg0_148)
		arg0_148:emit(BaseUI.ON_BACK)
	end))

	local var3_145 = var0_145.onLongPressed

	pg.DelegateInfo.Add(arg0_145, var3_145)
	var3_145:RemoveAllListeners()
	var3_145:AddListener(var1_145(function(arg0_149)
		arg0_149:emit(BaseUI.ON_HOME)
	end))
end

function GetZeroTime()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)
end

function GetHalfHour()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0, 1800)
end

function GetNextHour(arg0_152)
	local var0_152 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_152, var2_152 = pg.TimeMgr.GetInstance():parseTimeFrom(var0_152)

	return var1_152 * 86400 + (var2_152 + arg0_152) * 3600
end

function GetPerceptualSize(arg0_153, arg1_153)
	local function var0_153(arg0_154)
		if not arg0_154 then
			return 0, 1
		elseif arg0_154 > 240 then
			return 4, 1
		elseif arg0_154 > 225 then
			return 3, 1
		elseif arg0_154 > 192 then
			return 2, 1
		elseif arg0_154 < 126 then
			return 1, arg1_153 or 0.5
		else
			return 1, 1
		end
	end

	if type(arg0_153) == "number" then
		return var0_153(arg0_153)
	end

	local var1_153 = 1
	local var2_153 = 0
	local var3_153 = 0
	local var4_153 = #arg0_153

	while var1_153 <= var4_153 do
		local var5_153 = string.byte(arg0_153, var1_153)
		local var6_153, var7_153 = var0_153(var5_153)

		var1_153 = var1_153 + var6_153
		var2_153 = var2_153 + var7_153
	end

	return var2_153
end

function shortenString(arg0_155, arg1_155, arg2_155)
	local var0_155 = 1
	local var1_155 = 0
	local var2_155 = 0
	local var3_155 = #arg0_155

	while var0_155 <= var3_155 do
		local var4_155 = string.byte(arg0_155, var0_155)
		local var5_155, var6_155 = GetPerceptualSize(var4_155, arg2_155)

		var0_155 = var0_155 + var5_155
		var1_155 = var1_155 + var6_155

		if arg1_155 <= math.ceil(var1_155) then
			var2_155 = var0_155

			break
		end
	end

	if var2_155 == 0 or var3_155 < var2_155 then
		return arg0_155
	end

	return string.sub(arg0_155, 1, var2_155 - 1) .. ".."
end

function shouldShortenString(arg0_156, arg1_156)
	local var0_156 = 1
	local var1_156 = 0
	local var2_156 = 0
	local var3_156 = #arg0_156

	while var0_156 <= var3_156 do
		local var4_156 = string.byte(arg0_156, var0_156)
		local var5_156, var6_156 = GetPerceptualSize(var4_156)

		var0_156 = var0_156 + var5_156
		var1_156 = var1_156 + var6_156

		if arg1_156 <= math.ceil(var1_156) then
			var2_156 = var0_156

			break
		end
	end

	if var2_156 == 0 or var3_156 < var2_156 then
		return false
	end

	return true
end

function nameValidityCheck(arg0_157, arg1_157, arg2_157, arg3_157)
	local var0_157 = true
	local var1_157, var2_157 = utf8_to_unicode(arg0_157)
	local var3_157 = filterEgyUnicode(filterSpecChars(arg0_157))
	local var4_157 = wordVer(arg0_157)

	if not checkSpaceValid(arg0_157) then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_157[1]))

		var0_157 = false
	elseif var4_157 > 0 or var3_157 ~= arg0_157 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_157[4]))

		var0_157 = false
	elseif var2_157 < arg1_157 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_157[2]))

		var0_157 = false
	elseif arg2_157 < var2_157 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_157[3]))

		var0_157 = false
	end

	return var0_157
end

function checkSpaceValid(arg0_158)
	if PLATFORM_CODE == PLATFORM_US then
		return true
	end

	local var0_158 = string.gsub(arg0_158, " ", "")

	return arg0_158 == string.gsub(var0_158, "　", "")
end

function filterSpecChars(arg0_159)
	local var0_159 = {}
	local var1_159 = 0
	local var2_159 = 0
	local var3_159 = 0
	local var4_159 = 1

	while var4_159 <= #arg0_159 do
		local var5_159 = string.byte(arg0_159, var4_159)

		if not var5_159 then
			break
		end

		if var5_159 >= 48 and var5_159 <= 57 or var5_159 >= 65 and var5_159 <= 90 or var5_159 == 95 or var5_159 >= 97 and var5_159 <= 122 then
			table.insert(var0_159, string.char(var5_159))
		elseif var5_159 >= 228 and var5_159 <= 233 then
			local var6_159 = string.byte(arg0_159, var4_159 + 1)
			local var7_159 = string.byte(arg0_159, var4_159 + 2)

			if var6_159 and var7_159 and var6_159 >= 128 and var6_159 <= 191 and var7_159 >= 128 and var7_159 <= 191 then
				var4_159 = var4_159 + 2

				table.insert(var0_159, string.char(var5_159, var6_159, var7_159))

				var1_159 = var1_159 + 1
			end
		elseif var5_159 == 45 or var5_159 == 40 or var5_159 == 41 then
			table.insert(var0_159, string.char(var5_159))
		elseif var5_159 == 194 then
			local var8_159 = string.byte(arg0_159, var4_159 + 1)

			if var8_159 == 183 then
				var4_159 = var4_159 + 1

				table.insert(var0_159, string.char(var5_159, var8_159))

				var1_159 = var1_159 + 1
			end
		elseif var5_159 == 239 then
			local var9_159 = string.byte(arg0_159, var4_159 + 1)
			local var10_159 = string.byte(arg0_159, var4_159 + 2)

			if var9_159 == 188 and (var10_159 == 136 or var10_159 == 137) then
				var4_159 = var4_159 + 2

				table.insert(var0_159, string.char(var5_159, var9_159, var10_159))

				var1_159 = var1_159 + 1
			end
		elseif var5_159 == 206 or var5_159 == 207 then
			local var11_159 = string.byte(arg0_159, var4_159 + 1)

			if var5_159 == 206 and var11_159 >= 177 or var5_159 == 207 and var11_159 <= 134 then
				var4_159 = var4_159 + 1

				table.insert(var0_159, string.char(var5_159, var11_159))

				var1_159 = var1_159 + 1
			end
		elseif var5_159 == 227 and PLATFORM_CODE == PLATFORM_JP then
			local var12_159 = string.byte(arg0_159, var4_159 + 1)
			local var13_159 = string.byte(arg0_159, var4_159 + 2)

			if var12_159 and var13_159 and var12_159 > 128 and var12_159 <= 191 and var13_159 >= 128 and var13_159 <= 191 then
				var4_159 = var4_159 + 2

				table.insert(var0_159, string.char(var5_159, var12_159, var13_159))

				var2_159 = var2_159 + 1
			end
		elseif var5_159 >= 224 and PLATFORM_CODE == PLATFORM_KR then
			local var14_159 = string.byte(arg0_159, var4_159 + 1)
			local var15_159 = string.byte(arg0_159, var4_159 + 2)

			if var14_159 and var15_159 and var14_159 >= 128 and var14_159 <= 191 and var15_159 >= 128 and var15_159 <= 191 then
				var4_159 = var4_159 + 2

				table.insert(var0_159, string.char(var5_159, var14_159, var15_159))

				var3_159 = var3_159 + 1
			end
		elseif PLATFORM_CODE == PLATFORM_US then
			if var4_159 ~= 1 and var5_159 == 32 and string.byte(arg0_159, var4_159 + 1) ~= 32 then
				table.insert(var0_159, string.char(var5_159))
			end

			if var5_159 >= 192 and var5_159 <= 223 then
				local var16_159 = string.byte(arg0_159, var4_159 + 1)

				var4_159 = var4_159 + 1

				if var5_159 == 194 and var16_159 and var16_159 >= 128 then
					table.insert(var0_159, string.char(var5_159, var16_159))
				elseif var5_159 == 195 and var16_159 and var16_159 <= 191 then
					table.insert(var0_159, string.char(var5_159, var16_159))
				end
			end
		end

		var4_159 = var4_159 + 1
	end

	return table.concat(var0_159), var1_159 + var2_159 + var3_159
end

function filterEgyUnicode(arg0_160)
	arg0_160 = string.gsub(arg0_160, "�[�-�][�-�]", "")
	arg0_160 = string.gsub(arg0_160, "�[�-�]", "")

	return arg0_160
end

function shiftPanel(arg0_161, arg1_161, arg2_161, arg3_161, arg4_161, arg5_161, arg6_161, arg7_161, arg8_161)
	arg3_161 = arg3_161 or 0.2

	if arg5_161 then
		LeanTween.cancel(go(arg0_161))
	end

	local var0_161 = rtf(arg0_161)

	arg1_161 = arg1_161 or var0_161.anchoredPosition.x
	arg2_161 = arg2_161 or var0_161.anchoredPosition.y

	local var1_161 = LeanTween.move(var0_161, Vector3(arg1_161, arg2_161, 0), arg3_161)

	arg7_161 = arg7_161 or LeanTweenType.easeInOutSine

	var1_161:setEase(arg7_161)

	if arg4_161 then
		var1_161:setDelay(arg4_161)
	end

	if arg6_161 then
		GetOrAddComponent(arg0_161, "CanvasGroup").blocksRaycasts = false
	end

	var1_161:setOnComplete(System.Action(function()
		if arg8_161 then
			arg8_161()
		end

		if arg6_161 then
			GetOrAddComponent(arg0_161, "CanvasGroup").blocksRaycasts = true
		end
	end))

	return var1_161
end

function TweenValue(arg0_163, arg1_163, arg2_163, arg3_163, arg4_163, arg5_163, arg6_163, arg7_163)
	local var0_163 = LeanTween.value(go(arg0_163), arg1_163, arg2_163, arg3_163):setOnUpdate(System.Action_float(function(arg0_164)
		if arg5_163 then
			arg5_163(arg0_164)
		end
	end)):setOnComplete(System.Action(function()
		if arg6_163 then
			arg6_163()
		end
	end)):setDelay(arg4_163 or 0)

	if arg7_163 and arg7_163 > 0 then
		var0_163:setRepeat(arg7_163)
	end

	return var0_163
end

function rotateAni(arg0_166, arg1_166, arg2_166)
	return LeanTween.rotate(rtf(arg0_166), 360 * arg1_166, arg2_166):setLoopClamp()
end

function blinkAni(arg0_167, arg1_167, arg2_167, arg3_167)
	return LeanTween.alpha(rtf(arg0_167), arg3_167 or 0, arg1_167):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(arg2_167 or 0)
end

function scaleAni(arg0_168, arg1_168, arg2_168, arg3_168)
	return LeanTween.scale(rtf(arg0_168), arg3_168 or 0, arg1_168):setLoopPingPong(arg2_168 or 0)
end

function floatAni(arg0_169, arg1_169, arg2_169, arg3_169)
	local var0_169 = arg0_169.localPosition.y + arg1_169

	return LeanTween.moveY(rtf(arg0_169), var0_169, arg2_169):setLoopPingPong(arg3_169 or 0)
end

local var10_0 = tostring

function tostring(arg0_170)
	if arg0_170 == nil then
		return "nil"
	end

	local var0_170 = var10_0(arg0_170)

	if var0_170 == nil then
		if type(arg0_170) == "table" then
			return "{}"
		end

		return " ~nil"
	end

	return var0_170
end

function wordVer(arg0_171, arg1_171)
	if arg0_171.match(arg0_171, ChatConst.EmojiCodeMatch) then
		return 0, arg0_171
	end

	arg1_171 = arg1_171 or {}

	local var0_171 = filterEgyUnicode(arg0_171)

	if #var0_171 ~= #arg0_171 then
		if arg1_171.isReplace then
			arg0_171 = var0_171
		else
			return 1
		end
	end

	local var1_171 = wordSplit(arg0_171)
	local var2_171 = pg.word_template
	local var3_171 = pg.word_legal_template

	arg1_171.isReplace = arg1_171.isReplace or false
	arg1_171.replaceWord = arg1_171.replaceWord or "*"

	local var4_171 = #var1_171
	local var5_171 = 1
	local var6_171 = ""
	local var7_171 = 0

	while var5_171 <= var4_171 do
		local var8_171, var9_171, var10_171 = wordLegalMatch(var1_171, var3_171, var5_171)

		if var8_171 then
			var5_171 = var9_171
			var6_171 = var6_171 .. var10_171
		else
			local var11_171, var12_171, var13_171 = wordVerMatch(var1_171, var2_171, arg1_171, var5_171, "", false, var5_171, "")

			if var11_171 then
				var5_171 = var12_171
				var7_171 = var7_171 + 1

				if arg1_171.isReplace then
					var6_171 = var6_171 .. var13_171
				end
			else
				if arg1_171.isReplace then
					var6_171 = var6_171 .. var1_171[var5_171]
				end

				var5_171 = var5_171 + 1
			end
		end
	end

	if arg1_171.isReplace then
		return var7_171, var6_171
	else
		return var7_171
	end
end

function wordLegalMatch(arg0_172, arg1_172, arg2_172, arg3_172, arg4_172)
	if arg2_172 > #arg0_172 then
		return arg3_172, arg2_172, arg4_172
	end

	local var0_172 = arg0_172[arg2_172]
	local var1_172 = arg1_172[var0_172]

	arg4_172 = arg4_172 == nil and "" or arg4_172

	if var1_172 then
		if var1_172.this then
			return wordLegalMatch(arg0_172, var1_172, arg2_172 + 1, true, arg4_172 .. var0_172)
		else
			return wordLegalMatch(arg0_172, var1_172, arg2_172 + 1, false, arg4_172 .. var0_172)
		end
	else
		return arg3_172, arg2_172, arg4_172
	end
end

local var11_0 = string.byte("a")
local var12_0 = string.byte("z")
local var13_0 = string.byte("A")
local var14_0 = string.byte("Z")

local function var15_0(arg0_173)
	if not arg0_173 then
		return arg0_173
	end

	local var0_173 = string.byte(arg0_173)

	if var0_173 > 128 then
		return
	end

	if var0_173 >= var11_0 and var0_173 <= var12_0 then
		return string.char(var0_173 - 32)
	elseif var0_173 >= var13_0 and var0_173 <= var14_0 then
		return string.char(var0_173 + 32)
	else
		return arg0_173
	end
end

function wordVerMatch(arg0_174, arg1_174, arg2_174, arg3_174, arg4_174, arg5_174, arg6_174, arg7_174)
	if arg3_174 > #arg0_174 then
		return arg5_174, arg6_174, arg7_174
	end

	local var0_174 = arg0_174[arg3_174]
	local var1_174 = arg1_174[var0_174]

	if var1_174 then
		local var2_174, var3_174, var4_174 = wordVerMatch(arg0_174, var1_174, arg2_174, arg3_174 + 1, arg2_174.isReplace and arg4_174 .. arg2_174.replaceWord or arg4_174, var1_174.this or arg5_174, var1_174.this and arg3_174 + 1 or arg6_174, var1_174.this and (arg2_174.isReplace and arg4_174 .. arg2_174.replaceWord or arg4_174) or arg7_174)

		if var2_174 then
			return var2_174, var3_174, var4_174
		end
	end

	local var5_174 = var15_0(var0_174)
	local var6_174 = arg1_174[var5_174]

	if var5_174 ~= var0_174 and var6_174 then
		local var7_174, var8_174, var9_174 = wordVerMatch(arg0_174, var6_174, arg2_174, arg3_174 + 1, arg2_174.isReplace and arg4_174 .. arg2_174.replaceWord or arg4_174, var6_174.this or arg5_174, var6_174.this and arg3_174 + 1 or arg6_174, var6_174.this and (arg2_174.isReplace and arg4_174 .. arg2_174.replaceWord or arg4_174) or arg7_174)

		if var7_174 then
			return var7_174, var8_174, var9_174
		end
	end

	return arg5_174, arg6_174, arg7_174
end

function wordSplit(arg0_175)
	local var0_175 = {}

	for iter0_175 in arg0_175.gmatch(arg0_175, "[\x01-\x7F�-�][�-�]*") do
		var0_175[#var0_175 + 1] = iter0_175
	end

	return var0_175
end

function contentWrap(arg0_176, arg1_176, arg2_176)
	local var0_176 = LuaHelper.WrapContent(arg0_176, arg1_176, arg2_176)

	return #var0_176 ~= #arg0_176, var0_176
end

function cancelRich(arg0_177)
	local var0_177

	for iter0_177 = 1, 20 do
		local var1_177

		arg0_177, var1_177 = string.gsub(arg0_177, "<([^>]*)>", "%1")

		if var1_177 <= 0 then
			break
		end
	end

	return arg0_177
end

function cancelColorRich(arg0_178)
	local var0_178

	for iter0_178 = 1, 20 do
		local var1_178

		arg0_178, var1_178 = string.gsub(arg0_178, "<color=#[a-zA-Z0-9]+>(.-)</color>", "%1")

		if var1_178 <= 0 then
			break
		end
	end

	return arg0_178
end

function getSkillConfig(arg0_179)
	local var0_179 = pg.buffCfg["buff_" .. arg0_179]

	if not var0_179 then
		return
	end

	local var1_179 = Clone(var0_179)

	var1_179.name = getSkillName(arg0_179)
	var1_179.desc = HXSet.hxLan(var1_179.desc)
	var1_179.desc_get = HXSet.hxLan(var1_179.desc_get)

	_.each(var1_179, function(arg0_180)
		arg0_180.desc = HXSet.hxLan(arg0_180.desc)
	end)

	return var1_179
end

function getSkillName(arg0_181)
	local var0_181 = pg.skill_data_template[arg0_181] or pg.skill_data_display[arg0_181]

	if var0_181 then
		return HXSet.hxLan(var0_181.name)
	else
		return ""
	end
end

function getSkillDescGet(arg0_182, arg1_182)
	local var0_182 = arg1_182 and pg.skill_world_display[arg0_182] and setmetatable({}, {
		__index = function(arg0_183, arg1_183)
			return pg.skill_world_display[arg0_182][arg1_183] or pg.skill_data_template[arg0_182][arg1_183]
		end
	}) or pg.skill_data_template[arg0_182]

	if not var0_182 then
		return ""
	end

	local var1_182 = var0_182.desc_get ~= "" and var0_182.desc_get or var0_182.desc

	for iter0_182, iter1_182 in pairs(var0_182.desc_get_add) do
		local var2_182 = setColorStr(iter1_182[1], COLOR_GREEN)

		if iter1_182[2] then
			var2_182 = var2_182 .. specialGSub(i18n("word_skill_desc_get"), "$1", setColorStr(iter1_182[2], COLOR_GREEN))
		end

		var1_182 = specialGSub(var1_182, "$" .. iter0_182, var2_182)
	end

	return HXSet.hxLan(var1_182)
end

function getSkillDescLearn(arg0_184, arg1_184, arg2_184)
	local var0_184 = arg2_184 and pg.skill_world_display[arg0_184] and setmetatable({}, {
		__index = function(arg0_185, arg1_185)
			return pg.skill_world_display[arg0_184][arg1_185] or pg.skill_data_template[arg0_184][arg1_185]
		end
	}) or pg.skill_data_template[arg0_184]

	if not var0_184 then
		return ""
	end

	local var1_184 = var0_184.desc

	if not var0_184.desc_add then
		return HXSet.hxLan(var1_184)
	end

	for iter0_184, iter1_184 in pairs(var0_184.desc_add) do
		local var2_184 = iter1_184[arg1_184][1]

		if iter1_184[arg1_184][2] then
			var2_184 = var2_184 .. specialGSub(i18n("word_skill_desc_learn"), "$1", iter1_184[arg1_184][2])
		end

		var1_184 = specialGSub(var1_184, "$" .. iter0_184, setColorStr(var2_184, COLOR_YELLOW))
	end

	return HXSet.hxLan(var1_184)
end

function getSkillDesc(arg0_186, arg1_186, arg2_186)
	local var0_186 = arg2_186 and pg.skill_world_display[arg0_186] and setmetatable({}, {
		__index = function(arg0_187, arg1_187)
			return pg.skill_world_display[arg0_186][arg1_187] or pg.skill_data_template[arg0_186][arg1_187]
		end
	}) or pg.skill_data_template[arg0_186]

	if not var0_186 then
		return ""
	end

	local var1_186 = var0_186.desc

	if not var0_186.desc_add then
		return HXSet.hxLan(var1_186)
	end

	for iter0_186, iter1_186 in pairs(var0_186.desc_add) do
		local var2_186 = setColorStr(iter1_186[arg1_186][1], COLOR_GREEN)

		var1_186 = specialGSub(var1_186, "$" .. iter0_186, var2_186)
	end

	return HXSet.hxLan(var1_186)
end

function specialGSub(arg0_188, arg1_188, arg2_188)
	arg0_188 = string.gsub(arg0_188, "<color=#", "<color=NNN")
	arg0_188 = string.gsub(arg0_188, "#", "")
	arg2_188 = string.gsub(arg2_188, "%%", "%%%%")
	arg0_188 = string.gsub(arg0_188, arg1_188, arg2_188)
	arg0_188 = string.gsub(arg0_188, "<color=NNN", "<color=#")

	return arg0_188
end

function topAnimation(arg0_189, arg1_189, arg2_189, arg3_189, arg4_189, arg5_189)
	local var0_189 = {}

	arg4_189 = arg4_189 or 0.27

	local var1_189 = 0.05

	if arg0_189 then
		local var2_189 = arg0_189.transform.localPosition.x

		setAnchoredPosition(arg0_189, {
			x = var2_189 - 500
		})
		shiftPanel(arg0_189, var2_189, nil, 0.05, arg4_189, true, true)
		setActive(arg0_189, true)
	end

	setActive(arg1_189, false)
	setActive(arg2_189, false)
	setActive(arg3_189, false)

	for iter0_189 = 1, 3 do
		table.insert(var0_189, LeanTween.delayedCall(arg4_189 + 0.13 + var1_189 * iter0_189, System.Action(function()
			if arg1_189 then
				setActive(arg1_189, not arg1_189.gameObject.activeSelf)
			end
		end)).uniqueId)
		table.insert(var0_189, LeanTween.delayedCall(arg4_189 + 0.02 + var1_189 * iter0_189, System.Action(function()
			if arg2_189 then
				setActive(arg2_189, not go(arg2_189).activeSelf)
			end

			if arg2_189 then
				setActive(arg3_189, not go(arg3_189).activeSelf)
			end
		end)).uniqueId)
	end

	if arg5_189 then
		table.insert(var0_189, LeanTween.delayedCall(arg4_189 + 0.13 + var1_189 * 3 + 0.1, System.Action(function()
			arg5_189()
		end)).uniqueId)
	end

	return var0_189
end

function cancelTweens(arg0_193)
	assert(arg0_193, "must provide cancel targets, LeanTween.cancelAll is not allow")

	for iter0_193, iter1_193 in ipairs(arg0_193) do
		if iter1_193 then
			LeanTween.cancel(iter1_193)
		end
	end
end

function getOfflineTimeStamp(arg0_194)
	local var0_194 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_194
	local var1_194 = ""

	if var0_194 <= 59 then
		var1_194 = i18n("just_now")
	elseif var0_194 <= 3599 then
		var1_194 = i18n("several_minutes_before", math.floor(var0_194 / 60))
	elseif var0_194 <= 86399 then
		var1_194 = i18n("several_hours_before", math.floor(var0_194 / 3600))
	else
		var1_194 = i18n("several_days_before", math.floor(var0_194 / 86400))
	end

	return var1_194
end

function playMovie(arg0_195, arg1_195, arg2_195)
	local var0_195 = GameObject.Find("OverlayCamera/Overlay/UITop/MoviePanel")

	if not IsNil(var0_195) then
		pg.UIMgr.GetInstance():LoadingOn()
		WWWLoader.Inst:LoadStreamingAsset(arg0_195, function(arg0_196)
			pg.UIMgr.GetInstance():LoadingOff()

			local var0_196 = GCHandle.Alloc(arg0_196, GCHandleType.Pinned)

			setActive(var0_195, true)

			local var1_196 = var0_195:AddComponent(typeof(CriManaMovieControllerForUI))

			var1_196.player:SetData(arg0_196, arg0_196.Length)

			var1_196.target = var0_195:GetComponent(typeof(Image))
			var1_196.loop = false
			var1_196.additiveMode = false
			var1_196.playOnStart = true

			local var2_196

			var2_196 = Timer.New(function()
				if var1_196.player.status == CriMana.Player.Status.PlayEnd or var1_196.player.status == CriMana.Player.Status.Stop or var1_196.player.status == CriMana.Player.Status.Error then
					var2_196:Stop()
					Object.Destroy(var1_196)
					GCHandle.Free(var0_196)
					setActive(var0_195, false)

					if arg1_195 then
						arg1_195()
					end
				end
			end, 0.2, -1)

			var2_196:Start()
			removeOnButton(var0_195)

			if arg2_195 then
				onButton(nil, var0_195, function()
					var1_196:Stop()
					GetOrAddComponent(var0_195, typeof(Button)).onClick:RemoveAllListeners()
				end, SFX_CANCEL)
			end
		end)
	elseif arg1_195 then
		arg1_195()
	end
end

PaintCameraAdjustOn = false

function cameraPaintViewAdjust(arg0_199)
	if PaintCameraAdjustOn ~= arg0_199 then
		local var0_199 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(CanvasScaler))

		if arg0_199 then
			CameraMgr.instance.AutoAdapt = false

			CameraMgr.instance:Revert()

			var0_199.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight
			var0_199.matchWidthOrHeight = 1
		else
			CameraMgr.instance.AutoAdapt = true
			CameraMgr.instance.CurrentWidth = 1
			CameraMgr.instance.CurrentHeight = 1
			CameraMgr.instance.AspectRatio = 1.77777777777778
			var0_199.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand
		end

		PaintCameraAdjustOn = arg0_199
	end
end

function ManhattonDist(arg0_200, arg1_200)
	return math.abs(arg0_200.row - arg1_200.row) + math.abs(arg0_200.column - arg1_200.column)
end

function checkFirstHelpShow(arg0_201)
	local var0_201 = getProxy(SettingsProxy)

	if not var0_201:checkReadHelp(arg0_201) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[arg0_201].tip
		})
		var0_201:recordReadHelp(arg0_201)
	end
end

preOrientation = nil
preNotchFitterEnabled = false

function openPortrait(arg0_202)
	enableNotch(arg0_202, true)

	preOrientation = Input.deviceOrientation:ToString()

	originalPrint("Begining Orientation:" .. preOrientation)

	Screen.autorotateToPortrait = true
	Screen.autorotateToPortraitUpsideDown = true

	cameraPaintViewAdjust(true)
end

function closePortrait(arg0_203)
	enableNotch(arg0_203, false)

	Screen.autorotateToPortrait = false
	Screen.autorotateToPortraitUpsideDown = false

	originalPrint("Closing Orientation:" .. preOrientation)

	Screen.orientation = ScreenOrientation.LandscapeLeft

	local var0_203 = Timer.New(function()
		Screen.orientation = ScreenOrientation.AutoRotation
	end, 0.2, 1):Start()

	cameraPaintViewAdjust(false)
end

function enableNotch(arg0_205, arg1_205)
	if arg0_205 == nil then
		return
	end

	local var0_205 = arg0_205:GetComponent("NotchAdapt")
	local var1_205 = arg0_205:GetComponent("AspectRatioFitter")

	var0_205.enabled = arg1_205

	if var1_205 then
		if arg1_205 then
			var1_205.enabled = preNotchFitterEnabled
		else
			preNotchFitterEnabled = var1_205.enabled
			var1_205.enabled = false
		end
	end
end

function comma_value(arg0_206)
	local var0_206 = arg0_206
	local var1_206 = 0

	repeat
		local var2_206

		var0_206, var2_206 = string.gsub(var0_206, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var2_206 == 0

	return var0_206
end

local var16_0 = 0.2

function SwitchPanel(arg0_207, arg1_207, arg2_207, arg3_207, arg4_207, arg5_207)
	arg3_207 = defaultValue(arg3_207, var16_0)

	if arg5_207 then
		LeanTween.cancel(go(arg0_207))
	end

	local var0_207 = Vector3.New(tf(arg0_207).localPosition.x, tf(arg0_207).localPosition.y, tf(arg0_207).localPosition.z)

	if arg1_207 then
		var0_207.x = arg1_207
	end

	if arg2_207 then
		var0_207.y = arg2_207
	end

	local var1_207 = LeanTween.move(rtf(arg0_207), var0_207, arg3_207):setEase(LeanTweenType.easeInOutSine)

	if arg4_207 then
		var1_207:setDelay(arg4_207)
	end

	return var1_207
end

function updateActivityTaskStatus(arg0_208)
	local var0_208 = arg0_208:getConfig("config_id")
	local var1_208, var2_208 = getActivityTask(arg0_208, true)

	if not var2_208 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_208.id
		})

		return true
	end

	return false
end

function updateCrusingActivityTask(arg0_209)
	local var0_209 = getProxy(TaskProxy)
	local var1_209 = arg0_209:getNDay()
	local var2_209 = pg.TimeMgr.GetInstance():GetServerOverWeek(arg0_209:getStartTime())

	for iter0_209, iter1_209 in ipairs(arg0_209:getConfig("config_data")) do
		local var3_209 = pg.battlepass_task_group[iter1_209]

		if var3_209 and var2_209 >= var3_209.group_mask then
			if underscore.any(underscore.flatten(var3_209.task_group), function(arg0_210)
				return var0_209:getTaskVO(arg0_210) == nil
			end) then
				pg.m02:sendNotification(GAME.CRUSING_CMD, {
					cmd = 1,
					activity_id = arg0_209.id
				})

				return true
			end
		elseif not var3_209 then
			warning("battlepass_task_group表中不存在 id = " .. iter1_209)
		end
	end

	return false
end

function setShipCardFrame(arg0_211, arg1_211, arg2_211)
	arg0_211.localScale = Vector3.one
	arg0_211.anchorMin = Vector2.zero
	arg0_211.anchorMax = Vector2.one

	local var0_211 = arg2_211 or arg1_211

	GetImageSpriteFromAtlasAsync("shipframe", var0_211, arg0_211)

	local var1_211 = pg.frame_resource[var0_211]

	if var1_211 then
		local var2_211 = var1_211.param

		arg0_211.offsetMin = Vector2(var2_211[1], var2_211[2])
		arg0_211.offsetMax = Vector2(var2_211[3], var2_211[4])
	else
		arg0_211.offsetMin = Vector2.zero
		arg0_211.offsetMax = Vector2.zero
	end
end

function setRectShipCardFrame(arg0_212, arg1_212, arg2_212)
	arg0_212.localScale = Vector3.one
	arg0_212.anchorMin = Vector2.zero
	arg0_212.anchorMax = Vector2.one

	setImageSprite(arg0_212, GetSpriteFromAtlas("shipframeb", "b" .. (arg2_212 or arg1_212)))

	local var0_212 = "b" .. (arg2_212 or arg1_212)
	local var1_212 = pg.frame_resource[var0_212]

	if var1_212 then
		local var2_212 = var1_212.param

		arg0_212.offsetMin = Vector2(var2_212[1], var2_212[2])
		arg0_212.offsetMax = Vector2(var2_212[3], var2_212[4])
	else
		arg0_212.offsetMin = Vector2.zero
		arg0_212.offsetMax = Vector2.zero
	end
end

function setFrameEffect(arg0_213, arg1_213)
	if arg1_213 then
		local var0_213 = arg1_213 .. "(Clone)"
		local var1_213 = false

		eachChild(arg0_213, function(arg0_214)
			setActive(arg0_214, arg0_214.name == var0_213)

			var1_213 = var1_213 or arg0_214.name == var0_213
		end)

		if not var1_213 then
			LoadAndInstantiateAsync("effect", arg1_213, function(arg0_215)
				if IsNil(arg0_213) or findTF(arg0_213, var0_213) then
					Object.Destroy(arg0_215)
				else
					setParent(arg0_215, arg0_213)
					setActive(arg0_215, true)
				end
			end)
		end
	end

	setActive(arg0_213, arg1_213)
end

function setProposeMarkIcon(arg0_216, arg1_216)
	local var0_216 = arg0_216:Find("proposeShipCard(Clone)")
	local var1_216 = arg1_216.propose and not arg1_216:ShowPropose()

	if var0_216 then
		setActive(var0_216, var1_216)
	elseif var1_216 then
		pg.PoolMgr.GetInstance():GetUI("proposeShipCard", true, function(arg0_217)
			if IsNil(arg0_216) or arg0_216:Find("proposeShipCard(Clone)") then
				pg.PoolMgr.GetInstance():ReturnUI("proposeShipCard", arg0_217)
			else
				setParent(arg0_217, arg0_216, false)
			end
		end)
	end
end

function flushShipCard(arg0_218, arg1_218)
	local var0_218 = arg1_218:rarity2bgPrint()
	local var1_218 = findTF(arg0_218, "content/bg")

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var0_218, "", var1_218)

	local var2_218 = findTF(arg0_218, "content/ship_icon")
	local var3_218 = arg1_218 and {
		"shipYardIcon/" .. arg1_218:getPainting(),
		arg1_218:getPainting()
	} or {
		"shipYardIcon/unknown",
		""
	}

	GetImageSpriteFromAtlasAsync(var3_218[1], var3_218[2], var2_218)

	local var4_218 = arg1_218:getShipType()
	local var5_218 = findTF(arg0_218, "content/info/top/type")

	GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var4_218), var5_218)
	setText(findTF(arg0_218, "content/dockyard/lv/Text"), defaultValue(arg1_218.level, 1))

	local var6_218 = arg1_218:getStar()
	local var7_218 = arg1_218:getMaxStar()
	local var8_218 = findTF(arg0_218, "content/front/stars")

	setActive(var8_218, true)

	local var9_218 = findTF(var8_218, "star_tpl")
	local var10_218 = var8_218.childCount

	for iter0_218 = 1, Ship.CONFIG_MAX_STAR do
		local var11_218 = var10_218 < iter0_218 and cloneTplTo(var9_218, var8_218) or var8_218:GetChild(iter0_218 - 1)

		setActive(var11_218, iter0_218 <= var7_218)
		triggerToggle(var11_218, iter0_218 <= var6_218)
	end

	local var12_218 = findTF(arg0_218, "content/front/frame")
	local var13_218, var14_218 = arg1_218:GetFrameAndEffect()

	setShipCardFrame(var12_218, var0_218, var13_218)
	setFrameEffect(findTF(arg0_218, "content/front/bg_other"), var14_218)
	setProposeMarkIcon(arg0_218:Find("content/dockyard/propose"), arg1_218)
end

function TweenItemAlphaAndWhite(arg0_219)
	LeanTween.cancel(arg0_219)

	local var0_219 = GetOrAddComponent(arg0_219, "CanvasGroup")

	var0_219.alpha = 0

	LeanTween.alphaCanvas(var0_219, 1, 0.2):setUseEstimatedTime(true)

	local var1_219 = findTF(arg0_219.transform, "white_mask")

	if var1_219 then
		setActive(var1_219, false)
	end
end

function ClearTweenItemAlphaAndWhite(arg0_220)
	LeanTween.cancel(arg0_220)

	GetOrAddComponent(arg0_220, "CanvasGroup").alpha = 0
end

function getGroupOwnSkins(arg0_221)
	local var0_221 = {}
	local var1_221 = getProxy(ShipSkinProxy):getSkinList()
	local var2_221 = getProxy(CollectionProxy):getShipGroup(arg0_221)

	if var2_221 then
		local var3_221 = ShipGroup.getSkinList(arg0_221)

		for iter0_221, iter1_221 in ipairs(var3_221) do
			if iter1_221.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var1_221, iter1_221.id) or iter1_221.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var2_221.trans or iter1_221.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var2_221.married == 1 then
				var0_221[iter1_221.id] = true
			end
		end
	end

	return var0_221
end

function split(arg0_222, arg1_222)
	local var0_222 = {}

	if not arg0_222 then
		return nil
	end

	local var1_222 = #arg0_222
	local var2_222 = 1

	while var2_222 <= var1_222 do
		local var3_222 = string.find(arg0_222, arg1_222, var2_222)

		if var3_222 == nil then
			table.insert(var0_222, string.sub(arg0_222, var2_222, var1_222))

			break
		end

		table.insert(var0_222, string.sub(arg0_222, var2_222, var3_222 - 1))

		if var3_222 == var1_222 then
			table.insert(var0_222, "")

			break
		end

		var2_222 = var3_222 + 1
	end

	return var0_222
end

function NumberToChinese(arg0_223, arg1_223)
	local var0_223 = ""
	local var1_223 = #arg0_223

	for iter0_223 = 1, var1_223 do
		local var2_223 = string.sub(arg0_223, iter0_223, iter0_223)

		if var2_223 ~= "0" or var2_223 == "0" and not arg1_223 then
			if arg1_223 then
				if var1_223 >= 2 then
					if iter0_223 == 1 then
						if var2_223 == "1" then
							var0_223 = i18n("number_" .. 10)
						else
							var0_223 = i18n("number_" .. var2_223) .. i18n("number_" .. 10)
						end
					else
						var0_223 = var0_223 .. i18n("number_" .. var2_223)
					end
				else
					var0_223 = var0_223 .. i18n("number_" .. var2_223)
				end
			else
				var0_223 = var0_223 .. i18n("number_" .. var2_223)
			end
		end
	end

	return var0_223
end

function getActivityTask(arg0_224, arg1_224)
	local var0_224 = getProxy(TaskProxy)
	local var1_224 = arg0_224:getConfig("config_data")
	local var2_224 = arg0_224:getNDay(arg0_224.data1)
	local var3_224
	local var4_224
	local var5_224

	for iter0_224 = math.max(arg0_224.data3, 1), math.min(var2_224, #var1_224) do
		local var6_224 = _.flatten({
			var1_224[iter0_224]
		})

		for iter1_224, iter2_224 in ipairs(var6_224) do
			local var7_224 = var0_224:getTaskById(iter2_224)

			if var7_224 then
				return var7_224.id, var7_224
			end

			if var4_224 then
				var5_224 = var0_224:getFinishTaskById(iter2_224)

				if var5_224 then
					var4_224 = var5_224
				elseif arg1_224 then
					return iter2_224
				else
					return var4_224.id, var4_224
				end
			else
				var4_224 = var0_224:getFinishTaskById(iter2_224)
				var5_224 = var5_224 or iter2_224
			end
		end
	end

	if var4_224 then
		return var4_224.id, var4_224
	else
		return var5_224
	end
end

function setImageFromImage(arg0_225, arg1_225, arg2_225)
	local var0_225 = GetComponent(arg0_225, "Image")

	var0_225.sprite = GetComponent(arg1_225, "Image").sprite

	if arg2_225 then
		var0_225:SetNativeSize()
	end
end

function skinTimeStamp(arg0_226)
	local var0_226, var1_226, var2_226, var3_226 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_226)

	if var0_226 >= 1 then
		return i18n("limit_skin_time_day", var0_226)
	elseif var0_226 <= 0 and var1_226 > 0 then
		return i18n("limit_skin_time_day_min", var1_226, var2_226)
	elseif var0_226 <= 0 and var1_226 <= 0 and (var2_226 > 0 or var3_226 > 0) then
		return i18n("limit_skin_time_min", math.max(var2_226, 1))
	elseif var0_226 <= 0 and var1_226 <= 0 and var2_226 <= 0 and var3_226 <= 0 then
		return i18n("limit_skin_time_overtime")
	end
end

function skinCommdityTimeStamp(arg0_227)
	local var0_227 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_227 = math.max(arg0_227 - var0_227, 0)
	local var2_227 = math.floor(var1_227 / 86400)

	if var2_227 > 0 then
		return i18n("time_remaining_tip") .. var2_227 .. i18n("word_date")
	else
		local var3_227 = math.floor(var1_227 / 3600)

		if var3_227 > 0 then
			return i18n("time_remaining_tip") .. var3_227 .. i18n("word_hour")
		else
			local var4_227 = math.floor(var1_227 / 60)

			if var4_227 > 0 then
				return i18n("time_remaining_tip") .. var4_227 .. i18n("word_minute")
			else
				return i18n("time_remaining_tip") .. var1_227 .. i18n("word_second")
			end
		end
	end
end

function InstagramTimeStamp(arg0_228)
	local var0_228 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_228
	local var1_228 = var0_228 / 86400

	if var1_228 > 1 then
		return i18n("ins_word_day", math.floor(var1_228))
	else
		local var2_228 = var0_228 / 3600

		if var2_228 > 1 then
			return i18n("ins_word_hour", math.floor(var2_228))
		else
			local var3_228 = var0_228 / 60

			if var3_228 > 1 then
				return i18n("ins_word_minu", math.floor(var3_228))
			else
				return i18n("ins_word_minu", 1)
			end
		end
	end
end

function InstagramReplyTimeStamp(arg0_229)
	local var0_229 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_229
	local var1_229 = var0_229 / 86400

	if var1_229 > 1 then
		return i18n1(math.floor(var1_229) .. "d")
	else
		local var2_229 = var0_229 / 3600

		if var2_229 > 1 then
			return i18n1(math.floor(var2_229) .. "h")
		else
			local var3_229 = var0_229 / 60

			if var3_229 > 1 then
				return i18n1(math.floor(var3_229) .. "min")
			else
				return i18n1("1min")
			end
		end
	end
end

function attireTimeStamp(arg0_230)
	local var0_230, var1_230, var2_230, var3_230 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_230)

	if var0_230 <= 0 and var1_230 <= 0 and var2_230 <= 0 and var3_230 <= 0 then
		return i18n("limit_skin_time_overtime")
	else
		return i18n("attire_time_stamp", var0_230, var1_230, var2_230)
	end
end

function checkExist(arg0_231, ...)
	local var0_231 = {
		...
	}

	for iter0_231, iter1_231 in ipairs(var0_231) do
		if arg0_231 == nil then
			break
		end

		assert(type(arg0_231) == "table", "type error : intermediate target should be table")
		assert(type(iter1_231) == "table", "type error : param should be table")

		if type(arg0_231[iter1_231[1]]) == "function" then
			arg0_231 = arg0_231[iter1_231[1]](arg0_231, unpack(iter1_231[2] or {}))
		else
			arg0_231 = arg0_231[iter1_231[1]]
		end
	end

	return arg0_231
end

function AcessWithinNull(arg0_232, arg1_232)
	if arg0_232 == nil then
		return
	end

	assert(type(arg0_232) == "table")

	return arg0_232[arg1_232]
end

function showRepairMsgbox()
	local var0_233 = {
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var1_233 = {
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var2_233 = {
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
			var2_233,
			var1_233,
			var0_233
		}
	})
end

function resourceVerify(arg0_237, arg1_237)
	if CSharpVersion > 35 then
		BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()

		return
	end

	local var0_237 = Application.persistentDataPath .. "/hashes.csv"
	local var1_237
	local var2_237 = PathMgr.ReadAllLines(var0_237)
	local var3_237 = {}

	if arg0_237 then
		setActive(arg0_237, true)
	else
		pg.UIMgr.GetInstance():LoadingOn()
	end

	local function var4_237()
		if arg0_237 then
			setActive(arg0_237, false)
		else
			pg.UIMgr.GetInstance():LoadingOff()
		end

		print(var1_237)

		if var1_237 then
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

	local var5_237 = var2_237.Length
	local var6_237

	local function var7_237(arg0_240)
		if arg0_240 < 0 then
			var4_237()

			return
		end

		if arg1_237 then
			setSlider(arg1_237, 0, var5_237, var5_237 - arg0_240)
		end

		local var0_240 = string.split(var2_237[arg0_240], ",")
		local var1_240 = var0_240[1]
		local var2_240 = var0_240[3]
		local var3_240 = PathMgr.getAssetBundle(var1_240)

		if PathMgr.FileExists(var3_240) then
			local var4_240 = PathMgr.ReadAllBytes(PathMgr.getAssetBundle(var1_240))

			if var2_240 == HashUtil.CalcMD5(var4_240) then
				onNextTick(function()
					var7_237(arg0_240 - 1)
				end)

				return
			end
		end

		var1_237 = var1_240

		var4_237()
	end

	var7_237(var5_237 - 1)
end

function splitByWordEN(arg0_242, arg1_242)
	local var0_242 = string.split(arg0_242, " ")
	local var1_242 = ""
	local var2_242 = ""
	local var3_242 = arg1_242:GetComponent(typeof(RectTransform))
	local var4_242 = arg1_242:GetComponent(typeof(Text))
	local var5_242 = var3_242.rect.width

	for iter0_242, iter1_242 in ipairs(var0_242) do
		local var6_242 = var2_242

		var2_242 = var2_242 == "" and iter1_242 or var2_242 .. " " .. iter1_242

		setText(arg1_242, var2_242)

		if var5_242 < var4_242.preferredWidth then
			var1_242 = var1_242 == "" and var6_242 or var1_242 .. "\n" .. var6_242
			var2_242 = iter1_242
		end

		if iter0_242 >= #var0_242 then
			var1_242 = var1_242 == "" and var2_242 or var1_242 .. "\n" .. var2_242
		end
	end

	return var1_242
end

function checkBirthFormat(arg0_243)
	if #arg0_243 ~= 8 then
		return false
	end

	local var0_243 = 0
	local var1_243 = #arg0_243

	while var0_243 < var1_243 do
		local var2_243 = string.byte(arg0_243, var0_243 + 1)

		if var2_243 < 48 or var2_243 > 57 then
			return false
		end

		var0_243 = var0_243 + 1
	end

	return true
end

function isHalfBodyLive2D(arg0_244)
	local var0_244 = {
		"biaoqiang",
		"z23",
		"lafei",
		"lingbo",
		"mingshi",
		"xuefeng"
	}

	return _.any(var0_244, function(arg0_245)
		return arg0_245 == arg0_244
	end)
end

function GetServerState(arg0_246)
	local var0_246 = -1
	local var1_246 = 0
	local var2_246 = 1
	local var3_246 = 2
	local var4_246 = NetConst.GetServerStateUrl()

	if PLATFORM_CODE == PLATFORM_CH then
		var4_246 = string.gsub(var4_246, "https", "http")
	end

	VersionMgr.Inst:WebRequest(var4_246, function(arg0_247, arg1_247)
		local var0_247 = true
		local var1_247 = false

		for iter0_247 in string.gmatch(arg1_247, "\"state\":%d") do
			if iter0_247 ~= "\"state\":1" then
				var0_247 = false
			end

			var1_247 = true
		end

		if not var1_247 then
			var0_247 = false
		end

		if arg0_246 ~= nil then
			arg0_246(var0_247 and var2_246 or var1_246)
		end
	end)
end

function setScrollText(arg0_248, arg1_248)
	GetOrAddComponent(arg0_248, "ScrollText"):SetText(arg1_248)
end

function changeToScrollText(arg0_249, arg1_249)
	local var0_249 = GetComponent(arg0_249, typeof(Text))

	assert(var0_249, "without component<Text>")

	local var1_249 = arg0_249:Find("subText")

	if not var1_249 then
		var1_249 = cloneTplTo(arg0_249, arg0_249, "subText")

		eachChild(arg0_249, function(arg0_250)
			setActive(arg0_250, arg0_250 == var1_249)
		end)

		arg0_249:GetComponent(typeof(Text)).enabled = false
	end

	setScrollText(var1_249, arg1_249)
end

local var17_0
local var18_0
local var19_0
local var20_0

local function var21_0(arg0_251, arg1_251, arg2_251)
	local var0_251 = arg0_251:Find("base")
	local var1_251, var2_251, var3_251 = Equipment.GetInfoTrans(arg1_251, arg2_251)

	if arg1_251.nextValue then
		local var4_251 = {
			name = arg1_251.name,
			type = arg1_251.type,
			value = arg1_251.nextValue
		}
		local var5_251, var6_251 = Equipment.GetInfoTrans(var4_251, arg2_251)

		var2_251 = var2_251 .. setColorStr("   >   " .. var6_251, COLOR_GREEN)
	end

	setText(var0_251:Find("name"), var1_251)

	if var3_251 then
		local var7_251 = "<color=#afff72>(+" .. ys.Battle.BattleConst.UltimateBonus.AuxBoostValue * 100 .. "%)</color>"

		setText(var0_251:Find("value"), var2_251 .. var7_251)
	else
		setText(var0_251:Find("value"), var2_251)
	end

	setActive(var0_251:Find("value/up"), arg1_251.compare and arg1_251.compare > 0)
	setActive(var0_251:Find("value/down"), arg1_251.compare and arg1_251.compare < 0)
	triggerToggle(var0_251, arg1_251.lock_open)

	if not arg1_251.lock_open and arg1_251.sub and #arg1_251.sub > 0 then
		GetComponent(var0_251, typeof(Toggle)).enabled = true
	else
		setActive(var0_251:Find("name/close"), false)
		setActive(var0_251:Find("name/open"), false)

		GetComponent(var0_251, typeof(Toggle)).enabled = false
	end
end

local function var22_0(arg0_252, arg1_252, arg2_252, arg3_252)
	var21_0(arg0_252, arg2_252, arg3_252)

	if not arg2_252.sub or #arg2_252.sub == 0 then
		return
	end

	var19_0(arg0_252:Find("subs"), arg1_252, arg2_252.sub, arg3_252)
end

function var19_0(arg0_253, arg1_253, arg2_253, arg3_253)
	removeAllChildren(arg0_253)
	var20_0(arg0_253, arg1_253, arg2_253, arg3_253)
end

function var20_0(arg0_254, arg1_254, arg2_254, arg3_254)
	for iter0_254, iter1_254 in ipairs(arg2_254) do
		local var0_254 = cloneTplTo(arg1_254, arg0_254)

		var22_0(var0_254, arg1_254, iter1_254, arg3_254)
	end
end

function updateEquipInfo(arg0_255, arg1_255, arg2_255, arg3_255)
	local var0_255 = arg0_255:Find("attr_tpl")

	var19_0(arg0_255:Find("attrs"), var0_255, arg1_255.attrs, arg3_255)
	setActive(arg0_255:Find("skill"), arg2_255)

	if arg2_255 then
		var22_0(arg0_255:Find("skill/attr"), var0_255, {
			name = i18n("skill"),
			value = setColorStr(arg2_255.name, "#FFDE00FF")
		}, arg3_255)
		setText(arg0_255:Find("skill/value/Text"), getSkillDescGet(arg2_255.id))
	end

	setActive(arg0_255:Find("weapon"), #arg1_255.weapon.sub > 0)

	if #arg1_255.weapon.sub > 0 then
		var19_0(arg0_255:Find("weapon"), var0_255, {
			arg1_255.weapon
		}, arg3_255)
	end

	setActive(arg0_255:Find("equip_info"), #arg1_255.equipInfo.sub > 0)

	if #arg1_255.equipInfo.sub > 0 then
		var19_0(arg0_255:Find("equip_info"), var0_255, {
			arg1_255.equipInfo
		}, arg3_255)
	end

	var22_0(arg0_255:Find("part/attr"), var0_255, {
		name = i18n("equip_info_23")
	}, arg3_255)

	local var1_255 = arg0_255:Find("part/value")
	local var2_255 = var1_255:Find("label")
	local var3_255 = {}
	local var4_255 = {}

	if #arg1_255.part[1] == 0 and #arg1_255.part[2] == 0 then
		setmetatable(var3_255, {
			__index = function(arg0_256, arg1_256)
				return true
			end
		})
		setmetatable(var4_255, {
			__index = function(arg0_257, arg1_257)
				return true
			end
		})
	else
		for iter0_255, iter1_255 in ipairs(arg1_255.part[1]) do
			var3_255[iter1_255] = true
		end

		for iter2_255, iter3_255 in ipairs(arg1_255.part[2]) do
			var4_255[iter3_255] = true
		end
	end

	local var5_255 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var3_255, var4_255)

	UIItemList.StaticAlign(var1_255, var2_255, #var5_255, function(arg0_258, arg1_258, arg2_258)
		arg1_258 = arg1_258 + 1

		if arg0_258 == UIItemList.EventUpdate then
			local var0_258 = var5_255[arg1_258]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0_258), arg2_258)
			setActive(arg2_258:Find("main"), var3_255[var0_258] and not var4_255[var0_258])
			setActive(arg2_258:Find("sub"), var4_255[var0_258] and not var3_255[var0_258])
			setImageAlpha(arg2_258, not var3_255[var0_258] and not var4_255[var0_258] and 0.3 or 1)
		end
	end)
end

function updateEquipUpgradeInfo(arg0_259, arg1_259, arg2_259)
	local var0_259 = arg0_259:Find("attr_tpl")

	var19_0(arg0_259:Find("attrs"), var0_259, arg1_259.attrs, arg2_259)
	setActive(arg0_259:Find("weapon"), #arg1_259.weapon.sub > 0)

	if #arg1_259.weapon.sub > 0 then
		var19_0(arg0_259:Find("weapon"), var0_259, {
			arg1_259.weapon
		}, arg2_259)
	end

	setActive(arg0_259:Find("equip_info"), #arg1_259.equipInfo.sub > 0)

	if #arg1_259.equipInfo.sub > 0 then
		var19_0(arg0_259:Find("equip_info"), var0_259, {
			arg1_259.equipInfo
		}, arg2_259)
	end
end

function setCanvasOverrideSorting(arg0_260, arg1_260)
	local var0_260 = arg0_260.parent

	arg0_260:SetParent(pg.LayerWeightMgr.GetInstance().uiOrigin, false)

	if isActive(arg0_260) then
		GetOrAddComponent(arg0_260, typeof(Canvas)).overrideSorting = arg1_260
	else
		setActive(arg0_260, true)

		GetOrAddComponent(arg0_260, typeof(Canvas)).overrideSorting = arg1_260

		setActive(arg0_260, false)
	end

	arg0_260:SetParent(var0_260, false)
end

function createNewGameObject(arg0_261, arg1_261)
	local var0_261 = GameObject.New()

	if arg0_261 then
		var0_261.name = "model"
	end

	var0_261.layer = arg1_261 or Layer.UI

	return GetOrAddComponent(var0_261, "RectTransform")
end

function CreateShell(arg0_262)
	if type(arg0_262) ~= "table" and type(arg0_262) ~= "userdata" then
		return arg0_262
	end

	local var0_262 = setmetatable({
		__index = arg0_262
	}, arg0_262)

	return setmetatable({}, var0_262)
end

function CameraFittingSettin(arg0_263)
	local var0_263 = GetComponent(arg0_263, typeof(Camera))
	local var1_263 = 1.77777777777778
	local var2_263 = Screen.width / Screen.height

	if var2_263 < var1_263 then
		local var3_263 = var2_263 / var1_263

		var0_263.rect = var0_0.Rect.New(0, (1 - var3_263) / 2, 1, var3_263)
	end
end

function SwitchSpecialChar(arg0_264, arg1_264)
	if PLATFORM_CODE ~= PLATFORM_US then
		arg0_264 = arg0_264:gsub(" ", " ")
		arg0_264 = arg0_264:gsub("\t", "    ")
	end

	if not arg1_264 then
		arg0_264 = arg0_264:gsub("\n", " ")
	end

	return arg0_264
end

function AfterCheck(arg0_265, arg1_265)
	local var0_265 = {}

	for iter0_265, iter1_265 in ipairs(arg0_265) do
		var0_265[iter0_265] = iter1_265[1]()
	end

	arg1_265()

	for iter2_265, iter3_265 in ipairs(arg0_265) do
		if var0_265[iter2_265] ~= iter3_265[1]() then
			iter3_265[2]()
		end

		var0_265[iter2_265] = iter3_265[1]()
	end
end

function CompareFuncs(arg0_266, arg1_266)
	local var0_266 = {}

	local function var1_266(arg0_267, arg1_267)
		var0_266[arg0_267] = var0_266[arg0_267] or {}
		var0_266[arg0_267][arg1_267] = var0_266[arg0_267][arg1_267] or arg0_266[arg0_267](arg1_267)

		return var0_266[arg0_267][arg1_267]
	end

	return function(arg0_268, arg1_268)
		local var0_268 = 1

		while var0_268 <= #arg0_266 do
			local var1_268 = var1_266(var0_268, arg0_268)
			local var2_268 = var1_266(var0_268, arg1_268)

			if var1_268 == var2_268 then
				var0_268 = var0_268 + 1
			else
				return var1_268 < var2_268
			end
		end

		return tobool(arg1_266)
	end
end

function DropResultIntegration(arg0_269)
	local var0_269 = {}
	local var1_269 = 1

	while var1_269 <= #arg0_269 do
		local var2_269 = arg0_269[var1_269].type
		local var3_269 = arg0_269[var1_269].id

		var0_269[var2_269] = var0_269[var2_269] or {}

		if var0_269[var2_269][var3_269] then
			local var4_269 = arg0_269[var0_269[var2_269][var3_269]]
			local var5_269 = table.remove(arg0_269, var1_269)

			var4_269.count = var4_269.count + var5_269.count
		else
			var0_269[var2_269][var3_269] = var1_269
			var1_269 = var1_269 + 1
		end
	end

	local var6_269 = {
		function(arg0_270)
			local var0_270 = arg0_270.type
			local var1_270 = arg0_270.id

			if var0_270 == DROP_TYPE_SHIP then
				return 1
			elseif var0_270 == DROP_TYPE_RESOURCE then
				if var1_270 == 1 then
					return 2
				else
					return 3
				end
			elseif var0_270 == DROP_TYPE_ITEM then
				if var1_270 == 59010 then
					return 4
				elseif var1_270 == 59900 then
					return 5
				else
					local var2_270 = Item.getConfigData(var1_270)
					local var3_270 = var2_270 and var2_270.type or 0

					if var3_270 == 9 then
						return 6
					elseif var3_270 == 5 then
						return 7
					elseif var3_270 == 4 then
						return 8
					elseif var3_270 == 7 then
						return 9
					end
				end
			elseif var0_270 == DROP_TYPE_VITEM and var1_270 == 59011 then
				return 4
			end

			return 100
		end,
		function(arg0_271)
			local var0_271

			if arg0_271.type == DROP_TYPE_SHIP then
				var0_271 = pg.ship_data_statistics[arg0_271.id]
			elseif arg0_271.type == DROP_TYPE_ITEM then
				var0_271 = Item.getConfigData(arg0_271.id)
			end

			return (var0_271 and var0_271.rarity or 0) * -1
		end,
		function(arg0_272)
			return arg0_272.id
		end
	}

	table.sort(arg0_269, CompareFuncs(var6_269))
end

function getLoginConfig()
	local var0_273 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_273 = 1

	for iter0_273, iter1_273 in ipairs(pg.login.all) do
		if pg.login[iter1_273].date ~= "stop" then
			local var2_273, var3_273 = parseTimeConfig(pg.login[iter1_273].date)

			assert(not var3_273)

			if pg.TimeMgr.GetInstance():inTime(var2_273, var0_273) then
				var1_273 = iter1_273

				break
			end
		end
	end

	local var4_273 = pg.login[var1_273].login_static

	var4_273 = var4_273 ~= "" and var4_273 or "login"

	local var5_273 = pg.login[var1_273].login_cri
	local var6_273 = var5_273 ~= "" and true or false
	local var7_273 = pg.login[var1_273].op_play == 1 and true or false
	local var8_273 = pg.login[var1_273].op_time

	if var8_273 == "" or not pg.TimeMgr.GetInstance():inTime(var8_273, var0_273) then
		var7_273 = false
	end

	local var9_273 = var8_273 == "" and var8_273 or table.concat(var8_273[1][1])

	return var6_273, var6_273 and var5_273 or var4_273, pg.login[var1_273].bgm, var7_273, var9_273
end

function setIntimacyIcon(arg0_274, arg1_274, arg2_274)
	local var0_274 = {}
	local var1_274

	seriesAsync({
		function(arg0_275)
			if arg0_274.childCount > 0 then
				var1_274 = arg0_274:GetChild(0)

				arg0_275()
			else
				LoadAndInstantiateAsync("template", "intimacytpl", function(arg0_276)
					var1_274 = tf(arg0_276)

					setParent(var1_274, arg0_274)
					arg0_275()
				end)
			end
		end,
		function(arg0_277)
			setImageAlpha(var1_274, arg2_274 and 0 or 1)
			eachChild(var1_274, function(arg0_278)
				setActive(arg0_278, false)
			end)

			if arg2_274 then
				local var0_277 = var1_274:Find(arg2_274 .. "(Clone)")

				if not var0_277 then
					LoadAndInstantiateAsync("ui", arg2_274, function(arg0_279)
						setParent(arg0_279, var1_274)
						setActive(arg0_279, true)
					end)
				else
					setActive(var0_277, true)
				end
			elseif arg1_274 then
				setImageSprite(var1_274, GetSpriteFromAtlas("energy", arg1_274), true)
			else
				assert(false, "param error")
			end
		end
	})
end

local var23_0

function nowWorld()
	var23_0 = var23_0 or getProxy(WorldProxy)

	return var23_0 and var23_0.world
end

function removeWorld()
	var23_0.world:Dispose()

	var23_0.world = nil
	var23_0 = nil
end

function switch(arg0_282, arg1_282, arg2_282, ...)
	if arg1_282[arg0_282] then
		return arg1_282[arg0_282](...)
	elseif arg2_282 then
		return arg2_282(...)
	end
end

function parseTimeConfig(arg0_283)
	if type(arg0_283[1]) == "table" then
		return arg0_283[2], arg0_283[1]
	else
		return arg0_283
	end
end

local var24_0 = {
	__add = function(arg0_284, arg1_284)
		return NewPos(arg0_284.x + arg1_284.x, arg0_284.y + arg1_284.y)
	end,
	__sub = function(arg0_285, arg1_285)
		return NewPos(arg0_285.x - arg1_285.x, arg0_285.y - arg1_285.y)
	end,
	__mul = function(arg0_286, arg1_286)
		if type(arg1_286) == "number" then
			return NewPos(arg0_286.x * arg1_286, arg0_286.y * arg1_286)
		else
			return NewPos(arg0_286.x * arg1_286.x, arg0_286.y * arg1_286.y)
		end
	end,
	__eq = function(arg0_287, arg1_287)
		return arg0_287.x == arg1_287.x and arg0_287.y == arg1_287.y
	end,
	__tostring = function(arg0_288)
		return arg0_288.x .. "_" .. arg0_288.y
	end
}

function NewPos(arg0_289, arg1_289)
	assert(arg0_289 and arg1_289)

	local var0_289 = setmetatable({
		x = arg0_289,
		y = arg1_289
	}, var24_0)

	function var0_289.SqrMagnitude(arg0_290)
		return arg0_290.x * arg0_290.x + arg0_290.y * arg0_290.y
	end

	function var0_289.Normalize(arg0_291)
		local var0_291 = arg0_291:SqrMagnitude()

		if var0_291 > 1e-05 then
			return arg0_291 * (1 / math.sqrt(var0_291))
		else
			return NewPos(0, 0)
		end
	end

	return var0_289
end

local var25_0

function Timekeeping()
	warning(Time.realtimeSinceStartup - (var25_0 or Time.realtimeSinceStartup), Time.realtimeSinceStartup)

	var25_0 = Time.realtimeSinceStartup
end

function GetRomanDigit(arg0_293)
	return (string.char(226, 133, 160 + (arg0_293 - 1)))
end

function quickPlayAnimator(arg0_294, arg1_294)
	arg0_294:GetComponent(typeof(Animator)):Play(arg1_294, -1, 0)
end

function quickCheckAndPlayAnimator(arg0_295, arg1_295)
	local var0_295 = arg0_295:GetComponent(typeof(Animator))

	var0_295.enabled = true

	local var1_295 = Animator.StringToHash(arg1_295)

	if var0_295:HasState(0, var1_295) then
		var0_295:Play(arg1_295, -1, 0)
	end
end

function quickPlayAnimation(arg0_296, arg1_296)
	arg0_296:GetComponent(typeof(Animation)):Play(arg1_296)
end

function getSurveyUrl(arg0_297)
	local var0_297 = pg.survey_data_template[arg0_297]
	local var1_297

	if not IsUnityEditor then
		if PLATFORM_CODE == PLATFORM_CH then
			local var2_297 = getProxy(UserProxy):GetCacheGatewayInServerLogined()

			if var2_297 == PLATFORM_ANDROID then
				if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_BILI then
					var1_297 = var0_297.main_url
				else
					var1_297 = var0_297.uo_url
				end
			elseif var2_297 == PLATFORM_IPHONEPLAYER then
				var1_297 = var0_297.ios_url
			end
		elseif PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_KR then
			var1_297 = var0_297.main_url
		end
	else
		var1_297 = var0_297.main_url
	end

	local var3_297 = getProxy(PlayerProxy):getRawData().id
	local var4_297 = getProxy(UserProxy):getRawData().arg2 or ""
	local var5_297
	local var6_297 = PLATFORM == PLATFORM_ANDROID and 1 or PLATFORM == PLATFORM_IPHONEPLAYER and 2 or 3
	local var7_297 = getProxy(UserProxy):getRawData()
	local var8_297 = getProxy(ServerProxy):getRawData()[var7_297 and var7_297.server or 0]
	local var9_297 = var8_297 and var8_297.id or ""
	local var10_297 = getProxy(PlayerProxy):getRawData().level
	local var11_297 = var3_297 .. "_" .. arg0_297
	local var12_297 = var1_297
	local var13_297 = {
		var3_297,
		var4_297,
		var6_297,
		var9_297,
		var10_297,
		var11_297
	}

	if var12_297 then
		for iter0_297, iter1_297 in ipairs(var13_297) do
			var12_297 = string.gsub(var12_297, "$" .. iter0_297, tostring(iter1_297))
		end
	end

	originalPrint("survey url", tostring(var12_297))

	return var12_297
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

function FilterVarchar(arg0_299)
	assert(type(arg0_299) == "string" or type(arg0_299) == "table")

	if arg0_299 == "" then
		return nil
	end

	return arg0_299
end

function getGameset(arg0_300)
	local var0_300 = pg.gameset[arg0_300]

	assert(var0_300)

	return {
		var0_300.key_value,
		var0_300.description
	}
end

function getDorm3dGameset(arg0_301)
	local var0_301 = pg.dorm3d_set[arg0_301]

	assert(var0_301)

	return {
		var0_301.key_value_int,
		var0_301.key_value_varchar
	}
end

function GetItemsOverflowDic(arg0_302)
	arg0_302 = arg0_302 or {}

	local var0_302 = {
		[DROP_TYPE_ITEM] = {},
		[DROP_TYPE_RESOURCE] = {},
		[DROP_TYPE_EQUIP] = 0,
		[DROP_TYPE_SHIP] = 0,
		[DROP_TYPE_WORLD_ITEM] = 0
	}

	while #arg0_302 > 0 do
		local var1_302 = table.remove(arg0_302)

		switch(var1_302.type, {
			[DROP_TYPE_ITEM] = function()
				if var1_302:getConfig("open_directly") == 1 then
					for iter0_303, iter1_303 in ipairs(var1_302:getConfig("display_icon")) do
						local var0_303 = Drop.Create(iter1_303)

						var0_303.count = var0_303.count * var1_302.count

						table.insert(arg0_302, var0_303)
					end
				elseif var1_302:getSubClass():IsShipExpType() then
					var0_302[var1_302.type][var1_302.id] = defaultValue(var0_302[var1_302.type][var1_302.id], 0) + var1_302.count
				end
			end,
			[DROP_TYPE_RESOURCE] = function()
				var0_302[var1_302.type][var1_302.id] = defaultValue(var0_302[var1_302.type][var1_302.id], 0) + var1_302.count
			end,
			[DROP_TYPE_EQUIP] = function()
				var0_302[var1_302.type] = var0_302[var1_302.type] + var1_302.count
			end,
			[DROP_TYPE_SHIP] = function()
				var0_302[var1_302.type] = var0_302[var1_302.type] + var1_302.count
			end,
			[DROP_TYPE_WORLD_ITEM] = function()
				var0_302[var1_302.type] = var0_302[var1_302.type] + var1_302.count
			end
		})
	end

	return var0_302
end

function CheckOverflow(arg0_308, arg1_308)
	local var0_308 = {}
	local var1_308 = arg0_308[DROP_TYPE_RESOURCE][PlayerConst.ResGold] or 0
	local var2_308 = arg0_308[DROP_TYPE_RESOURCE][PlayerConst.ResOil] or 0
	local var3_308 = arg0_308[DROP_TYPE_EQUIP]
	local var4_308 = arg0_308[DROP_TYPE_SHIP]
	local var5_308 = getProxy(PlayerProxy):getRawData()
	local var6_308 = false

	if arg1_308 then
		local var7_308 = var5_308:OverStore(PlayerConst.ResStoreGold, var1_308)
		local var8_308 = var5_308:OverStore(PlayerConst.ResStoreOil, var2_308)

		if var7_308 > 0 or var8_308 > 0 then
			var0_308.isStoreOverflow = {
				var7_308,
				var8_308
			}
		end
	else
		if var1_308 > 0 and var5_308:GoldMax(var1_308) then
			return false, "gold"
		end

		if var2_308 > 0 and var5_308:OilMax(var2_308) then
			return false, "oil"
		end
	end

	var0_308.isExpBookOverflow = {}

	for iter0_308, iter1_308 in pairs(arg0_308[DROP_TYPE_ITEM]) do
		local var9_308 = Item.getConfigData(iter0_308)

		if getProxy(BagProxy):getItemCountById(iter0_308) + iter1_308 > var9_308.max_num then
			table.insert(var0_308.isExpBookOverflow, iter0_308)
		end
	end

	local var10_308 = getProxy(EquipmentProxy):getCapacity()

	if var3_308 > 0 and var10_308 >= var5_308:getMaxEquipmentBag() then
		return false, "equip"
	end

	local var11_308 = getProxy(BayProxy):getShipCount()

	if var4_308 > 0 and var4_308 + var11_308 > var5_308:getMaxShipBag() then
		return false, "ship"
	end

	return true, var0_308
end

function CheckShipExpOverflow(arg0_309)
	local var0_309 = getProxy(BagProxy)

	for iter0_309, iter1_309 in pairs(arg0_309[DROP_TYPE_ITEM]) do
		if var0_309:getItemCountById(iter0_309) + iter1_309 > Item.getConfigData(iter0_309).max_num then
			return false
		end
	end

	return true
end

local var26_0 = {
	[17] = "item_type17_tip2",
	tech = "techpackage_item_use_confirm",
	[16] = "item_type16_tip2",
	[11] = "equip_skin_detail_tip",
	[13] = "item_type13_tip2"
}

function RegisterDetailButton(arg0_310, arg1_310, arg2_310)
	Drop.Change(arg2_310)
	switch(arg2_310.type, {
		[DROP_TYPE_ITEM] = function()
			if arg2_310:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
				local var0_311 = Item.getConfigData(arg2_310.id).usage_arg
				local var1_311 = var0_311[3]

				if Item.InTimeLimitSkinAssigned(arg2_310.id) then
					var1_311 = table.mergeArray(var0_311[2], var1_311, true)
				end

				local var2_311 = {}

				for iter0_311, iter1_311 in ipairs(var0_311[2]) do
					var2_311[iter1_311] = true
				end

				onButton(arg0_310, arg1_310, function()
					arg0_310:closeView()
					pg.m02:sendNotification(GAME.LOAD_LAYERS, {
						parentContext = getProxy(ContextProxy):getCurrentContext(),
						context = Context.New({
							viewComponent = SelectSkinLayer,
							mediator = SkinAtlasMediator,
							data = {
								mode = SelectSkinLayer.MODE_VIEW,
								itemId = arg2_310.id,
								selectableSkinList = underscore.map(var1_311, function(arg0_313)
									return SelectableSkin.New({
										id = arg0_313,
										isTimeLimit = var2_311[arg0_313] or false
									})
								end)
							}
						})
					})
				end, SFX_PANEL)
				setActive(arg1_310, true)
			else
				local var3_311 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_310.id) and "tech" or arg2_310:getConfig("type")

				if var26_0[var3_311] then
					local var4_311 = {
						item2Row = true,
						content = i18n(var26_0[var3_311]),
						itemList = underscore.map(arg2_310:getConfig("display_icon"), function(arg0_314)
							return Drop.Create(arg0_314)
						end)
					}

					if var3_311 == 11 then
						onButton(arg0_310, arg1_310, function()
							arg0_310:emit(BaseUI.ON_DROP_LIST_OWN, var4_311)
						end, SFX_PANEL)
					else
						onButton(arg0_310, arg1_310, function()
							arg0_310:emit(BaseUI.ON_DROP_LIST, var4_311)
						end, SFX_PANEL)
					end
				end

				setActive(arg1_310, tobool(var26_0[var3_311]))
			end
		end,
		[DROP_TYPE_EQUIP] = function()
			onButton(arg0_310, arg1_310, function()
				arg0_310:emit(BaseUI.ON_DROP, arg2_310)
			end, SFX_PANEL)
			setActive(arg1_310, true)
		end,
		[DROP_TYPE_SPWEAPON] = function()
			onButton(arg0_310, arg1_310, function()
				arg0_310:emit(BaseUI.ON_DROP, arg2_310)
			end, SFX_PANEL)
			setActive(arg1_310, true)
		end
	}, function()
		setActive(arg1_310, false)
	end)
end

function RegisterNewStyleDetailButton(arg0_322, arg1_322, arg2_322)
	Drop.Change(arg2_322)
	switch(arg2_322.type, {
		[DROP_TYPE_ITEM] = function()
			local var0_323 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_322.id) and "tech" or arg2_322:getConfig("type")

			if var26_0[var0_323] then
				local var1_323 = {
					useDeepShow = true,
					showOwn = var0_323 == 11,
					content = i18n(var26_0[var0_323]),
					itemList = underscore.map(arg2_322:getConfig("display_icon"), function(arg0_324)
						return Drop.Create(arg0_324)
					end)
				}

				onButton(arg0_322, arg1_322, function()
					arg0_322:emit(BaseUI.ON_NEW_STYLE_ITEMS, var1_323)
				end, SFX_PANEL)
			end

			setActive(arg1_322, tobool(var26_0[var0_323]))
		end
	}, function()
		setActive(arg1_322, false)
	end)
end

function UpdateOwnDisplay(arg0_327, arg1_327)
	local var0_327, var1_327 = arg1_327:getOwnedCount()

	setActive(arg0_327, var1_327 and var0_327 > 0)

	if var1_327 and var0_327 > 0 then
		setText(arg0_327:Find("label"), i18n("word_own1"))
		setText(arg0_327:Find("Text"), var0_327)
	end
end

function Damp(arg0_328, arg1_328, arg2_328)
	arg1_328 = Mathf.Max(1, arg1_328)

	local var0_328 = Mathf.Epsilon

	if arg1_328 < var0_328 or var0_328 > Mathf.Abs(arg0_328) then
		return arg0_328
	end

	if arg2_328 < var0_328 then
		return 0
	end

	local var1_328 = -4.605170186

	return arg0_328 * (1 - Mathf.Exp(var1_328 * arg2_328 / arg1_328))
end

function checkCullResume(arg0_329)
	if not ReflectionHelp.RefCallMethodEx(typeof("UnityEngine.CanvasRenderer"), "GetMaterial", GetComponent(arg0_329, "CanvasRenderer"), {
		typeof("System.Int32")
	}, {
		0
	}) then
		local var0_329 = arg0_329:GetComponentsInChildren(typeof(MeshImage)):ToTable()

		for iter0_329, iter1_329 in ipairs(var0_329) do
			iter1_329:SetVerticesDirty()
		end

		return false
	end

	return true
end

function parseEquipCode(arg0_330)
	local var0_330 = {}

	if arg0_330 and arg0_330 ~= "" then
		local var1_330 = base64.dec(arg0_330)

		var0_330 = string.split(var1_330, "/")
		var0_330[5], var0_330[6] = unpack(string.split(var0_330[5], "\\"))

		if #var0_330 < 6 or arg0_330 ~= base64.enc(table.concat({
			table.concat(underscore.first(var0_330, 5), "/"),
			var0_330[6]
		}, "\\")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_illegal"))

			var0_330 = {}
		end
	end

	for iter0_330 = 1, 6 do
		var0_330[iter0_330] = var0_330[iter0_330] and tonumber(var0_330[iter0_330], 32) or 0
	end

	return var0_330
end

function buildEquipCode(arg0_331)
	local var0_331 = underscore.map(arg0_331:getAllEquipments(), function(arg0_332)
		return ConversionBase(32, arg0_332 and arg0_332.id or 0)
	end)
	local var1_331 = {
		table.concat(var0_331, "/"),
		ConversionBase(32, checkExist(arg0_331:GetSpWeapon(), {
			"id"
		}) or 0)
	}

	return base64.enc(table.concat(var1_331, "\\"))
end

function setDirectorSpeed(arg0_333, arg1_333)
	GetComponent(arg0_333, "TimelineSpeed"):SetTimelineSpeed(arg1_333)
end

function setDefaultZeroMetatable(arg0_334)
	return setmetatable(arg0_334, {
		__index = function(arg0_335, arg1_335)
			if rawget(arg0_335, arg1_335) == nil then
				arg0_335[arg1_335] = 0
			end

			return arg0_335[arg1_335]
		end
	})
end

function checkABExist(arg0_336)
	if EDITOR_TOOL then
		return ResourceMgr.Inst:AssetExist(arg0_336)
	else
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_336))
	end
end

function compareNumber(arg0_337, arg1_337, arg2_337)
	return switch(arg1_337, {
		[">"] = function()
			return arg0_337 > arg2_337
		end,
		[">="] = function()
			return arg0_337 >= arg2_337
		end,
		["="] = function()
			return arg0_337 == arg2_337
		end,
		["<"] = function()
			return arg0_337 < arg2_337
		end,
		["<="] = function()
			return arg0_337 <= arg2_337
		end
	})
end

function ArabicToRoman(arg0_343)
	local var0_343 = {
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

	local function var1_343(arg0_344, arg1_344)
		return select(2, arg0_344:gsub(arg1_344, ""))
	end

	local var2_343 = ""

	while arg0_343 > 0 do
		for iter0_343, iter1_343 in pairs(var0_343) do
			local var3_343 = iter1_343[2]
			local var4_343 = iter1_343[1]

			while var4_343 <= arg0_343 do
				var2_343 = var2_343 .. var3_343
				arg0_343 = arg0_343 - var4_343
			end
		end
	end

	if arg0_343 > 10000 then
		local var5_343 = var1_343(var2_343, "M")

		var2_343 = "M*" .. var5_343 .. " " .. var2_343
	end

	return var2_343
end

function stringInset(arg0_345, ...)
	for iter0_345, iter1_345 in ipairs({
		...
	}) do
		arg0_345 = string.gsub(arg0_345, "$" .. iter0_345, iter1_345)
	end

	return arg0_345
end
