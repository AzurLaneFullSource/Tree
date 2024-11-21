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
	GetComponent(arg0_29, "SkeletonGraphic").AnimationState:SetAnimation(0, arg1_29, defaultValue(arg2_29, true))
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

function setColorStr(arg0_66, arg1_66)
	return "<color=" .. arg1_66 .. ">" .. arg0_66 .. "</color>"
end

function setSizeStr(arg0_67, arg1_67)
	local var0_67, var1_67 = string.gsub(arg0_67, "[<]size=%d+[>]", "<size=" .. arg1_67 .. ">")

	if var1_67 == 0 then
		var0_67 = "<size=" .. arg1_67 .. ">" .. var0_67 .. "</size>"
	end

	return var0_67
end

function getBgm(arg0_68, arg1_68)
	local var0_68 = pg.voice_bgm[arg0_68]

	if pg.CriMgr.GetInstance():IsDefaultBGM() then
		return var0_68 and var0_68.default_bgm or nil
	elseif var0_68 then
		if var0_68.special_bgm and type(var0_68.special_bgm) == "table" and #var0_68.special_bgm > 0 and _.all(var0_68.special_bgm, function(arg0_69)
			return type(arg0_69) == "table" and #arg0_69 > 2 and type(arg0_69[2]) == "number"
		end) then
			local var1_68 = Clone(var0_68.special_bgm)

			table.sort(var1_68, function(arg0_70, arg1_70)
				return arg0_70[2] > arg1_70[2]
			end)

			local var2_68 = ""

			_.each(var1_68, function(arg0_71)
				if var2_68 ~= "" then
					return
				end

				local var0_71 = arg0_71[1]
				local var1_71 = arg0_71[3]

				switch(var0_71, {
					function()
						local var0_72 = var1_71[1]
						local var1_72 = var1_71[2]

						if #var0_72 == 1 then
							if var0_72[1] ~= "always" then
								return
							end
						elseif not pg.TimeMgr.GetInstance():inTime(var0_72) then
							return
						end

						_.each(var1_72, function(arg0_73)
							if var2_68 ~= "" then
								return
							end

							if #arg0_73 == 2 and pg.TimeMgr.GetInstance():inPeriod(arg0_73[1]) then
								var2_68 = arg0_73[2]
							elseif #arg0_73 == 3 and pg.TimeMgr.GetInstance():inPeriod(arg0_73[1], arg0_73[2]) then
								var2_68 = arg0_73[3]
							end
						end)
					end,
					function()
						local var0_74 = false
						local var1_74 = ""

						_.each(var1_71, function(arg0_75)
							if #arg0_75 ~= 2 or var0_74 then
								return
							end

							if pg.NewStoryMgr.GetInstance():IsPlayed(arg0_75[1]) then
								var2_68 = arg0_75[2]

								if var2_68 ~= "" then
									var1_74 = var2_68
								else
									var2_68 = var1_74
								end
							else
								var0_74 = true
							end
						end)
					end,
					function()
						if not arg1_68 then
							return
						end

						_.each(var1_71, function(arg0_77)
							if #arg0_77 == 2 and arg0_77[1] == arg1_68 then
								var2_68 = arg0_77[2]

								return
							end
						end)
					end
				})
			end)

			return var2_68 ~= "" and var2_68 or var0_68.bgm
		else
			return var0_68 and var0_68.bgm or nil
		end
	else
		return nil
	end
end

function playStory(arg0_78, arg1_78)
	pg.NewStoryMgr.GetInstance():Play(arg0_78, arg1_78)
end

function errorMessage(arg0_79)
	local var0_79 = ERROR_MESSAGE[arg0_79]

	if var0_79 == nil then
		var0_79 = ERROR_MESSAGE[9999] .. ":" .. arg0_79
	end

	return var0_79
end

function errorTip(arg0_80, arg1_80, ...)
	local var0_80 = pg.gametip[arg0_80 .. "_error"]
	local var1_80

	if var0_80 then
		var1_80 = var0_80.tip
	else
		var1_80 = pg.gametip.common_error.tip
	end

	local var2_80 = arg0_80 .. "_error_" .. arg1_80

	if pg.gametip[var2_80] then
		local var3_80 = i18n(var2_80, ...)

		return var1_80 .. var3_80
	else
		local var4_80 = "common_error_" .. arg1_80

		if pg.gametip[var4_80] then
			local var5_80 = i18n(var4_80, ...)

			return var1_80 .. var5_80
		else
			local var6_80 = errorMessage(arg1_80)

			return var1_80 .. arg1_80 .. ":" .. var6_80
		end
	end
end

function colorNumber(arg0_81, arg1_81)
	local var0_81 = "@COLOR_SCOPE"
	local var1_81 = {}

	arg0_81 = string.gsub(arg0_81, "<color=#%x+>", function(arg0_82)
		table.insert(var1_81, arg0_82)

		return var0_81
	end)
	arg0_81 = string.gsub(arg0_81, "%d+%.?%d*%%*", function(arg0_83)
		return "<color=" .. arg1_81 .. ">" .. arg0_83 .. "</color>"
	end)

	if #var1_81 > 0 then
		local var2_81 = 0

		return (string.gsub(arg0_81, var0_81, function(arg0_84)
			var2_81 = var2_81 + 1

			return var1_81[var2_81]
		end))
	else
		return arg0_81
	end
end

function getBounds(arg0_85)
	local var0_85 = LuaHelper.GetWorldCorners(rtf(arg0_85))
	local var1_85 = Bounds.New(var0_85[0], Vector3.zero)

	var1_85:Encapsulate(var0_85[2])

	return var1_85
end

local function var3_0(arg0_86, arg1_86)
	arg0_86.localScale = Vector3.one
	arg0_86.anchorMin = Vector2.zero
	arg0_86.anchorMax = Vector2.one
	arg0_86.offsetMin = Vector2(arg1_86[1], arg1_86[2])
	arg0_86.offsetMax = Vector2(-arg1_86[3], -arg1_86[4])
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

function setFrame(arg0_87, arg1_87, arg2_87)
	arg1_87 = tostring(arg1_87)

	local var0_87, var1_87 = unpack((string.split(arg1_87, "_")))

	if var1_87 or tonumber(var0_87) > 5 then
		arg2_87 = arg2_87 or "frame" .. arg1_87
	end

	GetImageSpriteFromAtlasAsync("weaponframes", "frame", arg0_87)

	local var2_87 = arg2_87 and Color.white or Color.NewHex(ItemRarity.Rarity2FrameHexColor(var0_87 and tonumber(var0_87) or ItemRarity.Gray))

	setImageColor(arg0_87, var2_87)

	local var3_87 = findTF(arg0_87, "specialFrame")

	if arg2_87 then
		if var3_87 then
			setActive(var3_87, true)
		else
			var3_87 = cloneTplTo(arg0_87, arg0_87, "specialFrame")

			removeAllChildren(var3_87)
		end

		var3_0(var3_87, var4_0[arg2_87] or var4_0.other)
		GetImageSpriteFromAtlasAsync("weaponframes", arg2_87, var3_87)
	elseif var3_87 then
		setActive(var3_87, false)
	end
end

function setIconColorful(arg0_88, arg1_88, arg2_88, arg3_88)
	arg3_88 = arg3_88 or {
		[ItemRarity.SSR] = {
			name = "IconColorful",
			active = function(arg0_89, arg1_89)
				return not arg1_89.noIconColorful and arg0_89 == ItemRarity.SSR
			end
		}
	}

	local var0_88 = findTF(arg0_88, "icon_bg/frame")

	for iter0_88, iter1_88 in pairs(arg3_88) do
		local var1_88 = iter1_88.name
		local var2_88 = iter1_88.active(arg1_88, arg2_88)
		local var3_88 = var0_88:Find(var1_88 .. "(Clone)")

		if var3_88 then
			setActive(var3_88, var2_88)
		elseif var2_88 then
			LoadAndInstantiateAsync("ui", string.lower(var1_88), function(arg0_90)
				if IsNil(arg0_88) or var0_88:Find(var1_88 .. "(Clone)") then
					Object.Destroy(arg0_90)
				else
					local var0_90 = var5_0[arg0_90.name] or 999
					local var1_90 = underscore.range(var0_88.childCount):chain():map(function(arg0_91)
						return var0_88:GetChild(arg0_91 - 1)
					end):map(function(arg0_92)
						return var5_0[arg0_92.name] or 0
					end):value()
					local var2_90 = 0

					for iter0_90 = #var1_90, 1, -1 do
						if var0_90 > var1_90[iter0_90] then
							var2_90 = iter0_90

							break
						end
					end

					setParent(arg0_90, var0_88)
					tf(arg0_90):SetSiblingIndex(var2_90)
					setActive(arg0_90, var2_88)
				end
			end)
		end
	end
end

function setIconStars(arg0_93, arg1_93, arg2_93)
	local var0_93 = findTF(arg0_93, "icon_bg/startpl")
	local var1_93 = findTF(arg0_93, "icon_bg/stars")

	if var1_93 and var0_93 then
		setActive(var1_93, false)
		setActive(var0_93, false)
	end

	if not var1_93 or not arg1_93 then
		return
	end

	for iter0_93 = 1, math.max(arg2_93, var1_93.childCount) do
		setActive(iter0_93 > var1_93.childCount and cloneTplTo(var0_93, var1_93) or var1_93:GetChild(iter0_93 - 1), iter0_93 <= arg2_93)
	end

	setActive(var1_93, true)
end

local function var6_0(arg0_94, arg1_94)
	local var0_94 = findTF(arg0_94, "icon_bg/slv")

	if not IsNil(var0_94) then
		setActive(var0_94, arg1_94 > 0)
		setText(findTF(var0_94, "Text"), arg1_94)
	end
end

function setIconName(arg0_95, arg1_95, arg2_95)
	local var0_95 = findTF(arg0_95, "name")

	if not IsNil(var0_95) then
		setText(var0_95, arg1_95)
		setTextAlpha(var0_95, (arg2_95.hideName or arg2_95.anonymous) and 0 or 1)
	end
end

function setIconCount(arg0_96, arg1_96)
	local var0_96 = findTF(arg0_96, "icon_bg/count")

	if not IsNil(var0_96) then
		setText(var0_96, arg1_96 and (type(arg1_96) ~= "number" or arg1_96 > 0) and arg1_96 or "")
	end
end

function updateEquipment(arg0_97, arg1_97, arg2_97)
	arg2_97 = arg2_97 or {}

	assert(arg1_97, "equipmentVo can not be nil.")

	local var0_97 = EquipmentRarity.Rarity2Print(arg1_97:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_97, findTF(arg0_97, "icon_bg"))
	setFrame(findTF(arg0_97, "icon_bg/frame"), var0_97)

	local var1_97 = findTF(arg0_97, "icon_bg/icon")

	var3_0(var1_97, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync("equips/" .. arg1_97:getConfig("icon"), "", var1_97)
	setIconStars(arg0_97, true, arg1_97:getConfig("rarity"))
	var6_0(arg0_97, arg1_97:getConfig("level") - 1)
	setIconName(arg0_97, arg1_97:getConfig("name"), arg2_97)
	setIconCount(arg0_97, arg1_97.count)
	setIconColorful(arg0_97, arg1_97:getConfig("rarity") - 1, arg2_97)
end

function updateItem(arg0_98, arg1_98, arg2_98)
	arg2_98 = arg2_98 or {}

	local var0_98 = ItemRarity.Rarity2Print(arg1_98:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_98, findTF(arg0_98, "icon_bg"))

	local var1_98

	if arg1_98:getConfig("type") == 9 then
		var1_98 = "frame_design"
	elseif arg1_98:getConfig("type") == 100 then
		var1_98 = "frame_dorm"
	elseif arg2_98.frame then
		var1_98 = arg2_98.frame
	end

	setFrame(findTF(arg0_98, "icon_bg/frame"), var0_98, var1_98)

	local var2_98 = findTF(arg0_98, "icon_bg/icon")
	local var3_98 = arg1_98.icon or arg1_98:getConfig("icon")

	if arg1_98:getConfig("type") == Item.LOVE_LETTER_TYPE then
		assert(arg1_98.extra, "without extra data")

		var3_98 = "SquareIcon/" .. ShipGroup.getDefaultSkin(arg1_98.extra).prefab
	end

	GetImageSpriteFromAtlasAsync(var3_98, "", var2_98)
	setIconStars(arg0_98, false)
	setIconName(arg0_98, arg1_98:getName(), arg2_98)
	setIconColorful(arg0_98, arg1_98:getConfig("rarity"), arg2_98)
end

function updateWorldItem(arg0_99, arg1_99, arg2_99)
	arg2_99 = arg2_99 or {}

	local var0_99 = ItemRarity.Rarity2Print(arg1_99:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_99, findTF(arg0_99, "icon_bg"))
	setFrame(findTF(arg0_99, "icon_bg/frame"), var0_99)

	local var1_99 = findTF(arg0_99, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_99.icon or arg1_99:getConfig("icon"), "", var1_99)
	setIconStars(arg0_99, false)
	setIconName(arg0_99, arg1_99:getConfig("name"), arg2_99)
	setIconColorful(arg0_99, arg1_99:getConfig("rarity"), arg2_99)
end

function updateWorldCollection(arg0_100, arg1_100, arg2_100)
	arg2_100 = arg2_100 or {}

	assert(arg1_100:getConfigTable(), "world_collection_file_template 和 world_collection_record_template 表中找不到配置: " .. arg1_100.id)

	local var0_100 = arg1_100:getDropRarity()
	local var1_100 = ItemRarity.Rarity2Print(var0_100)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_100, findTF(arg0_100, "icon_bg"))
	setFrame(findTF(arg0_100, "icon_bg/frame"), var1_100)

	local var2_100 = findTF(arg0_100, "icon_bg/icon")
	local var3_100 = WorldCollectionProxy.GetCollectionType(arg1_100.id) == WorldCollectionProxy.WorldCollectionType.FILE and "shoucangguangdie" or "shoucangjiaojuan"

	GetImageSpriteFromAtlasAsync("props/" .. var3_100, "", var2_100)
	setIconStars(arg0_100, false)
	setIconName(arg0_100, arg1_100:getName(), arg2_100)
	setIconColorful(arg0_100, var0_100, arg2_100)
end

function updateWorldBuff(arg0_101, arg1_101, arg2_101)
	arg2_101 = arg2_101 or {}

	local var0_101 = pg.world_SLGbuff_data[arg1_101]

	assert(var0_101, "找不到大世界buff配置: " .. arg1_101)

	local var1_101 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_101, findTF(arg0_101, "icon_bg"))
	setFrame(findTF(arg0_101, "icon_bg/frame"), var1_101)

	local var2_101 = findTF(arg0_101, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("world/buff/" .. var0_101.icon, "", var2_101)

	local var3_101 = arg0_101:Find("icon_bg/stars")

	if not IsNil(var3_101) then
		setActive(var3_101, false)
	end

	local var4_101 = findTF(arg0_101, "name")

	if not IsNil(var4_101) then
		setText(var4_101, var0_101.name)
	end

	local var5_101 = findTF(arg0_101, "icon_bg/count")

	if not IsNil(var5_101) then
		SetActive(var5_101, false)
	end
end

function updateShip(arg0_102, arg1_102, arg2_102)
	arg2_102 = arg2_102 or {}

	local var0_102 = arg1_102:rarity2bgPrint()
	local var1_102 = arg1_102:getPainting()

	if arg2_102.anonymous then
		var0_102 = "1"
		var1_102 = "unknown"
	end

	if arg2_102.unknown_small then
		var1_102 = "unknown_small"
	end

	local var2_102 = findTF(arg0_102, "icon_bg/new")

	if var2_102 then
		if arg2_102.isSkin then
			setActive(var2_102, not arg2_102.isTimeLimit and arg2_102.isNew)
		else
			setActive(var2_102, arg1_102.virgin)
		end
	end

	local var3_102 = findTF(arg0_102, "icon_bg/timelimit")

	if var3_102 then
		setActive(var3_102, arg2_102.isTimeLimit)
	end

	local var4_102 = findTF(arg0_102, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. (arg2_102.isSkin and "_skin" or var0_102), var4_102)

	local var5_102 = findTF(arg0_102, "icon_bg/frame")
	local var6_102

	if arg1_102.isNpc then
		var6_102 = "frame_npc"
	elseif arg1_102:ShowPropose() then
		var6_102 = "frame_prop"

		if arg1_102:isMetaShip() then
			var6_102 = var6_102 .. "_meta"
		end
	elseif arg2_102.isSkin then
		var6_102 = "frame_skin"
	end

	setFrame(var5_102, var0_102, var6_102)

	if arg2_102.gray then
		setGray(var4_102, true, true)
	end

	local var7_102 = findTF(arg0_102, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg2_102.Q and "QIcon/" or "SquareIcon/") .. var1_102, "", var7_102)

	local var8_102 = findTF(arg0_102, "icon_bg/lv")

	if var8_102 then
		setActive(var8_102, not arg1_102.isNpc)

		if not arg1_102.isNpc then
			local var9_102 = findTF(var8_102, "Text")

			if var9_102 and arg1_102.level then
				setText(var9_102, arg1_102.level)
			end
		end
	end

	local var10_102 = findTF(arg0_102, "ship_type")

	if var10_102 then
		setActive(var10_102, true)
		setImageSprite(var10_102, GetSpriteFromAtlas("shiptype", shipType2print(arg1_102:getShipType())))
	end

	local var11_102 = var4_102:Find("npc")

	if not IsNil(var11_102) then
		if var2_102 and go(var2_102).activeSelf then
			setActive(var11_102, false)
		else
			setActive(var11_102, arg1_102:isActivityNpc())
		end
	end

	local var12_102 = arg0_102:Find("group_locked")

	if var12_102 then
		setActive(var12_102, not arg2_102.isSkin and not getProxy(CollectionProxy):getShipGroup(arg1_102.groupId))
	end

	setIconStars(arg0_102, arg2_102.initStar, arg1_102:getStar())
	setIconName(arg0_102, arg2_102.isSkin and arg1_102:GetSkinConfig().name or arg1_102:getName(), arg2_102)
	setIconColorful(arg0_102, arg2_102.isSkin and ItemRarity.Gold or arg1_102:getRarity() - 1, arg2_102)
end

function updateCommander(arg0_103, arg1_103, arg2_103)
	arg2_103 = arg2_103 or {}

	local var0_103 = arg1_103:getDropRarity()
	local var1_103 = ItemRarity.Rarity2Print(var0_103)
	local var2_103 = arg1_103:getConfig("painting")

	if arg2_103.anonymous then
		var1_103 = 1
		var2_103 = "unknown"
	end

	local var3_103 = findTF(arg0_103, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_103, var3_103)

	local var4_103 = findTF(arg0_103, "icon_bg/frame")

	setFrame(var4_103, var1_103)

	if arg2_103.gray then
		setGray(var3_103, true, true)
	end

	local var5_103 = findTF(arg0_103, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("CommanderIcon/" .. var2_103, "", var5_103)
	setIconStars(arg0_103, arg2_103.initStar, 0)
	setIconName(arg0_103, arg1_103:getName(), arg2_103)
end

function updateStrategy(arg0_104, arg1_104, arg2_104)
	arg2_104 = arg2_104 or {}

	local var0_104 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_104, findTF(arg0_104, "icon_bg"))
	setFrame(findTF(arg0_104, "icon_bg/frame"), var0_104)

	local var1_104 = findTF(arg0_104, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg1_104.isWorldBuff and "world/buff/" or "strategyicon/") .. arg1_104:getIcon(), "", var1_104)
	setIconStars(arg0_104, false)
	setIconName(arg0_104, arg1_104:getName(), arg2_104)
	setIconColorful(arg0_104, ItemRarity.Gray, arg2_104)
end

function updateFurniture(arg0_105, arg1_105, arg2_105)
	arg2_105 = arg2_105 or {}

	local var0_105 = arg1_105:getDropRarity()
	local var1_105 = ItemRarity.Rarity2Print(var0_105)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_105, findTF(arg0_105, "icon_bg"))
	setFrame(findTF(arg0_105, "icon_bg/frame"), var1_105)

	local var2_105 = findTF(arg0_105, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1_105:getIcon(), "", var2_105)
	setIconStars(arg0_105, false)
	setIconName(arg0_105, arg1_105:getName(), arg2_105)
	setIconColorful(arg0_105, var0_105, arg2_105)
end

function updateSpWeapon(arg0_106, arg1_106, arg2_106)
	arg2_106 = arg2_106 or {}

	assert(arg1_106, "spWeaponVO can not be nil.")
	assert(isa(arg1_106, SpWeapon), "spWeaponVO is not Equipment.")

	local var0_106 = ItemRarity.Rarity2Print(arg1_106:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_106, findTF(arg0_106, "icon_bg"))
	setFrame(findTF(arg0_106, "icon_bg/frame"), var0_106)

	local var1_106 = findTF(arg0_106, "icon_bg/icon")

	var3_0(var1_106, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync(arg1_106:GetIconPath(), "", var1_106)
	setIconStars(arg0_106, true, arg1_106:GetRarity())
	var6_0(arg0_106, arg1_106:GetLevel() - 1)
	setIconName(arg0_106, arg1_106:GetName(), arg2_106)
	setIconCount(arg0_106, arg1_106.count)
	setIconColorful(arg0_106, arg1_106:GetRarity(), arg2_106)
end

function UpdateSpWeaponSlot(arg0_107, arg1_107, arg2_107)
	local var0_107 = ItemRarity.Rarity2Print(arg1_107:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_107, findTF(arg0_107, "Icon/Mask/icon_bg"))

	local var1_107 = findTF(arg0_107, "Icon/Mask/icon_bg/icon")

	arg2_107 = arg2_107 or {
		16,
		16,
		16,
		16
	}

	var3_0(var1_107, arg2_107)
	GetImageSpriteFromAtlasAsync(arg1_107:GetIconPath(), "", var1_107)

	local var2_107 = arg1_107:GetLevel() - 1
	local var3_107 = findTF(arg0_107, "Icon/LV")

	setActive(var3_107, var2_107 > 0)
	setText(findTF(var3_107, "Text"), var2_107)
end

function updateDorm3dFurniture(arg0_108, arg1_108, arg2_108)
	arg2_108 = arg2_108 or {}

	local var0_108 = arg1_108:getDropRarity()
	local var1_108 = ItemRarity.Rarity2Print(var0_108)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_108, findTF(arg0_108, "icon_bg"))
	setFrame(findTF(arg0_108, "icon_bg/frame"), var1_108)

	local var2_108 = findTF(arg0_108, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_108:getIcon(), "", var2_108)
	setIconStars(arg0_108, false)
	setIconName(arg0_108, arg1_108:getName(), arg2_108)
	setIconColorful(arg0_108, var0_108, arg2_108)
end

function updateDorm3dGift(arg0_109, arg1_109, arg2_109)
	arg2_109 = arg2_109 or {}

	local var0_109 = arg1_109:getDropRarity()
	local var1_109 = ItemRarity.Rarity2Print(var0_109) or ItemRarity.Gray

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_109, arg0_109:Find("icon_bg"))
	setFrame(arg0_109:Find("icon_bg/frame"), var1_109)

	local var2_109 = arg0_109:Find("icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_109:getIcon(), "", var2_109)
	setIconStars(arg0_109, false)
	setIconName(arg0_109, arg1_109:getName(), arg2_109)
	setIconColorful(arg0_109, var0_109, arg2_109)
end

function updateDorm3dSkin(arg0_110, arg1_110, arg2_110)
	arg2_110 = arg2_110 or {}

	local var0_110 = arg1_110:getDropRarity()
	local var1_110 = ItemRarity.Rarity2Print(var0_110) or ItemRarity.Gray

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_110, arg0_110:Find("icon_bg"))
	setFrame(arg0_110:Find("icon_bg/frame"), var1_110)

	local var2_110 = arg0_110:Find("icon_bg/icon")

	setIconStars(arg0_110, false)
	setIconName(arg0_110, arg1_110:getName(), arg2_110)
	setIconColorful(arg0_110, var0_110, arg2_110)
end

function updateDorm3dIcon(arg0_111, arg1_111)
	local var0_111 = arg1_111:getDropRarityDorm()

	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(var0_111), arg0_111)

	local var1_111 = arg0_111:Find("icon")

	GetImageSpriteFromAtlasAsync(arg1_111:getIcon(), "", var1_111)
	setText(arg0_111:Find("count/Text"), "x" .. arg1_111.count)
	setText(arg0_111:Find("name/Text"), arg1_111:getName())
end

local var7_0

function findCullAndClipWorldRect(arg0_112)
	if #arg0_112 == 0 then
		return false
	end

	local var0_112 = arg0_112[1].canvasRect

	for iter0_112 = 1, #arg0_112 do
		var0_112 = rectIntersect(var0_112, arg0_112[iter0_112].canvasRect)
	end

	if var0_112.width <= 0 or var0_112.height <= 0 then
		return false
	end

	var7_0 = var7_0 or GameObject.Find("UICamera/Canvas").transform

	local var1_112 = var7_0:TransformPoint(Vector3(var0_112.x, var0_112.y, 0))
	local var2_112 = var7_0:TransformPoint(Vector3(var0_112.x + var0_112.width, var0_112.y + var0_112.height, 0))

	return true, Vector4(var1_112.x, var1_112.y, var2_112.x, var2_112.y)
end

function rectIntersect(arg0_113, arg1_113)
	local var0_113 = math.max(arg0_113.x, arg1_113.x)
	local var1_113 = math.min(arg0_113.x + arg0_113.width, arg1_113.x + arg1_113.width)
	local var2_113 = math.max(arg0_113.y, arg1_113.y)
	local var3_113 = math.min(arg0_113.y + arg0_113.height, arg1_113.y + arg1_113.height)

	if var0_113 <= var1_113 and var2_113 <= var3_113 then
		return var0_0.Rect.New(var0_113, var2_113, var1_113 - var0_113, var3_113 - var2_113)
	end

	return var0_0.Rect.New(0, 0, 0, 0)
end

function getDropInfo(arg0_114)
	local var0_114 = {}

	for iter0_114, iter1_114 in ipairs(arg0_114) do
		local var1_114 = Drop.Create(iter1_114)

		var1_114.count = var1_114.count or 1

		if var1_114.type == DROP_TYPE_EMOJI then
			table.insert(var0_114, var1_114:getName())
		else
			table.insert(var0_114, var1_114:getName() .. "x" .. var1_114.count)
		end
	end

	return table.concat(var0_114, "、")
end

function updateDrop(arg0_115, arg1_115, arg2_115)
	Drop.Change(arg1_115)

	arg2_115 = arg2_115 or {}

	local var0_115 = {
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
	local var1_115

	for iter0_115, iter1_115 in ipairs(var0_115) do
		local var2_115 = arg0_115:Find(iter1_115[1])

		if arg1_115.type ~= iter1_115[2] and not IsNil(var2_115) then
			setActive(var2_115, false)
		end
	end

	arg0_115:Find("icon_bg/frame"):GetComponent(typeof(Image)).enabled = true

	setIconColorful(arg0_115, arg1_115:getDropRarity(), arg2_115, {
		[ItemRarity.Gold] = {
			name = "Item_duang5",
			active = function(arg0_116, arg1_116)
				return arg1_116.fromAwardLayer and arg0_116 >= ItemRarity.Gold
			end
		}
	})
	var3_0(findTF(arg0_115, "icon_bg/icon"), {
		2,
		2,
		2,
		2
	})
	arg1_115:UpdateDropTpl(arg0_115, arg2_115)
	setIconCount(arg0_115, arg2_115.count or arg1_115:getCount())
end

function updateBuff(arg0_117, arg1_117, arg2_117)
	arg2_117 = arg2_117 or {}

	local var0_117 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_117, findTF(arg0_117, "icon_bg"))

	local var1_117 = pg.benefit_buff_template[arg1_117]

	setFrame(findTF(arg0_117, "icon_bg/frame"), var0_117)
	setText(findTF(arg0_117, "icon_bg/count"), 1)

	local var2_117 = findTF(arg0_117, "icon_bg/icon")
	local var3_117 = var1_117.icon

	GetImageSpriteFromAtlasAsync(var3_117, "", var2_117)
	setIconStars(arg0_117, false)
	setIconName(arg0_117, var1_117.name, arg2_117)
	setIconColorful(arg0_117, ItemRarity.Gold, arg2_117)
end

function updateAttire(arg0_118, arg1_118, arg2_118, arg3_118)
	local var0_118 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_118, findTF(arg0_118, "icon_bg"))
	setFrame(findTF(arg0_118, "icon_bg/frame"), var0_118)

	local var1_118 = findTF(arg0_118, "icon_bg/icon")
	local var2_118

	if arg1_118 == AttireConst.TYPE_CHAT_FRAME then
		var2_118 = "chat_frame"
	elseif arg1_118 == AttireConst.TYPE_ICON_FRAME then
		var2_118 = "icon_frame"
	end

	GetImageSpriteFromAtlasAsync("Props/" .. var2_118, "", var1_118)
	setIconName(arg0_118, arg2_118.name, arg3_118)
end

function updateAttireCombatUI(arg0_119, arg1_119, arg2_119, arg3_119)
	local var0_119 = arg2_119.rare

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_119, findTF(arg0_119, "icon_bg"))
	setFrame(findTF(arg0_119, "icon_bg/frame"), var0_119, "frame_battle_ui")

	local var1_119 = findTF(arg0_119, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("Props/" .. arg2_119.display_icon, "", var1_119)
	setIconName(arg0_119, arg2_119.name, arg3_119)
end

function updateCover(arg0_120, arg1_120, arg2_120)
	local var0_120 = arg1_120:getDropRarity()

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_120, findTF(arg0_120, "icon_bg"))
	setFrame(findTF(arg0_120, "icon_bg/frame"), var0_120)

	local var1_120 = findTF(arg0_120, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_120:getIcon(), "", var1_120)
	setIconName(arg0_120, arg1_120:getName(), arg2_120)
	setIconStars(arg0_120, false)
end

function updateEmoji(arg0_121, arg1_121, arg2_121)
	local var0_121 = findTF(arg0_121, "icon_bg/icon")
	local var1_121 = "icon_emoji"

	GetImageSpriteFromAtlasAsync("Props/" .. var1_121, "", var0_121)

	local var2_121 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var2_121, findTF(arg0_121, "icon_bg"))
	setFrame(findTF(arg0_121, "icon_bg/frame"), var2_121)
	setIconName(arg0_121, arg1_121.name, arg2_121)
end

function updateEquipmentSkin(arg0_122, arg1_122, arg2_122)
	arg2_122 = arg2_122 or {}

	local var0_122 = EquipmentRarity.Rarity2Print(arg1_122.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_122, findTF(arg0_122, "icon_bg"))
	setFrame(findTF(arg0_122, "icon_bg/frame"), var0_122, "frame_skin")

	local var1_122 = findTF(arg0_122, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. arg1_122.icon, "", var1_122)
	setIconStars(arg0_122, false)
	setIconName(arg0_122, arg1_122.name, arg2_122)
	setIconCount(arg0_122, arg1_122.count)
	setIconColorful(arg0_122, arg1_122.rarity - 1, arg2_122)
end

function NoPosMsgBox(arg0_123, arg1_123, arg2_123, arg3_123)
	local var0_123
	local var1_123 = {}

	if arg1_123 then
		table.insert(var1_123, {
			text = "text_noPos_clear",
			atuoClose = true,
			onCallback = arg1_123
		})
	end

	if arg2_123 then
		table.insert(var1_123, {
			text = "text_noPos_buy",
			atuoClose = true,
			onCallback = arg2_123
		})
	end

	if arg3_123 then
		table.insert(var1_123, {
			text = "text_noPos_intensify",
			atuoClose = true,
			onCallback = arg3_123
		})
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		hideNo = true,
		content = arg0_123,
		custom = var1_123,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function openDestroyEquip()
	if pg.m02:hasMediator(EquipmentMediator.__cname) then
		local var0_124 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_124 and var0_124.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_124
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
		local var0_125 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_125 and var0_125.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_125
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
		onClick = function(arg0_128, arg1_128)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
				page = 3,
				shipId = arg0_128.id,
				shipVOs = arg1_128
			})
		end
	})
end

function GoShoppingMsgBox(arg0_129, arg1_129, arg2_129)
	if arg2_129 then
		local var0_129 = ""

		for iter0_129, iter1_129 in ipairs(arg2_129) do
			local var1_129 = Item.getConfigData(iter1_129[1])

			var0_129 = var0_129 .. i18n(iter1_129[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var1_129.name, iter1_129[2])

			if iter0_129 < #arg2_129 then
				var0_129 = var0_129 .. i18n("text_noRes_info_tip_link")
			end
		end

		if var0_129 ~= "" then
			arg0_129 = arg0_129 .. "\n" .. i18n("text_noRes_tip", var0_129)
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = arg0_129,
		weight = LayerWeightConst.SECOND_LAYER,
		onYes = function()
			gotoChargeScene(arg1_129, arg2_129)
		end
	})
end

function shoppingBatch(arg0_131, arg1_131, arg2_131, arg3_131, arg4_131)
	local var0_131 = pg.shop_template[arg0_131]

	assert(var0_131, "shop_template中找不到商品id：" .. arg0_131)

	local var1_131 = getProxy(PlayerProxy):getData()[id2res(var0_131.resource_type)]
	local var2_131 = arg1_131.price or var0_131.resource_num
	local var3_131 = math.floor(var1_131 / var2_131)

	var3_131 = var3_131 <= 0 and 1 or var3_131
	var3_131 = arg2_131 ~= nil and arg2_131 < var3_131 and arg2_131 or var3_131

	local var4_131 = true
	local var5_131 = 1

	if var0_131 ~= nil and arg1_131.id then
		print(var3_131 * var0_131.num, "--", var3_131)
		assert(Item.getConfigData(arg1_131.id), "item config should be existence")

		local var6_131 = Item.New({
			id = arg1_131.id
		}):getConfig("name")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			needCounter = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_ITEM,
				id = arg1_131.id
			},
			addNum = var0_131.num,
			maxNum = var3_131 * var0_131.num,
			defaultNum = var0_131.num,
			numUpdate = function(arg0_132, arg1_132)
				var5_131 = math.floor(arg1_132 / var0_131.num)

				local var0_132 = var5_131 * var2_131

				if var0_132 > var1_131 then
					setText(arg0_132, i18n(arg3_131, var0_132, arg1_132, COLOR_RED, var6_131))

					var4_131 = false
				else
					setText(arg0_132, i18n(arg3_131, var0_132, arg1_132, COLOR_GREEN, var6_131))

					var4_131 = true
				end
			end,
			onYes = function()
				if var4_131 then
					pg.m02:sendNotification(GAME.SHOPPING, {
						id = arg0_131,
						count = var5_131
					})
				elseif arg4_131 then
					pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_131))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("main_playerInfoLayer_error_changeNameNoGem"))
				end
			end
		})
	end
end

function shoppingBatchNewStyle(arg0_134, arg1_134, arg2_134, arg3_134, arg4_134)
	local var0_134 = pg.shop_template[arg0_134]

	assert(var0_134, "shop_template中找不到商品id：" .. arg0_134)

	local var1_134 = getProxy(PlayerProxy):getData()[id2res(var0_134.resource_type)]
	local var2_134 = arg1_134.price or var0_134.resource_num
	local var3_134 = math.floor(var1_134 / var2_134)

	var3_134 = var3_134 <= 0 and 1 or var3_134
	var3_134 = arg2_134 ~= nil and arg2_134 < var3_134 and arg2_134 or var3_134

	local var4_134 = true
	local var5_134 = 1

	if var0_134 ~= nil and arg1_134.id then
		print(var3_134 * var0_134.num, "--", var3_134)
		assert(Item.getConfigData(arg1_134.id), "item config should be existence")

		local var6_134 = Item.New({
			id = arg1_134.id
		}):getConfig("name")

		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_SHOPPING, {
			drop = Drop.New({
				count = 1,
				type = DROP_TYPE_ITEM,
				id = arg1_134.id
			}),
			price = var2_134,
			addNum = var0_134.num,
			maxNum = var3_134 * var0_134.num,
			defaultNum = var0_134.num,
			numUpdate = function(arg0_135, arg1_135)
				var5_134 = math.floor(arg1_135 / var0_134.num)

				local var0_135 = var5_134 * var2_134

				if var0_135 > var1_134 then
					setTextInNewStyleBox(arg0_135, i18n(arg3_134, var0_135, arg1_135, COLOR_RED, var6_134))

					var4_134 = false
				else
					setTextInNewStyleBox(arg0_135, i18n(arg3_134, var0_135, arg1_135, "#238C40FF", var6_134))

					var4_134 = true
				end
			end,
			btnList = {
				{
					type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.shopping,
					name = i18n("word_buy"),
					func = function()
						if var4_134 then
							pg.m02:sendNotification(GAME.SHOPPING, {
								id = arg0_134,
								count = var5_134
							})
						elseif arg4_134 then
							pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_134))
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

function gotoChargeScene(arg0_137, arg1_137)
	local var0_137 = getProxy(ContextProxy)
	local var1_137 = getProxy(ContextProxy):getCurrentContext()

	if instanceof(var1_137.mediator, ChargeMediator) then
		var1_137.mediator:getViewComponent():switchSubViewByTogger(arg0_137)
	else
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
			wrap = arg0_137 or ChargeScene.TYPE_ITEM,
			noRes = arg1_137
		})
	end
end

function clearDrop(arg0_138)
	local var0_138 = findTF(arg0_138, "icon_bg")
	local var1_138 = findTF(arg0_138, "icon_bg/frame")
	local var2_138 = findTF(arg0_138, "icon_bg/icon")
	local var3_138 = findTF(arg0_138, "icon_bg/icon/icon")

	clearImageSprite(var0_138)
	clearImageSprite(var1_138)
	clearImageSprite(var2_138)

	if var3_138 then
		clearImageSprite(var3_138)
	end
end

local var8_0 = {
	red = Color.New(1, 0.25, 0.25),
	blue = Color.New(0.11, 0.55, 0.64),
	yellow = Color.New(0.92, 0.52, 0)
}

function updateSkill(arg0_139, arg1_139, arg2_139, arg3_139)
	local var0_139 = findTF(arg0_139, "skill")
	local var1_139 = findTF(arg0_139, "lock")
	local var2_139 = findTF(arg0_139, "unknown")

	if arg1_139 then
		setActive(var0_139, true)
		setActive(var2_139, false)
		setActive(var1_139, not arg2_139)
		LoadImageSpriteAsync("skillicon/" .. arg1_139.icon, findTF(var0_139, "icon"))

		local var3_139 = arg1_139.color or "blue"

		setText(findTF(var0_139, "name"), shortenString(getSkillName(arg1_139.id), arg3_139 or 8))

		local var4_139 = findTF(var0_139, "level")

		setText(var4_139, "LEVEL: " .. (arg2_139 and arg2_139.level or "??"))
		setTextColor(var4_139, var8_0[var3_139])
	else
		setActive(var0_139, false)
		setActive(var2_139, true)
		setActive(var1_139, false)
	end
end

local var9_0 = true

function onBackButton(arg0_140, arg1_140, arg2_140, arg3_140)
	local var0_140 = GetOrAddComponent(arg1_140, "UILongPressTrigger")

	assert(arg2_140, "callback should exist")

	var0_140.longPressThreshold = defaultValue(arg3_140, 1)

	local function var1_140(arg0_141)
		return function()
			if var9_0 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SOUND_BACK)
			end

			local var0_142, var1_142 = arg2_140()

			if var0_142 then
				arg0_141(var1_142)
			end
		end
	end

	local var2_140 = var0_140.onReleased

	pg.DelegateInfo.Add(arg0_140, var2_140)
	var2_140:RemoveAllListeners()
	var2_140:AddListener(var1_140(function(arg0_143)
		arg0_143:emit(BaseUI.ON_BACK)
	end))

	local var3_140 = var0_140.onLongPressed

	pg.DelegateInfo.Add(arg0_140, var3_140)
	var3_140:RemoveAllListeners()
	var3_140:AddListener(var1_140(function(arg0_144)
		arg0_144:emit(BaseUI.ON_HOME)
	end))
end

function GetZeroTime()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)
end

function GetHalfHour()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0, 1800)
end

function GetNextHour(arg0_147)
	local var0_147 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_147, var2_147 = pg.TimeMgr.GetInstance():parseTimeFrom(var0_147)

	return var1_147 * 86400 + (var2_147 + arg0_147) * 3600
end

function GetPerceptualSize(arg0_148)
	local function var0_148(arg0_149)
		if not arg0_149 then
			return 0, 1
		elseif arg0_149 > 240 then
			return 4, 1
		elseif arg0_149 > 225 then
			return 3, 1
		elseif arg0_149 > 192 then
			return 2, 1
		elseif arg0_149 < 126 then
			return 1, 0.5
		else
			return 1, 1
		end
	end

	if type(arg0_148) == "number" then
		return var0_148(arg0_148)
	end

	local var1_148 = 1
	local var2_148 = 0
	local var3_148 = 0
	local var4_148 = #arg0_148

	while var1_148 <= var4_148 do
		local var5_148 = string.byte(arg0_148, var1_148)
		local var6_148, var7_148 = var0_148(var5_148)

		var1_148 = var1_148 + var6_148
		var2_148 = var2_148 + var7_148
	end

	return var2_148
end

function shortenString(arg0_150, arg1_150)
	local var0_150 = 1
	local var1_150 = 0
	local var2_150 = 0
	local var3_150 = #arg0_150

	while var0_150 <= var3_150 do
		local var4_150 = string.byte(arg0_150, var0_150)
		local var5_150, var6_150 = GetPerceptualSize(var4_150)

		var0_150 = var0_150 + var5_150
		var1_150 = var1_150 + var6_150

		if arg1_150 <= math.ceil(var1_150) then
			var2_150 = var0_150

			break
		end
	end

	if var2_150 == 0 or var3_150 < var2_150 then
		return arg0_150
	end

	return string.sub(arg0_150, 1, var2_150 - 1) .. ".."
end

function shouldShortenString(arg0_151, arg1_151)
	local var0_151 = 1
	local var1_151 = 0
	local var2_151 = 0
	local var3_151 = #arg0_151

	while var0_151 <= var3_151 do
		local var4_151 = string.byte(arg0_151, var0_151)
		local var5_151, var6_151 = GetPerceptualSize(var4_151)

		var0_151 = var0_151 + var5_151
		var1_151 = var1_151 + var6_151

		if arg1_151 <= math.ceil(var1_151) then
			var2_151 = var0_151

			break
		end
	end

	if var2_151 == 0 or var3_151 < var2_151 then
		return false
	end

	return true
end

function nameValidityCheck(arg0_152, arg1_152, arg2_152, arg3_152)
	local var0_152 = true
	local var1_152, var2_152 = utf8_to_unicode(arg0_152)
	local var3_152 = filterEgyUnicode(filterSpecChars(arg0_152))
	local var4_152 = wordVer(arg0_152)

	if not checkSpaceValid(arg0_152) then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_152[1]))

		var0_152 = false
	elseif var4_152 > 0 or var3_152 ~= arg0_152 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_152[4]))

		var0_152 = false
	elseif var2_152 < arg1_152 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_152[2]))

		var0_152 = false
	elseif arg2_152 < var2_152 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_152[3]))

		var0_152 = false
	end

	return var0_152
end

function checkSpaceValid(arg0_153)
	if PLATFORM_CODE == PLATFORM_US then
		return true
	end

	local var0_153 = string.gsub(arg0_153, " ", "")

	return arg0_153 == string.gsub(var0_153, "　", "")
end

function filterSpecChars(arg0_154)
	local var0_154 = {}
	local var1_154 = 0
	local var2_154 = 0
	local var3_154 = 0
	local var4_154 = 1

	while var4_154 <= #arg0_154 do
		local var5_154 = string.byte(arg0_154, var4_154)

		if not var5_154 then
			break
		end

		if var5_154 >= 48 and var5_154 <= 57 or var5_154 >= 65 and var5_154 <= 90 or var5_154 == 95 or var5_154 >= 97 and var5_154 <= 122 then
			table.insert(var0_154, string.char(var5_154))
		elseif var5_154 >= 228 and var5_154 <= 233 then
			local var6_154 = string.byte(arg0_154, var4_154 + 1)
			local var7_154 = string.byte(arg0_154, var4_154 + 2)

			if var6_154 and var7_154 and var6_154 >= 128 and var6_154 <= 191 and var7_154 >= 128 and var7_154 <= 191 then
				var4_154 = var4_154 + 2

				table.insert(var0_154, string.char(var5_154, var6_154, var7_154))

				var1_154 = var1_154 + 1
			end
		elseif var5_154 == 45 or var5_154 == 40 or var5_154 == 41 then
			table.insert(var0_154, string.char(var5_154))
		elseif var5_154 == 194 then
			local var8_154 = string.byte(arg0_154, var4_154 + 1)

			if var8_154 == 183 then
				var4_154 = var4_154 + 1

				table.insert(var0_154, string.char(var5_154, var8_154))

				var1_154 = var1_154 + 1
			end
		elseif var5_154 == 239 then
			local var9_154 = string.byte(arg0_154, var4_154 + 1)
			local var10_154 = string.byte(arg0_154, var4_154 + 2)

			if var9_154 == 188 and (var10_154 == 136 or var10_154 == 137) then
				var4_154 = var4_154 + 2

				table.insert(var0_154, string.char(var5_154, var9_154, var10_154))

				var1_154 = var1_154 + 1
			end
		elseif var5_154 == 206 or var5_154 == 207 then
			local var11_154 = string.byte(arg0_154, var4_154 + 1)

			if var5_154 == 206 and var11_154 >= 177 or var5_154 == 207 and var11_154 <= 134 then
				var4_154 = var4_154 + 1

				table.insert(var0_154, string.char(var5_154, var11_154))

				var1_154 = var1_154 + 1
			end
		elseif var5_154 == 227 and PLATFORM_CODE == PLATFORM_JP then
			local var12_154 = string.byte(arg0_154, var4_154 + 1)
			local var13_154 = string.byte(arg0_154, var4_154 + 2)

			if var12_154 and var13_154 and var12_154 > 128 and var12_154 <= 191 and var13_154 >= 128 and var13_154 <= 191 then
				var4_154 = var4_154 + 2

				table.insert(var0_154, string.char(var5_154, var12_154, var13_154))

				var2_154 = var2_154 + 1
			end
		elseif var5_154 >= 224 and PLATFORM_CODE == PLATFORM_KR then
			local var14_154 = string.byte(arg0_154, var4_154 + 1)
			local var15_154 = string.byte(arg0_154, var4_154 + 2)

			if var14_154 and var15_154 and var14_154 >= 128 and var14_154 <= 191 and var15_154 >= 128 and var15_154 <= 191 then
				var4_154 = var4_154 + 2

				table.insert(var0_154, string.char(var5_154, var14_154, var15_154))

				var3_154 = var3_154 + 1
			end
		elseif PLATFORM_CODE == PLATFORM_US then
			if var4_154 ~= 1 and var5_154 == 32 and string.byte(arg0_154, var4_154 + 1) ~= 32 then
				table.insert(var0_154, string.char(var5_154))
			end

			if var5_154 >= 192 and var5_154 <= 223 then
				local var16_154 = string.byte(arg0_154, var4_154 + 1)

				var4_154 = var4_154 + 1

				if var5_154 == 194 and var16_154 and var16_154 >= 128 then
					table.insert(var0_154, string.char(var5_154, var16_154))
				elseif var5_154 == 195 and var16_154 and var16_154 <= 191 then
					table.insert(var0_154, string.char(var5_154, var16_154))
				end
			end
		end

		var4_154 = var4_154 + 1
	end

	return table.concat(var0_154), var1_154 + var2_154 + var3_154
end

function filterEgyUnicode(arg0_155)
	arg0_155 = string.gsub(arg0_155, "�[�-�][�-�]", "")
	arg0_155 = string.gsub(arg0_155, "�[�-�]", "")

	return arg0_155
end

function shiftPanel(arg0_156, arg1_156, arg2_156, arg3_156, arg4_156, arg5_156, arg6_156, arg7_156, arg8_156)
	arg3_156 = arg3_156 or 0.2

	if arg5_156 then
		LeanTween.cancel(go(arg0_156))
	end

	local var0_156 = rtf(arg0_156)

	arg1_156 = arg1_156 or var0_156.anchoredPosition.x
	arg2_156 = arg2_156 or var0_156.anchoredPosition.y

	local var1_156 = LeanTween.move(var0_156, Vector3(arg1_156, arg2_156, 0), arg3_156)

	arg7_156 = arg7_156 or LeanTweenType.easeInOutSine

	var1_156:setEase(arg7_156)

	if arg4_156 then
		var1_156:setDelay(arg4_156)
	end

	if arg6_156 then
		GetOrAddComponent(arg0_156, "CanvasGroup").blocksRaycasts = false
	end

	var1_156:setOnComplete(System.Action(function()
		if arg8_156 then
			arg8_156()
		end

		if arg6_156 then
			GetOrAddComponent(arg0_156, "CanvasGroup").blocksRaycasts = true
		end
	end))

	return var1_156
end

function TweenValue(arg0_158, arg1_158, arg2_158, arg3_158, arg4_158, arg5_158, arg6_158, arg7_158)
	local var0_158 = LeanTween.value(go(arg0_158), arg1_158, arg2_158, arg3_158):setOnUpdate(System.Action_float(function(arg0_159)
		if arg5_158 then
			arg5_158(arg0_159)
		end
	end)):setOnComplete(System.Action(function()
		if arg6_158 then
			arg6_158()
		end
	end)):setDelay(arg4_158 or 0)

	if arg7_158 and arg7_158 > 0 then
		var0_158:setRepeat(arg7_158)
	end

	return var0_158
end

function rotateAni(arg0_161, arg1_161, arg2_161)
	return LeanTween.rotate(rtf(arg0_161), 360 * arg1_161, arg2_161):setLoopClamp()
end

function blinkAni(arg0_162, arg1_162, arg2_162, arg3_162)
	return LeanTween.alpha(rtf(arg0_162), arg3_162 or 0, arg1_162):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(arg2_162 or 0)
end

function scaleAni(arg0_163, arg1_163, arg2_163, arg3_163)
	return LeanTween.scale(rtf(arg0_163), arg3_163 or 0, arg1_163):setLoopPingPong(arg2_163 or 0)
end

function floatAni(arg0_164, arg1_164, arg2_164, arg3_164)
	local var0_164 = arg0_164.localPosition.y + arg1_164

	return LeanTween.moveY(rtf(arg0_164), var0_164, arg2_164):setLoopPingPong(arg3_164 or 0)
end

local var10_0 = tostring

function tostring(arg0_165)
	if arg0_165 == nil then
		return "nil"
	end

	local var0_165 = var10_0(arg0_165)

	if var0_165 == nil then
		if type(arg0_165) == "table" then
			return "{}"
		end

		return " ~nil"
	end

	return var0_165
end

function wordVer(arg0_166, arg1_166)
	if arg0_166.match(arg0_166, ChatConst.EmojiCodeMatch) then
		return 0, arg0_166
	end

	arg1_166 = arg1_166 or {}

	local var0_166 = filterEgyUnicode(arg0_166)

	if #var0_166 ~= #arg0_166 then
		if arg1_166.isReplace then
			arg0_166 = var0_166
		else
			return 1
		end
	end

	local var1_166 = wordSplit(arg0_166)
	local var2_166 = pg.word_template
	local var3_166 = pg.word_legal_template

	arg1_166.isReplace = arg1_166.isReplace or false
	arg1_166.replaceWord = arg1_166.replaceWord or "*"

	local var4_166 = #var1_166
	local var5_166 = 1
	local var6_166 = ""
	local var7_166 = 0

	while var5_166 <= var4_166 do
		local var8_166, var9_166, var10_166 = wordLegalMatch(var1_166, var3_166, var5_166)

		if var8_166 then
			var5_166 = var9_166
			var6_166 = var6_166 .. var10_166
		else
			local var11_166, var12_166, var13_166 = wordVerMatch(var1_166, var2_166, arg1_166, var5_166, "", false, var5_166, "")

			if var11_166 then
				var5_166 = var12_166
				var7_166 = var7_166 + 1

				if arg1_166.isReplace then
					var6_166 = var6_166 .. var13_166
				end
			else
				if arg1_166.isReplace then
					var6_166 = var6_166 .. var1_166[var5_166]
				end

				var5_166 = var5_166 + 1
			end
		end
	end

	if arg1_166.isReplace then
		return var7_166, var6_166
	else
		return var7_166
	end
end

function wordLegalMatch(arg0_167, arg1_167, arg2_167, arg3_167, arg4_167)
	if arg2_167 > #arg0_167 then
		return arg3_167, arg2_167, arg4_167
	end

	local var0_167 = arg0_167[arg2_167]
	local var1_167 = arg1_167[var0_167]

	arg4_167 = arg4_167 == nil and "" or arg4_167

	if var1_167 then
		if var1_167.this then
			return wordLegalMatch(arg0_167, var1_167, arg2_167 + 1, true, arg4_167 .. var0_167)
		else
			return wordLegalMatch(arg0_167, var1_167, arg2_167 + 1, false, arg4_167 .. var0_167)
		end
	else
		return arg3_167, arg2_167, arg4_167
	end
end

local var11_0 = string.byte("a")
local var12_0 = string.byte("z")
local var13_0 = string.byte("A")
local var14_0 = string.byte("Z")

local function var15_0(arg0_168)
	if not arg0_168 then
		return arg0_168
	end

	local var0_168 = string.byte(arg0_168)

	if var0_168 > 128 then
		return
	end

	if var0_168 >= var11_0 and var0_168 <= var12_0 then
		return string.char(var0_168 - 32)
	elseif var0_168 >= var13_0 and var0_168 <= var14_0 then
		return string.char(var0_168 + 32)
	else
		return arg0_168
	end
end

function wordVerMatch(arg0_169, arg1_169, arg2_169, arg3_169, arg4_169, arg5_169, arg6_169, arg7_169)
	if arg3_169 > #arg0_169 then
		return arg5_169, arg6_169, arg7_169
	end

	local var0_169 = arg0_169[arg3_169]
	local var1_169 = arg1_169[var0_169]

	if var1_169 then
		local var2_169, var3_169, var4_169 = wordVerMatch(arg0_169, var1_169, arg2_169, arg3_169 + 1, arg2_169.isReplace and arg4_169 .. arg2_169.replaceWord or arg4_169, var1_169.this or arg5_169, var1_169.this and arg3_169 + 1 or arg6_169, var1_169.this and (arg2_169.isReplace and arg4_169 .. arg2_169.replaceWord or arg4_169) or arg7_169)

		if var2_169 then
			return var2_169, var3_169, var4_169
		end
	end

	local var5_169 = var15_0(var0_169)
	local var6_169 = arg1_169[var5_169]

	if var5_169 ~= var0_169 and var6_169 then
		local var7_169, var8_169, var9_169 = wordVerMatch(arg0_169, var6_169, arg2_169, arg3_169 + 1, arg2_169.isReplace and arg4_169 .. arg2_169.replaceWord or arg4_169, var6_169.this or arg5_169, var6_169.this and arg3_169 + 1 or arg6_169, var6_169.this and (arg2_169.isReplace and arg4_169 .. arg2_169.replaceWord or arg4_169) or arg7_169)

		if var7_169 then
			return var7_169, var8_169, var9_169
		end
	end

	return arg5_169, arg6_169, arg7_169
end

function wordSplit(arg0_170)
	local var0_170 = {}

	for iter0_170 in arg0_170.gmatch(arg0_170, "[\x01-\x7F�-�][�-�]*") do
		var0_170[#var0_170 + 1] = iter0_170
	end

	return var0_170
end

function contentWrap(arg0_171, arg1_171, arg2_171)
	local var0_171 = LuaHelper.WrapContent(arg0_171, arg1_171, arg2_171)

	return #var0_171 ~= #arg0_171, var0_171
end

function cancelRich(arg0_172)
	local var0_172

	for iter0_172 = 1, 20 do
		local var1_172

		arg0_172, var1_172 = string.gsub(arg0_172, "<([^>]*)>", "%1")

		if var1_172 <= 0 then
			break
		end
	end

	return arg0_172
end

function cancelColorRich(arg0_173)
	local var0_173

	for iter0_173 = 1, 20 do
		local var1_173

		arg0_173, var1_173 = string.gsub(arg0_173, "<color=#[a-zA-Z0-9]+>(.-)</color>", "%1")

		if var1_173 <= 0 then
			break
		end
	end

	return arg0_173
end

function getSkillConfig(arg0_174)
	local var0_174 = require("GameCfg.buff.buff_" .. arg0_174)

	if not var0_174 then
		warning("找不到技能配置: " .. arg0_174)

		return
	end

	local var1_174 = Clone(var0_174)

	var1_174.name = getSkillName(arg0_174)
	var1_174.desc = HXSet.hxLan(var1_174.desc)
	var1_174.desc_get = HXSet.hxLan(var1_174.desc_get)

	_.each(var1_174, function(arg0_175)
		arg0_175.desc = HXSet.hxLan(arg0_175.desc)
	end)

	return var1_174
end

function getSkillName(arg0_176)
	local var0_176 = pg.skill_data_template[arg0_176] or pg.skill_data_display[arg0_176]

	if var0_176 then
		return HXSet.hxLan(var0_176.name)
	else
		return ""
	end
end

function getSkillDescGet(arg0_177, arg1_177)
	local var0_177 = arg1_177 and pg.skill_world_display[arg0_177] and setmetatable({}, {
		__index = function(arg0_178, arg1_178)
			return pg.skill_world_display[arg0_177][arg1_178] or pg.skill_data_template[arg0_177][arg1_178]
		end
	}) or pg.skill_data_template[arg0_177]

	if not var0_177 then
		return ""
	end

	local var1_177 = var0_177.desc_get ~= "" and var0_177.desc_get or var0_177.desc

	for iter0_177, iter1_177 in pairs(var0_177.desc_get_add) do
		local var2_177 = setColorStr(iter1_177[1], COLOR_GREEN)

		if iter1_177[2] then
			var2_177 = var2_177 .. specialGSub(i18n("word_skill_desc_get"), "$1", setColorStr(iter1_177[2], COLOR_GREEN))
		end

		var1_177 = specialGSub(var1_177, "$" .. iter0_177, var2_177)
	end

	return HXSet.hxLan(var1_177)
end

function getSkillDescLearn(arg0_179, arg1_179, arg2_179)
	local var0_179 = arg2_179 and pg.skill_world_display[arg0_179] and setmetatable({}, {
		__index = function(arg0_180, arg1_180)
			return pg.skill_world_display[arg0_179][arg1_180] or pg.skill_data_template[arg0_179][arg1_180]
		end
	}) or pg.skill_data_template[arg0_179]

	if not var0_179 then
		return ""
	end

	local var1_179 = var0_179.desc

	if not var0_179.desc_add then
		return HXSet.hxLan(var1_179)
	end

	for iter0_179, iter1_179 in pairs(var0_179.desc_add) do
		local var2_179 = iter1_179[arg1_179][1]

		if iter1_179[arg1_179][2] then
			var2_179 = var2_179 .. specialGSub(i18n("word_skill_desc_learn"), "$1", iter1_179[arg1_179][2])
		end

		var1_179 = specialGSub(var1_179, "$" .. iter0_179, setColorStr(var2_179, COLOR_YELLOW))
	end

	return HXSet.hxLan(var1_179)
end

function getSkillDesc(arg0_181, arg1_181, arg2_181)
	local var0_181 = arg2_181 and pg.skill_world_display[arg0_181] and setmetatable({}, {
		__index = function(arg0_182, arg1_182)
			return pg.skill_world_display[arg0_181][arg1_182] or pg.skill_data_template[arg0_181][arg1_182]
		end
	}) or pg.skill_data_template[arg0_181]

	if not var0_181 then
		return ""
	end

	local var1_181 = var0_181.desc

	if not var0_181.desc_add then
		return HXSet.hxLan(var1_181)
	end

	for iter0_181, iter1_181 in pairs(var0_181.desc_add) do
		local var2_181 = setColorStr(iter1_181[arg1_181][1], COLOR_GREEN)

		var1_181 = specialGSub(var1_181, "$" .. iter0_181, var2_181)
	end

	return HXSet.hxLan(var1_181)
end

function specialGSub(arg0_183, arg1_183, arg2_183)
	arg0_183 = string.gsub(arg0_183, "<color=#", "<color=NNN")
	arg0_183 = string.gsub(arg0_183, "#", "")
	arg2_183 = string.gsub(arg2_183, "%%", "%%%%")
	arg0_183 = string.gsub(arg0_183, arg1_183, arg2_183)
	arg0_183 = string.gsub(arg0_183, "<color=NNN", "<color=#")

	return arg0_183
end

function topAnimation(arg0_184, arg1_184, arg2_184, arg3_184, arg4_184, arg5_184)
	local var0_184 = {}

	arg4_184 = arg4_184 or 0.27

	local var1_184 = 0.05

	if arg0_184 then
		local var2_184 = arg0_184.transform.localPosition.x

		setAnchoredPosition(arg0_184, {
			x = var2_184 - 500
		})
		shiftPanel(arg0_184, var2_184, nil, 0.05, arg4_184, true, true)
		setActive(arg0_184, true)
	end

	setActive(arg1_184, false)
	setActive(arg2_184, false)
	setActive(arg3_184, false)

	for iter0_184 = 1, 3 do
		table.insert(var0_184, LeanTween.delayedCall(arg4_184 + 0.13 + var1_184 * iter0_184, System.Action(function()
			if arg1_184 then
				setActive(arg1_184, not arg1_184.gameObject.activeSelf)
			end
		end)).uniqueId)
		table.insert(var0_184, LeanTween.delayedCall(arg4_184 + 0.02 + var1_184 * iter0_184, System.Action(function()
			if arg2_184 then
				setActive(arg2_184, not go(arg2_184).activeSelf)
			end

			if arg2_184 then
				setActive(arg3_184, not go(arg3_184).activeSelf)
			end
		end)).uniqueId)
	end

	if arg5_184 then
		table.insert(var0_184, LeanTween.delayedCall(arg4_184 + 0.13 + var1_184 * 3 + 0.1, System.Action(function()
			arg5_184()
		end)).uniqueId)
	end

	return var0_184
end

function cancelTweens(arg0_188)
	assert(arg0_188, "must provide cancel targets, LeanTween.cancelAll is not allow")

	for iter0_188, iter1_188 in ipairs(arg0_188) do
		if iter1_188 then
			LeanTween.cancel(iter1_188)
		end
	end
end

function getOfflineTimeStamp(arg0_189)
	local var0_189 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_189
	local var1_189 = ""

	if var0_189 <= 59 then
		var1_189 = i18n("just_now")
	elseif var0_189 <= 3599 then
		var1_189 = i18n("several_minutes_before", math.floor(var0_189 / 60))
	elseif var0_189 <= 86399 then
		var1_189 = i18n("several_hours_before", math.floor(var0_189 / 3600))
	else
		var1_189 = i18n("several_days_before", math.floor(var0_189 / 86400))
	end

	return var1_189
end

function playMovie(arg0_190, arg1_190, arg2_190)
	local var0_190 = GameObject.Find("OverlayCamera/Overlay/UITop/MoviePanel")

	if not IsNil(var0_190) then
		pg.UIMgr.GetInstance():LoadingOn()
		WWWLoader.Inst:LoadStreamingAsset(arg0_190, function(arg0_191)
			pg.UIMgr.GetInstance():LoadingOff()

			local var0_191 = GCHandle.Alloc(arg0_191, GCHandleType.Pinned)

			setActive(var0_190, true)

			local var1_191 = var0_190:AddComponent(typeof(CriManaMovieControllerForUI))

			var1_191.player:SetData(arg0_191, arg0_191.Length)

			var1_191.target = var0_190:GetComponent(typeof(Image))
			var1_191.loop = false
			var1_191.additiveMode = false
			var1_191.playOnStart = true

			local var2_191

			var2_191 = Timer.New(function()
				if var1_191.player.status == CriMana.Player.Status.PlayEnd or var1_191.player.status == CriMana.Player.Status.Stop or var1_191.player.status == CriMana.Player.Status.Error then
					var2_191:Stop()
					Object.Destroy(var1_191)
					GCHandle.Free(var0_191)
					setActive(var0_190, false)

					if arg1_190 then
						arg1_190()
					end
				end
			end, 0.2, -1)

			var2_191:Start()
			removeOnButton(var0_190)

			if arg2_190 then
				onButton(nil, var0_190, function()
					var1_191:Stop()
					GetOrAddComponent(var0_190, typeof(Button)).onClick:RemoveAllListeners()
				end, SFX_CANCEL)
			end
		end)
	elseif arg1_190 then
		arg1_190()
	end
end

PaintCameraAdjustOn = false

function cameraPaintViewAdjust(arg0_194)
	if PaintCameraAdjustOn ~= arg0_194 then
		local var0_194 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(CanvasScaler))

		if arg0_194 then
			CameraMgr.instance.AutoAdapt = false

			CameraMgr.instance:Revert()

			var0_194.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight
			var0_194.matchWidthOrHeight = 1
		else
			CameraMgr.instance.AutoAdapt = true
			CameraMgr.instance.CurrentWidth = 1
			CameraMgr.instance.CurrentHeight = 1
			CameraMgr.instance.AspectRatio = 1.77777777777778
			var0_194.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand
		end

		PaintCameraAdjustOn = arg0_194
	end
end

function ManhattonDist(arg0_195, arg1_195)
	return math.abs(arg0_195.row - arg1_195.row) + math.abs(arg0_195.column - arg1_195.column)
end

function checkFirstHelpShow(arg0_196)
	local var0_196 = getProxy(SettingsProxy)

	if not var0_196:checkReadHelp(arg0_196) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[arg0_196].tip
		})
		var0_196:recordReadHelp(arg0_196)
	end
end

preOrientation = nil
preNotchFitterEnabled = false

function openPortrait(arg0_197)
	enableNotch(arg0_197, true)

	preOrientation = Input.deviceOrientation:ToString()

	originalPrint("Begining Orientation:" .. preOrientation)

	Screen.autorotateToPortrait = true
	Screen.autorotateToPortraitUpsideDown = true

	cameraPaintViewAdjust(true)
end

function closePortrait(arg0_198)
	enableNotch(arg0_198, false)

	Screen.autorotateToPortrait = false
	Screen.autorotateToPortraitUpsideDown = false

	originalPrint("Closing Orientation:" .. preOrientation)

	Screen.orientation = ScreenOrientation.LandscapeLeft

	local var0_198 = Timer.New(function()
		Screen.orientation = ScreenOrientation.AutoRotation
	end, 0.2, 1):Start()

	cameraPaintViewAdjust(false)
end

function enableNotch(arg0_200, arg1_200)
	if arg0_200 == nil then
		return
	end

	local var0_200 = arg0_200:GetComponent("NotchAdapt")
	local var1_200 = arg0_200:GetComponent("AspectRatioFitter")

	var0_200.enabled = arg1_200

	if var1_200 then
		if arg1_200 then
			var1_200.enabled = preNotchFitterEnabled
		else
			preNotchFitterEnabled = var1_200.enabled
			var1_200.enabled = false
		end
	end
end

function comma_value(arg0_201)
	local var0_201 = arg0_201
	local var1_201 = 0

	repeat
		local var2_201

		var0_201, var2_201 = string.gsub(var0_201, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var2_201 == 0

	return var0_201
end

local var16_0 = 0.2

function SwitchPanel(arg0_202, arg1_202, arg2_202, arg3_202, arg4_202, arg5_202)
	arg3_202 = defaultValue(arg3_202, var16_0)

	if arg5_202 then
		LeanTween.cancel(go(arg0_202))
	end

	local var0_202 = Vector3.New(tf(arg0_202).localPosition.x, tf(arg0_202).localPosition.y, tf(arg0_202).localPosition.z)

	if arg1_202 then
		var0_202.x = arg1_202
	end

	if arg2_202 then
		var0_202.y = arg2_202
	end

	local var1_202 = LeanTween.move(rtf(arg0_202), var0_202, arg3_202):setEase(LeanTweenType.easeInOutSine)

	if arg4_202 then
		var1_202:setDelay(arg4_202)
	end

	return var1_202
end

function updateActivityTaskStatus(arg0_203)
	local var0_203 = arg0_203:getConfig("config_id")
	local var1_203, var2_203 = getActivityTask(arg0_203, true)

	if not var2_203 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_203.id
		})

		return true
	end

	return false
end

function updateCrusingActivityTask(arg0_204)
	local var0_204 = getProxy(TaskProxy)
	local var1_204 = arg0_204:getNDay()

	for iter0_204, iter1_204 in ipairs(arg0_204:getConfig("config_data")) do
		local var2_204 = pg.battlepass_task_group[iter1_204]

		if var1_204 >= var2_204.time and underscore.any(underscore.flatten(var2_204.task_group), function(arg0_205)
			return var0_204:getTaskVO(arg0_205) == nil
		end) then
			pg.m02:sendNotification(GAME.CRUSING_CMD, {
				cmd = 1,
				activity_id = arg0_204.id
			})

			return true
		end
	end

	return false
end

function setShipCardFrame(arg0_206, arg1_206, arg2_206)
	arg0_206.localScale = Vector3.one
	arg0_206.anchorMin = Vector2.zero
	arg0_206.anchorMax = Vector2.one

	local var0_206 = arg2_206 or arg1_206

	GetImageSpriteFromAtlasAsync("shipframe", var0_206, arg0_206)

	local var1_206 = pg.frame_resource[var0_206]

	if var1_206 then
		local var2_206 = var1_206.param

		arg0_206.offsetMin = Vector2(var2_206[1], var2_206[2])
		arg0_206.offsetMax = Vector2(var2_206[3], var2_206[4])
	else
		arg0_206.offsetMin = Vector2.zero
		arg0_206.offsetMax = Vector2.zero
	end
end

function setRectShipCardFrame(arg0_207, arg1_207, arg2_207)
	arg0_207.localScale = Vector3.one
	arg0_207.anchorMin = Vector2.zero
	arg0_207.anchorMax = Vector2.one

	setImageSprite(arg0_207, GetSpriteFromAtlas("shipframeb", "b" .. (arg2_207 or arg1_207)))

	local var0_207 = "b" .. (arg2_207 or arg1_207)
	local var1_207 = pg.frame_resource[var0_207]

	if var1_207 then
		local var2_207 = var1_207.param

		arg0_207.offsetMin = Vector2(var2_207[1], var2_207[2])
		arg0_207.offsetMax = Vector2(var2_207[3], var2_207[4])
	else
		arg0_207.offsetMin = Vector2.zero
		arg0_207.offsetMax = Vector2.zero
	end
end

function setFrameEffect(arg0_208, arg1_208)
	if arg1_208 then
		local var0_208 = arg1_208 .. "(Clone)"
		local var1_208 = false

		eachChild(arg0_208, function(arg0_209)
			setActive(arg0_209, arg0_209.name == var0_208)

			var1_208 = var1_208 or arg0_209.name == var0_208
		end)

		if not var1_208 then
			LoadAndInstantiateAsync("effect", arg1_208, function(arg0_210)
				if IsNil(arg0_208) or findTF(arg0_208, var0_208) then
					Object.Destroy(arg0_210)
				else
					setParent(arg0_210, arg0_208)
					setActive(arg0_210, true)
				end
			end)
		end
	end

	setActive(arg0_208, arg1_208)
end

function setProposeMarkIcon(arg0_211, arg1_211)
	local var0_211 = arg0_211:Find("proposeShipCard(Clone)")
	local var1_211 = arg1_211.propose and not arg1_211:ShowPropose()

	if var0_211 then
		setActive(var0_211, var1_211)
	elseif var1_211 then
		pg.PoolMgr.GetInstance():GetUI("proposeShipCard", true, function(arg0_212)
			if IsNil(arg0_211) or arg0_211:Find("proposeShipCard(Clone)") then
				pg.PoolMgr.GetInstance():ReturnUI("proposeShipCard", arg0_212)
			else
				setParent(arg0_212, arg0_211, false)
			end
		end)
	end
end

function flushShipCard(arg0_213, arg1_213)
	local var0_213 = arg1_213:rarity2bgPrint()
	local var1_213 = findTF(arg0_213, "content/bg")

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var0_213, "", var1_213)

	local var2_213 = findTF(arg0_213, "content/ship_icon")
	local var3_213 = arg1_213 and {
		"shipYardIcon/" .. arg1_213:getPainting(),
		arg1_213:getPainting()
	} or {
		"shipYardIcon/unknown",
		""
	}

	GetImageSpriteFromAtlasAsync(var3_213[1], var3_213[2], var2_213)

	local var4_213 = arg1_213:getShipType()
	local var5_213 = findTF(arg0_213, "content/info/top/type")

	GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var4_213), var5_213)
	setText(findTF(arg0_213, "content/dockyard/lv/Text"), defaultValue(arg1_213.level, 1))

	local var6_213 = arg1_213:getStar()
	local var7_213 = arg1_213:getMaxStar()
	local var8_213 = findTF(arg0_213, "content/front/stars")

	setActive(var8_213, true)

	local var9_213 = findTF(var8_213, "star_tpl")
	local var10_213 = var8_213.childCount

	for iter0_213 = 1, Ship.CONFIG_MAX_STAR do
		local var11_213 = var10_213 < iter0_213 and cloneTplTo(var9_213, var8_213) or var8_213:GetChild(iter0_213 - 1)

		setActive(var11_213, iter0_213 <= var7_213)
		triggerToggle(var11_213, iter0_213 <= var6_213)
	end

	local var12_213 = findTF(arg0_213, "content/front/frame")
	local var13_213, var14_213 = arg1_213:GetFrameAndEffect()

	setShipCardFrame(var12_213, var0_213, var13_213)
	setFrameEffect(findTF(arg0_213, "content/front/bg_other"), var14_213)
	setProposeMarkIcon(arg0_213:Find("content/dockyard/propose"), arg1_213)
end

function TweenItemAlphaAndWhite(arg0_214)
	LeanTween.cancel(arg0_214)

	local var0_214 = GetOrAddComponent(arg0_214, "CanvasGroup")

	var0_214.alpha = 0

	LeanTween.alphaCanvas(var0_214, 1, 0.2):setUseEstimatedTime(true)

	local var1_214 = findTF(arg0_214.transform, "white_mask")

	if var1_214 then
		setActive(var1_214, false)
	end
end

function ClearTweenItemAlphaAndWhite(arg0_215)
	LeanTween.cancel(arg0_215)

	GetOrAddComponent(arg0_215, "CanvasGroup").alpha = 0
end

function getGroupOwnSkins(arg0_216)
	local var0_216 = {}
	local var1_216 = getProxy(ShipSkinProxy):getSkinList()
	local var2_216 = getProxy(CollectionProxy):getShipGroup(arg0_216)

	if var2_216 then
		local var3_216 = ShipGroup.getSkinList(arg0_216)

		for iter0_216, iter1_216 in ipairs(var3_216) do
			if iter1_216.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var1_216, iter1_216.id) or iter1_216.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var2_216.trans or iter1_216.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var2_216.married == 1 then
				var0_216[iter1_216.id] = true
			end
		end
	end

	return var0_216
end

function split(arg0_217, arg1_217)
	local var0_217 = {}

	if not arg0_217 then
		return nil
	end

	local var1_217 = #arg0_217
	local var2_217 = 1

	while var2_217 <= var1_217 do
		local var3_217 = string.find(arg0_217, arg1_217, var2_217)

		if var3_217 == nil then
			table.insert(var0_217, string.sub(arg0_217, var2_217, var1_217))

			break
		end

		table.insert(var0_217, string.sub(arg0_217, var2_217, var3_217 - 1))

		if var3_217 == var1_217 then
			table.insert(var0_217, "")

			break
		end

		var2_217 = var3_217 + 1
	end

	return var0_217
end

function NumberToChinese(arg0_218, arg1_218)
	local var0_218 = ""
	local var1_218 = #arg0_218

	for iter0_218 = 1, var1_218 do
		local var2_218 = string.sub(arg0_218, iter0_218, iter0_218)

		if var2_218 ~= "0" or var2_218 == "0" and not arg1_218 then
			if arg1_218 then
				if var1_218 >= 2 then
					if iter0_218 == 1 then
						if var2_218 == "1" then
							var0_218 = i18n("number_" .. 10)
						else
							var0_218 = i18n("number_" .. var2_218) .. i18n("number_" .. 10)
						end
					else
						var0_218 = var0_218 .. i18n("number_" .. var2_218)
					end
				else
					var0_218 = var0_218 .. i18n("number_" .. var2_218)
				end
			else
				var0_218 = var0_218 .. i18n("number_" .. var2_218)
			end
		end
	end

	return var0_218
end

function getActivityTask(arg0_219, arg1_219)
	local var0_219 = getProxy(TaskProxy)
	local var1_219 = arg0_219:getConfig("config_data")
	local var2_219 = arg0_219:getNDay(arg0_219.data1)
	local var3_219
	local var4_219
	local var5_219

	for iter0_219 = math.max(arg0_219.data3, 1), math.min(var2_219, #var1_219) do
		local var6_219 = _.flatten({
			var1_219[iter0_219]
		})

		for iter1_219, iter2_219 in ipairs(var6_219) do
			local var7_219 = var0_219:getTaskById(iter2_219)

			if var7_219 then
				return var7_219.id, var7_219
			end

			if var4_219 then
				var5_219 = var0_219:getFinishTaskById(iter2_219)

				if var5_219 then
					var4_219 = var5_219
				elseif arg1_219 then
					return iter2_219
				else
					return var4_219.id, var4_219
				end
			else
				var4_219 = var0_219:getFinishTaskById(iter2_219)
				var5_219 = var5_219 or iter2_219
			end
		end
	end

	if var4_219 then
		return var4_219.id, var4_219
	else
		return var5_219
	end
end

function setImageFromImage(arg0_220, arg1_220, arg2_220)
	local var0_220 = GetComponent(arg0_220, "Image")

	var0_220.sprite = GetComponent(arg1_220, "Image").sprite

	if arg2_220 then
		var0_220:SetNativeSize()
	end
end

function skinTimeStamp(arg0_221)
	local var0_221, var1_221, var2_221, var3_221 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_221)

	if var0_221 >= 1 then
		return i18n("limit_skin_time_day", var0_221)
	elseif var0_221 <= 0 and var1_221 > 0 then
		return i18n("limit_skin_time_day_min", var1_221, var2_221)
	elseif var0_221 <= 0 and var1_221 <= 0 and (var2_221 > 0 or var3_221 > 0) then
		return i18n("limit_skin_time_min", math.max(var2_221, 1))
	elseif var0_221 <= 0 and var1_221 <= 0 and var2_221 <= 0 and var3_221 <= 0 then
		return i18n("limit_skin_time_overtime")
	end
end

function skinCommdityTimeStamp(arg0_222)
	local var0_222 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_222 = math.max(arg0_222 - var0_222, 0)
	local var2_222 = math.floor(var1_222 / 86400)

	if var2_222 > 0 then
		return i18n("time_remaining_tip") .. var2_222 .. i18n("word_date")
	else
		local var3_222 = math.floor(var1_222 / 3600)

		if var3_222 > 0 then
			return i18n("time_remaining_tip") .. var3_222 .. i18n("word_hour")
		else
			local var4_222 = math.floor(var1_222 / 60)

			if var4_222 > 0 then
				return i18n("time_remaining_tip") .. var4_222 .. i18n("word_minute")
			else
				return i18n("time_remaining_tip") .. var1_222 .. i18n("word_second")
			end
		end
	end
end

function InstagramTimeStamp(arg0_223)
	local var0_223 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_223
	local var1_223 = var0_223 / 86400

	if var1_223 > 1 then
		return i18n("ins_word_day", math.floor(var1_223))
	else
		local var2_223 = var0_223 / 3600

		if var2_223 > 1 then
			return i18n("ins_word_hour", math.floor(var2_223))
		else
			local var3_223 = var0_223 / 60

			if var3_223 > 1 then
				return i18n("ins_word_minu", math.floor(var3_223))
			else
				return i18n("ins_word_minu", 1)
			end
		end
	end
end

function InstagramReplyTimeStamp(arg0_224)
	local var0_224 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_224
	local var1_224 = var0_224 / 86400

	if var1_224 > 1 then
		return i18n1(math.floor(var1_224) .. "d")
	else
		local var2_224 = var0_224 / 3600

		if var2_224 > 1 then
			return i18n1(math.floor(var2_224) .. "h")
		else
			local var3_224 = var0_224 / 60

			if var3_224 > 1 then
				return i18n1(math.floor(var3_224) .. "min")
			else
				return i18n1("1min")
			end
		end
	end
end

function attireTimeStamp(arg0_225)
	local var0_225, var1_225, var2_225, var3_225 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_225)

	if var0_225 <= 0 and var1_225 <= 0 and var2_225 <= 0 and var3_225 <= 0 then
		return i18n("limit_skin_time_overtime")
	else
		return i18n("attire_time_stamp", var0_225, var1_225, var2_225)
	end
end

function checkExist(arg0_226, ...)
	local var0_226 = {
		...
	}

	for iter0_226, iter1_226 in ipairs(var0_226) do
		if arg0_226 == nil then
			break
		end

		assert(type(arg0_226) == "table", "type error : intermediate target should be table")
		assert(type(iter1_226) == "table", "type error : param should be table")

		if type(arg0_226[iter1_226[1]]) == "function" then
			arg0_226 = arg0_226[iter1_226[1]](arg0_226, unpack(iter1_226[2] or {}))
		else
			arg0_226 = arg0_226[iter1_226[1]]
		end
	end

	return arg0_226
end

function AcessWithinNull(arg0_227, arg1_227)
	if arg0_227 == nil then
		return
	end

	assert(type(arg0_227) == "table")

	return arg0_227[arg1_227]
end

function showRepairMsgbox()
	local var0_228 = {
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var1_228 = {
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var2_228 = {
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
			var2_228,
			var1_228,
			var0_228
		}
	})
end

function resourceVerify(arg0_232, arg1_232)
	if CSharpVersion > 35 then
		BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()

		return
	end

	local var0_232 = Application.persistentDataPath .. "/hashes.csv"
	local var1_232
	local var2_232 = PathMgr.ReadAllLines(var0_232)
	local var3_232 = {}

	if arg0_232 then
		setActive(arg0_232, true)
	else
		pg.UIMgr.GetInstance():LoadingOn()
	end

	local function var4_232()
		if arg0_232 then
			setActive(arg0_232, false)
		else
			pg.UIMgr.GetInstance():LoadingOff()
		end

		print(var1_232)

		if var1_232 then
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

	local var5_232 = var2_232.Length
	local var6_232

	local function var7_232(arg0_235)
		if arg0_235 < 0 then
			var4_232()

			return
		end

		if arg1_232 then
			setSlider(arg1_232, 0, var5_232, var5_232 - arg0_235)
		end

		local var0_235 = string.split(var2_232[arg0_235], ",")
		local var1_235 = var0_235[1]
		local var2_235 = var0_235[3]
		local var3_235 = PathMgr.getAssetBundle(var1_235)

		if PathMgr.FileExists(var3_235) then
			local var4_235 = PathMgr.ReadAllBytes(PathMgr.getAssetBundle(var1_235))

			if var2_235 == HashUtil.CalcMD5(var4_235) then
				onNextTick(function()
					var7_232(arg0_235 - 1)
				end)

				return
			end
		end

		var1_232 = var1_235

		var4_232()
	end

	var7_232(var5_232 - 1)
end

function splitByWordEN(arg0_237, arg1_237)
	local var0_237 = string.split(arg0_237, " ")
	local var1_237 = ""
	local var2_237 = ""
	local var3_237 = arg1_237:GetComponent(typeof(RectTransform))
	local var4_237 = arg1_237:GetComponent(typeof(Text))
	local var5_237 = var3_237.rect.width

	for iter0_237, iter1_237 in ipairs(var0_237) do
		local var6_237 = var2_237

		var2_237 = var2_237 == "" and iter1_237 or var2_237 .. " " .. iter1_237

		setText(arg1_237, var2_237)

		if var5_237 < var4_237.preferredWidth then
			var1_237 = var1_237 == "" and var6_237 or var1_237 .. "\n" .. var6_237
			var2_237 = iter1_237
		end

		if iter0_237 >= #var0_237 then
			var1_237 = var1_237 == "" and var2_237 or var1_237 .. "\n" .. var2_237
		end
	end

	return var1_237
end

function checkBirthFormat(arg0_238)
	if #arg0_238 ~= 8 then
		return false
	end

	local var0_238 = 0
	local var1_238 = #arg0_238

	while var0_238 < var1_238 do
		local var2_238 = string.byte(arg0_238, var0_238 + 1)

		if var2_238 < 48 or var2_238 > 57 then
			return false
		end

		var0_238 = var0_238 + 1
	end

	return true
end

function isHalfBodyLive2D(arg0_239)
	local var0_239 = {
		"biaoqiang",
		"z23",
		"lafei",
		"lingbo",
		"mingshi",
		"xuefeng"
	}

	return _.any(var0_239, function(arg0_240)
		return arg0_240 == arg0_239
	end)
end

function GetServerState(arg0_241)
	local var0_241 = -1
	local var1_241 = 0
	local var2_241 = 1
	local var3_241 = 2
	local var4_241 = NetConst.GetServerStateUrl()

	if PLATFORM_CODE == PLATFORM_CH then
		var4_241 = string.gsub(var4_241, "https", "http")
	end

	VersionMgr.Inst:WebRequest(var4_241, function(arg0_242, arg1_242)
		local var0_242 = true
		local var1_242 = false

		for iter0_242 in string.gmatch(arg1_242, "\"state\":%d") do
			if iter0_242 ~= "\"state\":1" then
				var0_242 = false
			end

			var1_242 = true
		end

		if not var1_242 then
			var0_242 = false
		end

		if arg0_241 ~= nil then
			arg0_241(var0_242 and var2_241 or var1_241)
		end
	end)
end

function setScrollText(arg0_243, arg1_243)
	GetOrAddComponent(arg0_243, "ScrollText"):SetText(arg1_243)
end

function changeToScrollText(arg0_244, arg1_244)
	local var0_244 = GetComponent(arg0_244, typeof(Text))

	assert(var0_244, "without component<Text>")

	local var1_244 = arg0_244:Find("subText")

	if not var1_244 then
		var1_244 = cloneTplTo(arg0_244, arg0_244, "subText")

		eachChild(arg0_244, function(arg0_245)
			setActive(arg0_245, arg0_245 == var1_244)
		end)

		arg0_244:GetComponent(typeof(Text)).enabled = false
	end

	setScrollText(var1_244, arg1_244)
end

local var17_0
local var18_0
local var19_0
local var20_0

local function var21_0(arg0_246, arg1_246, arg2_246)
	local var0_246 = arg0_246:Find("base")
	local var1_246, var2_246, var3_246 = Equipment.GetInfoTrans(arg1_246, arg2_246)

	if arg1_246.nextValue then
		local var4_246 = {
			name = arg1_246.name,
			type = arg1_246.type,
			value = arg1_246.nextValue
		}
		local var5_246, var6_246 = Equipment.GetInfoTrans(var4_246, arg2_246)

		var2_246 = var2_246 .. setColorStr("   >   " .. var6_246, COLOR_GREEN)
	end

	setText(var0_246:Find("name"), var1_246)

	if var3_246 then
		local var7_246 = "<color=#afff72>(+" .. ys.Battle.BattleConst.UltimateBonus.AuxBoostValue * 100 .. "%)</color>"

		setText(var0_246:Find("value"), var2_246 .. var7_246)
	else
		setText(var0_246:Find("value"), var2_246)
	end

	setActive(var0_246:Find("value/up"), arg1_246.compare and arg1_246.compare > 0)
	setActive(var0_246:Find("value/down"), arg1_246.compare and arg1_246.compare < 0)
	triggerToggle(var0_246, arg1_246.lock_open)

	if not arg1_246.lock_open and arg1_246.sub and #arg1_246.sub > 0 then
		GetComponent(var0_246, typeof(Toggle)).enabled = true
	else
		setActive(var0_246:Find("name/close"), false)
		setActive(var0_246:Find("name/open"), false)

		GetComponent(var0_246, typeof(Toggle)).enabled = false
	end
end

local function var22_0(arg0_247, arg1_247, arg2_247, arg3_247)
	var21_0(arg0_247, arg2_247, arg3_247)

	if not arg2_247.sub or #arg2_247.sub == 0 then
		return
	end

	var19_0(arg0_247:Find("subs"), arg1_247, arg2_247.sub, arg3_247)
end

function var19_0(arg0_248, arg1_248, arg2_248, arg3_248)
	removeAllChildren(arg0_248)
	var20_0(arg0_248, arg1_248, arg2_248, arg3_248)
end

function var20_0(arg0_249, arg1_249, arg2_249, arg3_249)
	for iter0_249, iter1_249 in ipairs(arg2_249) do
		local var0_249 = cloneTplTo(arg1_249, arg0_249)

		var22_0(var0_249, arg1_249, iter1_249, arg3_249)
	end
end

function updateEquipInfo(arg0_250, arg1_250, arg2_250, arg3_250)
	local var0_250 = arg0_250:Find("attr_tpl")

	var19_0(arg0_250:Find("attrs"), var0_250, arg1_250.attrs, arg3_250)
	setActive(arg0_250:Find("skill"), arg2_250)

	if arg2_250 then
		var22_0(arg0_250:Find("skill/attr"), var0_250, {
			name = i18n("skill"),
			value = setColorStr(arg2_250.name, "#FFDE00FF")
		}, arg3_250)
		setText(arg0_250:Find("skill/value/Text"), getSkillDescGet(arg2_250.id))
	end

	setActive(arg0_250:Find("weapon"), #arg1_250.weapon.sub > 0)

	if #arg1_250.weapon.sub > 0 then
		var19_0(arg0_250:Find("weapon"), var0_250, {
			arg1_250.weapon
		}, arg3_250)
	end

	setActive(arg0_250:Find("equip_info"), #arg1_250.equipInfo.sub > 0)

	if #arg1_250.equipInfo.sub > 0 then
		var19_0(arg0_250:Find("equip_info"), var0_250, {
			arg1_250.equipInfo
		}, arg3_250)
	end

	var22_0(arg0_250:Find("part/attr"), var0_250, {
		name = i18n("equip_info_23")
	}, arg3_250)

	local var1_250 = arg0_250:Find("part/value")
	local var2_250 = var1_250:Find("label")
	local var3_250 = {}
	local var4_250 = {}

	if #arg1_250.part[1] == 0 and #arg1_250.part[2] == 0 then
		setmetatable(var3_250, {
			__index = function(arg0_251, arg1_251)
				return true
			end
		})
		setmetatable(var4_250, {
			__index = function(arg0_252, arg1_252)
				return true
			end
		})
	else
		for iter0_250, iter1_250 in ipairs(arg1_250.part[1]) do
			var3_250[iter1_250] = true
		end

		for iter2_250, iter3_250 in ipairs(arg1_250.part[2]) do
			var4_250[iter3_250] = true
		end
	end

	local var5_250 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var3_250, var4_250)

	UIItemList.StaticAlign(var1_250, var2_250, #var5_250, function(arg0_253, arg1_253, arg2_253)
		arg1_253 = arg1_253 + 1

		if arg0_253 == UIItemList.EventUpdate then
			local var0_253 = var5_250[arg1_253]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0_253), arg2_253)
			setActive(arg2_253:Find("main"), var3_250[var0_253] and not var4_250[var0_253])
			setActive(arg2_253:Find("sub"), var4_250[var0_253] and not var3_250[var0_253])
			setImageAlpha(arg2_253, not var3_250[var0_253] and not var4_250[var0_253] and 0.3 or 1)
		end
	end)
end

function updateEquipUpgradeInfo(arg0_254, arg1_254, arg2_254)
	local var0_254 = arg0_254:Find("attr_tpl")

	var19_0(arg0_254:Find("attrs"), var0_254, arg1_254.attrs, arg2_254)
	setActive(arg0_254:Find("weapon"), #arg1_254.weapon.sub > 0)

	if #arg1_254.weapon.sub > 0 then
		var19_0(arg0_254:Find("weapon"), var0_254, {
			arg1_254.weapon
		}, arg2_254)
	end

	setActive(arg0_254:Find("equip_info"), #arg1_254.equipInfo.sub > 0)

	if #arg1_254.equipInfo.sub > 0 then
		var19_0(arg0_254:Find("equip_info"), var0_254, {
			arg1_254.equipInfo
		}, arg2_254)
	end
end

function setCanvasOverrideSorting(arg0_255, arg1_255)
	local var0_255 = arg0_255.parent

	arg0_255:SetParent(pg.LayerWeightMgr.GetInstance().uiOrigin, false)

	if isActive(arg0_255) then
		GetOrAddComponent(arg0_255, typeof(Canvas)).overrideSorting = arg1_255
	else
		setActive(arg0_255, true)

		GetOrAddComponent(arg0_255, typeof(Canvas)).overrideSorting = arg1_255

		setActive(arg0_255, false)
	end

	arg0_255:SetParent(var0_255, false)
end

function createNewGameObject(arg0_256, arg1_256)
	local var0_256 = GameObject.New()

	if arg0_256 then
		var0_256.name = "model"
	end

	var0_256.layer = arg1_256 or Layer.UI

	return GetOrAddComponent(var0_256, "RectTransform")
end

function CreateShell(arg0_257)
	if type(arg0_257) ~= "table" and type(arg0_257) ~= "userdata" then
		return arg0_257
	end

	local var0_257 = setmetatable({
		__index = arg0_257
	}, arg0_257)

	return setmetatable({}, var0_257)
end

function CameraFittingSettin(arg0_258)
	local var0_258 = GetComponent(arg0_258, typeof(Camera))
	local var1_258 = 1.77777777777778
	local var2_258 = Screen.width / Screen.height

	if var2_258 < var1_258 then
		local var3_258 = var2_258 / var1_258

		var0_258.rect = var0_0.Rect.New(0, (1 - var3_258) / 2, 1, var3_258)
	end
end

function SwitchSpecialChar(arg0_259, arg1_259)
	if PLATFORM_CODE ~= PLATFORM_US then
		arg0_259 = arg0_259:gsub(" ", " ")
		arg0_259 = arg0_259:gsub("\t", "    ")
	end

	if not arg1_259 then
		arg0_259 = arg0_259:gsub("\n", " ")
	end

	return arg0_259
end

function AfterCheck(arg0_260, arg1_260)
	local var0_260 = {}

	for iter0_260, iter1_260 in ipairs(arg0_260) do
		var0_260[iter0_260] = iter1_260[1]()
	end

	arg1_260()

	for iter2_260, iter3_260 in ipairs(arg0_260) do
		if var0_260[iter2_260] ~= iter3_260[1]() then
			iter3_260[2]()
		end

		var0_260[iter2_260] = iter3_260[1]()
	end
end

function CompareFuncs(arg0_261, arg1_261)
	local var0_261 = {}

	local function var1_261(arg0_262, arg1_262)
		var0_261[arg0_262] = var0_261[arg0_262] or {}
		var0_261[arg0_262][arg1_262] = var0_261[arg0_262][arg1_262] or arg0_261[arg0_262](arg1_262)

		return var0_261[arg0_262][arg1_262]
	end

	return function(arg0_263, arg1_263)
		local var0_263 = 1

		while var0_263 <= #arg0_261 do
			local var1_263 = var1_261(var0_263, arg0_263)
			local var2_263 = var1_261(var0_263, arg1_263)

			if var1_263 == var2_263 then
				var0_263 = var0_263 + 1
			else
				return var1_263 < var2_263
			end
		end

		return tobool(arg1_261)
	end
end

function DropResultIntegration(arg0_264)
	local var0_264 = {}
	local var1_264 = 1

	while var1_264 <= #arg0_264 do
		local var2_264 = arg0_264[var1_264].type
		local var3_264 = arg0_264[var1_264].id

		var0_264[var2_264] = var0_264[var2_264] or {}

		if var0_264[var2_264][var3_264] then
			local var4_264 = arg0_264[var0_264[var2_264][var3_264]]
			local var5_264 = table.remove(arg0_264, var1_264)

			var4_264.count = var4_264.count + var5_264.count
		else
			var0_264[var2_264][var3_264] = var1_264
			var1_264 = var1_264 + 1
		end
	end

	local var6_264 = {
		function(arg0_265)
			local var0_265 = arg0_265.type
			local var1_265 = arg0_265.id

			if var0_265 == DROP_TYPE_SHIP then
				return 1
			elseif var0_265 == DROP_TYPE_RESOURCE then
				if var1_265 == 1 then
					return 2
				else
					return 3
				end
			elseif var0_265 == DROP_TYPE_ITEM then
				if var1_265 == 59010 then
					return 4
				elseif var1_265 == 59900 then
					return 5
				else
					local var2_265 = Item.getConfigData(var1_265)
					local var3_265 = var2_265 and var2_265.type or 0

					if var3_265 == 9 then
						return 6
					elseif var3_265 == 5 then
						return 7
					elseif var3_265 == 4 then
						return 8
					elseif var3_265 == 7 then
						return 9
					end
				end
			elseif var0_265 == DROP_TYPE_VITEM and var1_265 == 59011 then
				return 4
			end

			return 100
		end,
		function(arg0_266)
			local var0_266

			if arg0_266.type == DROP_TYPE_SHIP then
				var0_266 = pg.ship_data_statistics[arg0_266.id]
			elseif arg0_266.type == DROP_TYPE_ITEM then
				var0_266 = Item.getConfigData(arg0_266.id)
			end

			return (var0_266 and var0_266.rarity or 0) * -1
		end,
		function(arg0_267)
			return arg0_267.id
		end
	}

	table.sort(arg0_264, CompareFuncs(var6_264))
end

function getLoginConfig()
	local var0_268 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_268 = 1

	for iter0_268, iter1_268 in ipairs(pg.login.all) do
		if pg.login[iter1_268].date ~= "stop" then
			local var2_268, var3_268 = parseTimeConfig(pg.login[iter1_268].date)

			assert(not var3_268)

			if pg.TimeMgr.GetInstance():inTime(var2_268, var0_268) then
				var1_268 = iter1_268

				break
			end
		end
	end

	local var4_268 = pg.login[var1_268].login_static

	var4_268 = var4_268 ~= "" and var4_268 or "login"

	local var5_268 = pg.login[var1_268].login_cri
	local var6_268 = var5_268 ~= "" and true or false
	local var7_268 = pg.login[var1_268].op_play == 1 and true or false
	local var8_268 = pg.login[var1_268].op_time

	if var8_268 == "" or not pg.TimeMgr.GetInstance():inTime(var8_268, var0_268) then
		var7_268 = false
	end

	local var9_268 = var8_268 == "" and var8_268 or table.concat(var8_268[1][1])

	return var6_268, var6_268 and var5_268 or var4_268, pg.login[var1_268].bgm, var7_268, var9_268
end

function setIntimacyIcon(arg0_269, arg1_269, arg2_269)
	local var0_269 = {}
	local var1_269

	seriesAsync({
		function(arg0_270)
			if arg0_269.childCount > 0 then
				var1_269 = arg0_269:GetChild(0)

				arg0_270()
			else
				LoadAndInstantiateAsync("template", "intimacytpl", function(arg0_271)
					var1_269 = tf(arg0_271)

					setParent(var1_269, arg0_269)
					arg0_270()
				end)
			end
		end,
		function(arg0_272)
			setImageAlpha(var1_269, arg2_269 and 0 or 1)
			eachChild(var1_269, function(arg0_273)
				setActive(arg0_273, false)
			end)

			if arg2_269 then
				local var0_272 = var1_269:Find(arg2_269 .. "(Clone)")

				if not var0_272 then
					LoadAndInstantiateAsync("ui", arg2_269, function(arg0_274)
						setParent(arg0_274, var1_269)
						setActive(arg0_274, true)
					end)
				else
					setActive(var0_272, true)
				end
			elseif arg1_269 then
				setImageSprite(var1_269, GetSpriteFromAtlas("energy", arg1_269), true)
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

function switch(arg0_277, arg1_277, arg2_277, ...)
	if arg1_277[arg0_277] then
		return arg1_277[arg0_277](...)
	elseif arg2_277 then
		return arg2_277(...)
	end
end

function parseTimeConfig(arg0_278)
	if type(arg0_278[1]) == "table" then
		return arg0_278[2], arg0_278[1]
	else
		return arg0_278
	end
end

local var24_0 = {
	__add = function(arg0_279, arg1_279)
		return NewPos(arg0_279.x + arg1_279.x, arg0_279.y + arg1_279.y)
	end,
	__sub = function(arg0_280, arg1_280)
		return NewPos(arg0_280.x - arg1_280.x, arg0_280.y - arg1_280.y)
	end,
	__mul = function(arg0_281, arg1_281)
		if type(arg1_281) == "number" then
			return NewPos(arg0_281.x * arg1_281, arg0_281.y * arg1_281)
		else
			return NewPos(arg0_281.x * arg1_281.x, arg0_281.y * arg1_281.y)
		end
	end,
	__eq = function(arg0_282, arg1_282)
		return arg0_282.x == arg1_282.x and arg0_282.y == arg1_282.y
	end,
	__tostring = function(arg0_283)
		return arg0_283.x .. "_" .. arg0_283.y
	end
}

function NewPos(arg0_284, arg1_284)
	assert(arg0_284 and arg1_284)

	local var0_284 = setmetatable({
		x = arg0_284,
		y = arg1_284
	}, var24_0)

	function var0_284.SqrMagnitude(arg0_285)
		return arg0_285.x * arg0_285.x + arg0_285.y * arg0_285.y
	end

	function var0_284.Normalize(arg0_286)
		local var0_286 = arg0_286:SqrMagnitude()

		if var0_286 > 1e-05 then
			return arg0_286 * (1 / math.sqrt(var0_286))
		else
			return NewPos(0, 0)
		end
	end

	return var0_284
end

local var25_0

function Timekeeping()
	warning(Time.realtimeSinceStartup - (var25_0 or Time.realtimeSinceStartup), Time.realtimeSinceStartup)

	var25_0 = Time.realtimeSinceStartup
end

function GetRomanDigit(arg0_288)
	return (string.char(226, 133, 160 + (arg0_288 - 1)))
end

function quickPlayAnimator(arg0_289, arg1_289)
	arg0_289:GetComponent(typeof(Animator)):Play(arg1_289, -1, 0)
end

function quickCheckAndPlayAnimator(arg0_290, arg1_290)
	local var0_290 = arg0_290:GetComponent(typeof(Animator))
	local var1_290 = Animator.StringToHash(arg1_290)

	if var0_290:HasState(0, var1_290) then
		var0_290:Play(arg1_290, -1, 0)
	end
end

function quickPlayAnimation(arg0_291, arg1_291)
	arg0_291:GetComponent(typeof(Animation)):Play(arg1_291)
end

function getSurveyUrl(arg0_292)
	local var0_292 = pg.survey_data_template[arg0_292]
	local var1_292

	if not IsUnityEditor then
		if PLATFORM_CODE == PLATFORM_CH then
			local var2_292 = getProxy(UserProxy):GetCacheGatewayInServerLogined()

			if var2_292 == PLATFORM_ANDROID then
				if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_BILI then
					var1_292 = var0_292.main_url
				else
					var1_292 = var0_292.uo_url
				end
			elseif var2_292 == PLATFORM_IPHONEPLAYER then
				var1_292 = var0_292.ios_url
			end
		elseif PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
			var1_292 = var0_292.main_url
		end
	else
		var1_292 = var0_292.main_url
	end

	local var3_292 = getProxy(PlayerProxy):getRawData().id
	local var4_292 = getProxy(UserProxy):getRawData().arg2 or ""
	local var5_292
	local var6_292 = PLATFORM == PLATFORM_ANDROID and 1 or PLATFORM == PLATFORM_IPHONEPLAYER and 2 or 3
	local var7_292 = getProxy(UserProxy):getRawData()
	local var8_292 = getProxy(ServerProxy):getRawData()[var7_292 and var7_292.server or 0]
	local var9_292 = var8_292 and var8_292.id or ""
	local var10_292 = getProxy(PlayerProxy):getRawData().level
	local var11_292 = var3_292 .. "_" .. arg0_292
	local var12_292 = var1_292
	local var13_292 = {
		var3_292,
		var4_292,
		var6_292,
		var9_292,
		var10_292,
		var11_292
	}

	if var12_292 then
		for iter0_292, iter1_292 in ipairs(var13_292) do
			var12_292 = string.gsub(var12_292, "$" .. iter0_292, tostring(iter1_292))
		end
	end

	warning(var12_292)

	return var12_292
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

function FilterVarchar(arg0_294)
	assert(type(arg0_294) == "string" or type(arg0_294) == "table")

	if arg0_294 == "" then
		return nil
	end

	return arg0_294
end

function getGameset(arg0_295)
	local var0_295 = pg.gameset[arg0_295]

	assert(var0_295)

	return {
		var0_295.key_value,
		var0_295.description
	}
end

function getDorm3dGameset(arg0_296)
	local var0_296 = pg.dorm3d_set[arg0_296]

	assert(var0_296)

	return {
		var0_296.key_value_int,
		var0_296.key_value_varchar
	}
end

function GetItemsOverflowDic(arg0_297)
	arg0_297 = arg0_297 or {}

	local var0_297 = {
		[DROP_TYPE_ITEM] = {},
		[DROP_TYPE_RESOURCE] = {},
		[DROP_TYPE_EQUIP] = 0,
		[DROP_TYPE_SHIP] = 0,
		[DROP_TYPE_WORLD_ITEM] = 0
	}

	while #arg0_297 > 0 do
		local var1_297 = table.remove(arg0_297)

		switch(var1_297.type, {
			[DROP_TYPE_ITEM] = function()
				if var1_297:getConfig("open_directly") == 1 then
					for iter0_298, iter1_298 in ipairs(var1_297:getConfig("display_icon")) do
						local var0_298 = Drop.Create(iter1_298)

						var0_298.count = var0_298.count * var1_297.count

						table.insert(arg0_297, var0_298)
					end
				elseif var1_297:getSubClass():IsShipExpType() then
					var0_297[var1_297.type][var1_297.id] = defaultValue(var0_297[var1_297.type][var1_297.id], 0) + var1_297.count
				end
			end,
			[DROP_TYPE_RESOURCE] = function()
				var0_297[var1_297.type][var1_297.id] = defaultValue(var0_297[var1_297.type][var1_297.id], 0) + var1_297.count
			end,
			[DROP_TYPE_EQUIP] = function()
				var0_297[var1_297.type] = var0_297[var1_297.type] + var1_297.count
			end,
			[DROP_TYPE_SHIP] = function()
				var0_297[var1_297.type] = var0_297[var1_297.type] + var1_297.count
			end,
			[DROP_TYPE_WORLD_ITEM] = function()
				var0_297[var1_297.type] = var0_297[var1_297.type] + var1_297.count
			end
		})
	end

	return var0_297
end

function CheckOverflow(arg0_303, arg1_303)
	local var0_303 = {}
	local var1_303 = arg0_303[DROP_TYPE_RESOURCE][PlayerConst.ResGold] or 0
	local var2_303 = arg0_303[DROP_TYPE_RESOURCE][PlayerConst.ResOil] or 0
	local var3_303 = arg0_303[DROP_TYPE_EQUIP]
	local var4_303 = arg0_303[DROP_TYPE_SHIP]
	local var5_303 = getProxy(PlayerProxy):getRawData()
	local var6_303 = false

	if arg1_303 then
		local var7_303 = var5_303:OverStore(PlayerConst.ResStoreGold, var1_303)
		local var8_303 = var5_303:OverStore(PlayerConst.ResStoreOil, var2_303)

		if var7_303 > 0 or var8_303 > 0 then
			var0_303.isStoreOverflow = {
				var7_303,
				var8_303
			}
		end
	else
		if var1_303 > 0 and var5_303:GoldMax(var1_303) then
			return false, "gold"
		end

		if var2_303 > 0 and var5_303:OilMax(var2_303) then
			return false, "oil"
		end
	end

	var0_303.isExpBookOverflow = {}

	for iter0_303, iter1_303 in pairs(arg0_303[DROP_TYPE_ITEM]) do
		local var9_303 = Item.getConfigData(iter0_303)

		if getProxy(BagProxy):getItemCountById(iter0_303) + iter1_303 > var9_303.max_num then
			table.insert(var0_303.isExpBookOverflow, iter0_303)
		end
	end

	local var10_303 = getProxy(EquipmentProxy):getCapacity()

	if var3_303 > 0 and var3_303 + var10_303 > var5_303:getMaxEquipmentBag() then
		return false, "equip"
	end

	local var11_303 = getProxy(BayProxy):getShipCount()

	if var4_303 > 0 and var4_303 + var11_303 > var5_303:getMaxShipBag() then
		return false, "ship"
	end

	return true, var0_303
end

function CheckShipExpOverflow(arg0_304)
	local var0_304 = getProxy(BagProxy)

	for iter0_304, iter1_304 in pairs(arg0_304[DROP_TYPE_ITEM]) do
		if var0_304:getItemCountById(iter0_304) + iter1_304 > Item.getConfigData(iter0_304).max_num then
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

function RegisterDetailButton(arg0_305, arg1_305, arg2_305)
	Drop.Change(arg2_305)
	switch(arg2_305.type, {
		[DROP_TYPE_ITEM] = function()
			if arg2_305:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
				local var0_306 = Item.getConfigData(arg2_305.id).usage_arg
				local var1_306 = var0_306[3]

				if Item.InTimeLimitSkinAssigned(arg2_305.id) then
					var1_306 = table.mergeArray(var0_306[2], var1_306, true)
				end

				local var2_306 = {}

				for iter0_306, iter1_306 in ipairs(var0_306[2]) do
					var2_306[iter1_306] = true
				end

				onButton(arg0_305, arg1_305, function()
					arg0_305:closeView()
					pg.m02:sendNotification(GAME.LOAD_LAYERS, {
						parentContext = getProxy(ContextProxy):getCurrentContext(),
						context = Context.New({
							viewComponent = SelectSkinLayer,
							mediator = SkinAtlasMediator,
							data = {
								mode = SelectSkinLayer.MODE_VIEW,
								itemId = arg2_305.id,
								selectableSkinList = underscore.map(var1_306, function(arg0_308)
									return SelectableSkin.New({
										id = arg0_308,
										isTimeLimit = var2_306[arg0_308] or false
									})
								end)
							}
						})
					})
				end, SFX_PANEL)
				setActive(arg1_305, true)
			else
				local var3_306 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_305.id) and "tech" or arg2_305:getConfig("type")

				if var26_0[var3_306] then
					local var4_306 = {
						item2Row = true,
						content = i18n(var26_0[var3_306]),
						itemList = underscore.map(arg2_305:getConfig("display_icon"), function(arg0_309)
							return Drop.Create(arg0_309)
						end)
					}

					if var3_306 == 11 then
						onButton(arg0_305, arg1_305, function()
							arg0_305:emit(BaseUI.ON_DROP_LIST_OWN, var4_306)
						end, SFX_PANEL)
					else
						onButton(arg0_305, arg1_305, function()
							arg0_305:emit(BaseUI.ON_DROP_LIST, var4_306)
						end, SFX_PANEL)
					end
				end

				setActive(arg1_305, tobool(var26_0[var3_306]))
			end
		end,
		[DROP_TYPE_EQUIP] = function()
			onButton(arg0_305, arg1_305, function()
				arg0_305:emit(BaseUI.ON_DROP, arg2_305)
			end, SFX_PANEL)
			setActive(arg1_305, true)
		end,
		[DROP_TYPE_SPWEAPON] = function()
			onButton(arg0_305, arg1_305, function()
				arg0_305:emit(BaseUI.ON_DROP, arg2_305)
			end, SFX_PANEL)
			setActive(arg1_305, true)
		end
	}, function()
		setActive(arg1_305, false)
	end)
end

function RegisterNewStyleDetailButton(arg0_317, arg1_317, arg2_317)
	Drop.Change(arg2_317)
	switch(arg2_317.type, {
		[DROP_TYPE_ITEM] = function()
			local var0_318 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_317.id) and "tech" or arg2_317:getConfig("type")

			if var26_0[var0_318] then
				local var1_318 = {
					useDeepShow = true,
					showOwn = var0_318 == 11,
					content = i18n(var26_0[var0_318]),
					itemList = underscore.map(arg2_317:getConfig("display_icon"), function(arg0_319)
						return Drop.Create(arg0_319)
					end)
				}

				onButton(arg0_317, arg1_317, function()
					arg0_317:emit(BaseUI.ON_NEW_STYLE_ITEMS, var1_318)
				end, SFX_PANEL)
			end

			setActive(arg1_317, tobool(var26_0[var0_318]))
		end
	}, function()
		setActive(arg1_317, false)
	end)
end

function UpdateOwnDisplay(arg0_322, arg1_322)
	local var0_322, var1_322 = arg1_322:getOwnedCount()

	setActive(arg0_322, var1_322 and var0_322 > 0)

	if var1_322 and var0_322 > 0 then
		setText(arg0_322:Find("label"), i18n("word_own1"))
		setText(arg0_322:Find("Text"), var0_322)
	end
end

function Damp(arg0_323, arg1_323, arg2_323)
	arg1_323 = Mathf.Max(1, arg1_323)

	local var0_323 = Mathf.Epsilon

	if arg1_323 < var0_323 or var0_323 > Mathf.Abs(arg0_323) then
		return arg0_323
	end

	if arg2_323 < var0_323 then
		return 0
	end

	local var1_323 = -4.605170186

	return arg0_323 * (1 - Mathf.Exp(var1_323 * arg2_323 / arg1_323))
end

function checkCullResume(arg0_324)
	if not ReflectionHelp.RefCallMethodEx(typeof("UnityEngine.CanvasRenderer"), "GetMaterial", GetComponent(arg0_324, "CanvasRenderer"), {
		typeof("System.Int32")
	}, {
		0
	}) then
		local var0_324 = arg0_324:GetComponentsInChildren(typeof(MeshImage))

		for iter0_324 = 1, var0_324.Length do
			var0_324[iter0_324 - 1]:SetVerticesDirty()
		end

		return false
	end

	return true
end

function parseEquipCode(arg0_325)
	local var0_325 = {}

	if arg0_325 and arg0_325 ~= "" then
		local var1_325 = base64.dec(arg0_325)

		var0_325 = string.split(var1_325, "/")
		var0_325[5], var0_325[6] = unpack(string.split(var0_325[5], "\\"))

		if #var0_325 < 6 or arg0_325 ~= base64.enc(table.concat({
			table.concat(underscore.first(var0_325, 5), "/"),
			var0_325[6]
		}, "\\")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_illegal"))

			var0_325 = {}
		end
	end

	for iter0_325 = 1, 6 do
		var0_325[iter0_325] = var0_325[iter0_325] and tonumber(var0_325[iter0_325], 32) or 0
	end

	return var0_325
end

function buildEquipCode(arg0_326)
	local var0_326 = underscore.map(arg0_326:getAllEquipments(), function(arg0_327)
		return ConversionBase(32, arg0_327 and arg0_327.id or 0)
	end)
	local var1_326 = {
		table.concat(var0_326, "/"),
		ConversionBase(32, checkExist(arg0_326:GetSpWeapon(), {
			"id"
		}) or 0)
	}

	return base64.enc(table.concat(var1_326, "\\"))
end

function setDirectorSpeed(arg0_328, arg1_328)
	GetComponent(arg0_328, "TimelineSpeed"):SetTimelineSpeed(arg1_328)
end

function setDefaultZeroMetatable(arg0_329)
	return setmetatable(arg0_329, {
		__index = function(arg0_330, arg1_330)
			if rawget(arg0_330, arg1_330) == nil then
				arg0_330[arg1_330] = 0
			end

			return arg0_330[arg1_330]
		end
	})
end

function checkABExist(arg0_331)
	if EDITOR_TOOL then
		return ResourceMgr.Inst:AssetExist(arg0_331)
	else
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_331))
	end
end
