pg = pg or {}
pg.GuildPaintingMgr = singletonClass("GuildPaintingMgr")

local var0 = pg.GuildPaintingMgr

function var0.Enter(arg0, arg1)
	arg0._tf = arg1
end

function var0.Update(arg0, arg1, arg2, arg3)
	arg0.isShipPainting = arg3

	arg0:Show()

	if arg0.name == arg1 then
		return
	end

	arg0:Clear()

	if arg0.isShipPainting then
		setPaintingPrefabAsync(arg0._tf, arg1, "chuanwu")
	else
		setGuildPaintingPrefabAsync(arg0._tf, arg1, "chuanwu")
	end

	arg0.name = arg1

	if arg2 then
		arg0._tf.localPosition = arg2
	end
end

function var0.Show(arg0)
	if not IsNil(arg0._tf) then
		setActive(arg0._tf, true)
	end
end

function var0.Hide(arg0)
	if not IsNil(arg0._tf) then
		setActive(arg0._tf, false)
	end
end

function var0.Clear(arg0)
	if arg0.name then
		if arg0.isShipPainting then
			retPaintingPrefab(arg0._tf, arg0.name)
		else
			retGuildPaintingPrefab(arg0._tf, arg0.name)
		end

		arg0.name = nil
	end
end

function var0.Exit(arg0)
	arg0:Clear()
end
