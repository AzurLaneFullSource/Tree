pg = pg or {}
pg.GuildPaintingMgr = singletonClass("GuildPaintingMgr")

local var0_0 = pg.GuildPaintingMgr

function var0_0.Enter(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.isShipPainting = arg3_2

	arg0_2:Show()

	if arg0_2.name == arg1_2 then
		return
	end

	arg0_2:Clear()

	if arg0_2.isShipPainting then
		setPaintingPrefabAsync(arg0_2._tf, arg1_2, "chuanwu")
	else
		setGuildPaintingPrefabAsync(arg0_2._tf, arg1_2, "chuanwu")
	end

	arg0_2.name = arg1_2

	if arg2_2 then
		arg0_2._tf.localPosition = arg2_2
	end
end

function var0_0.Show(arg0_3)
	if not IsNil(arg0_3._tf) then
		setActive(arg0_3._tf, true)
	end
end

function var0_0.Hide(arg0_4)
	if not IsNil(arg0_4._tf) then
		setActive(arg0_4._tf, false)
	end
end

function var0_0.Clear(arg0_5)
	if arg0_5.name then
		if arg0_5.isShipPainting then
			retPaintingPrefab(arg0_5._tf, arg0_5.name)
		else
			retGuildPaintingPrefab(arg0_5._tf, arg0_5.name)
		end

		arg0_5.name = nil
	end
end

function var0_0.Exit(arg0_6)
	arg0_6:Clear()
end
