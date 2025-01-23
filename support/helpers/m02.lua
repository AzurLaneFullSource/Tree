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

function updateActivityMedal(arg0_120, arg1_120, arg2_120)
	local var0_120 = ItemRarity.Rarity2Print(arg1_120.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_120, findTF(arg0_120, "icon_bg"))
	setFrame(findTF(arg0_120, "icon_bg/frame"), var0_120)

	local var1_120 = findTF(arg0_120, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_120.icon, "", var1_120)
	setIconName(arg0_120, arg1_120.name, arg2_120)
end

function updateCover(arg0_121, arg1_121, arg2_121)
	local var0_121 = arg1_121:getDropRarity()

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_121, findTF(arg0_121, "icon_bg"))
	setFrame(findTF(arg0_121, "icon_bg/frame"), var0_121)

	local var1_121 = findTF(arg0_121, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_121:getIcon(), "", var1_121)
	setIconName(arg0_121, arg1_121:getName(), arg2_121)
	setIconStars(arg0_121, false)
end

function updateEmoji(arg0_122, arg1_122, arg2_122)
	local var0_122 = findTF(arg0_122, "icon_bg/icon")
	local var1_122 = "icon_emoji"

	GetImageSpriteFromAtlasAsync("Props/" .. var1_122, "", var0_122)

	local var2_122 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var2_122, findTF(arg0_122, "icon_bg"))
	setFrame(findTF(arg0_122, "icon_bg/frame"), var2_122)
	setIconName(arg0_122, arg1_122.name, arg2_122)
end

function updateEquipmentSkin(arg0_123, arg1_123, arg2_123)
	arg2_123 = arg2_123 or {}

	local var0_123 = EquipmentRarity.Rarity2Print(arg1_123.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_123, findTF(arg0_123, "icon_bg"))
	setFrame(findTF(arg0_123, "icon_bg/frame"), var0_123, "frame_skin")

	local var1_123 = findTF(arg0_123, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. arg1_123.icon, "", var1_123)
	setIconStars(arg0_123, false)
	setIconName(arg0_123, arg1_123.name, arg2_123)
	setIconCount(arg0_123, arg1_123.count)
	setIconColorful(arg0_123, arg1_123.rarity - 1, arg2_123)
end

function NoPosMsgBox(arg0_124, arg1_124, arg2_124, arg3_124)
	local var0_124
	local var1_124 = {}

	if arg1_124 then
		table.insert(var1_124, {
			text = "text_noPos_clear",
			atuoClose = true,
			onCallback = arg1_124
		})
	end

	if arg2_124 then
		table.insert(var1_124, {
			text = "text_noPos_buy",
			atuoClose = true,
			onCallback = arg2_124
		})
	end

	if arg3_124 then
		table.insert(var1_124, {
			text = "text_noPos_intensify",
			atuoClose = true,
			onCallback = arg3_124
		})
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		hideNo = true,
		content = arg0_124,
		custom = var1_124,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function openDestroyEquip()
	if pg.m02:hasMediator(EquipmentMediator.__cname) then
		local var0_125 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_125 and var0_125.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_125
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
		local var0_126 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_126 and var0_126.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_126
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
		onClick = function(arg0_129, arg1_129)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
				page = 3,
				shipId = arg0_129.id,
				shipVOs = arg1_129
			})
		end
	})
end

function GoShoppingMsgBox(arg0_130, arg1_130, arg2_130)
	if arg2_130 then
		local var0_130 = ""

		for iter0_130, iter1_130 in ipairs(arg2_130) do
			local var1_130 = Item.getConfigData(iter1_130[1])

			var0_130 = var0_130 .. i18n(iter1_130[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var1_130.name, iter1_130[2])

			if iter0_130 < #arg2_130 then
				var0_130 = var0_130 .. i18n("text_noRes_info_tip_link")
			end
		end

		if var0_130 ~= "" then
			arg0_130 = arg0_130 .. "\n" .. i18n("text_noRes_tip", var0_130)
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = arg0_130,
		weight = LayerWeightConst.SECOND_LAYER,
		onYes = function()
			gotoChargeScene(arg1_130, arg2_130)
		end
	})
end

function shoppingBatch(arg0_132, arg1_132, arg2_132, arg3_132, arg4_132)
	local var0_132 = pg.shop_template[arg0_132]

	assert(var0_132, "shop_template中找不到商品id：" .. arg0_132)

	local var1_132 = getProxy(PlayerProxy):getData()[id2res(var0_132.resource_type)]
	local var2_132 = arg1_132.price or var0_132.resource_num
	local var3_132 = math.floor(var1_132 / var2_132)

	var3_132 = var3_132 <= 0 and 1 or var3_132
	var3_132 = arg2_132 ~= nil and arg2_132 < var3_132 and arg2_132 or var3_132

	local var4_132 = true
	local var5_132 = 1

	if var0_132 ~= nil and arg1_132.id then
		print(var3_132 * var0_132.num, "--", var3_132)
		assert(Item.getConfigData(arg1_132.id), "item config should be existence")

		local var6_132 = Item.New({
			id = arg1_132.id
		}):getConfig("name")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			needCounter = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_ITEM,
				id = arg1_132.id
			},
			addNum = var0_132.num,
			maxNum = var3_132 * var0_132.num,
			defaultNum = var0_132.num,
			numUpdate = function(arg0_133, arg1_133)
				var5_132 = math.floor(arg1_133 / var0_132.num)

				local var0_133 = var5_132 * var2_132

				if var0_133 > var1_132 then
					setText(arg0_133, i18n(arg3_132, var0_133, arg1_133, COLOR_RED, var6_132))

					var4_132 = false
				else
					setText(arg0_133, i18n(arg3_132, var0_133, arg1_133, COLOR_GREEN, var6_132))

					var4_132 = true
				end
			end,
			onYes = function()
				if var4_132 then
					pg.m02:sendNotification(GAME.SHOPPING, {
						id = arg0_132,
						count = var5_132
					})
				elseif arg4_132 then
					pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_132))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("main_playerInfoLayer_error_changeNameNoGem"))
				end
			end
		})
	end
end

function shoppingBatchNewStyle(arg0_135, arg1_135, arg2_135, arg3_135, arg4_135)
	local var0_135 = pg.shop_template[arg0_135]

	assert(var0_135, "shop_template中找不到商品id：" .. arg0_135)

	local var1_135 = getProxy(PlayerProxy):getData()[id2res(var0_135.resource_type)]
	local var2_135 = arg1_135.price or var0_135.resource_num
	local var3_135 = math.floor(var1_135 / var2_135)

	var3_135 = var3_135 <= 0 and 1 or var3_135
	var3_135 = arg2_135 ~= nil and arg2_135 < var3_135 and arg2_135 or var3_135

	local var4_135 = true
	local var5_135 = 1

	if var0_135 ~= nil and arg1_135.id then
		print(var3_135 * var0_135.num, "--", var3_135)
		assert(Item.getConfigData(arg1_135.id), "item config should be existence")

		local var6_135 = Item.New({
			id = arg1_135.id
		}):getConfig("name")

		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_SHOPPING, {
			drop = Drop.New({
				count = 1,
				type = DROP_TYPE_ITEM,
				id = arg1_135.id
			}),
			price = var2_135,
			addNum = var0_135.num,
			maxNum = var3_135 * var0_135.num,
			defaultNum = var0_135.num,
			numUpdate = function(arg0_136, arg1_136)
				var5_135 = math.floor(arg1_136 / var0_135.num)

				local var0_136 = var5_135 * var2_135

				if var0_136 > var1_135 then
					setTextInNewStyleBox(arg0_136, i18n(arg3_135, var0_136, arg1_136, COLOR_RED, var6_135))

					var4_135 = false
				else
					setTextInNewStyleBox(arg0_136, i18n(arg3_135, var0_136, arg1_136, "#238C40FF", var6_135))

					var4_135 = true
				end
			end,
			btnList = {
				{
					type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.shopping,
					name = i18n("word_buy"),
					func = function()
						if var4_135 then
							pg.m02:sendNotification(GAME.SHOPPING, {
								id = arg0_135,
								count = var5_135
							})
						elseif arg4_135 then
							pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_135))
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

function gotoChargeScene(arg0_138, arg1_138)
	local var0_138 = getProxy(ContextProxy)
	local var1_138 = getProxy(ContextProxy):getCurrentContext()

	if instanceof(var1_138.mediator, ChargeMediator) then
		var1_138.mediator:getViewComponent():switchSubViewByTogger(arg0_138)
	else
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
			wrap = arg0_138 or ChargeScene.TYPE_ITEM,
			noRes = arg1_138
		})
	end
end

function clearDrop(arg0_139)
	local var0_139 = findTF(arg0_139, "icon_bg")
	local var1_139 = findTF(arg0_139, "icon_bg/frame")
	local var2_139 = findTF(arg0_139, "icon_bg/icon")
	local var3_139 = findTF(arg0_139, "icon_bg/icon/icon")

	clearImageSprite(var0_139)
	clearImageSprite(var1_139)
	clearImageSprite(var2_139)

	if var3_139 then
		clearImageSprite(var3_139)
	end
end

local var8_0 = {
	red = Color.New(1, 0.25, 0.25),
	blue = Color.New(0.11, 0.55, 0.64),
	yellow = Color.New(0.92, 0.52, 0)
}

function updateSkill(arg0_140, arg1_140, arg2_140, arg3_140)
	local var0_140 = findTF(arg0_140, "skill")
	local var1_140 = findTF(arg0_140, "lock")
	local var2_140 = findTF(arg0_140, "unknown")

	if arg1_140 then
		setActive(var0_140, true)
		setActive(var2_140, false)
		setActive(var1_140, not arg2_140)
		LoadImageSpriteAsync("skillicon/" .. arg1_140.icon, findTF(var0_140, "icon"))

		local var3_140 = arg1_140.color or "blue"

		setText(findTF(var0_140, "name"), shortenString(getSkillName(arg1_140.id), arg3_140 or 8))

		local var4_140 = findTF(var0_140, "level")

		setText(var4_140, "LEVEL: " .. (arg2_140 and arg2_140.level or "??"))
		setTextColor(var4_140, var8_0[var3_140])
	else
		setActive(var0_140, false)
		setActive(var2_140, true)
		setActive(var1_140, false)
	end
end

local var9_0 = true

function onBackButton(arg0_141, arg1_141, arg2_141, arg3_141)
	local var0_141 = GetOrAddComponent(arg1_141, "UILongPressTrigger")

	assert(arg2_141, "callback should exist")

	var0_141.longPressThreshold = defaultValue(arg3_141, 1)

	local function var1_141(arg0_142)
		return function()
			if var9_0 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SOUND_BACK)
			end

			local var0_143, var1_143 = arg2_141()

			if var0_143 then
				arg0_142(var1_143)
			end
		end
	end

	local var2_141 = var0_141.onReleased

	pg.DelegateInfo.Add(arg0_141, var2_141)
	var2_141:RemoveAllListeners()
	var2_141:AddListener(var1_141(function(arg0_144)
		arg0_144:emit(BaseUI.ON_BACK)
	end))

	local var3_141 = var0_141.onLongPressed

	pg.DelegateInfo.Add(arg0_141, var3_141)
	var3_141:RemoveAllListeners()
	var3_141:AddListener(var1_141(function(arg0_145)
		arg0_145:emit(BaseUI.ON_HOME)
	end))
end

function GetZeroTime()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)
end

function GetHalfHour()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0, 1800)
end

function GetNextHour(arg0_148)
	local var0_148 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_148, var2_148 = pg.TimeMgr.GetInstance():parseTimeFrom(var0_148)

	return var1_148 * 86400 + (var2_148 + arg0_148) * 3600
end

function GetPerceptualSize(arg0_149)
	local function var0_149(arg0_150)
		if not arg0_150 then
			return 0, 1
		elseif arg0_150 > 240 then
			return 4, 1
		elseif arg0_150 > 225 then
			return 3, 1
		elseif arg0_150 > 192 then
			return 2, 1
		elseif arg0_150 < 126 then
			return 1, 0.5
		else
			return 1, 1
		end
	end

	if type(arg0_149) == "number" then
		return var0_149(arg0_149)
	end

	local var1_149 = 1
	local var2_149 = 0
	local var3_149 = 0
	local var4_149 = #arg0_149

	while var1_149 <= var4_149 do
		local var5_149 = string.byte(arg0_149, var1_149)
		local var6_149, var7_149 = var0_149(var5_149)

		var1_149 = var1_149 + var6_149
		var2_149 = var2_149 + var7_149
	end

	return var2_149
end

function shortenString(arg0_151, arg1_151)
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
		return arg0_151
	end

	return string.sub(arg0_151, 1, var2_151 - 1) .. ".."
end

function shouldShortenString(arg0_152, arg1_152)
	local var0_152 = 1
	local var1_152 = 0
	local var2_152 = 0
	local var3_152 = #arg0_152

	while var0_152 <= var3_152 do
		local var4_152 = string.byte(arg0_152, var0_152)
		local var5_152, var6_152 = GetPerceptualSize(var4_152)

		var0_152 = var0_152 + var5_152
		var1_152 = var1_152 + var6_152

		if arg1_152 <= math.ceil(var1_152) then
			var2_152 = var0_152

			break
		end
	end

	if var2_152 == 0 or var3_152 < var2_152 then
		return false
	end

	return true
end

function nameValidityCheck(arg0_153, arg1_153, arg2_153, arg3_153)
	local var0_153 = true
	local var1_153, var2_153 = utf8_to_unicode(arg0_153)
	local var3_153 = filterEgyUnicode(filterSpecChars(arg0_153))
	local var4_153 = wordVer(arg0_153)

	if not checkSpaceValid(arg0_153) then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_153[1]))

		var0_153 = false
	elseif var4_153 > 0 or var3_153 ~= arg0_153 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_153[4]))

		var0_153 = false
	elseif var2_153 < arg1_153 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_153[2]))

		var0_153 = false
	elseif arg2_153 < var2_153 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_153[3]))

		var0_153 = false
	end

	return var0_153
end

function checkSpaceValid(arg0_154)
	if PLATFORM_CODE == PLATFORM_US then
		return true
	end

	local var0_154 = string.gsub(arg0_154, " ", "")

	return arg0_154 == string.gsub(var0_154, "　", "")
end

function filterSpecChars(arg0_155)
	local var0_155 = {}
	local var1_155 = 0
	local var2_155 = 0
	local var3_155 = 0
	local var4_155 = 1

	while var4_155 <= #arg0_155 do
		local var5_155 = string.byte(arg0_155, var4_155)

		if not var5_155 then
			break
		end

		if var5_155 >= 48 and var5_155 <= 57 or var5_155 >= 65 and var5_155 <= 90 or var5_155 == 95 or var5_155 >= 97 and var5_155 <= 122 then
			table.insert(var0_155, string.char(var5_155))
		elseif var5_155 >= 228 and var5_155 <= 233 then
			local var6_155 = string.byte(arg0_155, var4_155 + 1)
			local var7_155 = string.byte(arg0_155, var4_155 + 2)

			if var6_155 and var7_155 and var6_155 >= 128 and var6_155 <= 191 and var7_155 >= 128 and var7_155 <= 191 then
				var4_155 = var4_155 + 2

				table.insert(var0_155, string.char(var5_155, var6_155, var7_155))

				var1_155 = var1_155 + 1
			end
		elseif var5_155 == 45 or var5_155 == 40 or var5_155 == 41 then
			table.insert(var0_155, string.char(var5_155))
		elseif var5_155 == 194 then
			local var8_155 = string.byte(arg0_155, var4_155 + 1)

			if var8_155 == 183 then
				var4_155 = var4_155 + 1

				table.insert(var0_155, string.char(var5_155, var8_155))

				var1_155 = var1_155 + 1
			end
		elseif var5_155 == 239 then
			local var9_155 = string.byte(arg0_155, var4_155 + 1)
			local var10_155 = string.byte(arg0_155, var4_155 + 2)

			if var9_155 == 188 and (var10_155 == 136 or var10_155 == 137) then
				var4_155 = var4_155 + 2

				table.insert(var0_155, string.char(var5_155, var9_155, var10_155))

				var1_155 = var1_155 + 1
			end
		elseif var5_155 == 206 or var5_155 == 207 then
			local var11_155 = string.byte(arg0_155, var4_155 + 1)

			if var5_155 == 206 and var11_155 >= 177 or var5_155 == 207 and var11_155 <= 134 then
				var4_155 = var4_155 + 1

				table.insert(var0_155, string.char(var5_155, var11_155))

				var1_155 = var1_155 + 1
			end
		elseif var5_155 == 227 and PLATFORM_CODE == PLATFORM_JP then
			local var12_155 = string.byte(arg0_155, var4_155 + 1)
			local var13_155 = string.byte(arg0_155, var4_155 + 2)

			if var12_155 and var13_155 and var12_155 > 128 and var12_155 <= 191 and var13_155 >= 128 and var13_155 <= 191 then
				var4_155 = var4_155 + 2

				table.insert(var0_155, string.char(var5_155, var12_155, var13_155))

				var2_155 = var2_155 + 1
			end
		elseif var5_155 >= 224 and PLATFORM_CODE == PLATFORM_KR then
			local var14_155 = string.byte(arg0_155, var4_155 + 1)
			local var15_155 = string.byte(arg0_155, var4_155 + 2)

			if var14_155 and var15_155 and var14_155 >= 128 and var14_155 <= 191 and var15_155 >= 128 and var15_155 <= 191 then
				var4_155 = var4_155 + 2

				table.insert(var0_155, string.char(var5_155, var14_155, var15_155))

				var3_155 = var3_155 + 1
			end
		elseif PLATFORM_CODE == PLATFORM_US then
			if var4_155 ~= 1 and var5_155 == 32 and string.byte(arg0_155, var4_155 + 1) ~= 32 then
				table.insert(var0_155, string.char(var5_155))
			end

			if var5_155 >= 192 and var5_155 <= 223 then
				local var16_155 = string.byte(arg0_155, var4_155 + 1)

				var4_155 = var4_155 + 1

				if var5_155 == 194 and var16_155 and var16_155 >= 128 then
					table.insert(var0_155, string.char(var5_155, var16_155))
				elseif var5_155 == 195 and var16_155 and var16_155 <= 191 then
					table.insert(var0_155, string.char(var5_155, var16_155))
				end
			end
		end

		var4_155 = var4_155 + 1
	end

	return table.concat(var0_155), var1_155 + var2_155 + var3_155
end

function filterEgyUnicode(arg0_156)
	arg0_156 = string.gsub(arg0_156, "�[�-�][�-�]", "")
	arg0_156 = string.gsub(arg0_156, "�[�-�]", "")

	return arg0_156
end

function shiftPanel(arg0_157, arg1_157, arg2_157, arg3_157, arg4_157, arg5_157, arg6_157, arg7_157, arg8_157)
	arg3_157 = arg3_157 or 0.2

	if arg5_157 then
		LeanTween.cancel(go(arg0_157))
	end

	local var0_157 = rtf(arg0_157)

	arg1_157 = arg1_157 or var0_157.anchoredPosition.x
	arg2_157 = arg2_157 or var0_157.anchoredPosition.y

	local var1_157 = LeanTween.move(var0_157, Vector3(arg1_157, arg2_157, 0), arg3_157)

	arg7_157 = arg7_157 or LeanTweenType.easeInOutSine

	var1_157:setEase(arg7_157)

	if arg4_157 then
		var1_157:setDelay(arg4_157)
	end

	if arg6_157 then
		GetOrAddComponent(arg0_157, "CanvasGroup").blocksRaycasts = false
	end

	var1_157:setOnComplete(System.Action(function()
		if arg8_157 then
			arg8_157()
		end

		if arg6_157 then
			GetOrAddComponent(arg0_157, "CanvasGroup").blocksRaycasts = true
		end
	end))

	return var1_157
end

function TweenValue(arg0_159, arg1_159, arg2_159, arg3_159, arg4_159, arg5_159, arg6_159, arg7_159)
	local var0_159 = LeanTween.value(go(arg0_159), arg1_159, arg2_159, arg3_159):setOnUpdate(System.Action_float(function(arg0_160)
		if arg5_159 then
			arg5_159(arg0_160)
		end
	end)):setOnComplete(System.Action(function()
		if arg6_159 then
			arg6_159()
		end
	end)):setDelay(arg4_159 or 0)

	if arg7_159 and arg7_159 > 0 then
		var0_159:setRepeat(arg7_159)
	end

	return var0_159
end

function rotateAni(arg0_162, arg1_162, arg2_162)
	return LeanTween.rotate(rtf(arg0_162), 360 * arg1_162, arg2_162):setLoopClamp()
end

function blinkAni(arg0_163, arg1_163, arg2_163, arg3_163)
	return LeanTween.alpha(rtf(arg0_163), arg3_163 or 0, arg1_163):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(arg2_163 or 0)
end

function scaleAni(arg0_164, arg1_164, arg2_164, arg3_164)
	return LeanTween.scale(rtf(arg0_164), arg3_164 or 0, arg1_164):setLoopPingPong(arg2_164 or 0)
end

function floatAni(arg0_165, arg1_165, arg2_165, arg3_165)
	local var0_165 = arg0_165.localPosition.y + arg1_165

	return LeanTween.moveY(rtf(arg0_165), var0_165, arg2_165):setLoopPingPong(arg3_165 or 0)
end

local var10_0 = tostring

function tostring(arg0_166)
	if arg0_166 == nil then
		return "nil"
	end

	local var0_166 = var10_0(arg0_166)

	if var0_166 == nil then
		if type(arg0_166) == "table" then
			return "{}"
		end

		return " ~nil"
	end

	return var0_166
end

function wordVer(arg0_167, arg1_167)
	if arg0_167.match(arg0_167, ChatConst.EmojiCodeMatch) then
		return 0, arg0_167
	end

	arg1_167 = arg1_167 or {}

	local var0_167 = filterEgyUnicode(arg0_167)

	if #var0_167 ~= #arg0_167 then
		if arg1_167.isReplace then
			arg0_167 = var0_167
		else
			return 1
		end
	end

	local var1_167 = wordSplit(arg0_167)
	local var2_167 = pg.word_template
	local var3_167 = pg.word_legal_template

	arg1_167.isReplace = arg1_167.isReplace or false
	arg1_167.replaceWord = arg1_167.replaceWord or "*"

	local var4_167 = #var1_167
	local var5_167 = 1
	local var6_167 = ""
	local var7_167 = 0

	while var5_167 <= var4_167 do
		local var8_167, var9_167, var10_167 = wordLegalMatch(var1_167, var3_167, var5_167)

		if var8_167 then
			var5_167 = var9_167
			var6_167 = var6_167 .. var10_167
		else
			local var11_167, var12_167, var13_167 = wordVerMatch(var1_167, var2_167, arg1_167, var5_167, "", false, var5_167, "")

			if var11_167 then
				var5_167 = var12_167
				var7_167 = var7_167 + 1

				if arg1_167.isReplace then
					var6_167 = var6_167 .. var13_167
				end
			else
				if arg1_167.isReplace then
					var6_167 = var6_167 .. var1_167[var5_167]
				end

				var5_167 = var5_167 + 1
			end
		end
	end

	if arg1_167.isReplace then
		return var7_167, var6_167
	else
		return var7_167
	end
end

function wordLegalMatch(arg0_168, arg1_168, arg2_168, arg3_168, arg4_168)
	if arg2_168 > #arg0_168 then
		return arg3_168, arg2_168, arg4_168
	end

	local var0_168 = arg0_168[arg2_168]
	local var1_168 = arg1_168[var0_168]

	arg4_168 = arg4_168 == nil and "" or arg4_168

	if var1_168 then
		if var1_168.this then
			return wordLegalMatch(arg0_168, var1_168, arg2_168 + 1, true, arg4_168 .. var0_168)
		else
			return wordLegalMatch(arg0_168, var1_168, arg2_168 + 1, false, arg4_168 .. var0_168)
		end
	else
		return arg3_168, arg2_168, arg4_168
	end
end

local var11_0 = string.byte("a")
local var12_0 = string.byte("z")
local var13_0 = string.byte("A")
local var14_0 = string.byte("Z")

local function var15_0(arg0_169)
	if not arg0_169 then
		return arg0_169
	end

	local var0_169 = string.byte(arg0_169)

	if var0_169 > 128 then
		return
	end

	if var0_169 >= var11_0 and var0_169 <= var12_0 then
		return string.char(var0_169 - 32)
	elseif var0_169 >= var13_0 and var0_169 <= var14_0 then
		return string.char(var0_169 + 32)
	else
		return arg0_169
	end
end

function wordVerMatch(arg0_170, arg1_170, arg2_170, arg3_170, arg4_170, arg5_170, arg6_170, arg7_170)
	if arg3_170 > #arg0_170 then
		return arg5_170, arg6_170, arg7_170
	end

	local var0_170 = arg0_170[arg3_170]
	local var1_170 = arg1_170[var0_170]

	if var1_170 then
		local var2_170, var3_170, var4_170 = wordVerMatch(arg0_170, var1_170, arg2_170, arg3_170 + 1, arg2_170.isReplace and arg4_170 .. arg2_170.replaceWord or arg4_170, var1_170.this or arg5_170, var1_170.this and arg3_170 + 1 or arg6_170, var1_170.this and (arg2_170.isReplace and arg4_170 .. arg2_170.replaceWord or arg4_170) or arg7_170)

		if var2_170 then
			return var2_170, var3_170, var4_170
		end
	end

	local var5_170 = var15_0(var0_170)
	local var6_170 = arg1_170[var5_170]

	if var5_170 ~= var0_170 and var6_170 then
		local var7_170, var8_170, var9_170 = wordVerMatch(arg0_170, var6_170, arg2_170, arg3_170 + 1, arg2_170.isReplace and arg4_170 .. arg2_170.replaceWord or arg4_170, var6_170.this or arg5_170, var6_170.this and arg3_170 + 1 or arg6_170, var6_170.this and (arg2_170.isReplace and arg4_170 .. arg2_170.replaceWord or arg4_170) or arg7_170)

		if var7_170 then
			return var7_170, var8_170, var9_170
		end
	end

	return arg5_170, arg6_170, arg7_170
end

function wordSplit(arg0_171)
	local var0_171 = {}

	for iter0_171 in arg0_171.gmatch(arg0_171, "[\x01-\x7F�-�][�-�]*") do
		var0_171[#var0_171 + 1] = iter0_171
	end

	return var0_171
end

function contentWrap(arg0_172, arg1_172, arg2_172)
	local var0_172 = LuaHelper.WrapContent(arg0_172, arg1_172, arg2_172)

	return #var0_172 ~= #arg0_172, var0_172
end

function cancelRich(arg0_173)
	local var0_173

	for iter0_173 = 1, 20 do
		local var1_173

		arg0_173, var1_173 = string.gsub(arg0_173, "<([^>]*)>", "%1")

		if var1_173 <= 0 then
			break
		end
	end

	return arg0_173
end

function cancelColorRich(arg0_174)
	local var0_174

	for iter0_174 = 1, 20 do
		local var1_174

		arg0_174, var1_174 = string.gsub(arg0_174, "<color=#[a-zA-Z0-9]+>(.-)</color>", "%1")

		if var1_174 <= 0 then
			break
		end
	end

	return arg0_174
end

function getSkillConfig(arg0_175)
	local var0_175 = pg.buffCfg["buff_" .. arg0_175]

	if not var0_175 then
		return
	end

	local var1_175 = Clone(var0_175)

	var1_175.name = getSkillName(arg0_175)
	var1_175.desc = HXSet.hxLan(var1_175.desc)
	var1_175.desc_get = HXSet.hxLan(var1_175.desc_get)

	_.each(var1_175, function(arg0_176)
		arg0_176.desc = HXSet.hxLan(arg0_176.desc)
	end)

	return var1_175
end

function getSkillName(arg0_177)
	local var0_177 = pg.skill_data_template[arg0_177] or pg.skill_data_display[arg0_177]

	if var0_177 then
		return HXSet.hxLan(var0_177.name)
	else
		return ""
	end
end

function getSkillDescGet(arg0_178, arg1_178)
	local var0_178 = arg1_178 and pg.skill_world_display[arg0_178] and setmetatable({}, {
		__index = function(arg0_179, arg1_179)
			return pg.skill_world_display[arg0_178][arg1_179] or pg.skill_data_template[arg0_178][arg1_179]
		end
	}) or pg.skill_data_template[arg0_178]

	if not var0_178 then
		return ""
	end

	local var1_178 = var0_178.desc_get ~= "" and var0_178.desc_get or var0_178.desc

	for iter0_178, iter1_178 in pairs(var0_178.desc_get_add) do
		local var2_178 = setColorStr(iter1_178[1], COLOR_GREEN)

		if iter1_178[2] then
			var2_178 = var2_178 .. specialGSub(i18n("word_skill_desc_get"), "$1", setColorStr(iter1_178[2], COLOR_GREEN))
		end

		var1_178 = specialGSub(var1_178, "$" .. iter0_178, var2_178)
	end

	return HXSet.hxLan(var1_178)
end

function getSkillDescLearn(arg0_180, arg1_180, arg2_180)
	local var0_180 = arg2_180 and pg.skill_world_display[arg0_180] and setmetatable({}, {
		__index = function(arg0_181, arg1_181)
			return pg.skill_world_display[arg0_180][arg1_181] or pg.skill_data_template[arg0_180][arg1_181]
		end
	}) or pg.skill_data_template[arg0_180]

	if not var0_180 then
		return ""
	end

	local var1_180 = var0_180.desc

	if not var0_180.desc_add then
		return HXSet.hxLan(var1_180)
	end

	for iter0_180, iter1_180 in pairs(var0_180.desc_add) do
		local var2_180 = iter1_180[arg1_180][1]

		if iter1_180[arg1_180][2] then
			var2_180 = var2_180 .. specialGSub(i18n("word_skill_desc_learn"), "$1", iter1_180[arg1_180][2])
		end

		var1_180 = specialGSub(var1_180, "$" .. iter0_180, setColorStr(var2_180, COLOR_YELLOW))
	end

	return HXSet.hxLan(var1_180)
end

function getSkillDesc(arg0_182, arg1_182, arg2_182)
	local var0_182 = arg2_182 and pg.skill_world_display[arg0_182] and setmetatable({}, {
		__index = function(arg0_183, arg1_183)
			return pg.skill_world_display[arg0_182][arg1_183] or pg.skill_data_template[arg0_182][arg1_183]
		end
	}) or pg.skill_data_template[arg0_182]

	if not var0_182 then
		return ""
	end

	local var1_182 = var0_182.desc

	if not var0_182.desc_add then
		return HXSet.hxLan(var1_182)
	end

	for iter0_182, iter1_182 in pairs(var0_182.desc_add) do
		local var2_182 = setColorStr(iter1_182[arg1_182][1], COLOR_GREEN)

		var1_182 = specialGSub(var1_182, "$" .. iter0_182, var2_182)
	end

	return HXSet.hxLan(var1_182)
end

function specialGSub(arg0_184, arg1_184, arg2_184)
	arg0_184 = string.gsub(arg0_184, "<color=#", "<color=NNN")
	arg0_184 = string.gsub(arg0_184, "#", "")
	arg2_184 = string.gsub(arg2_184, "%%", "%%%%")
	arg0_184 = string.gsub(arg0_184, arg1_184, arg2_184)
	arg0_184 = string.gsub(arg0_184, "<color=NNN", "<color=#")

	return arg0_184
end

function topAnimation(arg0_185, arg1_185, arg2_185, arg3_185, arg4_185, arg5_185)
	local var0_185 = {}

	arg4_185 = arg4_185 or 0.27

	local var1_185 = 0.05

	if arg0_185 then
		local var2_185 = arg0_185.transform.localPosition.x

		setAnchoredPosition(arg0_185, {
			x = var2_185 - 500
		})
		shiftPanel(arg0_185, var2_185, nil, 0.05, arg4_185, true, true)
		setActive(arg0_185, true)
	end

	setActive(arg1_185, false)
	setActive(arg2_185, false)
	setActive(arg3_185, false)

	for iter0_185 = 1, 3 do
		table.insert(var0_185, LeanTween.delayedCall(arg4_185 + 0.13 + var1_185 * iter0_185, System.Action(function()
			if arg1_185 then
				setActive(arg1_185, not arg1_185.gameObject.activeSelf)
			end
		end)).uniqueId)
		table.insert(var0_185, LeanTween.delayedCall(arg4_185 + 0.02 + var1_185 * iter0_185, System.Action(function()
			if arg2_185 then
				setActive(arg2_185, not go(arg2_185).activeSelf)
			end

			if arg2_185 then
				setActive(arg3_185, not go(arg3_185).activeSelf)
			end
		end)).uniqueId)
	end

	if arg5_185 then
		table.insert(var0_185, LeanTween.delayedCall(arg4_185 + 0.13 + var1_185 * 3 + 0.1, System.Action(function()
			arg5_185()
		end)).uniqueId)
	end

	return var0_185
end

function cancelTweens(arg0_189)
	assert(arg0_189, "must provide cancel targets, LeanTween.cancelAll is not allow")

	for iter0_189, iter1_189 in ipairs(arg0_189) do
		if iter1_189 then
			LeanTween.cancel(iter1_189)
		end
	end
end

function getOfflineTimeStamp(arg0_190)
	local var0_190 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_190
	local var1_190 = ""

	if var0_190 <= 59 then
		var1_190 = i18n("just_now")
	elseif var0_190 <= 3599 then
		var1_190 = i18n("several_minutes_before", math.floor(var0_190 / 60))
	elseif var0_190 <= 86399 then
		var1_190 = i18n("several_hours_before", math.floor(var0_190 / 3600))
	else
		var1_190 = i18n("several_days_before", math.floor(var0_190 / 86400))
	end

	return var1_190
end

function playMovie(arg0_191, arg1_191, arg2_191)
	local var0_191 = GameObject.Find("OverlayCamera/Overlay/UITop/MoviePanel")

	if not IsNil(var0_191) then
		pg.UIMgr.GetInstance():LoadingOn()
		WWWLoader.Inst:LoadStreamingAsset(arg0_191, function(arg0_192)
			pg.UIMgr.GetInstance():LoadingOff()

			local var0_192 = GCHandle.Alloc(arg0_192, GCHandleType.Pinned)

			setActive(var0_191, true)

			local var1_192 = var0_191:AddComponent(typeof(CriManaMovieControllerForUI))

			var1_192.player:SetData(arg0_192, arg0_192.Length)

			var1_192.target = var0_191:GetComponent(typeof(Image))
			var1_192.loop = false
			var1_192.additiveMode = false
			var1_192.playOnStart = true

			local var2_192

			var2_192 = Timer.New(function()
				if var1_192.player.status == CriMana.Player.Status.PlayEnd or var1_192.player.status == CriMana.Player.Status.Stop or var1_192.player.status == CriMana.Player.Status.Error then
					var2_192:Stop()
					Object.Destroy(var1_192)
					GCHandle.Free(var0_192)
					setActive(var0_191, false)

					if arg1_191 then
						arg1_191()
					end
				end
			end, 0.2, -1)

			var2_192:Start()
			removeOnButton(var0_191)

			if arg2_191 then
				onButton(nil, var0_191, function()
					var1_192:Stop()
					GetOrAddComponent(var0_191, typeof(Button)).onClick:RemoveAllListeners()
				end, SFX_CANCEL)
			end
		end)
	elseif arg1_191 then
		arg1_191()
	end
end

PaintCameraAdjustOn = false

function cameraPaintViewAdjust(arg0_195)
	if PaintCameraAdjustOn ~= arg0_195 then
		local var0_195 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(CanvasScaler))

		if arg0_195 then
			CameraMgr.instance.AutoAdapt = false

			CameraMgr.instance:Revert()

			var0_195.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight
			var0_195.matchWidthOrHeight = 1
		else
			CameraMgr.instance.AutoAdapt = true
			CameraMgr.instance.CurrentWidth = 1
			CameraMgr.instance.CurrentHeight = 1
			CameraMgr.instance.AspectRatio = 1.77777777777778
			var0_195.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand
		end

		PaintCameraAdjustOn = arg0_195
	end
end

function ManhattonDist(arg0_196, arg1_196)
	return math.abs(arg0_196.row - arg1_196.row) + math.abs(arg0_196.column - arg1_196.column)
end

function checkFirstHelpShow(arg0_197)
	local var0_197 = getProxy(SettingsProxy)

	if not var0_197:checkReadHelp(arg0_197) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[arg0_197].tip
		})
		var0_197:recordReadHelp(arg0_197)
	end
end

preOrientation = nil
preNotchFitterEnabled = false

function openPortrait(arg0_198)
	enableNotch(arg0_198, true)

	preOrientation = Input.deviceOrientation:ToString()

	originalPrint("Begining Orientation:" .. preOrientation)

	Screen.autorotateToPortrait = true
	Screen.autorotateToPortraitUpsideDown = true

	cameraPaintViewAdjust(true)
end

function closePortrait(arg0_199)
	enableNotch(arg0_199, false)

	Screen.autorotateToPortrait = false
	Screen.autorotateToPortraitUpsideDown = false

	originalPrint("Closing Orientation:" .. preOrientation)

	Screen.orientation = ScreenOrientation.LandscapeLeft

	local var0_199 = Timer.New(function()
		Screen.orientation = ScreenOrientation.AutoRotation
	end, 0.2, 1):Start()

	cameraPaintViewAdjust(false)
end

function enableNotch(arg0_201, arg1_201)
	if arg0_201 == nil then
		return
	end

	local var0_201 = arg0_201:GetComponent("NotchAdapt")
	local var1_201 = arg0_201:GetComponent("AspectRatioFitter")

	var0_201.enabled = arg1_201

	if var1_201 then
		if arg1_201 then
			var1_201.enabled = preNotchFitterEnabled
		else
			preNotchFitterEnabled = var1_201.enabled
			var1_201.enabled = false
		end
	end
end

function comma_value(arg0_202)
	local var0_202 = arg0_202
	local var1_202 = 0

	repeat
		local var2_202

		var0_202, var2_202 = string.gsub(var0_202, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var2_202 == 0

	return var0_202
end

local var16_0 = 0.2

function SwitchPanel(arg0_203, arg1_203, arg2_203, arg3_203, arg4_203, arg5_203)
	arg3_203 = defaultValue(arg3_203, var16_0)

	if arg5_203 then
		LeanTween.cancel(go(arg0_203))
	end

	local var0_203 = Vector3.New(tf(arg0_203).localPosition.x, tf(arg0_203).localPosition.y, tf(arg0_203).localPosition.z)

	if arg1_203 then
		var0_203.x = arg1_203
	end

	if arg2_203 then
		var0_203.y = arg2_203
	end

	local var1_203 = LeanTween.move(rtf(arg0_203), var0_203, arg3_203):setEase(LeanTweenType.easeInOutSine)

	if arg4_203 then
		var1_203:setDelay(arg4_203)
	end

	return var1_203
end

function updateActivityTaskStatus(arg0_204)
	local var0_204 = arg0_204:getConfig("config_id")
	local var1_204, var2_204 = getActivityTask(arg0_204, true)

	if not var2_204 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_204.id
		})

		return true
	end

	return false
end

function updateCrusingActivityTask(arg0_205)
	local var0_205 = getProxy(TaskProxy)
	local var1_205 = arg0_205:getNDay()
	local var2_205 = pg.TimeMgr.GetInstance():GetServerOverWeek(arg0_205:getStartTime())

	for iter0_205, iter1_205 in ipairs(arg0_205:getConfig("config_data")) do
		local var3_205 = pg.battlepass_task_group[iter1_205]

		if var3_205 and var2_205 >= var3_205.group_mask then
			if underscore.any(underscore.flatten(var3_205.task_group), function(arg0_206)
				return var0_205:getTaskVO(arg0_206) == nil
			end) then
				pg.m02:sendNotification(GAME.CRUSING_CMD, {
					cmd = 1,
					activity_id = arg0_205.id
				})

				return true
			end
		elseif not var3_205 then
			warning("battlepass_task_group表中不存在 id = " .. iter1_205)
		end
	end

	return false
end

function setShipCardFrame(arg0_207, arg1_207, arg2_207)
	arg0_207.localScale = Vector3.one
	arg0_207.anchorMin = Vector2.zero
	arg0_207.anchorMax = Vector2.one

	local var0_207 = arg2_207 or arg1_207

	GetImageSpriteFromAtlasAsync("shipframe", var0_207, arg0_207)

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

function setRectShipCardFrame(arg0_208, arg1_208, arg2_208)
	arg0_208.localScale = Vector3.one
	arg0_208.anchorMin = Vector2.zero
	arg0_208.anchorMax = Vector2.one

	setImageSprite(arg0_208, GetSpriteFromAtlas("shipframeb", "b" .. (arg2_208 or arg1_208)))

	local var0_208 = "b" .. (arg2_208 or arg1_208)
	local var1_208 = pg.frame_resource[var0_208]

	if var1_208 then
		local var2_208 = var1_208.param

		arg0_208.offsetMin = Vector2(var2_208[1], var2_208[2])
		arg0_208.offsetMax = Vector2(var2_208[3], var2_208[4])
	else
		arg0_208.offsetMin = Vector2.zero
		arg0_208.offsetMax = Vector2.zero
	end
end

function setFrameEffect(arg0_209, arg1_209)
	if arg1_209 then
		local var0_209 = arg1_209 .. "(Clone)"
		local var1_209 = false

		eachChild(arg0_209, function(arg0_210)
			setActive(arg0_210, arg0_210.name == var0_209)

			var1_209 = var1_209 or arg0_210.name == var0_209
		end)

		if not var1_209 then
			LoadAndInstantiateAsync("effect", arg1_209, function(arg0_211)
				if IsNil(arg0_209) or findTF(arg0_209, var0_209) then
					Object.Destroy(arg0_211)
				else
					setParent(arg0_211, arg0_209)
					setActive(arg0_211, true)
				end
			end)
		end
	end

	setActive(arg0_209, arg1_209)
end

function setProposeMarkIcon(arg0_212, arg1_212)
	local var0_212 = arg0_212:Find("proposeShipCard(Clone)")
	local var1_212 = arg1_212.propose and not arg1_212:ShowPropose()

	if var0_212 then
		setActive(var0_212, var1_212)
	elseif var1_212 then
		pg.PoolMgr.GetInstance():GetUI("proposeShipCard", true, function(arg0_213)
			if IsNil(arg0_212) or arg0_212:Find("proposeShipCard(Clone)") then
				pg.PoolMgr.GetInstance():ReturnUI("proposeShipCard", arg0_213)
			else
				setParent(arg0_213, arg0_212, false)
			end
		end)
	end
end

function flushShipCard(arg0_214, arg1_214)
	local var0_214 = arg1_214:rarity2bgPrint()
	local var1_214 = findTF(arg0_214, "content/bg")

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var0_214, "", var1_214)

	local var2_214 = findTF(arg0_214, "content/ship_icon")
	local var3_214 = arg1_214 and {
		"shipYardIcon/" .. arg1_214:getPainting(),
		arg1_214:getPainting()
	} or {
		"shipYardIcon/unknown",
		""
	}

	GetImageSpriteFromAtlasAsync(var3_214[1], var3_214[2], var2_214)

	local var4_214 = arg1_214:getShipType()
	local var5_214 = findTF(arg0_214, "content/info/top/type")

	GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var4_214), var5_214)
	setText(findTF(arg0_214, "content/dockyard/lv/Text"), defaultValue(arg1_214.level, 1))

	local var6_214 = arg1_214:getStar()
	local var7_214 = arg1_214:getMaxStar()
	local var8_214 = findTF(arg0_214, "content/front/stars")

	setActive(var8_214, true)

	local var9_214 = findTF(var8_214, "star_tpl")
	local var10_214 = var8_214.childCount

	for iter0_214 = 1, Ship.CONFIG_MAX_STAR do
		local var11_214 = var10_214 < iter0_214 and cloneTplTo(var9_214, var8_214) or var8_214:GetChild(iter0_214 - 1)

		setActive(var11_214, iter0_214 <= var7_214)
		triggerToggle(var11_214, iter0_214 <= var6_214)
	end

	local var12_214 = findTF(arg0_214, "content/front/frame")
	local var13_214, var14_214 = arg1_214:GetFrameAndEffect()

	setShipCardFrame(var12_214, var0_214, var13_214)
	setFrameEffect(findTF(arg0_214, "content/front/bg_other"), var14_214)
	setProposeMarkIcon(arg0_214:Find("content/dockyard/propose"), arg1_214)
end

function TweenItemAlphaAndWhite(arg0_215)
	LeanTween.cancel(arg0_215)

	local var0_215 = GetOrAddComponent(arg0_215, "CanvasGroup")

	var0_215.alpha = 0

	LeanTween.alphaCanvas(var0_215, 1, 0.2):setUseEstimatedTime(true)

	local var1_215 = findTF(arg0_215.transform, "white_mask")

	if var1_215 then
		setActive(var1_215, false)
	end
end

function ClearTweenItemAlphaAndWhite(arg0_216)
	LeanTween.cancel(arg0_216)

	GetOrAddComponent(arg0_216, "CanvasGroup").alpha = 0
end

function getGroupOwnSkins(arg0_217)
	local var0_217 = {}
	local var1_217 = getProxy(ShipSkinProxy):getSkinList()
	local var2_217 = getProxy(CollectionProxy):getShipGroup(arg0_217)

	if var2_217 then
		local var3_217 = ShipGroup.getSkinList(arg0_217)

		for iter0_217, iter1_217 in ipairs(var3_217) do
			if iter1_217.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var1_217, iter1_217.id) or iter1_217.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var2_217.trans or iter1_217.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var2_217.married == 1 then
				var0_217[iter1_217.id] = true
			end
		end
	end

	return var0_217
end

function split(arg0_218, arg1_218)
	local var0_218 = {}

	if not arg0_218 then
		return nil
	end

	local var1_218 = #arg0_218
	local var2_218 = 1

	while var2_218 <= var1_218 do
		local var3_218 = string.find(arg0_218, arg1_218, var2_218)

		if var3_218 == nil then
			table.insert(var0_218, string.sub(arg0_218, var2_218, var1_218))

			break
		end

		table.insert(var0_218, string.sub(arg0_218, var2_218, var3_218 - 1))

		if var3_218 == var1_218 then
			table.insert(var0_218, "")

			break
		end

		var2_218 = var3_218 + 1
	end

	return var0_218
end

function NumberToChinese(arg0_219, arg1_219)
	local var0_219 = ""
	local var1_219 = #arg0_219

	for iter0_219 = 1, var1_219 do
		local var2_219 = string.sub(arg0_219, iter0_219, iter0_219)

		if var2_219 ~= "0" or var2_219 == "0" and not arg1_219 then
			if arg1_219 then
				if var1_219 >= 2 then
					if iter0_219 == 1 then
						if var2_219 == "1" then
							var0_219 = i18n("number_" .. 10)
						else
							var0_219 = i18n("number_" .. var2_219) .. i18n("number_" .. 10)
						end
					else
						var0_219 = var0_219 .. i18n("number_" .. var2_219)
					end
				else
					var0_219 = var0_219 .. i18n("number_" .. var2_219)
				end
			else
				var0_219 = var0_219 .. i18n("number_" .. var2_219)
			end
		end
	end

	return var0_219
end

function getActivityTask(arg0_220, arg1_220)
	local var0_220 = getProxy(TaskProxy)
	local var1_220 = arg0_220:getConfig("config_data")
	local var2_220 = arg0_220:getNDay(arg0_220.data1)
	local var3_220
	local var4_220
	local var5_220

	for iter0_220 = math.max(arg0_220.data3, 1), math.min(var2_220, #var1_220) do
		local var6_220 = _.flatten({
			var1_220[iter0_220]
		})

		for iter1_220, iter2_220 in ipairs(var6_220) do
			local var7_220 = var0_220:getTaskById(iter2_220)

			if var7_220 then
				return var7_220.id, var7_220
			end

			if var4_220 then
				var5_220 = var0_220:getFinishTaskById(iter2_220)

				if var5_220 then
					var4_220 = var5_220
				elseif arg1_220 then
					return iter2_220
				else
					return var4_220.id, var4_220
				end
			else
				var4_220 = var0_220:getFinishTaskById(iter2_220)
				var5_220 = var5_220 or iter2_220
			end
		end
	end

	if var4_220 then
		return var4_220.id, var4_220
	else
		return var5_220
	end
end

function setImageFromImage(arg0_221, arg1_221, arg2_221)
	local var0_221 = GetComponent(arg0_221, "Image")

	var0_221.sprite = GetComponent(arg1_221, "Image").sprite

	if arg2_221 then
		var0_221:SetNativeSize()
	end
end

function skinTimeStamp(arg0_222)
	local var0_222, var1_222, var2_222, var3_222 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_222)

	if var0_222 >= 1 then
		return i18n("limit_skin_time_day", var0_222)
	elseif var0_222 <= 0 and var1_222 > 0 then
		return i18n("limit_skin_time_day_min", var1_222, var2_222)
	elseif var0_222 <= 0 and var1_222 <= 0 and (var2_222 > 0 or var3_222 > 0) then
		return i18n("limit_skin_time_min", math.max(var2_222, 1))
	elseif var0_222 <= 0 and var1_222 <= 0 and var2_222 <= 0 and var3_222 <= 0 then
		return i18n("limit_skin_time_overtime")
	end
end

function skinCommdityTimeStamp(arg0_223)
	local var0_223 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_223 = math.max(arg0_223 - var0_223, 0)
	local var2_223 = math.floor(var1_223 / 86400)

	if var2_223 > 0 then
		return i18n("time_remaining_tip") .. var2_223 .. i18n("word_date")
	else
		local var3_223 = math.floor(var1_223 / 3600)

		if var3_223 > 0 then
			return i18n("time_remaining_tip") .. var3_223 .. i18n("word_hour")
		else
			local var4_223 = math.floor(var1_223 / 60)

			if var4_223 > 0 then
				return i18n("time_remaining_tip") .. var4_223 .. i18n("word_minute")
			else
				return i18n("time_remaining_tip") .. var1_223 .. i18n("word_second")
			end
		end
	end
end

function InstagramTimeStamp(arg0_224)
	local var0_224 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_224
	local var1_224 = var0_224 / 86400

	if var1_224 > 1 then
		return i18n("ins_word_day", math.floor(var1_224))
	else
		local var2_224 = var0_224 / 3600

		if var2_224 > 1 then
			return i18n("ins_word_hour", math.floor(var2_224))
		else
			local var3_224 = var0_224 / 60

			if var3_224 > 1 then
				return i18n("ins_word_minu", math.floor(var3_224))
			else
				return i18n("ins_word_minu", 1)
			end
		end
	end
end

function InstagramReplyTimeStamp(arg0_225)
	local var0_225 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_225
	local var1_225 = var0_225 / 86400

	if var1_225 > 1 then
		return i18n1(math.floor(var1_225) .. "d")
	else
		local var2_225 = var0_225 / 3600

		if var2_225 > 1 then
			return i18n1(math.floor(var2_225) .. "h")
		else
			local var3_225 = var0_225 / 60

			if var3_225 > 1 then
				return i18n1(math.floor(var3_225) .. "min")
			else
				return i18n1("1min")
			end
		end
	end
end

function attireTimeStamp(arg0_226)
	local var0_226, var1_226, var2_226, var3_226 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_226)

	if var0_226 <= 0 and var1_226 <= 0 and var2_226 <= 0 and var3_226 <= 0 then
		return i18n("limit_skin_time_overtime")
	else
		return i18n("attire_time_stamp", var0_226, var1_226, var2_226)
	end
end

function checkExist(arg0_227, ...)
	local var0_227 = {
		...
	}

	for iter0_227, iter1_227 in ipairs(var0_227) do
		if arg0_227 == nil then
			break
		end

		assert(type(arg0_227) == "table", "type error : intermediate target should be table")
		assert(type(iter1_227) == "table", "type error : param should be table")

		if type(arg0_227[iter1_227[1]]) == "function" then
			arg0_227 = arg0_227[iter1_227[1]](arg0_227, unpack(iter1_227[2] or {}))
		else
			arg0_227 = arg0_227[iter1_227[1]]
		end
	end

	return arg0_227
end

function AcessWithinNull(arg0_228, arg1_228)
	if arg0_228 == nil then
		return
	end

	assert(type(arg0_228) == "table")

	return arg0_228[arg1_228]
end

function showRepairMsgbox()
	local var0_229 = {
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var1_229 = {
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var2_229 = {
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
			var2_229,
			var1_229,
			var0_229
		}
	})
end

function resourceVerify(arg0_233, arg1_233)
	if CSharpVersion > 35 then
		BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()

		return
	end

	local var0_233 = Application.persistentDataPath .. "/hashes.csv"
	local var1_233
	local var2_233 = PathMgr.ReadAllLines(var0_233)
	local var3_233 = {}

	if arg0_233 then
		setActive(arg0_233, true)
	else
		pg.UIMgr.GetInstance():LoadingOn()
	end

	local function var4_233()
		if arg0_233 then
			setActive(arg0_233, false)
		else
			pg.UIMgr.GetInstance():LoadingOff()
		end

		print(var1_233)

		if var1_233 then
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

	local var5_233 = var2_233.Length
	local var6_233

	local function var7_233(arg0_236)
		if arg0_236 < 0 then
			var4_233()

			return
		end

		if arg1_233 then
			setSlider(arg1_233, 0, var5_233, var5_233 - arg0_236)
		end

		local var0_236 = string.split(var2_233[arg0_236], ",")
		local var1_236 = var0_236[1]
		local var2_236 = var0_236[3]
		local var3_236 = PathMgr.getAssetBundle(var1_236)

		if PathMgr.FileExists(var3_236) then
			local var4_236 = PathMgr.ReadAllBytes(PathMgr.getAssetBundle(var1_236))

			if var2_236 == HashUtil.CalcMD5(var4_236) then
				onNextTick(function()
					var7_233(arg0_236 - 1)
				end)

				return
			end
		end

		var1_233 = var1_236

		var4_233()
	end

	var7_233(var5_233 - 1)
end

function splitByWordEN(arg0_238, arg1_238)
	local var0_238 = string.split(arg0_238, " ")
	local var1_238 = ""
	local var2_238 = ""
	local var3_238 = arg1_238:GetComponent(typeof(RectTransform))
	local var4_238 = arg1_238:GetComponent(typeof(Text))
	local var5_238 = var3_238.rect.width

	for iter0_238, iter1_238 in ipairs(var0_238) do
		local var6_238 = var2_238

		var2_238 = var2_238 == "" and iter1_238 or var2_238 .. " " .. iter1_238

		setText(arg1_238, var2_238)

		if var5_238 < var4_238.preferredWidth then
			var1_238 = var1_238 == "" and var6_238 or var1_238 .. "\n" .. var6_238
			var2_238 = iter1_238
		end

		if iter0_238 >= #var0_238 then
			var1_238 = var1_238 == "" and var2_238 or var1_238 .. "\n" .. var2_238
		end
	end

	return var1_238
end

function checkBirthFormat(arg0_239)
	if #arg0_239 ~= 8 then
		return false
	end

	local var0_239 = 0
	local var1_239 = #arg0_239

	while var0_239 < var1_239 do
		local var2_239 = string.byte(arg0_239, var0_239 + 1)

		if var2_239 < 48 or var2_239 > 57 then
			return false
		end

		var0_239 = var0_239 + 1
	end

	return true
end

function isHalfBodyLive2D(arg0_240)
	local var0_240 = {
		"biaoqiang",
		"z23",
		"lafei",
		"lingbo",
		"mingshi",
		"xuefeng"
	}

	return _.any(var0_240, function(arg0_241)
		return arg0_241 == arg0_240
	end)
end

function GetServerState(arg0_242)
	local var0_242 = -1
	local var1_242 = 0
	local var2_242 = 1
	local var3_242 = 2
	local var4_242 = NetConst.GetServerStateUrl()

	if PLATFORM_CODE == PLATFORM_CH then
		var4_242 = string.gsub(var4_242, "https", "http")
	end

	VersionMgr.Inst:WebRequest(var4_242, function(arg0_243, arg1_243)
		local var0_243 = true
		local var1_243 = false

		for iter0_243 in string.gmatch(arg1_243, "\"state\":%d") do
			if iter0_243 ~= "\"state\":1" then
				var0_243 = false
			end

			var1_243 = true
		end

		if not var1_243 then
			var0_243 = false
		end

		if arg0_242 ~= nil then
			arg0_242(var0_243 and var2_242 or var1_242)
		end
	end)
end

function setScrollText(arg0_244, arg1_244)
	GetOrAddComponent(arg0_244, "ScrollText"):SetText(arg1_244)
end

function changeToScrollText(arg0_245, arg1_245)
	local var0_245 = GetComponent(arg0_245, typeof(Text))

	assert(var0_245, "without component<Text>")

	local var1_245 = arg0_245:Find("subText")

	if not var1_245 then
		var1_245 = cloneTplTo(arg0_245, arg0_245, "subText")

		eachChild(arg0_245, function(arg0_246)
			setActive(arg0_246, arg0_246 == var1_245)
		end)

		arg0_245:GetComponent(typeof(Text)).enabled = false
	end

	setScrollText(var1_245, arg1_245)
end

local var17_0
local var18_0
local var19_0
local var20_0

local function var21_0(arg0_247, arg1_247, arg2_247)
	local var0_247 = arg0_247:Find("base")
	local var1_247, var2_247, var3_247 = Equipment.GetInfoTrans(arg1_247, arg2_247)

	if arg1_247.nextValue then
		local var4_247 = {
			name = arg1_247.name,
			type = arg1_247.type,
			value = arg1_247.nextValue
		}
		local var5_247, var6_247 = Equipment.GetInfoTrans(var4_247, arg2_247)

		var2_247 = var2_247 .. setColorStr("   >   " .. var6_247, COLOR_GREEN)
	end

	setText(var0_247:Find("name"), var1_247)

	if var3_247 then
		local var7_247 = "<color=#afff72>(+" .. ys.Battle.BattleConst.UltimateBonus.AuxBoostValue * 100 .. "%)</color>"

		setText(var0_247:Find("value"), var2_247 .. var7_247)
	else
		setText(var0_247:Find("value"), var2_247)
	end

	setActive(var0_247:Find("value/up"), arg1_247.compare and arg1_247.compare > 0)
	setActive(var0_247:Find("value/down"), arg1_247.compare and arg1_247.compare < 0)
	triggerToggle(var0_247, arg1_247.lock_open)

	if not arg1_247.lock_open and arg1_247.sub and #arg1_247.sub > 0 then
		GetComponent(var0_247, typeof(Toggle)).enabled = true
	else
		setActive(var0_247:Find("name/close"), false)
		setActive(var0_247:Find("name/open"), false)

		GetComponent(var0_247, typeof(Toggle)).enabled = false
	end
end

local function var22_0(arg0_248, arg1_248, arg2_248, arg3_248)
	var21_0(arg0_248, arg2_248, arg3_248)

	if not arg2_248.sub or #arg2_248.sub == 0 then
		return
	end

	var19_0(arg0_248:Find("subs"), arg1_248, arg2_248.sub, arg3_248)
end

function var19_0(arg0_249, arg1_249, arg2_249, arg3_249)
	removeAllChildren(arg0_249)
	var20_0(arg0_249, arg1_249, arg2_249, arg3_249)
end

function var20_0(arg0_250, arg1_250, arg2_250, arg3_250)
	for iter0_250, iter1_250 in ipairs(arg2_250) do
		local var0_250 = cloneTplTo(arg1_250, arg0_250)

		var22_0(var0_250, arg1_250, iter1_250, arg3_250)
	end
end

function updateEquipInfo(arg0_251, arg1_251, arg2_251, arg3_251)
	local var0_251 = arg0_251:Find("attr_tpl")

	var19_0(arg0_251:Find("attrs"), var0_251, arg1_251.attrs, arg3_251)
	setActive(arg0_251:Find("skill"), arg2_251)

	if arg2_251 then
		var22_0(arg0_251:Find("skill/attr"), var0_251, {
			name = i18n("skill"),
			value = setColorStr(arg2_251.name, "#FFDE00FF")
		}, arg3_251)
		setText(arg0_251:Find("skill/value/Text"), getSkillDescGet(arg2_251.id))
	end

	setActive(arg0_251:Find("weapon"), #arg1_251.weapon.sub > 0)

	if #arg1_251.weapon.sub > 0 then
		var19_0(arg0_251:Find("weapon"), var0_251, {
			arg1_251.weapon
		}, arg3_251)
	end

	setActive(arg0_251:Find("equip_info"), #arg1_251.equipInfo.sub > 0)

	if #arg1_251.equipInfo.sub > 0 then
		var19_0(arg0_251:Find("equip_info"), var0_251, {
			arg1_251.equipInfo
		}, arg3_251)
	end

	var22_0(arg0_251:Find("part/attr"), var0_251, {
		name = i18n("equip_info_23")
	}, arg3_251)

	local var1_251 = arg0_251:Find("part/value")
	local var2_251 = var1_251:Find("label")
	local var3_251 = {}
	local var4_251 = {}

	if #arg1_251.part[1] == 0 and #arg1_251.part[2] == 0 then
		setmetatable(var3_251, {
			__index = function(arg0_252, arg1_252)
				return true
			end
		})
		setmetatable(var4_251, {
			__index = function(arg0_253, arg1_253)
				return true
			end
		})
	else
		for iter0_251, iter1_251 in ipairs(arg1_251.part[1]) do
			var3_251[iter1_251] = true
		end

		for iter2_251, iter3_251 in ipairs(arg1_251.part[2]) do
			var4_251[iter3_251] = true
		end
	end

	local var5_251 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var3_251, var4_251)

	UIItemList.StaticAlign(var1_251, var2_251, #var5_251, function(arg0_254, arg1_254, arg2_254)
		arg1_254 = arg1_254 + 1

		if arg0_254 == UIItemList.EventUpdate then
			local var0_254 = var5_251[arg1_254]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0_254), arg2_254)
			setActive(arg2_254:Find("main"), var3_251[var0_254] and not var4_251[var0_254])
			setActive(arg2_254:Find("sub"), var4_251[var0_254] and not var3_251[var0_254])
			setImageAlpha(arg2_254, not var3_251[var0_254] and not var4_251[var0_254] and 0.3 or 1)
		end
	end)
end

function updateEquipUpgradeInfo(arg0_255, arg1_255, arg2_255)
	local var0_255 = arg0_255:Find("attr_tpl")

	var19_0(arg0_255:Find("attrs"), var0_255, arg1_255.attrs, arg2_255)
	setActive(arg0_255:Find("weapon"), #arg1_255.weapon.sub > 0)

	if #arg1_255.weapon.sub > 0 then
		var19_0(arg0_255:Find("weapon"), var0_255, {
			arg1_255.weapon
		}, arg2_255)
	end

	setActive(arg0_255:Find("equip_info"), #arg1_255.equipInfo.sub > 0)

	if #arg1_255.equipInfo.sub > 0 then
		var19_0(arg0_255:Find("equip_info"), var0_255, {
			arg1_255.equipInfo
		}, arg2_255)
	end
end

function setCanvasOverrideSorting(arg0_256, arg1_256)
	local var0_256 = arg0_256.parent

	arg0_256:SetParent(pg.LayerWeightMgr.GetInstance().uiOrigin, false)

	if isActive(arg0_256) then
		GetOrAddComponent(arg0_256, typeof(Canvas)).overrideSorting = arg1_256
	else
		setActive(arg0_256, true)

		GetOrAddComponent(arg0_256, typeof(Canvas)).overrideSorting = arg1_256

		setActive(arg0_256, false)
	end

	arg0_256:SetParent(var0_256, false)
end

function createNewGameObject(arg0_257, arg1_257)
	local var0_257 = GameObject.New()

	if arg0_257 then
		var0_257.name = "model"
	end

	var0_257.layer = arg1_257 or Layer.UI

	return GetOrAddComponent(var0_257, "RectTransform")
end

function CreateShell(arg0_258)
	if type(arg0_258) ~= "table" and type(arg0_258) ~= "userdata" then
		return arg0_258
	end

	local var0_258 = setmetatable({
		__index = arg0_258
	}, arg0_258)

	return setmetatable({}, var0_258)
end

function CameraFittingSettin(arg0_259)
	local var0_259 = GetComponent(arg0_259, typeof(Camera))
	local var1_259 = 1.77777777777778
	local var2_259 = Screen.width / Screen.height

	if var2_259 < var1_259 then
		local var3_259 = var2_259 / var1_259

		var0_259.rect = var0_0.Rect.New(0, (1 - var3_259) / 2, 1, var3_259)
	end
end

function SwitchSpecialChar(arg0_260, arg1_260)
	if PLATFORM_CODE ~= PLATFORM_US then
		arg0_260 = arg0_260:gsub(" ", " ")
		arg0_260 = arg0_260:gsub("\t", "    ")
	end

	if not arg1_260 then
		arg0_260 = arg0_260:gsub("\n", " ")
	end

	return arg0_260
end

function AfterCheck(arg0_261, arg1_261)
	local var0_261 = {}

	for iter0_261, iter1_261 in ipairs(arg0_261) do
		var0_261[iter0_261] = iter1_261[1]()
	end

	arg1_261()

	for iter2_261, iter3_261 in ipairs(arg0_261) do
		if var0_261[iter2_261] ~= iter3_261[1]() then
			iter3_261[2]()
		end

		var0_261[iter2_261] = iter3_261[1]()
	end
end

function CompareFuncs(arg0_262, arg1_262)
	local var0_262 = {}

	local function var1_262(arg0_263, arg1_263)
		var0_262[arg0_263] = var0_262[arg0_263] or {}
		var0_262[arg0_263][arg1_263] = var0_262[arg0_263][arg1_263] or arg0_262[arg0_263](arg1_263)

		return var0_262[arg0_263][arg1_263]
	end

	return function(arg0_264, arg1_264)
		local var0_264 = 1

		while var0_264 <= #arg0_262 do
			local var1_264 = var1_262(var0_264, arg0_264)
			local var2_264 = var1_262(var0_264, arg1_264)

			if var1_264 == var2_264 then
				var0_264 = var0_264 + 1
			else
				return var1_264 < var2_264
			end
		end

		return tobool(arg1_262)
	end
end

function DropResultIntegration(arg0_265)
	local var0_265 = {}
	local var1_265 = 1

	while var1_265 <= #arg0_265 do
		local var2_265 = arg0_265[var1_265].type
		local var3_265 = arg0_265[var1_265].id

		var0_265[var2_265] = var0_265[var2_265] or {}

		if var0_265[var2_265][var3_265] then
			local var4_265 = arg0_265[var0_265[var2_265][var3_265]]
			local var5_265 = table.remove(arg0_265, var1_265)

			var4_265.count = var4_265.count + var5_265.count
		else
			var0_265[var2_265][var3_265] = var1_265
			var1_265 = var1_265 + 1
		end
	end

	local var6_265 = {
		function(arg0_266)
			local var0_266 = arg0_266.type
			local var1_266 = arg0_266.id

			if var0_266 == DROP_TYPE_SHIP then
				return 1
			elseif var0_266 == DROP_TYPE_RESOURCE then
				if var1_266 == 1 then
					return 2
				else
					return 3
				end
			elseif var0_266 == DROP_TYPE_ITEM then
				if var1_266 == 59010 then
					return 4
				elseif var1_266 == 59900 then
					return 5
				else
					local var2_266 = Item.getConfigData(var1_266)
					local var3_266 = var2_266 and var2_266.type or 0

					if var3_266 == 9 then
						return 6
					elseif var3_266 == 5 then
						return 7
					elseif var3_266 == 4 then
						return 8
					elseif var3_266 == 7 then
						return 9
					end
				end
			elseif var0_266 == DROP_TYPE_VITEM and var1_266 == 59011 then
				return 4
			end

			return 100
		end,
		function(arg0_267)
			local var0_267

			if arg0_267.type == DROP_TYPE_SHIP then
				var0_267 = pg.ship_data_statistics[arg0_267.id]
			elseif arg0_267.type == DROP_TYPE_ITEM then
				var0_267 = Item.getConfigData(arg0_267.id)
			end

			return (var0_267 and var0_267.rarity or 0) * -1
		end,
		function(arg0_268)
			return arg0_268.id
		end
	}

	table.sort(arg0_265, CompareFuncs(var6_265))
end

function getLoginConfig()
	local var0_269 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_269 = 1

	for iter0_269, iter1_269 in ipairs(pg.login.all) do
		if pg.login[iter1_269].date ~= "stop" then
			local var2_269, var3_269 = parseTimeConfig(pg.login[iter1_269].date)

			assert(not var3_269)

			if pg.TimeMgr.GetInstance():inTime(var2_269, var0_269) then
				var1_269 = iter1_269

				break
			end
		end
	end

	local var4_269 = pg.login[var1_269].login_static

	var4_269 = var4_269 ~= "" and var4_269 or "login"

	local var5_269 = pg.login[var1_269].login_cri
	local var6_269 = var5_269 ~= "" and true or false
	local var7_269 = pg.login[var1_269].op_play == 1 and true or false
	local var8_269 = pg.login[var1_269].op_time

	if var8_269 == "" or not pg.TimeMgr.GetInstance():inTime(var8_269, var0_269) then
		var7_269 = false
	end

	local var9_269 = var8_269 == "" and var8_269 or table.concat(var8_269[1][1])

	return var6_269, var6_269 and var5_269 or var4_269, pg.login[var1_269].bgm, var7_269, var9_269
end

function setIntimacyIcon(arg0_270, arg1_270, arg2_270)
	local var0_270 = {}
	local var1_270

	seriesAsync({
		function(arg0_271)
			if arg0_270.childCount > 0 then
				var1_270 = arg0_270:GetChild(0)

				arg0_271()
			else
				LoadAndInstantiateAsync("template", "intimacytpl", function(arg0_272)
					var1_270 = tf(arg0_272)

					setParent(var1_270, arg0_270)
					arg0_271()
				end)
			end
		end,
		function(arg0_273)
			setImageAlpha(var1_270, arg2_270 and 0 or 1)
			eachChild(var1_270, function(arg0_274)
				setActive(arg0_274, false)
			end)

			if arg2_270 then
				local var0_273 = var1_270:Find(arg2_270 .. "(Clone)")

				if not var0_273 then
					LoadAndInstantiateAsync("ui", arg2_270, function(arg0_275)
						setParent(arg0_275, var1_270)
						setActive(arg0_275, true)
					end)
				else
					setActive(var0_273, true)
				end
			elseif arg1_270 then
				setImageSprite(var1_270, GetSpriteFromAtlas("energy", arg1_270), true)
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

function switch(arg0_278, arg1_278, arg2_278, ...)
	if arg1_278[arg0_278] then
		return arg1_278[arg0_278](...)
	elseif arg2_278 then
		return arg2_278(...)
	end
end

function parseTimeConfig(arg0_279)
	if type(arg0_279[1]) == "table" then
		return arg0_279[2], arg0_279[1]
	else
		return arg0_279
	end
end

local var24_0 = {
	__add = function(arg0_280, arg1_280)
		return NewPos(arg0_280.x + arg1_280.x, arg0_280.y + arg1_280.y)
	end,
	__sub = function(arg0_281, arg1_281)
		return NewPos(arg0_281.x - arg1_281.x, arg0_281.y - arg1_281.y)
	end,
	__mul = function(arg0_282, arg1_282)
		if type(arg1_282) == "number" then
			return NewPos(arg0_282.x * arg1_282, arg0_282.y * arg1_282)
		else
			return NewPos(arg0_282.x * arg1_282.x, arg0_282.y * arg1_282.y)
		end
	end,
	__eq = function(arg0_283, arg1_283)
		return arg0_283.x == arg1_283.x and arg0_283.y == arg1_283.y
	end,
	__tostring = function(arg0_284)
		return arg0_284.x .. "_" .. arg0_284.y
	end
}

function NewPos(arg0_285, arg1_285)
	assert(arg0_285 and arg1_285)

	local var0_285 = setmetatable({
		x = arg0_285,
		y = arg1_285
	}, var24_0)

	function var0_285.SqrMagnitude(arg0_286)
		return arg0_286.x * arg0_286.x + arg0_286.y * arg0_286.y
	end

	function var0_285.Normalize(arg0_287)
		local var0_287 = arg0_287:SqrMagnitude()

		if var0_287 > 1e-05 then
			return arg0_287 * (1 / math.sqrt(var0_287))
		else
			return NewPos(0, 0)
		end
	end

	return var0_285
end

local var25_0

function Timekeeping()
	warning(Time.realtimeSinceStartup - (var25_0 or Time.realtimeSinceStartup), Time.realtimeSinceStartup)

	var25_0 = Time.realtimeSinceStartup
end

function GetRomanDigit(arg0_289)
	return (string.char(226, 133, 160 + (arg0_289 - 1)))
end

function quickPlayAnimator(arg0_290, arg1_290)
	arg0_290:GetComponent(typeof(Animator)):Play(arg1_290, -1, 0)
end

function quickCheckAndPlayAnimator(arg0_291, arg1_291)
	local var0_291 = arg0_291:GetComponent(typeof(Animator))
	local var1_291 = Animator.StringToHash(arg1_291)

	if var0_291:HasState(0, var1_291) then
		var0_291:Play(arg1_291, -1, 0)
	end
end

function quickPlayAnimation(arg0_292, arg1_292)
	arg0_292:GetComponent(typeof(Animation)):Play(arg1_292)
end

function getSurveyUrl(arg0_293)
	local var0_293 = pg.survey_data_template[arg0_293]
	local var1_293

	if not IsUnityEditor then
		if PLATFORM_CODE == PLATFORM_CH then
			local var2_293 = getProxy(UserProxy):GetCacheGatewayInServerLogined()

			if var2_293 == PLATFORM_ANDROID then
				if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_BILI then
					var1_293 = var0_293.main_url
				else
					var1_293 = var0_293.uo_url
				end
			elseif var2_293 == PLATFORM_IPHONEPLAYER then
				var1_293 = var0_293.ios_url
			end
		elseif PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
			var1_293 = var0_293.main_url
		end
	else
		var1_293 = var0_293.main_url
	end

	local var3_293 = getProxy(PlayerProxy):getRawData().id
	local var4_293 = getProxy(UserProxy):getRawData().arg2 or ""
	local var5_293
	local var6_293 = PLATFORM == PLATFORM_ANDROID and 1 or PLATFORM == PLATFORM_IPHONEPLAYER and 2 or 3
	local var7_293 = getProxy(UserProxy):getRawData()
	local var8_293 = getProxy(ServerProxy):getRawData()[var7_293 and var7_293.server or 0]
	local var9_293 = var8_293 and var8_293.id or ""
	local var10_293 = getProxy(PlayerProxy):getRawData().level
	local var11_293 = var3_293 .. "_" .. arg0_293
	local var12_293 = var1_293
	local var13_293 = {
		var3_293,
		var4_293,
		var6_293,
		var9_293,
		var10_293,
		var11_293
	}

	if var12_293 then
		for iter0_293, iter1_293 in ipairs(var13_293) do
			var12_293 = string.gsub(var12_293, "$" .. iter0_293, tostring(iter1_293))
		end
	end

	warning(var12_293)

	return var12_293
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

function FilterVarchar(arg0_295)
	assert(type(arg0_295) == "string" or type(arg0_295) == "table")

	if arg0_295 == "" then
		return nil
	end

	return arg0_295
end

function getGameset(arg0_296)
	local var0_296 = pg.gameset[arg0_296]

	assert(var0_296)

	return {
		var0_296.key_value,
		var0_296.description
	}
end

function getDorm3dGameset(arg0_297)
	local var0_297 = pg.dorm3d_set[arg0_297]

	assert(var0_297)

	return {
		var0_297.key_value_int,
		var0_297.key_value_varchar
	}
end

function GetItemsOverflowDic(arg0_298)
	arg0_298 = arg0_298 or {}

	local var0_298 = {
		[DROP_TYPE_ITEM] = {},
		[DROP_TYPE_RESOURCE] = {},
		[DROP_TYPE_EQUIP] = 0,
		[DROP_TYPE_SHIP] = 0,
		[DROP_TYPE_WORLD_ITEM] = 0
	}

	while #arg0_298 > 0 do
		local var1_298 = table.remove(arg0_298)

		switch(var1_298.type, {
			[DROP_TYPE_ITEM] = function()
				if var1_298:getConfig("open_directly") == 1 then
					for iter0_299, iter1_299 in ipairs(var1_298:getConfig("display_icon")) do
						local var0_299 = Drop.Create(iter1_299)

						var0_299.count = var0_299.count * var1_298.count

						table.insert(arg0_298, var0_299)
					end
				elseif var1_298:getSubClass():IsShipExpType() then
					var0_298[var1_298.type][var1_298.id] = defaultValue(var0_298[var1_298.type][var1_298.id], 0) + var1_298.count
				end
			end,
			[DROP_TYPE_RESOURCE] = function()
				var0_298[var1_298.type][var1_298.id] = defaultValue(var0_298[var1_298.type][var1_298.id], 0) + var1_298.count
			end,
			[DROP_TYPE_EQUIP] = function()
				var0_298[var1_298.type] = var0_298[var1_298.type] + var1_298.count
			end,
			[DROP_TYPE_SHIP] = function()
				var0_298[var1_298.type] = var0_298[var1_298.type] + var1_298.count
			end,
			[DROP_TYPE_WORLD_ITEM] = function()
				var0_298[var1_298.type] = var0_298[var1_298.type] + var1_298.count
			end
		})
	end

	return var0_298
end

function CheckOverflow(arg0_304, arg1_304)
	local var0_304 = {}
	local var1_304 = arg0_304[DROP_TYPE_RESOURCE][PlayerConst.ResGold] or 0
	local var2_304 = arg0_304[DROP_TYPE_RESOURCE][PlayerConst.ResOil] or 0
	local var3_304 = arg0_304[DROP_TYPE_EQUIP]
	local var4_304 = arg0_304[DROP_TYPE_SHIP]
	local var5_304 = getProxy(PlayerProxy):getRawData()
	local var6_304 = false

	if arg1_304 then
		local var7_304 = var5_304:OverStore(PlayerConst.ResStoreGold, var1_304)
		local var8_304 = var5_304:OverStore(PlayerConst.ResStoreOil, var2_304)

		if var7_304 > 0 or var8_304 > 0 then
			var0_304.isStoreOverflow = {
				var7_304,
				var8_304
			}
		end
	else
		if var1_304 > 0 and var5_304:GoldMax(var1_304) then
			return false, "gold"
		end

		if var2_304 > 0 and var5_304:OilMax(var2_304) then
			return false, "oil"
		end
	end

	var0_304.isExpBookOverflow = {}

	for iter0_304, iter1_304 in pairs(arg0_304[DROP_TYPE_ITEM]) do
		local var9_304 = Item.getConfigData(iter0_304)

		if getProxy(BagProxy):getItemCountById(iter0_304) + iter1_304 > var9_304.max_num then
			table.insert(var0_304.isExpBookOverflow, iter0_304)
		end
	end

	local var10_304 = getProxy(EquipmentProxy):getCapacity()

	if var3_304 > 0 and var3_304 + var10_304 > var5_304:getMaxEquipmentBag() then
		return false, "equip"
	end

	local var11_304 = getProxy(BayProxy):getShipCount()

	if var4_304 > 0 and var4_304 + var11_304 > var5_304:getMaxShipBag() then
		return false, "ship"
	end

	return true, var0_304
end

function CheckShipExpOverflow(arg0_305)
	local var0_305 = getProxy(BagProxy)

	for iter0_305, iter1_305 in pairs(arg0_305[DROP_TYPE_ITEM]) do
		if var0_305:getItemCountById(iter0_305) + iter1_305 > Item.getConfigData(iter0_305).max_num then
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

function RegisterDetailButton(arg0_306, arg1_306, arg2_306)
	Drop.Change(arg2_306)
	switch(arg2_306.type, {
		[DROP_TYPE_ITEM] = function()
			if arg2_306:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
				local var0_307 = Item.getConfigData(arg2_306.id).usage_arg
				local var1_307 = var0_307[3]

				if Item.InTimeLimitSkinAssigned(arg2_306.id) then
					var1_307 = table.mergeArray(var0_307[2], var1_307, true)
				end

				local var2_307 = {}

				for iter0_307, iter1_307 in ipairs(var0_307[2]) do
					var2_307[iter1_307] = true
				end

				onButton(arg0_306, arg1_306, function()
					arg0_306:closeView()
					pg.m02:sendNotification(GAME.LOAD_LAYERS, {
						parentContext = getProxy(ContextProxy):getCurrentContext(),
						context = Context.New({
							viewComponent = SelectSkinLayer,
							mediator = SkinAtlasMediator,
							data = {
								mode = SelectSkinLayer.MODE_VIEW,
								itemId = arg2_306.id,
								selectableSkinList = underscore.map(var1_307, function(arg0_309)
									return SelectableSkin.New({
										id = arg0_309,
										isTimeLimit = var2_307[arg0_309] or false
									})
								end)
							}
						})
					})
				end, SFX_PANEL)
				setActive(arg1_306, true)
			else
				local var3_307 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_306.id) and "tech" or arg2_306:getConfig("type")

				if var26_0[var3_307] then
					local var4_307 = {
						item2Row = true,
						content = i18n(var26_0[var3_307]),
						itemList = underscore.map(arg2_306:getConfig("display_icon"), function(arg0_310)
							return Drop.Create(arg0_310)
						end)
					}

					if var3_307 == 11 then
						onButton(arg0_306, arg1_306, function()
							arg0_306:emit(BaseUI.ON_DROP_LIST_OWN, var4_307)
						end, SFX_PANEL)
					else
						onButton(arg0_306, arg1_306, function()
							arg0_306:emit(BaseUI.ON_DROP_LIST, var4_307)
						end, SFX_PANEL)
					end
				end

				setActive(arg1_306, tobool(var26_0[var3_307]))
			end
		end,
		[DROP_TYPE_EQUIP] = function()
			onButton(arg0_306, arg1_306, function()
				arg0_306:emit(BaseUI.ON_DROP, arg2_306)
			end, SFX_PANEL)
			setActive(arg1_306, true)
		end,
		[DROP_TYPE_SPWEAPON] = function()
			onButton(arg0_306, arg1_306, function()
				arg0_306:emit(BaseUI.ON_DROP, arg2_306)
			end, SFX_PANEL)
			setActive(arg1_306, true)
		end
	}, function()
		setActive(arg1_306, false)
	end)
end

function RegisterNewStyleDetailButton(arg0_318, arg1_318, arg2_318)
	Drop.Change(arg2_318)
	switch(arg2_318.type, {
		[DROP_TYPE_ITEM] = function()
			local var0_319 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_318.id) and "tech" or arg2_318:getConfig("type")

			if var26_0[var0_319] then
				local var1_319 = {
					useDeepShow = true,
					showOwn = var0_319 == 11,
					content = i18n(var26_0[var0_319]),
					itemList = underscore.map(arg2_318:getConfig("display_icon"), function(arg0_320)
						return Drop.Create(arg0_320)
					end)
				}

				onButton(arg0_318, arg1_318, function()
					arg0_318:emit(BaseUI.ON_NEW_STYLE_ITEMS, var1_319)
				end, SFX_PANEL)
			end

			setActive(arg1_318, tobool(var26_0[var0_319]))
		end
	}, function()
		setActive(arg1_318, false)
	end)
end

function UpdateOwnDisplay(arg0_323, arg1_323)
	local var0_323, var1_323 = arg1_323:getOwnedCount()

	setActive(arg0_323, var1_323 and var0_323 > 0)

	if var1_323 and var0_323 > 0 then
		setText(arg0_323:Find("label"), i18n("word_own1"))
		setText(arg0_323:Find("Text"), var0_323)
	end
end

function Damp(arg0_324, arg1_324, arg2_324)
	arg1_324 = Mathf.Max(1, arg1_324)

	local var0_324 = Mathf.Epsilon

	if arg1_324 < var0_324 or var0_324 > Mathf.Abs(arg0_324) then
		return arg0_324
	end

	if arg2_324 < var0_324 then
		return 0
	end

	local var1_324 = -4.605170186

	return arg0_324 * (1 - Mathf.Exp(var1_324 * arg2_324 / arg1_324))
end

function checkCullResume(arg0_325)
	if not ReflectionHelp.RefCallMethodEx(typeof("UnityEngine.CanvasRenderer"), "GetMaterial", GetComponent(arg0_325, "CanvasRenderer"), {
		typeof("System.Int32")
	}, {
		0
	}) then
		local var0_325 = arg0_325:GetComponentsInChildren(typeof(MeshImage))

		for iter0_325 = 1, var0_325.Length do
			var0_325[iter0_325 - 1]:SetVerticesDirty()
		end

		return false
	end

	return true
end

function parseEquipCode(arg0_326)
	local var0_326 = {}

	if arg0_326 and arg0_326 ~= "" then
		local var1_326 = base64.dec(arg0_326)

		var0_326 = string.split(var1_326, "/")
		var0_326[5], var0_326[6] = unpack(string.split(var0_326[5], "\\"))

		if #var0_326 < 6 or arg0_326 ~= base64.enc(table.concat({
			table.concat(underscore.first(var0_326, 5), "/"),
			var0_326[6]
		}, "\\")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_illegal"))

			var0_326 = {}
		end
	end

	for iter0_326 = 1, 6 do
		var0_326[iter0_326] = var0_326[iter0_326] and tonumber(var0_326[iter0_326], 32) or 0
	end

	return var0_326
end

function buildEquipCode(arg0_327)
	local var0_327 = underscore.map(arg0_327:getAllEquipments(), function(arg0_328)
		return ConversionBase(32, arg0_328 and arg0_328.id or 0)
	end)
	local var1_327 = {
		table.concat(var0_327, "/"),
		ConversionBase(32, checkExist(arg0_327:GetSpWeapon(), {
			"id"
		}) or 0)
	}

	return base64.enc(table.concat(var1_327, "\\"))
end

function setDirectorSpeed(arg0_329, arg1_329)
	GetComponent(arg0_329, "TimelineSpeed"):SetTimelineSpeed(arg1_329)
end

function setDefaultZeroMetatable(arg0_330)
	return setmetatable(arg0_330, {
		__index = function(arg0_331, arg1_331)
			if rawget(arg0_331, arg1_331) == nil then
				arg0_331[arg1_331] = 0
			end

			return arg0_331[arg1_331]
		end
	})
end

function checkABExist(arg0_332)
	if EDITOR_TOOL then
		return ResourceMgr.Inst:AssetExist(arg0_332)
	else
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_332))
	end
end

function compareNumber(arg0_333, arg1_333, arg2_333)
	return switch(arg1_333, {
		[">"] = function()
			return arg0_333 > arg2_333
		end,
		[">="] = function()
			return arg0_333 >= arg2_333
		end,
		["="] = function()
			return arg0_333 == arg2_333
		end,
		["<"] = function()
			return arg0_333 < arg2_333
		end,
		["<="] = function()
			return arg0_333 <= arg2_333
		end
	})
end
