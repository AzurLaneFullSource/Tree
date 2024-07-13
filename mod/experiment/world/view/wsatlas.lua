local var0_0 = class("WSAtlas", import("...BaseEntity"))

var0_0.Fields = {
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
var0_0.Listeners = {
	onUpdateActiveEntrance = "OnUpdateActiveEntrance",
	onUpdatePressingAward = "OnUpdatePressingAward",
	onUpdateProgress = "OnUpdateProgress"
}
var0_0.spriteBaseSize = Vector2(2048, 1347)

function var0_0.Setup(arg0_1)
	pg.DelegateInfo.New(arg0_1)
	arg0_1:Init()
end

function var0_0.Dispose(arg0_2)
	pg.DelegateInfo.Dispose(arg0_2)
	arg0_2:RemoveAtlasListener()
	arg0_2:UpdateStaticMark()
	arg0_2:ActiveSelect(arg0_2.selectEntrance, false)

	if arg0_2.tfActiveMark then
		arg0_2:DestroyActiveMark()
	end

	eachChild(arg0_2.tfMapScene:Find("lock_layer"), function(arg0_3)
		arg0_2:RemoveExtraMarkPrefab(arg0_3)
	end)
	arg0_2:ReturnScene()
	arg0_2:Clear()
end

function var0_0.Init(arg0_4)
	arg0_4.staticEntranceDic = {}
end

function var0_0.UpdateAtlas(arg0_5, arg1_5)
	if arg0_5.atlas ~= arg1_5 then
		arg0_5:RemoveAtlasListener()

		arg0_5.atlas = arg1_5

		arg0_5:AddAtlasListener()
		arg0_5:UpdateModelMask()
		arg0_5:OnUpdateActiveEntrance(nil, nil, arg0_5.atlas:GetActiveEntrance())
		arg0_5:OnUpdatePressingAward()
	end
end

function var0_0.AddAtlasListener(arg0_6)
	if arg0_6.atlas then
		arg0_6.atlas:AddListener(WorldAtlas.EventUpdateProgress, arg0_6.onUpdateProgress)
		arg0_6.atlas:AddListener(WorldAtlas.EventUpdateActiveEntrance, arg0_6.onUpdateActiveEntrance)
		arg0_6.atlas:AddListener(WorldAtlas.EventAddPressingEntrance, arg0_6.onUpdatePressingAward)
	end
end

function var0_0.RemoveAtlasListener(arg0_7)
	if arg0_7.atlas then
		arg0_7.atlas:RemoveListener(WorldAtlas.EventUpdateProgress, arg0_7.onUpdateProgress)
		arg0_7.atlas:RemoveListener(WorldAtlas.EventUpdateActiveEntrance, arg0_7.onUpdateActiveEntrance)
		arg0_7.atlas:RemoveListener(WorldAtlas.EventAddPressingEntrance, arg0_7.onUpdatePressingAward)
	end
end

function var0_0.LoadScene(arg0_8, arg1_8)
	assert(false, "overwrite by subclass")
end

function var0_0.ReturnScene(arg0_9)
	assert(false, "overwrite by subclass")
end

function var0_0.ShowOrHide(arg0_10, arg1_10)
	setActive(arg0_10.transform, arg1_10)
end

function var0_0.GetMapScreenPos(arg0_11, arg1_11)
	return arg0_11.cmPointer:GetMapScreenPos(arg1_11)
end

function var0_0.UpdateSelect(arg0_12, arg1_12)
	arg0_12:ActiveSelect(arg0_12.selectEntrance, false)
	arg0_12:ActiveSelect(arg1_12, true)
end

function var0_0.ActiveSelect(arg0_13, arg1_13, arg2_13)
	arg0_13.selectEntrance = arg2_13 and arg1_13 or nil

	if not arg1_13 or arg0_13.staticEntranceDic[arg1_13.id] then
		return
	end

	if arg1_13:HasPort() then
		-- block empty
	else
		setActive(arg0_13.tfMapSelect:Find("A" .. arg1_13:GetColormaskUniqueID() .. "_2"), arg2_13)
	end
end

function var0_0.ActiveStatic(arg0_14, arg1_14, arg2_14)
	arg0_14.staticEntranceDic[arg1_14.id] = arg2_14

	if arg1_14 == arg0_14.selectEntrance then
		return
	end

	if arg1_14:HasPort() then
		-- block empty
	else
		local var0_14 = arg0_14.tfMapSelect:Find("A" .. arg1_14:GetColormaskUniqueID() .. "_2")

		LeanTween.cancel(go(var0_14))

		local var1_14 = var0_14:GetComponent("SpriteRenderer").color

		var1_14.a = arg2_14 and 0 or 1
		var0_14:GetComponent("SpriteRenderer").color = var1_14

		if arg2_14 then
			setActive(var0_14, true)
			LeanTween.alpha(go(var0_14), 0.75, 1):setFrom(0):setLoopPingPong()
		else
			setActive(var0_14, arg0_14.selectEntrance == arg1_14)
		end
	end
end

var0_0.pressingMaskColor = Color.New(0.0274509803921569, 0.274509803921569, 0.549019607843137, 0.501960784313725)
var0_0.openMaskColor = Color.New(0, 0, 0, 0)
var0_0.lockMaskColor = Color.New(0, 0, 0, 0.4)

function var0_0.UpdateModelMask(arg0_15)
	for iter0_15, iter1_15 in pairs(arg0_15.atlas.entranceDic) do
		arg0_15:UpdateEntranceMask(iter1_15)
	end
end

function var0_0.UpdateEntranceMask(arg0_16, arg1_16)
	if arg1_16:HasPort() then
		-- block empty
	else
		local var0_16 = arg0_16.tfMapScene:Find("lock_layer/A" .. arg1_16:GetColormaskUniqueID()):GetComponent("SpriteRenderer")

		if arg1_16:IsPressing() then
			var0_16.color = var0_0.pressingMaskColor
			var0_16.material = arg0_16.addSprite
		elseif arg0_16.atlas.transportDic[arg1_16.id] and arg1_16:IsOpen() then
			var0_16.color = var0_0.openMaskColor
			var0_16.material = arg0_16.defaultSprite
		else
			var0_16.color = var0_0.lockMaskColor
			var0_16.material = arg0_16.defaultSprite
		end
	end
end

function var0_0.SetSairenMarkActive(arg0_17, arg1_17, arg2_17)
	arg0_17:DoUpdatExtraMark(arg1_17, "dsj_srgr", arg2_17, function(arg0_18)
		if arg2_17 then
			arg0_18:GetComponent("SpriteRenderer").sprite = arg1_17:GetComponent("SpriteRenderer").sprite
		end
	end)
end

function var0_0.OnUpdateProgress(arg0_19, arg1_19, arg2_19, arg3_19)
	for iter0_19 in pairs(arg3_19) do
		local var0_19 = arg0_19.atlas:GetEntrance(iter0_19)

		arg0_19:UpdateEntranceMask(var0_19)
	end

	arg0_19:UpdateCenterEffectDisplay()
end

function var0_0.BuildActiveMark(arg0_20)
	arg0_20.tfActiveMark = tf(GameObject.New())
	arg0_20.tfActiveMark.gameObject.layer = Layer.UI
	arg0_20.tfActiveMark.name = "active_mark"

	arg0_20.tfActiveMark:SetParent(arg0_20.tfSpriteScene, false)
	setActive(arg0_20.tfActiveMark, false)
end

function var0_0.DestroyActiveMark(arg0_21)
	arg0_21:RemoveExtraMarkPrefab(arg0_21.tfActiveMark)
	Destroy(arg0_21.tfActiveMark)
end

function var0_0.LoadExtraMarkPrefab(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = PoolMgr.GetInstance()

	var0_22:GetPrefab("world/mark/" .. arg2_22, arg2_22, true, function(arg0_23)
		if IsNil(arg1_22) then
			var0_22:ReturnPrefab("world/mark/" .. arg2_22, arg2_22, arg0_23, true)
		else
			arg0_23.name = arg2_22

			tf(arg0_23):SetParent(arg1_22, false)
			setActive(arg0_23, true)
			existCall(arg3_22, tf(arg0_23))
		end
	end)
end

function var0_0.RemoveExtraMarkPrefab(arg0_24, arg1_24)
	local var0_24 = PoolMgr.GetInstance()

	eachChild(arg1_24, function(arg0_25)
		var0_24:ReturnPrefab("world/mark/" .. arg0_25.name, arg0_25.name, go(arg0_25), true)
	end)
end

function var0_0.DoUpdatExtraMark(arg0_26, arg1_26, arg2_26, arg3_26, arg4_26)
	local var0_26 = arg1_26:Find(arg2_26)

	if var0_26 then
		setActive(var0_26, arg3_26)
		existCall(arg4_26, var0_26)
	elseif arg3_26 then
		arg0_26:LoadExtraMarkPrefab(arg1_26, arg2_26, arg4_26)
	end
end

function var0_0.OnUpdateActiveEntrance(arg0_27, arg1_27, arg2_27, arg3_27)
	if arg3_27 then
		arg0_27.tfActiveMark.localPosition = WorldConst.CalcModelPosition(arg3_27, arg0_27.spriteBaseSize)
	end

	setActive(arg0_27.tfActiveMark, arg3_27)
end

function var0_0.UpdateStaticMark(arg0_28, arg1_28)
	for iter0_28, iter1_28 in pairs(arg0_28.staticEntranceDic) do
		arg0_28:ActiveStatic(arg0_28.atlas:GetEntrance(iter0_28), false)
	end

	for iter2_28, iter3_28 in pairs(arg1_28 or {}) do
		if iter3_28 then
			arg0_28:ActiveStatic(arg0_28.atlas:GetEntrance(iter2_28), true)
		end
	end
end

function var0_0.OnUpdatePressingAward(arg0_29, arg1_29, arg2_29, arg3_29)
	arg3_29 = arg3_29 or arg0_29.atlas.transportDic

	for iter0_29, iter1_29 in pairs(arg3_29) do
		if iter1_29 then
			arg0_29:UpdateEntranceMask(arg0_29.atlas:GetEntrance(iter0_29))
		end
	end
end

function var0_0.UpdateCenterEffectDisplay(arg0_30)
	local var0_30 = nowWorld():CheckAreaUnlock(5)

	setActive(arg0_30.tfEntity:Find("decolation_layer/DSJ_xuanwo"), not var0_30)
	setActive(arg0_30.tfEntity:Find("decolation_layer/DSJ_xuanwo_jianhua"), var0_30)
end

return var0_0
