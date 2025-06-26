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
			arg4_37()
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

	GetImageSpriteFromAtlasAsync("islandframe", var1_102, findTF(arg0_102, "icon_bg"))

	if not IsNil(findTF(arg0_102, "icon_bg/frame")) then
		GetImageSpriteFromAtlasAsync("islandframe", var1_102, findTF(arg0_102, "icon_bg/frame"))
	end

	setActive(findTF(arg0_102, "icon_bg/count_bg/count"), false)
	GetImageSpriteFromAtlasAsync(var0_102, "", findTF(arg0_102, "icon_bg/icon"))
	setIconName(arg0_102, "", {})
end

function updateIslandItem(arg0_103, arg1_103)
	local var0_103 = arg1_103:getConfigTable().rarity
	local var1_103 = arg1_103:getConfigTable().icon
	local var2_103 = arg1_103:getConfigTable().name
	local var3_103 = IslandItemRarity.Rarity2FrameName(var0_103)

	GetImageSpriteFromAtlasAsync("islandframe", var3_103, findTF(arg0_103, "icon_bg"))

	if not IsNil(findTF(arg0_103, "icon_bg/frame")) then
		GetImageSpriteFromAtlasAsync("islandframe", var3_103, findTF(arg0_103, "icon_bg/frame"))
	end

	setActive(findTF(arg0_103, "icon_bg/count_bg"), arg1_103.count > 0)
	setText(findTF(arg0_103, "icon_bg/count_bg/count"), arg1_103.count)
	GetImageSpriteFromAtlasAsync(var1_103, "", findTF(arg0_103, "icon_bg/icon"))
	setIconName(arg0_103, var2_103, {})
end

function updateWorldItem(arg0_104, arg1_104, arg2_104)
	arg2_104 = arg2_104 or {}

	local var0_104 = ItemRarity.Rarity2Print(arg1_104:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_104, findTF(arg0_104, "icon_bg"))
	setFrame(findTF(arg0_104, "icon_bg/frame"), var0_104)

	local var1_104 = findTF(arg0_104, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_104.icon or arg1_104:getConfig("icon"), "", var1_104)
	setIconStars(arg0_104, false)
	setIconName(arg0_104, arg1_104:getConfig("name"), arg2_104)
	setIconColorful(arg0_104, arg1_104:getConfig("rarity"), arg2_104)
end

function updateWorldCollection(arg0_105, arg1_105, arg2_105)
	arg2_105 = arg2_105 or {}

	assert(arg1_105:getConfigTable(), "world_collection_file_template 和 world_collection_record_template 表中找不到配置: " .. arg1_105.id)

	local var0_105 = arg1_105:getDropRarity()
	local var1_105 = ItemRarity.Rarity2Print(var0_105)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_105, findTF(arg0_105, "icon_bg"))
	setFrame(findTF(arg0_105, "icon_bg/frame"), var1_105)

	local var2_105 = findTF(arg0_105, "icon_bg/icon")
	local var3_105 = WorldCollectionProxy.GetCollectionType(arg1_105.id) == WorldCollectionProxy.WorldCollectionType.FILE and "shoucangguangdie" or "shoucangjiaojuan"

	GetImageSpriteFromAtlasAsync("props/" .. var3_105, "", var2_105)
	setIconStars(arg0_105, false)
	setIconName(arg0_105, arg1_105:getName(), arg2_105)
	setIconColorful(arg0_105, var0_105, arg2_105)
end

function updateWorldBuff(arg0_106, arg1_106, arg2_106)
	arg2_106 = arg2_106 or {}

	local var0_106 = pg.world_SLGbuff_data[arg1_106]

	assert(var0_106, "找不到大世界buff配置: " .. arg1_106)

	local var1_106 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_106, findTF(arg0_106, "icon_bg"))
	setFrame(findTF(arg0_106, "icon_bg/frame"), var1_106)

	local var2_106 = findTF(arg0_106, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("world/buff/" .. var0_106.icon, "", var2_106)

	local var3_106 = arg0_106:Find("icon_bg/stars")

	if not IsNil(var3_106) then
		setActive(var3_106, false)
	end

	local var4_106 = findTF(arg0_106, "name")

	if not IsNil(var4_106) then
		setText(var4_106, var0_106.name)
	end

	local var5_106 = findTF(arg0_106, "icon_bg/count")

	if not IsNil(var5_106) then
		SetActive(var5_106, false)
	end
end

function updateShip(arg0_107, arg1_107, arg2_107)
	arg2_107 = arg2_107 or {}

	local var0_107 = arg1_107:rarity2bgPrint()
	local var1_107 = arg1_107:getPainting()

	if arg2_107.anonymous then
		var0_107 = "1"
		var1_107 = "unknown"
	end

	if arg2_107.unknown_small then
		var1_107 = "unknown_small"
	end

	local var2_107 = findTF(arg0_107, "icon_bg/new")

	if var2_107 then
		if arg2_107.isSkin then
			setActive(var2_107, not arg2_107.isTimeLimit and arg2_107.isNew)
		else
			setActive(var2_107, arg1_107.virgin)
		end
	end

	local var3_107 = findTF(arg0_107, "icon_bg/timelimit")

	if var3_107 then
		setActive(var3_107, arg2_107.isTimeLimit)
	end

	local var4_107 = findTF(arg0_107, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. (arg2_107.isSkin and "_skin" or var0_107), var4_107)

	local var5_107 = findTF(arg0_107, "icon_bg/frame")
	local var6_107

	if arg1_107.isNpc then
		var6_107 = "frame_npc"
	elseif arg1_107:ShowPropose() then
		var6_107 = "frame_prop"

		if arg1_107:isMetaShip() then
			var6_107 = var6_107 .. "_meta"
		end
	elseif arg2_107.isSkin then
		var6_107 = "frame_skin"
	end

	setFrame(var5_107, var0_107, var6_107)

	if arg2_107.gray then
		setGray(var4_107, true, true)
	end

	local var7_107 = findTF(arg0_107, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg2_107.Q and "QIcon/" or "SquareIcon/") .. var1_107, "", var7_107)

	local var8_107 = findTF(arg0_107, "icon_bg/lv")

	if var8_107 then
		setActive(var8_107, not arg1_107.isNpc)

		if not arg1_107.isNpc then
			local var9_107 = findTF(var8_107, "Text")

			if var9_107 and arg1_107.level then
				setText(var9_107, arg1_107.level)
			end
		end
	end

	local var10_107 = findTF(arg0_107, "ship_type")

	if var10_107 then
		setActive(var10_107, true)
		setImageSprite(var10_107, GetSpriteFromAtlas("shiptype", shipType2print(arg1_107:getShipType())))
	end

	local var11_107 = var4_107:Find("npc")

	if not IsNil(var11_107) then
		if var2_107 and go(var2_107).activeSelf then
			setActive(var11_107, false)
		else
			setActive(var11_107, arg1_107:isActivityNpc())
		end
	end

	local var12_107 = arg0_107:Find("group_locked")

	if var12_107 then
		setActive(var12_107, not arg2_107.isSkin and not getProxy(CollectionProxy):getShipGroup(arg1_107.groupId))
	end

	setIconStars(arg0_107, arg2_107.initStar, arg1_107:getStar())
	setIconName(arg0_107, arg2_107.isSkin and arg1_107:GetSkinConfig().name or arg1_107:getName(), arg2_107)
	setIconColorful(arg0_107, arg2_107.isSkin and ItemRarity.Gold or arg1_107:getRarity() - 1, arg2_107)
end

function updateCommander(arg0_108, arg1_108, arg2_108)
	arg2_108 = arg2_108 or {}

	local var0_108 = arg1_108:getDropRarity()
	local var1_108 = ItemRarity.Rarity2Print(var0_108)
	local var2_108 = arg1_108:getConfig("painting")

	if arg2_108.anonymous then
		var1_108 = 1
		var2_108 = "unknown"
	end

	local var3_108 = findTF(arg0_108, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_108, var3_108)

	local var4_108 = findTF(arg0_108, "icon_bg/frame")

	setFrame(var4_108, var1_108)

	if arg2_108.gray then
		setGray(var3_108, true, true)
	end

	local var5_108 = findTF(arg0_108, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("CommanderIcon/" .. var2_108, "", var5_108)
	setIconStars(arg0_108, arg2_108.initStar, 0)
	setIconName(arg0_108, arg1_108:getName(), arg2_108)
end

function updateStrategy(arg0_109, arg1_109, arg2_109)
	arg2_109 = arg2_109 or {}

	local var0_109 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_109, findTF(arg0_109, "icon_bg"))
	setFrame(findTF(arg0_109, "icon_bg/frame"), var0_109)

	local var1_109 = findTF(arg0_109, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg1_109.isWorldBuff and "world/buff/" or "strategyicon/") .. arg1_109:getIcon(), "", var1_109)
	setIconStars(arg0_109, false)
	setIconName(arg0_109, arg1_109:getName(), arg2_109)
	setIconColorful(arg0_109, ItemRarity.Gray, arg2_109)
end

function updateFurniture(arg0_110, arg1_110, arg2_110)
	arg2_110 = arg2_110 or {}

	local var0_110 = arg1_110:getDropRarity()
	local var1_110 = ItemRarity.Rarity2Print(var0_110)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_110, findTF(arg0_110, "icon_bg"))
	setFrame(findTF(arg0_110, "icon_bg/frame"), var1_110)

	local var2_110 = findTF(arg0_110, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1_110:getIcon(), "", var2_110)
	setIconStars(arg0_110, false)
	setIconName(arg0_110, arg1_110:getName(), arg2_110)
	setIconColorful(arg0_110, var0_110, arg2_110)
end

function updateSpWeapon(arg0_111, arg1_111, arg2_111)
	arg2_111 = arg2_111 or {}

	assert(arg1_111, "spWeaponVO can not be nil.")
	assert(isa(arg1_111, SpWeapon), "spWeaponVO is not Equipment.")

	local var0_111 = ItemRarity.Rarity2Print(arg1_111:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_111, findTF(arg0_111, "icon_bg"))
	setFrame(findTF(arg0_111, "icon_bg/frame"), var0_111)

	local var1_111 = findTF(arg0_111, "icon_bg/icon")

	var4_0(var1_111, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync(arg1_111:GetIconPath(), "", var1_111)
	setIconStars(arg0_111, true, arg1_111:GetRarity())
	var7_0(arg0_111, arg1_111:GetLevel() - 1)
	setIconName(arg0_111, arg1_111:GetName(), arg2_111)
	setIconCount(arg0_111, arg1_111.count)
	setIconColorful(arg0_111, arg1_111:GetRarity(), arg2_111)
end

function UpdateSpWeaponSlot(arg0_112, arg1_112, arg2_112)
	local var0_112 = ItemRarity.Rarity2Print(arg1_112:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_112, findTF(arg0_112, "Icon/Mask/icon_bg"))

	local var1_112 = findTF(arg0_112, "Icon/Mask/icon_bg/icon")

	arg2_112 = arg2_112 or {
		16,
		16,
		16,
		16
	}

	var4_0(var1_112, arg2_112)
	GetImageSpriteFromAtlasAsync(arg1_112:GetIconPath(), "", var1_112)

	local var2_112 = arg1_112:GetLevel() - 1
	local var3_112 = findTF(arg0_112, "Icon/LV")

	setActive(var3_112, var2_112 > 0)
	setText(findTF(var3_112, "Text"), var2_112)
end

function updateDorm3dFurniture(arg0_113, arg1_113, arg2_113)
	arg2_113 = arg2_113 or {}

	local var0_113 = arg1_113:getDropRarity()
	local var1_113 = ItemRarity.Rarity2Print(var0_113)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_113, findTF(arg0_113, "icon_bg"))
	setFrame(findTF(arg0_113, "icon_bg/frame"), var1_113)

	local var2_113 = findTF(arg0_113, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_113:getIcon(), "", var2_113)
	setIconStars(arg0_113, false)
	setIconName(arg0_113, arg1_113:getName(), arg2_113)
	setIconColorful(arg0_113, var0_113, arg2_113)
end

function updateDorm3dGift(arg0_114, arg1_114, arg2_114)
	arg2_114 = arg2_114 or {}

	local var0_114 = arg1_114:getDropRarity()
	local var1_114 = ItemRarity.Rarity2Print(var0_114) or ItemRarity.Gray

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_114, arg0_114:Find("icon_bg"))
	setFrame(arg0_114:Find("icon_bg/frame"), var1_114)

	local var2_114 = arg0_114:Find("icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_114:getIcon(), "", var2_114)
	setIconStars(arg0_114, false)
	setIconName(arg0_114, arg1_114:getName(), arg2_114)
	setIconColorful(arg0_114, var0_114, arg2_114)
end

function updateDorm3dSkin(arg0_115, arg1_115, arg2_115)
	arg2_115 = arg2_115 or {}

	local var0_115 = arg1_115:getDropRarity()
	local var1_115 = ItemRarity.Rarity2Print(var0_115) or ItemRarity.Gray

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_115, arg0_115:Find("icon_bg"))
	setFrame(arg0_115:Find("icon_bg/frame"), var1_115)

	local var2_115 = arg0_115:Find("icon_bg/icon")

	setIconStars(arg0_115, false)
	setIconName(arg0_115, arg1_115:getName(), arg2_115)
	setIconColorful(arg0_115, var0_115, arg2_115)
end

function updateDorm3dIcon(arg0_116, arg1_116)
	local var0_116 = arg1_116:getDropRarityDorm()

	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(var0_116), arg0_116)

	local var1_116 = arg0_116:Find("icon")

	GetImageSpriteFromAtlasAsync(arg1_116:getIcon(), "", var1_116)
	setText(arg0_116:Find("count/Text"), "x" .. arg1_116.count)
	setText(arg0_116:Find("name/Text"), arg1_116:getName())
end

local var8_0

function findCullAndClipWorldRect(arg0_117)
	if #arg0_117 == 0 then
		return false
	end

	local var0_117 = arg0_117[1].canvasRect

	for iter0_117 = 1, #arg0_117 do
		var0_117 = rectIntersect(var0_117, arg0_117[iter0_117].canvasRect)
	end

	if var0_117.width <= 0 or var0_117.height <= 0 then
		return false
	end

	var8_0 = var8_0 or GameObject.Find("UICamera/Canvas").transform

	local var1_117 = var8_0:TransformPoint(Vector3(var0_117.x, var0_117.y, 0))
	local var2_117 = var8_0:TransformPoint(Vector3(var0_117.x + var0_117.width, var0_117.y + var0_117.height, 0))

	return true, Vector4(var1_117.x, var1_117.y, var2_117.x, var2_117.y)
end

function rectIntersect(arg0_118, arg1_118)
	local var0_118 = math.max(arg0_118.x, arg1_118.x)
	local var1_118 = math.min(arg0_118.x + arg0_118.width, arg1_118.x + arg1_118.width)
	local var2_118 = math.max(arg0_118.y, arg1_118.y)
	local var3_118 = math.min(arg0_118.y + arg0_118.height, arg1_118.y + arg1_118.height)

	if var0_118 <= var1_118 and var2_118 <= var3_118 then
		return var0_0.Rect.New(var0_118, var2_118, var1_118 - var0_118, var3_118 - var2_118)
	end

	return var0_0.Rect.New(0, 0, 0, 0)
end

function getDropInfo(arg0_119)
	local var0_119 = {}

	for iter0_119, iter1_119 in ipairs(arg0_119) do
		local var1_119 = Drop.Create(iter1_119)

		var1_119.count = var1_119.count or 1

		if var1_119.type == DROP_TYPE_EMOJI then
			table.insert(var0_119, var1_119:getName())
		else
			table.insert(var0_119, var1_119:getName() .. "x" .. var1_119.count)
		end
	end

	return table.concat(var0_119, "、")
end

function updateDrop(arg0_120, arg1_120, arg2_120)
	Drop.Change(arg1_120)

	arg2_120 = arg2_120 or {}

	local var0_120 = {
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
	local var1_120

	for iter0_120, iter1_120 in ipairs(var0_120) do
		local var2_120 = arg0_120:Find(iter1_120[1])

		if arg1_120.type ~= iter1_120[2] and not IsNil(var2_120) then
			setActive(var2_120, false)
		end
	end

	if not IsNil(arg0_120:Find("icon_bg/frame")) then
		arg0_120:Find("icon_bg/frame"):GetComponent(typeof(Image)).enabled = true

		setIconColorful(arg0_120, arg1_120:getDropRarity(), arg2_120, {
			[ItemRarity.Gold] = {
				name = "Item_duang5",
				active = function(arg0_121, arg1_121)
					return arg1_121.fromAwardLayer and arg0_121 >= ItemRarity.Gold
				end
			}
		})
		var4_0(findTF(arg0_120, "icon_bg/icon"), {
			2,
			2,
			2,
			2
		})
	end

	arg1_120:UpdateDropTpl(arg0_120, arg2_120)
	setIconCount(arg0_120, arg2_120.count or arg1_120:getCount())
end

function updateBuff(arg0_122, arg1_122, arg2_122)
	arg2_122 = arg2_122 or {}

	local var0_122 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_122, findTF(arg0_122, "icon_bg"))

	local var1_122 = pg.benefit_buff_template[arg1_122]

	setFrame(findTF(arg0_122, "icon_bg/frame"), var0_122)
	setText(findTF(arg0_122, "icon_bg/count"), 1)

	local var2_122 = findTF(arg0_122, "icon_bg/icon")
	local var3_122 = var1_122.icon

	GetImageSpriteFromAtlasAsync(var3_122, "", var2_122)
	setIconStars(arg0_122, false)
	setIconName(arg0_122, var1_122.name, arg2_122)
	setIconColorful(arg0_122, ItemRarity.Gold, arg2_122)
end

function updateAttire(arg0_123, arg1_123, arg2_123, arg3_123)
	local var0_123 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_123, findTF(arg0_123, "icon_bg"))
	setFrame(findTF(arg0_123, "icon_bg/frame"), var0_123)

	local var1_123 = findTF(arg0_123, "icon_bg/icon")
	local var2_123

	if arg1_123 == AttireConst.TYPE_CHAT_FRAME then
		var2_123 = "chat_frame"
	elseif arg1_123 == AttireConst.TYPE_ICON_FRAME then
		var2_123 = "icon_frame"
	end

	GetImageSpriteFromAtlasAsync("Props/" .. var2_123, "", var1_123)
	setIconName(arg0_123, arg2_123.name, arg3_123)
end

function updateAttireCombatUI(arg0_124, arg1_124, arg2_124, arg3_124)
	local var0_124 = arg2_124.rare

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_124, findTF(arg0_124, "icon_bg"))
	setFrame(findTF(arg0_124, "icon_bg/frame"), var0_124, "frame_battle_ui")

	local var1_124 = findTF(arg0_124, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("Props/" .. arg2_124.display_icon, "", var1_124)
	setIconName(arg0_124, arg2_124.name, arg3_124)
end

function updateActivityMedal(arg0_125, arg1_125, arg2_125)
	local var0_125 = ItemRarity.Rarity2Print(arg1_125.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_125, findTF(arg0_125, "icon_bg"))
	setFrame(findTF(arg0_125, "icon_bg/frame"), var0_125)

	local var1_125 = findTF(arg0_125, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_125.icon, "", var1_125)
	setIconName(arg0_125, arg1_125.name, arg2_125)
end

function updateCover(arg0_126, arg1_126, arg2_126)
	local var0_126 = arg1_126:getDropRarity()

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_126, findTF(arg0_126, "icon_bg"))
	setFrame(findTF(arg0_126, "icon_bg/frame"), var0_126)

	local var1_126 = findTF(arg0_126, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_126:getIcon(), "", var1_126)
	setIconName(arg0_126, arg1_126:getName(), arg2_126)
	setIconStars(arg0_126, false)
end

function updateEmoji(arg0_127, arg1_127, arg2_127)
	local var0_127 = findTF(arg0_127, "icon_bg/icon")
	local var1_127 = "icon_emoji"

	GetImageSpriteFromAtlasAsync("Props/" .. var1_127, "", var0_127)

	local var2_127 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var2_127, findTF(arg0_127, "icon_bg"))
	setFrame(findTF(arg0_127, "icon_bg/frame"), var2_127)
	setIconName(arg0_127, arg1_127.name, arg2_127)
end

function updateEquipmentSkin(arg0_128, arg1_128, arg2_128)
	arg2_128 = arg2_128 or {}

	local var0_128 = EquipmentRarity.Rarity2Print(arg1_128.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_128, findTF(arg0_128, "icon_bg"))
	setFrame(findTF(arg0_128, "icon_bg/frame"), var0_128, "frame_skin")

	local var1_128 = findTF(arg0_128, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. arg1_128.icon, "", var1_128)
	setIconStars(arg0_128, false)
	setIconName(arg0_128, arg1_128.name, arg2_128)
	setIconCount(arg0_128, arg1_128.count)
	setIconColorful(arg0_128, arg1_128.rarity - 1, arg2_128)
end

function NoPosMsgBox(arg0_129, arg1_129, arg2_129, arg3_129)
	local var0_129
	local var1_129 = {}

	if arg1_129 then
		table.insert(var1_129, {
			text = "text_noPos_clear",
			atuoClose = true,
			onCallback = arg1_129
		})
	end

	if arg2_129 then
		table.insert(var1_129, {
			text = "text_noPos_buy",
			atuoClose = true,
			onCallback = arg2_129
		})
	end

	if arg3_129 then
		table.insert(var1_129, {
			text = "text_noPos_intensify",
			atuoClose = true,
			onCallback = arg3_129
		})
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		hideNo = true,
		content = arg0_129,
		custom = var1_129,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function openDestroyEquip()
	if pg.m02:hasMediator(EquipmentMediator.__cname) then
		local var0_130 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_130 and var0_130.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_130
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
		local var0_131 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_131 and var0_131.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_131
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
		onClick = function(arg0_134, arg1_134)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
				page = 3,
				shipId = arg0_134.id,
				shipVOs = arg1_134
			})
		end
	})
end

function GoShoppingMsgBox(arg0_135, arg1_135, arg2_135)
	if arg2_135 then
		local var0_135 = ""

		for iter0_135, iter1_135 in ipairs(arg2_135) do
			local var1_135 = Item.getConfigData(iter1_135[1])

			var0_135 = var0_135 .. i18n(iter1_135[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var1_135.name, iter1_135[2])

			if iter0_135 < #arg2_135 then
				var0_135 = var0_135 .. i18n("text_noRes_info_tip_link")
			end
		end

		if var0_135 ~= "" then
			arg0_135 = arg0_135 .. "\n" .. i18n("text_noRes_tip", var0_135)
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = arg0_135,
		weight = LayerWeightConst.SECOND_LAYER,
		onYes = function()
			gotoChargeScene(arg1_135, arg2_135)
		end
	})
end

function shoppingBatch(arg0_137, arg1_137, arg2_137, arg3_137, arg4_137)
	local var0_137 = pg.shop_template[arg0_137]

	assert(var0_137, "shop_template中找不到商品id：" .. arg0_137)

	local var1_137 = getProxy(PlayerProxy):getData()[id2res(var0_137.resource_type)]
	local var2_137 = arg1_137.price or var0_137.resource_num
	local var3_137 = math.floor(var1_137 / var2_137)

	var3_137 = var3_137 <= 0 and 1 or var3_137
	var3_137 = arg2_137 ~= nil and arg2_137 < var3_137 and arg2_137 or var3_137

	local var4_137 = true
	local var5_137 = 1

	if var0_137 ~= nil and arg1_137.id then
		print(var3_137 * var0_137.num, "--", var3_137)
		assert(Item.getConfigData(arg1_137.id), "item config should be existence")

		local var6_137 = Item.New({
			id = arg1_137.id
		}):getConfig("name")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			needCounter = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_ITEM,
				id = arg1_137.id
			},
			addNum = var0_137.num,
			maxNum = var3_137 * var0_137.num,
			defaultNum = var0_137.num,
			numUpdate = function(arg0_138, arg1_138)
				var5_137 = math.floor(arg1_138 / var0_137.num)

				local var0_138 = var5_137 * var2_137

				if var0_138 > var1_137 then
					setText(arg0_138, i18n(arg3_137, var0_138, arg1_138, COLOR_RED, var6_137))

					var4_137 = false
				else
					setText(arg0_138, i18n(arg3_137, var0_138, arg1_138, COLOR_GREEN, var6_137))

					var4_137 = true
				end
			end,
			onYes = function()
				if var4_137 then
					pg.m02:sendNotification(GAME.SHOPPING, {
						id = arg0_137,
						count = var5_137
					})
				elseif arg4_137 then
					pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_137))
					pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_OR_SKIN_FAILD)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("main_playerInfoLayer_error_changeNameNoGem"))
				end
			end
		})
	end
end

function shoppingBatchNewStyle(arg0_140, arg1_140, arg2_140, arg3_140, arg4_140)
	local var0_140 = pg.shop_template[arg0_140]

	assert(var0_140, "shop_template中找不到商品id：" .. arg0_140)

	local var1_140 = getProxy(PlayerProxy):getData()[id2res(var0_140.resource_type)]
	local var2_140 = arg1_140.price or var0_140.resource_num
	local var3_140 = math.floor(var1_140 / var2_140)

	var3_140 = var3_140 <= 0 and 1 or var3_140
	var3_140 = arg2_140 ~= nil and arg2_140 < var3_140 and arg2_140 or var3_140

	local var4_140 = true
	local var5_140 = 1

	if var0_140 ~= nil and arg1_140.id then
		print(var3_140 * var0_140.num, "--", var3_140)
		assert(Item.getConfigData(arg1_140.id), "item config should be existence")

		local var6_140 = Item.New({
			id = arg1_140.id
		}):getConfig("name")

		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_SHOPPING, {
			drop = Drop.New({
				count = 1,
				type = DROP_TYPE_ITEM,
				id = arg1_140.id
			}),
			price = var2_140,
			addNum = var0_140.num,
			maxNum = var3_140 * var0_140.num,
			defaultNum = var0_140.num,
			numUpdate = function(arg0_141, arg1_141)
				var5_140 = math.floor(arg1_141 / var0_140.num)

				local var0_141 = var5_140 * var2_140

				if var0_141 > var1_140 then
					setTextInNewStyleBox(arg0_141, i18n(arg3_140, var0_141, arg1_141, COLOR_RED, var6_140))

					var4_140 = false
				else
					setTextInNewStyleBox(arg0_141, i18n(arg3_140, var0_141, arg1_141, "#238C40FF", var6_140))

					var4_140 = true
				end
			end,
			btnList = {
				{
					type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.shopping,
					name = i18n("word_buy"),
					func = function()
						if var4_140 then
							pg.m02:sendNotification(GAME.SHOPPING, {
								id = arg0_140,
								count = var5_140
							})
						elseif arg4_140 then
							pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_140))
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

function gotoChargeScene(arg0_143, arg1_143)
	local var0_143 = getProxy(ContextProxy)
	local var1_143 = getProxy(ContextProxy):getCurrentContext()

	if instanceof(var1_143.mediator, ChargeMediator) then
		var1_143.mediator:getViewComponent():switchSubViewByTogger(arg0_143)
	else
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
			wrap = arg0_143 or ChargeScene.TYPE_ITEM,
			noRes = arg1_143
		})
	end

	pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_OR_SKIN_FAILD)
end

function clearDrop(arg0_144)
	local var0_144 = findTF(arg0_144, "icon_bg")
	local var1_144 = findTF(arg0_144, "icon_bg/frame")
	local var2_144 = findTF(arg0_144, "icon_bg/icon")
	local var3_144 = findTF(arg0_144, "icon_bg/icon/icon")

	clearImageSprite(var0_144)
	clearImageSprite(var1_144)
	clearImageSprite(var2_144)

	if var3_144 then
		clearImageSprite(var3_144)
	end
end

local var9_0 = {
	red = Color.New(1, 0.25, 0.25),
	blue = Color.New(0.11, 0.55, 0.64),
	yellow = Color.New(0.92, 0.52, 0)
}

function updateSkill(arg0_145, arg1_145, arg2_145, arg3_145)
	local var0_145 = findTF(arg0_145, "skill")
	local var1_145 = findTF(arg0_145, "lock")
	local var2_145 = findTF(arg0_145, "unknown")

	if arg1_145 then
		setActive(var0_145, true)
		setActive(var2_145, false)
		setActive(var1_145, not arg2_145)
		LoadImageSpriteAsync("skillicon/" .. arg1_145.icon, findTF(var0_145, "icon"))

		local var3_145 = arg1_145.color or "blue"

		setText(findTF(var0_145, "name"), shortenString(getSkillName(arg1_145.id), arg3_145 or 8))

		local var4_145 = findTF(var0_145, "level")

		setText(var4_145, "LEVEL: " .. (arg2_145 and arg2_145.level or "??"))
		setTextColor(var4_145, var9_0[var3_145])
	else
		setActive(var0_145, false)
		setActive(var2_145, true)
		setActive(var1_145, false)
	end
end

local var10_0 = true

function onBackButton(arg0_146, arg1_146, arg2_146, arg3_146)
	local var0_146 = GetOrAddComponent(arg1_146, "UILongPressTrigger")

	assert(arg2_146, "callback should exist")

	var0_146.longPressThreshold = defaultValue(arg3_146, 1)

	local function var1_146(arg0_147)
		return function()
			if var10_0 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SOUND_BACK)
			end

			local var0_148, var1_148 = arg2_146()

			if var0_148 then
				arg0_147(var1_148)
			end
		end
	end

	local var2_146 = var0_146.onReleased

	pg.DelegateInfo.Add(arg0_146, var2_146)
	var2_146:RemoveAllListeners()
	var2_146:AddListener(var1_146(function(arg0_149)
		arg0_149:emit(BaseUI.ON_BACK)
	end))

	local var3_146 = var0_146.onLongPressed

	pg.DelegateInfo.Add(arg0_146, var3_146)
	var3_146:RemoveAllListeners()
	var3_146:AddListener(var1_146(function(arg0_150)
		arg0_150:emit(BaseUI.ON_HOME)
	end))
end

function GetZeroTime()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)
end

function GetHalfHour()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0, 1800)
end

function GetNextHour(arg0_153)
	local var0_153 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_153, var2_153 = pg.TimeMgr.GetInstance():parseTimeFrom(var0_153)

	return var1_153 * 86400 + (var2_153 + arg0_153) * 3600
end

function GetPerceptualSize(arg0_154, arg1_154)
	local function var0_154(arg0_155)
		if not arg0_155 then
			return 0, 1
		elseif arg0_155 > 240 then
			return 4, 1
		elseif arg0_155 > 225 then
			return 3, 1
		elseif arg0_155 > 192 then
			return 2, 1
		elseif arg0_155 < 126 then
			return 1, arg1_154 or 0.5
		else
			return 1, 1
		end
	end

	if type(arg0_154) == "number" then
		return var0_154(arg0_154)
	end

	local var1_154 = 1
	local var2_154 = 0
	local var3_154 = 0
	local var4_154 = #arg0_154

	while var1_154 <= var4_154 do
		local var5_154 = string.byte(arg0_154, var1_154)
		local var6_154, var7_154 = var0_154(var5_154)

		var1_154 = var1_154 + var6_154
		var2_154 = var2_154 + var7_154
	end

	return var2_154
end

function shortenString(arg0_156, arg1_156, arg2_156)
	local var0_156 = 1
	local var1_156 = 0
	local var2_156 = 0
	local var3_156 = #arg0_156

	while var0_156 <= var3_156 do
		local var4_156 = string.byte(arg0_156, var0_156)
		local var5_156, var6_156 = GetPerceptualSize(var4_156, arg2_156)

		var0_156 = var0_156 + var5_156
		var1_156 = var1_156 + var6_156

		if arg1_156 <= math.ceil(var1_156) then
			var2_156 = var0_156

			break
		end
	end

	if var2_156 == 0 or var3_156 < var2_156 then
		return arg0_156
	end

	return string.sub(arg0_156, 1, var2_156 - 1) .. ".."
end

function shouldShortenString(arg0_157, arg1_157)
	local var0_157 = 1
	local var1_157 = 0
	local var2_157 = 0
	local var3_157 = #arg0_157

	while var0_157 <= var3_157 do
		local var4_157 = string.byte(arg0_157, var0_157)
		local var5_157, var6_157 = GetPerceptualSize(var4_157)

		var0_157 = var0_157 + var5_157
		var1_157 = var1_157 + var6_157

		if arg1_157 <= math.ceil(var1_157) then
			var2_157 = var0_157

			break
		end
	end

	if var2_157 == 0 or var3_157 < var2_157 then
		return false
	end

	return true
end

function nameValidityCheck(arg0_158, arg1_158, arg2_158, arg3_158)
	local var0_158 = true
	local var1_158, var2_158 = utf8_to_unicode(arg0_158)
	local var3_158 = filterEgyUnicode(filterSpecChars(arg0_158))
	local var4_158 = wordVer(arg0_158)

	if not checkSpaceValid(arg0_158) then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_158[1]))

		var0_158 = false
	elseif var4_158 > 0 or var3_158 ~= arg0_158 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_158[4]))

		var0_158 = false
	elseif var2_158 < arg1_158 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_158[2]))

		var0_158 = false
	elseif arg2_158 < var2_158 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_158[3]))

		var0_158 = false
	end

	return var0_158
end

function checkSpaceValid(arg0_159)
	if PLATFORM_CODE == PLATFORM_US then
		return true
	end

	local var0_159 = string.gsub(arg0_159, " ", "")

	return arg0_159 == string.gsub(var0_159, "　", "")
end

function filterSpecChars(arg0_160)
	local var0_160 = {}
	local var1_160 = 0
	local var2_160 = 0
	local var3_160 = 0
	local var4_160 = 1

	while var4_160 <= #arg0_160 do
		local var5_160 = string.byte(arg0_160, var4_160)

		if not var5_160 then
			break
		end

		if var5_160 >= 48 and var5_160 <= 57 or var5_160 >= 65 and var5_160 <= 90 or var5_160 == 95 or var5_160 >= 97 and var5_160 <= 122 then
			table.insert(var0_160, string.char(var5_160))
		elseif var5_160 >= 228 and var5_160 <= 233 then
			local var6_160 = string.byte(arg0_160, var4_160 + 1)
			local var7_160 = string.byte(arg0_160, var4_160 + 2)

			if var6_160 and var7_160 and var6_160 >= 128 and var6_160 <= 191 and var7_160 >= 128 and var7_160 <= 191 then
				var4_160 = var4_160 + 2

				table.insert(var0_160, string.char(var5_160, var6_160, var7_160))

				var1_160 = var1_160 + 1
			end
		elseif var5_160 == 45 or var5_160 == 40 or var5_160 == 41 then
			table.insert(var0_160, string.char(var5_160))
		elseif var5_160 == 194 then
			local var8_160 = string.byte(arg0_160, var4_160 + 1)

			if var8_160 == 183 then
				var4_160 = var4_160 + 1

				table.insert(var0_160, string.char(var5_160, var8_160))

				var1_160 = var1_160 + 1
			end
		elseif var5_160 == 239 then
			local var9_160 = string.byte(arg0_160, var4_160 + 1)
			local var10_160 = string.byte(arg0_160, var4_160 + 2)

			if var9_160 == 188 and (var10_160 == 136 or var10_160 == 137) then
				var4_160 = var4_160 + 2

				table.insert(var0_160, string.char(var5_160, var9_160, var10_160))

				var1_160 = var1_160 + 1
			end
		elseif var5_160 == 206 or var5_160 == 207 then
			local var11_160 = string.byte(arg0_160, var4_160 + 1)

			if var5_160 == 206 and var11_160 >= 177 or var5_160 == 207 and var11_160 <= 134 then
				var4_160 = var4_160 + 1

				table.insert(var0_160, string.char(var5_160, var11_160))

				var1_160 = var1_160 + 1
			end
		elseif var5_160 == 227 and PLATFORM_CODE == PLATFORM_JP then
			local var12_160 = string.byte(arg0_160, var4_160 + 1)
			local var13_160 = string.byte(arg0_160, var4_160 + 2)

			if var12_160 and var13_160 and var12_160 > 128 and var12_160 <= 191 and var13_160 >= 128 and var13_160 <= 191 then
				var4_160 = var4_160 + 2

				table.insert(var0_160, string.char(var5_160, var12_160, var13_160))

				var2_160 = var2_160 + 1
			end
		elseif var5_160 >= 224 and PLATFORM_CODE == PLATFORM_KR then
			local var14_160 = string.byte(arg0_160, var4_160 + 1)
			local var15_160 = string.byte(arg0_160, var4_160 + 2)

			if var14_160 and var15_160 and var14_160 >= 128 and var14_160 <= 191 and var15_160 >= 128 and var15_160 <= 191 then
				var4_160 = var4_160 + 2

				table.insert(var0_160, string.char(var5_160, var14_160, var15_160))

				var3_160 = var3_160 + 1
			end
		elseif PLATFORM_CODE == PLATFORM_US then
			if var4_160 ~= 1 and var5_160 == 32 and string.byte(arg0_160, var4_160 + 1) ~= 32 then
				table.insert(var0_160, string.char(var5_160))
			end

			if var5_160 >= 192 and var5_160 <= 223 then
				local var16_160 = string.byte(arg0_160, var4_160 + 1)

				var4_160 = var4_160 + 1

				if var5_160 == 194 and var16_160 and var16_160 >= 128 then
					table.insert(var0_160, string.char(var5_160, var16_160))
				elseif var5_160 == 195 and var16_160 and var16_160 <= 191 then
					table.insert(var0_160, string.char(var5_160, var16_160))
				end
			end
		end

		var4_160 = var4_160 + 1
	end

	return table.concat(var0_160), var1_160 + var2_160 + var3_160
end

function filterEgyUnicode(arg0_161)
	arg0_161 = string.gsub(arg0_161, "�[�-�][�-�]", "")
	arg0_161 = string.gsub(arg0_161, "�[�-�]", "")

	return arg0_161
end

function shiftPanel(arg0_162, arg1_162, arg2_162, arg3_162, arg4_162, arg5_162, arg6_162, arg7_162, arg8_162)
	arg3_162 = arg3_162 or 0.2

	if arg5_162 then
		LeanTween.cancel(go(arg0_162))
	end

	local var0_162 = rtf(arg0_162)

	arg1_162 = arg1_162 or var0_162.anchoredPosition.x
	arg2_162 = arg2_162 or var0_162.anchoredPosition.y

	local var1_162 = LeanTween.move(var0_162, Vector3(arg1_162, arg2_162, 0), arg3_162)

	arg7_162 = arg7_162 or LeanTweenType.easeInOutSine

	var1_162:setEase(arg7_162)

	if arg4_162 then
		var1_162:setDelay(arg4_162)
	end

	if arg6_162 then
		GetOrAddComponent(arg0_162, "CanvasGroup").blocksRaycasts = false
	end

	var1_162:setOnComplete(System.Action(function()
		if arg8_162 then
			arg8_162()
		end

		if arg6_162 then
			GetOrAddComponent(arg0_162, "CanvasGroup").blocksRaycasts = true
		end
	end))

	return var1_162
end

function TweenValue(arg0_164, arg1_164, arg2_164, arg3_164, arg4_164, arg5_164, arg6_164, arg7_164)
	local var0_164 = LeanTween.value(go(arg0_164), arg1_164, arg2_164, arg3_164):setOnUpdate(System.Action_float(function(arg0_165)
		if arg5_164 then
			arg5_164(arg0_165)
		end
	end)):setOnComplete(System.Action(function()
		if arg6_164 then
			arg6_164()
		end
	end)):setDelay(arg4_164 or 0)

	if arg7_164 and arg7_164 > 0 then
		var0_164:setRepeat(arg7_164)
	end

	return var0_164
end

function rotateAni(arg0_167, arg1_167, arg2_167)
	return LeanTween.rotate(rtf(arg0_167), 360 * arg1_167, arg2_167):setLoopClamp()
end

function blinkAni(arg0_168, arg1_168, arg2_168, arg3_168)
	return LeanTween.alpha(rtf(arg0_168), arg3_168 or 0, arg1_168):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(arg2_168 or 0)
end

function scaleAni(arg0_169, arg1_169, arg2_169, arg3_169)
	return LeanTween.scale(rtf(arg0_169), arg3_169 or 0, arg1_169):setLoopPingPong(arg2_169 or 0)
end

function floatAni(arg0_170, arg1_170, arg2_170, arg3_170)
	local var0_170 = arg0_170.localPosition.y + arg1_170

	return LeanTween.moveY(rtf(arg0_170), var0_170, arg2_170):setLoopPingPong(arg3_170 or 0)
end

local var11_0 = tostring

function tostring(arg0_171)
	if arg0_171 == nil then
		return "nil"
	end

	local var0_171 = var11_0(arg0_171)

	if var0_171 == nil then
		if type(arg0_171) == "table" then
			return "{}"
		end

		return " ~nil"
	end

	return var0_171
end

function wordVer(arg0_172, arg1_172)
	if arg0_172.match(arg0_172, ChatConst.EmojiCodeMatch) then
		return 0, arg0_172
	end

	arg1_172 = arg1_172 or {}

	local var0_172 = filterEgyUnicode(arg0_172)

	if #var0_172 ~= #arg0_172 then
		if arg1_172.isReplace then
			arg0_172 = var0_172
		else
			return 1
		end
	end

	local var1_172 = wordSplit(arg0_172)
	local var2_172 = pg.word_template
	local var3_172 = pg.word_legal_template

	arg1_172.isReplace = arg1_172.isReplace or false
	arg1_172.replaceWord = arg1_172.replaceWord or "*"

	local var4_172 = #var1_172
	local var5_172 = 1
	local var6_172 = ""
	local var7_172 = 0

	while var5_172 <= var4_172 do
		local var8_172, var9_172, var10_172 = wordLegalMatch(var1_172, var3_172, var5_172)

		if var8_172 then
			var5_172 = var9_172
			var6_172 = var6_172 .. var10_172
		else
			local var11_172, var12_172, var13_172 = wordVerMatch(var1_172, var2_172, arg1_172, var5_172, "", false, var5_172, "")

			if var11_172 then
				var5_172 = var12_172
				var7_172 = var7_172 + 1

				if arg1_172.isReplace then
					var6_172 = var6_172 .. var13_172
				end
			else
				if arg1_172.isReplace then
					var6_172 = var6_172 .. var1_172[var5_172]
				end

				var5_172 = var5_172 + 1
			end
		end
	end

	if arg1_172.isReplace then
		return var7_172, var6_172
	else
		return var7_172
	end
end

function wordLegalMatch(arg0_173, arg1_173, arg2_173, arg3_173, arg4_173)
	if arg2_173 > #arg0_173 then
		return arg3_173, arg2_173, arg4_173
	end

	local var0_173 = arg0_173[arg2_173]
	local var1_173 = arg1_173[var0_173]

	arg4_173 = arg4_173 == nil and "" or arg4_173

	if var1_173 then
		if var1_173.this then
			return wordLegalMatch(arg0_173, var1_173, arg2_173 + 1, true, arg4_173 .. var0_173)
		else
			return wordLegalMatch(arg0_173, var1_173, arg2_173 + 1, false, arg4_173 .. var0_173)
		end
	else
		return arg3_173, arg2_173, arg4_173
	end
end

local var12_0 = string.byte("a")
local var13_0 = string.byte("z")
local var14_0 = string.byte("A")
local var15_0 = string.byte("Z")

local function var16_0(arg0_174)
	if not arg0_174 then
		return arg0_174
	end

	local var0_174 = string.byte(arg0_174)

	if var0_174 > 128 then
		return
	end

	if var0_174 >= var12_0 and var0_174 <= var13_0 then
		return string.char(var0_174 - 32)
	elseif var0_174 >= var14_0 and var0_174 <= var15_0 then
		return string.char(var0_174 + 32)
	else
		return arg0_174
	end
end

function wordVerMatch(arg0_175, arg1_175, arg2_175, arg3_175, arg4_175, arg5_175, arg6_175, arg7_175)
	if arg3_175 > #arg0_175 then
		return arg5_175, arg6_175, arg7_175
	end

	local var0_175 = arg0_175[arg3_175]
	local var1_175 = arg1_175[var0_175]

	if var1_175 then
		local var2_175, var3_175, var4_175 = wordVerMatch(arg0_175, var1_175, arg2_175, arg3_175 + 1, arg2_175.isReplace and arg4_175 .. arg2_175.replaceWord or arg4_175, var1_175.this or arg5_175, var1_175.this and arg3_175 + 1 or arg6_175, var1_175.this and (arg2_175.isReplace and arg4_175 .. arg2_175.replaceWord or arg4_175) or arg7_175)

		if var2_175 then
			return var2_175, var3_175, var4_175
		end
	end

	local var5_175 = var16_0(var0_175)
	local var6_175 = arg1_175[var5_175]

	if var5_175 ~= var0_175 and var6_175 then
		local var7_175, var8_175, var9_175 = wordVerMatch(arg0_175, var6_175, arg2_175, arg3_175 + 1, arg2_175.isReplace and arg4_175 .. arg2_175.replaceWord or arg4_175, var6_175.this or arg5_175, var6_175.this and arg3_175 + 1 or arg6_175, var6_175.this and (arg2_175.isReplace and arg4_175 .. arg2_175.replaceWord or arg4_175) or arg7_175)

		if var7_175 then
			return var7_175, var8_175, var9_175
		end
	end

	return arg5_175, arg6_175, arg7_175
end

function wordSplit(arg0_176)
	local var0_176 = {}

	for iter0_176 in arg0_176.gmatch(arg0_176, "[\x01-\x7F�-�][�-�]*") do
		var0_176[#var0_176 + 1] = iter0_176
	end

	return var0_176
end

function contentWrap(arg0_177, arg1_177, arg2_177)
	local var0_177 = LuaHelper.WrapContent(arg0_177, arg1_177, arg2_177)

	return #var0_177 ~= #arg0_177, var0_177
end

function cancelRich(arg0_178)
	local var0_178

	for iter0_178 = 1, 20 do
		local var1_178

		arg0_178, var1_178 = string.gsub(arg0_178, "<([^>]*)>", "%1")

		if var1_178 <= 0 then
			break
		end
	end

	return arg0_178
end

function cancelColorRich(arg0_179)
	local var0_179

	for iter0_179 = 1, 20 do
		local var1_179

		arg0_179, var1_179 = string.gsub(arg0_179, "<color=#[a-zA-Z0-9]+>(.-)</color>", "%1")

		if var1_179 <= 0 then
			break
		end
	end

	return arg0_179
end

function getSkillConfig(arg0_180)
	local var0_180 = pg.buffCfg["buff_" .. arg0_180]

	if not var0_180 then
		return
	end

	local var1_180 = Clone(var0_180)

	var1_180.name = getSkillName(arg0_180)
	var1_180.desc = HXSet.hxLan(var1_180.desc)
	var1_180.desc_get = HXSet.hxLan(var1_180.desc_get)

	_.each(var1_180, function(arg0_181)
		arg0_181.desc = HXSet.hxLan(arg0_181.desc)
	end)

	return var1_180
end

function getSkillName(arg0_182)
	local var0_182 = pg.skill_data_template[arg0_182] or pg.skill_data_display[arg0_182]

	if var0_182 then
		return HXSet.hxLan(var0_182.name)
	else
		return ""
	end
end

function getSkillDescGet(arg0_183, arg1_183)
	local var0_183 = arg1_183 and pg.skill_world_display[arg0_183] and setmetatable({}, {
		__index = function(arg0_184, arg1_184)
			return pg.skill_world_display[arg0_183][arg1_184] or pg.skill_data_template[arg0_183][arg1_184]
		end
	}) or pg.skill_data_template[arg0_183]

	if not var0_183 then
		return ""
	end

	local var1_183 = var0_183.desc_get ~= "" and var0_183.desc_get or var0_183.desc

	for iter0_183, iter1_183 in pairs(var0_183.desc_get_add) do
		local var2_183 = setColorStr(iter1_183[1], COLOR_GREEN)

		if iter1_183[2] then
			var2_183 = var2_183 .. specialGSub(i18n("word_skill_desc_get"), "$1", setColorStr(iter1_183[2], COLOR_GREEN))
		end

		var1_183 = specialGSub(var1_183, "$" .. iter0_183, var2_183)
	end

	return HXSet.hxLan(var1_183)
end

function getSkillDescLearn(arg0_185, arg1_185, arg2_185)
	local var0_185 = arg2_185 and pg.skill_world_display[arg0_185] and setmetatable({}, {
		__index = function(arg0_186, arg1_186)
			return pg.skill_world_display[arg0_185][arg1_186] or pg.skill_data_template[arg0_185][arg1_186]
		end
	}) or pg.skill_data_template[arg0_185]

	if not var0_185 then
		return ""
	end

	local var1_185 = var0_185.desc

	if not var0_185.desc_add then
		return HXSet.hxLan(var1_185)
	end

	for iter0_185, iter1_185 in pairs(var0_185.desc_add) do
		local var2_185 = iter1_185[arg1_185][1]

		if iter1_185[arg1_185][2] then
			var2_185 = var2_185 .. specialGSub(i18n("word_skill_desc_learn"), "$1", iter1_185[arg1_185][2])
		end

		var1_185 = specialGSub(var1_185, "$" .. iter0_185, setColorStr(var2_185, COLOR_YELLOW))
	end

	return HXSet.hxLan(var1_185)
end

function getSkillDesc(arg0_187, arg1_187, arg2_187)
	local var0_187 = arg2_187 and pg.skill_world_display[arg0_187] and setmetatable({}, {
		__index = function(arg0_188, arg1_188)
			return pg.skill_world_display[arg0_187][arg1_188] or pg.skill_data_template[arg0_187][arg1_188]
		end
	}) or pg.skill_data_template[arg0_187]

	if not var0_187 then
		return ""
	end

	local var1_187 = var0_187.desc

	if not var0_187.desc_add then
		return HXSet.hxLan(var1_187)
	end

	for iter0_187, iter1_187 in pairs(var0_187.desc_add) do
		local var2_187 = setColorStr(iter1_187[arg1_187][1], COLOR_GREEN)

		var1_187 = specialGSub(var1_187, "$" .. iter0_187, var2_187)
	end

	return HXSet.hxLan(var1_187)
end

function specialGSub(arg0_189, arg1_189, arg2_189)
	arg0_189 = string.gsub(arg0_189, "<color=#", "<color=NNN")
	arg0_189 = string.gsub(arg0_189, "#", "")
	arg2_189 = string.gsub(arg2_189, "%%", "%%%%")
	arg0_189 = string.gsub(arg0_189, arg1_189, arg2_189)
	arg0_189 = string.gsub(arg0_189, "<color=NNN", "<color=#")

	return arg0_189
end

function topAnimation(arg0_190, arg1_190, arg2_190, arg3_190, arg4_190, arg5_190)
	local var0_190 = {}

	arg4_190 = arg4_190 or 0.27

	local var1_190 = 0.05

	if arg0_190 then
		local var2_190 = arg0_190.transform.localPosition.x

		setAnchoredPosition(arg0_190, {
			x = var2_190 - 500
		})
		shiftPanel(arg0_190, var2_190, nil, 0.05, arg4_190, true, true)
		setActive(arg0_190, true)
	end

	setActive(arg1_190, false)
	setActive(arg2_190, false)
	setActive(arg3_190, false)

	for iter0_190 = 1, 3 do
		table.insert(var0_190, LeanTween.delayedCall(arg4_190 + 0.13 + var1_190 * iter0_190, System.Action(function()
			if arg1_190 then
				setActive(arg1_190, not arg1_190.gameObject.activeSelf)
			end
		end)).uniqueId)
		table.insert(var0_190, LeanTween.delayedCall(arg4_190 + 0.02 + var1_190 * iter0_190, System.Action(function()
			if arg2_190 then
				setActive(arg2_190, not go(arg2_190).activeSelf)
			end

			if arg2_190 then
				setActive(arg3_190, not go(arg3_190).activeSelf)
			end
		end)).uniqueId)
	end

	if arg5_190 then
		table.insert(var0_190, LeanTween.delayedCall(arg4_190 + 0.13 + var1_190 * 3 + 0.1, System.Action(function()
			arg5_190()
		end)).uniqueId)
	end

	return var0_190
end

function cancelTweens(arg0_194)
	assert(arg0_194, "must provide cancel targets, LeanTween.cancelAll is not allow")

	for iter0_194, iter1_194 in ipairs(arg0_194) do
		if iter1_194 then
			LeanTween.cancel(iter1_194)
		end
	end
end

function getOfflineTimeStamp(arg0_195)
	local var0_195 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_195
	local var1_195 = ""

	if var0_195 <= 59 then
		var1_195 = i18n("just_now")
	elseif var0_195 <= 3599 then
		var1_195 = i18n("several_minutes_before", math.floor(var0_195 / 60))
	elseif var0_195 <= 86399 then
		var1_195 = i18n("several_hours_before", math.floor(var0_195 / 3600))
	else
		var1_195 = i18n("several_days_before", math.floor(var0_195 / 86400))
	end

	return var1_195
end

function playMovie(arg0_196, arg1_196, arg2_196)
	local var0_196 = GameObject.Find("OverlayCamera/Overlay/UITop/MoviePanel")

	if not IsNil(var0_196) then
		pg.UIMgr.GetInstance():LoadingOn()
		WWWLoader.Inst:LoadStreamingAsset(arg0_196, function(arg0_197)
			pg.UIMgr.GetInstance():LoadingOff()

			local var0_197 = GCHandle.Alloc(arg0_197, GCHandleType.Pinned)

			setActive(var0_196, true)

			local var1_197 = var0_196:AddComponent(typeof(CriManaMovieControllerForUI))

			var1_197.player:SetData(arg0_197, arg0_197.Length)

			var1_197.target = var0_196:GetComponent(typeof(Image))
			var1_197.loop = false
			var1_197.additiveMode = false
			var1_197.playOnStart = true

			local var2_197

			var2_197 = Timer.New(function()
				if var1_197.player.status == CriMana.Player.Status.PlayEnd or var1_197.player.status == CriMana.Player.Status.Stop or var1_197.player.status == CriMana.Player.Status.Error then
					var2_197:Stop()
					Object.Destroy(var1_197)
					GCHandle.Free(var0_197)
					setActive(var0_196, false)

					if arg1_196 then
						arg1_196()
					end
				end
			end, 0.2, -1)

			var2_197:Start()
			removeOnButton(var0_196)

			if arg2_196 then
				onButton(nil, var0_196, function()
					var1_197:Stop()
					GetOrAddComponent(var0_196, typeof(Button)).onClick:RemoveAllListeners()
				end, SFX_CANCEL)
			end
		end)
	elseif arg1_196 then
		arg1_196()
	end
end

PaintCameraAdjustOn = false

function cameraPaintViewAdjust(arg0_200)
	if PaintCameraAdjustOn ~= arg0_200 then
		local var0_200 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(CanvasScaler))

		if arg0_200 then
			CameraMgr.instance.AutoAdapt = false

			CameraMgr.instance:Revert()

			var0_200.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight
			var0_200.matchWidthOrHeight = 1
		else
			CameraMgr.instance.AutoAdapt = true
			CameraMgr.instance.CurrentWidth = 1
			CameraMgr.instance.CurrentHeight = 1
			CameraMgr.instance.AspectRatio = 1.77777777777778
			var0_200.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand
		end

		PaintCameraAdjustOn = arg0_200
	end
end

function ManhattonDist(arg0_201, arg1_201)
	return math.abs(arg0_201.row - arg1_201.row) + math.abs(arg0_201.column - arg1_201.column)
end

function checkFirstHelpShow(arg0_202)
	local var0_202 = getProxy(SettingsProxy)

	if not var0_202:checkReadHelp(arg0_202) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[arg0_202].tip
		})
		var0_202:recordReadHelp(arg0_202)
	end
end

preOrientation = nil
preNotchFitterEnabled = false

function openPortrait(arg0_203)
	enableNotch(arg0_203, true)

	preOrientation = Input.deviceOrientation:ToString()

	originalPrint("Begining Orientation:" .. preOrientation)

	Screen.autorotateToPortrait = true
	Screen.autorotateToPortraitUpsideDown = true

	cameraPaintViewAdjust(true)
end

function closePortrait(arg0_204)
	enableNotch(arg0_204, false)

	Screen.autorotateToPortrait = false
	Screen.autorotateToPortraitUpsideDown = false

	originalPrint("Closing Orientation:" .. preOrientation)

	Screen.orientation = ScreenOrientation.LandscapeLeft

	local var0_204 = Timer.New(function()
		Screen.orientation = ScreenOrientation.AutoRotation
	end, 0.2, 1):Start()

	cameraPaintViewAdjust(false)
end

function enableNotch(arg0_206, arg1_206)
	if arg0_206 == nil then
		return
	end

	local var0_206 = arg0_206:GetComponent("NotchAdapt")
	local var1_206 = arg0_206:GetComponent("AspectRatioFitter")

	var0_206.enabled = arg1_206

	if var1_206 then
		if arg1_206 then
			var1_206.enabled = preNotchFitterEnabled
		else
			preNotchFitterEnabled = var1_206.enabled
			var1_206.enabled = false
		end
	end
end

function comma_value(arg0_207)
	local var0_207 = arg0_207
	local var1_207 = 0

	repeat
		local var2_207

		var0_207, var2_207 = string.gsub(var0_207, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var2_207 == 0

	return var0_207
end

local var17_0 = 0.2

function SwitchPanel(arg0_208, arg1_208, arg2_208, arg3_208, arg4_208, arg5_208)
	arg3_208 = defaultValue(arg3_208, var17_0)

	if arg5_208 then
		LeanTween.cancel(go(arg0_208))
	end

	local var0_208 = Vector3.New(tf(arg0_208).localPosition.x, tf(arg0_208).localPosition.y, tf(arg0_208).localPosition.z)

	if arg1_208 then
		var0_208.x = arg1_208
	end

	if arg2_208 then
		var0_208.y = arg2_208
	end

	local var1_208 = LeanTween.move(rtf(arg0_208), var0_208, arg3_208):setEase(LeanTweenType.easeInOutSine)

	if arg4_208 then
		var1_208:setDelay(arg4_208)
	end

	return var1_208
end

function updateActivityTaskStatus(arg0_209)
	local var0_209 = arg0_209:getConfig("config_id")
	local var1_209, var2_209 = getActivityTask(arg0_209, true)

	if not var2_209 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_209.id
		})

		return true
	end

	return false
end

function updateCrusingActivityTask(arg0_210)
	local var0_210 = getProxy(TaskProxy)
	local var1_210 = arg0_210:getNDay()
	local var2_210 = pg.TimeMgr.GetInstance():GetServerOverWeek(arg0_210:getStartTime())

	for iter0_210, iter1_210 in ipairs(arg0_210:getConfig("config_data")) do
		local var3_210 = pg.battlepass_task_group[iter1_210]

		if var3_210 and var2_210 >= var3_210.group_mask then
			if underscore.any(underscore.flatten(var3_210.task_group), function(arg0_211)
				return var0_210:getTaskVO(arg0_211) == nil
			end) then
				pg.m02:sendNotification(GAME.CRUSING_CMD, {
					cmd = 1,
					activity_id = arg0_210.id
				})

				return true
			end
		elseif not var3_210 then
			warning("battlepass_task_group表中不存在 id = " .. iter1_210)
		end
	end

	return false
end

function setShipCardFrame(arg0_212, arg1_212, arg2_212)
	arg0_212.localScale = Vector3.one
	arg0_212.anchorMin = Vector2.zero
	arg0_212.anchorMax = Vector2.one

	local var0_212 = arg2_212 or arg1_212

	GetImageSpriteFromAtlasAsync("shipframe", var0_212, arg0_212)

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

function setRectShipCardFrame(arg0_213, arg1_213, arg2_213)
	arg0_213.localScale = Vector3.one
	arg0_213.anchorMin = Vector2.zero
	arg0_213.anchorMax = Vector2.one

	setImageSprite(arg0_213, GetSpriteFromAtlas("shipframeb", "b" .. (arg2_213 or arg1_213)))

	local var0_213 = "b" .. (arg2_213 or arg1_213)
	local var1_213 = pg.frame_resource[var0_213]

	if var1_213 then
		local var2_213 = var1_213.param

		arg0_213.offsetMin = Vector2(var2_213[1], var2_213[2])
		arg0_213.offsetMax = Vector2(var2_213[3], var2_213[4])
	else
		arg0_213.offsetMin = Vector2.zero
		arg0_213.offsetMax = Vector2.zero
	end
end

function setFrameEffect(arg0_214, arg1_214)
	if arg1_214 then
		local var0_214 = arg1_214 .. "(Clone)"
		local var1_214 = false

		eachChild(arg0_214, function(arg0_215)
			setActive(arg0_215, arg0_215.name == var0_214)

			var1_214 = var1_214 or arg0_215.name == var0_214
		end)

		if not var1_214 then
			LoadAndInstantiateAsync("effect", arg1_214, function(arg0_216)
				if IsNil(arg0_214) or findTF(arg0_214, var0_214) then
					Object.Destroy(arg0_216)
				else
					setParent(arg0_216, arg0_214)
					setActive(arg0_216, true)
				end
			end)
		end
	end

	setActive(arg0_214, arg1_214)
end

function setProposeMarkIcon(arg0_217, arg1_217)
	local var0_217 = arg0_217:Find("proposeShipCard(Clone)")
	local var1_217 = arg1_217.propose and not arg1_217:ShowPropose()

	if var0_217 then
		setActive(var0_217, var1_217)
	elseif var1_217 then
		pg.PoolMgr.GetInstance():GetUI("proposeShipCard", true, function(arg0_218)
			if IsNil(arg0_217) or arg0_217:Find("proposeShipCard(Clone)") then
				pg.PoolMgr.GetInstance():ReturnUI("proposeShipCard", arg0_218)
			else
				setParent(arg0_218, arg0_217, false)
			end
		end)
	end
end

function flushShipCard(arg0_219, arg1_219)
	local var0_219 = arg1_219:rarity2bgPrint()
	local var1_219 = findTF(arg0_219, "content/bg")

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var0_219, "", var1_219)

	local var2_219 = findTF(arg0_219, "content/ship_icon")
	local var3_219 = arg1_219 and {
		"shipYardIcon/" .. arg1_219:getPainting(),
		arg1_219:getPainting()
	} or {
		"shipYardIcon/unknown",
		""
	}

	GetImageSpriteFromAtlasAsync(var3_219[1], var3_219[2], var2_219)

	local var4_219 = arg1_219:getShipType()
	local var5_219 = findTF(arg0_219, "content/info/top/type")

	GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var4_219), var5_219)
	setText(findTF(arg0_219, "content/dockyard/lv/Text"), defaultValue(arg1_219.level, 1))

	local var6_219 = arg1_219:getStar()
	local var7_219 = arg1_219:getMaxStar()
	local var8_219 = findTF(arg0_219, "content/front/stars")

	setActive(var8_219, true)

	local var9_219 = findTF(var8_219, "star_tpl")
	local var10_219 = var8_219.childCount

	for iter0_219 = 1, Ship.CONFIG_MAX_STAR do
		local var11_219 = var10_219 < iter0_219 and cloneTplTo(var9_219, var8_219) or var8_219:GetChild(iter0_219 - 1)

		setActive(var11_219, iter0_219 <= var7_219)
		triggerToggle(var11_219, iter0_219 <= var6_219)
	end

	local var12_219 = findTF(arg0_219, "content/front/frame")
	local var13_219, var14_219 = arg1_219:GetFrameAndEffect()

	setShipCardFrame(var12_219, var0_219, var13_219)
	setFrameEffect(findTF(arg0_219, "content/front/bg_other"), var14_219)
	setProposeMarkIcon(arg0_219:Find("content/dockyard/propose"), arg1_219)
end

function TweenItemAlphaAndWhite(arg0_220)
	LeanTween.cancel(arg0_220)

	local var0_220 = GetOrAddComponent(arg0_220, "CanvasGroup")

	var0_220.alpha = 0

	LeanTween.alphaCanvas(var0_220, 1, 0.2):setUseEstimatedTime(true)

	local var1_220 = findTF(arg0_220.transform, "white_mask")

	if var1_220 then
		setActive(var1_220, false)
	end
end

function ClearTweenItemAlphaAndWhite(arg0_221)
	LeanTween.cancel(arg0_221)

	GetOrAddComponent(arg0_221, "CanvasGroup").alpha = 0
end

function getGroupOwnSkins(arg0_222)
	local var0_222 = {}
	local var1_222 = getProxy(ShipSkinProxy):getSkinList()
	local var2_222 = getProxy(CollectionProxy):getShipGroup(arg0_222)

	if var2_222 then
		local var3_222 = ShipGroup.getSkinList(arg0_222)

		for iter0_222, iter1_222 in ipairs(var3_222) do
			if iter1_222.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var1_222, iter1_222.id) or iter1_222.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var2_222.trans or iter1_222.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var2_222.married == 1 then
				var0_222[iter1_222.id] = true
			end
		end
	end

	return var0_222
end

function split(arg0_223, arg1_223)
	local var0_223 = {}

	if not arg0_223 then
		return nil
	end

	local var1_223 = #arg0_223
	local var2_223 = 1

	while var2_223 <= var1_223 do
		local var3_223 = string.find(arg0_223, arg1_223, var2_223)

		if var3_223 == nil then
			table.insert(var0_223, string.sub(arg0_223, var2_223, var1_223))

			break
		end

		table.insert(var0_223, string.sub(arg0_223, var2_223, var3_223 - 1))

		if var3_223 == var1_223 then
			table.insert(var0_223, "")

			break
		end

		var2_223 = var3_223 + 1
	end

	return var0_223
end

function NumberToChinese(arg0_224, arg1_224)
	local var0_224 = ""
	local var1_224 = #arg0_224

	for iter0_224 = 1, var1_224 do
		local var2_224 = string.sub(arg0_224, iter0_224, iter0_224)

		if var2_224 ~= "0" or var2_224 == "0" and not arg1_224 then
			if arg1_224 then
				if var1_224 >= 2 then
					if iter0_224 == 1 then
						if var2_224 == "1" then
							var0_224 = i18n("number_" .. 10)
						else
							var0_224 = i18n("number_" .. var2_224) .. i18n("number_" .. 10)
						end
					else
						var0_224 = var0_224 .. i18n("number_" .. var2_224)
					end
				else
					var0_224 = var0_224 .. i18n("number_" .. var2_224)
				end
			else
				var0_224 = var0_224 .. i18n("number_" .. var2_224)
			end
		end
	end

	return var0_224
end

function getActivityTask(arg0_225, arg1_225)
	local var0_225 = getProxy(TaskProxy)
	local var1_225 = arg0_225:getConfig("config_data")
	local var2_225 = arg0_225:getNDay(arg0_225.data1)
	local var3_225
	local var4_225
	local var5_225

	for iter0_225 = math.max(arg0_225.data3, 1), math.min(var2_225, #var1_225) do
		local var6_225 = _.flatten({
			var1_225[iter0_225]
		})

		for iter1_225, iter2_225 in ipairs(var6_225) do
			local var7_225 = var0_225:getTaskById(iter2_225)

			if var7_225 then
				return var7_225.id, var7_225
			end

			if var4_225 then
				var5_225 = var0_225:getFinishTaskById(iter2_225)

				if var5_225 then
					var4_225 = var5_225
				elseif arg1_225 then
					return iter2_225
				else
					return var4_225.id, var4_225
				end
			else
				var4_225 = var0_225:getFinishTaskById(iter2_225)
				var5_225 = var5_225 or iter2_225
			end
		end
	end

	if var4_225 then
		return var4_225.id, var4_225
	else
		return var5_225
	end
end

function setImageFromImage(arg0_226, arg1_226, arg2_226)
	local var0_226 = GetComponent(arg0_226, "Image")

	var0_226.sprite = GetComponent(arg1_226, "Image").sprite

	if arg2_226 then
		var0_226:SetNativeSize()
	end
end

function skinTimeStamp(arg0_227)
	local var0_227, var1_227, var2_227, var3_227 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_227)

	if var0_227 >= 1 then
		return i18n("limit_skin_time_day", var0_227)
	elseif var0_227 <= 0 and var1_227 > 0 then
		return i18n("limit_skin_time_day_min", var1_227, var2_227)
	elseif var0_227 <= 0 and var1_227 <= 0 and (var2_227 > 0 or var3_227 > 0) then
		return i18n("limit_skin_time_min", math.max(var2_227, 1))
	elseif var0_227 <= 0 and var1_227 <= 0 and var2_227 <= 0 and var3_227 <= 0 then
		return i18n("limit_skin_time_overtime")
	end
end

function skinCommdityTimeStamp(arg0_228)
	local var0_228 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_228 = math.max(arg0_228 - var0_228, 0)
	local var2_228 = math.floor(var1_228 / 86400)

	if var2_228 > 0 then
		return i18n("time_remaining_tip") .. var2_228 .. i18n("word_date")
	else
		local var3_228 = math.floor(var1_228 / 3600)

		if var3_228 > 0 then
			return i18n("time_remaining_tip") .. var3_228 .. i18n("word_hour")
		else
			local var4_228 = math.floor(var1_228 / 60)

			if var4_228 > 0 then
				return i18n("time_remaining_tip") .. var4_228 .. i18n("word_minute")
			else
				return i18n("time_remaining_tip") .. var1_228 .. i18n("word_second")
			end
		end
	end
end

function InstagramTimeStamp(arg0_229)
	local var0_229 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_229
	local var1_229 = var0_229 / 86400

	if var1_229 > 1 then
		return i18n("ins_word_day", math.floor(var1_229))
	else
		local var2_229 = var0_229 / 3600

		if var2_229 > 1 then
			return i18n("ins_word_hour", math.floor(var2_229))
		else
			local var3_229 = var0_229 / 60

			if var3_229 > 1 then
				return i18n("ins_word_minu", math.floor(var3_229))
			else
				return i18n("ins_word_minu", 1)
			end
		end
	end
end

function InstagramReplyTimeStamp(arg0_230)
	local var0_230 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_230
	local var1_230 = var0_230 / 86400

	if var1_230 > 1 then
		return i18n1(math.floor(var1_230) .. "d")
	else
		local var2_230 = var0_230 / 3600

		if var2_230 > 1 then
			return i18n1(math.floor(var2_230) .. "h")
		else
			local var3_230 = var0_230 / 60

			if var3_230 > 1 then
				return i18n1(math.floor(var3_230) .. "min")
			else
				return i18n1("1min")
			end
		end
	end
end

function attireTimeStamp(arg0_231)
	local var0_231, var1_231, var2_231, var3_231 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_231)

	if var0_231 <= 0 and var1_231 <= 0 and var2_231 <= 0 and var3_231 <= 0 then
		return i18n("limit_skin_time_overtime")
	else
		return i18n("attire_time_stamp", var0_231, var1_231, var2_231)
	end
end

function checkExist(arg0_232, ...)
	local var0_232 = {
		...
	}

	for iter0_232, iter1_232 in ipairs(var0_232) do
		if arg0_232 == nil then
			break
		end

		assert(type(arg0_232) == "table", "type error : intermediate target should be table")
		assert(type(iter1_232) == "table", "type error : param should be table")

		if type(arg0_232[iter1_232[1]]) == "function" then
			arg0_232 = arg0_232[iter1_232[1]](arg0_232, unpack(iter1_232[2] or {}))
		else
			arg0_232 = arg0_232[iter1_232[1]]
		end
	end

	return arg0_232
end

function AcessWithinNull(arg0_233, arg1_233)
	if arg0_233 == nil then
		return
	end

	assert(type(arg0_233) == "table")

	return arg0_233[arg1_233]
end

function showRepairMsgbox()
	local var0_234 = {
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var1_234 = {
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var2_234 = {
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
			var2_234,
			var1_234,
			var0_234
		}
	})
end

function resourceVerify(arg0_238, arg1_238)
	if CSharpVersion > 35 then
		BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()

		return
	end

	local var0_238 = Application.persistentDataPath .. "/hashes.csv"
	local var1_238
	local var2_238 = PathMgr.ReadAllLines(var0_238)
	local var3_238 = {}

	if arg0_238 then
		setActive(arg0_238, true)
	else
		pg.UIMgr.GetInstance():LoadingOn()
	end

	local function var4_238()
		if arg0_238 then
			setActive(arg0_238, false)
		else
			pg.UIMgr.GetInstance():LoadingOff()
		end

		print(var1_238)

		if var1_238 then
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

	local var5_238 = var2_238.Length
	local var6_238

	local function var7_238(arg0_241)
		if arg0_241 < 0 then
			var4_238()

			return
		end

		if arg1_238 then
			setSlider(arg1_238, 0, var5_238, var5_238 - arg0_241)
		end

		local var0_241 = string.split(var2_238[arg0_241], ",")
		local var1_241 = var0_241[1]
		local var2_241 = var0_241[3]
		local var3_241 = PathMgr.getAssetBundle(var1_241)

		if PathMgr.FileExists(var3_241) then
			local var4_241 = PathMgr.ReadAllBytes(PathMgr.getAssetBundle(var1_241))

			if var2_241 == HashUtil.CalcMD5(var4_241) then
				onNextTick(function()
					var7_238(arg0_241 - 1)
				end)

				return
			end
		end

		var1_238 = var1_241

		var4_238()
	end

	var7_238(var5_238 - 1)
end

function splitByWordEN(arg0_243, arg1_243)
	local var0_243 = string.split(arg0_243, " ")
	local var1_243 = ""
	local var2_243 = ""
	local var3_243 = arg1_243:GetComponent(typeof(RectTransform))
	local var4_243 = arg1_243:GetComponent(typeof(Text))
	local var5_243 = var3_243.rect.width

	for iter0_243, iter1_243 in ipairs(var0_243) do
		local var6_243 = var2_243

		var2_243 = var2_243 == "" and iter1_243 or var2_243 .. " " .. iter1_243

		setText(arg1_243, var2_243)

		if var5_243 < var4_243.preferredWidth then
			var1_243 = var1_243 == "" and var6_243 or var1_243 .. "\n" .. var6_243
			var2_243 = iter1_243
		end

		if iter0_243 >= #var0_243 then
			var1_243 = var1_243 == "" and var2_243 or var1_243 .. "\n" .. var2_243
		end
	end

	return var1_243
end

function checkBirthFormat(arg0_244)
	if #arg0_244 ~= 8 then
		return false
	end

	local var0_244 = 0
	local var1_244 = #arg0_244

	while var0_244 < var1_244 do
		local var2_244 = string.byte(arg0_244, var0_244 + 1)

		if var2_244 < 48 or var2_244 > 57 then
			return false
		end

		var0_244 = var0_244 + 1
	end

	return true
end

function isHalfBodyLive2D(arg0_245)
	local var0_245 = {
		"biaoqiang",
		"z23",
		"lafei",
		"lingbo",
		"mingshi",
		"xuefeng"
	}

	return _.any(var0_245, function(arg0_246)
		return arg0_246 == arg0_245
	end)
end

function GetServerState(arg0_247)
	local var0_247 = -1
	local var1_247 = 0
	local var2_247 = 1
	local var3_247 = 2
	local var4_247 = NetConst.GetServerStateUrl()

	if PLATFORM_CODE == PLATFORM_CH then
		var4_247 = string.gsub(var4_247, "https", "http")
	end

	VersionMgr.Inst:WebRequest(var4_247, function(arg0_248, arg1_248)
		local var0_248 = true
		local var1_248 = false

		for iter0_248 in string.gmatch(arg1_248, "\"state\":%d") do
			if iter0_248 ~= "\"state\":1" then
				var0_248 = false
			end

			var1_248 = true
		end

		if not var1_248 then
			var0_248 = false
		end

		if arg0_247 ~= nil then
			arg0_247(var0_248 and var2_247 or var1_247)
		end
	end)
end

function setScrollText(arg0_249, arg1_249)
	GetOrAddComponent(arg0_249, "ScrollText"):SetText(arg1_249)
end

function changeToScrollText(arg0_250, arg1_250)
	local var0_250 = GetComponent(arg0_250, typeof(Text))

	assert(var0_250, "without component<Text>")

	local var1_250 = arg0_250:Find("subText")

	if not var1_250 then
		var1_250 = cloneTplTo(arg0_250, arg0_250, "subText")

		eachChild(arg0_250, function(arg0_251)
			setActive(arg0_251, arg0_251 == var1_250)
		end)

		arg0_250:GetComponent(typeof(Text)).enabled = false
	end

	setScrollText(var1_250, arg1_250)
end

local var18_0
local var19_0
local var20_0
local var21_0

local function var22_0(arg0_252, arg1_252, arg2_252)
	local var0_252 = arg0_252:Find("base")
	local var1_252, var2_252, var3_252 = Equipment.GetInfoTrans(arg1_252, arg2_252)

	if arg1_252.nextValue then
		local var4_252 = {
			name = arg1_252.name,
			type = arg1_252.type,
			value = arg1_252.nextValue
		}
		local var5_252, var6_252 = Equipment.GetInfoTrans(var4_252, arg2_252)

		var2_252 = var2_252 .. setColorStr("   >   " .. var6_252, COLOR_GREEN)
	end

	setText(var0_252:Find("name"), var1_252)

	if var3_252 then
		local var7_252 = "<color=#afff72>(+" .. ys.Battle.BattleConst.UltimateBonus.AuxBoostValue * 100 .. "%)</color>"

		setText(var0_252:Find("value"), var2_252 .. var7_252)
	else
		setText(var0_252:Find("value"), var2_252)
	end

	setActive(var0_252:Find("value/up"), arg1_252.compare and arg1_252.compare > 0)
	setActive(var0_252:Find("value/down"), arg1_252.compare and arg1_252.compare < 0)
	triggerToggle(var0_252, arg1_252.lock_open)

	if not arg1_252.lock_open and arg1_252.sub and #arg1_252.sub > 0 then
		GetComponent(var0_252, typeof(Toggle)).enabled = true
	else
		setActive(var0_252:Find("name/close"), false)
		setActive(var0_252:Find("name/open"), false)

		GetComponent(var0_252, typeof(Toggle)).enabled = false
	end
end

local function var23_0(arg0_253, arg1_253, arg2_253, arg3_253)
	var22_0(arg0_253, arg2_253, arg3_253)

	if not arg2_253.sub or #arg2_253.sub == 0 then
		return
	end

	var20_0(arg0_253:Find("subs"), arg1_253, arg2_253.sub, arg3_253)
end

function var20_0(arg0_254, arg1_254, arg2_254, arg3_254)
	removeAllChildren(arg0_254)
	var21_0(arg0_254, arg1_254, arg2_254, arg3_254)
end

function var21_0(arg0_255, arg1_255, arg2_255, arg3_255)
	for iter0_255, iter1_255 in ipairs(arg2_255) do
		local var0_255 = cloneTplTo(arg1_255, arg0_255)

		var23_0(var0_255, arg1_255, iter1_255, arg3_255)
	end
end

function updateEquipInfo(arg0_256, arg1_256, arg2_256, arg3_256)
	local var0_256 = arg0_256:Find("attr_tpl")

	var20_0(arg0_256:Find("attrs"), var0_256, arg1_256.attrs, arg3_256)
	setActive(arg0_256:Find("skill"), arg2_256)

	if arg2_256 then
		var23_0(arg0_256:Find("skill/attr"), var0_256, {
			name = i18n("skill"),
			value = setColorStr(arg2_256.name, "#FFDE00FF")
		}, arg3_256)
		setText(arg0_256:Find("skill/value/Text"), getSkillDescGet(arg2_256.id))
	end

	setActive(arg0_256:Find("weapon"), #arg1_256.weapon.sub > 0)

	if #arg1_256.weapon.sub > 0 then
		var20_0(arg0_256:Find("weapon"), var0_256, {
			arg1_256.weapon
		}, arg3_256)
	end

	setActive(arg0_256:Find("equip_info"), #arg1_256.equipInfo.sub > 0)

	if #arg1_256.equipInfo.sub > 0 then
		var20_0(arg0_256:Find("equip_info"), var0_256, {
			arg1_256.equipInfo
		}, arg3_256)
	end

	var23_0(arg0_256:Find("part/attr"), var0_256, {
		name = i18n("equip_info_23")
	}, arg3_256)

	local var1_256 = arg0_256:Find("part/value")
	local var2_256 = var1_256:Find("label")
	local var3_256 = {}
	local var4_256 = {}

	if #arg1_256.part[1] == 0 and #arg1_256.part[2] == 0 then
		setmetatable(var3_256, {
			__index = function(arg0_257, arg1_257)
				return true
			end
		})
		setmetatable(var4_256, {
			__index = function(arg0_258, arg1_258)
				return true
			end
		})
	else
		for iter0_256, iter1_256 in ipairs(arg1_256.part[1]) do
			var3_256[iter1_256] = true
		end

		for iter2_256, iter3_256 in ipairs(arg1_256.part[2]) do
			var4_256[iter3_256] = true
		end
	end

	local var5_256 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var3_256, var4_256)

	UIItemList.StaticAlign(var1_256, var2_256, #var5_256, function(arg0_259, arg1_259, arg2_259)
		arg1_259 = arg1_259 + 1

		if arg0_259 == UIItemList.EventUpdate then
			local var0_259 = var5_256[arg1_259]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0_259), arg2_259)
			setActive(arg2_259:Find("main"), var3_256[var0_259] and not var4_256[var0_259])
			setActive(arg2_259:Find("sub"), var4_256[var0_259] and not var3_256[var0_259])
			setImageAlpha(arg2_259, not var3_256[var0_259] and not var4_256[var0_259] and 0.3 or 1)
		end
	end)
end

function updateEquipUpgradeInfo(arg0_260, arg1_260, arg2_260)
	local var0_260 = arg0_260:Find("attr_tpl")

	var20_0(arg0_260:Find("attrs"), var0_260, arg1_260.attrs, arg2_260)
	setActive(arg0_260:Find("weapon"), #arg1_260.weapon.sub > 0)

	if #arg1_260.weapon.sub > 0 then
		var20_0(arg0_260:Find("weapon"), var0_260, {
			arg1_260.weapon
		}, arg2_260)
	end

	setActive(arg0_260:Find("equip_info"), #arg1_260.equipInfo.sub > 0)

	if #arg1_260.equipInfo.sub > 0 then
		var20_0(arg0_260:Find("equip_info"), var0_260, {
			arg1_260.equipInfo
		}, arg2_260)
	end
end

function setCanvasOverrideSorting(arg0_261, arg1_261)
	local var0_261 = arg0_261.parent

	arg0_261:SetParent(pg.LayerWeightMgr.GetInstance().uiOrigin, false)

	if isActive(arg0_261) then
		GetOrAddComponent(arg0_261, typeof(Canvas)).overrideSorting = arg1_261
	else
		setActive(arg0_261, true)

		GetOrAddComponent(arg0_261, typeof(Canvas)).overrideSorting = arg1_261

		setActive(arg0_261, false)
	end

	arg0_261:SetParent(var0_261, false)
end

function createNewGameObject(arg0_262, arg1_262)
	local var0_262 = GameObject.New()

	if arg0_262 then
		var0_262.name = "model"
	end

	var0_262.layer = arg1_262 or Layer.UI

	return GetOrAddComponent(var0_262, "RectTransform")
end

function CreateShell(arg0_263)
	if type(arg0_263) ~= "table" and type(arg0_263) ~= "userdata" then
		return arg0_263
	end

	local var0_263 = setmetatable({
		__index = arg0_263
	}, arg0_263)

	return setmetatable({}, var0_263)
end

function CameraFittingSettin(arg0_264)
	local var0_264 = GetComponent(arg0_264, typeof(Camera))
	local var1_264 = 1.77777777777778
	local var2_264 = Screen.width / Screen.height

	if var2_264 < var1_264 then
		local var3_264 = var2_264 / var1_264

		var0_264.rect = var0_0.Rect.New(0, (1 - var3_264) / 2, 1, var3_264)
	end
end

function SwitchSpecialChar(arg0_265, arg1_265)
	if PLATFORM_CODE ~= PLATFORM_US then
		arg0_265 = arg0_265:gsub(" ", " ")
		arg0_265 = arg0_265:gsub("\t", "    ")
	end

	if not arg1_265 then
		arg0_265 = arg0_265:gsub("\n", " ")
	end

	return arg0_265
end

function AfterCheck(arg0_266, arg1_266)
	local var0_266 = {}

	for iter0_266, iter1_266 in ipairs(arg0_266) do
		var0_266[iter0_266] = iter1_266[1]()
	end

	arg1_266()

	for iter2_266, iter3_266 in ipairs(arg0_266) do
		if var0_266[iter2_266] ~= iter3_266[1]() then
			iter3_266[2]()
		end

		var0_266[iter2_266] = iter3_266[1]()
	end
end

function CompareFuncs(arg0_267, arg1_267)
	local var0_267 = {}

	local function var1_267(arg0_268, arg1_268)
		var0_267[arg0_268] = var0_267[arg0_268] or {}
		var0_267[arg0_268][arg1_268] = var0_267[arg0_268][arg1_268] or arg0_267[arg0_268](arg1_268)

		return var0_267[arg0_268][arg1_268]
	end

	return function(arg0_269, arg1_269)
		local var0_269 = 1

		while var0_269 <= #arg0_267 do
			local var1_269 = var1_267(var0_269, arg0_269)
			local var2_269 = var1_267(var0_269, arg1_269)

			if var1_269 == var2_269 then
				var0_269 = var0_269 + 1
			else
				return var1_269 < var2_269
			end
		end

		return tobool(arg1_267)
	end
end

function DropResultIntegration(arg0_270)
	local var0_270 = {}
	local var1_270 = 1

	while var1_270 <= #arg0_270 do
		local var2_270 = arg0_270[var1_270].type
		local var3_270 = arg0_270[var1_270].id

		var0_270[var2_270] = var0_270[var2_270] or {}

		if var0_270[var2_270][var3_270] then
			local var4_270 = arg0_270[var0_270[var2_270][var3_270]]
			local var5_270 = table.remove(arg0_270, var1_270)

			var4_270.count = var4_270.count + var5_270.count
		else
			var0_270[var2_270][var3_270] = var1_270
			var1_270 = var1_270 + 1
		end
	end

	local var6_270 = {
		function(arg0_271)
			local var0_271 = arg0_271.type
			local var1_271 = arg0_271.id

			if var0_271 == DROP_TYPE_SHIP then
				return 1
			elseif var0_271 == DROP_TYPE_RESOURCE then
				if var1_271 == 1 then
					return 2
				else
					return 3
				end
			elseif var0_271 == DROP_TYPE_ITEM then
				if var1_271 == 59010 then
					return 4
				elseif var1_271 == 59900 then
					return 5
				else
					local var2_271 = Item.getConfigData(var1_271)
					local var3_271 = var2_271 and var2_271.type or 0

					if var3_271 == 9 then
						return 6
					elseif var3_271 == 5 then
						return 7
					elseif var3_271 == 4 then
						return 8
					elseif var3_271 == 7 then
						return 9
					end
				end
			elseif var0_271 == DROP_TYPE_VITEM and var1_271 == 59011 then
				return 4
			end

			return 100
		end,
		function(arg0_272)
			local var0_272

			if arg0_272.type == DROP_TYPE_SHIP then
				var0_272 = pg.ship_data_statistics[arg0_272.id]
			elseif arg0_272.type == DROP_TYPE_ITEM then
				var0_272 = Item.getConfigData(arg0_272.id)
			end

			return (var0_272 and var0_272.rarity or 0) * -1
		end,
		function(arg0_273)
			return arg0_273.id
		end
	}

	table.sort(arg0_270, CompareFuncs(var6_270))
end

function getLoginConfig()
	local var0_274 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_274 = 1

	for iter0_274, iter1_274 in ipairs(pg.login.all) do
		if pg.login[iter1_274].date ~= "stop" then
			local var2_274, var3_274 = parseTimeConfig(pg.login[iter1_274].date)

			assert(not var3_274)

			if pg.TimeMgr.GetInstance():inTime(var2_274, var0_274) then
				var1_274 = iter1_274

				break
			end
		end
	end

	local var4_274 = pg.login[var1_274].login_static

	var4_274 = var4_274 ~= "" and var4_274 or "login"

	local var5_274 = pg.login[var1_274].login_cri
	local var6_274 = var5_274 ~= "" and true or false
	local var7_274 = pg.login[var1_274].op_play == 1 and true or false
	local var8_274 = pg.login[var1_274].op_time

	if var8_274 == "" or not pg.TimeMgr.GetInstance():inTime(var8_274, var0_274) then
		var7_274 = false
	end

	local var9_274 = var8_274 == "" and var8_274 or table.concat(var8_274[1][1])

	return var6_274, var6_274 and var5_274 or var4_274, pg.login[var1_274].bgm, var7_274, var9_274
end

function setIntimacyIcon(arg0_275, arg1_275, arg2_275)
	local var0_275 = {}
	local var1_275

	seriesAsync({
		function(arg0_276)
			if arg0_275.childCount > 0 then
				var1_275 = arg0_275:GetChild(0)

				arg0_276()
			else
				LoadAndInstantiateAsync("template", "intimacytpl", function(arg0_277)
					var1_275 = tf(arg0_277)

					setParent(var1_275, arg0_275)
					arg0_276()
				end)
			end
		end,
		function(arg0_278)
			setImageAlpha(var1_275, arg2_275 and 0 or 1)
			eachChild(var1_275, function(arg0_279)
				setActive(arg0_279, false)
			end)

			if arg2_275 then
				local var0_278 = var1_275:Find(arg2_275 .. "(Clone)")

				if not var0_278 then
					LoadAndInstantiateAsync("ui", arg2_275, function(arg0_280)
						setParent(arg0_280, var1_275)
						setActive(arg0_280, true)
					end)
				else
					setActive(var0_278, true)
				end
			elseif arg1_275 then
				setImageSprite(var1_275, GetSpriteFromAtlas("energy", arg1_275), true)
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

function switch(arg0_283, arg1_283, arg2_283, ...)
	if arg1_283[arg0_283] then
		return arg1_283[arg0_283](...)
	elseif arg2_283 then
		return arg2_283(...)
	end
end

function parseTimeConfig(arg0_284)
	if type(arg0_284[1]) == "table" then
		return arg0_284[2], arg0_284[1]
	else
		return arg0_284
	end
end

local var25_0 = {
	__add = function(arg0_285, arg1_285)
		return NewPos(arg0_285.x + arg1_285.x, arg0_285.y + arg1_285.y)
	end,
	__sub = function(arg0_286, arg1_286)
		return NewPos(arg0_286.x - arg1_286.x, arg0_286.y - arg1_286.y)
	end,
	__mul = function(arg0_287, arg1_287)
		if type(arg1_287) == "number" then
			return NewPos(arg0_287.x * arg1_287, arg0_287.y * arg1_287)
		else
			return NewPos(arg0_287.x * arg1_287.x, arg0_287.y * arg1_287.y)
		end
	end,
	__eq = function(arg0_288, arg1_288)
		return arg0_288.x == arg1_288.x and arg0_288.y == arg1_288.y
	end,
	__tostring = function(arg0_289)
		return arg0_289.x .. "_" .. arg0_289.y
	end
}

function NewPos(arg0_290, arg1_290)
	assert(arg0_290 and arg1_290)

	local var0_290 = setmetatable({
		x = arg0_290,
		y = arg1_290
	}, var25_0)

	function var0_290.SqrMagnitude(arg0_291)
		return arg0_291.x * arg0_291.x + arg0_291.y * arg0_291.y
	end

	function var0_290.Normalize(arg0_292)
		local var0_292 = arg0_292:SqrMagnitude()

		if var0_292 > 1e-05 then
			return arg0_292 * (1 / math.sqrt(var0_292))
		else
			return NewPos(0, 0)
		end
	end

	return var0_290
end

local var26_0

function Timekeeping()
	warning(Time.realtimeSinceStartup - (var26_0 or Time.realtimeSinceStartup), Time.realtimeSinceStartup)

	var26_0 = Time.realtimeSinceStartup
end

function GetRomanDigit(arg0_294)
	return (string.char(226, 133, 160 + (arg0_294 - 1)))
end

function quickPlayAnimator(arg0_295, arg1_295)
	arg0_295:GetComponent(typeof(Animator)):Play(arg1_295, -1, 0)
end

function quickCheckAndPlayAnimator(arg0_296, arg1_296)
	local var0_296 = arg0_296:GetComponent(typeof(Animator))

	var0_296.enabled = true

	local var1_296 = Animator.StringToHash(arg1_296)

	if var0_296:HasState(0, var1_296) then
		var0_296:Play(arg1_296, -1, 0)
	end
end

function quickPlayAnimation(arg0_297, arg1_297)
	local var0_297 = arg0_297:GetComponent(typeof(Animation))

	var0_297:Stop()
	var0_297:Play(arg1_297)
end

function getSurveyUrl(arg0_298)
	local var0_298 = pg.survey_data_template[arg0_298]
	local var1_298

	if not IsUnityEditor then
		if PLATFORM_CODE == PLATFORM_CH then
			local var2_298 = getProxy(UserProxy):GetCacheGatewayInServerLogined()

			if var2_298 == PLATFORM_ANDROID then
				if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_BILI then
					var1_298 = var0_298.main_url
				else
					var1_298 = var0_298.uo_url
				end
			elseif var2_298 == PLATFORM_IPHONEPLAYER then
				var1_298 = var0_298.ios_url
			end
		elseif PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_KR then
			var1_298 = var0_298.main_url
		end
	else
		var1_298 = var0_298.main_url
	end

	local var3_298 = getProxy(PlayerProxy):getRawData().id
	local var4_298 = getProxy(UserProxy):getRawData().arg2 or ""
	local var5_298
	local var6_298 = PLATFORM == PLATFORM_ANDROID and 1 or PLATFORM == PLATFORM_IPHONEPLAYER and 2 or 3
	local var7_298 = getProxy(UserProxy):getRawData()
	local var8_298 = getProxy(ServerProxy):getRawData()[var7_298 and var7_298.server or 0]
	local var9_298 = var8_298 and var8_298.id or ""
	local var10_298 = getProxy(PlayerProxy):getRawData().level
	local var11_298 = var3_298 .. "_" .. arg0_298
	local var12_298 = var1_298
	local var13_298 = {
		var3_298,
		var4_298,
		var6_298,
		var9_298,
		var10_298,
		var11_298
	}

	if var12_298 then
		for iter0_298, iter1_298 in ipairs(var13_298) do
			var12_298 = string.gsub(var12_298, "$" .. iter0_298, tostring(iter1_298))
		end
	end

	originalPrint("survey url", tostring(var12_298))

	return var12_298
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

function FilterVarchar(arg0_300)
	assert(type(arg0_300) == "string" or type(arg0_300) == "table")

	if arg0_300 == "" then
		return nil
	end

	return arg0_300
end

function getGameset(arg0_301)
	local var0_301 = pg.gameset[arg0_301]

	assert(var0_301)

	return {
		var0_301.key_value,
		var0_301.description
	}
end

function getDorm3dGameset(arg0_302)
	local var0_302 = pg.dorm3d_set[arg0_302]

	assert(var0_302)

	return {
		var0_302.key_value_int,
		var0_302.key_value_varchar
	}
end

function GetItemsOverflowDic(arg0_303)
	arg0_303 = arg0_303 or {}

	local var0_303 = {
		[DROP_TYPE_ITEM] = {},
		[DROP_TYPE_RESOURCE] = {},
		[DROP_TYPE_EQUIP] = 0,
		[DROP_TYPE_SHIP] = 0,
		[DROP_TYPE_WORLD_ITEM] = 0
	}

	while #arg0_303 > 0 do
		local var1_303 = table.remove(arg0_303)

		switch(var1_303.type, {
			[DROP_TYPE_ITEM] = function()
				if var1_303:getConfig("open_directly") == 1 then
					for iter0_304, iter1_304 in ipairs(var1_303:getConfig("display_icon")) do
						local var0_304 = Drop.Create(iter1_304)

						var0_304.count = var0_304.count * var1_303.count

						table.insert(arg0_303, var0_304)
					end
				elseif var1_303:getSubClass():IsShipExpType() then
					var0_303[var1_303.type][var1_303.id] = defaultValue(var0_303[var1_303.type][var1_303.id], 0) + var1_303.count
				end
			end,
			[DROP_TYPE_RESOURCE] = function()
				var0_303[var1_303.type][var1_303.id] = defaultValue(var0_303[var1_303.type][var1_303.id], 0) + var1_303.count
			end,
			[DROP_TYPE_EQUIP] = function()
				var0_303[var1_303.type] = var0_303[var1_303.type] + var1_303.count
			end,
			[DROP_TYPE_SHIP] = function()
				var0_303[var1_303.type] = var0_303[var1_303.type] + var1_303.count
			end,
			[DROP_TYPE_WORLD_ITEM] = function()
				var0_303[var1_303.type] = var0_303[var1_303.type] + var1_303.count
			end
		})
	end

	return var0_303
end

function CheckOverflow(arg0_309, arg1_309)
	local var0_309 = {}
	local var1_309 = arg0_309[DROP_TYPE_RESOURCE][PlayerConst.ResGold] or 0
	local var2_309 = arg0_309[DROP_TYPE_RESOURCE][PlayerConst.ResOil] or 0
	local var3_309 = arg0_309[DROP_TYPE_EQUIP]
	local var4_309 = arg0_309[DROP_TYPE_SHIP]
	local var5_309 = getProxy(PlayerProxy):getRawData()
	local var6_309 = false

	if arg1_309 then
		local var7_309 = var5_309:OverStore(PlayerConst.ResStoreGold, var1_309)
		local var8_309 = var5_309:OverStore(PlayerConst.ResStoreOil, var2_309)

		if var7_309 > 0 or var8_309 > 0 then
			var0_309.isStoreOverflow = {
				var7_309,
				var8_309
			}
		end
	else
		if var1_309 > 0 and var5_309:GoldMax(var1_309) then
			return false, "gold"
		end

		if var2_309 > 0 and var5_309:OilMax(var2_309) then
			return false, "oil"
		end
	end

	var0_309.isExpBookOverflow = {}

	for iter0_309, iter1_309 in pairs(arg0_309[DROP_TYPE_ITEM]) do
		local var9_309 = Item.getConfigData(iter0_309)

		if getProxy(BagProxy):getItemCountById(iter0_309) + iter1_309 > var9_309.max_num then
			table.insert(var0_309.isExpBookOverflow, iter0_309)
		end
	end

	local var10_309 = getProxy(EquipmentProxy):getCapacity()

	if var3_309 > 0 and var10_309 >= var5_309:getMaxEquipmentBag() then
		return false, "equip"
	end

	local var11_309 = getProxy(BayProxy):getShipCount()

	if var4_309 > 0 and var4_309 + var11_309 > var5_309:getMaxShipBag() then
		return false, "ship"
	end

	return true, var0_309
end

function CheckShipExpOverflow(arg0_310)
	local var0_310 = getProxy(BagProxy)

	for iter0_310, iter1_310 in pairs(arg0_310[DROP_TYPE_ITEM]) do
		if var0_310:getItemCountById(iter0_310) + iter1_310 > Item.getConfigData(iter0_310).max_num then
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

function RegisterDetailButton(arg0_311, arg1_311, arg2_311)
	Drop.Change(arg2_311)
	switch(arg2_311.type, {
		[DROP_TYPE_ITEM] = function()
			if arg2_311:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
				local var0_312 = Item.getConfigData(arg2_311.id).usage_arg
				local var1_312 = var0_312[3]

				if Item.InTimeLimitSkinAssigned(arg2_311.id) then
					var1_312 = table.mergeArray(var0_312[2], var1_312, true)
				end

				local var2_312 = {}

				for iter0_312, iter1_312 in ipairs(var0_312[2]) do
					var2_312[iter1_312] = true
				end

				onButton(arg0_311, arg1_311, function()
					arg0_311:closeView()
					pg.m02:sendNotification(GAME.LOAD_LAYERS, {
						parentContext = getProxy(ContextProxy):getCurrentContext(),
						context = Context.New({
							viewComponent = SelectSkinLayer,
							mediator = SkinAtlasMediator,
							data = {
								mode = SelectSkinLayer.MODE_VIEW,
								itemId = arg2_311.id,
								selectableSkinList = underscore.map(var1_312, function(arg0_314)
									return SelectableSkin.New({
										id = arg0_314,
										isTimeLimit = var2_312[arg0_314] or false
									})
								end)
							}
						})
					})
				end, SFX_PANEL)
				setActive(arg1_311, true)
			else
				local var3_312 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_311.id) and "tech" or arg2_311:getConfig("type")

				if var27_0[var3_312] then
					local var4_312 = {
						item2Row = true,
						content = i18n(var27_0[var3_312]),
						itemList = underscore.map(arg2_311:getConfig("display_icon"), function(arg0_315)
							return Drop.Create(arg0_315)
						end)
					}

					if var3_312 == 11 then
						onButton(arg0_311, arg1_311, function()
							arg0_311:emit(BaseUI.ON_DROP_LIST_OWN, var4_312)
						end, SFX_PANEL)
					else
						onButton(arg0_311, arg1_311, function()
							arg0_311:emit(BaseUI.ON_DROP_LIST, var4_312)
						end, SFX_PANEL)
					end
				end

				setActive(arg1_311, tobool(var27_0[var3_312]))
			end
		end,
		[DROP_TYPE_EQUIP] = function()
			onButton(arg0_311, arg1_311, function()
				arg0_311:emit(BaseUI.ON_DROP, arg2_311)
			end, SFX_PANEL)
			setActive(arg1_311, true)
		end,
		[DROP_TYPE_SPWEAPON] = function()
			onButton(arg0_311, arg1_311, function()
				arg0_311:emit(BaseUI.ON_DROP, arg2_311)
			end, SFX_PANEL)
			setActive(arg1_311, true)
		end
	}, function()
		setActive(arg1_311, false)
	end)
end

function RegisterNewStyleDetailButton(arg0_323, arg1_323, arg2_323)
	Drop.Change(arg2_323)
	switch(arg2_323.type, {
		[DROP_TYPE_ITEM] = function()
			local var0_324 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_323.id) and "tech" or arg2_323:getConfig("type")

			if var27_0[var0_324] then
				local var1_324 = {
					useDeepShow = true,
					showOwn = var0_324 == 11,
					content = i18n(var27_0[var0_324]),
					itemList = underscore.map(arg2_323:getConfig("display_icon"), function(arg0_325)
						return Drop.Create(arg0_325)
					end)
				}

				onButton(arg0_323, arg1_323, function()
					arg0_323:emit(BaseUI.ON_NEW_STYLE_ITEMS, var1_324)
				end, SFX_PANEL)
			end

			setActive(arg1_323, tobool(var27_0[var0_324]))
		end
	}, function()
		setActive(arg1_323, false)
	end)
end

function UpdateOwnDisplay(arg0_328, arg1_328)
	local var0_328, var1_328 = arg1_328:getOwnedCount()

	setActive(arg0_328, var1_328 and var0_328 > 0)

	if var1_328 and var0_328 > 0 then
		setText(arg0_328:Find("label"), i18n("word_own1"))
		setText(arg0_328:Find("Text"), var0_328)
	end
end

function Damp(arg0_329, arg1_329, arg2_329)
	arg1_329 = Mathf.Max(1, arg1_329)

	local var0_329 = Mathf.Epsilon

	if arg1_329 < var0_329 or var0_329 > Mathf.Abs(arg0_329) then
		return arg0_329
	end

	if arg2_329 < var0_329 then
		return 0
	end

	local var1_329 = -4.605170186

	return arg0_329 * (1 - Mathf.Exp(var1_329 * arg2_329 / arg1_329))
end

function checkCullResume(arg0_330)
	if not ReflectionHelp.RefCallMethodEx(typeof("UnityEngine.CanvasRenderer"), "GetMaterial", GetComponent(arg0_330, "CanvasRenderer"), {
		typeof("System.Int32")
	}, {
		0
	}) then
		local var0_330 = arg0_330:GetComponentsInChildren(typeof(MeshImage)):ToTable()

		for iter0_330, iter1_330 in ipairs(var0_330) do
			iter1_330:SetVerticesDirty()
		end

		return false
	end

	return true
end

function parseEquipCode(arg0_331)
	local var0_331 = {}

	if arg0_331 and arg0_331 ~= "" then
		local var1_331 = base64.dec(arg0_331)

		var0_331 = string.split(var1_331, "/")
		var0_331[5], var0_331[6] = unpack(string.split(var0_331[5], "\\"))

		if #var0_331 < 6 or arg0_331 ~= base64.enc(table.concat({
			table.concat(underscore.first(var0_331, 5), "/"),
			var0_331[6]
		}, "\\")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_illegal"))

			var0_331 = {}
		end
	end

	for iter0_331 = 1, 6 do
		var0_331[iter0_331] = var0_331[iter0_331] and tonumber(var0_331[iter0_331], 32) or 0
	end

	return var0_331
end

function buildEquipCode(arg0_332)
	local var0_332 = underscore.map(arg0_332:getAllEquipments(), function(arg0_333)
		return ConversionBase(32, arg0_333 and arg0_333.id or 0)
	end)
	local var1_332 = {
		table.concat(var0_332, "/"),
		ConversionBase(32, checkExist(arg0_332:GetSpWeapon(), {
			"id"
		}) or 0)
	}

	return base64.enc(table.concat(var1_332, "\\"))
end

function setDirectorSpeed(arg0_334, arg1_334)
	GetComponent(arg0_334, "TimelineSpeed"):SetTimelineSpeed(arg1_334)
end

function setDefaultZeroMetatable(arg0_335)
	return setmetatable(arg0_335, {
		__index = function(arg0_336, arg1_336)
			if rawget(arg0_336, arg1_336) == nil then
				arg0_336[arg1_336] = 0
			end

			return arg0_336[arg1_336]
		end
	})
end

function checkABExist(arg0_337)
	if EDITOR_TOOL then
		return ResourceMgr.Inst:AssetExist(arg0_337)
	else
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_337))
	end
end

function compareNumber(arg0_338, arg1_338, arg2_338)
	return switch(arg1_338, {
		[">"] = function()
			return arg0_338 > arg2_338
		end,
		[">="] = function()
			return arg0_338 >= arg2_338
		end,
		["="] = function()
			return arg0_338 == arg2_338
		end,
		["<"] = function()
			return arg0_338 < arg2_338
		end,
		["<="] = function()
			return arg0_338 <= arg2_338
		end
	})
end

function ArabicToRoman(arg0_344)
	local var0_344 = {
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

	local function var1_344(arg0_345, arg1_345)
		return select(2, arg0_345:gsub(arg1_345, ""))
	end

	local var2_344 = ""

	while arg0_344 > 0 do
		for iter0_344, iter1_344 in pairs(var0_344) do
			local var3_344 = iter1_344[2]
			local var4_344 = iter1_344[1]

			while var4_344 <= arg0_344 do
				var2_344 = var2_344 .. var3_344
				arg0_344 = arg0_344 - var4_344
			end
		end
	end

	if arg0_344 > 10000 then
		local var5_344 = var1_344(var2_344, "M")

		var2_344 = "M*" .. var5_344 .. " " .. var2_344
	end

	return var2_344
end

function stringInset(arg0_346, ...)
	for iter0_346, iter1_346 in ipairs({
		...
	}) do
		arg0_346 = string.gsub(arg0_346, "$" .. iter0_346, iter1_346)
	end

	return arg0_346
end
