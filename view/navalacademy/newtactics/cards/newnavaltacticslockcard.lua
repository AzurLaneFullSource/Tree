local var0 = class("NewNavalTacticsLockCard", import(".NewNavalTacticsBaseCard"))

function var0.UnlockCnt2ShopId(arg0, arg1)
	return ({
		21,
		22
	})[arg1 - 1]
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		local var0 = getProxy(NavalAcademyProxy):getSkillClassNum()
		local var1 = arg0:UnlockCnt2ShopId(var0)

		arg0:emit(NewNavalTacticsLayer.ON_UNLOCK, var1)
	end, SFX_PANEL)
end

return var0
