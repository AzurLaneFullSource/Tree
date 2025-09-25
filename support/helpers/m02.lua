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

function updateIslandDefaultIconTpl(arg0_107, arg1_107, arg2_107)
	GetImageSpriteFromAtlasAsync(arg1_107:getIcon(), "", findTF(arg0_107, "icon_bg/icon"))
	setActive(findTF(arg0_107, "icon_bg/count_bg"), arg1_107.count > 0)
	setText(findTF(arg0_107, "icon_bg/count_bg/count"), arg1_107.count)
	setIconName(arg0_107, arg1_107:getName(), {})
end

function getIslandSeasonPtInfo()
	local var0_108 = pg.island_set.season_pt.key_value_varchar

	return {
		name = var0_108[1],
		icon = var0_108[2]
	}
end

function updateIslandSeasonPt(arg0_109, arg1_109)
	local var0_109 = getIslandSeasonPtInfo()

	GetImageSpriteFromAtlasAsync("island/" .. var0_109.icon, "", findTF(arg0_109, "icon_bg/icon"))
	setActive(findTF(arg0_109, "icon_bg/count_bg"), arg1_109.count > 0)
	setText(findTF(arg0_109, "icon_bg/count_bg/count"), arg1_109.count)
end

function updateIslandCardDiy(arg0_110, arg1_110)
	GetImageSpriteFromAtlasAsync(arg1_110:getIcon(), "", findTF(arg0_110, "icon_bg/icon"))
	setActive(findTF(arg0_110, "icon_bg/count_bg"), arg1_110.count > 0)
	setText(findTF(arg0_110, "icon_bg/count_bg/count"), arg1_110.count)
	setIconName(arg0_110, arg1_110:getConfigTable().name, {})
end

function updateIslandSpeedupTicket(arg0_111, arg1_111)
	GetImageSpriteFromAtlasAsync(arg1_111:getIcon(), "", findTF(arg0_111, "icon_bg/icon"))
	setActive(findTF(arg0_111, "icon_bg/count_bg"), arg1_111.count > 0)
	setText(findTF(arg0_111, "icon_bg/count_bg/count"), arg1_111.count)
	setIconName(arg0_111, arg1_111:getConfigTable().name, {})
end

function updateIslandWatherCollect(arg0_112, arg1_112)
	local var0_112 = arg1_112:getConfigTable().icon
	local var1_112 = arg1_112:getConfigTable().name

	setText(findTF(arg0_112, "icon_bg/count"), arg1_112.count)
	GetImageSpriteFromAtlasAsync("island/" .. var0_112, "", findTF(arg0_112, "icon_bg/icon"))
	setIconName(arg0_112, var1_112, {})
end

function updateWorldItem(arg0_113, arg1_113, arg2_113)
	arg2_113 = arg2_113 or {}

	local var0_113 = ItemRarity.Rarity2Print(arg1_113:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_113, findTF(arg0_113, "icon_bg"))
	setFrame(findTF(arg0_113, "icon_bg/frame"), var0_113)

	local var1_113 = findTF(arg0_113, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_113.icon or arg1_113:getConfig("icon"), "", var1_113)
	setIconStars(arg0_113, false)
	setIconName(arg0_113, arg1_113:getConfig("name"), arg2_113)
	setIconColorful(arg0_113, arg1_113:getConfig("rarity"), arg2_113)
end

function updateWorldCollection(arg0_114, arg1_114, arg2_114)
	arg2_114 = arg2_114 or {}

	assert(arg1_114:getConfigTable(), "world_collection_file_template 和 world_collection_record_template 表中找不到配置: " .. arg1_114.id)

	local var0_114 = arg1_114:getDropRarity()
	local var1_114 = ItemRarity.Rarity2Print(var0_114)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_114, findTF(arg0_114, "icon_bg"))
	setFrame(findTF(arg0_114, "icon_bg/frame"), var1_114)

	local var2_114 = findTF(arg0_114, "icon_bg/icon")
	local var3_114 = WorldCollectionProxy.GetCollectionType(arg1_114.id) == WorldCollectionProxy.WorldCollectionType.FILE and "shoucangguangdie" or "shoucangjiaojuan"

	GetImageSpriteFromAtlasAsync("props/" .. var3_114, "", var2_114)
	setIconStars(arg0_114, false)
	setIconName(arg0_114, arg1_114:getName(), arg2_114)
	setIconColorful(arg0_114, var0_114, arg2_114)
end

function updateWorldBuff(arg0_115, arg1_115, arg2_115)
	arg2_115 = arg2_115 or {}

	local var0_115 = pg.world_SLGbuff_data[arg1_115]

	assert(var0_115, "找不到大世界buff配置: " .. arg1_115)

	local var1_115 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_115, findTF(arg0_115, "icon_bg"))
	setFrame(findTF(arg0_115, "icon_bg/frame"), var1_115)

	local var2_115 = findTF(arg0_115, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("world/buff/" .. var0_115.icon, "", var2_115)

	local var3_115 = arg0_115:Find("icon_bg/stars")

	if not IsNil(var3_115) then
		setActive(var3_115, false)
	end

	local var4_115 = findTF(arg0_115, "name")

	if not IsNil(var4_115) then
		setText(var4_115, var0_115.name)
	end

	local var5_115 = findTF(arg0_115, "icon_bg/count")

	if not IsNil(var5_115) then
		SetActive(var5_115, false)
	end
end

function updateShip(arg0_116, arg1_116, arg2_116)
	arg2_116 = arg2_116 or {}

	local var0_116 = arg1_116:rarity2bgPrint()
	local var1_116 = arg1_116:getPainting()

	if arg2_116.anonymous then
		var0_116 = "1"
		var1_116 = "unknown"
	end

	if arg2_116.unknown_small then
		var1_116 = "unknown_small"
	end

	local var2_116 = findTF(arg0_116, "icon_bg/new")

	if var2_116 then
		if arg2_116.isSkin then
			setActive(var2_116, not arg2_116.isTimeLimit and arg2_116.isNew)
		else
			setActive(var2_116, arg1_116.virgin)
		end
	end

	local var3_116 = findTF(arg0_116, "icon_bg/timelimit")

	if var3_116 then
		setActive(var3_116, arg2_116.isTimeLimit)
	end

	local var4_116 = findTF(arg0_116, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. (arg2_116.isSkin and "_skin" or var0_116), var4_116)

	local var5_116 = findTF(arg0_116, "icon_bg/frame")
	local var6_116

	if arg1_116.isNpc then
		var6_116 = "frame_npc"
	elseif arg1_116:ShowPropose() then
		var6_116 = "frame_prop"

		if arg1_116:isMetaShip() then
			var6_116 = var6_116 .. "_meta"
		end
	elseif arg2_116.isSkin then
		var6_116 = "frame_skin"
	end

	setFrame(var5_116, var0_116, var6_116)

	if arg2_116.gray then
		setGray(var4_116, true, true)
	end

	local var7_116 = findTF(arg0_116, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg2_116.Q and "QIcon/" or "SquareIcon/") .. var1_116, "", var7_116)

	local var8_116 = findTF(arg0_116, "icon_bg/lv")

	if var8_116 then
		setActive(var8_116, not arg1_116.isNpc)

		if not arg1_116.isNpc then
			local var9_116 = findTF(var8_116, "Text")

			if var9_116 and arg1_116.level then
				setText(var9_116, arg1_116.level)
			end
		end
	end

	local var10_116 = findTF(arg0_116, "ship_type")

	if var10_116 then
		setActive(var10_116, true)
		setImageSprite(var10_116, GetSpriteFromAtlas("shiptype", shipType2print(arg1_116:getShipType())))
	end

	local var11_116 = var4_116:Find("npc")

	if not IsNil(var11_116) then
		if var2_116 and go(var2_116).activeSelf then
			setActive(var11_116, false)
		else
			setActive(var11_116, arg1_116:isActivityNpc())
		end
	end

	local var12_116 = arg0_116:Find("group_locked")

	if var12_116 then
		setActive(var12_116, not arg2_116.isSkin and not getProxy(CollectionProxy):getShipGroup(arg1_116.groupId))
	end

	setIconStars(arg0_116, arg2_116.initStar, arg1_116:getStar())
	setIconName(arg0_116, arg2_116.isSkin and arg1_116:GetSkinConfig().name or arg1_116:getName(), arg2_116)
	setIconColorful(arg0_116, arg2_116.isSkin and ItemRarity.Gold or arg1_116:getRarity() - 1, arg2_116)
end

function updateCommander(arg0_117, arg1_117, arg2_117)
	arg2_117 = arg2_117 or {}

	local var0_117 = arg1_117:getDropRarity()
	local var1_117 = ItemRarity.Rarity2Print(var0_117)
	local var2_117 = arg1_117:getConfig("painting")

	if arg2_117.anonymous then
		var1_117 = 1
		var2_117 = "unknown"
	end

	local var3_117 = findTF(arg0_117, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_117, var3_117)

	local var4_117 = findTF(arg0_117, "icon_bg/frame")

	setFrame(var4_117, var1_117)

	if arg2_117.gray then
		setGray(var3_117, true, true)
	end

	local var5_117 = findTF(arg0_117, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("CommanderIcon/" .. var2_117, "", var5_117)
	setIconStars(arg0_117, arg2_117.initStar, 0)
	setIconName(arg0_117, arg1_117:getName(), arg2_117)
end

function updateStrategy(arg0_118, arg1_118, arg2_118)
	arg2_118 = arg2_118 or {}

	local var0_118 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_118, findTF(arg0_118, "icon_bg"))
	setFrame(findTF(arg0_118, "icon_bg/frame"), var0_118)

	local var1_118 = findTF(arg0_118, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg1_118.isWorldBuff and "world/buff/" or "strategyicon/") .. arg1_118:getIcon(), "", var1_118)
	setIconStars(arg0_118, false)
	setIconName(arg0_118, arg1_118:getName(), arg2_118)
	setIconColorful(arg0_118, ItemRarity.Gray, arg2_118)
end

function updateFurniture(arg0_119, arg1_119, arg2_119)
	arg2_119 = arg2_119 or {}

	local var0_119 = arg1_119:getDropRarity()
	local var1_119 = ItemRarity.Rarity2Print(var0_119)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_119, findTF(arg0_119, "icon_bg"))
	setFrame(findTF(arg0_119, "icon_bg/frame"), var1_119)

	local var2_119 = findTF(arg0_119, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1_119:getIcon(), "", var2_119)
	setIconStars(arg0_119, false)
	setIconName(arg0_119, arg1_119:getName(), arg2_119)
	setIconColorful(arg0_119, var0_119, arg2_119)
end

function updateSpWeapon(arg0_120, arg1_120, arg2_120)
	arg2_120 = arg2_120 or {}

	assert(arg1_120, "spWeaponVO can not be nil.")
	assert(isa(arg1_120, SpWeapon), "spWeaponVO is not Equipment.")

	local var0_120 = ItemRarity.Rarity2Print(arg1_120:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_120, findTF(arg0_120, "icon_bg"))
	setFrame(findTF(arg0_120, "icon_bg/frame"), var0_120)

	local var1_120 = findTF(arg0_120, "icon_bg/icon")

	var4_0(var1_120, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync(arg1_120:GetIconPath(), "", var1_120)
	setIconStars(arg0_120, true, arg1_120:GetRarity())
	var7_0(arg0_120, arg1_120:GetLevel() - 1)
	setIconName(arg0_120, arg1_120:GetName(), arg2_120)
	setIconCount(arg0_120, arg1_120.count)
	setIconColorful(arg0_120, arg1_120:GetRarity(), arg2_120)
end

function UpdateSpWeaponSlot(arg0_121, arg1_121, arg2_121)
	local var0_121 = ItemRarity.Rarity2Print(arg1_121:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_121, findTF(arg0_121, "Icon/Mask/icon_bg"))

	local var1_121 = findTF(arg0_121, "Icon/Mask/icon_bg/icon")

	arg2_121 = arg2_121 or {
		16,
		16,
		16,
		16
	}

	var4_0(var1_121, arg2_121)
	GetImageSpriteFromAtlasAsync(arg1_121:GetIconPath(), "", var1_121)

	local var2_121 = arg1_121:GetLevel() - 1
	local var3_121 = findTF(arg0_121, "Icon/LV")

	setActive(var3_121, var2_121 > 0)
	setText(findTF(var3_121, "Text"), var2_121)
end

function updateDorm3dIcon(arg0_122, arg1_122)
	local var0_122 = arg1_122:getDropRarityDorm()

	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(var0_122), arg0_122)

	local var1_122 = arg0_122:Find("icon")

	GetImageSpriteFromAtlasAsync(arg1_122:getIcon(), "", var1_122)
	setText(arg0_122:Find("count/Text"), "x" .. arg1_122.count)
	setText(arg0_122:Find("name/Text"), arg1_122:getName())
end

local var8_0

function findCullAndClipWorldRect(arg0_123)
	if #arg0_123 == 0 then
		return false
	end

	local var0_123 = arg0_123[1].canvasRect

	for iter0_123 = 1, #arg0_123 do
		var0_123 = rectIntersect(var0_123, arg0_123[iter0_123].canvasRect)
	end

	if var0_123.width <= 0 or var0_123.height <= 0 then
		return false
	end

	var8_0 = var8_0 or GameObject.Find("UICamera/Canvas").transform

	local var1_123 = var8_0:TransformPoint(Vector3(var0_123.x, var0_123.y, 0))
	local var2_123 = var8_0:TransformPoint(Vector3(var0_123.x + var0_123.width, var0_123.y + var0_123.height, 0))

	return true, Vector4(var1_123.x, var1_123.y, var2_123.x, var2_123.y)
end

function rectIntersect(arg0_124, arg1_124)
	local var0_124 = math.max(arg0_124.x, arg1_124.x)
	local var1_124 = math.min(arg0_124.x + arg0_124.width, arg1_124.x + arg1_124.width)
	local var2_124 = math.max(arg0_124.y, arg1_124.y)
	local var3_124 = math.min(arg0_124.y + arg0_124.height, arg1_124.y + arg1_124.height)

	if var0_124 <= var1_124 and var2_124 <= var3_124 then
		return var0_0.Rect.New(var0_124, var2_124, var1_124 - var0_124, var3_124 - var2_124)
	end

	return var0_0.Rect.New(0, 0, 0, 0)
end

function getDropInfo(arg0_125)
	local var0_125 = {}

	for iter0_125, iter1_125 in ipairs(arg0_125) do
		local var1_125 = Drop.Create(iter1_125)

		var1_125.count = var1_125.count or 1

		if var1_125.type == DROP_TYPE_EMOJI then
			table.insert(var0_125, var1_125:getName())
		else
			table.insert(var0_125, var1_125:getName() .. "x" .. var1_125.count)
		end
	end

	return table.concat(var0_125, "、")
end

function updateDrop(arg0_126, arg1_126, arg2_126)
	Drop.Change(arg1_126)

	arg2_126 = arg2_126 or {}

	local var0_126 = {
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
	local var1_126

	for iter0_126, iter1_126 in ipairs(var0_126) do
		local var2_126 = arg0_126:Find(iter1_126[1])

		if arg1_126.type ~= iter1_126[2] and not IsNil(var2_126) then
			setActive(var2_126, false)
		end
	end

	if not IsNil(arg0_126:Find("icon_bg/frame")) then
		arg0_126:Find("icon_bg/frame"):GetComponent(typeof(Image)).enabled = true

		setIconColorful(arg0_126, arg1_126:getDropRarity(), arg2_126, {
			[ItemRarity.Gold] = {
				name = "Item_duang5",
				active = function(arg0_127, arg1_127)
					return arg1_127.fromAwardLayer and arg0_127 >= ItemRarity.Gold
				end
			}
		})
		var4_0(findTF(arg0_126, "icon_bg/icon"), {
			2,
			2,
			2,
			2
		})
	end

	arg1_126:UpdateDropTpl(arg0_126, arg2_126)
	setIconCount(arg0_126, arg2_126.count or arg1_126:getCount())
end

function updateCustomDrop(arg0_128, arg1_128, arg2_128)
	Drop.Change(arg1_128)

	arg2_128 = arg2_128 or {}

	arg1_128:UpdateCustomDropTpl(arg0_128, arg2_128)
end

function updateBuff(arg0_129, arg1_129, arg2_129)
	arg2_129 = arg2_129 or {}

	local var0_129 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_129, findTF(arg0_129, "icon_bg"))

	local var1_129 = pg.benefit_buff_template[arg1_129]

	setFrame(findTF(arg0_129, "icon_bg/frame"), var0_129)
	setText(findTF(arg0_129, "icon_bg/count"), 1)

	local var2_129 = findTF(arg0_129, "icon_bg/icon")
	local var3_129 = var1_129.icon

	GetImageSpriteFromAtlasAsync(var3_129, "", var2_129)
	setIconStars(arg0_129, false)
	setIconName(arg0_129, var1_129.name, arg2_129)
	setIconColorful(arg0_129, ItemRarity.Gold, arg2_129)
end

function updateAttire(arg0_130, arg1_130, arg2_130, arg3_130)
	local var0_130 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_130, findTF(arg0_130, "icon_bg"))
	setFrame(findTF(arg0_130, "icon_bg/frame"), var0_130)

	local var1_130 = findTF(arg0_130, "icon_bg/icon")
	local var2_130

	if arg1_130 == AttireConst.TYPE_CHAT_FRAME then
		var2_130 = "chat_frame"
	elseif arg1_130 == AttireConst.TYPE_ICON_FRAME then
		var2_130 = "icon_frame"
	end

	GetImageSpriteFromAtlasAsync("Props/" .. var2_130, "", var1_130)
	setIconName(arg0_130, arg2_130.name, arg3_130)
end

function updateAttireCombatUI(arg0_131, arg1_131, arg2_131, arg3_131)
	local var0_131 = arg2_131.rare

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_131, findTF(arg0_131, "icon_bg"))
	setFrame(findTF(arg0_131, "icon_bg/frame"), var0_131, "frame_battle_ui")

	local var1_131 = findTF(arg0_131, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("Props/" .. arg2_131.display_icon, "", var1_131)
	setIconName(arg0_131, arg2_131.name, arg3_131)
end

function updateActivityMedal(arg0_132, arg1_132, arg2_132)
	local var0_132 = ItemRarity.Rarity2Print(arg1_132.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_132, findTF(arg0_132, "icon_bg"))
	setFrame(findTF(arg0_132, "icon_bg/frame"), var0_132)

	local var1_132 = findTF(arg0_132, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_132.icon, "", var1_132)
	setIconName(arg0_132, arg1_132.name, arg2_132)
end

function updateCover(arg0_133, arg1_133, arg2_133)
	local var0_133 = arg1_133:getDropRarity()

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_133, findTF(arg0_133, "icon_bg"))
	setFrame(findTF(arg0_133, "icon_bg/frame"), var0_133)

	local var1_133 = findTF(arg0_133, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_133:getIcon(), "", var1_133)
	setIconName(arg0_133, arg1_133:getName(), arg2_133)
	setIconStars(arg0_133, false)
end

function updateEmoji(arg0_134, arg1_134, arg2_134)
	local var0_134 = findTF(arg0_134, "icon_bg/icon")
	local var1_134 = "icon_emoji"

	GetImageSpriteFromAtlasAsync("Props/" .. var1_134, "", var0_134)

	local var2_134 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var2_134, findTF(arg0_134, "icon_bg"))
	setFrame(findTF(arg0_134, "icon_bg/frame"), var2_134)
	setIconName(arg0_134, arg1_134.name, arg2_134)
end

function updateEquipmentSkin(arg0_135, arg1_135, arg2_135)
	arg2_135 = arg2_135 or {}

	local var0_135 = EquipmentRarity.Rarity2Print(arg1_135.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_135, findTF(arg0_135, "icon_bg"))
	setFrame(findTF(arg0_135, "icon_bg/frame"), var0_135, "frame_skin")

	local var1_135 = findTF(arg0_135, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. arg1_135.icon, "", var1_135)
	setIconStars(arg0_135, false)
	setIconName(arg0_135, arg1_135.name, arg2_135)
	setIconCount(arg0_135, arg1_135.count)
	setIconColorful(arg0_135, arg1_135.rarity - 1, arg2_135)
end

function NoPosMsgBox(arg0_136, arg1_136, arg2_136, arg3_136)
	local var0_136
	local var1_136 = {}

	if arg1_136 then
		table.insert(var1_136, {
			text = "text_noPos_clear",
			atuoClose = true,
			onCallback = arg1_136
		})
	end

	if arg2_136 then
		table.insert(var1_136, {
			text = "text_noPos_buy",
			atuoClose = true,
			onCallback = arg2_136
		})
	end

	if arg3_136 then
		table.insert(var1_136, {
			text = "text_noPos_intensify",
			atuoClose = true,
			onCallback = arg3_136
		})
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		hideNo = true,
		content = arg0_136,
		custom = var1_136
	})
end

function openDestroyEquip()
	if pg.m02:hasMediator(EquipmentMediator.__cname) then
		local var0_137 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_137 and var0_137.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_137
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
		local var0_138 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_138 and var0_138.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_138
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
		onClick = function(arg0_141, arg1_141)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
				page = 3,
				shipId = arg0_141.id,
				shipVOs = arg1_141
			})
		end
	})
end

function GoShoppingMsgBox(arg0_142, arg1_142, arg2_142)
	if arg2_142 then
		local var0_142 = ""

		for iter0_142, iter1_142 in ipairs(arg2_142) do
			local var1_142 = Item.getConfigData(iter1_142[1])

			var0_142 = var0_142 .. i18n(iter1_142[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var1_142.name, iter1_142[2])

			if iter0_142 < #arg2_142 then
				var0_142 = var0_142 .. i18n("text_noRes_info_tip_link")
			end
		end

		if var0_142 ~= "" then
			arg0_142 = arg0_142 .. "\n" .. i18n("text_noRes_tip", var0_142)
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = arg0_142,
		onYes = function()
			gotoChargeScene(arg1_142, arg2_142)
		end
	})
end

function shoppingBatch(arg0_144, arg1_144, arg2_144, arg3_144, arg4_144)
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

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			needCounter = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_ITEM,
				id = arg1_144.id
			},
			addNum = var0_144.num,
			maxNum = var3_144 * var0_144.num,
			defaultNum = var0_144.num,
			numUpdate = function(arg0_145, arg1_145)
				var5_144 = math.floor(arg1_145 / var0_144.num)

				local var0_145 = var5_144 * var2_144

				if var0_145 > var1_144 then
					setText(arg0_145, i18n(arg3_144, var0_145, arg1_145, COLOR_RED, var6_144))

					var4_144 = false
				else
					setText(arg0_145, i18n(arg3_144, var0_145, arg1_145, COLOR_GREEN, var6_144))

					var4_144 = true
				end
			end,
			onYes = function()
				if var4_144 then
					pg.m02:sendNotification(GAME.SHOPPING, {
						id = arg0_144,
						count = var5_144
					})
				elseif arg4_144 then
					pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_144))
					pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_OR_SKIN_FAILD)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("main_playerInfoLayer_error_changeNameNoGem"))
				end
			end
		})
	end
end

function shoppingBatchNewStyle(arg0_147, arg1_147, arg2_147, arg3_147, arg4_147)
	local var0_147 = pg.shop_template[arg0_147]

	assert(var0_147, "shop_template中找不到商品id：" .. arg0_147)

	local var1_147 = getProxy(PlayerProxy):getData()[id2res(var0_147.resource_type)]
	local var2_147 = arg1_147.price or var0_147.resource_num
	local var3_147 = math.floor(var1_147 / var2_147)

	var3_147 = var3_147 <= 0 and 1 or var3_147
	var3_147 = arg2_147 ~= nil and arg2_147 < var3_147 and arg2_147 or var3_147

	local var4_147 = true
	local var5_147 = 1

	if var0_147 ~= nil and arg1_147.id then
		print(var3_147 * var0_147.num, "--", var3_147)
		assert(Item.getConfigData(arg1_147.id), "item config should be existence")

		local var6_147 = Item.New({
			id = arg1_147.id
		}):getConfig("name")

		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_SHOPPING, {
			drop = Drop.New({
				count = 1,
				type = DROP_TYPE_ITEM,
				id = arg1_147.id
			}),
			price = var2_147,
			addNum = var0_147.num,
			maxNum = var3_147 * var0_147.num,
			defaultNum = var0_147.num,
			numUpdate = function(arg0_148, arg1_148)
				var5_147 = math.floor(arg1_148 / var0_147.num)

				local var0_148 = var5_147 * var2_147

				if var0_148 > var1_147 then
					setTextInNewStyleBox(arg0_148, i18n(arg3_147, var0_148, arg1_148, COLOR_RED, var6_147))

					var4_147 = false
				else
					setTextInNewStyleBox(arg0_148, i18n(arg3_147, var0_148, arg1_148, "#238C40FF", var6_147))

					var4_147 = true
				end
			end,
			btnList = {
				{
					type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.shopping,
					name = i18n("word_buy"),
					func = function()
						if var4_147 then
							pg.m02:sendNotification(GAME.SHOPPING, {
								id = arg0_147,
								count = var5_147
							})
						elseif arg4_147 then
							pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_147))
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

function gotoChargeScene(arg0_150, arg1_150)
	local var0_150 = getProxy(ContextProxy)
	local var1_150 = getProxy(ContextProxy):getCurrentContext()

	if instanceof(var1_150.mediator, NewShopMainMediator) then
		var1_150.mediator:getViewComponent():switchSubViewByTogger(arg0_150)
	else
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
			wrap = arg0_150 or ChargeScene.TYPE_ITEM,
			noRes = arg1_150
		})
	end

	pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_OR_SKIN_FAILD)
end

function clearDrop(arg0_151)
	local var0_151 = findTF(arg0_151, "icon_bg")
	local var1_151 = findTF(arg0_151, "icon_bg/frame")
	local var2_151 = findTF(arg0_151, "icon_bg/icon")
	local var3_151 = findTF(arg0_151, "icon_bg/icon/icon")

	clearImageSprite(var0_151)
	clearImageSprite(var1_151)
	clearImageSprite(var2_151)

	if var3_151 then
		clearImageSprite(var3_151)
	end
end

local var9_0 = {
	red = Color.New(1, 0.25, 0.25),
	blue = Color.New(0.11, 0.55, 0.64),
	yellow = Color.New(0.92, 0.52, 0)
}

function updateSkill(arg0_152, arg1_152, arg2_152, arg3_152)
	local var0_152 = findTF(arg0_152, "skill")
	local var1_152 = findTF(arg0_152, "lock")
	local var2_152 = findTF(arg0_152, "unknown")

	if arg1_152 then
		setActive(var0_152, true)
		setActive(var2_152, false)
		setActive(var1_152, not arg2_152)
		LoadImageSpriteAsync("skillicon/" .. arg1_152.icon, findTF(var0_152, "icon"))

		local var3_152 = arg1_152.color or "blue"

		setText(findTF(var0_152, "name"), shortenString(getSkillName(arg1_152.id), arg3_152 or 8))

		local var4_152 = findTF(var0_152, "level")

		setText(var4_152, "LEVEL: " .. (arg2_152 and arg2_152.level or "??"))
		setTextColor(var4_152, var9_0[var3_152])
	else
		setActive(var0_152, false)
		setActive(var2_152, true)
		setActive(var1_152, false)
	end
end

local var10_0 = true

function onBackButton(arg0_153, arg1_153, arg2_153, arg3_153)
	local var0_153 = GetOrAddComponent(arg1_153, "UILongPressTrigger")

	assert(arg2_153, "callback should exist")

	var0_153.longPressThreshold = defaultValue(arg3_153, 1)

	local function var1_153(arg0_154)
		return function()
			if var10_0 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SOUND_BACK)
			end

			local var0_155, var1_155 = arg2_153()

			if var0_155 then
				arg0_154(var1_155)
			end
		end
	end

	local var2_153 = var0_153.onReleased

	pg.DelegateInfo.Add(arg0_153, var2_153)
	var2_153:RemoveAllListeners()
	var2_153:AddListener(var1_153(function(arg0_156)
		arg0_156:emit(BaseUI.ON_BACK)
	end))

	local var3_153 = var0_153.onLongPressed

	pg.DelegateInfo.Add(arg0_153, var3_153)
	var3_153:RemoveAllListeners()
	var3_153:AddListener(var1_153(function(arg0_157)
		arg0_157:emit(BaseUI.ON_HOME)
	end))
end

function GetZeroTime()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)
end

function GetHalfHour()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0, 1800)
end

function GetNextHour(arg0_160)
	local var0_160 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_160, var2_160 = pg.TimeMgr.GetInstance():parseTimeFrom(var0_160)

	return var1_160 * 86400 + (var2_160 + arg0_160) * 3600
end

function GetPerceptualSize(arg0_161, arg1_161)
	local function var0_161(arg0_162)
		if not arg0_162 then
			return 0, 1
		elseif arg0_162 > 240 then
			return 4, 1
		elseif arg0_162 > 225 then
			return 3, 1
		elseif arg0_162 > 192 then
			return 2, 1
		elseif arg0_162 < 126 then
			return 1, arg1_161 or 0.5
		else
			return 1, 1
		end
	end

	if type(arg0_161) == "number" then
		return var0_161(arg0_161)
	end

	local var1_161 = 1
	local var2_161 = 0
	local var3_161 = 0
	local var4_161 = #arg0_161

	while var1_161 <= var4_161 do
		local var5_161 = string.byte(arg0_161, var1_161)
		local var6_161, var7_161 = var0_161(var5_161)

		var1_161 = var1_161 + var6_161
		var2_161 = var2_161 + var7_161
	end

	return var2_161
end

function shortenString(arg0_163, arg1_163, arg2_163)
	local var0_163 = 1
	local var1_163 = 0
	local var2_163 = 0
	local var3_163 = #arg0_163

	while var0_163 <= var3_163 do
		local var4_163 = string.byte(arg0_163, var0_163)
		local var5_163, var6_163 = GetPerceptualSize(var4_163, arg2_163)

		var0_163 = var0_163 + var5_163
		var1_163 = var1_163 + var6_163

		if arg1_163 <= math.ceil(var1_163) then
			var2_163 = var0_163

			break
		end
	end

	if var2_163 == 0 or var3_163 < var2_163 then
		return arg0_163
	end

	return string.sub(arg0_163, 1, var2_163 - 1) .. ".."
end

function shouldShortenString(arg0_164, arg1_164)
	local var0_164 = 1
	local var1_164 = 0
	local var2_164 = 0
	local var3_164 = #arg0_164

	while var0_164 <= var3_164 do
		local var4_164 = string.byte(arg0_164, var0_164)
		local var5_164, var6_164 = GetPerceptualSize(var4_164)

		var0_164 = var0_164 + var5_164
		var1_164 = var1_164 + var6_164

		if arg1_164 <= math.ceil(var1_164) then
			var2_164 = var0_164

			break
		end
	end

	if var2_164 == 0 or var3_164 < var2_164 then
		return false
	end

	return true
end

function nameValidityCheck(arg0_165, arg1_165, arg2_165, arg3_165)
	local var0_165 = true
	local var1_165, var2_165 = utf8_to_unicode(arg0_165)
	local var3_165 = filterEgyUnicode(filterSpecChars(arg0_165))
	local var4_165 = wordVer(arg0_165)

	if not checkSpaceValid(arg0_165) then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_165[1]))

		var0_165 = false
	elseif var4_165 > 0 or var3_165 ~= arg0_165 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_165[4]))

		var0_165 = false
	elseif var2_165 < arg1_165 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_165[2]))

		var0_165 = false
	elseif arg2_165 < var2_165 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_165[3]))

		var0_165 = false
	end

	return var0_165
end

function checkSpaceValid(arg0_166)
	if PLATFORM_CODE == PLATFORM_US then
		return true
	end

	local var0_166 = string.gsub(arg0_166, " ", "")

	return arg0_166 == string.gsub(var0_166, "　", "")
end

function filterSpecChars(arg0_167)
	local var0_167 = {}
	local var1_167 = 0
	local var2_167 = 0
	local var3_167 = 0
	local var4_167 = 1

	while var4_167 <= #arg0_167 do
		local var5_167 = string.byte(arg0_167, var4_167)

		if not var5_167 then
			break
		end

		if var5_167 >= 48 and var5_167 <= 57 or var5_167 >= 65 and var5_167 <= 90 or var5_167 == 95 or var5_167 >= 97 and var5_167 <= 122 then
			table.insert(var0_167, string.char(var5_167))
		elseif var5_167 >= 228 and var5_167 <= 233 then
			local var6_167 = string.byte(arg0_167, var4_167 + 1)
			local var7_167 = string.byte(arg0_167, var4_167 + 2)

			if var6_167 and var7_167 and var6_167 >= 128 and var6_167 <= 191 and var7_167 >= 128 and var7_167 <= 191 then
				var4_167 = var4_167 + 2

				table.insert(var0_167, string.char(var5_167, var6_167, var7_167))

				var1_167 = var1_167 + 1
			end
		elseif var5_167 == 45 or var5_167 == 40 or var5_167 == 41 then
			table.insert(var0_167, string.char(var5_167))
		elseif var5_167 == 194 then
			local var8_167 = string.byte(arg0_167, var4_167 + 1)

			if var8_167 == 183 then
				var4_167 = var4_167 + 1

				table.insert(var0_167, string.char(var5_167, var8_167))

				var1_167 = var1_167 + 1
			end
		elseif var5_167 == 239 then
			local var9_167 = string.byte(arg0_167, var4_167 + 1)
			local var10_167 = string.byte(arg0_167, var4_167 + 2)

			if var9_167 == 188 and (var10_167 == 136 or var10_167 == 137) then
				var4_167 = var4_167 + 2

				table.insert(var0_167, string.char(var5_167, var9_167, var10_167))

				var1_167 = var1_167 + 1
			end
		elseif var5_167 == 206 or var5_167 == 207 then
			local var11_167 = string.byte(arg0_167, var4_167 + 1)

			if var5_167 == 206 and var11_167 >= 177 or var5_167 == 207 and var11_167 <= 134 then
				var4_167 = var4_167 + 1

				table.insert(var0_167, string.char(var5_167, var11_167))

				var1_167 = var1_167 + 1
			end
		elseif var5_167 == 227 and PLATFORM_CODE == PLATFORM_JP then
			local var12_167 = string.byte(arg0_167, var4_167 + 1)
			local var13_167 = string.byte(arg0_167, var4_167 + 2)

			if var12_167 and var13_167 and var12_167 > 128 and var12_167 <= 191 and var13_167 >= 128 and var13_167 <= 191 then
				var4_167 = var4_167 + 2

				table.insert(var0_167, string.char(var5_167, var12_167, var13_167))

				var2_167 = var2_167 + 1
			end
		elseif var5_167 >= 224 and PLATFORM_CODE == PLATFORM_KR then
			local var14_167 = string.byte(arg0_167, var4_167 + 1)
			local var15_167 = string.byte(arg0_167, var4_167 + 2)

			if var14_167 and var15_167 and var14_167 >= 128 and var14_167 <= 191 and var15_167 >= 128 and var15_167 <= 191 then
				var4_167 = var4_167 + 2

				table.insert(var0_167, string.char(var5_167, var14_167, var15_167))

				var3_167 = var3_167 + 1
			end
		elseif PLATFORM_CODE == PLATFORM_US then
			if var4_167 ~= 1 and var5_167 == 32 and string.byte(arg0_167, var4_167 + 1) ~= 32 then
				table.insert(var0_167, string.char(var5_167))
			end

			if var5_167 >= 192 and var5_167 <= 223 then
				local var16_167 = string.byte(arg0_167, var4_167 + 1)

				var4_167 = var4_167 + 1

				if var5_167 == 194 and var16_167 and var16_167 >= 128 then
					table.insert(var0_167, string.char(var5_167, var16_167))
				elseif var5_167 == 195 and var16_167 and var16_167 <= 191 then
					table.insert(var0_167, string.char(var5_167, var16_167))
				end
			end
		end

		var4_167 = var4_167 + 1
	end

	return table.concat(var0_167), var1_167 + var2_167 + var3_167
end

function filterEgyUnicode(arg0_168)
	arg0_168 = string.gsub(arg0_168, "�[�-�][�-�]", "")
	arg0_168 = string.gsub(arg0_168, "�[�-�]", "")

	return arg0_168
end

function shiftPanel(arg0_169, arg1_169, arg2_169, arg3_169, arg4_169, arg5_169, arg6_169, arg7_169, arg8_169)
	arg3_169 = arg3_169 or 0.2

	if arg5_169 then
		LeanTween.cancel(go(arg0_169))
	end

	local var0_169 = rtf(arg0_169)

	arg1_169 = arg1_169 or var0_169.anchoredPosition.x
	arg2_169 = arg2_169 or var0_169.anchoredPosition.y

	local var1_169 = LeanTween.move(var0_169, Vector3(arg1_169, arg2_169, 0), arg3_169)

	arg7_169 = arg7_169 or LeanTweenType.easeInOutSine

	var1_169:setEase(arg7_169)

	if arg4_169 then
		var1_169:setDelay(arg4_169)
	end

	if arg6_169 then
		GetOrAddComponent(arg0_169, "CanvasGroup").blocksRaycasts = false
	end

	var1_169:setOnComplete(System.Action(function()
		if arg8_169 then
			arg8_169()
		end

		if arg6_169 then
			GetOrAddComponent(arg0_169, "CanvasGroup").blocksRaycasts = true
		end
	end))

	return var1_169
end

function TweenValue(arg0_171, arg1_171, arg2_171, arg3_171, arg4_171, arg5_171, arg6_171, arg7_171)
	local var0_171 = LeanTween.value(go(arg0_171), arg1_171, arg2_171, arg3_171):setOnUpdate(System.Action_float(function(arg0_172)
		if arg5_171 then
			arg5_171(arg0_172)
		end
	end)):setOnComplete(System.Action(function()
		if arg6_171 then
			arg6_171()
		end
	end)):setDelay(arg4_171 or 0)

	if arg7_171 and arg7_171 > 0 then
		var0_171:setRepeat(arg7_171)
	end

	return var0_171
end

function rotateAni(arg0_174, arg1_174, arg2_174)
	return LeanTween.rotate(rtf(arg0_174), 360 * arg1_174, arg2_174):setLoopClamp()
end

function blinkAni(arg0_175, arg1_175, arg2_175, arg3_175)
	return LeanTween.alpha(rtf(arg0_175), arg3_175 or 0, arg1_175):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(arg2_175 or 0)
end

function scaleAni(arg0_176, arg1_176, arg2_176, arg3_176)
	return LeanTween.scale(rtf(arg0_176), arg3_176 or 0, arg1_176):setLoopPingPong(arg2_176 or 0)
end

function floatAni(arg0_177, arg1_177, arg2_177, arg3_177)
	local var0_177 = arg0_177.localPosition.y + arg1_177

	return LeanTween.moveY(rtf(arg0_177), var0_177, arg2_177):setLoopPingPong(arg3_177 or 0)
end

local var11_0 = tostring

function tostring(arg0_178)
	if arg0_178 == nil then
		return "nil"
	end

	local var0_178 = var11_0(arg0_178)

	if var0_178 == nil then
		if type(arg0_178) == "table" then
			return "{}"
		end

		return " ~nil"
	end

	return var0_178
end

function wordVer(arg0_179, arg1_179)
	if arg0_179.match(arg0_179, ChatConst.EmojiCodeMatch) then
		return 0, arg0_179
	end

	arg1_179 = arg1_179 or {}

	local var0_179 = filterEgyUnicode(arg0_179)

	if #var0_179 ~= #arg0_179 then
		if arg1_179.isReplace then
			arg0_179 = var0_179
		else
			return 1
		end
	end

	local var1_179 = wordSplit(arg0_179)
	local var2_179 = pg.word_template
	local var3_179 = pg.word_legal_template

	arg1_179.isReplace = arg1_179.isReplace or false
	arg1_179.replaceWord = arg1_179.replaceWord or "*"

	local var4_179 = #var1_179
	local var5_179 = 1
	local var6_179 = ""
	local var7_179 = 0

	while var5_179 <= var4_179 do
		local var8_179, var9_179, var10_179 = wordLegalMatch(var1_179, var3_179, var5_179)

		if var8_179 then
			var5_179 = var9_179
			var6_179 = var6_179 .. var10_179
		else
			local var11_179, var12_179, var13_179 = wordVerMatch(var1_179, var2_179, arg1_179, var5_179, "", false, var5_179, "")

			if var11_179 then
				var5_179 = var12_179
				var7_179 = var7_179 + 1

				if arg1_179.isReplace then
					var6_179 = var6_179 .. var13_179
				end
			else
				if arg1_179.isReplace then
					var6_179 = var6_179 .. var1_179[var5_179]
				end

				var5_179 = var5_179 + 1
			end
		end
	end

	if arg1_179.isReplace then
		return var7_179, var6_179
	else
		return var7_179
	end
end

function wordLegalMatch(arg0_180, arg1_180, arg2_180, arg3_180, arg4_180)
	if arg2_180 > #arg0_180 then
		return arg3_180, arg2_180, arg4_180
	end

	local var0_180 = arg0_180[arg2_180]
	local var1_180 = arg1_180[var0_180]

	arg4_180 = arg4_180 == nil and "" or arg4_180

	if var1_180 then
		if var1_180.this then
			return wordLegalMatch(arg0_180, var1_180, arg2_180 + 1, true, arg4_180 .. var0_180)
		else
			return wordLegalMatch(arg0_180, var1_180, arg2_180 + 1, false, arg4_180 .. var0_180)
		end
	else
		return arg3_180, arg2_180, arg4_180
	end
end

local var12_0 = string.byte("a")
local var13_0 = string.byte("z")
local var14_0 = string.byte("A")
local var15_0 = string.byte("Z")

local function var16_0(arg0_181)
	if not arg0_181 then
		return arg0_181
	end

	local var0_181 = string.byte(arg0_181)

	if var0_181 > 128 then
		return
	end

	if var0_181 >= var12_0 and var0_181 <= var13_0 then
		return string.char(var0_181 - 32)
	elseif var0_181 >= var14_0 and var0_181 <= var15_0 then
		return string.char(var0_181 + 32)
	else
		return arg0_181
	end
end

function wordVerMatch(arg0_182, arg1_182, arg2_182, arg3_182, arg4_182, arg5_182, arg6_182, arg7_182)
	if arg3_182 > #arg0_182 then
		return arg5_182, arg6_182, arg7_182
	end

	local var0_182 = arg0_182[arg3_182]
	local var1_182 = arg1_182[var0_182]

	if var1_182 then
		local var2_182, var3_182, var4_182 = wordVerMatch(arg0_182, var1_182, arg2_182, arg3_182 + 1, arg2_182.isReplace and arg4_182 .. arg2_182.replaceWord or arg4_182, var1_182.this or arg5_182, var1_182.this and arg3_182 + 1 or arg6_182, var1_182.this and (arg2_182.isReplace and arg4_182 .. arg2_182.replaceWord or arg4_182) or arg7_182)

		if var2_182 then
			return var2_182, var3_182, var4_182
		end
	end

	local var5_182 = var16_0(var0_182)
	local var6_182 = arg1_182[var5_182]

	if var5_182 ~= var0_182 and var6_182 then
		local var7_182, var8_182, var9_182 = wordVerMatch(arg0_182, var6_182, arg2_182, arg3_182 + 1, arg2_182.isReplace and arg4_182 .. arg2_182.replaceWord or arg4_182, var6_182.this or arg5_182, var6_182.this and arg3_182 + 1 or arg6_182, var6_182.this and (arg2_182.isReplace and arg4_182 .. arg2_182.replaceWord or arg4_182) or arg7_182)

		if var7_182 then
			return var7_182, var8_182, var9_182
		end
	end

	return arg5_182, arg6_182, arg7_182
end

function wordSplit(arg0_183)
	local var0_183 = {}

	for iter0_183 in arg0_183.gmatch(arg0_183, "[\x01-\x7F�-�][�-�]*") do
		var0_183[#var0_183 + 1] = iter0_183
	end

	return var0_183
end

function contentWrap(arg0_184, arg1_184, arg2_184)
	local var0_184 = LuaHelper.WrapContent(arg0_184, arg1_184, arg2_184)

	return #var0_184 ~= #arg0_184, var0_184
end

function cancelRich(arg0_185)
	local var0_185

	for iter0_185 = 1, 20 do
		local var1_185

		arg0_185, var1_185 = string.gsub(arg0_185, "<([^>]*)>", "%1")

		if var1_185 <= 0 then
			break
		end
	end

	return arg0_185
end

function cancelColorRich(arg0_186)
	local var0_186

	for iter0_186 = 1, 20 do
		local var1_186

		arg0_186, var1_186 = string.gsub(arg0_186, "<color=#[a-zA-Z0-9]+>(.-)</color>", "%1")

		if var1_186 <= 0 then
			break
		end
	end

	return arg0_186
end

function getSkillConfig(arg0_187)
	local var0_187 = pg.buffCfg["buff_" .. arg0_187]

	if not var0_187 then
		return
	end

	local var1_187 = Clone(var0_187)

	var1_187.name = getSkillName(arg0_187)
	var1_187.desc = HXSet.hxLan(var1_187.desc)
	var1_187.desc_get = HXSet.hxLan(var1_187.desc_get)

	_.each(var1_187, function(arg0_188)
		arg0_188.desc = HXSet.hxLan(arg0_188.desc)
	end)

	return var1_187
end

function getSkillName(arg0_189)
	local var0_189 = pg.skill_data_template[arg0_189] or pg.skill_data_display[arg0_189]

	if var0_189 then
		return HXSet.hxLan(var0_189.name)
	else
		return ""
	end
end

function getSkillDescGet(arg0_190, arg1_190)
	local var0_190 = arg1_190 and pg.skill_world_display[arg0_190] and setmetatable({}, {
		__index = function(arg0_191, arg1_191)
			return pg.skill_world_display[arg0_190][arg1_191] or pg.skill_data_template[arg0_190][arg1_191]
		end
	}) or pg.skill_data_template[arg0_190]

	if not var0_190 then
		return ""
	end

	local var1_190 = var0_190.desc_get ~= "" and var0_190.desc_get or var0_190.desc

	for iter0_190, iter1_190 in pairs(var0_190.desc_get_add) do
		local var2_190 = setColorStr(iter1_190[1], COLOR_GREEN)

		if iter1_190[2] then
			var2_190 = var2_190 .. specialGSub(i18n("word_skill_desc_get"), "$1", setColorStr(iter1_190[2], COLOR_GREEN))
		end

		var1_190 = specialGSub(var1_190, "$" .. iter0_190, var2_190)
	end

	return HXSet.hxLan(var1_190)
end

function getSkillDescLearn(arg0_192, arg1_192, arg2_192)
	local var0_192 = arg2_192 and pg.skill_world_display[arg0_192] and setmetatable({}, {
		__index = function(arg0_193, arg1_193)
			return pg.skill_world_display[arg0_192][arg1_193] or pg.skill_data_template[arg0_192][arg1_193]
		end
	}) or pg.skill_data_template[arg0_192]

	if not var0_192 then
		return ""
	end

	local var1_192 = var0_192.desc

	if not var0_192.desc_add then
		return HXSet.hxLan(var1_192)
	end

	for iter0_192, iter1_192 in pairs(var0_192.desc_add) do
		local var2_192 = iter1_192[arg1_192][1]

		if iter1_192[arg1_192][2] then
			var2_192 = var2_192 .. specialGSub(i18n("word_skill_desc_learn"), "$1", iter1_192[arg1_192][2])
		end

		var1_192 = specialGSub(var1_192, "$" .. iter0_192, setColorStr(var2_192, COLOR_YELLOW))
	end

	return HXSet.hxLan(var1_192)
end

function getSkillDesc(arg0_194, arg1_194, arg2_194)
	local var0_194 = arg2_194 and pg.skill_world_display[arg0_194] and setmetatable({}, {
		__index = function(arg0_195, arg1_195)
			return pg.skill_world_display[arg0_194][arg1_195] or pg.skill_data_template[arg0_194][arg1_195]
		end
	}) or pg.skill_data_template[arg0_194]

	if not var0_194 then
		return ""
	end

	local var1_194 = var0_194.desc

	if not var0_194.desc_add then
		return HXSet.hxLan(var1_194)
	end

	for iter0_194, iter1_194 in pairs(var0_194.desc_add) do
		local var2_194 = setColorStr(iter1_194[arg1_194][1], COLOR_GREEN)

		var1_194 = specialGSub(var1_194, "$" .. iter0_194, var2_194)
	end

	return HXSet.hxLan(var1_194)
end

function specialGSub(arg0_196, arg1_196, arg2_196)
	arg0_196 = string.gsub(arg0_196, "<color=#", "<color=NNN")
	arg0_196 = string.gsub(arg0_196, "#", "")
	arg2_196 = string.gsub(arg2_196, "%%", "%%%%")
	arg0_196 = string.gsub(arg0_196, arg1_196, arg2_196)
	arg0_196 = string.gsub(arg0_196, "<color=NNN", "<color=#")

	return arg0_196
end

function topAnimation(arg0_197, arg1_197, arg2_197, arg3_197, arg4_197, arg5_197)
	local var0_197 = {}

	arg4_197 = arg4_197 or 0.27

	local var1_197 = 0.05

	if arg0_197 then
		local var2_197 = arg0_197.transform.localPosition.x

		setAnchoredPosition(arg0_197, {
			x = var2_197 - 500
		})
		shiftPanel(arg0_197, var2_197, nil, 0.05, arg4_197, true, true)
		setActive(arg0_197, true)
	end

	setActive(arg1_197, false)
	setActive(arg2_197, false)
	setActive(arg3_197, false)

	for iter0_197 = 1, 3 do
		table.insert(var0_197, LeanTween.delayedCall(arg4_197 + 0.13 + var1_197 * iter0_197, System.Action(function()
			if arg1_197 then
				setActive(arg1_197, not arg1_197.gameObject.activeSelf)
			end
		end)).uniqueId)
		table.insert(var0_197, LeanTween.delayedCall(arg4_197 + 0.02 + var1_197 * iter0_197, System.Action(function()
			if arg2_197 then
				setActive(arg2_197, not go(arg2_197).activeSelf)
			end

			if arg2_197 then
				setActive(arg3_197, not go(arg3_197).activeSelf)
			end
		end)).uniqueId)
	end

	if arg5_197 then
		table.insert(var0_197, LeanTween.delayedCall(arg4_197 + 0.13 + var1_197 * 3 + 0.1, System.Action(function()
			arg5_197()
		end)).uniqueId)
	end

	return var0_197
end

function cancelTweens(arg0_201)
	assert(arg0_201, "must provide cancel targets, LeanTween.cancelAll is not allow")

	for iter0_201, iter1_201 in ipairs(arg0_201) do
		if iter1_201 then
			LeanTween.cancel(iter1_201)
		end
	end
end

function getOfflineTimeStamp(arg0_202)
	local var0_202 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_202
	local var1_202 = ""

	if var0_202 <= 59 then
		var1_202 = i18n("just_now")
	elseif var0_202 <= 3599 then
		var1_202 = i18n("several_minutes_before", math.floor(var0_202 / 60))
	elseif var0_202 <= 86399 then
		var1_202 = i18n("several_hours_before", math.floor(var0_202 / 3600))
	else
		var1_202 = i18n("several_days_before", math.floor(var0_202 / 86400))
	end

	return var1_202
end

function playMovie(arg0_203, arg1_203, arg2_203)
	local var0_203 = GameObject.Find("OverlayCamera/Overlay/UITop/MoviePanel")

	if not IsNil(var0_203) then
		pg.UIMgr.GetInstance():LoadingOn()
		WWWLoader.Inst:LoadStreamingAsset(arg0_203, function(arg0_204)
			pg.UIMgr.GetInstance():LoadingOff()

			local var0_204 = GCHandle.Alloc(arg0_204, GCHandleType.Pinned)

			setActive(var0_203, true)

			local var1_204 = var0_203:AddComponent(typeof(CriManaMovieControllerForUI))

			var1_204.player:SetData(arg0_204, arg0_204.Length)

			var1_204.target = var0_203:GetComponent(typeof(Image))
			var1_204.loop = false
			var1_204.additiveMode = false
			var1_204.playOnStart = true

			local var2_204

			var2_204 = Timer.New(function()
				if var1_204.player.status == CriMana.Player.Status.PlayEnd or var1_204.player.status == CriMana.Player.Status.Stop or var1_204.player.status == CriMana.Player.Status.Error then
					var2_204:Stop()
					Object.Destroy(var1_204)
					GCHandle.Free(var0_204)
					setActive(var0_203, false)

					if arg1_203 then
						arg1_203()
					end
				end
			end, 0.2, -1)

			var2_204:Start()
			removeOnButton(var0_203)

			if arg2_203 then
				onButton(nil, var0_203, function()
					var1_204:Stop()
					GetOrAddComponent(var0_203, typeof(Button)).onClick:RemoveAllListeners()
				end, SFX_CANCEL)
			end
		end)
	elseif arg1_203 then
		arg1_203()
	end
end

PaintCameraAdjustOn = false

function cameraPaintViewAdjust(arg0_207)
	if PaintCameraAdjustOn ~= arg0_207 then
		local var0_207 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(CanvasScaler))

		if arg0_207 then
			var0_207.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight
			var0_207.matchWidthOrHeight = 1
		else
			var0_207.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand
		end

		pg.CameraFixMgr.GetInstance():BlockCameraRatioControll(arg0_207)

		PaintCameraAdjustOn = arg0_207
	end
end

function ManhattonDist(arg0_208, arg1_208)
	return math.abs(arg0_208.row - arg1_208.row) + math.abs(arg0_208.column - arg1_208.column)
end

function checkFirstHelpShow(arg0_209)
	local var0_209 = getProxy(SettingsProxy)

	if not var0_209:checkReadHelp(arg0_209) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[arg0_209].tip
		})
		var0_209:recordReadHelp(arg0_209)
	end
end

preOrientation = nil
preNotchFitterEnabled = false

function openPortrait(arg0_210)
	preOrientation = Input.deviceOrientation:ToString()

	originalPrint("Begining Orientation:" .. preOrientation)

	Screen.autorotateToPortrait = true
	Screen.autorotateToPortraitUpsideDown = true

	cameraPaintViewAdjust(true)
end

function closePortrait(arg0_211)
	Screen.autorotateToPortrait = false
	Screen.autorotateToPortraitUpsideDown = false

	originalPrint("Closing Orientation:" .. preOrientation)

	Screen.orientation = ScreenOrientation.LandscapeLeft

	local var0_211 = Timer.New(function()
		Screen.orientation = ScreenOrientation.AutoRotation
	end, 0.2, 1):Start()

	cameraPaintViewAdjust(false)
end

function enableNotch(arg0_213, arg1_213)
	if arg0_213 == nil then
		return
	end

	arg0_213:GetComponent("NotchAdapt").enabled = arg1_213
end

function comma_value(arg0_214)
	local var0_214 = arg0_214
	local var1_214 = 0

	repeat
		local var2_214

		var0_214, var2_214 = string.gsub(var0_214, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var2_214 == 0

	return var0_214
end

local var17_0 = 0.2

function SwitchPanel(arg0_215, arg1_215, arg2_215, arg3_215, arg4_215, arg5_215)
	arg3_215 = defaultValue(arg3_215, var17_0)

	if arg5_215 then
		LeanTween.cancel(go(arg0_215))
	end

	local var0_215 = Vector3.New(tf(arg0_215).localPosition.x, tf(arg0_215).localPosition.y, tf(arg0_215).localPosition.z)

	if arg1_215 then
		var0_215.x = arg1_215
	end

	if arg2_215 then
		var0_215.y = arg2_215
	end

	local var1_215 = LeanTween.move(rtf(arg0_215), var0_215, arg3_215):setEase(LeanTweenType.easeInOutSine)

	if arg4_215 then
		var1_215:setDelay(arg4_215)
	end

	return var1_215
end

function updateActivityTaskStatus(arg0_216)
	local var0_216 = arg0_216:getConfig("config_id")
	local var1_216, var2_216 = getActivityTask(arg0_216, true)

	if not var2_216 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_216.id
		})

		return true
	end

	return false
end

function updateCrusingActivityTask(arg0_217)
	local var0_217 = getProxy(TaskProxy)
	local var1_217 = arg0_217:getNDay()
	local var2_217 = pg.TimeMgr.GetInstance():GetServerOverWeek(arg0_217:getStartTime())

	for iter0_217, iter1_217 in ipairs(arg0_217:getConfig("config_data")) do
		local var3_217 = pg.battlepass_task_group[iter1_217]

		if var3_217 and var2_217 >= var3_217.group_mask then
			if underscore.any(underscore.flatten(var3_217.task_group), function(arg0_218)
				return var0_217:getTaskVO(arg0_218) == nil
			end) then
				pg.m02:sendNotification(GAME.CRUSING_CMD, {
					cmd = 1,
					activity_id = arg0_217.id
				})

				return true
			end
		elseif not var3_217 then
			warning("battlepass_task_group表中不存在 id = " .. iter1_217)
		end
	end

	return false
end

function setShipCardFrame(arg0_219, arg1_219, arg2_219)
	arg0_219.localScale = Vector3.one
	arg0_219.anchorMin = Vector2.zero
	arg0_219.anchorMax = Vector2.one

	local var0_219 = arg2_219 or arg1_219

	GetImageSpriteFromAtlasAsync("shipframe", var0_219, arg0_219)

	local var1_219 = pg.frame_resource[var0_219]

	if var1_219 then
		local var2_219 = var1_219.param

		arg0_219.offsetMin = Vector2(var2_219[1], var2_219[2])
		arg0_219.offsetMax = Vector2(var2_219[3], var2_219[4])
	else
		arg0_219.offsetMin = Vector2.zero
		arg0_219.offsetMax = Vector2.zero
	end
end

function setRectShipCardFrame(arg0_220, arg1_220, arg2_220)
	arg0_220.localScale = Vector3.one
	arg0_220.anchorMin = Vector2.zero
	arg0_220.anchorMax = Vector2.one

	setImageSprite(arg0_220, GetSpriteFromAtlas("shipframeb", "b" .. (arg2_220 or arg1_220)))

	local var0_220 = "b" .. (arg2_220 or arg1_220)
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

function setFrameEffect(arg0_221, arg1_221)
	if arg1_221 then
		local var0_221 = arg1_221 .. "(Clone)"
		local var1_221 = false

		eachChild(arg0_221, function(arg0_222)
			setActive(arg0_222, arg0_222.name == var0_221)

			var1_221 = var1_221 or arg0_222.name == var0_221
		end)

		if not var1_221 then
			LoadAndInstantiateAsync("effect", arg1_221, function(arg0_223)
				if IsNil(arg0_221) or findTF(arg0_221, var0_221) then
					Object.Destroy(arg0_223)
				else
					setParent(arg0_223, arg0_221)
					setActive(arg0_223, true)
				end
			end)
		end
	end

	setActive(arg0_221, arg1_221)
end

function setProposeMarkIcon(arg0_224, arg1_224)
	local var0_224 = arg0_224:Find("proposeShipCard(Clone)")
	local var1_224 = arg1_224.propose and not arg1_224:ShowPropose()

	if var0_224 then
		setActive(var0_224, var1_224)
	elseif var1_224 then
		pg.PoolMgr.GetInstance():GetUI("proposeShipCard", true, function(arg0_225)
			if IsNil(arg0_224) or arg0_224:Find("proposeShipCard(Clone)") then
				pg.PoolMgr.GetInstance():ReturnUI("proposeShipCard", arg0_225)
			else
				setParent(arg0_225, arg0_224, false)
			end
		end)
	end
end

function flushShipCard(arg0_226, arg1_226)
	local var0_226 = arg1_226:rarity2bgPrint()
	local var1_226 = findTF(arg0_226, "content/bg")

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var0_226, "", var1_226)

	local var2_226 = findTF(arg0_226, "content/ship_icon")
	local var3_226 = arg1_226 and {
		"shipYardIcon/" .. arg1_226:getPainting(),
		arg1_226:getPainting()
	} or {
		"shipYardIcon/unknown",
		""
	}

	GetImageSpriteFromAtlasAsync(var3_226[1], var3_226[2], var2_226)

	local var4_226 = arg1_226:getShipType()
	local var5_226 = findTF(arg0_226, "content/info/top/type")

	GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var4_226), var5_226)
	setText(findTF(arg0_226, "content/dockyard/lv/Text"), defaultValue(arg1_226.level, 1))

	local var6_226 = arg1_226:getStar()
	local var7_226 = arg1_226:getMaxStar()
	local var8_226 = findTF(arg0_226, "content/front/stars")

	setActive(var8_226, true)

	local var9_226 = findTF(var8_226, "star_tpl")
	local var10_226 = var8_226.childCount

	for iter0_226 = 1, Ship.CONFIG_MAX_STAR do
		local var11_226 = var10_226 < iter0_226 and cloneTplTo(var9_226, var8_226) or var8_226:GetChild(iter0_226 - 1)

		setActive(var11_226, iter0_226 <= var7_226)
		triggerToggle(var11_226, iter0_226 <= var6_226)
	end

	local var12_226 = findTF(arg0_226, "content/front/frame")
	local var13_226, var14_226 = arg1_226:GetFrameAndEffect()

	setShipCardFrame(var12_226, var0_226, var13_226)
	setFrameEffect(findTF(arg0_226, "content/front/bg_other"), var14_226)
	setProposeMarkIcon(arg0_226:Find("content/dockyard/propose"), arg1_226)
end

function TweenItemAlphaAndWhite(arg0_227)
	LeanTween.cancel(arg0_227)

	local var0_227 = GetOrAddComponent(arg0_227, "CanvasGroup")

	var0_227.alpha = 0

	LeanTween.alphaCanvas(var0_227, 1, 0.2):setUseEstimatedTime(true)

	local var1_227 = findTF(arg0_227.transform, "white_mask")

	if var1_227 then
		setActive(var1_227, false)
	end
end

function ClearTweenItemAlphaAndWhite(arg0_228)
	LeanTween.cancel(arg0_228)

	GetOrAddComponent(arg0_228, "CanvasGroup").alpha = 0
end

function getGroupOwnSkins(arg0_229)
	local var0_229 = {}
	local var1_229 = getProxy(ShipSkinProxy):getSkinList()
	local var2_229 = getProxy(CollectionProxy):getShipGroup(arg0_229)

	if var2_229 then
		local var3_229 = ShipGroup.getSkinList(arg0_229)

		for iter0_229, iter1_229 in ipairs(var3_229) do
			if iter1_229.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var1_229, iter1_229.id) or iter1_229.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var2_229.trans or iter1_229.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var2_229.married == 1 then
				var0_229[iter1_229.id] = true
			end
		end
	end

	return var0_229
end

function split(arg0_230, arg1_230)
	local var0_230 = {}

	if not arg0_230 then
		return nil
	end

	local var1_230 = #arg0_230
	local var2_230 = 1

	while var2_230 <= var1_230 do
		local var3_230 = string.find(arg0_230, arg1_230, var2_230)

		if var3_230 == nil then
			table.insert(var0_230, string.sub(arg0_230, var2_230, var1_230))

			break
		end

		table.insert(var0_230, string.sub(arg0_230, var2_230, var3_230 - 1))

		if var3_230 == var1_230 then
			table.insert(var0_230, "")

			break
		end

		var2_230 = var3_230 + 1
	end

	return var0_230
end

function NumberToChinese(arg0_231, arg1_231)
	local var0_231 = ""
	local var1_231 = #arg0_231

	for iter0_231 = 1, var1_231 do
		local var2_231 = string.sub(arg0_231, iter0_231, iter0_231)

		if var2_231 ~= "0" or var2_231 == "0" and not arg1_231 then
			if arg1_231 then
				if var1_231 >= 2 then
					if iter0_231 == 1 then
						if var2_231 == "1" then
							var0_231 = i18n("number_" .. 10)
						else
							var0_231 = i18n("number_" .. var2_231) .. i18n("number_" .. 10)
						end
					else
						var0_231 = var0_231 .. i18n("number_" .. var2_231)
					end
				else
					var0_231 = var0_231 .. i18n("number_" .. var2_231)
				end
			else
				var0_231 = var0_231 .. i18n("number_" .. var2_231)
			end
		end
	end

	return var0_231
end

function getActivityTask(arg0_232, arg1_232)
	local var0_232 = getProxy(TaskProxy)
	local var1_232 = arg0_232:getConfig("config_data")
	local var2_232 = arg0_232:getNDay(arg0_232.data1)
	local var3_232
	local var4_232
	local var5_232

	for iter0_232 = math.max(arg0_232.data3, 1), math.min(var2_232, #var1_232) do
		local var6_232 = _.flatten({
			var1_232[iter0_232]
		})

		for iter1_232, iter2_232 in ipairs(var6_232) do
			local var7_232 = var0_232:getTaskById(iter2_232)

			if var7_232 then
				return var7_232.id, var7_232
			end

			if var4_232 then
				var5_232 = var0_232:getFinishTaskById(iter2_232)

				if var5_232 then
					var4_232 = var5_232
				elseif arg1_232 then
					return iter2_232
				else
					return var4_232.id, var4_232
				end
			else
				var4_232 = var0_232:getFinishTaskById(iter2_232)
				var5_232 = var5_232 or iter2_232
			end
		end
	end

	if var4_232 then
		return var4_232.id, var4_232
	else
		return var5_232
	end
end

function setImageFromImage(arg0_233, arg1_233, arg2_233)
	local var0_233 = GetComponent(arg0_233, "Image")

	var0_233.sprite = GetComponent(arg1_233, "Image").sprite

	if arg2_233 then
		var0_233:SetNativeSize()
	end
end

function skinTimeStamp(arg0_234)
	local var0_234, var1_234, var2_234, var3_234 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_234)

	if var0_234 >= 1 then
		return i18n("limit_skin_time_day", var0_234)
	elseif var0_234 <= 0 and var1_234 > 0 then
		return i18n("limit_skin_time_day_min", var1_234, var2_234)
	elseif var0_234 <= 0 and var1_234 <= 0 and (var2_234 > 0 or var3_234 > 0) then
		return i18n("limit_skin_time_min", math.max(var2_234, 1))
	elseif var0_234 <= 0 and var1_234 <= 0 and var2_234 <= 0 and var3_234 <= 0 then
		return i18n("limit_skin_time_overtime")
	end
end

function skinCommdityTimeStamp(arg0_235)
	local var0_235 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_235 = math.max(arg0_235 - var0_235, 0)
	local var2_235 = math.floor(var1_235 / 86400)

	if var2_235 > 0 then
		return i18n("time_remaining_tip") .. var2_235 .. i18n("word_date")
	else
		local var3_235 = math.floor(var1_235 / 3600)

		if var3_235 > 0 then
			return i18n("time_remaining_tip") .. var3_235 .. i18n("word_hour")
		else
			local var4_235 = math.floor(var1_235 / 60)

			if var4_235 > 0 then
				return i18n("time_remaining_tip") .. var4_235 .. i18n("word_minute")
			else
				return i18n("time_remaining_tip") .. var1_235 .. i18n("word_second")
			end
		end
	end
end

function InstagramTimeStamp(arg0_236)
	local var0_236 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_236
	local var1_236 = var0_236 / 86400

	if var1_236 > 1 then
		return i18n("ins_word_day", math.floor(var1_236))
	else
		local var2_236 = var0_236 / 3600

		if var2_236 > 1 then
			return i18n("ins_word_hour", math.floor(var2_236))
		else
			local var3_236 = var0_236 / 60

			if var3_236 > 1 then
				return i18n("ins_word_minu", math.floor(var3_236))
			else
				return i18n("ins_word_minu", 1)
			end
		end
	end
end

function InstagramReplyTimeStamp(arg0_237)
	local var0_237 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_237
	local var1_237 = var0_237 / 86400

	if var1_237 > 1 then
		return i18n1(math.floor(var1_237) .. "d")
	else
		local var2_237 = var0_237 / 3600

		if var2_237 > 1 then
			return i18n1(math.floor(var2_237) .. "h")
		else
			local var3_237 = var0_237 / 60

			if var3_237 > 1 then
				return i18n1(math.floor(var3_237) .. "min")
			else
				return i18n1("1min")
			end
		end
	end
end

function attireTimeStamp(arg0_238)
	local var0_238, var1_238, var2_238, var3_238 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_238)

	if var0_238 <= 0 and var1_238 <= 0 and var2_238 <= 0 and var3_238 <= 0 then
		return i18n("limit_skin_time_overtime")
	else
		return i18n("attire_time_stamp", var0_238, var1_238, var2_238)
	end
end

function checkExist(arg0_239, ...)
	local var0_239 = {
		...
	}

	for iter0_239, iter1_239 in ipairs(var0_239) do
		if arg0_239 == nil then
			break
		end

		assert(type(arg0_239) == "table", "type error : intermediate target should be table")
		assert(type(iter1_239) == "table", "type error : param should be table")

		if type(arg0_239[iter1_239[1]]) == "function" then
			arg0_239 = arg0_239[iter1_239[1]](arg0_239, unpack(iter1_239[2] or {}))
		else
			arg0_239 = arg0_239[iter1_239[1]]
		end
	end

	return arg0_239
end

function AcessWithinNull(arg0_240, arg1_240)
	if arg0_240 == nil then
		return
	end

	assert(type(arg0_240) == "table")

	return arg0_240[arg1_240]
end

function showRepairMsgbox()
	local var0_241 = {
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var1_241 = {
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var2_241 = {
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
			var2_241,
			var1_241,
			var0_241
		}
	})
end

function resourceVerify(arg0_245, arg1_245)
	if CSharpVersion > 35 then
		BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()

		return
	end

	local var0_245 = Application.persistentDataPath .. "/hashes.csv"
	local var1_245
	local var2_245 = PathMgr.ReadAllLines(var0_245)
	local var3_245 = {}

	if arg0_245 then
		setActive(arg0_245, true)
	else
		pg.UIMgr.GetInstance():LoadingOn()
	end

	local function var4_245()
		if arg0_245 then
			setActive(arg0_245, false)
		else
			pg.UIMgr.GetInstance():LoadingOff()
		end

		print(var1_245)

		if var1_245 then
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

	local var5_245 = var2_245.Length
	local var6_245

	local function var7_245(arg0_248)
		if arg0_248 < 0 then
			var4_245()

			return
		end

		if arg1_245 then
			setSlider(arg1_245, 0, var5_245, var5_245 - arg0_248)
		end

		local var0_248 = string.split(var2_245[arg0_248], ",")
		local var1_248 = var0_248[1]
		local var2_248 = var0_248[3]
		local var3_248 = PathMgr.getAssetBundle(var1_248)

		if PathMgr.FileExists(var3_248) then
			local var4_248 = PathMgr.ReadAllBytes(PathMgr.getAssetBundle(var1_248))

			if var2_248 == HashUtil.CalcMD5(var4_248) then
				onNextTick(function()
					var7_245(arg0_248 - 1)
				end)

				return
			end
		end

		var1_245 = var1_248

		var4_245()
	end

	var7_245(var5_245 - 1)
end

function splitByWordEN(arg0_250, arg1_250)
	local var0_250 = string.split(arg0_250, " ")
	local var1_250 = ""
	local var2_250 = ""
	local var3_250 = arg1_250:GetComponent(typeof(RectTransform))
	local var4_250 = arg1_250:GetComponent(typeof(Text))
	local var5_250 = var3_250.rect.width

	for iter0_250, iter1_250 in ipairs(var0_250) do
		local var6_250 = var2_250

		var2_250 = var2_250 == "" and iter1_250 or var2_250 .. " " .. iter1_250

		setText(arg1_250, var2_250)

		if var5_250 < var4_250.preferredWidth then
			var1_250 = var1_250 == "" and var6_250 or var1_250 .. "\n" .. var6_250
			var2_250 = iter1_250
		end

		if iter0_250 >= #var0_250 then
			var1_250 = var1_250 == "" and var2_250 or var1_250 .. "\n" .. var2_250
		end
	end

	return var1_250
end

function checkBirthFormat(arg0_251)
	if #arg0_251 ~= 8 then
		return false
	end

	local var0_251 = 0
	local var1_251 = #arg0_251

	while var0_251 < var1_251 do
		local var2_251 = string.byte(arg0_251, var0_251 + 1)

		if var2_251 < 48 or var2_251 > 57 then
			return false
		end

		var0_251 = var0_251 + 1
	end

	return true
end

function isHalfBodyLive2D(arg0_252)
	local var0_252 = {
		"biaoqiang",
		"z23",
		"lafei",
		"lingbo",
		"mingshi",
		"xuefeng"
	}

	return _.any(var0_252, function(arg0_253)
		return arg0_253 == arg0_252
	end)
end

function GetServerState(arg0_254)
	local var0_254 = -1
	local var1_254 = 0
	local var2_254 = 1
	local var3_254 = 2
	local var4_254 = NetConst.GetServerStateUrl()

	if PLATFORM_CODE == PLATFORM_CH then
		var4_254 = string.gsub(var4_254, "https", "http")
	end

	VersionMgr.Inst:WebRequest(var4_254, function(arg0_255, arg1_255)
		local var0_255 = true
		local var1_255 = false

		for iter0_255 in string.gmatch(arg1_255, "\"state\":%d") do
			if iter0_255 ~= "\"state\":1" then
				var0_255 = false
			end

			var1_255 = true
		end

		if not var1_255 then
			var0_255 = false
		end

		if arg0_254 ~= nil then
			arg0_254(var0_255 and var2_254 or var1_254)
		end
	end)
end

function setScrollText(arg0_256, arg1_256)
	GetOrAddComponent(arg0_256, "ScrollText"):SetText(arg1_256)
end

function changeToScrollText(arg0_257, arg1_257)
	local var0_257 = GetComponent(arg0_257, typeof(Text))

	assert(var0_257, "without component<Text>")

	local var1_257 = arg0_257:Find("subText")

	if not var1_257 then
		var1_257 = cloneTplTo(arg0_257, arg0_257, "subText")

		eachChild(arg0_257, function(arg0_258)
			setActive(arg0_258, arg0_258 == var1_257)
		end)

		arg0_257:GetComponent(typeof(Text)).enabled = false
	end

	setScrollText(var1_257, arg1_257)
end

local var18_0
local var19_0
local var20_0
local var21_0

local function var22_0(arg0_259, arg1_259, arg2_259)
	local var0_259 = arg0_259:Find("base")
	local var1_259, var2_259, var3_259 = Equipment.GetInfoTrans(arg1_259, arg2_259)

	if arg1_259.nextValue then
		local var4_259 = {
			name = arg1_259.name,
			type = arg1_259.type,
			value = arg1_259.nextValue
		}
		local var5_259, var6_259 = Equipment.GetInfoTrans(var4_259, arg2_259)

		var2_259 = var2_259 .. setColorStr("   >   " .. var6_259, COLOR_GREEN)
	end

	setText(var0_259:Find("name"), var1_259)

	if var3_259 then
		local var7_259 = "<color=#afff72>(+" .. ys.Battle.BattleConst.UltimateBonus.AuxBoostValue * 100 .. "%)</color>"

		setText(var0_259:Find("value"), var2_259 .. var7_259)
	else
		setText(var0_259:Find("value"), var2_259)
	end

	setActive(var0_259:Find("value/up"), arg1_259.compare and arg1_259.compare > 0)
	setActive(var0_259:Find("value/down"), arg1_259.compare and arg1_259.compare < 0)
	triggerToggle(var0_259, arg1_259.lock_open)

	if not arg1_259.lock_open and arg1_259.sub and #arg1_259.sub > 0 then
		GetComponent(var0_259, typeof(Toggle)).enabled = true
	else
		setActive(var0_259:Find("name/close"), false)
		setActive(var0_259:Find("name/open"), false)

		GetComponent(var0_259, typeof(Toggle)).enabled = false
	end
end

local function var23_0(arg0_260, arg1_260, arg2_260, arg3_260)
	var22_0(arg0_260, arg2_260, arg3_260)

	if not arg2_260.sub or #arg2_260.sub == 0 then
		return
	end

	var20_0(arg0_260:Find("subs"), arg1_260, arg2_260.sub, arg3_260)
end

function var20_0(arg0_261, arg1_261, arg2_261, arg3_261)
	removeAllChildren(arg0_261)
	var21_0(arg0_261, arg1_261, arg2_261, arg3_261)
end

function var21_0(arg0_262, arg1_262, arg2_262, arg3_262)
	for iter0_262, iter1_262 in ipairs(arg2_262) do
		local var0_262 = cloneTplTo(arg1_262, arg0_262)

		var23_0(var0_262, arg1_262, iter1_262, arg3_262)
	end
end

function updateEquipInfo(arg0_263, arg1_263, arg2_263, arg3_263)
	local var0_263 = arg0_263:Find("attr_tpl")

	var20_0(arg0_263:Find("attrs"), var0_263, arg1_263.attrs, arg3_263)
	setActive(arg0_263:Find("skill"), arg2_263)

	if arg2_263 then
		var23_0(arg0_263:Find("skill/attr"), var0_263, {
			name = i18n("skill"),
			value = setColorStr(arg2_263.name, "#FFDE00FF")
		}, arg3_263)
		setText(arg0_263:Find("skill/value/Text"), getSkillDescGet(arg2_263.id))
	end

	setActive(arg0_263:Find("weapon"), #arg1_263.weapon.sub > 0)

	if #arg1_263.weapon.sub > 0 then
		var20_0(arg0_263:Find("weapon"), var0_263, {
			arg1_263.weapon
		}, arg3_263)
	end

	setActive(arg0_263:Find("equip_info"), #arg1_263.equipInfo.sub > 0)

	if #arg1_263.equipInfo.sub > 0 then
		var20_0(arg0_263:Find("equip_info"), var0_263, {
			arg1_263.equipInfo
		}, arg3_263)
	end

	var23_0(arg0_263:Find("part/attr"), var0_263, {
		name = i18n("equip_info_23")
	}, arg3_263)

	local var1_263 = arg0_263:Find("part/value")
	local var2_263 = var1_263:Find("label")
	local var3_263 = {}
	local var4_263 = {}

	if #arg1_263.part[1] == 0 and #arg1_263.part[2] == 0 then
		setmetatable(var3_263, {
			__index = function(arg0_264, arg1_264)
				return true
			end
		})
		setmetatable(var4_263, {
			__index = function(arg0_265, arg1_265)
				return true
			end
		})
	else
		for iter0_263, iter1_263 in ipairs(arg1_263.part[1]) do
			var3_263[iter1_263] = true
		end

		for iter2_263, iter3_263 in ipairs(arg1_263.part[2]) do
			var4_263[iter3_263] = true
		end
	end

	local var5_263 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var3_263, var4_263)

	UIItemList.StaticAlign(var1_263, var2_263, #var5_263, function(arg0_266, arg1_266, arg2_266)
		arg1_266 = arg1_266 + 1

		if arg0_266 == UIItemList.EventUpdate then
			local var0_266 = var5_263[arg1_266]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0_266), arg2_266)
			setActive(arg2_266:Find("main"), var3_263[var0_266] and not var4_263[var0_266])
			setActive(arg2_266:Find("sub"), var4_263[var0_266] and not var3_263[var0_266])
			setImageAlpha(arg2_266, not var3_263[var0_266] and not var4_263[var0_266] and 0.3 or 1)
		end
	end)
end

function updateEquipUpgradeInfo(arg0_267, arg1_267, arg2_267)
	local var0_267 = arg0_267:Find("attr_tpl")

	var20_0(arg0_267:Find("attrs"), var0_267, arg1_267.attrs, arg2_267)
	setActive(arg0_267:Find("weapon"), #arg1_267.weapon.sub > 0)

	if #arg1_267.weapon.sub > 0 then
		var20_0(arg0_267:Find("weapon"), var0_267, {
			arg1_267.weapon
		}, arg2_267)
	end

	setActive(arg0_267:Find("equip_info"), #arg1_267.equipInfo.sub > 0)

	if #arg1_267.equipInfo.sub > 0 then
		var20_0(arg0_267:Find("equip_info"), var0_267, {
			arg1_267.equipInfo
		}, arg2_267)
	end
end

function setCanvasOverrideSorting(arg0_268, arg1_268)
	local var0_268 = arg0_268.parent

	arg0_268:SetParent(pg.LayerWeightMgr.GetInstance().uiOrigin, false)

	if isActive(arg0_268) then
		GetOrAddComponent(arg0_268, typeof(Canvas)).overrideSorting = arg1_268
	else
		setActive(arg0_268, true)

		GetOrAddComponent(arg0_268, typeof(Canvas)).overrideSorting = arg1_268

		setActive(arg0_268, false)
	end

	arg0_268:SetParent(var0_268, false)
end

function createNewGameObject(arg0_269, arg1_269)
	local var0_269 = GameObject.New()

	if arg0_269 then
		var0_269.name = "model"
	end

	var0_269.layer = arg1_269 or Layer.UI

	return GetOrAddComponent(var0_269, "RectTransform")
end

function CreateShell(arg0_270)
	if type(arg0_270) ~= "table" and type(arg0_270) ~= "userdata" then
		return arg0_270
	end

	local var0_270 = setmetatable({
		__index = arg0_270
	}, arg0_270)

	return setmetatable({}, var0_270)
end

function CameraFittingSettin(arg0_271)
	local var0_271 = GetComponent(arg0_271, typeof(Camera))
	local var1_271 = 1.77777777777778
	local var2_271 = Screen.width / Screen.height

	if var2_271 < var1_271 then
		local var3_271 = var2_271 / var1_271

		var0_271.rect = var0_0.Rect.New(0, (1 - var3_271) / 2, 1, var3_271)
	end
end

function SwitchSpecialChar(arg0_272, arg1_272)
	if PLATFORM_CODE ~= PLATFORM_US then
		arg0_272 = arg0_272:gsub(" ", " ")
		arg0_272 = arg0_272:gsub("\t", "    ")
	end

	if not arg1_272 then
		arg0_272 = arg0_272:gsub("\n", " ")
	end

	return arg0_272
end

function AfterCheck(arg0_273, arg1_273)
	local var0_273 = {}

	for iter0_273, iter1_273 in ipairs(arg0_273) do
		var0_273[iter0_273] = iter1_273[1]()
	end

	arg1_273()

	for iter2_273, iter3_273 in ipairs(arg0_273) do
		if var0_273[iter2_273] ~= iter3_273[1]() then
			iter3_273[2]()
		end

		var0_273[iter2_273] = iter3_273[1]()
	end
end

function CompareFuncs(arg0_274, arg1_274)
	local var0_274 = {}

	local function var1_274(arg0_275, arg1_275)
		var0_274[arg0_275] = var0_274[arg0_275] or {}
		var0_274[arg0_275][arg1_275] = var0_274[arg0_275][arg1_275] or arg0_274[arg0_275](arg1_275)

		return var0_274[arg0_275][arg1_275]
	end

	return function(arg0_276, arg1_276)
		local var0_276 = 1

		while var0_276 <= #arg0_274 do
			local var1_276 = var1_274(var0_276, arg0_276)
			local var2_276 = var1_274(var0_276, arg1_276)

			if var1_276 == var2_276 then
				var0_276 = var0_276 + 1
			else
				return var1_276 < var2_276
			end
		end

		return tobool(arg1_274)
	end
end

function DropResultIntegration(arg0_277)
	local var0_277 = {}
	local var1_277 = 1

	while var1_277 <= #arg0_277 do
		local var2_277 = arg0_277[var1_277].type
		local var3_277 = arg0_277[var1_277].id

		var0_277[var2_277] = var0_277[var2_277] or {}

		if var0_277[var2_277][var3_277] then
			local var4_277 = arg0_277[var0_277[var2_277][var3_277]]
			local var5_277 = table.remove(arg0_277, var1_277)

			var4_277.count = var4_277.count + var5_277.count
		else
			var0_277[var2_277][var3_277] = var1_277
			var1_277 = var1_277 + 1
		end
	end

	local var6_277 = {
		function(arg0_278)
			local var0_278 = arg0_278.type
			local var1_278 = arg0_278.id

			if var0_278 == DROP_TYPE_SHIP then
				return 1
			elseif var0_278 == DROP_TYPE_RESOURCE then
				if var1_278 == 1 then
					return 2
				else
					return 3
				end
			elseif var0_278 == DROP_TYPE_ITEM then
				if var1_278 == 59010 then
					return 4
				elseif var1_278 == 59900 then
					return 5
				else
					local var2_278 = Item.getConfigData(var1_278)
					local var3_278 = var2_278 and var2_278.type or 0

					if var3_278 == 9 then
						return 6
					elseif var3_278 == 5 then
						return 7
					elseif var3_278 == 4 then
						return 8
					elseif var3_278 == 7 then
						return 9
					end
				end
			elseif var0_278 == DROP_TYPE_VITEM and var1_278 == 59011 then
				return 4
			end

			return 100
		end,
		function(arg0_279)
			local var0_279

			if arg0_279.type == DROP_TYPE_SHIP then
				var0_279 = pg.ship_data_statistics[arg0_279.id]
			elseif arg0_279.type == DROP_TYPE_ITEM then
				var0_279 = Item.getConfigData(arg0_279.id)
			end

			return (var0_279 and var0_279.rarity or 0) * -1
		end,
		function(arg0_280)
			return arg0_280.id
		end
	}

	table.sort(arg0_277, CompareFuncs(var6_277))
end

function getLoginConfig()
	if LOGIN_HX and PlayerProxy.GetDeviceMaxPlayerLevel() <= pg.gameset.LOGIN_HX_LV.key_value then
		return false, "login", "", false, ""
	end

	local var0_281 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_281 = 1

	for iter0_281, iter1_281 in ipairs(pg.login.all) do
		if pg.login[iter1_281].date ~= "stop" then
			local var2_281, var3_281 = parseTimeConfig(pg.login[iter1_281].date)

			assert(not var3_281)

			if pg.TimeMgr.GetInstance():inTime(var2_281, var0_281) then
				var1_281 = iter1_281

				break
			end
		end
	end

	local var4_281 = pg.login[var1_281].login_static

	var4_281 = var4_281 ~= "" and var4_281 or "login"

	local var5_281 = pg.login[var1_281].login_cri
	local var6_281 = var5_281 ~= "" and true or false
	local var7_281 = pg.login[var1_281].op_play == 1 and true or false
	local var8_281 = pg.login[var1_281].op_time

	if var8_281 == "" or not pg.TimeMgr.GetInstance():inTime(var8_281, var0_281) then
		var7_281 = false
	end

	local var9_281 = var8_281 == "" and var8_281 or table.concat(var8_281[1][1])

	return var6_281, var6_281 and var5_281 or var4_281, pg.login[var1_281].bgm, var7_281, var9_281
end

function setIntimacyIcon(arg0_282, arg1_282, arg2_282)
	local var0_282 = {}
	local var1_282

	seriesAsync({
		function(arg0_283)
			if arg0_282.childCount > 0 then
				var1_282 = arg0_282:GetChild(0)

				arg0_283()
			else
				LoadAndInstantiateAsync("template", "intimacytpl", function(arg0_284)
					var1_282 = tf(arg0_284)

					setParent(var1_282, arg0_282)
					arg0_283()
				end)
			end
		end,
		function(arg0_285)
			setImageAlpha(var1_282, arg2_282 and 0 or 1)
			eachChild(var1_282, function(arg0_286)
				setActive(arg0_286, false)
			end)

			if arg2_282 then
				local var0_285 = var1_282:Find(arg2_282 .. "(Clone)")

				if not var0_285 then
					LoadAndInstantiateAsync("ui", arg2_282, function(arg0_287)
						setParent(arg0_287, var1_282)
						setActive(arg0_287, true)
					end)
				else
					setActive(var0_285, true)
				end
			elseif arg1_282 then
				setImageSprite(var1_282, GetSpriteFromAtlas("energy", arg1_282), true)
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

function switch(arg0_290, arg1_290, arg2_290, ...)
	if arg1_290[arg0_290] then
		return arg1_290[arg0_290](...)
	elseif arg2_290 then
		return arg2_290(...)
	end
end

function parseTimeConfig(arg0_291)
	if type(arg0_291[1]) == "table" then
		return arg0_291[2], arg0_291[1]
	else
		return arg0_291
	end
end

local var25_0 = {
	__add = function(arg0_292, arg1_292)
		return NewPos(arg0_292.x + arg1_292.x, arg0_292.y + arg1_292.y)
	end,
	__sub = function(arg0_293, arg1_293)
		return NewPos(arg0_293.x - arg1_293.x, arg0_293.y - arg1_293.y)
	end,
	__mul = function(arg0_294, arg1_294)
		if type(arg1_294) == "number" then
			return NewPos(arg0_294.x * arg1_294, arg0_294.y * arg1_294)
		else
			return NewPos(arg0_294.x * arg1_294.x, arg0_294.y * arg1_294.y)
		end
	end,
	__eq = function(arg0_295, arg1_295)
		return arg0_295.x == arg1_295.x and arg0_295.y == arg1_295.y
	end,
	__tostring = function(arg0_296)
		return arg0_296.x .. "_" .. arg0_296.y
	end
}

function NewPos(arg0_297, arg1_297)
	assert(arg0_297 and arg1_297)

	local var0_297 = setmetatable({
		x = arg0_297,
		y = arg1_297
	}, var25_0)

	function var0_297.SqrMagnitude(arg0_298)
		return arg0_298.x * arg0_298.x + arg0_298.y * arg0_298.y
	end

	function var0_297.Normalize(arg0_299)
		local var0_299 = arg0_299:SqrMagnitude()

		if var0_299 > 1e-05 then
			return arg0_299 * (1 / math.sqrt(var0_299))
		else
			return NewPos(0, 0)
		end
	end

	return var0_297
end

local var26_0

function Timekeeping()
	warning(Time.realtimeSinceStartup - (var26_0 or Time.realtimeSinceStartup), Time.realtimeSinceStartup)

	var26_0 = Time.realtimeSinceStartup
end

function GetRomanDigit(arg0_301)
	return (string.char(226, 133, 160 + (arg0_301 - 1)))
end

function quickPlayAnimator(arg0_302, arg1_302)
	arg0_302:GetComponent(typeof(Animator)):Play(arg1_302, -1, 0)
end

function quickCheckAndPlayAnimator(arg0_303, arg1_303)
	local var0_303 = arg0_303:GetComponent(typeof(Animator))

	var0_303.enabled = true

	local var1_303 = Animator.StringToHash(arg1_303)

	if var0_303:HasState(0, var1_303) then
		var0_303:Play(arg1_303, -1, 0)
	end
end

function quickPlayAnimation(arg0_304, arg1_304)
	local var0_304 = arg0_304:GetComponent(typeof(Animation))

	var0_304:Stop()
	var0_304:Play(arg1_304)
end

function getSurveyUrl(arg0_305)
	local var0_305 = pg.survey_data_template[arg0_305]
	local var1_305

	if not IsUnityEditor then
		if PLATFORM_CODE == PLATFORM_CH then
			local var2_305 = getProxy(UserProxy):GetCacheGatewayInServerLogined()

			if var2_305 == PLATFORM_ANDROID then
				if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_BILI then
					var1_305 = var0_305.main_url
				else
					var1_305 = var0_305.uo_url
				end
			elseif var2_305 == PLATFORM_IPHONEPLAYER then
				var1_305 = var0_305.ios_url
			end
		elseif PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_KR then
			var1_305 = var0_305.main_url
		end
	else
		var1_305 = var0_305.main_url
	end

	local var3_305 = getProxy(PlayerProxy):getRawData().id
	local var4_305 = getProxy(UserProxy):getRawData().arg2 or ""
	local var5_305
	local var6_305 = PLATFORM == PLATFORM_ANDROID and 1 or PLATFORM == PLATFORM_IPHONEPLAYER and 2 or 3
	local var7_305 = getProxy(UserProxy):getRawData()
	local var8_305 = getProxy(ServerProxy):getRawData()[var7_305 and var7_305.server or 0]
	local var9_305 = var8_305 and var8_305.id or ""
	local var10_305 = getProxy(PlayerProxy):getRawData().level
	local var11_305 = var3_305 .. "_" .. arg0_305
	local var12_305 = var1_305
	local var13_305 = {
		var3_305,
		var4_305,
		var6_305,
		var9_305,
		var10_305,
		var11_305
	}

	if var12_305 then
		for iter0_305, iter1_305 in ipairs(var13_305) do
			var12_305 = string.gsub(var12_305, "$" .. iter0_305, tostring(iter1_305))
		end
	end

	originalPrint("survey url", tostring(var12_305))

	return var12_305
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

function FilterVarchar(arg0_307)
	assert(type(arg0_307) == "string" or type(arg0_307) == "table")

	if arg0_307 == "" then
		return nil
	end

	return arg0_307
end

function getGameset(arg0_308)
	local var0_308 = pg.gameset[arg0_308]

	assert(var0_308)

	return {
		var0_308.key_value,
		var0_308.description
	}
end

function getDorm3dGameset(arg0_309)
	local var0_309 = pg.dorm3d_set[arg0_309]

	assert(var0_309)

	return {
		var0_309.key_value_int,
		var0_309.key_value_varchar
	}
end

function GetItemsOverflowDic(arg0_310)
	arg0_310 = arg0_310 or {}

	local var0_310 = {
		[DROP_TYPE_ITEM] = {},
		[DROP_TYPE_RESOURCE] = {},
		[DROP_TYPE_EQUIP] = 0,
		[DROP_TYPE_SHIP] = 0,
		[DROP_TYPE_WORLD_ITEM] = 0
	}

	while #arg0_310 > 0 do
		local var1_310 = table.remove(arg0_310)

		switch(var1_310.type, {
			[DROP_TYPE_ITEM] = function()
				if var1_310:getConfig("open_directly") == 1 then
					for iter0_311, iter1_311 in ipairs(var1_310:getConfig("display_icon")) do
						local var0_311 = Drop.Create(iter1_311)

						var0_311.count = var0_311.count * var1_310.count

						table.insert(arg0_310, var0_311)
					end
				elseif var1_310:getSubClass():IsShipExpType() then
					var0_310[var1_310.type][var1_310.id] = defaultValue(var0_310[var1_310.type][var1_310.id], 0) + var1_310.count
				end
			end,
			[DROP_TYPE_RESOURCE] = function()
				var0_310[var1_310.type][var1_310.id] = defaultValue(var0_310[var1_310.type][var1_310.id], 0) + var1_310.count
			end,
			[DROP_TYPE_EQUIP] = function()
				var0_310[var1_310.type] = var0_310[var1_310.type] + var1_310.count
			end,
			[DROP_TYPE_SHIP] = function()
				var0_310[var1_310.type] = var0_310[var1_310.type] + var1_310.count
			end,
			[DROP_TYPE_WORLD_ITEM] = function()
				var0_310[var1_310.type] = var0_310[var1_310.type] + var1_310.count
			end
		})
	end

	return var0_310
end

function CheckOverflow(arg0_316, arg1_316)
	local var0_316 = {}
	local var1_316 = arg0_316[DROP_TYPE_RESOURCE][PlayerConst.ResGold] or 0
	local var2_316 = arg0_316[DROP_TYPE_RESOURCE][PlayerConst.ResOil] or 0
	local var3_316 = arg0_316[DROP_TYPE_EQUIP]
	local var4_316 = arg0_316[DROP_TYPE_SHIP]
	local var5_316 = getProxy(PlayerProxy):getRawData()
	local var6_316 = false

	if arg1_316 then
		local var7_316 = var5_316:OverStore(PlayerConst.ResStoreGold, var1_316)
		local var8_316 = var5_316:OverStore(PlayerConst.ResStoreOil, var2_316)

		if var7_316 > 0 or var8_316 > 0 then
			var0_316.isStoreOverflow = {
				var7_316,
				var8_316
			}
		end
	else
		if var1_316 > 0 and var5_316:GoldMax(var1_316) then
			return false, "gold"
		end

		if var2_316 > 0 and var5_316:OilMax(var2_316) then
			return false, "oil"
		end
	end

	var0_316.isExpBookOverflow = {}

	for iter0_316, iter1_316 in pairs(arg0_316[DROP_TYPE_ITEM]) do
		local var9_316 = Item.getConfigData(iter0_316)

		if getProxy(BagProxy):getItemCountById(iter0_316) + iter1_316 > var9_316.max_num then
			table.insert(var0_316.isExpBookOverflow, iter0_316)
		end
	end

	local var10_316 = getProxy(EquipmentProxy):getCapacity()

	if var3_316 > 0 and var10_316 >= var5_316:getMaxEquipmentBag() then
		return false, "equip"
	end

	local var11_316 = getProxy(BayProxy):getShipCount()

	if var4_316 > 0 and var4_316 + var11_316 > var5_316:getMaxShipBag() then
		return false, "ship"
	end

	return true, var0_316
end

function CheckShipExpOverflow(arg0_317)
	local var0_317 = getProxy(BagProxy)

	for iter0_317, iter1_317 in pairs(arg0_317[DROP_TYPE_ITEM]) do
		if var0_317:getItemCountById(iter0_317) + iter1_317 > Item.getConfigData(iter0_317).max_num then
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

function RegisterDetailButton(arg0_318, arg1_318, arg2_318)
	Drop.Change(arg2_318)
	switch(arg2_318.type, {
		[DROP_TYPE_ITEM] = function()
			if arg2_318:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
				local var0_319 = Item.getConfigData(arg2_318.id).usage_arg
				local var1_319 = var0_319[3]

				if Item.InTimeLimitSkinAssigned(arg2_318.id) then
					var1_319 = table.mergeArray(var0_319[2], var1_319, true)
				end

				local var2_319 = {}

				for iter0_319, iter1_319 in ipairs(var0_319[2]) do
					var2_319[iter1_319] = true
				end

				onButton(arg0_318, arg1_318, function()
					arg0_318:closeView()
					pg.m02:sendNotification(GAME.LOAD_LAYERS, {
						parentContext = getProxy(ContextProxy):getCurrentContext(),
						context = Context.New({
							viewComponent = NewSelectSkinLayer,
							mediator = NewSkinAtlasMediator,
							data = {
								mode = SelectSkinLayer.MODE_VIEW,
								itemId = arg2_318.id,
								selectableSkinList = underscore.map(var1_319, function(arg0_321)
									return SelectableSkin.New({
										id = arg0_321,
										isTimeLimit = var2_319[arg0_321] or false
									})
								end)
							}
						})
					})
				end, SFX_PANEL)
				setActive(arg1_318, true)
			else
				local var3_319 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_318.id) and "tech" or arg2_318:getConfig("type")

				if var27_0[var3_319] then
					local var4_319 = {
						item2Row = true,
						content = i18n(var27_0[var3_319]),
						itemList = underscore.map(arg2_318:getConfig("display_icon"), function(arg0_322)
							return Drop.Create(arg0_322)
						end)
					}

					if var3_319 == 11 then
						onButton(arg0_318, arg1_318, function()
							arg0_318:emit(BaseUI.ON_DROP_LIST_OWN, var4_319)
						end, SFX_PANEL)
					else
						onButton(arg0_318, arg1_318, function()
							arg0_318:emit(BaseUI.ON_DROP_LIST, var4_319)
						end, SFX_PANEL)
					end
				end

				setActive(arg1_318, tobool(var27_0[var3_319]))
			end
		end,
		[DROP_TYPE_EQUIP] = function()
			onButton(arg0_318, arg1_318, function()
				arg0_318:emit(BaseUI.ON_DROP, arg2_318)
			end, SFX_PANEL)
			setActive(arg1_318, true)
		end,
		[DROP_TYPE_SPWEAPON] = function()
			onButton(arg0_318, arg1_318, function()
				arg0_318:emit(BaseUI.ON_DROP, arg2_318)
			end, SFX_PANEL)
			setActive(arg1_318, true)
		end
	}, function()
		setActive(arg1_318, false)
	end)
end

function RegisterNewStyleDetailButton(arg0_330, arg1_330, arg2_330)
	Drop.Change(arg2_330)
	switch(arg2_330.type, {
		[DROP_TYPE_ITEM] = function()
			local var0_331 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_330.id) and "tech" or arg2_330:getConfig("type")

			if var27_0[var0_331] then
				local var1_331 = {
					useDeepShow = true,
					showOwn = var0_331 == 11,
					content = i18n(var27_0[var0_331]),
					itemList = underscore.map(arg2_330:getConfig("display_icon"), function(arg0_332)
						return Drop.Create(arg0_332)
					end)
				}

				onButton(arg0_330, arg1_330, function()
					arg0_330:emit(BaseUI.ON_NEW_STYLE_ITEMS, var1_331)
				end, SFX_PANEL)
			end

			setActive(arg1_330, tobool(var27_0[var0_331]))
		end
	}, function()
		setActive(arg1_330, false)
	end)
end

function UpdateOwnDisplay(arg0_335, arg1_335)
	local var0_335, var1_335 = arg1_335:getOwnedCount()

	setActive(arg0_335, var1_335 and var0_335 > 0)

	if var1_335 and var0_335 > 0 then
		setText(arg0_335:Find("label"), i18n("word_own1"))
		setText(arg0_335:Find("Text"), var0_335)
	end
end

function Damp(arg0_336, arg1_336, arg2_336)
	arg1_336 = Mathf.Max(1, arg1_336)

	local var0_336 = Mathf.Epsilon

	if arg1_336 < var0_336 or var0_336 > Mathf.Abs(arg0_336) then
		return arg0_336
	end

	if arg2_336 < var0_336 then
		return 0
	end

	local var1_336 = -4.605170186

	return arg0_336 * (1 - Mathf.Exp(var1_336 * arg2_336 / arg1_336))
end

function checkCullResume(arg0_337, arg1_337)
	if arg1_337 or not ReflectionHelp.RefCallMethodEx(typeof("UnityEngine.CanvasRenderer"), "GetMaterial", GetComponent(arg0_337, "CanvasRenderer"), {
		typeof("System.Int32")
	}, {
		0
	}) then
		local var0_337 = arg0_337:GetComponentsInChildren(typeof(var0_0.UI.Graphic)):ToTable()

		for iter0_337, iter1_337 in ipairs(var0_337) do
			iter1_337:SetVerticesDirty()
		end

		return false
	end

	return true
end

function parseEquipCode(arg0_338)
	local var0_338 = {}

	if arg0_338 and arg0_338 ~= "" then
		local var1_338 = base64.dec(arg0_338)

		var0_338 = string.split(var1_338, "/")
		var0_338[5], var0_338[6] = unpack(string.split(var0_338[5], "\\"))

		if #var0_338 < 6 or arg0_338 ~= base64.enc(table.concat({
			table.concat(underscore.first(var0_338, 5), "/"),
			var0_338[6]
		}, "\\")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_illegal"))

			var0_338 = {}
		end
	end

	for iter0_338 = 1, 6 do
		var0_338[iter0_338] = var0_338[iter0_338] and tonumber(var0_338[iter0_338], 32) or 0
	end

	return var0_338
end

function buildEquipCode(arg0_339)
	local var0_339 = underscore.map(arg0_339:getAllEquipments(), function(arg0_340)
		return ConversionBase(32, arg0_340 and arg0_340.id or 0)
	end)
	local var1_339 = {
		table.concat(var0_339, "/"),
		ConversionBase(32, checkExist(arg0_339:GetSpWeapon(), {
			"id"
		}) or 0)
	}

	return base64.enc(table.concat(var1_339, "\\"))
end

function setDirectorSpeed(arg0_341, arg1_341)
	GetComponent(arg0_341, typeof(TimelineSpeed)):SetTimelineSpeed(arg1_341)
end

function setDefaultZeroMetatable(arg0_342)
	return setmetatable(arg0_342, {
		__index = function(arg0_343, arg1_343)
			if rawget(arg0_343, arg1_343) == nil then
				arg0_343[arg1_343] = 0
			end

			return arg0_343[arg1_343]
		end
	})
end

function checkABExist(arg0_344)
	if EDITOR_TOOL then
		return ResourceMgr.Inst:AssetExist(arg0_344)
	else
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_344))
	end
end

function compareNumber(arg0_345, arg1_345, arg2_345)
	return switch(arg1_345, {
		[">"] = function()
			return arg0_345 > arg2_345
		end,
		[">="] = function()
			return arg0_345 >= arg2_345
		end,
		["="] = function()
			return arg0_345 == arg2_345
		end,
		["<"] = function()
			return arg0_345 < arg2_345
		end,
		["<="] = function()
			return arg0_345 <= arg2_345
		end
	})
end

function ArabicToRoman(arg0_351)
	local var0_351 = {
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

	local function var1_351(arg0_352, arg1_352)
		return select(2, arg0_352:gsub(arg1_352, ""))
	end

	local var2_351 = ""

	while arg0_351 > 0 do
		for iter0_351, iter1_351 in pairs(var0_351) do
			local var3_351 = iter1_351[2]
			local var4_351 = iter1_351[1]

			while var4_351 <= arg0_351 do
				var2_351 = var2_351 .. var3_351
				arg0_351 = arg0_351 - var4_351
			end
		end
	end

	if arg0_351 > 10000 then
		local var5_351 = var1_351(var2_351, "M")

		var2_351 = "M*" .. var5_351 .. " " .. var2_351
	end

	return var2_351
end

function stringInset(arg0_353, ...)
	for iter0_353, iter1_353 in ipairs({
		...
	}) do
		arg0_353 = string.gsub(arg0_353, "$" .. iter0_353, iter1_353)
	end

	return arg0_353
end

function addSubLayer(arg0_354, arg1_354, arg2_354, arg3_354, arg4_354)
	if arg2_354 then
		while arg1_354.parent do
			arg1_354 = arg1_354.parent
		end
	end

	local var0_354 = {
		parentContext = arg1_354,
		context = arg0_354,
		callback = arg3_354
	}

	var0_354 = arg4_354 and table.merge(var0_354, arg4_354) or var0_354

	pg.m02:sendNotification(GAME.LOAD_LAYERS, var0_354)
end
