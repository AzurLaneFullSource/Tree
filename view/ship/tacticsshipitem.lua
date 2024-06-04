local var0 = class("TacticsShipItem", import(".DockyardShipItem"))

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0.isLoaded = false

	if IsNil(arg2) then
		local var0 = function(arg0)
			arg0.name = "ShipCardTpl"

			setParent(arg0, arg1)

			arg0.transform.localScale = Vector3(1.28, 1.28, 1)
			arg0.transform.localPosition = Vector3(0, 251, 0)

			var0.super.Ctor(arg0, arg0, arg3, arg4)

			arg0.isLoaded = true

			if arg0.cacheShipVO then
				arg0:update(arg0.cacheShipVO)
			end
		end

		ResourceMgr.Inst:getAssetAsync("template/shipcardtpl", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			local var0 = Instantiate(arg0)

			var0(var0)
		end), true, true)
	else
		var0.super.Ctor(arg0, arg2, arg3, arg4)

		arg0.isLoaded = true
	end
end

function var0.update(arg0, arg1)
	if not arg0.isLoaded then
		arg0.cacheShipVO = arg1
	else
		var0.super.update(arg0, arg1)
	end
end

function var0.UpdateExpBuff(arg0)
	return
end

return var0
