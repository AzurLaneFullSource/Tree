local var0 = class("CourtYardShipFactory")

function var0.Ctor(arg0, arg1)
	arg0.poolMgr = arg1
end

function var0.Make(arg0, arg1)
	local var0 = arg0.poolMgr:GetShipPool():Dequeue()
	local var1 = SpineRole.New(arg1)
	local var2

	if arg1:GetShipType() == CourtYardConst.SHIP_TYPE_OTHER then
		var2 = CourtYardOtherPlayerShipModule.New(arg1, var0, var1)
	else
		var2 = ({
			CourtYardShipModule,
			CourtYardVisitorShipModule,
			CourtYardFeastShipModule
		})[arg1:GetShipType()].New(arg1, var0, var1)
	end

	local var3 = arg1:GetPrefab()

	seriesAsync({
		function(arg0)
			var1:Load(arg0, true)
		end,
		function(arg0)
			arg0:MakeAttachments(var0, arg1, arg0)
		end
	}, function()
		if IsNil(var0) then
			return
		end

		local var0 = var1.modelRoot

		var0.name = "model"
		var0.transform.localScale = Vector3.one
		rtf(var0).sizeDelta = Vector2.New(200, 500)

		SetParent(var0, var0)
		var0.transform:SetSiblingIndex(2)
		setActive(var0, true)
		var2:OnIconLoaed()
		var2:Init()
	end)

	return var2
end

function var0.MakeAttachments(arg0, arg1, arg2, arg3)
	if arg2:GetShipType() == CourtYardConst.SHIP_TYPE_FEAST then
		ResourceMgr.Inst:getAssetAsync("ui/CourtYardFeastAttachments", "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			if arg0.exited then
				return
			end

			Object.Instantiate(arg0, arg1.transform).name = "feastAttachments"

			arg3()
		end), true, true)
	else
		arg3()
	end
end

function var0.Dispose(arg0)
	arg0.exited = true
end

return var0
