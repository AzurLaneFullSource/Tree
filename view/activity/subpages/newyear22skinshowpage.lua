local var0_0 = class("NewYear22SkinShowPage", import("...base.BaseActivityPage"))
local var1_0 = {
	{
		id = 403101,
		name = "Y22_adaerbote"
	},
	{
		id = 499061,
		name = "Y22_aogusite"
	},
	{
		id = 399051,
		name = "Y22_bailong"
	},
	{
		id = 405011,
		name = "Y22_bisimai"
	},
	{
		id = 108021,
		name = "Y22_daqinghuayu"
	},
	{
		id = 205091,
		name = "Y22_hao"
	},
	{
		id = 402041,
		name = "Y22_laibixi"
	},
	{
		id = 302211,
		name = "Y22_lei"
	},
	{
		id = 402061,
		name = "Y22_magedebao"
	},
	{
		id = 699011,
		name = "Y22_makeboluo"
	},
	{
		id = 202071,
		name = "Y22_nananpudun"
	},
	{
		id = 303141,
		name = "Y22_niaohai"
	},
	{
		id = 202291,
		name = "Y22_peineiluopo"
	},
	{
		id = 408021,
		name = "Y22_U47"
	},
	{
		id = 408121,
		name = "Y22_U1206"
	},
	{
		id = 405031,
		name = "Y22_wuerlixi"
	},
	{
		id = 401461,
		name = "Y22_Z46"
	},
	{
		id = 406021,
		name = "Y22_yibei"
	},
	{
		id = 201331,
		name = "Y22_yikaluosi"
	},
	{
		id = 205011,
		name = "Y22_yilishabai"
	}
}

function var0_0.OnInit(arg0_1)
	arg0_1:findUI()
	arg0_1:initData()
end

function var0_0.findUI(arg0_2)
	arg0_2.paintBackTF = arg0_2:findTF("Paints/PaintBack")
	arg0_2.paintFrontTF = arg0_2:findTF("Paints/PaintFront")
	arg0_2.skinShopBtn = arg0_2:findTF("BtnShop")
	arg0_2.goBtn = arg0_2:findTF("BtnGO")

	onButton(arg0_2, arg0_2.skinShopBtn, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.goBtn, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.NEWYEAR_BACKHILL_2022)
	end, SFX_PANEL)
end

function var0_0.initData(arg0_5)
	arg0_5.paintCount = 20
	arg0_5.curPaintIndex = 1
	arg0_5.paintSwitchTime = 1
	arg0_5.paintStaticTime = 3.5
	arg0_5.paintStaticCountValue = 0
	arg0_5.paintPathPrefix = "NewYear22SkinShowPage/"
end

function var0_0.switchNextPaint(arg0_6)
	arg0_6.frameTimer:Stop()

	local var0_6 = arg0_6.curPaintIndex % arg0_6.paintCount + 1
	local var1_6 = var1_0[var0_6].name
	local var2_6 = arg0_6.paintPathPrefix .. var1_6
	local var3_6 = pg.ship_data_statistics[var1_0[var0_6].id].name

	setImageSprite(arg0_6.paintBackTF, LoadSprite(var2_6, var1_6))
	setText(findTF(arg0_6.paintBackTF, "txt"), var3_6)
	setText(findTF(arg0_6.paintBackTF, "outlineTxt"), var3_6)

	local var4_6 = GetComponent(arg0_6.paintFrontTF, typeof(CanvasGroup))
	local var5_6 = GetComponent(arg0_6.paintBackTF, typeof(CanvasGroup))

	LeanTween.value(go(arg0_6.paintFrontTF), 1, 0, arg0_6.paintSwitchTime):setOnUpdate(System.Action_float(function(arg0_7)
		var4_6.alpha = arg0_7
		var5_6.alpha = 1 - arg0_7
	end)):setOnComplete(System.Action(function()
		setImageFromImage(arg0_6.paintFrontTF, arg0_6.paintBackTF)

		var4_6.alpha = 1
		var5_6.alpha = 0

		setText(findTF(arg0_6.paintFrontTF, "txt"), var3_6)
		setText(findTF(arg0_6.paintFrontTF, "outlineTxt"), var3_6)

		arg0_6.curPaintIndex = var0_6

		arg0_6.frameTimer:Start()
	end))
end

function var0_0.OnFirstFlush(arg0_9)
	arg0_9:initPaint()
	arg0_9:initTimer()
end

function var0_0.initPaint(arg0_10)
	local var0_10 = arg0_10.curPaintIndex
	local var1_10 = (var0_10 - 1) % arg0_10.paintCount + 1
	local var2_10 = pg.ship_data_statistics[var1_0[var1_10].id].name
	local var3_10 = var1_0[var0_10].name
	local var4_10 = arg0_10.paintPathPrefix .. var3_10

	setImageSprite(arg0_10.paintFrontTF, LoadSprite(var4_10, var3_10))
	setText(findTF(arg0_10.paintFrontTF, "txt"), var2_10)
	setText(findTF(arg0_10.paintFrontTF, "outlineTxt"), var2_10)

	local var5_10 = pg.ship_data_statistics[var1_0[var1_10].id].name
	local var6_10 = var1_0[var1_10].name
	local var7_10 = arg0_10.paintPathPrefix .. var6_10

	setImageSprite(arg0_10.paintBackTF, LoadSprite(var7_10, var6_10))
	setText(findTF(arg0_10.paintBackTF, "txt"), var5_10)
	setText(findTF(arg0_10.paintBackTF, "outlineTxt"), var5_10)
end

function var0_0.initTimer(arg0_11)
	local var0_11 = 0.0166666666666667

	arg0_11.paintStaticCountValue = 0
	arg0_11.frameTimer = Timer.New(function()
		arg0_11.paintStaticCountValue = arg0_11.paintStaticCountValue + var0_11

		if arg0_11.paintStaticCountValue >= arg0_11.paintStaticTime then
			arg0_11.paintStaticCountValue = 0

			arg0_11:switchNextPaint()
		end
	end, var0_11, -1, false)

	arg0_11.frameTimer:Start()
end

function var0_0.OnDestroy(arg0_13)
	if arg0_13.frameTimer then
		arg0_13.frameTimer:Stop()

		arg0_13.frameTimer = nil
	end
end

return var0_0
