local var0_0 = class("CourtYardBaseView")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.name = arg1_1
	arg0_1.storey = arg2_1

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.isInit = false

	local var0_2 = arg0_2:GetStoreyModule()
	local var1_2

	seriesAsync({
		function(arg0_3)
			arg0_2:LoadUI(var0_2.__cname, function(arg0_4)
				var1_2 = arg0_4

				arg0_3()
			end)
		end,
		function(arg0_5)
			arg0_2:InitObjPool(arg0_5)
		end
	}, function()
		arg0_2.storeyModule = var0_2.New(arg0_2.storey, var1_2)
		arg0_2.isInit = true
	end)
end

function var0_0.IsInit(arg0_7)
	return arg0_7.isInit == true
end

function var0_0.LoadUI(arg0_8, arg1_8, arg2_8)
	arg0_8.resName = arg1_8

	ResourceMgr.Inst:getAssetAsync("UI/" .. arg0_8.resName, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_9)
		local var0_9

		if arg0_8.storey:GetStyle() == CourtYardConst.STYLE_PREVIEW then
			var0_9 = pg.UIMgr.GetInstance().OverlayMain:Find("BackYardInterActionPreview(Clone)/frame/view")
		else
			var0_9 = pg.UIMgr.GetInstance().UIMain:Find(arg0_8.name .. "(Clone)")
		end

		local var1_9 = Object.Instantiate(arg0_9, var0_9)

		arg0_8._go = var1_9

		var1_9.transform:SetSiblingIndex(1)
		setActive(var1_9, true)

		arg0_8.poolRoot = var1_9.transform:Find("root")

		arg2_8(var1_9)
	end), true, true)
end

function var0_0.GetRect(arg0_10)
	assert(arg0_10.storeyModule)

	return arg0_10.storeyModule.rectTF
end

function var0_0.GetStoreyModule(arg0_11)
	local var0_11 = arg0_11.storey

	return ({
		[CourtYardConst.STYLE_INNER] = CourtYardStoreyModule,
		[CourtYardConst.STYLE_OUTSIDE] = CourtYardOutStoreyModule,
		[CourtYardConst.STYLE_FEAST] = CourtYardFeastStoreyModule,
		[CourtYardConst.STYLE_PREVIEW] = CourtYardStoreyPreviewModule
	})[var0_11:GetStyle()]
end

function var0_0.InitObjPool(arg0_12, arg1_12)
	local var0_12 = arg0_12.storey
	local var1_12 = ({
		[CourtYardConst.STYLE_INNER] = CourtYardPoolMgr,
		[CourtYardConst.STYLE_OUTSIDE] = CourtYardPoolMgr,
		[CourtYardConst.STYLE_FEAST] = CourtYardFeastPoolMgr,
		[CourtYardConst.STYLE_PREVIEW] = CourtYardPoolMgr
	})[var0_12:GetStyle()].New()

	var1_12:Init(arg0_12.poolRoot, arg1_12)

	arg0_12.poolMgr = var1_12
end

function var0_0.GetCurrStorey(arg0_13)
	return arg0_13.storeyModule
end

function var0_0.Dispose(arg0_14)
	if arg0_14.storeyModule then
		arg0_14.storeyModule:Dispose()

		arg0_14.storeyModule = nil
	end

	arg0_14.storey = nil

	arg0_14.poolMgr:Dispose()

	arg0_14.poolMgr = nil
end

return var0_0
