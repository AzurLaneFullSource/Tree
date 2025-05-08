local var0_0 = class("IslandStaticUnit", import(".IslandSceneUnit"))

function var0_0.OnInit(arg0_1)
	return
end

function var0_0.OnUpdate(arg0_2)
	return
end

function var0_0.OnDispose(arg0_3)
	return
end

function var0_0.DoPlant(arg0_4)
	if arg0_4.otherGo then
		return
	end

	local var0_4 = "island/unit_item/infrastructure/farm/pre_art_farm_potato01_grow"

	ResourceMgr.Inst:getAssetAsync(var0_4, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_5)
		arg0_4.otherGo = Object.Instantiate(arg0_5)
		arg0_4.otherGo.name = arg0_4.name
		arg0_4.otherGo.transform.position = arg0_4.position
		arg0_4.otherGo.transform.eulerAngles = arg0_4.rotation

		setActive(arg0_4.otherGo, true)
	end), true, true)
end

return var0_0
