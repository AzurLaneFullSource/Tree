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

function GetPrefabFromAtlasAsync(arg0_29, arg1_29, arg2_29)
	local var0_29 = pg.PoolMgr.GetInstance()

	var1_0[arg1_29] = arg0_29

	var0_29:GetPrefab(arg0_29, "", true, function(arg0_30)
		if IsNil(arg1_29) or var1_0[arg1_29] ~= arg0_29 then
			var0_29:ReturnPrefab(arg0_29, "", arg0_30)

			return
		elseif tf(arg1_29):Find(arg0_30.name) then
			var0_29:ReturnPrefab(arg0_29, "", arg0_30)

			arg0_30 = tf(arg1_29):Find(arg0_30.name).gameObject
		else
			setParent(arg0_30, arg1_29)
		end

		var1_0[arg1_29] = nil

		arg2_29(arg0_30)
	end)
end

function SetAction(arg0_31, arg1_31, arg2_31)
	local var0_31 = GetComponent(arg0_31, "SkeletonGraphic").AnimationState

	var0_31:SetAnimation(0, arg1_31, defaultValue(arg2_31, true))
	var0_31:Update(Time.deltaTime)
end

function SetActionCallback(arg0_32, arg1_32)
	GetOrAddComponent(arg0_32, typeof(SpineAnimUI)):SetActionCallBack(arg1_32)
end

function emojiText(arg0_33, arg1_33)
	local var0_33 = GetComponent(arg0_33, "TextMesh")
	local var1_33 = GetComponent(arg0_33, "MeshRenderer")
	local var2_33 = Shader.Find("UI/Unlit/Transparent")
	local var3_33 = var1_33.materials
	local var4_33 = {
		var3_33[0]
	}
	local var5_33 = {}
	local var6_33 = 0
	local var7_33 = {}
	local var8_33 = string.gsub(arg1_33, "#(%d+)#", function(arg0_34)
		if not var5_33[arg0_34] then
			var6_33 = var6_33 + 1
			var7_33["emoji" .. arg0_34] = Material.New(var2_33)

			table.insert(var4_33, mat)

			var5_33[arg0_34] = var6_33

			local var0_34 = var6_33
		end

		return "<quad material=" .. var6_33 .. " />"
	end)
	local var9_33 = AssetBundleHelper.LoadManyAssets("emojis", underscore.keys(var7_33), nil, false, nil, true)

	for iter0_33, iter1_33 in pairs(var7_33) do
		iter1_33.mainTexture = var9_33[iter0_33]
	end

	var0_33.text = var8_33
	var1_33.materials = var4_33
end

function setPaintingImg(arg0_35, arg1_35)
	local var0_35 = LoadSprite("painting/" .. arg1_35) or LoadSprite("painting/unknown")

	setImageSprite(arg0_35, var0_35)
	resetAspectRatio(arg0_35)
end

function setPaintingPrefab(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36, arg5_36)
	local var0_36 = findTF(arg0_36, "fitter")

	assert(var0_36, "请添加子物体fitter")
	removeAllChildren(var0_36)

	local var1_36 = GetOrAddComponent(var0_36, "PaintingScaler")

	var1_36.FrameName = arg2_36 or ""
	var1_36.Tween = 1

	local var2_36 = arg1_36

	if not arg3_36 and checkABExist("painting/" .. arg1_36 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg1_36, 0) ~= 0 then
		arg1_36 = arg1_36 .. "_n"
	end

	PoolMgr.GetInstance():GetPainting(arg1_36, false, function(arg0_37)
		setParent(arg0_37, var0_36, false)

		local var0_37 = findTF(arg0_37, "Touch")

		if not IsNil(var0_37) then
			setActive(var0_37, false)
		end

		local var1_37 = findTF(arg0_37, "hx")

		if not IsNil(var1_37) then
			setActive(var1_37, HXSet.isHx())
		end

		ShipExpressionHelper.SetExpression(var0_36:GetChild(0), var2_36)
		existCall(arg5_36)
	end)
	PaintingShiftTransform(var0_36, arg2_36, arg4_36)
end

local var2_0 = {}

function setPaintingPrefabAsync(arg0_38, arg1_38, arg2_38, arg3_38, arg4_38)
	local var0_38 = arg1_38

	if checkABExist("painting/" .. arg1_38 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg1_38, 0) ~= 0 then
		arg1_38 = arg1_38 .. "_n"
	end

	LoadPaintingPrefabAsync(arg0_38, var0_38, arg1_38, arg2_38, arg3_38, arg4_38)
end

function LoadPaintingPrefabAsync(arg0_39, arg1_39, arg2_39, arg3_39, arg4_39, arg5_39)
	local var0_39 = findTF(arg0_39, "fitter")

	assert(var0_39, "请添加子物体fitter")
	removeAllChildren(var0_39)

	local var1_39 = GetOrAddComponent(var0_39, "PaintingScaler")

	var1_39.FrameName = arg3_39 or ""
	var1_39.Tween = 1
	var2_0[arg0_39] = arg2_39

	PoolMgr.GetInstance():GetPainting(arg2_39, true, function(arg0_40)
		if IsNil(arg0_39) or var2_0[arg0_39] ~= arg2_39 then
			PoolMgr.GetInstance():ReturnPainting(arg2_39, arg0_40)

			return
		else
			setParent(arg0_40, var0_39, false)

			var2_0[arg0_39] = nil

			ShipExpressionHelper.SetExpression(arg0_40, arg1_39)
		end

		local var0_40 = findTF(arg0_40, "Touch")

		if not IsNil(var0_40) then
			setActive(var0_40, false)
		end

		local var1_40 = findTF(arg0_40, "Drag")

		if not IsNil(var1_40) then
			setActive(var1_40, false)
		end

		local var2_40 = findTF(arg0_40, "hx")

		if not IsNil(var2_40) then
			setActive(var2_40, HXSet.isHx())
		end

		if arg4_39 then
			arg4_39(arg0_40)
		end
	end)
	PaintingShiftTransform(var0_39, arg3_39, arg5_39)
end

local var3_0 = {
	pifu = "skin_card_shift",
	biandui = "formation_shift"
}

function PaintingShiftTransform(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg0_41.parent:GetComponent(typeof(RectTransform))
	local var1_41 = var3_0[arg1_41]

	if var1_41 ~= nil and arg2_41 ~= nil then
		local var2_41 = pg.ship_skin_newmainui_shift[arg2_41.skinID]

		if var2_41 then
			local var3_41 = var2_41[var1_41]

			var0_41.localEulerAngles = Vector3(0, 0, var3_41[5] and var3_41[5] or 0)

			return
		end
	end

	var0_41.localEulerAngles = Vector3(0, 0, 0)
end

function retPaintingPrefab(arg0_42, arg1_42, arg2_42)
	if arg0_42 and arg1_42 then
		local var0_42 = findTF(arg0_42, "fitter")

		if var0_42 and var0_42.childCount > 0 then
			local var1_42 = var0_42:GetChild(0)

			if not IsNil(var1_42) then
				local var2_42 = findTF(var1_42, "Touch")

				if not IsNil(var2_42) then
					eachChild(var2_42, function(arg0_43)
						local var0_43 = arg0_43:GetComponent(typeof(Button))

						if not IsNil(var0_43) then
							removeOnButton(arg0_43)
						end
					end)
				end

				if not arg2_42 then
					PoolMgr.GetInstance():ReturnPainting(string.gsub(var1_42.name, "%(Clone%)", ""), var1_42.gameObject)
				else
					PoolMgr.GetInstance():ReturnPaintingWithPrefix(string.gsub(var1_42.name, "%(Clone%)", ""), var1_42.gameObject, arg2_42)
				end
			end
		end

		var2_0[arg0_42] = nil
	end
end

function checkPaintingPrefab(arg0_44, arg1_44, arg2_44, arg3_44, arg4_44)
	local var0_44 = findTF(arg0_44, "fitter")

	assert(var0_44, "请添加子物体fitter")
	removeAllChildren(var0_44)

	local var1_44 = GetOrAddComponent(var0_44, "PaintingScaler")

	var1_44.FrameName = arg2_44 or ""
	var1_44.Tween = 1

	local var2_44 = arg4_44 or "painting/"
	local var3_44 = arg1_44

	if not arg3_44 and checkABExist(var2_44 .. arg1_44 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg1_44, 0) ~= 0 then
		arg1_44 = arg1_44 .. "_n"
	end

	return var0_44, arg1_44, var3_44
end

function onLoadedPaintingPrefab(arg0_45)
	local var0_45 = arg0_45.paintingTF
	local var1_45 = arg0_45.fitterTF
	local var2_45 = arg0_45.defaultPaintingName

	setParent(var0_45, var1_45, false)

	local var3_45 = findTF(var0_45, "Touch")

	if not IsNil(var3_45) then
		setActive(var3_45, false)
	end

	local var4_45 = findTF(var0_45, "hx")

	if not IsNil(var4_45) then
		setActive(var4_45, HXSet.isHx())
	end

	ShipExpressionHelper.SetExpression(var1_45:GetChild(0), var2_45)
end

function onLoadedPaintingPrefabAsync(arg0_46)
	local var0_46 = arg0_46.paintingTF
	local var1_46 = arg0_46.fitterTF
	local var2_46 = arg0_46.objectOrTransform
	local var3_46 = arg0_46.paintingName
	local var4_46 = arg0_46.defaultPaintingName
	local var5_46 = arg0_46.callback

	if IsNil(var2_46) or var2_0[var2_46] ~= var3_46 then
		PoolMgr.GetInstance():ReturnPainting(var3_46, var0_46)

		return
	else
		setParent(var0_46, var1_46, false)

		var2_0[var2_46] = nil

		ShipExpressionHelper.SetExpression(var0_46, var4_46)
	end

	local var6_46 = findTF(var0_46, "Touch")

	if not IsNil(var6_46) then
		setActive(var6_46, false)
	end

	local var7_46 = findTF(var0_46, "hx")

	if not IsNil(var7_46) then
		setActive(var7_46, HXSet.isHx())
	end

	if var5_46 then
		var5_46()
	end
end

function setCommanderPaintingPrefab(arg0_47, arg1_47, arg2_47, arg3_47)
	local var0_47, var1_47, var2_47 = checkPaintingPrefab(arg0_47, arg1_47, arg2_47, arg3_47)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_47, false, function(arg0_48)
		local var0_48 = {
			paintingTF = arg0_48,
			fitterTF = var0_47,
			defaultPaintingName = var2_47
		}

		onLoadedPaintingPrefab(var0_48)
	end, "commanderpainting/")
end

function setCommanderPaintingPrefabAsync(arg0_49, arg1_49, arg2_49, arg3_49, arg4_49)
	local var0_49, var1_49, var2_49 = checkPaintingPrefab(arg0_49, arg1_49, arg2_49, arg4_49)

	var2_0[arg0_49] = var1_49

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_49, true, function(arg0_50)
		local var0_50 = {
			paintingTF = arg0_50,
			fitterTF = var0_49,
			objectOrTransform = arg0_49,
			paintingName = var1_49,
			defaultPaintingName = var2_49,
			callback = arg3_49
		}

		onLoadedPaintingPrefabAsync(var0_50)
	end, "commanderpainting/")
end

function retCommanderPaintingPrefab(arg0_51, arg1_51)
	retPaintingPrefab(arg0_51, arg1_51, "commanderpainting/")
end

function setMetaPaintingPrefab(arg0_52, arg1_52, arg2_52, arg3_52)
	local var0_52, var1_52, var2_52 = checkPaintingPrefab(arg0_52, arg1_52, arg2_52, arg3_52)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_52, false, function(arg0_53)
		local var0_53 = {
			paintingTF = arg0_53,
			fitterTF = var0_52,
			defaultPaintingName = var2_52
		}

		onLoadedPaintingPrefab(var0_53)
	end, "metapainting/")
end

function setMetaPaintingPrefabAsync(arg0_54, arg1_54, arg2_54, arg3_54, arg4_54)
	local var0_54, var1_54, var2_54 = checkPaintingPrefab(arg0_54, arg1_54, arg2_54, arg4_54)

	var2_0[arg0_54] = var1_54

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_54, true, function(arg0_55)
		local var0_55 = {
			paintingTF = arg0_55,
			fitterTF = var0_54,
			objectOrTransform = arg0_54,
			paintingName = var1_54,
			defaultPaintingName = var2_54,
			callback = arg3_54
		}

		onLoadedPaintingPrefabAsync(var0_55)
	end, "metapainting/")
end

function retMetaPaintingPrefab(arg0_56, arg1_56)
	retPaintingPrefab(arg0_56, arg1_56, "metapainting/")
end

function setGuildPaintingPrefab(arg0_57, arg1_57, arg2_57, arg3_57)
	local var0_57, var1_57, var2_57 = checkPaintingPrefab(arg0_57, arg1_57, arg2_57, arg3_57)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_57, false, function(arg0_58)
		local var0_58 = {
			paintingTF = arg0_58,
			fitterTF = var0_57,
			defaultPaintingName = var2_57
		}

		onLoadedPaintingPrefab(var0_58)
	end, "guildpainting/")
end

function setGuildPaintingPrefabAsync(arg0_59, arg1_59, arg2_59, arg3_59, arg4_59)
	local var0_59, var1_59, var2_59 = checkPaintingPrefab(arg0_59, arg1_59, arg2_59, arg4_59)

	var2_0[arg0_59] = var1_59

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_59, true, function(arg0_60)
		local var0_60 = {
			paintingTF = arg0_60,
			fitterTF = var0_59,
			objectOrTransform = arg0_59,
			paintingName = var1_59,
			defaultPaintingName = var2_59,
			callback = arg3_59
		}

		onLoadedPaintingPrefabAsync(var0_60)
	end, "guildpainting/")
end

function retGuildPaintingPrefab(arg0_61, arg1_61)
	retPaintingPrefab(arg0_61, arg1_61, "guildpainting/")
end

function setShopPaintingPrefab(arg0_62, arg1_62, arg2_62, arg3_62)
	local var0_62, var1_62, var2_62 = checkPaintingPrefab(arg0_62, arg1_62, arg2_62, arg3_62)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_62, false, function(arg0_63)
		local var0_63 = {
			paintingTF = arg0_63,
			fitterTF = var0_62,
			defaultPaintingName = var2_62
		}

		onLoadedPaintingPrefab(var0_63)
	end, "shoppainting/")
end

function retShopPaintingPrefab(arg0_64, arg1_64)
	retPaintingPrefab(arg0_64, arg1_64, "shoppainting/")
end

function setBuildPaintingPrefabAsync(arg0_65, arg1_65, arg2_65, arg3_65, arg4_65)
	local var0_65, var1_65, var2_65 = checkPaintingPrefab(arg0_65, arg1_65, arg2_65, arg4_65)

	var2_0[arg0_65] = var1_65

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_65, true, function(arg0_66)
		local var0_66 = {
			paintingTF = arg0_66,
			fitterTF = var0_65,
			objectOrTransform = arg0_65,
			paintingName = var1_65,
			defaultPaintingName = var2_65,
			callback = arg3_65
		}

		onLoadedPaintingPrefabAsync(var0_66)
	end, "buildpainting/")
end

function retBuildPaintingPrefab(arg0_67, arg1_67)
	retPaintingPrefab(arg0_67, arg1_67, "buildpainting/")
end

function setColorCount(arg0_68, arg1_68, arg2_68)
	setText(arg0_68, string.format(arg1_68 < arg2_68 and "<color=" .. COLOR_RED .. ">%d</color>/%d" or "%d/%d", arg1_68, arg2_68))
end

function customColorCount(arg0_69, arg1_69, arg2_69, arg3_69, arg4_69)
	arg0_69.text = _customColorCount(arg1_69, arg2_69, arg3_69, arg4_69)
end

function _customColorCount(arg0_70, arg1_70, arg2_70, arg3_70)
	local var0_70 = arg0_70 < arg1_70 and arg3_70 or arg2_70

	return string.format("<color=" .. var0_70 .. ">%d</color>/%d" or "%d/%d", arg0_70, arg1_70)
end

function setColorStr(arg0_71, arg1_71)
	return "<color=" .. arg1_71 .. ">" .. arg0_71 .. "</color>"
end

function setSizeStr(arg0_72, arg1_72)
	local var0_72, var1_72 = string.gsub(arg0_72, "[<]size=%d+[>]", "<size=" .. arg1_72 .. ">")

	if var1_72 == 0 then
		var0_72 = "<size=" .. arg1_72 .. ">" .. var0_72 .. "</size>"
	end

	return var0_72
end

function getBgm(arg0_73, arg1_73)
	local var0_73 = pg.voice_bgm[arg0_73]

	if pg.CriMgr.GetInstance():IsDefaultBGM() then
		return var0_73 and var0_73.default_bgm or nil
	elseif var0_73 then
		if var0_73.special_bgm and type(var0_73.special_bgm) == "table" and #var0_73.special_bgm > 0 and _.all(var0_73.special_bgm, function(arg0_74)
			return type(arg0_74) == "table" and #arg0_74 > 2 and type(arg0_74[2]) == "number"
		end) then
			local var1_73 = Clone(var0_73.special_bgm)

			table.sort(var1_73, function(arg0_75, arg1_75)
				return arg0_75[2] > arg1_75[2]
			end)

			local var2_73 = ""

			_.each(var1_73, function(arg0_76)
				if var2_73 ~= "" then
					return
				end

				local var0_76 = arg0_76[1]
				local var1_76 = arg0_76[3]

				switch(var0_76, {
					function()
						local var0_77 = var1_76[1]
						local var1_77 = var1_76[2]

						if #var0_77 == 1 then
							if var0_77[1] ~= "always" then
								return
							end
						elseif not pg.TimeMgr.GetInstance():inTime(var0_77) then
							return
						end

						_.each(var1_77, function(arg0_78)
							if var2_73 ~= "" then
								return
							end

							if #arg0_78 == 2 and pg.TimeMgr.GetInstance():inPeriod(arg0_78[1]) then
								var2_73 = arg0_78[2]
							elseif #arg0_78 == 3 and pg.TimeMgr.GetInstance():inPeriod(arg0_78[1], arg0_78[2]) then
								var2_73 = arg0_78[3]
							end
						end)
					end,
					function()
						local var0_79 = false
						local var1_79 = ""

						_.each(var1_76, function(arg0_80)
							if #arg0_80 ~= 2 or var0_79 then
								return
							end

							if pg.NewStoryMgr.GetInstance():IsPlayed(arg0_80[1]) then
								var2_73 = arg0_80[2]

								if var2_73 ~= "" then
									var1_79 = var2_73
								else
									var2_73 = var1_79
								end
							else
								var0_79 = true
							end
						end)
					end,
					function()
						if not arg1_73 then
							return
						end

						_.each(var1_76, function(arg0_82)
							if #arg0_82 == 2 and arg0_82[1] == arg1_73 then
								var2_73 = arg0_82[2]

								return
							end
						end)
					end
				})
			end)

			return var2_73 ~= "" and var2_73 or var0_73.bgm
		else
			return var0_73 and var0_73.bgm or nil
		end
	else
		return nil
	end
end

function playStory(arg0_83, arg1_83)
	pg.NewStoryMgr.GetInstance():Play(arg0_83, arg1_83)
end

function errorMessage(arg0_84)
	local var0_84 = ERROR_MESSAGE[arg0_84]

	if var0_84 == nil then
		var0_84 = ERROR_MESSAGE[9999] .. ":" .. arg0_84
	end

	return var0_84
end

function errorTip(arg0_85, arg1_85, ...)
	local var0_85 = pg.gametip[arg0_85 .. "_error"]
	local var1_85

	if var0_85 then
		var1_85 = var0_85.tip
	else
		var1_85 = pg.gametip.common_error.tip
	end

	local var2_85 = arg0_85 .. "_error_" .. arg1_85

	if pg.gametip[var2_85] then
		local var3_85 = i18n(var2_85, ...)

		return var1_85 .. var3_85
	else
		local var4_85 = "common_error_" .. arg1_85

		if pg.gametip[var4_85] then
			local var5_85 = i18n(var4_85, ...)

			return var1_85 .. var5_85
		else
			local var6_85 = errorMessage(arg1_85)

			return var1_85 .. arg1_85 .. ":" .. var6_85
		end
	end
end

function colorNumber(arg0_86, arg1_86)
	local var0_86 = "@COLOR_SCOPE"
	local var1_86 = {}

	arg0_86 = string.gsub(arg0_86, "<color=#%x+>", function(arg0_87)
		table.insert(var1_86, arg0_87)

		return var0_86
	end)
	arg0_86 = string.gsub(arg0_86, "%d+%.?%d*%%*", function(arg0_88)
		return "<color=" .. arg1_86 .. ">" .. arg0_88 .. "</color>"
	end)

	if #var1_86 > 0 then
		local var2_86 = 0

		return (string.gsub(arg0_86, var0_86, function(arg0_89)
			var2_86 = var2_86 + 1

			return var1_86[var2_86]
		end))
	else
		return arg0_86
	end
end

function getBounds(arg0_90)
	local var0_90 = LuaHelper.GetWorldCorners(rtf(arg0_90))
	local var1_90 = Bounds.New(var0_90[0], Vector3.zero)

	var1_90:Encapsulate(var0_90[2])

	return var1_90
end

local function var4_0(arg0_91, arg1_91)
	arg0_91.localScale = Vector3.one
	arg0_91.anchorMin = Vector2.zero
	arg0_91.anchorMax = Vector2.one
	arg0_91.offsetMin = Vector2(arg1_91[1], arg1_91[2])
	arg0_91.offsetMax = Vector2(-arg1_91[3], -arg1_91[4])
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

function setFrame(arg0_92, arg1_92, arg2_92)
	arg1_92 = tostring(arg1_92)

	local var0_92, var1_92 = unpack((string.split(arg1_92, "_")))

	if var1_92 or tonumber(var0_92) > 5 then
		arg2_92 = arg2_92 or "frame" .. arg1_92
	end

	GetImageSpriteFromAtlasAsync("weaponframes", "frame", arg0_92)

	local var2_92 = arg2_92 and Color.white or Color.NewHex(ItemRarity.Rarity2FrameHexColor(var0_92 and tonumber(var0_92) or ItemRarity.Gray))

	setImageColor(arg0_92, var2_92)

	local var3_92 = findTF(arg0_92, "specialFrame")

	if arg2_92 then
		if var3_92 then
			setActive(var3_92, true)
		else
			var3_92 = cloneTplTo(arg0_92, arg0_92, "specialFrame")

			removeAllChildren(var3_92)
		end

		var4_0(var3_92, var5_0[arg2_92] or var5_0.other)
		GetImageSpriteFromAtlasAsync("weaponframes", arg2_92, var3_92)
	elseif var3_92 then
		setActive(var3_92, false)
	end
end

function setIconColorful(arg0_93, arg1_93, arg2_93, arg3_93)
	arg3_93 = arg3_93 or {
		[ItemRarity.SSR] = {
			name = "IconColorful",
			active = function(arg0_94, arg1_94)
				return not arg1_94.noIconColorful and arg0_94 == ItemRarity.SSR
			end
		}
	}

	local var0_93 = findTF(arg0_93, "icon_bg/frame")

	for iter0_93, iter1_93 in pairs(arg3_93) do
		local var1_93 = iter1_93.name
		local var2_93 = iter1_93.active(arg1_93, arg2_93)
		local var3_93 = var0_93:Find(var1_93 .. "(Clone)")

		if var3_93 then
			setActive(var3_93, var2_93)
		elseif var2_93 then
			LoadAndInstantiateAsync("ui", string.lower(var1_93), function(arg0_95)
				if IsNil(arg0_93) or var0_93:Find(var1_93 .. "(Clone)") then
					Object.Destroy(arg0_95)
				else
					local var0_95 = var6_0[arg0_95.name] or 999
					local var1_95 = underscore.range(var0_93.childCount):chain():map(function(arg0_96)
						return var0_93:GetChild(arg0_96 - 1)
					end):map(function(arg0_97)
						return var6_0[arg0_97.name] or 0
					end):value()
					local var2_95 = 0

					for iter0_95 = #var1_95, 1, -1 do
						if var0_95 > var1_95[iter0_95] then
							var2_95 = iter0_95

							break
						end
					end

					setParent(arg0_95, var0_93)
					tf(arg0_95):SetSiblingIndex(var2_95)
					setActive(arg0_95, var2_93)
				end
			end)
		end
	end
end

function setIconStars(arg0_98, arg1_98, arg2_98)
	local var0_98 = findTF(arg0_98, "icon_bg/startpl")
	local var1_98 = findTF(arg0_98, "icon_bg/stars")

	if var1_98 and var0_98 then
		setActive(var1_98, false)
		setActive(var0_98, false)
	end

	if not var1_98 or not arg1_98 then
		return
	end

	for iter0_98 = 1, math.max(arg2_98, var1_98.childCount) do
		setActive(iter0_98 > var1_98.childCount and cloneTplTo(var0_98, var1_98) or var1_98:GetChild(iter0_98 - 1), iter0_98 <= arg2_98)
	end

	setActive(var1_98, true)
end

local function var7_0(arg0_99, arg1_99)
	local var0_99 = findTF(arg0_99, "icon_bg/slv")

	if not IsNil(var0_99) then
		setActive(var0_99, arg1_99 > 0)
		setText(findTF(var0_99, "Text"), arg1_99)
	end
end

function setIconName(arg0_100, arg1_100, arg2_100)
	local var0_100 = findTF(arg0_100, "name")

	if not IsNil(var0_100) then
		setText(var0_100, arg1_100)
		setTextAlpha(var0_100, (arg2_100.hideName or arg2_100.anonymous) and 0 or 1)
	end
end

function setIconCount(arg0_101, arg1_101)
	local var0_101 = findTF(arg0_101, "icon_bg/count")

	if not IsNil(var0_101) then
		setText(var0_101, arg1_101 and (type(arg1_101) ~= "number" or arg1_101 > 0) and arg1_101 or "")
	end
end

function updateEquipment(arg0_102, arg1_102, arg2_102)
	arg2_102 = arg2_102 or {}

	assert(arg1_102, "equipmentVo can not be nil.")

	local var0_102 = EquipmentRarity.Rarity2Print(arg1_102:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_102, findTF(arg0_102, "icon_bg"))
	setFrame(findTF(arg0_102, "icon_bg/frame"), var0_102)

	local var1_102 = findTF(arg0_102, "icon_bg/icon")

	var4_0(var1_102, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync("equips/" .. arg1_102:getConfig("icon"), "", var1_102)
	setIconStars(arg0_102, true, arg1_102:getConfig("rarity"))
	var7_0(arg0_102, arg1_102:getConfig("level") - 1)
	setIconName(arg0_102, arg1_102:getConfig("name"), arg2_102)
	setIconCount(arg0_102, arg1_102.count)
	setIconColorful(arg0_102, arg1_102:getConfig("rarity") - 1, arg2_102)
end

function updateItem(arg0_103, arg1_103, arg2_103)
	arg2_103 = arg2_103 or {}

	local var0_103 = ItemRarity.Rarity2Print(arg1_103:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_103, findTF(arg0_103, "icon_bg"))

	local var1_103

	if arg1_103:getConfig("type") == 9 then
		var1_103 = "frame_design"
	elseif arg1_103:getConfig("type") == 100 then
		var1_103 = "frame_dorm"
	elseif arg2_103.frame then
		var1_103 = arg2_103.frame
	end

	setFrame(findTF(arg0_103, "icon_bg/frame"), var0_103, var1_103)

	local var2_103 = findTF(arg0_103, "icon_bg/icon")
	local var3_103 = arg1_103.icon or arg1_103:getConfig("icon")

	if arg1_103:getConfig("type") == Item.LOVE_LETTER_TYPE then
		assert(arg1_103.extra, "without extra data")

		var3_103 = "SquareIcon/" .. ShipGroup.getDefaultSkin(arg1_103.extra).painting
	end

	GetImageSpriteFromAtlasAsync(var3_103, "", var2_103)
	setIconStars(arg0_103, false)
	setIconName(arg0_103, arg1_103:getName(), arg2_103)
	setIconColorful(arg0_103, arg1_103:getConfig("rarity"), arg2_103)
end

function updateIslandUnlock(arg0_104, arg1_104)
	local var0_104 = arg1_104:getConfigTable().cmd_icon

	setIslandRarityFrame(arg0_104, arg1_104)
	setActive(findTF(arg0_104, "icon_bg/count_bg"), false)
	GetImageSpriteFromAtlasAsync("island/" .. var0_104, "", findTF(arg0_104, "icon_bg/icon"))
	setIconName(arg0_104, "", {})
end

function updateIslandInvitation(arg0_105, arg1_105)
	local var0_105 = pg.island_chara_template[arg1_105.id].invite_item
	local var1_105 = pg.island_item_data_template[var0_105].icon

	setIslandRarityFrame(arg0_105, arg1_105)
	setActive(findTF(arg0_105, "icon_bg/count_bg"), arg1_105.count > 0)
	setText(findTF(arg0_105, "icon_bg/count_bg/count"), arg1_105.count)
	GetImageSpriteFromAtlasAsync("island/" .. var1_105, "", findTF(arg0_105, "icon_bg/icon"))
	setIconName(arg0_105, "", {})
end

function updateIslandItem(arg0_106, arg1_106)
	local var0_106 = arg1_106:getConfigTable().icon
	local var1_106 = arg1_106:getConfigTable().name

	setIslandRarityFrame(arg0_106, arg1_106)
	setActive(findTF(arg0_106, "icon_bg/count_bg"), arg1_106.count > 0)
	setText(findTF(arg0_106, "icon_bg/count_bg/count"), arg1_106.count)
	GetImageSpriteFromAtlasAsync("island/" .. var0_106, "", findTF(arg0_106, "icon_bg/icon"))
	setIconName(arg0_106, var1_106, {})
end

function updateIslandFurniture(arg0_107, arg1_107)
	local var0_107 = arg1_107:getConfigTable().rarity
	local var1_107 = arg1_107:getConfigTable().icon
	local var2_107 = arg1_107:getConfigTable().name

	setIslandRarityFrame(arg0_107, arg1_107)
	setActive(findTF(arg0_107, "icon_bg/count_bg"), arg1_107.count > 0)
	setText(findTF(arg0_107, "icon_bg/count_bg/count"), arg1_107.count)
	GetImageSpriteFromAtlasAsync("island/IslandFurnitureIcon/" .. var1_107, "", findTF(arg0_107, "icon_bg/icon"))
	setIconName(arg0_107, var2_107, {})
end

function updateDefaultIconTpl(arg0_108, arg1_108, arg2_108)
	arg2_108 = arg2_108 or {}

	local var0_108 = arg1_108:getDropRarity()
	local var1_108 = ItemRarity.Rarity2Print(var0_108)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_108, arg0_108:Find("icon_bg"))
	setFrame(arg0_108:Find("icon_bg/frame"), var1_108)

	local var2_108 = arg0_108:Find("icon_bg/icon")

	for iter0_108, iter1_108 in ipairs({
		arg1_108:getIcon(),
		arg1_108:getDefaultIcon()
	}) do
		if noEmptyStr(iter1_108) and checkABExist(iter1_108) then
			GetImageSpriteFromAtlasAsync(iter1_108, "", var2_108)

			break
		end
	end

	setIconStars(arg0_108, false)
	setIconName(arg0_108, arg1_108:getName(), arg2_108)
	setIconColorful(arg0_108, var0_108, arg2_108)
end

function updateIslandDefaultIconTpl(arg0_109, arg1_109, arg2_109)
	GetImageSpriteFromAtlasAsync(arg1_109:getIcon(), "", findTF(arg0_109, "icon_bg/icon"))
	setActive(findTF(arg0_109, "icon_bg/count_bg"), arg1_109.count > 0)
	setText(findTF(arg0_109, "icon_bg/count_bg/count"), arg1_109.count)
	setIconName(arg0_109, arg1_109:getName(), {})
	setIslandRarityFrame(arg0_109, arg1_109)
end

function setIslandRarityFrame(arg0_110, arg1_110)
	local var0_110 = arg1_110:getIslandRarity()
	local var1_110 = IslandItemRarity.Rarity2FrameName(var0_110)

	GetImageSpriteFromAtlasAsync("island/islandframe", var1_110, findTF(arg0_110, "icon_bg"))

	if not IsNil(findTF(arg0_110, "icon_bg/frame")) then
		GetImageSpriteFromAtlasAsync("island/islandframe", var1_110, findTF(arg0_110, "icon_bg/frame"))
	end
end

function getIslandSeasonPtInfo()
	local var0_111 = pg.island_set.season_pt.key_value_varchar

	return {
		name = var0_111[1],
		icon = var0_111[2]
	}
end

function updateIslandSeasonPt(arg0_112, arg1_112)
	local var0_112 = getIslandSeasonPtInfo()

	GetImageSpriteFromAtlasAsync("island/" .. var0_112.icon, "", findTF(arg0_112, "icon_bg/icon"))
	setActive(findTF(arg0_112, "icon_bg/count_bg"), arg1_112.count > 0)
	setText(findTF(arg0_112, "icon_bg/count_bg/count"), arg1_112.count)
	setIslandRarityFrame(arg0_112, arg1_112)
end

function updateIslandCardDiy(arg0_113, arg1_113)
	GetImageSpriteFromAtlasAsync(arg1_113:getIcon(), "", findTF(arg0_113, "icon_bg/icon"))
	setActive(findTF(arg0_113, "icon_bg/count_bg"), arg1_113.count > 0)
	setText(findTF(arg0_113, "icon_bg/count_bg/count"), arg1_113.count)
	setIconName(arg0_113, arg1_113:getConfigTable().name, {})
	setIslandRarityFrame(arg0_113, arg1_113)
end

function updateIslandSpeedupTicket(arg0_114, arg1_114)
	local var0_114 = arg1_114:getConfigTable().icon

	GetImageSpriteFromAtlasAsync("island/" .. var0_114, "", findTF(arg0_114, "icon_bg/icon"))
	setActive(findTF(arg0_114, "icon_bg/count_bg"), arg1_114.count > 0)
	setText(findTF(arg0_114, "icon_bg/count_bg/count"), arg1_114.count)
	setIconName(arg0_114, arg1_114:getConfigTable().name, {})
	setIslandRarityFrame(arg0_114, arg1_114)
end

function updateIslandSkin(arg0_115, arg1_115)
	local var0_115 = arg1_115:getConfigTable().icon

	GetImageSpriteFromAtlasAsync("island/IslandDressIcon/" .. var0_115, "", findTF(arg0_115, "icon_bg/icon"))
	setActive(findTF(arg0_115, "icon_bg/count_bg"), arg1_115.count > 0)
	setText(findTF(arg0_115, "icon_bg/count_bg/count"), arg1_115.count)
	setIconName(arg0_115, arg1_115:getConfigTable().name, {})
	setIslandRarityFrame(arg0_115, arg1_115)
end

function updateIslandWatherCollect(arg0_116, arg1_116)
	local var0_116 = arg1_116:getConfigTable().icon
	local var1_116 = arg1_116:getConfigTable().name

	setText(findTF(arg0_116, "icon_bg/count"), arg1_116.count)
	GetImageSpriteFromAtlasAsync("island/" .. var0_116, "", findTF(arg0_116, "icon_bg/icon"))
	setIconName(arg0_116, var1_116, {})
	setIslandRarityFrame(arg0_116, arg1_116)
end

function updateWorldItem(arg0_117, arg1_117, arg2_117)
	arg2_117 = arg2_117 or {}

	local var0_117 = ItemRarity.Rarity2Print(arg1_117:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_117, findTF(arg0_117, "icon_bg"))
	setFrame(findTF(arg0_117, "icon_bg/frame"), var0_117)

	local var1_117 = findTF(arg0_117, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_117.icon or arg1_117:getConfig("icon"), "", var1_117)
	setIconStars(arg0_117, false)
	setIconName(arg0_117, arg1_117:getConfig("name"), arg2_117)
	setIconColorful(arg0_117, arg1_117:getConfig("rarity"), arg2_117)
end

function updateWorldCollection(arg0_118, arg1_118, arg2_118)
	arg2_118 = arg2_118 or {}

	assert(arg1_118:getConfigTable(), "world_collection_file_template 和 world_collection_record_template 表中找不到配置: " .. arg1_118.id)

	local var0_118 = arg1_118:getDropRarity()
	local var1_118 = ItemRarity.Rarity2Print(var0_118)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_118, findTF(arg0_118, "icon_bg"))
	setFrame(findTF(arg0_118, "icon_bg/frame"), var1_118)

	local var2_118 = findTF(arg0_118, "icon_bg/icon")
	local var3_118 = WorldCollectionProxy.GetCollectionType(arg1_118.id) == WorldCollectionProxy.WorldCollectionType.FILE and "shoucangguangdie" or "shoucangjiaojuan"

	GetImageSpriteFromAtlasAsync("props/" .. var3_118, "", var2_118)
	setIconStars(arg0_118, false)
	setIconName(arg0_118, arg1_118:getName(), arg2_118)
	setIconColorful(arg0_118, var0_118, arg2_118)
end

function updateWorldBuff(arg0_119, arg1_119, arg2_119)
	arg2_119 = arg2_119 or {}

	local var0_119 = pg.world_SLGbuff_data[arg1_119]

	assert(var0_119, "找不到大世界buff配置: " .. arg1_119)

	local var1_119 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_119, findTF(arg0_119, "icon_bg"))
	setFrame(findTF(arg0_119, "icon_bg/frame"), var1_119)

	local var2_119 = findTF(arg0_119, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("world/buff/" .. var0_119.icon, "", var2_119)

	local var3_119 = arg0_119:Find("icon_bg/stars")

	if not IsNil(var3_119) then
		setActive(var3_119, false)
	end

	local var4_119 = findTF(arg0_119, "name")

	if not IsNil(var4_119) then
		setText(var4_119, var0_119.name)
	end

	local var5_119 = findTF(arg0_119, "icon_bg/count")

	if not IsNil(var5_119) then
		SetActive(var5_119, false)
	end
end

function updateShip(arg0_120, arg1_120, arg2_120)
	arg2_120 = arg2_120 or {}

	local var0_120 = arg1_120:rarity2bgPrint()
	local var1_120 = arg1_120:getPainting()

	if arg2_120.anonymous then
		var0_120 = "1"
		var1_120 = "unknown"
	end

	if arg2_120.unknown_small then
		var1_120 = "unknown_small"
	end

	local var2_120 = findTF(arg0_120, "icon_bg/new")

	if var2_120 then
		if arg2_120.isSkin then
			setActive(var2_120, not arg2_120.isTimeLimit and arg2_120.isNew)
		else
			setActive(var2_120, arg1_120.virgin)
		end
	end

	local var3_120 = findTF(arg0_120, "icon_bg/timelimit")

	if var3_120 then
		setActive(var3_120, arg2_120.isTimeLimit)
	end

	local var4_120 = findTF(arg0_120, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. (arg2_120.isSkin and "_skin" or var0_120), var4_120)

	local var5_120 = findTF(arg0_120, "icon_bg/frame")
	local var6_120

	if arg1_120.isNpc then
		var6_120 = "frame_npc"
	elseif arg1_120:ShowPropose() then
		var6_120 = "frame_prop"

		if arg1_120:isMetaShip() then
			var6_120 = var6_120 .. "_meta"
		end
	elseif arg2_120.isSkin then
		var6_120 = "frame_skin"
	end

	setFrame(var5_120, var0_120, var6_120)

	if arg2_120.gray then
		setGray(var4_120, true, true)
	end

	local var7_120 = findTF(arg0_120, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg2_120.Q and "QIcon/" or "SquareIcon/") .. var1_120, "", var7_120)

	local var8_120 = findTF(arg0_120, "icon_bg/lv")

	if var8_120 then
		setActive(var8_120, not arg1_120.isNpc)

		if not arg1_120.isNpc then
			local var9_120 = findTF(var8_120, "Text")

			if var9_120 and arg1_120.level then
				setText(var9_120, arg1_120.level)
			end
		end
	end

	local var10_120 = findTF(arg0_120, "ship_type")

	if var10_120 then
		setActive(var10_120, true)
		setImageSprite(var10_120, GetSpriteFromAtlas("shiptype", shipType2print(arg1_120:getShipType())))
	end

	local var11_120 = var4_120:Find("npc")

	if not IsNil(var11_120) then
		if var2_120 and go(var2_120).activeSelf then
			setActive(var11_120, false)
		else
			setActive(var11_120, arg1_120:isActivityNpc())
		end
	end

	local var12_120 = arg0_120:Find("group_locked")

	if var12_120 then
		setActive(var12_120, not arg2_120.isSkin and not getProxy(CollectionProxy):getShipGroup(arg1_120.groupId))
	end

	setIconStars(arg0_120, arg2_120.initStar, arg1_120:getStar())
	setIconName(arg0_120, arg2_120.isSkin and arg1_120:GetSkinConfig().name or arg1_120:getName(), arg2_120)
	setIconColorful(arg0_120, arg2_120.isSkin and ItemRarity.Gold or arg1_120:getRarity() - 1, arg2_120)
end

function updateCommander(arg0_121, arg1_121, arg2_121)
	arg2_121 = arg2_121 or {}

	local var0_121 = arg1_121:getDropRarity()
	local var1_121 = ItemRarity.Rarity2Print(var0_121)
	local var2_121 = arg1_121:getConfig("painting")

	if arg2_121.anonymous then
		var1_121 = 1
		var2_121 = "unknown"
	end

	local var3_121 = findTF(arg0_121, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_121, var3_121)

	local var4_121 = findTF(arg0_121, "icon_bg/frame")

	setFrame(var4_121, var1_121)

	if arg2_121.gray then
		setGray(var3_121, true, true)
	end

	local var5_121 = findTF(arg0_121, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("CommanderIcon/" .. var2_121, "", var5_121)
	setIconStars(arg0_121, arg2_121.initStar, 0)
	setIconName(arg0_121, arg1_121:getName(), arg2_121)
end

function updateStrategy(arg0_122, arg1_122, arg2_122)
	arg2_122 = arg2_122 or {}

	local var0_122 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_122, findTF(arg0_122, "icon_bg"))
	setFrame(findTF(arg0_122, "icon_bg/frame"), var0_122)

	local var1_122 = findTF(arg0_122, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg1_122.isWorldBuff and "world/buff/" or "strategyicon/") .. arg1_122:getIcon(), "", var1_122)
	setIconStars(arg0_122, false)
	setIconName(arg0_122, arg1_122:getName(), arg2_122)
	setIconColorful(arg0_122, ItemRarity.Gray, arg2_122)
end

function updateFurniture(arg0_123, arg1_123, arg2_123)
	arg2_123 = arg2_123 or {}

	local var0_123 = arg1_123:getDropRarity()
	local var1_123 = ItemRarity.Rarity2Print(var0_123)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_123, findTF(arg0_123, "icon_bg"))
	setFrame(findTF(arg0_123, "icon_bg/frame"), var1_123)

	local var2_123 = findTF(arg0_123, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1_123:getIcon(), "", var2_123)
	setIconStars(arg0_123, false)
	setIconName(arg0_123, arg1_123:getName(), arg2_123)
	setIconColorful(arg0_123, var0_123, arg2_123)
end

function updateSpWeapon(arg0_124, arg1_124, arg2_124)
	arg2_124 = arg2_124 or {}

	assert(arg1_124, "spWeaponVO can not be nil.")
	assert(isa(arg1_124, SpWeapon), "spWeaponVO is not Equipment.")

	local var0_124 = ItemRarity.Rarity2Print(arg1_124:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_124, findTF(arg0_124, "icon_bg"))
	setFrame(findTF(arg0_124, "icon_bg/frame"), var0_124)

	local var1_124 = findTF(arg0_124, "icon_bg/icon")

	var4_0(var1_124, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync(arg1_124:GetIconPath(), "", var1_124)
	setIconStars(arg0_124, true, arg1_124:GetRarity())
	var7_0(arg0_124, arg1_124:GetLevel() - 1)
	setIconName(arg0_124, arg1_124:GetName(), arg2_124)
	setIconCount(arg0_124, arg1_124.count)
	setIconColorful(arg0_124, arg1_124:GetRarity(), arg2_124)
end

function UpdateSpWeaponSlot(arg0_125, arg1_125, arg2_125)
	local var0_125 = ItemRarity.Rarity2Print(arg1_125:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_125, findTF(arg0_125, "Icon/Mask/icon_bg"))

	local var1_125 = findTF(arg0_125, "Icon/Mask/icon_bg/icon")

	arg2_125 = arg2_125 or {
		16,
		16,
		16,
		16
	}

	var4_0(var1_125, arg2_125)
	GetImageSpriteFromAtlasAsync(arg1_125:GetIconPath(), "", var1_125)

	local var2_125 = arg1_125:GetLevel() - 1
	local var3_125 = findTF(arg0_125, "Icon/LV")

	setActive(var3_125, var2_125 > 0)
	setText(findTF(var3_125, "Text"), var2_125)
end

function updateDorm3dIcon(arg0_126, arg1_126)
	local var0_126 = arg1_126:getDropRarityDorm()

	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(var0_126), arg0_126)

	local var1_126 = arg0_126:Find("icon")

	GetImageSpriteFromAtlasAsync(arg1_126:getIcon(), "", var1_126)
	setText(arg0_126:Find("count/Text"), "x" .. arg1_126.count)
	setText(arg0_126:Find("name/Text"), arg1_126:getName())
end

function setLoveLetterMedal(arg0_127, arg1_127, arg2_127)
	local var0_127

	seriesAsync({
		function(arg0_128)
			GetPrefabFromAtlasAsync(arg1_127:GetPrefabName(), arg0_127, function(arg0_129)
				var0_127 = arg0_129.transform

				eachChild(arg0_127, function(arg0_130, arg1_130)
					if arg0_130.name ~= arg0_129.name then
						returnLoveLetterMedal(arg0_130)
					end
				end)
				arg0_128()
			end)
		end
	}, function()
		local var0_131 = arg1_127:GetPainting()

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. var0_131, "", var0_127:Find("mask/icon"))
		setText(var0_127:Find("front/mark/Text"), arg1_127:GetDisplayLevelMark())
		setActive(var0_127:Find("pick_up"), arg2_127 and arg2_127.showPickUp)
		setActive(var0_127:Find("front/mark"), true)

		if arg2_127 and arg2_127.hideMark then
			setActive(var0_127:Find("front/mark"), false)
		end
	end)
end

function returnLoveLetterMedal(arg0_132)
	if IsNil(arg0_132) then
		return
	end

	local var0_132 = string.gsub(arg0_132.name, "%(Clone%)", "")

	pg.PoolMgr.GetInstance():ReturnPrefab("lovelettermedal/" .. string.lower(var0_132), "", arg0_132.gameObject)
end

local var8_0

function findCullAndClipWorldRect(arg0_133)
	if #arg0_133 == 0 then
		return false
	end

	local var0_133 = arg0_133[1].canvasRect

	for iter0_133 = 1, #arg0_133 do
		var0_133 = rectIntersect(var0_133, arg0_133[iter0_133].canvasRect)
	end

	if var0_133.width <= 0 or var0_133.height <= 0 then
		return false
	end

	var8_0 = var8_0 or GameObject.Find("UICamera/Canvas").transform

	local var1_133 = var8_0:TransformPoint(Vector3(var0_133.x, var0_133.y, 0))
	local var2_133 = var8_0:TransformPoint(Vector3(var0_133.x + var0_133.width, var0_133.y + var0_133.height, 0))

	return true, Vector4(var1_133.x, var1_133.y, var2_133.x, var2_133.y)
end

function rectIntersect(arg0_134, arg1_134)
	local var0_134 = math.max(arg0_134.x, arg1_134.x)
	local var1_134 = math.min(arg0_134.x + arg0_134.width, arg1_134.x + arg1_134.width)
	local var2_134 = math.max(arg0_134.y, arg1_134.y)
	local var3_134 = math.min(arg0_134.y + arg0_134.height, arg1_134.y + arg1_134.height)

	if var0_134 <= var1_134 and var2_134 <= var3_134 then
		return var0_0.Rect.New(var0_134, var2_134, var1_134 - var0_134, var3_134 - var2_134)
	end

	return var0_0.Rect.New(0, 0, 0, 0)
end

function getDropInfo(arg0_135)
	local var0_135 = {}

	for iter0_135, iter1_135 in ipairs(arg0_135) do
		local var1_135 = Drop.Create(iter1_135)

		var1_135.count = var1_135.count or 1

		if var1_135.type == DROP_TYPE_EMOJI then
			table.insert(var0_135, var1_135:getName())
		else
			table.insert(var0_135, var1_135:getName() .. "x" .. var1_135.count)
		end
	end

	return table.concat(var0_135, "、")
end

function updateDrop(arg0_136, arg1_136, arg2_136)
	Drop.Change(arg1_136)

	arg2_136 = arg2_136 or {}

	local var0_136 = {
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
	local var1_136

	for iter0_136, iter1_136 in ipairs(var0_136) do
		local var2_136 = arg0_136:Find(iter1_136[1])

		if arg1_136.type ~= iter1_136[2] and not IsNil(var2_136) then
			setActive(var2_136, false)
		end
	end

	if not IsNil(arg0_136:Find("icon_bg/frame")) then
		arg0_136:Find("icon_bg/frame"):GetComponent(typeof(Image)).enabled = true

		setIconColorful(arg0_136, arg1_136:getDropRarity(), arg2_136, {
			[ItemRarity.Gold] = {
				name = "Item_duang5",
				active = function(arg0_137, arg1_137)
					return arg1_137.fromAwardLayer and arg0_137 >= ItemRarity.Gold
				end
			}
		})
		var4_0(findTF(arg0_136, "icon_bg/icon"), {
			2,
			2,
			2,
			2
		})
	end

	arg1_136:UpdateDropTpl(arg0_136, arg2_136)
	setIconCount(arg0_136, arg2_136.count or arg1_136:getCount())
end

function updateCustomDrop(arg0_138, arg1_138, arg2_138)
	Drop.Change(arg1_138)

	arg2_138 = arg2_138 or {}

	arg1_138:UpdateCustomDropTpl(arg0_138, arg2_138)
end

function updateBuff(arg0_139, arg1_139, arg2_139)
	arg2_139 = arg2_139 or {}

	local var0_139 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_139, findTF(arg0_139, "icon_bg"))

	local var1_139 = pg.benefit_buff_template[arg1_139]

	setFrame(findTF(arg0_139, "icon_bg/frame"), var0_139)
	setText(findTF(arg0_139, "icon_bg/count"), 1)

	local var2_139 = findTF(arg0_139, "icon_bg/icon")
	local var3_139 = var1_139.icon

	GetImageSpriteFromAtlasAsync(var3_139, "", var2_139)
	setIconStars(arg0_139, false)
	setIconName(arg0_139, var1_139.name, arg2_139)
	setIconColorful(arg0_139, ItemRarity.Gold, arg2_139)
end

function updateAttire(arg0_140, arg1_140, arg2_140, arg3_140)
	local var0_140 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_140, findTF(arg0_140, "icon_bg"))
	setFrame(findTF(arg0_140, "icon_bg/frame"), var0_140)

	local var1_140 = findTF(arg0_140, "icon_bg/icon")
	local var2_140

	if arg1_140 == AttireConst.TYPE_CHAT_FRAME then
		var2_140 = "chat_frame"
	elseif arg1_140 == AttireConst.TYPE_ICON_FRAME then
		var2_140 = "icon_frame"
	end

	GetImageSpriteFromAtlasAsync("Props/" .. var2_140, "", var1_140)
	setIconName(arg0_140, arg2_140.name, arg3_140)
end

function updateAttireCombatUI(arg0_141, arg1_141, arg2_141, arg3_141)
	local var0_141 = arg2_141.rare

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_141, findTF(arg0_141, "icon_bg"))
	setFrame(findTF(arg0_141, "icon_bg/frame"), var0_141, "frame_battle_ui")

	local var1_141 = findTF(arg0_141, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("Props/" .. arg2_141.display_icon, "", var1_141)
	setIconName(arg0_141, arg2_141.name, arg3_141)
end

function updateActivityMedal(arg0_142, arg1_142, arg2_142)
	local var0_142 = ItemRarity.Rarity2Print(arg1_142.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_142, findTF(arg0_142, "icon_bg"))
	setFrame(findTF(arg0_142, "icon_bg/frame"), var0_142)

	local var1_142 = findTF(arg0_142, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_142.icon, "", var1_142)
	setIconName(arg0_142, arg1_142.name, arg2_142)
end

function updateCover(arg0_143, arg1_143, arg2_143)
	local var0_143 = arg1_143:getDropRarity()

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_143, findTF(arg0_143, "icon_bg"))
	setFrame(findTF(arg0_143, "icon_bg/frame"), var0_143)

	local var1_143 = findTF(arg0_143, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_143:getIcon(), "", var1_143)
	setIconName(arg0_143, arg1_143:getName(), arg2_143)
	setIconStars(arg0_143, false)
end

function updateEmoji(arg0_144, arg1_144, arg2_144)
	local var0_144 = findTF(arg0_144, "icon_bg/icon")
	local var1_144 = "icon_emoji"

	GetImageSpriteFromAtlasAsync("Props/" .. var1_144, "", var0_144)

	local var2_144 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var2_144, findTF(arg0_144, "icon_bg"))
	setFrame(findTF(arg0_144, "icon_bg/frame"), var2_144)
	setIconName(arg0_144, arg1_144.name, arg2_144)
end

function updateEquipmentSkin(arg0_145, arg1_145, arg2_145)
	arg2_145 = arg2_145 or {}

	local var0_145 = EquipmentRarity.Rarity2Print(arg1_145.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_145, findTF(arg0_145, "icon_bg"))
	setFrame(findTF(arg0_145, "icon_bg/frame"), var0_145, "frame_skin")

	local var1_145 = findTF(arg0_145, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. arg1_145.icon, "", var1_145)
	setIconStars(arg0_145, false)
	setIconName(arg0_145, arg1_145.name, arg2_145)
	setIconCount(arg0_145, arg1_145.count)
	setIconColorful(arg0_145, arg1_145.rarity - 1, arg2_145)
end

function NoPosMsgBox(arg0_146, arg1_146, arg2_146, arg3_146)
	local var0_146
	local var1_146 = {}

	if arg1_146 then
		table.insert(var1_146, {
			text = "text_noPos_clear",
			atuoClose = true,
			onCallback = arg1_146
		})
	end

	if arg2_146 then
		table.insert(var1_146, {
			text = "text_noPos_buy",
			atuoClose = true,
			onCallback = arg2_146
		})
	end

	if arg3_146 then
		table.insert(var1_146, {
			text = "text_noPos_intensify",
			atuoClose = true,
			onCallback = arg3_146
		})
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		hideNo = true,
		content = arg0_146,
		custom = var1_146
	})
end

function openDestroyEquip()
	if pg.m02:hasMediator(EquipmentMediator.__cname) then
		local var0_147 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_147 and var0_147.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_147
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
		local var0_148 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_148 and var0_148.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_148
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
		onClick = function(arg0_151, arg1_151)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
				page = 3,
				shipId = arg0_151.id,
				shipVOs = arg1_151
			})
		end
	})
end

function GoShoppingMsgBox(arg0_152, arg1_152, arg2_152)
	if arg2_152 then
		local var0_152 = ""

		for iter0_152, iter1_152 in ipairs(arg2_152) do
			local var1_152 = Item.getConfigData(iter1_152[1])

			var0_152 = var0_152 .. i18n(iter1_152[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var1_152.name, iter1_152[2])

			if iter0_152 < #arg2_152 then
				var0_152 = var0_152 .. i18n("text_noRes_info_tip_link")
			end
		end

		if var0_152 ~= "" then
			arg0_152 = arg0_152 .. "\n" .. i18n("text_noRes_tip", var0_152)
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = arg0_152,
		onYes = function()
			gotoChargeScene(arg1_152, arg2_152)
		end
	})
end

function shoppingBatch(arg0_154, arg1_154, arg2_154, arg3_154, arg4_154)
	local var0_154 = pg.shop_template[arg0_154]

	assert(var0_154, "shop_template中找不到商品id：" .. arg0_154)

	local var1_154 = getProxy(PlayerProxy):getData()[id2res(var0_154.resource_type)]
	local var2_154 = arg1_154.price or var0_154.resource_num
	local var3_154 = math.floor(var1_154 / var2_154)

	var3_154 = var3_154 <= 0 and 1 or var3_154
	var3_154 = arg2_154 ~= nil and arg2_154 < var3_154 and arg2_154 or var3_154

	local var4_154 = true
	local var5_154 = 1

	if var0_154 ~= nil and arg1_154.id then
		print(var3_154 * var0_154.num, "--", var3_154)
		assert(Item.getConfigData(arg1_154.id), "item config should be existence")

		local var6_154 = Item.New({
			id = arg1_154.id
		}):getConfig("name")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			needCounter = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_ITEM,
				id = arg1_154.id
			},
			addNum = var0_154.num,
			maxNum = var3_154 * var0_154.num,
			defaultNum = var0_154.num,
			numUpdate = function(arg0_155, arg1_155)
				var5_154 = math.floor(arg1_155 / var0_154.num)

				local var0_155 = var5_154 * var2_154

				if var0_155 > var1_154 then
					setText(arg0_155, i18n(arg3_154, var0_155, arg1_155, COLOR_RED, var6_154))

					var4_154 = false
				else
					setText(arg0_155, i18n(arg3_154, var0_155, arg1_155, COLOR_GREEN, var6_154))

					var4_154 = true
				end
			end,
			onYes = function()
				if var4_154 then
					pg.m02:sendNotification(GAME.SHOPPING, {
						id = arg0_154,
						count = var5_154
					})
				elseif arg4_154 then
					pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_154))
					pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_OR_SKIN_FAILD)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("main_playerInfoLayer_error_changeNameNoGem"))
				end
			end
		})
	end
end

function shoppingBatchNewStyle(arg0_157, arg1_157, arg2_157, arg3_157, arg4_157)
	local var0_157 = pg.shop_template[arg0_157]

	assert(var0_157, "shop_template中找不到商品id：" .. arg0_157)

	local var1_157 = getProxy(PlayerProxy):getData()[id2res(var0_157.resource_type)]
	local var2_157 = arg1_157.price or var0_157.resource_num
	local var3_157 = math.floor(var1_157 / var2_157)

	var3_157 = var3_157 <= 0 and 1 or var3_157
	var3_157 = arg2_157 ~= nil and arg2_157 < var3_157 and arg2_157 or var3_157

	local var4_157 = true
	local var5_157 = 1

	if var0_157 ~= nil and arg1_157.id then
		print(var3_157 * var0_157.num, "--", var3_157)
		assert(Item.getConfigData(arg1_157.id), "item config should be existence")

		local var6_157 = Item.New({
			id = arg1_157.id
		}):getConfig("name")

		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_SHOPPING, {
			drop = Drop.New({
				count = 1,
				type = DROP_TYPE_ITEM,
				id = arg1_157.id
			}),
			price = var2_157,
			addNum = var0_157.num,
			maxNum = var3_157 * var0_157.num,
			defaultNum = var0_157.num,
			numUpdate = function(arg0_158, arg1_158)
				var5_157 = math.floor(arg1_158 / var0_157.num)

				local var0_158 = var5_157 * var2_157

				if var0_158 > var1_157 then
					setTextInNewStyleBox(arg0_158, i18n(arg3_157, var0_158, arg1_158, COLOR_RED, var6_157))

					var4_157 = false
				else
					setTextInNewStyleBox(arg0_158, i18n(arg3_157, var0_158, arg1_158, "#238C40FF", var6_157))

					var4_157 = true
				end
			end,
			btnList = {
				{
					type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.shopping,
					name = i18n("word_buy"),
					func = function()
						if var4_157 then
							pg.m02:sendNotification(GAME.SHOPPING, {
								id = arg0_157,
								count = var5_157
							})
						elseif arg4_157 then
							pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_157))
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

function gotoChargeScene(arg0_160, arg1_160)
	local var0_160 = getProxy(ContextProxy)
	local var1_160 = getProxy(ContextProxy):getCurrentContext()

	if instanceof(var1_160.mediator, NewShopMainMediator) then
		var1_160.mediator:getViewComponent():switchSubViewByTogger(arg0_160)
	else
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
			wrap = arg0_160 or ChargeScene.TYPE_ITEM,
			noRes = arg1_160
		})
	end

	pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_OR_SKIN_FAILD)
end

function clearDrop(arg0_161)
	local var0_161 = findTF(arg0_161, "icon_bg")
	local var1_161 = findTF(arg0_161, "icon_bg/frame")
	local var2_161 = findTF(arg0_161, "icon_bg/icon")
	local var3_161 = findTF(arg0_161, "icon_bg/icon/icon")

	clearImageSprite(var0_161)
	clearImageSprite(var1_161)
	clearImageSprite(var2_161)

	if var3_161 then
		clearImageSprite(var3_161)
	end
end

local var9_0 = {
	red = Color.New(1, 0.25, 0.25),
	blue = Color.New(0.11, 0.55, 0.64),
	yellow = Color.New(0.92, 0.52, 0)
}

function updateSkill(arg0_162, arg1_162, arg2_162, arg3_162)
	local var0_162 = findTF(arg0_162, "skill")
	local var1_162 = findTF(arg0_162, "lock")
	local var2_162 = findTF(arg0_162, "unknown")

	if arg1_162 then
		setActive(var0_162, true)
		setActive(var2_162, false)
		setActive(var1_162, not arg2_162)
		LoadImageSpriteAsync("skillicon/" .. arg1_162.icon, findTF(var0_162, "icon"))

		local var3_162 = arg1_162.color or "blue"

		setText(findTF(var0_162, "name"), shortenString(getSkillName(arg1_162.id), arg3_162 or 8))

		local var4_162 = findTF(var0_162, "level")

		setText(var4_162, "LEVEL: " .. (arg2_162 and arg2_162.level or "??"))
		setTextColor(var4_162, var9_0[var3_162])
	else
		setActive(var0_162, false)
		setActive(var2_162, true)
		setActive(var1_162, false)
	end
end

local var10_0 = true

function onBackButton(arg0_163, arg1_163, arg2_163, arg3_163)
	local var0_163 = GetOrAddComponent(arg1_163, "UILongPressTrigger")

	assert(arg2_163, "callback should exist")

	var0_163.longPressThreshold = defaultValue(arg3_163, 1)

	local function var1_163(arg0_164)
		return function()
			if var10_0 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SOUND_BACK)
			end

			local var0_165, var1_165 = arg2_163()

			if var0_165 then
				arg0_164(var1_165)
			end
		end
	end

	local var2_163 = var0_163.onReleased

	pg.DelegateInfo.Add(arg0_163, var2_163)
	var2_163:RemoveAllListeners()
	var2_163:AddListener(var1_163(function(arg0_166)
		arg0_166:emit(BaseUI.ON_BACK)
	end))

	local var3_163 = var0_163.onLongPressed

	pg.DelegateInfo.Add(arg0_163, var3_163)
	var3_163:RemoveAllListeners()
	var3_163:AddListener(var1_163(function(arg0_167)
		arg0_167:emit(BaseUI.ON_HOME)
	end))
end

function GetZeroTime()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)
end

function GetHalfHour()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0, 1800)
end

function GetNextHour(arg0_170)
	local var0_170 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_170, var2_170 = pg.TimeMgr.GetInstance():parseTimeFrom(var0_170)

	return var1_170 * 86400 + (var2_170 + arg0_170) * 3600
end

function GetPerceptualSize(arg0_171, arg1_171)
	local function var0_171(arg0_172)
		if not arg0_172 then
			return 0, 1
		elseif arg0_172 > 240 then
			return 4, 1
		elseif arg0_172 > 225 then
			return 3, 1
		elseif arg0_172 > 192 then
			return 2, 1
		elseif arg0_172 < 126 then
			return 1, arg1_171 or 0.5
		else
			return 1, 1
		end
	end

	if type(arg0_171) == "number" then
		return var0_171(arg0_171)
	end

	local var1_171 = 1
	local var2_171 = 0
	local var3_171 = 0
	local var4_171 = #arg0_171

	while var1_171 <= var4_171 do
		local var5_171 = string.byte(arg0_171, var1_171)
		local var6_171, var7_171 = var0_171(var5_171)

		var1_171 = var1_171 + var6_171
		var2_171 = var2_171 + var7_171
	end

	return var2_171
end

function shortenString(arg0_173, arg1_173, arg2_173)
	local var0_173 = 1
	local var1_173 = 0
	local var2_173 = 0
	local var3_173 = #arg0_173

	while var0_173 <= var3_173 do
		local var4_173 = string.byte(arg0_173, var0_173)
		local var5_173, var6_173 = GetPerceptualSize(var4_173, arg2_173)

		var0_173 = var0_173 + var5_173
		var1_173 = var1_173 + var6_173

		if arg1_173 <= math.ceil(var1_173) then
			var2_173 = var0_173

			break
		end
	end

	if var2_173 == 0 or var3_173 < var2_173 then
		return arg0_173
	end

	return string.sub(arg0_173, 1, var2_173 - 1) .. ".."
end

function shouldShortenString(arg0_174, arg1_174)
	local var0_174 = 1
	local var1_174 = 0
	local var2_174 = 0
	local var3_174 = #arg0_174

	while var0_174 <= var3_174 do
		local var4_174 = string.byte(arg0_174, var0_174)
		local var5_174, var6_174 = GetPerceptualSize(var4_174)

		var0_174 = var0_174 + var5_174
		var1_174 = var1_174 + var6_174

		if arg1_174 <= math.ceil(var1_174) then
			var2_174 = var0_174

			break
		end
	end

	if var2_174 == 0 or var3_174 < var2_174 then
		return false
	end

	return true
end

function nameValidityCheck(arg0_175, arg1_175, arg2_175, arg3_175)
	local var0_175 = true
	local var1_175, var2_175 = utf8_to_unicode(arg0_175)
	local var3_175 = filterEgyUnicode(filterSpecChars(arg0_175))
	local var4_175 = wordVer(arg0_175)

	if not checkSpaceValid(arg0_175) then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_175[1]))

		var0_175 = false
	elseif var4_175 > 0 or var3_175 ~= arg0_175 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_175[4]))

		var0_175 = false
	elseif var2_175 < arg1_175 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_175[2]))

		var0_175 = false
	elseif arg2_175 < var2_175 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_175[3]))

		var0_175 = false
	end

	return var0_175
end

function checkSpaceValid(arg0_176)
	if PLATFORM_CODE == PLATFORM_US then
		return true
	end

	local var0_176 = string.gsub(arg0_176, " ", "")

	return arg0_176 == string.gsub(var0_176, "　", "")
end

function filterSpecChars(arg0_177)
	local var0_177 = {}
	local var1_177 = 0
	local var2_177 = 0
	local var3_177 = 0
	local var4_177 = 1

	while var4_177 <= #arg0_177 do
		local var5_177 = string.byte(arg0_177, var4_177)

		if not var5_177 then
			break
		end

		if var5_177 >= 48 and var5_177 <= 57 or var5_177 >= 65 and var5_177 <= 90 or var5_177 == 95 or var5_177 >= 97 and var5_177 <= 122 then
			table.insert(var0_177, string.char(var5_177))
		elseif var5_177 >= 228 and var5_177 <= 233 then
			local var6_177 = string.byte(arg0_177, var4_177 + 1)
			local var7_177 = string.byte(arg0_177, var4_177 + 2)

			if var6_177 and var7_177 and var6_177 >= 128 and var6_177 <= 191 and var7_177 >= 128 and var7_177 <= 191 then
				var4_177 = var4_177 + 2

				table.insert(var0_177, string.char(var5_177, var6_177, var7_177))

				var1_177 = var1_177 + 1
			end
		elseif var5_177 == 45 or var5_177 == 40 or var5_177 == 41 then
			table.insert(var0_177, string.char(var5_177))
		elseif var5_177 == 194 then
			local var8_177 = string.byte(arg0_177, var4_177 + 1)

			if var8_177 == 183 then
				var4_177 = var4_177 + 1

				table.insert(var0_177, string.char(var5_177, var8_177))

				var1_177 = var1_177 + 1
			end
		elseif var5_177 == 239 then
			local var9_177 = string.byte(arg0_177, var4_177 + 1)
			local var10_177 = string.byte(arg0_177, var4_177 + 2)

			if var9_177 == 188 and (var10_177 == 136 or var10_177 == 137) then
				var4_177 = var4_177 + 2

				table.insert(var0_177, string.char(var5_177, var9_177, var10_177))

				var1_177 = var1_177 + 1
			end
		elseif var5_177 == 206 or var5_177 == 207 then
			local var11_177 = string.byte(arg0_177, var4_177 + 1)

			if var5_177 == 206 and var11_177 >= 177 or var5_177 == 207 and var11_177 <= 134 then
				var4_177 = var4_177 + 1

				table.insert(var0_177, string.char(var5_177, var11_177))

				var1_177 = var1_177 + 1
			end
		elseif var5_177 == 227 and PLATFORM_CODE == PLATFORM_JP then
			local var12_177 = string.byte(arg0_177, var4_177 + 1)
			local var13_177 = string.byte(arg0_177, var4_177 + 2)

			if var12_177 and var13_177 and var12_177 > 128 and var12_177 <= 191 and var13_177 >= 128 and var13_177 <= 191 then
				var4_177 = var4_177 + 2

				table.insert(var0_177, string.char(var5_177, var12_177, var13_177))

				var2_177 = var2_177 + 1
			end
		elseif var5_177 >= 224 and PLATFORM_CODE == PLATFORM_KR then
			local var14_177 = string.byte(arg0_177, var4_177 + 1)
			local var15_177 = string.byte(arg0_177, var4_177 + 2)

			if var14_177 and var15_177 and var14_177 >= 128 and var14_177 <= 191 and var15_177 >= 128 and var15_177 <= 191 then
				var4_177 = var4_177 + 2

				table.insert(var0_177, string.char(var5_177, var14_177, var15_177))

				var3_177 = var3_177 + 1
			end
		elseif PLATFORM_CODE == PLATFORM_US then
			if var4_177 ~= 1 and var5_177 == 32 and string.byte(arg0_177, var4_177 + 1) ~= 32 then
				table.insert(var0_177, string.char(var5_177))
			end

			if var5_177 >= 192 and var5_177 <= 223 then
				local var16_177 = string.byte(arg0_177, var4_177 + 1)

				var4_177 = var4_177 + 1

				if var5_177 == 194 and var16_177 and var16_177 >= 128 then
					table.insert(var0_177, string.char(var5_177, var16_177))
				elseif var5_177 == 195 and var16_177 and var16_177 <= 191 then
					table.insert(var0_177, string.char(var5_177, var16_177))
				end
			end
		end

		var4_177 = var4_177 + 1
	end

	return table.concat(var0_177), var1_177 + var2_177 + var3_177
end

function filterEgyUnicode(arg0_178)
	arg0_178 = string.gsub(arg0_178, "�[�-�][�-�]", "")
	arg0_178 = string.gsub(arg0_178, "�[�-�]", "")

	return arg0_178
end

function shiftPanel(arg0_179, arg1_179, arg2_179, arg3_179, arg4_179, arg5_179, arg6_179, arg7_179, arg8_179)
	arg3_179 = arg3_179 or 0.2

	if arg5_179 then
		LeanTween.cancel(go(arg0_179))
	end

	local var0_179 = rtf(arg0_179)

	arg1_179 = arg1_179 or var0_179.anchoredPosition.x
	arg2_179 = arg2_179 or var0_179.anchoredPosition.y

	local var1_179 = LeanTween.move(var0_179, Vector3(arg1_179, arg2_179, 0), arg3_179)

	arg7_179 = arg7_179 or LeanTweenType.easeInOutSine

	var1_179:setEase(arg7_179)

	if arg4_179 then
		var1_179:setDelay(arg4_179)
	end

	if arg6_179 then
		GetOrAddComponent(arg0_179, "CanvasGroup").blocksRaycasts = false
	end

	var1_179:setOnComplete(System.Action(function()
		if arg8_179 then
			arg8_179()
		end

		if arg6_179 then
			GetOrAddComponent(arg0_179, "CanvasGroup").blocksRaycasts = true
		end
	end))

	return var1_179
end

function TweenValue(arg0_181, arg1_181, arg2_181, arg3_181, arg4_181, arg5_181, arg6_181, arg7_181)
	local var0_181 = LeanTween.value(go(arg0_181), arg1_181, arg2_181, arg3_181):setOnUpdate(System.Action_float(function(arg0_182)
		if arg5_181 then
			arg5_181(arg0_182)
		end
	end)):setOnComplete(System.Action(function()
		if arg6_181 then
			arg6_181()
		end
	end)):setDelay(arg4_181 or 0)

	if arg7_181 and arg7_181 > 0 then
		var0_181:setRepeat(arg7_181)
	end

	return var0_181
end

function rotateAni(arg0_184, arg1_184, arg2_184)
	return LeanTween.rotate(rtf(arg0_184), 360 * arg1_184, arg2_184):setLoopClamp()
end

function blinkAni(arg0_185, arg1_185, arg2_185, arg3_185)
	return LeanTween.alpha(rtf(arg0_185), arg3_185 or 0, arg1_185):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(arg2_185 or 0)
end

function scaleAni(arg0_186, arg1_186, arg2_186, arg3_186)
	return LeanTween.scale(rtf(arg0_186), arg3_186 or 0, arg1_186):setLoopPingPong(arg2_186 or 0)
end

function floatAni(arg0_187, arg1_187, arg2_187, arg3_187)
	local var0_187 = arg0_187.localPosition.y + arg1_187

	return LeanTween.moveY(rtf(arg0_187), var0_187, arg2_187):setLoopPingPong(arg3_187 or 0)
end

local var11_0 = tostring

function tostring(arg0_188)
	if arg0_188 == nil then
		return "nil"
	end

	local var0_188 = var11_0(arg0_188)

	if var0_188 == nil then
		if type(arg0_188) == "table" then
			return "{}"
		end

		return " ~nil"
	end

	return var0_188
end

function wordVer(arg0_189, arg1_189)
	if arg0_189.match(arg0_189, ChatConst.EmojiCodeMatch) then
		return 0, arg0_189
	end

	arg1_189 = arg1_189 or {}

	local var0_189 = filterEgyUnicode(arg0_189)

	if #var0_189 ~= #arg0_189 then
		if arg1_189.isReplace then
			arg0_189 = var0_189
		else
			return 1
		end
	end

	local var1_189 = wordSplit(arg0_189)
	local var2_189 = pg.word_template
	local var3_189 = pg.word_legal_template

	arg1_189.isReplace = arg1_189.isReplace or false
	arg1_189.replaceWord = arg1_189.replaceWord or "*"

	local var4_189 = #var1_189
	local var5_189 = 1
	local var6_189 = ""
	local var7_189 = 0

	while var5_189 <= var4_189 do
		local var8_189, var9_189, var10_189 = wordLegalMatch(var1_189, var3_189, var5_189)

		if var8_189 then
			var5_189 = var9_189
			var6_189 = var6_189 .. var10_189
		else
			local var11_189, var12_189, var13_189 = wordVerMatch(var1_189, var2_189, arg1_189, var5_189, "", false, var5_189, "")

			if var11_189 then
				var5_189 = var12_189
				var7_189 = var7_189 + 1

				if arg1_189.isReplace then
					var6_189 = var6_189 .. var13_189
				end
			else
				if arg1_189.isReplace then
					var6_189 = var6_189 .. var1_189[var5_189]
				end

				var5_189 = var5_189 + 1
			end
		end
	end

	if arg1_189.isReplace then
		return var7_189, var6_189
	else
		return var7_189
	end
end

function wordLegalMatch(arg0_190, arg1_190, arg2_190, arg3_190, arg4_190)
	if arg2_190 > #arg0_190 then
		return arg3_190, arg2_190, arg4_190
	end

	local var0_190 = arg0_190[arg2_190]
	local var1_190 = arg1_190[var0_190]

	arg4_190 = arg4_190 == nil and "" or arg4_190

	if var1_190 then
		if var1_190.this then
			return wordLegalMatch(arg0_190, var1_190, arg2_190 + 1, true, arg4_190 .. var0_190)
		else
			return wordLegalMatch(arg0_190, var1_190, arg2_190 + 1, false, arg4_190 .. var0_190)
		end
	else
		return arg3_190, arg2_190, arg4_190
	end
end

local var12_0 = string.byte("a")
local var13_0 = string.byte("z")
local var14_0 = string.byte("A")
local var15_0 = string.byte("Z")

local function var16_0(arg0_191)
	if not arg0_191 then
		return arg0_191
	end

	local var0_191 = string.byte(arg0_191)

	if var0_191 > 128 then
		return
	end

	if var0_191 >= var12_0 and var0_191 <= var13_0 then
		return string.char(var0_191 - 32)
	elseif var0_191 >= var14_0 and var0_191 <= var15_0 then
		return string.char(var0_191 + 32)
	else
		return arg0_191
	end
end

function wordVerMatch(arg0_192, arg1_192, arg2_192, arg3_192, arg4_192, arg5_192, arg6_192, arg7_192)
	if arg3_192 > #arg0_192 then
		return arg5_192, arg6_192, arg7_192
	end

	local var0_192 = arg0_192[arg3_192]
	local var1_192 = arg1_192[var0_192]

	if var1_192 then
		local var2_192, var3_192, var4_192 = wordVerMatch(arg0_192, var1_192, arg2_192, arg3_192 + 1, arg2_192.isReplace and arg4_192 .. arg2_192.replaceWord or arg4_192, var1_192.this or arg5_192, var1_192.this and arg3_192 + 1 or arg6_192, var1_192.this and (arg2_192.isReplace and arg4_192 .. arg2_192.replaceWord or arg4_192) or arg7_192)

		if var2_192 then
			return var2_192, var3_192, var4_192
		end
	end

	local var5_192 = var16_0(var0_192)
	local var6_192 = arg1_192[var5_192]

	if var5_192 ~= var0_192 and var6_192 then
		local var7_192, var8_192, var9_192 = wordVerMatch(arg0_192, var6_192, arg2_192, arg3_192 + 1, arg2_192.isReplace and arg4_192 .. arg2_192.replaceWord or arg4_192, var6_192.this or arg5_192, var6_192.this and arg3_192 + 1 or arg6_192, var6_192.this and (arg2_192.isReplace and arg4_192 .. arg2_192.replaceWord or arg4_192) or arg7_192)

		if var7_192 then
			return var7_192, var8_192, var9_192
		end
	end

	return arg5_192, arg6_192, arg7_192
end

function wordSplit(arg0_193)
	local var0_193 = {}

	for iter0_193 in arg0_193.gmatch(arg0_193, "[\x01-\x7F�-�][�-�]*") do
		var0_193[#var0_193 + 1] = iter0_193
	end

	return var0_193
end

function contentWrap(arg0_194, arg1_194, arg2_194)
	local var0_194 = LuaHelper.WrapContent(arg0_194, arg1_194, arg2_194)

	return #var0_194 ~= #arg0_194, var0_194
end

function cancelRich(arg0_195)
	local var0_195

	for iter0_195 = 1, 20 do
		local var1_195

		arg0_195, var1_195 = string.gsub(arg0_195, "<([^>]*)>", "%1")

		if var1_195 <= 0 then
			break
		end
	end

	return arg0_195
end

function cancelColorRich(arg0_196)
	local var0_196

	for iter0_196 = 1, 20 do
		local var1_196

		arg0_196, var1_196 = string.gsub(arg0_196, "<color=#[a-zA-Z0-9]+>(.-)</color>", "%1")

		if var1_196 <= 0 then
			break
		end
	end

	return arg0_196
end

function getSkillConfig(arg0_197)
	local var0_197 = pg.buffCfg["buff_" .. arg0_197]

	if not var0_197 then
		return
	end

	local var1_197 = Clone(var0_197)

	var1_197.name = getSkillName(arg0_197)
	var1_197.desc = HXSet.hxLan(var1_197.desc)
	var1_197.desc_get = HXSet.hxLan(var1_197.desc_get)

	_.each(var1_197, function(arg0_198)
		arg0_198.desc = HXSet.hxLan(arg0_198.desc)
	end)

	return var1_197
end

function getSkillName(arg0_199)
	local var0_199 = pg.skill_data_template[arg0_199] or pg.skill_data_display[arg0_199]

	if var0_199 then
		return HXSet.hxLan(var0_199.name)
	else
		return ""
	end
end

function getSkillDescGet(arg0_200, arg1_200)
	local var0_200 = arg1_200 and pg.skill_world_display[arg0_200] and setmetatable({}, {
		__index = function(arg0_201, arg1_201)
			return pg.skill_world_display[arg0_200][arg1_201] or pg.skill_data_template[arg0_200][arg1_201]
		end
	}) or pg.skill_data_template[arg0_200]

	if not var0_200 then
		return ""
	end

	local var1_200 = var0_200.desc_get ~= "" and var0_200.desc_get or var0_200.desc

	for iter0_200, iter1_200 in pairs(var0_200.desc_get_add) do
		local var2_200 = setColorStr(iter1_200[1], COLOR_GREEN)

		if iter1_200[2] then
			var2_200 = var2_200 .. specialGSub(i18n("word_skill_desc_get"), "$1", setColorStr(iter1_200[2], COLOR_GREEN))
		end

		var1_200 = specialGSub(var1_200, "$" .. iter0_200, var2_200)
	end

	return HXSet.hxLan(var1_200)
end

function getSkillDescLearn(arg0_202, arg1_202, arg2_202)
	local var0_202 = arg2_202 and pg.skill_world_display[arg0_202] and setmetatable({}, {
		__index = function(arg0_203, arg1_203)
			return pg.skill_world_display[arg0_202][arg1_203] or pg.skill_data_template[arg0_202][arg1_203]
		end
	}) or pg.skill_data_template[arg0_202]

	if not var0_202 then
		return ""
	end

	local var1_202 = var0_202.desc

	if not var0_202.desc_add then
		return HXSet.hxLan(var1_202)
	end

	for iter0_202, iter1_202 in pairs(var0_202.desc_add) do
		local var2_202 = iter1_202[arg1_202][1]

		if iter1_202[arg1_202][2] then
			var2_202 = var2_202 .. specialGSub(i18n("word_skill_desc_learn"), "$1", iter1_202[arg1_202][2])
		end

		var1_202 = specialGSub(var1_202, "$" .. iter0_202, setColorStr(var2_202, COLOR_YELLOW))
	end

	return HXSet.hxLan(var1_202)
end

function getSkillDesc(arg0_204, arg1_204, arg2_204)
	local var0_204 = arg2_204 and pg.skill_world_display[arg0_204] and setmetatable({}, {
		__index = function(arg0_205, arg1_205)
			return pg.skill_world_display[arg0_204][arg1_205] or pg.skill_data_template[arg0_204][arg1_205]
		end
	}) or pg.skill_data_template[arg0_204]

	if not var0_204 then
		return ""
	end

	local var1_204 = var0_204.desc

	if not var0_204.desc_add then
		return HXSet.hxLan(var1_204)
	end

	for iter0_204, iter1_204 in pairs(var0_204.desc_add) do
		local var2_204 = setColorStr(iter1_204[arg1_204][1], COLOR_GREEN)

		var1_204 = specialGSub(var1_204, "$" .. iter0_204, var2_204)
	end

	return HXSet.hxLan(var1_204)
end

function specialGSub(arg0_206, arg1_206, arg2_206)
	arg0_206 = string.gsub(arg0_206, "<color=#", "<color=NNN")
	arg0_206 = string.gsub(arg0_206, "#", "")
	arg2_206 = string.gsub(arg2_206, "%%", "%%%%")
	arg0_206 = string.gsub(arg0_206, arg1_206, arg2_206)
	arg0_206 = string.gsub(arg0_206, "<color=NNN", "<color=#")

	return arg0_206
end

function topAnimation(arg0_207, arg1_207, arg2_207, arg3_207, arg4_207, arg5_207)
	local var0_207 = {}

	arg4_207 = arg4_207 or 0.27

	local var1_207 = 0.05

	if arg0_207 then
		local var2_207 = arg0_207.transform.localPosition.x

		setAnchoredPosition(arg0_207, {
			x = var2_207 - 500
		})
		shiftPanel(arg0_207, var2_207, nil, 0.05, arg4_207, true, true)
		setActive(arg0_207, true)
	end

	setActive(arg1_207, false)
	setActive(arg2_207, false)
	setActive(arg3_207, false)

	for iter0_207 = 1, 3 do
		table.insert(var0_207, LeanTween.delayedCall(arg4_207 + 0.13 + var1_207 * iter0_207, System.Action(function()
			if arg1_207 then
				setActive(arg1_207, not arg1_207.gameObject.activeSelf)
			end
		end)).uniqueId)
		table.insert(var0_207, LeanTween.delayedCall(arg4_207 + 0.02 + var1_207 * iter0_207, System.Action(function()
			if arg2_207 then
				setActive(arg2_207, not go(arg2_207).activeSelf)
			end

			if arg2_207 then
				setActive(arg3_207, not go(arg3_207).activeSelf)
			end
		end)).uniqueId)
	end

	if arg5_207 then
		table.insert(var0_207, LeanTween.delayedCall(arg4_207 + 0.13 + var1_207 * 3 + 0.1, System.Action(function()
			arg5_207()
		end)).uniqueId)
	end

	return var0_207
end

function cancelTweens(arg0_211)
	assert(arg0_211, "must provide cancel targets, LeanTween.cancelAll is not allow")

	for iter0_211, iter1_211 in ipairs(arg0_211) do
		if iter1_211 then
			LeanTween.cancel(iter1_211)
		end
	end
end

function getOfflineTimeStamp(arg0_212)
	local var0_212 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_212
	local var1_212 = ""

	if var0_212 <= 59 then
		var1_212 = i18n("just_now")
	elseif var0_212 <= 3599 then
		var1_212 = i18n("several_minutes_before", math.floor(var0_212 / 60))
	elseif var0_212 <= 86399 then
		var1_212 = i18n("several_hours_before", math.floor(var0_212 / 3600))
	else
		var1_212 = i18n("several_days_before", math.floor(var0_212 / 86400))
	end

	return var1_212
end

function playMovie(arg0_213, arg1_213, arg2_213)
	local var0_213 = GameObject.Find("OverlayCamera/Overlay/UITop/MoviePanel")

	if not IsNil(var0_213) then
		pg.UIMgr.GetInstance():LoadingOn()
		WWWLoader.Inst:LoadStreamingAsset(arg0_213, function(arg0_214)
			pg.UIMgr.GetInstance():LoadingOff()

			local var0_214 = GCHandle.Alloc(arg0_214, GCHandleType.Pinned)

			setActive(var0_213, true)

			local var1_214 = var0_213:AddComponent(typeof(CriManaMovieControllerForUI))

			var1_214.player:SetData(arg0_214, arg0_214.Length)

			var1_214.target = var0_213:GetComponent(typeof(Image))
			var1_214.loop = false
			var1_214.additiveMode = false
			var1_214.playOnStart = true

			local var2_214

			var2_214 = Timer.New(function()
				if var1_214.player.status == CriMana.Player.Status.PlayEnd or var1_214.player.status == CriMana.Player.Status.Stop or var1_214.player.status == CriMana.Player.Status.Error then
					var2_214:Stop()
					Object.Destroy(var1_214)
					GCHandle.Free(var0_214)
					setActive(var0_213, false)

					if arg1_213 then
						arg1_213()
					end
				end
			end, 0.2, -1)

			var2_214:Start()
			removeOnButton(var0_213)

			if arg2_213 then
				onButton(nil, var0_213, function()
					var1_214:Stop()
					GetOrAddComponent(var0_213, typeof(Button)).onClick:RemoveAllListeners()
				end, SFX_CANCEL)
			end
		end)
	elseif arg1_213 then
		arg1_213()
	end
end

PaintCameraAdjustOn = false

function cameraPaintViewAdjust(arg0_217)
	if PaintCameraAdjustOn ~= arg0_217 then
		local var0_217 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(CanvasScaler))

		if arg0_217 then
			var0_217.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight
			var0_217.matchWidthOrHeight = 1
		else
			var0_217.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand
		end

		pg.CameraFixMgr.GetInstance():BlockCameraRatioControll(arg0_217)

		PaintCameraAdjustOn = arg0_217
	end
end

function ManhattonDist(arg0_218, arg1_218)
	return math.abs(arg0_218.row - arg1_218.row) + math.abs(arg0_218.column - arg1_218.column)
end

function checkFirstHelpShow(arg0_219)
	local var0_219 = getProxy(SettingsProxy)

	if not var0_219:checkReadHelp(arg0_219) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[arg0_219].tip
		})
		var0_219:recordReadHelp(arg0_219)
	end
end

preOrientation = nil
preNotchFitterEnabled = false

function openPortrait(arg0_220)
	preOrientation = Input.deviceOrientation:ToString()

	originalPrint("Begining Orientation:" .. preOrientation)

	Screen.autorotateToPortrait = true
	Screen.autorotateToPortraitUpsideDown = true

	cameraPaintViewAdjust(true)
end

function closePortrait(arg0_221)
	Screen.autorotateToPortrait = false
	Screen.autorotateToPortraitUpsideDown = false

	originalPrint("Closing Orientation:" .. preOrientation)

	Screen.orientation = ScreenOrientation.LandscapeLeft

	local var0_221 = Timer.New(function()
		Screen.orientation = ScreenOrientation.AutoRotation
	end, 0.2, 1):Start()

	cameraPaintViewAdjust(false)
end

function enableNotch(arg0_223, arg1_223)
	if arg0_223 == nil then
		return
	end

	arg0_223:GetComponent("NotchAdapt").enabled = arg1_223
end

function comma_value(arg0_224)
	local var0_224 = arg0_224
	local var1_224 = 0

	repeat
		local var2_224

		var0_224, var2_224 = string.gsub(var0_224, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var2_224 == 0

	return var0_224
end

local var17_0 = 0.2

function SwitchPanel(arg0_225, arg1_225, arg2_225, arg3_225, arg4_225, arg5_225)
	arg3_225 = defaultValue(arg3_225, var17_0)

	if arg5_225 then
		LeanTween.cancel(go(arg0_225))
	end

	local var0_225 = Vector3.New(tf(arg0_225).localPosition.x, tf(arg0_225).localPosition.y, tf(arg0_225).localPosition.z)

	if arg1_225 then
		var0_225.x = arg1_225
	end

	if arg2_225 then
		var0_225.y = arg2_225
	end

	local var1_225 = LeanTween.move(rtf(arg0_225), var0_225, arg3_225):setEase(LeanTweenType.easeInOutSine)

	if arg4_225 then
		var1_225:setDelay(arg4_225)
	end

	return var1_225
end

function updateActivityTaskStatus(arg0_226)
	local var0_226 = arg0_226:getConfig("config_id")
	local var1_226, var2_226 = getActivityTask(arg0_226, true)

	if not var2_226 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_226.id
		})

		return true
	end

	return false
end

function updateCrusingActivityTask(arg0_227)
	local var0_227 = getProxy(TaskProxy)
	local var1_227 = arg0_227:getNDay()
	local var2_227 = pg.TimeMgr.GetInstance():GetServerOverWeek(arg0_227:getStartTime())

	for iter0_227, iter1_227 in ipairs(arg0_227:getConfig("config_data")) do
		local var3_227 = pg.battlepass_task_group[iter1_227]

		if var3_227 and var2_227 >= var3_227.group_mask then
			if underscore.any(underscore.flatten(var3_227.task_group), function(arg0_228)
				return var0_227:getTaskVO(arg0_228) == nil
			end) then
				pg.m02:sendNotification(GAME.CRUSING_CMD, {
					cmd = 1,
					activity_id = arg0_227.id
				})

				return true
			end
		elseif not var3_227 then
			warning("battlepass_task_group表中不存在 id = " .. iter1_227)
		end
	end

	return false
end

function updateCrusingHei5ActivityTask(arg0_229)
	local var0_229 = getProxy(TaskProxy)
	local var1_229 = arg0_229:getNDay()
	local var2_229 = pg.TimeMgr.GetInstance():GetServerOverWeek(arg0_229:getStartTime())

	for iter0_229, iter1_229 in ipairs(arg0_229:getConfig("config_data")) do
		local var3_229 = pg.black_friday_battlepass_task_group[iter1_229]

		if var3_229 and var2_229 >= var3_229.group_mask then
			if underscore.any(underscore.flatten(var3_229.task_group), function(arg0_230)
				return var0_229:getTaskVO(arg0_230) == nil
			end) then
				pg.m02:sendNotification(GAME.CRUSING_CMD_HEI5, {
					cmd = 1,
					activity_id = arg0_229.id
				})

				return true
			end
		elseif not var3_229 then
			warning("black_friday_battlepass_task_group表中不存在 id = " .. iter1_229)
		end
	end

	return false
end

function setShipCardFrame(arg0_231, arg1_231, arg2_231)
	arg0_231.localScale = Vector3.one
	arg0_231.anchorMin = Vector2.zero
	arg0_231.anchorMax = Vector2.one

	local var0_231 = arg2_231 or arg1_231

	GetImageSpriteFromAtlasAsync("shipframe", var0_231, arg0_231)

	local var1_231 = pg.frame_resource[var0_231]

	if var1_231 then
		local var2_231 = var1_231.param

		arg0_231.offsetMin = Vector2(var2_231[1], var2_231[2])
		arg0_231.offsetMax = Vector2(var2_231[3], var2_231[4])
	else
		arg0_231.offsetMin = Vector2.zero
		arg0_231.offsetMax = Vector2.zero
	end
end

function setRectShipCardFrame(arg0_232, arg1_232, arg2_232)
	arg0_232.localScale = Vector3.one
	arg0_232.anchorMin = Vector2.zero
	arg0_232.anchorMax = Vector2.one

	setImageSprite(arg0_232, GetSpriteFromAtlas("shipframeb", "b" .. (arg2_232 or arg1_232)))

	local var0_232 = "b" .. (arg2_232 or arg1_232)
	local var1_232 = pg.frame_resource[var0_232]

	if var1_232 then
		local var2_232 = var1_232.param

		arg0_232.offsetMin = Vector2(var2_232[1], var2_232[2])
		arg0_232.offsetMax = Vector2(var2_232[3], var2_232[4])
	else
		arg0_232.offsetMin = Vector2.zero
		arg0_232.offsetMax = Vector2.zero
	end
end

function setFrameEffect(arg0_233, arg1_233)
	if arg1_233 then
		local var0_233 = arg1_233 .. "(Clone)"
		local var1_233 = false

		eachChild(arg0_233, function(arg0_234)
			setActive(arg0_234, arg0_234.name == var0_233)

			var1_233 = var1_233 or arg0_234.name == var0_233
		end)

		if not var1_233 then
			LoadAndInstantiateAsync("effect", arg1_233, function(arg0_235)
				if IsNil(arg0_233) or findTF(arg0_233, var0_233) then
					Object.Destroy(arg0_235)
				else
					setParent(arg0_235, arg0_233)
					setActive(arg0_235, true)
				end
			end)
		end
	end

	setActive(arg0_233, arg1_233)
end

function setProposeMarkIcon(arg0_236, arg1_236)
	local var0_236 = arg0_236:Find("proposeShipCard(Clone)")
	local var1_236 = arg1_236.propose and not arg1_236:ShowPropose()

	if var0_236 then
		setActive(var0_236, var1_236)
	elseif var1_236 then
		pg.PoolMgr.GetInstance():GetUI("proposeShipCard", true, function(arg0_237)
			if IsNil(arg0_236) or arg0_236:Find("proposeShipCard(Clone)") then
				pg.PoolMgr.GetInstance():ReturnUI("proposeShipCard", arg0_237)
			else
				setParent(arg0_237, arg0_236, false)
			end
		end)
	end
end

function flushShipCard(arg0_238, arg1_238)
	local var0_238 = arg1_238:rarity2bgPrint()
	local var1_238 = findTF(arg0_238, "content/bg")

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var0_238, "", var1_238)

	local var2_238 = findTF(arg0_238, "content/ship_icon")
	local var3_238 = arg1_238 and {
		"shipYardIcon/" .. arg1_238:getPainting(),
		arg1_238:getPainting()
	} or {
		"shipYardIcon/unknown",
		""
	}

	GetImageSpriteFromAtlasAsync(var3_238[1], var3_238[2], var2_238)

	local var4_238 = arg1_238:getShipType()
	local var5_238 = findTF(arg0_238, "content/info/top/type")

	GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var4_238), var5_238)
	setText(findTF(arg0_238, "content/dockyard/lv/Text"), defaultValue(arg1_238.level, 1))

	local var6_238 = arg1_238:getStar()
	local var7_238 = arg1_238:getMaxStar()
	local var8_238 = findTF(arg0_238, "content/front/stars")

	setActive(var8_238, true)

	local var9_238 = findTF(var8_238, "star_tpl")
	local var10_238 = var8_238.childCount

	for iter0_238 = 1, Ship.CONFIG_MAX_STAR do
		local var11_238 = var10_238 < iter0_238 and cloneTplTo(var9_238, var8_238) or var8_238:GetChild(iter0_238 - 1)

		setActive(var11_238, iter0_238 <= var7_238)
		triggerToggle(var11_238, iter0_238 <= var6_238)
	end

	local var12_238 = findTF(arg0_238, "content/front/frame")
	local var13_238, var14_238 = arg1_238:GetFrameAndEffect()

	setShipCardFrame(var12_238, var0_238, var13_238)
	setFrameEffect(findTF(arg0_238, "content/front/bg_other"), var14_238)
	setProposeMarkIcon(arg0_238:Find("content/dockyard/propose"), arg1_238)
end

function TweenItemAlphaAndWhite(arg0_239)
	LeanTween.cancel(arg0_239)

	local var0_239 = GetOrAddComponent(arg0_239, "CanvasGroup")

	var0_239.alpha = 0

	LeanTween.alphaCanvas(var0_239, 1, 0.2):setUseEstimatedTime(true)

	local var1_239 = findTF(arg0_239.transform, "white_mask")

	if var1_239 then
		setActive(var1_239, false)
	end
end

function ClearTweenItemAlphaAndWhite(arg0_240)
	LeanTween.cancel(arg0_240)

	GetOrAddComponent(arg0_240, "CanvasGroup").alpha = 0
end

function getGroupOwnSkins(arg0_241)
	local var0_241 = {}
	local var1_241 = getProxy(ShipSkinProxy):getSkinList()
	local var2_241 = getProxy(CollectionProxy):getShipGroup(arg0_241)

	if var2_241 then
		local var3_241 = ShipGroup.getSkinList(arg0_241)

		for iter0_241, iter1_241 in ipairs(var3_241) do
			if iter1_241.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var1_241, iter1_241.id) or iter1_241.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var2_241.trans or iter1_241.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var2_241.married == 1 then
				var0_241[iter1_241.id] = true
			end
		end
	end

	return var0_241
end

function split(arg0_242, arg1_242)
	local var0_242 = {}

	if not arg0_242 then
		return nil
	end

	local var1_242 = #arg0_242
	local var2_242 = 1

	while var2_242 <= var1_242 do
		local var3_242 = string.find(arg0_242, arg1_242, var2_242)

		if var3_242 == nil then
			table.insert(var0_242, string.sub(arg0_242, var2_242, var1_242))

			break
		end

		table.insert(var0_242, string.sub(arg0_242, var2_242, var3_242 - 1))

		if var3_242 == var1_242 then
			table.insert(var0_242, "")

			break
		end

		var2_242 = var3_242 + 1
	end

	return var0_242
end

function NumberToChinese(arg0_243, arg1_243)
	local var0_243 = ""
	local var1_243 = #arg0_243

	for iter0_243 = 1, var1_243 do
		local var2_243 = string.sub(arg0_243, iter0_243, iter0_243)

		if var2_243 ~= "0" or var2_243 == "0" and not arg1_243 then
			if arg1_243 then
				if var1_243 >= 2 then
					if iter0_243 == 1 then
						if var2_243 == "1" then
							var0_243 = i18n("number_" .. 10)
						else
							var0_243 = i18n("number_" .. var2_243) .. i18n("number_" .. 10)
						end
					else
						var0_243 = var0_243 .. i18n("number_" .. var2_243)
					end
				else
					var0_243 = var0_243 .. i18n("number_" .. var2_243)
				end
			else
				var0_243 = var0_243 .. i18n("number_" .. var2_243)
			end
		end
	end

	return var0_243
end

function getActivityTask(arg0_244, arg1_244)
	local var0_244 = getProxy(TaskProxy)
	local var1_244 = arg0_244:getConfig("config_data")
	local var2_244 = arg0_244:getNDay(arg0_244.data1)
	local var3_244
	local var4_244
	local var5_244

	for iter0_244 = math.max(arg0_244.data3, 1), math.min(var2_244, #var1_244) do
		local var6_244 = _.flatten({
			var1_244[iter0_244]
		})

		for iter1_244, iter2_244 in ipairs(var6_244) do
			local var7_244 = var0_244:getTaskById(iter2_244)

			if var7_244 then
				return var7_244.id, var7_244
			end

			if var4_244 then
				var5_244 = var0_244:getFinishTaskById(iter2_244)

				if var5_244 then
					var4_244 = var5_244
				elseif arg1_244 then
					return iter2_244
				else
					return var4_244.id, var4_244
				end
			else
				var4_244 = var0_244:getFinishTaskById(iter2_244)
				var5_244 = var5_244 or iter2_244
			end
		end
	end

	if var4_244 then
		return var4_244.id, var4_244
	else
		return var5_244
	end
end

function setImageFromImage(arg0_245, arg1_245, arg2_245)
	local var0_245 = GetComponent(arg0_245, "Image")

	var0_245.sprite = GetComponent(arg1_245, "Image").sprite

	if arg2_245 then
		var0_245:SetNativeSize()
	end
end

function skinTimeStamp(arg0_246)
	local var0_246, var1_246, var2_246, var3_246 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_246)

	if var0_246 >= 1 then
		return i18n("limit_skin_time_day", var0_246)
	elseif var0_246 <= 0 and var1_246 > 0 then
		return i18n("limit_skin_time_day_min", var1_246, var2_246)
	elseif var0_246 <= 0 and var1_246 <= 0 and (var2_246 > 0 or var3_246 > 0) then
		return i18n("limit_skin_time_min", math.max(var2_246, 1))
	elseif var0_246 <= 0 and var1_246 <= 0 and var2_246 <= 0 and var3_246 <= 0 then
		return i18n("limit_skin_time_overtime")
	end
end

function skinCommdityTimeStamp(arg0_247)
	local var0_247 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_247 = math.max(arg0_247 - var0_247, 0)
	local var2_247 = math.floor(var1_247 / 86400)

	if var2_247 > 0 then
		return i18n("time_remaining_tip") .. var2_247 .. i18n("word_date")
	else
		local var3_247 = math.floor(var1_247 / 3600)

		if var3_247 > 0 then
			return i18n("time_remaining_tip") .. var3_247 .. i18n("word_hour")
		else
			local var4_247 = math.floor(var1_247 / 60)

			if var4_247 > 0 then
				return i18n("time_remaining_tip") .. var4_247 .. i18n("word_minute")
			else
				return i18n("time_remaining_tip") .. var1_247 .. i18n("word_second")
			end
		end
	end
end

function InstagramTimeStamp(arg0_248)
	local var0_248 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_248
	local var1_248 = var0_248 / 86400

	if var1_248 > 1 then
		return i18n("ins_word_day", math.floor(var1_248))
	else
		local var2_248 = var0_248 / 3600

		if var2_248 > 1 then
			return i18n("ins_word_hour", math.floor(var2_248))
		else
			local var3_248 = var0_248 / 60

			if var3_248 > 1 then
				return i18n("ins_word_minu", math.floor(var3_248))
			else
				return i18n("ins_word_minu", 1)
			end
		end
	end
end

function InstagramReplyTimeStamp(arg0_249)
	local var0_249 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_249
	local var1_249 = var0_249 / 86400

	if var1_249 > 1 then
		return i18n1(math.floor(var1_249) .. "d")
	else
		local var2_249 = var0_249 / 3600

		if var2_249 > 1 then
			return i18n1(math.floor(var2_249) .. "h")
		else
			local var3_249 = var0_249 / 60

			if var3_249 > 1 then
				return i18n1(math.floor(var3_249) .. "min")
			else
				return i18n1("1min")
			end
		end
	end
end

function attireTimeStamp(arg0_250)
	local var0_250, var1_250, var2_250, var3_250 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_250)

	if var0_250 <= 0 and var1_250 <= 0 and var2_250 <= 0 and var3_250 <= 0 then
		return i18n("limit_skin_time_overtime")
	else
		return i18n("attire_time_stamp", var0_250, var1_250, var2_250)
	end
end

function checkExist(arg0_251, ...)
	local var0_251 = {
		...
	}

	for iter0_251, iter1_251 in ipairs(var0_251) do
		if arg0_251 == nil then
			break
		end

		assert(type(arg0_251) == "table", "type error : intermediate target should be table")
		assert(type(iter1_251) == "table", "type error : param should be table")

		if type(arg0_251[iter1_251[1]]) == "function" then
			arg0_251 = arg0_251[iter1_251[1]](arg0_251, unpack(iter1_251[2] or {}))
		else
			arg0_251 = arg0_251[iter1_251[1]]
		end
	end

	return arg0_251
end

function AcessWithinNull(arg0_252, arg1_252)
	if arg0_252 == nil then
		return
	end

	assert(type(arg0_252) == "table")

	return arg0_252[arg1_252]
end

function showRepairMsgbox()
	local var0_253 = {
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var1_253 = {
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var2_253 = {
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
			var2_253,
			var1_253,
			var0_253
		}
	})
end

function resourceVerify(arg0_257, arg1_257)
	if CSharpVersion > 35 then
		BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()

		return
	end

	local var0_257 = Application.persistentDataPath .. "/hashes.csv"
	local var1_257
	local var2_257 = PathMgr.ReadAllLines(var0_257)
	local var3_257 = {}

	if arg0_257 then
		setActive(arg0_257, true)
	else
		pg.UIMgr.GetInstance():LoadingOn()
	end

	local function var4_257()
		if arg0_257 then
			setActive(arg0_257, false)
		else
			pg.UIMgr.GetInstance():LoadingOff()
		end

		print(var1_257)

		if var1_257 then
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

	local var5_257 = var2_257.Length
	local var6_257

	local function var7_257(arg0_260)
		if arg0_260 < 0 then
			var4_257()

			return
		end

		if arg1_257 then
			setSlider(arg1_257, 0, var5_257, var5_257 - arg0_260)
		end

		local var0_260 = string.split(var2_257[arg0_260], ",")
		local var1_260 = var0_260[1]
		local var2_260 = var0_260[3]
		local var3_260 = PathMgr.getAssetBundle(var1_260)

		if PathMgr.FileExists(var3_260) then
			local var4_260 = PathMgr.ReadAllBytes(PathMgr.getAssetBundle(var1_260))

			if var2_260 == HashUtil.CalcMD5(var4_260) then
				onNextTick(function()
					var7_257(arg0_260 - 1)
				end)

				return
			end
		end

		var1_257 = var1_260

		var4_257()
	end

	var7_257(var5_257 - 1)
end

function splitByWordEN(arg0_262, arg1_262)
	local var0_262 = string.split(arg0_262, " ")
	local var1_262 = ""
	local var2_262 = ""
	local var3_262 = arg1_262:GetComponent(typeof(RectTransform))
	local var4_262 = arg1_262:GetComponent(typeof(Text))
	local var5_262 = var3_262.rect.width

	for iter0_262, iter1_262 in ipairs(var0_262) do
		local var6_262 = var2_262

		var2_262 = var2_262 == "" and iter1_262 or var2_262 .. " " .. iter1_262

		setText(arg1_262, var2_262)

		if var5_262 < var4_262.preferredWidth then
			var1_262 = var1_262 == "" and var6_262 or var1_262 .. "\n" .. var6_262
			var2_262 = iter1_262
		end

		if iter0_262 >= #var0_262 then
			var1_262 = var1_262 == "" and var2_262 or var1_262 .. "\n" .. var2_262
		end
	end

	return var1_262
end

function checkBirthFormat(arg0_263)
	if #arg0_263 ~= 8 then
		return false
	end

	local var0_263 = 0
	local var1_263 = #arg0_263

	while var0_263 < var1_263 do
		local var2_263 = string.byte(arg0_263, var0_263 + 1)

		if var2_263 < 48 or var2_263 > 57 then
			return false
		end

		var0_263 = var0_263 + 1
	end

	return true
end

function isHalfBodyLive2D(arg0_264)
	local var0_264 = {
		"biaoqiang",
		"z23",
		"lafei",
		"lingbo",
		"mingshi",
		"xuefeng"
	}

	return _.any(var0_264, function(arg0_265)
		return arg0_265 == arg0_264
	end)
end

function GetServerState(arg0_266)
	local var0_266 = -1
	local var1_266 = 0
	local var2_266 = 1
	local var3_266 = 2
	local var4_266 = NetConst.GetServerStateUrl()

	if PLATFORM_CODE == PLATFORM_CH then
		var4_266 = string.gsub(var4_266, "https", "http")
	end

	VersionMgr.Inst:WebRequest(var4_266, function(arg0_267, arg1_267)
		local var0_267 = true
		local var1_267 = false

		for iter0_267 in string.gmatch(arg1_267, "\"state\":%d") do
			if iter0_267 ~= "\"state\":1" then
				var0_267 = false
			end

			var1_267 = true
		end

		if not var1_267 then
			var0_267 = false
		end

		if arg0_266 ~= nil then
			arg0_266(var0_267 and var2_266 or var1_266)
		end
	end)
end

function setScrollText(arg0_268, arg1_268)
	GetOrAddComponent(arg0_268, "ScrollText"):SetText(arg1_268)
end

function changeToScrollText(arg0_269, arg1_269)
	local var0_269 = GetComponent(arg0_269, typeof(Text))

	assert(var0_269, "without component<Text>")

	local var1_269 = arg0_269:Find("subText")

	if not var1_269 then
		var1_269 = cloneTplTo(arg0_269, arg0_269, "subText")

		eachChild(arg0_269, function(arg0_270)
			setActive(arg0_270, arg0_270 == var1_269)
		end)

		arg0_269:GetComponent(typeof(Text)).enabled = false
	end

	setScrollText(var1_269, arg1_269)
end

function setScrollTextWithSize(arg0_271, arg1_271, arg2_271, arg3_271)
	local var0_271 = arg3_271 < GetPerceptualSize(arg2_271)

	setActive(arg1_271, var0_271)
	setActive(arg0_271, not var0_271)

	if var0_271 then
		setScrollText(arg1_271, arg2_271)
	else
		setText(arg0_271, arg2_271)
	end
end

local var18_0
local var19_0
local var20_0
local var21_0

local function var22_0(arg0_272, arg1_272, arg2_272)
	local var0_272 = arg0_272:Find("base")
	local var1_272, var2_272, var3_272 = Equipment.GetInfoTrans(arg1_272, arg2_272)

	if arg1_272.nextValue then
		local var4_272 = {
			name = arg1_272.name,
			type = arg1_272.type,
			value = arg1_272.nextValue
		}
		local var5_272, var6_272 = Equipment.GetInfoTrans(var4_272, arg2_272)

		var2_272 = var2_272 .. setColorStr("   >   " .. var6_272, COLOR_GREEN)
	end

	setText(var0_272:Find("name"), var1_272)

	if var3_272 then
		local var7_272 = "<color=#afff72>(+" .. ys.Battle.BattleConst.UltimateBonus.AuxBoostValue * 100 .. "%)</color>"

		setText(var0_272:Find("value"), var2_272 .. var7_272)
	else
		setText(var0_272:Find("value"), var2_272)
	end

	setActive(var0_272:Find("value/up"), arg1_272.compare and arg1_272.compare > 0)
	setActive(var0_272:Find("value/down"), arg1_272.compare and arg1_272.compare < 0)
	triggerToggle(var0_272, arg1_272.lock_open)

	if not arg1_272.lock_open and arg1_272.sub and #arg1_272.sub > 0 then
		GetComponent(var0_272, typeof(Toggle)).enabled = true
	else
		setActive(var0_272:Find("name/close"), false)
		setActive(var0_272:Find("name/open"), false)

		GetComponent(var0_272, typeof(Toggle)).enabled = false
	end
end

local function var23_0(arg0_273, arg1_273, arg2_273, arg3_273)
	var22_0(arg0_273, arg2_273, arg3_273)

	if not arg2_273.sub or #arg2_273.sub == 0 then
		return
	end

	var20_0(arg0_273:Find("subs"), arg1_273, arg2_273.sub, arg3_273)
end

function var20_0(arg0_274, arg1_274, arg2_274, arg3_274)
	removeAllChildren(arg0_274)
	var21_0(arg0_274, arg1_274, arg2_274, arg3_274)
end

function var21_0(arg0_275, arg1_275, arg2_275, arg3_275)
	for iter0_275, iter1_275 in ipairs(arg2_275) do
		local var0_275 = cloneTplTo(arg1_275, arg0_275)

		var23_0(var0_275, arg1_275, iter1_275, arg3_275)
	end
end

function updateEquipInfo(arg0_276, arg1_276, arg2_276, arg3_276)
	local var0_276 = arg0_276:Find("attr_tpl")

	var20_0(arg0_276:Find("attrs"), var0_276, arg1_276.attrs, arg3_276)
	setActive(arg0_276:Find("skill"), arg2_276)

	if arg2_276 then
		var23_0(arg0_276:Find("skill/attr"), var0_276, {
			name = i18n("skill"),
			value = setColorStr(arg2_276.name, "#FFDE00FF")
		}, arg3_276)
		setText(arg0_276:Find("skill/value/Text"), getSkillDescGet(arg2_276.id))
	end

	setActive(arg0_276:Find("weapon"), #arg1_276.weapon.sub > 0)

	if #arg1_276.weapon.sub > 0 then
		var20_0(arg0_276:Find("weapon"), var0_276, {
			arg1_276.weapon
		}, arg3_276)
	end

	setActive(arg0_276:Find("equip_info"), #arg1_276.equipInfo.sub > 0)

	if #arg1_276.equipInfo.sub > 0 then
		var20_0(arg0_276:Find("equip_info"), var0_276, {
			arg1_276.equipInfo
		}, arg3_276)
	end

	var23_0(arg0_276:Find("part/attr"), var0_276, {
		name = i18n("equip_info_23")
	}, arg3_276)

	local var1_276 = arg0_276:Find("part/value")
	local var2_276 = var1_276:Find("label")
	local var3_276 = {}
	local var4_276 = {}

	if #arg1_276.part[1] == 0 and #arg1_276.part[2] == 0 then
		setmetatable(var3_276, {
			__index = function(arg0_277, arg1_277)
				return true
			end
		})
		setmetatable(var4_276, {
			__index = function(arg0_278, arg1_278)
				return true
			end
		})
	else
		for iter0_276, iter1_276 in ipairs(arg1_276.part[1]) do
			var3_276[iter1_276] = true
		end

		for iter2_276, iter3_276 in ipairs(arg1_276.part[2]) do
			var4_276[iter3_276] = true
		end
	end

	local var5_276 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var3_276, var4_276)

	UIItemList.StaticAlign(var1_276, var2_276, #var5_276, function(arg0_279, arg1_279, arg2_279)
		arg1_279 = arg1_279 + 1

		if arg0_279 == UIItemList.EventUpdate then
			local var0_279 = var5_276[arg1_279]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0_279), arg2_279)
			setActive(arg2_279:Find("main"), var3_276[var0_279] and not var4_276[var0_279])
			setActive(arg2_279:Find("sub"), var4_276[var0_279] and not var3_276[var0_279])
			setImageAlpha(arg2_279, not var3_276[var0_279] and not var4_276[var0_279] and 0.3 or 1)
		end
	end)
end

function updateEquipUpgradeInfo(arg0_280, arg1_280, arg2_280)
	local var0_280 = arg0_280:Find("attr_tpl")

	var20_0(arg0_280:Find("attrs"), var0_280, arg1_280.attrs, arg2_280)
	setActive(arg0_280:Find("weapon"), #arg1_280.weapon.sub > 0)

	if #arg1_280.weapon.sub > 0 then
		var20_0(arg0_280:Find("weapon"), var0_280, {
			arg1_280.weapon
		}, arg2_280)
	end

	setActive(arg0_280:Find("equip_info"), #arg1_280.equipInfo.sub > 0)

	if #arg1_280.equipInfo.sub > 0 then
		var20_0(arg0_280:Find("equip_info"), var0_280, {
			arg1_280.equipInfo
		}, arg2_280)
	end
end

function setCanvasOverrideSorting(arg0_281, arg1_281)
	local var0_281 = arg0_281.parent

	arg0_281:SetParent(pg.LayerWeightMgr.GetInstance().uiOrigin, false)

	if isActive(arg0_281) then
		GetOrAddComponent(arg0_281, typeof(Canvas)).overrideSorting = arg1_281
	else
		setActive(arg0_281, true)

		GetOrAddComponent(arg0_281, typeof(Canvas)).overrideSorting = arg1_281

		setActive(arg0_281, false)
	end

	arg0_281:SetParent(var0_281, false)
end

function createNewGameObject(arg0_282, arg1_282)
	local var0_282 = GameObject.New()

	if arg0_282 then
		var0_282.name = "model"
	end

	var0_282.layer = arg1_282 or Layer.UI

	return GetOrAddComponent(var0_282, "RectTransform")
end

function CreateShell(arg0_283)
	if type(arg0_283) ~= "table" and type(arg0_283) ~= "userdata" then
		return arg0_283
	end

	local var0_283 = setmetatable({
		__index = arg0_283
	}, arg0_283)

	return setmetatable({}, var0_283)
end

function CameraFittingSettin(arg0_284)
	local var0_284 = GetComponent(arg0_284, typeof(Camera))
	local var1_284 = 1.77777777777778
	local var2_284 = Screen.width / Screen.height

	if var2_284 < var1_284 then
		local var3_284 = var2_284 / var1_284

		var0_284.rect = var0_0.Rect.New(0, (1 - var3_284) / 2, 1, var3_284)
	end
end

function SwitchSpecialChar(arg0_285, arg1_285)
	if PLATFORM_CODE ~= PLATFORM_US then
		arg0_285 = arg0_285:gsub(" ", " ")
		arg0_285 = arg0_285:gsub("\t", "    ")
	end

	if not arg1_285 then
		arg0_285 = arg0_285:gsub("\n", " ")
	end

	return arg0_285
end

function AfterCheck(arg0_286, arg1_286)
	local var0_286 = {}

	for iter0_286, iter1_286 in ipairs(arg0_286) do
		var0_286[iter0_286] = iter1_286[1]()
	end

	arg1_286()

	for iter2_286, iter3_286 in ipairs(arg0_286) do
		if var0_286[iter2_286] ~= iter3_286[1]() then
			iter3_286[2]()
		end

		var0_286[iter2_286] = iter3_286[1]()
	end
end

function CompareFuncs(arg0_287, arg1_287)
	local var0_287 = {}

	local function var1_287(arg0_288, arg1_288)
		var0_287[arg0_288] = var0_287[arg0_288] or {}
		var0_287[arg0_288][arg1_288] = var0_287[arg0_288][arg1_288] or arg0_287[arg0_288](arg1_288)

		return var0_287[arg0_288][arg1_288]
	end

	return function(arg0_289, arg1_289)
		local var0_289 = 1

		while var0_289 <= #arg0_287 do
			local var1_289 = var1_287(var0_289, arg0_289)
			local var2_289 = var1_287(var0_289, arg1_289)

			if var1_289 == var2_289 then
				var0_289 = var0_289 + 1
			else
				return var1_289 < var2_289
			end
		end

		return tobool(arg1_287)
	end
end

function DropResultIntegration(arg0_290)
	local var0_290 = {}
	local var1_290 = 1

	while var1_290 <= #arg0_290 do
		local var2_290 = arg0_290[var1_290].type
		local var3_290 = arg0_290[var1_290].id

		var0_290[var2_290] = var0_290[var2_290] or {}

		if var0_290[var2_290][var3_290] then
			local var4_290 = arg0_290[var0_290[var2_290][var3_290]]
			local var5_290 = table.remove(arg0_290, var1_290)

			var4_290.count = var4_290.count + var5_290.count
		else
			var0_290[var2_290][var3_290] = var1_290
			var1_290 = var1_290 + 1
		end
	end

	local var6_290 = {
		function(arg0_291)
			local var0_291 = arg0_291.type
			local var1_291 = arg0_291.id

			if var0_291 == DROP_TYPE_SHIP then
				return 1
			elseif var0_291 == DROP_TYPE_RESOURCE then
				if var1_291 == 1 then
					return 2
				else
					return 3
				end
			elseif var0_291 == DROP_TYPE_ITEM then
				if var1_291 == 59010 then
					return 4
				elseif var1_291 == 59900 then
					return 5
				else
					local var2_291 = Item.getConfigData(var1_291)
					local var3_291 = var2_291 and var2_291.type or 0

					if var3_291 == 9 then
						return 6
					elseif var3_291 == 5 then
						return 7
					elseif var3_291 == 4 then
						return 8
					elseif var3_291 == 7 then
						return 9
					end
				end
			elseif var0_291 == DROP_TYPE_VITEM and var1_291 == 59011 then
				return 4
			end

			return 100
		end,
		function(arg0_292)
			local var0_292

			if arg0_292.type == DROP_TYPE_SHIP then
				var0_292 = pg.ship_data_statistics[arg0_292.id]
			elseif arg0_292.type == DROP_TYPE_ITEM then
				var0_292 = Item.getConfigData(arg0_292.id)
			end

			return (var0_292 and var0_292.rarity or 0) * -1
		end,
		function(arg0_293)
			return arg0_293.id
		end
	}

	table.sort(arg0_290, CompareFuncs(var6_290))
end

function getLoginConfig()
	if LOGIN_HX and PlayerProxy.GetDeviceMaxPlayerLevel() <= pg.gameset.LOGIN_HX_LV.key_value then
		return false, "login", "", false, ""
	end

	local var0_294 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_294 = 1

	for iter0_294, iter1_294 in ipairs(pg.login.all) do
		if pg.login[iter1_294].date ~= "stop" then
			local var2_294, var3_294 = parseTimeConfig(pg.login[iter1_294].date)

			assert(not var3_294)

			if pg.TimeMgr.GetInstance():inTime(var2_294, var0_294) then
				var1_294 = iter1_294

				break
			end
		end
	end

	local var4_294 = pg.login[var1_294].login_static

	var4_294 = var4_294 ~= "" and var4_294 or "login"

	local var5_294 = pg.login[var1_294].login_cri
	local var6_294 = var5_294 ~= "" and true or false
	local var7_294 = pg.login[var1_294].op_play == 1 and true or false
	local var8_294 = pg.login[var1_294].op_time

	if var8_294 == "" or not pg.TimeMgr.GetInstance():inTime(var8_294, var0_294) then
		var7_294 = false
	end

	local var9_294 = var8_294 == "" and var8_294 or table.concat(var8_294[1][1])

	return var6_294, var6_294 and var5_294 or var4_294, pg.login[var1_294].bgm, var7_294, var9_294
end

function setIntimacyIcon(arg0_295, arg1_295, arg2_295)
	local var0_295 = {}
	local var1_295

	seriesAsync({
		function(arg0_296)
			if arg0_295.childCount > 0 then
				var1_295 = arg0_295:GetChild(0)

				arg0_296()
			else
				LoadAndInstantiateAsync("template", "intimacytpl", function(arg0_297)
					if arg0_295.childCount == 0 then
						var1_295 = tf(arg0_297)

						setParent(var1_295, arg0_295)
						arg0_296()
					end
				end)
			end
		end,
		function(arg0_298)
			setImageAlpha(var1_295, arg2_295 and 0 or 1)
			eachChild(var1_295, function(arg0_299)
				setActive(arg0_299, false)
			end)

			if arg2_295 then
				local var0_298 = var1_295:Find(arg2_295 .. "(Clone)")

				if not var0_298 then
					LoadAndInstantiateAsync("ui", arg2_295, function(arg0_300)
						setParent(arg0_300, var1_295)
						setActive(arg0_300, true)
					end)
				else
					setActive(var0_298, true)
				end
			elseif arg1_295 then
				setImageSprite(var1_295, GetSpriteFromAtlas("energy", arg1_295), true)
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

function switch(arg0_303, arg1_303, arg2_303, ...)
	while type(arg1_303[arg0_303]) ~= "function" do
		if arg1_303[arg0_303] == nil then
			return existCall(arg2_303, ...)
		else
			arg0_303 = arg1_303[arg0_303]
		end
	end

	return arg1_303[arg0_303](...)
end

function parseTimeConfig(arg0_304)
	if type(arg0_304[1]) == "table" then
		return arg0_304[2], arg0_304[1]
	else
		return arg0_304
	end
end

local var25_0 = {
	__add = function(arg0_305, arg1_305)
		return NewPos(arg0_305.x + arg1_305.x, arg0_305.y + arg1_305.y)
	end,
	__sub = function(arg0_306, arg1_306)
		return NewPos(arg0_306.x - arg1_306.x, arg0_306.y - arg1_306.y)
	end,
	__mul = function(arg0_307, arg1_307)
		if type(arg1_307) == "number" then
			return NewPos(arg0_307.x * arg1_307, arg0_307.y * arg1_307)
		else
			return NewPos(arg0_307.x * arg1_307.x, arg0_307.y * arg1_307.y)
		end
	end,
	__eq = function(arg0_308, arg1_308)
		return arg0_308.x == arg1_308.x and arg0_308.y == arg1_308.y
	end,
	__tostring = function(arg0_309)
		return arg0_309.x .. "_" .. arg0_309.y
	end
}

function NewPos(arg0_310, arg1_310)
	assert(arg0_310 and arg1_310)

	local var0_310 = setmetatable({
		x = arg0_310,
		y = arg1_310
	}, var25_0)

	function var0_310.SqrMagnitude(arg0_311)
		return arg0_311.x * arg0_311.x + arg0_311.y * arg0_311.y
	end

	function var0_310.Normalize(arg0_312)
		local var0_312 = arg0_312:SqrMagnitude()

		if var0_312 > 1e-05 then
			return arg0_312 * (1 / math.sqrt(var0_312))
		else
			return NewPos(0, 0)
		end
	end

	return var0_310
end

local var26_0

function Timekeeping()
	warning(Time.realtimeSinceStartup - (var26_0 or Time.realtimeSinceStartup), Time.realtimeSinceStartup)

	var26_0 = Time.realtimeSinceStartup
end

function GetRomanDigit(arg0_314)
	return (string.char(226, 133, 160 + (arg0_314 - 1)))
end

function quickPlayAnimator(arg0_315, arg1_315)
	arg0_315:GetComponent(typeof(Animator)):Play(arg1_315, -1, 0)
end

function quickCheckAndPlayAnimator(arg0_316, arg1_316)
	local var0_316 = arg0_316:GetComponent(typeof(Animator))

	var0_316.enabled = true

	local var1_316 = Animator.StringToHash(arg1_316)

	if var0_316:HasState(0, var1_316) then
		var0_316:Play(arg1_316, -1, 0)
	end
end

function quickPlayAnimation(arg0_317, arg1_317)
	local var0_317 = arg0_317:GetComponent(typeof(Animation))

	var0_317:Stop()
	var0_317:Play(arg1_317)
end

function getSurveyUrl(arg0_318)
	local var0_318 = pg.survey_data_template[arg0_318]
	local var1_318

	if not IsUnityEditor then
		if PLATFORM_CODE == PLATFORM_CH then
			local var2_318 = getProxy(UserProxy):GetCacheGatewayInServerLogined()

			if var2_318 == PLATFORM_ANDROID then
				if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_BILI then
					var1_318 = var0_318.main_url
				else
					var1_318 = var0_318.uo_url
				end
			elseif var2_318 == PLATFORM_IPHONEPLAYER then
				var1_318 = var0_318.ios_url
			end
		elseif PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_KR then
			var1_318 = var0_318.main_url
		end
	else
		var1_318 = var0_318.main_url
	end

	local var3_318 = getProxy(PlayerProxy):getRawData().id
	local var4_318 = getProxy(UserProxy):getRawData().arg2 or ""
	local var5_318
	local var6_318 = PLATFORM == PLATFORM_ANDROID and 1 or PLATFORM == PLATFORM_IPHONEPLAYER and 2 or 3
	local var7_318 = getProxy(UserProxy):getRawData()
	local var8_318 = getProxy(ServerProxy):getRawData()[var7_318 and var7_318.server or 0]
	local var9_318 = var8_318 and var8_318.id or ""
	local var10_318 = getProxy(PlayerProxy):getRawData().level
	local var11_318 = var3_318 .. "_" .. arg0_318
	local var12_318 = var1_318
	local var13_318 = {
		var3_318,
		var4_318,
		var6_318,
		var9_318,
		var10_318,
		var11_318
	}

	if var12_318 then
		for iter0_318, iter1_318 in ipairs(var13_318) do
			var12_318 = string.gsub(var12_318, "$" .. iter0_318, tostring(iter1_318))
		end
	end

	originalPrint("survey url", tostring(var12_318))

	return var12_318
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

function FilterVarchar(arg0_320)
	assert(type(arg0_320) == "string" or type(arg0_320) == "table")

	if arg0_320 == "" then
		return nil
	end

	return arg0_320
end

function getGameset(arg0_321)
	local var0_321 = pg.gameset[arg0_321]

	assert(var0_321)

	return {
		var0_321.key_value,
		var0_321.description
	}
end

function getDorm3dGameset(arg0_322)
	local var0_322 = pg.dorm3d_set[arg0_322]

	assert(var0_322)

	return {
		var0_322.key_value_int,
		var0_322.key_value_varchar
	}
end

function GetItemsOverflowDic(arg0_323)
	arg0_323 = arg0_323 or {}

	local var0_323 = {
		[DROP_TYPE_ITEM] = {},
		[DROP_TYPE_RESOURCE] = {},
		[DROP_TYPE_EQUIP] = 0,
		[DROP_TYPE_SHIP] = 0,
		[DROP_TYPE_WORLD_ITEM] = 0
	}

	while #arg0_323 > 0 do
		local var1_323 = table.remove(arg0_323)

		switch(var1_323.type, {
			[DROP_TYPE_ITEM] = function()
				if var1_323:getConfig("open_directly") == 1 then
					for iter0_324, iter1_324 in ipairs(var1_323:getConfig("display_icon")) do
						local var0_324 = Drop.Create(iter1_324)

						var0_324.count = var0_324.count * var1_323.count

						table.insert(arg0_323, var0_324)
					end
				elseif var1_323:getSubClass():IsShipExpType() then
					var0_323[var1_323.type][var1_323.id] = defaultValue(var0_323[var1_323.type][var1_323.id], 0) + var1_323.count
				end
			end,
			[DROP_TYPE_RESOURCE] = function()
				var0_323[var1_323.type][var1_323.id] = defaultValue(var0_323[var1_323.type][var1_323.id], 0) + var1_323.count
			end,
			[DROP_TYPE_EQUIP] = function()
				var0_323[var1_323.type] = var0_323[var1_323.type] + var1_323.count
			end,
			[DROP_TYPE_SHIP] = function()
				var0_323[var1_323.type] = var0_323[var1_323.type] + var1_323.count
			end,
			[DROP_TYPE_WORLD_ITEM] = function()
				var0_323[var1_323.type] = var0_323[var1_323.type] + var1_323.count
			end
		})
	end

	return var0_323
end

function CheckOverflow(arg0_329, arg1_329)
	local var0_329 = {}
	local var1_329 = arg0_329[DROP_TYPE_RESOURCE][PlayerConst.ResGold] or 0
	local var2_329 = arg0_329[DROP_TYPE_RESOURCE][PlayerConst.ResOil] or 0
	local var3_329 = arg0_329[DROP_TYPE_EQUIP]
	local var4_329 = arg0_329[DROP_TYPE_SHIP]
	local var5_329 = getProxy(PlayerProxy):getRawData()
	local var6_329 = false

	if arg1_329 then
		local var7_329 = var5_329:OverStore(PlayerConst.ResStoreGold, var1_329)
		local var8_329 = var5_329:OverStore(PlayerConst.ResStoreOil, var2_329)

		if var7_329 > 0 or var8_329 > 0 then
			var0_329.isStoreOverflow = {
				var7_329,
				var8_329
			}
		end
	else
		if var1_329 > 0 and var5_329:GoldMax(var1_329) then
			return false, "gold"
		end

		if var2_329 > 0 and var5_329:OilMax(var2_329) then
			return false, "oil"
		end
	end

	var0_329.isExpBookOverflow = {}

	for iter0_329, iter1_329 in pairs(arg0_329[DROP_TYPE_ITEM]) do
		local var9_329 = Item.getConfigData(iter0_329)

		if getProxy(BagProxy):getItemCountById(iter0_329) + iter1_329 > var9_329.max_num then
			table.insert(var0_329.isExpBookOverflow, iter0_329)
		end
	end

	local var10_329 = getProxy(EquipmentProxy):getCapacity()

	if var3_329 > 0 and var10_329 >= var5_329:getMaxEquipmentBag() then
		return false, "equip"
	end

	local var11_329 = getProxy(BayProxy):getShipCount()

	if var4_329 > 0 and var4_329 + var11_329 > var5_329:getMaxShipBag() then
		return false, "ship"
	end

	return true, var0_329
end

function CheckShipExpOverflow(arg0_330)
	local var0_330 = getProxy(BagProxy)

	for iter0_330, iter1_330 in pairs(arg0_330[DROP_TYPE_ITEM]) do
		if var0_330:getItemCountById(iter0_330) + iter1_330 > Item.getConfigData(iter0_330).max_num then
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

function RegisterDetailButton(arg0_331, arg1_331, arg2_331)
	Drop.Change(arg2_331)
	switch(arg2_331.type, {
		[DROP_TYPE_ITEM] = function()
			if arg2_331:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
				local var0_332 = Item.getConfigData(arg2_331.id).usage_arg
				local var1_332 = var0_332[3]

				if Item.InTimeLimitSkinAssigned(arg2_331.id) then
					var1_332 = table.mergeArray(var0_332[2], var1_332, true)
				end

				local var2_332 = {}

				for iter0_332, iter1_332 in ipairs(var0_332[2]) do
					var2_332[iter1_332] = true
				end

				onButton(arg0_331, arg1_331, function()
					arg0_331:closeView()
					pg.m02:sendNotification(GAME.LOAD_LAYERS, {
						parentContext = getProxy(ContextProxy):getCurrentContext(),
						context = Context.New({
							viewComponent = NewSelectSkinLayer,
							mediator = NewSkinAtlasMediator,
							data = {
								mode = SelectSkinLayer.MODE_VIEW,
								itemId = arg2_331.id,
								selectableSkinList = underscore.map(var1_332, function(arg0_334)
									return SelectableSkin.New({
										id = arg0_334,
										isTimeLimit = var2_332[arg0_334] or false
									})
								end)
							}
						})
					})
				end, SFX_PANEL)
				setActive(arg1_331, true)
			else
				local var3_332 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_331.id) and "tech" or arg2_331:getConfig("type")

				if var27_0[var3_332] then
					local var4_332 = {
						item2Row = true,
						content = i18n(var27_0[var3_332]),
						itemList = underscore.map(arg2_331:getConfig("display_icon"), function(arg0_335)
							return Drop.Create(arg0_335)
						end)
					}

					if var3_332 == 11 then
						onButton(arg0_331, arg1_331, function()
							arg0_331:emit(BaseUI.ON_DROP_LIST_OWN, var4_332)
						end, SFX_PANEL)
					else
						onButton(arg0_331, arg1_331, function()
							arg0_331:emit(BaseUI.ON_DROP_LIST, var4_332)
						end, SFX_PANEL)
					end
				end

				setActive(arg1_331, tobool(var27_0[var3_332]))
			end
		end,
		[DROP_TYPE_EQUIP] = function()
			onButton(arg0_331, arg1_331, function()
				arg0_331:emit(BaseUI.ON_DROP, arg2_331)
			end, SFX_PANEL)
			setActive(arg1_331, true)
		end,
		[DROP_TYPE_SPWEAPON] = function()
			onButton(arg0_331, arg1_331, function()
				arg0_331:emit(BaseUI.ON_DROP, arg2_331)
			end, SFX_PANEL)
			setActive(arg1_331, true)
		end
	}, function()
		setActive(arg1_331, false)
	end)
end

function RegisterNewStyleDetailButton(arg0_343, arg1_343, arg2_343)
	Drop.Change(arg2_343)
	switch(arg2_343.type, {
		[DROP_TYPE_ITEM] = function()
			local var0_344 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_343.id) and "tech" or arg2_343:getConfig("type")

			if var27_0[var0_344] then
				local var1_344 = {
					useDeepShow = true,
					showOwn = var0_344 == 11,
					content = i18n(var27_0[var0_344]),
					itemList = underscore.map(arg2_343:getConfig("display_icon"), function(arg0_345)
						return Drop.Create(arg0_345)
					end)
				}

				onButton(arg0_343, arg1_343, function()
					arg0_343:emit(BaseUI.ON_NEW_STYLE_ITEMS, var1_344)
				end, SFX_PANEL)
			end

			setActive(arg1_343, tobool(var27_0[var0_344]))
		end
	}, function()
		setActive(arg1_343, false)
	end)
end

function UpdateOwnDisplay(arg0_348, arg1_348)
	local var0_348, var1_348 = arg1_348:getOwnedCount()

	setActive(arg0_348, var1_348 and var0_348 > 0)

	if var1_348 and var0_348 > 0 then
		setText(arg0_348:Find("label"), i18n("word_own1"))
		setText(arg0_348:Find("Text"), var0_348)
	end
end

function Damp(arg0_349, arg1_349, arg2_349)
	arg1_349 = Mathf.Max(1, arg1_349)

	local var0_349 = Mathf.Epsilon

	if arg1_349 < var0_349 or var0_349 > Mathf.Abs(arg0_349) then
		return arg0_349
	end

	if arg2_349 < var0_349 then
		return 0
	end

	local var1_349 = -4.605170186

	return arg0_349 * (1 - Mathf.Exp(var1_349 * arg2_349 / arg1_349))
end

function checkCullResume(arg0_350, arg1_350)
	if arg1_350 or not ReflectionHelp.RefCallMethodEx(typeof("UnityEngine.CanvasRenderer"), "GetMaterial", GetComponent(arg0_350, "CanvasRenderer"), {
		typeof("System.Int32")
	}, {
		0
	}) then
		local var0_350 = arg0_350:GetComponentsInChildren(typeof(var0_0.UI.Graphic)):ToTable()

		for iter0_350, iter1_350 in ipairs(var0_350) do
			iter1_350:SetVerticesDirty()
		end

		return false
	end

	return true
end

function parseEquipCode(arg0_351)
	local var0_351 = {}

	if arg0_351 and arg0_351 ~= "" then
		local var1_351 = base64.dec(arg0_351)

		var0_351 = string.split(var1_351, "/")
		var0_351[5], var0_351[6] = unpack(string.split(var0_351[5], "\\"))

		if #var0_351 < 6 or arg0_351 ~= base64.enc(table.concat({
			table.concat(underscore.first(var0_351, 5), "/"),
			var0_351[6]
		}, "\\")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_illegal"))

			var0_351 = {}
		end
	end

	for iter0_351 = 1, 6 do
		var0_351[iter0_351] = var0_351[iter0_351] and tonumber(var0_351[iter0_351], 32) or 0
	end

	return var0_351
end

function buildEquipCode(arg0_352)
	local var0_352 = underscore.map(arg0_352:getAllEquipments(), function(arg0_353)
		return ConversionBase(32, arg0_353 and arg0_353.id or 0)
	end)
	local var1_352 = {
		table.concat(var0_352, "/"),
		ConversionBase(32, checkExist(arg0_352:GetSpWeapon(), {
			"id"
		}) or 0)
	}

	return base64.enc(table.concat(var1_352, "\\"))
end

function setDirectorSpeed(arg0_354, arg1_354)
	GetComponent(arg0_354, typeof(TimelineSpeed)):SetTimelineSpeed(arg1_354)
end

function setDefaultZeroMetatable(arg0_355)
	return setmetatable(arg0_355, {
		__index = function(arg0_356, arg1_356)
			if rawget(arg0_356, arg1_356) == nil then
				arg0_356[arg1_356] = 0
			end

			return arg0_356[arg1_356]
		end
	})
end

function checkABExist(arg0_357)
	if EDITOR_TOOL then
		return ResourceMgr.Inst:AssetExist(arg0_357)
	else
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_357))
	end
end

function compareNumber(arg0_358, arg1_358, arg2_358)
	return switch(arg1_358, {
		[">"] = function()
			return arg0_358 > arg2_358
		end,
		[">="] = function()
			return arg0_358 >= arg2_358
		end,
		["="] = function()
			return arg0_358 == arg2_358
		end,
		["<"] = function()
			return arg0_358 < arg2_358
		end,
		["<="] = function()
			return arg0_358 <= arg2_358
		end
	})
end

function ArabicToRoman(arg0_364)
	local var0_364 = {
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

	local function var1_364(arg0_365, arg1_365)
		return select(2, arg0_365:gsub(arg1_365, ""))
	end

	local var2_364 = ""

	while arg0_364 > 0 do
		for iter0_364, iter1_364 in pairs(var0_364) do
			local var3_364 = iter1_364[2]
			local var4_364 = iter1_364[1]

			while var4_364 <= arg0_364 do
				var2_364 = var2_364 .. var3_364
				arg0_364 = arg0_364 - var4_364
			end
		end
	end

	if arg0_364 > 10000 then
		local var5_364 = var1_364(var2_364, "M")

		var2_364 = "M*" .. var5_364 .. " " .. var2_364
	end

	return var2_364
end

function stringInset(arg0_366, ...)
	for iter0_366, iter1_366 in ipairs({
		...
	}) do
		arg0_366 = string.gsub(arg0_366, "$" .. iter0_366, iter1_366)
	end

	return arg0_366
end

function addSubLayer(arg0_367, arg1_367, arg2_367, arg3_367, arg4_367)
	if arg2_367 then
		while arg1_367.parent do
			arg1_367 = arg1_367.parent
		end
	end

	local var0_367 = {
		parentContext = arg1_367,
		context = arg0_367,
		callback = arg3_367
	}

	var0_367 = arg4_367 and table.merge(var0_367, arg4_367) or var0_367

	pg.m02:sendNotification(GAME.LOAD_LAYERS, var0_367)
end
