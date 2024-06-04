local var0 = class("WSAtlas", import("...BaseEntity"))

var0.Fields = {
	transform = "userdata",
	atlas = "table",
	tfMapSelect = "userdata",
	tfCamera = "userdata",
	defaultSprite = "userdata",
	tfEntity = "userdata",
	cmPointer = "userdata",
	staticEntranceDic = "table",
	onClickColor = "function",
	tfSpriteScene = "userdata",
	addSprite = "userdata",
	tfMapScene = "userdata",
	tfActiveMark = "userdata",
	selectEntrance = "table"
}
var0.Listeners = {
	onUpdateActiveEntrance = "OnUpdateActiveEntrance",
	onUpdatePressingAward = "OnUpdatePressingAward",
	onUpdateProgress = "OnUpdateProgress"
}
var0.spriteBaseSize = Vector2(2048, 1347)

function var0.Setup(arg0)
	pg.DelegateInfo.New(arg0)
	arg0:Init()
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:RemoveAtlasListener()
	arg0:UpdateStaticMark()
	arg0:ActiveSelect(arg0.selectEntrance, false)

	if arg0.tfActiveMark then
		arg0:DestroyActiveMark()
	end

	eachChild(arg0.tfMapScene:Find("lock_layer"), function(arg0)
		arg0:RemoveExtraMarkPrefab(arg0)
	end)
	arg0:ReturnScene()
	arg0:Clear()
end

function var0.Init(arg0)
	arg0.staticEntranceDic = {}
end

function var0.UpdateAtlas(arg0, arg1)
	if arg0.atlas ~= arg1 then
		arg0:RemoveAtlasListener()

		arg0.atlas = arg1

		arg0:AddAtlasListener()
		arg0:UpdateModelMask()
		arg0:OnUpdateActiveEntrance(nil, nil, arg0.atlas:GetActiveEntrance())
		arg0:OnUpdatePressingAward()
	end
end

function var0.AddAtlasListener(arg0)
	if arg0.atlas then
		arg0.atlas:AddListener(WorldAtlas.EventUpdateProgress, arg0.onUpdateProgress)
		arg0.atlas:AddListener(WorldAtlas.EventUpdateActiveEntrance, arg0.onUpdateActiveEntrance)
		arg0.atlas:AddListener(WorldAtlas.EventAddPressingEntrance, arg0.onUpdatePressingAward)
	end
end

function var0.RemoveAtlasListener(arg0)
	if arg0.atlas then
		arg0.atlas:RemoveListener(WorldAtlas.EventUpdateProgress, arg0.onUpdateProgress)
		arg0.atlas:RemoveListener(WorldAtlas.EventUpdateActiveEntrance, arg0.onUpdateActiveEntrance)
		arg0.atlas:RemoveListener(WorldAtlas.EventAddPressingEntrance, arg0.onUpdatePressingAward)
	end
end

function var0.LoadScene(arg0, arg1)
	assert(false, "overwrite by subclass")
end

function var0.ReturnScene(arg0)
	assert(false, "overwrite by subclass")
end

function var0.ShowOrHide(arg0, arg1)
	setActive(arg0.transform, arg1)
end

function var0.GetMapScreenPos(arg0, arg1)
	return arg0.cmPointer:GetMapScreenPos(arg1)
end

function var0.UpdateSelect(arg0, arg1)
	arg0:ActiveSelect(arg0.selectEntrance, false)
	arg0:ActiveSelect(arg1, true)
end

function var0.ActiveSelect(arg0, arg1, arg2)
	arg0.selectEntrance = arg2 and arg1 or nil

	if not arg1 or arg0.staticEntranceDic[arg1.id] then
		return
	end

	if arg1:HasPort() then
		-- block empty
	else
		setActive(arg0.tfMapSelect:Find("A" .. arg1:GetColormaskUniqueID() .. "_2"), arg2)
	end
end

function var0.ActiveStatic(arg0, arg1, arg2)
	arg0.staticEntranceDic[arg1.id] = arg2

	if arg1 == arg0.selectEntrance then
		return
	end

	if arg1:HasPort() then
		-- block empty
	else
		local var0 = arg0.tfMapSelect:Find("A" .. arg1:GetColormaskUniqueID() .. "_2")

		LeanTween.cancel(go(var0))

		local var1 = var0:GetComponent("SpriteRenderer").color

		var1.a = arg2 and 0 or 1
		var0:GetComponent("SpriteRenderer").color = var1

		if arg2 then
			setActive(var0, true)
			LeanTween.alpha(go(var0), 0.75, 1):setFrom(0):setLoopPingPong()
		else
			setActive(var0, arg0.selectEntrance == arg1)
		end
	end
end

var0.pressingMaskColor = Color.New(0.0274509803921569, 0.274509803921569, 0.549019607843137, 0.501960784313725)
var0.openMaskColor = Color.New(0, 0, 0, 0)
var0.lockMaskColor = Color.New(0, 0, 0, 0.4)

function var0.UpdateModelMask(arg0)
	for iter0, iter1 in pairs(arg0.atlas.entranceDic) do
		arg0:UpdateEntranceMask(iter1)
	end
end

function var0.UpdateEntranceMask(arg0, arg1)
	if arg1:HasPort() then
		-- block empty
	else
		local var0 = arg0.tfMapScene:Find("lock_layer/A" .. arg1:GetColormaskUniqueID()):GetComponent("SpriteRenderer")

		if arg1:IsPressing() then
			var0.color = var0.pressingMaskColor
			var0.material = arg0.addSprite
		elseif arg0.atlas.transportDic[arg1.id] and arg1:IsOpen() then
			var0.color = var0.openMaskColor
			var0.material = arg0.defaultSprite
		else
			var0.color = var0.lockMaskColor
			var0.material = arg0.defaultSprite
		end
	end
end

function var0.SetSairenMarkActive(arg0, arg1, arg2)
	arg0:DoUpdatExtraMark(arg1, "dsj_srgr", arg2, function(arg0)
		if arg2 then
			arg0:GetComponent("SpriteRenderer").sprite = arg1:GetComponent("SpriteRenderer").sprite
		end
	end)
end

function var0.OnUpdateProgress(arg0, arg1, arg2, arg3)
	for iter0 in pairs(arg3) do
		local var0 = arg0.atlas:GetEntrance(iter0)

		arg0:UpdateEntranceMask(var0)
	end

	arg0:UpdateCenterEffectDisplay()
end

function var0.BuildActiveMark(arg0)
	arg0.tfActiveMark = tf(GameObject.New())
	arg0.tfActiveMark.gameObject.layer = Layer.UI
	arg0.tfActiveMark.name = "active_mark"

	arg0.tfActiveMark:SetParent(arg0.tfSpriteScene, false)
	setActive(arg0.tfActiveMark, false)
end

function var0.DestroyActiveMark(arg0)
	arg0:RemoveExtraMarkPrefab(arg0.tfActiveMark)
	Destroy(arg0.tfActiveMark)
end

function var0.LoadExtraMarkPrefab(arg0, arg1, arg2, arg3)
	local var0 = PoolMgr.GetInstance()

	var0:GetPrefab("world/mark/" .. arg2, arg2, true, function(arg0)
		if IsNil(arg1) then
			var0:ReturnPrefab("world/mark/" .. arg2, arg2, arg0, true)
		else
			arg0.name = arg2

			tf(arg0):SetParent(arg1, false)
			setActive(arg0, true)
			existCall(arg3, tf(arg0))
		end
	end)
end

function var0.RemoveExtraMarkPrefab(arg0, arg1)
	local var0 = PoolMgr.GetInstance()

	eachChild(arg1, function(arg0)
		var0:ReturnPrefab("world/mark/" .. arg0.name, arg0.name, go(arg0), true)
	end)
end

function var0.DoUpdatExtraMark(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg1:Find(arg2)

	if var0 then
		setActive(var0, arg3)
		existCall(arg4, var0)
	elseif arg3 then
		arg0:LoadExtraMarkPrefab(arg1, arg2, arg4)
	end
end

function var0.OnUpdateActiveEntrance(arg0, arg1, arg2, arg3)
	if arg3 then
		arg0.tfActiveMark.localPosition = WorldConst.CalcModelPosition(arg3, arg0.spriteBaseSize)
	end

	setActive(arg0.tfActiveMark, arg3)
end

function var0.UpdateStaticMark(arg0, arg1)
	for iter0, iter1 in pairs(arg0.staticEntranceDic) do
		arg0:ActiveStatic(arg0.atlas:GetEntrance(iter0), false)
	end

	for iter2, iter3 in pairs(arg1 or {}) do
		if iter3 then
			arg0:ActiveStatic(arg0.atlas:GetEntrance(iter2), true)
		end
	end
end

function var0.OnUpdatePressingAward(arg0, arg1, arg2, arg3)
	arg3 = arg3 or arg0.atlas.transportDic

	for iter0, iter1 in pairs(arg3) do
		if iter1 then
			arg0:UpdateEntranceMask(arg0.atlas:GetEntrance(iter0))
		end
	end
end

function var0.UpdateCenterEffectDisplay(arg0)
	local var0 = nowWorld():CheckAreaUnlock(5)

	setActive(arg0.tfEntity:Find("decolation_layer/DSJ_xuanwo"), not var0)
	setActive(arg0.tfEntity:Find("decolation_layer/DSJ_xuanwo_jianhua"), var0)
end

return var0
