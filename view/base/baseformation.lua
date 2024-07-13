local var0_0 = class("BaseFormation")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1._mainTf = arg1_1
	arg0_1._heroContainer = arg2_1
	arg0_1._heroInfoTpl = arg3_1
	arg0_1._gridTFs = arg4_1
	arg0_1._widthRate = rtf(arg0_1._mainTf).rect.width / UnityEngine.Screen.width
	arg0_1._heightRate = rtf(arg0_1._mainTf).rect.height / UnityEngine.Screen.height
	arg0_1._halfWidth = rtf(arg0_1._mainTf).rect.width / 2
	arg0_1._halfHeight = rtf(arg0_1._mainTf).rect.height / 2
	arg0_1._offset = arg0_1._heroContainer.localPosition
	arg0_1._eventTriggers = {}

	pg.DelegateInfo.New(arg0_1)
end

function var0_0.SetFleetVO(arg0_2, arg1_2)
	arg0_2._currentFleetVO = arg1_2
end

function var0_0.SetShipVOs(arg0_3, arg1_3)
	arg0_3._shipVOs = arg1_3
end

function var0_0.DisableTip(arg0_4)
	arg0_4._disableTip = true
end

function var0_0.ForceDropChar(arg0_5)
	if arg0_5._currentDragDelegate then
		arg0_5._forceDropCharacter = true

		LuaHelper.triggerEndDrag(arg0_5._currentDragDelegate)
	end
end

function var0_0.AddHeroInfoModify(arg0_6, arg1_6)
	arg0_6._heroInfoModifyCb = arg1_6
end

function var0_0.AddLongPress(arg0_7, arg1_7)
	arg0_7._longPressCb = arg1_7
end

function var0_0.AddClick(arg0_8, arg1_8)
	arg0_8._click = arg1_8
end

function var0_0.AddBeginDrag(arg0_9, arg1_9)
	arg0_9._beginDrag = arg1_9
end

function var0_0.AddEndDrag(arg0_10, arg1_10)
	arg0_10._endDrag = arg1_10
end

function var0_0.AddCheckBeginDrag(arg0_11, arg1_11)
	arg0_11._checkBeginDrag = arg1_11
end

function var0_0.AddShiftOnly(arg0_12, arg1_12)
	arg0_12._shiftOnly = arg1_12
end

function var0_0.AddRemoveShip(arg0_13, arg1_13)
	arg0_13._removeShip = arg1_13
end

function var0_0.AddCheckRemove(arg0_14, arg1_14)
	arg0_14._checkRemove = arg1_14
end

function var0_0.AddCheckSwitch(arg0_15, arg1_15)
	arg0_15._checkSwitch = arg1_15
end

function var0_0.AddSwitchToDisplayMode(arg0_16, arg1_16)
	arg0_16._switchToDisplayModeHandler = arg1_16
end

function var0_0.AddSwitchToShiftMode(arg0_17, arg1_17)
	arg0_17._switchToShiftModeHandler = arg1_17
end

function var0_0.AddSwitchToPreviewMode(arg0_18, arg1_18)
	arg0_18._swtichToPreviewModeHandler = arg1_18
end

function var0_0.AddGridTipClick(arg0_19, arg1_19)
	arg0_19._gridTipClick = arg1_19
end

function var0_0.AddLoadComplete(arg0_20, arg1_20)
	arg0_20._loadComplete = arg1_20
end

function var0_0.GenCharInfo(arg0_21, arg1_21, arg2_21)
	return {
		heroInfoTF = arg1_21,
		spineRole = arg2_21
	}
end

function var0_0.ClearHeroContainer(arg0_22)
	if arg0_22._characterList then
		arg0_22:RecycleCharacterList(arg0_22._currentFleetVO:getTeamByName(TeamType.Main), arg0_22._characterList[TeamType.Main])
		arg0_22:RecycleCharacterList(arg0_22._currentFleetVO:getTeamByName(TeamType.Vanguard), arg0_22._characterList[TeamType.Vanguard])
		arg0_22:RecycleCharacterList(arg0_22._currentFleetVO:getTeamByName(TeamType.Submarine), arg0_22._characterList[TeamType.Submarine])
	end

	removeAllChildren(arg0_22._heroContainer)
end

function var0_0.LoadAllCharacter(arg0_23)
	arg0_23:ClearHeroContainer()

	arg0_23._characterList = {
		[TeamType.Vanguard] = {},
		[TeamType.Main] = {},
		[TeamType.Submarine] = {}
	}

	local function var0_23(arg0_24, arg1_24, arg2_24, arg3_24)
		if arg0_23._exited then
			return
		end

		local var0_24 = arg0_23._shipVOs[arg1_24]
		local var1_24 = tf(Instantiate(arg0_23._heroInfoTpl))

		var1_24:SetParent(arg0_23._heroContainer, false)
		SetActive(var1_24, true)
		arg0_24:SetParent(var1_24)
		arg0_24:SetRaycastTarget(false)
		arg0_24:SetLocalScale(Vector3(0.8, 0.8, 1))
		arg0_24:SetLayer(Layer.UI)
		arg0_24.modelRoot.transform:SetAsFirstSibling()

		if arg0_23._heroInfoModifyCb ~= nil then
			arg0_23._heroInfoModifyCb(var1_24, var0_24, arg0_24)
		end

		local var2_24 = arg0_23:GenCharInfo(var1_24, arg0_24)
		local var3_24 = arg0_23._characterList[arg2_24]

		var3_24[arg3_24] = var2_24

		local var4_24, var5_24, var6_24 = arg0_24:CreateInterface()

		arg0_23._eventTriggers[var6_24] = true

		pg.DelegateInfo.Add(arg0_23, var5_24.onLongPressed)

		var5_24.longPressThreshold = 1

		var5_24.onLongPressed:RemoveAllListeners()
		var5_24.onLongPressed:AddListener(function()
			if arg0_23._longPressCb ~= nil then
				arg0_23._longPressCb(var1_24, var0_24, arg0_23._currentFleetVO, arg2_24)
			end
		end)
		pg.DelegateInfo.Add(arg0_23, var4_24.onModelClick)
		var4_24.onModelClick:AddListener(function()
			if arg0_23._click ~= nil then
				arg0_23._click(var0_24, arg2_24, arg0_23._currentFleetVO)
			end
		end)
		var6_24:AddBeginDragFunc(function()
			if arg0_23._modelDrag then
				return
			end

			if arg0_23._checkBeginDrag and not arg0_23._checkBeginDrag(var0_24, arg2_24, arg0_23._currentFleetVO) then
				return
			end

			arg0_23._modelDrag = arg0_24.modelRoot
			arg0_23._currentDragDelegate = var6_24

			LeanTween.cancel(arg0_24.modelRoot)
			var1_24:SetAsLastSibling()
			arg0_23:SwitchToShiftMode(var1_24, arg2_24)
			arg0_24:SetAction("tuozhuai")

			if arg0_23._beginDrag then
				arg0_23._beginDrag(var1_24)
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_HOME_DRAG)
		end)
		var6_24:AddDragFunc(function(arg0_28, arg1_28)
			if arg0_23._modelDrag ~= arg0_24.modelRoot then
				return
			end

			var1_24.localPosition = Vector3(arg1_28.position.x * arg0_23._widthRate - arg0_23._halfWidth - arg0_23._offset.x, arg1_28.position.y * arg0_23._heightRate - arg0_23._halfHeight - arg0_23._offset.y, -22)
		end)
		var6_24:AddDragEndFunc(function(arg0_29, arg1_29)
			if arg0_23._modelDrag ~= arg0_24.modelRoot then
				return
			end

			arg0_23._modelDrag = false

			local var0_29 = arg0_23._forceDropCharacter

			arg0_23._forceDropCharacter = nil
			arg0_23._currentDragDelegate = nil

			arg0_24:SetAction("stand")

			local function var1_29()
				arg0_23:SwitchToDisplayMode()
				arg0_23:SortSiblingIndex()

				if arg0_23._shiftOnly ~= nil then
					arg0_23._shiftOnly(arg0_23._currentFleetVO)
				end
			end

			if var0_29 then
				var1_29()

				return
			end

			local function var2_29()
				for iter0_31, iter1_31 in ipairs(var3_24) do
					if iter1_31.heroInfoTF == var1_24 then
						iter1_31.spineRole:Dispose()
						var1_24.gameObject:Destroy()
						table.remove(var3_24, iter0_31)

						break
					end
				end

				arg0_23:SwitchToDisplayMode()
				arg0_23:SortSiblingIndex()

				if arg0_23._removeShip ~= nil then
					arg0_23._removeShip(var0_24, arg0_23._currentFleetVO)
				end
			end

			local var3_29, var4_29 = arg0_23:GetShipPos(arg0_23._currentFleetVO, var0_24)

			if arg1_29.position.x < UnityEngine.Screen.width * 0.15 or arg1_29.position.x > UnityEngine.Screen.width * 0.87 or arg1_29.position.y < UnityEngine.Screen.height * 0.18 or arg1_29.position.y > UnityEngine.Screen.height * 0.7 then
				if arg0_23._checkRemove ~= nil then
					arg0_23._checkRemove(var1_29, var2_29, var0_24, arg0_23._currentFleetVO, var4_29)
				end
			else
				var1_29()
			end

			if arg0_23._endDrag ~= nil then
				arg0_23._endDrag(var1_24)
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_HOME_PUT)
		end)
		arg0_23:SetCharacterPos(arg2_24, arg3_24, var2_24)
	end

	local var1_23 = {}

	local function var2_23(arg0_32, arg1_32)
		for iter0_32, iter1_32 in ipairs(arg0_32) do
			table.insert(var1_23, function(arg0_33)
				local var0_33 = SpineRole.New(arg0_23._shipVOs[iter1_32])

				var0_33:Load(function()
					var0_23(var0_33, iter1_32, arg1_32, iter0_32)
					arg0_33()
				end, nil, var0_33.ORBIT_KEY_UI)
			end)
		end
	end

	local var3_23 = arg0_23._currentFleetVO:getFleetType()

	if var3_23 == FleetType.Normal then
		var2_23(arg0_23._currentFleetVO:getTeamByName(TeamType.Vanguard), TeamType.Vanguard)
		var2_23(arg0_23._currentFleetVO:getTeamByName(TeamType.Main), TeamType.Main)
	elseif var3_23 == FleetType.Submarine then
		var2_23(arg0_23._currentFleetVO:getTeamByName(TeamType.Submarine), TeamType.Submarine)
	end

	pg.UIMgr.GetInstance():LoadingOn()
	parallelAsync(var1_23, function(arg0_35)
		pg.UIMgr.GetInstance():LoadingOff()

		if arg0_23._exited then
			return
		end

		arg0_23:SortSiblingIndex()

		if arg0_23._loadComplete then
			arg0_23._loadComplete()
		end
	end)
end

function var0_0.GetShipPos(arg0_36, arg1_36, arg2_36)
	if not arg2_36 then
		return
	end

	local var0_36 = arg2_36:getTeamType()
	local var1_36 = arg1_36:getTeamByName(var0_36)

	return table.indexof(var1_36, arg2_36.id) or -1, var0_36
end

function var0_0.SetAllCharacterPos(arg0_37)
	local var0_37 = {
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}

	_.each(var0_37, function(arg0_38)
		for iter0_38, iter1_38 in ipairs(arg0_37._characterList[arg0_38]) do
			arg0_37:SetCharacterPos(arg0_38, iter0_38, iter1_38)
		end
	end)
end

function var0_0.SetCharacterPos(arg0_39, arg1_39, arg2_39, arg3_39)
	assert(arg0_39._gridTFs[arg1_39], "没有找到编队显示对象_teamType:" .. tostring(arg1_39))

	local var0_39 = arg3_39.heroInfoTF
	local var1_39 = arg3_39.spineRole
	local var2_39 = var1_39.modelRoot
	local var3_39 = arg0_39._gridTFs[arg1_39][arg2_39]
	local var4_39 = var3_39.localPosition

	LeanTween.cancel(var2_39)

	var0_39.localPosition = Vector3(var4_39.x, var4_39.y, -15 + var4_39.z + arg2_39)
	var2_39.transform.localPosition = Vector3(0, 20, 0)

	LeanTween.moveY(rtf(var2_39), 0, 0.5):setDelay(0.5)
	SetActive(var3_39:Find("shadow"), true)
	var1_39:SetAction("stand")
	var1_39:resumeRole()
end

function var0_0.ResetGrid(arg0_40, arg1_40, arg2_40)
	if not arg0_40._gridTFs[arg1_40] then
		return
	end

	local var0_40 = arg0_40._currentFleetVO:getTeamByName(arg1_40)

	assert(var0_40, arg1_40)

	local var1_40 = arg0_40._gridTFs[arg1_40]

	for iter0_40, iter1_40 in ipairs(var1_40) do
		SetActive(iter1_40:Find("shadow"), false)
		SetActive(iter1_40:Find("tip"), false)
	end

	if arg1_40 == TeamType.Main and #arg0_40._currentFleetVO:getTeamByName(TeamType.Vanguard) == 0 then
		return
	end

	local var2_40 = #var0_40

	if var2_40 < 3 then
		local var3_40 = var1_40[var2_40 + 1]:Find("tip")

		var3_40:GetComponent("Button").enabled = true

		onButton(arg0_40, var3_40, function()
			if arg0_40._gridTipClick then
				arg0_40._gridTipClick(arg1_40, arg0_40._currentFleetVO)
			end
		end, SFX_PANEL)

		var3_40.localScale = Vector3(0, 0, 1)

		if not arg0_40._disableTip then
			SetActive(var3_40, not arg2_40)
		end

		LeanTween.value(go(var3_40), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_42)
			var3_40.localScale = Vector3(arg0_42, arg0_42, 1)
		end)):setEase(LeanTweenType.easeOutBack)
	end
end

function var0_0.SwitchToShiftMode(arg0_43, arg1_43, arg2_43)
	assert(arg0_43._gridTFs[arg2_43], "没有找到编队显示对象_teamType:" .. tostring(arg2_43))

	if arg0_43._switchToShiftModeHandler then
		arg0_43._switchToShiftModeHandler()
	end

	for iter0_43 = 1, 3 do
		local var0_43 = {
			TeamType.Vanguard,
			TeamType.Main,
			TeamType.Submarine
		}

		_.each(var0_43, function(arg0_44)
			if arg0_43._gridTFs[arg0_44] and arg0_43._gridTFs[arg0_44][iter0_43] then
				setActive(arg0_43._gridTFs[arg0_44][iter0_43]:Find("tip"), false)
			end
		end)
		setActive(arg0_43._gridTFs[arg2_43][iter0_43]:Find("shadow"), false)
	end

	local var1_43 = arg0_43._characterList[arg2_43]

	for iter1_43, iter2_43 in ipairs(var1_43) do
		local var2_43 = iter2_43.heroInfoTF
		local var3_43 = iter2_43.spineRole
		local var4_43 = var3_43.modelRoot

		if var2_43 ~= arg1_43 then
			LeanTween.moveY(rtf(var4_43), var4_43.transform.localPosition.y + 20, 0.5)

			local var5_43, var6_43, var7_43 = var3_43:GetInterface()

			arg0_43._eventTriggers[var7_43] = true

			var7_43:AddPointEnterFunc(function()
				for iter0_45, iter1_45 in ipairs(var1_43) do
					if iter1_45.heroInfoTF == var2_43 then
						seriesAsync({
							function(arg0_46)
								if not arg0_43._checkSwitch then
									return arg0_46()
								end

								arg0_43._checkSwitch(arg0_46, arg0_43._shiftIndex, iter0_45, arg0_43._currentFleetVO, arg2_43)
							end,
							function(arg0_47)
								arg0_43:Shift(arg0_43._shiftIndex, iter0_45, arg2_43)
							end
						})

						break
					end
				end
			end)
		else
			arg0_43._shiftIndex = iter1_43

			var3_43:DisableInterface()
		end

		var3_43:SetAction("normal")
	end
end

function var0_0.SwitchToDisplayMode(arg0_48)
	if arg0_48._switchToDisplayModeHandler then
		arg0_48._switchToDisplayModeHandler()
	end

	local function var0_48(arg0_49)
		for iter0_49, iter1_49 in ipairs(arg0_49) do
			local var0_49 = iter1_49.heroInfoTF
			local var1_49 = iter1_49.spineRole
			local var2_49 = var1_49.modelRoot
			local var3_49, var4_49, var5_49 = var1_49:GetInterface()

			if var5_49 then
				arg0_48._eventTriggers[var5_49] = true

				if var5_49 then
					var5_49:RemovePointEnterFunc()
				end
			end
		end
	end

	arg0_48:TurnOffPreviewMode()
	var0_48(arg0_48._characterList[TeamType.Vanguard])
	var0_48(arg0_48._characterList[TeamType.Main])
	var0_48(arg0_48._characterList[TeamType.Submarine])

	arg0_48._shiftIndex = nil
end

function var0_0.SwitchToPreviewMode(arg0_50)
	if arg0_50._swtichToPreviewModeHandler then
		arg0_50._swtichToPreviewModeHandler()
	end

	arg0_50:ResetGrid(TeamType.Vanguard, true)
	arg0_50:ResetGrid(TeamType.Main, true)
	arg0_50:ResetGrid(TeamType.Submarine, true)
	arg0_50:SetAllCharacterPos()
	arg0_50:SetEnableForSpineInterface(false)
end

function var0_0.TurnOffPreviewMode(arg0_51)
	arg0_51:ResetGrid(TeamType.Vanguard)
	arg0_51:ResetGrid(TeamType.Main)
	arg0_51:ResetGrid(TeamType.Submarine)
	arg0_51:SetAllCharacterPos()
	arg0_51:SetEnableForSpineInterface(true)
end

function var0_0.SetEnableForSpineInterface(arg0_52, arg1_52)
	local var0_52 = {
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}

	_.each(var0_52, function(arg0_53)
		for iter0_53, iter1_53 in ipairs(arg0_52._characterList[arg0_53]) do
			if arg1_52 then
				iter1_53.spineRole:EnableInterface()
			else
				iter1_53.spineRole:DisableInterface()
			end
		end
	end)
end

function var0_0.Shift(arg0_54, arg1_54, arg2_54, arg3_54)
	assert(arg0_54._gridTFs[arg3_54], "没有找到编队显示对象_teamType:" .. tostring(arg3_54))

	local var0_54 = arg0_54._characterList[arg3_54]
	local var1_54 = arg0_54._gridTFs[arg3_54]
	local var2_54 = var0_54[arg2_54]
	local var3_54 = var2_54.heroInfoTF
	local var4_54 = var2_54.spineRole.modelRoot
	local var5_54 = var1_54[arg1_54].localPosition

	var3_54.localPosition = Vector3(var5_54.x, var5_54.y + 20, -15 + var5_54.z + arg1_54)

	local var6_54 = var0_54[arg1_54].spineRole.ship.id
	local var7_54 = var0_54[arg2_54].spineRole.ship.id

	LeanTween.cancel(var4_54)

	var0_54[arg1_54], var0_54[arg2_54] = var0_54[arg2_54], var0_54[arg1_54]

	arg0_54._currentFleetVO:switchShip(arg3_54, arg1_54, arg2_54, var6_54, var7_54)

	arg0_54._shiftIndex = arg2_54
end

function var0_0.SortSiblingIndex(arg0_55)
	local var0_55 = 0
	local var1_55 = {
		2,
		1,
		3
	}

	for iter0_55, iter1_55 in ipairs(var1_55) do
		local var2_55 = arg0_55._characterList[TeamType.Main][iter1_55]

		if var2_55 then
			local var3_55 = var2_55.heroInfoTF

			tf(var3_55):SetSiblingIndex(var0_55)

			var0_55 = var0_55 + 1
		end
	end

	local var4_55 = 3

	while var4_55 > 0 do
		local var5_55 = arg0_55._characterList[TeamType.Vanguard][var4_55]

		if var5_55 then
			local var6_55 = var5_55.heroInfoTF

			tf(var6_55):SetSiblingIndex(var0_55)

			var0_55 = var0_55 + 1
		end

		var4_55 = var4_55 - 1
	end

	local var7_55 = 3

	while var7_55 > 0 do
		local var8_55 = arg0_55._characterList[TeamType.Submarine][var7_55]

		if var8_55 then
			local var9_55 = var8_55.heroInfoTF

			tf(var9_55):SetSiblingIndex(var0_55)

			var0_55 = var0_55 + 1
		end

		var7_55 = var7_55 - 1
	end
end

function var0_0.UpdateGridVisibility(arg0_56)
	local var0_56 = arg0_56._currentFleetVO:getFleetType()

	_.each(arg0_56._gridTFs[TeamType.Main], function(arg0_57)
		setActive(arg0_57, var0_56 == FleetType.Normal)
	end)
	_.each(arg0_56._gridTFs[TeamType.Vanguard], function(arg0_58)
		setActive(arg0_58, var0_56 == FleetType.Normal)
	end)
	_.each(arg0_56._gridTFs[TeamType.Submarine], function(arg0_59)
		setActive(arg0_59, var0_56 == FleetType.Submarine)
	end)
end

function var0_0.RecycleCharacterList(arg0_60, arg1_60, arg2_60)
	for iter0_60, iter1_60 in ipairs(arg1_60) do
		local var0_60 = arg2_60[iter0_60]

		if var0_60 then
			var0_60.spineRole:Dispose()

			arg2_60[iter0_60] = nil
		end
	end
end

function var0_0.Destroy(arg0_61)
	arg0_61._exited = true

	arg0_61:RecycleCharacterList(arg0_61._currentFleetVO:getTeamByName(TeamType.Main), arg0_61._characterList[TeamType.Main])
	arg0_61:RecycleCharacterList(arg0_61._currentFleetVO:getTeamByName(TeamType.Vanguard), arg0_61._characterList[TeamType.Vanguard])
	arg0_61:RecycleCharacterList(arg0_61._currentFleetVO:getTeamByName(TeamType.Submarine), arg0_61._characterList[TeamType.Submarine])

	if arg0_61._eventTriggers then
		for iter0_61, iter1_61 in pairs(arg0_61._eventTriggers) do
			ClearEventTrigger(iter0_61)
		end

		arg0_61._eventTriggers = nil
	end
end

return var0_0
