local var0 = class("NewYear22SkinShowPage", import("...base.BaseActivityPage"))
local var1 = {
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

function var0.OnInit(arg0)
	arg0:findUI()
	arg0:initData()
end

function var0.findUI(arg0)
	arg0.paintBackTF = arg0:findTF("Paints/PaintBack")
	arg0.paintFrontTF = arg0:findTF("Paints/PaintFront")
	arg0.skinShopBtn = arg0:findTF("BtnShop")
	arg0.goBtn = arg0:findTF("BtnGO")

	onButton(arg0, arg0.skinShopBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
	onButton(arg0, arg0.goBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.NEWYEAR_BACKHILL_2022)
	end, SFX_PANEL)
end

function var0.initData(arg0)
	arg0.paintCount = 20
	arg0.curPaintIndex = 1
	arg0.paintSwitchTime = 1
	arg0.paintStaticTime = 3.5
	arg0.paintStaticCountValue = 0
	arg0.paintPathPrefix = "NewYear22SkinShowPage/"
end

function var0.switchNextPaint(arg0)
	arg0.frameTimer:Stop()

	local var0 = arg0.curPaintIndex % arg0.paintCount + 1
	local var1 = var1[var0].name
	local var2 = arg0.paintPathPrefix .. var1
	local var3 = pg.ship_data_statistics[var1[var0].id].name

	setImageSprite(arg0.paintBackTF, LoadSprite(var2, var1))
	setText(findTF(arg0.paintBackTF, "txt"), var3)
	setText(findTF(arg0.paintBackTF, "outlineTxt"), var3)

	local var4 = GetComponent(arg0.paintFrontTF, typeof(CanvasGroup))
	local var5 = GetComponent(arg0.paintBackTF, typeof(CanvasGroup))

	LeanTween.value(go(arg0.paintFrontTF), 1, 0, arg0.paintSwitchTime):setOnUpdate(System.Action_float(function(arg0)
		var4.alpha = arg0
		var5.alpha = 1 - arg0
	end)):setOnComplete(System.Action(function()
		setImageFromImage(arg0.paintFrontTF, arg0.paintBackTF)

		var4.alpha = 1
		var5.alpha = 0

		setText(findTF(arg0.paintFrontTF, "txt"), var3)
		setText(findTF(arg0.paintFrontTF, "outlineTxt"), var3)

		arg0.curPaintIndex = var0

		arg0.frameTimer:Start()
	end))
end

function var0.OnFirstFlush(arg0)
	arg0:initPaint()
	arg0:initTimer()
end

function var0.initPaint(arg0)
	local var0 = arg0.curPaintIndex
	local var1 = (var0 - 1) % arg0.paintCount + 1
	local var2 = pg.ship_data_statistics[var1[var1].id].name
	local var3 = var1[var0].name
	local var4 = arg0.paintPathPrefix .. var3

	setImageSprite(arg0.paintFrontTF, LoadSprite(var4, var3))
	setText(findTF(arg0.paintFrontTF, "txt"), var2)
	setText(findTF(arg0.paintFrontTF, "outlineTxt"), var2)

	local var5 = pg.ship_data_statistics[var1[var1].id].name
	local var6 = var1[var1].name
	local var7 = arg0.paintPathPrefix .. var6

	setImageSprite(arg0.paintBackTF, LoadSprite(var7, var6))
	setText(findTF(arg0.paintBackTF, "txt"), var5)
	setText(findTF(arg0.paintBackTF, "outlineTxt"), var5)
end

function var0.initTimer(arg0)
	local var0 = 0.0166666666666667

	arg0.paintStaticCountValue = 0
	arg0.frameTimer = Timer.New(function()
		arg0.paintStaticCountValue = arg0.paintStaticCountValue + var0

		if arg0.paintStaticCountValue >= arg0.paintStaticTime then
			arg0.paintStaticCountValue = 0

			arg0:switchNextPaint()
		end
	end, var0, -1, false)

	arg0.frameTimer:Start()
end

function var0.OnDestroy(arg0)
	if arg0.frameTimer then
		arg0.frameTimer:Stop()

		arg0.frameTimer = nil
	end
end

return var0
