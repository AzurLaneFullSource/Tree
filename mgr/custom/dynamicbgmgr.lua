pg = pg or {}
pg.DynamicBgMgr = singletonClass("DynamicBgMgr")

local var0_0 = pg.DynamicBgMgr

function var0_0.Ctor(arg0_1)
	arg0_1.cache = {}
end

function var0_0.LoadBg(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2, arg5_2, arg6_2)
	local var0_2 = "bg/star_level_bg_" .. arg2_2
	local var1_2 = "ui/star_level_bg_" .. arg2_2
	local var2_2 = arg1_2:getUIName()

	arg0_2:ClearBg(var2_2)

	if checkABExist(var1_2) then
		PoolMgr.GetInstance():GetPrefab(var1_2, "", true, function(arg0_3)
			if arg1_2.exited then
				PoolMgr.GetInstance():ReturnPrefab(var1_2, "", arg0_3, true)

				return
			end

			setActive(arg4_2, false)
			setParent(arg0_3, arg3_2, false)

			local var0_3 = arg0_3:GetComponent(typeof(CriManaEffectUI))

			if var0_3 then
				var0_3.renderMode = CriWare.CriManaMovieMaterialBase.RenderMode.Always

				var0_3:Pause(false)
			end

			arg0_2.cache[var2_2] = {
				path = var1_2,
				dyBg = arg0_3
			}

			existCall(arg5_2, arg0_3)
		end, 1)
	else
		PoolMgr.GetInstance():GetSprite(var0_2, "", true, function(arg0_4)
			if arg1_2.exited then
				PoolMgr.GetInstance():DecreasSprite(var0_2, "")

				return
			end

			setActive(arg4_2, true)
			setImageSprite(arg4_2, arg0_4)

			arg0_2.cache[var2_2] = {
				path = var0_2,
				staticBgTf = arg4_2,
				sp = arg0_4
			}

			existCall(arg6_2, arg0_4)
		end)
	end
end

function var0_0.ClearBg(arg0_5, arg1_5)
	if not arg0_5.cache[arg1_5] then
		return
	end

	local var0_5 = arg0_5.cache[arg1_5]

	if var0_5.dyBg then
		local var1_5 = var0_5.dyBg:GetComponent(typeof(CriManaEffectUI))

		if var1_5 then
			var1_5:Pause(true)
		end

		PoolMgr.GetInstance():ReturnPrefab(var0_5.path, "", var0_5.dyBg, true)
	elseif var0_5.staticBgTf then
		PoolMgr.GetInstance():DecreasSprite(var0_5.path, "")
	else
		assert(false)
	end

	arg0_5.cache[arg1_5] = nil
end
