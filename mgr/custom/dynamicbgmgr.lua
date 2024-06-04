pg = pg or {}
pg.DynamicBgMgr = singletonClass("DynamicBgMgr")

local var0 = pg.DynamicBgMgr

function var0.Ctor(arg0)
	arg0.cache = {}
end

function var0.LoadBg(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local var0 = "bg/star_level_bg_" .. arg2
	local var1 = "ui/star_level_bg_" .. arg2

	if checkABExist(var1) then
		arg0:ClearBg(arg1:getUIName())
		PoolMgr.GetInstance():GetPrefab(var1, "", true, function(arg0)
			if not arg1.exited then
				setParent(arg0, arg3, false)

				local var0 = arg0:GetComponent(typeof(CriManaEffectUI))

				if var0 then
					var0.renderMode = ReflectionHelp.RefGetField(typeof("CriManaMovieMaterial+RenderMode"), "Always", nil)

					var0:Pause(false)
				end

				setActive(arg4, false)

				if arg5 ~= nil then
					arg5(arg0)
				end

				arg0:InsertCache(arg1:getUIName(), arg2, arg0)
			else
				PoolMgr.GetInstance():DestroyPrefab(var1, "")
			end
		end, 1)
	else
		arg0:ClearBg(arg1:getUIName())
		GetSpriteFromAtlasAsync(var0, "", function(arg0)
			if not arg1.exited then
				setImageSprite(arg4, arg0)
				setActive(arg4, true)

				if arg6 ~= nil then
					arg6(arg0)
				end
			else
				PoolMgr.GetInstance():DestroySprite(var0)
			end
		end)
	end
end

function var0.ClearBg(arg0, arg1)
	for iter0 = #arg0.cache, 1, -1 do
		local var0 = arg0.cache[iter0]

		if var0.uiName == arg1 then
			local var1 = "ui/star_level_bg_" .. var0.bgName
			local var2 = var0.dyBg

			if IsNil(var2) then
				table.remove(arg0.cache, iter0)

				return
			end

			local var3 = var2:GetComponent(typeof(CriManaEffectUI))

			if var3 then
				var3:Pause(true)
			end

			PoolMgr.GetInstance():ReturnPrefab(var1, "", var2)

			if #arg0.cache > 1 then
				PoolMgr.GetInstance():DestroyPrefab(var1, "")
			end

			table.remove(arg0.cache, iter0)
		end
	end
end

function var0.InsertCache(arg0, arg1, arg2, arg3)
	for iter0, iter1 in ipairs(arg0.cache) do
		if iter1.uiName == arg1 and iter1.bgName == arg2 then
			iter1.dyBg = arg3

			return
		end
	end

	table.insert(arg0.cache, {
		uiName = arg1,
		bgName = arg2,
		dyBg = arg3
	})
end
