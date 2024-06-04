local var0 = class("NavalAcademyBuilding")

function var0.Ctor(arg0, arg1)
	pg.DelegateInfo.New(arg0)

	arg0.parent = arg1
	arg0._tf = arg1:findTF("academyMap/map/" .. arg0:GetGameObjectName())
	arg0.nameTxt = findTF(arg0._tf, "name/Text"):GetComponent(typeof(Text))
	arg0.tip = findTF(arg0._tf, "tip")
end

function var0.Init(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:OnClick()
	end, SFX_PANEL)

	arg0.nameTxt.text = arg0:GetTitle()

	arg0:RefreshTip()
	arg0:OnInit()
end

function var0.RefreshTip(arg0)
	setActive(arg0.tip, arg0:IsTip())
end

function var0.OnInit(arg0)
	return
end

function var0.OnClick(arg0)
	return
end

function var0.IsTip(arg0)
	return false
end

function var0.GetTitle(arg0)
	return ""
end

function var0.GetGameObjectName(arg0)
	assert(false)
end

function var0.emit(arg0, ...)
	arg0.parent:emit(...)
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
end

return var0
