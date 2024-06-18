local var0_0 = class("CourtYardShipFactory")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.poolMgr = arg1_1
end

function var0_0.Make(arg0_2, arg1_2)
	local var0_2 = arg0_2.poolMgr:GetShipPool():Dequeue()
	local var1_2 = SpineRole.New(arg1_2)
	local var2_2

	if arg1_2:GetShipType() == CourtYardConst.SHIP_TYPE_OTHER then
		var2_2 = CourtYardOtherPlayerShipModule.New(arg1_2, var0_2, var1_2)
	else
		var2_2 = ({
			CourtYardShipModule,
			CourtYardVisitorShipModule,
			CourtYardFeastShipModule
		})[arg1_2:GetShipType()].New(arg1_2, var0_2, var1_2)
	end

	local var3_2 = arg1_2:GetPrefab()

	seriesAsync({
		function(arg0_3)
			var1_2:Load(arg0_3, true)
		end,
		function(arg0_4)
			arg0_2:MakeAttachments(var0_2, arg1_2, arg0_4)
		end
	}, function()
		if IsNil(var0_2) then
			return
		end

		local var0_5 = var1_2.modelRoot

		var0_5.name = "model"
		var0_5.transform.localScale = Vector3.one
		rtf(var0_5).sizeDelta = Vector2.New(200, 500)

		SetParent(var0_5, var0_2)
		var0_5.transform:SetSiblingIndex(2)
		setActive(var0_2, true)
		var2_2:OnIconLoaed()
		var2_2:Init()
	end)

	return var2_2
end

function var0_0.MakeAttachments(arg0_6, arg1_6, arg2_6, arg3_6)
	if arg2_6:GetShipType() == CourtYardConst.SHIP_TYPE_FEAST then
		ResourceMgr.Inst:getAssetAsync("ui/CourtYardFeastAttachments", "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_7)
			if arg0_6.exited then
				return
			end

			Object.Instantiate(arg0_7, arg1_6.transform).name = "feastAttachments"

			arg3_6()
		end), true, true)
	else
		arg3_6()
	end
end

function var0_0.Dispose(arg0_8)
	arg0_8.exited = true
end

return var0_0
