local var0 = class("WSMapArtifact", import("...BaseEntity"))

var0.Fields = {
	transform = "userdata",
	prefab = "string",
	theme = "table",
	attachment = "table",
	moduleTF = "userdata",
	item_info = "table"
}

function var0.Build(arg0)
	arg0.transform = GetOrAddComponent(GameObject.New(), "RectTransform")
	arg0.transform.name = "model"
end

function var0.Dispose(arg0)
	arg0:Unload()
	Destroy(arg0.transform)
	arg0:Clear()
end

function var0.Setup(arg0, arg1, arg2, arg3)
	assert(not arg0.item_info)

	arg0.item_info = arg1
	arg0.theme = arg2
	arg0.attachment = arg3

	arg0:Load()
end

function var0.Load(arg0)
	local var0 = arg0.item_info[3]

	arg0.prefab = var0

	local var1 = PoolMgr.GetInstance()

	var1:GetPrefab(WorldConst.ResChapterPrefab .. var0, var0, true, function(arg0)
		if arg0.prefab then
			arg0.moduleTF = tf(arg0)

			arg0.moduleTF:SetParent(arg0.transform, false)
			arg0:Init()
		else
			var1:ReturnPrefab(WorldConst.ResChapterPrefab .. var0, var0, arg0)
		end
	end)
end

function var0.Unload(arg0)
	if arg0.prefab and arg0.moduleTF then
		PoolMgr.GetInstance():ReturnPrefab(WorldConst.ResChapterPrefab .. arg0.prefab, arg0.prefab, arg0.moduleTF.gameObject, true)
	end

	arg0.prefab = nil
	arg0.moduleTF = nil
end

function var0.Init(arg0)
	local var0 = arg0.moduleTF:GetComponent(typeof(UnityEngine.UI.Graphic))

	if not IsNil(var0) then
		var0.raycastTarget = false
	end

	local var1 = arg0.moduleTF:GetComponentsInChildren(typeof(UnityEngine.UI.Graphic), true)

	for iter0 = 0, var1.Length - 1 do
		var1[iter0].raycastTarget = false
	end

	local var2 = Vector2.zero
	local var3 = Vector3.one
	local var4 = Vector3.zero

	if arg0.attachment then
		var2 = arg0.attachment:GetDeviation()
		var3 = arg0.attachment:GetScale()
		var4 = arg0.attachment:GetMillor() and Vector3(0, 180, 0) or Vector3.zero
	else
		var2 = Vector2(arg0.item_info[4], arg0.item_info[5])
	end

	arg0.transform.anchoredPosition = var2
	arg0.transform.localScale = var3
	arg0.transform.localEulerAngles = var4
end

return var0
