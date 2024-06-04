local var0 = class("ArchivesWorldbossBtn")

function var0.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)

	arg0._tf = arg1
	arg0.img = arg0._tf:GetComponent(typeof(Image))
	arg0.event = arg2
	arg0.iconText = arg0._tf:Find("Text"):GetComponent(typeof(Text))
	arg0.tip = arg0._tf:Find("tip")

	onButton(arg0, arg0._tf, function()
		arg0.event:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_ARCHIVES_LIST)
	end, SFX_PANEL)
end

function var0.Flush(arg0)
	if WorldBossConst.GetAchieveState() == WorldBossConst.ACHIEVE_STATE_STARTING then
		local var0 = WorldBossConst.GetArchivesId()
		local var1 = WorldBossConst.BossId2MetaId(var0)
		local var2 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(var1)
		local var3 = var2.metaPtData:GetResProgress()

		arg0.iconText.text = var3 .. "/" .. var2.metaPtData:GetTotalResRequire()
		arg0.img.sprite = GetSpriteFromAtlas("MetaWorldboss/" .. var1, "btn")
	else
		arg0.iconText.text = ""
		arg0.img.sprite = LoadSprite("MetaWorldboss/extra_btn")
	end

	setActive(arg0.tip, WorldBossConst.AnyArchivesBossCanGetAward())
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
end

return var0
