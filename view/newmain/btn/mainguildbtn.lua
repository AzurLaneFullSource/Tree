local var0 = class("MainGuildBtn", import(".MainBaseBtn"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.guildLock = arg1:Find("lock")
	arg0.guildImage = arg1:GetComponent(typeof(Image))
end

function var0.OnClick(arg0)
	if getProxy(GuildProxy):getRawData() then
		arg0:emit(NewMainMediator.GO_SCENE, SCENE.GUILD)
	else
		arg0:emit(NewMainMediator.GO_SCENE, SCENE.NEWGUILD)
	end
end

function var0.Flush(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getRawData()
	local var1 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0.level, "NewGuildMediator")

	if not arg0.isOpenGuild or arg0.isOpenGuild ~= var1 then
		setActive(arg0.guildLock, not var1)

		local var2 = var1 and Color(1, 1, 1, 1) or Color(0.3, 0.3, 0.3, 1)

		arg0.guildImage.color = var2
		arg0.isOpenGuild = var1
	end
end

return var0
