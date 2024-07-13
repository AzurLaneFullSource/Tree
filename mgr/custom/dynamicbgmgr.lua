pg = pg or {}
pg.DynamicBgMgr = singletonClass("DynamicBgMgr")

local var0_0 = pg.DynamicBgMgr

function var0_0.Ctor(arg0_1)
	arg0_1.cache = {}
end

function var0_0.LoadBg(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2, arg5_2, arg6_2)
	local var0_2 = "bg/star_level_bg_" .. arg2_2
	local var1_2 = "ui/star_level_bg_" .. arg2_2

	if checkABExist(var1_2) then
		arg0_2:ClearBg(arg1_2:getUIName())
		PoolMgr.GetInstance():GetPrefab(var1_2, "", true, function(arg0_3)
			if not arg1_2.exited then
				setParent(arg0_3, arg3_2, false)

				local var0_3 = arg0_3:GetComponent(typeof(CriManaEffectUI))

				if var0_3 then
					var0_3.renderMode = ReflectionHelp.RefGetField(typeof("CriManaMovieMaterial+RenderMode"), "Always", nil)

					var0_3:Pause(false)
				end

				setActive(arg4_2, false)

				if arg5_2 ~= nil then
					arg5_2(arg0_3)
				end

				arg0_2:InsertCache(arg1_2:getUIName(), arg2_2, arg0_3)
			else
				PoolMgr.GetInstance():DestroyPrefab(var1_2, "")
			end
		end, 1)
	else
		arg0_2:ClearBg(arg1_2:getUIName())
		GetSpriteFromAtlasAsync(var0_2, "", function(arg0_4)
			if not arg1_2.exited then
				setImageSprite(arg4_2, arg0_4)
				setActive(arg4_2, true)

				if arg6_2 ~= nil then
					arg6_2(arg0_4)
				end
			else
				PoolMgr.GetInstance():DestroySprite(var0_2)
			end
		end)
	end
end

function var0_0.ClearBg(arg0_5, arg1_5)
	for iter0_5 = #arg0_5.cache, 1, -1 do
		local var0_5 = arg0_5.cache[iter0_5]

		if var0_5.uiName == arg1_5 then
			local var1_5 = "ui/star_level_bg_" .. var0_5.bgName
			local var2_5 = var0_5.dyBg

			if IsNil(var2_5) then
				table.remove(arg0_5.cache, iter0_5)

				return
			end

			local var3_5 = var2_5:GetComponent(typeof(CriManaEffectUI))

			if var3_5 then
				var3_5:Pause(true)
			end

			PoolMgr.GetInstance():ReturnPrefab(var1_5, "", var2_5)

			if #arg0_5.cache > 1 then
				PoolMgr.GetInstance():DestroyPrefab(var1_5, "")
			end

			table.remove(arg0_5.cache, iter0_5)
		end
	end
end

function var0_0.InsertCache(arg0_6, arg1_6, arg2_6, arg3_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.cache) do
		if iter1_6.uiName == arg1_6 and iter1_6.bgName == arg2_6 then
			iter1_6.dyBg = arg3_6

			return
		end
	end

	table.insert(arg0_6.cache, {
		uiName = arg1_6,
		bgName = arg2_6,
		dyBg = arg3_6
	})
end
