local var0_0 = class("MainBGView", import("..base.MainBaseView"))
local var1_0 = {
	{
		{
			0,
			5
		},
		"bg_main_night"
	},
	{
		{
			5,
			8
		},
		"bg_main_twilight"
	},
	{
		{
			8,
			16
		},
		"bg_main_day"
	},
	{
		{
			16,
			19
		},
		"bg_main_twilight"
	},
	{
		{
			19,
			24
		},
		"bg_main_night"
	}
}
local var2_0 = 0

function var0_0.GetBgAndBgm()
	local var0_1 = var1_0
	local var1_1 = getProxy(ActivityProxy):RawGetActivityById(pg.gameset.dayandnight_bgm.key_value)

	if var1_1 and not var1_1:isEnd() then
		var0_1 = pg.gameset.dayandnight_bgm.description
	end

	local var2_1 = pg.TimeMgr.GetInstance():GetServerHour()

	for iter0_1, iter1_1 in ipairs(var0_1) do
		local var3_1 = iter1_1[1]

		if var2_1 >= var3_1[1] and var2_1 < var3_1[2] then
			return iter1_1[2], iter1_1[3]
		end
	end
end

function var0_0.Ctor(arg0_2, arg1_2)
	var0_0.super.Ctor(arg0_2, arg1_2, nil)

	arg0_2._tf = arg1_2
	arg0_2._go = arg1_2.gameObject
	arg0_2.paintingCanvases = {
		arg1_2.parent.parent:Find("paintBg"):GetComponent(typeof(Canvas)),
		arg1_2.parent.parent:Find("paint"):GetComponent(typeof(Canvas))
	}
	arg0_2.isSpecialBg = false
	arg0_2.isloading = false
end

function var0_0.getUIName(arg0_3)
	return "MainBGView"
end

function var0_0.Init(arg0_4, arg1_4)
	arg0_4.ship = arg1_4

	arg0_4:ClearSpecailBg()

	local var0_4 = arg1_4:getShipBgPrint()

	arg0_4.isSpecialBg = var0_4 ~= arg1_4:rarity2bgPrintForGet()

	local var1_4, var2_4 = MainPaintingView.GetAssistantStatus(arg1_4)

	if arg0_4.isSpecialBg and var2_4 then
		arg0_4:SetSpecailBg(var0_4)
		arg0_4:ClearMapBg()
		arg0_4:ClearCommonBg()
	elseif var2_0 and var2_0 ~= 0 then
		local var3_4 = pg.expedition_data_by_map[var2_0]

		assert(var3_4, "expedition_data_by_map >>> " .. var2_0)

		local var4_4 = var3_4.bg .. "_" .. var3_4.ani_name

		if arg0_4.mapLoaderKey ~= var4_4 then
			arg0_4:ClearMapBg()

			arg0_4.mapLoaderKey = var4_4

			arg0_4:SetMapBg(var3_4.bg, var3_4.ani_name)
		end

		arg0_4:ClearCommonBg()
	else
		local var5_4 = var0_0.GetBgAndBgm()

		if arg0_4.commonBg == var5_4 then
			return
		end

		arg0_4:SetCommonBg(var5_4)
		arg0_4:ClearMapBg()

		arg0_4.commonBg = var5_4
	end
end

function var0_0.ClearCommonBg(arg0_5)
	arg0_5.commonBg = nil
end

function var0_0.Refresh(arg0_6, arg1_6)
	arg0_6:Init(arg1_6)
end

function var0_0.SetSpecailBg(arg0_7, arg1_7)
	arg0_7.isloading = true

	pg.DynamicBgMgr.GetInstance():LoadBg(arg0_7, arg1_7, arg0_7._tf.parent, arg0_7._tf, function(arg0_8)
		arg0_7.isloading = false
		arg0_8.transform.localPosition = Vector3(0, 0, 200)
	end, function()
		arg0_7.isloading = false
	end)
end

function var0_0.SetMapBg(arg0_10, arg1_10, arg2_10)
	arg0_10.isloading = true
	arg0_10.effectGo = nil

	parallelAsync({
		function(arg0_11)
			PoolMgr.GetInstance():GetSprite("levelmap/" .. arg1_10, "", true, function(arg0_12)
				setImageSprite(arg0_10._tf, arg0_12)
				arg0_11()
			end)
		end,
		function(arg0_13)
			if not arg2_10 or arg2_10 == "" then
				arg0_13()

				return
			end

			PoolMgr.GetInstance():GetPrefab("ui/" .. arg2_10, "", true, function(arg0_14)
				setParent(arg0_14, arg0_10._tf)
				arg0_10:AdjustMapEffect(arg0_14)

				arg0_10.effectGo = arg0_14

				arg0_13()
			end)
		end
	}, function()
		arg0_10.isloading = false
	end)
end

function var0_0.ClearMapBg(arg0_16)
	if not IsNil(arg0_16.effectGo) then
		Object.Destroy(arg0_16.effectGo)

		arg0_16.effectGo = nil
	end

	for iter0_16, iter1_16 in ipairs(arg0_16.paintingCanvases) do
		iter1_16.overrideSorting = false
		iter1_16.sortingOrder = 0
	end

	arg0_16.mapLoaderKey = nil
end

function var0_0.AdjustMapEffect(arg0_17, arg1_17)
	local var0_17 = -math.huge
	local var1_17 = arg1_17:GetComponentsInChildren(typeof(Canvas))

	for iter0_17 = 1, var1_17.Length do
		local var2_17 = var1_17[iter0_17 - 1]

		if var0_17 < var2_17.sortingOrder then
			var0_17 = var2_17.sortingOrder
		end
	end

	local var3_17 = arg1_17:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))

	for iter1_17 = 1, var3_17.Length do
		local var4_17 = var3_17[iter1_17 - 1]
		local var5_17 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var4_17)

		if var0_17 < var5_17 then
			var0_17 = var5_17
		end
	end

	for iter2_17, iter3_17 in ipairs(arg0_17.paintingCanvases) do
		iter3_17.overrideSorting = true
		iter3_17.sortingOrder = var0_17 + (iter2_17 == 3 and 2 or 1)
	end
end

function var0_0.SetCommonBg(arg0_18, arg1_18)
	setActive(arg0_18._tf, true)

	local var0_18 = LoadSprite("commonbg/" .. arg1_18, "")

	setImageSprite(arg0_18._tf, var0_18)
end

function var0_0.ClearSpecailBg(arg0_19)
	if arg0_19.isSpecialBg then
		pg.DynamicBgMgr.GetInstance():ClearBg(arg0_19:getUIName())

		arg0_19.isSpecialBg = false
	end
end

function var0_0.IsLoading(arg0_20)
	return arg0_20.isloading
end

function var0_0.Disable(arg0_21)
	arg0_21:ClearSpecailBg()
end

function var0_0.Dispose(arg0_22)
	var0_0.super.Dispose(arg0_22)
	arg0_22:ClearSpecailBg()
	arg0_22:ClearMapBg()
end

return var0_0
