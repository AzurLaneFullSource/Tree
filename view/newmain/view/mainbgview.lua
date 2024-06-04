local var0 = class("MainBGView", import("..base.MainBaseView"))
local var1 = {
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
local var2 = 0

function var0.GetBgAndBgm()
	local var0 = var1
	local var1 = getProxy(ActivityProxy):RawGetActivityById(pg.gameset.dayandnight_bgm.key_value)

	if var1 and not var1:isEnd() then
		var0 = pg.gameset.dayandnight_bgm.description
	end

	local var2 = pg.TimeMgr.GetInstance():GetServerHour()

	for iter0, iter1 in ipairs(var0) do
		local var3 = iter1[1]

		if var2 >= var3[1] and var2 < var3[2] then
			return iter1[2], iter1[3]
		end
	end
end

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1, nil)

	arg0._tf = arg1
	arg0._go = arg1.gameObject
	arg0.paintingCanvases = {
		arg1.parent.parent:Find("paintBg"):GetComponent(typeof(Canvas)),
		arg1.parent.parent:Find("paint"):GetComponent(typeof(Canvas))
	}
	arg0.isSpecialBg = false
	arg0.isloading = false
end

function var0.getUIName(arg0)
	return "MainBGView"
end

function var0.Init(arg0, arg1)
	arg0.ship = arg1

	arg0:ClearSpecailBg()

	local var0 = arg1:getShipBgPrint()

	arg0.isSpecialBg = var0 ~= arg1:rarity2bgPrintForGet()

	local var1, var2 = MainPaintingView.GetAssistantStatus(arg1)

	if arg0.isSpecialBg and var2 then
		arg0:SetSpecailBg(var0)
		arg0:ClearMapBg()
		arg0:ClearCommonBg()
	elseif var2 and var2 ~= 0 then
		local var3 = pg.expedition_data_by_map[var2]

		assert(var3, "expedition_data_by_map >>> " .. var2)

		local var4 = var3.bg .. "_" .. var3.ani_name

		if arg0.mapLoaderKey ~= var4 then
			arg0:ClearMapBg()

			arg0.mapLoaderKey = var4

			arg0:SetMapBg(var3.bg, var3.ani_name)
		end

		arg0:ClearCommonBg()
	else
		local var5 = var0.GetBgAndBgm()

		if arg0.commonBg == var5 then
			return
		end

		arg0:SetCommonBg(var5)
		arg0:ClearMapBg()

		arg0.commonBg = var5
	end
end

function var0.ClearCommonBg(arg0)
	arg0.commonBg = nil
end

function var0.Refresh(arg0, arg1)
	arg0:Init(arg1)
end

function var0.SetSpecailBg(arg0, arg1)
	arg0.isloading = true

	pg.DynamicBgMgr.GetInstance():LoadBg(arg0, arg1, arg0._tf.parent, arg0._tf, function(arg0)
		arg0.isloading = false
		arg0.transform.localPosition = Vector3(0, 0, 200)
	end, function()
		arg0.isloading = false
	end)
end

function var0.SetMapBg(arg0, arg1, arg2)
	arg0.isloading = true
	arg0.effectGo = nil

	parallelAsync({
		function(arg0)
			PoolMgr.GetInstance():GetSprite("levelmap/" .. arg1, "", true, function(arg0)
				setImageSprite(arg0._tf, arg0)
				arg0()
			end)
		end,
		function(arg0)
			if not arg2 or arg2 == "" then
				arg0()

				return
			end

			PoolMgr.GetInstance():GetPrefab("ui/" .. arg2, "", true, function(arg0)
				setParent(arg0, arg0._tf)
				arg0:AdjustMapEffect(arg0)

				arg0.effectGo = arg0

				arg0()
			end)
		end
	}, function()
		arg0.isloading = false
	end)
end

function var0.ClearMapBg(arg0)
	if not IsNil(arg0.effectGo) then
		Object.Destroy(arg0.effectGo)

		arg0.effectGo = nil
	end

	for iter0, iter1 in ipairs(arg0.paintingCanvases) do
		iter1.overrideSorting = false
		iter1.sortingOrder = 0
	end

	arg0.mapLoaderKey = nil
end

function var0.AdjustMapEffect(arg0, arg1)
	local var0 = -math.huge
	local var1 = arg1:GetComponentsInChildren(typeof(Canvas))

	for iter0 = 1, var1.Length do
		local var2 = var1[iter0 - 1]

		if var0 < var2.sortingOrder then
			var0 = var2.sortingOrder
		end
	end

	local var3 = arg1:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))

	for iter1 = 1, var3.Length do
		local var4 = var3[iter1 - 1]
		local var5 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var4)

		if var0 < var5 then
			var0 = var5
		end
	end

	for iter2, iter3 in ipairs(arg0.paintingCanvases) do
		iter3.overrideSorting = true
		iter3.sortingOrder = var0 + (iter2 == 3 and 2 or 1)
	end
end

function var0.SetCommonBg(arg0, arg1)
	setActive(arg0._tf, true)

	local var0 = LoadSprite("commonbg/" .. arg1, "")

	setImageSprite(arg0._tf, var0)
end

function var0.ClearSpecailBg(arg0)
	if arg0.isSpecialBg then
		pg.DynamicBgMgr.GetInstance():ClearBg(arg0:getUIName())

		arg0.isSpecialBg = false
	end
end

function var0.IsLoading(arg0)
	return arg0.isloading
end

function var0.Disable(arg0)
	arg0:ClearSpecailBg()
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)
	arg0:ClearSpecailBg()
	arg0:ClearMapBg()
end

return var0
