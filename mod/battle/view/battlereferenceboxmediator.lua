ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleEvent
local var2 = var0.Battle.BattleConst
local var3 = var0.Battle.BattleConfig
local var4 = class("BattleReferenceBoxMediator", var0.MVC.Mediator)

var0.Battle.BattleReferenceBoxMediator = var4
var4.__name = "BattleReferenceBoxMediator"

function var4.Ctor(arg0)
	var4.super.Ctor(arg0)
end

function var4.Initialize(arg0)
	var4.super.Initialize(arg0)

	arg0._dataProxy = arg0._state:GetProxyByName(var0.Battle.BattleDataProxy.__name)
	arg0._sceneMediator = arg0._state:GetSceneMediator()
	arg0._boxContainer = GameObject("BoxContainer")
	arg0._detailContainer = arg0._state:GetUI():findGO("CharacterDetailContainer")
	arg0._unitBoxList = {}
	arg0._bulletBoxList = {}
	arg0._wallBoxList = {}
	arg0._detailViewList = {}
	arg0._unitBoxActive = false
	arg0._bulletBoxActive = false
	arg0._detailViewActive = false

	arg0:initUnitEvent()
end

function var4.ActiveUnitBoxes(arg0, arg1)
	if arg1 and not arg0._unitBoxActive then
		arg0._unitBoxActive = true

		arg0:createExistBoxes()
	elseif not arg1 and arg0._unitBoxActive then
		arg0._unitBoxActive = false

		arg0:removeAllBoxes()
	end
end

function var4.ActiveBulletBoxes(arg0, arg1)
	if arg1 and not arg0._bulletBoxActive then
		arg0:initBulletEvent()

		arg0._bulletBoxActive = true
	elseif not arg1 and arg0._bulletBoxActive then
		arg0:disInitBulletEvent()
		arg0:removeAllBulletBoxes()

		arg0._bulletBoxActive = false
	end
end

function var4.ActiveUnitDetail(arg0, arg1)
	SetActive(arg0._detailContainer, arg1)

	if arg1 and not arg0._detailViewActive then
		for iter0, iter1 in ipairs(arg0._dataProxy:GetFleetList()) do
			local var0 = iter1:GetUnitList()

			for iter2, iter3 in ipairs(var0) do
				arg0:createDetail(iter3)
			end
		end

		for iter4, iter5 in pairs(arg0._dataProxy:GetUnitList()) do
			if table.contains(var0.Battle.BattleUnitDetailView.EnemyMarkList, iter5:GetTemplate().id) then
				arg0:createDetail(unit)
			end
		end

		arg0._detailViewActive = true
	elseif not arg1 and arg0._detailViewActive then
		arg0._detailViewActive = false

		arg0:removeAllDetail()
	end
end

function var4.Update(arg0)
	for iter0, iter1 in pairs(arg0._dataProxy:GetUnitList()) do
		local var0 = arg0._unitBoxList[iter0]

		if var0 then
			var0.transform.localPosition = iter1:GetPosition()
		end
	end

	if arg0._bulletBoxActive then
		for iter2, iter3 in pairs(arg0._dataProxy:GetBulletList()) do
			local var1 = arg0._bulletBoxList[iter2] or arg0:createBulletBox(iter3)

			var1.transform.localPosition = iter3:GetPosition()
			var1.transform.localEulerAngles = Vector3(0, -iter3:GetYAngle(), 0)

			local var2 = iter3:GetBoxSize() * 2

			var1.transform.localScale = Vector3(var2.x, var2.y, var2.z)
		end

		for iter4, iter5 in pairs(arg0._dataProxy:GetWallList()) do
			(arg0._wallBoxList[iter4] or arg0:createWallBox(iter5)).transform.localPosition = iter5:GetPosition()
		end
	end

	if arg0._detailViewActive then
		for iter6, iter7 in pairs(arg0._detailViewList) do
			iter7:Update()
		end
	end
end

function var4.initUnitEvent(arg0)
	arg0._dataProxy:RegisterEventListener(arg0, var1.ADD_UNIT, arg0.onAddUnit)
	arg0._dataProxy:RegisterEventListener(arg0, var1.REMOVE_UNIT, arg0.onRemoveUnit)
end

function var4.disInitUnitEvent(arg0)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.ADD_UNIT)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.REMOVE_UNIT)
end

function var4.onAddUnit(arg0, arg1)
	local var0 = arg1.Data.type
	local var1 = arg1.Data.unit

	if arg0._unitBoxActive then
		local var2 = arg0:createBox(var1)

		arg0._unitBoxList[var1:GetUniqueID()] = var2
	end

	if arg0._detailViewActive then
		if var0 == var2.UnitType.PLAYER_UNIT then
			arg0:createDetail(var1)
		elseif table.contains(var0.Battle.BattleUnitDetailView.EnemyMarkList, var1:GetTemplate().id) then
			arg0:createDetail(var1)
		end
	end
end

function var4.createBox(arg0, arg1)
	local var0
	local var1
	local var2
	local var3 = arg1:GetIFF() == 1 and "_friendly" or "_foe"
	local var4 = arg1:GetBoxSize()

	if var4.range then
		var0 = arg0._sceneMediator:InstantiateCharacterComponent("Cylinder" .. var3)
	else
		var0 = arg0._sceneMediator:InstantiateCharacterComponent("Cube" .. var3)
		var4 = var4 * 2
	end

	var0.transform:SetParent(arg0._boxContainer.transform)

	var0.layer = LayerMask.NameToLayer("Default")

	if var4.range then
		var0.transform.localScale = Vector3(var4.range * 2, var4.tickness * 2, var4.range * 2)
	else
		var0.transform.localScale = Vector3(var4.x, var4.y, var4.z)
	end

	SetActive(var0, true)

	return var0
end

function var4.createExistBoxes(arg0)
	for iter0, iter1 in pairs(arg0._dataProxy:GetUnitList()) do
		arg0._unitBoxList[iter0] = arg0:createBox(iter1)
	end
end

function var4.createDetail(arg0, arg1)
	local var0 = var0.Battle.BattleUnitDetailView.New()
	local var1 = arg1:GetIFF()
	local var2 = arg0._state:GetUI():findTF("CharacterDetailContainer/" .. arg1:GetIFF())
	local var3 = arg0._sceneMediator:InstantiateCharacterComponent("CharacterDetailContainer/detailPanel")

	var3.transform:SetParent(var2, true)
	var0:ConfigSkin(var3)
	var0:SetUnit(arg1)

	arg0._detailViewList[arg1:GetUniqueID()] = var0

	return var0
end

function var4.onRemoveUnit(arg0, arg1)
	local var0 = arg1.Data.type

	if arg0._unitBoxActive then
		arg0:removeBox(arg1.Data.UID)
	end

	if arg0._detailViewActive and (var0 ~= var2.UnitType.PLAYER_UNIT or var0 ~= var2.UnitType.ENEMY_UNIT or var0 ~= var2.UnitType.BOSS_UNIT) and arg0._detailViewList[arg1.Data.UID] then
		arg0:removeDetail(arg1.Data.UID)
	end
end

function var4.removeBox(arg0, arg1)
	GameObject.Destroy(arg0._unitBoxList[arg1])

	arg0._unitBoxList[arg1] = nil
end

function var4.removeDetail(arg0, arg1)
	arg0._detailViewList[arg1]:Dispose()

	arg0._detailViewList[arg1] = nil
end

function var4.removeAllBoxes(arg0)
	for iter0, iter1 in pairs(arg0._dataProxy:GetUnitList()) do
		arg0:removeBox(iter0)
	end
end

function var4.removeAllDetail(arg0)
	for iter0, iter1 in pairs(arg0._detailViewList) do
		arg0:removeDetail(iter0)
	end
end

function var4.initBulletEvent(arg0)
	arg0._dataProxy:RegisterEventListener(arg0, var1.REMOVE_BULLET, arg0.onRemoveBullet)
end

function var4.disInitBulletEvent(arg0)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.REMOVE_BULLET)
end

function var4.onRemoveBullet(arg0, arg1)
	arg0:removeBulletBox(arg1.Data.UID)
end

function var4.removeBulletBox(arg0, arg1)
	GameObject.Destroy(arg0._bulletBoxList[arg1])

	arg0._bulletBoxList[arg1] = nil
end

function var4.removeAllBulletBoxes(arg0)
	for iter0, iter1 in pairs(arg0._bulletBoxList) do
		arg0:removeBulletBox(iter0)
	end
end

function var4.createBulletBox(arg0, arg1)
	local var0

	if arg1:GetIFF() == 1 then
		var0 = arg0._sceneMediator:InstantiateCharacterComponent("Cube_friendly")
	else
		var0 = arg0._sceneMediator:InstantiateCharacterComponent("Cube_foe")
	end

	var0.transform:SetParent(arg0._boxContainer.transform)

	var0.layer = LayerMask.NameToLayer("Default")

	local var1 = arg1:GetBoxSize() * 2

	var0.transform.localScale = Vector3(var1.x, var1.y, var1.z)

	SetActive(var0, true)

	arg0._bulletBoxList[arg1:GetUniqueID()] = var0

	return var0
end

function var4.createWallBox(arg0, arg1)
	local var0 = arg0:createBox(arg1)

	arg0._wallBoxList[arg1:GetUniqueID()] = var0

	return var0
end

function var4.Dispose(arg0)
	arg0:disInitUnitEvent()

	for iter0, iter1 in pairs(arg0._unitBoxList) do
		GameObject.Destroy(iter1)
	end

	for iter2, iter3 in pairs(arg0._bulletBoxList) do
		GameObject.Destroy(iter3)
	end

	for iter4, iter5 in pairs(arg0._wallBoxList) do
		GameObject.Destroy(iter5)
	end

	arg0._unitBoxList = nil
	arg0._wallBoxList = nil
	arg0._bulletBoxList = nil

	arg0:removeAllDetail()

	arg0._detailViewList = nil

	GameObject.Destroy(arg0._boxContainer)
	var4.super.Dispose(arg0)
end
