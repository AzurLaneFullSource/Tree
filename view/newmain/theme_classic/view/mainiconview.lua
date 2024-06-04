local var0 = class("MainIconView", import("...base.MainBaseView"))
local var1 = 1
local var2 = 2

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1, nil)

	arg0._tf = arg1
	arg0._go = arg1.gameObject
	arg0.iconList = {
		[var1] = MainSpineIcon.New(arg1),
		[var2] = MainEducateCharIcon.New(arg1)
	}
end

function var0.GetIconType(arg0, arg1)
	if isa(arg1, VirtualEducateCharShip) then
		return var2
	else
		return var1
	end
end

function var0.Init(arg0, arg1)
	arg0.ship = arg1

	local var0 = arg0:GetIconType(arg1)

	if arg0.iconInstance then
		arg0.iconInstance:Unload()

		arg0.iconInstance = nil
	end

	arg0.iconInstance = arg0.iconList[var0]

	arg0.iconInstance:Load(arg1:getPrefab())
end

function var0.Refresh(arg0, arg1)
	local var0 = arg1:getPrefab()
	local var1 = arg0:GetIconType(arg1)

	if arg0.iconList[var1] ~= arg0.iconInstance or arg0.name ~= var0 then
		arg0:Init(arg1)
	elseif arg0.iconInstance then
		arg0.iconInstance:Resume()
	end

	arg0.ship = arg1
end

function var0.Disable(arg0)
	if arg0.iconInstance then
		arg0.iconInstance:Pause()
	end
end

function var0.IsLoading(arg0)
	if arg0.iconInstance then
		return arg0.iconInstance:IsLoading()
	end

	return false
end

function var0.GetDirection(arg0)
	return Vector2(0, 1)
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)

	for iter0, iter1 in ipairs(arg0.iconList) do
		iter1:Dispose()
	end

	arg0.iconList = nil
	arg0.iconInstance = nil
end

return var0
