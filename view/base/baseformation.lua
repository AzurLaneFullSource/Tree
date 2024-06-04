local var0 = class("BaseFormation")

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0._mainTf = arg1
	arg0._heroContainer = arg2
	arg0._heroInfoTpl = arg3
	arg0._gridTFs = arg4
	arg0._widthRate = rtf(arg0._mainTf).rect.width / UnityEngine.Screen.width
	arg0._heightRate = rtf(arg0._mainTf).rect.height / UnityEngine.Screen.height
	arg0._halfWidth = rtf(arg0._mainTf).rect.width / 2
	arg0._halfHeight = rtf(arg0._mainTf).rect.height / 2
	arg0._offset = arg0._heroContainer.localPosition
	arg0._eventTriggers = {}

	pg.DelegateInfo.New(arg0)
end

function var0.SetFleetVO(arg0, arg1)
	arg0._currentFleetVO = arg1
end

function var0.SetShipVOs(arg0, arg1)
	arg0._shipVOs = arg1
end

function var0.DisableTip(arg0)
	arg0._disableTip = true
end

function var0.ForceDropChar(arg0)
	if arg0._currentDragDelegate then
		arg0._forceDropCharacter = true

		LuaHelper.triggerEndDrag(arg0._currentDragDelegate)
	end
end

function var0.AddHeroInfoModify(arg0, arg1)
	arg0._heroInfoModifyCb = arg1
end

function var0.AddLongPress(arg0, arg1)
	arg0._longPressCb = arg1
end

function var0.AddClick(arg0, arg1)
	arg0._click = arg1
end

function var0.AddBeginDrag(arg0, arg1)
	arg0._beginDrag = arg1
end

function var0.AddEndDrag(arg0, arg1)
	arg0._endDrag = arg1
end

function var0.AddCheckBeginDrag(arg0, arg1)
	arg0._checkBeginDrag = arg1
end

function var0.AddShiftOnly(arg0, arg1)
	arg0._shiftOnly = arg1
end

function var0.AddRemoveShip(arg0, arg1)
	arg0._removeShip = arg1
end

function var0.AddCheckRemove(arg0, arg1)
	arg0._checkRemove = arg1
end

function var0.AddCheckSwitch(arg0, arg1)
	arg0._checkSwitch = arg1
end

function var0.AddSwitchToDisplayMode(arg0, arg1)
	arg0._switchToDisplayModeHandler = arg1
end

function var0.AddSwitchToShiftMode(arg0, arg1)
	arg0._switchToShiftModeHandler = arg1
end

function var0.AddSwitchToPreviewMode(arg0, arg1)
	arg0._swtichToPreviewModeHandler = arg1
end

function var0.AddGridTipClick(arg0, arg1)
	arg0._gridTipClick = arg1
end

function var0.AddLoadComplete(arg0, arg1)
	arg0._loadComplete = arg1
end

function var0.GenCharInfo(arg0, arg1, arg2)
	return {
		heroInfoTF = arg1,
		spineRole = arg2
	}
end

function var0.ClearHeroContainer(arg0)
	if arg0._characterList then
		arg0:RecycleCharacterList(arg0._currentFleetVO:getTeamByName(TeamType.Main), arg0._characterList[TeamType.Main])
		arg0:RecycleCharacterList(arg0._currentFleetVO:getTeamByName(TeamType.Vanguard), arg0._characterList[TeamType.Vanguard])
		arg0:RecycleCharacterList(arg0._currentFleetVO:getTeamByName(TeamType.Submarine), arg0._characterList[TeamType.Submarine])
	end

	removeAllChildren(arg0._heroContainer)
end

function var0.LoadAllCharacter(arg0)
	arg0:ClearHeroContainer()

	arg0._characterList = {
		[TeamType.Vanguard] = {},
		[TeamType.Main] = {},
		[TeamType.Submarine] = {}
	}

	local function var0(arg0, arg1, arg2, arg3)
		if arg0._exited then
			return
		end

		local var0 = arg0._shipVOs[arg1]
		local var1 = tf(Instantiate(arg0._heroInfoTpl))

		var1:SetParent(arg0._heroContainer, false)
		SetActive(var1, true)
		arg0:SetParent(var1)
		arg0:SetRaycastTarget(false)
		arg0:SetLocalScale(Vector3(0.8, 0.8, 1))
		arg0:SetLayer(Layer.UI)
		arg0.modelRoot.transform:SetAsFirstSibling()

		if arg0._heroInfoModifyCb ~= nil then
			arg0._heroInfoModifyCb(var1, var0, arg0)
		end

		local var2 = arg0:GenCharInfo(var1, arg0)
		local var3 = arg0._characterList[arg2]

		var3[arg3] = var2

		local var4, var5, var6 = arg0:CreateInterface()

		arg0._eventTriggers[var6] = true

		pg.DelegateInfo.Add(arg0, var5.onLongPressed)

		var5.longPressThreshold = 1

		var5.onLongPressed:RemoveAllListeners()
		var5.onLongPressed:AddListener(function()
			if arg0._longPressCb ~= nil then
				arg0._longPressCb(var1, var0, arg0._currentFleetVO, arg2)
			end
		end)
		pg.DelegateInfo.Add(arg0, var4.onModelClick)
		var4.onModelClick:AddListener(function()
			if arg0._click ~= nil then
				arg0._click(var0, arg2, arg0._currentFleetVO)
			end
		end)
		var6:AddBeginDragFunc(function()
			if arg0._modelDrag then
				return
			end

			if arg0._checkBeginDrag and not arg0._checkBeginDrag(var0, arg2, arg0._currentFleetVO) then
				return
			end

			arg0._modelDrag = arg0.modelRoot
			arg0._currentDragDelegate = var6

			LeanTween.cancel(arg0.modelRoot)
			var1:SetAsLastSibling()
			arg0:SwitchToShiftMode(var1, arg2)
			arg0:SetAction("tuozhuai")

			if arg0._beginDrag then
				arg0._beginDrag(var1)
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_HOME_DRAG)
		end)
		var6:AddDragFunc(function(arg0, arg1)
			if arg0._modelDrag ~= arg0.modelRoot then
				return
			end

			var1.localPosition = Vector3(arg1.position.x * arg0._widthRate - arg0._halfWidth - arg0._offset.x, arg1.position.y * arg0._heightRate - arg0._halfHeight - arg0._offset.y, -22)
		end)
		var6:AddDragEndFunc(function(arg0, arg1)
			if arg0._modelDrag ~= arg0.modelRoot then
				return
			end

			arg0._modelDrag = false

			local var0 = arg0._forceDropCharacter

			arg0._forceDropCharacter = nil
			arg0._currentDragDelegate = nil

			arg0:SetAction("stand")

			local function var1()
				arg0:SwitchToDisplayMode()
				arg0:SortSiblingIndex()

				if arg0._shiftOnly ~= nil then
					arg0._shiftOnly(arg0._currentFleetVO)
				end
			end

			if var0 then
				var1()

				return
			end

			local function var2()
				for iter0, iter1 in ipairs(var3) do
					if iter1.heroInfoTF == var1 then
						iter1.spineRole:Dispose()
						var1.gameObject:Destroy()
						table.remove(var3, iter0)

						break
					end
				end

				arg0:SwitchToDisplayMode()
				arg0:SortSiblingIndex()

				if arg0._removeShip ~= nil then
					arg0._removeShip(var0, arg0._currentFleetVO)
				end
			end

			local var3, var4 = arg0:GetShipPos(arg0._currentFleetVO, var0)

			if arg1.position.x < UnityEngine.Screen.width * 0.15 or arg1.position.x > UnityEngine.Screen.width * 0.87 or arg1.position.y < UnityEngine.Screen.height * 0.18 or arg1.position.y > UnityEngine.Screen.height * 0.7 then
				if arg0._checkRemove ~= nil then
					arg0._checkRemove(var1, var2, var0, arg0._currentFleetVO, var4)
				end
			else
				var1()
			end

			if arg0._endDrag ~= nil then
				arg0._endDrag(var1)
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_HOME_PUT)
		end)
		arg0:SetCharacterPos(arg2, arg3, var2)
	end

	local var1 = {}

	local function var2(arg0, arg1)
		for iter0, iter1 in ipairs(arg0) do
			table.insert(var1, function(arg0)
				local var0 = SpineRole.New(arg0._shipVOs[iter1])

				var0:Load(function()
					var0(var0, iter1, arg1, iter0)
					arg0()
				end, nil, var0.ORBIT_KEY_UI)
			end)
		end
	end

	local var3 = arg0._currentFleetVO:getFleetType()

	if var3 == FleetType.Normal then
		var2(arg0._currentFleetVO:getTeamByName(TeamType.Vanguard), TeamType.Vanguard)
		var2(arg0._currentFleetVO:getTeamByName(TeamType.Main), TeamType.Main)
	elseif var3 == FleetType.Submarine then
		var2(arg0._currentFleetVO:getTeamByName(TeamType.Submarine), TeamType.Submarine)
	end

	pg.UIMgr.GetInstance():LoadingOn()
	parallelAsync(var1, function(arg0)
		pg.UIMgr.GetInstance():LoadingOff()

		if arg0._exited then
			return
		end

		arg0:SortSiblingIndex()

		if arg0._loadComplete then
			arg0._loadComplete()
		end
	end)
end

function var0.GetShipPos(arg0, arg1, arg2)
	if not arg2 then
		return
	end

	local var0 = arg2:getTeamType()
	local var1 = arg1:getTeamByName(var0)

	return table.indexof(var1, arg2.id) or -1, var0
end

function var0.SetAllCharacterPos(arg0)
	local var0 = {
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}

	_.each(var0, function(arg0)
		for iter0, iter1 in ipairs(arg0._characterList[arg0]) do
			arg0:SetCharacterPos(arg0, iter0, iter1)
		end
	end)
end

function var0.SetCharacterPos(arg0, arg1, arg2, arg3)
	assert(arg0._gridTFs[arg1], "没有找到编队显示对象_teamType:" .. tostring(arg1))

	local var0 = arg3.heroInfoTF
	local var1 = arg3.spineRole
	local var2 = var1.modelRoot
	local var3 = arg0._gridTFs[arg1][arg2]
	local var4 = var3.localPosition

	LeanTween.cancel(var2)

	var0.localPosition = Vector3(var4.x, var4.y, -15 + var4.z + arg2)
	var2.transform.localPosition = Vector3(0, 20, 0)

	LeanTween.moveY(rtf(var2), 0, 0.5):setDelay(0.5)
	SetActive(var3:Find("shadow"), true)
	var1:SetAction("stand")
	var1:resumeRole()
end

function var0.ResetGrid(arg0, arg1, arg2)
	if not arg0._gridTFs[arg1] then
		return
	end

	local var0 = arg0._currentFleetVO:getTeamByName(arg1)

	assert(var0, arg1)

	local var1 = arg0._gridTFs[arg1]

	for iter0, iter1 in ipairs(var1) do
		SetActive(iter1:Find("shadow"), false)
		SetActive(iter1:Find("tip"), false)
	end

	if arg1 == TeamType.Main and #arg0._currentFleetVO:getTeamByName(TeamType.Vanguard) == 0 then
		return
	end

	local var2 = #var0

	if var2 < 3 then
		local var3 = var1[var2 + 1]:Find("tip")

		var3:GetComponent("Button").enabled = true

		onButton(arg0, var3, function()
			if arg0._gridTipClick then
				arg0._gridTipClick(arg1, arg0._currentFleetVO)
			end
		end, SFX_PANEL)

		var3.localScale = Vector3(0, 0, 1)

		if not arg0._disableTip then
			SetActive(var3, not arg2)
		end

		LeanTween.value(go(var3), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0)
			var3.localScale = Vector3(arg0, arg0, 1)
		end)):setEase(LeanTweenType.easeOutBack)
	end
end

function var0.SwitchToShiftMode(arg0, arg1, arg2)
	assert(arg0._gridTFs[arg2], "没有找到编队显示对象_teamType:" .. tostring(arg2))

	if arg0._switchToShiftModeHandler then
		arg0._switchToShiftModeHandler()
	end

	for iter0 = 1, 3 do
		local var0 = {
			TeamType.Vanguard,
			TeamType.Main,
			TeamType.Submarine
		}

		_.each(var0, function(arg0)
			if arg0._gridTFs[arg0] and arg0._gridTFs[arg0][iter0] then
				setActive(arg0._gridTFs[arg0][iter0]:Find("tip"), false)
			end
		end)
		setActive(arg0._gridTFs[arg2][iter0]:Find("shadow"), false)
	end

	local var1 = arg0._characterList[arg2]

	for iter1, iter2 in ipairs(var1) do
		local var2 = iter2.heroInfoTF
		local var3 = iter2.spineRole
		local var4 = var3.modelRoot

		if var2 ~= arg1 then
			LeanTween.moveY(rtf(var4), var4.transform.localPosition.y + 20, 0.5)

			local var5, var6, var7 = var3:GetInterface()

			arg0._eventTriggers[var7] = true

			var7:AddPointEnterFunc(function()
				for iter0, iter1 in ipairs(var1) do
					if iter1.heroInfoTF == var2 then
						seriesAsync({
							function(arg0)
								if not arg0._checkSwitch then
									return arg0()
								end

								arg0._checkSwitch(arg0, arg0._shiftIndex, iter0, arg0._currentFleetVO, arg2)
							end,
							function(arg0)
								arg0:Shift(arg0._shiftIndex, iter0, arg2)
							end
						})

						break
					end
				end
			end)
		else
			arg0._shiftIndex = iter1

			var3:DisableInterface()
		end

		var3:SetAction("normal")
	end
end

function var0.SwitchToDisplayMode(arg0)
	if arg0._switchToDisplayModeHandler then
		arg0._switchToDisplayModeHandler()
	end

	local function var0(arg0)
		for iter0, iter1 in ipairs(arg0) do
			local var0 = iter1.heroInfoTF
			local var1 = iter1.spineRole
			local var2 = var1.modelRoot
			local var3, var4, var5 = var1:GetInterface()

			if var5 then
				arg0._eventTriggers[var5] = true

				if var5 then
					var5:RemovePointEnterFunc()
				end
			end
		end
	end

	arg0:TurnOffPreviewMode()
	var0(arg0._characterList[TeamType.Vanguard])
	var0(arg0._characterList[TeamType.Main])
	var0(arg0._characterList[TeamType.Submarine])

	arg0._shiftIndex = nil
end

function var0.SwitchToPreviewMode(arg0)
	if arg0._swtichToPreviewModeHandler then
		arg0._swtichToPreviewModeHandler()
	end

	arg0:ResetGrid(TeamType.Vanguard, true)
	arg0:ResetGrid(TeamType.Main, true)
	arg0:ResetGrid(TeamType.Submarine, true)
	arg0:SetAllCharacterPos()
	arg0:SetEnableForSpineInterface(false)
end

function var0.TurnOffPreviewMode(arg0)
	arg0:ResetGrid(TeamType.Vanguard)
	arg0:ResetGrid(TeamType.Main)
	arg0:ResetGrid(TeamType.Submarine)
	arg0:SetAllCharacterPos()
	arg0:SetEnableForSpineInterface(true)
end

function var0.SetEnableForSpineInterface(arg0, arg1)
	local var0 = {
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}

	_.each(var0, function(arg0)
		for iter0, iter1 in ipairs(arg0._characterList[arg0]) do
			if arg1 then
				iter1.spineRole:EnableInterface()
			else
				iter1.spineRole:DisableInterface()
			end
		end
	end)
end

function var0.Shift(arg0, arg1, arg2, arg3)
	assert(arg0._gridTFs[arg3], "没有找到编队显示对象_teamType:" .. tostring(arg3))

	local var0 = arg0._characterList[arg3]
	local var1 = arg0._gridTFs[arg3]
	local var2 = var0[arg2]
	local var3 = var2.heroInfoTF
	local var4 = var2.spineRole.modelRoot
	local var5 = var1[arg1].localPosition

	var3.localPosition = Vector3(var5.x, var5.y + 20, -15 + var5.z + arg1)

	local var6 = var0[arg1].spineRole.ship.id
	local var7 = var0[arg2].spineRole.ship.id

	LeanTween.cancel(var4)

	var0[arg1], var0[arg2] = var0[arg2], var0[arg1]

	arg0._currentFleetVO:switchShip(arg3, arg1, arg2, var6, var7)

	arg0._shiftIndex = arg2
end

function var0.SortSiblingIndex(arg0)
	local var0 = 0
	local var1 = {
		2,
		1,
		3
	}

	for iter0, iter1 in ipairs(var1) do
		local var2 = arg0._characterList[TeamType.Main][iter1]

		if var2 then
			local var3 = var2.heroInfoTF

			tf(var3):SetSiblingIndex(var0)

			var0 = var0 + 1
		end
	end

	local var4 = 3

	while var4 > 0 do
		local var5 = arg0._characterList[TeamType.Vanguard][var4]

		if var5 then
			local var6 = var5.heroInfoTF

			tf(var6):SetSiblingIndex(var0)

			var0 = var0 + 1
		end

		var4 = var4 - 1
	end

	local var7 = 3

	while var7 > 0 do
		local var8 = arg0._characterList[TeamType.Submarine][var7]

		if var8 then
			local var9 = var8.heroInfoTF

			tf(var9):SetSiblingIndex(var0)

			var0 = var0 + 1
		end

		var7 = var7 - 1
	end
end

function var0.UpdateGridVisibility(arg0)
	local var0 = arg0._currentFleetVO:getFleetType()

	_.each(arg0._gridTFs[TeamType.Main], function(arg0)
		setActive(arg0, var0 == FleetType.Normal)
	end)
	_.each(arg0._gridTFs[TeamType.Vanguard], function(arg0)
		setActive(arg0, var0 == FleetType.Normal)
	end)
	_.each(arg0._gridTFs[TeamType.Submarine], function(arg0)
		setActive(arg0, var0 == FleetType.Submarine)
	end)
end

function var0.RecycleCharacterList(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg1) do
		local var0 = arg2[iter0]

		if var0 then
			var0.spineRole:Dispose()

			arg2[iter0] = nil
		end
	end
end

function var0.Destroy(arg0)
	arg0._exited = true

	arg0:RecycleCharacterList(arg0._currentFleetVO:getTeamByName(TeamType.Main), arg0._characterList[TeamType.Main])
	arg0:RecycleCharacterList(arg0._currentFleetVO:getTeamByName(TeamType.Vanguard), arg0._characterList[TeamType.Vanguard])
	arg0:RecycleCharacterList(arg0._currentFleetVO:getTeamByName(TeamType.Submarine), arg0._characterList[TeamType.Submarine])

	if arg0._eventTriggers then
		for iter0, iter1 in pairs(arg0._eventTriggers) do
			ClearEventTrigger(iter0)
		end

		arg0._eventTriggers = nil
	end
end

return var0
