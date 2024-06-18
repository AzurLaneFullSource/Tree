local var0_0 = class("TacticsShipItem", import(".DockyardShipItem"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.isLoaded = false

	if IsNil(arg2_1) then
		local function var0_1(arg0_2)
			arg0_2.name = "ShipCardTpl"

			setParent(arg0_2, arg1_1)

			arg0_2.transform.localScale = Vector3(1.28, 1.28, 1)
			arg0_2.transform.localPosition = Vector3(0, 251, 0)

			var0_0.super.Ctor(arg0_1, arg0_2, arg3_1, arg4_1)

			arg0_1.isLoaded = true

			if arg0_1.cacheShipVO then
				arg0_1:update(arg0_1.cacheShipVO)
			end
		end

		ResourceMgr.Inst:getAssetAsync("template/shipcardtpl", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_3)
			local var0_3 = Instantiate(arg0_3)

			var0_1(var0_3)
		end), true, true)
	else
		var0_0.super.Ctor(arg0_1, arg2_1, arg3_1, arg4_1)

		arg0_1.isLoaded = true
	end
end

function var0_0.update(arg0_4, arg1_4)
	if not arg0_4.isLoaded then
		arg0_4.cacheShipVO = arg1_4
	else
		var0_0.super.update(arg0_4, arg1_4)
	end
end

function var0_0.UpdateExpBuff(arg0_5)
	return
end

return var0_0
