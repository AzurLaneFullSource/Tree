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

function updateIslandSkin(arg0_113, arg1_113)
	local var0_113 = arg1_113:getConfigTable().icon

	GetImageSpriteFromAtlasAsync("island/IslandDressIcon/" .. var0_113, "", findTF(arg0_113, "icon_bg/icon"))
	setActive(findTF(arg0_113, "icon_bg/count_bg"), arg1_113.count > 0)
	setText(findTF(arg0_113, "icon_bg/count_bg/count"), arg1_113.count)
	setIconName(arg0_113, arg1_113:getConfigTable().name, {})
	setIslandRarityFrame(arg0_113, arg1_113)
end

function updateIslandWatherCollect(arg0_114, arg1_114)
	local var0_114 = arg1_114:getConfigTable().icon
	local var1_114 = arg1_114:getConfigTable().name

	setText(findTF(arg0_114, "icon_bg/count"), arg1_114.count)
	GetImageSpriteFromAtlasAsync("island/" .. var0_114, "", findTF(arg0_114, "icon_bg/icon"))
	setIconName(arg0_114, var1_114, {})
	setIslandRarityFrame(arg0_114, arg1_114)
end

function updateWorldItem(arg0_115, arg1_115, arg2_115)
	arg2_115 = arg2_115 or {}

	local var0_115 = ItemRarity.Rarity2Print(arg1_115:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_115, findTF(arg0_115, "icon_bg"))
	setFrame(findTF(arg0_115, "icon_bg/frame"), var0_115)

	local var1_115 = findTF(arg0_115, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_115.icon or arg1_115:getConfig("icon"), "", var1_115)
	setIconStars(arg0_115, false)
	setIconName(arg0_115, arg1_115:getConfig("name"), arg2_115)
	setIconColorful(arg0_115, arg1_115:getConfig("rarity"), arg2_115)
end

function updateWorldCollection(arg0_116, arg1_116, arg2_116)
	arg2_116 = arg2_116 or {}

	assert(arg1_116:getConfigTable(), "world_collection_file_template 和 world_collection_record_template 表中找不到配置: " .. arg1_116.id)

	local var0_116 = arg1_116:getDropRarity()
	local var1_116 = ItemRarity.Rarity2Print(var0_116)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_116, findTF(arg0_116, "icon_bg"))
	setFrame(findTF(arg0_116, "icon_bg/frame"), var1_116)

	local var2_116 = findTF(arg0_116, "icon_bg/icon")
	local var3_116 = WorldCollectionProxy.GetCollectionType(arg1_116.id) == WorldCollectionProxy.WorldCollectionType.FILE and "shoucangguangdie" or "shoucangjiaojuan"

	GetImageSpriteFromAtlasAsync("props/" .. var3_116, "", var2_116)
	setIconStars(arg0_116, false)
	setIconName(arg0_116, arg1_116:getName(), arg2_116)
	setIconColorful(arg0_116, var0_116, arg2_116)
end

function updateWorldBuff(arg0_117, arg1_117, arg2_117)
	arg2_117 = arg2_117 or {}

	local var0_117 = pg.world_SLGbuff_data[arg1_117]

	assert(var0_117, "找不到大世界buff配置: " .. arg1_117)

	local var1_117 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_117, findTF(arg0_117, "icon_bg"))
	setFrame(findTF(arg0_117, "icon_bg/frame"), var1_117)

	local var2_117 = findTF(arg0_117, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("world/buff/" .. var0_117.icon, "", var2_117)

	local var3_117 = arg0_117:Find("icon_bg/stars")

	if not IsNil(var3_117) then
		setActive(var3_117, false)
	end

	local var4_117 = findTF(arg0_117, "name")

	if not IsNil(var4_117) then
		setText(var4_117, var0_117.name)
	end

	local var5_117 = findTF(arg0_117, "icon_bg/count")

	if not IsNil(var5_117) then
		SetActive(var5_117, false)
	end
end

function updateShip(arg0_118, arg1_118, arg2_118)
	arg2_118 = arg2_118 or {}

	local var0_118 = arg1_118:rarity2bgPrint()
	local var1_118 = arg1_118:getPainting()

	if arg2_118.anonymous then
		var0_118 = "1"
		var1_118 = "unknown"
	end

	if arg2_118.unknown_small then
		var1_118 = "unknown_small"
	end

	local var2_118 = findTF(arg0_118, "icon_bg/new")

	if var2_118 then
		if arg2_118.isSkin then
			setActive(var2_118, not arg2_118.isTimeLimit and arg2_118.isNew)
		else
			setActive(var2_118, arg1_118.virgin)
		end
	end

	local var3_118 = findTF(arg0_118, "icon_bg/timelimit")

	if var3_118 then
		setActive(var3_118, arg2_118.isTimeLimit)
	end

	local var4_118 = findTF(arg0_118, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. (arg2_118.isSkin and "_skin" or var0_118), var4_118)

	local var5_118 = findTF(arg0_118, "icon_bg/frame")
	local var6_118

	if arg1_118.isNpc then
		var6_118 = "frame_npc"
	elseif arg1_118:ShowPropose() then
		var6_118 = "frame_prop"

		if arg1_118:isMetaShip() then
			var6_118 = var6_118 .. "_meta"
		end
	elseif arg2_118.isSkin then
		var6_118 = "frame_skin"
	end

	setFrame(var5_118, var0_118, var6_118)

	if arg2_118.gray then
		setGray(var4_118, true, true)
	end

	local var7_118 = findTF(arg0_118, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg2_118.Q and "QIcon/" or "SquareIcon/") .. var1_118, "", var7_118)

	local var8_118 = findTF(arg0_118, "icon_bg/lv")

	if var8_118 then
		setActive(var8_118, not arg1_118.isNpc)

		if not arg1_118.isNpc then
			local var9_118 = findTF(var8_118, "Text")

			if var9_118 and arg1_118.level then
				setText(var9_118, arg1_118.level)
			end
		end
	end

	local var10_118 = findTF(arg0_118, "ship_type")

	if var10_118 then
		setActive(var10_118, true)
		setImageSprite(var10_118, GetSpriteFromAtlas("shiptype", shipType2print(arg1_118:getShipType())))
	end

	local var11_118 = var4_118:Find("npc")

	if not IsNil(var11_118) then
		if var2_118 and go(var2_118).activeSelf then
			setActive(var11_118, false)
		else
			setActive(var11_118, arg1_118:isActivityNpc())
		end
	end

	local var12_118 = arg0_118:Find("group_locked")

	if var12_118 then
		setActive(var12_118, not arg2_118.isSkin and not getProxy(CollectionProxy):getShipGroup(arg1_118.groupId))
	end

	setIconStars(arg0_118, arg2_118.initStar, arg1_118:getStar())
	setIconName(arg0_118, arg2_118.isSkin and arg1_118:GetSkinConfig().name or arg1_118:getName(), arg2_118)
	setIconColorful(arg0_118, arg2_118.isSkin and ItemRarity.Gold or arg1_118:getRarity() - 1, arg2_118)
end

function updateCommander(arg0_119, arg1_119, arg2_119)
	arg2_119 = arg2_119 or {}

	local var0_119 = arg1_119:getDropRarity()
	local var1_119 = ItemRarity.Rarity2Print(var0_119)
	local var2_119 = arg1_119:getConfig("painting")

	if arg2_119.anonymous then
		var1_119 = 1
		var2_119 = "unknown"
	end

	local var3_119 = findTF(arg0_119, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_119, var3_119)

	local var4_119 = findTF(arg0_119, "icon_bg/frame")

	setFrame(var4_119, var1_119)

	if arg2_119.gray then
		setGray(var3_119, true, true)
	end

	local var5_119 = findTF(arg0_119, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("CommanderIcon/" .. var2_119, "", var5_119)
	setIconStars(arg0_119, arg2_119.initStar, 0)
	setIconName(arg0_119, arg1_119:getName(), arg2_119)
end

function updateStrategy(arg0_120, arg1_120, arg2_120)
	arg2_120 = arg2_120 or {}

	local var0_120 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_120, findTF(arg0_120, "icon_bg"))
	setFrame(findTF(arg0_120, "icon_bg/frame"), var0_120)

	local var1_120 = findTF(arg0_120, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg1_120.isWorldBuff and "world/buff/" or "strategyicon/") .. arg1_120:getIcon(), "", var1_120)
	setIconStars(arg0_120, false)
	setIconName(arg0_120, arg1_120:getName(), arg2_120)
	setIconColorful(arg0_120, ItemRarity.Gray, arg2_120)
end

function updateFurniture(arg0_121, arg1_121, arg2_121)
	arg2_121 = arg2_121 or {}

	local var0_121 = arg1_121:getDropRarity()
	local var1_121 = ItemRarity.Rarity2Print(var0_121)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_121, findTF(arg0_121, "icon_bg"))
	setFrame(findTF(arg0_121, "icon_bg/frame"), var1_121)

	local var2_121 = findTF(arg0_121, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1_121:getIcon(), "", var2_121)
	setIconStars(arg0_121, false)
	setIconName(arg0_121, arg1_121:getName(), arg2_121)
	setIconColorful(arg0_121, var0_121, arg2_121)
end

function updateSpWeapon(arg0_122, arg1_122, arg2_122)
	arg2_122 = arg2_122 or {}

	assert(arg1_122, "spWeaponVO can not be nil.")
	assert(isa(arg1_122, SpWeapon), "spWeaponVO is not Equipment.")

	local var0_122 = ItemRarity.Rarity2Print(arg1_122:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_122, findTF(arg0_122, "icon_bg"))
	setFrame(findTF(arg0_122, "icon_bg/frame"), var0_122)

	local var1_122 = findTF(arg0_122, "icon_bg/icon")

	var4_0(var1_122, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync(arg1_122:GetIconPath(), "", var1_122)
	setIconStars(arg0_122, true, arg1_122:GetRarity())
	var7_0(arg0_122, arg1_122:GetLevel() - 1)
	setIconName(arg0_122, arg1_122:GetName(), arg2_122)
	setIconCount(arg0_122, arg1_122.count)
	setIconColorful(arg0_122, arg1_122:GetRarity(), arg2_122)
end

function UpdateSpWeaponSlot(arg0_123, arg1_123, arg2_123)
	local var0_123 = ItemRarity.Rarity2Print(arg1_123:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_123, findTF(arg0_123, "Icon/Mask/icon_bg"))

	local var1_123 = findTF(arg0_123, "Icon/Mask/icon_bg/icon")

	arg2_123 = arg2_123 or {
		16,
		16,
		16,
		16
	}

	var4_0(var1_123, arg2_123)
	GetImageSpriteFromAtlasAsync(arg1_123:GetIconPath(), "", var1_123)

	local var2_123 = arg1_123:GetLevel() - 1
	local var3_123 = findTF(arg0_123, "Icon/LV")

	setActive(var3_123, var2_123 > 0)
	setText(findTF(var3_123, "Text"), var2_123)
end

function updateDorm3dIcon(arg0_124, arg1_124)
	local var0_124 = arg1_124:getDropRarityDorm()

	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(var0_124), arg0_124)

	local var1_124 = arg0_124:Find("icon")

	GetImageSpriteFromAtlasAsync(arg1_124:getIcon(), "", var1_124)
	setText(arg0_124:Find("count/Text"), "x" .. arg1_124.count)
	setText(arg0_124:Find("name/Text"), arg1_124:getName())
end

local var8_0

function findCullAndClipWorldRect(arg0_125)
	if #arg0_125 == 0 then
		return false
	end

	local var0_125 = arg0_125[1].canvasRect

	for iter0_125 = 1, #arg0_125 do
		var0_125 = rectIntersect(var0_125, arg0_125[iter0_125].canvasRect)
	end

	if var0_125.width <= 0 or var0_125.height <= 0 then
		return false
	end

	var8_0 = var8_0 or GameObject.Find("UICamera/Canvas").transform

	local var1_125 = var8_0:TransformPoint(Vector3(var0_125.x, var0_125.y, 0))
	local var2_125 = var8_0:TransformPoint(Vector3(var0_125.x + var0_125.width, var0_125.y + var0_125.height, 0))

	return true, Vector4(var1_125.x, var1_125.y, var2_125.x, var2_125.y)
end

function rectIntersect(arg0_126, arg1_126)
	local var0_126 = math.max(arg0_126.x, arg1_126.x)
	local var1_126 = math.min(arg0_126.x + arg0_126.width, arg1_126.x + arg1_126.width)
	local var2_126 = math.max(arg0_126.y, arg1_126.y)
	local var3_126 = math.min(arg0_126.y + arg0_126.height, arg1_126.y + arg1_126.height)

	if var0_126 <= var1_126 and var2_126 <= var3_126 then
		return var0_0.Rect.New(var0_126, var2_126, var1_126 - var0_126, var3_126 - var2_126)
	end

	return var0_0.Rect.New(0, 0, 0, 0)
end

function getDropInfo(arg0_127)
	local var0_127 = {}

	for iter0_127, iter1_127 in ipairs(arg0_127) do
		local var1_127 = Drop.Create(iter1_127)

		var1_127.count = var1_127.count or 1

		if var1_127.type == DROP_TYPE_EMOJI then
			table.insert(var0_127, var1_127:getName())
		else
			table.insert(var0_127, var1_127:getName() .. "x" .. var1_127.count)
		end
	end

	return table.concat(var0_127, "、")
end

function updateDrop(arg0_128, arg1_128, arg2_128)
	Drop.Change(arg1_128)

	arg2_128 = arg2_128 or {}

	local var0_128 = {
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
	local var1_128

	for iter0_128, iter1_128 in ipairs(var0_128) do
		local var2_128 = arg0_128:Find(iter1_128[1])

		if arg1_128.type ~= iter1_128[2] and not IsNil(var2_128) then
			setActive(var2_128, false)
		end
	end

	if not IsNil(arg0_128:Find("icon_bg/frame")) then
		arg0_128:Find("icon_bg/frame"):GetComponent(typeof(Image)).enabled = true

		setIconColorful(arg0_128, arg1_128:getDropRarity(), arg2_128, {
			[ItemRarity.Gold] = {
				name = "Item_duang5",
				active = function(arg0_129, arg1_129)
					return arg1_129.fromAwardLayer and arg0_129 >= ItemRarity.Gold
				end
			}
		})
		var4_0(findTF(arg0_128, "icon_bg/icon"), {
			2,
			2,
			2,
			2
		})
	end

	arg1_128:UpdateDropTpl(arg0_128, arg2_128)
	setIconCount(arg0_128, arg2_128.count or arg1_128:getCount())
end

function updateCustomDrop(arg0_130, arg1_130, arg2_130)
	Drop.Change(arg1_130)

	arg2_130 = arg2_130 or {}

	arg1_130:UpdateCustomDropTpl(arg0_130, arg2_130)
end

function updateBuff(arg0_131, arg1_131, arg2_131)
	arg2_131 = arg2_131 or {}

	local var0_131 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_131, findTF(arg0_131, "icon_bg"))

	local var1_131 = pg.benefit_buff_template[arg1_131]

	setFrame(findTF(arg0_131, "icon_bg/frame"), var0_131)
	setText(findTF(arg0_131, "icon_bg/count"), 1)

	local var2_131 = findTF(arg0_131, "icon_bg/icon")
	local var3_131 = var1_131.icon

	GetImageSpriteFromAtlasAsync(var3_131, "", var2_131)
	setIconStars(arg0_131, false)
	setIconName(arg0_131, var1_131.name, arg2_131)
	setIconColorful(arg0_131, ItemRarity.Gold, arg2_131)
end

function updateAttire(arg0_132, arg1_132, arg2_132, arg3_132)
	local var0_132 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_132, findTF(arg0_132, "icon_bg"))
	setFrame(findTF(arg0_132, "icon_bg/frame"), var0_132)

	local var1_132 = findTF(arg0_132, "icon_bg/icon")
	local var2_132

	if arg1_132 == AttireConst.TYPE_CHAT_FRAME then
		var2_132 = "chat_frame"
	elseif arg1_132 == AttireConst.TYPE_ICON_FRAME then
		var2_132 = "icon_frame"
	end

	GetImageSpriteFromAtlasAsync("Props/" .. var2_132, "", var1_132)
	setIconName(arg0_132, arg2_132.name, arg3_132)
end

function updateAttireCombatUI(arg0_133, arg1_133, arg2_133, arg3_133)
	local var0_133 = arg2_133.rare

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_133, findTF(arg0_133, "icon_bg"))
	setFrame(findTF(arg0_133, "icon_bg/frame"), var0_133, "frame_battle_ui")

	local var1_133 = findTF(arg0_133, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("Props/" .. arg2_133.display_icon, "", var1_133)
	setIconName(arg0_133, arg2_133.name, arg3_133)
end

function updateActivityMedal(arg0_134, arg1_134, arg2_134)
	local var0_134 = ItemRarity.Rarity2Print(arg1_134.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_134, findTF(arg0_134, "icon_bg"))
	setFrame(findTF(arg0_134, "icon_bg/frame"), var0_134)

	local var1_134 = findTF(arg0_134, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_134.icon, "", var1_134)
	setIconName(arg0_134, arg1_134.name, arg2_134)
end

function updateCover(arg0_135, arg1_135, arg2_135)
	local var0_135 = arg1_135:getDropRarity()

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_135, findTF(arg0_135, "icon_bg"))
	setFrame(findTF(arg0_135, "icon_bg/frame"), var0_135)

	local var1_135 = findTF(arg0_135, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_135:getIcon(), "", var1_135)
	setIconName(arg0_135, arg1_135:getName(), arg2_135)
	setIconStars(arg0_135, false)
end

function updateEmoji(arg0_136, arg1_136, arg2_136)
	local var0_136 = findTF(arg0_136, "icon_bg/icon")
	local var1_136 = "icon_emoji"

	GetImageSpriteFromAtlasAsync("Props/" .. var1_136, "", var0_136)

	local var2_136 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var2_136, findTF(arg0_136, "icon_bg"))
	setFrame(findTF(arg0_136, "icon_bg/frame"), var2_136)
	setIconName(arg0_136, arg1_136.name, arg2_136)
end

function updateEquipmentSkin(arg0_137, arg1_137, arg2_137)
	arg2_137 = arg2_137 or {}

	local var0_137 = EquipmentRarity.Rarity2Print(arg1_137.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_137, findTF(arg0_137, "icon_bg"))
	setFrame(findTF(arg0_137, "icon_bg/frame"), var0_137, "frame_skin")

	local var1_137 = findTF(arg0_137, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. arg1_137.icon, "", var1_137)
	setIconStars(arg0_137, false)
	setIconName(arg0_137, arg1_137.name, arg2_137)
	setIconCount(arg0_137, arg1_137.count)
	setIconColorful(arg0_137, arg1_137.rarity - 1, arg2_137)
end

function NoPosMsgBox(arg0_138, arg1_138, arg2_138, arg3_138)
	local var0_138
	local var1_138 = {}

	if arg1_138 then
		table.insert(var1_138, {
			text = "text_noPos_clear",
			atuoClose = true,
			onCallback = arg1_138
		})
	end

	if arg2_138 then
		table.insert(var1_138, {
			text = "text_noPos_buy",
			atuoClose = true,
			onCallback = arg2_138
		})
	end

	if arg3_138 then
		table.insert(var1_138, {
			text = "text_noPos_intensify",
			atuoClose = true,
			onCallback = arg3_138
		})
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		hideNo = true,
		content = arg0_138,
		custom = var1_138
	})
end

function openDestroyEquip()
	if pg.m02:hasMediator(EquipmentMediator.__cname) then
		local var0_139 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_139 and var0_139.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_139
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
		local var0_140 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_140 and var0_140.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_140
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
		onClick = function(arg0_143, arg1_143)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
				page = 3,
				shipId = arg0_143.id,
				shipVOs = arg1_143
			})
		end
	})
end

function GoShoppingMsgBox(arg0_144, arg1_144, arg2_144)
	if arg2_144 then
		local var0_144 = ""

		for iter0_144, iter1_144 in ipairs(arg2_144) do
			local var1_144 = Item.getConfigData(iter1_144[1])

			var0_144 = var0_144 .. i18n(iter1_144[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var1_144.name, iter1_144[2])

			if iter0_144 < #arg2_144 then
				var0_144 = var0_144 .. i18n("text_noRes_info_tip_link")
			end
		end

		if var0_144 ~= "" then
			arg0_144 = arg0_144 .. "\n" .. i18n("text_noRes_tip", var0_144)
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = arg0_144,
		onYes = function()
			gotoChargeScene(arg1_144, arg2_144)
		end
	})
end

function shoppingBatch(arg0_146, arg1_146, arg2_146, arg3_146, arg4_146)
	local var0_146 = pg.shop_template[arg0_146]

	assert(var0_146, "shop_template中找不到商品id：" .. arg0_146)

	local var1_146 = getProxy(PlayerProxy):getData()[id2res(var0_146.resource_type)]
	local var2_146 = arg1_146.price or var0_146.resource_num
	local var3_146 = math.floor(var1_146 / var2_146)

	var3_146 = var3_146 <= 0 and 1 or var3_146
	var3_146 = arg2_146 ~= nil and arg2_146 < var3_146 and arg2_146 or var3_146

	local var4_146 = true
	local var5_146 = 1

	if var0_146 ~= nil and arg1_146.id then
		print(var3_146 * var0_146.num, "--", var3_146)
		assert(Item.getConfigData(arg1_146.id), "item config should be existence")

		local var6_146 = Item.New({
			id = arg1_146.id
		}):getConfig("name")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			needCounter = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_ITEM,
				id = arg1_146.id
			},
			addNum = var0_146.num,
			maxNum = var3_146 * var0_146.num,
			defaultNum = var0_146.num,
			numUpdate = function(arg0_147, arg1_147)
				var5_146 = math.floor(arg1_147 / var0_146.num)

				local var0_147 = var5_146 * var2_146

				if var0_147 > var1_146 then
					setText(arg0_147, i18n(arg3_146, var0_147, arg1_147, COLOR_RED, var6_146))

					var4_146 = false
				else
					setText(arg0_147, i18n(arg3_146, var0_147, arg1_147, COLOR_GREEN, var6_146))

					var4_146 = true
				end
			end,
			onYes = function()
				if var4_146 then
					pg.m02:sendNotification(GAME.SHOPPING, {
						id = arg0_146,
						count = var5_146
					})
				elseif arg4_146 then
					pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_146))
					pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_OR_SKIN_FAILD)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("main_playerInfoLayer_error_changeNameNoGem"))
				end
			end
		})
	end
end

function shoppingBatchNewStyle(arg0_149, arg1_149, arg2_149, arg3_149, arg4_149)
	local var0_149 = pg.shop_template[arg0_149]

	assert(var0_149, "shop_template中找不到商品id：" .. arg0_149)

	local var1_149 = getProxy(PlayerProxy):getData()[id2res(var0_149.resource_type)]
	local var2_149 = arg1_149.price or var0_149.resource_num
	local var3_149 = math.floor(var1_149 / var2_149)

	var3_149 = var3_149 <= 0 and 1 or var3_149
	var3_149 = arg2_149 ~= nil and arg2_149 < var3_149 and arg2_149 or var3_149

	local var4_149 = true
	local var5_149 = 1

	if var0_149 ~= nil and arg1_149.id then
		print(var3_149 * var0_149.num, "--", var3_149)
		assert(Item.getConfigData(arg1_149.id), "item config should be existence")

		local var6_149 = Item.New({
			id = arg1_149.id
		}):getConfig("name")

		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_SHOPPING, {
			drop = Drop.New({
				count = 1,
				type = DROP_TYPE_ITEM,
				id = arg1_149.id
			}),
			price = var2_149,
			addNum = var0_149.num,
			maxNum = var3_149 * var0_149.num,
			defaultNum = var0_149.num,
			numUpdate = function(arg0_150, arg1_150)
				var5_149 = math.floor(arg1_150 / var0_149.num)

				local var0_150 = var5_149 * var2_149

				if var0_150 > var1_149 then
					setTextInNewStyleBox(arg0_150, i18n(arg3_149, var0_150, arg1_150, COLOR_RED, var6_149))

					var4_149 = false
				else
					setTextInNewStyleBox(arg0_150, i18n(arg3_149, var0_150, arg1_150, "#238C40FF", var6_149))

					var4_149 = true
				end
			end,
			btnList = {
				{
					type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.shopping,
					name = i18n("word_buy"),
					func = function()
						if var4_149 then
							pg.m02:sendNotification(GAME.SHOPPING, {
								id = arg0_149,
								count = var5_149
							})
						elseif arg4_149 then
							pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_149))
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

function gotoChargeScene(arg0_152, arg1_152)
	local var0_152 = getProxy(ContextProxy)
	local var1_152 = getProxy(ContextProxy):getCurrentContext()

	if instanceof(var1_152.mediator, NewShopMainMediator) then
		var1_152.mediator:getViewComponent():switchSubViewByTogger(arg0_152)
	else
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
			wrap = arg0_152 or ChargeScene.TYPE_ITEM,
			noRes = arg1_152
		})
	end

	pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_OR_SKIN_FAILD)
end

function clearDrop(arg0_153)
	local var0_153 = findTF(arg0_153, "icon_bg")
	local var1_153 = findTF(arg0_153, "icon_bg/frame")
	local var2_153 = findTF(arg0_153, "icon_bg/icon")
	local var3_153 = findTF(arg0_153, "icon_bg/icon/icon")

	clearImageSprite(var0_153)
	clearImageSprite(var1_153)
	clearImageSprite(var2_153)

	if var3_153 then
		clearImageSprite(var3_153)
	end
end

local var9_0 = {
	red = Color.New(1, 0.25, 0.25),
	blue = Color.New(0.11, 0.55, 0.64),
	yellow = Color.New(0.92, 0.52, 0)
}

function updateSkill(arg0_154, arg1_154, arg2_154, arg3_154)
	local var0_154 = findTF(arg0_154, "skill")
	local var1_154 = findTF(arg0_154, "lock")
	local var2_154 = findTF(arg0_154, "unknown")

	if arg1_154 then
		setActive(var0_154, true)
		setActive(var2_154, false)
		setActive(var1_154, not arg2_154)
		LoadImageSpriteAsync("skillicon/" .. arg1_154.icon, findTF(var0_154, "icon"))

		local var3_154 = arg1_154.color or "blue"

		setText(findTF(var0_154, "name"), shortenString(getSkillName(arg1_154.id), arg3_154 or 8))

		local var4_154 = findTF(var0_154, "level")

		setText(var4_154, "LEVEL: " .. (arg2_154 and arg2_154.level or "??"))
		setTextColor(var4_154, var9_0[var3_154])
	else
		setActive(var0_154, false)
		setActive(var2_154, true)
		setActive(var1_154, false)
	end
end

local var10_0 = true

function onBackButton(arg0_155, arg1_155, arg2_155, arg3_155)
	local var0_155 = GetOrAddComponent(arg1_155, "UILongPressTrigger")

	assert(arg2_155, "callback should exist")

	var0_155.longPressThreshold = defaultValue(arg3_155, 1)

	local function var1_155(arg0_156)
		return function()
			if var10_0 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SOUND_BACK)
			end

			local var0_157, var1_157 = arg2_155()

			if var0_157 then
				arg0_156(var1_157)
			end
		end
	end

	local var2_155 = var0_155.onReleased

	pg.DelegateInfo.Add(arg0_155, var2_155)
	var2_155:RemoveAllListeners()
	var2_155:AddListener(var1_155(function(arg0_158)
		arg0_158:emit(BaseUI.ON_BACK)
	end))

	local var3_155 = var0_155.onLongPressed

	pg.DelegateInfo.Add(arg0_155, var3_155)
	var3_155:RemoveAllListeners()
	var3_155:AddListener(var1_155(function(arg0_159)
		arg0_159:emit(BaseUI.ON_HOME)
	end))
end

function GetZeroTime()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)
end

function GetHalfHour()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0, 1800)
end

function GetNextHour(arg0_162)
	local var0_162 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_162, var2_162 = pg.TimeMgr.GetInstance():parseTimeFrom(var0_162)

	return var1_162 * 86400 + (var2_162 + arg0_162) * 3600
end

function GetPerceptualSize(arg0_163, arg1_163)
	local function var0_163(arg0_164)
		if not arg0_164 then
			return 0, 1
		elseif arg0_164 > 240 then
			return 4, 1
		elseif arg0_164 > 225 then
			return 3, 1
		elseif arg0_164 > 192 then
			return 2, 1
		elseif arg0_164 < 126 then
			return 1, arg1_163 or 0.5
		else
			return 1, 1
		end
	end

	if type(arg0_163) == "number" then
		return var0_163(arg0_163)
	end

	local var1_163 = 1
	local var2_163 = 0
	local var3_163 = 0
	local var4_163 = #arg0_163

	while var1_163 <= var4_163 do
		local var5_163 = string.byte(arg0_163, var1_163)
		local var6_163, var7_163 = var0_163(var5_163)

		var1_163 = var1_163 + var6_163
		var2_163 = var2_163 + var7_163
	end

	return var2_163
end

function shortenString(arg0_165, arg1_165, arg2_165)
	local var0_165 = 1
	local var1_165 = 0
	local var2_165 = 0
	local var3_165 = #arg0_165

	while var0_165 <= var3_165 do
		local var4_165 = string.byte(arg0_165, var0_165)
		local var5_165, var6_165 = GetPerceptualSize(var4_165, arg2_165)

		var0_165 = var0_165 + var5_165
		var1_165 = var1_165 + var6_165

		if arg1_165 <= math.ceil(var1_165) then
			var2_165 = var0_165

			break
		end
	end

	if var2_165 == 0 or var3_165 < var2_165 then
		return arg0_165
	end

	return string.sub(arg0_165, 1, var2_165 - 1) .. ".."
end

function shouldShortenString(arg0_166, arg1_166)
	local var0_166 = 1
	local var1_166 = 0
	local var2_166 = 0
	local var3_166 = #arg0_166

	while var0_166 <= var3_166 do
		local var4_166 = string.byte(arg0_166, var0_166)
		local var5_166, var6_166 = GetPerceptualSize(var4_166)

		var0_166 = var0_166 + var5_166
		var1_166 = var1_166 + var6_166

		if arg1_166 <= math.ceil(var1_166) then
			var2_166 = var0_166

			break
		end
	end

	if var2_166 == 0 or var3_166 < var2_166 then
		return false
	end

	return true
end

function nameValidityCheck(arg0_167, arg1_167, arg2_167, arg3_167)
	local var0_167 = true
	local var1_167, var2_167 = utf8_to_unicode(arg0_167)
	local var3_167 = filterEgyUnicode(filterSpecChars(arg0_167))
	local var4_167 = wordVer(arg0_167)

	if not checkSpaceValid(arg0_167) then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_167[1]))

		var0_167 = false
	elseif var4_167 > 0 or var3_167 ~= arg0_167 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_167[4]))

		var0_167 = false
	elseif var2_167 < arg1_167 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_167[2]))

		var0_167 = false
	elseif arg2_167 < var2_167 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_167[3]))

		var0_167 = false
	end

	return var0_167
end

function checkSpaceValid(arg0_168)
	if PLATFORM_CODE == PLATFORM_US then
		return true
	end

	local var0_168 = string.gsub(arg0_168, " ", "")

	return arg0_168 == string.gsub(var0_168, "　", "")
end

function filterSpecChars(arg0_169)
	local var0_169 = {}
	local var1_169 = 0
	local var2_169 = 0
	local var3_169 = 0
	local var4_169 = 1

	while var4_169 <= #arg0_169 do
		local var5_169 = string.byte(arg0_169, var4_169)

		if not var5_169 then
			break
		end

		if var5_169 >= 48 and var5_169 <= 57 or var5_169 >= 65 and var5_169 <= 90 or var5_169 == 95 or var5_169 >= 97 and var5_169 <= 122 then
			table.insert(var0_169, string.char(var5_169))
		elseif var5_169 >= 228 and var5_169 <= 233 then
			local var6_169 = string.byte(arg0_169, var4_169 + 1)
			local var7_169 = string.byte(arg0_169, var4_169 + 2)

			if var6_169 and var7_169 and var6_169 >= 128 and var6_169 <= 191 and var7_169 >= 128 and var7_169 <= 191 then
				var4_169 = var4_169 + 2

				table.insert(var0_169, string.char(var5_169, var6_169, var7_169))

				var1_169 = var1_169 + 1
			end
		elseif var5_169 == 45 or var5_169 == 40 or var5_169 == 41 then
			table.insert(var0_169, string.char(var5_169))
		elseif var5_169 == 194 then
			local var8_169 = string.byte(arg0_169, var4_169 + 1)

			if var8_169 == 183 then
				var4_169 = var4_169 + 1

				table.insert(var0_169, string.char(var5_169, var8_169))

				var1_169 = var1_169 + 1
			end
		elseif var5_169 == 239 then
			local var9_169 = string.byte(arg0_169, var4_169 + 1)
			local var10_169 = string.byte(arg0_169, var4_169 + 2)

			if var9_169 == 188 and (var10_169 == 136 or var10_169 == 137) then
				var4_169 = var4_169 + 2

				table.insert(var0_169, string.char(var5_169, var9_169, var10_169))

				var1_169 = var1_169 + 1
			end
		elseif var5_169 == 206 or var5_169 == 207 then
			local var11_169 = string.byte(arg0_169, var4_169 + 1)

			if var5_169 == 206 and var11_169 >= 177 or var5_169 == 207 and var11_169 <= 134 then
				var4_169 = var4_169 + 1

				table.insert(var0_169, string.char(var5_169, var11_169))

				var1_169 = var1_169 + 1
			end
		elseif var5_169 == 227 and PLATFORM_CODE == PLATFORM_JP then
			local var12_169 = string.byte(arg0_169, var4_169 + 1)
			local var13_169 = string.byte(arg0_169, var4_169 + 2)

			if var12_169 and var13_169 and var12_169 > 128 and var12_169 <= 191 and var13_169 >= 128 and var13_169 <= 191 then
				var4_169 = var4_169 + 2

				table.insert(var0_169, string.char(var5_169, var12_169, var13_169))

				var2_169 = var2_169 + 1
			end
		elseif var5_169 >= 224 and PLATFORM_CODE == PLATFORM_KR then
			local var14_169 = string.byte(arg0_169, var4_169 + 1)
			local var15_169 = string.byte(arg0_169, var4_169 + 2)

			if var14_169 and var15_169 and var14_169 >= 128 and var14_169 <= 191 and var15_169 >= 128 and var15_169 <= 191 then
				var4_169 = var4_169 + 2

				table.insert(var0_169, string.char(var5_169, var14_169, var15_169))

				var3_169 = var3_169 + 1
			end
		elseif PLATFORM_CODE == PLATFORM_US then
			if var4_169 ~= 1 and var5_169 == 32 and string.byte(arg0_169, var4_169 + 1) ~= 32 then
				table.insert(var0_169, string.char(var5_169))
			end

			if var5_169 >= 192 and var5_169 <= 223 then
				local var16_169 = string.byte(arg0_169, var4_169 + 1)

				var4_169 = var4_169 + 1

				if var5_169 == 194 and var16_169 and var16_169 >= 128 then
					table.insert(var0_169, string.char(var5_169, var16_169))
				elseif var5_169 == 195 and var16_169 and var16_169 <= 191 then
					table.insert(var0_169, string.char(var5_169, var16_169))
				end
			end
		end

		var4_169 = var4_169 + 1
	end

	return table.concat(var0_169), var1_169 + var2_169 + var3_169
end

function filterEgyUnicode(arg0_170)
	arg0_170 = string.gsub(arg0_170, "�[�-�][�-�]", "")
	arg0_170 = string.gsub(arg0_170, "�[�-�]", "")

	return arg0_170
end

function shiftPanel(arg0_171, arg1_171, arg2_171, arg3_171, arg4_171, arg5_171, arg6_171, arg7_171, arg8_171)
	arg3_171 = arg3_171 or 0.2

	if arg5_171 then
		LeanTween.cancel(go(arg0_171))
	end

	local var0_171 = rtf(arg0_171)

	arg1_171 = arg1_171 or var0_171.anchoredPosition.x
	arg2_171 = arg2_171 or var0_171.anchoredPosition.y

	local var1_171 = LeanTween.move(var0_171, Vector3(arg1_171, arg2_171, 0), arg3_171)

	arg7_171 = arg7_171 or LeanTweenType.easeInOutSine

	var1_171:setEase(arg7_171)

	if arg4_171 then
		var1_171:setDelay(arg4_171)
	end

	if arg6_171 then
		GetOrAddComponent(arg0_171, "CanvasGroup").blocksRaycasts = false
	end

	var1_171:setOnComplete(System.Action(function()
		if arg8_171 then
			arg8_171()
		end

		if arg6_171 then
			GetOrAddComponent(arg0_171, "CanvasGroup").blocksRaycasts = true
		end
	end))

	return var1_171
end

function TweenValue(arg0_173, arg1_173, arg2_173, arg3_173, arg4_173, arg5_173, arg6_173, arg7_173)
	local var0_173 = LeanTween.value(go(arg0_173), arg1_173, arg2_173, arg3_173):setOnUpdate(System.Action_float(function(arg0_174)
		if arg5_173 then
			arg5_173(arg0_174)
		end
	end)):setOnComplete(System.Action(function()
		if arg6_173 then
			arg6_173()
		end
	end)):setDelay(arg4_173 or 0)

	if arg7_173 and arg7_173 > 0 then
		var0_173:setRepeat(arg7_173)
	end

	return var0_173
end

function rotateAni(arg0_176, arg1_176, arg2_176)
	return LeanTween.rotate(rtf(arg0_176), 360 * arg1_176, arg2_176):setLoopClamp()
end

function blinkAni(arg0_177, arg1_177, arg2_177, arg3_177)
	return LeanTween.alpha(rtf(arg0_177), arg3_177 or 0, arg1_177):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(arg2_177 or 0)
end

function scaleAni(arg0_178, arg1_178, arg2_178, arg3_178)
	return LeanTween.scale(rtf(arg0_178), arg3_178 or 0, arg1_178):setLoopPingPong(arg2_178 or 0)
end

function floatAni(arg0_179, arg1_179, arg2_179, arg3_179)
	local var0_179 = arg0_179.localPosition.y + arg1_179

	return LeanTween.moveY(rtf(arg0_179), var0_179, arg2_179):setLoopPingPong(arg3_179 or 0)
end

local var11_0 = tostring

function tostring(arg0_180)
	if arg0_180 == nil then
		return "nil"
	end

	local var0_180 = var11_0(arg0_180)

	if var0_180 == nil then
		if type(arg0_180) == "table" then
			return "{}"
		end

		return " ~nil"
	end

	return var0_180
end

function wordVer(arg0_181, arg1_181)
	if arg0_181.match(arg0_181, ChatConst.EmojiCodeMatch) then
		return 0, arg0_181
	end

	arg1_181 = arg1_181 or {}

	local var0_181 = filterEgyUnicode(arg0_181)

	if #var0_181 ~= #arg0_181 then
		if arg1_181.isReplace then
			arg0_181 = var0_181
		else
			return 1
		end
	end

	local var1_181 = wordSplit(arg0_181)
	local var2_181 = pg.word_template
	local var3_181 = pg.word_legal_template

	arg1_181.isReplace = arg1_181.isReplace or false
	arg1_181.replaceWord = arg1_181.replaceWord or "*"

	local var4_181 = #var1_181
	local var5_181 = 1
	local var6_181 = ""
	local var7_181 = 0

	while var5_181 <= var4_181 do
		local var8_181, var9_181, var10_181 = wordLegalMatch(var1_181, var3_181, var5_181)

		if var8_181 then
			var5_181 = var9_181
			var6_181 = var6_181 .. var10_181
		else
			local var11_181, var12_181, var13_181 = wordVerMatch(var1_181, var2_181, arg1_181, var5_181, "", false, var5_181, "")

			if var11_181 then
				var5_181 = var12_181
				var7_181 = var7_181 + 1

				if arg1_181.isReplace then
					var6_181 = var6_181 .. var13_181
				end
			else
				if arg1_181.isReplace then
					var6_181 = var6_181 .. var1_181[var5_181]
				end

				var5_181 = var5_181 + 1
			end
		end
	end

	if arg1_181.isReplace then
		return var7_181, var6_181
	else
		return var7_181
	end
end

function wordLegalMatch(arg0_182, arg1_182, arg2_182, arg3_182, arg4_182)
	if arg2_182 > #arg0_182 then
		return arg3_182, arg2_182, arg4_182
	end

	local var0_182 = arg0_182[arg2_182]
	local var1_182 = arg1_182[var0_182]

	arg4_182 = arg4_182 == nil and "" or arg4_182

	if var1_182 then
		if var1_182.this then
			return wordLegalMatch(arg0_182, var1_182, arg2_182 + 1, true, arg4_182 .. var0_182)
		else
			return wordLegalMatch(arg0_182, var1_182, arg2_182 + 1, false, arg4_182 .. var0_182)
		end
	else
		return arg3_182, arg2_182, arg4_182
	end
end

local var12_0 = string.byte("a")
local var13_0 = string.byte("z")
local var14_0 = string.byte("A")
local var15_0 = string.byte("Z")

local function var16_0(arg0_183)
	if not arg0_183 then
		return arg0_183
	end

	local var0_183 = string.byte(arg0_183)

	if var0_183 > 128 then
		return
	end

	if var0_183 >= var12_0 and var0_183 <= var13_0 then
		return string.char(var0_183 - 32)
	elseif var0_183 >= var14_0 and var0_183 <= var15_0 then
		return string.char(var0_183 + 32)
	else
		return arg0_183
	end
end

function wordVerMatch(arg0_184, arg1_184, arg2_184, arg3_184, arg4_184, arg5_184, arg6_184, arg7_184)
	if arg3_184 > #arg0_184 then
		return arg5_184, arg6_184, arg7_184
	end

	local var0_184 = arg0_184[arg3_184]
	local var1_184 = arg1_184[var0_184]

	if var1_184 then
		local var2_184, var3_184, var4_184 = wordVerMatch(arg0_184, var1_184, arg2_184, arg3_184 + 1, arg2_184.isReplace and arg4_184 .. arg2_184.replaceWord or arg4_184, var1_184.this or arg5_184, var1_184.this and arg3_184 + 1 or arg6_184, var1_184.this and (arg2_184.isReplace and arg4_184 .. arg2_184.replaceWord or arg4_184) or arg7_184)

		if var2_184 then
			return var2_184, var3_184, var4_184
		end
	end

	local var5_184 = var16_0(var0_184)
	local var6_184 = arg1_184[var5_184]

	if var5_184 ~= var0_184 and var6_184 then
		local var7_184, var8_184, var9_184 = wordVerMatch(arg0_184, var6_184, arg2_184, arg3_184 + 1, arg2_184.isReplace and arg4_184 .. arg2_184.replaceWord or arg4_184, var6_184.this or arg5_184, var6_184.this and arg3_184 + 1 or arg6_184, var6_184.this and (arg2_184.isReplace and arg4_184 .. arg2_184.replaceWord or arg4_184) or arg7_184)

		if var7_184 then
			return var7_184, var8_184, var9_184
		end
	end

	return arg5_184, arg6_184, arg7_184
end

function wordSplit(arg0_185)
	local var0_185 = {}

	for iter0_185 in arg0_185.gmatch(arg0_185, "[\x01-\x7F�-�][�-�]*") do
		var0_185[#var0_185 + 1] = iter0_185
	end

	return var0_185
end

function contentWrap(arg0_186, arg1_186, arg2_186)
	local var0_186 = LuaHelper.WrapContent(arg0_186, arg1_186, arg2_186)

	return #var0_186 ~= #arg0_186, var0_186
end

function cancelRich(arg0_187)
	local var0_187

	for iter0_187 = 1, 20 do
		local var1_187

		arg0_187, var1_187 = string.gsub(arg0_187, "<([^>]*)>", "%1")

		if var1_187 <= 0 then
			break
		end
	end

	return arg0_187
end

function cancelColorRich(arg0_188)
	local var0_188

	for iter0_188 = 1, 20 do
		local var1_188

		arg0_188, var1_188 = string.gsub(arg0_188, "<color=#[a-zA-Z0-9]+>(.-)</color>", "%1")

		if var1_188 <= 0 then
			break
		end
	end

	return arg0_188
end

function getSkillConfig(arg0_189)
	local var0_189 = pg.buffCfg["buff_" .. arg0_189]

	if not var0_189 then
		return
	end

	local var1_189 = Clone(var0_189)

	var1_189.name = getSkillName(arg0_189)
	var1_189.desc = HXSet.hxLan(var1_189.desc)
	var1_189.desc_get = HXSet.hxLan(var1_189.desc_get)

	_.each(var1_189, function(arg0_190)
		arg0_190.desc = HXSet.hxLan(arg0_190.desc)
	end)

	return var1_189
end

function getSkillName(arg0_191)
	local var0_191 = pg.skill_data_template[arg0_191] or pg.skill_data_display[arg0_191]

	if var0_191 then
		return HXSet.hxLan(var0_191.name)
	else
		return ""
	end
end

function getSkillDescGet(arg0_192, arg1_192)
	local var0_192 = arg1_192 and pg.skill_world_display[arg0_192] and setmetatable({}, {
		__index = function(arg0_193, arg1_193)
			return pg.skill_world_display[arg0_192][arg1_193] or pg.skill_data_template[arg0_192][arg1_193]
		end
	}) or pg.skill_data_template[arg0_192]

	if not var0_192 then
		return ""
	end

	local var1_192 = var0_192.desc_get ~= "" and var0_192.desc_get or var0_192.desc

	for iter0_192, iter1_192 in pairs(var0_192.desc_get_add) do
		local var2_192 = setColorStr(iter1_192[1], COLOR_GREEN)

		if iter1_192[2] then
			var2_192 = var2_192 .. specialGSub(i18n("word_skill_desc_get"), "$1", setColorStr(iter1_192[2], COLOR_GREEN))
		end

		var1_192 = specialGSub(var1_192, "$" .. iter0_192, var2_192)
	end

	return HXSet.hxLan(var1_192)
end

function getSkillDescLearn(arg0_194, arg1_194, arg2_194)
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
		local var2_194 = iter1_194[arg1_194][1]

		if iter1_194[arg1_194][2] then
			var2_194 = var2_194 .. specialGSub(i18n("word_skill_desc_learn"), "$1", iter1_194[arg1_194][2])
		end

		var1_194 = specialGSub(var1_194, "$" .. iter0_194, setColorStr(var2_194, COLOR_YELLOW))
	end

	return HXSet.hxLan(var1_194)
end

function getSkillDesc(arg0_196, arg1_196, arg2_196)
	local var0_196 = arg2_196 and pg.skill_world_display[arg0_196] and setmetatable({}, {
		__index = function(arg0_197, arg1_197)
			return pg.skill_world_display[arg0_196][arg1_197] or pg.skill_data_template[arg0_196][arg1_197]
		end
	}) or pg.skill_data_template[arg0_196]

	if not var0_196 then
		return ""
	end

	local var1_196 = var0_196.desc

	if not var0_196.desc_add then
		return HXSet.hxLan(var1_196)
	end

	for iter0_196, iter1_196 in pairs(var0_196.desc_add) do
		local var2_196 = setColorStr(iter1_196[arg1_196][1], COLOR_GREEN)

		var1_196 = specialGSub(var1_196, "$" .. iter0_196, var2_196)
	end

	return HXSet.hxLan(var1_196)
end

function specialGSub(arg0_198, arg1_198, arg2_198)
	arg0_198 = string.gsub(arg0_198, "<color=#", "<color=NNN")
	arg0_198 = string.gsub(arg0_198, "#", "")
	arg2_198 = string.gsub(arg2_198, "%%", "%%%%")
	arg0_198 = string.gsub(arg0_198, arg1_198, arg2_198)
	arg0_198 = string.gsub(arg0_198, "<color=NNN", "<color=#")

	return arg0_198
end

function topAnimation(arg0_199, arg1_199, arg2_199, arg3_199, arg4_199, arg5_199)
	local var0_199 = {}

	arg4_199 = arg4_199 or 0.27

	local var1_199 = 0.05

	if arg0_199 then
		local var2_199 = arg0_199.transform.localPosition.x

		setAnchoredPosition(arg0_199, {
			x = var2_199 - 500
		})
		shiftPanel(arg0_199, var2_199, nil, 0.05, arg4_199, true, true)
		setActive(arg0_199, true)
	end

	setActive(arg1_199, false)
	setActive(arg2_199, false)
	setActive(arg3_199, false)

	for iter0_199 = 1, 3 do
		table.insert(var0_199, LeanTween.delayedCall(arg4_199 + 0.13 + var1_199 * iter0_199, System.Action(function()
			if arg1_199 then
				setActive(arg1_199, not arg1_199.gameObject.activeSelf)
			end
		end)).uniqueId)
		table.insert(var0_199, LeanTween.delayedCall(arg4_199 + 0.02 + var1_199 * iter0_199, System.Action(function()
			if arg2_199 then
				setActive(arg2_199, not go(arg2_199).activeSelf)
			end

			if arg2_199 then
				setActive(arg3_199, not go(arg3_199).activeSelf)
			end
		end)).uniqueId)
	end

	if arg5_199 then
		table.insert(var0_199, LeanTween.delayedCall(arg4_199 + 0.13 + var1_199 * 3 + 0.1, System.Action(function()
			arg5_199()
		end)).uniqueId)
	end

	return var0_199
end

function cancelTweens(arg0_203)
	assert(arg0_203, "must provide cancel targets, LeanTween.cancelAll is not allow")

	for iter0_203, iter1_203 in ipairs(arg0_203) do
		if iter1_203 then
			LeanTween.cancel(iter1_203)
		end
	end
end

function getOfflineTimeStamp(arg0_204)
	local var0_204 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_204
	local var1_204 = ""

	if var0_204 <= 59 then
		var1_204 = i18n("just_now")
	elseif var0_204 <= 3599 then
		var1_204 = i18n("several_minutes_before", math.floor(var0_204 / 60))
	elseif var0_204 <= 86399 then
		var1_204 = i18n("several_hours_before", math.floor(var0_204 / 3600))
	else
		var1_204 = i18n("several_days_before", math.floor(var0_204 / 86400))
	end

	return var1_204
end

function playMovie(arg0_205, arg1_205, arg2_205)
	local var0_205 = GameObject.Find("OverlayCamera/Overlay/UITop/MoviePanel")

	if not IsNil(var0_205) then
		pg.UIMgr.GetInstance():LoadingOn()
		WWWLoader.Inst:LoadStreamingAsset(arg0_205, function(arg0_206)
			pg.UIMgr.GetInstance():LoadingOff()

			local var0_206 = GCHandle.Alloc(arg0_206, GCHandleType.Pinned)

			setActive(var0_205, true)

			local var1_206 = var0_205:AddComponent(typeof(CriManaMovieControllerForUI))

			var1_206.player:SetData(arg0_206, arg0_206.Length)

			var1_206.target = var0_205:GetComponent(typeof(Image))
			var1_206.loop = false
			var1_206.additiveMode = false
			var1_206.playOnStart = true

			local var2_206

			var2_206 = Timer.New(function()
				if var1_206.player.status == CriMana.Player.Status.PlayEnd or var1_206.player.status == CriMana.Player.Status.Stop or var1_206.player.status == CriMana.Player.Status.Error then
					var2_206:Stop()
					Object.Destroy(var1_206)
					GCHandle.Free(var0_206)
					setActive(var0_205, false)

					if arg1_205 then
						arg1_205()
					end
				end
			end, 0.2, -1)

			var2_206:Start()
			removeOnButton(var0_205)

			if arg2_205 then
				onButton(nil, var0_205, function()
					var1_206:Stop()
					GetOrAddComponent(var0_205, typeof(Button)).onClick:RemoveAllListeners()
				end, SFX_CANCEL)
			end
		end)
	elseif arg1_205 then
		arg1_205()
	end
end

PaintCameraAdjustOn = false

function cameraPaintViewAdjust(arg0_209)
	if PaintCameraAdjustOn ~= arg0_209 then
		local var0_209 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(CanvasScaler))

		if arg0_209 then
			var0_209.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight
			var0_209.matchWidthOrHeight = 1
		else
			var0_209.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand
		end

		pg.CameraFixMgr.GetInstance():BlockCameraRatioControll(arg0_209)

		PaintCameraAdjustOn = arg0_209
	end
end

function ManhattonDist(arg0_210, arg1_210)
	return math.abs(arg0_210.row - arg1_210.row) + math.abs(arg0_210.column - arg1_210.column)
end

function checkFirstHelpShow(arg0_211)
	local var0_211 = getProxy(SettingsProxy)

	if not var0_211:checkReadHelp(arg0_211) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[arg0_211].tip
		})
		var0_211:recordReadHelp(arg0_211)
	end
end

preOrientation = nil
preNotchFitterEnabled = false

function openPortrait(arg0_212)
	preOrientation = Input.deviceOrientation:ToString()

	originalPrint("Begining Orientation:" .. preOrientation)

	Screen.autorotateToPortrait = true
	Screen.autorotateToPortraitUpsideDown = true

	cameraPaintViewAdjust(true)
end

function closePortrait(arg0_213)
	Screen.autorotateToPortrait = false
	Screen.autorotateToPortraitUpsideDown = false

	originalPrint("Closing Orientation:" .. preOrientation)

	Screen.orientation = ScreenOrientation.LandscapeLeft

	local var0_213 = Timer.New(function()
		Screen.orientation = ScreenOrientation.AutoRotation
	end, 0.2, 1):Start()

	cameraPaintViewAdjust(false)
end

function enableNotch(arg0_215, arg1_215)
	if arg0_215 == nil then
		return
	end

	arg0_215:GetComponent("NotchAdapt").enabled = arg1_215
end

function comma_value(arg0_216)
	local var0_216 = arg0_216
	local var1_216 = 0

	repeat
		local var2_216

		var0_216, var2_216 = string.gsub(var0_216, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var2_216 == 0

	return var0_216
end

local var17_0 = 0.2

function SwitchPanel(arg0_217, arg1_217, arg2_217, arg3_217, arg4_217, arg5_217)
	arg3_217 = defaultValue(arg3_217, var17_0)

	if arg5_217 then
		LeanTween.cancel(go(arg0_217))
	end

	local var0_217 = Vector3.New(tf(arg0_217).localPosition.x, tf(arg0_217).localPosition.y, tf(arg0_217).localPosition.z)

	if arg1_217 then
		var0_217.x = arg1_217
	end

	if arg2_217 then
		var0_217.y = arg2_217
	end

	local var1_217 = LeanTween.move(rtf(arg0_217), var0_217, arg3_217):setEase(LeanTweenType.easeInOutSine)

	if arg4_217 then
		var1_217:setDelay(arg4_217)
	end

	return var1_217
end

function updateActivityTaskStatus(arg0_218)
	local var0_218 = arg0_218:getConfig("config_id")
	local var1_218, var2_218 = getActivityTask(arg0_218, true)

	if not var2_218 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_218.id
		})

		return true
	end

	return false
end

function updateCrusingActivityTask(arg0_219)
	local var0_219 = getProxy(TaskProxy)
	local var1_219 = arg0_219:getNDay()
	local var2_219 = pg.TimeMgr.GetInstance():GetServerOverWeek(arg0_219:getStartTime())

	for iter0_219, iter1_219 in ipairs(arg0_219:getConfig("config_data")) do
		local var3_219 = pg.battlepass_task_group[iter1_219]

		if var3_219 and var2_219 >= var3_219.group_mask then
			if underscore.any(underscore.flatten(var3_219.task_group), function(arg0_220)
				return var0_219:getTaskVO(arg0_220) == nil
			end) then
				pg.m02:sendNotification(GAME.CRUSING_CMD, {
					cmd = 1,
					activity_id = arg0_219.id
				})

				return true
			end
		elseif not var3_219 then
			warning("battlepass_task_group表中不存在 id = " .. iter1_219)
		end
	end

	return false
end

function setShipCardFrame(arg0_221, arg1_221, arg2_221)
	arg0_221.localScale = Vector3.one
	arg0_221.anchorMin = Vector2.zero
	arg0_221.anchorMax = Vector2.one

	local var0_221 = arg2_221 or arg1_221

	GetImageSpriteFromAtlasAsync("shipframe", var0_221, arg0_221)

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

function setRectShipCardFrame(arg0_222, arg1_222, arg2_222)
	arg0_222.localScale = Vector3.one
	arg0_222.anchorMin = Vector2.zero
	arg0_222.anchorMax = Vector2.one

	setImageSprite(arg0_222, GetSpriteFromAtlas("shipframeb", "b" .. (arg2_222 or arg1_222)))

	local var0_222 = "b" .. (arg2_222 or arg1_222)
	local var1_222 = pg.frame_resource[var0_222]

	if var1_222 then
		local var2_222 = var1_222.param

		arg0_222.offsetMin = Vector2(var2_222[1], var2_222[2])
		arg0_222.offsetMax = Vector2(var2_222[3], var2_222[4])
	else
		arg0_222.offsetMin = Vector2.zero
		arg0_222.offsetMax = Vector2.zero
	end
end

function setFrameEffect(arg0_223, arg1_223)
	if arg1_223 then
		local var0_223 = arg1_223 .. "(Clone)"
		local var1_223 = false

		eachChild(arg0_223, function(arg0_224)
			setActive(arg0_224, arg0_224.name == var0_223)

			var1_223 = var1_223 or arg0_224.name == var0_223
		end)

		if not var1_223 then
			LoadAndInstantiateAsync("effect", arg1_223, function(arg0_225)
				if IsNil(arg0_223) or findTF(arg0_223, var0_223) then
					Object.Destroy(arg0_225)
				else
					setParent(arg0_225, arg0_223)
					setActive(arg0_225, true)
				end
			end)
		end
	end

	setActive(arg0_223, arg1_223)
end

function setProposeMarkIcon(arg0_226, arg1_226)
	local var0_226 = arg0_226:Find("proposeShipCard(Clone)")
	local var1_226 = arg1_226.propose and not arg1_226:ShowPropose()

	if var0_226 then
		setActive(var0_226, var1_226)
	elseif var1_226 then
		pg.PoolMgr.GetInstance():GetUI("proposeShipCard", true, function(arg0_227)
			if IsNil(arg0_226) or arg0_226:Find("proposeShipCard(Clone)") then
				pg.PoolMgr.GetInstance():ReturnUI("proposeShipCard", arg0_227)
			else
				setParent(arg0_227, arg0_226, false)
			end
		end)
	end
end

function flushShipCard(arg0_228, arg1_228)
	local var0_228 = arg1_228:rarity2bgPrint()
	local var1_228 = findTF(arg0_228, "content/bg")

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var0_228, "", var1_228)

	local var2_228 = findTF(arg0_228, "content/ship_icon")
	local var3_228 = arg1_228 and {
		"shipYardIcon/" .. arg1_228:getPainting(),
		arg1_228:getPainting()
	} or {
		"shipYardIcon/unknown",
		""
	}

	GetImageSpriteFromAtlasAsync(var3_228[1], var3_228[2], var2_228)

	local var4_228 = arg1_228:getShipType()
	local var5_228 = findTF(arg0_228, "content/info/top/type")

	GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var4_228), var5_228)
	setText(findTF(arg0_228, "content/dockyard/lv/Text"), defaultValue(arg1_228.level, 1))

	local var6_228 = arg1_228:getStar()
	local var7_228 = arg1_228:getMaxStar()
	local var8_228 = findTF(arg0_228, "content/front/stars")

	setActive(var8_228, true)

	local var9_228 = findTF(var8_228, "star_tpl")
	local var10_228 = var8_228.childCount

	for iter0_228 = 1, Ship.CONFIG_MAX_STAR do
		local var11_228 = var10_228 < iter0_228 and cloneTplTo(var9_228, var8_228) or var8_228:GetChild(iter0_228 - 1)

		setActive(var11_228, iter0_228 <= var7_228)
		triggerToggle(var11_228, iter0_228 <= var6_228)
	end

	local var12_228 = findTF(arg0_228, "content/front/frame")
	local var13_228, var14_228 = arg1_228:GetFrameAndEffect()

	setShipCardFrame(var12_228, var0_228, var13_228)
	setFrameEffect(findTF(arg0_228, "content/front/bg_other"), var14_228)
	setProposeMarkIcon(arg0_228:Find("content/dockyard/propose"), arg1_228)
end

function TweenItemAlphaAndWhite(arg0_229)
	LeanTween.cancel(arg0_229)

	local var0_229 = GetOrAddComponent(arg0_229, "CanvasGroup")

	var0_229.alpha = 0

	LeanTween.alphaCanvas(var0_229, 1, 0.2):setUseEstimatedTime(true)

	local var1_229 = findTF(arg0_229.transform, "white_mask")

	if var1_229 then
		setActive(var1_229, false)
	end
end

function ClearTweenItemAlphaAndWhite(arg0_230)
	LeanTween.cancel(arg0_230)

	GetOrAddComponent(arg0_230, "CanvasGroup").alpha = 0
end

function getGroupOwnSkins(arg0_231)
	local var0_231 = {}
	local var1_231 = getProxy(ShipSkinProxy):getSkinList()
	local var2_231 = getProxy(CollectionProxy):getShipGroup(arg0_231)

	if var2_231 then
		local var3_231 = ShipGroup.getSkinList(arg0_231)

		for iter0_231, iter1_231 in ipairs(var3_231) do
			if iter1_231.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var1_231, iter1_231.id) or iter1_231.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var2_231.trans or iter1_231.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var2_231.married == 1 then
				var0_231[iter1_231.id] = true
			end
		end
	end

	return var0_231
end

function split(arg0_232, arg1_232)
	local var0_232 = {}

	if not arg0_232 then
		return nil
	end

	local var1_232 = #arg0_232
	local var2_232 = 1

	while var2_232 <= var1_232 do
		local var3_232 = string.find(arg0_232, arg1_232, var2_232)

		if var3_232 == nil then
			table.insert(var0_232, string.sub(arg0_232, var2_232, var1_232))

			break
		end

		table.insert(var0_232, string.sub(arg0_232, var2_232, var3_232 - 1))

		if var3_232 == var1_232 then
			table.insert(var0_232, "")

			break
		end

		var2_232 = var3_232 + 1
	end

	return var0_232
end

function NumberToChinese(arg0_233, arg1_233)
	local var0_233 = ""
	local var1_233 = #arg0_233

	for iter0_233 = 1, var1_233 do
		local var2_233 = string.sub(arg0_233, iter0_233, iter0_233)

		if var2_233 ~= "0" or var2_233 == "0" and not arg1_233 then
			if arg1_233 then
				if var1_233 >= 2 then
					if iter0_233 == 1 then
						if var2_233 == "1" then
							var0_233 = i18n("number_" .. 10)
						else
							var0_233 = i18n("number_" .. var2_233) .. i18n("number_" .. 10)
						end
					else
						var0_233 = var0_233 .. i18n("number_" .. var2_233)
					end
				else
					var0_233 = var0_233 .. i18n("number_" .. var2_233)
				end
			else
				var0_233 = var0_233 .. i18n("number_" .. var2_233)
			end
		end
	end

	return var0_233
end

function getActivityTask(arg0_234, arg1_234)
	local var0_234 = getProxy(TaskProxy)
	local var1_234 = arg0_234:getConfig("config_data")
	local var2_234 = arg0_234:getNDay(arg0_234.data1)
	local var3_234
	local var4_234
	local var5_234

	for iter0_234 = math.max(arg0_234.data3, 1), math.min(var2_234, #var1_234) do
		local var6_234 = _.flatten({
			var1_234[iter0_234]
		})

		for iter1_234, iter2_234 in ipairs(var6_234) do
			local var7_234 = var0_234:getTaskById(iter2_234)

			if var7_234 then
				return var7_234.id, var7_234
			end

			if var4_234 then
				var5_234 = var0_234:getFinishTaskById(iter2_234)

				if var5_234 then
					var4_234 = var5_234
				elseif arg1_234 then
					return iter2_234
				else
					return var4_234.id, var4_234
				end
			else
				var4_234 = var0_234:getFinishTaskById(iter2_234)
				var5_234 = var5_234 or iter2_234
			end
		end
	end

	if var4_234 then
		return var4_234.id, var4_234
	else
		return var5_234
	end
end

function setImageFromImage(arg0_235, arg1_235, arg2_235)
	local var0_235 = GetComponent(arg0_235, "Image")

	var0_235.sprite = GetComponent(arg1_235, "Image").sprite

	if arg2_235 then
		var0_235:SetNativeSize()
	end
end

function skinTimeStamp(arg0_236)
	local var0_236, var1_236, var2_236, var3_236 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_236)

	if var0_236 >= 1 then
		return i18n("limit_skin_time_day", var0_236)
	elseif var0_236 <= 0 and var1_236 > 0 then
		return i18n("limit_skin_time_day_min", var1_236, var2_236)
	elseif var0_236 <= 0 and var1_236 <= 0 and (var2_236 > 0 or var3_236 > 0) then
		return i18n("limit_skin_time_min", math.max(var2_236, 1))
	elseif var0_236 <= 0 and var1_236 <= 0 and var2_236 <= 0 and var3_236 <= 0 then
		return i18n("limit_skin_time_overtime")
	end
end

function skinCommdityTimeStamp(arg0_237)
	local var0_237 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_237 = math.max(arg0_237 - var0_237, 0)
	local var2_237 = math.floor(var1_237 / 86400)

	if var2_237 > 0 then
		return i18n("time_remaining_tip") .. var2_237 .. i18n("word_date")
	else
		local var3_237 = math.floor(var1_237 / 3600)

		if var3_237 > 0 then
			return i18n("time_remaining_tip") .. var3_237 .. i18n("word_hour")
		else
			local var4_237 = math.floor(var1_237 / 60)

			if var4_237 > 0 then
				return i18n("time_remaining_tip") .. var4_237 .. i18n("word_minute")
			else
				return i18n("time_remaining_tip") .. var1_237 .. i18n("word_second")
			end
		end
	end
end

function InstagramTimeStamp(arg0_238)
	local var0_238 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_238
	local var1_238 = var0_238 / 86400

	if var1_238 > 1 then
		return i18n("ins_word_day", math.floor(var1_238))
	else
		local var2_238 = var0_238 / 3600

		if var2_238 > 1 then
			return i18n("ins_word_hour", math.floor(var2_238))
		else
			local var3_238 = var0_238 / 60

			if var3_238 > 1 then
				return i18n("ins_word_minu", math.floor(var3_238))
			else
				return i18n("ins_word_minu", 1)
			end
		end
	end
end

function InstagramReplyTimeStamp(arg0_239)
	local var0_239 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_239
	local var1_239 = var0_239 / 86400

	if var1_239 > 1 then
		return i18n1(math.floor(var1_239) .. "d")
	else
		local var2_239 = var0_239 / 3600

		if var2_239 > 1 then
			return i18n1(math.floor(var2_239) .. "h")
		else
			local var3_239 = var0_239 / 60

			if var3_239 > 1 then
				return i18n1(math.floor(var3_239) .. "min")
			else
				return i18n1("1min")
			end
		end
	end
end

function attireTimeStamp(arg0_240)
	local var0_240, var1_240, var2_240, var3_240 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_240)

	if var0_240 <= 0 and var1_240 <= 0 and var2_240 <= 0 and var3_240 <= 0 then
		return i18n("limit_skin_time_overtime")
	else
		return i18n("attire_time_stamp", var0_240, var1_240, var2_240)
	end
end

function checkExist(arg0_241, ...)
	local var0_241 = {
		...
	}

	for iter0_241, iter1_241 in ipairs(var0_241) do
		if arg0_241 == nil then
			break
		end

		assert(type(arg0_241) == "table", "type error : intermediate target should be table")
		assert(type(iter1_241) == "table", "type error : param should be table")

		if type(arg0_241[iter1_241[1]]) == "function" then
			arg0_241 = arg0_241[iter1_241[1]](arg0_241, unpack(iter1_241[2] or {}))
		else
			arg0_241 = arg0_241[iter1_241[1]]
		end
	end

	return arg0_241
end

function AcessWithinNull(arg0_242, arg1_242)
	if arg0_242 == nil then
		return
	end

	assert(type(arg0_242) == "table")

	return arg0_242[arg1_242]
end

function showRepairMsgbox()
	local var0_243 = {
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var1_243 = {
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var2_243 = {
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
			var2_243,
			var1_243,
			var0_243
		}
	})
end

function resourceVerify(arg0_247, arg1_247)
	if CSharpVersion > 35 then
		BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()

		return
	end

	local var0_247 = Application.persistentDataPath .. "/hashes.csv"
	local var1_247
	local var2_247 = PathMgr.ReadAllLines(var0_247)
	local var3_247 = {}

	if arg0_247 then
		setActive(arg0_247, true)
	else
		pg.UIMgr.GetInstance():LoadingOn()
	end

	local function var4_247()
		if arg0_247 then
			setActive(arg0_247, false)
		else
			pg.UIMgr.GetInstance():LoadingOff()
		end

		print(var1_247)

		if var1_247 then
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

	local var5_247 = var2_247.Length
	local var6_247

	local function var7_247(arg0_250)
		if arg0_250 < 0 then
			var4_247()

			return
		end

		if arg1_247 then
			setSlider(arg1_247, 0, var5_247, var5_247 - arg0_250)
		end

		local var0_250 = string.split(var2_247[arg0_250], ",")
		local var1_250 = var0_250[1]
		local var2_250 = var0_250[3]
		local var3_250 = PathMgr.getAssetBundle(var1_250)

		if PathMgr.FileExists(var3_250) then
			local var4_250 = PathMgr.ReadAllBytes(PathMgr.getAssetBundle(var1_250))

			if var2_250 == HashUtil.CalcMD5(var4_250) then
				onNextTick(function()
					var7_247(arg0_250 - 1)
				end)

				return
			end
		end

		var1_247 = var1_250

		var4_247()
	end

	var7_247(var5_247 - 1)
end

function splitByWordEN(arg0_252, arg1_252)
	local var0_252 = string.split(arg0_252, " ")
	local var1_252 = ""
	local var2_252 = ""
	local var3_252 = arg1_252:GetComponent(typeof(RectTransform))
	local var4_252 = arg1_252:GetComponent(typeof(Text))
	local var5_252 = var3_252.rect.width

	for iter0_252, iter1_252 in ipairs(var0_252) do
		local var6_252 = var2_252

		var2_252 = var2_252 == "" and iter1_252 or var2_252 .. " " .. iter1_252

		setText(arg1_252, var2_252)

		if var5_252 < var4_252.preferredWidth then
			var1_252 = var1_252 == "" and var6_252 or var1_252 .. "\n" .. var6_252
			var2_252 = iter1_252
		end

		if iter0_252 >= #var0_252 then
			var1_252 = var1_252 == "" and var2_252 or var1_252 .. "\n" .. var2_252
		end
	end

	return var1_252
end

function checkBirthFormat(arg0_253)
	if #arg0_253 ~= 8 then
		return false
	end

	local var0_253 = 0
	local var1_253 = #arg0_253

	while var0_253 < var1_253 do
		local var2_253 = string.byte(arg0_253, var0_253 + 1)

		if var2_253 < 48 or var2_253 > 57 then
			return false
		end

		var0_253 = var0_253 + 1
	end

	return true
end

function isHalfBodyLive2D(arg0_254)
	local var0_254 = {
		"biaoqiang",
		"z23",
		"lafei",
		"lingbo",
		"mingshi",
		"xuefeng"
	}

	return _.any(var0_254, function(arg0_255)
		return arg0_255 == arg0_254
	end)
end

function GetServerState(arg0_256)
	local var0_256 = -1
	local var1_256 = 0
	local var2_256 = 1
	local var3_256 = 2
	local var4_256 = NetConst.GetServerStateUrl()

	if PLATFORM_CODE == PLATFORM_CH then
		var4_256 = string.gsub(var4_256, "https", "http")
	end

	VersionMgr.Inst:WebRequest(var4_256, function(arg0_257, arg1_257)
		local var0_257 = true
		local var1_257 = false

		for iter0_257 in string.gmatch(arg1_257, "\"state\":%d") do
			if iter0_257 ~= "\"state\":1" then
				var0_257 = false
			end

			var1_257 = true
		end

		if not var1_257 then
			var0_257 = false
		end

		if arg0_256 ~= nil then
			arg0_256(var0_257 and var2_256 or var1_256)
		end
	end)
end

function setScrollText(arg0_258, arg1_258)
	GetOrAddComponent(arg0_258, "ScrollText"):SetText(arg1_258)
end

function changeToScrollText(arg0_259, arg1_259)
	local var0_259 = GetComponent(arg0_259, typeof(Text))

	assert(var0_259, "without component<Text>")

	local var1_259 = arg0_259:Find("subText")

	if not var1_259 then
		var1_259 = cloneTplTo(arg0_259, arg0_259, "subText")

		eachChild(arg0_259, function(arg0_260)
			setActive(arg0_260, arg0_260 == var1_259)
		end)

		arg0_259:GetComponent(typeof(Text)).enabled = false
	end

	setScrollText(var1_259, arg1_259)
end

local var18_0
local var19_0
local var20_0
local var21_0

local function var22_0(arg0_261, arg1_261, arg2_261)
	local var0_261 = arg0_261:Find("base")
	local var1_261, var2_261, var3_261 = Equipment.GetInfoTrans(arg1_261, arg2_261)

	if arg1_261.nextValue then
		local var4_261 = {
			name = arg1_261.name,
			type = arg1_261.type,
			value = arg1_261.nextValue
		}
		local var5_261, var6_261 = Equipment.GetInfoTrans(var4_261, arg2_261)

		var2_261 = var2_261 .. setColorStr("   >   " .. var6_261, COLOR_GREEN)
	end

	setText(var0_261:Find("name"), var1_261)

	if var3_261 then
		local var7_261 = "<color=#afff72>(+" .. ys.Battle.BattleConst.UltimateBonus.AuxBoostValue * 100 .. "%)</color>"

		setText(var0_261:Find("value"), var2_261 .. var7_261)
	else
		setText(var0_261:Find("value"), var2_261)
	end

	setActive(var0_261:Find("value/up"), arg1_261.compare and arg1_261.compare > 0)
	setActive(var0_261:Find("value/down"), arg1_261.compare and arg1_261.compare < 0)
	triggerToggle(var0_261, arg1_261.lock_open)

	if not arg1_261.lock_open and arg1_261.sub and #arg1_261.sub > 0 then
		GetComponent(var0_261, typeof(Toggle)).enabled = true
	else
		setActive(var0_261:Find("name/close"), false)
		setActive(var0_261:Find("name/open"), false)

		GetComponent(var0_261, typeof(Toggle)).enabled = false
	end
end

local function var23_0(arg0_262, arg1_262, arg2_262, arg3_262)
	var22_0(arg0_262, arg2_262, arg3_262)

	if not arg2_262.sub or #arg2_262.sub == 0 then
		return
	end

	var20_0(arg0_262:Find("subs"), arg1_262, arg2_262.sub, arg3_262)
end

function var20_0(arg0_263, arg1_263, arg2_263, arg3_263)
	removeAllChildren(arg0_263)
	var21_0(arg0_263, arg1_263, arg2_263, arg3_263)
end

function var21_0(arg0_264, arg1_264, arg2_264, arg3_264)
	for iter0_264, iter1_264 in ipairs(arg2_264) do
		local var0_264 = cloneTplTo(arg1_264, arg0_264)

		var23_0(var0_264, arg1_264, iter1_264, arg3_264)
	end
end

function updateEquipInfo(arg0_265, arg1_265, arg2_265, arg3_265)
	local var0_265 = arg0_265:Find("attr_tpl")

	var20_0(arg0_265:Find("attrs"), var0_265, arg1_265.attrs, arg3_265)
	setActive(arg0_265:Find("skill"), arg2_265)

	if arg2_265 then
		var23_0(arg0_265:Find("skill/attr"), var0_265, {
			name = i18n("skill"),
			value = setColorStr(arg2_265.name, "#FFDE00FF")
		}, arg3_265)
		setText(arg0_265:Find("skill/value/Text"), getSkillDescGet(arg2_265.id))
	end

	setActive(arg0_265:Find("weapon"), #arg1_265.weapon.sub > 0)

	if #arg1_265.weapon.sub > 0 then
		var20_0(arg0_265:Find("weapon"), var0_265, {
			arg1_265.weapon
		}, arg3_265)
	end

	setActive(arg0_265:Find("equip_info"), #arg1_265.equipInfo.sub > 0)

	if #arg1_265.equipInfo.sub > 0 then
		var20_0(arg0_265:Find("equip_info"), var0_265, {
			arg1_265.equipInfo
		}, arg3_265)
	end

	var23_0(arg0_265:Find("part/attr"), var0_265, {
		name = i18n("equip_info_23")
	}, arg3_265)

	local var1_265 = arg0_265:Find("part/value")
	local var2_265 = var1_265:Find("label")
	local var3_265 = {}
	local var4_265 = {}

	if #arg1_265.part[1] == 0 and #arg1_265.part[2] == 0 then
		setmetatable(var3_265, {
			__index = function(arg0_266, arg1_266)
				return true
			end
		})
		setmetatable(var4_265, {
			__index = function(arg0_267, arg1_267)
				return true
			end
		})
	else
		for iter0_265, iter1_265 in ipairs(arg1_265.part[1]) do
			var3_265[iter1_265] = true
		end

		for iter2_265, iter3_265 in ipairs(arg1_265.part[2]) do
			var4_265[iter3_265] = true
		end
	end

	local var5_265 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var3_265, var4_265)

	UIItemList.StaticAlign(var1_265, var2_265, #var5_265, function(arg0_268, arg1_268, arg2_268)
		arg1_268 = arg1_268 + 1

		if arg0_268 == UIItemList.EventUpdate then
			local var0_268 = var5_265[arg1_268]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0_268), arg2_268)
			setActive(arg2_268:Find("main"), var3_265[var0_268] and not var4_265[var0_268])
			setActive(arg2_268:Find("sub"), var4_265[var0_268] and not var3_265[var0_268])
			setImageAlpha(arg2_268, not var3_265[var0_268] and not var4_265[var0_268] and 0.3 or 1)
		end
	end)
end

function updateEquipUpgradeInfo(arg0_269, arg1_269, arg2_269)
	local var0_269 = arg0_269:Find("attr_tpl")

	var20_0(arg0_269:Find("attrs"), var0_269, arg1_269.attrs, arg2_269)
	setActive(arg0_269:Find("weapon"), #arg1_269.weapon.sub > 0)

	if #arg1_269.weapon.sub > 0 then
		var20_0(arg0_269:Find("weapon"), var0_269, {
			arg1_269.weapon
		}, arg2_269)
	end

	setActive(arg0_269:Find("equip_info"), #arg1_269.equipInfo.sub > 0)

	if #arg1_269.equipInfo.sub > 0 then
		var20_0(arg0_269:Find("equip_info"), var0_269, {
			arg1_269.equipInfo
		}, arg2_269)
	end
end

function setCanvasOverrideSorting(arg0_270, arg1_270)
	local var0_270 = arg0_270.parent

	arg0_270:SetParent(pg.LayerWeightMgr.GetInstance().uiOrigin, false)

	if isActive(arg0_270) then
		GetOrAddComponent(arg0_270, typeof(Canvas)).overrideSorting = arg1_270
	else
		setActive(arg0_270, true)

		GetOrAddComponent(arg0_270, typeof(Canvas)).overrideSorting = arg1_270

		setActive(arg0_270, false)
	end

	arg0_270:SetParent(var0_270, false)
end

function createNewGameObject(arg0_271, arg1_271)
	local var0_271 = GameObject.New()

	if arg0_271 then
		var0_271.name = "model"
	end

	var0_271.layer = arg1_271 or Layer.UI

	return GetOrAddComponent(var0_271, "RectTransform")
end

function CreateShell(arg0_272)
	if type(arg0_272) ~= "table" and type(arg0_272) ~= "userdata" then
		return arg0_272
	end

	local var0_272 = setmetatable({
		__index = arg0_272
	}, arg0_272)

	return setmetatable({}, var0_272)
end

function CameraFittingSettin(arg0_273)
	local var0_273 = GetComponent(arg0_273, typeof(Camera))
	local var1_273 = 1.77777777777778
	local var2_273 = Screen.width / Screen.height

	if var2_273 < var1_273 then
		local var3_273 = var2_273 / var1_273

		var0_273.rect = var0_0.Rect.New(0, (1 - var3_273) / 2, 1, var3_273)
	end
end

function SwitchSpecialChar(arg0_274, arg1_274)
	if PLATFORM_CODE ~= PLATFORM_US then
		arg0_274 = arg0_274:gsub(" ", " ")
		arg0_274 = arg0_274:gsub("\t", "    ")
	end

	if not arg1_274 then
		arg0_274 = arg0_274:gsub("\n", " ")
	end

	return arg0_274
end

function AfterCheck(arg0_275, arg1_275)
	local var0_275 = {}

	for iter0_275, iter1_275 in ipairs(arg0_275) do
		var0_275[iter0_275] = iter1_275[1]()
	end

	arg1_275()

	for iter2_275, iter3_275 in ipairs(arg0_275) do
		if var0_275[iter2_275] ~= iter3_275[1]() then
			iter3_275[2]()
		end

		var0_275[iter2_275] = iter3_275[1]()
	end
end

function CompareFuncs(arg0_276, arg1_276)
	local var0_276 = {}

	local function var1_276(arg0_277, arg1_277)
		var0_276[arg0_277] = var0_276[arg0_277] or {}
		var0_276[arg0_277][arg1_277] = var0_276[arg0_277][arg1_277] or arg0_276[arg0_277](arg1_277)

		return var0_276[arg0_277][arg1_277]
	end

	return function(arg0_278, arg1_278)
		local var0_278 = 1

		while var0_278 <= #arg0_276 do
			local var1_278 = var1_276(var0_278, arg0_278)
			local var2_278 = var1_276(var0_278, arg1_278)

			if var1_278 == var2_278 then
				var0_278 = var0_278 + 1
			else
				return var1_278 < var2_278
			end
		end

		return tobool(arg1_276)
	end
end

function DropResultIntegration(arg0_279)
	local var0_279 = {}
	local var1_279 = 1

	while var1_279 <= #arg0_279 do
		local var2_279 = arg0_279[var1_279].type
		local var3_279 = arg0_279[var1_279].id

		var0_279[var2_279] = var0_279[var2_279] or {}

		if var0_279[var2_279][var3_279] then
			local var4_279 = arg0_279[var0_279[var2_279][var3_279]]
			local var5_279 = table.remove(arg0_279, var1_279)

			var4_279.count = var4_279.count + var5_279.count
		else
			var0_279[var2_279][var3_279] = var1_279
			var1_279 = var1_279 + 1
		end
	end

	local var6_279 = {
		function(arg0_280)
			local var0_280 = arg0_280.type
			local var1_280 = arg0_280.id

			if var0_280 == DROP_TYPE_SHIP then
				return 1
			elseif var0_280 == DROP_TYPE_RESOURCE then
				if var1_280 == 1 then
					return 2
				else
					return 3
				end
			elseif var0_280 == DROP_TYPE_ITEM then
				if var1_280 == 59010 then
					return 4
				elseif var1_280 == 59900 then
					return 5
				else
					local var2_280 = Item.getConfigData(var1_280)
					local var3_280 = var2_280 and var2_280.type or 0

					if var3_280 == 9 then
						return 6
					elseif var3_280 == 5 then
						return 7
					elseif var3_280 == 4 then
						return 8
					elseif var3_280 == 7 then
						return 9
					end
				end
			elseif var0_280 == DROP_TYPE_VITEM and var1_280 == 59011 then
				return 4
			end

			return 100
		end,
		function(arg0_281)
			local var0_281

			if arg0_281.type == DROP_TYPE_SHIP then
				var0_281 = pg.ship_data_statistics[arg0_281.id]
			elseif arg0_281.type == DROP_TYPE_ITEM then
				var0_281 = Item.getConfigData(arg0_281.id)
			end

			return (var0_281 and var0_281.rarity or 0) * -1
		end,
		function(arg0_282)
			return arg0_282.id
		end
	}

	table.sort(arg0_279, CompareFuncs(var6_279))
end

function getLoginConfig()
	if LOGIN_HX and PlayerProxy.GetDeviceMaxPlayerLevel() <= pg.gameset.LOGIN_HX_LV.key_value then
		return false, "login", "", false, ""
	end

	local var0_283 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_283 = 1

	for iter0_283, iter1_283 in ipairs(pg.login.all) do
		if pg.login[iter1_283].date ~= "stop" then
			local var2_283, var3_283 = parseTimeConfig(pg.login[iter1_283].date)

			assert(not var3_283)

			if pg.TimeMgr.GetInstance():inTime(var2_283, var0_283) then
				var1_283 = iter1_283

				break
			end
		end
	end

	local var4_283 = pg.login[var1_283].login_static

	var4_283 = var4_283 ~= "" and var4_283 or "login"

	local var5_283 = pg.login[var1_283].login_cri
	local var6_283 = var5_283 ~= "" and true or false
	local var7_283 = pg.login[var1_283].op_play == 1 and true or false
	local var8_283 = pg.login[var1_283].op_time

	if var8_283 == "" or not pg.TimeMgr.GetInstance():inTime(var8_283, var0_283) then
		var7_283 = false
	end

	local var9_283 = var8_283 == "" and var8_283 or table.concat(var8_283[1][1])

	return var6_283, var6_283 and var5_283 or var4_283, pg.login[var1_283].bgm, var7_283, var9_283
end

function setIntimacyIcon(arg0_284, arg1_284, arg2_284)
	local var0_284 = {}
	local var1_284

	seriesAsync({
		function(arg0_285)
			if arg0_284.childCount > 0 then
				var1_284 = arg0_284:GetChild(0)

				arg0_285()
			else
				LoadAndInstantiateAsync("template", "intimacytpl", function(arg0_286)
					var1_284 = tf(arg0_286)

					setParent(var1_284, arg0_284)
					arg0_285()
				end)
			end
		end,
		function(arg0_287)
			setImageAlpha(var1_284, arg2_284 and 0 or 1)
			eachChild(var1_284, function(arg0_288)
				setActive(arg0_288, false)
			end)

			if arg2_284 then
				local var0_287 = var1_284:Find(arg2_284 .. "(Clone)")

				if not var0_287 then
					LoadAndInstantiateAsync("ui", arg2_284, function(arg0_289)
						setParent(arg0_289, var1_284)
						setActive(arg0_289, true)
					end)
				else
					setActive(var0_287, true)
				end
			elseif arg1_284 then
				setImageSprite(var1_284, GetSpriteFromAtlas("energy", arg1_284), true)
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

function switch(arg0_292, arg1_292, arg2_292, ...)
	if arg1_292[arg0_292] then
		return arg1_292[arg0_292](...)
	elseif arg2_292 then
		return arg2_292(...)
	end
end

function parseTimeConfig(arg0_293)
	if type(arg0_293[1]) == "table" then
		return arg0_293[2], arg0_293[1]
	else
		return arg0_293
	end
end

local var25_0 = {
	__add = function(arg0_294, arg1_294)
		return NewPos(arg0_294.x + arg1_294.x, arg0_294.y + arg1_294.y)
	end,
	__sub = function(arg0_295, arg1_295)
		return NewPos(arg0_295.x - arg1_295.x, arg0_295.y - arg1_295.y)
	end,
	__mul = function(arg0_296, arg1_296)
		if type(arg1_296) == "number" then
			return NewPos(arg0_296.x * arg1_296, arg0_296.y * arg1_296)
		else
			return NewPos(arg0_296.x * arg1_296.x, arg0_296.y * arg1_296.y)
		end
	end,
	__eq = function(arg0_297, arg1_297)
		return arg0_297.x == arg1_297.x and arg0_297.y == arg1_297.y
	end,
	__tostring = function(arg0_298)
		return arg0_298.x .. "_" .. arg0_298.y
	end
}

function NewPos(arg0_299, arg1_299)
	assert(arg0_299 and arg1_299)

	local var0_299 = setmetatable({
		x = arg0_299,
		y = arg1_299
	}, var25_0)

	function var0_299.SqrMagnitude(arg0_300)
		return arg0_300.x * arg0_300.x + arg0_300.y * arg0_300.y
	end

	function var0_299.Normalize(arg0_301)
		local var0_301 = arg0_301:SqrMagnitude()

		if var0_301 > 1e-05 then
			return arg0_301 * (1 / math.sqrt(var0_301))
		else
			return NewPos(0, 0)
		end
	end

	return var0_299
end

local var26_0

function Timekeeping()
	warning(Time.realtimeSinceStartup - (var26_0 or Time.realtimeSinceStartup), Time.realtimeSinceStartup)

	var26_0 = Time.realtimeSinceStartup
end

function GetRomanDigit(arg0_303)
	return (string.char(226, 133, 160 + (arg0_303 - 1)))
end

function quickPlayAnimator(arg0_304, arg1_304)
	arg0_304:GetComponent(typeof(Animator)):Play(arg1_304, -1, 0)
end

function quickCheckAndPlayAnimator(arg0_305, arg1_305)
	local var0_305 = arg0_305:GetComponent(typeof(Animator))

	var0_305.enabled = true

	local var1_305 = Animator.StringToHash(arg1_305)

	if var0_305:HasState(0, var1_305) then
		var0_305:Play(arg1_305, -1, 0)
	end
end

function quickPlayAnimation(arg0_306, arg1_306)
	local var0_306 = arg0_306:GetComponent(typeof(Animation))

	var0_306:Stop()
	var0_306:Play(arg1_306)
end

function getSurveyUrl(arg0_307)
	local var0_307 = pg.survey_data_template[arg0_307]
	local var1_307

	if not IsUnityEditor then
		if PLATFORM_CODE == PLATFORM_CH then
			local var2_307 = getProxy(UserProxy):GetCacheGatewayInServerLogined()

			if var2_307 == PLATFORM_ANDROID then
				if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_BILI then
					var1_307 = var0_307.main_url
				else
					var1_307 = var0_307.uo_url
				end
			elseif var2_307 == PLATFORM_IPHONEPLAYER then
				var1_307 = var0_307.ios_url
			end
		elseif PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_KR then
			var1_307 = var0_307.main_url
		end
	else
		var1_307 = var0_307.main_url
	end

	local var3_307 = getProxy(PlayerProxy):getRawData().id
	local var4_307 = getProxy(UserProxy):getRawData().arg2 or ""
	local var5_307
	local var6_307 = PLATFORM == PLATFORM_ANDROID and 1 or PLATFORM == PLATFORM_IPHONEPLAYER and 2 or 3
	local var7_307 = getProxy(UserProxy):getRawData()
	local var8_307 = getProxy(ServerProxy):getRawData()[var7_307 and var7_307.server or 0]
	local var9_307 = var8_307 and var8_307.id or ""
	local var10_307 = getProxy(PlayerProxy):getRawData().level
	local var11_307 = var3_307 .. "_" .. arg0_307
	local var12_307 = var1_307
	local var13_307 = {
		var3_307,
		var4_307,
		var6_307,
		var9_307,
		var10_307,
		var11_307
	}

	if var12_307 then
		for iter0_307, iter1_307 in ipairs(var13_307) do
			var12_307 = string.gsub(var12_307, "$" .. iter0_307, tostring(iter1_307))
		end
	end

	originalPrint("survey url", tostring(var12_307))

	return var12_307
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

function FilterVarchar(arg0_309)
	assert(type(arg0_309) == "string" or type(arg0_309) == "table")

	if arg0_309 == "" then
		return nil
	end

	return arg0_309
end

function getGameset(arg0_310)
	local var0_310 = pg.gameset[arg0_310]

	assert(var0_310)

	return {
		var0_310.key_value,
		var0_310.description
	}
end

function getDorm3dGameset(arg0_311)
	local var0_311 = pg.dorm3d_set[arg0_311]

	assert(var0_311)

	return {
		var0_311.key_value_int,
		var0_311.key_value_varchar
	}
end

function GetItemsOverflowDic(arg0_312)
	arg0_312 = arg0_312 or {}

	local var0_312 = {
		[DROP_TYPE_ITEM] = {},
		[DROP_TYPE_RESOURCE] = {},
		[DROP_TYPE_EQUIP] = 0,
		[DROP_TYPE_SHIP] = 0,
		[DROP_TYPE_WORLD_ITEM] = 0
	}

	while #arg0_312 > 0 do
		local var1_312 = table.remove(arg0_312)

		switch(var1_312.type, {
			[DROP_TYPE_ITEM] = function()
				if var1_312:getConfig("open_directly") == 1 then
					for iter0_313, iter1_313 in ipairs(var1_312:getConfig("display_icon")) do
						local var0_313 = Drop.Create(iter1_313)

						var0_313.count = var0_313.count * var1_312.count

						table.insert(arg0_312, var0_313)
					end
				elseif var1_312:getSubClass():IsShipExpType() then
					var0_312[var1_312.type][var1_312.id] = defaultValue(var0_312[var1_312.type][var1_312.id], 0) + var1_312.count
				end
			end,
			[DROP_TYPE_RESOURCE] = function()
				var0_312[var1_312.type][var1_312.id] = defaultValue(var0_312[var1_312.type][var1_312.id], 0) + var1_312.count
			end,
			[DROP_TYPE_EQUIP] = function()
				var0_312[var1_312.type] = var0_312[var1_312.type] + var1_312.count
			end,
			[DROP_TYPE_SHIP] = function()
				var0_312[var1_312.type] = var0_312[var1_312.type] + var1_312.count
			end,
			[DROP_TYPE_WORLD_ITEM] = function()
				var0_312[var1_312.type] = var0_312[var1_312.type] + var1_312.count
			end
		})
	end

	return var0_312
end

function CheckOverflow(arg0_318, arg1_318)
	local var0_318 = {}
	local var1_318 = arg0_318[DROP_TYPE_RESOURCE][PlayerConst.ResGold] or 0
	local var2_318 = arg0_318[DROP_TYPE_RESOURCE][PlayerConst.ResOil] or 0
	local var3_318 = arg0_318[DROP_TYPE_EQUIP]
	local var4_318 = arg0_318[DROP_TYPE_SHIP]
	local var5_318 = getProxy(PlayerProxy):getRawData()
	local var6_318 = false

	if arg1_318 then
		local var7_318 = var5_318:OverStore(PlayerConst.ResStoreGold, var1_318)
		local var8_318 = var5_318:OverStore(PlayerConst.ResStoreOil, var2_318)

		if var7_318 > 0 or var8_318 > 0 then
			var0_318.isStoreOverflow = {
				var7_318,
				var8_318
			}
		end
	else
		if var1_318 > 0 and var5_318:GoldMax(var1_318) then
			return false, "gold"
		end

		if var2_318 > 0 and var5_318:OilMax(var2_318) then
			return false, "oil"
		end
	end

	var0_318.isExpBookOverflow = {}

	for iter0_318, iter1_318 in pairs(arg0_318[DROP_TYPE_ITEM]) do
		local var9_318 = Item.getConfigData(iter0_318)

		if getProxy(BagProxy):getItemCountById(iter0_318) + iter1_318 > var9_318.max_num then
			table.insert(var0_318.isExpBookOverflow, iter0_318)
		end
	end

	local var10_318 = getProxy(EquipmentProxy):getCapacity()

	if var3_318 > 0 and var10_318 >= var5_318:getMaxEquipmentBag() then
		return false, "equip"
	end

	local var11_318 = getProxy(BayProxy):getShipCount()

	if var4_318 > 0 and var4_318 + var11_318 > var5_318:getMaxShipBag() then
		return false, "ship"
	end

	return true, var0_318
end

function CheckShipExpOverflow(arg0_319)
	local var0_319 = getProxy(BagProxy)

	for iter0_319, iter1_319 in pairs(arg0_319[DROP_TYPE_ITEM]) do
		if var0_319:getItemCountById(iter0_319) + iter1_319 > Item.getConfigData(iter0_319).max_num then
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

function RegisterDetailButton(arg0_320, arg1_320, arg2_320)
	Drop.Change(arg2_320)
	switch(arg2_320.type, {
		[DROP_TYPE_ITEM] = function()
			if arg2_320:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
				local var0_321 = Item.getConfigData(arg2_320.id).usage_arg
				local var1_321 = var0_321[3]

				if Item.InTimeLimitSkinAssigned(arg2_320.id) then
					var1_321 = table.mergeArray(var0_321[2], var1_321, true)
				end

				local var2_321 = {}

				for iter0_321, iter1_321 in ipairs(var0_321[2]) do
					var2_321[iter1_321] = true
				end

				onButton(arg0_320, arg1_320, function()
					arg0_320:closeView()
					pg.m02:sendNotification(GAME.LOAD_LAYERS, {
						parentContext = getProxy(ContextProxy):getCurrentContext(),
						context = Context.New({
							viewComponent = NewSelectSkinLayer,
							mediator = NewSkinAtlasMediator,
							data = {
								mode = SelectSkinLayer.MODE_VIEW,
								itemId = arg2_320.id,
								selectableSkinList = underscore.map(var1_321, function(arg0_323)
									return SelectableSkin.New({
										id = arg0_323,
										isTimeLimit = var2_321[arg0_323] or false
									})
								end)
							}
						})
					})
				end, SFX_PANEL)
				setActive(arg1_320, true)
			else
				local var3_321 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_320.id) and "tech" or arg2_320:getConfig("type")

				if var27_0[var3_321] then
					local var4_321 = {
						item2Row = true,
						content = i18n(var27_0[var3_321]),
						itemList = underscore.map(arg2_320:getConfig("display_icon"), function(arg0_324)
							return Drop.Create(arg0_324)
						end)
					}

					if var3_321 == 11 then
						onButton(arg0_320, arg1_320, function()
							arg0_320:emit(BaseUI.ON_DROP_LIST_OWN, var4_321)
						end, SFX_PANEL)
					else
						onButton(arg0_320, arg1_320, function()
							arg0_320:emit(BaseUI.ON_DROP_LIST, var4_321)
						end, SFX_PANEL)
					end
				end

				setActive(arg1_320, tobool(var27_0[var3_321]))
			end
		end,
		[DROP_TYPE_EQUIP] = function()
			onButton(arg0_320, arg1_320, function()
				arg0_320:emit(BaseUI.ON_DROP, arg2_320)
			end, SFX_PANEL)
			setActive(arg1_320, true)
		end,
		[DROP_TYPE_SPWEAPON] = function()
			onButton(arg0_320, arg1_320, function()
				arg0_320:emit(BaseUI.ON_DROP, arg2_320)
			end, SFX_PANEL)
			setActive(arg1_320, true)
		end
	}, function()
		setActive(arg1_320, false)
	end)
end

function RegisterNewStyleDetailButton(arg0_332, arg1_332, arg2_332)
	Drop.Change(arg2_332)
	switch(arg2_332.type, {
		[DROP_TYPE_ITEM] = function()
			local var0_333 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_332.id) and "tech" or arg2_332:getConfig("type")

			if var27_0[var0_333] then
				local var1_333 = {
					useDeepShow = true,
					showOwn = var0_333 == 11,
					content = i18n(var27_0[var0_333]),
					itemList = underscore.map(arg2_332:getConfig("display_icon"), function(arg0_334)
						return Drop.Create(arg0_334)
					end)
				}

				onButton(arg0_332, arg1_332, function()
					arg0_332:emit(BaseUI.ON_NEW_STYLE_ITEMS, var1_333)
				end, SFX_PANEL)
			end

			setActive(arg1_332, tobool(var27_0[var0_333]))
		end
	}, function()
		setActive(arg1_332, false)
	end)
end

function UpdateOwnDisplay(arg0_337, arg1_337)
	local var0_337, var1_337 = arg1_337:getOwnedCount()

	setActive(arg0_337, var1_337 and var0_337 > 0)

	if var1_337 and var0_337 > 0 then
		setText(arg0_337:Find("label"), i18n("word_own1"))
		setText(arg0_337:Find("Text"), var0_337)
	end
end

function Damp(arg0_338, arg1_338, arg2_338)
	arg1_338 = Mathf.Max(1, arg1_338)

	local var0_338 = Mathf.Epsilon

	if arg1_338 < var0_338 or var0_338 > Mathf.Abs(arg0_338) then
		return arg0_338
	end

	if arg2_338 < var0_338 then
		return 0
	end

	local var1_338 = -4.605170186

	return arg0_338 * (1 - Mathf.Exp(var1_338 * arg2_338 / arg1_338))
end

function checkCullResume(arg0_339, arg1_339)
	if arg1_339 or not ReflectionHelp.RefCallMethodEx(typeof("UnityEngine.CanvasRenderer"), "GetMaterial", GetComponent(arg0_339, "CanvasRenderer"), {
		typeof("System.Int32")
	}, {
		0
	}) then
		local var0_339 = arg0_339:GetComponentsInChildren(typeof(var0_0.UI.Graphic)):ToTable()

		for iter0_339, iter1_339 in ipairs(var0_339) do
			iter1_339:SetVerticesDirty()
		end

		return false
	end

	return true
end

function parseEquipCode(arg0_340)
	local var0_340 = {}

	if arg0_340 and arg0_340 ~= "" then
		local var1_340 = base64.dec(arg0_340)

		var0_340 = string.split(var1_340, "/")
		var0_340[5], var0_340[6] = unpack(string.split(var0_340[5], "\\"))

		if #var0_340 < 6 or arg0_340 ~= base64.enc(table.concat({
			table.concat(underscore.first(var0_340, 5), "/"),
			var0_340[6]
		}, "\\")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_illegal"))

			var0_340 = {}
		end
	end

	for iter0_340 = 1, 6 do
		var0_340[iter0_340] = var0_340[iter0_340] and tonumber(var0_340[iter0_340], 32) or 0
	end

	return var0_340
end

function buildEquipCode(arg0_341)
	local var0_341 = underscore.map(arg0_341:getAllEquipments(), function(arg0_342)
		return ConversionBase(32, arg0_342 and arg0_342.id or 0)
	end)
	local var1_341 = {
		table.concat(var0_341, "/"),
		ConversionBase(32, checkExist(arg0_341:GetSpWeapon(), {
			"id"
		}) or 0)
	}

	return base64.enc(table.concat(var1_341, "\\"))
end

function setDirectorSpeed(arg0_343, arg1_343)
	GetComponent(arg0_343, typeof(TimelineSpeed)):SetTimelineSpeed(arg1_343)
end

function setDefaultZeroMetatable(arg0_344)
	return setmetatable(arg0_344, {
		__index = function(arg0_345, arg1_345)
			if rawget(arg0_345, arg1_345) == nil then
				arg0_345[arg1_345] = 0
			end

			return arg0_345[arg1_345]
		end
	})
end

function checkABExist(arg0_346)
	if EDITOR_TOOL then
		return ResourceMgr.Inst:AssetExist(arg0_346)
	else
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_346))
	end
end

function compareNumber(arg0_347, arg1_347, arg2_347)
	return switch(arg1_347, {
		[">"] = function()
			return arg0_347 > arg2_347
		end,
		[">="] = function()
			return arg0_347 >= arg2_347
		end,
		["="] = function()
			return arg0_347 == arg2_347
		end,
		["<"] = function()
			return arg0_347 < arg2_347
		end,
		["<="] = function()
			return arg0_347 <= arg2_347
		end
	})
end

function ArabicToRoman(arg0_353)
	local var0_353 = {
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

	local function var1_353(arg0_354, arg1_354)
		return select(2, arg0_354:gsub(arg1_354, ""))
	end

	local var2_353 = ""

	while arg0_353 > 0 do
		for iter0_353, iter1_353 in pairs(var0_353) do
			local var3_353 = iter1_353[2]
			local var4_353 = iter1_353[1]

			while var4_353 <= arg0_353 do
				var2_353 = var2_353 .. var3_353
				arg0_353 = arg0_353 - var4_353
			end
		end
	end

	if arg0_353 > 10000 then
		local var5_353 = var1_353(var2_353, "M")

		var2_353 = "M*" .. var5_353 .. " " .. var2_353
	end

	return var2_353
end

function stringInset(arg0_355, ...)
	for iter0_355, iter1_355 in ipairs({
		...
	}) do
		arg0_355 = string.gsub(arg0_355, "$" .. iter0_355, iter1_355)
	end

	return arg0_355
end

function addSubLayer(arg0_356, arg1_356, arg2_356, arg3_356, arg4_356)
	if arg2_356 then
		while arg1_356.parent do
			arg1_356 = arg1_356.parent
		end
	end

	local var0_356 = {
		parentContext = arg1_356,
		context = arg0_356,
		callback = arg3_356
	}

	var0_356 = arg4_356 and table.merge(var0_356, arg4_356) or var0_356

	pg.m02:sendNotification(GAME.LOAD_LAYERS, var0_356)
end
