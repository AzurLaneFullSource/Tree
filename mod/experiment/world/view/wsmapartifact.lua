local var0_0 = class("WSMapArtifact", import("...BaseEntity"))

var0_0.Fields = {
	transform = "userdata",
	prefab = "string",
	theme = "table",
	attachment = "table",
	moduleTF = "userdata",
	item_info = "table"
}

function var0_0.Build(arg0_1)
	arg0_1.transform = GetOrAddComponent(GameObject.New(), "RectTransform")
	arg0_1.transform.name = "model"
end

function var0_0.Dispose(arg0_2)
	arg0_2:Unload()
	Destroy(arg0_2.transform)
	arg0_2:Clear()
end

function var0_0.Setup(arg0_3, arg1_3, arg2_3, arg3_3)
	assert(not arg0_3.item_info)

	arg0_3.item_info = arg1_3
	arg0_3.theme = arg2_3
	arg0_3.attachment = arg3_3

	arg0_3:Load()
end

function var0_0.Load(arg0_4)
	local var0_4 = arg0_4.item_info[3]

	arg0_4.prefab = var0_4

	local var1_4 = PoolMgr.GetInstance()

	var1_4:GetPrefab(WorldConst.ResChapterPrefab .. var0_4, var0_4, true, function(arg0_5)
		if arg0_4.prefab then
			arg0_4.moduleTF = tf(arg0_5)

			arg0_4.moduleTF:SetParent(arg0_4.transform, false)
			arg0_4:Init()
		else
			var1_4:ReturnPrefab(WorldConst.ResChapterPrefab .. var0_4, var0_4, arg0_5)
		end
	end)
end

function var0_0.Unload(arg0_6)
	if arg0_6.prefab and arg0_6.moduleTF then
		PoolMgr.GetInstance():ReturnPrefab(WorldConst.ResChapterPrefab .. arg0_6.prefab, arg0_6.prefab, arg0_6.moduleTF.gameObject, true)
	end

	arg0_6.prefab = nil
	arg0_6.moduleTF = nil
end

function var0_0.Init(arg0_7)
	local var0_7 = arg0_7.moduleTF:GetComponent(typeof(UnityEngine.UI.Graphic))

	if not IsNil(var0_7) then
		var0_7.raycastTarget = false
	end

	local var1_7 = arg0_7.moduleTF:GetComponentsInChildren(typeof(UnityEngine.UI.Graphic), true)

	for iter0_7 = 0, var1_7.Length - 1 do
		var1_7[iter0_7].raycastTarget = false
	end

	local var2_7 = Vector2.zero
	local var3_7 = Vector3.one
	local var4_7 = Vector3.zero

	if arg0_7.attachment then
		var2_7 = arg0_7.attachment:GetDeviation()
		var3_7 = arg0_7.attachment:GetScale()
		var4_7 = arg0_7.attachment:GetMillor() and Vector3(0, 180, 0) or Vector3.zero
	else
		var2_7 = Vector2(arg0_7.item_info[4], arg0_7.item_info[5])
	end

	arg0_7.transform.anchoredPosition = var2_7
	arg0_7.transform.localScale = var3_7
	arg0_7.transform.localEulerAngles = var4_7
end

return var0_0
