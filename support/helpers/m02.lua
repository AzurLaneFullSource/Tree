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
		local var1_63 = pg.SdkMgr.GetInstance():GetChannelUIDIncludeHarmony()
		local var2_63 = findTF(arg0_63, "exchange_hx_ch" .. var1_63)

		if not IsNil(var2_63) then
			setActive(var2_63, HXSet.isHx())
		end

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
	elseif arg1_103.id == 44004 then
		var1_103 = "frame8_1"
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
	local var0_111 = pg.island_set.season_pt_show.key_value_int
	local var1_111 = pg.island_item_data_template[var0_111]

	return {
		name = var1_111.name,
		icon = var1_111.icon
	}
end

function updateIslandSeasonPt(arg0_112, arg1_112)
	local var0_112 = Drop.New({
		type = DROP_TYPE_ISLAND_ITEM,
		id = pg.island_set.season_pt_show.key_value_int,
		count = arg1_112.count
	})

	updateIslandItem(arg0_112, var0_112)
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

function updateIslandDress(arg0_116, arg1_116)
	local var0_116 = arg1_116:getConfigTable().icon

	GetImageSpriteFromAtlasAsync("island/IslandDressIcon/" .. var0_116, "", findTF(arg0_116, "icon_bg/icon"))
	setActive(findTF(arg0_116, "icon_bg/count_bg"), arg1_116.count > 0)
	setText(findTF(arg0_116, "icon_bg/count_bg/count"), arg1_116.count)
	setIconName(arg0_116, arg1_116:getConfigTable().name, {})
	setIslandRarityFrame(arg0_116, arg1_116)
end

function updateIslandWatherCollect(arg0_117, arg1_117)
	local var0_117 = arg1_117:getConfigTable().icon
	local var1_117 = arg1_117:getConfigTable().name

	setText(findTF(arg0_117, "icon_bg/count"), arg1_117.count)
	GetImageSpriteFromAtlasAsync("island/" .. var0_117, "", findTF(arg0_117, "icon_bg/icon"))
	setIconName(arg0_117, var1_117, {})
	setIslandRarityFrame(arg0_117, arg1_117)
end

function updateWorldItem(arg0_118, arg1_118, arg2_118)
	arg2_118 = arg2_118 or {}

	local var0_118 = ItemRarity.Rarity2Print(arg1_118:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_118, findTF(arg0_118, "icon_bg"))
	setFrame(findTF(arg0_118, "icon_bg/frame"), var0_118)

	local var1_118 = findTF(arg0_118, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_118.icon or arg1_118:getConfig("icon"), "", var1_118)
	setIconStars(arg0_118, false)
	setIconName(arg0_118, arg1_118:getConfig("name"), arg2_118)
	setIconColorful(arg0_118, arg1_118:getConfig("rarity"), arg2_118)
end

function updateWorldCollection(arg0_119, arg1_119, arg2_119)
	arg2_119 = arg2_119 or {}

	assert(arg1_119:getConfigTable(), "world_collection_file_template 和 world_collection_record_template 表中找不到配置: " .. arg1_119.id)

	local var0_119 = arg1_119:getDropRarity()
	local var1_119 = ItemRarity.Rarity2Print(var0_119)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_119, findTF(arg0_119, "icon_bg"))
	setFrame(findTF(arg0_119, "icon_bg/frame"), var1_119)

	local var2_119 = findTF(arg0_119, "icon_bg/icon")
	local var3_119 = WorldCollectionProxy.GetCollectionType(arg1_119.id) == WorldCollectionProxy.WorldCollectionType.FILE and "shoucangguangdie" or "shoucangjiaojuan"

	GetImageSpriteFromAtlasAsync("props/" .. var3_119, "", var2_119)
	setIconStars(arg0_119, false)
	setIconName(arg0_119, arg1_119:getName(), arg2_119)
	setIconColorful(arg0_119, var0_119, arg2_119)
end

function updateWorldBuff(arg0_120, arg1_120, arg2_120)
	arg2_120 = arg2_120 or {}

	local var0_120 = pg.world_SLGbuff_data[arg1_120]

	assert(var0_120, "找不到大世界buff配置: " .. arg1_120)

	local var1_120 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_120, findTF(arg0_120, "icon_bg"))
	setFrame(findTF(arg0_120, "icon_bg/frame"), var1_120)

	local var2_120 = findTF(arg0_120, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("world/buff/" .. var0_120.icon, "", var2_120)

	local var3_120 = arg0_120:Find("icon_bg/stars")

	if not IsNil(var3_120) then
		setActive(var3_120, false)
	end

	local var4_120 = findTF(arg0_120, "name")

	if not IsNil(var4_120) then
		setText(var4_120, var0_120.name)
	end

	local var5_120 = findTF(arg0_120, "icon_bg/count")

	if not IsNil(var5_120) then
		SetActive(var5_120, false)
	end
end

function updateShip(arg0_121, arg1_121, arg2_121)
	arg2_121 = arg2_121 or {}

	local var0_121 = arg1_121:rarity2bgPrint()
	local var1_121 = arg1_121:getPainting()

	if arg2_121.anonymous then
		var0_121 = "1"
		var1_121 = "unknown"
	end

	if arg2_121.unknown_small then
		var1_121 = "unknown_small"
	end

	local var2_121 = findTF(arg0_121, "icon_bg/new")

	if var2_121 then
		if arg2_121.isSkin then
			setActive(var2_121, not arg2_121.isTimeLimit and arg2_121.isNew)
		else
			setActive(var2_121, arg1_121.virgin)
		end
	end

	local var3_121 = findTF(arg0_121, "icon_bg/timelimit")

	if var3_121 then
		setActive(var3_121, arg2_121.isTimeLimit)
	end

	local var4_121 = findTF(arg0_121, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. (arg2_121.isSkin and "_skin" or var0_121), var4_121)

	local var5_121 = findTF(arg0_121, "icon_bg/frame")
	local var6_121

	if arg1_121.isNpc then
		var6_121 = "frame_npc"
	elseif arg1_121:ShowPropose() then
		var6_121 = "frame_prop"

		if arg1_121:isMetaShip() then
			var6_121 = var6_121 .. "_meta"
		end
	elseif arg2_121.isSkin then
		var6_121 = "frame_skin"
	end

	setFrame(var5_121, var0_121, var6_121)

	if arg2_121.gray then
		setGray(var4_121, true, true)
	end

	local var7_121 = findTF(arg0_121, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg2_121.Q and "QIcon/" or "SquareIcon/") .. var1_121, "", var7_121)

	local var8_121 = findTF(arg0_121, "icon_bg/lv")

	if var8_121 then
		setActive(var8_121, not arg1_121.isNpc)

		if not arg1_121.isNpc then
			local var9_121 = findTF(var8_121, "Text")

			if var9_121 and arg1_121.level then
				setText(var9_121, arg1_121.level)
			end
		end
	end

	local var10_121 = findTF(arg0_121, "ship_type")

	if var10_121 then
		setActive(var10_121, true)
		setImageSprite(var10_121, GetSpriteFromAtlas("shiptype", shipType2print(arg1_121:getShipType())))
	end

	local var11_121 = var4_121:Find("npc")

	if not IsNil(var11_121) then
		if var2_121 and go(var2_121).activeSelf then
			setActive(var11_121, false)
		else
			setActive(var11_121, arg1_121:isActivityNpc())
		end
	end

	local var12_121 = arg0_121:Find("group_locked")

	if var12_121 then
		setActive(var12_121, not arg2_121.isSkin and not getProxy(CollectionProxy):getShipGroup(arg1_121.groupId))
	end

	setIconStars(arg0_121, arg2_121.initStar, arg1_121:getStar())
	setIconName(arg0_121, arg2_121.isSkin and arg1_121:GetSkinConfig().name or arg1_121:getName(), arg2_121)
	setIconColorful(arg0_121, arg2_121.isSkin and ItemRarity.Gold or arg1_121:getRarity() - 1, arg2_121)
end

function updateCommander(arg0_122, arg1_122, arg2_122)
	arg2_122 = arg2_122 or {}

	local var0_122 = arg1_122:getDropRarity()
	local var1_122 = ItemRarity.Rarity2Print(var0_122)
	local var2_122 = arg1_122:getConfig("painting")

	if arg2_122.anonymous then
		var1_122 = 1
		var2_122 = "unknown"
	end

	local var3_122 = findTF(arg0_122, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_122, var3_122)

	local var4_122 = findTF(arg0_122, "icon_bg/frame")

	setFrame(var4_122, var1_122)

	if arg2_122.gray then
		setGray(var3_122, true, true)
	end

	local var5_122 = findTF(arg0_122, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("CommanderIcon/" .. var2_122, "", var5_122)
	setIconStars(arg0_122, arg2_122.initStar, 0)
	setIconName(arg0_122, arg1_122:getName(), arg2_122)
end

function updateStrategy(arg0_123, arg1_123, arg2_123)
	arg2_123 = arg2_123 or {}

	local var0_123 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_123, findTF(arg0_123, "icon_bg"))
	setFrame(findTF(arg0_123, "icon_bg/frame"), var0_123)

	local var1_123 = findTF(arg0_123, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg1_123.isWorldBuff and "world/buff/" or "strategyicon/") .. arg1_123:getIcon(), "", var1_123)
	setIconStars(arg0_123, false)
	setIconName(arg0_123, arg1_123:getName(), arg2_123)
	setIconColorful(arg0_123, ItemRarity.Gray, arg2_123)
end

function updateFurniture(arg0_124, arg1_124, arg2_124)
	arg2_124 = arg2_124 or {}

	local var0_124 = arg1_124:getDropRarity()
	local var1_124 = ItemRarity.Rarity2Print(var0_124)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_124, findTF(arg0_124, "icon_bg"))
	setFrame(findTF(arg0_124, "icon_bg/frame"), var1_124)

	local var2_124 = findTF(arg0_124, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1_124:getIcon(), "", var2_124)
	setIconStars(arg0_124, false)
	setIconName(arg0_124, arg1_124:getName(), arg2_124)
	setIconColorful(arg0_124, var0_124, arg2_124)
end

function updateSpWeapon(arg0_125, arg1_125, arg2_125)
	arg2_125 = arg2_125 or {}

	assert(arg1_125, "spWeaponVO can not be nil.")
	assert(isa(arg1_125, SpWeapon), "spWeaponVO is not Equipment.")

	local var0_125 = ItemRarity.Rarity2Print(arg1_125:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_125, findTF(arg0_125, "icon_bg"))
	setFrame(findTF(arg0_125, "icon_bg/frame"), var0_125)

	local var1_125 = findTF(arg0_125, "icon_bg/icon")

	var4_0(var1_125, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync(arg1_125:GetIconPath(), "", var1_125)
	setIconStars(arg0_125, true, arg1_125:GetRarity())
	var7_0(arg0_125, arg1_125:GetLevel() - 1)
	setIconName(arg0_125, arg1_125:GetName(), arg2_125)
	setIconCount(arg0_125, arg1_125.count)
	setIconColorful(arg0_125, arg1_125:GetRarity(), arg2_125)
end

function UpdateSpWeaponSlot(arg0_126, arg1_126, arg2_126)
	local var0_126 = ItemRarity.Rarity2Print(arg1_126:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_126, findTF(arg0_126, "Icon/Mask/icon_bg"))

	local var1_126 = findTF(arg0_126, "Icon/Mask/icon_bg/icon")

	arg2_126 = arg2_126 or {
		16,
		16,
		16,
		16
	}

	var4_0(var1_126, arg2_126)
	GetImageSpriteFromAtlasAsync(arg1_126:GetIconPath(), "", var1_126)

	local var2_126 = arg1_126:GetLevel() - 1
	local var3_126 = findTF(arg0_126, "Icon/LV")

	setActive(var3_126, var2_126 > 0)
	setText(findTF(var3_126, "Text"), var2_126)
end

function updateDorm3dIcon(arg0_127, arg1_127)
	local var0_127 = arg1_127:getDropRarityDorm()

	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(var0_127), arg0_127)

	local var1_127 = arg0_127:Find("icon")

	GetImageSpriteFromAtlasAsync(arg1_127:getIcon(), "", var1_127)
	setText(arg0_127:Find("count/Text"), "x" .. arg1_127.count)
	setText(arg0_127:Find("name/Text"), arg1_127:getName())
end

function setLoveLetterMedal(arg0_128, arg1_128, arg2_128)
	local var0_128

	seriesAsync({
		function(arg0_129)
			GetPrefabFromAtlasAsync(arg1_128:GetPrefabName(), arg0_128, function(arg0_130)
				var0_128 = arg0_130.transform

				eachChild(arg0_128, function(arg0_131, arg1_131)
					if arg0_131.name ~= arg0_130.name then
						returnLoveLetterMedal(arg0_131)
					end
				end)
				arg0_129()
			end)
		end
	}, function()
		local var0_132 = arg1_128:GetPainting()

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. var0_132, "", var0_128:Find("mask/icon"))
		setText(var0_128:Find("front/mark/Text"), arg1_128:GetDisplayLevelMark())
		setActive(var0_128:Find("pick_up"), arg2_128 and arg2_128.showPickUp)
		setActive(var0_128:Find("front/mark"), true)

		if arg2_128 and arg2_128.hideMark then
			setActive(var0_128:Find("front/mark"), false)
		end
	end)
end

function returnLoveLetterMedal(arg0_133)
	if IsNil(arg0_133) then
		return
	end

	local var0_133 = string.gsub(arg0_133.name, "%(Clone%)", "")

	pg.PoolMgr.GetInstance():ReturnPrefab("lovelettermedal/" .. string.lower(var0_133), "", arg0_133.gameObject)
end

local var8_0

function findCullAndClipWorldRect(arg0_134)
	if #arg0_134 == 0 then
		return false
	end

	local var0_134 = arg0_134[1].canvasRect

	for iter0_134 = 1, #arg0_134 do
		var0_134 = rectIntersect(var0_134, arg0_134[iter0_134].canvasRect)
	end

	if var0_134.width <= 0 or var0_134.height <= 0 then
		return false
	end

	var8_0 = var8_0 or GameObject.Find("UICamera/Canvas").transform

	local var1_134 = var8_0:TransformPoint(Vector3(var0_134.x, var0_134.y, 0))
	local var2_134 = var8_0:TransformPoint(Vector3(var0_134.x + var0_134.width, var0_134.y + var0_134.height, 0))

	return true, Vector4(var1_134.x, var1_134.y, var2_134.x, var2_134.y)
end

function rectIntersect(arg0_135, arg1_135)
	local var0_135 = math.max(arg0_135.x, arg1_135.x)
	local var1_135 = math.min(arg0_135.x + arg0_135.width, arg1_135.x + arg1_135.width)
	local var2_135 = math.max(arg0_135.y, arg1_135.y)
	local var3_135 = math.min(arg0_135.y + arg0_135.height, arg1_135.y + arg1_135.height)

	if var0_135 <= var1_135 and var2_135 <= var3_135 then
		return var0_0.Rect.New(var0_135, var2_135, var1_135 - var0_135, var3_135 - var2_135)
	end

	return var0_0.Rect.New(0, 0, 0, 0)
end

function getDropInfo(arg0_136)
	local var0_136 = {}

	for iter0_136, iter1_136 in ipairs(arg0_136) do
		local var1_136 = Drop.Create(iter1_136)

		var1_136.count = var1_136.count or 1

		if var1_136.type == DROP_TYPE_EMOJI then
			table.insert(var0_136, var1_136:getName())
		else
			table.insert(var0_136, var1_136:getName() .. "x" .. var1_136.count)
		end
	end

	return table.concat(var0_136, "、")
end

function updateDrop(arg0_137, arg1_137, arg2_137)
	Drop.Change(arg1_137)

	arg2_137 = arg2_137 or {}

	local var0_137 = {
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
	local var1_137

	for iter0_137, iter1_137 in ipairs(var0_137) do
		local var2_137 = arg0_137:Find(iter1_137[1])

		if arg1_137.type ~= iter1_137[2] and not IsNil(var2_137) then
			setActive(var2_137, false)
		end
	end

	if not IsNil(arg0_137:Find("icon_bg/frame")) then
		arg0_137:Find("icon_bg/frame"):GetComponent(typeof(Image)).enabled = true

		setIconColorful(arg0_137, arg1_137:getDropRarity(), arg2_137, {
			[ItemRarity.Gold] = {
				name = "Item_duang5",
				active = function(arg0_138, arg1_138)
					return arg1_138.fromAwardLayer and arg0_138 >= ItemRarity.Gold
				end
			}
		})
		var4_0(findTF(arg0_137, "icon_bg/icon"), {
			2,
			2,
			2,
			2
		})
	end

	arg1_137:UpdateDropTpl(arg0_137, arg2_137)
	setIconCount(arg0_137, arg2_137.count or arg1_137:getCount())
end

function updateCustomDrop(arg0_139, arg1_139, arg2_139)
	Drop.Change(arg1_139)

	arg2_139 = arg2_139 or {}

	arg1_139:UpdateCustomDropTpl(arg0_139, arg2_139)
end

function updateBuff(arg0_140, arg1_140, arg2_140)
	arg2_140 = arg2_140 or {}

	local var0_140 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_140, findTF(arg0_140, "icon_bg"))

	local var1_140 = pg.benefit_buff_template[arg1_140]

	setFrame(findTF(arg0_140, "icon_bg/frame"), var0_140)
	setText(findTF(arg0_140, "icon_bg/count"), 1)

	local var2_140 = findTF(arg0_140, "icon_bg/icon")
	local var3_140 = var1_140.icon

	GetImageSpriteFromAtlasAsync(var3_140, "", var2_140)
	setIconStars(arg0_140, false)
	setIconName(arg0_140, var1_140.name, arg2_140)
	setIconColorful(arg0_140, ItemRarity.Gold, arg2_140)
end

function updateAttire(arg0_141, arg1_141, arg2_141, arg3_141)
	local var0_141 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_141, findTF(arg0_141, "icon_bg"))
	setFrame(findTF(arg0_141, "icon_bg/frame"), var0_141)

	local var1_141 = findTF(arg0_141, "icon_bg/icon")
	local var2_141

	if arg1_141 == AttireConst.TYPE_CHAT_FRAME then
		var2_141 = "chat_frame"
	elseif arg1_141 == AttireConst.TYPE_ICON_FRAME then
		var2_141 = "icon_frame"
	end

	GetImageSpriteFromAtlasAsync("Props/" .. var2_141, "", var1_141)
	setIconName(arg0_141, arg2_141.name, arg3_141)
end

function updateAttireCombatUI(arg0_142, arg1_142, arg2_142, arg3_142)
	local var0_142 = arg2_142.rare

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_142, findTF(arg0_142, "icon_bg"))
	setFrame(findTF(arg0_142, "icon_bg/frame"), var0_142, "frame_battle_ui")

	local var1_142 = findTF(arg0_142, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("Props/" .. arg2_142.display_icon, "", var1_142)
	setIconName(arg0_142, arg2_142.name, arg3_142)
end

function updateActivityMedal(arg0_143, arg1_143, arg2_143)
	local var0_143 = ItemRarity.Rarity2Print(arg1_143.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_143, findTF(arg0_143, "icon_bg"))
	setFrame(findTF(arg0_143, "icon_bg/frame"), var0_143)

	local var1_143 = findTF(arg0_143, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_143.icon, "", var1_143)
	setIconName(arg0_143, arg1_143.name, arg2_143)
end

function updateCover(arg0_144, arg1_144, arg2_144)
	local var0_144 = arg1_144:getDropRarity()

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_144, findTF(arg0_144, "icon_bg"))
	setFrame(findTF(arg0_144, "icon_bg/frame"), var0_144)

	local var1_144 = findTF(arg0_144, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_144:getIcon(), "", var1_144)
	setIconName(arg0_144, arg1_144:getName(), arg2_144)
	setIconStars(arg0_144, false)
end

function updateEmoji(arg0_145, arg1_145, arg2_145)
	local var0_145 = findTF(arg0_145, "icon_bg/icon")
	local var1_145 = "icon_emoji"

	GetImageSpriteFromAtlasAsync("Props/" .. var1_145, "", var0_145)

	local var2_145 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var2_145, findTF(arg0_145, "icon_bg"))
	setFrame(findTF(arg0_145, "icon_bg/frame"), var2_145)
	setIconName(arg0_145, arg1_145.name, arg2_145)
end

function updateEquipmentSkin(arg0_146, arg1_146, arg2_146)
	arg2_146 = arg2_146 or {}

	local var0_146 = EquipmentRarity.Rarity2Print(arg1_146.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_146, findTF(arg0_146, "icon_bg"))
	setFrame(findTF(arg0_146, "icon_bg/frame"), var0_146, "frame_skin")

	local var1_146 = findTF(arg0_146, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. arg1_146.icon, "", var1_146)
	setIconStars(arg0_146, false)
	setIconName(arg0_146, arg1_146.name, arg2_146)
	setIconCount(arg0_146, arg1_146.count)
	setIconColorful(arg0_146, arg1_146.rarity - 1, arg2_146)
end

function NoPosMsgBox(arg0_147, arg1_147, arg2_147, arg3_147)
	local var0_147
	local var1_147 = {}

	if arg1_147 then
		table.insert(var1_147, {
			text = "text_noPos_clear",
			atuoClose = true,
			onCallback = arg1_147
		})
	end

	if arg2_147 then
		table.insert(var1_147, {
			text = "text_noPos_buy",
			atuoClose = true,
			onCallback = arg2_147
		})
	end

	if arg3_147 then
		table.insert(var1_147, {
			text = "text_noPos_intensify",
			atuoClose = true,
			onCallback = arg3_147
		})
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		hideNo = true,
		content = arg0_147,
		custom = var1_147
	})
end

function openDestroyEquip()
	if pg.m02:hasMediator(EquipmentMediator.__cname) then
		local var0_148 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_148 and var0_148.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_148
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
		local var0_149 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_149 and var0_149.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_149
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
		onClick = function(arg0_152, arg1_152)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
				page = 3,
				shipId = arg0_152.id,
				shipVOs = arg1_152
			})
		end
	})
end

function GoShoppingMsgBox(arg0_153, arg1_153, arg2_153)
	if arg2_153 then
		local var0_153 = ""

		for iter0_153, iter1_153 in ipairs(arg2_153) do
			local var1_153 = Item.getConfigData(iter1_153[1])

			var0_153 = var0_153 .. i18n(iter1_153[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var1_153.name, iter1_153[2])

			if iter0_153 < #arg2_153 then
				var0_153 = var0_153 .. i18n("text_noRes_info_tip_link")
			end
		end

		if var0_153 ~= "" then
			arg0_153 = arg0_153 .. "\n" .. i18n("text_noRes_tip", var0_153)
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = arg0_153,
		onYes = function()
			gotoChargeScene(arg1_153, arg2_153)
		end
	})
end

function shoppingBatch(arg0_155, arg1_155, arg2_155, arg3_155, arg4_155)
	local var0_155 = pg.shop_template[arg0_155]

	assert(var0_155, "shop_template中找不到商品id：" .. arg0_155)

	local var1_155 = getProxy(PlayerProxy):getData()[id2res(var0_155.resource_type)]
	local var2_155 = arg1_155.price or var0_155.resource_num
	local var3_155 = math.floor(var1_155 / var2_155)

	var3_155 = var3_155 <= 0 and 1 or var3_155
	var3_155 = arg2_155 ~= nil and arg2_155 < var3_155 and arg2_155 or var3_155

	local var4_155 = true
	local var5_155 = 1

	if var0_155 ~= nil and arg1_155.id then
		print(var3_155 * var0_155.num, "--", var3_155)
		assert(Item.getConfigData(arg1_155.id), "item config should be existence")

		local var6_155 = Item.New({
			id = arg1_155.id
		}):getConfig("name")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			needCounter = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_ITEM,
				id = arg1_155.id
			},
			addNum = var0_155.num,
			maxNum = var3_155 * var0_155.num,
			defaultNum = var0_155.num,
			numUpdate = function(arg0_156, arg1_156)
				var5_155 = math.floor(arg1_156 / var0_155.num)

				local var0_156 = var5_155 * var2_155

				if var0_156 > var1_155 then
					setText(arg0_156, i18n(arg3_155, var0_156, arg1_156, COLOR_RED, var6_155))

					var4_155 = false
				else
					setText(arg0_156, i18n(arg3_155, var0_156, arg1_156, COLOR_GREEN, var6_155))

					var4_155 = true
				end
			end,
			onYes = function()
				if var4_155 then
					pg.m02:sendNotification(GAME.SHOPPING, {
						id = arg0_155,
						count = var5_155
					})
				elseif arg4_155 then
					pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_155))
					pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_OR_SKIN_FAILD)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("main_playerInfoLayer_error_changeNameNoGem"))
				end
			end
		})
	end
end

function shoppingBatchNewStyle(arg0_158, arg1_158, arg2_158, arg3_158, arg4_158)
	local var0_158 = pg.shop_template[arg0_158]

	assert(var0_158, "shop_template中找不到商品id：" .. arg0_158)

	local var1_158 = getProxy(PlayerProxy):getData()[id2res(var0_158.resource_type)]
	local var2_158 = arg1_158.price or var0_158.resource_num
	local var3_158 = math.floor(var1_158 / var2_158)

	var3_158 = var3_158 <= 0 and 1 or var3_158
	var3_158 = arg2_158 ~= nil and arg2_158 < var3_158 and arg2_158 or var3_158

	local var4_158 = true
	local var5_158 = 1

	if var0_158 ~= nil and arg1_158.id then
		print(var3_158 * var0_158.num, "--", var3_158)
		assert(Item.getConfigData(arg1_158.id), "item config should be existence")

		local var6_158 = Item.New({
			id = arg1_158.id
		}):getConfig("name")

		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_SHOPPING, {
			drop = Drop.New({
				count = 1,
				type = DROP_TYPE_ITEM,
				id = arg1_158.id
			}),
			price = var2_158,
			addNum = var0_158.num,
			maxNum = var3_158 * var0_158.num,
			defaultNum = var0_158.num,
			numUpdate = function(arg0_159, arg1_159)
				var5_158 = math.floor(arg1_159 / var0_158.num)

				local var0_159 = var5_158 * var2_158

				if var0_159 > var1_158 then
					setTextInNewStyleBox(arg0_159, i18n(arg3_158, var0_159, arg1_159, COLOR_RED, var6_158))

					var4_158 = false
				else
					setTextInNewStyleBox(arg0_159, i18n(arg3_158, var0_159, arg1_159, "#238C40FF", var6_158))

					var4_158 = true
				end
			end,
			btnList = {
				{
					type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.shopping,
					name = i18n("word_buy"),
					func = function()
						if var4_158 then
							pg.m02:sendNotification(GAME.SHOPPING, {
								id = arg0_158,
								count = var5_158
							})
						elseif arg4_158 then
							pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_158))
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

function gotoChargeScene(arg0_161, arg1_161)
	local var0_161 = getProxy(ContextProxy)
	local var1_161 = getProxy(ContextProxy):getCurrentContext()

	if instanceof(var1_161.mediator, NewShopMainMediator) then
		var1_161.mediator:getViewComponent():switchSubViewByTogger(arg0_161)
	else
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
			wrap = arg0_161 or ChargeScene.TYPE_ITEM,
			noRes = arg1_161
		})
	end

	pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_OR_SKIN_FAILD)
end

function clearDrop(arg0_162)
	local var0_162 = findTF(arg0_162, "icon_bg")
	local var1_162 = findTF(arg0_162, "icon_bg/frame")
	local var2_162 = findTF(arg0_162, "icon_bg/icon")
	local var3_162 = findTF(arg0_162, "icon_bg/icon/icon")

	clearImageSprite(var0_162)
	clearImageSprite(var1_162)
	clearImageSprite(var2_162)

	if var3_162 then
		clearImageSprite(var3_162)
	end
end

local var9_0 = {
	red = Color.New(1, 0.25, 0.25),
	blue = Color.New(0.11, 0.55, 0.64),
	yellow = Color.New(0.92, 0.52, 0)
}

function updateSkill(arg0_163, arg1_163, arg2_163, arg3_163)
	local var0_163 = findTF(arg0_163, "skill")
	local var1_163 = findTF(arg0_163, "lock")
	local var2_163 = findTF(arg0_163, "unknown")

	if arg1_163 then
		setActive(var0_163, true)
		setActive(var2_163, false)
		setActive(var1_163, not arg2_163)
		LoadImageSpriteAsync("skillicon/" .. arg1_163.icon, findTF(var0_163, "icon"))

		local var3_163 = arg1_163.color or "blue"

		setText(findTF(var0_163, "name"), shortenString(getSkillName(arg1_163.id), arg3_163 or 8))

		local var4_163 = findTF(var0_163, "level")

		setText(var4_163, "LEVEL: " .. (arg2_163 and arg2_163.level or "??"))
		setTextColor(var4_163, var9_0[var3_163])
	else
		setActive(var0_163, false)
		setActive(var2_163, true)
		setActive(var1_163, false)
	end
end

local var10_0 = true

function onBackButton(arg0_164, arg1_164, arg2_164, arg3_164)
	local var0_164 = GetOrAddComponent(arg1_164, "UILongPressTrigger")

	assert(arg2_164, "callback should exist")

	var0_164.longPressThreshold = defaultValue(arg3_164, 1)

	local function var1_164(arg0_165)
		return function()
			if var10_0 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SOUND_BACK)
			end

			local var0_166, var1_166 = arg2_164()

			if var0_166 then
				arg0_165(var1_166)
			end
		end
	end

	local var2_164 = var0_164.onReleased

	pg.DelegateInfo.Add(arg0_164, var2_164)
	var2_164:RemoveAllListeners()
	var2_164:AddListener(var1_164(function(arg0_167)
		arg0_167:emit(BaseUI.ON_BACK)
	end))

	local var3_164 = var0_164.onLongPressed

	pg.DelegateInfo.Add(arg0_164, var3_164)
	var3_164:RemoveAllListeners()
	var3_164:AddListener(var1_164(function(arg0_168)
		arg0_168:emit(BaseUI.ON_HOME)
	end))
end

function GetZeroTime()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)
end

function GetHalfHour()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0, 1800)
end

function GetNextHour(arg0_171)
	local var0_171 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_171, var2_171 = pg.TimeMgr.GetInstance():parseTimeFrom(var0_171)

	return var1_171 * 86400 + (var2_171 + arg0_171) * 3600
end

function GetPerceptualSize(arg0_172, arg1_172)
	local function var0_172(arg0_173)
		if not arg0_173 then
			return 0, 1
		elseif arg0_173 > 240 then
			return 4, 1
		elseif arg0_173 > 225 then
			return 3, 1
		elseif arg0_173 > 192 then
			return 2, 1
		elseif arg0_173 < 126 then
			return 1, arg1_172 or 0.5
		else
			return 1, 1
		end
	end

	if type(arg0_172) == "number" then
		return var0_172(arg0_172)
	end

	local var1_172 = 1
	local var2_172 = 0
	local var3_172 = 0
	local var4_172 = #arg0_172

	while var1_172 <= var4_172 do
		local var5_172 = string.byte(arg0_172, var1_172)
		local var6_172, var7_172 = var0_172(var5_172)

		var1_172 = var1_172 + var6_172
		var2_172 = var2_172 + var7_172
	end

	return var2_172
end

function shortenString(arg0_174, arg1_174, arg2_174)
	local var0_174 = 1
	local var1_174 = 0
	local var2_174 = 0
	local var3_174 = #arg0_174

	while var0_174 <= var3_174 do
		local var4_174 = string.byte(arg0_174, var0_174)
		local var5_174, var6_174 = GetPerceptualSize(var4_174, arg2_174)

		var0_174 = var0_174 + var5_174
		var1_174 = var1_174 + var6_174

		if arg1_174 <= math.ceil(var1_174) then
			var2_174 = var0_174

			break
		end
	end

	if var2_174 == 0 or var3_174 < var2_174 then
		return arg0_174
	end

	return string.sub(arg0_174, 1, var2_174 - 1) .. ".."
end

function shouldShortenString(arg0_175, arg1_175)
	local var0_175 = 1
	local var1_175 = 0
	local var2_175 = 0
	local var3_175 = #arg0_175

	while var0_175 <= var3_175 do
		local var4_175 = string.byte(arg0_175, var0_175)
		local var5_175, var6_175 = GetPerceptualSize(var4_175)

		var0_175 = var0_175 + var5_175
		var1_175 = var1_175 + var6_175

		if arg1_175 <= math.ceil(var1_175) then
			var2_175 = var0_175

			break
		end
	end

	if var2_175 == 0 or var3_175 < var2_175 then
		return false
	end

	return true
end

function nameValidityCheck(arg0_176, arg1_176, arg2_176, arg3_176)
	local var0_176 = true
	local var1_176, var2_176 = utf8_to_unicode(arg0_176)
	local var3_176 = filterEgyUnicode(filterSpecChars(arg0_176))
	local var4_176 = wordVer(arg0_176)

	if not checkSpaceValid(arg0_176) then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_176[1]))

		var0_176 = false
	elseif var4_176 > 0 or var3_176 ~= arg0_176 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_176[4]))

		var0_176 = false
	elseif var2_176 < arg1_176 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_176[2]))

		var0_176 = false
	elseif arg2_176 < var2_176 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_176[3]))

		var0_176 = false
	end

	return var0_176
end

function checkSpaceValid(arg0_177)
	if PLATFORM_CODE == PLATFORM_US then
		return true
	end

	local var0_177 = string.gsub(arg0_177, " ", "")

	return arg0_177 == string.gsub(var0_177, "　", "")
end

function filterSpecChars(arg0_178)
	local var0_178 = {}
	local var1_178 = 0
	local var2_178 = 0
	local var3_178 = 0
	local var4_178 = 1

	while var4_178 <= #arg0_178 do
		local var5_178 = string.byte(arg0_178, var4_178)

		if not var5_178 then
			break
		end

		if var5_178 >= 48 and var5_178 <= 57 or var5_178 >= 65 and var5_178 <= 90 or var5_178 == 95 or var5_178 >= 97 and var5_178 <= 122 then
			table.insert(var0_178, string.char(var5_178))
		elseif var5_178 >= 228 and var5_178 <= 233 then
			local var6_178 = string.byte(arg0_178, var4_178 + 1)
			local var7_178 = string.byte(arg0_178, var4_178 + 2)

			if var6_178 and var7_178 and var6_178 >= 128 and var6_178 <= 191 and var7_178 >= 128 and var7_178 <= 191 then
				var4_178 = var4_178 + 2

				table.insert(var0_178, string.char(var5_178, var6_178, var7_178))

				var1_178 = var1_178 + 1
			end
		elseif var5_178 == 45 or var5_178 == 40 or var5_178 == 41 then
			table.insert(var0_178, string.char(var5_178))
		elseif var5_178 == 194 then
			local var8_178 = string.byte(arg0_178, var4_178 + 1)

			if var8_178 == 183 then
				var4_178 = var4_178 + 1

				table.insert(var0_178, string.char(var5_178, var8_178))

				var1_178 = var1_178 + 1
			end
		elseif var5_178 == 239 then
			local var9_178 = string.byte(arg0_178, var4_178 + 1)
			local var10_178 = string.byte(arg0_178, var4_178 + 2)

			if var9_178 == 188 and (var10_178 == 136 or var10_178 == 137) then
				var4_178 = var4_178 + 2

				table.insert(var0_178, string.char(var5_178, var9_178, var10_178))

				var1_178 = var1_178 + 1
			end
		elseif var5_178 == 206 or var5_178 == 207 then
			local var11_178 = string.byte(arg0_178, var4_178 + 1)

			if var5_178 == 206 and var11_178 >= 177 or var5_178 == 207 and var11_178 <= 134 then
				var4_178 = var4_178 + 1

				table.insert(var0_178, string.char(var5_178, var11_178))

				var1_178 = var1_178 + 1
			end
		elseif var5_178 == 227 and PLATFORM_CODE == PLATFORM_JP then
			local var12_178 = string.byte(arg0_178, var4_178 + 1)
			local var13_178 = string.byte(arg0_178, var4_178 + 2)

			if var12_178 and var13_178 and var12_178 > 128 and var12_178 <= 191 and var13_178 >= 128 and var13_178 <= 191 then
				var4_178 = var4_178 + 2

				table.insert(var0_178, string.char(var5_178, var12_178, var13_178))

				var2_178 = var2_178 + 1
			end
		elseif var5_178 >= 224 and PLATFORM_CODE == PLATFORM_KR then
			local var14_178 = string.byte(arg0_178, var4_178 + 1)
			local var15_178 = string.byte(arg0_178, var4_178 + 2)

			if var14_178 and var15_178 and var14_178 >= 128 and var14_178 <= 191 and var15_178 >= 128 and var15_178 <= 191 then
				var4_178 = var4_178 + 2

				table.insert(var0_178, string.char(var5_178, var14_178, var15_178))

				var3_178 = var3_178 + 1
			end
		elseif PLATFORM_CODE == PLATFORM_US then
			if var4_178 ~= 1 and var5_178 == 32 and string.byte(arg0_178, var4_178 + 1) ~= 32 then
				table.insert(var0_178, string.char(var5_178))
			end

			if var5_178 >= 192 and var5_178 <= 223 then
				local var16_178 = string.byte(arg0_178, var4_178 + 1)

				var4_178 = var4_178 + 1

				if var5_178 == 194 and var16_178 and var16_178 >= 128 then
					table.insert(var0_178, string.char(var5_178, var16_178))
				elseif var5_178 == 195 and var16_178 and var16_178 <= 191 then
					table.insert(var0_178, string.char(var5_178, var16_178))
				end
			end
		end

		var4_178 = var4_178 + 1
	end

	return table.concat(var0_178), var1_178 + var2_178 + var3_178
end

function filterEgyUnicode(arg0_179)
	arg0_179 = string.gsub(arg0_179, "�[�-�][�-�]", "")
	arg0_179 = string.gsub(arg0_179, "�[�-�]", "")

	return arg0_179
end

function shiftPanel(arg0_180, arg1_180, arg2_180, arg3_180, arg4_180, arg5_180, arg6_180, arg7_180, arg8_180)
	arg3_180 = arg3_180 or 0.2

	if arg5_180 then
		LeanTween.cancel(go(arg0_180))
	end

	local var0_180 = rtf(arg0_180)

	arg1_180 = arg1_180 or var0_180.anchoredPosition.x
	arg2_180 = arg2_180 or var0_180.anchoredPosition.y

	local var1_180 = LeanTween.move(var0_180, Vector3(arg1_180, arg2_180, 0), arg3_180)

	arg7_180 = arg7_180 or LeanTweenType.easeInOutSine

	var1_180:setEase(arg7_180)

	if arg4_180 then
		var1_180:setDelay(arg4_180)
	end

	if arg6_180 then
		GetOrAddComponent(arg0_180, "CanvasGroup").blocksRaycasts = false
	end

	var1_180:setOnComplete(System.Action(function()
		if arg8_180 then
			arg8_180()
		end

		if arg6_180 then
			GetOrAddComponent(arg0_180, "CanvasGroup").blocksRaycasts = true
		end
	end))

	return var1_180
end

function TweenValue(arg0_182, arg1_182, arg2_182, arg3_182, arg4_182, arg5_182, arg6_182, arg7_182)
	local var0_182 = LeanTween.value(go(arg0_182), arg1_182, arg2_182, arg3_182):setOnUpdate(System.Action_float(function(arg0_183)
		if arg5_182 then
			arg5_182(arg0_183)
		end
	end)):setOnComplete(System.Action(function()
		if arg6_182 then
			arg6_182()
		end
	end)):setDelay(arg4_182 or 0)

	if arg7_182 and arg7_182 > 0 then
		var0_182:setRepeat(arg7_182)
	end

	return var0_182
end

function rotateAni(arg0_185, arg1_185, arg2_185)
	return LeanTween.rotate(rtf(arg0_185), 360 * arg1_185, arg2_185):setLoopClamp()
end

function blinkAni(arg0_186, arg1_186, arg2_186, arg3_186)
	return LeanTween.alpha(rtf(arg0_186), arg3_186 or 0, arg1_186):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(arg2_186 or 0)
end

function scaleAni(arg0_187, arg1_187, arg2_187, arg3_187)
	return LeanTween.scale(rtf(arg0_187), arg3_187 or 0, arg1_187):setLoopPingPong(arg2_187 or 0)
end

function floatAni(arg0_188, arg1_188, arg2_188, arg3_188)
	local var0_188 = arg0_188.localPosition.y + arg1_188

	return LeanTween.moveY(rtf(arg0_188), var0_188, arg2_188):setLoopPingPong(arg3_188 or 0)
end

local var11_0 = tostring

function tostring(arg0_189)
	if arg0_189 == nil then
		return "nil"
	end

	local var0_189 = var11_0(arg0_189)

	if var0_189 == nil then
		if type(arg0_189) == "table" then
			return "{}"
		end

		return " ~nil"
	end

	return var0_189
end

function wordVer(arg0_190, arg1_190)
	if arg0_190.match(arg0_190, ChatConst.EmojiCodeMatch) then
		return 0, arg0_190
	end

	arg1_190 = arg1_190 or {}

	local var0_190 = filterEgyUnicode(arg0_190)

	if #var0_190 ~= #arg0_190 then
		if arg1_190.isReplace then
			arg0_190 = var0_190
		else
			return 1
		end
	end

	local var1_190 = wordSplit(arg0_190)
	local var2_190 = pg.word_template
	local var3_190 = pg.word_legal_template

	arg1_190.isReplace = arg1_190.isReplace or false
	arg1_190.replaceWord = arg1_190.replaceWord or "*"

	local var4_190 = #var1_190
	local var5_190 = 1
	local var6_190 = ""
	local var7_190 = 0

	while var5_190 <= var4_190 do
		local var8_190, var9_190, var10_190 = wordLegalMatch(var1_190, var3_190, var5_190)

		if var8_190 then
			var5_190 = var9_190
			var6_190 = var6_190 .. var10_190
		else
			local var11_190, var12_190, var13_190 = wordVerMatch(var1_190, var2_190, arg1_190, var5_190, "", false, var5_190, "")

			if var11_190 then
				var5_190 = var12_190
				var7_190 = var7_190 + 1

				if arg1_190.isReplace then
					var6_190 = var6_190 .. var13_190
				end
			else
				if arg1_190.isReplace then
					var6_190 = var6_190 .. var1_190[var5_190]
				end

				var5_190 = var5_190 + 1
			end
		end
	end

	if arg1_190.isReplace then
		return var7_190, var6_190
	else
		return var7_190
	end
end

function wordLegalMatch(arg0_191, arg1_191, arg2_191, arg3_191, arg4_191)
	if arg2_191 > #arg0_191 then
		return arg3_191, arg2_191, arg4_191
	end

	local var0_191 = arg0_191[arg2_191]
	local var1_191 = arg1_191[var0_191]

	arg4_191 = arg4_191 == nil and "" or arg4_191

	if var1_191 then
		if var1_191.this then
			return wordLegalMatch(arg0_191, var1_191, arg2_191 + 1, true, arg4_191 .. var0_191)
		else
			return wordLegalMatch(arg0_191, var1_191, arg2_191 + 1, false, arg4_191 .. var0_191)
		end
	else
		return arg3_191, arg2_191, arg4_191
	end
end

local var12_0 = string.byte("a")
local var13_0 = string.byte("z")
local var14_0 = string.byte("A")
local var15_0 = string.byte("Z")

local function var16_0(arg0_192)
	if not arg0_192 then
		return arg0_192
	end

	local var0_192 = string.byte(arg0_192)

	if var0_192 > 128 then
		return
	end

	if var0_192 >= var12_0 and var0_192 <= var13_0 then
		return string.char(var0_192 - 32)
	elseif var0_192 >= var14_0 and var0_192 <= var15_0 then
		return string.char(var0_192 + 32)
	else
		return arg0_192
	end
end

function wordVerMatch(arg0_193, arg1_193, arg2_193, arg3_193, arg4_193, arg5_193, arg6_193, arg7_193)
	if arg3_193 > #arg0_193 then
		return arg5_193, arg6_193, arg7_193
	end

	local var0_193 = arg0_193[arg3_193]
	local var1_193 = arg1_193[var0_193]

	if var1_193 then
		local var2_193, var3_193, var4_193 = wordVerMatch(arg0_193, var1_193, arg2_193, arg3_193 + 1, arg2_193.isReplace and arg4_193 .. arg2_193.replaceWord or arg4_193, var1_193.this or arg5_193, var1_193.this and arg3_193 + 1 or arg6_193, var1_193.this and (arg2_193.isReplace and arg4_193 .. arg2_193.replaceWord or arg4_193) or arg7_193)

		if var2_193 then
			return var2_193, var3_193, var4_193
		end
	end

	local var5_193 = var16_0(var0_193)
	local var6_193 = arg1_193[var5_193]

	if var5_193 ~= var0_193 and var6_193 then
		local var7_193, var8_193, var9_193 = wordVerMatch(arg0_193, var6_193, arg2_193, arg3_193 + 1, arg2_193.isReplace and arg4_193 .. arg2_193.replaceWord or arg4_193, var6_193.this or arg5_193, var6_193.this and arg3_193 + 1 or arg6_193, var6_193.this and (arg2_193.isReplace and arg4_193 .. arg2_193.replaceWord or arg4_193) or arg7_193)

		if var7_193 then
			return var7_193, var8_193, var9_193
		end
	end

	return arg5_193, arg6_193, arg7_193
end

function wordSplit(arg0_194)
	local var0_194 = {}

	for iter0_194 in arg0_194.gmatch(arg0_194, "[\x01-\x7F�-�][�-�]*") do
		var0_194[#var0_194 + 1] = iter0_194
	end

	return var0_194
end

function contentWrap(arg0_195, arg1_195, arg2_195)
	local var0_195 = LuaHelper.WrapContent(arg0_195, arg1_195, arg2_195)

	return #var0_195 ~= #arg0_195, var0_195
end

function cancelRich(arg0_196)
	local var0_196

	for iter0_196 = 1, 20 do
		local var1_196

		arg0_196, var1_196 = string.gsub(arg0_196, "<([^>]*)>", "%1")

		if var1_196 <= 0 then
			break
		end
	end

	return arg0_196
end

function cancelColorRich(arg0_197)
	local var0_197

	for iter0_197 = 1, 20 do
		local var1_197

		arg0_197, var1_197 = string.gsub(arg0_197, "<color=#[a-zA-Z0-9]+>(.-)</color>", "%1")

		if var1_197 <= 0 then
			break
		end
	end

	return arg0_197
end

function getSkillConfig(arg0_198)
	local var0_198 = pg.buffCfg["buff_" .. arg0_198]

	if not var0_198 then
		return
	end

	local var1_198 = Clone(var0_198)

	var1_198.name = getSkillName(arg0_198)
	var1_198.desc = HXSet.hxLan(var1_198.desc)
	var1_198.desc_get = HXSet.hxLan(var1_198.desc_get)

	_.each(var1_198, function(arg0_199)
		arg0_199.desc = HXSet.hxLan(arg0_199.desc)
	end)

	return var1_198
end

function getSkillName(arg0_200)
	local var0_200 = pg.skill_data_template[arg0_200] or pg.skill_data_display[arg0_200]

	if var0_200 then
		return HXSet.hxLan(var0_200.name)
	else
		return ""
	end
end

function getSkillDescGet(arg0_201, arg1_201)
	local var0_201 = arg1_201 and pg.skill_world_display[arg0_201] and setmetatable({}, {
		__index = function(arg0_202, arg1_202)
			return pg.skill_world_display[arg0_201][arg1_202] or pg.skill_data_template[arg0_201][arg1_202]
		end
	}) or pg.skill_data_template[arg0_201]

	if not var0_201 then
		return ""
	end

	local var1_201 = var0_201.desc_get ~= "" and var0_201.desc_get or var0_201.desc

	for iter0_201, iter1_201 in pairs(var0_201.desc_get_add) do
		local var2_201 = setColorStr(iter1_201[1], COLOR_GREEN)

		if iter1_201[2] then
			var2_201 = var2_201 .. specialGSub(i18n("word_skill_desc_get"), "$1", setColorStr(iter1_201[2], COLOR_GREEN))
		end

		var1_201 = specialGSub(var1_201, "$" .. iter0_201, var2_201)
	end

	return HXSet.hxLan(var1_201)
end

function getSkillDescLearn(arg0_203, arg1_203, arg2_203)
	local var0_203 = arg2_203 and pg.skill_world_display[arg0_203] and setmetatable({}, {
		__index = function(arg0_204, arg1_204)
			return pg.skill_world_display[arg0_203][arg1_204] or pg.skill_data_template[arg0_203][arg1_204]
		end
	}) or pg.skill_data_template[arg0_203]

	if not var0_203 then
		return ""
	end

	local var1_203 = var0_203.desc

	if not var0_203.desc_add then
		return HXSet.hxLan(var1_203)
	end

	for iter0_203, iter1_203 in pairs(var0_203.desc_add) do
		local var2_203 = iter1_203[arg1_203][1]

		if iter1_203[arg1_203][2] then
			var2_203 = var2_203 .. specialGSub(i18n("word_skill_desc_learn"), "$1", iter1_203[arg1_203][2])
		end

		var1_203 = specialGSub(var1_203, "$" .. iter0_203, setColorStr(var2_203, COLOR_YELLOW))
	end

	return HXSet.hxLan(var1_203)
end

function getSkillDesc(arg0_205, arg1_205, arg2_205)
	local var0_205 = arg2_205 and pg.skill_world_display[arg0_205] and setmetatable({}, {
		__index = function(arg0_206, arg1_206)
			return pg.skill_world_display[arg0_205][arg1_206] or pg.skill_data_template[arg0_205][arg1_206]
		end
	}) or pg.skill_data_template[arg0_205]

	if not var0_205 then
		return ""
	end

	local var1_205 = var0_205.desc

	if not var0_205.desc_add then
		return HXSet.hxLan(var1_205)
	end

	for iter0_205, iter1_205 in pairs(var0_205.desc_add) do
		local var2_205 = setColorStr(iter1_205[arg1_205][1], COLOR_GREEN)

		var1_205 = specialGSub(var1_205, "$" .. iter0_205, var2_205)
	end

	return HXSet.hxLan(var1_205)
end

function specialGSub(arg0_207, arg1_207, arg2_207)
	arg0_207 = string.gsub(arg0_207, "<color=#", "<color=NNN")
	arg0_207 = string.gsub(arg0_207, "#", "")
	arg2_207 = string.gsub(arg2_207, "%%", "%%%%")
	arg0_207 = string.gsub(arg0_207, arg1_207, arg2_207)
	arg0_207 = string.gsub(arg0_207, "<color=NNN", "<color=#")

	return arg0_207
end

function topAnimation(arg0_208, arg1_208, arg2_208, arg3_208, arg4_208, arg5_208)
	local var0_208 = {}

	arg4_208 = arg4_208 or 0.27

	local var1_208 = 0.05

	if arg0_208 then
		local var2_208 = arg0_208.transform.localPosition.x

		setAnchoredPosition(arg0_208, {
			x = var2_208 - 500
		})
		shiftPanel(arg0_208, var2_208, nil, 0.05, arg4_208, true, true)
		setActive(arg0_208, true)
	end

	setActive(arg1_208, false)
	setActive(arg2_208, false)
	setActive(arg3_208, false)

	for iter0_208 = 1, 3 do
		table.insert(var0_208, LeanTween.delayedCall(arg4_208 + 0.13 + var1_208 * iter0_208, System.Action(function()
			if arg1_208 then
				setActive(arg1_208, not arg1_208.gameObject.activeSelf)
			end
		end)).uniqueId)
		table.insert(var0_208, LeanTween.delayedCall(arg4_208 + 0.02 + var1_208 * iter0_208, System.Action(function()
			if arg2_208 then
				setActive(arg2_208, not go(arg2_208).activeSelf)
			end

			if arg2_208 then
				setActive(arg3_208, not go(arg3_208).activeSelf)
			end
		end)).uniqueId)
	end

	if arg5_208 then
		table.insert(var0_208, LeanTween.delayedCall(arg4_208 + 0.13 + var1_208 * 3 + 0.1, System.Action(function()
			arg5_208()
		end)).uniqueId)
	end

	return var0_208
end

function cancelTweens(arg0_212)
	assert(arg0_212, "must provide cancel targets, LeanTween.cancelAll is not allow")

	for iter0_212, iter1_212 in ipairs(arg0_212) do
		if iter1_212 then
			LeanTween.cancel(iter1_212)
		end
	end
end

function getOfflineTimeStamp(arg0_213)
	local var0_213 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_213
	local var1_213 = ""

	if var0_213 <= 59 then
		var1_213 = i18n("just_now")
	elseif var0_213 <= 3599 then
		var1_213 = i18n("several_minutes_before", math.floor(var0_213 / 60))
	elseif var0_213 <= 86399 then
		var1_213 = i18n("several_hours_before", math.floor(var0_213 / 3600))
	else
		var1_213 = i18n("several_days_before", math.floor(var0_213 / 86400))
	end

	return var1_213
end

PaintCameraAdjustOn = false

function cameraPaintViewAdjust(arg0_214)
	if PaintCameraAdjustOn ~= arg0_214 then
		local var0_214 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(CanvasScaler))

		if arg0_214 then
			var0_214.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight
			var0_214.matchWidthOrHeight = 1
		else
			var0_214.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand
		end

		pg.CameraFixMgr.GetInstance():BlockCameraRatioControll(arg0_214)

		PaintCameraAdjustOn = arg0_214
	end
end

function ManhattonDist(arg0_215, arg1_215)
	return math.abs(arg0_215.row - arg1_215.row) + math.abs(arg0_215.column - arg1_215.column)
end

function checkFirstHelpShow(arg0_216)
	local var0_216 = getProxy(SettingsProxy)

	if not var0_216:checkReadHelp(arg0_216) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[arg0_216].tip
		})
		var0_216:recordReadHelp(arg0_216)
	end
end

preOrientation = nil
preNotchFitterEnabled = false

function openPortrait(arg0_217)
	preOrientation = Input.deviceOrientation:ToString()

	originalPrint("Begining Orientation:" .. preOrientation)

	Screen.autorotateToPortrait = true
	Screen.autorotateToPortraitUpsideDown = true

	cameraPaintViewAdjust(true)
end

function closePortrait(arg0_218)
	Screen.autorotateToPortrait = false
	Screen.autorotateToPortraitUpsideDown = false

	originalPrint("Closing Orientation:" .. preOrientation)

	Screen.orientation = ScreenOrientation.LandscapeLeft

	local var0_218 = Timer.New(function()
		Screen.orientation = ScreenOrientation.AutoRotation
	end, 0.2, 1):Start()

	cameraPaintViewAdjust(false)
end

function comma_value(arg0_220)
	local var0_220 = arg0_220
	local var1_220 = 0

	repeat
		local var2_220

		var0_220, var2_220 = string.gsub(var0_220, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var2_220 == 0

	return var0_220
end

local var17_0 = 0.2

function SwitchPanel(arg0_221, arg1_221, arg2_221, arg3_221, arg4_221, arg5_221)
	arg3_221 = defaultValue(arg3_221, var17_0)

	if arg5_221 then
		LeanTween.cancel(go(arg0_221))
	end

	local var0_221 = Vector3.New(tf(arg0_221).localPosition.x, tf(arg0_221).localPosition.y, tf(arg0_221).localPosition.z)

	if arg1_221 then
		var0_221.x = arg1_221
	end

	if arg2_221 then
		var0_221.y = arg2_221
	end

	local var1_221 = LeanTween.move(rtf(arg0_221), var0_221, arg3_221):setEase(LeanTweenType.easeInOutSine)

	if arg4_221 then
		var1_221:setDelay(arg4_221)
	end

	return var1_221
end

function updateActivityTaskStatus(arg0_222)
	if IslandTaskActhelper.IsIslandTaskAct(arg0_222) then
		return
	end

	local var0_222 = arg0_222:getConfig("config_id")
	local var1_222, var2_222 = getActivityTask(arg0_222, true)

	if not var2_222 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_222.id
		})

		return true
	end

	return false
end

function updateCrusingActivityTask(arg0_223)
	local var0_223 = getProxy(TaskProxy)
	local var1_223 = arg0_223:getNDay()
	local var2_223 = pg.TimeMgr.GetInstance():GetServerOverWeek(arg0_223:getStartTime())

	for iter0_223, iter1_223 in ipairs(arg0_223:getConfig("config_data")) do
		local var3_223 = pg.battlepass_task_group[iter1_223]

		if var3_223 and var2_223 >= var3_223.group_mask then
			if underscore.any(underscore.flatten(var3_223.task_group), function(arg0_224)
				return var0_223:getTaskVO(arg0_224) == nil
			end) then
				pg.m02:sendNotification(GAME.CRUSING_CMD, {
					cmd = 1,
					activity_id = arg0_223.id
				})

				return true
			end
		elseif not var3_223 then
			warning("battlepass_task_group表中不存在 id = " .. iter1_223)
		end
	end

	return false
end

function updateCrusingHei5ActivityTask(arg0_225)
	local var0_225 = getProxy(TaskProxy)
	local var1_225 = arg0_225:getNDay()
	local var2_225 = pg.TimeMgr.GetInstance():GetServerOverWeek(arg0_225:getStartTime())

	for iter0_225, iter1_225 in ipairs(arg0_225:getConfig("config_data")) do
		local var3_225 = pg.black_friday_battlepass_task_group[iter1_225]

		if var3_225 and var2_225 >= var3_225.group_mask then
			if underscore.any(underscore.flatten(var3_225.task_group), function(arg0_226)
				return var0_225:getTaskVO(arg0_226) == nil
			end) then
				pg.m02:sendNotification(GAME.CRUSING_CMD_HEI5, {
					cmd = 1,
					activity_id = arg0_225.id
				})

				return true
			end
		elseif not var3_225 then
			warning("black_friday_battlepass_task_group表中不存在 id = " .. iter1_225)
		end
	end

	return false
end

function setShipCardFrame(arg0_227, arg1_227, arg2_227)
	arg0_227.localScale = Vector3.one
	arg0_227.anchorMin = Vector2.zero
	arg0_227.anchorMax = Vector2.one

	local var0_227 = arg2_227 or arg1_227

	GetImageSpriteFromAtlasAsync("shipframe", var0_227, arg0_227)

	local var1_227 = pg.frame_resource[var0_227]

	if var1_227 then
		local var2_227 = var1_227.param

		arg0_227.offsetMin = Vector2(var2_227[1], var2_227[2])
		arg0_227.offsetMax = Vector2(var2_227[3], var2_227[4])
	else
		arg0_227.offsetMin = Vector2.zero
		arg0_227.offsetMax = Vector2.zero
	end
end

function setRectShipCardFrame(arg0_228, arg1_228, arg2_228)
	arg0_228.localScale = Vector3.one
	arg0_228.anchorMin = Vector2.zero
	arg0_228.anchorMax = Vector2.one

	setImageSprite(arg0_228, GetSpriteFromAtlas("shipframeb", "b" .. (arg2_228 or arg1_228)))

	local var0_228 = "b" .. (arg2_228 or arg1_228)
	local var1_228 = pg.frame_resource[var0_228]

	if var1_228 then
		local var2_228 = var1_228.param

		arg0_228.offsetMin = Vector2(var2_228[1], var2_228[2])
		arg0_228.offsetMax = Vector2(var2_228[3], var2_228[4])
	else
		arg0_228.offsetMin = Vector2.zero
		arg0_228.offsetMax = Vector2.zero
	end
end

function setFrameEffect(arg0_229, arg1_229)
	if arg1_229 then
		local var0_229 = arg1_229 .. "(Clone)"
		local var1_229 = false

		eachChild(arg0_229, function(arg0_230)
			setActive(arg0_230, arg0_230.name == var0_229)

			var1_229 = var1_229 or arg0_230.name == var0_229
		end)

		if not var1_229 then
			LoadAndInstantiateAsync("effect", arg1_229, function(arg0_231)
				if IsNil(arg0_229) or findTF(arg0_229, var0_229) then
					Object.Destroy(arg0_231)
				else
					setParent(arg0_231, arg0_229)
					setActive(arg0_231, true)
				end
			end)
		end
	end

	setActive(arg0_229, arg1_229)
end

function setProposeMarkIcon(arg0_232, arg1_232)
	local var0_232 = arg0_232:Find("proposeShipCard(Clone)")
	local var1_232 = arg1_232.propose and not arg1_232:ShowPropose()

	if var0_232 then
		setActive(var0_232, var1_232)
	elseif var1_232 then
		pg.PoolMgr.GetInstance():GetUI("proposeShipCard", true, function(arg0_233)
			if IsNil(arg0_232) or arg0_232:Find("proposeShipCard(Clone)") then
				pg.PoolMgr.GetInstance():ReturnUI("proposeShipCard", arg0_233)
			else
				setParent(arg0_233, arg0_232, false)
			end
		end)
	end
end

function flushShipCard(arg0_234, arg1_234)
	local var0_234 = arg1_234:rarity2bgPrint()
	local var1_234 = findTF(arg0_234, "content/bg")

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var0_234, "", var1_234)

	local var2_234 = findTF(arg0_234, "content/ship_icon")
	local var3_234 = arg1_234 and {
		"shipYardIcon/" .. arg1_234:getPainting(),
		arg1_234:getPainting()
	} or {
		"shipYardIcon/unknown",
		""
	}

	GetImageSpriteFromAtlasAsync(var3_234[1], var3_234[2], var2_234)

	local var4_234 = arg1_234:getShipType()
	local var5_234 = findTF(arg0_234, "content/info/top/type")

	GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var4_234), var5_234)
	setText(findTF(arg0_234, "content/dockyard/lv/Text"), defaultValue(arg1_234.level, 1))

	local var6_234 = arg1_234:getStar()
	local var7_234 = arg1_234:getMaxStar()
	local var8_234 = findTF(arg0_234, "content/front/stars")

	setActive(var8_234, true)

	local var9_234 = findTF(var8_234, "star_tpl")
	local var10_234 = var8_234.childCount

	for iter0_234 = 1, Ship.CONFIG_MAX_STAR do
		local var11_234 = var10_234 < iter0_234 and cloneTplTo(var9_234, var8_234) or var8_234:GetChild(iter0_234 - 1)

		setActive(var11_234, iter0_234 <= var7_234)
		triggerToggle(var11_234, iter0_234 <= var6_234)
	end

	local var12_234 = findTF(arg0_234, "content/front/frame")
	local var13_234, var14_234 = arg1_234:GetFrameAndEffect()

	setShipCardFrame(var12_234, var0_234, var13_234)
	setFrameEffect(findTF(arg0_234, "content/front/bg_other"), var14_234)
	setProposeMarkIcon(arg0_234:Find("content/dockyard/propose"), arg1_234)
end

function TweenItemAlphaAndWhite(arg0_235)
	LeanTween.cancel(arg0_235)

	local var0_235 = GetOrAddComponent(arg0_235, "CanvasGroup")

	var0_235.alpha = 0

	LeanTween.alphaCanvas(var0_235, 1, 0.2):setUseEstimatedTime(true)

	local var1_235 = findTF(arg0_235.transform, "white_mask")

	if var1_235 then
		setActive(var1_235, false)
	end
end

function ClearTweenItemAlphaAndWhite(arg0_236)
	LeanTween.cancel(arg0_236)

	GetOrAddComponent(arg0_236, "CanvasGroup").alpha = 0
end

function getGroupOwnSkins(arg0_237)
	local var0_237 = {}
	local var1_237 = getProxy(ShipSkinProxy):getSkinList()
	local var2_237 = getProxy(CollectionProxy):getShipGroup(arg0_237)

	if var2_237 then
		local var3_237 = ShipGroup.getSkinList(arg0_237)

		for iter0_237, iter1_237 in ipairs(var3_237) do
			if iter1_237.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var1_237, iter1_237.id) or iter1_237.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var2_237.trans or iter1_237.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var2_237.married == 1 then
				var0_237[iter1_237.id] = true
			end
		end
	end

	return var0_237
end

function split(arg0_238, arg1_238)
	local var0_238 = {}

	if not arg0_238 then
		return nil
	end

	local var1_238 = #arg0_238
	local var2_238 = 1

	while var2_238 <= var1_238 do
		local var3_238 = string.find(arg0_238, arg1_238, var2_238)

		if var3_238 == nil then
			table.insert(var0_238, string.sub(arg0_238, var2_238, var1_238))

			break
		end

		table.insert(var0_238, string.sub(arg0_238, var2_238, var3_238 - 1))

		if var3_238 == var1_238 then
			table.insert(var0_238, "")

			break
		end

		var2_238 = var3_238 + 1
	end

	return var0_238
end

function NumberToChinese(arg0_239, arg1_239)
	local var0_239 = ""
	local var1_239 = #arg0_239

	for iter0_239 = 1, var1_239 do
		local var2_239 = string.sub(arg0_239, iter0_239, iter0_239)

		if var2_239 ~= "0" or var2_239 == "0" and not arg1_239 then
			if arg1_239 then
				if var1_239 >= 2 then
					if iter0_239 == 1 then
						if var2_239 == "1" then
							var0_239 = i18n("number_" .. 10)
						else
							var0_239 = i18n("number_" .. var2_239) .. i18n("number_" .. 10)
						end
					else
						var0_239 = var0_239 .. i18n("number_" .. var2_239)
					end
				else
					var0_239 = var0_239 .. i18n("number_" .. var2_239)
				end
			else
				var0_239 = var0_239 .. i18n("number_" .. var2_239)
			end
		end
	end

	return var0_239
end

function getActivityTask(arg0_240, arg1_240)
	local var0_240 = getProxy(TaskProxy)
	local var1_240 = arg0_240:getConfig("config_data")
	local var2_240 = arg0_240:getNDay(arg0_240.data1)
	local var3_240
	local var4_240
	local var5_240

	for iter0_240 = math.max(arg0_240.data3, 1), math.min(var2_240, #var1_240) do
		local var6_240 = _.flatten({
			var1_240[iter0_240]
		})

		for iter1_240, iter2_240 in ipairs(var6_240) do
			local var7_240 = var0_240:getTaskById(iter2_240)

			if var7_240 then
				return var7_240.id, var7_240
			end

			if var4_240 then
				var5_240 = var0_240:getFinishTaskById(iter2_240)

				if var5_240 then
					var4_240 = var5_240
				elseif arg1_240 then
					return iter2_240
				else
					return var4_240.id, var4_240
				end
			else
				var4_240 = var0_240:getFinishTaskById(iter2_240)
				var5_240 = var5_240 or iter2_240
			end
		end
	end

	if var4_240 then
		return var4_240.id, var4_240
	else
		return var5_240
	end
end

function setImageFromImage(arg0_241, arg1_241, arg2_241)
	local var0_241 = GetComponent(arg0_241, "Image")

	var0_241.sprite = GetComponent(arg1_241, "Image").sprite

	if arg2_241 then
		var0_241:SetNativeSize()
	end
end

function skinTimeStamp(arg0_242)
	local var0_242, var1_242, var2_242, var3_242 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_242)

	if var0_242 >= 1 then
		return i18n("limit_skin_time_day", var0_242)
	elseif var0_242 <= 0 and var1_242 > 0 then
		return i18n("limit_skin_time_day_min", var1_242, var2_242)
	elseif var0_242 <= 0 and var1_242 <= 0 and (var2_242 > 0 or var3_242 > 0) then
		return i18n("limit_skin_time_min", math.max(var2_242, 1))
	elseif var0_242 <= 0 and var1_242 <= 0 and var2_242 <= 0 and var3_242 <= 0 then
		return i18n("limit_skin_time_overtime")
	end
end

function skinCommdityTimeStamp(arg0_243)
	local var0_243 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_243 = math.max(arg0_243 - var0_243, 0)
	local var2_243 = math.floor(var1_243 / 86400)

	if var2_243 > 0 then
		return i18n("time_remaining_tip") .. var2_243 .. i18n("word_date")
	else
		local var3_243 = math.floor(var1_243 / 3600)

		if var3_243 > 0 then
			return i18n("time_remaining_tip") .. var3_243 .. i18n("word_hour")
		else
			local var4_243 = math.floor(var1_243 / 60)

			if var4_243 > 0 then
				return i18n("time_remaining_tip") .. var4_243 .. i18n("word_minute")
			else
				return i18n("time_remaining_tip") .. var1_243 .. i18n("word_second")
			end
		end
	end
end

function InstagramTimeStamp(arg0_244)
	local var0_244 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_244
	local var1_244 = var0_244 / 86400

	if var1_244 > 1 then
		return i18n("ins_word_day", math.floor(var1_244))
	else
		local var2_244 = var0_244 / 3600

		if var2_244 > 1 then
			return i18n("ins_word_hour", math.floor(var2_244))
		else
			local var3_244 = var0_244 / 60

			if var3_244 > 1 then
				return i18n("ins_word_minu", math.floor(var3_244))
			else
				return i18n("ins_word_minu", 1)
			end
		end
	end
end

function InstagramReplyTimeStamp(arg0_245)
	local var0_245 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_245
	local var1_245 = var0_245 / 86400

	if var1_245 > 1 then
		return i18n1(math.floor(var1_245) .. "d")
	else
		local var2_245 = var0_245 / 3600

		if var2_245 > 1 then
			return i18n1(math.floor(var2_245) .. "h")
		else
			local var3_245 = var0_245 / 60

			if var3_245 > 1 then
				return i18n1(math.floor(var3_245) .. "min")
			else
				return i18n1("1min")
			end
		end
	end
end

function attireTimeStamp(arg0_246)
	local var0_246, var1_246, var2_246, var3_246 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_246)

	if var0_246 <= 0 and var1_246 <= 0 and var2_246 <= 0 and var3_246 <= 0 then
		return i18n("limit_skin_time_overtime")
	else
		return i18n("attire_time_stamp", var0_246, var1_246, var2_246)
	end
end

function checkExist(arg0_247, ...)
	local var0_247 = {
		...
	}

	for iter0_247, iter1_247 in ipairs(var0_247) do
		if arg0_247 == nil then
			break
		end

		assert(type(arg0_247) == "table", "type error : intermediate target should be table")
		assert(type(iter1_247) == "table", "type error : param should be table")

		if type(arg0_247[iter1_247[1]]) == "function" then
			arg0_247 = arg0_247[iter1_247[1]](arg0_247, unpack(iter1_247[2] or {}))
		else
			arg0_247 = arg0_247[iter1_247[1]]
		end
	end

	return arg0_247
end

function AcessWithinNull(arg0_248, arg1_248)
	if arg0_248 == nil then
		return
	end

	assert(type(arg0_248) == "table")

	return arg0_248[arg1_248]
end

function showRepairMsgbox()
	local var0_249 = {
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var1_249 = {
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var2_249 = {
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
			var2_249,
			var1_249,
			var0_249
		}
	})
end

function resourceVerify(arg0_253, arg1_253)
	if CSharpVersion > 35 then
		BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()

		return
	end

	local var0_253 = Application.persistentDataPath .. "/hashes.csv"
	local var1_253
	local var2_253 = PathMgr.ReadAllLines(var0_253)
	local var3_253 = {}

	if arg0_253 then
		setActive(arg0_253, true)
	else
		pg.UIMgr.GetInstance():LoadingOn()
	end

	local function var4_253()
		if arg0_253 then
			setActive(arg0_253, false)
		else
			pg.UIMgr.GetInstance():LoadingOff()
		end

		print(var1_253)

		if var1_253 then
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

	local var5_253 = var2_253.Length
	local var6_253

	local function var7_253(arg0_256)
		if arg0_256 < 0 then
			var4_253()

			return
		end

		if arg1_253 then
			setSlider(arg1_253, 0, var5_253, var5_253 - arg0_256)
		end

		local var0_256 = string.split(var2_253[arg0_256], ",")
		local var1_256 = var0_256[1]
		local var2_256 = var0_256[3]
		local var3_256 = PathMgr.getAssetBundle(var1_256)

		if PathMgr.FileExists(var3_256) then
			local var4_256 = PathMgr.ReadAllBytes(PathMgr.getAssetBundle(var1_256))

			if var2_256 == HashUtil.CalcMD5(var4_256) then
				onNextTick(function()
					var7_253(arg0_256 - 1)
				end)

				return
			end
		end

		var1_253 = var1_256

		var4_253()
	end

	var7_253(var5_253 - 1)
end

function splitByWordEN(arg0_258, arg1_258)
	local var0_258 = string.split(arg0_258, " ")
	local var1_258 = ""
	local var2_258 = ""
	local var3_258 = arg1_258:GetComponent(typeof(RectTransform))
	local var4_258 = arg1_258:GetComponent(typeof(Text))
	local var5_258 = var3_258.rect.width

	for iter0_258, iter1_258 in ipairs(var0_258) do
		local var6_258 = var2_258

		var2_258 = var2_258 == "" and iter1_258 or var2_258 .. " " .. iter1_258

		setText(arg1_258, var2_258)

		if var5_258 < var4_258.preferredWidth then
			var1_258 = var1_258 == "" and var6_258 or var1_258 .. "\n" .. var6_258
			var2_258 = iter1_258
		end

		if iter0_258 >= #var0_258 then
			var1_258 = var1_258 == "" and var2_258 or var1_258 .. "\n" .. var2_258
		end
	end

	return var1_258
end

function checkBirthFormat(arg0_259)
	if #arg0_259 ~= 8 then
		return false
	end

	local var0_259 = 0
	local var1_259 = #arg0_259

	while var0_259 < var1_259 do
		local var2_259 = string.byte(arg0_259, var0_259 + 1)

		if var2_259 < 48 or var2_259 > 57 then
			return false
		end

		var0_259 = var0_259 + 1
	end

	return true
end

function isHalfBodyLive2D(arg0_260)
	local var0_260 = {
		"biaoqiang",
		"z23",
		"lafei",
		"lingbo",
		"mingshi",
		"xuefeng"
	}

	return _.any(var0_260, function(arg0_261)
		return arg0_261 == arg0_260
	end)
end

function GetServerState(arg0_262)
	local var0_262 = -1
	local var1_262 = 0
	local var2_262 = 1
	local var3_262 = 2
	local var4_262 = NetConst.GetServerStateUrl()

	if PLATFORM_CODE == PLATFORM_CH then
		var4_262 = string.gsub(var4_262, "https", "http")
	end

	VersionMgr.Inst:WebRequest(var4_262, function(arg0_263, arg1_263)
		local var0_263 = true
		local var1_263 = false

		for iter0_263 in string.gmatch(arg1_263, "\"state\":%d") do
			if iter0_263 ~= "\"state\":1" then
				var0_263 = false
			end

			var1_263 = true
		end

		if not var1_263 then
			var0_263 = false
		end

		if arg0_262 ~= nil then
			arg0_262(var0_263 and var2_262 or var1_262)
		end
	end)
end

function setScrollText(arg0_264, arg1_264)
	GetOrAddComponent(arg0_264, "ScrollText"):SetText(arg1_264)
end

function changeToScrollText(arg0_265, arg1_265)
	local var0_265 = GetComponent(arg0_265, typeof(Text))

	assert(var0_265, "without component<Text>")

	local var1_265 = arg0_265:Find("subText")

	if not var1_265 then
		var1_265 = cloneTplTo(arg0_265, arg0_265, "subText")

		eachChild(arg0_265, function(arg0_266)
			setActive(arg0_266, arg0_266 == var1_265)
		end)

		arg0_265:GetComponent(typeof(Text)).enabled = false
	end

	setScrollText(var1_265, arg1_265)
end

function setScrollTextWithSize(arg0_267, arg1_267, arg2_267, arg3_267)
	local var0_267 = arg3_267 < GetPerceptualSize(arg2_267)

	setActive(arg1_267, var0_267)
	setActive(arg0_267, not var0_267)

	if var0_267 then
		setScrollText(arg1_267, arg2_267)
	else
		setText(arg0_267, arg2_267)
	end
end

local var18_0
local var19_0
local var20_0
local var21_0

local function var22_0(arg0_268, arg1_268, arg2_268)
	local var0_268 = arg0_268:Find("base")
	local var1_268, var2_268, var3_268 = Equipment.GetInfoTrans(arg1_268, arg2_268)

	if arg1_268.nextValue then
		local var4_268 = {
			name = arg1_268.name,
			type = arg1_268.type,
			value = arg1_268.nextValue
		}
		local var5_268, var6_268 = Equipment.GetInfoTrans(var4_268, arg2_268)

		var2_268 = var2_268 .. setColorStr("   >   " .. var6_268, COLOR_GREEN)
	end

	setText(var0_268:Find("name"), var1_268)

	if var3_268 then
		local var7_268 = "<color=#afff72>(+" .. ys.Battle.BattleConst.UltimateBonus.AuxBoostValue * 100 .. "%)</color>"

		setText(var0_268:Find("value"), var2_268 .. var7_268)
	else
		setText(var0_268:Find("value"), var2_268)
	end

	setActive(var0_268:Find("value/up"), arg1_268.compare and arg1_268.compare > 0)
	setActive(var0_268:Find("value/down"), arg1_268.compare and arg1_268.compare < 0)
	triggerToggle(var0_268, arg1_268.lock_open)

	if not arg1_268.lock_open and arg1_268.sub and #arg1_268.sub > 0 then
		GetComponent(var0_268, typeof(Toggle)).enabled = true
	else
		setActive(var0_268:Find("name/close"), false)
		setActive(var0_268:Find("name/open"), false)

		GetComponent(var0_268, typeof(Toggle)).enabled = false
	end
end

local function var23_0(arg0_269, arg1_269, arg2_269, arg3_269)
	var22_0(arg0_269, arg2_269, arg3_269)

	if not arg2_269.sub or #arg2_269.sub == 0 then
		return
	end

	var20_0(arg0_269:Find("subs"), arg1_269, arg2_269.sub, arg3_269)
end

function var20_0(arg0_270, arg1_270, arg2_270, arg3_270)
	removeAllChildren(arg0_270)
	var21_0(arg0_270, arg1_270, arg2_270, arg3_270)
end

function var21_0(arg0_271, arg1_271, arg2_271, arg3_271)
	for iter0_271, iter1_271 in ipairs(arg2_271) do
		local var0_271 = cloneTplTo(arg1_271, arg0_271)

		var23_0(var0_271, arg1_271, iter1_271, arg3_271)
	end
end

function updateEquipInfo(arg0_272, arg1_272, arg2_272, arg3_272)
	local var0_272 = arg0_272:Find("attr_tpl")

	var20_0(arg0_272:Find("attrs"), var0_272, arg1_272.attrs, arg3_272)
	setActive(arg0_272:Find("skill"), arg2_272)

	if arg2_272 then
		var23_0(arg0_272:Find("skill/attr"), var0_272, {
			name = i18n("skill"),
			value = setColorStr(arg2_272.name, "#FFDE00FF")
		}, arg3_272)
		setText(arg0_272:Find("skill/value/Text"), getSkillDescGet(arg2_272.id))
	end

	setActive(arg0_272:Find("weapon"), #arg1_272.weapon.sub > 0)

	if #arg1_272.weapon.sub > 0 then
		var20_0(arg0_272:Find("weapon"), var0_272, {
			arg1_272.weapon
		}, arg3_272)
	end

	setActive(arg0_272:Find("equip_info"), #arg1_272.equipInfo.sub > 0)

	if #arg1_272.equipInfo.sub > 0 then
		var20_0(arg0_272:Find("equip_info"), var0_272, {
			arg1_272.equipInfo
		}, arg3_272)
	end

	var23_0(arg0_272:Find("part/attr"), var0_272, {
		name = i18n("equip_info_23")
	}, arg3_272)

	local var1_272 = arg0_272:Find("part/value")
	local var2_272 = var1_272:Find("label")
	local var3_272 = {}
	local var4_272 = {}

	if #arg1_272.part[1] == 0 and #arg1_272.part[2] == 0 then
		setmetatable(var3_272, {
			__index = function(arg0_273, arg1_273)
				return true
			end
		})
		setmetatable(var4_272, {
			__index = function(arg0_274, arg1_274)
				return true
			end
		})
	else
		for iter0_272, iter1_272 in ipairs(arg1_272.part[1]) do
			var3_272[iter1_272] = true
		end

		for iter2_272, iter3_272 in ipairs(arg1_272.part[2]) do
			var4_272[iter3_272] = true
		end
	end

	local var5_272 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var3_272, var4_272)

	UIItemList.StaticAlign(var1_272, var2_272, #var5_272, function(arg0_275, arg1_275, arg2_275)
		arg1_275 = arg1_275 + 1

		if arg0_275 == UIItemList.EventUpdate then
			local var0_275 = var5_272[arg1_275]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0_275), arg2_275)
			setActive(arg2_275:Find("main"), var3_272[var0_275] and not var4_272[var0_275])
			setActive(arg2_275:Find("sub"), var4_272[var0_275] and not var3_272[var0_275])
			setImageAlpha(arg2_275, not var3_272[var0_275] and not var4_272[var0_275] and 0.3 or 1)
		end
	end)
end

function updateEquipUpgradeInfo(arg0_276, arg1_276, arg2_276)
	local var0_276 = arg0_276:Find("attr_tpl")

	var20_0(arg0_276:Find("attrs"), var0_276, arg1_276.attrs, arg2_276)
	setActive(arg0_276:Find("weapon"), #arg1_276.weapon.sub > 0)

	if #arg1_276.weapon.sub > 0 then
		var20_0(arg0_276:Find("weapon"), var0_276, {
			arg1_276.weapon
		}, arg2_276)
	end

	setActive(arg0_276:Find("equip_info"), #arg1_276.equipInfo.sub > 0)

	if #arg1_276.equipInfo.sub > 0 then
		var20_0(arg0_276:Find("equip_info"), var0_276, {
			arg1_276.equipInfo
		}, arg2_276)
	end
end

function SetCanvasOverrideSorting(arg0_277, arg1_277)
	local var0_277 = arg0_277.parent

	arg0_277:SetParent(pg.LayerWeightMgr.GetInstance().uiOrigin, false)

	if isActive(arg0_277) then
		GetOrAddComponent(arg0_277, typeof(Canvas)).overrideSorting = arg1_277
	else
		setActive(arg0_277, true)

		GetOrAddComponent(arg0_277, typeof(Canvas)).overrideSorting = arg1_277

		setActive(arg0_277, false)
	end

	arg0_277:SetParent(var0_277, false)
end

function SetTFLayerOrder(arg0_278, arg1_278)
	local var0_278 = {}
	local var1_278 = arg0_278:GetComponentsInChildren(typeof(Renderer), true):ToTable()

	table.insertto(var0_278, var1_278)

	local var2_278 = arg0_278:GetComponentsInChildren(typeof(Canvas), true):ToTable()

	table.insertto(var0_278, var2_278)

	for iter0_278, iter1_278 in ipairs(var0_278) do
		iter1_278.sortingOrder = arg1_278
	end
end

function createNewGameObject(arg0_279, arg1_279)
	local var0_279 = GameObject.New()

	if arg0_279 then
		var0_279.name = "model"
	end

	var0_279.layer = arg1_279 or Layer.UI

	return GetOrAddComponent(var0_279, "RectTransform")
end

function CreateShell(arg0_280)
	if type(arg0_280) ~= "table" and type(arg0_280) ~= "userdata" then
		return arg0_280
	end

	local var0_280 = setmetatable({
		__index = arg0_280
	}, arg0_280)

	return setmetatable({}, var0_280)
end

function CameraFittingSettin(arg0_281)
	local var0_281 = GetComponent(arg0_281, typeof(Camera))
	local var1_281 = 1.77777777777778
	local var2_281 = Screen.width / Screen.height

	if var2_281 < var1_281 then
		local var3_281 = var2_281 / var1_281

		var0_281.rect = var0_0.Rect.New(0, (1 - var3_281) / 2, 1, var3_281)
	end
end

function SwitchSpecialChar(arg0_282, arg1_282)
	if PLATFORM_CODE ~= PLATFORM_US then
		arg0_282 = arg0_282:gsub(" ", " ")
		arg0_282 = arg0_282:gsub("\t", "    ")
	end

	if not arg1_282 then
		arg0_282 = arg0_282:gsub("\n", " ")
	end

	return arg0_282
end

function AfterCheck(arg0_283, arg1_283)
	local var0_283 = {}

	for iter0_283, iter1_283 in ipairs(arg0_283) do
		var0_283[iter0_283] = iter1_283[1]()
	end

	arg1_283()

	for iter2_283, iter3_283 in ipairs(arg0_283) do
		if var0_283[iter2_283] ~= iter3_283[1]() then
			iter3_283[2]()
		end

		var0_283[iter2_283] = iter3_283[1]()
	end
end

function CompareFuncs(arg0_284, arg1_284)
	local var0_284 = {}

	local function var1_284(arg0_285, arg1_285)
		var0_284[arg0_285] = var0_284[arg0_285] or {}
		var0_284[arg0_285][arg1_285] = var0_284[arg0_285][arg1_285] or arg0_284[arg0_285](arg1_285)

		return var0_284[arg0_285][arg1_285]
	end

	return function(arg0_286, arg1_286)
		local var0_286 = 1

		while var0_286 <= #arg0_284 do
			local var1_286 = var1_284(var0_286, arg0_286)
			local var2_286 = var1_284(var0_286, arg1_286)

			if var1_286 == var2_286 then
				var0_286 = var0_286 + 1
			else
				return var1_286 < var2_286
			end
		end

		return tobool(arg1_284)
	end
end

function DropResultIntegration(arg0_287)
	local var0_287 = {}
	local var1_287 = 1

	while var1_287 <= #arg0_287 do
		local var2_287 = arg0_287[var1_287].type
		local var3_287 = arg0_287[var1_287].id

		var0_287[var2_287] = var0_287[var2_287] or {}

		if var0_287[var2_287][var3_287] then
			local var4_287 = arg0_287[var0_287[var2_287][var3_287]]
			local var5_287 = table.remove(arg0_287, var1_287)

			var4_287.count = var4_287.count + var5_287.count
		else
			var0_287[var2_287][var3_287] = var1_287
			var1_287 = var1_287 + 1
		end
	end

	local var6_287 = {
		function(arg0_288)
			local var0_288 = arg0_288.type
			local var1_288 = arg0_288.id

			if var0_288 == DROP_TYPE_SHIP then
				return 1
			elseif var0_288 == DROP_TYPE_RESOURCE then
				if var1_288 == 1 then
					return 2
				else
					return 3
				end
			elseif var0_288 == DROP_TYPE_ITEM then
				if var1_288 == 59010 then
					return 4
				elseif var1_288 == 59900 then
					return 5
				else
					local var2_288 = Item.getConfigData(var1_288)
					local var3_288 = var2_288 and var2_288.type or 0

					if var3_288 == 9 then
						return 6
					elseif var3_288 == 5 then
						return 7
					elseif var3_288 == 4 then
						return 8
					elseif var3_288 == 7 then
						return 9
					end
				end
			elseif var0_288 == DROP_TYPE_VITEM and var1_288 == 59011 then
				return 4
			end

			return 100
		end,
		function(arg0_289)
			local var0_289

			if arg0_289.type == DROP_TYPE_SHIP then
				var0_289 = pg.ship_data_statistics[arg0_289.id]
			elseif arg0_289.type == DROP_TYPE_ITEM then
				var0_289 = Item.getConfigData(arg0_289.id)
			end

			return (var0_289 and var0_289.rarity or 0) * -1
		end,
		function(arg0_290)
			return arg0_290.id
		end
	}

	table.sort(arg0_287, CompareFuncs(var6_287))
end

local function var24_0()
	local var0_291 = {}
	local var1_291 = pg.TimeMgr.GetInstance():GetServerTime()

	for iter0_291, iter1_291 in ipairs(pg.login.all) do
		if pg.login[iter1_291].date ~= "stop" then
			local var2_291, var3_291 = parseTimeConfig(pg.login[iter1_291].date)

			assert(not var3_291)

			if pg.TimeMgr.GetInstance():inTime(var2_291, var1_291) then
				table.insert(var0_291, iter1_291)
			end
		end
	end

	local function var4_291(arg0_292)
		local var0_292 = pg.login[arg0_292].effective_channel

		if type(var0_292) == "table" then
			return var0_292
		end

		if not var0_292 or var0_292 <= 0 then
			return {}
		end

		return {
			var0_292
		}
	end

	local var5_291 = {}

	if PLATFORM_CODE == PLATFORM_CH then
		local var6_291 = pg.SdkMgr.GetInstance():GetChannelUIDIncludeHarmony()

		for iter2_291, iter3_291 in ipairs(var0_291) do
			local var7_291 = var4_291(iter3_291)

			if _.any(var7_291, function(arg0_293)
				return arg0_293 == var6_291
			end) or #var7_291 == 0 then
				table.insert(var5_291, iter3_291)
			end
		end
	else
		for iter4_291, iter5_291 in ipairs(var0_291) do
			if #var4_291(iter5_291) == 0 then
				table.insert(var5_291, iter5_291)
			end
		end
	end

	if #var5_291 <= 0 then
		return 1
	end

	if #var5_291 == 1 then
		return var5_291[1]
	end

	table.sort(var5_291, function(arg0_294, arg1_294)
		local var0_294 = var4_291(arg0_294)
		local var1_294 = var4_291(arg1_294)

		if #var0_294 == #var1_294 then
			return arg1_294 < arg0_294
		else
			return #var0_294 > #var1_294
		end
	end)

	return var5_291[1]
end

function getLoginConfig()
	if LOGIN_HX and PlayerProxy.GetDeviceMaxPlayerLevel() <= pg.gameset.LOGIN_HX_LV.key_value then
		return false, "login", "", false, ""
	end

	local var0_295 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_295 = var24_0()
	local var2_295 = pg.login[var1_295].login_static

	var2_295 = var2_295 ~= "" and var2_295 or "login"

	local var3_295 = pg.login[var1_295].login_cri
	local var4_295 = var3_295 ~= "" and true or false
	local var5_295 = pg.login[var1_295].op_play == 1 and true or false
	local var6_295 = noEmptyStr(pg.login[var1_295].op_time)
	local var7_295 = ""

	if not var6_295 or var6_295 == "stop" then
		var5_295 = false
	else
		local var8_295, var9_295 = parseTimeConfig(pg.login[var1_295].date)

		assert(not var9_295)

		var7_295 = table.concat(var8_295[2][1])

		if not pg.TimeMgr.GetInstance():inTime(var8_295, var0_295) then
			var5_295 = false
		end
	end

	return var4_295, var4_295 and var3_295 or var2_295, pg.login[var1_295].bgm, var5_295, var7_295
end

function setIntimacyIcon(arg0_296, arg1_296, arg2_296)
	local var0_296 = {}
	local var1_296

	seriesAsync({
		function(arg0_297)
			if arg0_296.childCount > 0 then
				var1_296 = arg0_296:GetChild(0)

				arg0_297()
			else
				LoadAndInstantiateAsync("template", "intimacytpl", function(arg0_298)
					if arg0_296.childCount == 0 then
						var1_296 = tf(arg0_298)

						setParent(var1_296, arg0_296)
						arg0_297()
					end
				end)
			end
		end,
		function(arg0_299)
			setImageAlpha(var1_296, arg2_296 and 0 or 1)
			eachChild(var1_296, function(arg0_300)
				setActive(arg0_300, false)
			end)

			if arg2_296 then
				local var0_299 = var1_296:Find(arg2_296 .. "(Clone)")

				if not var0_299 then
					LoadAndInstantiateAsync("ui", arg2_296, function(arg0_301)
						setParent(arg0_301, var1_296)
						setActive(arg0_301, true)
					end)
				else
					setActive(var0_299, true)
				end
			elseif arg1_296 then
				setImageSprite(var1_296, GetSpriteFromAtlas("energy", arg1_296), true)
			else
				assert(false, "param error")
			end
		end
	})
end

local var25_0

function nowWorld()
	var25_0 = var25_0 or getProxy(WorldProxy)

	return var25_0 and var25_0.world
end

function removeWorld()
	var25_0.world:Dispose()

	var25_0.world = nil
	var25_0 = nil
end

function switch(arg0_304, arg1_304, arg2_304, ...)
	while type(arg1_304[arg0_304]) ~= "function" do
		if arg1_304[arg0_304] == nil then
			return existCall(arg2_304, ...)
		else
			arg0_304 = arg1_304[arg0_304]
		end
	end

	return arg1_304[arg0_304](...)
end

function parseTimeConfig(arg0_305)
	if type(arg0_305[1]) == "table" then
		return arg0_305[2], arg0_305[1]
	else
		return arg0_305
	end
end

local var26_0 = {
	__add = function(arg0_306, arg1_306)
		return NewPos(arg0_306.x + arg1_306.x, arg0_306.y + arg1_306.y)
	end,
	__sub = function(arg0_307, arg1_307)
		return NewPos(arg0_307.x - arg1_307.x, arg0_307.y - arg1_307.y)
	end,
	__mul = function(arg0_308, arg1_308)
		if type(arg1_308) == "number" then
			return NewPos(arg0_308.x * arg1_308, arg0_308.y * arg1_308)
		else
			return NewPos(arg0_308.x * arg1_308.x, arg0_308.y * arg1_308.y)
		end
	end,
	__eq = function(arg0_309, arg1_309)
		return arg0_309.x == arg1_309.x and arg0_309.y == arg1_309.y
	end,
	__tostring = function(arg0_310)
		return arg0_310.x .. "_" .. arg0_310.y
	end
}

function NewPos(arg0_311, arg1_311)
	assert(arg0_311 and arg1_311)

	local var0_311 = setmetatable({
		x = arg0_311,
		y = arg1_311
	}, var26_0)

	function var0_311.SqrMagnitude(arg0_312)
		return arg0_312.x * arg0_312.x + arg0_312.y * arg0_312.y
	end

	function var0_311.Normalize(arg0_313)
		local var0_313 = arg0_313:SqrMagnitude()

		if var0_313 > 1e-05 then
			return arg0_313 * (1 / math.sqrt(var0_313))
		else
			return NewPos(0, 0)
		end
	end

	return var0_311
end

local var27_0

function Timekeeping()
	warning(Time.realtimeSinceStartup - (var27_0 or Time.realtimeSinceStartup), Time.realtimeSinceStartup)

	var27_0 = Time.realtimeSinceStartup
end

function GetRomanDigit(arg0_315)
	return (string.char(226, 133, 160 + (arg0_315 - 1)))
end

function GetRomanDigitPlus(arg0_316)
	if arg0_316 > 0 and arg0_316 <= 10 then
		return GetRomanDigit(arg0_316)
	else
		return switch(arg0_316, {
			[11] = function()
				return "XI"
			end
		}, function()
			return arg0_316
		end)
	end
end

function quickPlayAnimator(arg0_319, arg1_319)
	arg0_319:GetComponent(typeof(Animator)):Play(arg1_319, -1, 0)
end

function quickCheckAndPlayAnimator(arg0_320, arg1_320)
	local var0_320 = arg0_320:GetComponent(typeof(Animator))

	var0_320.enabled = true

	local var1_320 = Animator.StringToHash(arg1_320)

	if var0_320:HasState(0, var1_320) then
		var0_320:Play(arg1_320, -1, 0)
	end
end

function quickPlayAnimation(arg0_321, arg1_321)
	local var0_321 = arg0_321:GetComponent(typeof(Animation))

	var0_321:Stop()
	var0_321:Play(arg1_321)
end

function getSurveyUrl(arg0_322)
	local var0_322 = pg.survey_data_template[arg0_322]
	local var1_322

	if not IsUnityEditor then
		if PLATFORM_CODE == PLATFORM_CH then
			local var2_322 = getProxy(UserProxy):GetCacheGatewayInServerLogined()

			if var2_322 == PLATFORM_ANDROID then
				if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_BILI then
					var1_322 = var0_322.main_url
				else
					var1_322 = var0_322.uo_url
				end
			elseif var2_322 == PLATFORM_IPHONEPLAYER then
				var1_322 = var0_322.ios_url
			end
		elseif PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_KR then
			var1_322 = var0_322.main_url
		end
	else
		var1_322 = var0_322.main_url
	end

	local var3_322 = getProxy(PlayerProxy):getRawData().id
	local var4_322 = getProxy(UserProxy):getRawData().arg2 or ""
	local var5_322
	local var6_322 = PLATFORM == PLATFORM_ANDROID and 1 or PLATFORM == PLATFORM_IPHONEPLAYER and 2 or 3
	local var7_322 = getProxy(UserProxy):getRawData()
	local var8_322 = getProxy(ServerProxy):getRawData()[var7_322 and var7_322.server or 0]
	local var9_322 = var8_322 and var8_322.id or ""
	local var10_322 = getProxy(PlayerProxy):getRawData().level
	local var11_322 = var3_322 .. "_" .. arg0_322
	local var12_322 = var1_322
	local var13_322 = {
		var3_322,
		var4_322,
		var6_322,
		var9_322,
		var10_322,
		var11_322
	}

	if var12_322 then
		for iter0_322, iter1_322 in ipairs(var13_322) do
			var12_322 = string.gsub(var12_322, "$" .. iter0_322, tostring(iter1_322))
		end
	end

	originalPrint("survey url", tostring(var12_322))

	return var12_322
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

function FilterVarchar(arg0_324)
	assert(type(arg0_324) == "string" or type(arg0_324) == "table")

	if arg0_324 == "" then
		return nil
	end

	return arg0_324
end

function getGameset(arg0_325)
	local var0_325 = pg.gameset[arg0_325]

	assert(var0_325)

	return {
		var0_325.key_value,
		var0_325.description
	}
end

function getDorm3dGameset(arg0_326)
	local var0_326 = pg.dorm3d_set[arg0_326]

	assert(var0_326)

	return {
		var0_326.key_value_int,
		var0_326.key_value_varchar
	}
end

function GetItemsOverflowDic(arg0_327)
	arg0_327 = arg0_327 or {}

	local var0_327 = {
		[DROP_TYPE_ITEM] = {},
		[DROP_TYPE_RESOURCE] = {},
		[DROP_TYPE_EQUIP] = 0,
		[DROP_TYPE_SHIP] = 0,
		[DROP_TYPE_WORLD_ITEM] = 0
	}

	while #arg0_327 > 0 do
		local var1_327 = table.remove(arg0_327)

		switch(var1_327.type, {
			[DROP_TYPE_ITEM] = function()
				if var1_327:getConfig("open_directly") == 1 then
					for iter0_328, iter1_328 in ipairs(var1_327:getConfig("display_icon")) do
						local var0_328 = Drop.Create(iter1_328)

						var0_328.count = var0_328.count * var1_327.count

						table.insert(arg0_327, var0_328)
					end
				elseif var1_327:getSubClass():IsShipExpType() then
					var0_327[var1_327.type][var1_327.id] = defaultValue(var0_327[var1_327.type][var1_327.id], 0) + var1_327.count
				end
			end,
			[DROP_TYPE_RESOURCE] = function()
				var0_327[var1_327.type][var1_327.id] = defaultValue(var0_327[var1_327.type][var1_327.id], 0) + var1_327.count
			end,
			[DROP_TYPE_EQUIP] = function()
				var0_327[var1_327.type] = var0_327[var1_327.type] + var1_327.count
			end,
			[DROP_TYPE_SHIP] = function()
				var0_327[var1_327.type] = var0_327[var1_327.type] + var1_327.count
			end,
			[DROP_TYPE_WORLD_ITEM] = function()
				var0_327[var1_327.type] = var0_327[var1_327.type] + var1_327.count
			end
		})
	end

	return var0_327
end

function CheckOverflow(arg0_333, arg1_333)
	local var0_333 = {}
	local var1_333 = arg0_333[DROP_TYPE_RESOURCE][PlayerConst.ResGold] or 0
	local var2_333 = arg0_333[DROP_TYPE_RESOURCE][PlayerConst.ResOil] or 0
	local var3_333 = arg0_333[DROP_TYPE_EQUIP]
	local var4_333 = arg0_333[DROP_TYPE_SHIP]
	local var5_333 = getProxy(PlayerProxy):getRawData()
	local var6_333 = false

	if arg1_333 then
		local var7_333 = var5_333:OverStore(PlayerConst.ResStoreGold, var1_333)
		local var8_333 = var5_333:OverStore(PlayerConst.ResStoreOil, var2_333)

		if var7_333 > 0 or var8_333 > 0 then
			var0_333.isStoreOverflow = {
				var7_333,
				var8_333
			}
		end
	else
		if var1_333 > 0 and var5_333:GoldMax(var1_333) then
			return false, "gold"
		end

		if var2_333 > 0 and var5_333:OilMax(var2_333) then
			return false, "oil"
		end
	end

	var0_333.isExpBookOverflow = {}

	for iter0_333, iter1_333 in pairs(arg0_333[DROP_TYPE_ITEM]) do
		local var9_333 = Item.getConfigData(iter0_333)

		if getProxy(BagProxy):getItemCountById(iter0_333) + iter1_333 > var9_333.max_num then
			table.insert(var0_333.isExpBookOverflow, iter0_333)
		end
	end

	local var10_333 = getProxy(EquipmentProxy):getCapacity()

	if var3_333 > 0 and var10_333 >= var5_333:getMaxEquipmentBag() then
		return false, "equip"
	end

	local var11_333 = getProxy(BayProxy):getShipCount()

	if var4_333 > 0 and var4_333 + var11_333 > var5_333:getMaxShipBag() then
		return false, "ship"
	end

	return true, var0_333
end

function CheckEquipLimit(arg0_334)
	local var0_334 = {}

	for iter0_334, iter1_334 in pairs(arg0_334) do
		if iter1_334.type == DROP_TYPE_EQUIP then
			local var1_334 = iter1_334:getConfig("group")

			if pg.equip_data_limit[var1_334] then
				var0_334[var1_334] = defaultValue(var0_334[var1_334], 0) + iter1_334.count
			end
		end
	end

	local var2_334 = {}

	for iter2_334, iter3_334 in pairs(var0_334) do
		local var3_334 = pg.equip_data_limit[iter2_334]
		local var4_334 = pg.equip_data_template.get_id_list_by_group[iter2_334]
		local var5_334 = underscore.reduce(var4_334, 0, function(arg0_335, arg1_335)
			local var0_335 = getProxy(EquipmentProxy):getEquipmentById(arg1_335)

			return arg0_335 + (var0_335 and var0_335.count or 0) + getProxy(BayProxy):GetEquipCountInShips(arg1_335)
		end)

		if var5_334 + iter3_334 > var3_334.max then
			table.insert(var2_334, {
				iter2_334,
				var5_334 + iter3_334 - var3_334.max
			})
		end
	end

	if #var2_334 == 0 then
		return false
	end

	return var2_334
end

function CheckShipExpOverflow(arg0_336)
	local var0_336 = getProxy(BagProxy)

	for iter0_336, iter1_336 in pairs(arg0_336[DROP_TYPE_ITEM]) do
		if var0_336:getItemCountById(iter0_336) + iter1_336 > Item.getConfigData(iter0_336).max_num then
			return false
		end
	end

	return true
end

local var28_0 = {
	[17] = "item_type17_tip2",
	tech = "techpackage_item_use_confirm",
	[16] = "item_type16_tip2",
	[11] = "equip_skin_detail_tip",
	[13] = "item_type13_tip2"
}

function RegisterDetailButton(arg0_337, arg1_337, arg2_337)
	Drop.Change(arg2_337)
	switch(arg2_337.type, {
		[DROP_TYPE_ITEM] = function()
			if arg2_337:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
				local var0_338 = Item.getConfigData(arg2_337.id).usage_arg
				local var1_338 = var0_338[3]

				if Item.InTimeLimitSkinAssigned(arg2_337.id) then
					var1_338 = table.mergeArray(var0_338[2], var1_338, true)
				end

				local var2_338 = {}

				for iter0_338, iter1_338 in ipairs(var0_338[2]) do
					var2_338[iter1_338] = true
				end

				onButton(arg0_337, arg1_337, function()
					arg0_337:closeView()
					pg.m02:sendNotification(GAME.LOAD_LAYERS, {
						parentContext = getProxy(ContextProxy):getCurrentContext(),
						context = Context.New({
							viewComponent = NewSelectSkinLayer,
							mediator = NewSkinAtlasMediator,
							data = {
								mode = SelectSkinLayer.MODE_VIEW,
								itemId = arg2_337.id,
								selectableSkinList = underscore.map(var1_338, function(arg0_340)
									return SelectableSkin.New({
										id = arg0_340,
										isTimeLimit = var2_338[arg0_340] or false
									})
								end)
							}
						})
					})
				end, SFX_PANEL)
				setActive(arg1_337, true)
			elseif arg2_337:getConfig("usage") ~= ItemUsage.EX_RE_MAP then
				local var3_338 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_337.id) and "tech" or arg2_337:getConfig("type")

				if var28_0[var3_338] then
					local var4_338 = {
						item2Row = true,
						content = i18n(var28_0[var3_338]),
						itemList = underscore.map(arg2_337:getConfig("display_icon"), function(arg0_341)
							return Drop.Create(arg0_341)
						end)
					}

					if var3_338 == 11 then
						onButton(arg0_337, arg1_337, function()
							arg0_337:emit(BaseUI.ON_DROP_LIST_OWN, var4_338)
						end, SFX_PANEL)
					else
						onButton(arg0_337, arg1_337, function()
							arg0_337:emit(BaseUI.ON_DROP_LIST, var4_338)
						end, SFX_PANEL)
					end
				end

				setActive(arg1_337, tobool(var28_0[var3_338]))
			end
		end,
		[DROP_TYPE_EQUIP] = function()
			onButton(arg0_337, arg1_337, function()
				arg0_337:emit(BaseUI.ON_DROP, arg2_337)
			end, SFX_PANEL)
			setActive(arg1_337, true)
		end,
		[DROP_TYPE_SPWEAPON] = function()
			onButton(arg0_337, arg1_337, function()
				arg0_337:emit(BaseUI.ON_DROP, arg2_337)
			end, SFX_PANEL)
			setActive(arg1_337, true)
		end
	}, function()
		setActive(arg1_337, false)
	end)
end

function RegisterNewStyleDetailButton(arg0_349, arg1_349, arg2_349)
	Drop.Change(arg2_349)
	switch(arg2_349.type, {
		[DROP_TYPE_ITEM] = function()
			local var0_350 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_349.id) and "tech" or arg2_349:getConfig("type")

			if var28_0[var0_350] then
				local var1_350 = {
					useDeepShow = true,
					showOwn = var0_350 == 11,
					content = i18n(var28_0[var0_350]),
					itemList = underscore.map(arg2_349:getConfig("display_icon"), function(arg0_351)
						return Drop.Create(arg0_351)
					end)
				}

				onButton(arg0_349, arg1_349, function()
					arg0_349:emit(BaseUI.ON_NEW_STYLE_ITEMS, var1_350)
				end, SFX_PANEL)
			end

			setActive(arg1_349, tobool(var28_0[var0_350]))
		end
	}, function()
		setActive(arg1_349, false)
	end)
end

function UpdateOwnDisplay(arg0_354, arg1_354)
	local var0_354, var1_354 = arg1_354:getOwnedCount()

	setActive(arg0_354, var1_354 and var0_354 > 0)

	if var1_354 and var0_354 > 0 then
		setText(arg0_354:Find("label"), i18n("word_own1"))
		setText(arg0_354:Find("Text"), var0_354)
	end
end

function Damp(arg0_355, arg1_355, arg2_355)
	arg1_355 = Mathf.Max(1, arg1_355)

	local var0_355 = Mathf.Epsilon

	if arg1_355 < var0_355 or var0_355 > Mathf.Abs(arg0_355) then
		return arg0_355
	end

	if arg2_355 < var0_355 then
		return 0
	end

	local var1_355 = -4.605170186

	return arg0_355 * (1 - Mathf.Exp(var1_355 * arg2_355 / arg1_355))
end

function checkCullResume(arg0_356, arg1_356)
	if arg1_356 or not ReflectionHelp.RefCallMethodEx(typeof("UnityEngine.CanvasRenderer"), "GetMaterial", GetComponent(arg0_356, "CanvasRenderer"), {
		typeof("System.Int32")
	}, {
		0
	}) then
		local var0_356 = arg0_356:GetComponentsInChildren(typeof(var0_0.UI.Graphic)):ToTable()

		for iter0_356, iter1_356 in ipairs(var0_356) do
			iter1_356:SetVerticesDirty()
		end

		return false
	end

	return true
end

function parseEquipCode(arg0_357)
	local var0_357 = {}

	if arg0_357 and arg0_357 ~= "" then
		local var1_357 = base64.dec(arg0_357)

		var0_357 = string.split(var1_357, "/")
		var0_357[5], var0_357[6] = unpack(string.split(var0_357[5], "\\"))

		if #var0_357 < 6 or arg0_357 ~= base64.enc(table.concat({
			table.concat(underscore.first(var0_357, 5), "/"),
			var0_357[6]
		}, "\\")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_illegal"))

			var0_357 = {}
		end
	end

	for iter0_357 = 1, 6 do
		var0_357[iter0_357] = var0_357[iter0_357] and tonumber(var0_357[iter0_357], 32) or 0
	end

	return var0_357
end

function buildEquipCode(arg0_358)
	local var0_358 = underscore.map(arg0_358:getAllEquipments(), function(arg0_359)
		return ConversionBase(32, arg0_359 and arg0_359.id or 0)
	end)
	local var1_358 = {
		table.concat(var0_358, "/"),
		ConversionBase(32, checkExist(arg0_358:GetSpWeapon(), {
			"id"
		}) or 0)
	}

	return base64.enc(table.concat(var1_358, "\\"))
end

function setDirectorSpeed(arg0_360, arg1_360)
	GetComponent(arg0_360, typeof(TimelineSpeed)):SetTimelineSpeed(arg1_360)
end

function setDefaultZeroMetatable(arg0_361)
	return setmetatable(arg0_361, {
		__index = function(arg0_362, arg1_362)
			if rawget(arg0_362, arg1_362) == nil then
				arg0_362[arg1_362] = 0
			end

			return arg0_362[arg1_362]
		end
	})
end

function checkABExist(arg0_363)
	if EDITOR_TOOL then
		return ResourceMgr.Inst:AssetExist(arg0_363)
	else
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_363))
	end
end

function compareNumber(arg0_364, arg1_364, arg2_364)
	return switch(arg1_364, {
		[">"] = function()
			return arg0_364 > arg2_364
		end,
		[">="] = function()
			return arg0_364 >= arg2_364
		end,
		["="] = function()
			return arg0_364 == arg2_364
		end,
		["<"] = function()
			return arg0_364 < arg2_364
		end,
		["<="] = function()
			return arg0_364 <= arg2_364
		end
	})
end

function ArabicToRoman(arg0_370)
	local var0_370 = {
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

	local function var1_370(arg0_371, arg1_371)
		return select(2, arg0_371:gsub(arg1_371, ""))
	end

	local var2_370 = ""

	while arg0_370 > 0 do
		for iter0_370, iter1_370 in pairs(var0_370) do
			local var3_370 = iter1_370[2]
			local var4_370 = iter1_370[1]

			while var4_370 <= arg0_370 do
				var2_370 = var2_370 .. var3_370
				arg0_370 = arg0_370 - var4_370
			end
		end
	end

	if arg0_370 > 10000 then
		local var5_370 = var1_370(var2_370, "M")

		var2_370 = "M*" .. var5_370 .. " " .. var2_370
	end

	return var2_370
end

function stringInset(arg0_372, ...)
	for iter0_372, iter1_372 in ipairs({
		...
	}) do
		arg0_372 = string.gsub(arg0_372, "$" .. iter0_372, iter1_372)
	end

	return arg0_372
end

function StringStartsWith(arg0_373, arg1_373)
	return string.sub(arg0_373, 1, string.len(arg1_373)) == arg1_373
end

function addSubLayer(arg0_374, arg1_374, arg2_374, arg3_374, arg4_374)
	if arg2_374 then
		while arg1_374.parent do
			arg1_374 = arg1_374.parent
		end
	end

	local var0_374 = {
		parentContext = arg1_374,
		context = arg0_374,
		callback = arg3_374
	}

	var0_374 = arg4_374 and table.merge(var0_374, arg4_374) or var0_374

	pg.m02:sendNotification(GAME.LOAD_LAYERS, var0_374)
end

function PackIntToString(arg0_375, arg1_375)
	return tostring(arg0_375) .. "," .. tostring(arg1_375)
end

function UnpackIntFromString(arg0_376)
	local var0_376, var1_376 = string.match(arg0_376, "(%-?%d+),(%-?%d+)")

	return tonumber(var0_376), tonumber(var1_376)
end

function getRandomIdxByWeights(arg0_377)
	local var0_377 = 0

	for iter0_377, iter1_377 in ipairs(arg0_377) do
		var0_377 = var0_377 + iter1_377
	end

	assert(var0_377 ~= 0, "总权重为0")

	local var1_377 = math.random(1, var0_377)
	local var2_377 = 0

	for iter2_377, iter3_377 in ipairs(arg0_377) do
		var2_377 = var2_377 + iter3_377

		if var1_377 <= var2_377 then
			return iter2_377
		end
	end

	return #arg0_377
end
