local var0 = class("CourtYardBaseView")

function var0.Ctor(arg0, arg1, arg2)
	arg0.name = arg1
	arg0.storey = arg2

	arg0:Init()
end

function var0.Init(arg0)
	arg0.isInit = false

	local var0 = arg0:GetStoreyModule()
	local var1

	seriesAsync({
		function(arg0)
			arg0:LoadUI(var0.__cname, function(arg0)
				var1 = arg0

				arg0()
			end)
		end,
		function(arg0)
			arg0:InitObjPool(arg0)
		end
	}, function()
		arg0.storeyModule = var0.New(arg0.storey, var1)
		arg0.isInit = true
	end)
end

function var0.IsInit(arg0)
	return arg0.isInit == true
end

function var0.LoadUI(arg0, arg1, arg2)
	arg0.resName = arg1

	ResourceMgr.Inst:getAssetAsync("UI/" .. arg0.resName, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		local var0

		if arg0.storey:GetStyle() == CourtYardConst.STYLE_PREVIEW then
			var0 = pg.UIMgr.GetInstance().OverlayMain:Find("BackYardInterActionPreview(Clone)/frame/view")
		else
			var0 = pg.UIMgr.GetInstance().UIMain:Find(arg0.name .. "(Clone)")
		end

		local var1 = Object.Instantiate(arg0, var0)

		arg0._go = var1

		var1.transform:SetSiblingIndex(1)
		setActive(var1, true)

		arg0.poolRoot = var1.transform:Find("root")

		arg2(var1)
	end), true, true)
end

function var0.GetRect(arg0)
	assert(arg0.storeyModule)

	return arg0.storeyModule.rectTF
end

function var0.GetStoreyModule(arg0)
	local var0 = arg0.storey

	return ({
		[CourtYardConst.STYLE_INNER] = CourtYardStoreyModule,
		[CourtYardConst.STYLE_OUTSIDE] = CourtYardOutStoreyModule,
		[CourtYardConst.STYLE_FEAST] = CourtYardFeastStoreyModule,
		[CourtYardConst.STYLE_PREVIEW] = CourtYardStoreyPreviewModule
	})[var0:GetStyle()]
end

function var0.InitObjPool(arg0, arg1)
	local var0 = arg0.storey
	local var1 = ({
		[CourtYardConst.STYLE_INNER] = CourtYardPoolMgr,
		[CourtYardConst.STYLE_OUTSIDE] = CourtYardPoolMgr,
		[CourtYardConst.STYLE_FEAST] = CourtYardFeastPoolMgr,
		[CourtYardConst.STYLE_PREVIEW] = CourtYardPoolMgr
	})[var0:GetStyle()].New()

	var1:Init(arg0.poolRoot, arg1)

	arg0.poolMgr = var1
end

function var0.GetCurrStorey(arg0)
	return arg0.storeyModule
end

function var0.Dispose(arg0)
	if arg0.storeyModule then
		arg0.storeyModule:Dispose()

		arg0.storeyModule = nil
	end

	arg0.storey = nil

	arg0.poolMgr:Dispose()

	arg0.poolMgr = nil
end

return var0
