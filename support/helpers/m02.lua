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

	ResourceMgr.Inst:getAssetAsync(arg0_12 .. arg1_12, arg1_12, var0_0.Events.UnityAction_UnityEngine_Object(function(arg0_13)
		local var0_13 = Instantiate(arg0_13)

		arg2_12(var0_13)
	end), arg3_12, arg4_12)
end

function LoadAndInstantiateSync(arg0_14, arg1_14, arg2_14, arg3_14)
	arg3_14 = defaultValue(arg3_14, true)
	arg2_14 = defaultValue(arg2_14, true)
	arg0_14, arg1_14 = HXSet.autoHxShift(arg0_14 .. "/", arg1_14)

	local var0_14 = ResourceMgr.Inst:getAssetSync(arg0_14 .. arg1_14, arg1_14, arg2_14, arg3_14)

	return (Instantiate(var0_14))
end

local var1_0 = {}

function LoadSprite(arg0_15, arg1_15)
	arg0_15, arg1_15 = HXSet.autoHxShiftPath(arg0_15, arg1_15)

	return ResourceMgr.Inst:getAssetSync(arg0_15, arg1_15 or "", typeof(Sprite), true, false)
end

function LoadSpriteAtlasAsync(arg0_16, arg1_16, arg2_16)
	arg0_16, arg1_16 = HXSet.autoHxShiftPath(arg0_16, arg1_16)

	ResourceMgr.Inst:getAssetAsync(arg0_16, arg1_16 or "", typeof(Sprite), var0_0.Events.UnityAction_UnityEngine_Object(function(arg0_17)
		arg2_16(arg0_17)
	end), true, false)
end

function LoadSpriteAsync(arg0_18, arg1_18)
	LoadSpriteAtlasAsync(arg0_18, nil, arg1_18)
end

function LoadAny(arg0_19, arg1_19, arg2_19)
	arg0_19, arg1_19 = HXSet.autoHxShiftPath(arg0_19, arg1_19)

	return ResourceMgr.Inst:getAssetSync(arg0_19, arg1_19, arg2_19, true, false)
end

function LoadAnyAsync(arg0_20, arg1_20, arg2_20, arg3_20)
	arg0_20, arg1_20 = HXSet.autoHxShiftPath(arg0_20, arg1_20)

	return ResourceMgr.Inst:getAssetAsync(arg0_20, arg1_20, arg2_20, arg3_20, true, false)
end

function LoadImageSpriteAtlasAsync(arg0_21, arg1_21, arg2_21, arg3_21)
	local var0_21 = arg2_21:GetComponent(typeof(Image))

	var0_21.enabled = false
	var1_0[var0_21] = arg0_21

	LoadSpriteAtlasAsync(arg0_21, arg1_21, function(arg0_22)
		if not IsNil(var0_21) and var1_0[var0_21] == arg0_21 then
			var1_0[var0_21] = nil
			var0_21.enabled = true
			var0_21.sprite = arg0_22

			if arg3_21 then
				var0_21:SetNativeSize()
			end
		end
	end)
end

function LoadImageSpriteAsync(arg0_23, arg1_23, arg2_23)
	LoadImageSpriteAtlasAsync(arg0_23, nil, arg1_23, arg2_23)
end

function GetSpriteFromAtlas(arg0_24, arg1_24)
	local var0_24

	arg0_24, arg1_24 = HXSet.autoHxShiftPath(arg0_24, arg1_24)

	PoolMgr.GetInstance():GetSprite(arg0_24, arg1_24, false, function(arg0_25)
		var0_24 = arg0_25
	end)

	return var0_24
end

function GetSpriteFromAtlasAsync(arg0_26, arg1_26, arg2_26)
	arg0_26, arg1_26 = HXSet.autoHxShiftPath(arg0_26, arg1_26)

	PoolMgr.GetInstance():GetSprite(arg0_26, arg1_26, true, function(arg0_27)
		arg2_26(arg0_27)
	end)
end

function GetImageSpriteFromAtlasAsync(arg0_28, arg1_28, arg2_28, arg3_28)
	arg0_28, arg1_28 = HXSet.autoHxShiftPath(arg0_28, arg1_28)

	local var0_28 = arg2_28:GetComponent(typeof(Image))

	var0_28.enabled = false
	var1_0[var0_28] = arg0_28 .. arg1_28

	GetSpriteFromAtlasAsync(arg0_28, arg1_28, function(arg0_29)
		if not IsNil(var0_28) and var1_0[var0_28] == arg0_28 .. arg1_28 then
			var1_0[var0_28] = nil
			var0_28.enabled = true
			var0_28.sprite = arg0_29

			if arg3_28 then
				var0_28:SetNativeSize()
			end
		end
	end)
end

function SetAction(arg0_30, arg1_30, arg2_30)
	GetComponent(arg0_30, "SkeletonGraphic").AnimationState:SetAnimation(0, arg1_30, defaultValue(arg2_30, true))
end

function SetActionCallback(arg0_31, arg1_31)
	GetOrAddComponent(arg0_31, typeof(SpineAnimUI)):SetActionCallBack(arg1_31)
end

function emojiText(arg0_32, arg1_32)
	local var0_32 = AssetBundleHelper.loadAssetBundleSync("emojis")
	local var1_32 = GetComponent(arg0_32, "TextMesh")
	local var2_32 = GetComponent(arg0_32, "MeshRenderer")
	local var3_32 = Shader.Find("UI/Unlit/Transparent")
	local var4_32 = var2_32.materials
	local var5_32 = {
		var4_32[0]
	}
	local var6_32 = {}
	local var7_32 = 0

	var1_32.text = string.gsub(arg1_32, "#(%d+)#", function(arg0_33)
		if not var6_32[arg0_33] then
			var7_32 = var7_32 + 1

			local var0_33 = Material.New(var3_32)

			var0_33.mainTexture = var0_32:LoadAssetSync("emoji" .. arg0_33, false, false)

			table.insert(var5_32, var0_33)

			var6_32[arg0_33] = var7_32

			local var1_33 = var7_32
		end

		return "<quad material=" .. var7_32 .. " />"
	end)
	var2_32.materials = var5_32

	ResourceMgr.Inst:ClearBundleRef("emojis", false, false)
end

function setPaintingImg(arg0_34, arg1_34)
	local var0_34 = LoadSprite("painting/" .. arg1_34) or LoadSprite("painting/unknown")

	setImageSprite(arg0_34, var0_34)
	resetAspectRatio(arg0_34)
end

function setPaintingPrefab(arg0_35, arg1_35, arg2_35, arg3_35)
	local var0_35 = findTF(arg0_35, "fitter")

	assert(var0_35, "请添加子物体fitter")
	removeAllChildren(var0_35)

	local var1_35 = GetOrAddComponent(var0_35, "PaintingScaler")

	var1_35.FrameName = arg2_35 or ""
	var1_35.Tween = 1

	local var2_35 = arg1_35

	if not arg3_35 and checkABExist("painting/" .. arg1_35 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg1_35, 0) ~= 0 then
		arg1_35 = arg1_35 .. "_n"
	end

	PoolMgr.GetInstance():GetPainting(arg1_35, false, function(arg0_36)
		setParent(arg0_36, var0_35, false)

		local var0_36 = findTF(arg0_36, "Touch")

		if not IsNil(var0_36) then
			setActive(var0_36, false)
		end

		local var1_36 = findTF(arg0_36, "hx")

		if not IsNil(var1_36) then
			setActive(var1_36, HXSet.isHx())
		end

		ShipExpressionHelper.SetExpression(var0_35:GetChild(0), var2_35)
	end)
end

local var2_0 = {}

function setPaintingPrefabAsync(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37)
	local var0_37 = arg1_37

	if checkABExist("painting/" .. arg1_37 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg1_37, 0) ~= 0 then
		arg1_37 = arg1_37 .. "_n"
	end

	LoadPaintingPrefabAsync(arg0_37, var0_37, arg1_37, arg2_37, arg3_37)
end

function LoadPaintingPrefabAsync(arg0_38, arg1_38, arg2_38, arg3_38, arg4_38)
	local var0_38 = findTF(arg0_38, "fitter")

	assert(var0_38, "请添加子物体fitter")
	removeAllChildren(var0_38)

	local var1_38 = GetOrAddComponent(var0_38, "PaintingScaler")

	var1_38.FrameName = arg3_38 or ""
	var1_38.Tween = 1
	var2_0[arg0_38] = arg2_38

	PoolMgr.GetInstance():GetPainting(arg2_38, true, function(arg0_39)
		if IsNil(arg0_38) or var2_0[arg0_38] ~= arg2_38 then
			PoolMgr.GetInstance():ReturnPainting(arg2_38, arg0_39)

			return
		else
			setParent(arg0_39, var0_38, false)

			var2_0[arg0_38] = nil

			ShipExpressionHelper.SetExpression(arg0_39, arg1_38)
		end

		local var0_39 = findTF(arg0_39, "Touch")

		if not IsNil(var0_39) then
			setActive(var0_39, false)
		end

		local var1_39 = findTF(arg0_39, "Drag")

		if not IsNil(var1_39) then
			setActive(var1_39, false)
		end

		local var2_39 = findTF(arg0_39, "hx")

		if not IsNil(var2_39) then
			setActive(var2_39, HXSet.isHx())
		end

		if arg4_38 then
			arg4_38()
		end
	end)
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

function setColorStr(arg0_67, arg1_67)
	return "<color=" .. arg1_67 .. ">" .. arg0_67 .. "</color>"
end

function setSizeStr(arg0_68, arg1_68)
	local var0_68, var1_68 = string.gsub(arg0_68, "[<]size=%d+[>]", "<size=" .. arg1_68 .. ">")

	if var1_68 == 0 then
		var0_68 = "<size=" .. arg1_68 .. ">" .. var0_68 .. "</size>"
	end

	return var0_68
end

function getBgm(arg0_69, arg1_69)
	local var0_69 = pg.voice_bgm[arg0_69]

	if pg.CriMgr.GetInstance():IsDefaultBGM() then
		return var0_69 and var0_69.default_bgm or nil
	elseif var0_69 then
		if var0_69.special_bgm and type(var0_69.special_bgm) == "table" and #var0_69.special_bgm > 0 and _.all(var0_69.special_bgm, function(arg0_70)
			return type(arg0_70) == "table" and #arg0_70 > 2 and type(arg0_70[2]) == "number"
		end) then
			local var1_69 = Clone(var0_69.special_bgm)

			table.sort(var1_69, function(arg0_71, arg1_71)
				return arg0_71[2] > arg1_71[2]
			end)

			local var2_69 = ""

			_.each(var1_69, function(arg0_72)
				if var2_69 ~= "" then
					return
				end

				local var0_72 = arg0_72[1]
				local var1_72 = arg0_72[3]

				switch(var0_72, {
					function()
						local var0_73 = var1_72[1]
						local var1_73 = var1_72[2]

						if #var0_73 == 1 then
							if var0_73[1] ~= "always" then
								return
							end
						elseif not pg.TimeMgr.GetInstance():inTime(var0_73) then
							return
						end

						_.each(var1_73, function(arg0_74)
							if var2_69 ~= "" then
								return
							end

							if #arg0_74 == 2 and pg.TimeMgr.GetInstance():inPeriod(arg0_74[1]) then
								var2_69 = arg0_74[2]
							elseif #arg0_74 == 3 and pg.TimeMgr.GetInstance():inPeriod(arg0_74[1], arg0_74[2]) then
								var2_69 = arg0_74[3]
							end
						end)
					end,
					function()
						local var0_75 = false
						local var1_75 = ""

						_.each(var1_72, function(arg0_76)
							if #arg0_76 ~= 2 or var0_75 then
								return
							end

							if pg.NewStoryMgr.GetInstance():IsPlayed(arg0_76[1]) then
								var2_69 = arg0_76[2]

								if var2_69 ~= "" then
									var1_75 = var2_69
								else
									var2_69 = var1_75
								end
							else
								var0_75 = true
							end
						end)
					end,
					function()
						if not arg1_69 then
							return
						end

						_.each(var1_72, function(arg0_78)
							if #arg0_78 == 2 and arg0_78[1] == arg1_69 then
								var2_69 = arg0_78[2]

								return
							end
						end)
					end
				})
			end)

			return var2_69 ~= "" and var2_69 or var0_69.bgm
		else
			return var0_69 and var0_69.bgm or nil
		end
	else
		return nil
	end
end

function playStory(arg0_79, arg1_79)
	pg.NewStoryMgr.GetInstance():Play(arg0_79, arg1_79)
end

function errorMessage(arg0_80)
	local var0_80 = ERROR_MESSAGE[arg0_80]

	if var0_80 == nil then
		var0_80 = ERROR_MESSAGE[9999] .. ":" .. arg0_80
	end

	return var0_80
end

function errorTip(arg0_81, arg1_81, ...)
	local var0_81 = pg.gametip[arg0_81 .. "_error"]
	local var1_81

	if var0_81 then
		var1_81 = var0_81.tip
	else
		var1_81 = pg.gametip.common_error.tip
	end

	local var2_81 = arg0_81 .. "_error_" .. arg1_81

	if pg.gametip[var2_81] then
		local var3_81 = i18n(var2_81, ...)

		return var1_81 .. var3_81
	else
		local var4_81 = "common_error_" .. arg1_81

		if pg.gametip[var4_81] then
			local var5_81 = i18n(var4_81, ...)

			return var1_81 .. var5_81
		else
			local var6_81 = errorMessage(arg1_81)

			return var1_81 .. arg1_81 .. ":" .. var6_81
		end
	end
end

function colorNumber(arg0_82, arg1_82)
	local var0_82 = "@COLOR_SCOPE"
	local var1_82 = {}

	arg0_82 = string.gsub(arg0_82, "<color=#%x+>", function(arg0_83)
		table.insert(var1_82, arg0_83)

		return var0_82
	end)
	arg0_82 = string.gsub(arg0_82, "%d+%.?%d*%%*", function(arg0_84)
		return "<color=" .. arg1_82 .. ">" .. arg0_84 .. "</color>"
	end)

	if #var1_82 > 0 then
		local var2_82 = 0

		return (string.gsub(arg0_82, var0_82, function(arg0_85)
			var2_82 = var2_82 + 1

			return var1_82[var2_82]
		end))
	else
		return arg0_82
	end
end

function getBounds(arg0_86)
	local var0_86 = LuaHelper.GetWorldCorners(rtf(arg0_86))
	local var1_86 = Bounds.New(var0_86[0], Vector3.zero)

	var1_86:Encapsulate(var0_86[2])

	return var1_86
end

local function var3_0(arg0_87, arg1_87)
	arg0_87.localScale = Vector3.one
	arg0_87.anchorMin = Vector2.zero
	arg0_87.anchorMax = Vector2.one
	arg0_87.offsetMin = Vector2(arg1_87[1], arg1_87[2])
	arg0_87.offsetMax = Vector2(-arg1_87[3], -arg1_87[4])
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

function setFrame(arg0_88, arg1_88, arg2_88)
	arg1_88 = tostring(arg1_88)

	local var0_88, var1_88 = unpack((string.split(arg1_88, "_")))

	if var1_88 or tonumber(var0_88) > 5 then
		arg2_88 = arg2_88 or "frame" .. arg1_88
	end

	GetImageSpriteFromAtlasAsync("weaponframes", "frame", arg0_88)

	local var2_88 = arg2_88 and Color.white or Color.NewHex(ItemRarity.Rarity2FrameHexColor(var0_88 and tonumber(var0_88) or ItemRarity.Gray))

	setImageColor(arg0_88, var2_88)

	local var3_88 = findTF(arg0_88, "specialFrame")

	if arg2_88 then
		if var3_88 then
			setActive(var3_88, true)
		else
			var3_88 = cloneTplTo(arg0_88, arg0_88, "specialFrame")

			removeAllChildren(var3_88)
		end

		var3_0(var3_88, var4_0[arg2_88] or var4_0.other)
		GetImageSpriteFromAtlasAsync("weaponframes", arg2_88, var3_88)
	elseif var3_88 then
		setActive(var3_88, false)
	end
end

function setIconColorful(arg0_89, arg1_89, arg2_89, arg3_89)
	arg3_89 = arg3_89 or {
		[ItemRarity.SSR] = {
			name = "IconColorful",
			active = function(arg0_90, arg1_90)
				return not arg1_90.noIconColorful and arg0_90 == ItemRarity.SSR
			end
		}
	}

	local var0_89 = findTF(arg0_89, "icon_bg/frame")

	for iter0_89, iter1_89 in pairs(arg3_89) do
		local var1_89 = iter1_89.name
		local var2_89 = iter1_89.active(arg1_89, arg2_89)
		local var3_89 = var0_89:Find(var1_89 .. "(Clone)")

		if var3_89 then
			setActive(var3_89, var2_89)
		elseif var2_89 then
			LoadAndInstantiateAsync("ui", string.lower(var1_89), function(arg0_91)
				if IsNil(arg0_89) or var0_89:Find(var1_89 .. "(Clone)") then
					Object.Destroy(arg0_91)
				else
					setParent(arg0_91, var0_89)
					setActive(arg0_91, var2_89)
				end
			end)
		end
	end
end

function setIconStars(arg0_92, arg1_92, arg2_92)
	local var0_92 = findTF(arg0_92, "icon_bg/startpl")
	local var1_92 = findTF(arg0_92, "icon_bg/stars")

	if var1_92 and var0_92 then
		setActive(var1_92, false)
		setActive(var0_92, false)
	end

	if not var1_92 or not arg1_92 then
		return
	end

	for iter0_92 = 1, math.max(arg2_92, var1_92.childCount) do
		setActive(iter0_92 > var1_92.childCount and cloneTplTo(var0_92, var1_92) or var1_92:GetChild(iter0_92 - 1), iter0_92 <= arg2_92)
	end

	setActive(var1_92, true)
end

local function var5_0(arg0_93, arg1_93)
	local var0_93 = findTF(arg0_93, "icon_bg/slv")

	if not IsNil(var0_93) then
		setActive(var0_93, arg1_93 > 0)
		setText(findTF(var0_93, "Text"), arg1_93)
	end
end

function setIconName(arg0_94, arg1_94, arg2_94)
	local var0_94 = findTF(arg0_94, "name")

	if not IsNil(var0_94) then
		setText(var0_94, arg1_94)
		setTextAlpha(var0_94, (arg2_94.hideName or arg2_94.anonymous) and 0 or 1)
	end
end

function setIconCount(arg0_95, arg1_95)
	local var0_95 = findTF(arg0_95, "icon_bg/count")

	if not IsNil(var0_95) then
		setText(var0_95, arg1_95 and (type(arg1_95) ~= "number" or arg1_95 > 0) and arg1_95 or "")
	end
end

function updateEquipment(arg0_96, arg1_96, arg2_96)
	arg2_96 = arg2_96 or {}

	assert(arg1_96, "equipmentVo can not be nil.")

	local var0_96 = EquipmentRarity.Rarity2Print(arg1_96:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_96, findTF(arg0_96, "icon_bg"))
	setFrame(findTF(arg0_96, "icon_bg/frame"), var0_96)

	local var1_96 = findTF(arg0_96, "icon_bg/icon")

	var3_0(var1_96, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync("equips/" .. arg1_96:getConfig("icon"), "", var1_96)
	setIconStars(arg0_96, true, arg1_96:getConfig("rarity"))
	var5_0(arg0_96, arg1_96:getConfig("level") - 1)
	setIconName(arg0_96, arg1_96:getConfig("name"), arg2_96)
	setIconCount(arg0_96, arg1_96.count)
	setIconColorful(arg0_96, arg1_96:getConfig("rarity") - 1, arg2_96)
end

function updateItem(arg0_97, arg1_97, arg2_97)
	arg2_97 = arg2_97 or {}

	local var0_97 = ItemRarity.Rarity2Print(arg1_97:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_97, findTF(arg0_97, "icon_bg"))

	local var1_97

	if arg1_97:getConfig("type") == 9 then
		var1_97 = "frame_design"
	elseif arg1_97:getConfig("type") == 100 then
		var1_97 = "frame_dorm"
	elseif arg2_97.frame then
		var1_97 = arg2_97.frame
	end

	setFrame(findTF(arg0_97, "icon_bg/frame"), var0_97, var1_97)

	local var2_97 = findTF(arg0_97, "icon_bg/icon")
	local var3_97 = arg1_97.icon or arg1_97:getConfig("icon")

	if arg1_97:getConfig("type") == Item.LOVE_LETTER_TYPE then
		assert(arg1_97.extra, "without extra data")

		var3_97 = "SquareIcon/" .. ShipGroup.getDefaultSkin(arg1_97.extra).prefab
	end

	GetImageSpriteFromAtlasAsync(var3_97, "", var2_97)
	setIconStars(arg0_97, false)
	setIconName(arg0_97, arg1_97:getName(), arg2_97)
	setIconColorful(arg0_97, arg1_97:getConfig("rarity"), arg2_97)
end

function updateWorldItem(arg0_98, arg1_98, arg2_98)
	arg2_98 = arg2_98 or {}

	local var0_98 = ItemRarity.Rarity2Print(arg1_98:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_98, findTF(arg0_98, "icon_bg"))
	setFrame(findTF(arg0_98, "icon_bg/frame"), var0_98)

	local var1_98 = findTF(arg0_98, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_98.icon or arg1_98:getConfig("icon"), "", var1_98)
	setIconStars(arg0_98, false)
	setIconName(arg0_98, arg1_98:getConfig("name"), arg2_98)
	setIconColorful(arg0_98, arg1_98:getConfig("rarity"), arg2_98)
end

function updateWorldCollection(arg0_99, arg1_99, arg2_99)
	arg2_99 = arg2_99 or {}

	assert(arg1_99:getConfigTable(), "world_collection_file_template 和 world_collection_record_template 表中找不到配置: " .. arg1_99.id)

	local var0_99 = arg1_99:getDropRarity()
	local var1_99 = ItemRarity.Rarity2Print(var0_99)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_99, findTF(arg0_99, "icon_bg"))
	setFrame(findTF(arg0_99, "icon_bg/frame"), var1_99)

	local var2_99 = findTF(arg0_99, "icon_bg/icon")
	local var3_99 = WorldCollectionProxy.GetCollectionType(arg1_99.id) == WorldCollectionProxy.WorldCollectionType.FILE and "shoucangguangdie" or "shoucangjiaojuan"

	GetImageSpriteFromAtlasAsync("props/" .. var3_99, "", var2_99)
	setIconStars(arg0_99, false)
	setIconName(arg0_99, arg1_99:getName(), arg2_99)
	setIconColorful(arg0_99, var0_99, arg2_99)
end

function updateWorldBuff(arg0_100, arg1_100, arg2_100)
	arg2_100 = arg2_100 or {}

	local var0_100 = pg.world_SLGbuff_data[arg1_100]

	assert(var0_100, "找不到大世界buff配置: " .. arg1_100)

	local var1_100 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_100, findTF(arg0_100, "icon_bg"))
	setFrame(findTF(arg0_100, "icon_bg/frame"), var1_100)

	local var2_100 = findTF(arg0_100, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("world/buff/" .. var0_100.icon, "", var2_100)

	local var3_100 = arg0_100:Find("icon_bg/stars")

	if not IsNil(var3_100) then
		setActive(var3_100, false)
	end

	local var4_100 = findTF(arg0_100, "name")

	if not IsNil(var4_100) then
		setText(var4_100, var0_100.name)
	end

	local var5_100 = findTF(arg0_100, "icon_bg/count")

	if not IsNil(var5_100) then
		SetActive(var5_100, false)
	end
end

function updateShip(arg0_101, arg1_101, arg2_101)
	arg2_101 = arg2_101 or {}

	local var0_101 = arg1_101:rarity2bgPrint()
	local var1_101 = arg1_101:getPainting()

	if arg2_101.anonymous then
		var0_101 = "1"
		var1_101 = "unknown"
	end

	if arg2_101.unknown_small then
		var1_101 = "unknown_small"
	end

	local var2_101 = findTF(arg0_101, "icon_bg/new")

	if var2_101 then
		if arg2_101.isSkin then
			setActive(var2_101, not arg2_101.isTimeLimit and arg2_101.isNew)
		else
			setActive(var2_101, arg1_101.virgin)
		end
	end

	local var3_101 = findTF(arg0_101, "icon_bg/timelimit")

	if var3_101 then
		setActive(var3_101, arg2_101.isTimeLimit)
	end

	local var4_101 = findTF(arg0_101, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. (arg2_101.isSkin and "_skin" or var0_101), var4_101)

	local var5_101 = findTF(arg0_101, "icon_bg/frame")
	local var6_101

	if arg1_101.isNpc then
		var6_101 = "frame_npc"
	elseif arg1_101:ShowPropose() then
		var6_101 = "frame_prop"

		if arg1_101:isMetaShip() then
			var6_101 = var6_101 .. "_meta"
		end
	elseif arg2_101.isSkin then
		var6_101 = "frame_skin"
	end

	setFrame(var5_101, var0_101, var6_101)

	if arg2_101.gray then
		setGray(var4_101, true, true)
	end

	local var7_101 = findTF(arg0_101, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg2_101.Q and "QIcon/" or "SquareIcon/") .. var1_101, "", var7_101)

	local var8_101 = findTF(arg0_101, "icon_bg/lv")

	if var8_101 then
		setActive(var8_101, not arg1_101.isNpc)

		if not arg1_101.isNpc then
			local var9_101 = findTF(var8_101, "Text")

			if var9_101 and arg1_101.level then
				setText(var9_101, arg1_101.level)
			end
		end
	end

	local var10_101 = findTF(arg0_101, "ship_type")

	if var10_101 then
		setActive(var10_101, true)
		setImageSprite(var10_101, GetSpriteFromAtlas("shiptype", shipType2print(arg1_101:getShipType())))
	end

	local var11_101 = var4_101:Find("npc")

	if not IsNil(var11_101) then
		if var2_101 and go(var2_101).activeSelf then
			setActive(var11_101, false)
		else
			setActive(var11_101, arg1_101:isActivityNpc())
		end
	end

	local var12_101 = arg0_101:Find("group_locked")

	if var12_101 then
		setActive(var12_101, not arg2_101.isSkin and not getProxy(CollectionProxy):getShipGroup(arg1_101.groupId))
	end

	setIconStars(arg0_101, arg2_101.initStar, arg1_101:getStar())
	setIconName(arg0_101, arg2_101.isSkin and arg1_101:GetSkinConfig().name or arg1_101:getName(), arg2_101)
	setIconColorful(arg0_101, arg2_101.isSkin and ItemRarity.Gold or arg1_101:getRarity() - 1, arg2_101)
end

function updateCommander(arg0_102, arg1_102, arg2_102)
	arg2_102 = arg2_102 or {}

	local var0_102 = arg1_102:getDropRarity()
	local var1_102 = ItemRarity.Rarity2Print(var0_102)
	local var2_102 = arg1_102:getConfig("painting")

	if arg2_102.anonymous then
		var1_102 = 1
		var2_102 = "unknown"
	end

	local var3_102 = findTF(arg0_102, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_102, var3_102)

	local var4_102 = findTF(arg0_102, "icon_bg/frame")

	setFrame(var4_102, var1_102)

	if arg2_102.gray then
		setGray(var3_102, true, true)
	end

	local var5_102 = findTF(arg0_102, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("CommanderIcon/" .. var2_102, "", var5_102)
	setIconStars(arg0_102, arg2_102.initStar, 0)
	setIconName(arg0_102, arg1_102:getName(), arg2_102)
end

function updateStrategy(arg0_103, arg1_103, arg2_103)
	arg2_103 = arg2_103 or {}

	local var0_103 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_103, findTF(arg0_103, "icon_bg"))
	setFrame(findTF(arg0_103, "icon_bg/frame"), var0_103)

	local var1_103 = findTF(arg0_103, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg1_103.isWorldBuff and "world/buff/" or "strategyicon/") .. arg1_103:getIcon(), "", var1_103)
	setIconStars(arg0_103, false)
	setIconName(arg0_103, arg1_103:getName(), arg2_103)
	setIconColorful(arg0_103, ItemRarity.Gray, arg2_103)
end

function updateFurniture(arg0_104, arg1_104, arg2_104)
	arg2_104 = arg2_104 or {}

	local var0_104 = arg1_104:getDropRarity()
	local var1_104 = ItemRarity.Rarity2Print(var0_104)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_104, findTF(arg0_104, "icon_bg"))
	setFrame(findTF(arg0_104, "icon_bg/frame"), var1_104)

	local var2_104 = findTF(arg0_104, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1_104:getIcon(), "", var2_104)
	setIconStars(arg0_104, false)
	setIconName(arg0_104, arg1_104:getName(), arg2_104)
	setIconColorful(arg0_104, var0_104, arg2_104)
end

function updateSpWeapon(arg0_105, arg1_105, arg2_105)
	arg2_105 = arg2_105 or {}

	assert(arg1_105, "spWeaponVO can not be nil.")
	assert(isa(arg1_105, SpWeapon), "spWeaponVO is not Equipment.")

	local var0_105 = ItemRarity.Rarity2Print(arg1_105:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_105, findTF(arg0_105, "icon_bg"))
	setFrame(findTF(arg0_105, "icon_bg/frame"), var0_105)

	local var1_105 = findTF(arg0_105, "icon_bg/icon")

	var3_0(var1_105, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync(arg1_105:GetIconPath(), "", var1_105)
	setIconStars(arg0_105, true, arg1_105:GetRarity())
	var5_0(arg0_105, arg1_105:GetLevel() - 1)
	setIconName(arg0_105, arg1_105:GetName(), arg2_105)
	setIconCount(arg0_105, arg1_105.count)
	setIconColorful(arg0_105, arg1_105:GetRarity(), arg2_105)
end

function UpdateSpWeaponSlot(arg0_106, arg1_106, arg2_106)
	local var0_106 = ItemRarity.Rarity2Print(arg1_106:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_106, findTF(arg0_106, "Icon/Mask/icon_bg"))

	local var1_106 = findTF(arg0_106, "Icon/Mask/icon_bg/icon")

	arg2_106 = arg2_106 or {
		16,
		16,
		16,
		16
	}

	var3_0(var1_106, arg2_106)
	GetImageSpriteFromAtlasAsync(arg1_106:GetIconPath(), "", var1_106)

	local var2_106 = arg1_106:GetLevel() - 1
	local var3_106 = findTF(arg0_106, "Icon/LV")

	setActive(var3_106, var2_106 > 0)
	setText(findTF(var3_106, "Text"), var2_106)
end

function updateDorm3dFurniture(arg0_107, arg1_107, arg2_107)
	arg2_107 = arg2_107 or {}

	local var0_107 = arg1_107:getDropRarity()
	local var1_107 = ItemRarity.Rarity2Print(var0_107)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_107, findTF(arg0_107, "icon_bg"))
	setFrame(findTF(arg0_107, "icon_bg/frame"), var1_107)

	local var2_107 = findTF(arg0_107, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_107:getIcon(), "", var2_107)
	setIconStars(arg0_107, false)
	setIconName(arg0_107, arg1_107:getName(), arg2_107)
	setIconColorful(arg0_107, var0_107, arg2_107)
end

function updateDorm3dGift(arg0_108, arg1_108, arg2_108)
	arg2_108 = arg2_108 or {}

	local var0_108 = arg1_108:getDropRarity()
	local var1_108 = ItemRarity.Rarity2Print(var0_108) or ItemRarity.Gray

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_108, arg0_108:Find("icon_bg"))
	setFrame(arg0_108:Find("icon_bg/frame"), var1_108)

	local var2_108 = arg0_108:Find("icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_108:getIcon(), "", var2_108)
	setIconStars(arg0_108, false)
	setIconName(arg0_108, arg1_108:getName(), arg2_108)
	setIconColorful(arg0_108, var0_108, arg2_108)
end

function updateDorm3dSkin(arg0_109, arg1_109, arg2_109)
	arg2_109 = arg2_109 or {}

	local var0_109 = arg1_109:getDropRarity()
	local var1_109 = ItemRarity.Rarity2Print(var0_109) or ItemRarity.Gray

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_109, arg0_109:Find("icon_bg"))
	setFrame(arg0_109:Find("icon_bg/frame"), var1_109)

	local var2_109 = arg0_109:Find("icon_bg/icon")

	setIconStars(arg0_109, false)
	setIconName(arg0_109, arg1_109:getName(), arg2_109)
	setIconColorful(arg0_109, var0_109, arg2_109)
end

function updateDorm3dIcon(arg0_110, arg1_110)
	local var0_110 = arg1_110:getDropRarityDorm()

	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(var0_110), arg0_110)

	local var1_110 = arg0_110:Find("icon")

	GetImageSpriteFromAtlasAsync(arg1_110:getIcon(), "", var1_110)
	setText(arg0_110:Find("count/Text"), "x" .. arg1_110.count)
	setText(arg0_110:Find("name/Text"), arg1_110:getName())
end

local var6_0

function findCullAndClipWorldRect(arg0_111)
	if #arg0_111 == 0 then
		return false
	end

	local var0_111 = arg0_111[1].canvasRect

	for iter0_111 = 1, #arg0_111 do
		var0_111 = rectIntersect(var0_111, arg0_111[iter0_111].canvasRect)
	end

	if var0_111.width <= 0 or var0_111.height <= 0 then
		return false
	end

	var6_0 = var6_0 or GameObject.Find("UICamera/Canvas").transform

	local var1_111 = var6_0:TransformPoint(Vector3(var0_111.x, var0_111.y, 0))
	local var2_111 = var6_0:TransformPoint(Vector3(var0_111.x + var0_111.width, var0_111.y + var0_111.height, 0))

	return true, Vector4(var1_111.x, var1_111.y, var2_111.x, var2_111.y)
end

function rectIntersect(arg0_112, arg1_112)
	local var0_112 = math.max(arg0_112.x, arg1_112.x)
	local var1_112 = math.min(arg0_112.x + arg0_112.width, arg1_112.x + arg1_112.width)
	local var2_112 = math.max(arg0_112.y, arg1_112.y)
	local var3_112 = math.min(arg0_112.y + arg0_112.height, arg1_112.y + arg1_112.height)

	if var0_112 <= var1_112 and var2_112 <= var3_112 then
		return var0_0.Rect.New(var0_112, var2_112, var1_112 - var0_112, var3_112 - var2_112)
	end

	return var0_0.Rect.New(0, 0, 0, 0)
end

function getDropInfo(arg0_113)
	local var0_113 = {}

	for iter0_113, iter1_113 in ipairs(arg0_113) do
		local var1_113 = Drop.Create(iter1_113)

		var1_113.count = var1_113.count or 1

		if var1_113.type == DROP_TYPE_EMOJI then
			table.insert(var0_113, var1_113:getName())
		else
			table.insert(var0_113, var1_113:getName() .. "x" .. var1_113.count)
		end
	end

	return table.concat(var0_113, "、")
end

function updateDrop(arg0_114, arg1_114, arg2_114)
	Drop.Change(arg1_114)

	arg2_114 = arg2_114 or {}

	local var0_114 = {
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
	local var1_114

	for iter0_114, iter1_114 in ipairs(var0_114) do
		local var2_114 = arg0_114:Find(iter1_114[1])

		if arg1_114.type ~= iter1_114[2] and not IsNil(var2_114) then
			setActive(var2_114, false)
		end
	end

	arg0_114:Find("icon_bg/frame"):GetComponent(typeof(Image)).enabled = true

	setIconColorful(arg0_114, arg1_114:getDropRarity(), arg2_114, {
		[ItemRarity.Gold] = {
			name = "Item_duang5",
			active = function(arg0_115, arg1_115)
				return arg1_115.fromAwardLayer and arg0_115 >= ItemRarity.Gold
			end
		}
	})
	var3_0(findTF(arg0_114, "icon_bg/icon"), {
		2,
		2,
		2,
		2
	})
	arg1_114:UpdateDropTpl(arg0_114, arg2_114)
	setIconCount(arg0_114, arg2_114.count or arg1_114:getCount())
end

function updateBuff(arg0_116, arg1_116, arg2_116)
	arg2_116 = arg2_116 or {}

	local var0_116 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_116, findTF(arg0_116, "icon_bg"))

	local var1_116 = pg.benefit_buff_template[arg1_116]

	setFrame(findTF(arg0_116, "icon_bg/frame"), var0_116)
	setText(findTF(arg0_116, "icon_bg/count"), 1)

	local var2_116 = findTF(arg0_116, "icon_bg/icon")
	local var3_116 = var1_116.icon

	GetImageSpriteFromAtlasAsync(var3_116, "", var2_116)
	setIconStars(arg0_116, false)
	setIconName(arg0_116, var1_116.name, arg2_116)
	setIconColorful(arg0_116, ItemRarity.Gold, arg2_116)
end

function updateAttire(arg0_117, arg1_117, arg2_117, arg3_117)
	local var0_117 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_117, findTF(arg0_117, "icon_bg"))
	setFrame(findTF(arg0_117, "icon_bg/frame"), var0_117)

	local var1_117 = findTF(arg0_117, "icon_bg/icon")
	local var2_117

	if arg1_117 == AttireConst.TYPE_CHAT_FRAME then
		var2_117 = "chat_frame"
	elseif arg1_117 == AttireConst.TYPE_ICON_FRAME then
		var2_117 = "icon_frame"
	end

	GetImageSpriteFromAtlasAsync("Props/" .. var2_117, "", var1_117)
	setIconName(arg0_117, arg2_117.name, arg3_117)
end

function updateAttireCombatUI(arg0_118, arg1_118, arg2_118, arg3_118)
	local var0_118 = arg2_118.rare

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_118, findTF(arg0_118, "icon_bg"))
	setFrame(findTF(arg0_118, "icon_bg/frame"), var0_118, "frame_battle_ui")

	local var1_118 = findTF(arg0_118, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("Props/" .. arg2_118.display_icon, "", var1_118)
	setIconName(arg0_118, arg2_118.name, arg3_118)
end

function updateCover(arg0_119, arg1_119, arg2_119)
	local var0_119 = arg1_119:getDropRarity()

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_119, findTF(arg0_119, "icon_bg"))
	setFrame(findTF(arg0_119, "icon_bg/frame"), var0_119)

	local var1_119 = findTF(arg0_119, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_119:getIcon(), "", var1_119)
	setIconName(arg0_119, arg1_119:getName(), arg2_119)
	setIconStars(arg0_119, false)
end

function updateEmoji(arg0_120, arg1_120, arg2_120)
	local var0_120 = findTF(arg0_120, "icon_bg/icon")
	local var1_120 = "icon_emoji"

	GetImageSpriteFromAtlasAsync("Props/" .. var1_120, "", var0_120)

	local var2_120 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var2_120, findTF(arg0_120, "icon_bg"))
	setFrame(findTF(arg0_120, "icon_bg/frame"), var2_120)
	setIconName(arg0_120, arg1_120.name, arg2_120)
end

function updateEquipmentSkin(arg0_121, arg1_121, arg2_121)
	arg2_121 = arg2_121 or {}

	local var0_121 = EquipmentRarity.Rarity2Print(arg1_121.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_121, findTF(arg0_121, "icon_bg"))
	setFrame(findTF(arg0_121, "icon_bg/frame"), var0_121, "frame_skin")

	local var1_121 = findTF(arg0_121, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. arg1_121.icon, "", var1_121)
	setIconStars(arg0_121, false)
	setIconName(arg0_121, arg1_121.name, arg2_121)
	setIconCount(arg0_121, arg1_121.count)
	setIconColorful(arg0_121, arg1_121.rarity - 1, arg2_121)
end

function NoPosMsgBox(arg0_122, arg1_122, arg2_122, arg3_122)
	local var0_122
	local var1_122 = {}

	if arg1_122 then
		table.insert(var1_122, {
			text = "text_noPos_clear",
			atuoClose = true,
			onCallback = arg1_122
		})
	end

	if arg2_122 then
		table.insert(var1_122, {
			text = "text_noPos_buy",
			atuoClose = true,
			onCallback = arg2_122
		})
	end

	if arg3_122 then
		table.insert(var1_122, {
			text = "text_noPos_intensify",
			atuoClose = true,
			onCallback = arg3_122
		})
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		hideNo = true,
		content = arg0_122,
		custom = var1_122,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function openDestroyEquip()
	if pg.m02:hasMediator(EquipmentMediator.__cname) then
		local var0_123 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_123 and var0_123.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_123
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
		local var0_124 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_124 and var0_124.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_124
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
		onClick = function(arg0_127, arg1_127)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
				page = 3,
				shipId = arg0_127.id,
				shipVOs = arg1_127
			})
		end
	})
end

function GoShoppingMsgBox(arg0_128, arg1_128, arg2_128)
	if arg2_128 then
		local var0_128 = ""

		for iter0_128, iter1_128 in ipairs(arg2_128) do
			local var1_128 = Item.getConfigData(iter1_128[1])

			var0_128 = var0_128 .. i18n(iter1_128[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var1_128.name, iter1_128[2])

			if iter0_128 < #arg2_128 then
				var0_128 = var0_128 .. i18n("text_noRes_info_tip_link")
			end
		end

		if var0_128 ~= "" then
			arg0_128 = arg0_128 .. "\n" .. i18n("text_noRes_tip", var0_128)
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = arg0_128,
		weight = LayerWeightConst.SECOND_LAYER,
		onYes = function()
			gotoChargeScene(arg1_128, arg2_128)
		end
	})
end

function shoppingBatch(arg0_130, arg1_130, arg2_130, arg3_130, arg4_130)
	local var0_130 = pg.shop_template[arg0_130]

	assert(var0_130, "shop_template中找不到商品id：" .. arg0_130)

	local var1_130 = getProxy(PlayerProxy):getData()[id2res(var0_130.resource_type)]
	local var2_130 = arg1_130.price or var0_130.resource_num
	local var3_130 = math.floor(var1_130 / var2_130)

	var3_130 = var3_130 <= 0 and 1 or var3_130
	var3_130 = arg2_130 ~= nil and arg2_130 < var3_130 and arg2_130 or var3_130

	local var4_130 = true
	local var5_130 = 1

	if var0_130 ~= nil and arg1_130.id then
		print(var3_130 * var0_130.num, "--", var3_130)
		assert(Item.getConfigData(arg1_130.id), "item config should be existence")

		local var6_130 = Item.New({
			id = arg1_130.id
		}):getConfig("name")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			needCounter = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_ITEM,
				id = arg1_130.id
			},
			addNum = var0_130.num,
			maxNum = var3_130 * var0_130.num,
			defaultNum = var0_130.num,
			numUpdate = function(arg0_131, arg1_131)
				var5_130 = math.floor(arg1_131 / var0_130.num)

				local var0_131 = var5_130 * var2_130

				if var0_131 > var1_130 then
					setText(arg0_131, i18n(arg3_130, var0_131, arg1_131, COLOR_RED, var6_130))

					var4_130 = false
				else
					setText(arg0_131, i18n(arg3_130, var0_131, arg1_131, COLOR_GREEN, var6_130))

					var4_130 = true
				end
			end,
			onYes = function()
				if var4_130 then
					pg.m02:sendNotification(GAME.SHOPPING, {
						id = arg0_130,
						count = var5_130
					})
				elseif arg4_130 then
					pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_130))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("main_playerInfoLayer_error_changeNameNoGem"))
				end
			end
		})
	end
end

function gotoChargeScene(arg0_133, arg1_133)
	local var0_133 = getProxy(ContextProxy)
	local var1_133 = getProxy(ContextProxy):getCurrentContext()

	if instanceof(var1_133.mediator, ChargeMediator) then
		var1_133.mediator:getViewComponent():switchSubViewByTogger(arg0_133)
	else
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
			wrap = arg0_133 or ChargeScene.TYPE_ITEM,
			noRes = arg1_133
		})
	end
end

function clearDrop(arg0_134)
	local var0_134 = findTF(arg0_134, "icon_bg")
	local var1_134 = findTF(arg0_134, "icon_bg/frame")
	local var2_134 = findTF(arg0_134, "icon_bg/icon")
	local var3_134 = findTF(arg0_134, "icon_bg/icon/icon")

	clearImageSprite(var0_134)
	clearImageSprite(var1_134)
	clearImageSprite(var2_134)

	if var3_134 then
		clearImageSprite(var3_134)
	end
end

local var7_0 = {
	red = Color.New(1, 0.25, 0.25),
	blue = Color.New(0.11, 0.55, 0.64),
	yellow = Color.New(0.92, 0.52, 0)
}

function updateSkill(arg0_135, arg1_135, arg2_135, arg3_135)
	local var0_135 = findTF(arg0_135, "skill")
	local var1_135 = findTF(arg0_135, "lock")
	local var2_135 = findTF(arg0_135, "unknown")

	if arg1_135 then
		setActive(var0_135, true)
		setActive(var2_135, false)
		setActive(var1_135, not arg2_135)
		LoadImageSpriteAsync("skillicon/" .. arg1_135.icon, findTF(var0_135, "icon"))

		local var3_135 = arg1_135.color or "blue"

		setText(findTF(var0_135, "name"), shortenString(getSkillName(arg1_135.id), arg3_135 or 8))

		local var4_135 = findTF(var0_135, "level")

		setText(var4_135, "LEVEL: " .. (arg2_135 and arg2_135.level or "??"))
		setTextColor(var4_135, var7_0[var3_135])
	else
		setActive(var0_135, false)
		setActive(var2_135, true)
		setActive(var1_135, false)
	end
end

local var8_0 = true

function onBackButton(arg0_136, arg1_136, arg2_136, arg3_136)
	local var0_136 = GetOrAddComponent(arg1_136, "UILongPressTrigger")

	assert(arg2_136, "callback should exist")

	var0_136.longPressThreshold = defaultValue(arg3_136, 1)

	local function var1_136(arg0_137)
		return function()
			if var8_0 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SOUND_BACK)
			end

			local var0_138, var1_138 = arg2_136()

			if var0_138 then
				arg0_137(var1_138)
			end
		end
	end

	local var2_136 = var0_136.onReleased

	pg.DelegateInfo.Add(arg0_136, var2_136)
	var2_136:RemoveAllListeners()
	var2_136:AddListener(var1_136(function(arg0_139)
		arg0_139:emit(BaseUI.ON_BACK)
	end))

	local var3_136 = var0_136.onLongPressed

	pg.DelegateInfo.Add(arg0_136, var3_136)
	var3_136:RemoveAllListeners()
	var3_136:AddListener(var1_136(function(arg0_140)
		arg0_140:emit(BaseUI.ON_HOME)
	end))
end

function GetZeroTime()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)
end

function GetHalfHour()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0, 1800)
end

function GetNextHour(arg0_143)
	local var0_143 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_143, var2_143 = pg.TimeMgr.GetInstance():parseTimeFrom(var0_143)

	return var1_143 * 86400 + (var2_143 + arg0_143) * 3600
end

function GetPerceptualSize(arg0_144)
	local function var0_144(arg0_145)
		if not arg0_145 then
			return 0, 1
		elseif arg0_145 > 240 then
			return 4, 1
		elseif arg0_145 > 225 then
			return 3, 1
		elseif arg0_145 > 192 then
			return 2, 1
		elseif arg0_145 < 126 then
			return 1, 0.5
		else
			return 1, 1
		end
	end

	if type(arg0_144) == "number" then
		return var0_144(arg0_144)
	end

	local var1_144 = 1
	local var2_144 = 0
	local var3_144 = 0
	local var4_144 = #arg0_144

	while var1_144 <= var4_144 do
		local var5_144 = string.byte(arg0_144, var1_144)
		local var6_144, var7_144 = var0_144(var5_144)

		var1_144 = var1_144 + var6_144
		var2_144 = var2_144 + var7_144
	end

	return var2_144
end

function shortenString(arg0_146, arg1_146)
	local var0_146 = 1
	local var1_146 = 0
	local var2_146 = 0
	local var3_146 = #arg0_146

	while var0_146 <= var3_146 do
		local var4_146 = string.byte(arg0_146, var0_146)
		local var5_146, var6_146 = GetPerceptualSize(var4_146)

		var0_146 = var0_146 + var5_146
		var1_146 = var1_146 + var6_146

		if arg1_146 <= math.ceil(var1_146) then
			var2_146 = var0_146

			break
		end
	end

	if var2_146 == 0 or var3_146 < var2_146 then
		return arg0_146
	end

	return string.sub(arg0_146, 1, var2_146 - 1) .. ".."
end

function shouldShortenString(arg0_147, arg1_147)
	local var0_147 = 1
	local var1_147 = 0
	local var2_147 = 0
	local var3_147 = #arg0_147

	while var0_147 <= var3_147 do
		local var4_147 = string.byte(arg0_147, var0_147)
		local var5_147, var6_147 = GetPerceptualSize(var4_147)

		var0_147 = var0_147 + var5_147
		var1_147 = var1_147 + var6_147

		if arg1_147 <= math.ceil(var1_147) then
			var2_147 = var0_147

			break
		end
	end

	if var2_147 == 0 or var3_147 < var2_147 then
		return false
	end

	return true
end

function nameValidityCheck(arg0_148, arg1_148, arg2_148, arg3_148)
	local var0_148 = true
	local var1_148, var2_148 = utf8_to_unicode(arg0_148)
	local var3_148 = filterEgyUnicode(filterSpecChars(arg0_148))
	local var4_148 = wordVer(arg0_148)

	if not checkSpaceValid(arg0_148) then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_148[1]))

		var0_148 = false
	elseif var4_148 > 0 or var3_148 ~= arg0_148 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_148[4]))

		var0_148 = false
	elseif var2_148 < arg1_148 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_148[2]))

		var0_148 = false
	elseif arg2_148 < var2_148 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_148[3]))

		var0_148 = false
	end

	return var0_148
end

function checkSpaceValid(arg0_149)
	if PLATFORM_CODE == PLATFORM_US then
		return true
	end

	local var0_149 = string.gsub(arg0_149, " ", "")

	return arg0_149 == string.gsub(var0_149, "　", "")
end

function filterSpecChars(arg0_150)
	local var0_150 = {}
	local var1_150 = 0
	local var2_150 = 0
	local var3_150 = 0
	local var4_150 = 1

	while var4_150 <= #arg0_150 do
		local var5_150 = string.byte(arg0_150, var4_150)

		if not var5_150 then
			break
		end

		if var5_150 >= 48 and var5_150 <= 57 or var5_150 >= 65 and var5_150 <= 90 or var5_150 == 95 or var5_150 >= 97 and var5_150 <= 122 then
			table.insert(var0_150, string.char(var5_150))
		elseif var5_150 >= 228 and var5_150 <= 233 then
			local var6_150 = string.byte(arg0_150, var4_150 + 1)
			local var7_150 = string.byte(arg0_150, var4_150 + 2)

			if var6_150 and var7_150 and var6_150 >= 128 and var6_150 <= 191 and var7_150 >= 128 and var7_150 <= 191 then
				var4_150 = var4_150 + 2

				table.insert(var0_150, string.char(var5_150, var6_150, var7_150))

				var1_150 = var1_150 + 1
			end
		elseif var5_150 == 45 or var5_150 == 40 or var5_150 == 41 then
			table.insert(var0_150, string.char(var5_150))
		elseif var5_150 == 194 then
			local var8_150 = string.byte(arg0_150, var4_150 + 1)

			if var8_150 == 183 then
				var4_150 = var4_150 + 1

				table.insert(var0_150, string.char(var5_150, var8_150))

				var1_150 = var1_150 + 1
			end
		elseif var5_150 == 239 then
			local var9_150 = string.byte(arg0_150, var4_150 + 1)
			local var10_150 = string.byte(arg0_150, var4_150 + 2)

			if var9_150 == 188 and (var10_150 == 136 or var10_150 == 137) then
				var4_150 = var4_150 + 2

				table.insert(var0_150, string.char(var5_150, var9_150, var10_150))

				var1_150 = var1_150 + 1
			end
		elseif var5_150 == 206 or var5_150 == 207 then
			local var11_150 = string.byte(arg0_150, var4_150 + 1)

			if var5_150 == 206 and var11_150 >= 177 or var5_150 == 207 and var11_150 <= 134 then
				var4_150 = var4_150 + 1

				table.insert(var0_150, string.char(var5_150, var11_150))

				var1_150 = var1_150 + 1
			end
		elseif var5_150 == 227 and PLATFORM_CODE == PLATFORM_JP then
			local var12_150 = string.byte(arg0_150, var4_150 + 1)
			local var13_150 = string.byte(arg0_150, var4_150 + 2)

			if var12_150 and var13_150 and var12_150 > 128 and var12_150 <= 191 and var13_150 >= 128 and var13_150 <= 191 then
				var4_150 = var4_150 + 2

				table.insert(var0_150, string.char(var5_150, var12_150, var13_150))

				var2_150 = var2_150 + 1
			end
		elseif var5_150 >= 224 and PLATFORM_CODE == PLATFORM_KR then
			local var14_150 = string.byte(arg0_150, var4_150 + 1)
			local var15_150 = string.byte(arg0_150, var4_150 + 2)

			if var14_150 and var15_150 and var14_150 >= 128 and var14_150 <= 191 and var15_150 >= 128 and var15_150 <= 191 then
				var4_150 = var4_150 + 2

				table.insert(var0_150, string.char(var5_150, var14_150, var15_150))

				var3_150 = var3_150 + 1
			end
		elseif PLATFORM_CODE == PLATFORM_US then
			if var4_150 ~= 1 and var5_150 == 32 and string.byte(arg0_150, var4_150 + 1) ~= 32 then
				table.insert(var0_150, string.char(var5_150))
			end

			if var5_150 >= 192 and var5_150 <= 223 then
				local var16_150 = string.byte(arg0_150, var4_150 + 1)

				var4_150 = var4_150 + 1

				if var5_150 == 194 and var16_150 and var16_150 >= 128 then
					table.insert(var0_150, string.char(var5_150, var16_150))
				elseif var5_150 == 195 and var16_150 and var16_150 <= 191 then
					table.insert(var0_150, string.char(var5_150, var16_150))
				end
			end
		end

		var4_150 = var4_150 + 1
	end

	return table.concat(var0_150), var1_150 + var2_150 + var3_150
end

function filterEgyUnicode(arg0_151)
	arg0_151 = string.gsub(arg0_151, "�[�-�][�-�]", "")
	arg0_151 = string.gsub(arg0_151, "�[�-�]", "")

	return arg0_151
end

function shiftPanel(arg0_152, arg1_152, arg2_152, arg3_152, arg4_152, arg5_152, arg6_152, arg7_152, arg8_152)
	arg3_152 = arg3_152 or 0.2

	if arg5_152 then
		LeanTween.cancel(go(arg0_152))
	end

	local var0_152 = rtf(arg0_152)

	arg1_152 = arg1_152 or var0_152.anchoredPosition.x
	arg2_152 = arg2_152 or var0_152.anchoredPosition.y

	local var1_152 = LeanTween.move(var0_152, Vector3(arg1_152, arg2_152, 0), arg3_152)

	arg7_152 = arg7_152 or LeanTweenType.easeInOutSine

	var1_152:setEase(arg7_152)

	if arg4_152 then
		var1_152:setDelay(arg4_152)
	end

	if arg6_152 then
		GetOrAddComponent(arg0_152, "CanvasGroup").blocksRaycasts = false
	end

	var1_152:setOnComplete(System.Action(function()
		if arg8_152 then
			arg8_152()
		end

		if arg6_152 then
			GetOrAddComponent(arg0_152, "CanvasGroup").blocksRaycasts = true
		end
	end))

	return var1_152
end

function TweenValue(arg0_154, arg1_154, arg2_154, arg3_154, arg4_154, arg5_154, arg6_154, arg7_154)
	local var0_154 = LeanTween.value(go(arg0_154), arg1_154, arg2_154, arg3_154):setOnUpdate(System.Action_float(function(arg0_155)
		if arg5_154 then
			arg5_154(arg0_155)
		end
	end)):setOnComplete(System.Action(function()
		if arg6_154 then
			arg6_154()
		end
	end)):setDelay(arg4_154 or 0)

	if arg7_154 and arg7_154 > 0 then
		var0_154:setRepeat(arg7_154)
	end

	return var0_154
end

function rotateAni(arg0_157, arg1_157, arg2_157)
	return LeanTween.rotate(rtf(arg0_157), 360 * arg1_157, arg2_157):setLoopClamp()
end

function blinkAni(arg0_158, arg1_158, arg2_158, arg3_158)
	return LeanTween.alpha(rtf(arg0_158), arg3_158 or 0, arg1_158):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(arg2_158 or 0)
end

function scaleAni(arg0_159, arg1_159, arg2_159, arg3_159)
	return LeanTween.scale(rtf(arg0_159), arg3_159 or 0, arg1_159):setLoopPingPong(arg2_159 or 0)
end

function floatAni(arg0_160, arg1_160, arg2_160, arg3_160)
	local var0_160 = arg0_160.localPosition.y + arg1_160

	return LeanTween.moveY(rtf(arg0_160), var0_160, arg2_160):setLoopPingPong(arg3_160 or 0)
end

local var9_0 = tostring

function tostring(arg0_161)
	if arg0_161 == nil then
		return "nil"
	end

	local var0_161 = var9_0(arg0_161)

	if var0_161 == nil then
		if type(arg0_161) == "table" then
			return "{}"
		end

		return " ~nil"
	end

	return var0_161
end

function wordVer(arg0_162, arg1_162)
	if arg0_162.match(arg0_162, ChatConst.EmojiCodeMatch) then
		return 0, arg0_162
	end

	arg1_162 = arg1_162 or {}

	local var0_162 = filterEgyUnicode(arg0_162)

	if #var0_162 ~= #arg0_162 then
		if arg1_162.isReplace then
			arg0_162 = var0_162
		else
			return 1
		end
	end

	local var1_162 = wordSplit(arg0_162)
	local var2_162 = pg.word_template
	local var3_162 = pg.word_legal_template

	arg1_162.isReplace = arg1_162.isReplace or false
	arg1_162.replaceWord = arg1_162.replaceWord or "*"

	local var4_162 = #var1_162
	local var5_162 = 1
	local var6_162 = ""
	local var7_162 = 0

	while var5_162 <= var4_162 do
		local var8_162, var9_162, var10_162 = wordLegalMatch(var1_162, var3_162, var5_162)

		if var8_162 then
			var5_162 = var9_162
			var6_162 = var6_162 .. var10_162
		else
			local var11_162, var12_162, var13_162 = wordVerMatch(var1_162, var2_162, arg1_162, var5_162, "", false, var5_162, "")

			if var11_162 then
				var5_162 = var12_162
				var7_162 = var7_162 + 1

				if arg1_162.isReplace then
					var6_162 = var6_162 .. var13_162
				end
			else
				if arg1_162.isReplace then
					var6_162 = var6_162 .. var1_162[var5_162]
				end

				var5_162 = var5_162 + 1
			end
		end
	end

	if arg1_162.isReplace then
		return var7_162, var6_162
	else
		return var7_162
	end
end

function wordLegalMatch(arg0_163, arg1_163, arg2_163, arg3_163, arg4_163)
	if arg2_163 > #arg0_163 then
		return arg3_163, arg2_163, arg4_163
	end

	local var0_163 = arg0_163[arg2_163]
	local var1_163 = arg1_163[var0_163]

	arg4_163 = arg4_163 == nil and "" or arg4_163

	if var1_163 then
		if var1_163.this then
			return wordLegalMatch(arg0_163, var1_163, arg2_163 + 1, true, arg4_163 .. var0_163)
		else
			return wordLegalMatch(arg0_163, var1_163, arg2_163 + 1, false, arg4_163 .. var0_163)
		end
	else
		return arg3_163, arg2_163, arg4_163
	end
end

local var10_0 = string.byte("a")
local var11_0 = string.byte("z")
local var12_0 = string.byte("A")
local var13_0 = string.byte("Z")

local function var14_0(arg0_164)
	if not arg0_164 then
		return arg0_164
	end

	local var0_164 = string.byte(arg0_164)

	if var0_164 > 128 then
		return
	end

	if var0_164 >= var10_0 and var0_164 <= var11_0 then
		return string.char(var0_164 - 32)
	elseif var0_164 >= var12_0 and var0_164 <= var13_0 then
		return string.char(var0_164 + 32)
	else
		return arg0_164
	end
end

function wordVerMatch(arg0_165, arg1_165, arg2_165, arg3_165, arg4_165, arg5_165, arg6_165, arg7_165)
	if arg3_165 > #arg0_165 then
		return arg5_165, arg6_165, arg7_165
	end

	local var0_165 = arg0_165[arg3_165]
	local var1_165 = arg1_165[var0_165]

	if var1_165 then
		local var2_165, var3_165, var4_165 = wordVerMatch(arg0_165, var1_165, arg2_165, arg3_165 + 1, arg2_165.isReplace and arg4_165 .. arg2_165.replaceWord or arg4_165, var1_165.this or arg5_165, var1_165.this and arg3_165 + 1 or arg6_165, var1_165.this and (arg2_165.isReplace and arg4_165 .. arg2_165.replaceWord or arg4_165) or arg7_165)

		if var2_165 then
			return var2_165, var3_165, var4_165
		end
	end

	local var5_165 = var14_0(var0_165)
	local var6_165 = arg1_165[var5_165]

	if var5_165 ~= var0_165 and var6_165 then
		local var7_165, var8_165, var9_165 = wordVerMatch(arg0_165, var6_165, arg2_165, arg3_165 + 1, arg2_165.isReplace and arg4_165 .. arg2_165.replaceWord or arg4_165, var6_165.this or arg5_165, var6_165.this and arg3_165 + 1 or arg6_165, var6_165.this and (arg2_165.isReplace and arg4_165 .. arg2_165.replaceWord or arg4_165) or arg7_165)

		if var7_165 then
			return var7_165, var8_165, var9_165
		end
	end

	return arg5_165, arg6_165, arg7_165
end

function wordSplit(arg0_166)
	local var0_166 = {}

	for iter0_166 in arg0_166.gmatch(arg0_166, "[\x01-\x7F�-�][�-�]*") do
		var0_166[#var0_166 + 1] = iter0_166
	end

	return var0_166
end

function contentWrap(arg0_167, arg1_167, arg2_167)
	local var0_167 = LuaHelper.WrapContent(arg0_167, arg1_167, arg2_167)

	return #var0_167 ~= #arg0_167, var0_167
end

function cancelRich(arg0_168)
	local var0_168

	for iter0_168 = 1, 20 do
		local var1_168

		arg0_168, var1_168 = string.gsub(arg0_168, "<([^>]*)>", "%1")

		if var1_168 <= 0 then
			break
		end
	end

	return arg0_168
end

function getSkillConfig(arg0_169)
	local var0_169 = require("GameCfg.buff.buff_" .. arg0_169)

	if not var0_169 then
		warning("找不到技能配置: " .. arg0_169)

		return
	end

	local var1_169 = Clone(var0_169)

	var1_169.name = getSkillName(arg0_169)
	var1_169.desc = HXSet.hxLan(var1_169.desc)
	var1_169.desc_get = HXSet.hxLan(var1_169.desc_get)

	_.each(var1_169, function(arg0_170)
		arg0_170.desc = HXSet.hxLan(arg0_170.desc)
	end)

	return var1_169
end

function getSkillName(arg0_171)
	local var0_171 = pg.skill_data_template[arg0_171] or pg.skill_data_display[arg0_171]

	if var0_171 then
		return HXSet.hxLan(var0_171.name)
	else
		return ""
	end
end

function getSkillDescGet(arg0_172, arg1_172)
	local var0_172 = arg1_172 and pg.skill_world_display[arg0_172] and setmetatable({}, {
		__index = function(arg0_173, arg1_173)
			return pg.skill_world_display[arg0_172][arg1_173] or pg.skill_data_template[arg0_172][arg1_173]
		end
	}) or pg.skill_data_template[arg0_172]

	if not var0_172 then
		return ""
	end

	local var1_172 = var0_172.desc_get ~= "" and var0_172.desc_get or var0_172.desc

	for iter0_172, iter1_172 in pairs(var0_172.desc_get_add) do
		local var2_172 = setColorStr(iter1_172[1], COLOR_GREEN)

		if iter1_172[2] then
			var2_172 = var2_172 .. specialGSub(i18n("word_skill_desc_get"), "$1", setColorStr(iter1_172[2], COLOR_GREEN))
		end

		var1_172 = specialGSub(var1_172, "$" .. iter0_172, var2_172)
	end

	return HXSet.hxLan(var1_172)
end

function getSkillDescLearn(arg0_174, arg1_174, arg2_174)
	local var0_174 = arg2_174 and pg.skill_world_display[arg0_174] and setmetatable({}, {
		__index = function(arg0_175, arg1_175)
			return pg.skill_world_display[arg0_174][arg1_175] or pg.skill_data_template[arg0_174][arg1_175]
		end
	}) or pg.skill_data_template[arg0_174]

	if not var0_174 then
		return ""
	end

	local var1_174 = var0_174.desc

	if not var0_174.desc_add then
		return HXSet.hxLan(var1_174)
	end

	for iter0_174, iter1_174 in pairs(var0_174.desc_add) do
		local var2_174 = iter1_174[arg1_174][1]

		if iter1_174[arg1_174][2] then
			var2_174 = var2_174 .. specialGSub(i18n("word_skill_desc_learn"), "$1", iter1_174[arg1_174][2])
		end

		var1_174 = specialGSub(var1_174, "$" .. iter0_174, setColorStr(var2_174, COLOR_YELLOW))
	end

	return HXSet.hxLan(var1_174)
end

function getSkillDesc(arg0_176, arg1_176, arg2_176)
	local var0_176 = arg2_176 and pg.skill_world_display[arg0_176] and setmetatable({}, {
		__index = function(arg0_177, arg1_177)
			return pg.skill_world_display[arg0_176][arg1_177] or pg.skill_data_template[arg0_176][arg1_177]
		end
	}) or pg.skill_data_template[arg0_176]

	if not var0_176 then
		return ""
	end

	local var1_176 = var0_176.desc

	if not var0_176.desc_add then
		return HXSet.hxLan(var1_176)
	end

	for iter0_176, iter1_176 in pairs(var0_176.desc_add) do
		local var2_176 = setColorStr(iter1_176[arg1_176][1], COLOR_GREEN)

		var1_176 = specialGSub(var1_176, "$" .. iter0_176, var2_176)
	end

	return HXSet.hxLan(var1_176)
end

function specialGSub(arg0_178, arg1_178, arg2_178)
	arg0_178 = string.gsub(arg0_178, "<color=#", "<color=NNN")
	arg0_178 = string.gsub(arg0_178, "#", "")
	arg2_178 = string.gsub(arg2_178, "%%", "%%%%")
	arg0_178 = string.gsub(arg0_178, arg1_178, arg2_178)
	arg0_178 = string.gsub(arg0_178, "<color=NNN", "<color=#")

	return arg0_178
end

function topAnimation(arg0_179, arg1_179, arg2_179, arg3_179, arg4_179, arg5_179)
	local var0_179 = {}

	arg4_179 = arg4_179 or 0.27

	local var1_179 = 0.05

	if arg0_179 then
		local var2_179 = arg0_179.transform.localPosition.x

		setAnchoredPosition(arg0_179, {
			x = var2_179 - 500
		})
		shiftPanel(arg0_179, var2_179, nil, 0.05, arg4_179, true, true)
		setActive(arg0_179, true)
	end

	setActive(arg1_179, false)
	setActive(arg2_179, false)
	setActive(arg3_179, false)

	for iter0_179 = 1, 3 do
		table.insert(var0_179, LeanTween.delayedCall(arg4_179 + 0.13 + var1_179 * iter0_179, System.Action(function()
			if arg1_179 then
				setActive(arg1_179, not arg1_179.gameObject.activeSelf)
			end
		end)).uniqueId)
		table.insert(var0_179, LeanTween.delayedCall(arg4_179 + 0.02 + var1_179 * iter0_179, System.Action(function()
			if arg2_179 then
				setActive(arg2_179, not go(arg2_179).activeSelf)
			end

			if arg2_179 then
				setActive(arg3_179, not go(arg3_179).activeSelf)
			end
		end)).uniqueId)
	end

	if arg5_179 then
		table.insert(var0_179, LeanTween.delayedCall(arg4_179 + 0.13 + var1_179 * 3 + 0.1, System.Action(function()
			arg5_179()
		end)).uniqueId)
	end

	return var0_179
end

function cancelTweens(arg0_183)
	assert(arg0_183, "must provide cancel targets, LeanTween.cancelAll is not allow")

	for iter0_183, iter1_183 in ipairs(arg0_183) do
		if iter1_183 then
			LeanTween.cancel(iter1_183)
		end
	end
end

function getOfflineTimeStamp(arg0_184)
	local var0_184 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_184
	local var1_184 = ""

	if var0_184 <= 59 then
		var1_184 = i18n("just_now")
	elseif var0_184 <= 3599 then
		var1_184 = i18n("several_minutes_before", math.floor(var0_184 / 60))
	elseif var0_184 <= 86399 then
		var1_184 = i18n("several_hours_before", math.floor(var0_184 / 3600))
	else
		var1_184 = i18n("several_days_before", math.floor(var0_184 / 86400))
	end

	return var1_184
end

function playMovie(arg0_185, arg1_185, arg2_185)
	local var0_185 = GameObject.Find("OverlayCamera/Overlay/UITop/MoviePanel")

	if not IsNil(var0_185) then
		pg.UIMgr.GetInstance():LoadingOn()
		WWWLoader.Inst:LoadStreamingAsset(arg0_185, function(arg0_186)
			pg.UIMgr.GetInstance():LoadingOff()

			local var0_186 = GCHandle.Alloc(arg0_186, GCHandleType.Pinned)

			setActive(var0_185, true)

			local var1_186 = var0_185:AddComponent(typeof(CriManaMovieControllerForUI))

			var1_186.player:SetData(arg0_186, arg0_186.Length)

			var1_186.target = var0_185:GetComponent(typeof(Image))
			var1_186.loop = false
			var1_186.additiveMode = false
			var1_186.playOnStart = true

			local var2_186

			var2_186 = Timer.New(function()
				if var1_186.player.status == CriMana.Player.Status.PlayEnd or var1_186.player.status == CriMana.Player.Status.Stop or var1_186.player.status == CriMana.Player.Status.Error then
					var2_186:Stop()
					Object.Destroy(var1_186)
					GCHandle.Free(var0_186)
					setActive(var0_185, false)

					if arg1_185 then
						arg1_185()
					end
				end
			end, 0.2, -1)

			var2_186:Start()
			removeOnButton(var0_185)

			if arg2_185 then
				onButton(nil, var0_185, function()
					var1_186:Stop()
					GetOrAddComponent(var0_185, typeof(Button)).onClick:RemoveAllListeners()
				end, SFX_CANCEL)
			end
		end)
	elseif arg1_185 then
		arg1_185()
	end
end

PaintCameraAdjustOn = false

function cameraPaintViewAdjust(arg0_189)
	if PaintCameraAdjustOn ~= arg0_189 then
		local var0_189 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(CanvasScaler))

		if arg0_189 then
			CameraMgr.instance.AutoAdapt = false

			CameraMgr.instance:Revert()

			var0_189.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight
			var0_189.matchWidthOrHeight = 1
		else
			CameraMgr.instance.AutoAdapt = true
			CameraMgr.instance.CurrentWidth = 1
			CameraMgr.instance.CurrentHeight = 1
			CameraMgr.instance.AspectRatio = 1.77777777777778
			var0_189.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand
		end

		PaintCameraAdjustOn = arg0_189
	end
end

function ManhattonDist(arg0_190, arg1_190)
	return math.abs(arg0_190.row - arg1_190.row) + math.abs(arg0_190.column - arg1_190.column)
end

function checkFirstHelpShow(arg0_191)
	local var0_191 = getProxy(SettingsProxy)

	if not var0_191:checkReadHelp(arg0_191) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[arg0_191].tip
		})
		var0_191:recordReadHelp(arg0_191)
	end
end

preOrientation = nil
preNotchFitterEnabled = false

function openPortrait(arg0_192)
	enableNotch(arg0_192, true)

	preOrientation = Input.deviceOrientation:ToString()

	originalPrint("Begining Orientation:" .. preOrientation)

	Screen.autorotateToPortrait = true
	Screen.autorotateToPortraitUpsideDown = true

	cameraPaintViewAdjust(true)
end

function closePortrait(arg0_193)
	enableNotch(arg0_193, false)

	Screen.autorotateToPortrait = false
	Screen.autorotateToPortraitUpsideDown = false

	originalPrint("Closing Orientation:" .. preOrientation)

	Screen.orientation = ScreenOrientation.LandscapeLeft

	local var0_193 = Timer.New(function()
		Screen.orientation = ScreenOrientation.AutoRotation
	end, 0.2, 1):Start()

	cameraPaintViewAdjust(false)
end

function enableNotch(arg0_195, arg1_195)
	if arg0_195 == nil then
		return
	end

	local var0_195 = arg0_195:GetComponent("NotchAdapt")
	local var1_195 = arg0_195:GetComponent("AspectRatioFitter")

	var0_195.enabled = arg1_195

	if var1_195 then
		if arg1_195 then
			var1_195.enabled = preNotchFitterEnabled
		else
			preNotchFitterEnabled = var1_195.enabled
			var1_195.enabled = false
		end
	end
end

function comma_value(arg0_196)
	local var0_196 = arg0_196
	local var1_196 = 0

	repeat
		local var2_196

		var0_196, var2_196 = string.gsub(var0_196, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var2_196 == 0

	return var0_196
end

local var15_0 = 0.2

function SwitchPanel(arg0_197, arg1_197, arg2_197, arg3_197, arg4_197, arg5_197)
	arg3_197 = defaultValue(arg3_197, var15_0)

	if arg5_197 then
		LeanTween.cancel(go(arg0_197))
	end

	local var0_197 = Vector3.New(tf(arg0_197).localPosition.x, tf(arg0_197).localPosition.y, tf(arg0_197).localPosition.z)

	if arg1_197 then
		var0_197.x = arg1_197
	end

	if arg2_197 then
		var0_197.y = arg2_197
	end

	local var1_197 = LeanTween.move(rtf(arg0_197), var0_197, arg3_197):setEase(LeanTweenType.easeInOutSine)

	if arg4_197 then
		var1_197:setDelay(arg4_197)
	end

	return var1_197
end

function updateActivityTaskStatus(arg0_198)
	local var0_198 = arg0_198:getConfig("config_id")
	local var1_198, var2_198 = getActivityTask(arg0_198, true)

	if not var2_198 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_198.id
		})

		return true
	end

	return false
end

function updateCrusingActivityTask(arg0_199)
	local var0_199 = getProxy(TaskProxy)
	local var1_199 = arg0_199:getNDay()

	for iter0_199, iter1_199 in ipairs(arg0_199:getConfig("config_data")) do
		local var2_199 = pg.battlepass_task_group[iter1_199]

		if var1_199 >= var2_199.time and underscore.any(underscore.flatten(var2_199.task_group), function(arg0_200)
			return var0_199:getTaskVO(arg0_200) == nil
		end) then
			pg.m02:sendNotification(GAME.CRUSING_CMD, {
				cmd = 1,
				activity_id = arg0_199.id
			})

			return true
		end
	end

	return false
end

function setShipCardFrame(arg0_201, arg1_201, arg2_201)
	arg0_201.localScale = Vector3.one
	arg0_201.anchorMin = Vector2.zero
	arg0_201.anchorMax = Vector2.one

	local var0_201 = arg2_201 or arg1_201

	GetImageSpriteFromAtlasAsync("shipframe", var0_201, arg0_201)

	local var1_201 = pg.frame_resource[var0_201]

	if var1_201 then
		local var2_201 = var1_201.param

		arg0_201.offsetMin = Vector2(var2_201[1], var2_201[2])
		arg0_201.offsetMax = Vector2(var2_201[3], var2_201[4])
	else
		arg0_201.offsetMin = Vector2.zero
		arg0_201.offsetMax = Vector2.zero
	end
end

function setRectShipCardFrame(arg0_202, arg1_202, arg2_202)
	arg0_202.localScale = Vector3.one
	arg0_202.anchorMin = Vector2.zero
	arg0_202.anchorMax = Vector2.one

	setImageSprite(arg0_202, GetSpriteFromAtlas("shipframeb", "b" .. (arg2_202 or arg1_202)))

	local var0_202 = "b" .. (arg2_202 or arg1_202)
	local var1_202 = pg.frame_resource[var0_202]

	if var1_202 then
		local var2_202 = var1_202.param

		arg0_202.offsetMin = Vector2(var2_202[1], var2_202[2])
		arg0_202.offsetMax = Vector2(var2_202[3], var2_202[4])
	else
		arg0_202.offsetMin = Vector2.zero
		arg0_202.offsetMax = Vector2.zero
	end
end

function setFrameEffect(arg0_203, arg1_203)
	if arg1_203 then
		local var0_203 = arg1_203 .. "(Clone)"
		local var1_203 = false

		eachChild(arg0_203, function(arg0_204)
			setActive(arg0_204, arg0_204.name == var0_203)

			var1_203 = var1_203 or arg0_204.name == var0_203
		end)

		if not var1_203 then
			LoadAndInstantiateAsync("effect", arg1_203, function(arg0_205)
				if IsNil(arg0_203) or findTF(arg0_203, var0_203) then
					Object.Destroy(arg0_205)
				else
					setParent(arg0_205, arg0_203)
					setActive(arg0_205, true)
				end
			end)
		end
	end

	setActive(arg0_203, arg1_203)
end

function setProposeMarkIcon(arg0_206, arg1_206)
	local var0_206 = arg0_206:Find("proposeShipCard(Clone)")
	local var1_206 = arg1_206.propose and not arg1_206:ShowPropose()

	if var0_206 then
		setActive(var0_206, var1_206)
	elseif var1_206 then
		pg.PoolMgr.GetInstance():GetUI("proposeShipCard", true, function(arg0_207)
			if IsNil(arg0_206) or arg0_206:Find("proposeShipCard(Clone)") then
				pg.PoolMgr.GetInstance():ReturnUI("proposeShipCard", arg0_207)
			else
				setParent(arg0_207, arg0_206, false)
			end
		end)
	end
end

function flushShipCard(arg0_208, arg1_208)
	local var0_208 = arg1_208:rarity2bgPrint()
	local var1_208 = findTF(arg0_208, "content/bg")

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var0_208, "", var1_208)

	local var2_208 = findTF(arg0_208, "content/ship_icon")
	local var3_208 = arg1_208 and {
		"shipYardIcon/" .. arg1_208:getPainting(),
		arg1_208:getPainting()
	} or {
		"shipYardIcon/unknown",
		""
	}

	GetImageSpriteFromAtlasAsync(var3_208[1], var3_208[2], var2_208)

	local var4_208 = arg1_208:getShipType()
	local var5_208 = findTF(arg0_208, "content/info/top/type")

	GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var4_208), var5_208)
	setText(findTF(arg0_208, "content/dockyard/lv/Text"), defaultValue(arg1_208.level, 1))

	local var6_208 = arg1_208:getStar()
	local var7_208 = arg1_208:getMaxStar()
	local var8_208 = findTF(arg0_208, "content/front/stars")

	setActive(var8_208, true)

	local var9_208 = findTF(var8_208, "star_tpl")
	local var10_208 = var8_208.childCount

	for iter0_208 = 1, Ship.CONFIG_MAX_STAR do
		local var11_208 = var10_208 < iter0_208 and cloneTplTo(var9_208, var8_208) or var8_208:GetChild(iter0_208 - 1)

		setActive(var11_208, iter0_208 <= var7_208)
		triggerToggle(var11_208, iter0_208 <= var6_208)
	end

	local var12_208 = findTF(arg0_208, "content/front/frame")
	local var13_208, var14_208 = arg1_208:GetFrameAndEffect()

	setShipCardFrame(var12_208, var0_208, var13_208)
	setFrameEffect(findTF(arg0_208, "content/front/bg_other"), var14_208)
	setProposeMarkIcon(arg0_208:Find("content/dockyard/propose"), arg1_208)
end

function TweenItemAlphaAndWhite(arg0_209)
	LeanTween.cancel(arg0_209)

	local var0_209 = GetOrAddComponent(arg0_209, "CanvasGroup")

	var0_209.alpha = 0

	LeanTween.alphaCanvas(var0_209, 1, 0.2):setUseEstimatedTime(true)

	local var1_209 = findTF(arg0_209.transform, "white_mask")

	if var1_209 then
		setActive(var1_209, false)
	end
end

function ClearTweenItemAlphaAndWhite(arg0_210)
	LeanTween.cancel(arg0_210)

	GetOrAddComponent(arg0_210, "CanvasGroup").alpha = 0
end

function getGroupOwnSkins(arg0_211)
	local var0_211 = {}
	local var1_211 = getProxy(ShipSkinProxy):getSkinList()
	local var2_211 = getProxy(CollectionProxy):getShipGroup(arg0_211)

	if var2_211 then
		local var3_211 = ShipGroup.getSkinList(arg0_211)

		for iter0_211, iter1_211 in ipairs(var3_211) do
			if iter1_211.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var1_211, iter1_211.id) or iter1_211.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var2_211.trans or iter1_211.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var2_211.married == 1 then
				var0_211[iter1_211.id] = true
			end
		end
	end

	return var0_211
end

function split(arg0_212, arg1_212)
	local var0_212 = {}

	if not arg0_212 then
		return nil
	end

	local var1_212 = #arg0_212
	local var2_212 = 1

	while var2_212 <= var1_212 do
		local var3_212 = string.find(arg0_212, arg1_212, var2_212)

		if var3_212 == nil then
			table.insert(var0_212, string.sub(arg0_212, var2_212, var1_212))

			break
		end

		table.insert(var0_212, string.sub(arg0_212, var2_212, var3_212 - 1))

		if var3_212 == var1_212 then
			table.insert(var0_212, "")

			break
		end

		var2_212 = var3_212 + 1
	end

	return var0_212
end

function NumberToChinese(arg0_213, arg1_213)
	local var0_213 = ""
	local var1_213 = #arg0_213

	for iter0_213 = 1, var1_213 do
		local var2_213 = string.sub(arg0_213, iter0_213, iter0_213)

		if var2_213 ~= "0" or var2_213 == "0" and not arg1_213 then
			if arg1_213 then
				if var1_213 >= 2 then
					if iter0_213 == 1 then
						if var2_213 == "1" then
							var0_213 = i18n("number_" .. 10)
						else
							var0_213 = i18n("number_" .. var2_213) .. i18n("number_" .. 10)
						end
					else
						var0_213 = var0_213 .. i18n("number_" .. var2_213)
					end
				else
					var0_213 = var0_213 .. i18n("number_" .. var2_213)
				end
			else
				var0_213 = var0_213 .. i18n("number_" .. var2_213)
			end
		end
	end

	return var0_213
end

function getActivityTask(arg0_214, arg1_214)
	local var0_214 = getProxy(TaskProxy)
	local var1_214 = arg0_214:getConfig("config_data")
	local var2_214 = arg0_214:getNDay(arg0_214.data1)
	local var3_214
	local var4_214
	local var5_214

	for iter0_214 = math.max(arg0_214.data3, 1), math.min(var2_214, #var1_214) do
		local var6_214 = _.flatten({
			var1_214[iter0_214]
		})

		for iter1_214, iter2_214 in ipairs(var6_214) do
			local var7_214 = var0_214:getTaskById(iter2_214)

			if var7_214 then
				return var7_214.id, var7_214
			end

			if var4_214 then
				var5_214 = var0_214:getFinishTaskById(iter2_214)

				if var5_214 then
					var4_214 = var5_214
				elseif arg1_214 then
					return iter2_214
				else
					return var4_214.id, var4_214
				end
			else
				var4_214 = var0_214:getFinishTaskById(iter2_214)
				var5_214 = var5_214 or iter2_214
			end
		end
	end

	if var4_214 then
		return var4_214.id, var4_214
	else
		return var5_214
	end
end

function setImageFromImage(arg0_215, arg1_215, arg2_215)
	local var0_215 = GetComponent(arg0_215, "Image")

	var0_215.sprite = GetComponent(arg1_215, "Image").sprite

	if arg2_215 then
		var0_215:SetNativeSize()
	end
end

function skinTimeStamp(arg0_216)
	local var0_216, var1_216, var2_216, var3_216 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_216)

	if var0_216 >= 1 then
		return i18n("limit_skin_time_day", var0_216)
	elseif var0_216 <= 0 and var1_216 > 0 then
		return i18n("limit_skin_time_day_min", var1_216, var2_216)
	elseif var0_216 <= 0 and var1_216 <= 0 and (var2_216 > 0 or var3_216 > 0) then
		return i18n("limit_skin_time_min", math.max(var2_216, 1))
	elseif var0_216 <= 0 and var1_216 <= 0 and var2_216 <= 0 and var3_216 <= 0 then
		return i18n("limit_skin_time_overtime")
	end
end

function skinCommdityTimeStamp(arg0_217)
	local var0_217 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_217 = math.max(arg0_217 - var0_217, 0)
	local var2_217 = math.floor(var1_217 / 86400)

	if var2_217 > 0 then
		return i18n("time_remaining_tip") .. var2_217 .. i18n("word_date")
	else
		local var3_217 = math.floor(var1_217 / 3600)

		if var3_217 > 0 then
			return i18n("time_remaining_tip") .. var3_217 .. i18n("word_hour")
		else
			local var4_217 = math.floor(var1_217 / 60)

			if var4_217 > 0 then
				return i18n("time_remaining_tip") .. var4_217 .. i18n("word_minute")
			else
				return i18n("time_remaining_tip") .. var1_217 .. i18n("word_second")
			end
		end
	end
end

function InstagramTimeStamp(arg0_218)
	local var0_218 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_218
	local var1_218 = var0_218 / 86400

	if var1_218 > 1 then
		return i18n("ins_word_day", math.floor(var1_218))
	else
		local var2_218 = var0_218 / 3600

		if var2_218 > 1 then
			return i18n("ins_word_hour", math.floor(var2_218))
		else
			local var3_218 = var0_218 / 60

			if var3_218 > 1 then
				return i18n("ins_word_minu", math.floor(var3_218))
			else
				return i18n("ins_word_minu", 1)
			end
		end
	end
end

function InstagramReplyTimeStamp(arg0_219)
	local var0_219 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_219
	local var1_219 = var0_219 / 86400

	if var1_219 > 1 then
		return i18n1(math.floor(var1_219) .. "d")
	else
		local var2_219 = var0_219 / 3600

		if var2_219 > 1 then
			return i18n1(math.floor(var2_219) .. "h")
		else
			local var3_219 = var0_219 / 60

			if var3_219 > 1 then
				return i18n1(math.floor(var3_219) .. "min")
			else
				return i18n1("1min")
			end
		end
	end
end

function attireTimeStamp(arg0_220)
	local var0_220, var1_220, var2_220, var3_220 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_220)

	if var0_220 <= 0 and var1_220 <= 0 and var2_220 <= 0 and var3_220 <= 0 then
		return i18n("limit_skin_time_overtime")
	else
		return i18n("attire_time_stamp", var0_220, var1_220, var2_220)
	end
end

function checkExist(arg0_221, ...)
	local var0_221 = {
		...
	}

	for iter0_221, iter1_221 in ipairs(var0_221) do
		if arg0_221 == nil then
			break
		end

		assert(type(arg0_221) == "table", "type error : intermediate target should be table")
		assert(type(iter1_221) == "table", "type error : param should be table")

		if type(arg0_221[iter1_221[1]]) == "function" then
			arg0_221 = arg0_221[iter1_221[1]](arg0_221, unpack(iter1_221[2] or {}))
		else
			arg0_221 = arg0_221[iter1_221[1]]
		end
	end

	return arg0_221
end

function AcessWithinNull(arg0_222, arg1_222)
	if arg0_222 == nil then
		return
	end

	assert(type(arg0_222) == "table")

	return arg0_222[arg1_222]
end

function showRepairMsgbox()
	local var0_223 = {
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var1_223 = {
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var2_223 = {
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
			var2_223,
			var1_223,
			var0_223
		}
	})
end

function resourceVerify(arg0_227, arg1_227)
	if CSharpVersion > 35 then
		BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()

		return
	end

	local var0_227 = Application.persistentDataPath .. "/hashes.csv"
	local var1_227
	local var2_227 = PathMgr.ReadAllLines(var0_227)
	local var3_227 = {}

	if arg0_227 then
		setActive(arg0_227, true)
	else
		pg.UIMgr.GetInstance():LoadingOn()
	end

	local function var4_227()
		if arg0_227 then
			setActive(arg0_227, false)
		else
			pg.UIMgr.GetInstance():LoadingOff()
		end

		print(var1_227)

		if var1_227 then
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

	local var5_227 = var2_227.Length
	local var6_227

	local function var7_227(arg0_230)
		if arg0_230 < 0 then
			var4_227()

			return
		end

		if arg1_227 then
			setSlider(arg1_227, 0, var5_227, var5_227 - arg0_230)
		end

		local var0_230 = string.split(var2_227[arg0_230], ",")
		local var1_230 = var0_230[1]
		local var2_230 = var0_230[3]
		local var3_230 = PathMgr.getAssetBundle(var1_230)

		if PathMgr.FileExists(var3_230) then
			local var4_230 = PathMgr.ReadAllBytes(PathMgr.getAssetBundle(var1_230))

			if var2_230 == HashUtil.CalcMD5(var4_230) then
				onNextTick(function()
					var7_227(arg0_230 - 1)
				end)

				return
			end
		end

		var1_227 = var1_230

		var4_227()
	end

	var7_227(var5_227 - 1)
end

function splitByWordEN(arg0_232, arg1_232)
	local var0_232 = string.split(arg0_232, " ")
	local var1_232 = ""
	local var2_232 = ""
	local var3_232 = arg1_232:GetComponent(typeof(RectTransform))
	local var4_232 = arg1_232:GetComponent(typeof(Text))
	local var5_232 = var3_232.rect.width

	for iter0_232, iter1_232 in ipairs(var0_232) do
		local var6_232 = var2_232

		var2_232 = var2_232 == "" and iter1_232 or var2_232 .. " " .. iter1_232

		setText(arg1_232, var2_232)

		if var5_232 < var4_232.preferredWidth then
			var1_232 = var1_232 == "" and var6_232 or var1_232 .. "\n" .. var6_232
			var2_232 = iter1_232
		end

		if iter0_232 >= #var0_232 then
			var1_232 = var1_232 == "" and var2_232 or var1_232 .. "\n" .. var2_232
		end
	end

	return var1_232
end

function checkBirthFormat(arg0_233)
	if #arg0_233 ~= 8 then
		return false
	end

	local var0_233 = 0
	local var1_233 = #arg0_233

	while var0_233 < var1_233 do
		local var2_233 = string.byte(arg0_233, var0_233 + 1)

		if var2_233 < 48 or var2_233 > 57 then
			return false
		end

		var0_233 = var0_233 + 1
	end

	return true
end

function isHalfBodyLive2D(arg0_234)
	local var0_234 = {
		"biaoqiang",
		"z23",
		"lafei",
		"lingbo",
		"mingshi",
		"xuefeng"
	}

	return _.any(var0_234, function(arg0_235)
		return arg0_235 == arg0_234
	end)
end

function GetServerState(arg0_236)
	local var0_236 = -1
	local var1_236 = 0
	local var2_236 = 1
	local var3_236 = 2
	local var4_236 = NetConst.GetServerStateUrl()

	if PLATFORM_CODE == PLATFORM_CH then
		var4_236 = string.gsub(var4_236, "https", "http")
	end

	VersionMgr.Inst:WebRequest(var4_236, function(arg0_237, arg1_237)
		local var0_237 = true
		local var1_237 = false

		for iter0_237 in string.gmatch(arg1_237, "\"state\":%d") do
			if iter0_237 ~= "\"state\":1" then
				var0_237 = false
			end

			var1_237 = true
		end

		if not var1_237 then
			var0_237 = false
		end

		if arg0_236 ~= nil then
			arg0_236(var0_237 and var2_236 or var1_236)
		end
	end)
end

function setScrollText(arg0_238, arg1_238)
	GetOrAddComponent(arg0_238, "ScrollText"):SetText(arg1_238)
end

function changeToScrollText(arg0_239, arg1_239)
	local var0_239 = GetComponent(arg0_239, typeof(Text))

	assert(var0_239, "without component<Text>")

	local var1_239 = arg0_239:Find("subText")

	if not var1_239 then
		var1_239 = cloneTplTo(arg0_239, arg0_239, "subText")

		eachChild(arg0_239, function(arg0_240)
			setActive(arg0_240, arg0_240 == var1_239)
		end)

		arg0_239:GetComponent(typeof(Text)).enabled = false
	end

	setScrollText(var1_239, arg1_239)
end

local var16_0
local var17_0
local var18_0
local var19_0

local function var20_0(arg0_241, arg1_241, arg2_241)
	local var0_241 = arg0_241:Find("base")
	local var1_241, var2_241, var3_241 = Equipment.GetInfoTrans(arg1_241, arg2_241)

	if arg1_241.nextValue then
		local var4_241 = {
			name = arg1_241.name,
			type = arg1_241.type,
			value = arg1_241.nextValue
		}
		local var5_241, var6_241 = Equipment.GetInfoTrans(var4_241, arg2_241)

		var2_241 = var2_241 .. setColorStr("   >   " .. var6_241, COLOR_GREEN)
	end

	setText(var0_241:Find("name"), var1_241)

	if var3_241 then
		local var7_241 = "<color=#afff72>(+" .. ys.Battle.BattleConst.UltimateBonus.AuxBoostValue * 100 .. "%)</color>"

		setText(var0_241:Find("value"), var2_241 .. var7_241)
	else
		setText(var0_241:Find("value"), var2_241)
	end

	setActive(var0_241:Find("value/up"), arg1_241.compare and arg1_241.compare > 0)
	setActive(var0_241:Find("value/down"), arg1_241.compare and arg1_241.compare < 0)
	triggerToggle(var0_241, arg1_241.lock_open)

	if not arg1_241.lock_open and arg1_241.sub and #arg1_241.sub > 0 then
		GetComponent(var0_241, typeof(Toggle)).enabled = true
	else
		setActive(var0_241:Find("name/close"), false)
		setActive(var0_241:Find("name/open"), false)

		GetComponent(var0_241, typeof(Toggle)).enabled = false
	end
end

local function var21_0(arg0_242, arg1_242, arg2_242, arg3_242)
	var20_0(arg0_242, arg2_242, arg3_242)

	if not arg2_242.sub or #arg2_242.sub == 0 then
		return
	end

	var18_0(arg0_242:Find("subs"), arg1_242, arg2_242.sub, arg3_242)
end

function var18_0(arg0_243, arg1_243, arg2_243, arg3_243)
	removeAllChildren(arg0_243)
	var19_0(arg0_243, arg1_243, arg2_243, arg3_243)
end

function var19_0(arg0_244, arg1_244, arg2_244, arg3_244)
	for iter0_244, iter1_244 in ipairs(arg2_244) do
		local var0_244 = cloneTplTo(arg1_244, arg0_244)

		var21_0(var0_244, arg1_244, iter1_244, arg3_244)
	end
end

function updateEquipInfo(arg0_245, arg1_245, arg2_245, arg3_245)
	local var0_245 = arg0_245:Find("attr_tpl")

	var18_0(arg0_245:Find("attrs"), var0_245, arg1_245.attrs, arg3_245)
	setActive(arg0_245:Find("skill"), arg2_245)

	if arg2_245 then
		var21_0(arg0_245:Find("skill/attr"), var0_245, {
			name = i18n("skill"),
			value = setColorStr(arg2_245.name, "#FFDE00FF")
		}, arg3_245)
		setText(arg0_245:Find("skill/value/Text"), getSkillDescGet(arg2_245.id))
	end

	setActive(arg0_245:Find("weapon"), #arg1_245.weapon.sub > 0)

	if #arg1_245.weapon.sub > 0 then
		var18_0(arg0_245:Find("weapon"), var0_245, {
			arg1_245.weapon
		}, arg3_245)
	end

	setActive(arg0_245:Find("equip_info"), #arg1_245.equipInfo.sub > 0)

	if #arg1_245.equipInfo.sub > 0 then
		var18_0(arg0_245:Find("equip_info"), var0_245, {
			arg1_245.equipInfo
		}, arg3_245)
	end

	var21_0(arg0_245:Find("part/attr"), var0_245, {
		name = i18n("equip_info_23")
	}, arg3_245)

	local var1_245 = arg0_245:Find("part/value")
	local var2_245 = var1_245:Find("label")
	local var3_245 = {}
	local var4_245 = {}

	if #arg1_245.part[1] == 0 and #arg1_245.part[2] == 0 then
		setmetatable(var3_245, {
			__index = function(arg0_246, arg1_246)
				return true
			end
		})
		setmetatable(var4_245, {
			__index = function(arg0_247, arg1_247)
				return true
			end
		})
	else
		for iter0_245, iter1_245 in ipairs(arg1_245.part[1]) do
			var3_245[iter1_245] = true
		end

		for iter2_245, iter3_245 in ipairs(arg1_245.part[2]) do
			var4_245[iter3_245] = true
		end
	end

	local var5_245 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var3_245, var4_245)

	UIItemList.StaticAlign(var1_245, var2_245, #var5_245, function(arg0_248, arg1_248, arg2_248)
		arg1_248 = arg1_248 + 1

		if arg0_248 == UIItemList.EventUpdate then
			local var0_248 = var5_245[arg1_248]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0_248), arg2_248)
			setActive(arg2_248:Find("main"), var3_245[var0_248] and not var4_245[var0_248])
			setActive(arg2_248:Find("sub"), var4_245[var0_248] and not var3_245[var0_248])
			setImageAlpha(arg2_248, not var3_245[var0_248] and not var4_245[var0_248] and 0.3 or 1)
		end
	end)
end

function updateEquipUpgradeInfo(arg0_249, arg1_249, arg2_249)
	local var0_249 = arg0_249:Find("attr_tpl")

	var18_0(arg0_249:Find("attrs"), var0_249, arg1_249.attrs, arg2_249)
	setActive(arg0_249:Find("weapon"), #arg1_249.weapon.sub > 0)

	if #arg1_249.weapon.sub > 0 then
		var18_0(arg0_249:Find("weapon"), var0_249, {
			arg1_249.weapon
		}, arg2_249)
	end

	setActive(arg0_249:Find("equip_info"), #arg1_249.equipInfo.sub > 0)

	if #arg1_249.equipInfo.sub > 0 then
		var18_0(arg0_249:Find("equip_info"), var0_249, {
			arg1_249.equipInfo
		}, arg2_249)
	end
end

function setCanvasOverrideSorting(arg0_250, arg1_250)
	local var0_250 = arg0_250.parent

	arg0_250:SetParent(pg.LayerWeightMgr.GetInstance().uiOrigin, false)

	if isActive(arg0_250) then
		GetOrAddComponent(arg0_250, typeof(Canvas)).overrideSorting = arg1_250
	else
		setActive(arg0_250, true)

		GetOrAddComponent(arg0_250, typeof(Canvas)).overrideSorting = arg1_250

		setActive(arg0_250, false)
	end

	arg0_250:SetParent(var0_250, false)
end

function createNewGameObject(arg0_251, arg1_251)
	local var0_251 = GameObject.New()

	if arg0_251 then
		var0_251.name = "model"
	end

	var0_251.layer = arg1_251 or Layer.UI

	return GetOrAddComponent(var0_251, "RectTransform")
end

function CreateShell(arg0_252)
	if type(arg0_252) ~= "table" and type(arg0_252) ~= "userdata" then
		return arg0_252
	end

	local var0_252 = setmetatable({
		__index = arg0_252
	}, arg0_252)

	return setmetatable({}, var0_252)
end

function CameraFittingSettin(arg0_253)
	local var0_253 = GetComponent(arg0_253, typeof(Camera))
	local var1_253 = 1.77777777777778
	local var2_253 = Screen.width / Screen.height

	if var2_253 < var1_253 then
		local var3_253 = var2_253 / var1_253

		var0_253.rect = var0_0.Rect.New(0, (1 - var3_253) / 2, 1, var3_253)
	end
end

function SwitchSpecialChar(arg0_254, arg1_254)
	if PLATFORM_CODE ~= PLATFORM_US then
		arg0_254 = arg0_254:gsub(" ", " ")
		arg0_254 = arg0_254:gsub("\t", "    ")
	end

	if not arg1_254 then
		arg0_254 = arg0_254:gsub("\n", " ")
	end

	return arg0_254
end

function AfterCheck(arg0_255, arg1_255)
	local var0_255 = {}

	for iter0_255, iter1_255 in ipairs(arg0_255) do
		var0_255[iter0_255] = iter1_255[1]()
	end

	arg1_255()

	for iter2_255, iter3_255 in ipairs(arg0_255) do
		if var0_255[iter2_255] ~= iter3_255[1]() then
			iter3_255[2]()
		end

		var0_255[iter2_255] = iter3_255[1]()
	end
end

function CompareFuncs(arg0_256, arg1_256)
	local var0_256 = {}

	local function var1_256(arg0_257, arg1_257)
		var0_256[arg0_257] = var0_256[arg0_257] or {}
		var0_256[arg0_257][arg1_257] = var0_256[arg0_257][arg1_257] or arg0_256[arg0_257](arg1_257)

		return var0_256[arg0_257][arg1_257]
	end

	return function(arg0_258, arg1_258)
		local var0_258 = 1

		while var0_258 <= #arg0_256 do
			local var1_258 = var1_256(var0_258, arg0_258)
			local var2_258 = var1_256(var0_258, arg1_258)

			if var1_258 == var2_258 then
				var0_258 = var0_258 + 1
			else
				return var1_258 < var2_258
			end
		end

		return tobool(arg1_256)
	end
end

function DropResultIntegration(arg0_259)
	local var0_259 = {}
	local var1_259 = 1

	while var1_259 <= #arg0_259 do
		local var2_259 = arg0_259[var1_259].type
		local var3_259 = arg0_259[var1_259].id

		var0_259[var2_259] = var0_259[var2_259] or {}

		if var0_259[var2_259][var3_259] then
			local var4_259 = arg0_259[var0_259[var2_259][var3_259]]
			local var5_259 = table.remove(arg0_259, var1_259)

			var4_259.count = var4_259.count + var5_259.count
		else
			var0_259[var2_259][var3_259] = var1_259
			var1_259 = var1_259 + 1
		end
	end

	local var6_259 = {
		function(arg0_260)
			local var0_260 = arg0_260.type
			local var1_260 = arg0_260.id

			if var0_260 == DROP_TYPE_SHIP then
				return 1
			elseif var0_260 == DROP_TYPE_RESOURCE then
				if var1_260 == 1 then
					return 2
				else
					return 3
				end
			elseif var0_260 == DROP_TYPE_ITEM then
				if var1_260 == 59010 then
					return 4
				elseif var1_260 == 59900 then
					return 5
				else
					local var2_260 = Item.getConfigData(var1_260)
					local var3_260 = var2_260 and var2_260.type or 0

					if var3_260 == 9 then
						return 6
					elseif var3_260 == 5 then
						return 7
					elseif var3_260 == 4 then
						return 8
					elseif var3_260 == 7 then
						return 9
					end
				end
			elseif var0_260 == DROP_TYPE_VITEM and var1_260 == 59011 then
				return 4
			end

			return 100
		end,
		function(arg0_261)
			local var0_261

			if arg0_261.type == DROP_TYPE_SHIP then
				var0_261 = pg.ship_data_statistics[arg0_261.id]
			elseif arg0_261.type == DROP_TYPE_ITEM then
				var0_261 = Item.getConfigData(arg0_261.id)
			end

			return (var0_261 and var0_261.rarity or 0) * -1
		end,
		function(arg0_262)
			return arg0_262.id
		end
	}

	table.sort(arg0_259, CompareFuncs(var6_259))
end

function getLoginConfig()
	local var0_263 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_263 = 1

	for iter0_263, iter1_263 in ipairs(pg.login.all) do
		if pg.login[iter1_263].date ~= "stop" then
			local var2_263, var3_263 = parseTimeConfig(pg.login[iter1_263].date)

			assert(not var3_263)

			if pg.TimeMgr.GetInstance():inTime(var2_263, var0_263) then
				var1_263 = iter1_263

				break
			end
		end
	end

	local var4_263 = pg.login[var1_263].login_static

	var4_263 = var4_263 ~= "" and var4_263 or "login"

	local var5_263 = pg.login[var1_263].login_cri
	local var6_263 = var5_263 ~= "" and true or false
	local var7_263 = pg.login[var1_263].op_play == 1 and true or false
	local var8_263 = pg.login[var1_263].op_time

	if var8_263 == "" or not pg.TimeMgr.GetInstance():inTime(var8_263, var0_263) then
		var7_263 = false
	end

	local var9_263 = var8_263 == "" and var8_263 or table.concat(var8_263[1][1])

	return var6_263, var6_263 and var5_263 or var4_263, pg.login[var1_263].bgm, var7_263, var9_263
end

function setIntimacyIcon(arg0_264, arg1_264, arg2_264)
	local var0_264 = {}
	local var1_264

	seriesAsync({
		function(arg0_265)
			if arg0_264.childCount > 0 then
				var1_264 = arg0_264:GetChild(0)

				arg0_265()
			else
				LoadAndInstantiateAsync("template", "intimacytpl", function(arg0_266)
					var1_264 = tf(arg0_266)

					setParent(var1_264, arg0_264)
					arg0_265()
				end)
			end
		end,
		function(arg0_267)
			setImageAlpha(var1_264, arg2_264 and 0 or 1)
			eachChild(var1_264, function(arg0_268)
				setActive(arg0_268, false)
			end)

			if arg2_264 then
				local var0_267 = var1_264:Find(arg2_264 .. "(Clone)")

				if not var0_267 then
					LoadAndInstantiateAsync("ui", arg2_264, function(arg0_269)
						setParent(arg0_269, var1_264)
						setActive(arg0_269, true)
					end)
				else
					setActive(var0_267, true)
				end
			elseif arg1_264 then
				setImageSprite(var1_264, GetSpriteFromAtlas("energy", arg1_264), true)
			else
				assert(false, "param error")
			end
		end
	})
end

local var22_0

function nowWorld()
	var22_0 = var22_0 or getProxy(WorldProxy)

	return var22_0 and var22_0.world
end

function removeWorld()
	var22_0.world:Dispose()

	var22_0.world = nil
	var22_0 = nil
end

function switch(arg0_272, arg1_272, arg2_272, ...)
	if arg1_272[arg0_272] then
		return arg1_272[arg0_272](...)
	elseif arg2_272 then
		return arg2_272(...)
	end
end

function parseTimeConfig(arg0_273)
	if type(arg0_273[1]) == "table" then
		return arg0_273[2], arg0_273[1]
	else
		return arg0_273
	end
end

local var23_0 = {
	__add = function(arg0_274, arg1_274)
		return NewPos(arg0_274.x + arg1_274.x, arg0_274.y + arg1_274.y)
	end,
	__sub = function(arg0_275, arg1_275)
		return NewPos(arg0_275.x - arg1_275.x, arg0_275.y - arg1_275.y)
	end,
	__mul = function(arg0_276, arg1_276)
		if type(arg1_276) == "number" then
			return NewPos(arg0_276.x * arg1_276, arg0_276.y * arg1_276)
		else
			return NewPos(arg0_276.x * arg1_276.x, arg0_276.y * arg1_276.y)
		end
	end,
	__eq = function(arg0_277, arg1_277)
		return arg0_277.x == arg1_277.x and arg0_277.y == arg1_277.y
	end,
	__tostring = function(arg0_278)
		return arg0_278.x .. "_" .. arg0_278.y
	end
}

function NewPos(arg0_279, arg1_279)
	assert(arg0_279 and arg1_279)

	local var0_279 = setmetatable({
		x = arg0_279,
		y = arg1_279
	}, var23_0)

	function var0_279.SqrMagnitude(arg0_280)
		return arg0_280.x * arg0_280.x + arg0_280.y * arg0_280.y
	end

	function var0_279.Normalize(arg0_281)
		local var0_281 = arg0_281:SqrMagnitude()

		if var0_281 > 1e-05 then
			return arg0_281 * (1 / math.sqrt(var0_281))
		else
			return NewPos(0, 0)
		end
	end

	return var0_279
end

local var24_0

function Timekeeping()
	warning(Time.realtimeSinceStartup - (var24_0 or Time.realtimeSinceStartup), Time.realtimeSinceStartup)

	var24_0 = Time.realtimeSinceStartup
end

function GetRomanDigit(arg0_283)
	return (string.char(226, 133, 160 + (arg0_283 - 1)))
end

function quickPlayAnimator(arg0_284, arg1_284)
	arg0_284:GetComponent(typeof(Animator)):Play(arg1_284, -1, 0)
end

function quickCheckAndPlayAnimator(arg0_285, arg1_285)
	local var0_285 = arg0_285:GetComponent(typeof(Animator))
	local var1_285 = Animator.StringToHash(arg1_285)

	if var0_285:HasState(0, var1_285) then
		var0_285:Play(arg1_285, -1, 0)
	end
end

function quickPlayAnimation(arg0_286, arg1_286)
	arg0_286:GetComponent(typeof(Animation)):Play(arg1_286)
end

function getSurveyUrl(arg0_287)
	local var0_287 = pg.survey_data_template[arg0_287]
	local var1_287

	if not IsUnityEditor then
		if PLATFORM_CODE == PLATFORM_CH then
			local var2_287 = getProxy(UserProxy):GetCacheGatewayInServerLogined()

			if var2_287 == PLATFORM_ANDROID then
				if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_BILI then
					var1_287 = var0_287.main_url
				else
					var1_287 = var0_287.uo_url
				end
			elseif var2_287 == PLATFORM_IPHONEPLAYER then
				var1_287 = var0_287.ios_url
			end
		elseif PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
			var1_287 = var0_287.main_url
		end
	else
		var1_287 = var0_287.main_url
	end

	local var3_287 = getProxy(PlayerProxy):getRawData().id
	local var4_287 = getProxy(UserProxy):getRawData().arg2 or ""
	local var5_287
	local var6_287 = PLATFORM == PLATFORM_ANDROID and 1 or PLATFORM == PLATFORM_IPHONEPLAYER and 2 or 3
	local var7_287 = getProxy(UserProxy):getRawData()
	local var8_287 = getProxy(ServerProxy):getRawData()[var7_287 and var7_287.server or 0]
	local var9_287 = var8_287 and var8_287.id or ""
	local var10_287 = getProxy(PlayerProxy):getRawData().level
	local var11_287 = var3_287 .. "_" .. arg0_287
	local var12_287 = var1_287
	local var13_287 = {
		var3_287,
		var4_287,
		var6_287,
		var9_287,
		var10_287,
		var11_287
	}

	if var12_287 then
		for iter0_287, iter1_287 in ipairs(var13_287) do
			var12_287 = string.gsub(var12_287, "$" .. iter0_287, tostring(iter1_287))
		end
	end

	warning(var12_287)

	return var12_287
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

function FilterVarchar(arg0_289)
	assert(type(arg0_289) == "string" or type(arg0_289) == "table")

	if arg0_289 == "" then
		return nil
	end

	return arg0_289
end

function getGameset(arg0_290)
	local var0_290 = pg.gameset[arg0_290]

	assert(var0_290)

	return {
		var0_290.key_value,
		var0_290.description
	}
end

function getDorm3dGameset(arg0_291)
	local var0_291 = pg.dorm3d_set[arg0_291]

	assert(var0_291)

	return {
		var0_291.key_value_int,
		var0_291.key_value_varchar
	}
end

function GetItemsOverflowDic(arg0_292)
	arg0_292 = arg0_292 or {}

	local var0_292 = {
		[DROP_TYPE_ITEM] = {},
		[DROP_TYPE_RESOURCE] = {},
		[DROP_TYPE_EQUIP] = 0,
		[DROP_TYPE_SHIP] = 0,
		[DROP_TYPE_WORLD_ITEM] = 0
	}

	while #arg0_292 > 0 do
		local var1_292 = table.remove(arg0_292)

		switch(var1_292.type, {
			[DROP_TYPE_ITEM] = function()
				if var1_292:getConfig("open_directly") == 1 then
					for iter0_293, iter1_293 in ipairs(var1_292:getConfig("display_icon")) do
						local var0_293 = Drop.Create(iter1_293)

						var0_293.count = var0_293.count * var1_292.count

						table.insert(arg0_292, var0_293)
					end
				elseif var1_292:getSubClass():IsShipExpType() then
					var0_292[var1_292.type][var1_292.id] = defaultValue(var0_292[var1_292.type][var1_292.id], 0) + var1_292.count
				end
			end,
			[DROP_TYPE_RESOURCE] = function()
				var0_292[var1_292.type][var1_292.id] = defaultValue(var0_292[var1_292.type][var1_292.id], 0) + var1_292.count
			end,
			[DROP_TYPE_EQUIP] = function()
				var0_292[var1_292.type] = var0_292[var1_292.type] + var1_292.count
			end,
			[DROP_TYPE_SHIP] = function()
				var0_292[var1_292.type] = var0_292[var1_292.type] + var1_292.count
			end,
			[DROP_TYPE_WORLD_ITEM] = function()
				var0_292[var1_292.type] = var0_292[var1_292.type] + var1_292.count
			end
		})
	end

	return var0_292
end

function CheckOverflow(arg0_298, arg1_298)
	local var0_298 = {}
	local var1_298 = arg0_298[DROP_TYPE_RESOURCE][PlayerConst.ResGold] or 0
	local var2_298 = arg0_298[DROP_TYPE_RESOURCE][PlayerConst.ResOil] or 0
	local var3_298 = arg0_298[DROP_TYPE_EQUIP]
	local var4_298 = arg0_298[DROP_TYPE_SHIP]
	local var5_298 = getProxy(PlayerProxy):getRawData()
	local var6_298 = false

	if arg1_298 then
		local var7_298 = var5_298:OverStore(PlayerConst.ResStoreGold, var1_298)
		local var8_298 = var5_298:OverStore(PlayerConst.ResStoreOil, var2_298)

		if var7_298 > 0 or var8_298 > 0 then
			var0_298.isStoreOverflow = {
				var7_298,
				var8_298
			}
		end
	else
		if var1_298 > 0 and var5_298:GoldMax(var1_298) then
			return false, "gold"
		end

		if var2_298 > 0 and var5_298:OilMax(var2_298) then
			return false, "oil"
		end
	end

	var0_298.isExpBookOverflow = {}

	for iter0_298, iter1_298 in pairs(arg0_298[DROP_TYPE_ITEM]) do
		local var9_298 = Item.getConfigData(iter0_298)

		if getProxy(BagProxy):getItemCountById(iter0_298) + iter1_298 > var9_298.max_num then
			table.insert(var0_298.isExpBookOverflow, iter0_298)
		end
	end

	local var10_298 = getProxy(EquipmentProxy):getCapacity()

	if var3_298 > 0 and var3_298 + var10_298 > var5_298:getMaxEquipmentBag() then
		return false, "equip"
	end

	local var11_298 = getProxy(BayProxy):getShipCount()

	if var4_298 > 0 and var4_298 + var11_298 > var5_298:getMaxShipBag() then
		return false, "ship"
	end

	return true, var0_298
end

function CheckShipExpOverflow(arg0_299)
	local var0_299 = getProxy(BagProxy)

	for iter0_299, iter1_299 in pairs(arg0_299[DROP_TYPE_ITEM]) do
		if var0_299:getItemCountById(iter0_299) + iter1_299 > Item.getConfigData(iter0_299).max_num then
			return false
		end
	end

	return true
end

local var25_0 = {
	[17] = "item_type17_tip2",
	tech = "techpackage_item_use_confirm",
	[16] = "item_type16_tip2",
	[11] = "equip_skin_detail_tip",
	[13] = "item_type13_tip2"
}

function RegisterDetailButton(arg0_300, arg1_300, arg2_300)
	Drop.Change(arg2_300)
	switch(arg2_300.type, {
		[DROP_TYPE_ITEM] = function()
			if arg2_300:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
				local var0_301 = Item.getConfigData(arg2_300.id).usage_arg
				local var1_301 = var0_301[3]

				if Item.InTimeLimitSkinAssigned(arg2_300.id) then
					var1_301 = table.mergeArray(var0_301[2], var1_301, true)
				end

				local var2_301 = {}

				for iter0_301, iter1_301 in ipairs(var0_301[2]) do
					var2_301[iter1_301] = true
				end

				onButton(arg0_300, arg1_300, function()
					arg0_300:closeView()
					pg.m02:sendNotification(GAME.LOAD_LAYERS, {
						parentContext = getProxy(ContextProxy):getCurrentContext(),
						context = Context.New({
							viewComponent = SelectSkinLayer,
							mediator = SkinAtlasMediator,
							data = {
								mode = SelectSkinLayer.MODE_VIEW,
								itemId = arg2_300.id,
								selectableSkinList = underscore.map(var1_301, function(arg0_303)
									return SelectableSkin.New({
										id = arg0_303,
										isTimeLimit = var2_301[arg0_303] or false
									})
								end)
							}
						})
					})
				end, SFX_PANEL)
				setActive(arg1_300, true)
			else
				local var3_301 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_300.id) and "tech" or arg2_300:getConfig("type")

				if var25_0[var3_301] then
					local var4_301 = {
						item2Row = true,
						content = i18n(var25_0[var3_301]),
						itemList = underscore.map(arg2_300:getConfig("display_icon"), function(arg0_304)
							return Drop.Create(arg0_304)
						end)
					}

					if var3_301 == 11 then
						onButton(arg0_300, arg1_300, function()
							arg0_300:emit(BaseUI.ON_DROP_LIST_OWN, var4_301)
						end, SFX_PANEL)
					else
						onButton(arg0_300, arg1_300, function()
							arg0_300:emit(BaseUI.ON_DROP_LIST, var4_301)
						end, SFX_PANEL)
					end
				end

				setActive(arg1_300, tobool(var25_0[var3_301]))
			end
		end,
		[DROP_TYPE_EQUIP] = function()
			onButton(arg0_300, arg1_300, function()
				arg0_300:emit(BaseUI.ON_DROP, arg2_300)
			end, SFX_PANEL)
			setActive(arg1_300, true)
		end,
		[DROP_TYPE_SPWEAPON] = function()
			onButton(arg0_300, arg1_300, function()
				arg0_300:emit(BaseUI.ON_DROP, arg2_300)
			end, SFX_PANEL)
			setActive(arg1_300, true)
		end
	}, function()
		setActive(arg1_300, false)
	end)
end

function UpdateOwnDisplay(arg0_312, arg1_312)
	local var0_312, var1_312 = arg1_312:getOwnedCount()

	setActive(arg0_312, var1_312 and var0_312 > 0)

	if var1_312 and var0_312 > 0 then
		setText(arg0_312:Find("label"), i18n("word_own1"))
		setText(arg0_312:Find("Text"), var0_312)
	end
end

function Damp(arg0_313, arg1_313, arg2_313)
	arg1_313 = Mathf.Max(1, arg1_313)

	local var0_313 = Mathf.Epsilon

	if arg1_313 < var0_313 or var0_313 > Mathf.Abs(arg0_313) then
		return arg0_313
	end

	if arg2_313 < var0_313 then
		return 0
	end

	local var1_313 = -4.605170186

	return arg0_313 * (1 - Mathf.Exp(var1_313 * arg2_313 / arg1_313))
end

function checkCullResume(arg0_314)
	if not ReflectionHelp.RefCallMethodEx(typeof("UnityEngine.CanvasRenderer"), "GetMaterial", GetComponent(arg0_314, "CanvasRenderer"), {
		typeof("System.Int32")
	}, {
		0
	}) then
		local var0_314 = arg0_314:GetComponentsInChildren(typeof(MeshImage))

		for iter0_314 = 1, var0_314.Length do
			var0_314[iter0_314 - 1]:SetVerticesDirty()
		end

		return false
	end

	return true
end

function parseEquipCode(arg0_315)
	local var0_315 = {}

	if arg0_315 and arg0_315 ~= "" then
		local var1_315 = base64.dec(arg0_315)

		var0_315 = string.split(var1_315, "/")
		var0_315[5], var0_315[6] = unpack(string.split(var0_315[5], "\\"))

		if #var0_315 < 6 or arg0_315 ~= base64.enc(table.concat({
			table.concat(underscore.first(var0_315, 5), "/"),
			var0_315[6]
		}, "\\")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_illegal"))

			var0_315 = {}
		end
	end

	for iter0_315 = 1, 6 do
		var0_315[iter0_315] = var0_315[iter0_315] and tonumber(var0_315[iter0_315], 32) or 0
	end

	return var0_315
end

function buildEquipCode(arg0_316)
	local var0_316 = underscore.map(arg0_316:getAllEquipments(), function(arg0_317)
		return ConversionBase(32, arg0_317 and arg0_317.id or 0)
	end)
	local var1_316 = {
		table.concat(var0_316, "/"),
		ConversionBase(32, checkExist(arg0_316:GetSpWeapon(), {
			"id"
		}) or 0)
	}

	return base64.enc(table.concat(var1_316, "\\"))
end

function setDirectorSpeed(arg0_318, arg1_318)
	GetComponent(arg0_318, "TimelineSpeed"):SetTimelineSpeed(arg1_318)
end

function setDefaultZeroMetatable(arg0_319)
	return setmetatable(arg0_319, {
		__index = function(arg0_320, arg1_320)
			if rawget(arg0_320, arg1_320) == nil then
				arg0_320[arg1_320] = 0
			end

			return arg0_320[arg1_320]
		end
	})
end

function checkABExist(arg0_321)
	if EDITOR_TOOL then
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_321)) or ResourceMgr.Inst:AssetExist(arg0_321)
	else
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_321))
	end
end
