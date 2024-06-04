local var0 = class("MetaWorldbossBtn")

function var0.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)

	arg0.event = arg2
	arg0.metaBtn = arg1
	arg0.metaProgress = arg1:Find("Text"):GetComponent(typeof(Text))
	arg0.metaTip = arg1:Find("tip")

	arg0:Init()
end

function var0.Init(arg0)
	onButton(arg0, arg0.metaBtn, function()
		local var0 = WorldBossConst.GetCurrBossGroup()

		arg0.event:emit(WorldBossMediator.GO_META, var0)
	end, SFX_PANEL)
	arg0:Update()
end

function var0.Update(arg0)
	local var0 = WorldBossConst.GetCurrBossGroup()

	setActive(arg0.metaTip, MetaCharacterConst.isMetaSynRedTag(var0))
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
end

return var0
