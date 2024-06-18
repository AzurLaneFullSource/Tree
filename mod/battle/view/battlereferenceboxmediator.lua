ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleEvent
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = var0_0.Battle.BattleConfig
local var4_0 = class("BattleReferenceBoxMediator", var0_0.MVC.Mediator)

var0_0.Battle.BattleReferenceBoxMediator = var4_0
var4_0.__name = "BattleReferenceBoxMediator"

function var4_0.Ctor(arg0_1)
	var4_0.super.Ctor(arg0_1)
end

function var4_0.Initialize(arg0_2)
	var4_0.super.Initialize(arg0_2)

	arg0_2._dataProxy = arg0_2._state:GetProxyByName(var0_0.Battle.BattleDataProxy.__name)
	arg0_2._sceneMediator = arg0_2._state:GetSceneMediator()
	arg0_2._boxContainer = GameObject("BoxContainer")
	arg0_2._detailContainer = arg0_2._state:GetUI():findGO("CharacterDetailContainer")
	arg0_2._unitBoxList = {}
	arg0_2._bulletBoxList = {}
	arg0_2._wallBoxList = {}
	arg0_2._detailViewList = {}
	arg0_2._unitBoxActive = false
	arg0_2._bulletBoxActive = false
	arg0_2._detailViewActive = false

	arg0_2:initUnitEvent()
end

function var4_0.ActiveUnitBoxes(arg0_3, arg1_3)
	if arg1_3 and not arg0_3._unitBoxActive then
		arg0_3._unitBoxActive = true

		arg0_3:createExistBoxes()
	elseif not arg1_3 and arg0_3._unitBoxActive then
		arg0_3._unitBoxActive = false

		arg0_3:removeAllBoxes()
	end
end

function var4_0.ActiveBulletBoxes(arg0_4, arg1_4)
	if arg1_4 and not arg0_4._bulletBoxActive then
		arg0_4:initBulletEvent()

		arg0_4._bulletBoxActive = true
	elseif not arg1_4 and arg0_4._bulletBoxActive then
		arg0_4:disInitBulletEvent()
		arg0_4:removeAllBulletBoxes()

		arg0_4._bulletBoxActive = false
	end
end

function var4_0.ActiveUnitDetail(arg0_5, arg1_5)
	SetActive(arg0_5._detailContainer, arg1_5)

	if arg1_5 and not arg0_5._detailViewActive then
		for iter0_5, iter1_5 in ipairs(arg0_5._dataProxy:GetFleetList()) do
			local var0_5 = iter1_5:GetUnitList()

			for iter2_5, iter3_5 in ipairs(var0_5) do
				arg0_5:createDetail(iter3_5)
			end
		end

		for iter4_5, iter5_5 in pairs(arg0_5._dataProxy:GetUnitList()) do
			if table.contains(var0_0.Battle.BattleUnitDetailView.EnemyMarkList, iter5_5:GetTemplate().id) then
				arg0_5:createDetail(unit)
			end
		end

		arg0_5._detailViewActive = true
	elseif not arg1_5 and arg0_5._detailViewActive then
		arg0_5._detailViewActive = false

		arg0_5:removeAllDetail()
	end
end

function var4_0.Update(arg0_6)
	for iter0_6, iter1_6 in pairs(arg0_6._dataProxy:GetUnitList()) do
		local var0_6 = arg0_6._unitBoxList[iter0_6]

		if var0_6 then
			var0_6.transform.localPosition = iter1_6:GetPosition()
		end
	end

	if arg0_6._bulletBoxActive then
		for iter2_6, iter3_6 in pairs(arg0_6._dataProxy:GetBulletList()) do
			local var1_6 = arg0_6._bulletBoxList[iter2_6] or arg0_6:createBulletBox(iter3_6)

			var1_6.transform.localPosition = iter3_6:GetPosition()
			var1_6.transform.localEulerAngles = Vector3(0, -iter3_6:GetYAngle(), 0)

			local var2_6 = iter3_6:GetBoxSize() * 2

			var1_6.transform.localScale = Vector3(var2_6.x, var2_6.y, var2_6.z)
		end

		for iter4_6, iter5_6 in pairs(arg0_6._dataProxy:GetWallList()) do
			(arg0_6._wallBoxList[iter4_6] or arg0_6:createWallBox(iter5_6)).transform.localPosition = iter5_6:GetPosition()
		end
	end

	if arg0_6._detailViewActive then
		for iter6_6, iter7_6 in pairs(arg0_6._detailViewList) do
			iter7_6:Update()
		end
	end
end

function var4_0.initUnitEvent(arg0_7)
	arg0_7._dataProxy:RegisterEventListener(arg0_7, var1_0.ADD_UNIT, arg0_7.onAddUnit)
	arg0_7._dataProxy:RegisterEventListener(arg0_7, var1_0.REMOVE_UNIT, arg0_7.onRemoveUnit)
end

function var4_0.disInitUnitEvent(arg0_8)
	arg0_8._dataProxy:UnregisterEventListener(arg0_8, var1_0.ADD_UNIT)
	arg0_8._dataProxy:UnregisterEventListener(arg0_8, var1_0.REMOVE_UNIT)
end

function var4_0.onAddUnit(arg0_9, arg1_9)
	local var0_9 = arg1_9.Data.type
	local var1_9 = arg1_9.Data.unit

	if arg0_9._unitBoxActive then
		local var2_9 = arg0_9:createBox(var1_9)

		arg0_9._unitBoxList[var1_9:GetUniqueID()] = var2_9
	end

	if arg0_9._detailViewActive then
		if var0_9 == var2_0.UnitType.PLAYER_UNIT then
			arg0_9:createDetail(var1_9)
		elseif table.contains(var0_0.Battle.BattleUnitDetailView.EnemyMarkList, var1_9:GetTemplate().id) then
			arg0_9:createDetail(var1_9)
		end
	end
end

function var4_0.createBox(arg0_10, arg1_10)
	local var0_10
	local var1_10
	local var2_10
	local var3_10 = arg1_10:GetIFF() == 1 and "_friendly" or "_foe"
	local var4_10 = arg1_10:GetBoxSize()

	if var4_10.range then
		var0_10 = arg0_10._sceneMediator:InstantiateCharacterComponent("Cylinder" .. var3_10)
	else
		var0_10 = arg0_10._sceneMediator:InstantiateCharacterComponent("Cube" .. var3_10)
		var4_10 = var4_10 * 2
	end

	var0_10.transform:SetParent(arg0_10._boxContainer.transform)

	var0_10.layer = LayerMask.NameToLayer("Default")

	if var4_10.range then
		var0_10.transform.localScale = Vector3(var4_10.range * 2, var4_10.tickness * 2, var4_10.range * 2)
	else
		var0_10.transform.localScale = Vector3(var4_10.x, var4_10.y, var4_10.z)
	end

	SetActive(var0_10, true)

	return var0_10
end

function var4_0.createExistBoxes(arg0_11)
	for iter0_11, iter1_11 in pairs(arg0_11._dataProxy:GetUnitList()) do
		arg0_11._unitBoxList[iter0_11] = arg0_11:createBox(iter1_11)
	end
end

function var4_0.createDetail(arg0_12, arg1_12)
	local var0_12 = var0_0.Battle.BattleUnitDetailView.New()
	local var1_12 = arg1_12:GetIFF()
	local var2_12 = arg0_12._state:GetUI():findTF("CharacterDetailContainer/" .. arg1_12:GetIFF())
	local var3_12 = arg0_12._sceneMediator:InstantiateCharacterComponent("CharacterDetailContainer/detailPanel")

	var3_12.transform:SetParent(var2_12, true)
	var0_12:ConfigSkin(var3_12)
	var0_12:SetUnit(arg1_12)

	arg0_12._detailViewList[arg1_12:GetUniqueID()] = var0_12

	return var0_12
end

function var4_0.onRemoveUnit(arg0_13, arg1_13)
	local var0_13 = arg1_13.Data.type

	if arg0_13._unitBoxActive then
		arg0_13:removeBox(arg1_13.Data.UID)
	end

	if arg0_13._detailViewActive and (var0_13 ~= var2_0.UnitType.PLAYER_UNIT or var0_13 ~= var2_0.UnitType.ENEMY_UNIT or var0_13 ~= var2_0.UnitType.BOSS_UNIT) and arg0_13._detailViewList[arg1_13.Data.UID] then
		arg0_13:removeDetail(arg1_13.Data.UID)
	end
end

function var4_0.removeBox(arg0_14, arg1_14)
	GameObject.Destroy(arg0_14._unitBoxList[arg1_14])

	arg0_14._unitBoxList[arg1_14] = nil
end

function var4_0.removeDetail(arg0_15, arg1_15)
	arg0_15._detailViewList[arg1_15]:Dispose()

	arg0_15._detailViewList[arg1_15] = nil
end

function var4_0.removeAllBoxes(arg0_16)
	for iter0_16, iter1_16 in pairs(arg0_16._dataProxy:GetUnitList()) do
		arg0_16:removeBox(iter0_16)
	end
end

function var4_0.removeAllDetail(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17._detailViewList) do
		arg0_17:removeDetail(iter0_17)
	end
end

function var4_0.initBulletEvent(arg0_18)
	arg0_18._dataProxy:RegisterEventListener(arg0_18, var1_0.REMOVE_BULLET, arg0_18.onRemoveBullet)
end

function var4_0.disInitBulletEvent(arg0_19)
	arg0_19._dataProxy:UnregisterEventListener(arg0_19, var1_0.REMOVE_BULLET)
end

function var4_0.onRemoveBullet(arg0_20, arg1_20)
	arg0_20:removeBulletBox(arg1_20.Data.UID)
end

function var4_0.removeBulletBox(arg0_21, arg1_21)
	GameObject.Destroy(arg0_21._bulletBoxList[arg1_21])

	arg0_21._bulletBoxList[arg1_21] = nil
end

function var4_0.removeAllBulletBoxes(arg0_22)
	for iter0_22, iter1_22 in pairs(arg0_22._bulletBoxList) do
		arg0_22:removeBulletBox(iter0_22)
	end
end

function var4_0.createBulletBox(arg0_23, arg1_23)
	local var0_23

	if arg1_23:GetIFF() == 1 then
		var0_23 = arg0_23._sceneMediator:InstantiateCharacterComponent("Cube_friendly")
	else
		var0_23 = arg0_23._sceneMediator:InstantiateCharacterComponent("Cube_foe")
	end

	var0_23.transform:SetParent(arg0_23._boxContainer.transform)

	var0_23.layer = LayerMask.NameToLayer("Default")

	local var1_23 = arg1_23:GetBoxSize() * 2

	var0_23.transform.localScale = Vector3(var1_23.x, var1_23.y, var1_23.z)

	SetActive(var0_23, true)

	arg0_23._bulletBoxList[arg1_23:GetUniqueID()] = var0_23

	return var0_23
end

function var4_0.createWallBox(arg0_24, arg1_24)
	local var0_24 = arg0_24:createBox(arg1_24)

	arg0_24._wallBoxList[arg1_24:GetUniqueID()] = var0_24

	return var0_24
end

function var4_0.Dispose(arg0_25)
	arg0_25:disInitUnitEvent()

	for iter0_25, iter1_25 in pairs(arg0_25._unitBoxList) do
		GameObject.Destroy(iter1_25)
	end

	for iter2_25, iter3_25 in pairs(arg0_25._bulletBoxList) do
		GameObject.Destroy(iter3_25)
	end

	for iter4_25, iter5_25 in pairs(arg0_25._wallBoxList) do
		GameObject.Destroy(iter5_25)
	end

	arg0_25._unitBoxList = nil
	arg0_25._wallBoxList = nil
	arg0_25._bulletBoxList = nil

	arg0_25:removeAllDetail()

	arg0_25._detailViewList = nil

	GameObject.Destroy(arg0_25._boxContainer)
	var4_0.super.Dispose(arg0_25)
end
